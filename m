Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6E916D311A
	for <lists+netdev@lfdr.de>; Sat,  1 Apr 2023 15:41:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbjDANln (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Apr 2023 09:41:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229983AbjDANlm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Apr 2023 09:41:42 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2056.outbound.protection.outlook.com [40.107.6.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECD9F22223;
        Sat,  1 Apr 2023 06:41:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dj4UMupHGe2pIaUJKBayYEg4h8CcV+CjDAeq9o2Xi2svtGymkh4zFLQG9lsGO8HaErOUQhR575c/T+Hre8j6aUT/RuHvyfcu14kt7vbCHaOrf+l1BcCsAh4YjIu6z+xnBJIOQmlKdn2p8UCMJmjZQoIgu8StHcdqFPFhnCz0TCyxdx8SxaCc76EsM6pJeJyURskU8lb7xpStBnGAWjebuCy/nS+C6NY28Xaoc0KycS7L4KuHWaU2Wd8HhYKG0HS2kDyW9S3uv3jSgwWG/BZvdeFAeSVi2znyhhmSyEf7MCEIrIwOd3bWqnBrugPoCJJdTZjUZRMAHQ9wuRNbPtRyBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MfVwofElVSHealPJE8cMS/2K/lJrWT/CXUco4T9QdZg=;
 b=E0qrG/pmcncpC9m/6aXKoiDauwK19c4XGP1D5GQ8PIVDqHOa26tE5KXChKXuqvANSlwjti/Hoft+xiLD/EfE8jc6xjpTsZwcfq5lQaHYsoefH0aAc0yzUFhGWuE7WW0cWImGqjVd35rqISTM0b+Cb2eNAMUSlgCGoP9oAESd+hDKO1fjGu7fiYfuKgjakamTOT6O1cPQUefjJ7x743Ob8Ntil42f0pCBkn+KYw657VKnquTEX11OuQZJX0YM/uiy104hc2DIbkHVdaSsQsl9Vn5+6tmy7DQGYPx5ma4gP/kPxeeK2AbgJbdwR8CqLKTIqPESq0jhLX7Q/qCa/4j76g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MfVwofElVSHealPJE8cMS/2K/lJrWT/CXUco4T9QdZg=;
 b=rLhBzOTu673AOZKP+kb6l3qc+74xCTOmfXJ0N33WKoB5e5OOb8/Y5//qwUhLZuktHexB68AAxCOzWH+gpWLljMyuyGofr9LChHrtGUUQphbiIupTOPELzIibBELcN3BimxOZ+jvrTFO8EkhLSXnaBSzImbtYCG0YS3QrHZGIcKg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by PA4PR04MB9488.eurprd04.prod.outlook.com (2603:10a6:102:2af::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.26; Sat, 1 Apr
 2023 13:41:34 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5%3]) with mapi id 15.20.6254.026; Sat, 1 Apr 2023
 13:41:34 +0000
Date:   Sat, 1 Apr 2023 16:41:29 +0300
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc:     Mark Brown <broonie@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        rafael@kernel.org, Colin Foster <colin.foster@in-advantage.com>,
        Lee Jones <lee@kernel.org>, davem@davemloft.net,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        thomas.petazzoni@bootlin.com
Subject: Re: [RFC 5/7] net: mdio: Introduce a regmap-based mdio driver
Message-ID: <20230401134129.txnxhl4sckkmziz7@skbuf>
References: <20230324093644.464704-1-maxime.chevallier@bootlin.com>
 <20230324093644.464704-6-maxime.chevallier@bootlin.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230324093644.464704-6-maxime.chevallier@bootlin.com>
X-ClientProxiedBy: VI1PR07CA0206.eurprd07.prod.outlook.com
 (2603:10a6:802:3f::30) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|PA4PR04MB9488:EE_
