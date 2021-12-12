Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 099E4471CCC
	for <lists+netdev@lfdr.de>; Sun, 12 Dec 2021 20:48:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbhLLTsJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Dec 2021 14:48:09 -0500
Received: from mail-yb1-f170.google.com ([209.85.219.170]:41936 "EHLO
        mail-yb1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbhLLTsJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Dec 2021 14:48:09 -0500
Received: by mail-yb1-f170.google.com with SMTP id v138so33675461ybb.8;
        Sun, 12 Dec 2021 11:48:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=NoY+p9C4RlRM+Rr+8sQAV4IFZ/6klwjmBy+nVoSD39Y=;
        b=il3YF33p/v1qgcdU4ZjBjluL8Fe61v/ziXsSPhSgHvEza6GzjR6MVRLYnUQkbXFgRp
         LuNdEiJSgbVB8b+bfFifGk/gpk8J8W93yt1jeP7a+Qv0dRGConUL2L1dqlH+6E2U4J0z
         sTa2w71vKWdWO+mVgpuVJ4RN8Cg9Lljlhm2GG2H7cELTWMdZ7NUnTGaduKQhn2/Xw6zT
         QT4DgkWiJUt5k+IIP7ur14R+IlHqyQlZaYBkf+nWN2N8i22HUVBGRZgC+A3a5/g8JfwZ
         MSprVFijlFBLlq/f5irohtmgylMmnJP660NM8p6v8EienSYKPYz+wCoPt5jKCwb1Qyn+
         NIPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=NoY+p9C4RlRM+Rr+8sQAV4IFZ/6klwjmBy+nVoSD39Y=;
        b=ASq70UyVpd1qCMnb1OUZu4mabE69GdDkxg+64GOCTvPhhsE1zuMt7pWPXJRRZEoBXc
         Pc80waMP8eYgfy5USWdRqGw9z985H+Uv9MsCAvkVT29dt3uQ+A8/Mvq+OTBUEKoFGl9H
         FlNAd4D0wTIaw1/C/HmaBdiIXWiEiFGBfkoqjPWmbyduChFD1s9JqOK8u9Kq4T2d5LPG
         5bkQbUGYZ77Hb4wdxpxlXP7984gNkj+e48o9Ho34VqBmz3RS6Ze+Wr5+0oh4Pc/ZJO7A
         JZ5+15w3PA5t/XmZYzEj8PH1Ig8HVW9Y7RVT/5YWhEx+HqoQn17QBamrpzaVA6WG3MdR
         9a/g==
X-Gm-Message-State: AOAM532cmKc1igvEfTYtIq/RQDjT+cVxmu2CKo2llLcVBZnQScGkZlDw
        OusNk9QAPWtv+zqsI2JpiudNITFJpfrcrAV48zA=
X-Google-Smtp-Source: ABdhPJyHmMLKxYptOaohXt2FmCOKIlvyz20cQNluXw8L+GwejO05BmC51rVxj+Q6fIzF5NlIKCxDOeDQSrBPwBQKH4Q=
X-Received: by 2002:a25:cf46:: with SMTP id f67mr28111698ybg.362.1639338428473;
 Sun, 12 Dec 2021 11:47:08 -0800 (PST)
MIME-Version: 1.0
References: <20211209092250.56430-1-hanyihao@vivo.com> <877dccwn6x.fsf@toke.dk>
 <CAEf4Bza3a88pdhFEQdR-FnT_gBPqBh+KL-OP-1P3bVfXv=Gbaw@mail.gmail.com> <87sfuzuia3.fsf@toke.dk>
In-Reply-To: <87sfuzuia3.fsf@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sun, 12 Dec 2021 11:46:57 -0800
Message-ID: <CAEf4BzYv3ONhy-JnQUtknzgBSK0gpm9GBJYtbAiJQe50_eX7Uw@mail.gmail.com>
Subject: Re: [PATCH v2] samples/bpf: xdpsock: fix swap.cocci warning
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Yihao Han <hanyihao@vivo.com>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>, kernel@vivo.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 11, 2021 at 10:07 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@red=
hat.com> wrote:
>
> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>
> > On Fri, Dec 10, 2021 at 6:26 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@=
redhat.com> wrote:
> >>
> >> Yihao Han <hanyihao@vivo.com> writes:
> >>
> >> > Fix following swap.cocci warning:
> >> > ./samples/bpf/xdpsock_user.c:528:22-23:
> >> > WARNING opportunity for swap()
> >> >
> >> > Signed-off-by: Yihao Han <hanyihao@vivo.com>
> >>
> >> Erm, did this get applied without anyone actually trying to compile
> >> samples? I'm getting build errors as:
> >
> > Good news: I actually do build samples/bpf nowadays after fixing a
> > bunch of compilation issues recently.
>
> Awesome!
>
> > Bad news: seems like I didn't pay too much attention after building
> > samples/bpf for this particular patch, sorry about that. I've dropped
> > this patch, samples/bpf builds for me. We should be good now.
>
> Yup, looks good, thanks!
>
> >>   CC  /home/build/linux/samples/bpf/xsk_fwd.o
> >> /home/build/linux/samples/bpf/xsk_fwd.c: In function =E2=80=98swap_mac=
_addresses=E2=80=99:
> >> /home/build/linux/samples/bpf/xsk_fwd.c:658:9: warning: implicit decla=
ration of function =E2=80=98swap=E2=80=99; did you mean =E2=80=98swab=E2=80=
=99? [-Wimplicit-function-declaration]
> >>   658 |         swap(*src_addr, *dst_addr);
> >>       |         ^~~~
> >>       |         swab
> >>
> >> /usr/bin/ld: /home/build/linux/samples/bpf/xsk_fwd.o: in function `thr=
ead_func':
> >> xsk_fwd.c:(.text+0x440): undefined reference to `swap'
> >> collect2: error: ld returned 1 exit status
> >>
> >>
> >> Could we maybe get samples/bpf added to the BPF CI builds? :)
> >
> > Maybe we could, if someone dedicated their effort towards making this
> > happen.
>
> Is it documented anywhere what that would entail? Is it just a matter of
> submitting a change to https://github.com/kernel-patches/vmtest ?

I think the right way would be to build samples/bpf from
selftests/bpf's Makefile. At the very least we should not require make
headers_install (I never understood that with samples/bpf, all those
up-to-date UAPI headers are right there in the same repo). Once that
is done, at the very least we'll build tests samples/bpf during CI
runs.

>
> -Toke
>
