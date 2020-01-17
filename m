Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11062140B49
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 14:45:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728977AbgAQNne (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 08:43:34 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:29455 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726970AbgAQNne (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jan 2020 08:43:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579268612;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mTb34bIVH9ntXAekope6u8a3J2IAdR9xFh/VSa4haYQ=;
        b=bT2Um09Vg2exNIWJZWa60i56WOIicZeUGZtO93kEHEVi+I7yQbqDQIoW5XYgrRRGETaePL
        CMjV9uStbYcGiqvAXOClCzewtYLLouM7LsT++jdLRBRO6fqCMnXH4WhZQkg028BsYY5hM4
        HNEIeWrtqE2ppRz910bNIc07QV0tG3M=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-263-34dMFG0rNOa-YvrE95dVIA-1; Fri, 17 Jan 2020 08:43:31 -0500
X-MC-Unique: 34dMFG0rNOa-YvrE95dVIA-1
Received: by mail-wr1-f71.google.com with SMTP id t3so10472944wrm.23
        for <netdev@vger.kernel.org>; Fri, 17 Jan 2020 05:43:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mTb34bIVH9ntXAekope6u8a3J2IAdR9xFh/VSa4haYQ=;
        b=m5CJoffv1aqJUv/89mQCknC3zWN9yp/DCa1d6eH10wKczjCiAONoGSqbYRwqyhFEb5
         ux5OoFaxjql7njvQ/gAyZf2bs9maxzc+kP2nUHHm0fOM/Hq1c4Md2PcjnHGpVrtmW/s9
         Z7i9qqq4uAwmLREUmfAeZTZc201mEBkkU33vsay79cMM/B+FBhoi7Mvviea7LTes777E
         Fi774O2DHSM5vU8v+EOeJPgHyb7N38WfgMaDzDt/3fc2tiBjkKqIcsPtstwXIXpcRDnj
         JIDR9docm0ojy0cPuDVg7/xW3QYH7FqvzZ/MSvb5XN71BvO3s8GszABK9QhEvVCyIHpE
         ig1w==
X-Gm-Message-State: APjAAAUhseBbu2nNeOe9S6XUFHXZiLErI7VVlGhtky1HgP6mlhaS1Uen
        ycp9VoncpouHzfQYHevDe8Ds10QcExPuc96BYsSCCtae368uXm8K3UCTCHywt+1+yhbXCDHBl1f
        PPANpEaKwb05Vb5G7
X-Received: by 2002:a1c:4e03:: with SMTP id g3mr4613643wmh.22.1579268609852;
        Fri, 17 Jan 2020 05:43:29 -0800 (PST)
X-Google-Smtp-Source: APXvYqxyvGw5GEhXz8GhythNW7SrNpiCEnWdjAguLYCeIMmhBsgeP8q6AL1vcN69AFULBuoQoNm6Ww==
X-Received: by 2002:a1c:4e03:: with SMTP id g3mr4613627wmh.22.1579268609613;
        Fri, 17 Jan 2020 05:43:29 -0800 (PST)
Received: from linux.home (2a01cb058a4e7100d3814d1912515f67.ipv6.abo.wanadoo.fr. [2a01:cb05:8a4e:7100:d381:4d19:1251:5f67])
        by smtp.gmail.com with ESMTPSA id e18sm33658501wrw.70.2020.01.17.05.43.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jan 2020 05:43:28 -0800 (PST)
Date:   Fri, 17 Jan 2020 14:43:27 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Tom Parkin <tparkin@katalix.com>
Cc:     Ridge Kennedy <ridge.kennedy@alliedtelesis.co.nz>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] l2tp: Allow duplicate session creation with UDP
Message-ID: <20200117134327.GA2743@linux.home>
References: <20200115223446.7420-1-ridge.kennedy@alliedtelesis.co.nz>
 <20200116123143.GA4028@jackdaw>
 <20200116192827.GB25654@linux.home>
 <20200116210501.GC4028@jackdaw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200116210501.GC4028@jackdaw>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 16, 2020 at 09:05:01PM +0000, Tom Parkin wrote:
> On  Thu, Jan 16, 2020 at 20:28:27 +0100, Guillaume Nault wrote:
> > On Thu, Jan 16, 2020 at 12:31:43PM +0000, Tom Parkin wrote:
> > > However, there's nothing to prevent user space from using the same UDP
> > > port for multiple tunnels, at which point this relaxation of the RFC
> > > rules would break down again.
> > > 
> > Multiplexing L2TP tunnels on top of non-connected UDP sockets might be
> > a nice optimisation for someone using many tunnels (like hundred of
> > thouthands), but I'm afraid the rest of the L2TP code is not ready to
> > handle such load anyway. And the current implementation only allows
> > one tunnel for each UDP socket anyway.
> 
> TBH I was thinking more of the case where multiple sockets are bound and
> connected to the same address/port (SO_REUSEADDR).  There's still a
> 1:1 mapping of tunnel:socket, but it's possible to have packets for tunnel
> A arrive on tunnel B's socket and vice versa.
> 
> It's a bit of a corner case, I grant you.
> 
Creating several sockets to handle the same tunnel (as identified by
its 5-tuple) may be doable with SO_REUSEPORT, with an ebpf program to
direct the packet to the right socket depending on the session ID. The
session ID would be local to the so_reuseport group. So I guess that
even this kind of setup can be achieved with non-global session IDs (I
haven't tried though, so I might have missed something).

> > > Since UDP-encap can also be broken in the face of duplicated L2TPv3
> > > session IDs, I think its better that the kernel continue to enforce
> > > the RFC.
> > How is UDP-encap broken with duplicate session IDs (as long as a UDP
> > socket can only one have one tunnel associated with it and that no
> > duplicate session IDs are allowed inside the same tunnel)?
> > 
> > It all boils down to what's the scope of a session ID. For me it has
> > always been the parent tunnel. But if that's in contradiction with
> > RFC 3931, I'd be happy to know.
> 
> For RFC 2661 the session ID is scoped to the tunnel.  Section 3.1
> says:
> 
>   "Session ID indicates the identifier for a session within a tunnel."
> 
> Control and data packets share the same header which includes both the
> tunnel and session ID with 16 bits allocated to each.  So it's always
> possible to tell from the data packet header which tunnel the session is
> associated with.
> 
> RFC 3931 changed the scheme.  Control packets now include a 32-bit
> "Control Connection ID" (analogous to the Tunnel ID).  Data packets
> have a session header specific to the packet-switching network in use:
> the RFC describes schemes for both IP and UDP, both of which employ a
> 32-bit session ID.  Section 4.1 says:
> 
>   "The Session ID alone provides the necessary context for all further
>   packet processing"
> 
> Since neither UDP nor IP encapsulated data packets include the control
> connection ID, the session ID must be unique to the LCCE to allow
> identification of the session.

Well my understanding was that the tunnel was implicitely given by the
UDP and IP headers. I don't think that multiplexing tunnels over the
same UDP connection made any sense with L2TPv2, and the kernel never
supported it natively (it might be possible with SO_REUSEPORT). Given
that the tunnel ID field was redundant with the lower headers, it made
sense to me that L2TPv3 dropped it (note that the kernel ignores the
L2TPv2 tunnel ID field on Rx). At least that was my understanding.

But as your quote says, the session ID _alone_ should provide all the
L2TP context. So I guess the spirit of the RFC is that there's a single
global namespace for session IDs. Now, practically speaking, I don't
see how scoped session IDs makes us incompatible, unless we consider
that a given session can be shared between several remote hosts (the
cross-talk case in my other email). Also, sharing a session over
several hosts would mean that L2TPv3 sessions aren't point-to-point,
which the control plane doesn't seem to take into account.

