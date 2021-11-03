Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C427444109
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 13:05:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231343AbhKCMH4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 08:07:56 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:48180 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229998AbhKCMHz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 08:07:55 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id D1566212C7;
        Wed,  3 Nov 2021 12:05:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1635941117; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PgRGtsIjSpE0gTUE8nyt8O3QJvBHS1FHfOmWkKc9SAg=;
        b=nB+4xjTcT8e05rkxv5wWuhtpuibYOqyfD9hyuKLFvXmq7J8GjFuYF4YITtIzpb++/4J60+
        +XLkv5ckNUjKOjT6XX58NpR4KZL+1FwaSImV7gf937uL1c0oWTe2nib/r9q3IHwx42RNVa
        GMemF03rS1tVn8qxikp2eZqiP5pOBWg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1635941117;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PgRGtsIjSpE0gTUE8nyt8O3QJvBHS1FHfOmWkKc9SAg=;
        b=z0830HcE1xX/EzHSjZaZC+ltJ/qk0GJMWPOWDpkP7egHpIX/6YJzAjfUbosc8aqHash4IO
        0pl8CwBcf1gZEbDw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 3D3F113DEB;
        Wed,  3 Nov 2021 12:05:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 9MH5C/16gmFoSQAAMHmgww
        (envelope-from <dkirjanov@suse.de>); Wed, 03 Nov 2021 12:05:17 +0000
Subject: Re: [PATCH 2/2] net: ethernet: Add driver for Sunplus SP7021
To:     Wells Lu <wellslutw@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, robh+dt@kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        p.zabel@pengutronix.de
Cc:     Wells Lu <wells.lu@sunplus.com>
References: <cover.1635936610.git.wells.lu@sunplus.com>
 <650ec751dd782071dd56af5e36c0d509b0c66d7f.1635936610.git.wells.lu@sunplus.com>
From:   Denis Kirjanov <dkirjanov@suse.de>
Message-ID: <f6744b5d-17ff-6cc6-e407-f60a34c697e5@suse.de>
Date:   Wed, 3 Nov 2021 15:05:16 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <650ec751dd782071dd56af5e36c0d509b0c66d7f.1635936610.git.wells.lu@sunplus.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: ru
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