X-MS-Office365-Filtering-Correlation-Id: 28ea11f6-0ba6-48a3-77f8-08db32b6cedf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fG7LZW+dADguut5Fr3jQHzIP5+vjZcw0sdiIgMb96PDIwkocb7wD/CVF0q1soRu34+F96o/OY/MpKWwPWTMKmOuBpZV6Rb6BwT3hJHa8RNHEay9cJqIDvO//Tt+Aa/+aURmAEOW9zzF00XScvpksYa7qVnssNKtfyxqg08H+oCcH/Mx/7Q3H6+PeYNO+/+1eeQV23kfwISQYikHAEjwwf5UcZWYTB46H+ptrrLu+J/GFO0kfxSolLSbSBLukPU3APv/lEgOexZ3Gf7AmHXZTjAn0m/Lo8XH7pHB2YveCP/eS18nh//bB8T3NgtiUG7cUEzvq2vfvsfmJ/gOt/q7fCM0RdetBe6AeIdifz9kpqCnW8GdjixkAkQqy9hhc+kNGKaThEsLlv7Q/XrtwcZL2aW4k8eun6V/d1oHdg9pA4pmLLhO1AiW8eytnlREwhpMxknYDm2x5WFr9e2y9fdyVnZlETkpW+oBGqAlSU4h3g0GHHIR/YaSudz91WFL0StnKwL7dXZqCWi9u9zV4dLCEEnHq6K73AASfDqIC+MFFGaeLHKN4Cd8DsrllFo8bLQlN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(376002)(346002)(366004)(39860400002)(396003)(136003)(451199021)(186003)(316002)(4326008)(6916009)(8676002)(66946007)(66556008)(66476007)(83380400001)(54906003)(478600001)(8936002)(6666004)(41300700001)(6486002)(44832011)(7416002)(2906002)(5660300002)(1076003)(6506007)(6512007)(9686003)(38100700002)(26005)(86362001)(33716001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JXuKC5vk61z6ALN6nvVYrt+P7XVTVU01bmviBCmKrX7f3or8VtUtXRB6lPF1?=
 =?us-ascii?Q?eF3H40bypEde04olfzqIWBh7ACI9ixloglm+U2+QnGVkdT2b3+sqbgqJY500?=
 =?us-ascii?Q?f6+PPT2QegntFMy6H6EVRViD/7KKDQ+ysH537AXFjmKTiyA4E9f3NXGHTQJ0?=
 =?us-ascii?Q?ZpEasRiHZytVHKcMX0yTx8NuVSlgaaOoswNfrhZdgV6HoLHQRl8YZZ8MecYx?=
 =?us-ascii?Q?6M1NcUrpa8PeagSMk749Vozq9qDzM/902F8seM1kCw421tNPSu3T0mVn71B4?=
 =?us-ascii?Q?8N2MZW81VmuedpcjznfeIq9eQvxuIhnXWmxSlX6+TtQ1+h6q6YgV66ltBOCq?=
 =?us-ascii?Q?MCMugM7BN4GynynW+300tbfr/JRvemRmln0o3wXqzU6nUjguX5r8cxm9D3rb?=
 =?us-ascii?Q?gNoHJVbIOTRQQzkSap4Y1dRp6d+zBuPu6u2vD9LvUlDUuhixtx2K15kMNerg?=
 =?us-ascii?Q?+eZb/mmt22UwkwNBZPaXyyTiZVfJAR1ybNnfx55OHiR+EahUq6moSkIH9dQi?=
 =?us-ascii?Q?GKs163KusJvNQik5d4jLIKOe0RZ1Ci/Bk1fqYcNTKCu0Hlvfci6/9/GzZ8fn?=
 =?us-ascii?Q?P+n7cqxug+36EngRoX0ttCmcImv9DMg85nttbWsvgeQWLHj57egchYw62QS3?=
 =?us-ascii?Q?qCdkxGfo8g4gx8RdrXzuKj0+0/nyagQDJeGvpOkUM/40CoyWw0iZHBwn5ywl?=
 =?us-ascii?Q?5Xu2bq/U9Vklg68HEH+ByonjUcJysRqFYL52MkyiouTtDDN312uP+SeeD2qa?=
 =?us-ascii?Q?53p8AE4Gi5SfI14UFCT0/jldqWbQ9G113T103uXYa5l5mixT6ZI9bGtFs5i1?=
 =?us-ascii?Q?v7xaqLeIMNwirjvZ4e5milP1/uzQ7+/FCPYZboTRg2odRcXAGaqh429cazFz?=
 =?us-ascii?Q?5WSHNgedn5PLUXsGQ1m8B+qqkSOiI+hNdVGo9a+chG4zfviSFdAyViW5M45Z?=
 =?us-ascii?Q?k9YJT+DKHeF1hLrw0jlLJ0Z41Y7Ifeg6Kyh7IBf7sCz8v+78LQAutNkomr3g?=
 =?us-ascii?Q?PeDgCzhsdEdWcodDN82ndR+CzVEipHVRPMxh53LQKTfe6oWlzPA4MvC3uU50?=
 =?us-ascii?Q?tzv82dr9S6yZah89Kgckp9vAOtgNsUDTCrz5nZ6/HxZSx2xVssGe4kiD55ch?=
 =?us-ascii?Q?yMj7QhoAw98cK36JFpqmsWsqPpr4HsSNQwvnrWwQXJS5gCSCm0MfAF1aCfYK?=
 =?us-ascii?Q?t1keWVuK4DrmJDoh32sY6+OxS5pFnljsjh2T74t82k6QECpbPLYDyJTpc0QK?=
 =?us-ascii?Q?CQJrTYJggO0J7h3bg0vph2DyXbutL3+4ZbEIIPftp/Ofd5SZ40kuJNemIgsx?=
 =?us-ascii?Q?uTmlfQAyB84LsZ4WT5E1ZqdPa2QAE6ITRkzyQ8vUWyfThBo86sfw6ZqhUKH+?=
 =?us-ascii?Q?/3T3f9sXWLMa6ZApsMe7pPE7Y2hgZS3KU5hCiaxUZcVEKZd6YQqjwa/L1Gls?=
 =?us-ascii?Q?Idv/0GHuJvoIdmCk3iVa72LJfDfXr7RTisNS0OGKwo/6V68O9NCrmqXV0/8h?=
 =?us-ascii?Q?zSrbuqjFf6QcT4PMK9NKIdrNA/xojOYnOVZrYjtxDuWEfKEov7uGiDuToa8O?=
 =?us-ascii?Q?tHfV+d89yRg4O/BQg6PU21jNteOLaMF6UIZfuVkLcoNXUkT6/rJW5dKZth2Z?=
 =?us-ascii?Q?iw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28ea11f6-0ba6-48a3-77f8-08db32b6cedf
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2023 13:41:34.1725
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SIj/JkErVTe8v1R0ypYaIjFvIBjDZ5glB/NT9bsew36/HtSFKN9d2sNNomxZsINvc7Z9aO7ehTyd9Wez5dNIfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB9488
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Maxime,

