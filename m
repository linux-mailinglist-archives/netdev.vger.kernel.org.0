Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD92A310EB6
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 18:31:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233364AbhBEPrD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 10:47:03 -0500
Received: from mail-eopbgr20057.outbound.protection.outlook.com ([40.107.2.57]:43022
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233294AbhBEPoP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Feb 2021 10:44:15 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iVktmSIPHa9RlnAMIxDYOzKA8kmozmy4DtC6fv7h9JaNglZIWd0mq2DQDWCflrT9fLWi4YaLPVxYTUVSZtl9gY1Rz2rFmXaenG6SLWcBUa2LZY9mHSWzeRnbyvGjRxEMmgAfNfamazziQqgQAkQ6XYi8Dy3oPrHnfJ62Qco4LnzITH29NCHLaMf6MW2JKXjpS2i+QH5U1yW7MOmLBB9ewTnuzYoGy3f5igtZrGvUVmr2XmNIUubqkZU4ZKcHyi4nclZR/3k+ZmvcQ38uefXiWt1l0nhpVO6cGrUZZ7RRaOj4zDd2R+UZ3OBaUi7qeTUTud4yS8DHvOcFaTw2RmkJ0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vSwjsVDIHVon1ivwtYvn445He9ul6JGCkvavktccA54=;
 b=Xty7paRXU7IzizuNw2YE8tnnSozkXbi4UhY/YzS1c6uxSxpjP7zg5R7HSvfXvhSlEpbPRSiV0/xzQ1NohTLhd25TpIv5JdP2ddz7osh5i53HWgpIAVid2ZzsvMNU4j237ViLECscg8IYRM7KtAHKSQcr8ZR3zPdOcEKZKVRc8Oku4V6hOvwDrLntTQtILthAkltsQuekZlJbPCc/1qXx43gGasybIPtECOvTggRq91urgcoMmwX/5ImNVJ9uFZyctHw6qYPONd/eFl8T3/sfOwsGqhtLgGCpsnULY5zu6tzRkconvTx03rKdyRJrPgmNYGP0knNP3GCVXoZRiW2/AQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vSwjsVDIHVon1ivwtYvn445He9ul6JGCkvavktccA54=;
 b=Wvg06c91zePIYMyiCPKfiUhqev8Okmwh6yceMC6nXVaOjMCkhobvrFpFLvvu0MBVFcS4PnYJE86R1rVbkmPfyoYGOtDs+Cgr/xULcatGrgzTEB1trdwdqAbYvFk73rtTjyAPjR7IdxtqnaXK3097TKajIntJ57ID1267OR/bkN0=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB5953.eurprd04.prod.outlook.com (2603:10a6:208:10f::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.19; Fri, 5 Feb
 2021 17:25:44 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42%6]) with mapi id 15.20.3805.024; Fri, 5 Feb 2021
 17:25:44 +0000
Date:   Fri, 5 Feb 2021 22:55:18 +0530
From:   Calvin Johnson <calvin.johnson@oss.nxp.com>
To:     Grant Likely <grant.likely@arm.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Pieter Jansen Van Vuuren <pieter.jansenvv@bamboosystems.io>,
        Jon <jon@solid-run.com>, Saravana Kannan <saravanak@google.com>,
        Randy Dunlap <rdunlap@infradead.org>
Cc:     linux.cj@gmail.com, Diana Madalina Craciun <diana.craciun@nxp.com>,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Frank Rowand <frowand.list@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: Re: [net-next PATCH v4 07/15] net: mdiobus: Introduce
 fwnode_mdiobus_register_phy()
