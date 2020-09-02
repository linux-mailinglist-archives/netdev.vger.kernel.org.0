Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2871425B4DE
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 21:57:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726821AbgIBT5g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 15:57:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726285AbgIBT50 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 15:57:26 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F83FC061244;
        Wed,  2 Sep 2020 12:57:25 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id h126so470614ybg.4;
        Wed, 02 Sep 2020 12:57:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RVwJ81Qtpdk1XpGW5J7CwHz1UYeI3dTDYRrlyLt13sM=;
        b=AuJthCL6aO4RqJX/kWznJ3sHdv1Crb7oRuz4/AeJwn2AoaSXAPGLZrMwYOAxD6MCTa
         tuL1MO6QL11N7qKolHCGvr4NB3kp/g+T1E5sI/VwNxfUXWN74CCpoUKV/GaWKnNUXQF+
         C1feQ3RSDrL4/VjqkNWuGHTVuao8869fHZJxiyLSEo4b9XM9CdgHd4M+wsOza33RNeiT
         96r/pzjG1fEUSBKdo/arM21CEODmy1MRWpTDIJr1zG7CeIuqNgephYuIXJIo3wBFQe4u
         9UODwJn8wgptL/nkjdobdvMa75z9+G9VTR2OHAGYQPTvpkH9022eaIE9J2Y5e37IgO8V
         qiAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RVwJ81Qtpdk1XpGW5J7CwHz1UYeI3dTDYRrlyLt13sM=;
        b=oJjGw4OB9y6nDyfd6Ra7LpYt84Fx6/GYYrmVeOkhNWgleHG1RqLrVjVr6xd8cH0pjX
         q/VqkvWZDZhD2OMgrUqYN48NZDBJsBuj9XZITG+ZpwMFDj9qdztfDD3qwIguTDDT4MAq
         T0mSaTExoZqgOKbhHxNR2TlB7bPUYHQiuWOSVEfRzlJZ3kSXEa3eeNnjwku5hv0ipoGx
         QnNEVH5vaPnvwEa2tHn25j86kph5oxEBe4gl37TfN3LWmF1cd4G4r6H5MfAoAknoNPdn
         QDOWD2ZFMY8PFF041nyAJwo1t+Msh2MlxjuFRq/MePEylFUmIOPpARa+OHiUX+aVJmEg
         HY9w==
X-Gm-Message-State: AOAM5336mb6tPs8UiSBQ9s1sVYNcKJInif/gT7/IHmFTXj4z95qfO3ua
        DSrQP00zYUn/cy0VtHgKHZYLIHCsx1h+vHJOgYU=
X-Google-Smtp-Source: ABdhPJzpoTIUFvE14LX/tt+D4kj0VQHFDqttKFYDuoVwCcqEIXZT3of7Y20jbgkuLu+Gl6asJQ1QI5od67fV49gW2ZE=
X-Received: by 2002:a5b:44d:: with SMTP id s13mr12423151ybp.403.1599076644849;
 Wed, 02 Sep 2020 12:57:24 -0700 (PDT)
MIME-Version: 1.0
References: <20200901015003.2871861-1-andriin@fb.com> <20200901015003.2871861-8-andriin@fb.com>
 <20200902054132.y3p3spqt6vzxiy2t@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200902054132.y3p3spqt6vzxiy2t@ast-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 2 Sep 2020 12:57:14 -0700
Message-ID: <CAEf4BzbLo+BA=qvFdA_tupOy8SoN-kSHU6+TJw3aZ0m4VYvgDA@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 07/14] selftests/bpf: add selftest for
 multi-prog sections and bpf-to-bpf calls
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 1, 2020 at 10:41 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Mon, Aug 31, 2020 at 06:49:56PM -0700, Andrii Nakryiko wrote:
> > +
> > +__noinline int sub1(int x)
> > +{
> > +     return x + 1;
> > +}
> > +
> > +static __noinline int sub5(int v);
> > +
> > +__noinline int sub2(int y)
> > +{
> > +     return sub5(y + 2);
> > +}
> > +
> > +static __noinline int sub3(int z)
> > +{
> > +     return z + 3 + sub1(4);
> > +}
> > +
> > +static __noinline int sub4(int w)
> > +{
> > +     return w + sub3(5) + sub1(6);
>
> Did you check that asm has these calls?

Yeah, I actually did check. All calls are there.

> Since sub3 is static the compiler doesn't have to do the call.
> 'static noinline' doesn't mean that compiler have to do the call.
> It can compute the value and replace a call with a constant.
> It only has to keep the body of the function if the address of it
> was taken.

All these subX() functions are either global or call global function
(sub1() is global), which seems to keep Clang from optimizing all
this. Clang has to assume the worst case for global functions,
probably due to LD_PRELOAD, right?
