Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2993C5B1EE6
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 15:28:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231788AbiIHN2C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 09:28:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231520AbiIHN1m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 09:27:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C42EC127564
        for <netdev@vger.kernel.org>; Thu,  8 Sep 2022 06:27:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662643648;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mhUZ/EIJ0TeggMsyWeg2BYnQAmC6lfeP5ChDxxSPJCw=;
        b=VeQ2n5pt5vlff3ltVOtOnJK42rCXupEAwhCaP6wz0vrX8+XawRGdMbyPApb3F69Vk4AXIf
        EcckdWDQB4PyxRPbhF+K+RqizRctRsGtBbOJcc0+TZsbMg5AJIk2BFQuvUvXx8uthnmIIo
        BJ3qGfpaYheGtmPUUUb4yVKPePzS7m4=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-19-kW8i5MuwPMS4Nx1MnA1DRA-1; Thu, 08 Sep 2022 09:27:17 -0400
X-MC-Unique: kW8i5MuwPMS4Nx1MnA1DRA-1
Received: by mail-qk1-f200.google.com with SMTP id n15-20020a05620a294f00b006b5768a0ed0so14482243qkp.7
        for <netdev@vger.kernel.org>; Thu, 08 Sep 2022 06:27:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date;
        bh=mhUZ/EIJ0TeggMsyWeg2BYnQAmC6lfeP5ChDxxSPJCw=;
        b=ueyl0/iKWIb7ED5xc0WS45QIHamAGdqQJsp5qihxf+2i//fgboDjC1LmZojb5Rh4EH
         SmhoCpPd08FNwTVJBbqpyaZBF8G4qDBshZgdmgGhdr5GNh6gOcHjhWALtnntkzO3tPu6
         bxrCaa+Gkeo6LOGLLKFb/0Fw3oavQHNfqLSjpWtfuHzP3snRB1dx4AA3fLr1r6gQoXBx
         ArcKcJmxoUIB8O4NoCXEhz1RTqrOw4a8dI0RJwfkzYGkIvogS5HQqMR+HweoqmjTbTdy
         G73Q/BbYDcs/D6u4l3mmhFBakBYgajEvrOwOg+y1XU6FxenboMV0AEtGOJyGDK2olAX3
         q2lA==
X-Gm-Message-State: ACgBeo1fz1iKS2ZC0v2rWHiSkhDyal/JgAWcdOoJhMekja/PL+0uA+Cb
        eFbWxRyDoAux3XIwLKAwdzQF3YIVyJI8K9O3j6+6mE7WB5ec5XvnhbpRFRbFfxPh9sB/ey41767
        5ODim6pZ7tsSX1z5m
X-Received: by 2002:ac8:5b44:0:b0:35a:7195:6a34 with SMTP id n4-20020ac85b44000000b0035a71956a34mr412613qtw.510.1662643636903;
        Thu, 08 Sep 2022 06:27:16 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6lItHhLIzeYz16jAL90YX0vDtKrwEHUlXB7pYhVW0xxOEnq0nPBAPG2PEosVhdRh8AqjeEJQ==
X-Received: by 2002:ac8:5b44:0:b0:35a:7195:6a34 with SMTP id n4-20020ac85b44000000b0035a71956a34mr412575qtw.510.1662643636359;
        Thu, 08 Sep 2022 06:27:16 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-119-112.dyn.eolo.it. [146.241.119.112])
        by smtp.gmail.com with ESMTPSA id i11-20020a05620a150b00b006af08c26774sm16197028qkk.47.2022.09.08.06.27.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 06:27:15 -0700 (PDT)
Message-ID: <9a514918c2fe48f99daa9430c3659eb5c28e9578.camel@redhat.com>
Subject: Re: [net-next v7 2/3] net: ethernet: adi: Add ADIN1110 support
From:   Paolo Abeni <pabeni@redhat.com>
To:     andrei.tachici@stud.acs.upb.ro, linux-kernel@vger.kernel.org
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        netdev@vger.kernel.org, vegard.nossum@oracle.com, joel@jms.id.au,
        l.stelmach@samsung.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, devicetree@vger.kernel.org
Date:   Thu, 08 Sep 2022 15:27:11 +0200
In-Reply-To: <20220906082203.19572-3-andrei.tachici@stud.acs.upb.ro>
References: <20220906082203.19572-1-andrei.tachici@stud.acs.upb.ro>
         <20220906082203.19572-3-andrei.tachici@stud.acs.upb.ro>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hello,

