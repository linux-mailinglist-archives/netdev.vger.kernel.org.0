Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D416F571B
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 21:05:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390407AbfKHTSI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 14:18:08 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:36371 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389814AbfKHTSF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 14:18:05 -0500
Received: by mail-ot1-f67.google.com with SMTP id f10so6150295oto.3;
        Fri, 08 Nov 2019 11:18:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PshHM4wMUmgh4w0+dg2Pa170zD6/a/9WGi4RKmoPqrE=;
        b=Us2wo00rEDbnJ5WSxsRzjKQzr/4J5sRXF4Z6PGQSq6srp6MgnwVxaHDthN5gntnWAT
         aRo01cNo5hr5xtpeiIOTw0dabti1PC5A+C95b7NAkhCun7Kwl38dVJBmYlo4KySwoJLn
         i27wLG0LPpuz01uT3zQ5JdAjdIvv4hg7CsY3uD6FysqArUOld2Ii1yaQtYUYy931/22i
         3mtlknaYGgEu7gMhfWCDkxLSr0w9+p3gqigVVHt7xMXf7rPwIUxHa7rVq18369qfvVNd
         FbVY0qjmdfqbXHh24bGXFfCOrXdhNgthnu4MeeUOr8ew4CP//QGUIttqQahJ/pNMFyCQ
         dt+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PshHM4wMUmgh4w0+dg2Pa170zD6/a/9WGi4RKmoPqrE=;
        b=q63eW+njnqcj2B5WGmMX8a3jVC18Gu0RCQ0TOb7pKo6wjZrc0+f2/aBGTI3Tp3TINO
         tMZhhqy6TDT4ChLx9pRHVeD0m9ITqdREnpHqmbRokC3b9QAJ0pFhm5afWscsir9fdDob
         ibtfMxocbZ5LD6d/CL3xg6Pp00AW3s1+YbJd7NxuBQPSDS2NDGCjSEF/bd+HMT09Cw9C
         5t5XxQ6fBQKKTmL1ubrC8ujO770WrAeaJghCSc+VFuN95Y6fq2zBCfvS62JQUJV7NwAy
         QgDmQuOkI926u/bZl1yGKrUYuB3EXqHuN13HoFHvAPALTsa5OJ+//xywenMu60y2yuWq
         /oBQ==
X-Gm-Message-State: APjAAAW0X8h4idYe1kHmjfrw0JoIOkfV2QB01QMcTGNOqX0INQAMsIk5
        U3zKt06srhaL/rf8NtzFAElavsBT/r63eH6g4do=
X-Google-Smtp-Source: APXvYqz9tjMdt62d6o8FLz7qizChgVo/9yy6E3pgLz6i3Y7LEF03hHrhv1Ca5LQYSg4dX3EoL3FJL8PaU6WU2yR+Oh8=
X-Received: by 2002:a05:6830:2363:: with SMTP id r3mr10323155oth.39.1573240684852;
 Fri, 08 Nov 2019 11:18:04 -0800 (PST)
MIME-Version: 1.0
References: <1573148860-30254-1-git-send-email-magnus.karlsson@intel.com>
 <1573148860-30254-2-git-send-email-magnus.karlsson@intel.com>
 <20191108180314.GA30004@gmail.com> <CAJ8uoz0DJx0sbsAU1GyjZcX3JvcEq7QKFRM5sYrZ_ScAHgEE=A@mail.gmail.com>
 <20191108184320.GC30004@gmail.com>
In-Reply-To: <20191108184320.GC30004@gmail.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Fri, 8 Nov 2019 20:17:53 +0100
Message-ID: <CAJ8uoz3_N4JZZtJpWAsRBSLHv0tm4vtC4RT-r-USN0WhudMbig@mail.gmail.com>
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

