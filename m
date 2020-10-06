Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FAF2284B9E
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 14:28:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726335AbgJFM2b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 08:28:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726241AbgJFM2a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 08:28:30 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91D5DC061755;
        Tue,  6 Oct 2020 05:28:30 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id y20so1140294pll.12;
        Tue, 06 Oct 2020 05:28:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=34g3MdNJVEk4Coh+a8Qqghb5lgYQKjZyNrJqboaybe0=;
        b=n3gBGG5oo+3Yazlcbz9JapTBnucdsFoIi8Bu1shJ3izqdc74CCAmrl3Q6dlEXb988t
         4fTjce8E/f4K/gwK/SWgWKlSEqphQAv34UHVrnnBY4k/1l/JGIMDxH/jGsdAYmobyW8I
         NqVlQiS9gzsYwC5/3SE6i9xYwLdebx8z1SvLoaNLEqW3IoYUlBNfE4j9xlABvgxRC2Ac
         TB1aPdfp918cizEmSNsbJ4vOrenJnC5vwdNDIahuLzwYu+uM49LKDtt/Fc61xQwF75w4
         Jp7NwjyGENiuPAdif6xN4pblLVMF39wEjuTg2ELcuJY2TtD+rCPI1/VwSiaR54LiLeEl
         3BVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=34g3MdNJVEk4Coh+a8Qqghb5lgYQKjZyNrJqboaybe0=;
        b=BmvQeo4iYst3Bq3Nqd5/QXG2R42ocXALc6ssl4qrTYYs7zmi9YbOFzrT772PHPHG70
         NQsig9DwmEBdbHJB+ooGVBfVLtbEA64Xl49Im8ThJVcZrsSfneguaSKYau9Bs51CHmfP
         Va9iCW15K4ZUxrV/SjGbj0R9I4XzkDi51WsyMr0Fn6OObs3u5XJk72DvHwHG1G8gLj7o
         0X4iWJcctShcMpb6shxrmhdNyUCm/qwYNhIkiAkgN/2S/11y0K2swRhFGgbmc/J0jfmM
         EIlCBoCKczxyaxIiziKgq0PgERg0I4Wn2qaF9d6fxjiSFAeFWS9T9ZC8nwGxUUhWfK23
         LTwg==
X-Gm-Message-State: AOAM533O/eqE0zAkfWecnaMQ0sRjWjrr5bxko0C3aMeH8DIm/57iN9kb
        5VJAg/SSpcr8yoFm1oPKy4mL5ABD3l07OR8rvzs=
X-Google-Smtp-Source: ABdhPJwB4Cxh6Xm29QPguQme76vU2edavYDHuq6X+ZxPViM44IF+dUd9+3Dnh1l8VAq0zq3NsEbxACQ/9UzjmB8IOP0=
X-Received: by 2002:a17:90a:d80e:: with SMTP id a14mr3984745pjv.168.1601987310087;
 Tue, 06 Oct 2020 05:28:30 -0700 (PDT)
MIME-Version: 1.0
References: <1601645787-16944-1-git-send-email-magnus.karlsson@gmail.com> <75f034e8-09c4-9f43-03ed-84f003a036d3@iogearbox.net>
In-Reply-To: <75f034e8-09c4-9f43-03ed-84f003a036d3@iogearbox.net>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Tue, 6 Oct 2020 14:28:19 +0200
Message-ID: <CAJ8uoz0oG=q5ERODhfcvBhZcswGpufp=zUvpG617SkxRP_AaLg@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: fix compatibility problem in xsk_socket__create
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        bpf <bpf@vger.kernel.org>, Ciara Loftus <ciara.loftus@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 5, 2020 at 4:37 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 10/2/20 3:36 PM, Magnus Karlsson wrote:
> > From: Magnus Karlsson <magnus.karlsson@intel.com>
> >
> > Fix a compatibility problem when the old XDP_SHARED_UMEM mode is used
> > together with the xsk_socket__create() call. In the old XDP_SHARED_UMEM
> > mode, only sharing of the same device and queue id was allowed, and in
> > this mode, the fill ring and completion ring were shared between the
> > AF_XDP sockets. Therfore, it was perfectly fine to call the
> > xsk_socket__create() API for each socket and not use the new
> > xsk_socket__create_shared() API. This behaviour was ruined by the
> > commit introducing XDP_SHARED_UMEM support between different devices
> > and/or queue ids. This patch restores the ability to use
> > xsk_socket__create in these circumstances so that backward
> > compatibility is not broken.
> >
> > We also make sure that a user that uses the
> > xsk_socket__create_shared() api for the first socket in the old
> > XDP_SHARED_UMEM mode above, gets and error message if the user tries
> > to feed a fill ring or a completion ring that is not the same as the
> > ones used for the umem registration. Previously, libbpf would just
> > have silently ignored the supplied fill and completion rings and just
> > taken them from the umem. Better to provide an error to the user.
> >
> > Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> > Fixes: 2f6324a3937f ("libbpf: Support shared umems between queues and devices")
> > ---
> >   tools/lib/bpf/xsk.c | 14 +++++++++++++-
> >   1 file changed, 13 insertions(+), 1 deletion(-)
> >
> > diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
> > index 30b4ca5..5b61932 100644
> > --- a/tools/lib/bpf/xsk.c
> > +++ b/tools/lib/bpf/xsk.c
> > @@ -705,7 +705,7 @@ int xsk_socket__create_shared(struct xsk_socket **xsk_ptr,
> >       struct xsk_ctx *ctx;
> >       int err, ifindex;
> >
> > -     if (!umem || !xsk_ptr || !(rx || tx) || !fill || !comp)
> > +     if (!umem || !xsk_ptr || !(rx || tx))
> >               return -EFAULT;
> >
> >       xsk = calloc(1, sizeof(*xsk));
> > @@ -735,12 +735,24 @@ int xsk_socket__create_shared(struct xsk_socket **xsk_ptr,
> >
> >       ctx = xsk_get_ctx(umem, ifindex, queue_id);
> >       if (!ctx) {
> > +             if (!fill || !comp) {
> > +                     err = -EFAULT;
> > +                     goto out_socket;
> > +             }
> > +
> >               ctx = xsk_create_ctx(xsk, umem, ifindex, ifname, queue_id,
> >                                    fill, comp);
> >               if (!ctx) {
> >                       err = -ENOMEM;
> >                       goto out_socket;
> >               }
> > +     } else if ((fill && ctx->fill != fill) || (comp && ctx->comp != comp)) {
> > +             /* If the xsk_socket__create_shared() api is used for the first socket
> > +              * registration, then make sure the fill and completion rings supplied
> > +              * are the same as the ones used to register the umem. If not, bail out.
> > +              */
> > +             err = -EINVAL;
> > +             goto out_socket;
>
> This looks buggy. You got a valid ctx in this path which was ctx->refcount++'ed. By just
> going to out_socket you'll leak this libbpf internal refcount.

Yes, you are correct. Thanks for spotting. It jumps to the wrong
label. It should be:

goto out_put_ctx;

so that ctx refcount is decreased. Will submit a v2.

> >       }
> >       xsk->ctx = ctx;
> >
> >
>
