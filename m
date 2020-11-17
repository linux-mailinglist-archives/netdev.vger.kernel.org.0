Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A1A02B557A
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 01:02:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730945AbgKQACP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 19:02:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:56430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730322AbgKQACP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 19:02:15 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD6D02463F;
        Tue, 17 Nov 2020 00:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605571334;
        bh=XDEKzXHVHD1gwy3D3kVdGbY5bLC8iHPoeZJ1eT4YG/4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=boDjBxHXKKd0sX9VK8Ls2NQLZahOK1uVP+4WHpIYLuuGFmwX8GWq6G9wd5T346Zyb
         zZY52oEA4RcmeRxfQBsVD/FNe/mlrekLFQPCnbAdF9DPheJBONPjWOMt9Ysnj+KphV
         qBX5pTtTgSH8fql+jIS1IcdiOExuFO2bxox442tI=
Date:   Mon, 16 Nov 2020 16:02:13 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
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
Message-ID: <20201116160213.3de5280c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <7cb26c4f-0c5d-0e08-5bbe-676f5d66a858@gmail.com>
References: <20201115073533.1366-1-o.rempel@pengutronix.de>
        <20201116133453.270b8db5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201116222146.znetv5u2q2q2vk2j@skbuf>
        <20201116143544.036baf58@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201116230053.ddub7p6lvvszz7ic@skbuf>
        <20201116151347.591925ca@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201116232731.4utpige7fguzghsi@skbuf>
        <7cb26c4f-0c5d-0e08-5bbe-676f5d66a858@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 Nov 2020 15:30:39 -0800 Florian Fainelli wrote:
> > What about RMON/RFC2819 style etherStatsPkts65to127Octets? We have a
> > number of switches supporting that style of counters, including the one
> > that Oleksij is adding support for, apparently (but not all switches
> > though). I suppose your M.O. is that anything standardizable is welcome
> > to be standardized via rtnetlink?
> > 
> > Andrew, Florian, any opinions here?
> 
> Settling on RMON/RFC2819 statistics would work for me, and hopefully is
> not too hard to get the various drivers converted to.

That would be grate! For RMON stats you may have slightly more legwork
to do on ethtool side, since IIRC the plumbing for stats over netlink
is (intentionally?) not there until we settle on how to handle
standardize-able counters.

I've only done pause stats 'cause those and FEC are the primary HW
stats my employer cares about :) I'm sure people would actually find
use for the RMON stats once they get standardized tho!

> With respect to Oleksij's patch, I would tend to accept it so we
> actually have more visibility into what standardized counters are
> available across switch drivers.

For a while now we have been pushing back on stats which have a proper
interface to be added to ethtool -S. So I'd expect the list of stats
exposed via ethtool will end up being shorter than in this patch.
