Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 390602737C0
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 02:58:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729422AbgIVA6l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 20:58:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:51068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729404AbgIVA6g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Sep 2020 20:58:36 -0400
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D327823AC6
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 00:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600736315;
        bh=mO4DYr7N0RLjWZa37eU/VgHJpvS4aRf2iPegAH0iEtc=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=NcH2VkLBgDzvNIcwu92WQk4IAewPXtNoyAN5ZuO8pHvo1p+Rn1Ou8f+8UcnDfmQCh
         RwG2NziW5jzt2iYAfirGZDU632aRajjo/G+x78cv/5v0WMOpY6g8gUKcWrozhHCxYh
         Z9K4X8JU7DVwK0bapy70hqrLYXRdGWUnkheGMJIA=
Received: by mail-wm1-f51.google.com with SMTP id q9so1607504wmj.2
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 17:58:34 -0700 (PDT)
X-Gm-Message-State: AOAM530iq6fn8UxS+fz5LU3WkMRs/OwY9Op5aX14vR5ivucwRqODxHjN
        yQzPIbiyBQ95/hhYhCM6kPUuiT6QmeDrvELo2b2r4g==
X-Google-Smtp-Source: ABdhPJzzXZz8FGhOqJIy3SOg0uhFjle8bEWKILqBSG3M41u7cJLjsHkjpP4JLeSfHDUPrx8gGM2D3rP9PVKnU83D0i8=
X-Received: by 2002:a1c:740c:: with SMTP id p12mr1761323wmc.176.1600736312695;
 Mon, 21 Sep 2020 17:58:32 -0700 (PDT)
MIME-Version: 1.0
References: <CAK8P3a2Mi+1yttyGk4k7HxRVrMtmFqJewouVhynqUL0PJycmog@mail.gmail.com>
 <D0791499-1190-4C3F-A984-0A313ECA81C7@amacapital.net> <563138b5-7073-74bc-f0c5-b2bad6277e87@gmail.com>
 <486c92d0-0f2e-bd61-1ab8-302524af5e08@gmail.com> <CALCETrW3rwGsgfLNnu_0JAcL5jvrPVTLTWM3JpbB5P9Hye6Fdw@mail.gmail.com>
 <d5c6736a-2cb4-4e22-78da-a667bda5c05a@gmail.com>
In-Reply-To: <d5c6736a-2cb4-4e22-78da-a667bda5c05a@gmail.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Mon, 21 Sep 2020 17:58:20 -0700
X-Gmail-Original-Message-ID: <CALCETrUEC81va8-fuUXG1uA5rbKxnKDYsDOXC70_HtKD4LAeAg@mail.gmail.com>
Message-ID: <CALCETrUEC81va8-fuUXG1uA5rbKxnKDYsDOXC70_HtKD4LAeAg@mail.gmail.com>
Subject: Re: [PATCH 1/9] kernel: add a PF_FORCE_COMPAT flag
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Christoph Hellwig <hch@lst.de>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        David Howells <dhowells@redhat.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "open list:MIPS" <linux-mips@vger.kernel.org>,
        Parisc List <linux-parisc@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        sparclinux <sparclinux@vger.kernel.org>,
        linux-block <linux-block@vger.kernel.org>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        linux-aio <linux-aio@kvack.org>, io-uring@vger.kernel.org,
        linux-arch <linux-arch@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Network Development <netdev@vger.kernel.org>,
        keyrings@vger.kernel.org,
        LSM List <linux-security-module@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 21, 2020 at 5:24 PM Pavel Begunkov <asml.silence@gmail.com> wro=
te:
>
>
>
> On 22/09/2020 02:51, Andy Lutomirski wrote:
> > On Mon, Sep 21, 2020 at 9:15 AM Pavel Begunkov <asml.silence@gmail.com>=
 wrote:
