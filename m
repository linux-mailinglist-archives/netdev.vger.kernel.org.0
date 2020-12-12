Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8C852D84E6
	for <lists+netdev@lfdr.de>; Sat, 12 Dec 2020 06:40:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729946AbgLLFi0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 00:38:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725813AbgLLFhp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Dec 2020 00:37:45 -0500
Received: from mail-ua1-x941.google.com (mail-ua1-x941.google.com [IPv6:2607:f8b0:4864:20::941])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A1F2C0613CF
        for <netdev@vger.kernel.org>; Fri, 11 Dec 2020 21:37:05 -0800 (PST)
Received: by mail-ua1-x941.google.com with SMTP id n18so3610185ual.9
        for <netdev@vger.kernel.org>; Fri, 11 Dec 2020 21:37:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=vf1LpceJ3/eT76im7d0MJGd4tAxKu5YcAEonLzrJyco=;
        b=NjhDSnOi456i0iHZqsvYHKd+DjUvwCU2Yrl34UwuSuYLjnEU8Q+6lXrt53fam4JdYS
         H7xHmQwaTLGguPqCO2zDsoMmMNXQSpMel1/GR61LLfCwxt6u1Xx6S0K4oSMZOOk8oPvz
         LdwhYJHCHOy4nqU7niaf2H3bs8EO6k+ya1ctq5ME+EZcleStY9K6B+wyPa3XtwwqsDj9
         OXyMLd2tAwCtNIksCWnvL1XZ2hIAX4NS0sD4daUwUWGG4LAotcIEwnaFWd9Do2bnyND9
         F2IOf82c94AGIh9S3z7Qn0OknuRuq5TATCLhDU5cS+EwGhBJtPNPHbk0JQM55uFxLAN4
         /Dsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=vf1LpceJ3/eT76im7d0MJGd4tAxKu5YcAEonLzrJyco=;
        b=orlhsJHsB3fi83fhFzjHQfDOlrKn2Hpl/+taop0O8+KaTm8ys0MnrYf3h7QPYrc4Ew
         Ro5WMtgqQgvTFKexcyYUYoLh6Ui/YhLeijcL3yp9jQgRb7StnTMuQloTF/MYDjndnvT5
         1+sY1KoVXXv6Rba/6GC089iV/1KRLSgr+egP8ZPoZrEH2ZqxBIFhgBAoLNwNLTB3OE7J
         wlhfDHjfuW5v4Z1eqqctTCv3CJyuYS+/S8XGN8rC7pxW041eJEccDb0XvbvsAPTbL9MD
         HpIkgWbA+X4ky1zpSflvcMsVu0PN4WL7fV4AaWzja7NDZxahxgcykErNmlsemJ44jDQ/
         0M7Q==
X-Gm-Message-State: AOAM531z7faFQYsOLxXiZynk5rvjGYIiCo/fa78lab08thNOaiX08QJx
        V2f82Js3slS/4uz+QI10OZxIE8zM0jTp5xcBo6P4j3G10CfoISWy
X-Google-Smtp-Source: ABdhPJy9darlr9FtznUuVqLUVvOl81LZhnxLJMYLHUMw9alOppj48ixyaInO9Ii60CigOyhm9vbpKZsoYZoptVwvy3Y=
X-Received: by 2002:ab0:704e:: with SMTP id v14mr15727504ual.134.1607751422731;
 Fri, 11 Dec 2020 21:37:02 -0800 (PST)
MIME-Version: 1.0
References: <20201211042610.71081-1-yanjun.zhu@intel.com> <b3cd5ccb-e1cc-f091-8330-dba6c58b2fc3@iogearbox.net>
In-Reply-To: <b3cd5ccb-e1cc-f091-8330-dba6c58b2fc3@iogearbox.net>
From:   Rain River <rain.1986.08.12@gmail.com>
Date:   Sat, 12 Dec 2020 13:36:51 +0800
Message-ID: <CAJr_XRCKC++xBJY-1cxj6M7sSsf2ZBHzV-EeM65y=7VzAY=M_w@mail.gmail.com>
Subject: Re: [PATCH v3 1/1] xdp: avoid calling kfree twice
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Zhu Yanjun <yanjun.zhu@intel.com>, zyjzyj2000@gmail.com,
        bjorn.topel@intel.com, magnus.karlsson@intel.com,
        netdev@vger.kernel.org, jonathan.lemon@gmail.com,
        Ye Dong <dong.ye@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 11, 2020 at 11:53 PM Daniel Borkmann <daniel@iogearbox.net> wro=
