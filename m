Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3368154D4A
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 13:10:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730374AbfFYLKV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 07:10:21 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:19234 "EHLO
        hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727746AbfFYLKV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 07:10:21 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate15.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d12011d0001>; Tue, 25 Jun 2019 04:10:21 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 25 Jun 2019 04:10:19 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 25 Jun 2019 04:10:19 -0700
Received: from [10.21.132.148] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 25 Jun
 2019 11:10:17 +0000
Subject: Re: [PATCH net-next 3/3] net: stmmac: Convert to phylink and remove
 phylib logic
To:     Jose Abreu <Jose.Abreu@synopsys.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        linux-tegra <linux-tegra@vger.kernel.org>
References: <cover.1560266175.git.joabreu@synopsys.com>
 <6226d6a0de5929ed07d64b20472c52a86e71383d.1560266175.git.joabreu@synopsys.com>
 <d9ffce3d-4827-fa4a-89e8-0492c4bc1848@nvidia.com>
 <78EB27739596EE489E55E81C33FEC33A0B9C8D6E@DE02WEMBXB.internal.synopsys.com>
 <26cfaeff-a310-3b79-5b57-fd9c93bd8929@nvidia.com>
 <78EB27739596EE489E55E81C33FEC33A0B9C8DD9@DE02WEMBXB.internal.synopsys.com>
 <b66c7578-172f-4443-f4c3-411525e28738@nvidia.com>
 <d96f8bea-f7ef-82ae-01ba-9c97aec0ee38@nvidia.com>
 <6f36b6b6-8209-ed98-e7e1-3dac0a92f6cd@nvidia.com>
 <7f0f2ed0-f47c-4670-d169-25f0413c1fd3@nvidia.com>
 <78EB27739596EE489E55E81C33FEC33A0B9D7024@DE02WEMBXB.internal.synopsys.com>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <113f37a2-c37f-cdb5-5194-4361d949258a@nvidia.com>
Date:   Tue, 25 Jun 2019 12:10:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <78EB27739596EE489E55E81C33FEC33A0B9D7024@DE02WEMBXB.internal.synopsys.com>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1561461021; bh=ywXSgknL1Gy2ftDz0c9HRG7PbJQeUv91vnO+i6OhLZ4=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=J9xgagejO3vqCTRQb9mVBdvVaM+6AcQW66kLwwnvuI2Q2QFjL5mB27Vl6Cz/BnpGA
         8q1wiF5aqsIAzrthX2fNUiwCuBAJ/8+UhijqgZTWdXuM5pBF1SBa2ZLuMB6kVmKArz
         HKJyyAYvRK/4ZUajLTTLuRy5/mnhvxA2520aSqW4NAcx60w0gmLKL7ymNIYmjgyac3
         YmK+jNHAADo2ONnQiaH9YKKlMoxqcUfxknGI4sX1N7mhctJx3X6DK2ws3zWwEfExd3
         54fxDhZUGekKioLX2NBMATjSTb+SyVJSYOjE1Po1om4APyvq6p5eXt8To1IXtAad4T
         HLVyGrWnpl/Hg==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 25/06/2019 08:37, Jose Abreu wrote:
> From: Jon Hunter <jonathanh@nvidia.com>
> 
>> Any further feedback? I am still seeing this issue on today's -next.
> 
> Apologies but I was in FTO.
> 
> Is there any possibility you can just disable the ethX configuration in 
> the rootfs mount and manually configure it after rootfs is done ?
> 
> I just want to make sure in which conditions this is happening (if in 
> ifdown or ifup).

I have been looking at this a bit closer and I can see the problem. What
happens is that ...

1. stmmac_mac_link_up() is called and priv->eee_active is set to false
2. stmmac_eee_init() is called but because priv->eee_active is false,
   timer_setup() for eee_ctrl_timer is never called.
3. stmmac_eee_init() returns true and so then priv->eee_enabled is set 
   to true.
4. When stmmac_tx_clean() is called because priv->eee_enabled is set to    
   true, mod_timer() is called for the eee_ctrl_timer, but because 
   timer_setup() was never called, we hit the BUG defined at
   kernel/time/timer.c:952, because no function is defined for the 
   timer.

The following fixes it for me ...

--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -399,10 +399,13 @@ bool stmmac_eee_init(struct stmmac_priv *priv)
        mutex_lock(&priv->lock);
 
        /* Check if it needs to be deactivated */
-       if (!priv->eee_active && priv->eee_enabled) {
-               netdev_dbg(priv->dev, "disable EEE\n");
-               del_timer_sync(&priv->eee_ctrl_timer);
-               stmmac_set_eee_timer(priv, priv->hw, 0, tx_lpi_timer);
+       if (!priv->eee_active) {
+               if (priv->eee_enabled) {
+                       netdev_dbg(priv->dev, "disable EEE\n");
+                       del_timer_sync(&priv->eee_ctrl_timer);
+                       stmmac_set_eee_timer(priv, priv->hw, 0, tx_lpi_timer);
+               }
+               mutex_unlock(&priv->lock);
                return false;
        }

It also looks like you have a potention deadlock in the current code
because in the case of if (!priv->eee_active && priv->eee_enabled)
you don't unlock the mutex. The above fixes this as well. I can send a
formal patch if this looks correct. 

Cheers
Jon

-- 
nvpublic
