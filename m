Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82CBD500CEB
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 14:18:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241737AbiDNMVE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 08:21:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231996AbiDNMVD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 08:21:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A70662A33;
        Thu, 14 Apr 2022 05:18:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8A7D0B82935;
        Thu, 14 Apr 2022 12:18:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FEA1C385A9;
        Thu, 14 Apr 2022 12:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649938714;
        bh=VC9cveuea8MQPshrwi5leOFayF16bfqB8vVXYO+KWiw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HQoUWx8gsCn/PaPutvbHInlBGD+Q9nesPiCioeSB9J1s3lYDC+q9sutSE3Tpnbwjw
         5q1DoLmE8jN0ZZf4oTYe65Yhy7sWMnG5iGK7JB2cUfrHS2DN2hL9TzpIarkqqWa8N8
         0RsAMG8nxbinqyFAWGruzA2xFvSCi5LWYND2h4WLFSl3CjfRMod7GREHMrp7BUHWTQ
         dHeFqJrAc+ZZIgZSrjyzvoCU+QDLRI4WuLTUDIQ/TTpUxSvqd9s7M2ESB7m+2YSoF+
         VNmiMpqzKhzmqtZUxdsFnKTIIgkPUddTlgYyYo/BcSRDmb2dYIsnp7GktFLr46B7/H
         kmtT4X9Qjf6Rg==
Date:   Thu, 14 Apr 2022 14:18:25 +0200
From:   Jakub Kicinski <kuba@kernel.org>
To:     Wells Lu <wellslutw@gmail.com>
Cc:     davem@davemloft.net, robh+dt@kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        p.zabel@pengutronix.de, pabeni@redhat.com, krzk+dt@kernel.org,
        roopa@nvidia.com, andrew@lunn.ch, edumazet@google.com,
        wells.lu@sunplus.com
Subject: Re: [PATCH net-next v8 2/2] net: ethernet: Add driver for Sunplus
 SP7021
Message-ID: <20220414141825.50eb8b6a@kernel.org>
In-Reply-To: <1649817118-14667-3-git-send-email-wellslutw@gmail.com>
References: <1649817118-14667-1-git-send-email-wellslutw@gmail.com>
        <1649817118-14667-3-git-send-email-wellslutw@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 13 Apr 2022 10:31:58 +0800 Wells Lu wrote:
