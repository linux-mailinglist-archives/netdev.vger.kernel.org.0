Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 210A618D365
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 16:55:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727192AbgCTPzz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 11:55:55 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:51924 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726840AbgCTPzz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 11:55:55 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6039814C652BC;
        Fri, 20 Mar 2020 08:55:54 -0700 (PDT)
Date:   Fri, 20 Mar 2020 08:55:53 -0700 (PDT)
Message-Id: <20200320.085553.875593102765967647.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, linux@armlinux.org.uk
Subject: Re: [PATCH v3 net-next] net: dsa: sja1105: Add support for the
 SGMII port
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200320112937.27203-1-olteanv@gmail.com>
References: <20200320112937.27203-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 20 Mar 2020 08:55:54 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Fri, 20 Mar 2020 13:29:37 +0200

> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> SJA1105 switches R and S have one SerDes port with an 802.3z
> quasi-compatible PCS, hardwired on port 4. The other ports are still
> MII/RMII/RGMII. The PCS performs rate adaptation to lower link speeds;
> the MAC on this port is hardwired at gigabit. Only full duplex is
> supported.
> 
> The SGMII port can be configured as part of the static config tables, as
> well as through a dedicated SPI address region for its pseudo-clause-22
> registers. However it looks like the static configuration is not
> able to change some out-of-reset values (like the value of MII_BMCR), so
> at the end of the day, having code for it is utterly pointless. We are
> just going to use the pseudo-C22 interface.
> 
> Because the PCS gets reset when the switch resets, we have to add even
> more restoration logic to sja1105_static_config_reload, otherwise the
> SGMII port breaks after operations such as enabling PTP timestamping
> which require a switch reset.
> 
> From PHYLINK perspective, the switch supports *only* SGMII (it doesn't
> support 1000Base-X). It also doesn't expose access to the raw config
> word for in-band AN in registers MII_ADV/MII_LPA.
> It is able to work in the following modes:
>  - Forced speed
>  - SGMII in-band AN slave (speed received from PHY)
>  - SGMII in-band AN master (acting as a PHY)
> 
> The latter mode is not supported by this patch. It is even unclear to me
> how that would be described. There is some code for it left in the
> patch, but 'an_master' is always passed as false.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Applied, thank you.