On Fri, Mar 24, 2023 at 10:36:42AM +0100, Maxime Chevallier wrote:
> There exists several examples today of devices that embed an ethernet
> PHY or PCS directly inside an SoC. In this situation, either the device
> is controlled through a vendor-specific register set, or sometimes
> exposes the standard 802.3 registers that are typically accessed over
> MDIO.
> 
> As phylib and phylink are designed to use mdiodevices, this driver
> allows creating a virtual MDIO bus, that translates mdiodev register
> accesses to regmap accesses.
> 
> The reason we use regmap is because there are at least 3 such devices
> known today, 2 of them are Altera TSE PCS's, memory-mapped, exposed
> with a 4-byte stride in stmmac's dwmac-socfpga variant, and a 2-byte
> stride in altera-tse. The other one (nxp,sja1110-base-tx-mdio) is
> exposed over SPI.
> 
> Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
> ---
>  MAINTAINERS                      |  7 +++
>  drivers/net/mdio/Kconfig         | 11 +++++
>  drivers/net/mdio/Makefile        |  1 +
>  drivers/net/mdio/mdio-regmap.c   | 85 ++++++++++++++++++++++++++++++++
>  include/linux/mdio/mdio-regmap.h | 25 ++++++++++
>  5 files changed, 129 insertions(+)
>  create mode 100644 drivers/net/mdio/mdio-regmap.c
>  create mode 100644 include/linux/mdio/mdio-regmap.h
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 8d5bc223f305..10b3a1800e0d 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -12751,6 +12751,13 @@ F:	Documentation/devicetree/bindings/net/ieee802154/mcr20a.txt
>  F:	drivers/net/ieee802154/mcr20a.c
>  F:	drivers/net/ieee802154/mcr20a.h
>  
> +MDIO REGMAP DRIVER
> +M:	Maxime Chevallier <maxime.chevallier@bootlin.com>
> +L:	netdev@vger.kernel.org
> +S:	Maintained
> +F:	drivers/net/mdio/mdio-regmap.c
> +F:	include/linux/mdio/mdio-regmap.h
> +
>  MEASUREMENT COMPUTING CIO-DAC IIO DRIVER
>  M:	William Breathitt Gray <william.gray@linaro.org>
>  L:	linux-iio@vger.kernel.org
> diff --git a/drivers/net/mdio/Kconfig b/drivers/net/mdio/Kconfig
> index 90309980686e..671e4bb82e3e 100644
> --- a/drivers/net/mdio/Kconfig
> +++ b/drivers/net/mdio/Kconfig
> @@ -182,6 +182,17 @@ config MDIO_IPQ8064
>  	  This driver supports the MDIO interface found in the network
>  	  interface units of the IPQ8064 SoC
>  
> +config MDIO_REGMAP
> +	tristate "Regmap-based virtual MDIO bus driver"

