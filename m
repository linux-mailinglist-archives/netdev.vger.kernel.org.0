Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FC403A4B32
	for <lists+netdev@lfdr.de>; Sat, 12 Jun 2021 01:27:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230410AbhFKX3v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 19:29:51 -0400
Received: from mail-pl1-f169.google.com ([209.85.214.169]:34570 "EHLO
        mail-pl1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230130AbhFKX3u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 19:29:50 -0400
Received: by mail-pl1-f169.google.com with SMTP id h1so3598873plt.1;
        Fri, 11 Jun 2021 16:27:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xmvWhepk7+DTWIJD3sxkKjlDCnRliUseIcDMgkGbSgQ=;
        b=HJZDKWsJ9+eYY2vRW8WzQe2ODlyiRphnZ4rrdHi0akPJaH6NhuJEvdgoCX29IAkNqu
         fuXe1AAEIJpXDabP9OTJUngfY3d12oR3HzWrMSxCGme0fj25de2YOpguoKM7sBjxggP9
         r/dkorJkGnZ7RBErpopXnEuFh07d2bwTA6iwJZFP0uXWGcwOciVU4G8mElov7LPLxEAt
         ZXpejrl4jd6Lp+a4gM2GjE8/mcIaOnSSUwrGvgM9Rg7G6Q3khj6fC7KOEG1RsTHCIFHP
         YV5nQmrz6hy+hLbfSzbga/bioQ98yUyX27iWuWtW2I736s/FIzXITiEOJcWqViTukx7Y
         HwnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xmvWhepk7+DTWIJD3sxkKjlDCnRliUseIcDMgkGbSgQ=;
        b=uThJd7E+aQrJClaLoWnKqA11NWPpAsCcoXoaaHSPGx/Ys8so1pdMbW4TNERsjqZBcg
         1QAqeq+hKFxsGWIxh+ZPZharR4e9JiiofAdCSfVe0f/3nL2x/yWX4+0kc+t8CIYzT9hn
         xsQxWX1FPuXWmLZPps6nfdB6iQNfP8wvzXrKD6esvook7wB1bJdNAixcX5u6cVu2BCGv
         i1IvlEdCnuPRjHQeJ7y65r8jKpp9HGG0k1uiMzGskZ8CZBtcCzw9Uz72TutogdRd8LR9
         6ry6MRVuaGPLXfzLfnwHrZvsvkTepGj5M7NW4TsMSwNYIGecG8w4weLwhpQzFyNWqdVW
         c5YQ==
X-Gm-Message-State: AOAM531EmZECk1cSZrMsIgu2JdBVvHLkNyVp53hy3MZC7wIsVOOlV+C6
        2znyZnt5WSrjo6PNJyRCwy0=
X-Google-Smtp-Source: ABdhPJxKVJcXQx4+NSa6O4GnyDEzzhXVMpjUDTiEdzxznFgKLJ3hYQukWRkk4KZ+0ilHM0n+yZNGWg==
X-Received: by 2002:a17:902:c403:b029:106:7793:3fcc with SMTP id k3-20020a170902c403b029010677933fccmr6048181plk.81.1623453995890;
        Fri, 11 Jun 2021 16:26:35 -0700 (PDT)
Received: from [192.168.1.67] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id g29sm5978314pgm.11.2021.06.11.16.26.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Jun 2021 16:26:35 -0700 (PDT)
Subject: Re: [PATCH net-next v4 8/9] net: dsa: dsa_slave_phy_connect(): extend
 phy's flags with port specific phy flags
To:     Vladimir Oltean <olteanv@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, kernel@pengutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>
References: <20210611071527.9333-1-o.rempel@pengutronix.de>
 <20210611071527.9333-9-o.rempel@pengutronix.de>
 <20210611192417.gvfxi2kbfjx4jv3d@skbuf>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <97ea2ff1-d3a3-b2d5-f829-3863409bfecc@gmail.com>
Date:   Fri, 11 Jun 2021 16:26:33 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210611192417.gvfxi2kbfjx4jv3d@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/11/2021 12:24 PM, Vladimir Oltean wrote:
> On Fri, Jun 11, 2021 at 09:15:26AM +0200, Oleksij Rempel wrote:
>> This patch extends the flags of the phy that's being connected with the
>> port specific flags of the switch port.
>>
>> This is needed to handle a port specific erratum of the KSZ8873 switch,
>> which is added in a later patch.
>>
>> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
>> ---
> 
> What happens differently between having this patch and not having it?

The current get_phy_flags() is only processed when we connect to a PHY
via a designed phy-handle property via phylink_of_phy_connect((, but if
we fallback on the internal MDIO bus created by a switch and take the
dsa_slave_phy_connect() path then we would not be processing that flag
and using it at PHY connection time. Oleksij, your proposed patch fails
to check that dsa_switch_ops::get_phy_flags is actually non-NULL, how
about this approach instead where we only fetch the flags once, and we
deal with an option get_phy_flags callback too:

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index d4756b920108..ba7866ec946f 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1749,7 +1749,7 @@ static void dsa_slave_phylink_fixed_state(struct
phylink_config *config,
 }

 /* slave device setup
*******************************************************/
-static int dsa_slave_phy_connect(struct net_device *slave_dev, int addr)
+static int dsa_slave_phy_connect(struct net_device *slave_dev, int
addr, u32 flags)
 {
        struct dsa_port *dp = dsa_slave_to_port(slave_dev);
        struct dsa_switch *ds = dp->ds;
@@ -1760,6 +1760,8 @@ static int dsa_slave_phy_connect(struct net_device
*slave_dev, int addr)
                return -ENODEV;
        }

+       slave_dev->phydev->dev_flags |= flags;
+
        return phylink_connect_phy(dp->pl, slave_dev->phydev);
 }

@@ -1804,7 +1806,7 @@ static int dsa_slave_phy_setup(struct net_device
*slave_dev)
                /* We could not connect to a designated PHY or SFP, so
try to
                 * use the switch internal MDIO bus instead
                 */
-               ret = dsa_slave_phy_connect(slave_dev, dp->index);
+               ret = dsa_slave_phy_connect(slave_dev, dp->index,
phy_flags);
                if (ret) {
                        netdev_err(slave_dev,
                                   "failed to connect to port %d: %d\n",
-- 
Florian
