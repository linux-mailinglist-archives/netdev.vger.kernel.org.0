Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D429CAB01
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 19:27:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391212AbfJCRQo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 13:16:44 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:41575 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389869AbfJCRQn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 13:16:43 -0400
Received: by mail-qt1-f196.google.com with SMTP id d16so4634707qtq.8;
        Thu, 03 Oct 2019 10:16:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=JYtDMQDuVwNG8RqJRwPjaq6fFD8Re73+f293ZD4Wuu8=;
        b=X65WtpVrZDIrxBVNWICeND5pIWhjgoOYVvKncTm9QbFMbaL5r9hckYjcpXRgaPZyLa
         JqVw0XcKNXHml026LmzXPcsIEPtG4rXqZfHLJjgs49cVhrcGQgSqwxy+LDiYM7y+i4yE
         786uxyRDJrbFAP9ghhzYguh/0Y5piaG2/PSQNcWIca3qCXgC+6q7ZMRpDEmju0CCvmKH
         oo3NXQQwgJUvelIATdto/0clFKpv3DPDhBTl8nxsogTCraf/qBTXyC8o7uiAY5uoMSYM
         TTTpylbrrqyI29KMsdxcB4U+boLAjZq0C50zSlNzh5noBPAUZPBFlfqsL2502R7iQHde
         v3bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=JYtDMQDuVwNG8RqJRwPjaq6fFD8Re73+f293ZD4Wuu8=;
        b=BFDdWZOCLQ21AvalC4owxB4JfQtAL7cnTPIGQBKxRKYYxREuwL88wlz+nyWquAn45d
         agLAejxCW2ifUhtKt7oXElxG8wRtpK8S5G8ljZN+QRW4hMNaWW29rjfnVuNheSFJGhLi
         PhpmJt3ZGYQ5EPHmFlxWNJQjKV8nza6nUIcW6f/bt5LWLgIxKjFItRhNXrfasGfUHiVZ
         +o7a9wQ3iowbcHV4bb4Q3HH3ODjcgnpAd8oOaU6ExfnKzhoSP9L93hHorSBNnL+MzcxR
         l6ri/v9xFRUu7wCTjySc6uyLGTZCcSHG4ZDS8UGoBwAN8ZMC9WR2dQwtaopY7mkqPILr
         5EaQ==
X-Gm-Message-State: APjAAAUXuKF7bGCxxgNlq04B9eYcL41/OQCx3ycN/2olUg2jkJNFmT8s
        3y7CGl8GVBwfGXxCGl+VmuUCj9aOrZxnRP8Xqh7RxMS9Cq8=
X-Google-Smtp-Source: APXvYqzriFgfsaOb+zMayUMrzzyhk7sKU1aDErcpfzuTPS3JYASAuhxXYTY9J0+rlPuyNmp6vaxcjnhpvJTRRKRaAKw=
X-Received: by 2002:ad4:4649:: with SMTP id y9mr6155437qvv.247.1570123002156;
 Thu, 03 Oct 2019 10:16:42 -0700 (PDT)
MIME-Version: 1.0
References: <20191001101429.24965-1-bjorn.topel@gmail.com> <CAK7LNATNw4Qysj1Q2dXd4PALfbtgMXPwgvmW=g0dRcrczGW-Fg@mail.gmail.com>
 <CAJ+HfNgvxornSfqnbAthNy6u6=-enGCdA8K1e6rLXhCzGgmONQ@mail.gmail.com>
 <CAK7LNATD4vCQnNsHXP8A2cyWDkCNX=LGh0ej-dkDajm-+Lfw8Q@mail.gmail.com>
 <CAJ+HfNgem7ijzQkz7BU-Z_A-CqWXY_uMF6_p0tGZ6eUMx_N3QQ@mail.gmail.com>
 <20191002231448.GA10649@khorivan> <CAJ+HfNiCrcVDwQw4nxsntnTSy2pUgV2n6pW206==hUmq1=ZUTA@mail.gmail.com>
 <CAK7LNARd4_o4E=TSONZjJ9iyyeUE1=L_njU7LiEZFpNunSEEkw@mail.gmail.com> <CAJ+HfNhx+gQmRMb18UDRrmzciDYUbdezUh9bRhWG8_HTUCLk9w@mail.gmail.com>