te:
>
> On 12/11/20 5:26 AM, Zhu Yanjun wrote:
> > In the function xdp_umem_pin_pages, if npgs !=3D umem->npgs and
> > npgs >=3D 0, the function xdp_umem_unpin_pages is called. In this
> > function, kfree is called to handle umem->pgs, and then in the
> > function xdp_umem_pin_pages, kfree is called again to handle
> > umem->pgs. Eventually, to umem->pgs, kfree is called twice.
> >
> > Since umem->pgs is set to NULL after the first kfree, the second
> > kfree would not trigger call trace.
>
> This can still be misinterpreted imho; maybe lets simplify, for example:
>
>    [bpf-next] xdp: avoid unnecessary second call to kfree
>
>    For the case when in xdp_umem_pin_pages() the call to pin_user_pages()
>    wasn't able to pin all the requested number of pages in memory (but so=
me)
>    then we error out by cleaning up the ones that got pinned through a ca=
ll
>    to xdp_umem_unpin_pages() and later on we free kfree(umem->pgs) itself=
.
>
>    This is unneeded since xdp_umem_unpin_pages() itself already does the
>    kfree(umem->pgs) internally with subsequent setting umem->pgs to NULL,=
 so
>    that in xdp_umem_pin_pages() the second kfree(umem->pgs) becomes entir=
ely
>    unnecessary for this case. Therefore, clean the error handling up.
>
> > Fixes: c0c77d8fb787 ("xsk: add user memory registration support sockopt=
")
>
> Why do we need a Fixes tag here? It's a _cleanup_, not a bug/fix technica=
lly.
>
> > CC: Ye Dong <dong.ye@intel.com>
> > Acked-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> > Signed-off-by: Zhu Yanjun <yanjun.zhu@intel.com>
> > ---
> >   net/xdp/xdp_umem.c | 17 +++++------------
> >   1 file changed, 5 insertions(+), 12 deletions(-)
> >
> > diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
> > index 56a28a686988..01b31c56cead 100644
> > --- a/net/xdp/xdp_umem.c
> > +++ b/net/xdp/xdp_umem.c
> > @@ -97,7 +97,6 @@ static int xdp_umem_pin_pages(struct xdp_umem *umem, =
unsigned long address)
> >   {
> >       unsigned int gup_flags =3D FOLL_WRITE;
> >       long npgs;
> > -     int err;
> >
> >       umem->pgs =3D kcalloc(umem->npgs, sizeof(*umem->pgs),
> >                           GFP_KERNEL | __GFP_NOWARN);
> > @@ -112,20 +111,14 @@ static int xdp_umem_pin_pages(struct xdp_umem *um=
em, unsigned long address)
> >       if (npgs !=3D umem->npgs) {
> >               if (npgs >=3D 0) {
> >                       umem->npgs =3D npgs;
> > -                     err =3D -ENOMEM;
> > -                     goto out_pin;
> > +                     xdp_umem_unpin_pages(umem);
> > +                     return -ENOMEM;
> >               }
> > -             err =3D npgs;
> > -             goto out_pgs;
> > +             kfree(umem->pgs);
> > +             umem->pgs =3D NULL;
> > +             return (int)npgs;
> >       }
> >       return 0;
> > -
> > -out_pin:
> > -     xdp_umem_unpin_pages(umem);
> > -out_pgs:
> > -     kfree(umem->pgs);
> > -     umem->pgs =3D NULL;
> > -     return err;
> >   }
> >
> >   static int xdp_umem_account_pages(struct xdp_umem *umem)
> >
>
> While at it, maybe we could also simplify the if (npgs !=3D umem->npgs) a=
 bit to
> get rid of the indent, something like:

The original patch is just to make some cleanups. Please do not make
it so complicated.
If you like it, please file an official patch for code review.

>
> diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
> index 56a28a686988..fa4dd16cced5 100644
> --- a/net/xdp/xdp_umem.c
> +++ b/net/xdp/xdp_umem.c
> @@ -97,7 +97,6 @@ static int xdp_umem_pin_pages(struct xdp_umem *umem, un=
signed long address)
>   {
>         unsigned int gup_flags =3D FOLL_WRITE;
>         long npgs;
> -       int err;
>
>         umem->pgs =3D kcalloc(umem->npgs, sizeof(*umem->pgs),
>                             GFP_KERNEL | __GFP_NOWARN);
> @@ -108,24 +107,17 @@ static int xdp_umem_pin_pages(struct xdp_umem *umem=
, unsigned long address)
>         npgs =3D pin_user_pages(address, umem->npgs,
>                               gup_flags | FOLL_LONGTERM, &umem->pgs[0], N=
ULL);
>         mmap_read_unlock(current->mm);
> -
> -       if (npgs !=3D umem->npgs) {
> -               if (npgs >=3D 0) {
> -                       umem->npgs =3D npgs;
> -                       err =3D -ENOMEM;
> -                       goto out_pin;
> -               }
> -               err =3D npgs;
> -               goto out_pgs;
> +       if (npgs =3D=3D umem->npgs)
> +               return 0;
> +       if (npgs >=3D 0) {
> +               umem->npgs =3D npgs;
> +               xdp_umem_unpin_pages(umem);
> +               return -ENOMEM;
>         }
> -       return 0;
>
> -out_pin:
> -       xdp_umem_unpin_pages(umem);
> -out_pgs:
>         kfree(umem->pgs);
>         umem->pgs =3D NULL;
> -       return err;
> +       return npgs;
>   }
>
>   static int xdp_umem_account_pages(struct xdp_umem *umem)
