Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F06F691D3C
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 11:50:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232214AbjBJKun (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 05:50:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232207AbjBJKul (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 05:50:41 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C50436FE83;
        Fri, 10 Feb 2023 02:50:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Z1JvU2F5mmSgJkdjazjKaoYsiFRpf2xh0spIxIuuqDU=; b=DCim+ODrqaJj7syeAN7iDH8mia
        f1qyyYxCydLfnBS+ekKoNcCcuinpc/tQ+DXXs3gUXu1NKQtajfYV9ikEMUgsdk1ERja5Q0gTI57GP
        b6p7smOwRS/uOAJ+1mlc/1ycgDprZE/5KfUrVo6Hg5wrLfKgGH3nfOlSw5HrMEwNaux7QqYQrgHmP
        2mLXLa5SckienhHEPW9WbhQWIIge7WBaKa8nWITIBPZ/2YkRfhu+W1kXvaipJQH/+oQoQThQ3mdCb
        OehSdCtjo9u2P21pzSBy54+yzJZb8NFxu8TgkeklepL5Z0vnwHRPJksCZxbUqbG0V9+w3P5Iy1468
        HSnCkvGg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:36508)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pQQzD-0001KG-BU; Fri, 10 Feb 2023 10:50:35 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pQQz9-0005Vr-MD; Fri, 10 Feb 2023 10:50:31 +0000
Date:   Fri, 10 Feb 2023 10:50:31 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        John Crispin <john@phrozen.org>, Felix Fietkau <nbd@nbd.name>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Jianhui Zhao <zhaojh329@gmail.com>,
        =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Subject: Re: [PATCH v2 09/11] net: pcs: add driver for MediaTek SGMII PCS
Message-ID: <Y+Yhd2Hou/kZkU1o@shell.armlinux.org.uk>
References: <cover.1675779094.git.daniel@makrotopia.org>
 <20bcf972bc1b27ad14977a235292ef47443a7043.1675779094.git.daniel@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20bcf972bc1b27ad14977a235292ef47443a7043.1675779094.git.daniel@makrotopia.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 07, 2023 at 02:23:08PM +0000, Daniel Golle wrote:
> +config PCS_MTK_LYNXI
> +	tristate
> +	select PHYLINK

Does this need to select PHYLINK? If the user of this doesn't already
select phylink, then phylink_create() won't be called and thus trying
to use PCS_MTK_LYNXI becomes impossible. I know PCS_XPCS does, none of
the others do though.

> +	select REGMAP
> +	help
> +	  This module provides helpers to phylink for managing the LynxI PCS
> +	  which is part of MediaTek's SoC and Ethernet switch ICs.
> +
>  config PCS_RZN1_MIIC
>  	tristate "Renesas RZ/N1 MII converter"
>  	depends on OF && (ARCH_RZN1 || COMPILE_TEST)
> diff --git a/drivers/net/pcs/Makefile b/drivers/net/pcs/Makefile
> index 4c780d8f2e98..9b9afd6b1c22 100644
> --- a/drivers/net/pcs/Makefile
> +++ b/drivers/net/pcs/Makefile
> @@ -5,5 +5,6 @@ pcs_xpcs-$(CONFIG_PCS_XPCS)	:= pcs-xpcs.o pcs-xpcs-nxp.o
>  
>  obj-$(CONFIG_PCS_XPCS)		+= pcs_xpcs.o
>  obj-$(CONFIG_PCS_LYNX)		+= pcs-lynx.o
> +obj-$(CONFIG_PCS_MTK_LYNXI)	+= pcs-mtk-lynxi.o
>  obj-$(CONFIG_PCS_RZN1_MIIC)	+= pcs-rzn1-miic.o
>  obj-$(CONFIG_PCS_ALTERA_TSE)	+= pcs-altera-tse.o
> diff --git a/drivers/net/pcs/pcs-mtk-lynxi.c b/drivers/net/pcs/pcs-mtk-lynxi.c
> new file mode 100644
> index 000000000000..0100def53d45
> --- /dev/null
> +++ b/drivers/net/pcs/pcs-mtk-lynxi.c
> @@ -0,0 +1,315 @@
> +// SPDX-License-Identifier: GPL-2.0
> +// Copyright (c) 2018-2019 MediaTek Inc.
> +/* A library for MediaTek SGMII circuit
> + *
> + * Author: Sean Wang <sean.wang@mediatek.com>
> + * Author: Daniel Golle <daniel@makrotopia.org>
> + *
> + */
> +#include <linux/mdio.h>
> +#include <linux/phylink.h>
> +#include <linux/pcs/pcs-mtk-lynxi.h>
> +#include <linux/of.h>
> +#include <linux/phylink.h>
> +#include <linux/regmap.h>
> +
> +/* SGMII subsystem config registers */
> +/* BMCR (low 16) BMSR (high 16) */
> +#define SGMSYS_PCS_CONTROL_1		0x0
> +#define SGMII_BMCR			GENMASK(15, 0)
> +#define SGMII_BMSR			GENMASK(31, 16)
> +#define SGMII_AN_RESTART		BIT(9)
> +#define SGMII_ISOLATE			BIT(10)
> +#define SGMII_AN_ENABLE			BIT(12)

Not really a review comment but a question: would it be sensible to
define these as:

#define SGMII_AN_RESTART		BMCR_ANRESTART

etc, since they follow the IEEE802.3 clause 22 register layout?

> +#define SGMII_LINK_STATYS		BIT(18)
> +#define SGMII_AN_ABILITY		BIT(19)
> +#define SGMII_AN_COMPLETE		BIT(21)

These also correspond to BMSR bits (<<16).

> +#define SGMII_PCS_FAULT			BIT(23)
> +#define SGMII_AN_EXPANSION_CLR		BIT(30)

This define doesn't seem to be used.

> +
> +#define SGMSYS_PCS_DEVICE_ID		0x4
> +#define SGMII_LYNXI_DEV_ID		0x4d544950
> +
> +#define SGMSYS_PCS_ADVERTISE		0x8
> +#define SGMII_ADVERTISE			GENMASK(15, 0)
> +#define SGMII_LPA			GENMASK(31, 16)
> +
> +#define SGMSYS_PCS_SCRATCH		0x14
> +#define SGMII_DEV_VERSION		GENMASK(31, 16)
> +
> +/* Register to programmable link timer, the unit in 2 * 8ns */
> +#define SGMSYS_PCS_LINK_TIMER		0x18
> +#define SGMII_LINK_TIMER_MASK		GENMASK(19, 0)
> +#define SGMII_LINK_TIMER_DEFAULT	(0x186a0 & SGMII_LINK_TIMER_MASK)

We no longer make use of SGMII_LINK_TIMER_DEFAULT, so this can be
removed.

> +
> +/* Register to control remote fault */
> +#define SGMSYS_SGMII_MODE		0x20
> +#define SGMII_IF_MODE_SGMII		BIT(0)
> +#define SGMII_SPEED_DUPLEX_AN		BIT(1)
> +#define SGMII_SPEED_MASK		GENMASK(3, 2)
> +#define SGMII_SPEED_10			FIELD_PREP(SGMII_SPEED_MASK, 0)
> +#define SGMII_SPEED_100			FIELD_PREP(SGMII_SPEED_MASK, 1)
> +#define SGMII_SPEED_1000		FIELD_PREP(SGMII_SPEED_MASK, 2)
> +#define SGMII_DUPLEX_HALF		BIT(4)
> +#define SGMII_REMOTE_FAULT_DIS		BIT(8)

> +#define SGMII_CODE_SYNC_SET_VAL		BIT(9)
> +#define SGMII_CODE_SYNC_SET_EN		BIT(10)
> +#define SGMII_SEND_AN_ERROR_EN		BIT(11)

These three don't appear to be used.

> +
> +/* Register to reset SGMII design */
> +#define SGMII_RESERVED_0		0x34
> +#define SGMII_SW_RESET			BIT(0)
> +
> +/* Register to set SGMII speed, ANA RG_ Control Signals III */
> +#define SGMSYS_ANA_RG_CS3		0x2028

SGMSYS_ANA_RG_CS3 isn't used here, although its register bits below
are.

> +#define RG_PHY_SPEED_MASK		(BIT(2) | BIT(3))
> +#define RG_PHY_SPEED_1_25G		0x0
> +#define RG_PHY_SPEED_3_125G		BIT(2)
> +

...

> +struct mtk_pcs_lynxi {
> +	struct regmap		*regmap;
> +	struct device		*dev;

I can only find one place that this is written to in this patch, it
seems its otherwise never used. Do we need it?

Other than that, I don't see anything else to comment on that hasn't
been mentioned in previous patches. Thanks!

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
