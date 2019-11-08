Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C036F536A
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 19:19:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728495AbfKHSTa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 13:19:30 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:38868 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726462AbfKHSTa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 13:19:30 -0500
Received: by mail-ot1-f67.google.com with SMTP id v24so5998862otp.5;
        Fri, 08 Nov 2019 10:19:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=V9pDZPCOB72mc0w+CgAkcjIsa5BFmf772gEgW5V819A=;
        b=rFchVElXx4ycLxgyvwHwizGlgV9wSkmPk70wocBF25tpayTj9CKIo9+m6DvG8g6COH
         prTiA2ks7ooexqGRhWOOiLLFhzBFh83/aNMwHBoNn0KH/Pjre8tgcIJ07UoJBxDwkqHS
         qaKAZCvouthU+E8lKUI/pnwF05Rn8JBAg1P2RZx0FWAEmHiUw5w1jiARlW9Fkh5Z1Xta
         1dCWBFT3SFmOvdmkj49QQtDUaxwATJBqzs0nkPTWnnLliiDSl14lUgQ3vKWFI2A9LM0u
         ukUskZmL3fWk4HcfaKM+kYb/YyitXhShwqlHLgt1VFoZFc+wuw5kb7CXq0COwy/uVj18
         Eqqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=V9pDZPCOB72mc0w+CgAkcjIsa5BFmf772gEgW5V819A=;
        b=HbfW8OCrIXcLjXT89FAiJA8KHyoKbv1nvWDHXW0QhMrSHaBXLbFFkIOlLNVvq7ygso
         0gi2SFhg4XMJoGLEOSooMEGyVer0yYNuIzWGH0Haj8P6dGZLaYBiKZfjQ/VIUZALdsg1
         nPMj3Wg1VHxjz7J1ttmgByeB39Io0VuYMABOqgpxTulOggZ72NIcDlxI4VLq3kx/z/ud
         G+ZCK/0eD8+chRc271KnVeAkS2kUnSw0FBMJFEQ2WtCHjHnBdOMLvOSTDk6A18eJ84PB
         hVOKh9iNMVFvLT2fcDagQ5EwsENuR1cAMQzdFHyMTI11ZpOs406LQvzhTDhm1VTnkixv
         o/zw==
X-Gm-Message-State: APjAAAVyzsZn4BwdKeCaOmg+19t4aCAlwghO6CI0qN9E/6WAkKJxgrew
        egGDnp4ISi0psrTiqhtDYytY4PO/7JpDYMoehf8=
X-Google-Smtp-Source: APXvYqyGmKprODME71EZE5mb0NXD8QAqoculJAjy1x6ox/WP7nKtzfzu1r6Q/EG/opGDzZhfPGIGYW6UnRoUOw4YNBA=
X-Received: by 2002:a9d:286:: with SMTP id 6mr9858567otl.192.1573237169439;
 Fri, 08 Nov 2019 10:19:29 -0800 (PST)
MIME-Version: 1.0
References: <1573148860-30254-1-git-send-email-magnus.karlsson@intel.com>
 <1573148860-30254-2-git-send-email-magnus.karlsson@intel.com> <20191108180314.GA30004@gmail.com>
In-Reply-To: <20191108180314.GA30004@gmail.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Fri, 8 Nov 2019 19:19:18 +0100
Message-ID: <CAJ8uoz0DJx0sbsAU1GyjZcX3JvcEq7QKFRM5sYrZ_ScAHgEE=A@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/5] libbpf: support XDP_SHARED_UMEM with
 external XDP program