In-Reply-To: <CAJ+HfNhx+gQmRMb18UDRrmzciDYUbdezUh9bRhWG8_HTUCLk9w@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 3 Oct 2019 10:16:31 -0700
Message-ID: <CAEf4BzbZxa3iGZEWB03rdL+7ErmhdpB0e3aeOQvbLPu0o8XFqw@mail.gmail.com>
Subject: Re: [PATCH bpf] samples/bpf: kbuild: add CONFIG_SAMPLE_BPF Kconfig
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     Masahiro Yamada <yamada.masahiro@socionext.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
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

On Thu, Oct 3, 2019 at 3:52 AM Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com=
> wrote:
>
> On Thu, 3 Oct 2019 at 12:37, Masahiro Yamada
> <yamada.masahiro@socionext.com> wrote:
> >
> > On Thu, Oct 3, 2019 at 3:28 PM Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail=
.com> wrote:
> > >
> > > On Thu, 3 Oct 2019 at 01:14, Ivan Khoronzhuk <ivan.khoronzhuk@linaro.=
org> wrote:
> > > >
> > > > On Wed, Oct 02, 2019 at 09:41:15AM +0200, Bj=C3=B6rn T=C3=B6pel wro=
te:
> > > > >On Wed, 2 Oct 2019 at 03:49, Masahiro Yamada
> > > > ><yamada.masahiro@socionext.com> wrote:
> > > > >>
> > > > >[...]
> > > > >> > Yes, the BPF samples require clang/LLVM with BPF support to bu=
ild. Any
> > > > >> > suggestion on a good way to address this (missing tools), bett=
er than
> > > > >> > the warning above? After the commit 394053f4a4b3 ("kbuild: mak=
e single
> > > > >> > targets work more correctly"), it's no longer possible to buil=
d
> > > > >> > samples/bpf without support in the samples/Makefile.
> > > > >>
> > > > >>
> > > > >> You can with
> > > > >>
> > > > >> "make M=3Dsamples/bpf"
> > > > >>
> > > > >
> > > > >Oh, I didn't know that. Does M=3D support "output" builds (O=3D)?
> >
> > No.
> > O=3D points to the output directory of vmlinux,
> > not of the external module.
> >
> > You cannot put the build artifacts from samples/bpf/
> > in a separate directory.
> >
>
> Hmm, I can't even get "make M=3Dsamples/bpf/" to build. Am I missing
> something obvious?

There were 3 or 4 separate fixes submitted for samples/bpf yesterday,
maybe you are hitting some of those issues. Try to pull latest (not
sure if bpf or bpf-next tree). I tried make M=3Dsamples/bpf and it
worked for me.

>
> Prior 394053f4a4b3 "make samples/bpf/" and "make O=3D/foo/bar
> samples/bpf/" worked, but I guess I can live with that...
>
>
> Thanks!
> Bj=C3=B6rn
>
>
> >
> >
> > > > >I usually just build samples/bpf/ with:
> > > > >
> > > > >  $ make V=3D1 O=3D/home/foo/build/bleh samples/bpf/
> > > > >
> > > > >
> > > > >Bj=C3=B6rn
> > > >
> > > > Shouldn't README be updated?
> > > >
> > >
> > > Hmm, the M=3D variant doesn't work at all for me. The build is still
> > > broken for me. Maybe I'm missing anything obvious...
> > >
> > >
> > > > --
> > > > Regards,
> > > > Ivan Khoronzhuk
> >
> >
> >
> > --
> > Best Regards
> > Masahiro Yamada
