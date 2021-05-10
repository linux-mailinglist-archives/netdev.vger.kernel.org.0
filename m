Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CE90377985
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 02:37:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbhEJAgw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 May 2021 20:36:52 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60174 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229853AbhEJAgw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 9 May 2021 20:36:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=nIgyEb0753Jj49OfzGu6lUc2D4FlTLsAUUZPZ5UjLz8=; b=O4zEKVlej2iAJx3h8LaAyq6COb
        YVCMRC7J2MeoQ9qYscXeAfRcjyD6KONlP2D14DtnFPvAHwi6sZViltIjsq1WMWcmOBUo23KIvWEbr
        okfVf5+8Pg66HZyviVt9ksgos3SCq8uIfGuH5nhmqFefy5uebmB/eXUiAnSAXTVXidEg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lftte-003R9G-G7; Mon, 10 May 2021 02:35:42 +0200
Date:   Mon, 10 May 2021 02:35:42 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH v2 net] net: dsa: fix error code getting shifted with 4
 in dsa_slave_get_sset_count
Message-ID: <YJh/3unc5rM6oKvH@lunn.ch>
References: <20210509193338.451174-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210509193338.451174-1-olteanv@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 09, 2021 at 10:33:38PM +0300, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> DSA implements a bunch of 'standardized' ethtool statistics counters,
> namely tx_packets, tx_bytes, rx_packets, rx_bytes. So whatever the
> hardware driver returns in .get_sset_count(), we need to add 4 to that.
> 
> That is ok, except that .get_sset_count() can return a negative error
> code, for example:
> 
> b53_get_sset_count
> -> phy_ethtool_get_sset_count
>    -> return -EIO
> 
> -EIO is -5, and with 4 added to it, it becomes -1, aka -EPERM. One can
> imagine that certain error codes may even become positive, although
> based on code inspection I did not see instances of that.
> 
> Check the error code first, if it is negative return it as-is.
> 
> Based on a similar patch for dsa_master_get_strings from Dan Carpenter:
> https://patchwork.kernel.org/project/netdevbpf/patch/YJaSe3RPgn7gKxZv@mwanda/
> 
> Fixes: 91da11f870f0 ("net: Distributed Switch Architecture protocol support")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
