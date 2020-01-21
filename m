Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 120B3144240
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 17:35:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728852AbgAUQfo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 11:35:44 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:29055 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726714AbgAUQfo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 11:35:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579624543;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4ZtA6wV6ZYeIaJtcu+fv8OOyrPgzQolZBO5iyc9hpPM=;
        b=Whf5rwenhFAQeM94ZjnnJKh4zohXVQnXGcv4wXXsJAwYRQF9olJcgTCUjoYLGzeVL8H07c
        ZVBw3HqWJrThJCjbUnHvuIHXR6nstCRnOjV8LhNLZTCfQxWhME4KRWhDkvk/XfgbvKiO3E
        CuXORQDS5fT5r3lrPTnYxoddFiBphpo=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-417-lwyFiJaoPoqVQnaLIDS60w-1; Tue, 21 Jan 2020 11:35:41 -0500
X-MC-Unique: lwyFiJaoPoqVQnaLIDS60w-1
Received: by mail-wr1-f71.google.com with SMTP id o6so1570914wrp.8
        for <netdev@vger.kernel.org>; Tue, 21 Jan 2020 08:35:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4ZtA6wV6ZYeIaJtcu+fv8OOyrPgzQolZBO5iyc9hpPM=;
        b=erMPB/UwducXcYY9AAt6W4jQwGjrzh2u2s1YZUDubn1ttbStB7JJcs1ysqaxKMdWa3
         yGlECb6Is27wI9t8LgSAFRYtGBn44hPeQ3UaJoYC9kiahfroNGoXoASimywuCq/Guqlu
         y4b8RACibGm14ke6kLMEkIk+2n0a70H5Ow+A8t//8bWN0Z5O7kiuiOD8tMNoXFMcDBaa
         ZlIfFyiXv0YyHMCARUR82rzEj3+ZkoDmS8YhqU2UwWKnyr2ysoYPwlntwwIcq/w00Alk
         ND2nFcmPzSoxk0HIc964pVZNlqpLHMTX0XmHtcojYzeIkhnYLIa6h2WVEcVdNtkvWWc2
         wUMg==
X-Gm-Message-State: APjAAAWIXroKw6MMBPyRrPwNKektXP4mFDgDAReisLZZi1eWO4oFNM+k
        fN5iYTPZTN9pmd2qh6DJEzDuAQRBFQTk1FR0V7BXr9EW+7nYtz2hLPBGyzKxWWA85e/OsR2FY5F
        yjqjcjT+0d1SOEL+Q
X-Received: by 2002:a7b:c775:: with SMTP id x21mr5114767wmk.59.1579624540029;
        Tue, 21 Jan 2020 08:35:40 -0800 (PST)
X-Google-Smtp-Source: APXvYqwDGAc/6OuFYGCe6s7rGc5skNciZjsJc36UjxxeY9ndAWlPqNeh7VDWDgyVARYvwxiDSiFjag==
X-Received: by 2002:a7b:c775:: with SMTP id x21mr5114749wmk.59.1579624539805;
        Tue, 21 Jan 2020 08:35:39 -0800 (PST)
Received: from localhost.localdomain (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id t190sm4617212wmt.44.2020.01.21.08.35.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jan 2020 08:35:39 -0800 (PST)
Date:   Tue, 21 Jan 2020 17:35:31 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Tom Parkin <tparkin@katalix.com>
Cc:     Ridge Kennedy <ridgek@alliedtelesis.co.nz>, netdev@vger.kernel.org
Subject: Re: [PATCH net] l2tp: Allow duplicate session creation with UDP
Message-ID: <20200121163531.GA6469@localhost.localdomain>
References: <20200116123854.GA23974@linux.home>
 <20200116131223.GB4028@jackdaw>
 <20200116190556.GA25654@linux.home>
 <20200116212332.GD4028@jackdaw>
 <alpine.DEB.2.21.2001171027090.9038@ridgek-dl.ws.atlnz.lc>
 <20200117131848.GA3405@jackdaw>
 <20200117142558.GB2743@linux.home>
 <20200117191939.GB3405@jackdaw>
 <20200118191336.GC12036@linux.home>
 <20200120150946.GB4142@jackdaw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200120150946.GB4142@jackdaw>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 20, 2020 at 03:09:46PM +0000, Tom Parkin wrote:
> On  Sat, Jan 18, 2020 at 20:13:36 +0100, Guillaume Nault wrote:
> > I've never seen that as a problem in practice since establishing more
> > than one tunnel between two LCCE or LAC/LNS doesn't bring any
> > advantage.
> 
> I think the practical use depends a bit on context -- it might be
> useful to e.g. segregate sessions with different QoS or security
> requirements into different tunnels in order to make userspace
> configuration management easier.
> 
That could be useful for L2TPv2. But that's not going to be more
limitted for L2TPv3 as the tunnel ID isn't visible on the wire.

> > > Since we don't want to arbitrarily limit IP-encap tunnels to on per
> > > pair of peers, it's not practical to stash tunnel context with the
> > > socket in the IP-encap data path.
> > > 
> > Even though l2tp_ip doesn't lookup the session in the context of the
> > socket, it is limitted to one tunnel for a pair of peers, because it
> > doesn't support SO_REUSEADDR and SO_REUSEPORT.
> 
> This isn't the case.  It is indeed possible to create multiple IP-encap
> tunnels between the same IP addresses.
> 
> l2tp_ip takes tunnel ID into account in struct sockaddr_l2tpip when
> binding and connecting sockets.
> 
Yes, sorry. I didn't give this enough thinking and mixed the UDP and IP
transport constraints.

> I think if l2tp_ip were to support SO_REUSEADDR, it would be in the
> context of struct sockaddr_l2tpip.  In which case reusing the address
> wouldn't really make any sense.
> 
Yes, I think we can just forget about it.

> > Thinking more about the original issue, I think we could restrict the
> > scope of session IDs to the 3-tuple (for IP encap) or 5-tuple (for UDP
> > encap) of its parent tunnel. We could do that by adding the IP addresses,
> > protocol and ports to the hash key in the netns session hash-table.
> > This way:
> >  * Sessions would be only accessible from the peer with whom we
> >    established the tunnel.
> >  * We could use multiple sockets bound and connected to the same
> >    address pair, and lookup the right session no matter on which
> >    socket L2TP messages are received.
> >  * We would solve Ridge's problem because we could reuse session IDs
> >    as long as the 3 or 5-tuple of the parent tunnel is different.
> > 
> > That would be something for net-next though. For -net, we could get
> > something like Ridge's patch, which is simpler, since we've never
> > supported multiple tunnels per session anyway.
> 
> Yes, I think this would be possible.  I've been thinking of similar
> schemes.
> 
> I'm struggling with it a bit though.  Wouldn't extending the hash key
> like this get expensive, especially for IPv6 addresses?
> 
From what I recall, L2TP performances are already quite low. That's
certainly not a reason for making things worse, but I believe that
computing a 3 or 5 tuple hash should be low overhead in comparison.
But checking with real numbers would be interesting.