On Tue, 2022-09-06 at 11:22 +0300, andrei.tachici@stud.acs.upb.ro wrote:
> From: Alexandru Tachici <alexandru.tachici@analog.com>
> 
> The ADIN1110 is a low power single port 10BASE-T1L MAC-PHY
> designed for industrial Ethernet applications. It integrates
> an Ethernet PHY core with a MAC and all the associated analog
> circuitry, input and output clock buffering.
> 
> ADIN1110 MAC-PHY encapsulates the ADIN1100 PHY. The PHY registers
> can be accessed through the MDIO MAC registers.
> We are registering an MDIO bus with custom read/write in order
> to let the PHY to be discovered by the PAL. This will let
> the ADIN1100 Linux driver to probe and take control of
> the PHY.
> 
> The ADIN2111 is a low power, low complexity, two-Ethernet ports
> switch with integrated 10BASE-T1L PHYs and one serial peripheral
> interface (SPI) port.
> 
> The device is designed for industrial Ethernet applications using
> low power constrained nodes and is compliant with the IEEE 802.3cg-
> 2019
> Ethernet standard for long reach 10 Mbps single pair Ethernet (SPE).
> The switch supports various routing configurations between
> the two Ethernet ports and the SPI host port providing a flexible
> solution for line, daisy-chain, or ring network topologies.
> 
> The ADIN2111 supports cable reach of up to 1700 meters with ultra
> low power consumption of 77 mW. The two PHY cores support the
> 1.0 V p-p operating mode and the 2.4 V p-p operating mode defined
> in the IEEE 802.3cg standard.
> 
> The device integrates the switch, two Ethernet physical layer (PHY)
> cores with a media access control (MAC) interface and all the
> associated analog circuitry, and input and output clock buffering.
> 
> The device also includes internal buffer queues, the SPI and
> subsystem registers, as well as the control logic to manage the reset
> and clock control and hardware pin configuration.
> 
> Access to the PHYs is exposed via an internal MDIO bus. Writes/reads
> can be performed by reading/writing to the ADIN2111 MDIO registers
> via SPI.
> 
> On probe, for each port, a struct net_device is allocated and
> registered. When both ports are added to the same bridge, the driver
> will enable offloading of frame forwarding at the hardware level.
> 
> Driver offers STP support. Normal operation on forwarding state.
> Allows only frames with the 802.1d DA to be passed to the host
> when in any of the other states.
> 
> When both ports of ADIN2111 belong to the same SW bridge a maximum
> of 12 FDB entries will offloaded by the hardware and are marked as
> such.
> 
> Co-developed-by: Lennart Franzen <lennart@lfdomain.com>
> Signed-off-by: Lennart Franzen <lennart@lfdomain.com>
> Signed-off-by: Alexandru Tachici <alexandru.tachici@analog.com>
> ---
>  drivers/net/ethernet/Kconfig        |    1 +
>  drivers/net/ethernet/Makefile       |    1 +
>  drivers/net/ethernet/adi/Kconfig    |   28 +
>  drivers/net/ethernet/adi/Makefile   |    6 +
>  drivers/net/ethernet/adi/adin1110.c | 1627
> +++++++++++++++++++++++++++
>  5 files changed, 1663 insertions(+)
>  create mode 100644 drivers/net/ethernet/adi/Kconfig
>  create mode 100644 drivers/net/ethernet/adi/Makefile
>  create mode 100644 drivers/net/ethernet/adi/adin1110.c
> 
> diff --git a/drivers/net/ethernet/Kconfig
> b/drivers/net/ethernet/Kconfig
> index 9a55c1d5a0a1..1917da784191 100644
> --- a/drivers/net/ethernet/Kconfig
> +++ b/drivers/net/ethernet/Kconfig
> @@ -121,6 +121,7 @@ config LANTIQ_XRX200
>  	  Support for the PMAC of the Gigabit switch (GSWIP) inside
> the
>  	  Lantiq / Intel VRX200 VDSL SoC
>  
> +source "drivers/net/ethernet/adi/Kconfig"
>  source "drivers/net/ethernet/litex/Kconfig"
>  source "drivers/net/ethernet/marvell/Kconfig"
>  source "drivers/net/ethernet/mediatek/Kconfig"
> diff --git a/drivers/net/ethernet/Makefile
> b/drivers/net/ethernet/Makefile
> index c06e75ed4231..0d872d4efcd1 100644
> --- a/drivers/net/ethernet/Makefile
> +++ b/drivers/net/ethernet/Makefile
> @@ -8,6 +8,7 @@ obj-$(CONFIG_NET_VENDOR_8390) += 8390/
>  obj-$(CONFIG_NET_VENDOR_ACTIONS) += actions/
>  obj-$(CONFIG_NET_VENDOR_ADAPTEC) += adaptec/
>  obj-$(CONFIG_GRETH) += aeroflex/
> +obj-$(CONFIG_NET_VENDOR_ADI) += adi/
>  obj-$(CONFIG_NET_VENDOR_AGERE) += agere/
>  obj-$(CONFIG_NET_VENDOR_ALACRITECH) += alacritech/
>  obj-$(CONFIG_NET_VENDOR_ALLWINNER) += allwinner/
> diff --git a/drivers/net/ethernet/adi/Kconfig
> b/drivers/net/ethernet/adi/Kconfig
> new file mode 100644
> index 000000000000..da3bdd302502
> --- /dev/null
> +++ b/drivers/net/ethernet/adi/Kconfig
> @@ -0,0 +1,28 @@
> +# SPDX-License-Identifier: GPL-2.0 OR BSD-2-Clause
> +#
> +# Analog Devices device configuration
> +#
> +
> +config NET_VENDOR_ADI
> +	bool "Analog Devices devices"
> +	default y
> +	depends on SPI
> +	help
> +	  If you have a network (Ethernet) card belonging to this
> class, say Y.
> +
> +	  Note that the answer to this question doesn't directly
> affect the
> +	  kernel: saying N will just cause the configurator to skip
> all
> +	  the questions about ADI devices. If you say Y, you will be
> asked
> +	  for your specific card in the following questions.
> +
> +if NET_VENDOR_ADI
> +
> +config ADIN1110
> +	tristate "Analog Devices ADIN1110 MAC-PHY"
> +	depends on SPI && NET_SWITCHDEV
> +	select CRC8
> +	help
> +	  Say yes here to build support for Analog Devices ADIN1110
> +	  Low Power 10BASE-T1L Ethernet MAC-PHY.
> +
> +endif # NET_VENDOR_ADI
> diff --git a/drivers/net/ethernet/adi/Makefile
> b/drivers/net/ethernet/adi/Makefile
> new file mode 100644
> index 000000000000..d0383d94303c
> --- /dev/null
> +++ b/drivers/net/ethernet/adi/Makefile
> @@ -0,0 +1,6 @@
> +# SPDX-License-Identifier: GPL-2.0 OR BSD-2-Clause
> +#
> +# Makefile for the Analog Devices network device drivers.
> +#
> +
> +obj-$(CONFIG_ADIN1110) += adin1110.o
> diff --git a/drivers/net/ethernet/adi/adin1110.c
> b/drivers/net/ethernet/adi/adin1110.c
> new file mode 100644
> index 000000000000..391718d056cc
> --- /dev/null
> +++ b/drivers/net/ethernet/adi/adin1110.c
> @@ -0,0 +1,1627 @@
> +// SPDX-License-Identifier: GPL-2.0 OR BSD-2-Clause
> +/* ADIN1110 Low Power 10BASE-T1L Ethernet MAC-PHY
> + * ADIN2111 2-Port Ethernet Switch with Integrated 10BASE-T1L PHY
> + *
> + * Copyright 2021 Analog Devices Inc.
> + */
> +
> +#include <linux/bitfield.h>
> +#include <linux/bits.h>
> +#include <linux/cache.h>
> +#include <linux/crc8.h>
> +#include <linux/etherdevice.h>
> +#include <linux/ethtool.h>
> +#include <linux/if_bridge.h>
> +#include <linux/interrupt.h>
> +#include <linux/iopoll.h>
> +#include <linux/gpio.h>
> +#include <linux/kernel.h>
> +#include <linux/mii.h>
> +#include <linux/module.h>
> +#include <linux/netdevice.h>
> +#include <linux/regulator/consumer.h>
> +#include <linux/phy.h>
> +#include <linux/property.h>
> +#include <linux/spi/spi.h>
> +
> +#include <net/switchdev.h>
> +
> +#include <asm/unaligned.h>
> +
> +#define ADIN1110_PHY_ID				0x1
> +
> +#define ADIN1110_RESET				0x03
> +#define   ADIN1110_SWRESET			BIT(0)
> +
> +#define ADIN1110_CONFIG1			0x04
> +#define   ADIN1110_CONFIG1_SYNC			BIT(15)
> +
> +#define ADIN1110_CONFIG2			0x06
> +#define   ADIN2111_P2_FWD_UNK2HOST		BIT(12)
> +#define   ADIN2111_PORT_CUT_THRU_EN		BIT(11)
> +#define   ADIN1110_CRC_APPEND			BIT(5)
> +#define   ADIN1110_FWD_UNK2HOST			BIT(2)
> +
> +#define ADIN1110_STATUS0			0x08
> +
> +#define ADIN1110_STATUS1			0x09
> +#define   ADIN2111_P2_RX_RDY			BIT(17)
> +#define   ADIN1110_SPI_ERR			BIT(10)
> +#define   ADIN1110_RX_RDY			BIT(4)
> +
> +#define ADIN1110_IMASK1				0x0D
> +#define   ADIN2111_RX_RDY_IRQ			BIT(17)
> +#define   ADIN1110_SPI_ERR_IRQ			BIT(10)
> +#define   ADIN1110_RX_RDY_IRQ			BIT(4)
> +#define   ADIN1110_TX_RDY_IRQ			BIT(3)
> +
> +#define ADIN1110_MDIOACC			0x20
> +#define   ADIN1110_MDIO_TRDONE			BIT(31)
> +#define   ADIN1110_MDIO_ST			GENMASK(29, 28)
> +#define   ADIN1110_MDIO_OP			GENMASK(27, 26)
> +#define   ADIN1110_MDIO_PRTAD			GENMASK(25, 21)
> +#define   ADIN1110_MDIO_DEVAD			GENMASK(20, 16)
> +#define   ADIN1110_MDIO_DATA			GENMASK(15, 0)
> +
> +#define ADIN1110_TX_FSIZE			0x30
> +#define ADIN1110_TX				0x31
> +#define ADIN1110_TX_SPACE			0x32
> +
> +#define ADIN1110_MAC_ADDR_FILTER_UPR		0x50
> +#define   ADIN2111_MAC_ADDR_APPLY2PORT2		BIT(31)
> +#define   ADIN1110_MAC_ADDR_APPLY2PORT		BIT(30)
> +#define   ADIN2111_MAC_ADDR_TO_OTHER_PORT	BIT(17)
> +#define   ADIN1110_MAC_ADDR_TO_HOST		BIT(16)
> +
> +#define ADIN1110_MAC_ADDR_FILTER_LWR		0x51
> +
> +#define ADIN1110_MAC_ADDR_MASK_UPR		0x70
> +#define ADIN1110_MAC_ADDR_MASK_LWR		0x71
> +
> +#define ADIN1110_RX_FSIZE			0x90
> +#define ADIN1110_RX				0x91
> +
> +#define ADIN2111_RX_P2_FSIZE			0xC0
> +#define ADIN2111_RX_P2				0xC1
> +
> +#define ADIN1110_CLEAR_STATUS0			0xFFF
> +
> +/* MDIO_OP codes */
> +#define ADIN1110_MDIO_OP_WR			0x1
> +#define ADIN1110_MDIO_OP_RD			0x3
> +
> +#define ADIN1110_CD				BIT(7)
> +#define ADIN1110_WRITE				BIT(5)
> +
> +#define ADIN1110_MAX_BUFF			2048
> +#define ADIN1110_MAX_FRAMES_READ		64
> +#define ADIN1110_WR_HEADER_LEN			2
> +#define ADIN1110_FRAME_HEADER_LEN		2
> +#define ADIN1110_INTERNAL_SIZE_HEADER_LEN	2
> +#define ADIN1110_RD_HEADER_LEN			3
> +#define ADIN1110_REG_LEN			4
> +#define ADIN1110_FEC_LEN			4
> +
> +#define ADIN1110_PHY_ID_VAL			0x0283BC91
> +#define ADIN2111_PHY_ID_VAL			0x0283BCA1
> +
> +#define ADIN_MAC_MAX_PORTS			2
> +#define ADIN_MAC_MAX_ADDR_SLOTS			16
> +
> +#define ADIN_MAC_MULTICAST_ADDR_SLOT		0
> +#define ADIN_MAC_BROADCAST_ADDR_SLOT		1
> +#define ADIN_MAC_P1_ADDR_SLOT			2
> +#define ADIN_MAC_P2_ADDR_SLOT			3
> +#define ADIN_MAC_FDB_ADDR_SLOT			4
> +
> +DECLARE_CRC8_TABLE(adin1110_crc_table);
> +
> +enum adin1110_chips_id {
> +	ADIN1110_MAC = 0,
> +	ADIN2111_MAC,
> +};
> +
> +struct adin1110_cfg {
> +	enum adin1110_chips_id	id;
> +	char			name[MDIO_NAME_SIZE];
> +	u32			phy_ids[PHY_MAX_ADDR];
> +	u32			ports_nr;
> +	u32			phy_id_val;
> +};
> +
> +struct adin1110_port_priv {
> +	struct adin1110_priv		*priv;
> +	struct net_device		*netdev;
> +	struct net_device		*bridge;
> +	struct phy_device		*phydev;
> +	struct work_struct		tx_work;
> +	u64				rx_packets;
> +	u64				tx_packets;
> +	u64				rx_bytes;
> +	u64				tx_bytes;
> +	struct work_struct		rx_mode_work;
> +	u32				flags;
> +	struct sk_buff_head		txq;
> +	u32				nr;
> +	u32				state;
> +	struct adin1110_cfg		*cfg;
> +};
> +
> +struct adin1110_priv {
> +	struct mutex			lock; /* protect spi */
> +	spinlock_t			state_lock; /* protect RX
> mode */
> +	struct mii_bus			*mii_bus;
> +	struct spi_device		*spidev;
> +	bool				append_crc;
> +	struct adin1110_cfg		*cfg;
> +	u32				tx_space;
> +	u32				irq_mask;
> +	bool				forwarding;
> +	int				irq;
> +	struct adin1110_port_priv	*ports[ADIN_MAC_MAX_PORTS];
> +	char				mii_bus_name[MII_BUS_ID_SIZE
> ];
> +	u8				data[ADIN1110_MAX_BUFF]
> ____cacheline_aligned;
> +};
> +
> +struct adin1110_switchdev_event_work {
> +	struct work_struct work;
> +	struct switchdev_notifier_fdb_info fdb_info;
> +	struct adin1110_port_priv *port_priv;
> +	unsigned long event;
> +};
> +
> +static struct adin1110_cfg adin1110_cfgs[] = {
> +	{
> +		.id = ADIN1110_MAC,
> +		.name = "adin1110",
> +		.phy_ids = {1},
> +		.ports_nr = 1,
> +		.phy_id_val = ADIN1110_PHY_ID_VAL,
> +	},
> +	{
> +		.id = ADIN2111_MAC,
> +		.name = "adin2111",
> +		.phy_ids = {1, 2},
> +		.ports_nr = 2,
> +		.phy_id_val = ADIN2111_PHY_ID_VAL,
> +	},
> +};
> +
> +static u8 adin1110_crc_data(u8 *data, u32 len)
> +{
> +	return crc8(adin1110_crc_table, data, len, 0);
> +}
> +
> +static int adin1110_read_reg(struct adin1110_priv *priv, u16 reg,
> u32 *val)
> +{
> +	u32 header_len = ADIN1110_RD_HEADER_LEN;
> +	u32 read_len = ADIN1110_REG_LEN;
> +	struct spi_transfer t[2] = {0};
> +	int ret;
> +
> +	priv->data[0] = ADIN1110_CD | FIELD_GET(GENMASK(12, 8),
> reg);
> +	priv->data[1] = FIELD_GET(GENMASK(7, 0), reg);
> +	priv->data[2] = 0x00;
> +
> +	if (priv->append_crc) {
> +		priv->data[2] = adin1110_crc_data(&priv->data[0],
> 2);
> +		priv->data[3] = 0x00;
> +		header_len++;
> +	}
> +
> +	t[0].tx_buf = &priv->data[0];
> +	t[0].len = header_len;
> +
> +	if (priv->append_crc)
> +		read_len++;
> +
> +	memset(&priv->data[header_len], 0, read_len);
> +	t[1].rx_buf = &priv->data[header_len];
> +	t[1].len = read_len;
> +
> +	ret = spi_sync_transfer(priv->spidev, t, 2);
> +	if (ret)
> +		return ret;
> +
> +	if (priv->append_crc) {
> +		u8 recv_crc;
> +		u8 crc;
> +
> +		crc = adin1110_crc_data(&priv->data[header_len],
> ADIN1110_REG_LEN);
> +		recv_crc = priv->data[header_len +
> ADIN1110_REG_LEN];
> +
> +		if (crc != recv_crc) {
> +			dev_err_ratelimited(&priv->spidev->dev, "CRC
> error.");
> +			return -EBADMSG;
> +		}
> +	}
> +
> +	*val = get_unaligned_be32(&priv->data[header_len]);
> +
> +	return ret;
> +}
> +
> +static int adin1110_write_reg(struct adin1110_priv *priv, u16 reg,
> u32 val)
> +{
> +	u32 header_len = ADIN1110_WR_HEADER_LEN;
> +	u32 write_len = ADIN1110_REG_LEN;
> +
> +	priv->data[0] = ADIN1110_CD | ADIN1110_WRITE |
> FIELD_GET(GENMASK(12, 8), reg);
> +	priv->data[1] = FIELD_GET(GENMASK(7, 0), reg);
> +
> +	if (priv->append_crc) {
> +		priv->data[2] = adin1110_crc_data(&priv->data[0],
> header_len);
> +		header_len++;
> +	}
> +
> +	put_unaligned_be32(val, &priv->data[header_len]);
> +	if (priv->append_crc) {
> +		priv->data[header_len + write_len] =
> adin1110_crc_data(&priv->data[header_len],
> +								      
> write_len);
> +		write_len++;
> +	}
> +
> +	return spi_write(priv->spidev, &priv->data[0], header_len +
> write_len);
> +}
> +
> +static int adin1110_set_bits(struct adin1110_priv *priv, u16 reg,
> unsigned long mask,
> +			     unsigned long val)
> +{
> +	u32 write_val;
> +	int ret;
> +
> +	ret = adin1110_read_reg(priv, reg, &write_val);
> +	if (ret < 0)
> +		return ret;
> +
> +	set_mask_bits(&write_val, mask, val);
> +
> +	return adin1110_write_reg(priv, reg, write_val);
> +}
> +
> +static int adin1110_round_len(int len)
> +{
> +	/* can read/write only mutiples of 4 bytes of payload */
> +	len = ALIGN(len, 4);
> +
> +	/* NOTE: ADIN1110_WR_HEADER_LEN should be used for write
> ops. */
> +	if (len + ADIN1110_RD_HEADER_LEN > ADIN1110_MAX_BUFF)
> +		return -EINVAL;
> +
> +	return len;
> +}
> +
> +static int adin1110_read_fifo(struct adin1110_port_priv *port_priv)
> +{
> +	struct adin1110_priv *priv = port_priv->priv;
> +	u32 header_len = ADIN1110_RD_HEADER_LEN;
> +	struct spi_transfer t[2] = {0};
> +	u32 frame_size_no_fcs;
> +	struct sk_buff *rxb;
> +	u32 frame_size;
> +	int round_len;
> +	u16 reg;
> +	int ret;
> +
> +	if (!port_priv->nr) {
> +		reg = ADIN1110_RX;
> +		ret = adin1110_read_reg(priv, ADIN1110_RX_FSIZE,
> &frame_size);
> +	} else {
> +		reg = ADIN2111_RX_P2;
> +		ret = adin1110_read_reg(priv, ADIN2111_RX_P2_FSIZE,
> &frame_size);
> +	}
> +
> +	if (ret < 0)
> +		return ret;
> +
> +	/* the read frame size includes the extra 2 bytes from the 
> ADIN1110 frame header */
> +	if (frame_size < ADIN1110_FRAME_HEADER_LEN +
> ADIN1110_FEC_LEN)
> +		return ret;
> +
> +	round_len = adin1110_round_len(frame_size);
> +	if (round_len < 0)
> +		return ret;
> +
> +	frame_size_no_fcs = frame_size - ADIN1110_FRAME_HEADER_LEN -
> ADIN1110_FEC_LEN;
> +
> +	rxb = netdev_alloc_skb(port_priv->netdev, round_len);
> +	if (!rxb)
> +		return -ENOMEM;
> +
> +	memset(priv->data, 0, round_len + ADIN1110_RD_HEADER_LEN);
> +
> +	priv->data[0] = ADIN1110_CD | FIELD_GET(GENMASK(12, 8),
> reg);
> +	priv->data[1] = FIELD_GET(GENMASK(7, 0), reg);
> +
> +	if (priv->append_crc) {
> +		priv->data[2] = adin1110_crc_data(&priv->data[0],
> 2);
> +		header_len++;
> +	}
> +
> +	skb_put(rxb, frame_size_no_fcs + ADIN1110_FRAME_HEADER_LEN);
> +
> +	t[0].tx_buf = &priv->data[0];
> +	t[0].len = header_len;
> +
> +	t[1].rx_buf = &rxb->data[0];
> +	t[1].len = round_len;
> +
> +	ret = spi_sync_transfer(priv->spidev, t, 2);
> +	if (ret) {
> +		kfree_skb(rxb);
> +		return ret;
> +	}
> +
> +	skb_pull(rxb, ADIN1110_FRAME_HEADER_LEN);
> +	rxb->protocol = eth_type_trans(rxb, port_priv->netdev);
> +
> +	if ((port_priv->flags & IFF_ALLMULTI && rxb->pkt_type ==
> PACKET_MULTICAST) ||
> +	    (port_priv->flags & IFF_BROADCAST && rxb->pkt_type ==
> PACKET_BROADCAST))
> +		rxb->offload_fwd_mark = 1;
> +
> +	netif_rx(rxb);
> +
> +	port_priv->rx_bytes += frame_size -
> ADIN1110_FRAME_HEADER_LEN;
> +	port_priv->rx_packets++;
> +
> +	return 0;
> +}
> +
> +static int adin1110_write_fifo(struct adin1110_port_priv *port_priv,
> struct sk_buff *txb)
> +{
> +	struct adin1110_priv *priv = port_priv->priv;
> +	u32 header_len = ADIN1110_WR_HEADER_LEN;
> +	__be16 frame_header;
> +	int padding = 0;
> +	int padded_len;
> +	int round_len;
> +	int ret;
> +
> +	/* Pad frame to 64 byte length,
> +	 * MAC nor PHY will otherwise add the
> +	 * required padding.
> +	 * The FEC will be added by the MAC internally.
> +	 */
> +	if (txb->len + ADIN1110_FEC_LEN < 64)
> +		padding = 64 - (txb->len + ADIN1110_FEC_LEN);
> +
> +	padded_len = txb->len + padding + ADIN1110_FRAME_HEADER_LEN;
> +
> +	round_len = adin1110_round_len(padded_len);
> +	if (round_len < 0)
> +		return round_len;
> +
> +	ret = adin1110_write_reg(priv, ADIN1110_TX_FSIZE,
> padded_len);
> +	if (ret < 0)
> +		return ret;
> +
> +	memset(priv->data, 0, round_len + ADIN1110_WR_HEADER_LEN);
> +
> +	priv->data[0] = ADIN1110_CD | ADIN1110_WRITE |
> FIELD_GET(GENMASK(12, 8), ADIN1110_TX);
> +	priv->data[1] = FIELD_GET(GENMASK(7, 0), ADIN1110_TX);
> +	if (priv->append_crc) {
> +		priv->data[2] = adin1110_crc_data(&priv->data[0],
> 2);
> +		header_len++;
> +	}
> +
> +	/* mention the port on which to send the frame in the frame
> header */
> +	frame_header = cpu_to_be16(port_priv->nr);
> +	memcpy(&priv->data[header_len], &frame_header,
> ADIN1110_FRAME_HEADER_LEN);
> +
> +	memcpy(&priv->data[header_len + ADIN1110_FRAME_HEADER_LEN],
> txb->data, txb->len);
> +
> +	ret = spi_write(priv->spidev, &priv->data[0], round_len +
> header_len);
> +	if (ret < 0)
> +		return ret;
> +
> +	port_priv->tx_bytes += txb->len;
> +	port_priv->tx_packets++;
> +
> +	return 0;
> +}
> +
> +static int adin1110_read_mdio_acc(struct adin1110_priv *priv)
> +{
> +	u32 val;
> +	int ret;
> +
> +	mutex_lock(&priv->lock);
> +	ret = adin1110_read_reg(priv, ADIN1110_MDIOACC, &val);
> +	mutex_unlock(&priv->lock);
> +	if (ret < 0)
> +		return 0;
> +
> +	return val;
> +}
> +
> +static int adin1110_mdio_read(struct mii_bus *bus, int phy_id, int
> reg)
> +{
> +	struct adin1110_priv *priv = bus->priv;
> +	u32 val = 0;
> +	int ret;
> +
> +	if (mdio_phy_id_is_c45(phy_id))
> +		return -EOPNOTSUPP;
> +
> +	val |= FIELD_PREP(ADIN1110_MDIO_OP, ADIN1110_MDIO_OP_RD);
> +	val |= FIELD_PREP(ADIN1110_MDIO_ST, 0x1);
> +	val |= FIELD_PREP(ADIN1110_MDIO_PRTAD, phy_id);
> +	val |= FIELD_PREP(ADIN1110_MDIO_DEVAD, reg);
> +
> +	/* write the clause 22 read command to the chip */
> +	mutex_lock(&priv->lock);
> +	ret = adin1110_write_reg(priv, ADIN1110_MDIOACC, val);
> +	mutex_unlock(&priv->lock);
> +	if (ret < 0)
> +		return ret;
> +
> +	/* ADIN1110_MDIO_TRDONE BIT of the ADIN1110_MDIOACC
> +	 * register is set when the read is done.
> +	 * After the transaction is done, ADIN1110_MDIO_DATA
> +	 * bitfield of ADIN1110_MDIOACC register will contain
> +	 * the requested register value.
> +	 */
> +	ret = readx_poll_timeout(adin1110_read_mdio_acc, priv, val,
> (val & ADIN1110_MDIO_TRDONE),
> +				 10000, 30000);
> +	if (ret < 0)
> +		return ret;
> +
> +	return (val & ADIN1110_MDIO_DATA);
> +}
> +
> +static int adin1110_mdio_write(struct mii_bus *bus, int phy_id, int
> reg, u16 reg_val)
> +{
> +	struct adin1110_priv *priv = bus->priv;
> +	u32 val = 0;
> +	int ret;
> +
> +	if (mdio_phy_id_is_c45(phy_id))
> +		return -EOPNOTSUPP;
> +
> +	val |= FIELD_PREP(ADIN1110_MDIO_OP, ADIN1110_MDIO_OP_WR);
> +	val |= FIELD_PREP(ADIN1110_MDIO_ST, 0x1);
> +	val |= FIELD_PREP(ADIN1110_MDIO_PRTAD, phy_id);
> +	val |= FIELD_PREP(ADIN1110_MDIO_DEVAD, reg);
> +	val |= FIELD_PREP(ADIN1110_MDIO_DATA, reg_val);
> +
> +	/* write the clause 22 write command to the chip */
> +	mutex_lock(&priv->lock);
> +	ret = adin1110_write_reg(priv, ADIN1110_MDIOACC, val);
> +	mutex_unlock(&priv->lock);
> +	if (ret < 0)
> +		return ret;
> +
> +	return readx_poll_timeout(adin1110_read_mdio_acc, priv, val,
> (val & ADIN1110_MDIO_TRDONE),
> +				  10000, 30000);
> +}
> +
> +/* ADIN1110 MAC-PHY contains an ADIN1100 PHY.
> + * ADIN2111 MAC-PHY contains two ADIN1100 PHYs.
> + * By registering a new MDIO bus we allow the PAL to discover
> + * the encapsulated PHY and probe the ADIN1100 driver.
> + */
> +static int adin1110_register_mdiobus(struct adin1110_priv *priv,
> struct device *dev)
> +{
> +	struct mii_bus *mii_bus;
> +	int ret;
> +
> +	mii_bus = devm_mdiobus_alloc(dev);
> +	if (!mii_bus)
> +		return -ENOMEM;
> +
> +	snprintf(priv->mii_bus_name, MII_BUS_ID_SIZE, "%s-%u",
> +		 priv->cfg->name, priv->spidev->chip_select);
> +
> +	mii_bus->name = priv->mii_bus_name;
> +	mii_bus->read = adin1110_mdio_read;
> +	mii_bus->write = adin1110_mdio_write;
> +	mii_bus->priv = priv;
> +	mii_bus->parent = dev;
> +	mii_bus->phy_mask = ~((u32)GENMASK(2, 0));
> +	mii_bus->probe_capabilities = MDIOBUS_C22;
> +	snprintf(mii_bus->id, MII_BUS_ID_SIZE, "%s", dev_name(dev));
> +
> +	ret = devm_mdiobus_register(dev, mii_bus);
> +	if (ret)
> +		return ret;
> +
> +	priv->mii_bus = mii_bus;
> +
> +	return 0;
> +}
> +
> +static bool adin1110_port_rx_ready(struct adin1110_port_priv
> *port_priv, u32 status)
> +{
> +	if (!netif_oper_up(port_priv->netdev))
> +		return false;
> +
> +	if (!port_priv->nr)
> +		return !!(status & ADIN1110_RX_RDY);
> +	else
> +		return !!(status & ADIN2111_P2_RX_RDY);
> +}
> +
> +static void adin1110_read_frames(struct adin1110_port_priv
> *port_priv, unsigned int budget)
> +{
> +	struct adin1110_priv *priv = port_priv->priv;
> +	u32 status1;
> +	int ret;
> +
> +	while (budget) {
> +		ret = adin1110_read_reg(priv, ADIN1110_STATUS1,
> &status1);
> +		if (ret < 0)
> +			return;
> +
> +		if (!adin1110_port_rx_ready(port_priv, status1))
> +			break;
> +
> +		ret = adin1110_read_fifo(port_priv);
> +		if (ret < 0)
> +			return;
> +
> +		budget--;
> +	}
> +}
> +
> +static void adin1110_wake_queues(struct adin1110_priv *priv)
> +{
> +	int i;
> +
> +	for (i = 0; i < priv->cfg->ports_nr; i++)
> +		netif_wake_queue(priv->ports[i]->netdev);
> +}
> +
> +static irqreturn_t adin1110_irq(int irq, void *p)
> +{
> +	struct adin1110_priv *priv = p;
> +	u32 status1;
> +	u32 val;
> +	int ret;
> +	int i;
> +
> +	mutex_lock(&priv->lock);
> +
> +	ret = adin1110_read_reg(priv, ADIN1110_STATUS1, &status1);
> +	if (ret < 0)
> +		goto out;
> +
> +	if (priv->append_crc && (status1 & ADIN1110_SPI_ERR))
> +		dev_warn_ratelimited(&priv->spidev->dev, "SPI CRC
> error on write.\n");
> +
> +	ret = adin1110_read_reg(priv, ADIN1110_TX_SPACE, &val);
> +	if (ret < 0)
> +		goto out;
> +
> +	/* TX FIFO space is expressed in half-words */
> +	priv->tx_space = 2 * val;
> +
> +	for (i = 0; i < priv->cfg->ports_nr; i++) {
> +		if (adin1110_port_rx_ready(priv->ports[i], status1))
> +			adin1110_read_frames(priv->ports[i],
> ADIN1110_MAX_FRAMES_READ);
> +	}
> +
> +	/* clear IRQ sources */
> +	adin1110_write_reg(priv, ADIN1110_STATUS0,
> ADIN1110_CLEAR_STATUS0);
> +	adin1110_write_reg(priv, ADIN1110_STATUS1, priv->irq_mask);
> +
> +out:
> +	mutex_unlock(&priv->lock);
> +
> +	if (priv->tx_space > 0 && ret >= 0)
> +		adin1110_wake_queues(priv);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +/* ADIN1110 can filter up to 16 MAC addresses, mac_nr here is the
> slot used */
> +static int adin1110_write_mac_address(struct adin1110_port_priv
> *port_priv, int mac_nr,
> +				      const u8 *addr, u8 *mask, u32
> port_rules)
> +{
> +	struct adin1110_priv *priv = port_priv->priv;
> +	u32 offset = mac_nr * 2;
> +	u32 port_rules_mask;
> +	int ret;
> +	u32 val;
> +
> +	if (!port_priv->nr)
> +		port_rules_mask = ADIN1110_MAC_ADDR_APPLY2PORT;
> +	else
> +		port_rules_mask = ADIN2111_MAC_ADDR_APPLY2PORT2;
> +
> +	if (port_rules & port_rules_mask)
> +		port_rules_mask |= ADIN1110_MAC_ADDR_TO_HOST |
> ADIN2111_MAC_ADDR_TO_OTHER_PORT;
> +
> +	port_rules_mask |= GENMASK(15, 0);
> +	val = port_rules | get_unaligned_be16(&addr[0]);
> +	ret = adin1110_set_bits(priv, ADIN1110_MAC_ADDR_FILTER_UPR +
> offset, port_rules_mask, val);
> +	if (ret < 0)
> +		return ret;
> +
> +	val = get_unaligned_be32(&addr[2]);
> +	ret =  adin1110_write_reg(priv, ADIN1110_MAC_ADDR_FILTER_LWR
> + offset, val);
> +	if (ret < 0)
> +		return ret;
> +
> +	/* Only the first two MAC address slots support masking. */
> +	if (mac_nr < ADIN_MAC_P1_ADDR_SLOT) {
> +		val = get_unaligned_be16(&mask[0]);
> +		ret = adin1110_write_reg(priv,
> ADIN1110_MAC_ADDR_MASK_UPR + offset, val);
> +		if (ret < 0)
> +			return ret;
> +
> +		val = get_unaligned_be32(&mask[2]);
> +		return adin1110_write_reg(priv,
> ADIN1110_MAC_ADDR_MASK_LWR + offset, val);
> +	}
> +
> +	return 0;
> +}
> +
> +static int adin1110_clear_mac_address(struct adin1110_priv *priv,
> int mac_nr)
> +{
> +	u32 offset = mac_nr * 2;
> +	int ret;
> +
> +	ret = adin1110_write_reg(priv, ADIN1110_MAC_ADDR_FILTER_UPR
> + offset, 0);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret =  adin1110_write_reg(priv, ADIN1110_MAC_ADDR_FILTER_LWR
> + offset, 0);
> +	if (ret < 0)
> +		return ret;
> +
> +	/* only the first two MAC address slots are maskable */
> +	if (mac_nr <= 1) {
> +		ret = adin1110_write_reg(priv,
> ADIN1110_MAC_ADDR_MASK_UPR + offset, 0);
> +		if (ret < 0)
> +			return ret;
> +
> +		ret = adin1110_write_reg(priv,
> ADIN1110_MAC_ADDR_MASK_LWR + offset, 0);
> +	}
> +
> +	return ret;
> +}
> +
> +static u32 adin1110_port_rules(struct adin1110_port_priv *port_priv,
> bool fw_to_host,
> +			       bool fw_to_other_port)
> +{
> +	u32 port_rules = 0;
> +
> +	if (!port_priv->nr)
> +		port_rules |= ADIN1110_MAC_ADDR_APPLY2PORT;
> +	else
> +		port_rules |= ADIN2111_MAC_ADDR_APPLY2PORT2;
> +
> +	if (fw_to_host)
> +		port_rules |= ADIN1110_MAC_ADDR_TO_HOST;
> +
> +	if (fw_to_other_port && port_priv->priv->forwarding)
> +		port_rules |= ADIN2111_MAC_ADDR_TO_OTHER_PORT;
> +
> +	return port_rules;
> +}
> +
> +static int adin1110_multicast_filter(struct adin1110_port_priv
> *port_priv, int mac_nr,
> +				     bool accept_multicast)
> +{
> +	u8 mask[ETH_ALEN] = {0};
> +	u8 mac[ETH_ALEN] = {0};
> +	u32 port_rules = 0;
> +
> +	mask[0] = BIT(0);
> +	mac[0] = BIT(0);
> +
> +	if (accept_multicast && port_priv->state ==
> BR_STATE_FORWARDING)
> +		port_rules = adin1110_port_rules(port_priv, true,
> true);
> +
> +	return adin1110_write_mac_address(port_priv, mac_nr, mac,
> mask, port_rules);
> +}
> +
> +static int adin1110_broadcasts_filter(struct adin1110_port_priv
> *port_priv, int mac_nr,
> +				      bool accept_broadcast)
> +{
> +	u32 port_rules = 0;
> +	u8 mask[ETH_ALEN];
> +
> +	memset(mask, 0xFF, ETH_ALEN);
> +
> +	if (accept_broadcast && port_priv->state ==
> BR_STATE_FORWARDING)
> +		port_rules = adin1110_port_rules(port_priv, true,
> true);
> +
> +	return adin1110_write_mac_address(port_priv, mac_nr, mask,
> mask, port_rules);
> +}
> +
> +static int adin1110_set_mac_address(struct net_device *netdev, const
> unsigned char *dev_addr)
> +{
> +	struct adin1110_port_priv *port_priv = netdev_priv(netdev);
> +	u8 mask[ETH_ALEN];
> +	u32 port_rules;
> +	u32 mac_slot;
> +
> +	if (!is_valid_ether_addr(dev_addr))
> +		return -EADDRNOTAVAIL;
> +
> +	eth_hw_addr_set(netdev, dev_addr);
> +	memset(mask, 0xFF, ETH_ALEN);
> +
> +	mac_slot = (!port_priv->nr) ?  ADIN_MAC_P1_ADDR_SLOT :
> ADIN_MAC_P2_ADDR_SLOT;
> +	port_rules = adin1110_port_rules(port_priv, true, false);
> +
> +	return adin1110_write_mac_address(port_priv, mac_slot,
> netdev->dev_addr, mask, port_rules);
> +}
> +
> +static int adin1110_ndo_set_mac_address(struct net_device *netdev,
> void *addr)
> +{
> +	struct sockaddr *sa = addr;
> +	int ret;
> +
> +	ret = eth_prepare_mac_addr_change(netdev, addr);
> +	if (ret < 0)
> +		return ret;
> +
> +	return adin1110_set_mac_address(netdev, sa->sa_data);
> +}
> +
> +static int adin1110_ioctl(struct net_device *netdev, struct ifreq
> *rq, int cmd)
> +{
> +	if (!netif_running(netdev))
> +		return -EINVAL;
> +
> +	return phy_do_ioctl(netdev, rq, cmd);
> +}
> +
> +static int adin1110_set_promisc_mode(struct adin1110_port_priv
> *port_priv, bool promisc)
> +{
> +	struct adin1110_priv *priv = port_priv->priv;
> +	u32 mask;
> +
> +	if (port_priv->state != BR_STATE_FORWARDING)
> +		promisc = false;
> +
> +	if (!port_priv->nr)
> +		mask = ADIN1110_FWD_UNK2HOST;
> +	else
> +		mask = ADIN2111_P2_FWD_UNK2HOST;
> +
> +	return adin1110_set_bits(priv, ADIN1110_CONFIG2, mask,
> promisc ? mask : 0);
> +}
> +
> +static int adin1110_setup_rx_mode(struct adin1110_port_priv
> *port_priv)
> +{
> +	int ret;
> +
> +	ret = adin1110_set_promisc_mode(port_priv, !!(port_priv-
> >flags & IFF_PROMISC));
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = adin1110_multicast_filter(port_priv,
> ADIN_MAC_MULTICAST_ADDR_SLOT,
> +					!!(port_priv->flags &
> IFF_ALLMULTI));
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = adin1110_broadcasts_filter(port_priv,
> ADIN_MAC_BROADCAST_ADDR_SLOT,
> +					 !!(port_priv->flags &
> IFF_BROADCAST));
> +	if (ret < 0)
> +		return ret;
> +
> +	return adin1110_set_bits(port_priv->priv, ADIN1110_CONFIG1,
> ADIN1110_CONFIG1_SYNC,
> +				 ADIN1110_CONFIG1_SYNC);
> +}
> +
> +static bool adin1110_can_offload_forwarding(struct adin1110_priv
> *priv)
> +{
> +	int i;
> +
> +	if (priv->cfg->id != ADIN2111_MAC)
> +		return false;
> +
> +	/* Can't enable forwarding if ports do not belong to the
> same bridge */
> +	if (priv->ports[0]->bridge != priv->ports[1]->bridge ||
> !priv->ports[0]->bridge)
> +		return false;
> +
> +	/* Can't enable forwarding if there is a port that has been
> blocked by STP */
> +	for (i = 0; i < priv->cfg->ports_nr; i++) {
> +		if (priv->ports[i]->state != BR_STATE_FORWARDING)
> +			return false;
> +	}
> +
> +	return true;
> +}
> +
> +static void adin1110_rx_mode_work(struct work_struct *work)
> +{
> +	struct adin1110_port_priv *port_priv = container_of(work,
> struct adin1110_port_priv, rx_mode_work);
> +	struct adin1110_priv *priv = port_priv->priv;
> +
> +	mutex_lock(&priv->lock);
> +	adin1110_setup_rx_mode(port_priv);
> +	mutex_unlock(&priv->lock);
> +}
> +
> +static void adin1110_set_rx_mode(struct net_device *dev)
> +{
> +	struct adin1110_port_priv *port_priv = netdev_priv(dev);
> +	struct adin1110_priv *priv = port_priv->priv;
> +
> +	spin_lock(&priv->state_lock);
> +
> +	port_priv->flags = dev->flags;
> +	schedule_work(&port_priv->rx_mode_work);
> +
> +	spin_unlock(&priv->state_lock);
> +}
> +
> +static int adin1110_net_open(struct net_device *net_dev)
> +{
> +	struct adin1110_port_priv *port_priv = netdev_priv(net_dev);
> +	struct adin1110_priv *priv = port_priv->priv;
> +	u32 val;
> +	int ret;
> +
> +	mutex_lock(&priv->lock);
> +
> +	/* Configure MAC to compute and append the FCS itself. */
> +	ret = adin1110_write_reg(priv, ADIN1110_CONFIG2,
> ADIN1110_CRC_APPEND);
> +	if (ret < 0)
> +		goto out;
> +
> +	val = ADIN1110_TX_RDY_IRQ | ADIN1110_RX_RDY_IRQ |
> ADIN1110_SPI_ERR_IRQ;
> +	if (priv->cfg->id == ADIN2111_MAC)
> +		val |= ADIN2111_RX_RDY_IRQ;
> +
> +	priv->irq_mask = val;
> +	ret = adin1110_write_reg(priv, ADIN1110_IMASK1, ~val);
> +	if (ret < 0) {
> +		netdev_err(net_dev, "Failed to enable chip IRQs:
> %d\n", ret);
> +		goto out;
> +	}
> +
> +	ret = adin1110_read_reg(priv, ADIN1110_TX_SPACE, &val);
> +	if (ret < 0) {
> +		netdev_err(net_dev, "Failed to read TX FIFO space:
> %d\n", ret);
> +		goto out;
> +	}
> +
> +	priv->tx_space = 2 * val;
> +
> +	port_priv->state = BR_STATE_FORWARDING;
> +	ret = adin1110_set_mac_address(net_dev, net_dev->dev_addr);
> +	if (ret < 0) {
> +		netdev_err(net_dev, "Could not set MAC address: %pM,
> %d\n", net_dev->dev_addr, ret);
> +		goto out;
> +	}
> +
> +	ret = adin1110_set_bits(priv, ADIN1110_CONFIG1,
> ADIN1110_CONFIG1_SYNC,
> +				ADIN1110_CONFIG1_SYNC);
> +
> +out:
> +	mutex_unlock(&priv->lock);
> +
> +	if (ret < 0)
> +		return ret;
> +
> +	phy_start(port_priv->phydev);
> +
> +	netif_start_queue(net_dev);
> +
> +	return 0;
> +}
> +
> +static int adin1110_net_stop(struct net_device *net_dev)
> +{
> +	struct adin1110_port_priv *port_priv = netdev_priv(net_dev);
> +	struct adin1110_priv *priv = port_priv->priv;
> +	u32 mask;
> +	int ret;
> +
> +	mask = !port_priv->nr ? ADIN2111_RX_RDY_IRQ :
> ADIN1110_RX_RDY_IRQ;
> +
> +	/* Disable RX RDY IRQs */
> +	mutex_lock(&priv->lock);
> +	ret = adin1110_set_bits(priv, ADIN1110_IMASK1, mask, mask);
> +	mutex_unlock(&priv->lock);
> +	if (ret < 0)
> +		return ret;
> +
> +	netif_stop_queue(port_priv->netdev);
> +	flush_work(&port_priv->tx_work);
> +	phy_stop(port_priv->phydev);
> +
> +	return 0;
> +}
> +
> +static void adin1110_tx_work(struct work_struct *work)
> +{
> +	struct adin1110_port_priv *port_priv = container_of(work,
> struct adin1110_port_priv, tx_work);
> +	struct adin1110_priv *priv = port_priv->priv;
> +	struct sk_buff *txb;
> +	int ret;
> +
> +	mutex_lock(&priv->lock);
> +
> +	while ((txb = skb_dequeue(&port_priv->txq))) {
> +		ret = adin1110_write_fifo(port_priv, txb);
> +		if (ret < 0)
> +			dev_err_ratelimited(&priv->spidev->dev,
> "Frame write error: %d\n", ret);
> +
> +		dev_kfree_skb(txb);
> +	}
> +
> +	mutex_unlock(&priv->lock);
> +}
> +
> +static netdev_tx_t adin1110_start_xmit(struct sk_buff *skb, struct
> net_device *dev)
> +{
> +	struct adin1110_port_priv *port_priv = netdev_priv(dev);
> +	struct adin1110_priv *priv = port_priv->priv;
> +	netdev_tx_t netdev_ret = NETDEV_TX_OK;
> +	u32 tx_space_needed;
> +
> +	tx_space_needed = skb->len + ADIN1110_FRAME_HEADER_LEN +
> ADIN1110_INTERNAL_SIZE_HEADER_LEN;
> +	if (tx_space_needed > priv->tx_space) {
> +		netif_stop_queue(dev);
> +		netdev_ret = NETDEV_TX_BUSY;
> +	} else {
> +		priv->tx_space -= tx_space_needed;
> +		skb_queue_tail(&port_priv->txq, skb);
> +	}
> +
> +	schedule_work(&port_priv->tx_work);
> +
> +	return netdev_ret;
> +}
> +
> +static void adin1110_ndo_get_stats64(struct net_device *dev, struct
> rtnl_link_stats64 *storage)
> +{
> +	struct adin1110_port_priv *port_priv = netdev_priv(dev);
> +
> +	storage->rx_packets = port_priv->rx_packets;
> +	storage->tx_packets = port_priv->tx_packets;
> +
> +	storage->rx_bytes = port_priv->rx_bytes;
> +	storage->tx_bytes = port_priv->tx_bytes;
> +}
> +
> +static int adin1110_port_get_port_parent_id(struct net_device *dev,
> +					    struct
> netdev_phys_item_id *ppid)
> +{
> +	struct adin1110_port_priv *port_priv = netdev_priv(dev);
> +	struct adin1110_priv *priv = port_priv->priv;
> +
> +	ppid->id_len = strnlen(priv->mii_bus_name, MII_BUS_ID_SIZE);
> +	memcpy(ppid->id, priv->mii_bus_name, ppid->id_len);
> +
> +	return 0;
> +}
> +
> +static int adin1110_ndo_get_phys_port_name(struct net_device *dev,
> char *name, size_t len)
> +{
> +	struct adin1110_port_priv *port_priv = netdev_priv(dev);
> +	int err;
> +
> +	err = snprintf(name, len, "p%d", port_priv->nr);
> +	if (err >= len)
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
> +static const struct net_device_ops adin1110_netdev_ops = {
> +	.ndo_open		= adin1110_net_open,
> +	.ndo_stop		= adin1110_net_stop,
> +	.ndo_eth_ioctl		= adin1110_ioctl,
> +	.ndo_start_xmit		= adin1110_start_xmit,
> +	.ndo_set_mac_address	= adin1110_ndo_set_mac_address,
> +	.ndo_set_rx_mode	= adin1110_set_rx_mode,
> +	.ndo_validate_addr	= eth_validate_addr,
> +	.ndo_get_stats64	= adin1110_ndo_get_stats64,
> +	.ndo_get_port_parent_id	=
> adin1110_port_get_port_parent_id,
> +	.ndo_get_phys_port_name	=
> adin1110_ndo_get_phys_port_name,
> +};
> +
> +static void adin1110_get_drvinfo(struct net_device *dev, struct
> ethtool_drvinfo *di)
> +{
> +	strscpy(di->driver, "ADIN1110", sizeof(di->driver));
> +	strscpy(di->bus_info, dev_name(dev->dev.parent), sizeof(di-
> >bus_info));
> +}
> +
> +static const struct ethtool_ops adin1110_ethtool_ops = {
> +	.get_drvinfo		= adin1110_get_drvinfo,
> +	.get_link		= ethtool_op_get_link,
> +	.get_link_ksettings	= phy_ethtool_get_link_ksettings,
> +	.set_link_ksettings	= phy_ethtool_set_link_ksettings,
> +};
> +
> +static void adin1110_adjust_link(struct net_device *dev)
> +{
> +	struct phy_device *phydev = dev->phydev;
> +
> +	if (!phydev->link)
> +		phy_print_status(phydev);
> +}
> +
> +/* PHY ID is stored in the MAC registers too, check spi connection
> by reading it */
> +static int adin1110_check_spi(struct adin1110_priv *priv)
> +{
> +	int ret;
> +	u32 val;
> +
> +	ret = adin1110_read_reg(priv, ADIN1110_PHY_ID, &val);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (val != priv->cfg->phy_id_val) {
> +		dev_err(&priv->spidev->dev, "PHY ID expected: %x,
> read: %x\n",
> +			priv->cfg->phy_id_val, val);
> +		return -EIO;
> +	}
> +
> +	return 0;
> +}
> +
> +static int adin1110_hw_forwarding(struct adin1110_priv *priv, bool
> enable)
> +{
> +	int ret;
> +	int i;
> +
> +	priv->forwarding = enable;
> +
> +	if (!priv->forwarding) {
> +		for (i = ADIN_MAC_FDB_ADDR_SLOT; i <
> ADIN_MAC_MAX_ADDR_SLOTS; i++) {
> +			ret = adin1110_clear_mac_address(priv, i);
> +			if (ret < 0)
> +				return ret;
> +		}
> +	}
> +
> +	/* Forwarding is optimised when MAC runs in Cut Through
> mode. */
> +	ret = adin1110_set_bits(priv, ADIN1110_CONFIG2,
> ADIN2111_PORT_CUT_THRU_EN,
> +				priv->forwarding ?
> ADIN2111_PORT_CUT_THRU_EN : 0);
> +	if (ret < 0)
> +		return ret;
> +
> +	for (i = 0; i < priv->cfg->ports_nr; i++) {
> +		ret = adin1110_setup_rx_mode(priv->ports[i]);
> +		if (ret < 0)
> +			return ret;
> +	}
> +
> +	return ret;
> +}
> +
> +static int adin1110_port_bridge_join(struct adin1110_port_priv
> *port_priv,
> +				     struct net_device *bridge)
> +{
> +	struct adin1110_priv *priv = port_priv->priv;
> +	int ret;
> +
> +	port_priv->bridge = bridge;
> +
> +	if (adin1110_can_offload_forwarding(priv)) {
> +		mutex_lock(&priv->lock);
> +		ret = adin1110_hw_forwarding(priv, true);
> +		mutex_unlock(&priv->lock);
> +
> +		if (ret < 0)
> +			return ret;
> +	}
> +
> +	return adin1110_set_mac_address(port_priv->netdev, bridge-
> >dev_addr);
> +}
> +
> +static int adin1110_port_bridge_leave(struct adin1110_port_priv
> *port_priv,
> +				      struct net_device *bridge)
> +{
> +	struct adin1110_priv *priv = port_priv->priv;
> +	int ret;
> +
> +	port_priv->bridge = NULL;
> +
> +	mutex_lock(&priv->lock);
> +	ret = adin1110_hw_forwarding(priv, false);
> +	mutex_unlock(&priv->lock);
> +
> +	return ret;
> +}
> +
> +static int adin1110_netdevice_event(struct notifier_block *unused,
> unsigned long event, void *ptr)
> +{
> +	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
> +	struct adin1110_port_priv *port_priv = netdev_priv(dev);
> +	struct netdev_notifier_changeupper_info *info = ptr;
> +	int ret = 0;
> +
> +	switch (event) {
> +	case NETDEV_CHANGEUPPER:
> +		if (netif_is_bridge_master(info->upper_dev)) {
> +			if (info->linking)
> +				ret =
> adin1110_port_bridge_join(port_priv, info->upper_dev);
> +			else
> +				ret =
> adin1110_port_bridge_leave(port_priv, info->upper_dev);
> +		}
> +		break;
> +	default:
> +		break;
> +	}
> +
> +	return notifier_from_errno(ret);
> +}
> +
> +static struct notifier_block adin1110_netdevice_nb = {
> +	.notifier_call = adin1110_netdevice_event,
> +};
> +
> +static void adin1110_disconnect_phy(void *data)
> +{
> +	phy_disconnect(data);
> +}
> +
> +static bool adin1110_port_dev_check(const struct net_device *dev)
> +{
> +	return dev->netdev_ops == &adin1110_netdev_ops;
> +}
> +
> +static int adin1110_port_set_forwarding_state(struct
> adin1110_port_priv *port_priv)
> +{
> +	struct adin1110_priv *priv = port_priv->priv;
> +	int ret;
> +
> +	port_priv->state = BR_STATE_FORWARDING;
> +
> +	mutex_lock(&priv->lock);
> +	ret = adin1110_set_mac_address(port_priv->netdev, port_priv-
> >netdev->dev_addr);
> +	if (ret < 0)
> +		goto out;
> +
> +	if (adin1110_can_offload_forwarding(priv))
> +		ret = adin1110_hw_forwarding(priv, true);
> +	else
> +		ret = adin1110_setup_rx_mode(port_priv);
> +out:
> +	mutex_unlock(&priv->lock);
> +
> +	return ret;
> +}
> +
> +static int adin1110_port_set_blocking_state(struct
> adin1110_port_priv *port_priv)
> +{
> +	u8 mac[ETH_ALEN] = {0x01, 0x80, 0xC2, 0x00, 0x00, 0x00};
> +	struct adin1110_priv *priv = port_priv->priv;
> +	u8 mask[ETH_ALEN];
> +	u32 port_rules;
> +	int mac_slot;
> +	int ret;
> +
> +	port_priv->state = BR_STATE_BLOCKING;
> +
> +	mutex_lock(&priv->lock);
> +
> +	mac_slot = (!port_priv->nr) ?  ADIN_MAC_P1_ADDR_SLOT :
> ADIN_MAC_P2_ADDR_SLOT;
> +	ret = adin1110_clear_mac_address(priv, mac_slot);
> +	if (ret < 0)
> +		goto out;
> +
> +	ret = adin1110_hw_forwarding(priv, false);
> +	if (ret < 0)
> +		return ret;

Should be:
		goto out;

or it will leave the mutex locked.

> +
> +	/* Allow only BPDUs to be passed to the CPU */
> +	memset(mask, 0xFF, ETH_ALEN);
> +	port_rules = adin1110_port_rules(port_priv, true, false);
> +	ret = adin1110_write_mac_address(port_priv, mac_slot, mac,
> mask, port_rules);
> +out:
> +	mutex_unlock(&priv->lock);
> +
> +	return ret;
> +}
> +
> +/* ADIN1110/2111 does not have any native STP support. Listen for
> bridge core state changes and
> + * allow all frames to pass or only the BPDUs.
> + */
> +static int adin1110_port_attr_stp_state_set(struct
> adin1110_port_priv *port_priv, u8 state)
> +{
> +	switch (state) {
> +	case BR_STATE_FORWARDING:
> +		return
> adin1110_port_set_forwarding_state(port_priv);
> +	case BR_STATE_LEARNING:
> +	case BR_STATE_LISTENING:
> +	case BR_STATE_DISABLED:
> +	case BR_STATE_BLOCKING:
> +		return adin1110_port_set_blocking_state(port_priv);
> +	default:
> +		return -EINVAL;
> +	}
> +}
> +
> +static int adin1110_port_attr_set(struct net_device *dev, const void
> *ctx,
> +				  const struct switchdev_attr *attr,
> +				  struct netlink_ext_ack *extack)
> +{
> +	struct adin1110_port_priv *port_priv = netdev_priv(dev);
> +
> +	switch (attr->id) {
> +	case SWITCHDEV_ATTR_ID_PORT_STP_STATE:
> +		return adin1110_port_attr_stp_state_set(port_priv,
> attr->u.stp_state);
> +	default:
> +		return -EOPNOTSUPP;
> +	}
> +}
> +
> +static int adin1110_switchdev_blocking_event(struct notifier_block
> *unused, unsigned long event,
> +					     void *ptr)
> +{
> +	struct net_device *netdev =
> switchdev_notifier_info_to_dev(ptr);
> +	int ret;
> +
> +	if (event == SWITCHDEV_PORT_ATTR_SET) {
> +		ret = switchdev_handle_port_attr_set(netdev, ptr,
> adin1110_port_dev_check,
> +						    
> adin1110_port_attr_set);
> +
> +		return notifier_from_errno(ret);
> +	}
> +
> +	return NOTIFY_DONE;
> +}
> +
> +static struct notifier_block adin1110_switchdev_blocking_notifier =
> {
> +	.notifier_call = adin1110_switchdev_blocking_event,
> +};
> +
> +static void adin1110_fdb_offload_notify(struct net_device *netdev,
> +					struct
> switchdev_notifier_fdb_info *rcv)
> +{
> +	struct switchdev_notifier_fdb_info info = {};
> +
> +	info.addr = rcv->addr;
> +	info.vid = rcv->vid;
> +	info.offloaded = true;
> +	call_switchdev_notifiers(SWITCHDEV_FDB_OFFLOADED, netdev,
> &info.info, NULL);
> +}
> +
> +static int adin1110_fdb_add(struct adin1110_port_priv *port_priv,
> +			    struct switchdev_notifier_fdb_info *fdb)
> +{
> +	struct adin1110_priv *priv = port_priv->priv;
> +	struct adin1110_port_priv *other_port;
> +	u8 mask[ETH_ALEN];
> +	u32 port_rules;
> +	int mac_nr;
> +	u32 val;
> +	int ret;
> +
> +	netdev_dbg(port_priv->netdev,
> +		   "DEBUG: %s: MACID = %pM vid = %u flags = %u %u --
> port %d\n", __func__,
> +		   fdb->addr, fdb->vid, fdb->added_by_user, fdb-
> >offloaded, port_priv->nr);
> +
> +	if (!priv->forwarding)
> +		return 0;
> +
> +	if (fdb->is_local)
> +		return -EINVAL;
> +
> +	/* Find free FDB slot on device. */
> +	for (mac_nr = ADIN_MAC_FDB_ADDR_SLOT; mac_nr <
> ADIN_MAC_MAX_ADDR_SLOTS; mac_nr++) {
> +		ret = adin1110_read_reg(priv,
> ADIN1110_MAC_ADDR_FILTER_UPR + (mac_nr * 2), &val);
> +		if (ret < 0)
> +			return ret;
> +		if (!val)
> +			break;
> +	}
> +
> +	if (mac_nr == ADIN_MAC_MAX_ADDR_SLOTS)
> +		return -ENOMEM;
> +
> +	other_port = priv->ports[!port_priv->nr];
> +	port_rules = adin1110_port_rules(port_priv, false, true);
> +	memset(mask, 0xFF, ETH_ALEN);
> +
> +	return adin1110_write_mac_address(other_port, mac_nr, (u8
> *)fdb->addr, mask, port_rules);
> +}
> +
> +static int adin1110_read_mac(struct adin1110_priv *priv, int mac_nr,
> u8 *addr)
> +{
> +	u32 val;
> +	int ret;
> +
> +	ret = adin1110_read_reg(priv, ADIN1110_MAC_ADDR_FILTER_UPR +
> (mac_nr * 2), &val);
> +	if (ret < 0)
> +		return ret;
> +
> +	put_unaligned_be16(val, addr);
> +
> +	ret = adin1110_read_reg(priv, ADIN1110_MAC_ADDR_FILTER_LWR +
> (mac_nr * 2), &val);
> +	if (ret < 0)
> +		return ret;
> +
> +	put_unaligned_be32(val, addr + 2);
> +
> +	return 0;
> +}
> +
> +static int adin1110_fdb_del(struct adin1110_port_priv *port_priv,
> +			    struct switchdev_notifier_fdb_info *fdb)
> +{
> +	struct adin1110_priv *priv = port_priv->priv;
> +	u8 addr[ETH_ALEN];
> +	int mac_nr;
> +	int ret;
> +
> +	netdev_dbg(port_priv->netdev,
> +		   "DEBUG: %s: MACID = %pM vid = %u flags = %u %u --
> port %d\n", __func__,
> +		   fdb->addr, fdb->vid, fdb->added_by_user, fdb-
> >offloaded, port_priv->nr);
> +
> +	if (fdb->is_local)
> +		return -EINVAL;
> +
> +	for (mac_nr = ADIN_MAC_FDB_ADDR_SLOT; mac_nr <
> ADIN_MAC_MAX_ADDR_SLOTS; mac_nr++) {
> +		ret = adin1110_read_mac(priv, mac_nr, addr);
> +		if (ret < 0)
> +			return ret;
> +
> +		if (ether_addr_equal(addr, fdb->addr)) {
> +			ret = adin1110_clear_mac_address(priv,
> mac_nr);
> +			if (ret < 0)
> +				return ret;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static void adin1110_switchdev_event_work(struct work_struct *work)
> +{
> +	struct adin1110_switchdev_event_work *switchdev_work;
> +	struct adin1110_port_priv *port_priv;
> +	int ret;
> +
> +	switchdev_work = container_of(work, struct
> adin1110_switchdev_event_work, work);
> +	port_priv = switchdev_work->port_priv;
> +
> +	mutex_lock(&port_priv->priv->lock);
> +
> +	switch (switchdev_work->event) {
> +	case SWITCHDEV_FDB_ADD_TO_DEVICE:
> +		ret = adin1110_fdb_add(port_priv, &switchdev_work-
> >fdb_info);
> +		if (!ret)
> +			adin1110_fdb_offload_notify(port_priv-
> >netdev, &switchdev_work->fdb_info);
> +		break;
> +	case SWITCHDEV_FDB_DEL_TO_DEVICE:
> +		adin1110_fdb_del(port_priv, &switchdev_work-
> >fdb_info);
> +		break;
> +	default:
> +		break;
> +	}
> +
> +	mutex_unlock(&port_priv->priv->lock);
> +
> +	kfree(switchdev_work->fdb_info.addr);
> +	kfree(switchdev_work);
> +	dev_put(port_priv->netdev);
> +}
> +
> +/* called under rcu_read_lock() */
> +static int adin1110_switchdev_event(struct notifier_block *unused,
> unsigned long event, void *ptr)
> +{
> +	struct net_device *netdev =
> switchdev_notifier_info_to_dev(ptr);
> +	struct adin1110_port_priv *port_priv = netdev_priv(netdev);
> +	struct adin1110_switchdev_event_work *switchdev_work;
> +	struct switchdev_notifier_fdb_info *fdb_info = ptr;
> +
> +	if (!adin1110_port_dev_check(netdev))
> +		return NOTIFY_DONE;
> +
> +	switchdev_work = kzalloc(sizeof(*switchdev_work),
> GFP_ATOMIC);
> +	if (WARN_ON(!switchdev_work))
> +		return NOTIFY_BAD;
> +
> +	INIT_WORK(&switchdev_work->work,
> adin1110_switchdev_event_work);
> +	switchdev_work->port_priv = port_priv;
> +	switchdev_work->event = event;
> +
> +	switch (event) {
> +	case SWITCHDEV_FDB_ADD_TO_DEVICE:
> +	case SWITCHDEV_FDB_DEL_TO_DEVICE:
> +		memcpy(&switchdev_work->fdb_info, ptr,
> sizeof(switchdev_work->fdb_info));
> +		switchdev_work->fdb_info.addr = kzalloc(ETH_ALEN,
> GFP_ATOMIC);
> +
> +		if (!switchdev_work->fdb_info.addr)
> +			goto err_addr_alloc;
> +
> +		ether_addr_copy((u8 *)switchdev_work->fdb_info.addr,
> fdb_info->addr);
> +		dev_hold(netdev);
> +		break;
> +	default:
> +		kfree(switchdev_work);
> +		return NOTIFY_DONE;
> +	}
> +
> +	queue_work(system_long_wq, &switchdev_work->work);
> +
> +	return NOTIFY_DONE;
> +
> +err_addr_alloc:
> +	kfree(switchdev_work);
> +	return NOTIFY_BAD;
> +}
> +
> +static struct notifier_block adin1110_switchdev_notifier = {
> +	.notifier_call = adin1110_switchdev_event,
> +};
> +
> +static void adin1110_unregister_notifiers(void *data)
> +{
> +	unregister_switchdev_blocking_notifier(&adin1110_switchdev_b
> locking_notifier);
> +	unregister_switchdev_notifier(&adin1110_switchdev_notifier);
> +	unregister_netdevice_notifier(&adin1110_netdevice_nb);
> +}
> +
> +static int adin1110_setup_notifiers(struct adin1110_priv *priv)
> +{
> +	struct device *dev = &priv->spidev->dev;
> +	int ret;
> +
> +	ret = register_netdevice_notifier(&adin1110_netdevice_nb);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret =
> register_switchdev_notifier(&adin1110_switchdev_notifier);
> +	if (ret < 0) {

the preferred style would be
		goto err_netdev;

> +		unregister_netdevice_notifier(&adin1110_netdevice_nb
> );
> +		return ret;
> +	}
> +
> +	ret =
> register_switchdev_blocking_notifier(&adin1110_switchdev_blocking_not
> ifier);
> +	if (ret < 0) {

here:
		goto err_sdev;

> +		unregister_netdevice_notifier(&adin1110_netdevice_nb
> );
> +		unregister_switchdev_notifier(&adin1110_switchdev_no
> tifier);
> +		return ret;
> +	}
> +
> +	return devm_add_action_or_reset(dev,
> adin1110_unregister_notifiers, NULL);

err_sdev:
	unregister_switchdev_notifier(&adin1110_switchdev_notifier);

err_netdev:
	unregister_netdevice_notifier(&adin1110_netdevice_nb);
	return ret;

[...]

Many lines exceed the 80 chars boundaries, even if it's not a strict
limit, you could try to fit it a little more, e.g. reducing the
indentation level where possible and relevant and/or truncating the
longest line.

Thanks!

Paolo


