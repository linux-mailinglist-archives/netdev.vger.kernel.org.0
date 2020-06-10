Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77BBA1F58DE
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 18:16:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728802AbgFJQQy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 12:16:54 -0400
Received: from mail-vi1eur05on2076.outbound.protection.outlook.com ([40.107.21.76]:26107
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728157AbgFJQQw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Jun 2020 12:16:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AheZ2vAMYcApkM2LEC6a6LFKmiG2VpWqS0DpXw2IGCfrl+oPe3GgzuHPb1XzJXRdt7iCgma3A2V1JhKPj5CP/LWMJBuhdU1NzCYIcNSO3PYzCW8dsYbaGvQoutmreylm54ouo+U7DP0NY5QUb16npbwN9HWWXs0C4tAyTigvyJdRVuIW+zOOkKusTGTIsnDhM7iGPY7Lnzcg0lyjLkRT0HbxBGKpfnrXBEva/vLP/xZodTWmJB0ncfwhqL69GDxkG3RQUVYFh8EaIdt/3j++ILy0tWI3UXVDLIXuUusIMPUCYh25Wl1sNgEytjgnREzxPRu+MV4gtVyw4BWVW5ouLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=egVAcZtC2zfRt2WJKXc/aOJzNY4H6wcpHyKFXmKlQ0c=;
 b=aM4qpo9o+J3S4DGtMqJWoNH8G8r2MIGmVbPgNVRpUBt9r6iDdkeHoxlVPzqQ3BsyAMCEDsvy83EYQACqXM2HeUpQ8KbUBjYxZXTVC+s0NWUcZ8cI7og8riNUPkmlJSPMrH5Fqev1SiTvMjHkPTSEfWPIQBPmTrwG33Bp6aqW/B/wUl8xSfiVZeSkLRn3GmRvlKO7m10Ca4kN7EH7Ympi0YbBlWkNQCzuGN9RnCmZnuR44hiUNfwf64FiE8p98kXDOXJsTCiS902+erF1J/dWjTljWZrzpQROuZNADCiubyT8wYpz+6cZZOndkyF1BQmsAhfdKnSfUeJ+cfLzgMTZag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=egVAcZtC2zfRt2WJKXc/aOJzNY4H6wcpHyKFXmKlQ0c=;
 b=AKXc5//e6DNTRzl+B7I3qJPnR74GLPEKaxQOG34B8XpmvetylSe2aV/YDjbqLDSpXagEv/BUdlGF3QYe/caQkXPK/pqmFFupYX2tJLtHLDYNrYWCkIyE4Jbs20NYYVa+8jkLWr7a4KijVIgzvCSxxQVgQ/pnmqgM8MoLcT1VH3Y=
Authentication-Results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none
 header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB5473.eurprd04.prod.outlook.com (2603:10a6:208:112::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.18; Wed, 10 Jun
 2020 16:16:40 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45%7]) with mapi id 15.20.3066.023; Wed, 10 Jun 2020
 16:16:40 +0000
Date:   Wed, 10 Jun 2020 21:46:33 +0530
From:   Calvin Johnson <calvin.johnson@oss.nxp.com>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH RFC v2 6/9] net: phy: add support for probing MMDs >= 8
 for devices-in-package
