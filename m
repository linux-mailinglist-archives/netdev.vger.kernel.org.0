Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C19C14190E
	for <lists+netdev@lfdr.de>; Sat, 18 Jan 2020 20:13:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbgARTNq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jan 2020 14:13:46 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:53791 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726658AbgARTNq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jan 2020 14:13:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579374823;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nhCNnHeJn/QbqN0LCcigo2/wvezOC/eKm2riNa42Rws=;
        b=FA7h1MrgzL4PSm+C0y1bqSljSrVXZJblpBD175Mi917SzAsmVM1sxUE2asRmBGvIJMq/EH
        nD3J1U+KRj1cUPn954p/uUdTQlYhizcteUrQu3j7mtbcqWQVCBRkfsGIRwPktjyrZ7QiWN
        IyxPC8xf9JS0HaEq9lXBLDXHY8GXImY=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-191-T3nmiKzgN6exD_eoZq5J6Q-1; Sat, 18 Jan 2020 14:13:41 -0500
X-MC-Unique: T3nmiKzgN6exD_eoZq5J6Q-1
Received: by mail-wr1-f69.google.com with SMTP id o6so11982771wrp.8
        for <netdev@vger.kernel.org>; Sat, 18 Jan 2020 11:13:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nhCNnHeJn/QbqN0LCcigo2/wvezOC/eKm2riNa42Rws=;
        b=YSkwYeL2pt/yKQ2TdqaaEUe3FGhMO2riAu3sC+BgKMic3dgN+MUS5NGTbk4ehqMn1u
         wK1k1wk98CD5pTe0aa2UVm7FlYdE8YHOrp2Bhv1kkKgrsvvuuL5js+YVf/f9DApxKsYo
         r2YRIamiMXGjFLLUdYGCGd/rU+GEijOvcLSfJ8bDgX/q5xJ6KXvLuifqaOnprGRi0vvW
         eXu8dQIg+cyke0SxP+5tBWvaC2FwtosRCdWd1GkGmWMgDQQmx2JzKtgVGvcVzdtoW3So
         YG5MjQtITRE4Vt5KI8TmlNEJaZs9yzct7rBgOgZX8Kty6x+XJXCJm2+MauYB4MLzHdOk
         ofKA==
X-Gm-Message-State: APjAAAUN5VQ7mo2IwXABl2NIhAo6qeJz9Bb/rcWhgtMdd72GMv88vWP5
        VF5xvTtq3EhTfEMrqaFKpDRkLqDDUESYSTrSxM7tsKdS6TzsJgi70THSUOV5pHveHgTrboVpLHY
        reuac6NzqUvyHAL7/
X-Received: by 2002:a05:600c:295a:: with SMTP id n26mr11050391wmd.187.1579374819965;
        Sat, 18 Jan 2020 11:13:39 -0800 (PST)
X-Google-Smtp-Source: APXvYqwKrT1lBon7Ez1Dqoham7mkpzCq/5PwT6DQv8KkHWl0UqYGnWwzDgN+j9ypV/Ih9AQv1mQkSw==
X-Received: by 2002:a05:600c:295a:: with SMTP id n26mr11050374wmd.187.1579374819694;
        Sat, 18 Jan 2020 11:13:39 -0800 (PST)
Received: from linux.home (2a01cb058a4e7100d3814d1912515f67.ipv6.abo.wanadoo.fr. [2a01:cb05:8a4e:7100:d381:4d19:1251:5f67])
        by smtp.gmail.com with ESMTPSA id v8sm38296027wrw.2.2020.01.18.11.13.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Jan 2020 11:13:39 -0800 (PST)
Date:   Sat, 18 Jan 2020 20:13:36 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Tom Parkin <tparkin@katalix.com>
Cc:     Ridge Kennedy <ridgek@alliedtelesis.co.nz>, netdev@vger.kernel.org
Subject: Re: [PATCH net] l2tp: Allow duplicate session creation with UDP
Message-ID: <20200118191336.GC12036@linux.home>
References: <20200115223446.7420-1-ridge.kennedy@alliedtelesis.co.nz>
 <20200116123854.GA23974@linux.home>
 <20200116131223.GB4028@jackdaw>
 <20200116190556.GA25654@linux.home>
 <20200116212332.GD4028@jackdaw>
 <alpine.DEB.2.21.2001171027090.9038@ridgek-dl.ws.atlnz.lc>
 <20200117131848.GA3405@jackdaw>
 <20200117142558.GB2743@linux.home>
 <20200117191939.GB3405@jackdaw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200117191939.GB3405@jackdaw>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 17, 2020 at 07:19:39PM +0000, Tom Parkin wrote:
> On  Fri, Jan 17, 2020 at 15:25:58 +0100, Guillaume Nault wrote:
> > On Fri, Jan 17, 2020 at 01:18:49PM +0000, Tom Parkin wrote:
> > > More generally, for v3 having the session ID be unique to the LCCE is
> > > required to make IP-encap work at all.  We can't reliably obtain the
> > > tunnel context from the socket because we've only got a 3-tuple
> > > address to direct an incoming frame to a given socket; and the L2TPv3
> > > IP-encap data packet header only contains the session ID, so that's
> > > literally all there is to work with.
> > > 
> > I don't see how that differs from the UDP case. We should still be able
> > to get the corresponding socket and lookup the session ID in that
> > context. Or did I miss something? Sure, that means that the socket is
> > the tunnel, but is there anything wrong with that?
> 
> It doesn't fundamentally differ from the UDP case.
> 
> The issue is that if you're stashing tunnel context with the socket
> (as UDP currently does), then you're relying on the kernel's ability
> to deliver packets for a given tunnel on that tunnel's socket.
> 
> In the UDP case this is normally easily done, assuming each UDP tunnel
> socket has a unique 5-tuple address.  So if peers allow the use of
> ports other than port 1701, it's normally not an issue.
> 
> However, if you do get a 5-tuple clash, then packets may start
> arriving on the "wrong" socket.  In general this is a corner case
> assuming peers allow ports other than 1701 to be used, and so we don't
> see it terribly often.
> 
> Contrast this with IP-encap.  Because we don't have ports, the 5-tuple
> address now becomes a 3-tuple address.  Suddenly it's quite easy to
> get a clash: two IP-encap tunnels between the same two peers would do
> it.
> 
Well, the situation is the same with UDP, when the peer always uses
source port 1701, which is a pretty common case as you noted
previously.
I've never seen that as a problem in practice since establishing more
than one tunnel between two LCCE or LAC/LNS doesn't bring any
advantage.

> Since we don't want to arbitrarily limit IP-encap tunnels to on per
> pair of peers, it's not practical to stash tunnel context with the
> socket in the IP-encap data path.
> 
Even though l2tp_ip doesn't lookup the session in the context of the
socket, it is limitted to one tunnel for a pair of peers, because it
doesn't support SO_REUSEADDR and SO_REUSEPORT.

> > > If we relax the restriction for UDP-encap then it fixes your (Ridge's)
> > > use case; but it does impose some restrictions:
> > > 
> > >  1. The l2tp subsystem has an existing bug for UDP encap where
> > >  SO_REUSEADDR is used, as I've mentioned.  Where the 5-tuple address of
> > >  two sockets clashes, frames may be directed to either socket.  So
> > >  determining the tunnel context from the socket isn't valid in this
> > >  situation.
> > > 
> > >  For L2TPv2 we could fix this by looking the tunnel context up using
> > >  the tunnel ID in the header.
> > > 
> > >  For L2TPv3 there is no tunnel ID in the header.  If we allow
> > >  duplicated session IDs for L2TPv3/UDP, there's no way to fix the
> > >  problem.
> > > 
> > >  This sounds like a bit of a corner case, although its surprising how
> > >  many implementations expect all traffic over port 1701, making
> > >  5-tuple clashes more likely.
> > > 
> > Hum, I think I understand your scenario better. I just wonder why one
> > would establish several tunnels over the same UDP or IP connection (and
> > I've also been surprised by all those implementations forcing 1701 as
> > source port).
> >
> 
> Indeed, it's not ideal :-(
> 
> > >  2. Part of the rationale for L2TPv3's approach to IDs is that it
> > >  allows the data plane to potentially be more efficient since a
> > >  session can be identified by session ID alone.
> > >  
> > >  The kernel hasn't really exploited that fact fully (UDP encap
> > >  still uses the socket to get the tunnel context), but if we make
> > >  this change we'll be restricting the optimisations we might make
> > >  in the future.
> > > 
> > > Ultimately it comes down to a judgement call.  Being unable to fix
> > > the SO_REUSEADDR bug would be the biggest practical headache I
> > > think.
> > And it would be good to have a consistent behaviour between IP and UDP
> > encapsulation. If one does a global session lookup, the other should
> > too.
> 
> That would also be my preference.
> 
Thinking more about the original issue, I think we could restrict the
scope of session IDs to the 3-tuple (for IP encap) or 5-tuple (for UDP
encap) of its parent tunnel. We could do that by adding the IP addresses,
protocol and ports to the hash key in the netns session hash-table.
This way:
 * Sessions would be only accessible from the peer with whom we
   established the tunnel.
 * We could use multiple sockets bound and connected to the same
   address pair, and lookup the right session no matter on which
   socket L2TP messages are received.
 * We would solve Ridge's problem because we could reuse session IDs
   as long as the 3 or 5-tuple of the parent tunnel is different.

That would be something for net-next though. For -net, we could get
something like Ridge's patch, which is simpler, since we've never
supported multiple tunnels per session anyway.

