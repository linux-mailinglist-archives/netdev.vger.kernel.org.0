Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38B8E2B556B
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 00:56:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731214AbgKPX4I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 18:56:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:52610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728281AbgKPX4H (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 18:56:07 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1E2D20758;
        Mon, 16 Nov 2020 23:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605570967;
        bh=DOQpUMc6qBTxv+A3TJ1JObV5KNd1EpCukKk4oazz4B8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=i5Na4pD3/hzlEDCmxCu1bE0/Ur59/kLpQQapa+TW+FWlM57GlI7okvmt8eoTUkSl1
         WM7s6FMe0+JNj33cyZhMGXBX8zV8vo5CRGgntJ2o2rdD7RmZfhuPbdRJXQh6LBW4WX
         xN7Dy6bCtweapVpaFVqwmz7ljny31CcUJwWJEDC0=
Date:   Mon, 16 Nov 2020 15:56:05 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org
Subject: Re: [PATCH v1 net-next] net: dsa: qca: ar9331: add ethtool stats
 support
Message-ID: <20201116155605.1309c4eb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201116232731.4utpige7fguzghsi@skbuf>
References: <20201115073533.1366-1-o.rempel@pengutronix.de>
        <20201116133453.270b8db5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201116222146.znetv5u2q2q2vk2j@skbuf>
        <20201116143544.036baf58@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201116230053.ddub7p6lvvszz7ic@skbuf>
        <20201116151347.591925ca@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201116232731.4utpige7fguzghsi@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 Nov 2020 01:27:31 +0200 Vladimir Oltean wrote:
> > Note that I said _forwarded_. Frames are either forwarded by the HW or
> > SW (former never hit the CPU, while the latter do hit the CPU or
> > originate from it).  
> 
> Ah, you were just thinking out loud, I really did not understand what
> you meant by the separation between "forwarded in software" and
> "forwarded in hardware".
> Yes, the hardware typically only gives us MAC-level counters anyway.
> Another way to look at it is that the number of packets forwarded in
> hardware from a given port are equal to the total number of RX packets
> on that MAC minus the packets seen by the CPU coming from that port.
> So all in all, it's the MAC-level counters we should expose in
> .ndo_get_stats64, I'm glad you agree. As for the error packets, I
> suppose that would be a driver-specific aggregate.

Yup, sorry about the confusion, I was only working on those stats
with SDN/OvS/tc hardware, which explains the slight difference in
terminology.