> Add driver for Sunplus SP7021 SoC.
> 
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Wells Lu <wellslutw@gmail.com>
> ---
> Changes in v8
>   - Fixed "WARNING: unmet direct dependencies detected for PINCTRL_SPPCTL".
>     Removed 'select PINCTRL_SPPCTL' in Kconfig.
>     Selecting PINCTRL_SPPCTL is not actually a must.
> 
>  MAINTAINERS                                    |   1 +
>  drivers/net/ethernet/Kconfig                   |   1 +
>  drivers/net/ethernet/Makefile                  |   1 +
>  drivers/net/ethernet/sunplus/Kconfig           |  35 ++
>  drivers/net/ethernet/sunplus/Makefile          |   6 +
>  drivers/net/ethernet/sunplus/spl2sw_define.h   | 271 +++++++++++
>  drivers/net/ethernet/sunplus/spl2sw_desc.c     | 226 +++++++++
>  drivers/net/ethernet/sunplus/spl2sw_desc.h     |  19 +
>  drivers/net/ethernet/sunplus/spl2sw_driver.c   | 604 +++++++++++++++++++++++++
>  drivers/net/ethernet/sunplus/spl2sw_driver.h   |  12 +
>  drivers/net/ethernet/sunplus/spl2sw_int.c      | 253 +++++++++++
>  drivers/net/ethernet/sunplus/spl2sw_int.h      |  13 +
>  drivers/net/ethernet/sunplus/spl2sw_mac.c      | 346 ++++++++++++++
>  drivers/net/ethernet/sunplus/spl2sw_mac.h      |  19 +
>  drivers/net/ethernet/sunplus/spl2sw_mdio.c     | 126 ++++++
>  drivers/net/ethernet/sunplus/spl2sw_mdio.h     |  12 +
>  drivers/net/ethernet/sunplus/spl2sw_phy.c      |  92 ++++
>  drivers/net/ethernet/sunplus/spl2sw_phy.h      |  12 +
>  drivers/net/ethernet/sunplus/spl2sw_register.h |  86 ++++
>  19 files changed, 2135 insertions(+)
>  create mode 100644 drivers/net/ethernet/sunplus/Kconfig
>  create mode 100644 drivers/net/ethernet/sunplus/Makefile
>  create mode 100644 drivers/net/ethernet/sunplus/spl2sw_define.h
>  create mode 100644 drivers/net/ethernet/sunplus/spl2sw_desc.c
>  create mode 100644 drivers/net/ethernet/sunplus/spl2sw_desc.h
>  create mode 100644 drivers/net/ethernet/sunplus/spl2sw_driver.c
>  create mode 100644 drivers/net/ethernet/sunplus/spl2sw_driver.h
>  create mode 100644 drivers/net/ethernet/sunplus/spl2sw_int.c
>  create mode 100644 drivers/net/ethernet/sunplus/spl2sw_int.h
>  create mode 100644 drivers/net/ethernet/sunplus/spl2sw_mac.c
>  create mode 100644 drivers/net/ethernet/sunplus/spl2sw_mac.h
>  create mode 100644 drivers/net/ethernet/sunplus/spl2sw_mdio.c
>  create mode 100644 drivers/net/ethernet/sunplus/spl2sw_mdio.h
>  create mode 100644 drivers/net/ethernet/sunplus/spl2sw_phy.c
>  create mode 100644 drivers/net/ethernet/sunplus/spl2sw_phy.h
>  create mode 100644 drivers/net/ethernet/sunplus/spl2sw_register.h
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 1d54292..0269797 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -18875,6 +18875,7 @@ L:	netdev@vger.kernel.org
>  S:	Maintained
>  W:	https://sunplus.atlassian.net/wiki/spaces/doc/overview
>  F:	Documentation/devicetree/bindings/net/sunplus,sp7021-emac.yaml
> +F:	drivers/net/ethernet/sunplus/
>  
>  SUNPLUS OCOTP DRIVER
>  M:	Vincent Shih <vincent.sunplus@gmail.com>
> diff --git a/drivers/net/ethernet/Kconfig b/drivers/net/ethernet/Kconfig
> index bd4cb9d..8828539 100644
> --- a/drivers/net/ethernet/Kconfig
> +++ b/drivers/net/ethernet/Kconfig
> @@ -179,6 +179,7 @@ source "drivers/net/ethernet/smsc/Kconfig"
>  source "drivers/net/ethernet/socionext/Kconfig"
>  source "drivers/net/ethernet/stmicro/Kconfig"
>  source "drivers/net/ethernet/sun/Kconfig"
> +source "drivers/net/ethernet/sunplus/Kconfig"
>  source "drivers/net/ethernet/synopsys/Kconfig"
>  source "drivers/net/ethernet/tehuti/Kconfig"
>  source "drivers/net/ethernet/ti/Kconfig"
> diff --git a/drivers/net/ethernet/Makefile b/drivers/net/ethernet/Makefile
> index 8ef43e0..9eb0116 100644
> --- a/drivers/net/ethernet/Makefile
> +++ b/drivers/net/ethernet/Makefile
> @@ -90,6 +90,7 @@ obj-$(CONFIG_NET_VENDOR_SMSC) += smsc/
>  obj-$(CONFIG_NET_VENDOR_SOCIONEXT) += socionext/
>  obj-$(CONFIG_NET_VENDOR_STMICRO) += stmicro/
>  obj-$(CONFIG_NET_VENDOR_SUN) += sun/
> +obj-$(CONFIG_NET_VENDOR_SUNPLUS) += sunplus/
>  obj-$(CONFIG_NET_VENDOR_TEHUTI) += tehuti/
>  obj-$(CONFIG_NET_VENDOR_TI) += ti/
>  obj-$(CONFIG_NET_VENDOR_TOSHIBA) += toshiba/
> diff --git a/drivers/net/ethernet/sunplus/Kconfig b/drivers/net/ethernet/sunplus/Kconfig
> new file mode 100644
> index 0000000..d0144a2
> --- /dev/null
> +++ b/drivers/net/ethernet/sunplus/Kconfig
> @@ -0,0 +1,35 @@
> +# SPDX-License-Identifier: GPL-2.0
> +#
> +# Sunplus network device configuration
> +#
> +
> +config NET_VENDOR_SUNPLUS
> +	bool "Sunplus devices"
> +	default y
> +	depends on ARCH_SUNPLUS || COMPILE_TEST
> +	help
> +	  If you have a network (Ethernet) card belonging to this
> +	  class, say Y here.
> +
> +	  Note that the answer to this question doesn't directly
> +	  affect the kernel: saying N will just cause the configurator
> +	  to skip all the questions about Sunplus cards. If you say Y,
> +	  you will be asked for your specific card in the following
> +	  questions.
> +
> +if NET_VENDOR_SUNPLUS
> +
> +config SP7021_EMAC
> +	tristate "Sunplus Dual 10M/100M Ethernet devices"
> +	depends on SOC_SP7021 || COMPILE_TEST
> +	select PHYLIB
> +	select COMMON_CLK_SP7021
> +	select RESET_SUNPLUS
> +	select NVMEM_SUNPLUS_OCOTP
> +	help
> +	  If you have Sunplus dual 10M/100M Ethernet devices, say Y.
> +	  The network device creates two net-device interfaces.
> +	  To compile this driver as a module, choose M here. The
> +	  module will be called sp7021_emac.
> +
> +endif # NET_VENDOR_SUNPLUS
> diff --git a/drivers/net/ethernet/sunplus/Makefile b/drivers/net/ethernet/sunplus/Makefile
> new file mode 100644
> index 0000000..ef7d7d0
> --- /dev/null
> +++ b/drivers/net/ethernet/sunplus/Makefile
> @@ -0,0 +1,6 @@
> +# SPDX-License-Identifier: GPL-2.0
> +#
> +# Makefile for the Sunplus network device drivers.
> +#
> +obj-$(CONFIG_SP7021_EMAC) += sp7021_emac.o
> +sp7021_emac-objs := spl2sw_driver.o spl2sw_int.o spl2sw_desc.o spl2sw_mac.o spl2sw_mdio.o spl2sw_phy.o
> diff --git a/drivers/net/ethernet/sunplus/spl2sw_define.h b/drivers/net/ethernet/sunplus/spl2sw_define.h
> new file mode 100644
> index 0000000..f299bda
> --- /dev/null
> +++ b/drivers/net/ethernet/sunplus/spl2sw_define.h
> @@ -0,0 +1,271 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/* Copyright Sunplus Technology Co., Ltd.
> + *       All rights reserved.
> + */
> +
> +#ifndef __SPL2SW_DEFINE_H__
> +#define __SPL2SW_DEFINE_H__
> +
> +#define MAX_NETDEV_NUM			2	/* Maximum # of net-device */
> +
> +/* Interrupt status */
> +#define MAC_INT_DAISY_MODE_CHG		BIT(31) /* Daisy Mode Change             */
> +#define MAC_INT_IP_CHKSUM_ERR		BIT(23) /* IP Checksum Append Error      */
> +#define MAC_INT_WDOG_TIMER1_EXP		BIT(22) /* Watchdog Timer1 Expired       */
> +#define MAC_INT_WDOG_TIMER0_EXP		BIT(21) /* Watchdog Timer0 Expired       */
> +#define MAC_INT_INTRUDER_ALERT		BIT(20) /* Atruder Alert                 */
> +#define MAC_INT_PORT_ST_CHG		BIT(19) /* Port Status Change            */
> +#define MAC_INT_BC_STORM		BIT(18) /* Broad Cast Storm              */
> +#define MAC_INT_MUST_DROP_LAN		BIT(17) /* Global Queue Exhausted        */
> +#define MAC_INT_GLOBAL_QUE_FULL		BIT(16) /* Global Queue Full             */
> +#define MAC_INT_TX_SOC_PAUSE_ON		BIT(15) /* Soc Port TX Pause On          */
> +#define MAC_INT_RX_SOC_QUE_FULL		BIT(14) /* Soc Port Out Queue Full       */
> +#define MAC_INT_TX_LAN1_QUE_FULL	BIT(9)  /* Port 1 Out Queue Full         */
> +#define MAC_INT_TX_LAN0_QUE_FULL	BIT(8)  /* Port 0 Out Queue Full         */
> +#define MAC_INT_RX_L_DESCF		BIT(7)  /* Low Priority Descriptor Full  */
> +#define MAC_INT_RX_H_DESCF		BIT(6)  /* High Priority Descriptor Full */
> +#define MAC_INT_RX_DONE_L		BIT(5)  /* RX Low Priority Done          */
> +#define MAC_INT_RX_DONE_H		BIT(4)  /* RX High Priority Done         */
> +#define MAC_INT_TX_DONE_L		BIT(3)  /* TX Low Priority Done          */
> +#define MAC_INT_TX_DONE_H		BIT(2)  /* TX High Priority Done         */
> +#define MAC_INT_TX_DES_ERR		BIT(1)  /* TX Descriptor Error           */
> +#define MAC_INT_RX_DES_ERR		BIT(0)  /* Rx Descriptor Error           */
> +
> +#define MAC_INT_RX			(MAC_INT_RX_DONE_H | MAC_INT_RX_DONE_L | \
> +					MAC_INT_RX_DES_ERR)
> +#define MAC_INT_TX			(MAC_INT_TX_DONE_L | MAC_INT_TX_DONE_H | \
> +					MAC_INT_TX_DES_ERR)
> +#define MAC_INT_MASK_DEF		(MAC_INT_DAISY_MODE_CHG | MAC_INT_IP_CHKSUM_ERR | \
> +					MAC_INT_WDOG_TIMER1_EXP | MAC_INT_WDOG_TIMER0_EXP | \
> +					MAC_INT_INTRUDER_ALERT | MAC_INT_PORT_ST_CHG | \
> +					MAC_INT_BC_STORM | MAC_INT_MUST_DROP_LAN | \
> +					MAC_INT_GLOBAL_QUE_FULL | MAC_INT_TX_SOC_PAUSE_ON | \
> +					MAC_INT_RX_SOC_QUE_FULL | MAC_INT_TX_LAN1_QUE_FULL | \
> +					MAC_INT_TX_LAN0_QUE_FULL | MAC_INT_RX_L_DESCF | \
> +					MAC_INT_RX_H_DESCF)
> +
> +/* Address table search */
> +#define MAC_ADDR_LOOKUP_IDLE		BIT(2)
> +#define MAC_SEARCH_NEXT_ADDR		BIT(1)
> +#define MAC_BEGIN_SEARCH_ADDR		BIT(0)
> +
> +/* Address table status */
> +#define MAC_HASH_LOOKUP_ADDR		GENMASK(31, 22)
> +#define MAC_R_PORT_MAP			GENMASK(13, 12)
> +#define MAC_R_CPU_PORT			GENMASK(11, 10)
> +#define MAC_R_VID			GENMASK(9, 7)
> +#define MAC_R_AGE			GENMASK(6, 4)
> +#define MAC_R_PROXY			BIT(3)
> +#define MAC_R_MC_INGRESS		BIT(2)
> +#define MAC_AT_TABLE_END		BIT(1)
> +#define MAC_AT_DATA_READY		BIT(0)
> +
> +/* Wt mac ad0 */
> +#define MAC_W_PORT_MAP			GENMASK(13, 12)
> +#define MAC_W_LAN_PORT_1		BIT(13)
> +#define MAC_W_LAN_PORT_0		BIT(12)
> +#define MAC_W_CPU_PORT			GENMASK(11, 10)
> +#define MAC_W_CPU_PORT_1		BIT(11)
> +#define MAC_W_CPU_PORT_0		BIT(10)
> +#define MAC_W_VID			GENMASK(9, 7)
> +#define MAC_W_AGE			GENMASK(6, 4)
> +#define MAC_W_PROXY			BIT(3)
> +#define MAC_W_MC_INGRESS		BIT(2)
> +#define MAC_W_MAC_DONE			BIT(1)
> +#define MAC_W_MAC_CMD			BIT(0)
> +
> +/* W mac 15_0 bus */
> +#define MAC_W_MAC_15_0			GENMASK(15, 0)
> +
> +/* W mac 47_16 bus */
> +#define MAC_W_MAC_47_16			GENMASK(31, 0)
> +
> +/* PVID config 0 */
> +#define MAC_P1_PVID			GENMASK(6, 4)
> +#define MAC_P0_PVID			GENMASK(2, 0)
> +
> +/* VLAN member config 0 */
> +#define MAC_VLAN_MEMSET_3		GENMASK(27, 24)
> +#define MAC_VLAN_MEMSET_2		GENMASK(19, 16)
> +#define MAC_VLAN_MEMSET_1		GENMASK(11, 8)
> +#define MAC_VLAN_MEMSET_0		GENMASK(3, 0)
> +
> +/* VLAN member config 1 */
> +#define MAC_VLAN_MEMSET_5		GENMASK(11, 8)
> +#define MAC_VLAN_MEMSET_4		GENMASK(3, 0)
> +
> +/* Port ability */
> +#define MAC_PORT_ABILITY_LINK_ST	GENMASK(25, 24)
> +
> +/* CPU control */
> +#define MAC_EN_SOC1_AGING		BIT(15)
> +#define MAC_EN_SOC0_AGING		BIT(14)
> +#define MAC_DIS_LRN_SOC1		BIT(13)
> +#define MAC_DIS_LRN_SOC0		BIT(12)
> +#define MAC_EN_CRC_SOC1			BIT(9)
> +#define MAC_EN_CRC_SOC0			BIT(8)
> +#define MAC_DIS_SOC1_CPU		BIT(7)
> +#define MAC_DIS_SOC0_CPU		BIT(6)
> +#define MAC_DIS_BC2CPU_P1		BIT(5)
> +#define MAC_DIS_BC2CPU_P0		BIT(4)
> +#define MAC_DIS_MC2CPU			GENMASK(3, 2)
> +#define MAC_DIS_MC2CPU_P1		BIT(3)
> +#define MAC_DIS_MC2CPU_P0		BIT(2)
> +#define MAC_DIS_UN2CPU			GENMASK(1, 0)
> +
> +/* Port control 0 */
> +#define MAC_DIS_PORT			GENMASK(25, 24)
> +#define MAC_DIS_PORT1			BIT(25)
> +#define MAC_DIS_PORT0			BIT(24)
> +#define MAC_DIS_RMC2CPU_P1		BIT(17)
> +#define MAC_DIS_RMC2CPU_P0		BIT(16)
> +#define MAC_EN_FLOW_CTL_P1		BIT(9)
> +#define MAC_EN_FLOW_CTL_P0		BIT(8)
> +#define MAC_EN_BACK_PRESS_P1		BIT(1)
> +#define MAC_EN_BACK_PRESS_P0		BIT(0)
> +
> +/* Port control 1 */
> +#define MAC_DIS_SA_LRN_P1		BIT(9)
> +#define MAC_DIS_SA_LRN_P0		BIT(8)
> +
> +/* Port control 2 */
> +#define MAC_EN_AGING_P1			BIT(9)
> +#define MAC_EN_AGING_P0			BIT(8)
> +
> +/* Switch Global control */
> +#define MAC_RMC_TB_FAULT_RULE		GENMASK(26, 25)
> +#define MAC_LED_FLASH_TIME		GENMASK(24, 23)
> +#define MAC_BC_STORM_PREV		GENMASK(5, 4)
> +
> +/* LED port 0 */
> +#define MAC_LED_ACT_HI			BIT(28)
> +
> +/* PHY control register 0  */
> +#define MAC_CPU_PHY_WT_DATA		GENMASK(31, 16)
> +#define MAC_CPU_PHY_CMD			GENMASK(14, 13)
> +#define MAC_CPU_PHY_REG_ADDR		GENMASK(12, 8)
> +#define MAC_CPU_PHY_ADDR		GENMASK(4, 0)
> +
> +/* PHY control register 1 */
> +#define MAC_CPU_PHY_RD_DATA		GENMASK(31, 16)
> +#define MAC_PHY_RD_RDY			BIT(1)
> +#define MAC_PHY_WT_DONE			BIT(0)
> +
> +/* MAC force mode */
> +#define MAC_EXT_PHY1_ADDR		GENMASK(28, 24)
> +#define MAC_EXT_PHY0_ADDR		GENMASK(20, 16)
> +#define MAC_FORCE_RMII_LINK		GENMASK(9, 8)
> +#define MAC_FORCE_RMII_EN_1		BIT(7)
> +#define MAC_FORCE_RMII_EN_0		BIT(6)
> +#define MAC_FORCE_RMII_FC		GENMASK(5, 4)
> +#define MAC_FORCE_RMII_DPX		GENMASK(3, 2)
> +#define MAC_FORCE_RMII_SPD		GENMASK(1, 0)
> +
> +/* CPU transmit trigger */
> +#define MAC_TRIG_L_SOC0			BIT(1)
> +#define MAC_TRIG_H_SOC0			BIT(0)
> +
> +/* Config descriptor queue */
> +#define TX_DESC_NUM			16	/* # of descriptors in TX queue   */
> +#define MAC_GUARD_DESC_NUM		2	/* # of descriptors of gap      0 */
> +#define RX_QUEUE0_DESC_NUM		16	/* # of descriptors in RX queue 0 */
> +#define RX_QUEUE1_DESC_NUM		16	/* # of descriptors in RX queue 1 */
> +#define TX_DESC_QUEUE_NUM		1	/* # of TX queue                  */
> +#define RX_DESC_QUEUE_NUM		2	/* # of RX queue                  */
> +
> +#define MAC_RX_LEN_MAX			2047	/* Size of RX buffer       */
> +
> +/* Tx descriptor */
> +/* cmd1 */
> +#define TXD_OWN				BIT(31)
> +#define TXD_ERR_CODE			GENMASK(29, 26)
> +#define TXD_SOP				BIT(25)		/* start of a packet */
> +#define TXD_EOP				BIT(24)		/* end of a packet */
> +#define TXD_VLAN			GENMASK(17, 12)
> +#define TXD_PKT_LEN			GENMASK(10, 0)	/* packet length */
> +/* cmd2 */
> +#define TXD_EOR				BIT(31)		/* end of ring */
> +#define TXD_BUF_LEN2			GENMASK(22, 12)
> +#define TXD_BUF_LEN1			GENMASK(10, 0)
> +
> +/* Rx descriptor */
> +/* cmd1 */
> +#define RXD_OWN				BIT(31)
> +#define RXD_ERR_CODE			GENMASK(29, 26)
> +#define RXD_TCP_UDP_CHKSUM		BIT(23)
> +#define RXD_PROXY			BIT(22)
> +#define RXD_PROTOCOL			GENMASK(21, 20)
> +#define RXD_VLAN_TAG			BIT(19)
> +#define RXD_IP_CHKSUM			BIT(18)
> +#define RXD_ROUTE_TYPE			GENMASK(17, 16)
> +#define RXD_PKT_SP			GENMASK(14, 12)	/* packet source port */
> +#define RXD_PKT_LEN			GENMASK(10, 0)	/* packet length */
> +/* cmd2 */
> +#define RXD_EOR				BIT(31)		/* end of ring */
> +#define RXD_BUF_LEN2			GENMASK(22, 12)
> +#define RXD_BUF_LEN1			GENMASK(10, 0)
> +
> +/* structure of descriptor */
> +struct spl2sw_mac_desc {
> +	u32 cmd1;
> +	u32 cmd2;
> +	u32 addr1;
> +	u32 addr2;
> +};
> +
> +struct spl2sw_skb_info {
> +	struct sk_buff *skb;
> +	u32 mapping;
> +	u32 len;
> +};
> +
> +struct spl2sw_common {
> +	void __iomem *l2sw_reg_base;
> +
> +	struct platform_device *pdev;
> +	struct reset_control *rstc;
> +	struct clk *clk;
> +	int irq;
> +
> +	void *desc_base;
> +	dma_addr_t desc_dma;
> +	s32 desc_size;
> +	struct spl2sw_mac_desc *rx_desc[RX_DESC_QUEUE_NUM];
> +	struct spl2sw_skb_info *rx_skb_info[RX_DESC_QUEUE_NUM];
> +	u32 rx_pos[RX_DESC_QUEUE_NUM];
> +	u32 rx_desc_num[RX_DESC_QUEUE_NUM];
> +	u32 rx_desc_buff_size;
> +
> +	struct spl2sw_mac_desc *tx_desc;
> +	struct spl2sw_skb_info tx_temp_skb_info[TX_DESC_NUM];
> +	u32 tx_done_pos;
> +	u32 tx_pos;
> +	u32 tx_desc_full;
> +
> +	struct net_device *ndev[MAX_NETDEV_NUM];
> +	struct mii_bus *mii_bus;
> +
> +	struct napi_struct rx_napi;
> +	struct napi_struct tx_napi;
> +
> +	spinlock_t rx_lock;	/* spinlock for accessing rx buffer */
> +	spinlock_t tx_lock;	/* spinlock for accessing tx buffer */
> +	spinlock_t mdio_lock;	/* spinlock for mdio commands */
> +
> +	u8 enable;
> +};
> +
> +struct spl2sw_mac {
> +	struct net_device *ndev;
> +	struct spl2sw_common *comm;
> +
> +	u8 mac_addr[ETH_ALEN];
> +	phy_interface_t phy_mode;
> +	struct device_node *phy_node;
> +
> +	u8 lan_port;
> +	u8 to_vlan;
> +	u8 vlan_id;
> +};
> +
> +#endif
> diff --git a/drivers/net/ethernet/sunplus/spl2sw_desc.c b/drivers/net/ethernet/sunplus/spl2sw_desc.c
> new file mode 100644
> index 0000000..7d237d4
> --- /dev/null
> +++ b/drivers/net/ethernet/sunplus/spl2sw_desc.c
> @@ -0,0 +1,226 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright Sunplus Technology Co., Ltd.
> + *       All rights reserved.
> + */
> +
> +#include <linux/platform_device.h>
> +#include <linux/netdevice.h>
> +#include <linux/of_mdio.h>
> +
> +#include "spl2sw_define.h"
> +#include "spl2sw_desc.h"
> +
> +void spl2sw_rx_descs_flush(struct spl2sw_common *comm)
> +{
> +	struct spl2sw_skb_info *rx_skbinfo;
> +	struct spl2sw_mac_desc *rx_desc;
> +	u32 i, j;
> +
> +	for (i = 0; i < RX_DESC_QUEUE_NUM; i++) {
> +		rx_desc = comm->rx_desc[i];
> +		rx_skbinfo = comm->rx_skb_info[i];
> +		for (j = 0; j < comm->rx_desc_num[i]; j++) {
> +			rx_desc[j].addr1 = rx_skbinfo[j].mapping;
> +			rx_desc[j].cmd2 = (j == comm->rx_desc_num[i] - 1) ?
> +					  RXD_EOR | comm->rx_desc_buff_size :
> +					  comm->rx_desc_buff_size;
> +			wmb();	/* Set RXD_OWN after other fields are ready. */
> +			rx_desc[j].cmd1 = RXD_OWN;
> +		}
> +	}
> +}
> +
> +void spl2sw_tx_descs_clean(struct spl2sw_common *comm)
> +{
> +	u32 i;
> +
> +	if (!comm->tx_desc)
> +		return;
> +
> +	for (i = 0; i < TX_DESC_NUM; i++) {
> +		comm->tx_desc[i].cmd1 = 0;
> +		wmb();	/* Clear TXD_OWN and then set other fields. */
> +		comm->tx_desc[i].cmd2 = 0;
> +		comm->tx_desc[i].addr1 = 0;
> +		comm->tx_desc[i].addr2 = 0;
> +
> +		if (comm->tx_temp_skb_info[i].mapping) {
> +			dma_unmap_single(&comm->pdev->dev, comm->tx_temp_skb_info[i].mapping,
> +					 comm->tx_temp_skb_info[i].skb->len, DMA_TO_DEVICE);
> +			comm->tx_temp_skb_info[i].mapping = 0;
> +		}
> +
> +		if (comm->tx_temp_skb_info[i].skb) {
> +			dev_kfree_skb_any(comm->tx_temp_skb_info[i].skb);
> +			comm->tx_temp_skb_info[i].skb = NULL;
> +		}
> +	}
> +}
> +
> +void spl2sw_rx_descs_clean(struct spl2sw_common *comm)
> +{
> +	struct spl2sw_skb_info *rx_skbinfo;
> +	struct spl2sw_mac_desc *rx_desc;
> +	u32 i, j;
> +
> +	for (i = 0; i < RX_DESC_QUEUE_NUM; i++) {
> +		if (!comm->rx_skb_info[i])
> +			continue;
> +
> +		rx_desc = comm->rx_desc[i];
> +		rx_skbinfo = comm->rx_skb_info[i];
> +		for (j = 0; j < comm->rx_desc_num[i]; j++) {
> +			rx_desc[j].cmd1 = 0;
> +			wmb();	/* Clear RXD_OWN and then set other fields. */
> +			rx_desc[j].cmd2 = 0;
> +			rx_desc[j].addr1 = 0;
> +
> +			if (rx_skbinfo[j].skb) {
> +				dma_unmap_single(&comm->pdev->dev, rx_skbinfo[j].mapping,
> +						 comm->rx_desc_buff_size, DMA_FROM_DEVICE);
> +				dev_kfree_skb_any(rx_skbinfo[j].skb);
> +				rx_skbinfo[j].skb = NULL;
> +				rx_skbinfo[j].mapping = 0;
> +			}
> +		}
> +
> +		kfree(rx_skbinfo);
> +		comm->rx_skb_info[i] = NULL;
> +	}
> +}
> +
> +void spl2sw_descs_clean(struct spl2sw_common *comm)
> +{
> +	spl2sw_rx_descs_clean(comm);
> +	spl2sw_tx_descs_clean(comm);
> +}
> +
> +void spl2sw_descs_free(struct spl2sw_common *comm)
> +{
> +	u32 i;
> +
> +	spl2sw_descs_clean(comm);
> +	comm->tx_desc = NULL;
> +	for (i = 0; i < RX_DESC_QUEUE_NUM; i++)
> +		comm->rx_desc[i] = NULL;
> +
> +	/*  Free descriptor area  */
> +	if (comm->desc_base) {
> +		dma_free_coherent(&comm->pdev->dev, comm->desc_size, comm->desc_base,
> +				  comm->desc_dma);
> +		comm->desc_base = NULL;
> +		comm->desc_dma = 0;
> +		comm->desc_size = 0;
> +	}
> +}
> +
> +void spl2sw_tx_descs_init(struct spl2sw_common *comm)
> +{
> +	memset(comm->tx_desc, '\0', sizeof(struct spl2sw_mac_desc) *
> +	       (TX_DESC_NUM + MAC_GUARD_DESC_NUM));
> +}
> +
> +int spl2sw_rx_descs_init(struct spl2sw_common *comm)
> +{
> +	struct spl2sw_skb_info *rx_skbinfo;
> +	struct spl2sw_mac_desc *rx_desc;
> +	struct sk_buff *skb;
> +	u32 i, j;
> +
> +	for (i = 0; i < RX_DESC_QUEUE_NUM; i++) {
> +		comm->rx_skb_info[i] = kcalloc(comm->rx_desc_num[i], sizeof(*rx_skbinfo),
> +					       GFP_KERNEL | GFP_DMA);
> +		if (!comm->rx_skb_info[i])
> +			goto mem_alloc_fail;
> +
> +		rx_skbinfo = comm->rx_skb_info[i];
> +		rx_desc = comm->rx_desc[i];
> +		for (j = 0; j < comm->rx_desc_num[i]; j++) {
> +			skb = netdev_alloc_skb(NULL, comm->rx_desc_buff_size);
> +			if (!skb)
> +				goto mem_alloc_fail;
> +
> +			rx_skbinfo[j].skb = skb;
> +			rx_skbinfo[j].mapping = dma_map_single(&comm->pdev->dev, skb->data,
> +							       comm->rx_desc_buff_size,
> +							       DMA_FROM_DEVICE);
> +			if (dma_mapping_error(&comm->pdev->dev, rx_skbinfo[j].mapping))
> +				goto mem_alloc_fail;

Can you call spl2sw_rx_descs_clean() here without clearing the skb?
It will try to unmap the error mapping.

> +			rx_desc[j].addr1 = rx_skbinfo[j].mapping;
> +			rx_desc[j].addr2 = 0;
> +			rx_desc[j].cmd2 = (j == comm->rx_desc_num[i] - 1) ?
> +					  RXD_EOR | comm->rx_desc_buff_size :
> +					  comm->rx_desc_buff_size;
> +			wmb();	/* Set RXD_OWN after other fields are effective. */
> +			rx_desc[j].cmd1 = RXD_OWN;
> +		}
> +	}
> +
> +	return 0;
> +
> +mem_alloc_fail:
> +	spl2sw_rx_descs_clean(comm);
> +	return -ENOMEM;
> +}