> >>
> >> On 21/09/2020 19:10, Pavel Begunkov wrote:
> >>> On 20/09/2020 01:22, Andy Lutomirski wrote:
> >>>>
> >>>>> On Sep 19, 2020, at 2:16 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> >>>>>
> >>>>> =EF=BB=BFOn Sat, Sep 19, 2020 at 6:21 PM Andy Lutomirski <luto@kern=
el.org> wrote:
> >>>>>>> On Fri, Sep 18, 2020 at 8:16 AM Christoph Hellwig <hch@lst.de> wr=
ote:
> >>>>>>> On Fri, Sep 18, 2020 at 02:58:22PM +0100, Al Viro wrote:
> >>>>>>>> Said that, why not provide a variant that would take an explicit
> >>>>>>>> "is it compat" argument and use it there?  And have the normal
> >>>>>>>> one pass in_compat_syscall() to that...
> >>>>>>>
> >>>>>>> That would help to not introduce a regression with this series ye=
s.
> >>>>>>> But it wouldn't fix existing bugs when io_uring is used to access
> >>>>>>> read or write methods that use in_compat_syscall().  One example =
that
> >>>>>>> I recently ran into is drivers/scsi/sg.c.
> >>>>>
> >>>>> Ah, so reading /dev/input/event* would suffer from the same issue,
> >>>>> and that one would in fact be broken by your patch in the hypotheti=
cal
> >>>>> case that someone tried to use io_uring to read /dev/input/event on=
 x32...
> >>>>>
> >>>>> For reference, I checked the socket timestamp handling that has a
> >>>>> number of corner cases with time32/time64 formats in compat mode,
> >>>>> but none of those appear to be affected by the problem.
> >>>>>
> >>>>>> Aside from the potentially nasty use of per-task variables, one th=
ing
> >>>>>> I don't like about PF_FORCE_COMPAT is that it's one-way.  If we're
> >>>>>> going to have a generic mechanism for this, shouldn't we allow a f=
ull
> >>>>>> override of the syscall arch instead of just allowing forcing comp=
at
> >>>>>> so that a compat syscall can do a non-compat operation?
> >>>>>
> >>>>> The only reason it's needed here is that the caller is in a kernel
> >>>>> thread rather than a system call. Are there any possible scenarios
> >>>>> where one would actually need the opposite?
> >>>>>
> >>>>
> >>>> I can certainly imagine needing to force x32 mode from a kernel thre=
ad.
> >>>>
> >>>> As for the other direction: what exactly are the desired bitness/arc=
h semantics of io_uring?  Is the operation bitness chosen by the io_uring c=
reation or by the io_uring_enter() bitness?
> >>>
> >>> It's rather the second one. Even though AFAIR it wasn't discussed
> >>> specifically, that how it works now (_partially_).
> >>
> >> Double checked -- I'm wrong, that's the former one. Most of it is base=
d
> >> on a flag that was set an creation.
> >>
> >
> > Could we get away with making io_uring_enter() return -EINVAL (or
> > maybe -ENOTTY?) if you try to do it with bitness that doesn't match
> > the io_uring?  And disable SQPOLL in compat mode?
>
> Something like below. If PF_FORCE_COMPAT or any other solution
> doesn't lend by the time, I'll take a look whether other io_uring's
> syscalls need similar checks, etc.
>
>
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 0458f02d4ca8..aab20785fa9a 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -8671,6 +8671,10 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, =
u32, to_submit,
>         if (ctx->flags & IORING_SETUP_R_DISABLED)
>                 goto out;
>
> +       ret =3D -EINVAl;
> +       if (ctx->compat !=3D in_compat_syscall())
> +               goto out;
> +

This seems entirely reasonable to me.  Sharing an io_uring ring
between programs with different ABIs seems a bit nutty.

>         /*
>          * For SQ polling, the thread will do all submissions and complet=
ions.
>          * Just return the requested submit count, and wake the thread if
> @@ -9006,6 +9010,10 @@ static int io_uring_create(unsigned entries, struc=
t io_uring_params *p,
>         if (ret)
>                 goto err;
>
> +       ret =3D -EINVAL;
> +       if (ctx->compat)
> +               goto err;
> +

I may be looking at a different kernel than you, but aren't you
preventing creating an io_uring regardless of whether SQPOLL is
requested?

>         /* Only gets the ring fd, doesn't install it in the file table */
>         fd =3D io_uring_get_fd(ctx, &file);
>         if (fd < 0) {
> --
> Pavel Begunkov
