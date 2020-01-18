Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A88CC1418D0
	for <lists+netdev@lfdr.de>; Sat, 18 Jan 2020 18:53:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726809AbgARRwc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jan 2020 12:52:32 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:31229 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726413AbgARRwb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jan 2020 12:52:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579369950;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UV2dQPwyKCiU4heLms9GLy1/Ia8WRqFfFIS0In8hQGk=;
        b=PWbLk6wHffZs5dbA3UArjNXHRJn8N2FYvEY+3COT2cpvVvtbdDuIFlhrFA/YBBOpjsugR0
        5VhXr7i+EMC4q+aicQlLMFL6ja30aT95YEfL+vad7Wf3cwP1nQsPCdyuA3bXm/6nON8QDa
        s5v84qFZtTBUJlVjJ6Qdj9b2ZRGkpe0=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-192-_yORxyWjPHqf48t0U6TiXQ-1; Sat, 18 Jan 2020 12:52:29 -0500
X-MC-Unique: _yORxyWjPHqf48t0U6TiXQ-1
Received: by mail-wr1-f72.google.com with SMTP id y7so12006963wrm.3
        for <netdev@vger.kernel.org>; Sat, 18 Jan 2020 09:52:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UV2dQPwyKCiU4heLms9GLy1/Ia8WRqFfFIS0In8hQGk=;
        b=nnR/vOVm3N2B64YuT5sWGLtpqi+02+LJWbHxLqMHjamQEM3QgmEBLKHykD+hZqn+zw
         D8MTwaczY85YV4mNJ1SOthSqfswWT6rJtSRyqEUlg511S3yKoobKdVSj887k7ORvr68T
         C+zwkg3QU12apEI3EhbP89ml9Gp/g0s5s6GafJYiHbXOf2MNh/DD5lbzNr8Hvrex4G7H
         l9gkN5nGSW2EnO42050ck8tZg9KE1Qu/DvVstq3H3U2/WGaW42jP13p+avV7Wr9c3tGW
         K9K8jQzA9p8RxE6NWAUncfiI0+IEMvq1iuWzo9QzZoUmzLr5riZxDOBxnXyKxzdwWqa8
         avbQ==
X-Gm-Message-State: APjAAAW7rxxjX3VUIquWzMPnC4I8moCGgO5QxBXvmAeM7KvcGLuafpQO
        UYNbrHTz9jQi5hnBHtO3CgNU3hlpCSqbKbAAQ4A+7ijSf2EOFRKsHV/QC8buAC+hEoZDYkkxcem
        5fUQzHh7NF94EZg4Z
X-Received: by 2002:a05:6000:160d:: with SMTP id u13mr9122439wrb.22.1579369947754;
        Sat, 18 Jan 2020 09:52:27 -0800 (PST)
X-Google-Smtp-Source: APXvYqzNgzLDh6J9vtPZ1+113wsx7Q98pp8HBQlZoB7kar79EYOGuDCHd39b5OIbWtn/OPmBny0AAg==
X-Received: by 2002:a05:6000:160d:: with SMTP id u13mr9122415wrb.22.1579369947458;
        Sat, 18 Jan 2020 09:52:27 -0800 (PST)
Received: from linux.home (2a01cb058a4e7100d3814d1912515f67.ipv6.abo.wanadoo.fr. [2a01:cb05:8a4e:7100:d381:4d19:1251:5f67])
        by smtp.gmail.com with ESMTPSA id t8sm40051030wrp.69.2020.01.18.09.52.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Jan 2020 09:52:26 -0800 (PST)
