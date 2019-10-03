Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EA78C9CB2
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 12:50:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729439AbfJCKuf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 06:50:35 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:43271 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728234AbfJCKuf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 06:50:35 -0400
Received: by mail-qk1-f194.google.com with SMTP id h126so1817556qke.10;
        Thu, 03 Oct 2019 03:50:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=fM8THgk9XJ8sEx3BQtTeX7NMdju8tZeZ21w0FheC/X8=;
        b=Yw6zyNoUH4yW7RQ7YV/7pJcwMNXfuTZin2s/vuqWslxOAE4epDnrWzWgpUbLtI8hDA
         HCVll6Yh+odiUiVVb7MEZ3qz32civ6+r1+Gee42f5hA465jar5eE+/Mx7qBDkRqB+t2W
         wW3T3dz1ZFePY825jVVGxLvhovVOPOVkY5L+bBeZHxnvamkRVuY3FBFoDnAlwfvjmthq
         wC7a7z0hq2/ZAw6DPVtwNxkC0U70C3ONCDKKO0w3BEY8obTeZDHuBVn03N5z2xV4VoUj
         49WeCaq1NNaGCUPphU+k1YwfEfnO79wk8kehNyTcVzvlgQ8hJ21EgwFir6+qlsAC6fES
         sT1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=fM8THgk9XJ8sEx3BQtTeX7NMdju8tZeZ21w0FheC/X8=;
        b=PuWc8KJFNlnAylrkY7giVxKUS9QaH+Pjym19IWAKxjl7pKt24XhKerAapCuBhDKelO
         InUQk/HP07fyTwNHS9vwgqArCvbh8xsfrYEuKrSbfb/4cetFyA6di5tcMkkgvdXA9FG9
         +Ia/sJNDCn+Cmn/fnnF5/YuFbonDP7ToHVdAd4BqyLf/XcDBoxxfZ89fgVkxs6Qm8bKT
         PVoB1DTYyxOGbnOKJ8yw8CaKkdjunAiezWq4mFYw1PtZ3UR+mqSbAPK2Eml6sXksvw5k
         Uzfy5yffY7OjlpG4eOdrgEbWJo2pNtzdBypQcA8FUgwwxIlmw5xX5k/1rORlPPurzoS9
         Beyw==
X-Gm-Message-State: APjAAAV3egMP+FyFruq03V8ZccCVbwSR0EgQmWO+S3/E3gmvjxMQ/Gm2
        M0yov9q7LvZQSO6H5ZZRxLBSuCkxBet9vSIlmMY=
X-Google-Smtp-Source: APXvYqyy5HXJM2u1U8CaDWPNkgh8DjaBowL+QJagMg52IaLV/RQvEkR4ypi9bc/ESi24zGBP49W6itIZ24w1nDkJSGg=
X-Received: by 2002:a37:4b02:: with SMTP id y2mr3537894qka.493.1570099834447;
 Thu, 03 Oct 2019 03:50:34 -0700 (PDT)
MIME-Version: 1.0
References: <20191001101429.24965-1-bjorn.topel@gmail.com> <CAK7LNATNw4Qysj1Q2dXd4PALfbtgMXPwgvmW=g0dRcrczGW-Fg@mail.gmail.com>
 <CAJ+HfNgvxornSfqnbAthNy6u6=-enGCdA8K1e6rLXhCzGgmONQ@mail.gmail.com>
 <CAK7LNATD4vCQnNsHXP8A2cyWDkCNX=LGh0ej-dkDajm-+Lfw8Q@mail.gmail.com>
 <CAJ+HfNgem7ijzQkz7BU-Z_A-CqWXY_uMF6_p0tGZ6eUMx_N3QQ@mail.gmail.com>
 <20191002231448.GA10649@khorivan> <CAJ+HfNiCrcVDwQw4nxsntnTSy2pUgV2n6pW206==hUmq1=ZUTA@mail.gmail.com>
 <CAK7LNARd4_o4E=TSONZjJ9iyyeUE1=L_njU7LiEZFpNunSEEkw@mail.gmail.com>
In-Reply-To: <CAK7LNARd4_o4E=TSONZjJ9iyyeUE1=L_njU7LiEZFpNunSEEkw@mail.gmail.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Thu, 3 Oct 2019 12:50:23 +0200
Message-ID: <CAJ+HfNhx+gQmRMb18UDRrmzciDYUbdezUh9bRhWG8_HTUCLk9w@mail.gmail.com>
Subject: Re: [PATCH bpf] samples/bpf: kbuild: add CONFIG_SAMPLE_BPF Kconfig
To:     Masahiro Yamada <yamada.masahiro@socionext.com>
Cc:     Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 3 Oct 2019 at 12:37, Masahiro Yamada
<yamada.masahiro@socionext.com> wrote:
>
> On Thu, Oct 3, 2019 at 3:28 PM Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.c=
om> wrote:
> >
> > On Thu, 3 Oct 2019 at 01:14, Ivan Khoronzhuk <ivan.khoronzhuk@linaro.or=
g> wrote:
> > >
> > > On Wed, Oct 02, 2019 at 09:41:15AM +0200, Bj=C3=B6rn T=C3=B6pel wrote=
:
> > > >On Wed, 2 Oct 2019 at 03:49, Masahiro Yamada
> > > ><yamada.masahiro@socionext.com> wrote:
> > > >>
> > > >[...]
> > > >> > Yes, the BPF samples require clang/LLVM with BPF support to buil=
d. Any
> > > >> > suggestion on a good way to address this (missing tools), better=
 than
> > > >> > the warning above? After the commit 394053f4a4b3 ("kbuild: make =
single
> > > >> > targets work more correctly"), it's no longer possible to build
> > > >> > samples/bpf without support in the samples/Makefile.
> > > >>
> > > >>
> > > >> You can with
> > > >>
> > > >> "make M=3Dsamples/bpf"
> > > >>
> > > >
> > > >Oh, I didn't know that. Does M=3D support "output" builds (O=3D)?
>
> No.
> O=3D points to the output directory of vmlinux,
> not of the external module.
>
> You cannot put the build artifacts from samples/bpf/
> in a separate directory.
>

Hmm, I can't even get "make M=3Dsamples/bpf/" to build. Am I missing
something obvious?

Prior 394053f4a4b3 "make samples/bpf/" and "make O=3D/foo/bar
samples/bpf/" worked, but I guess I can live with that...


Thanks!
Bj=C3=B6rn


>
>
> > > >I usually just build samples/bpf/ with:
> > > >
> > > >  $ make V=3D1 O=3D/home/foo/build/bleh samples/bpf/
> > > >
> > > >
> > > >Bj=C3=B6rn
> > >
> > > Shouldn't README be updated?
> > >
> >
> > Hmm, the M=3D variant doesn't work at all for me. The build is still
> > broken for me. Maybe I'm missing anything obvious...
> >
> >
> > > --
> > > Regards,
> > > Ivan Khoronzhuk
>
>
>
> --
> Best Regards
> Masahiro Yamada