Message-ID: <20210205172518.GA18214@lsv03152.swis.in-blr01.nxp.com>
References: <20210122154300.7628-1-calvin.johnson@oss.nxp.com>
 <20210122154300.7628-8-calvin.johnson@oss.nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210122154300.7628-8-calvin.johnson@oss.nxp.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: SG2PR06CA0129.apcprd06.prod.outlook.com
 (2603:1096:1:1d::31) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR06CA0129.apcprd06.prod.outlook.com (2603:1096:1:1d::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.20 via Frontend Transport; Fri, 5 Feb 2021 17:25:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e005065a-3193-4a81-e927-08d8c9fb10e7
X-MS-TrafficTypeDiagnostic: AM0PR04MB5953:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB595343F91BE276F7C9F4DB84D2B29@AM0PR04MB5953.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 030nPa9XGE+gQ+WQEeYn3lomG3ZijDflLmk3GLMi5QAEBUs9D6RiCDc4T+WvNcXrs+Pt1lzpoN669/bPa4+DVT4FON8n4KcKThuv5tzRqaLg9TzvlBMKVHju5mEjQLamUkqjjkLD2Kz+aKmK6JlpyGfNGyR2UN9Tm647JOBOmaI34UW6yD6GPVovmU5gPkiEPZ/kJyLQ6SlE1cFTvRgIp1GTmeVc+IkMgHQJdpuQXbO8k9NqJySbCHAVGsWdncYleP/1x77CYIDWzni5vtnJ2kx0mMX6vLmg8VAzH0oIBh1LbtdbPg6ksGY8TiXx9NI5zDXLxv1usNqyOwgt4uba/fbSH45dlGCYqRHOFjaorTW+U8rMy6Ks0pEML37pTaYJ6r0CJ5z5LVJIy+LFO+Km8QU5oYI3g1DBTAIe4iBpkDxF/CjZNpZYNvdz9VVmQ3yUQHPs+KTf3iaG1b1ujO7pPwDPgZ7bCIZ2WLx2vpa9zLZpZfdqvpDWlli86BhfhE+nz+u+nJSHgR2AEOYfepI1dl2dp+z2KRLrlvU4Ke1zY140qPw/2yoGypMgfBuGocXHuTD2eXXt2d3K8Cy2Bzcv58ldeMh5jWInhg1GJmg1A84=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(396003)(376002)(136003)(366004)(6506007)(55236004)(5660300002)(33656002)(8936002)(1076003)(55016002)(7416002)(44832011)(186003)(52116002)(1006002)(8676002)(2906002)(921005)(54906003)(7696005)(9686003)(86362001)(83380400001)(66946007)(478600001)(316002)(6666004)(110136005)(66476007)(4326008)(956004)(16526019)(66556008)(26005)(110426009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?yITgQF7K5zKJZWtVJiq935mNFZksflCeJTkQ7KHUXFq7EOBHt844R4GKuUFQ?=
 =?us-ascii?Q?n7NRgHKRU8TAtw0Er60Dqlq91FEjIT2QI/FwdpQozsKc9Xy+7s/BLMClItZw?=
 =?us-ascii?Q?dpNkmoZUHh1FaBgDJH9cpTouijRfYjzvF2QCWcK2z8E2VO8ZCf7uIilgUusX?=
 =?us-ascii?Q?HHjbZmKtMvXSiIC0xzZ+97oNVHntk6jacr/KsdoNIW1drA/A1By09YEOil/c?=
 =?us-ascii?Q?IVA+Ji3yjdfYxOFFYu0cfJnAJnpFVRBIf6UBApH7kJeFDmKwP0pmjGtHyPy5?=
 =?us-ascii?Q?CNqLQT+XvoAETqsOPr/83IvmqNLbisNc0XkerGqe8Q/iJU9fA5Z4l1oFBnm4?=
 =?us-ascii?Q?ydt5foTlz3PGRhdqxKZ5ChISPdIqaYUDWbEF+d94PkusZilDqwmyEdIAy2ki?=
 =?us-ascii?Q?r3EIiEXjjF+Q+KM7oAuxczSWCFQkwbJwAOv3NPjem9PcCQaWBg6xdDRDYd2K?=
 =?us-ascii?Q?LOZPMl5m94zHRfqSxc7JsX1xXlkhJj/qOPRUPJVQ7P3RlIzSRl6Zu1+2NTlE?=
 =?us-ascii?Q?IuPMJe7fGyDo08hOOC+uKXfYbCYRO+t6KH3TQY4F5Petq2zHCooF6f4cSy55?=
 =?us-ascii?Q?ExExcKWKXpLDnDVRY6Ese682e/UH9tZLESkAazLYKzgyP+kplADUiNHdeHa1?=
 =?us-ascii?Q?ONB9xxLzUFVQUsEfM6O4kstFTAjiz2N5jPf4IAOehDfkH4CuZ32IugjWezA6?=
 =?us-ascii?Q?75Q7PUAFz++WgDgvxJDYxNTMo2uoIoJfViwGaGwkBMkcZOWDuHNPAR5pZwQJ?=
 =?us-ascii?Q?XwukH/t2cIilyxS2L3g1gIfRj/trstN7HGiEGs3D2iIbVvXBI7iI+PdQOdOI?=
 =?us-ascii?Q?s58jb22acX72D/6fm3jMOzGVyzzfMymgmSKJJ1FvVXJzY57HBhSwxQwgWvoO?=
 =?us-ascii?Q?quTePf/M9fih1GETcr6C0LclqYwHgTolaQ7EmqsU6IRCFOAMmRJ0jXgrqYI8?=
 =?us-ascii?Q?/Bnt9bH9iJk3iAzwQfUT0RlM2QSJKpr9zivpCnhzxCO5dwonu6Eljfe5kuOs?=
 =?us-ascii?Q?jAYLSo4eZDdmKH86Zxxe96MPhS11bYY5iSQS0hbORMeLnyGMbo9vDeMvq8HC?=
 =?us-ascii?Q?erOK10kh6tbTrQ3blIxxhwzQ6ZUGGFbQxNLbVgnBvCRvWOSS3dys/7QBN0Z/?=
 =?us-ascii?Q?i6aSypdlB4OCuq0n8yMdkI+HS3jMxC7bTHPR277PFv6RhwW/hMcxXryQCv3b?=
 =?us-ascii?Q?Td+7oJAxU7A+bYLtENKgLresxvstrefQWqjUu+U6e2kggC+vx/kklAtlh0/R?=
 =?us-ascii?Q?GrWY7aUYeFgBqgLCxgXOm8hOGo/JwheiAUaOsoy0U++VJYtag9anBebBp+4v?=
 =?us-ascii?Q?dmTrkptuz/wlibf2WAWWv5A0CwZBTMU3Xmz7byeeVumpvQ=3D=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e005065a-3193-4a81-e927-08d8c9fb10e7
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2021 17:25:44.1677
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q0o6Fjr/Lnq3MVk1YciYF5ZJ952Y210u0DvpSTV1ddNrfcoGZEi+/I7SbkoATOkgsPsCsaFIBd2xR8ZZ1e4dSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5953
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 22, 2021 at 09:12:52PM +0530, Calvin Johnson wrote:
> Introduce fwnode_mdiobus_register_phy() to register PHYs on the
> mdiobus. From the compatible string, identify whether the PHY is
> c45 and based on this create a PHY device instance which is
> registered on the mdiobus.
> 
> Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
> ---
> 
> Changes in v4: None
> Changes in v3: None
> Changes in v2: None
> 
>  drivers/net/mdio/of_mdio.c |  3 +-
>  drivers/net/phy/mdio_bus.c | 67 ++++++++++++++++++++++++++++++++++++++
>  include/linux/mdio.h       |  2 ++
>  include/linux/of_mdio.h    |  6 +++-
>  4 files changed, 76 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/mdio/of_mdio.c b/drivers/net/mdio/of_mdio.c
> index d4cc293358f7..cd7da38ae763 100644
> --- a/drivers/net/mdio/of_mdio.c
> +++ b/drivers/net/mdio/of_mdio.c
> @@ -32,7 +32,7 @@ static int of_get_phy_id(struct device_node *device, u32 *phy_id)
>  	return fwnode_get_phy_id(of_fwnode_handle(device), phy_id);
>  }
>  
> -static struct mii_timestamper *of_find_mii_timestamper(struct device_node *node)
> +struct mii_timestamper *of_find_mii_timestamper(struct device_node *node)
>  {
>  	struct of_phandle_args arg;
>  	int err;
> @@ -49,6 +49,7 @@ static struct mii_timestamper *of_find_mii_timestamper(struct device_node *node)
>  
>  	return register_mii_timestamper(arg.np, arg.args[0]);
>  }
> +EXPORT_SYMBOL(of_find_mii_timestamper);
>  
>  int of_mdiobus_phy_device_register(struct mii_bus *mdio, struct phy_device *phy,
>  			      struct device_node *child, u32 addr)
> diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
> index 040509b81f02..44ddfb0ba99f 100644
> --- a/drivers/net/phy/mdio_bus.c
> +++ b/drivers/net/phy/mdio_bus.c
> @@ -8,6 +8,7 @@
>  
>  #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>  
> +#include <linux/acpi.h>
>  #include <linux/delay.h>
>  #include <linux/device.h>
>  #include <linux/errno.h>
> @@ -106,6 +107,72 @@ int mdiobus_unregister_device(struct mdio_device *mdiodev)
>  }
>  EXPORT_SYMBOL(mdiobus_unregister_device);
>  
> +int fwnode_mdiobus_register_phy(struct mii_bus *bus,
> +				struct fwnode_handle *child, u32 addr)
> +{
> +	struct mii_timestamper *mii_ts;
> +	struct phy_device *phy;
> +	bool is_c45 = false;
> +	u32 phy_id;
> +	int rc;
> +
> +	if (is_of_node(child)) {
> +		mii_ts = of_find_mii_timestamper(to_of_node(child));
> +		if (IS_ERR(mii_ts))
> +			return PTR_ERR(mii_ts);
> +	}
> +
> +	rc = fwnode_property_match_string(child, "compatible", "ethernet-phy-ieee802.3-c45");
With ACPI, I'm facing some problem with fwnode_property_match_string(). It is
unable to detect the compatible string and returns -EPROTO.

ACPI node for PHY4 is as below:

 Device(PHY4) {
    Name (_ADR, 0x4)
    Name(_CRS, ResourceTemplate() {
    Interrupt(ResourceConsumer, Level, ActiveHigh, Shared)
    {
      AQR_PHY4_IT
    }
    }) // end of _CRS for PHY4
    Name (_DSD, Package () {
      ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
        Package () {
          Package () {"compatible", "ethernet-phy-ieee802.3-c45"}
       }
    })
  } // end of PHY4

 What is see is that in acpi_data_get_property(),
propvalue->type = 0x2(ACPI_TYPE_STRING) and type = 0x4(ACPI_TYPE_PACKAGE).

Any help please?

fwnode_property_match_string() works fine for DT.

Thanks
Calvin

> +	if (rc >= 0)
> +		is_c45 = true;
> +
> +	if (is_c45 || fwnode_get_phy_id(child, &phy_id))
> +		phy = get_phy_device(bus, addr, is_c45);
> +	else
> +		phy = phy_device_create(bus, addr, phy_id, 0, NULL);
> +	if (IS_ERR(phy)) {
> +		if (mii_ts && is_of_node(child))
> +			unregister_mii_timestamper(mii_ts);
> +		return PTR_ERR(phy);
> +	}
> +
> +	if (is_acpi_node(child)) {
> +		phy->irq = bus->irq[addr];
> +
> +		/* Associate the fwnode with the device structure so it
> +		 * can be looked up later.
> +		 */
> +		phy->mdio.dev.fwnode = child;
> +
> +		/* All data is now stored in the phy struct, so register it */
> +		rc = phy_device_register(phy);
> +		if (rc) {
> +			phy_device_free(phy);
> +			fwnode_handle_put(phy->mdio.dev.fwnode);
> +			return rc;
> +		}
> +
> +		dev_dbg(&bus->dev, "registered phy at address %i\n", addr);
> +	} else if (is_of_node(child)) {
> +		rc = of_mdiobus_phy_device_register(bus, phy, to_of_node(child), addr);
> +		if (rc) {
> +			if (mii_ts)
> +				unregister_mii_timestamper(mii_ts);
> +			phy_device_free(phy);
> +			return rc;
> +		}
> +
> +		/* phy->mii_ts may already be defined by the PHY driver. A
> +		 * mii_timestamper probed via the device tree will still have
> +		 * precedence.
> +		 */
> +		if (mii_ts)
> +			phy->mii_ts = mii_ts;
> +	}
> +	return 0;
> +}
> +EXPORT_SYMBOL(fwnode_mdiobus_register_phy);
> +
>  struct phy_device *mdiobus_get_phy(struct mii_bus *bus, int addr)
>  {
>  	struct mdio_device *mdiodev = bus->mdio_map[addr];
> diff --git a/include/linux/mdio.h b/include/linux/mdio.h
> index ffb787d5ebde..7f4215c069fe 100644
> --- a/include/linux/mdio.h
> +++ b/include/linux/mdio.h
> @@ -381,6 +381,8 @@ int mdiobus_register_device(struct mdio_device *mdiodev);
>  int mdiobus_unregister_device(struct mdio_device *mdiodev);
>  bool mdiobus_is_registered_device(struct mii_bus *bus, int addr);
>  struct phy_device *mdiobus_get_phy(struct mii_bus *bus, int addr);
> +int fwnode_mdiobus_register_phy(struct mii_bus *bus,
> +				      struct fwnode_handle *child, u32 addr);
>  
>  /**
>   * mdio_module_driver() - Helper macro for registering mdio drivers
> diff --git a/include/linux/of_mdio.h b/include/linux/of_mdio.h
> index cfe8c607a628..3b66016f18aa 100644
> --- a/include/linux/of_mdio.h
> +++ b/include/linux/of_mdio.h
> @@ -34,6 +34,7 @@ struct mii_bus *of_mdio_find_bus(struct device_node *mdio_np);
>  int of_phy_register_fixed_link(struct device_node *np);
>  void of_phy_deregister_fixed_link(struct device_node *np);
>  bool of_phy_is_fixed_link(struct device_node *np);
> +struct mii_timestamper *of_find_mii_timestamper(struct device_node *np);
>  int of_mdiobus_phy_device_register(struct mii_bus *mdio, struct phy_device *phy,
>  				   struct device_node *child, u32 addr);
>  
> @@ -128,7 +129,10 @@ static inline bool of_phy_is_fixed_link(struct device_node *np)
>  {
>  	return false;
>  }
> -
> +static inline struct mii_timestamper *of_find_mii_timestamper(struct device_node *np)
> +{
> +	return NULL;
> +}
>  static inline int of_mdiobus_phy_device_register(struct mii_bus *mdio,
>  					    struct phy_device *phy,
>  					    struct device_node *child, u32 addr)
> -- 
> 2.17.1
> 