Date:   Sat, 18 Jan 2020 18:52:24 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Tom Parkin <tparkin@katalix.com>
Cc:     Ridge Kennedy <ridge.kennedy@alliedtelesis.co.nz>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] l2tp: Allow duplicate session creation with UDP
Message-ID: <20200118175224.GB12036@linux.home>
References: <20200115223446.7420-1-ridge.kennedy@alliedtelesis.co.nz>
 <20200116123854.GA23974@linux.home>
 <20200116131223.GB4028@jackdaw>
 <20200116190556.GA25654@linux.home>
 <20200116212332.GD4028@jackdaw>
 <20200117163627.GC2743@linux.home>
 <20200117192912.GB19201@jackdaw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200117192912.GB19201@jackdaw>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 17, 2020 at 07:29:12PM +0000, Tom Parkin wrote:
> On  Fri, Jan 17, 2020 at 17:36:27 +0100, Guillaume Nault wrote:
> > On Thu, Jan 16, 2020 at 09:23:32PM +0000, Tom Parkin wrote:
> > > On  Thu, Jan 16, 2020 at 20:05:56 +0100, Guillaume Nault wrote:
> > > > What makes me uneasy is that, as soon as the l2tp_ip or l2tp_ip6 module
> > > > is loaded, a peer can reach whatever L2TPv3 session exists on the host
> > > > just by sending an L2TP_IP packet to it.
> > > > I don't know how practical it is to exploit this fact, but it looks
> > > > like it's asking for trouble.
> > > 
> > > Yes, I agree, although practically it's only a slightly easier
> > > "exploit" than L2TP/UDP offers.
> > > 
> > > The UDP case requires a rogue packet to be delivered to the correct
> > > socket AND have a session ID matching that of one in the associated
> > > tunnel.
> > > 
> > > It's a slightly more arduous scenario to engineer than the existing
> > > L2TPv3/IP case, but only a little.
> > > 
> > In the UDP case, we have a socket connected to the peer (or at least
> > bound to a local address). That is, some local setup is needed. With
> > l2tp_ip, we don't even need to have an open socket. Everything is
> > triggered remotely. And here, "remotely" means "any host on any IP
> > network the LCCE is connected", because the destination address can
> > be any address assigned to the LCCE, even if it's not configured to
> > handle any kind of L2TP. But well, after thinking more about our L2TPv3
> > discussiong, I guess that's how the designer's of the protocol wanted.
> 
> I note that RFC 3931 provides for a cookie in the data packet header
> to mitigate against data packet spoofing (section 8.2).
>
Indeed, I forgot about the L2TPv3 cookie.

> More generally I've not tried to see what could be done to spoof
> session data packets, so I can't really comment further.  It would be
> interesting to try spoofing packets and see if the kernel code could
> do more to limit any potential problems.
> 
> > > > > For normal operation, you just need to get the wrong packet on the
> > > > > wrong socket to run into trouble of course.  In such a situation
> > > > > having a unique session ID for v3 helps you to determine that
> > > > > something has gone wrong, which is what the UDP encap recv path does
> > > > > if the session data packet's session ID isn't found in the context of
> > > > > the socket that receives it.
> > > > Unique global session IDs might help troubleshooting, but they also
> > > > break some use cases, as reported by Ridge. At some point, we'll have
> > > > to make a choice, or even add a knob if necessary.
> > > 
> > > I suspect we need to reach agreement on what RFC 3931 implies before
> > > making headway on what the kernel should ideally do.
> > > 
> > > There is perhaps room for pragmatism given that the kernel
> > > used to be more permissive prior to dbdbc73b4478, and we weren't
> > > inundated with reports of session ID clashes.
> > > 
> > To summarise, my understanding is that global session IDs would follow
> > the spirit of RFC 3931 and would allow establishing multiple L2TPv3
> > connections (tunnels) over the same 5-tuple (or 3-tuple for IP encap).
> > Per socket session IDs don't, but would allow fixing Ridge's case.
> 
> I'm not 100% certain what "per socket session IDs" means here.  Could
> you clarify?
> 
By "per socket session IDs", I mean that the session IDs have to be
interpreted in the context of their parent tunnel socket (the current
l2tp_udp_recv_core() approach). That's opposed to "global session IDs"
which have netns-wide significance (the current l2tp_ip_recv()
approach).

