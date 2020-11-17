Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C33FF2B55B5
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 01:31:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731402AbgKQA2r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 19:28:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:46656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730202AbgKQA2q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 19:28:46 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 94E7F2465E;
        Tue, 17 Nov 2020 00:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605572926;
        bh=6yaImKJKzBRBADUskb41q+3HaRMkDUkwEqn+lqXHavg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=x1o9AuWesC2uZjJPilV7I9Pm7Alcm325vJ3rY/GxL1pBjzoen7daBt+KUGwMjzrkW
         qfp6Fwl9kl/oVIEctfU7RCnug3TVh7YDRsFi43ERyxFqxyq/UWvUIc/Xz6XEosD/D/
         ebTcW0+/l5CH0oIPMlyCRCDYVW80GCJFwh6FhAV4=
Date:   Mon, 16 Nov 2020 16:28:44 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org
Subject: Re: [PATCH v1 net-next] net: dsa: qca: ar9331: add ethtool stats
 support
Message-ID: <20201116162844.7b503b13@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201117001005.b7o7fytd2stawrm7@skbuf>
References: <20201115073533.1366-1-o.rempel@pengutronix.de>
        <20201116133453.270b8db5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201116222146.znetv5u2q2q2vk2j@skbuf>
        <20201116143544.036baf58@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201116230053.ddub7p6lvvszz7ic@skbuf>
        <20201116151347.591925ca@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201116232731.4utpige7fguzghsi@skbuf>
        <7cb26c4f-0c5d-0e08-5bbe-676f5d66a858@gmail.com>
        <20201116160213.3de5280c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201117001005.b7o7fytd2stawrm7@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 Nov 2020 02:10:05 +0200 Vladimir Oltean wrote:
> On Mon, Nov 16, 2020 at 04:02:13PM -0800, Jakub Kicinski wrote:
> > For a while now we have been pushing back on stats which have a proper
> > interface to be added to ethtool -S. So I'd expect the list of stats
> > exposed via ethtool will end up being shorter than in this patch.  
> 
> Hmm, not sure if that's ever going to be the case. Even with drivers
> that are going to expose standardized forms of counters, I'm not sure
> it's going to be nice to remove them from ethtool -S.

Not remove, but also not accept adding them to new drivers.

> Testing teams all
> over the world have scripts that grep for those. Unfortunately I think
> ethtool -S will always remain a dumping ground of hell, and the place
> where you search for a counter based on its name from the hardware block
> guide as opposed to its standardized name/function. And that might mean
> there's no reason to not accept Oleksij's patch right away. Even if he
> might volunteer to actually follow up with a patch where he exposes the
> .ndo_get_stats64 from DSA towards drivers, as well as implements
> .ndo_has_offload_stats and .ndo_get_offload_stats within DSA, that will
> most likely be done as separate patches to this one, and not change in
> any way how this patch looks.

