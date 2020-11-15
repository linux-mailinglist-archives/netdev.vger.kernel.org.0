Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1E672B3626
	for <lists+netdev@lfdr.de>; Sun, 15 Nov 2020 17:29:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727172AbgKOQ2s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Nov 2020 11:28:48 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24583 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726743AbgKOQ2r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Nov 2020 11:28:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605457726;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=doET0Hr+4F8UN6ZBNIWUkeYEDhOjDwyxEM72WQlKhPs=;
        b=KeBv2tFm6eESMa1n9WGPq4oq7eAoA6+y5Kf9WaM2vWf2+iMK2iJPCAC4PHGzoPEpeaEmXs
        BiBGHZmJqJZBkyRhSaHapyX1Zp9pE5I99nmzvGmCtuWRNxThGL7W26lAinj5l6uPyUFmLr
        vztvJQn4vnX0bStX6cxVKDpp72z9sQ0=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-559-RhZ8ZhlHPoyWwORCilKlYQ-1; Sun, 15 Nov 2020 11:28:44 -0500
X-MC-Unique: RhZ8ZhlHPoyWwORCilKlYQ-1
Received: by mail-wm1-f71.google.com with SMTP id o19so8715415wme.2
        for <netdev@vger.kernel.org>; Sun, 15 Nov 2020 08:28:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=doET0Hr+4F8UN6ZBNIWUkeYEDhOjDwyxEM72WQlKhPs=;
        b=SY7kLuNr7Gk0kGgE84yzj5nEG+QShmq0aVntEotBbKjISjsnd+QJ6b/M24XPZF+wbj
         myNCYgo7SXoUiH7qQlk57Qe9NQgZTd3CgLddcQ1C1QKFvBXJtnD74rz5fX4kVhXu2yuC
         YA/Wg0n+XUH8P25x9iVmkpF4u+ZHSdlcE5lncorMeLpFqnTKKvdqMU0ZRqdOEO03n78a
         hMvO86aKYUYMZPQ7VrExas7K7lIqHO61oxVa3Ya2+swyTYVRtFsqcIFwfAFcufODqFjO
         ffyiTEj0zIkaamycylrD56/p6xetDzhK6NNEC2uaYTpx/ip5gzaJCLwWkNqmK8JP7nn7
         K0fQ==
X-Gm-Message-State: AOAM5318DdZZfAtZp1ee/yWthKvY9bcC9s+DfpV1Pe+u0gpLdgYqnNjp
        EBBq3H8DfwXojUHTgDqEjQvqzTZcRnNLdIBYoOHPJwuG1dmdiBNFXNZ47pQDHfJiUTIFwvmE7HE
        HcyAfhBJk/QyU0Lnp
X-Received: by 2002:a1c:bc08:: with SMTP id m8mr12169211wmf.137.1605457722702;
        Sun, 15 Nov 2020 08:28:42 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz5IJ2EzZ3sasWPbAQUqFuWTTG1lb8K+1luXkOg0L2iHUvuRSatq/UNqDfeqSF/u3b86BstjQ==
X-Received: by 2002:a1c:bc08:: with SMTP id m8mr12169204wmf.137.1605457722483;
        Sun, 15 Nov 2020 08:28:42 -0800 (PST)
Received: from linux.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id t5sm16708086wmg.19.2020.11.15.08.28.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2020 08:28:41 -0800 (PST)
Date:   Sun, 15 Nov 2020 17:28:38 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Tom Parkin <tparkin@katalix.com>
Cc:     netdev@vger.kernel.org, jchapman@katalix.com
Subject: Re: [RFC PATCH 1/2] ppp: add PPPIOCBRIDGECHAN ioctl
Message-ID: <20201115162838.GF11274@linux.home>
References: <20201106181647.16358-1-tparkin@katalix.com>
 <20201106181647.16358-2-tparkin@katalix.com>
 <20201109232401.GM2366@linux.home>
 <20201110120429.GB5635@katalix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201110120429.GB5635@katalix.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 10, 2020 at 12:04:29PM +0000, Tom Parkin wrote:
> On  Tue, Nov 10, 2020 at 00:24:01 +0100, Guillaume Nault wrote:
> > On Fri, Nov 06, 2020 at 06:16:46PM +0000, Tom Parkin wrote:
> > > +				err = 0;
> > > +			}
> > > +			spin_unlock_bh(&pn->all_channels_lock);
> > > +			break;
> > >  		default:
> > >  			down_read(&pch->chan_sem);
> > >  			chan = pch->chan;
> > > @@ -2100,6 +2120,12 @@ ppp_input(struct ppp_channel *chan, struct sk_buff *skb)
> > >  		return;
> > >  	}
> > >  
> > > +	if (pch->bridge) {
> > > +		skb_queue_tail(&pch->bridge->file.xq, skb);
> > 
> > The bridged channel might reside in a different network namespace.
> > So it seems that skb_scrub_packet() is needed before sending the
> > packet.
> 
> I'm not sure about this.
> 
> PPPIOCBRIDGECHAN is looking up the bridged channel in the ppp_pernet
> list.  Unless the channel can migrate across network namespaces after
> the bridge is set up I don't think it would be possible for the
> bridged channel to be in a different namespace.
> 
> Am I missing something here?

So yes, channels can't migrate across namespaces. However, the bridged
channel is looked up from the caller's current namespace, which isn't
guaranteed to be the same namespace as the channel used in the ioctl().

For example:

setns(ns1, CLONE_NEWNET);
chan_ns1 = open("/dev/ppp");
...
setns(ns2, CLONE_NEWNET);
chan_ns2 = open("/dev/ppp");
...
ioctl(chan_ns1, PPPIOCBRIDGECHAN, chan_ns2_id);

Here, chan_ns1 belongs to ns1, but chan_ns2_id will be looked up in the
context of ns2. I find it nice to have the possibility to bridge
channels from different namespaces, but we have to handle the case
correctly.

> > > +		ppp_channel_push(pch->bridge);
> > 
> > I'm not sure if the skb_queue_tail()/ppp_channel_push() sequence really
> > is necessary. We're not going through a PPP unit, so we have no risk of
> > recursion here. Also, if ->start_xmit() fails, I see no reason for
> > requeuing the skb, like __ppp_channel_push() does. I'd have to think
> > more about it, but I believe that we could call the channel's
> > ->start_xmit() function directly (respecting the locking constraints
> > of course).
> 
> I take your point about re-queuing based on the return of
> ->start_xmit().  For pppoe and pppol2tp start_xmit just swallows the
> skb on failure in any case, so for this specific usecase queuing is
> not an issue.

Indeed.

> However, my primary motivation for using ppp_channel_push was actually
> the handling for managing dropping the packet if the channel was
> deregistered.

I might be missing something, but I don't see what ppp_channel_push()
does appart from holding the xmit lock and handling the xmit queue.
If we agree that there's no need to use the xmit queue, all
ppp_channel_push() does for us is taking pch->downl, which we probably
can do on our own.

> It'd be simple enough to add another function which performed the same
> deregistration check but didn't transmit via. the queue.

That's probably what I'm missing: what do you mean by "deregistration
check"? I can't see anything like this in ppp_channel_push().