Message-ID: <20200610161633.GA22223@lsv03152.swis.in-blr01.nxp.com>
References: <20200527103318.GK1551@shell.armlinux.org.uk>
 <E1jdtNz-000840-Sk@rmk-PC.armlinux.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1jdtNz-000840-Sk@rmk-PC.armlinux.org.uk>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: SG2PR06CA0198.apcprd06.prod.outlook.com (2603:1096:4:1::30)
 To AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR06CA0198.apcprd06.prod.outlook.com (2603:1096:4:1::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.21 via Frontend Transport; Wed, 10 Jun 2020 16:16:38 +0000
X-Originating-IP: [14.142.151.118]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9b82ae03-496a-4156-6331-08d80d59a881
X-MS-TrafficTypeDiagnostic: AM0PR04MB5473:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB5473C2D1CCA90554C2E90E97D2830@AM0PR04MB5473.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 0430FA5CB7
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hNjbDB481NFi6R990u5Gi2BGevz3RCLLP7qjLZZCqzaDYXx6Oc/KxXtOPDjBHTJh9P5bjVPKa7qXyxG5oYM+0SRQdZ+PCDpZLaopGd7E9DbCdhsosLo+QDN5FAESe98ZsfehkBD8ZL6pZDep23pHMkpGl4iwS53VgKpJdGK/D7is/7oPJOEEbHr1n/v+CQMvwUyHfpqnOEC1Ng8QY0ET4lS8VM51/jJ6+4V1C3Le7GEmyvDpnj7Dfx6Ku/R5hmlW7kbD/iOT92iaZFfEM1g0S6QySsocATYP5o8A6Os1uRuGi5Kvz7Xa8QEZOY35NyAX/L+OHslCcWJ5JJs+ZPe6d+MWHu60BppbXYJlkRo/XaxkNoa4WnCQrA7GOHYaqTp8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(346002)(376002)(136003)(39860400002)(396003)(956004)(186003)(66946007)(33656002)(66476007)(66556008)(83380400001)(55236004)(6506007)(44832011)(5660300002)(16526019)(2906002)(26005)(7696005)(54906003)(8676002)(9686003)(316002)(1076003)(86362001)(478600001)(52116002)(6666004)(8936002)(55016002)(1006002)(4326008)(110426005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 6FpCIHKKifJilYlg6cO32d4GQ/MxQua1Ya0TPNtLjtW5b+IRzxwwrg2vtzPuAXFyptPgOM3HJr89fdAv63g0aRGc/YBDPmgN2BAyIfegpY4Sn2Gd5bVpOqLDxdvkV10LxI75gCHKBe0NqHfarCMRUapSXXiioVDi2YG9F+Gg4r8Kkxc0hq7ueelFpgDRVByuFpHO45TD34+jjwodn6LBS1NdzJSr0YLNMmk6dvLZIs61UnseYXF3Z5jnmKDOMuWxMkT6CG50xiBHD78pvLaG//4A+yI5IEbPdFDBcN8QgaloVd6f87oCG8YgvHm3wmyupUrnmKUAY94HH5VpdhWiHclxhSJqGtZcT546TcPQ/qTZWwR6WRv+l0U8gHAZk3uxnULtwZE0M8y+3un4h/VoLTbCTffNwKdZ4cnRIYtu+HK/UfjsHs7IJxvlT1uCEuoFOTSmLzWe7gaVC8UJeo202gBp/ksYzW7wf3eZmWN7yaRjAEv98D81TasyKk1dbbKM
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b82ae03-496a-4156-6331-08d80d59a881
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2020 16:16:40.5426
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eX5EgSY0R5pdfhzwKmcbhnFnGC9zFRA5yktKpcMZh/Maez/s+3CtaWyn+pD801qb2cqZBLPleoiHO+aoxE+9Ng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5473
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell,

On Wed, May 27, 2020 at 11:34:11AM +0100, Russell King wrote:
> Add support for probing MMDs above 7 for a valid devices-in-package
> specifier, but only probe the vendor MMDs for this if they also report
> that there the device is present in status register 2.  This avoids
> issues where the MMD is implemented, but does not provide IEEE 802.3
> compliant registers (such as the MV88X3310 PHY.)

While this patch looks good to me, commit message doesn't seem to align
with the code changes as it is dealing with MMD at addresses 30 & 31.
Can you please clarify?

Thanks
Calvin

> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> ---
>  drivers/net/phy/phy_device.c | 40 ++++++++++++++++++++++++++++++++++--
>  include/linux/phy.h          |  2 ++
>  2 files changed, 40 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> index bc20ee01b31d..79f01cfec774 100644
> --- a/drivers/net/phy/phy_device.c
> +++ b/drivers/net/phy/phy_device.c
> @@ -659,6 +659,28 @@ struct phy_device *phy_device_create(struct mii_bus *bus, int addr, u32 phy_id,
>  }
>  EXPORT_SYMBOL(phy_device_create);
>  
> +/* phy_c45_probe_present - checks to see if a MMD is present in the package
> + * @bus: the target MII bus
> + * @prtad: PHY package address on the MII bus
> + * @devad: PHY device (MMD) address
> + *
> + * Read the MDIO_STAT2 register, and check whether a device is responding
> + * at this address.
> + *
> + * Returns: negative error number on bus access error, zero if no device
> + * is responding, or positive if a device is present.
> + */
> +static int phy_c45_probe_present(struct mii_bus *bus, int prtad, int devad)
> +{
> +	int stat2;
> +
> +	stat2 = mdiobus_c45_read(bus, prtad, devad, MDIO_STAT2);
> +	if (stat2 < 0)
> +		return stat2;
> +
> +	return (stat2 & MDIO_STAT2_DEVPRST) == MDIO_STAT2_DEVPRST_VAL;
> +}
> +
>  /* get_phy_c45_devs_in_pkg - reads a MMD's devices in package registers.
>   * @bus: the target MII bus
>   * @addr: PHY address on the MII bus
> @@ -709,12 +731,26 @@ static int get_phy_c45_ids(struct mii_bus *bus, int addr,
>  {
>  	const int num_ids = ARRAY_SIZE(c45_ids->device_ids);
>  	u32 *devs = &c45_ids->devices_in_package;
> -	int i, phy_reg;
> +	int i, ret, phy_reg;
>  
>  	/* Find first non-zero Devices In package. Device zero is reserved
>  	 * for 802.3 c45 complied PHYs, so don't probe it at first.
>  	 */
> -	for (i = 1; i < num_ids && *devs == 0; i++) {
> +	for (i = 1; i < MDIO_MMD_NUM && *devs == 0; i++) {
> +		if (i == MDIO_MMD_VEND1 || i == MDIO_MMD_VEND2) {
> +			/* Check that there is a device present at this
> +			 * address before reading the devices-in-package
> +			 * register to avoid reading garbage from the PHY.
> +			 * Some PHYs (88x3310) vendor space is not IEEE802.3
> +			 * compliant.
> +			 */
> +			ret = phy_c45_probe_present(bus, addr, i);
> +			if (ret < 0)
> +				return -EIO;
> +
> +			if (!ret)
> +				continue;
> +		}
>  		phy_reg = get_phy_c45_devs_in_pkg(bus, addr, i, devs);
>  		if (phy_reg < 0)
>  			return -EIO;
> diff --git a/include/linux/phy.h b/include/linux/phy.h
> index 9b7c46cf14d3..41c046545354 100644
> --- a/include/linux/phy.h
> +++ b/include/linux/phy.h
> @@ -350,6 +350,8 @@ enum phy_state {
>  	PHY_NOLINK,
>  };
>  
> +#define MDIO_MMD_NUM 32
> +
>  /**
>   * struct phy_c45_device_ids - 802.3-c45 Device Identifiers
>   * @devices_in_package: Bit vector of devices present.
> -- 
> 2.20.1
> 
