Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E26249E1E
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 12:19:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728945AbfFRKTC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 06:19:02 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:3961 "EHLO
        hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725934AbfFRKTB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 06:19:01 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate16.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d08ba940000>; Tue, 18 Jun 2019 03:19:00 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 18 Jun 2019 03:19:00 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 18 Jun 2019 03:19:00 -0700
Received: from [10.21.132.148] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 18 Jun
 2019 10:18:55 +0000
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
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <b66c7578-172f-4443-f4c3-411525e28738@nvidia.com>
Date:   Tue, 18 Jun 2019 11:18:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <78EB27739596EE489E55E81C33FEC33A0B9C8DD9@DE02WEMBXB.internal.synopsys.com>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL108.nvidia.com (172.18.146.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1560853140; bh=c8UwikRvDDyA/O40zAYZCjzIgqKqCU4r3za0BT5rFTA=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=IsghBDLD+HugcVDANvNXIEr2nq0Ib1u64NXqu+Ay16gh1k9ojVjTsu4x4bdXfe1g/
         VmU2CT8xtjRftJV+sWZSHorPeT4jtD+y1jjn+sNYXQtGVyifGo1md9pPYu+uGjrXN2
         b6mJg+22AUQ5lwNIalMN+aIAK2ISzNJc9biAA5QioZDxKV3NBPe9PB52X2jRVUQn2c
         eSssvwvCsRvUp2Tl0Il8cczvjvKXObfwzq5SWoqoPQtSSGe/eJKl4t+1DJPWw/60TC
         5YbexGEtqWZ5KbB3jT+VQpnPVoEfwrkn8vMuO+qlYFAACjfKdpBP+pNe3PcaRA6nHb
         PB5cN7ElL+k9w==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 18/06/2019 10:46, Jose Abreu wrote:
> From: Jon Hunter <jonathanh@nvidia.com>
> 
>> I am not certain but I don't believe so. We are using a static IP address
>> and mounting the root file-system via NFS when we see this ...
> 
> Can you please add a call to napi_synchronize() before every 
> napi_disable() calls, like this:
> 
> if (queue < rx_queues_cnt) {
> 	napi_synchronize(&ch->rx_napi);
> 	napi_disable(&ch->rx_napi);
> }
> 
> if (queue < tx_queues_cnt) {
> 	napi_synchronize(&ch->tx_napi);
> 	napi_disable(&ch->tx_napi);
> }
> 
> [ I can send you a patch if you prefer ]

Yes I can try this and for completeness you mean ...

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 4ca46289a742..d4a12cb64d8e 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -146,10 +146,15 @@ static void stmmac_disable_all_queues(struct stmmac_priv *priv)
        for (queue = 0; queue < maxq; queue++) {
                struct stmmac_channel *ch = &priv->channel[queue];
 
-               if (queue < rx_queues_cnt)
+               if (queue < rx_queues_cnt) {
+                       napi_synchronize(&ch->rx_napi);
                        napi_disable(&ch->rx_napi);
-               if (queue < tx_queues_cnt)
+               }
+
+               if (queue < tx_queues_cnt) {
+                       napi_synchronize(&ch->tx_napi);
                        napi_disable(&ch->tx_napi);
+               }
        }
 }

Cheers
Jon

-- 
nvpublic
