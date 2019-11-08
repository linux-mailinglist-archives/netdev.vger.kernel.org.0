Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B60B4F5AE8
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 23:31:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728080AbfKHWbG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 17:31:06 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:32821 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726095AbfKHWbG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 17:31:06 -0500
Received: by mail-pf1-f196.google.com with SMTP id c184so5764474pfb.0;
        Fri, 08 Nov 2019 14:31:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Wu5ubnZYQLIP4fPqXNQ/8DGx/HEXQ/JJIGFSBZLMbVc=;
        b=DdVvDJH+Z+0z01wrW959AIrvQL72PAHNB9Ocn6xoJ/f2c0b+W1Vkca6MJRugrJX67K
         BJgQqXUHt/PA0frKRJkoVCPRRMjYjvnUZtVjd+l1MtD1imxgMqq6HPo5ewaZnkbr5rDj
         PT4Kyk7RqhvRWzI1ey4Hj/LKpNcYxXOEwuAeUzAcM7rHmx8i1ue2QVwCd85Y7YkufYjk
         X5/fMXCyw34xu06u20WAaW31vZPYif4eeKQDH9IbaOGqxyyNoQ+jXFxt3znAYtW2JmGX
         vOSBXjU5KCj3AeohvAoujwCYLwEwhozqPFGgZy93htSYDUr2eZ47qe5dyegGx/9WXraO
         g78g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Wu5ubnZYQLIP4fPqXNQ/8DGx/HEXQ/JJIGFSBZLMbVc=;
        b=jA5X0v7Rjg7M4pj6I6w7Wpf+dvlRSfLd/Vn2VX+LoWTaQLBNM+6ICYJEW1sAD/G2ot
         A+g7Z7wu8F+pgncpfIIB0QFOQpJo9DJq2/1zPgZL3VCRYcgxZl2a0wNJ1qoLCmAMn6FM
         fe5cMXxuBmFpcW/Xy3SldQGJdqYv2qxoSPFBTTxL4b9gGlqIhW0824VyeUKyBASelIEH
         z99yHSVOey48URcRsJDO6v6HI2jkGlRYTGVS/wSCtWFfG28GKEMVsii+8ijSh2liJPhy
         fSMG3Bfwu+l2aablVLXHk2mXMdS8IY1lQ86zwv9tunykIkGQ4N0xbIch6dnEjaMeQmpQ
         AP4A==
X-Gm-Message-State: APjAAAUD1BJuNEofTRsEU4an4nx/Ia8ctTU2E6pvm5RJJ1jb0SBduWIm
        soFHpT9Zm4W3VhObfVBRyO4=
X-Google-Smtp-Source: APXvYqznSnVLNyR5dWZDRhth8Ex1T07zuKOQiERUdAHrIVKh9vn+bZ1UOI/qFPoImmMfm9jbhrEPnQ==
X-Received: by 2002:a63:6506:: with SMTP id z6mr14541726pgb.65.1573252263287;
        Fri, 08 Nov 2019 14:31:03 -0800 (PST)
Received: from gmail.com ([66.170.99.95])
        by smtp.gmail.com with ESMTPSA id d8sm6605908pfo.47.2019.11.08.14.31.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 08 Nov 2019 14:31:02 -0800 (PST)
Date:   Fri, 8 Nov 2019 14:31:01 -0800
From:   William Tu <u9012063@gmail.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     Magnus Karlsson <magnus.karlsson@intel.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next 1/5] libbpf: support XDP_SHARED_UMEM with
 external XDP program
Message-ID: <20191108223101.GA32043@gmail.com>
References: <1573148860-30254-1-git-send-email-magnus.karlsson@intel.com>
 <1573148860-30254-2-git-send-email-magnus.karlsson@intel.com>
 <20191108180314.GA30004@gmail.com>
 <CAJ8uoz0DJx0sbsAU1GyjZcX3JvcEq7QKFRM5sYrZ_ScAHgEE=A@mail.gmail.com>
 <20191108184320.GC30004@gmail.com>
 <CAJ8uoz3_N4JZZtJpWAsRBSLHv0tm4vtC4RT-r-USN0WhudMbig@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJ8uoz3_N4JZZtJpWAsRBSLHv0tm4vtC4RT-r-USN0WhudMbig@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 08, 2019 at 08:17:53PM +0100, Magnus Karlsson wrote:
> On Fri, Nov 8, 2019 at 7:43 PM William Tu <u9012063@gmail.com> wrote:
> >
> > On Fri, Nov 08, 2019 at 07:19:18PM +0100, Magnus Karlsson wrote:
> > > On Fri, Nov 8, 2019 at 7:03 PM William Tu <u9012063@gmail.com> wrote:
> > > >
> > > > Hi Magnus,
> > > >
> > > > Thanks for the patch.
> > > >
> > > > On Thu, Nov 07, 2019 at 06:47:36PM +0100, Magnus Karlsson wrote:
> > > > > Add support in libbpf to create multiple sockets that share a single
> > > > > umem. Note that an external XDP program need to be supplied that
> > > > > routes the incoming traffic to the desired sockets. So you need to
> > > > > supply the libbpf_flag XSK_LIBBPF_FLAGS__INHIBIT_PROG_LOAD and load
> > > > > your own XDP program.
> > > > >
> > > > > Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> > > > > ---
> > > > >  tools/lib/bpf/xsk.c | 27 +++++++++++++++++----------
> > > > >  1 file changed, 17 insertions(+), 10 deletions(-)
> > > > >
> > > > > diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
> > > > > index 86c1b61..8ebd810 100644
> > > > > --- a/tools/lib/bpf/xsk.c
> > > > > +++ b/tools/lib/bpf/xsk.c
> > > > > @@ -586,15 +586,21 @@ int xsk_socket__create(struct xsk_socket **xsk_ptr, const char *ifname,
> > > > >       if (!umem || !xsk_ptr || !rx || !tx)
> > > > >               return -EFAULT;
> > > > >
> > > > > -     if (umem->refcount) {
> > > > > -             pr_warn("Error: shared umems not supported by libbpf.\n");
> > > > > -             return -EBUSY;
> > > > > -     }
> > > > > -
> > > > >       xsk = calloc(1, sizeof(*xsk));
> > > > >       if (!xsk)
> > > > >               return -ENOMEM;
> > > > >
> > > > > +     err = xsk_set_xdp_socket_config(&xsk->config, usr_config);
> > > > > +     if (err)
> > > > > +             goto out_xsk_alloc;
> > > > > +
> > > > > +     if (umem->refcount &&
> > > > > +         !(xsk->config.libbpf_flags & XSK_LIBBPF_FLAGS__INHIBIT_PROG_LOAD)) {
> > > > > +             pr_warn("Error: shared umems not supported by libbpf supplied XDP program.\n");
> > > >
> > > > Why can't we use the existing default one in libbpf?
> > > > If users don't want to redistribute packet to different queue,
> > > > then they can still use the libbpf default one.
> > >
> > > Is there any point in creating two or more sockets tied to the same
> > > umem and directing all traffic to just one socket? IMHO, I believe
> >
> > When using build-in XDP, isn't the traffic being directed to its
> > own xsk on its queue? (so not just one xsk socket)
> >
> > So using build-in XDP, for example, queue1/xsk1 and queue2/xsk2, and
> > sharing one umem. Both xsk1 and xsk2 receive packets from their queue.
> 
> WIth the XDP_SHARED_UMEM flag this is not allowed. In your example,
> queue1/xsk1 and queue1/xsk2 would be allowed. All sockets need to be
> tied to the same queue id if they share a umem. In this case an XDP
> program has to decide how to distribute the packets since they all
> arrive on the same queue.
> 
> If you want queue1/xsk1 and queue2/xsk2 you need separate umems since
> it would otherwise violate the SPSC requirement or the rings. Or
> implement MPSC and SPMC queues to be used in this configuration.
> 
> > > that most users in this case would want to distribute the packets over
> > > the sockets in some way. I also think that users might be unpleasantly
> > > surprised if they create multiple sockets and all packets only get to
> > > a single socket because libbpf loaded an XDP program that makes little
> > > sense in the XDP_SHARED_UMEM case. If we force them to supply an XDP
> >
> > Do I misunderstand the code?
> > I looked at xsk_setup_xdp_prog, xsk_load_xdp_prog, and xsk_set_bpf_maps.
> > The build-in prog will distribute packets to different xsk sockets,
> > not a single socket.
> 
> True, but only for the case above (queue1/xsk1 and queue2/xsk2) where
> they have separate umems. For the queue1/xsk1 and queue1/xsk2 case, it
> would send everything to xsk1.
> 
> /Magnus

Hi Magnus,

Thanks for your explanation. Now I understand.

William