To:     William Tu <u9012063@gmail.com>
Cc:     Magnus Karlsson <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 8, 2019 at 7:03 PM William Tu <u9012063@gmail.com> wrote:
>
> Hi Magnus,
>
> Thanks for the patch.
>
> On Thu, Nov 07, 2019 at 06:47:36PM +0100, Magnus Karlsson wrote:
> > Add support in libbpf to create multiple sockets that share a single
> > umem. Note that an external XDP program need to be supplied that
> > routes the incoming traffic to the desired sockets. So you need to
> > supply the libbpf_flag XSK_LIBBPF_FLAGS__INHIBIT_PROG_LOAD and load
> > your own XDP program.
> >
> > Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> > ---
> >  tools/lib/bpf/xsk.c | 27 +++++++++++++++++----------
> >  1 file changed, 17 insertions(+), 10 deletions(-)
> >
> > diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
> > index 86c1b61..8ebd810 100644
> > --- a/tools/lib/bpf/xsk.c
> > +++ b/tools/lib/bpf/xsk.c
> > @@ -586,15 +586,21 @@ int xsk_socket__create(struct xsk_socket **xsk_ptr, const char *ifname,
> >       if (!umem || !xsk_ptr || !rx || !tx)
> >               return -EFAULT;
> >
> > -     if (umem->refcount) {
> > -             pr_warn("Error: shared umems not supported by libbpf.\n");
> > -             return -EBUSY;
> > -     }
> > -
> >       xsk = calloc(1, sizeof(*xsk));
> >       if (!xsk)
> >               return -ENOMEM;
> >
> > +     err = xsk_set_xdp_socket_config(&xsk->config, usr_config);
> > +     if (err)
> > +             goto out_xsk_alloc;
> > +
> > +     if (umem->refcount &&
> > +         !(xsk->config.libbpf_flags & XSK_LIBBPF_FLAGS__INHIBIT_PROG_LOAD)) {
> > +             pr_warn("Error: shared umems not supported by libbpf supplied XDP program.\n");
>
> Why can't we use the existing default one in libbpf?
> If users don't want to redistribute packet to different queue,
> then they can still use the libbpf default one.

Is there any point in creating two or more sockets tied to the same
umem and directing all traffic to just one socket? IMHO, I believe
that most users in this case would want to distribute the packets over
the sockets in some way. I also think that users might be unpleasantly
surprised if they create multiple sockets and all packets only get to
a single socket because libbpf loaded an XDP program that makes little
sense in the XDP_SHARED_UMEM case. If we force them to supply an XDP
program, they need to make this decision. I also wanted to extend the
sample with an explicit user loaded XDP program as an example of how
to do this. What do you think?

/Magnus

> William
> > +             err = -EBUSY;
> > +             goto out_xsk_alloc;
> > +     }
> > +
> >       if (umem->refcount++ > 0) {
> >               xsk->fd = socket(AF_XDP, SOCK_RAW, 0);
> >               if (xsk->fd < 0) {
> > @@ -616,10 +622,6 @@ int xsk_socket__create(struct xsk_socket **xsk_ptr, const char *ifname,
> >       memcpy(xsk->ifname, ifname, IFNAMSIZ - 1);
> >       xsk->ifname[IFNAMSIZ - 1] = '\0';
> >
> > -     err = xsk_set_xdp_socket_config(&xsk->config, usr_config);
> > -     if (err)
> > -             goto out_socket;
> > -
> >       if (rx) {
> >               err = setsockopt(xsk->fd, SOL_XDP, XDP_RX_RING,
> >                                &xsk->config.rx_size,
> > @@ -687,7 +689,12 @@ int xsk_socket__create(struct xsk_socket **xsk_ptr, const char *ifname,
> >       sxdp.sxdp_family = PF_XDP;
> >       sxdp.sxdp_ifindex = xsk->ifindex;
> >       sxdp.sxdp_queue_id = xsk->queue_id;
> > -     sxdp.sxdp_flags = xsk->config.bind_flags;
> > +     if (umem->refcount > 1) {
> > +             sxdp.sxdp_flags = XDP_SHARED_UMEM;
> > +             sxdp.sxdp_shared_umem_fd = umem->fd;
> > +     } else {
> > +             sxdp.sxdp_flags = xsk->config.bind_flags;
> > +     }
> >
> >       err = bind(xsk->fd, (struct sockaddr *)&sxdp, sizeof(sxdp));
> >       if (err) {
> > --
> > 2.7.4
> >
