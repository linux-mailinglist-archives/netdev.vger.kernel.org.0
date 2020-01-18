Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F38E71418A8
	for <lists+netdev@lfdr.de>; Sat, 18 Jan 2020 18:18:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726621AbgARRS4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jan 2020 12:18:56 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:30138 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726413AbgARRS4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jan 2020 12:18:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579367933;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JuPdqJ6EywkUbr5vbvc454wWuYbKVO2aXgAWkMsU6Fw=;
        b=iLMNb1R2ZWnudX7OLqttuWtwT6Qf/HpN5zZ/0mWNrKCygEgfTiQ8NG3TqZYp6x6yS7witf
        hUQrsMeIdDji+Ky+E9QgJALjQavtoanU/ldTYJC5EjQPbdOFIImh4NljlRUrNCbTjPuqTB
        5+Mv4OTJLj8PNSJFIFZLs4HFr3rJrA8=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-149-PUM4vwhzPymya0HfHyAUsw-1; Sat, 18 Jan 2020 12:18:50 -0500
X-MC-Unique: PUM4vwhzPymya0HfHyAUsw-1
Received: by mail-wm1-f71.google.com with SMTP id p5so1600270wmc.4
        for <netdev@vger.kernel.org>; Sat, 18 Jan 2020 09:18:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JuPdqJ6EywkUbr5vbvc454wWuYbKVO2aXgAWkMsU6Fw=;
        b=colNuc5rTOyQYoytVBz/Zf3wDnBsNki7bH3ove6Za+20u0POODab8JpkaZ0Br5e8sp
         dO8oP5bmfa6xW4mfcrpzrHgWWXrqCOx8xhxNI3uNIc2sz9G6ziG4S8ZbqM7FvcN0nFwi
         lafGZgh4870lfB4EF2hIuU+Xb7QygsweoENxEguGJ87Ddi98IVvAFmoZhylrHzvdH6Bj
         7ylkhDDTzSAd+9Jv8Tx8h/rckkiYQR2830I0L0TB+IR/WRUwsuGVrFqRDfsE0VcuYHMa
         lbC7Xl3d4SwaZDJn11UCNM3wRsYDFWBm/YpQsmOzDEEf+xuZTUztGDK7ptBsKlvAQ1QU
         bN0A==
X-Gm-Message-State: APjAAAVXvxzNcTxEQlas4rWgUkGEGI7fGxvSXSATlJ7CJrES61PBopXN
        ZUFlmRnPYQc7LB0DRkb91Ykc9lh6kj7wd9pYCs+DIT9jp5p4YFiTtdVH6tKZJ5qO6ZXwknSV7hk
        3vfO1krRx/LYVGH3C
X-Received: by 2002:a1c:20d6:: with SMTP id g205mr10859473wmg.38.1579367928992;
        Sat, 18 Jan 2020 09:18:48 -0800 (PST)
X-Google-Smtp-Source: APXvYqw6JiEgHKXSoBhVTdbH4eLZd6iZ5NfrTipvWBJMNHdw9YcgK69WerGZQRCoHStNrkwWOpClkw==
X-Received: by 2002:a1c:20d6:: with SMTP id g205mr10859461wmg.38.1579367928752;
        Sat, 18 Jan 2020 09:18:48 -0800 (PST)
Received: from linux.home (2a01cb058a4e7100d3814d1912515f67.ipv6.abo.wanadoo.fr. [2a01:cb05:8a4e:7100:d381:4d19:1251:5f67])
        by smtp.gmail.com with ESMTPSA id m7sm39697185wrr.40.2020.01.18.09.18.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Jan 2020 09:18:48 -0800 (PST)