> +int spl2sw_descs_init(struct spl2sw_common *comm)
> +{
> +	u32 i, ret;
> +
> +	/* Initialize rx descriptor's data */
> +	comm->rx_desc_num[0] = RX_QUEUE0_DESC_NUM;
> +	comm->rx_desc_num[1] = RX_QUEUE1_DESC_NUM;
> +
> +	for (i = 0; i < RX_DESC_QUEUE_NUM; i++) {
> +		comm->rx_desc[i] = NULL;
> +		comm->rx_skb_info[i] = NULL;
> +		comm->rx_pos[i] = 0;
> +	}
> +	comm->rx_desc_buff_size = MAC_RX_LEN_MAX;
> +
> +	/* Initialize tx descriptor's data */
> +	comm->tx_done_pos = 0;
> +	comm->tx_desc = NULL;
> +	comm->tx_pos = 0;
> +	comm->tx_desc_full = 0;
> +	for (i = 0; i < TX_DESC_NUM; i++)
> +		comm->tx_temp_skb_info[i].skb = NULL;
> +
> +	/* Allocate tx & rx descriptors. */
> +	ret = spl2sw_descs_alloc(comm);
> +	if (ret)
> +		return ret;
> +
> +	spl2sw_tx_descs_init(comm);
> +
> +	return spl2sw_rx_descs_init(comm);

Don't you have to free whatever spl2sw_descs_alloc() allocated, here?

> +}

