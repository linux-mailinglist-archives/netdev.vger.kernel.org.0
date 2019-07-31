Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA5667C9D8
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 19:04:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730493AbfGaREe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 13:04:34 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:45228 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729097AbfGaREd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 13:04:33 -0400
Received: by mail-qt1-f194.google.com with SMTP id x22so62382715qtp.12;
        Wed, 31 Jul 2019 10:04:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=lqvJbiJ0ViYrKCHlWuUGRI0Vk4anl27aep+PR9BDs+A=;
        b=tXxIAc53CSuZJBIX1g5xzEWAYBBLKY/cXcS7/18hagcnmxknic4QI3+xtya1EyRCg6
         iEsAauTbSkMMI7+/BF0Wp1No+hL9RgmPjrJZf3UQwFFCfH27MBycms/V/Db4HcGiJs/D
         Vsj9jFLpkgx2myvgBIc2FBs4iiaCPUTDk3Bg4u7Pa/6+JcHxEtdtoUsWRHlXGbUsILDt
         8epP++AB2E+lIzvMuG4f8SrPAZOicHi+J8zTP2BZ54gOru+gvBQpfL/+Rmes42HoC8Gc
         7iltFpnWz5rUbpU1tE1PqtnOXAdGVMsvmntSlkKDvRMbmB5TuKbVwJvXmf7W2+WfOHeE
         0f/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=lqvJbiJ0ViYrKCHlWuUGRI0Vk4anl27aep+PR9BDs+A=;
        b=GuQ0a+JsF4HNzBOf39Doe7H/beBEy9SU+x/jCn5hSLF9/uuWk33xTCgPNPEQ7Uu1QW
         FLxpH2VUWevK0ql4PQFSeTBy4aWp6esz04tFdy4O1k9lP/JoFqVzZCDdZlSlryZtyFIi
         6zZ4/m53sHxSR0aDQw0/fRky30kyh5+1+CiFsEhCIB5veLb8kfoZC9DD1aGSSFfxVPM5
         v+1U9C5zUcHJ7ppSpuUZmpEcKkZbU3ipeYrG+JraN9o9IuOBaTAOCrpEBmDidwvdTDTI
         Mq42UyXyTNQyVZ4Lb3ra53YIjwFnKvvVweTEJQiVtIeXGL9S45fWqpGnGJLjFaXlf9qk
         7SkA==
X-Gm-Message-State: APjAAAXz4I4/JfYLD8gAm156k+bBk1D7eP/7KuOx7RaQ7QmI2aCo7/e1
        3BJfn6qGPKE0Jl0jp+gqS9hAnl+FRBgX1AxspLUoB0fucHg=
X-Google-Smtp-Source: APXvYqwy3ZmLY6pIjLa4qrVxnHYguShOGr9R5V8LdkI11Hm5N6g+XEEdjPRgBtvzFXuGRnbYmgE32fzMJ8kolOLW+To=
X-Received: by 2002:ac8:2d56:: with SMTP id o22mr84694203qta.171.1564592672034;
 Wed, 31 Jul 2019 10:04:32 -0700 (PDT)
MIME-Version: 1.0
References: <20190726203747.1124677-1-andriin@fb.com> <20190726203747.1124677-2-andriin@fb.com>
 <20190726212152.GA24397@mini-arch> <CAEf4BzYDvZENJqrT0KKpHbfHNCdObB9p4ZcJqQj3+rM_1ESF3g@mail.gmail.com>
 <20190726220119.GE24397@mini-arch> <CAEf4Bzbj6RWUo8Q7wgMnbL=T7V2yK2=gbdO3sSfxJ71Gp6jeYA@mail.gmail.com>
 <3D822EE0-C033-4192-B505-A30E5EC23BC3@linux.ibm.com>
In-Reply-To: <3D822EE0-C033-4192-B505-A30E5EC23BC3@linux.ibm.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 31 Jul 2019 10:04:20 -0700
Message-ID: <CAEf4BzbQ3JF9s_LsOEeVUoXDR57USdNFvQ4E=5vUzQ=sAPuUaQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/9] selftests/bpf: prevent headers to be
 compiled as C code
To:     Ilya Leoshkevich <iii@linux.ibm.com>
Cc:     Stanislav Fomichev <sdf@fomichev.me>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 31, 2019 at 6:21 AM Ilya Leoshkevich <iii@linux.ibm.com> wrote:
>
> > Am 27.07.2019 um 20:53 schrieb Andrii Nakryiko <andrii.nakryiko@gmail.c=
om>:
> >
> > On Fri, Jul 26, 2019 at 3:01 PM Stanislav Fomichev <sdf@fomichev.me> wr=
ote:
> >>
> >> On 07/26, Andrii Nakryiko wrote:
> >>> On Fri, Jul 26, 2019 at 2:21 PM Stanislav Fomichev <sdf@fomichev.me> =
wrote:
> >>>>
> >>>> On 07/26, Andrii Nakryiko wrote:
> >>>>> Apprently listing header as a normal dependency for a binary output
> >>>>> makes it go through compilation as if it was C code. This currently
> >>>>> works without a problem, but in subsequent commits causes problems =
for
> >>>>> differently generated test.h for test_progs. Marking those headers =
as
> >>>>> order-only dependency solves the issue.
> >>>> Are you sure it will not result in a situation where
> >>>> test_progs/test_maps is not regenerated if tests.h is updated.
> >>>>
> >>>> If I read the following doc correctly, order deps make sense for
> >>>> directories only:
> >>>> https://www.gnu.org/software/make/manual/html_node/Prerequisite-Type=
s.html
> >>>>
> >>>> Can you maybe double check it with:
> >>>> * make
> >>>> * add new prog_tests/test_something.c
> >>>> * make
> >>>> to see if the binary is regenerated with test_something.c?
> >>>
> >>> Yeah, tested that, it triggers test_progs rebuild.
> >>>
> >>> Ordering is still preserved, because test.h is dependency of
> >>> test_progs.c, which is dependency of test_progs binary, so that's why
> >>> it works.
> >>>
> >>> As to why .h file is compiled as C file, I have no idea and ideally
> >>> that should be fixed somehow.
> >> I guess that's because it's a prerequisite and we have a target that
> >> puts all prerequisites when calling CC:
> >>
> >> test_progs: a.c b.c tests.h
> >>        gcc a.c b.c tests.h -o test_progs
> >>
> >> So gcc compiles each input file.
> >
> > If that's really a definition of the rule, then it seems not exactly
> > correct. What if some of the prerequisites are some object files,
> > directories, etc. I'd say the rule should only include .c files. I'll
> > add it to my TODO list to go and check how all this is defined
> > somewhere, but for now I'm leaving everything as is in this patch.
> >
>
> I believe it=E2=80=99s an implicit built-in rule, which is defined by mak=
e
> itself here:
>
> https://git.savannah.gnu.org/cgit/make.git/tree/default.c?h=3D4.2.1#n131
>
> The observed behavior arises because these rules use $^ all over the
> place. My 2c is that it would be better to make the rule explicit,
> because it would cost just an extra line, but it would be immediately
> obvious why the code is correct w.r.t. rebuilds.

Thanks for pointing this out, Ilya! I agree, I'd rather have a simple
explicit rule in Makefile that having to guess where this is coming
from and why it doesn't work as you'd expect it to. If no one else
adds that first, I'll eventually get to this.

>
> Best regards,
> Ilya