Date:   Sat, 18 Jan 2020 18:18:45 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Tom Parkin <tparkin@katalix.com>
Cc:     Ridge Kennedy <ridge.kennedy@alliedtelesis.co.nz>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] l2tp: Allow duplicate session creation with UDP
Message-ID: <20200118171845.GA12036@linux.home>
References: <20200115223446.7420-1-ridge.kennedy@alliedtelesis.co.nz>
 <20200116123143.GA4028@jackdaw>
 <20200116192827.GB25654@linux.home>
 <20200116210501.GC4028@jackdaw>
 <20200117134327.GA2743@linux.home>
 <20200117185931.GA19201@jackdaw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200117185931.GA19201@jackdaw>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 17, 2020 at 06:59:31PM +0000, Tom Parkin wrote:
> On  Fri, Jan 17, 2020 at 14:43:27 +0100, Guillaume Nault wrote:
> > On Thu, Jan 16, 2020 at 09:05:01PM +0000, Tom Parkin wrote:
> > > On  Thu, Jan 16, 2020 at 20:28:27 +0100, Guillaume Nault wrote:
> > > > How is UDP-encap broken with duplicate session IDs (as long as a UDP
> > > > socket can only one have one tunnel associated with it and that no
> > > > duplicate session IDs are allowed inside the same tunnel)?
> > > > 
> > > > It all boils down to what's the scope of a session ID. For me it has
> > > > always been the parent tunnel. But if that's in contradiction with
> > > > RFC 3931, I'd be happy to know.
> > > 
> > > For RFC 2661 the session ID is scoped to the tunnel.  Section 3.1
> > > says:
> > > 
> > >   "Session ID indicates the identifier for a session within a tunnel."
> > > 
> > > Control and data packets share the same header which includes both the
> > > tunnel and session ID with 16 bits allocated to each.  So it's always
> > > possible to tell from the data packet header which tunnel the session is
> > > associated with.
> > > 
> > > RFC 3931 changed the scheme.  Control packets now include a 32-bit
> > > "Control Connection ID" (analogous to the Tunnel ID).  Data packets
> > > have a session header specific to the packet-switching network in use:
> > > the RFC describes schemes for both IP and UDP, both of which employ a
> > > 32-bit session ID.  Section 4.1 says:
> > > 
> > >   "The Session ID alone provides the necessary context for all further
> > >   packet processing"
> > > 
> > > Since neither UDP nor IP encapsulated data packets include the control
> > > connection ID, the session ID must be unique to the LCCE to allow
> > > identification of the session.
> > 
> > Well my understanding was that the tunnel was implicitely given by the
> > UDP and IP headers. I don't think that multiplexing tunnels over the
> > same UDP connection made any sense with L2TPv2, and the kernel never
> > supported it natively (it might be possible with SO_REUSEPORT). Given
> > that the tunnel ID field was redundant with the lower headers, it made
> > sense to me that L2TPv3 dropped it (note that the kernel ignores the
> > L2TPv2 tunnel ID field on Rx). At least that was my understanding.
> > 
> > But as your quote says, the session ID _alone_ should provide all the
> > L2TP context. So I guess the spirit of the RFC is that there's a single
> > global namespace for session IDs. Now, practically speaking, I don't
> > see how scoped session IDs makes us incompatible, unless we consider
> > that a given session can be shared between several remote hosts (the
> > cross-talk case in my other email). Also, sharing a session over
> > several hosts would mean that L2TPv3 sessions aren't point-to-point,
> > which the control plane doesn't seem to take into account.
> 
> I think from your other emails in this thread that we're maybe in
> agreement already.
> 
> But just in case, I wanted to clarify that the session ID namespace
> is for a given LCCE (LAC or LNS in L2TPv2 parlance) per RFC 3931
> section 4.1 -- it's not truly "global".
> 
I meant global to a given host (LCCE or LAC/LNS), which for Linux
actually means global to a network namespace. I probably should have
been more precise in my previous emails, but everytime I talked about
"global" session IDs, I meant "global to the network namespace", and
when I talked about "scoped" session IDs, I meant that the ID was only
valid in the context of the UDP or L2TP_IP socket.

