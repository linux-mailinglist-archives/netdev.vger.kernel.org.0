Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0B6B36975F
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 18:47:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243173AbhDWQsZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 12:48:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243109AbhDWQsY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 12:48:24 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55FD9C061574;
        Fri, 23 Apr 2021 09:47:47 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id l22so49016409ljc.9;
        Fri, 23 Apr 2021 09:47:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Z9CSkWjoaT/hQ88KgcDlGnLSBzYbOvKna9ZhP8lUZlE=;
        b=hh2gs7JpCs90IkiY1rJczvQ4E//glxdSIg/kg+tq2pkIs4RN3xiMFPZ+TMAuGELAyM
         57ls2e8+VzwclzTEv4xYxrB0/CnzL0unkwFIs6KTd7ECdG/7eJ4fIWeg9SpFKuOx4vB0
         TWgV+nXk0XrtEuuLhwu4Crrf++Cl/7ERHNZikP8jfpNKX8KmZiqxSKRoDyZULJY/yUmZ
         FnD/a86WVXqJ/zLNyTEgZoQKrUfPbaIywZuGhuwOac9YNZCANo+KH91Vm5AAoWBdaugE
         LgidWvZ866PrB9S+uBJLpd8XnFtPvCC7yywctkJxX1gs4MWHhrmK/kN7ZyvnEFdqRuce
         8fKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Z9CSkWjoaT/hQ88KgcDlGnLSBzYbOvKna9ZhP8lUZlE=;
        b=Cg7GTGJrPJNDtDXjNP5saJ0H5QsShwQI/t1triNCOHaRU1Do1D/izQsTRb05TD033N
         kP/ZDWpDDQmOAwPf3UuXVr/3Wu9k2ieZ3Fr1fhyxBYOxY8WmUnoW5CAukfnJslCrEmBb
         Hh0Bg6Ss1DG0KpwHO5NvpzuYG4UJ+ed4J6kkmwT7PK2Md/SzKSYSLpXCWLXPMFGEh1b9
         jj9NU2GJQQ7kHgLQA2YOuF3O4jwrdhVlOVmzFGzQLiyWVorAHWqNTTZ2OIuODJHShX/T
         mdA6A9dMtv8Y4TfwGdTPH0frHLSX+ciR/5PH6Xc5SCOIhppo0aFPFlQYHApmL7nwiDrg
         rz7w==
X-Gm-Message-State: AOAM531O8xdyOQe0gGjBpq/QWx9KZGwXfqJqXj7elHYxmQ8W2iKdU65s
        tZA7hV+Qh88TzOOqoTAYvWuuRIqTURDesvQI1de7Rh6Z
X-Google-Smtp-Source: ABdhPJxpbgAqS1GibhcllwDT+1U4zjY+5kMeemf9VlkANhkfYipY7NLqbF5yJgJW4JdQkixwi8+KQjlNOUQR7YAdedk=
X-Received: by 2002:a2e:6c0d:: with SMTP id h13mr3226834ljc.486.1619196465904;
 Fri, 23 Apr 2021 09:47:45 -0700 (PDT)
MIME-Version: 1.0
References: <1619085648-36826-1-git-send-email-jiapeng.chong@linux.alibaba.com>
 <7ecb85e6-410b-65bb-a042-74045ee17c3f@iogearbox.net> <93957f3e-2274-c389-64a4-235ed8a228bf@linux.alibaba.com>
In-Reply-To: <93957f3e-2274-c389-64a4-235ed8a228bf@linux.alibaba.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 23 Apr 2021 09:47:34 -0700
Message-ID: <CAADnVQJoJW9GWk4guqzHQkDPD4RWoh-puVhnfW0LBPT_N6-4HA@mail.gmail.com>
Subject: Re: [PATCH] selftests/bpf: fix warning comparing pointer to 0
To:     Abaci Robot <abaci@linux.alibaba.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 23, 2021 at 4:57 AM Abaci Robot <abaci@linux.alibaba.com> wrote=
:
>
> =E5=9C=A8 2021/4/23 =E4=B8=8A=E5=8D=885:56, Daniel Borkmann =E5=86=99=E9=
=81=93:
> > On 4/22/21 12:00 PM, Jiapeng Chong wrote:
> >> Fix the following coccicheck warning:
> >>
> >> ./tools/testing/selftests/bpf/progs/fentry_test.c:76:15-16: WARNING
> >> comparing pointer to 0.
> >>
> >> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> >> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> >
> > How many more of those 'comparing pointer to 0' patches do you have?
> > Right now we already merged the following with similar trivial pattern:
> >
> > - ebda107e5f222a086c83ddf6d1ab1da97dd15810
> > - a9c80b03e586fd3819089fbd33c38fb65ad5e00c
> > - 04ea63e34a2ee85cfd38578b3fc97b2d4c9dd573
> >
> > Given they don't really 'fix' anything, I would like to reduce such
> > patch cleanup churn on the bpf tree. Please _consolidate_ all other
> > such occurrences into a _single_ patch for BPF selftests, and resubmit.
> >
> > Thanks!
> >
> >> ---
> >>   tools/testing/selftests/bpf/progs/fentry_test.c | 2 +-
> >>   1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/tools/testing/selftests/bpf/progs/fentry_test.c
> >> b/tools/testing/selftests/bpf/progs/fentry_test.c
> >> index 52a550d..d4247d6 100644
> >> --- a/tools/testing/selftests/bpf/progs/fentry_test.c
> >> +++ b/tools/testing/selftests/bpf/progs/fentry_test.c
> >> @@ -73,7 +73,7 @@ int BPF_PROG(test7, struct bpf_fentry_test_t *arg)
> >>   SEC("fentry/bpf_fentry_test8")
> >>   int BPF_PROG(test8, struct bpf_fentry_test_t *arg)
> >>   {
> >> -    if (arg->a =3D=3D 0)
> >> +    if (!arg->a)
> >>           test8_result =3D 1;
> >>       return 0;
> >>   }
> >>
>
> Hi,
>
> Thanks for your reply.
>
> TLDR:
> 1. Now all this kind of warning in tools/testing/selftests/bpf/progs/
> were reported and discussed except this one.
> 2. We might not do scanning and check reports on
> tools/testing/selftests/bpf/progs/ in the future,

please stop such scans in selftests/bpf.
I don't see any value in such patches.
