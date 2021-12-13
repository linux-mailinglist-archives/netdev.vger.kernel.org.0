Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 551AD472C51
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 13:31:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231465AbhLMMbv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 07:31:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231733AbhLMMbv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 07:31:51 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEED1C061574
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 04:31:50 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id y12so50742757eda.12
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 04:31:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=W5R9sVR4aSo/6KZ7j1gRYqeTEqCjFd1ZLBePACqQooc=;
        b=aRa0hzTgeeHfFVCYU03GPiTaVDU8E5t/e0UDe7RqlxhuMVbtSDDedY7cUyOhnNfFr8
         GGCTJLUBBg3DUOwDVEfsFphn7ADKAr627mFKeKc1i8Yc1F4dNX8xeC0OUS5bkAMyNHsw
         CXmZQ2AQRYwZW/IXBJIYc3Uz/YFxidXUPL1t9kE6HMLnWYJa9EmcHxacrIgKJY17zhmE
         rRaqr3aNNbNmomOlw0/WbfASicZyX2JZ1xwkGamINysclCD6dtHa26+5csqwP2PC82MQ
         exbgkHsKcwSUmzZStT6K6gdTo6BgvsEev14vWa0G5tj75GMrXVAou2v81BGatsE1CX7d
         yKTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=W5R9sVR4aSo/6KZ7j1gRYqeTEqCjFd1ZLBePACqQooc=;
        b=XxZiuTtLTly64Zoh6Cxw3t3AqIqHsFoixfnq8KX44BVeErKhLjrnF4YjpOrqc06aZ+
         j4WQ36wmGDFd9IpULA89GwCyrMhFNnWIV1aEp8KexvgDm0wrIfD9JId1WMRbvoGW1mRQ
         yqHGCh0oAp494MrZ2pPq/hbF6ZnlGQQeXlYDcjAt+/Z3e+8F9lVedphTt51k4Vd0QHMx
         r2jpgmjWspgGqzwrN4qRur/QVkNe3waXeZzV6Jfp49Nn3zwFzY7IT3cjJGUF5tnXrOas
         vR7knqpZ+8vdRHIFvnFLcSrKX+PVgCk3s0zL8xEA6tEbXpGAP2omgLVYvndhIx07KPnt
         ua4w==
X-Gm-Message-State: AOAM530j0aOWrJjm26DLq4XcyPodW+mKlOmUK7uqAykXpIJnJ+iZUxZU
        Hz3GxoN4FbGEjTrab8+9YDU=
X-Google-Smtp-Source: ABdhPJxdcSz0B936ZwiA7QQMhiWU7eR4N4Vq50OyOvlBDPKCc3zTTXnFF37SER9rkomaY3BSkbqQSA==
X-Received: by 2002:a50:e102:: with SMTP id h2mr62571511edl.298.1639398709339;
        Mon, 13 Dec 2021 04:31:49 -0800 (PST)
Received: from skbuf ([188.25.173.50])
        by smtp.gmail.com with ESMTPSA id ds22sm15644ejc.186.2021.12.13.04.31.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Dec 2021 04:31:48 -0800 (PST)
Date:   Mon, 13 Dec 2021 14:31:47 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Kurt Kanzenbach <kurt@kmk-computers.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v1] net: dsa: mv88e6xxx: Trap PTP traffic
Message-ID: <20211213123147.2lc63aok6l5kg643@skbuf>
References: <20211209173337.24521-1-kurt@kmk-computers.de>
 <87y24t1fvk.fsf@waldekranz.com>
 <20211210211410.62cf1f01@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20211211153926.GA3357@hoboy.vegasvil.org>
 <20211213121045.GA14042@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211213121045.GA14042@hoboy.vegasvil.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Richard,

On Mon, Dec 13, 2021 at 04:10:45AM -0800, Richard Cochran wrote:
> On Sat, Dec 11, 2021 at 07:39:26AM -0800, Richard Cochran wrote:
> > On Fri, Dec 10, 2021 at 09:14:10PM -0800, Jakub Kicinski wrote:
> > > On Fri, 10 Dec 2021 01:07:59 +0100 Tobias Waldekranz wrote:
> > > > Do we know how PTP is supposed to work in relation to things like STP?
> > > > I.e should you be able to run PTP over a link that is currently in
> > > > blocking?
> > > 
> > > Not sure if I'm missing the real question but IIRC the standard
> > > calls out that PTP clock distribution tree can be different that
> > > the STP tree, ergo PTP ignores STP forwarding state.
> > 
> > That is correct.  The PTP will form its own spanning tree, and that
> > might be different than the STP.  In fact, the Layer2 PTP messages
> > have special MAC addresses that are supposed to be sent
> > unconditionally, even over blocked ports.
> 
> Let me correct that statement.
> 
> I looked at 1588 again, and for E2E TC it states, "All PTP version 2
> messages shall be forwarded according to the addressing rules of the
> network."  I suppose that includes the STP state.
> 
> For P2P TC, there is an exception that the peer delay messages are not
> forwarded.  These are generated and consumed by the switch.
> 
> The PTP spanning tree still is formed by the Boundary Clocks (BC), and
> a Transparent Clock (TC) does not participate in forming the PTP
> spanning tree.
> 
> What does this mean for Linux DSA switch drivers?
> 
> 1. All incoming PTP frames should be forwarded to the CPU port, so
>    that the software stack may perform its BC or TC functions.
> 
> 2. When used as a BC, the PTP frames sent from the CPU port should not
>    be dropped.
> 
> 3. When used as a TC, PTP frames sent from the CPU port can be dropped
>    on blocked external ports, except for the Peer Delay messages.
> 
> Now maybe a particular switch implementation makes it hard to form
> rules for #3 that still work for UDP over IPv4/6.

With other drivers, all packets injected from the CPU port act as if in
"god mode", bypassing any STP state. It then becomes the responsibility
of the software to not send packets on a port that is blocking,
except for packets for control protocols. Would you agree that ptp4l
should consider monitoring whether its ports are under a bridge, and
what STP state that bridge port is in? I think this isn't even specific
to DSA, the same thing would happen with software bridging: packets sent
through sockets opened on the bridge would have egress prevented on
blocking ports by virtue of the bridge driver code, but packets sent
through sockets opened on the bridge port directly, I don't think the
bridge driver has any saying about the STP state. So similarly, it
becomes the application's responsibility.