> +static int spl2sw_ethernet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
> +{
> +	struct spl2sw_mac *mac = netdev_priv(ndev);
> +	struct spl2sw_common *comm = mac->comm;
> +	struct spl2sw_skb_info *skbinfo;
> +	struct spl2sw_mac_desc *txdesc;
> +	unsigned long flags;
> +	u32 tx_pos;
> +	u32 cmd1;
> +	u32 cmd2;
> +
> +	if (unlikely(comm->tx_desc_full == 1)) {
> +		/* No TX descriptors left. Wait for tx interrupt. */
> +		netdev_dbg(ndev, "TX descriptor queue full when xmit!\n");
> +		return NETDEV_TX_BUSY;
> +	}
> +
> +	/* If skb size is shorter than ETH_ZLEN (60), pad it with 0. */
> +	if (unlikely(skb->len < ETH_ZLEN)) {
> +		if (skb_tailroom(skb) >= (ETH_ZLEN - skb->len)) {
> +			memset(skb_put(skb, ETH_ZLEN - skb->len), '\0',
> +			       ETH_ZLEN - skb->len);
> +		} else {
> +			struct sk_buff *old_skb = skb;
> +
> +			skb = netdev_alloc_skb(ndev, ETH_ZLEN);
> +			if (skb) {
> +				memset(skb->data + old_skb->len, '\0',
> +				       ETH_ZLEN - old_skb->len);
> +				memcpy(skb->data, old_skb->data, old_skb->len);
> +				skb_put(skb, ETH_ZLEN);
> +				dev_kfree_skb(old_skb);
> +			} else {
> +				skb = old_skb;
> +			}
> +		}
> +	}

skb_padto()

> +	spin_lock_irqsave(&comm->tx_lock, flags);
> +	tx_pos = comm->tx_pos;
> +	txdesc = &comm->tx_desc[tx_pos];
> +	skbinfo = &comm->tx_temp_skb_info[tx_pos];
> +	skbinfo->len = skb->len;
> +	skbinfo->skb = skb;
> +	skbinfo->mapping = dma_map_single(&comm->pdev->dev, skb->data,
> +					  skb->len, DMA_TO_DEVICE);
> +	if (dma_mapping_error(&comm->pdev->dev, skbinfo->mapping)) {
> +		ndev->stats.tx_errors++;
> +		dev_kfree_skb(skb);
> +		skbinfo->mapping = 0;
> +		skbinfo->len = 0;
> +		skbinfo->skb = NULL;

Don't init these before dma_map_single() so you won't have to clear
them on failure.

> +		goto xmit_drop;
> +	}
> +
> +	/* Set up a TX descriptor */
> +	cmd1 = TXD_OWN | TXD_SOP | TXD_EOP | (mac->to_vlan << 12) |
> +	       (skb->len & TXD_PKT_LEN);
> +	cmd2 = skb->len & TXD_BUF_LEN1;
> +
> +	if (tx_pos == (TX_DESC_NUM - 1))
> +		cmd2 |= TXD_EOR;
> +
> +	txdesc->addr1 = skbinfo->mapping;
> +	txdesc->cmd2 = cmd2;
> +	wmb();	/* Set TXD_OWN after other fields are effective. */
> +	txdesc->cmd1 = cmd1;
> +
> +	/* Move tx_pos to next position */
> +	tx_pos = ((tx_pos + 1) == TX_DESC_NUM) ? 0 : tx_pos + 1;
> +
> +	if (unlikely(tx_pos == comm->tx_done_pos)) {
> +		netif_stop_queue(ndev);
> +		comm->tx_desc_full = 1;

Why do you maintain this tx_desc_full variable? You could compare pos
to done_pos instead, no?

> +	}
> +	comm->tx_pos = tx_pos;
> +	wmb();		/* make sure settings are effective. */
> +
> +	/* trigger gmac to transmit */
> +	writel(MAC_TRIG_L_SOC0, comm->l2sw_reg_base + L2SW_CPU_TX_TRIG);
> +
> +xmit_drop:
> +	spin_unlock_irqrestore(&comm->tx_lock, flags);
> +	return NETDEV_TX_OK;
> +}

