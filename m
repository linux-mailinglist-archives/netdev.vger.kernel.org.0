Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B4835623C3
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 22:03:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236665AbiF3UDz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 16:03:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236280AbiF3UDy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 16:03:54 -0400
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA2703B568
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 13:03:53 -0700 (PDT)
Received: by mail-qk1-x733.google.com with SMTP id z16so47821qkj.7
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 13:03:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HM+W2Ta6F/8XU4LNaxg55KQeP8YL5SBzfGDpvAzW1/M=;
        b=UZiRZK2hRMgnFjucQh/6ycH3EnbW//UwC42TtJudbgp6LCr7y9I3sRHvSkQUmGt0Nq
         WWFq4hR+1aKL8tH6Uj4P5YG+ULmrpet63pDOHA15SQxltqjEDB06AA7hEYJ7tEpiBQDP
         CIB12G2AIdyN/pBNqA19Sashs6O1zRrjBUOWnGZeIrniU01FPAlvNCIA3iCLQodoAcCb
         ObMhqjFwOnrLSTjiTAEKFqOUeqijugrDnQRXsQ3WbnqjFIIvrV/qGpcM0VPSBn5MzD80
         +UCbIk7lwVEZNJjqIybsff1rzImdvJ2XohvBjPTAlu0iZ356iCAmETVJJjPw1Dr85IXP
         xy9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HM+W2Ta6F/8XU4LNaxg55KQeP8YL5SBzfGDpvAzW1/M=;
        b=OYD6ve4kBL8YwUKGTwOS2fQ7FXgd1DPfOo7y5EM8FmjIBfkGq9woT2qbn9+zJS3B1e
         lkGZCB9nQf8syr57syHPjrzVquD0dF+p54/oIBGMjxGcoSy7kWKLQmqMpTTEfiQYhV+q
         qMLcf3mRP1FKarF1y2213Ii8OFxBdjHc5A1Nuuf7FLjT5cecpX8IwswwtH5L/BvVyD54
         itFVFMMCTSf6rQD64ssfvoSsahmf1fCVbfAXGDeYvHR5S4zs15P3Fkxua1BSXakoleMR
         zhBxPmsnWkSMnLKZQICaBWRnbCA9bd5ijaIfFd8PrTyWc6CxexfEarHu01QcWUZDZkTW
         mB5w==
X-Gm-Message-State: AJIora8KdtlqLeqBMQzXbKnPKFFXTIWT6aziOJnSGLe/r+Qwej3JlwC0
        U5CMZeCE5Z+cFEiLEaFPU2e3bdlxMwc8KgxSqwZMbA==
X-Google-Smtp-Source: AGRyM1uNXVxwajgwmdA+mDMFc2wydm8tIRUU6IwuVfHQsFFBzGvcT3q7cjjMlrdcHKMfVfdAl/sJfVnrZOrJmHHBqzw=
X-Received: by 2002:a05:620a:27d0:b0:6af:1fed:2d10 with SMTP id
 i16-20020a05620a27d000b006af1fed2d10mr7546454qkp.127.1656619433063; Thu, 30
 Jun 2022 13:03:53 -0700 (PDT)
MIME-Version: 1.0
References: <20220629143951.74851-1-quentin@isovalent.com> <CAEf4BzY3Zh_fgg5j7CeZtN5vUEXdBPio2PS71dULrE3UBEsFvw@mail.gmail.com>
In-Reply-To: <CAEf4BzY3Zh_fgg5j7CeZtN5vUEXdBPio2PS71dULrE3UBEsFvw@mail.gmail.com>
From:   Quentin Monnet <quentin@isovalent.com>
Date:   Thu, 30 Jun 2022 21:03:41 +0100
Message-ID: <CACdoK4LTgpcuS9Sgk6F-9=cP09aACxJN4iTXJ=39OohPcBKXAg@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpftool: Allow disabling features at compile time
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Peter Wu <peter@lekensteyn.nl>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 Jun 2022 at 20:25, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
>
> On Wed, Jun 29, 2022 at 7:40 AM Quentin Monnet <quentin@isovalent.com> wrote:
> >
> > Some dependencies for bpftool are optional, and the associated features
> > may be left aside at compilation time depending on the available
> > components on the system (libraries, BTF, clang version, etc.).
> > Sometimes, it is useful to explicitly leave some of those features aside
> > when compiling, even though the system would support them. For example,
> > this can be useful:
> >
> >     - for testing bpftool's behaviour when the feature is not present,
> >     - for copmiling for a different system, where some libraries are
> >       missing,
> >     - for producing a lighter binary,
> >     - for disabling features that do not compile correctly on older
> >       systems - although this is not supposed to happen, this is
> >       currently the case for skeletons support on Linux < 5.15, where
> >       struct bpf_perf_link is not defined in kernel BTF.
> >
> > For such cases, we introduce, in the Makefile, some environment
> > variables that can be used to disable those features: namely,
> > BPFTOOL_FEATURE_NO_LIBBFD, BPFTOOL_FEATURE_NO_LIBCAP, and
> > BPFTOOL_FEATURE_NO_SKELETONS.
> >
> > Signed-off-by: Quentin Monnet <quentin@isovalent.com>
> > ---
> >  tools/bpf/bpftool/Makefile | 20 ++++++++++++++++++--
> >  1 file changed, 18 insertions(+), 2 deletions(-)
> >
> > diff --git a/tools/bpf/bpftool/Makefile b/tools/bpf/bpftool/Makefile
> > index c19e0e4c41bd..b3dd6a1482f6 100644
> > --- a/tools/bpf/bpftool/Makefile
> > +++ b/tools/bpf/bpftool/Makefile
> > @@ -93,8 +93,24 @@ INSTALL ?= install
> >  RM ?= rm -f
> >
> >  FEATURE_USER = .bpftool
> > -FEATURE_TESTS = libbfd disassembler-four-args zlib libcap \
> > -       clang-bpf-co-re
> > +FEATURE_TESTS := disassembler-four-args zlib
>
> as an aside, zlib is not really optional, libbpf depends on it and
> bpftool depends on libbpf, so... what's the point of a feature test?

I'm not sure either, it looks like it's mostly a way to print that the
lib is missing (when it's the case) before attempting to compile [0].
Probably something we can look into removing, I agree the feature test
doesn't bring much here. We'll soon need a new test for the latest
libbfd changes though [1].

[0] https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git/commit/?id=d66fa3c70e598746a907e5db5ed024035e01817a
[1] https://lore.kernel.org/bpf/20220622181918.ykrs5rsnmx3og4sv@alap3.anarazel.de/