11/3/21 2:02 PM, Wells Lu пишет:
> Add Ethernet driver for Sunplus SP7021.
> 
> Signed-off-by: Wells Lu <wells.lu@sunplus.com>
> ---
>   MAINTAINERS                                  |   1 +
>   drivers/net/ethernet/Kconfig                 |   1 +
>   drivers/net/ethernet/Makefile                |   1 +
>   drivers/net/ethernet/sunplus/Kconfig         |  20 +
>   drivers/net/ethernet/sunplus/Makefile        |   6 +
>   drivers/net/ethernet/sunplus/l2sw_define.h   | 221 ++++++++
>   drivers/net/ethernet/sunplus/l2sw_desc.c     | 233 ++++++++
>   drivers/net/ethernet/sunplus/l2sw_desc.h     |  21 +
>   drivers/net/ethernet/sunplus/l2sw_driver.c   | 779 +++++++++++++++++++++++++++
>   drivers/net/ethernet/sunplus/l2sw_driver.h   |  23 +
>   drivers/net/ethernet/sunplus/l2sw_hal.c      | 422 +++++++++++++++
>   drivers/net/ethernet/sunplus/l2sw_hal.h      |  47 ++
>   drivers/net/ethernet/sunplus/l2sw_int.c      | 326 +++++++++++
>   drivers/net/ethernet/sunplus/l2sw_int.h      |  16 +
>   drivers/net/ethernet/sunplus/l2sw_mac.c      |  68 +++
>   drivers/net/ethernet/sunplus/l2sw_mac.h      |  24 +
>   drivers/net/ethernet/sunplus/l2sw_mdio.c     | 118 ++++
>   drivers/net/ethernet/sunplus/l2sw_mdio.h     |  19 +
>   drivers/net/ethernet/sunplus/l2sw_register.h |  99 ++++
>   19 files changed, 2445 insertions(+)
>   create mode 100644 drivers/net/ethernet/sunplus/Kconfig
>   create mode 100644 drivers/net/ethernet/sunplus/Makefile
>   create mode 100644 drivers/net/ethernet/sunplus/l2sw_define.h
>   create mode 100644 drivers/net/ethernet/sunplus/l2sw_desc.c
>   create mode 100644 drivers/net/ethernet/sunplus/l2sw_desc.h
>   create mode 100644 drivers/net/ethernet/sunplus/l2sw_driver.c
>   create mode 100644 drivers/net/ethernet/sunplus/l2sw_driver.h
>   create mode 100644 drivers/net/ethernet/sunplus/l2sw_hal.c
>   create mode 100644 drivers/net/ethernet/sunplus/l2sw_hal.h
>   create mode 100644 drivers/net/ethernet/sunplus/l2sw_int.c
>   create mode 100644 drivers/net/ethernet/sunplus/l2sw_int.h
>   create mode 100644 drivers/net/ethernet/sunplus/l2sw_mac.c
>   create mode 100644 drivers/net/ethernet/sunplus/l2sw_mac.h
>   create mode 100644 drivers/net/ethernet/sunplus/l2sw_mdio.c
>   create mode 100644 drivers/net/ethernet/sunplus/l2sw_mdio.h
>   create mode 100644 drivers/net/ethernet/sunplus/l2sw_register.h
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 4669c16..ca676ec 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -18006,6 +18006,7 @@ L:	netdev@vger.kernel.org
>   S:	Maintained
>   W:	https://sunplus-tibbo.atlassian.net/wiki/spaces/doc/overview
>   F:	Documentation/devicetree/bindings/net/sunplus,sp7021-l2sw.yaml
> +F:	drivers/net/ethernet/sunplus/
>   
>   SUPERH
>   M:	Yoshinori Sato <ysato@users.sourceforge.jp>
> diff --git a/drivers/net/ethernet/Kconfig b/drivers/net/ethernet/Kconfig
> index 412ae3e..0084852 100644
> --- a/drivers/net/ethernet/Kconfig
> +++ b/drivers/net/ethernet/Kconfig
> @@ -176,6 +176,7 @@ source "drivers/net/ethernet/smsc/Kconfig"
>   source "drivers/net/ethernet/socionext/Kconfig"
>   source "drivers/net/ethernet/stmicro/Kconfig"
>   source "drivers/net/ethernet/sun/Kconfig"
> +source "drivers/net/ethernet/sunplus/Kconfig"
>   source "drivers/net/ethernet/synopsys/Kconfig"
>   source "drivers/net/ethernet/tehuti/Kconfig"
>   source "drivers/net/ethernet/ti/Kconfig"
> diff --git a/drivers/net/ethernet/Makefile b/drivers/net/ethernet/Makefile
> index aaa5078..e4ce162 100644
> --- a/drivers/net/ethernet/Makefile
> +++ b/drivers/net/ethernet/Makefile
> @@ -87,6 +87,7 @@ obj-$(CONFIG_NET_VENDOR_SMSC) += smsc/
>   obj-$(CONFIG_NET_VENDOR_SOCIONEXT) += socionext/
>   obj-$(CONFIG_NET_VENDOR_STMICRO) += stmicro/
>   obj-$(CONFIG_NET_VENDOR_SUN) += sun/
> +obj-$(CONFIG_NET_VENDOR_SUNPLUS) += sunplus/
>   obj-$(CONFIG_NET_VENDOR_TEHUTI) += tehuti/
>   obj-$(CONFIG_NET_VENDOR_TI) += ti/
>   obj-$(CONFIG_NET_VENDOR_TOSHIBA) += toshiba/
> diff --git a/drivers/net/ethernet/sunplus/Kconfig b/drivers/net/ethernet/sunplus/Kconfig
> new file mode 100644
> index 0000000..a9e3a4c
> --- /dev/null
> +++ b/drivers/net/ethernet/sunplus/Kconfig
> @@ -0,0 +1,20 @@
> +# SPDX-License-Identifier: GPL-2.0
> +#
> +# Sunplus Ethernet device configuration
> +#
> +
> +config NET_VENDOR_SUNPLUS
> +	tristate "Sunplus Dual 10M/100M Ethernet (with L2 switch) devices"
> +	depends on ETHERNET && SOC_SP7021
> +	select PHYLIB
> +	select PINCTRL_SPPCTL
> +	select COMMON_CLK_SP7021
> +	select RESET_SUNPLUS
> +	select NVMEM_SUNPLUS_OCOTP
> +	help
> +	  If you have Sunplus dual 10M/100M Ethernet (with L2 switch)
> +	  devices, say Y.
> +	  The network device supports dual 10M/100M Ethernet interfaces,
> +	  or one 10/100M Ethernet interface with two LAN ports.
> +	  To compile this driver as a module, choose M here.  The module
> +	  will be called sp_l2sw.
> diff --git a/drivers/net/ethernet/sunplus/Makefile b/drivers/net/ethernet/sunplus/Makefile
> new file mode 100644
> index 0000000..b401cec
> --- /dev/null
> +++ b/drivers/net/ethernet/sunplus/Makefile
> @@ -0,0 +1,6 @@
> +# SPDX-License-Identifier: GPL-2.0
> +#
> +# Makefile for the Sunplus network device drivers.
> +#
> +obj-$(CONFIG_NET_VENDOR_SUNPLUS) += sp_l2sw.o
> +sp_l2sw-objs := l2sw_driver.o l2sw_int.o l2sw_hal.o l2sw_desc.o l2sw_mac.o l2sw_mdio.o
> diff --git a/drivers/net/ethernet/sunplus/l2sw_define.h b/drivers/net/ethernet/sunplus/l2sw_define.h
> new file mode 100644
> index 0000000..c1049c5
> --- /dev/null
> +++ b/drivers/net/ethernet/sunplus/l2sw_define.h
> @@ -0,0 +1,221 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/* Copyright Sunplus Technology Co., Ltd.
> + *       All rights reserved.
> + */
> +
> +#ifndef __L2SW_DEFINE_H__
> +#define __L2SW_DEFINE_H__
> +
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/sched.h>
> +#include <linux/kernel.h>
> +#include <linux/slab.h>
> +#include <linux/errno.h>
> +#include <linux/types.h>
> +#include <linux/interrupt.h>
> +#include <linux/kdev_t.h>
> +#include <linux/in.h>
> +#include <linux/netdevice.h>
> +#include <linux/etherdevice.h>
> +#include <linux/ip.h>
> +#include <linux/tcp.h>
> +#include <linux/skbuff.h>
> +#include <linux/ethtool.h>
> +#include <linux/platform_device.h>
> +#include <linux/phy.h>
> +#include <linux/mii.h>
> +#include <linux/if_vlan.h>
> +#include <linux/io.h>
> +#include <linux/dma-mapping.h>
> +#include <linux/of_address.h>
> +#include <linux/of_mdio.h>
> +
> +#undef pr_fmt
> +#define pr_fmt(fmt)     "[L2SW]" fmt
> +
> +//define MAC interrupt status bit
> +#define MAC_INT_DAISY_MODE_CHG          BIT(31)
> +#define MAC_INT_IP_CHKSUM_ERR           BIT(23)
> +#define MAC_INT_WDOG_TIMER1_EXP         BIT(22)
> +#define MAC_INT_WDOG_TIMER0_EXP         BIT(21)
> +#define MAC_INT_INTRUDER_ALERT          BIT(20)
> +#define MAC_INT_PORT_ST_CHG             BIT(19)
> +#define MAC_INT_BC_STORM                BIT(18)
> +#define MAC_INT_MUST_DROP_LAN           BIT(17)
> +#define MAC_INT_GLOBAL_QUE_FULL         BIT(16)
> +#define MAC_INT_TX_SOC_PAUSE_ON         BIT(15)
> +#define MAC_INT_RX_SOC_QUE_FULL         BIT(14)
> +#define MAC_INT_TX_LAN1_QUE_FULL        BIT(9)
> +#define MAC_INT_TX_LAN0_QUE_FULL        BIT(8)
> +#define MAC_INT_RX_L_DESCF              BIT(7)
> +#define MAC_INT_RX_H_DESCF              BIT(6)
> +#define MAC_INT_RX_DONE_L               BIT(5)
> +#define MAC_INT_RX_DONE_H               BIT(4)
> +#define MAC_INT_TX_DONE_L               BIT(3)
> +#define MAC_INT_TX_DONE_H               BIT(2)
> +#define MAC_INT_TX_DES_ERR              BIT(1)
> +#define MAC_INT_RX_DES_ERR              BIT(0)
> +
> +#define MAC_INT_RX                      (MAC_INT_RX_DONE_H | MAC_INT_RX_DONE_L | \
> +					MAC_INT_RX_DES_ERR)
> +#define MAC_INT_TX                      (MAC_INT_TX_DONE_L | MAC_INT_TX_DONE_H | \
> +					MAC_INT_TX_DES_ERR)
> +#define MAC_INT_MASK_DEF                (MAC_INT_DAISY_MODE_CHG | MAC_INT_IP_CHKSUM_ERR | \
> +					MAC_INT_WDOG_TIMER1_EXP | MAC_INT_WDOG_TIMER0_EXP | \
> +					MAC_INT_INTRUDER_ALERT | MAC_INT_BC_STORM | \
> +					MAC_INT_MUST_DROP_LAN | MAC_INT_GLOBAL_QUE_FULL | \
> +					MAC_INT_TX_SOC_PAUSE_ON | MAC_INT_RX_SOC_QUE_FULL | \
> +					MAC_INT_TX_LAN1_QUE_FULL | MAC_INT_TX_LAN0_QUE_FULL | \
> +					MAC_INT_RX_L_DESCF | MAC_INT_RX_H_DESCF)
> +
> +/*define port ability*/
> +#define PORT_ABILITY_LINK_ST_P1         BIT(25)
> +#define PORT_ABILITY_LINK_ST_P0         BIT(24)
> +
> +/*define PHY command bit*/
> +#define PHY_WT_DATA_MASK                0xffff0000
> +#define PHY_RD_CMD                      0x00004000
> +#define PHY_WT_CMD                      0x00002000
> +#define PHY_REG_MASK                    0x00001f00
> +#define PHY_ADR_MASK                    0x0000001f
> +
> +/*define PHY status bit*/
> +#define PHY_RD_DATA_MASK                0xffff0000
> +#define PHY_RD_RDY                      BIT(1)
> +#define PHY_WT_DONE                     BIT(0)
> +
> +/*define other register bit*/
> +#define RX_MAX_LEN_MASK                 0x00011000
> +#define ROUTE_MODE_MASK                 0x00000060
> +#define POK_INT_THS_MASK                0x000E0000
> +#define VLAN_TH_MASK                    0x00000007
> +
> +/*define tx descriptor bit*/
> +#define OWN_BIT                         BIT(31)
> +#define FS_BIT                          BIT(25)
> +#define LS_BIT                          BIT(24)
> +#define LEN_MASK                        0x000007FF
> +#define PKTSP_MASK                      0x00007000
> +#define PKTSP_PORT1                     0x00001000
> +#define TO_VLAN_MASK                    0x0003F000
> +#define TO_VLAN_GROUP1                  0x00002000
> +
> +#define EOR_BIT                         BIT(31)
> +
> +/*define rx descriptor bit*/
> +#define ERR_CODE                        (0xf << 26)
> +#define RX_TCP_UDP_CHKSUM_BIT           BIT(23)
> +#define RX_IP_CHKSUM_BIT                BIT(18)
> +
> +#define OWC_BIT                         BIT(31)
> +#define TXOK_BIT                        BIT(26)
> +#define LNKF_BIT                        BIT(25)
> +#define BUR_BIT                         BIT(22)
> +#define TWDE_BIT                        BIT(20)
> +#define CC_MASK                         0x000f0000
> +#define TBE_MASK                        0x00070000
> +
> +// Address table search
> +#define MAC_ADDR_LOOKUP_IDLE            BIT(2)
> +#define MAC_SEARCH_NEXT_ADDR            BIT(1)
> +#define MAC_BEGIN_SEARCH_ADDR           BIT(0)
> +
> +// Address table search
> +#define MAC_HASK_LOOKUP_ADDR_MASK       (0x3ff << 22)
> +#define MAC_AT_TABLE_END                BIT(1)
> +#define MAC_AT_DATA_READY               BIT(0)
> +
> +#define MAC_PHY_ADDR                    0x01	/* define by hardware */
> +
> +/*config descriptor*/
> +#define TX_DESC_NUM                     16
> +#define MAC_GUARD_DESC_NUM              2
> +#define RX_QUEUE0_DESC_NUM              16
> +#define RX_QUEUE1_DESC_NUM              16
> +#define TX_DESC_QUEUE_NUM               1
> +#define RX_DESC_QUEUE_NUM               2
> +
> +#define MAC_TX_BUFF_SIZE                1536
> +#define MAC_RX_LEN_MAX                  2047
> +
> +#define DESC_ALIGN_BYTE                 32
> +#define RX_OFFSET                       0
> +#define TX_OFFSET                       0
> +
> +#define ETHERNET_MAC_ADDR_LEN           6
> +
> +struct mac_desc {
> +	u32 cmd1;
> +	u32 cmd2;
> +	u32 addr1;
> +	u32 addr2;
> +};
> +
> +struct skb_info {
> +	struct sk_buff *skb;
> +	u32 mapping;
> +	u32 len;
> +};
> +
> +struct l2sw_common {
> +	struct net_device *net_dev;
> +	struct platform_device *pdev;
> +	int dual_nic;
> +	int sa_learning;
> +
> +	void *desc_base;
> +	dma_addr_t desc_dma;
> +	s32 desc_size;
> +	struct clk *clk;
> +	struct reset_control *rstc;
> +	int irq;
> +
> +	struct mac_desc *rx_desc[RX_DESC_QUEUE_NUM];
> +	struct skb_info *rx_skb_info[RX_DESC_QUEUE_NUM];
> +	u32 rx_pos[RX_DESC_QUEUE_NUM];
> +	u32 rx_desc_num[RX_DESC_QUEUE_NUM];
> +	u32 rx_desc_buff_size;
> +
> +	struct mac_desc *tx_desc;
> +	struct skb_info tx_temp_skb_info[TX_DESC_NUM];
> +	u32 tx_done_pos;
> +	u32 tx_pos;
> +	u32 tx_desc_full;
> +
> +	struct mii_bus *mii_bus;
> +	struct phy_device *phy_dev;
> +
> +	struct napi_struct rx_napi;
> +	struct napi_struct tx_napi;
> +
> +	spinlock_t rx_lock;      // spinlock for accessing rx buffer
> +	spinlock_t tx_lock;      // spinlock for accessing tx buffer
> +	spinlock_t ioctl_lock;   // spinlock for ioctl operations
> +	struct mutex store_mode; // mutex for dynamic mode change

run checkpatch.pl and fix the errors

