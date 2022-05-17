Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63C4152AD49
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 23:04:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353143AbiEQVDs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 17:03:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349514AbiEQVDs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 17:03:48 -0400
Received: from smtp.smtpout.orange.fr (smtp04.smtpout.orange.fr [80.12.242.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A958532FB
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 14:03:46 -0700 (PDT)
Received: from [192.168.1.18] ([86.243.180.246])
        by smtp.orange.fr with ESMTPA
        id r4M1nkfskEhCQr4M1ndeLA; Tue, 17 May 2022 23:03:44 +0200
X-ME-Helo: [192.168.1.18]
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Tue, 17 May 2022 23:03:44 +0200
X-ME-IP: 86.243.180.246
Message-ID: <ad895690-b611-05d6-3950-601e99c7fa25@wanadoo.fr>
Date:   Tue, 17 May 2022 23:03:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: Re: [PATCH net-next v2 1/5] net: ipqess: introduce the Qualcomm
 IPQESS driver
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        davem@davemloft.net, Rob Herring <robh+dt@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, thomas.petazzoni@bootlin.com,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Robert Marko <robert.marko@sartura.hr>
References: <20220514150656.122108-1-maxime.chevallier@bootlin.com>
 <20220514150656.122108-2-maxime.chevallier@bootlin.com>
X-Mozilla-News-Host: news://news.gmane.org
Content-Language: fr
In-Reply-To: <20220514150656.122108-2-maxime.chevallier@bootlin.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 14/05/2022 à 17:06, Maxime Chevallier a écrit :
> The Qualcomm IPQESS controller is a simple 1G Ethernet controller found
> on the IPQ4019 chip. This controller has some specificities, in that the
> IPQ4019 platform that includes that controller also has an internal
> switch, based on the QCA8K IP.
> 
> It is connected to that switch through an internal link, and doesn't
> expose directly any external interface, hence it only supports the
> PHY_INTERFACE_MODE_INTERNAL for now.
> 
> It has 16 RX and TX queues, with a very basic RSS fanout configured at
> init time.
> 
> Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
> ---
> V1->V2 :
>   - Reworked the init sequence, following Andrew's comments
>   - Added clock and reset support
>   - Reworked the error paths
>   - Added extra endianness wrappers to fix sparse warnings
> 
>   MAINTAINERS                                   |    6 +
>   drivers/net/ethernet/qualcomm/Kconfig         |   11 +
>   drivers/net/ethernet/qualcomm/Makefile        |    2 +
>   drivers/net/ethernet/qualcomm/ipqess/Makefile |    8 +
>   drivers/net/ethernet/qualcomm/ipqess/ipqess.c | 1269 +++++++++++++++++
>   drivers/net/ethernet/qualcomm/ipqess/ipqess.h |  518 +++++++
>   .../ethernet/qualcomm/ipqess/ipqess_ethtool.c |  168 +++
>   7 files changed, 1982 insertions(+)
>   create mode 100644 drivers/net/ethernet/qualcomm/ipqess/Makefile
>   create mode 100644 drivers/net/ethernet/qualcomm/ipqess/ipqess.c
>   create mode 100644 drivers/net/ethernet/qualcomm/ipqess/ipqess.h
>   create mode 100644 drivers/net/ethernet/qualcomm/ipqess/ipqess_ethtool.c
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 9b0480f1b153..29e6ec4f975a 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -16308,6 +16308,12 @@ L:	netdev@vger.kernel.org
>   S:	Maintained
>   F:	drivers/net/ethernet/qualcomm/emac/
>   
> +QUALCOMM IPQESS ETHERNET DRIVER
> +M:	Maxime Chevallier <maxime.chevallier@bootlin.com>
> +L:	netdev@vger.kernel.org
> +S:	Maintained
> +F:	drivers/net/ethernet/qualcomm/ipqess/
> +
>   QUALCOMM ETHQOS ETHERNET DRIVER
>   M:	Vinod Koul <vkoul@kernel.org>
>   L:	netdev@vger.kernel.org
> diff --git a/drivers/net/ethernet/qualcomm/Kconfig b/drivers/net/ethernet/qualcomm/Kconfig
> index a4434eb38950..a723ddbea248 100644
> --- a/drivers/net/ethernet/qualcomm/Kconfig
> +++ b/drivers/net/ethernet/qualcomm/Kconfig
> @@ -60,6 +60,17 @@ config QCOM_EMAC
>   	  low power, Receive-Side Scaling (RSS), and IEEE 1588-2008
>   	  Precision Clock Synchronization Protocol.
>   
> +config QCOM_IPQ4019_ESS_EDMA
> +	tristate "Qualcomm Atheros IPQ4019 ESS EDMA support"
> +	depends on OF
> +	select PHYLINK
> +	help
> +	  This driver supports the Qualcomm Atheros IPQ40xx built-in
> +	  ESS EDMA ethernet controller.
> +
> +	  To compile this driver as a module, choose M here: the
> +	  module will be called ipqess.
> +
>   source "drivers/net/ethernet/qualcomm/rmnet/Kconfig"
>   
>   endif # NET_VENDOR_QUALCOMM
> diff --git a/drivers/net/ethernet/qualcomm/Makefile b/drivers/net/ethernet/qualcomm/Makefile
> index 9250976dd884..db463c9ea1f9 100644
> --- a/drivers/net/ethernet/qualcomm/Makefile
> +++ b/drivers/net/ethernet/qualcomm/Makefile
> @@ -11,4 +11,6 @@ qcauart-objs := qca_uart.o
>   
>   obj-y += emac/
>   
> +obj-$(CONFIG_QCOM_IPQ4019_ESS_EDMA) += ipqess/
> +
>   obj-$(CONFIG_RMNET) += rmnet/
> diff --git a/drivers/net/ethernet/qualcomm/ipqess/Makefile b/drivers/net/ethernet/qualcomm/ipqess/Makefile
> new file mode 100644
> index 000000000000..4f2db7283ebf
> --- /dev/null
> +++ b/drivers/net/ethernet/qualcomm/ipqess/Makefile
> @@ -0,0 +1,8 @@
> +# SPDX-License-Identifier: GPL-2.0-only
> +#
> +# Makefile for the IPQ ESS driver
> +#
> +
> +obj-$(CONFIG_QCOM_IPQ4019_ESS_EDMA) += ipq_ess.o
> +
> +ipq_ess-objs := ipqess.o ipqess_ethtool.o
> diff --git a/drivers/net/ethernet/qualcomm/ipqess/ipqess.c b/drivers/net/ethernet/qualcomm/ipqess/ipqess.c
> new file mode 100644
> index 000000000000..b11f11f23c11
> --- /dev/null
> +++ b/drivers/net/ethernet/qualcomm/ipqess/ipqess.c
> @@ -0,0 +1,1269 @@
> +// SPDX-License-Identifier: GPL-2.0 OR ISC
> +/* Copyright (c) 2014 - 2017, The Linux Foundation. All rights reserved.
> + * Copyright (c) 2017 - 2018, John Crispin <john@phrozen.org>
> + * Copyright (c) 2018 - 2019, Christian Lamparter <chunkeey@gmail.com>
> + * Copyright (c) 2020 - 2021, Gabor Juhos <j4g8y7@gmail.com>
> + * Copyright (c) 2021 - 2022, Maxime Chevallier <maxime.chevallier@bootlin.com>
> + *
> + */
> +
> +#include <linux/bitfield.h>
> +#include <linux/clk.h>
> +#include <linux/if_vlan.h>
> +#include <linux/interrupt.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/of_device.h>
> +#include <linux/of_mdio.h>
> +#include <linux/of_net.h>
> +#include <linux/phylink.h>
> +#include <linux/platform_device.h>
> +#include <linux/reset.h>
> +#include <linux/skbuff.h>
> +#include <linux/vmalloc.h>
> +#include <net/checksum.h>
> +#include <net/ip6_checksum.h>
> +
> +#include "ipqess.h"
> +
> +#define IPQESS_RRD_SIZE		16
> +#define IPQESS_NEXT_IDX(X, Y)  (((X) + 1) & ((Y) - 1))
> +#define IPQESS_TX_DMA_BUF_LEN	0x3fff
> +
> +static void ipqess_w32(struct ipqess *ess, u32 reg, u32 val)
> +{
> +	writel(val, ess->hw_addr + reg);
> +}
> +
> +static u32 ipqess_r32(struct ipqess *ess, u16 reg)
> +{
> +	return readl(ess->hw_addr + reg);
> +}
> +
> +static void ipqess_m32(struct ipqess *ess, u32 mask, u32 val, u16 reg)
> +{
> +	u32 _val = ipqess_r32(ess, reg);
> +
> +	_val &= ~mask;
> +	_val |= val;
> +
> +	ipqess_w32(ess, reg, _val);
> +}
> +
> +void ipqess_update_hw_stats(struct ipqess *ess)
> +{
> +	u32 *p;
> +	u32 stat;
> +	int i;
> +
> +	lockdep_assert_held(&ess->stats_lock);
> +
> +	p = (u32 *)&ess->ipqess_stats;
> +	for (i = 0; i < IPQESS_MAX_TX_QUEUE; i++) {
> +		stat = ipqess_r32(ess, IPQESS_REG_TX_STAT_PKT_Q(i));
> +		*p += stat;
> +		p++;
> +	}
> +
> +	for (i = 0; i < IPQESS_MAX_TX_QUEUE; i++) {
> +		stat = ipqess_r32(ess, IPQESS_REG_TX_STAT_BYTE_Q(i));
> +		*p += stat;
> +		p++;
> +	}
> +
> +	for (i = 0; i < IPQESS_MAX_RX_QUEUE; i++) {
> +		stat = ipqess_r32(ess, IPQESS_REG_RX_STAT_PKT_Q(i));
> +		*p += stat;
> +		p++;
> +	}
> +
> +	for (i = 0; i < IPQESS_MAX_RX_QUEUE; i++) {
> +		stat = ipqess_r32(ess, IPQESS_REG_RX_STAT_BYTE_Q(i));
> +		*p += stat;
> +		p++;
> +	}
> +}
> +
> +static int ipqess_tx_ring_alloc(struct ipqess *ess)
> +{
> +	struct device *dev = &ess->pdev->dev;
> +	int i;
> +
> +	for (i = 0; i < IPQESS_NETDEV_QUEUES; i++) {
> +		struct ipqess_tx_ring *tx_ring = &ess->tx_ring[i];
> +		size_t size;
> +		u32 idx;
> +
> +		tx_ring->ess = ess;
> +		tx_ring->ring_id = i;
> +		tx_ring->idx = i * 4;
> +		tx_ring->count = IPQESS_TX_RING_SIZE;
> +		tx_ring->nq = netdev_get_tx_queue(ess->netdev, i);
> +
> +		size = sizeof(struct ipqess_buf) * IPQESS_TX_RING_SIZE;
> +		tx_ring->buf = devm_kzalloc(dev, size, GFP_KERNEL);
> +		if (!tx_ring->buf) {
> +			netdev_err(ess->netdev, "buffer alloc of tx ring failed");
> +			return -ENOMEM;
> +		}
> +
> +		size = sizeof(struct ipqess_tx_desc) * IPQESS_TX_RING_SIZE;
> +		tx_ring->hw_desc = dmam_alloc_coherent(dev, size, &tx_ring->dma,
> +						       GFP_KERNEL | __GFP_ZERO);

Hi,

Nitpicking: I think that __GFP_ZERO is useless (and harmless) because 
dma_alloc_coherent() always zeroes the memory that is allocated.

CJ

