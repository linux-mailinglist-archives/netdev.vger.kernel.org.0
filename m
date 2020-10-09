Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10933288360
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 09:21:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731868AbgJIHV4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 03:21:56 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:49999 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725908AbgJIHVz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 03:21:55 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 4C6zz55S6Dz1r6nY;
        Fri,  9 Oct 2020 09:21:47 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 4C6zyz0T4Fz1qrgj;
        Fri,  9 Oct 2020 09:21:47 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id bRFHjs4xAlou; Fri,  9 Oct 2020 09:21:45 +0200 (CEST)
X-Auth-Info: ShYu8ckela9vfHKCt95Sw20bAy5JpfhzdwpnNNxEm9s=
Received: from [IPv6:::1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Fri,  9 Oct 2020 09:21:45 +0200 (CEST)
Subject: Re: [PATCH][RESEND] net: fec: Fix PHY init after
 phy_reset_after_clk_enable()
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Richard Leitner <richard.leitner@skidata.com>,
        Christoph Niedermaier <cniedermaier@dh-electronics.com>,
        "David S . Miller" <davem@davemloft.net>,
        NXP Linux Team <linux-imx@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>
References: <20201006135253.97395-1-marex@denx.de>
 <20201008175124.08f3fe5e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Marek Vasut <marex@denx.de>
Message-ID: <6b600a23-cdf9-827f-2ff8-501ed0f1bdb1@denx.de>
Date:   Fri, 9 Oct 2020 09:21:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201008175124.08f3fe5e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/9/20 2:51 AM, Jakub Kicinski wrote:
> On Tue,  6 Oct 2020 15:52:53 +0200 Marek Vasut wrote:
>> The phy_reset_after_clk_enable() does a PHY reset, which means the PHY
>> loses its register settings. The fec_enet_mii_probe() starts the PHY
>> and does the necessary calls to configure the PHY via PHY framework,
>> and loads the correct register settings into the PHY. Therefore,
>> fec_enet_mii_probe() should be called only after the PHY has been
>> reset, not before as it is now.
>>
>> Fixes: 1b0a83ac04e3 ("net: fec: add phy_reset_after_clk_enable() support")
>> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
>> Tested-by: Richard Leitner <richard.leitner@skidata.com>
>> Signed-off-by: Marek Vasut <marex@denx.de>
> 
> Is moving the reset before fec_enet_mii_probe() the reason you need the
> second patch?
> 
>   net: fec: Fix phy_device lookup for phy_reset_after_clk_enable()

No, the second patch addresses separate issue.
