Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1E3B2F184D
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 15:29:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388361AbhAKO14 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 09:27:56 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:46481 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1733225AbhAKO1y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 09:27:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610375188;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CHPeCEbaHbj2Od0I3DVp/GwXhgaqLn8QyohlkXhOCJU=;
        b=clzjmPIIOZtF9pDSk5qU1jKRy7+i9MHOt/Se5DTfyXlriRPaVElTnqRi9rQQYc6tyrIsNX
        8ImNg1BGjbkozCXQIzAgSYN3gxfsrh6Rgglv2CKlmEUGNUhSMWpPavCdCN8lT6z3y8gT8p
        3ONWCRkXZFXwvycuxdqQj6jUWQrI2AQ=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-216-X0wWAGW7NUynL0fS0IJAmQ-1; Mon, 11 Jan 2021 09:26:26 -0500
X-MC-Unique: X0wWAGW7NUynL0fS0IJAmQ-1
Received: by mail-wm1-f70.google.com with SMTP id b4so5192491wmj.4
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 06:26:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=CHPeCEbaHbj2Od0I3DVp/GwXhgaqLn8QyohlkXhOCJU=;
        b=Zv+KZ1a8cvatqS2u9zigFme+LZ8B/+pLtyYrkZJIsskHKhodVjV5kwI5dElcT78vqd
         iXiqKl3zVJ387VNqurtWGS2g2m/ctom41vRHpvAE0CvqDr4eymEDBbKa5/lWD8Yj14mx
         i49bIrrJDwmVX0YUTmb156vwXXxBXc5meuCcTBUlGXs0l6t/nF/WcTJ8JacwmHBpSHY4
         A+/dknmKE0KfwoOfv3lMkoXjQjckHM6jNT2LngWzbFDDpsb15vmViCncYW6UEedQ+k9N
         pgQipF0SRd09Pu5FkT9GL/nn4bxzSpBm2mSCmSb+MwxDBKB6vS/u1MneuAM1i3wy3GCK
         MKMA==
X-Gm-Message-State: AOAM532nZ4VLYESfG7ceNFQVFKPZAwURdV2EbV/dfNk1pZOFvxyxJ3pk
        KhpN4eChDFA6PEfJTMyONMKA28kD2hNw+o1YNKNIQSkA/pxu1BYtWDrxe5H8U0kzFtbuNnM0vNW
        Y4cLRKTdKlZ6atVR7
X-Received: by 2002:a7b:c8c5:: with SMTP id f5mr4467wml.106.1610375184749;
        Mon, 11 Jan 2021 06:26:24 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz8SDoeRvnOoGXS5ccYWbpIeNA43tQ7cFxXNi4vYHReSCAs6ikHp10y7lv+h8/D6kPUal4DeA==
X-Received: by 2002:a7b:c8c5:: with SMTP id f5mr4449wml.106.1610375184520;
        Mon, 11 Jan 2021 06:26:24 -0800 (PST)
Received: from linux.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id u6sm26959328wrm.90.2021.01.11.06.26.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jan 2021 06:26:23 -0800 (PST)
Date:   Mon, 11 Jan 2021 15:26:21 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Simon Chopin <s.chopin@alphalink.fr>
Cc:     Tom Parkin <tparkin@katalix.com>, netdev@vger.kernel.org
Subject: Re: [PATCH v4 net-next 1/2] ppp: add PPPIOCBRIDGECHAN and
 PPPIOCUNBRIDGECHAN ioctls
Message-ID: <20210111142621.GB13412@linux.home>
References: <20201210155058.14518-1-tparkin@katalix.com>
 <20201210155058.14518-2-tparkin@katalix.com>
 <ebc3b218-ab1c-30b1-144b-413b168631b1@alphalink.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ebc3b218-ab1c-30b1-144b-413b168631b1@alphalink.fr>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 11, 2021 at 02:17:13PM +0100, Simon Chopin wrote:
> Hello,
> 
> Le 10/12/2020 à 16:50, Tom Parkin a écrit :
> > This new ioctl pair allows two ppp channels to be bridged together:
> > frames arriving in one channel are transmitted in the other channel
> > and vice versa.
> > 
> > The practical use for this is primarily to support the L2TP Access
> > Concentrator use-case.  The end-user session is presented as a ppp
> > channel (typically PPPoE, although it could be e.g. PPPoA, or even PPP
> > over a serial link) and is switched into a PPPoL2TP session for
> > transmission to the LNS.  At the LNS the PPP session is terminated in
> > the ISP's network.
> > 
> > When a PPP channel is bridged to another it takes a reference on the
> > other's struct ppp_file.  This reference is dropped when the channels
> > are unbridged, which can occur either explicitly on userspace calling
> > the PPPIOCUNBRIDGECHAN ioctl, or implicitly when either channel in the
> > bridge is unregistered.
> > 
> > In order to implement the channel bridge, struct channel is extended
> > with a new field, 'bridge', which points to the other struct channel
> > making up the bridge.
> > 
> > This pointer is RCU protected to avoid adding another lock to the data
> > path.
> > 
> > To guard against concurrent writes to the pointer, the existing struct
> > channel lock 'upl' coverage is extended rather than adding a new lock.
> > 
> > The 'upl' lock is used to protect the existing unit pointer.  Since the
> > bridge effectively replaces the unit (they're mutually exclusive for a
> > channel) it makes coding easier to use the same lock to cover them
> > both.
> > 
> > Signed-off-by: Tom Parkin <tparkin@katalix.com>
> > ---
> >  drivers/net/ppp/ppp_generic.c  | 152 ++++++++++++++++++++++++++++++++-
> >  include/uapi/linux/ppp-ioctl.h |   2 +
> >  2 files changed, 151 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/net/ppp/ppp_generic.c b/drivers/net/ppp/ppp_generic.c
> > index 7d005896a0f9..09c27f7773f9 100644
> > --- a/drivers/net/ppp/ppp_generic.c
> > +++ b/drivers/net/ppp/ppp_generic.c
> > @@ -174,7 +174,8 @@ struct channel {
> >  	struct ppp	*ppp;		/* ppp unit we're connected to */
> >  	struct net	*chan_net;	/* the net channel belongs to */
> >  	struct list_head clist;		/* link in list of channels per unit */
> > -	rwlock_t	upl;		/* protects `ppp' */
> > +	rwlock_t	upl;		/* protects `ppp' and 'bridge' */
> > +	struct channel __rcu *bridge;	/* "bridged" ppp channel */
> >  #ifdef CONFIG_PPP_MULTILINK
> >  	u8		avail;		/* flag used in multilink stuff */
> >  	u8		had_frag;	/* >= 1 fragments have been sent */
> > @@ -606,6 +607,83 @@ static struct bpf_prog *compat_ppp_get_filter(struct sock_fprog32 __user *p)
> >  #endif
> >  #endif
> >  
> > +/* Bridge one PPP channel to another.
> > + * When two channels are bridged, ppp_input on one channel is redirected to
> > + * the other's ops->start_xmit handler.
> > + * In order to safely bridge channels we must reject channels which are already
> > + * part of a bridge instance, or which form part of an existing unit.
> > + * Once successfully bridged, each channel holds a reference on the other
> > + * to prevent it being freed while the bridge is extant.
> > + */
> > +static int ppp_bridge_channels(struct channel *pch, struct channel *pchb)
> > +{
> > +	write_lock_bh(&pch->upl);
> > +	if (pch->ppp ||
> > +	    rcu_dereference_protected(pch->bridge, lockdep_is_held(&pch->upl))) {
> > +		write_unlock_bh(&pch->upl);
> > +		return -EALREADY;
> > +	}
> > +	rcu_assign_pointer(pch->bridge, pchb);
> > +	write_unlock_bh(&pch->upl);
> > +
> This is mostly for my own education:
> 
> I might be misunderstanding something, but is there anything
> that would prevent a packet from being forwarded from pch to pchb at this
> precise moment? If not, then it might be theoretically possible to have
> any answer to said packet (say, a LCP ACK) to be received before the 
> pchb->bridge is set?

That's possible in theory. But I can't see any problem in practice,
because:

  * It's unlikely the round trip time would be small enough to trigger
    this situation.

  * If this situation ever happens, the reply is passed to user space,
    which is free to forward it to the other channel. If the user
    space implementation isn't prepared for this situation and just
    drops the packet, that's fine too. It's just a transient packet
    drop, which PPP peers are supposed to handle just fine (this can
    happen anywhere in the network after all).

  * Any use case I know for channel bridging involves a "live" channel
    (where LCP and authentication protocols are running) and an "idle"
    channel (where no protocol is running at all yet). So the problem
    can be avoided entirely by calling the PPPIOCBRIDGECHAN ioctl on
    the idle channel file descriptor, rather than on the live channel.

Or did you have any other possible problem in mind?

> > +	write_lock_bh(&pchb->upl);
> > +	if (pchb->ppp ||
> > +	    rcu_dereference_protected(pchb->bridge, lockdep_is_held(&pchb->upl))) {
> > +		write_unlock_bh(&pchb->upl);
> > +		goto err_unset;
> > +	}
> > +	rcu_assign_pointer(pchb->bridge, pch);
> > +	write_unlock_bh(&pchb->upl);
> > +
> > +	refcount_inc(&pch->file.refcnt);
> > +	refcount_inc(&pchb->file.refcnt);
> > +
> > +	return 0;
> > +
> > +err_unset:
> > +	write_lock_bh(&pch->upl);
> > +	RCU_INIT_POINTER(pch->bridge, NULL);
> > +	write_unlock_bh(&pch->upl);
> > +	synchronize_rcu();
> > +	return -EALREADY;
> > +}
> 