On Fri, Nov 8, 2019 at 7:43 PM William Tu <u9012063@gmail.com> wrote:
>
> On Fri, Nov 08, 2019 at 07:19:18PM +0100, Magnus Karlsson wrote:
> > On Fri, Nov 8, 2019 at 7:03 PM William Tu <u9012063@gmail.com> wrote:
> > >
> > > Hi Magnus,
> > >
> > > Thanks for the patch.
> > >
> > > On Thu, Nov 07, 2019 at 06:47:36PM +0100, Magnus Karlsson wrote:
> > > > Add support in libbpf to create multiple sockets that share a single
> > > > umem. Note that an external XDP program need to be supplied that
> > > > routes the incoming traffic to the desired sockets. So you need to
> > > > supply the libbpf_flag XSK_LIBBPF_FLAGS__INHIBIT_PROG_LOAD and load
> > > > your own XDP program.
> > > >
> > > > Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> > > > ---
> > > >  tools/lib/bpf/xsk.c | 27 +++++++++++++++++----------
> > > >  1 file changed, 17 insertions(+), 10 deletions(-)
> > > >
> > > > diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
> > > > index 86c1b61..8ebd810 100644
> > > > --- a/tools/lib/bpf/xsk.c
> > > > +++ b/tools/lib/bpf/xsk.c
> > > > @@ -586,15 +586,21 @@ int xsk_socket__create(struct xsk_socket **xsk_ptr, const char *ifname,
> > > >       if (!umem || !xsk_ptr || !rx || !tx)
> > > >               return -EFAULT;
> > > >
> > > > -     if (umem->refcount) {
> > > > -             pr_warn("Error: shared umems not supported by libbpf.\n");
> > > > -             return -EBUSY;
> > > > -     }
> > > > -
> > > >       xsk = calloc(1, sizeof(*xsk));
> > > >       if (!xsk)
> > > >               return -ENOMEM;
> > > >
> > > > +     err = xsk_set_xdp_socket_config(&xsk->config, usr_config);
> > > > +     if (err)
> > > > +             goto out_xsk_alloc;
> > > > +
> > > > +     if (umem->refcount &&
> > > > +         !(xsk->config.libbpf_flags & XSK_LIBBPF_FLAGS__INHIBIT_PROG_LOAD)) {
> > > > +             pr_warn("Error: shared umems not supported by libbpf supplied XDP program.\n");
> > >
> > > Why can't we use the existing default one in libbpf?
> > > If users don't want to redistribute packet to different queue,
> > > then they can still use the libbpf default one.
> >
> > Is there any point in creating two or more sockets tied to the same
> > umem and directing all traffic to just one socket? IMHO, I believe
>
> When using build-in XDP, isn't the traffic being directed to its
> own xsk on its queue? (so not just one xsk socket)
>
> So using build-in XDP, for example, queue1/xsk1 and queue2/xsk2, and
> sharing one umem. Both xsk1 and xsk2 receive packets from their queue.

WIth the XDP_SHARED_UMEM flag this is not allowed. In your example,
queue1/xsk1 and queue1/xsk2 would be allowed. All sockets need to be
tied to the same queue id if they share a umem. In this case an XDP
program has to decide how to distribute the packets since they all
arrive on the same queue.

If you want queue1/xsk1 and queue2/xsk2 you need separate umems since
it would otherwise violate the SPSC requirement or the rings. Or
implement MPSC and SPMC queues to be used in this configuration.

> > that most users in this case would want to distribute the packets over
> > the sockets in some way. I also think that users might be unpleasantly
> > surprised if they create multiple sockets and all packets only get to
> > a single socket because libbpf loaded an XDP program that makes little
> > sense in the XDP_SHARED_UMEM case. If we force them to supply an XDP
>
> Do I misunderstand the code?
> I looked at xsk_setup_xdp_prog, xsk_load_xdp_prog, and xsk_set_bpf_maps.
> The build-in prog will distribute packets to different xsk sockets,
> not a single socket.

True, but only for the case above (queue1/xsk1 and queue2/xsk2) where
they have separate umems. For the queue1/xsk1 and queue1/xsk2 case, it
would send everything to xsk1.

/Magnus

> > program, they need to make this decision. I also wanted to extend the
> > sample with an explicit user loaded XDP program as an example of how
> > to do this. What do you think?
>
> Yes, I like it. Like previous version having the xdpsock_kern.c as an
> example for people to follow.
>
> William
>
> >
> > /Magnus
> >
> > > William
> > > > +             err = -EBUSY;
> > > > +             goto out_xsk_alloc;
> > > > +     }
> > > > +
> > > >       if (umem->refcount++ > 0) {
> > > >               xsk->fd = socket(AF_XDP, SOCK_RAW, 0);
> > > >               if (xsk->fd < 0) {
> > > > @@ -616,10 +622,6 @@ int xsk_socket__create(struct xsk_socket **xsk_ptr, const char *ifname,
> > > >       memcpy(xsk->ifname, ifname, IFNAMSIZ - 1);
> > > >       xsk->ifname[IFNAMSIZ - 1] = '\0';
> > > >
> > > > -     err = xsk_set_xdp_socket_config(&xsk->config, usr_config);
> > > > -     if (err)
> > > > -             goto out_socket;
> > > > -
> > > >       if (rx) {
> > > >               err = setsockopt(xsk->fd, SOL_XDP, XDP_RX_RING,
> > > >                                &xsk->config.rx_size,
> > > > @@ -687,7 +689,12 @@ int xsk_socket__create(struct xsk_socket **xsk_ptr, const char *ifname,
> > > >       sxdp.sxdp_family = PF_XDP;
> > > >       sxdp.sxdp_ifindex = xsk->ifindex;
> > > >       sxdp.sxdp_queue_id = xsk->queue_id;
> > > > -     sxdp.sxdp_flags = xsk->config.bind_flags;
> > > > +     if (umem->refcount > 1) {
> > > > +             sxdp.sxdp_flags = XDP_SHARED_UMEM;
> > > > +             sxdp.sxdp_shared_umem_fd = umem->fd;
> > > > +     } else {
> > > > +             sxdp.sxdp_flags = xsk->config.bind_flags;
> > > > +     }
> > > >
> > > >       err = bind(xsk->fd, (struct sockaddr *)&sxdp, sizeof(sxdp));
> > > >       if (err) {
> > > > --
> > > > 2.7.4
> > > >