> +static int spl2sw_probe(struct platform_device *pdev)
> +{
> +	struct device_node *eth_ports_np;
> +	struct device_node *port_np;
> +	struct spl2sw_common *comm;
> +	struct device_node *phy_np;
> +	phy_interface_t phy_mode;
> +	struct net_device *ndev;
> +	u8 mac_addr[ETH_ALEN];
> +	struct spl2sw_mac *mac;
> +	int irq, i;
> +	int ret;
> +
> +	if (platform_get_drvdata(pdev))
> +		return -ENODEV;
> +
> +	/* Allocate memory for 'spl2sw_common' area. */
> +	comm = devm_kzalloc(&pdev->dev, sizeof(*comm), GFP_KERNEL);
> +	if (!comm)
> +		return -ENOMEM;
> +	comm->pdev = pdev;
> +
> +	spin_lock_init(&comm->rx_lock);
> +	spin_lock_init(&comm->tx_lock);
> +	spin_lock_init(&comm->mdio_lock);
> +
> +	/* Get memory resource 0 from dts. */
> +	comm->l2sw_reg_base = devm_platform_ioremap_resource(pdev, 0);
> +	if (IS_ERR(comm->l2sw_reg_base))
> +		return PTR_ERR(comm->l2sw_reg_base);
> +
> +	/* Get irq resource from dts. */
> +	ret = platform_get_irq(pdev, 0);
> +	if (ret < 0)
> +		return ret;
> +	irq = ret;
> +
> +	/* Get clock controller. */
> +	comm->clk = devm_clk_get(&pdev->dev, NULL);
> +	if (IS_ERR(comm->clk)) {
> +		dev_err_probe(&pdev->dev, PTR_ERR(comm->clk),
> +			      "Failed to retrieve clock controller!\n");
> +		return PTR_ERR(comm->clk);
> +	}
> +
> +	/* Get reset controller. */
> +	comm->rstc = devm_reset_control_get_exclusive(&pdev->dev, NULL);
> +	if (IS_ERR(comm->rstc)) {
> +		dev_err_probe(&pdev->dev, PTR_ERR(comm->rstc),
> +			      "Failed to retrieve reset controller!\n");
> +		return PTR_ERR(comm->rstc);
> +	}
> +
> +	/* Enable clock. */
> +	clk_prepare_enable(comm->clk);

This can fail.

> +	udelay(1);
> +
> +	reset_control_assert(comm->rstc);
> +	udelay(1);
> +	reset_control_deassert(comm->rstc);
> +	udelay(1);
> +
> +	/* Get child node ethernet-ports. */
> +	eth_ports_np = of_get_child_by_name(pdev->dev.of_node, "ethernet-ports");
> +	if (!eth_ports_np) {
> +		dev_err(&pdev->dev, "No ethernet-ports child node found!\n");
> +		ret = -ENODEV;
> +		goto out_clk_disable;
> +	}
> +
> +	for (i = 0; i < MAX_NETDEV_NUM; i++) {
> +		/* Get port@i of node ethernet-ports. */
> +		port_np = spl2sw_get_eth_child_node(eth_ports_np, i);
> +		if (!port_np)
> +			continue;
> +
> +		/* Get phy-mode. */
> +		if (of_get_phy_mode(port_np, &phy_mode)) {
> +			dev_err(&pdev->dev, "Failed to get phy-mode property of port@%d!\n",
> +				i);
> +			continue;
> +		}
> +
> +		/* Get phy-handle. */
> +		phy_np = of_parse_phandle(port_np, "phy-handle", 0);
> +		if (!phy_np) {
> +			dev_err(&pdev->dev, "Failed to get phy-handle property of port@%d!\n",
> +				i);
> +			continue;
> +		}
> +
> +		/* Get mac-address from nvmem. */
> +		ret = spl2sw_nvmem_get_mac_address(&pdev->dev, port_np, mac_addr);
> +		if (ret) {
> +			dev_info(&pdev->dev, "Generate a random mac address!\n");
> +
> +			/* Generate a mac address using OUI of Sunplus Technology
> +			 * and random controller number.
> +			 */
> +			mac_addr[0] = 0xfc; /* OUI of Sunplus: fc:4b:bc */
> +			mac_addr[1] = 0x4b;
> +			mac_addr[2] = 0xbc;
> +			mac_addr[3] = get_random_int() % 256;
> +			mac_addr[4] = get_random_int() % 256;
> +			mac_addr[5] = get_random_int() % 256;

I don't think you can do that. Either you use your OUI and assign the
address at manufacture or you must use a locally administered address.
And if locally administered address is used it better be completely
random to lower the probability of collision to absolute minimum.

> +		}
> +
> +		/* Initialize the net device. */
> +		ret = spl2sw_init_netdev(pdev, mac_addr, &ndev);
> +		if (ret)
> +			goto out_unregister_dev;
> +
> +		ndev->irq = irq;
> +		comm->ndev[i] = ndev;
> +		mac = netdev_priv(ndev);
> +		mac->phy_node = phy_np;
> +		mac->phy_mode = phy_mode;
> +		mac->comm = comm;
> +
> +		mac->lan_port = 0x1 << i;	/* forward to port i */
> +		mac->to_vlan = 0x1 << i;	/* vlan group: i     */
> +		mac->vlan_id = i;		/* vlan group: i     */
> +
> +		/* Set MAC address */
> +		ret = spl2sw_mac_addr_add(mac);
> +		if (ret)
> +			goto out_unregister_dev;
> +
> +		spl2sw_mac_rx_mode_set(mac);
> +	}

> +	/* Request irq. */
> +	ret = devm_request_irq(&pdev->dev, irq, spl2sw_ethernet_interrupt,
> +			       0, ndev->name, ndev);

Why use a netdev pointer as priv for a common IRQ?

> +	if (ret) {
> +		netdev_err(ndev, "Failed to request irq #%d for \"%s\"!\n",
> +			   irq, ndev->name);
> +		goto out_unregister_dev;
> +	}
> +
> +	/* Initialize mdio bus */
> +	ret = spl2sw_mdio_init(comm);
> +	if (ret) {
> +		netdev_err(ndev, "Failed to initialize mdio bus!\n");
> +		goto out_unregister_dev;
> +	}
> +
> +	ret = spl2sw_mac_addr_del_all(comm);
> +	if (ret)
> +		goto out_free_mdio;
> +
> +	ret = spl2sw_descs_init(comm);
> +	if (ret) {
> +		dev_err(&comm->pdev->dev, "Fail to initialize mac descriptors!\n");
> +		spl2sw_descs_free(comm);
> +		goto out_free_mdio;
> +	}
> +
> +	spl2sw_mac_init(comm);
> +
> +	ret = spl2sw_phy_connect(comm);
> +	if (ret) {
> +		netdev_err(ndev, "Failed to connect phy!\n");
> +		goto out_free_mdio;
> +	}

You do all this init after registering the netdev. What prevent the
user space from opening the device and trying to use it before the
probe finished? Seems ripe for crashes. Registering netdevs should
be done very late during probe().

> +	netif_napi_add(ndev, &comm->rx_napi, spl2sw_rx_poll, SPL2SW_RX_NAPI_WEIGHT);
> +	napi_enable(&comm->rx_napi);
> +	netif_napi_add(ndev, &comm->tx_napi, spl2sw_tx_poll, SPL2SW_TX_NAPI_WEIGHT);
> +	napi_enable(&comm->tx_napi);
> +	return 0;
> +
> +out_free_mdio:
> +	spl2sw_mdio_remove(comm);
> +
> +out_unregister_dev:
> +	for (i = 0; i < MAX_NETDEV_NUM; i++)
> +		if (comm->ndev[i])
> +			unregister_netdev(comm->ndev[i]);
> +
> +out_clk_disable:
> +	clk_disable_unprepare(comm->clk);
> +	return ret;
> +}