IMO this shouldn't have the text visible to the Kconfig user (just
"tristate"); it should only be selectable by the driver which makes use
of the exported symbol.

AFAIK, Kconfig options which are selectable should not depend on
anything. The dependency should transfer to the options which selects
it (here REGMAP). Optionally there can be a comment specifying that the

> +	depends on REGMAP
> +	help
> +	  This driver allows using MDIO devices that are not sitting on a
> +	  regular MDIO bus, but still exposes the standard 802.3 register
> +	  layout. It's regmap-based so that it can be used on integrated,
> +	  memory-mapped PHYs, SPI PHYs and so on. A new virtual MDIO bus is
> +	  created, and its read/write operations are mapped to the underlying
> +	  regmap.
> +
>  config MDIO_THUNDER
>  	tristate "ThunderX SOCs MDIO buses"
>  	depends on 64BIT
> diff --git a/drivers/net/mdio/Makefile b/drivers/net/mdio/Makefile
> index 7d4cb4c11e4e..1015f0db4531 100644
> --- a/drivers/net/mdio/Makefile
> +++ b/drivers/net/mdio/Makefile
> @@ -19,6 +19,7 @@ obj-$(CONFIG_MDIO_MOXART)		+= mdio-moxart.o
>  obj-$(CONFIG_MDIO_MSCC_MIIM)		+= mdio-mscc-miim.o
>  obj-$(CONFIG_MDIO_MVUSB)		+= mdio-mvusb.o
>  obj-$(CONFIG_MDIO_OCTEON)		+= mdio-octeon.o
> +obj-$(CONFIG_MDIO_REGMAP)		+= mdio-regmap.o
>  obj-$(CONFIG_MDIO_SUN4I)		+= mdio-sun4i.o
>  obj-$(CONFIG_MDIO_THUNDER)		+= mdio-thunder.o
>  obj-$(CONFIG_MDIO_XGENE)		+= mdio-xgene.o
> diff --git a/drivers/net/mdio/mdio-regmap.c b/drivers/net/mdio/mdio-regmap.c
> new file mode 100644
> index 000000000000..c85d62c2f55c
> --- /dev/null
> +++ b/drivers/net/mdio/mdio-regmap.c
> @@ -0,0 +1,85 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/* Driver for MMIO-Mapped MDIO devices. Some IPs expose internal PHYs or PCS
> + * within the MMIO-mapped area
> + *
> + * Copyright (C) 2023 Maxime Chevallier <maxime.chevallier@bootlin.com>
> + */
> +#include <linux/bitfield.h>
> +#include <linux/delay.h>
> +#include <linux/mdio.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/of_mdio.h>
> +#include <linux/phy.h>
> +#include <linux/platform_device.h>
> +#include <linux/regmap.h>
> +#include <linux/mdio/mdio-regmap.h>
> +
> +#define DRV_NAME "mdio-regmap"
> +
> +static int mdio_regmap_read_c22(struct mii_bus *bus, int addr, int regnum)
> +{
> +	struct mdio_regmap_config *ctx = bus->priv;
> +	unsigned int val;
> +	int ret;
> +
> +	if (!(ctx->valid_addr & BIT(addr)))
> +		return -ENODEV;
> +
> +	ret = regmap_read(ctx->regmap, regnum, &val);
> +	if (ret < 0)
> +		return ret;
> +
> +	return val;
> +}
> +
> +static int mdio_regmap_write_c22(struct mii_bus *bus, int addr, int regnum,
> +				 u16 val)
> +{
> +	struct mdio_regmap_config *ctx = bus->priv;
> +
> +	if (!(ctx->valid_addr & BIT(addr)))
> +		return -ENODEV;
> +
> +	return regmap_write(ctx->regmap, regnum, val);
> +}
> +
> +struct mii_bus *devm_mdio_regmap_register(struct device *dev,
> +					  const struct mdio_regmap_config *config)
> +{
> +	struct mdio_regmap_config *mrc;
> +	struct mii_bus *mii;
> +	int rc;
> +
> +	if (!config->parent)
> +		return ERR_PTR(-EINVAL);
> +
> +	if (!config->valid_addr)
> +		return ERR_PTR(-EINVAL);
> +
> +	mii = devm_mdiobus_alloc_size(config->parent, sizeof(*mrc));
> +	if (!mii)
> +		return ERR_PTR(-ENOMEM);
> +
> +	mrc = mii->priv;
> +	memcpy(mrc, config, sizeof(*mrc));
> +
> +	mrc->regmap = config->regmap;
> +	mrc->parent = config->parent;

mrc->parent doesn't seem to be used

> +	mrc->valid_addr = config->valid_addr;
> +
> +	mii->name = DRV_NAME;
> +	strncpy(mii->id, config->name, MII_BUS_ID_SIZE);
> +	mii->parent = config->parent;
> +	mii->read = mdio_regmap_read_c22;
> +	mii->write = mdio_regmap_write_c22;
> +
> +	rc = devm_mdiobus_register(dev, mii);
> +	if (rc) {
> +		dev_err(config->parent, "Cannot register MDIO bus![%s] (%d)\n", mii->id, rc);
> +		return ERR_PTR(rc);
> +	}
> +
> +	return mii;
> +}
> +
> diff --git a/include/linux/mdio/mdio-regmap.h b/include/linux/mdio/mdio-regmap.h
> new file mode 100644
> index 000000000000..ea428e5a2913
> --- /dev/null
> +++ b/include/linux/mdio/mdio-regmap.h
> @@ -0,0 +1,25 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/* Driver for MMIO-Mapped MDIO devices. Some IPs expose internal PHYs or PCS
> + * within the MMIO-mapped area
> + *
> + * Copyright (C) 2023 Maxime Chevallier <maxime.chevallier@bootlin.com>
> + */
> +#ifndef MDIO_REGMAP_H
> +#define MDIO_REGMAP_H
> +
> +#define MDIO_REGMAP_NAME 63

hmm.. NAME_LEN would be less confusing for a name. Although... why not
MII_BUS_ID_SIZE directly, seeing that this is how it is actually used?

> +
> +struct device;
> +struct regmap;
> +
> +struct mdio_regmap_config {
> +	struct device *parent;
> +	struct regmap *regmap;
> +	char name[MDIO_REGMAP_NAME];
> +	u32 valid_addr;

Would it be better to name this valid_addr_mask, since that is how it is
used? Or is the "ctx->valid_addr & BIT(addr)" check wrong (should have
been "ctx->valid_addr == addr")? How is the driver supposed to work with
multiple valid addresses?

> +};
> +
> +struct mii_bus *devm_mdio_regmap_register(struct device *dev,
> +					  const struct mdio_regmap_config *config);
> +
> +#endif
> -- 
> 2.39.2
>
