Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5F4017ED78
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 01:55:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727547AbgCJAzx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 20:55:53 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34310 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727380AbgCJAzw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 20:55:52 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 22F9B15A00CDC;
        Mon,  9 Mar 2020 17:55:52 -0700 (PDT)
Date:   Mon, 09 Mar 2020 17:55:51 -0700 (PDT)
Message-Id: <20200309.175551.444627983233718053.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     horatiu.vultur@microchip.com, alexandre.belloni@bootlin.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        joergen.andreasen@microchip.com, allan.nielsen@microchip.com,
        claudiu.manoil@nxp.com, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com, alexandru.marginean@nxp.com,
        xiaoliang.yang_1@nxp.com, yangbo.lu@nxp.com
Subject: Re: [PATCH net] net: mscc: ocelot: properly account for VLAN
 header length when setting MRU
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200309201608.14420-1-olteanv@gmail.com>
References: <20200309201608.14420-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 09 Mar 2020 17:55:52 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Mon,  9 Mar 2020 22:16:08 +0200

> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> What the driver writes into MAC_MAXLEN_CFG does not actually represent
> VLAN_ETH_FRAME_LEN but instead ETH_FRAME_LEN + ETH_FCS_LEN. Yes they are
> numerically equal, but the difference is important, as the switch treats
> VLAN-tagged traffic specially and knows to increase the maximum accepted
> frame size automatically. So it is always wrong to account for VLAN in
> the MAC_MAXLEN_CFG register.
> 
> Unconditionally increase the maximum allowed frame size for
> double-tagged traffic. Accounting for the additional length does not
> mean that the other VLAN membership checks aren't performed, so there's
> no harm done.
> 
> Also, stop abusing the MTU name for configuring the MRU. There is no
> support for configuring the MRU on an interface at the moment.
> 
> Fixes: a556c76adc05 ("net: mscc: Add initial Ocelot switch support")
> Fixes: fa914e9c4d94 ("net: mscc: ocelot: create a helper for changing the port MTU")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

This doesn't apply cleanly to the current net tree, please respin.

Thank you.