> new file mode 100644
> index 0000000..5f177b3
> --- /dev/null
> +++ b/drivers/net/ethernet/sunplus/spl2sw_driver.h
> @@ -0,0 +1,12 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/* Copyright Sunplus Technology Co., Ltd.
> + *       All rights reserved.
> + */
> +
> +#ifndef __SPL2SW_DRIVER_H__
> +#define __SPL2SW_DRIVER_H__
> +
> +#define SPL2SW_RX_NAPI_WEIGHT	16
> +#define SPL2SW_TX_NAPI_WEIGHT	16
> +
> +#endif
> diff --git a/drivers/net/ethernet/sunplus/spl2sw_int.c b/drivers/net/ethernet/sunplus/spl2sw_int.c
> new file mode 100644
> index 0000000..b6ab8fe
> --- /dev/null
> +++ b/drivers/net/ethernet/sunplus/spl2sw_int.c
> @@ -0,0 +1,253 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright Sunplus Technology Co., Ltd.
> + *       All rights reserved.
> + */
> +
> +#include <linux/platform_device.h>
> +#include <linux/etherdevice.h>
> +#include <linux/netdevice.h>
> +#include <linux/bitfield.h>
> +#include <linux/of_mdio.h>
> +
> +#include "spl2sw_register.h"
> +#include "spl2sw_define.h"
> +#include "spl2sw_int.h"
> +
> +int spl2sw_rx_poll(struct napi_struct *napi, int budget)
> +{
> +	struct spl2sw_common *comm = container_of(napi, struct spl2sw_common, rx_napi);
> +	struct spl2sw_mac_desc *desc, *h_desc;
> +	struct net_device_stats *stats;
> +	struct sk_buff *skb, *new_skb;
> +	struct spl2sw_skb_info *sinfo;
> +	u32 rx_pos, pkg_len;
> +	u32 num, rx_count;
> +	s32 queue;
> +	u32 mask;
> +	int port;
> +	u32 cmd;
> +
> +	spin_lock(&comm->rx_lock);

What purpose does this lock serve?

> +	/* Process high-priority queue and then low-priority queue. */
> +	for (queue = 0; queue < RX_DESC_QUEUE_NUM; queue++) {
> +		rx_pos = comm->rx_pos[queue];
> +		rx_count = comm->rx_desc_num[queue];
> +
> +		for (num = 0; num < rx_count; num++) {
> +			sinfo = comm->rx_skb_info[queue] + rx_pos;
> +			desc = comm->rx_desc[queue] + rx_pos;
> +			cmd = desc->cmd1;
> +
> +			if (cmd & RXD_OWN)
> +				break;
> +
> +			port = FIELD_GET(RXD_PKT_SP, cmd);
> +			if (port < MAX_NETDEV_NUM && comm->ndev[port])
> +				stats = &comm->ndev[port]->stats;
> +			else
> +				goto spl2sw_rx_poll_rec_err;
> +
> +			pkg_len = FIELD_GET(RXD_PKT_LEN, cmd);
> +			if (unlikely((cmd & RXD_ERR_CODE) || pkg_len < ETH_ZLEN + 4)) {
> +				stats->rx_length_errors++;
> +				stats->rx_dropped++;
> +				goto spl2sw_rx_poll_rec_err;
> +			}
> +
> +			if (unlikely(cmd & RXD_IP_CHKSUM)) {

IP chksum as in bad IP header csum? Let that thru, kernel will drop
it. We don't trust HW to parse above L2 and get checksums right.

> +				stats->rx_crc_errors++;
> +				stats->rx_dropped++;
> +				goto spl2sw_rx_poll_rec_err;
> +			}
> +
> +			dma_unmap_single(&comm->pdev->dev, sinfo->mapping,
> +					 comm->rx_desc_buff_size, DMA_FROM_DEVICE);
> +
> +			skb = sinfo->skb;
> +			skb_put(skb, pkg_len - 4); /* Minus FCS */
> +			skb->ip_summed = CHECKSUM_NONE;
> +			skb->protocol = eth_type_trans(skb, comm->ndev[port]);
> +			netif_receive_skb(skb);
> +
> +			stats->rx_packets++;
> +			stats->rx_bytes += skb->len;
> +
> +			/* Allocate a new skb for receiving. */
> +			new_skb = netdev_alloc_skb(NULL, comm->rx_desc_buff_size);
> +			if (unlikely(!new_skb)) {
> +				desc->cmd2 = (rx_pos == comm->rx_desc_num[queue] - 1) ?
> +					     RXD_EOR : 0;
> +				sinfo->skb = NULL;
> +				sinfo->mapping = 0;
> +				goto spl2sw_rx_poll_alloc_err;

How does this work? The device will handle the empty entry somehow?

> +			}
> +
> +			sinfo->mapping = dma_map_single(&comm->pdev->dev, new_skb->data,
> +							comm->rx_desc_buff_size,
> +							DMA_FROM_DEVICE);
> +			if (dma_mapping_error(&comm->pdev->dev, sinfo->mapping)) {
> +				dev_kfree_skb_irq(new_skb);
> +				desc->cmd2 = (rx_pos == comm->rx_desc_num[queue] - 1) ?
> +					     RXD_EOR : 0;
> +				sinfo->skb = NULL;
> +				goto spl2sw_rx_poll_alloc_err;
> +			}
> +
> +			sinfo->skb = new_skb;
> +			desc->addr1 = sinfo->mapping;
> +
> +spl2sw_rx_poll_rec_err:
> +			desc->cmd2 = (rx_pos == comm->rx_desc_num[queue] - 1) ?
> +				     RXD_EOR | comm->rx_desc_buff_size :
> +				     comm->rx_desc_buff_size;
> +
> +spl2sw_rx_poll_alloc_err:
> +			wmb();	/* Set RXD_OWN after other fields are effective. */
> +			desc->cmd1 = RXD_OWN;
> +
> +			/* Move rx_pos to next position */
> +			rx_pos = ((rx_pos + 1) == comm->rx_desc_num[queue]) ? 0 : rx_pos + 1;
> +
> +			/* If there are packets in high-priority queue,
> +			 * stop processing low-priority queue.
> +			 */
> +			if (queue == 1 && !(h_desc->cmd1 & RXD_OWN))
> +				break;
> +		}
> +
> +		comm->rx_pos[queue] = rx_pos;
> +
> +		/* Save pointer to last rx descriptor of high-priority queue. */
> +		if (queue == 0)
> +			h_desc = comm->rx_desc[queue] + rx_pos;

Where do you take budget into account?

> +	}
> +
> +	spin_unlock(&comm->rx_lock);
> +
> +	wmb();	/* make sure settings are effective. */
> +	mask = readl(comm->l2sw_reg_base + L2SW_SW_INT_MASK_0);
> +	mask &= ~MAC_INT_RX;
> +	writel(mask, comm->l2sw_reg_base + L2SW_SW_INT_MASK_0);
> +
> +	napi_complete(napi);
> +	return 0;
> +}
