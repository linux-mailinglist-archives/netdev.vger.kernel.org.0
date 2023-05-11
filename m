Return-Path: <netdev+bounces-1823-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3378D6FF384
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 16:01:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EA6B51C20F39
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 14:01:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B023019E71;
	Thu, 11 May 2023 14:01:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9727C1F922
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 14:01:23 +0000 (UTC)
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2101.outbound.protection.outlook.com [40.107.220.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D877C5247;
	Thu, 11 May 2023 07:01:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nvEEhQWa2r3jfeO7S7ABAzKPVKrPYQSP9fIKLWCltblxr6hDuO+1nt921lStOOTJXPnqAqqV0aP+gJH0ZmXnv0dp+nvMtD+avejgjyQ6gMsCsWPhzWkgABPjOcKh4pP2UnyWYSlS2fFVeSvmDP2TdEpeDhNeEvN8JIP5CwEJrswuiQtdpv8KzWJ8x2Zcnob65z+V4LdD1BMm6ceApdv0fYD5+OFzcez5Qa2HrK2oPWI+nT0vIkFhkAkxKVXIk2BVxuSk0SXV83Z4weRDAlN6nq6AllOXzfukoHrSY81qzzcB27aGikidsChs0gSorJy8028iznfRxgfoMWZ5620e4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0Y0xI6rSh2R5D8r5eEnq2spcVeYewEFWya36jjItlxw=;
 b=SSgb4HLrh5v0msP4B5hBXPAUpHe5Rr90+yOjcW5LscKYuo2XtZybA0YcLnxWKcXWMJ3ZyLBN/qYKxkjg7Q/5VYFYtDQ1KODRQ3B/egaAi617aSFM/FV4Ubt+qdVQn6UAjm6bcRA95G4z/daQV2MmTSThn10Tq+snAotEb+HX0Xw9xvu9P+XFYYniYsPbIuM329hXF+WCQwkPLjYz98vAr33AUIasgRfIJkk9UGMN/+MF40AeAjZ/m+RRiUQOM6Nl11+Bk2c+ojOPGO+iA8J/H8Xow4ugx2WI8HcnHqjXZo2mX9MQPS7UCFPTVEYKvCrYKCm1hzuzfe9rebsP/Dh36w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0Y0xI6rSh2R5D8r5eEnq2spcVeYewEFWya36jjItlxw=;
 b=sL64lqnfwOAD/Ao0I0vUzvxLuNhvJJV/55oGL/o+vnFjwIV6w/rr60rXpfa0Lf8BUFM+dkPTKWlbB4xJbWj7tmRkhTia20/PYKaFuGVIveNBu3WgN/IGTVCA1huKb71pkp24PtB2Tmt8ETNBWvqm5HN0I0RAzRTEpQZU7fpJGAk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW5PR13MB5581.namprd13.prod.outlook.com (2603:10b6:303:195::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.19; Thu, 11 May
 2023 14:01:12 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.020; Thu, 11 May 2023
 14:01:12 +0000
Date: Thu, 11 May 2023 16:00:37 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Harini Katakam <harini.katakam@amd.com>
Cc: andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
	davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
	pabeni@redhat.com, vladimir.oltean@nxp.com,
	wsa+renesas@sang-engineering.com, mkl@pengutronix.de,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	harinikatakamlinux@gmail.com, michal.simek@amd.com,
	radhey.shyam.pandey@amd.com
Subject: Re: [PATCH net-next v3 2/3] phy: mscc: Add support for RGMII delay
 configuration
Message-ID: <ZFz1Bb8byoR1mQxH@corigine.com>
References: <20230511120808.28646-1-harini.katakam@amd.com>
 <20230511120808.28646-3-harini.katakam@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230511120808.28646-3-harini.katakam@amd.com>
X-ClientProxiedBy: AM0PR05CA0094.eurprd05.prod.outlook.com
 (2603:10a6:208:136::34) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW5PR13MB5581:EE_
X-MS-Office365-Filtering-Correlation-Id: 507718f9-5a87-45b0-b3a4-08db52282d9e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	lsL8zNuiqnN2DNRmO1xNFnppFjnfcfR5mdrEcAPOf6bkR8/Yh/yo3YtnLc8ZxchhSlX559+PmLlHWpWAAg186sTakJWJqmp98nDATFsoPkxqlq6GSvNmTrqwkSqRTL2pl7VDtTCoPfiNt6t8P5X59CuI8WJdDNvAsdIdzDxSDunyCsGx+6BbuMbcLd/kpeyL9An35iJysneoXVncRRupj1eLqPCqzipwA1N5/hY3/EmjSPv8WSX4vu8TficmCyj/4Xk3/0m0fuZBmxV7tDxSWjmm+cBmJw5IM1cOb2Ujr85qaAmNHrROd8JYWNhY6vn1M4dL2W4lRcJ4vZuMnzgh/bqJfFZK6TJKQyh0myLVAlZryyZZX5MHjSAtwhxTwg9rwryZKAVHZVDVP7l6fs5vu62SoC+9g5UQcD0wY0fkUuSNvLgI7FQBu3VIGVOPo2SvxC51XWF7PBT1eceTXepGU0asuu4gqFEy+m7JnkL46wvrzTWd5cQn8dOCeUCBqKV7eI9/4tw8i6HDqJALFL7NObloRuT9op9ajrD0lT45tv4RsHCq7SthVLXKrTGyTEU+7Q4GuFVYSu1Y//774WBN/RikEsN0EKjy/UeRQTqDw6o=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(346002)(376002)(366004)(39840400004)(451199021)(186003)(36756003)(478600001)(86362001)(6486002)(40140700001)(6666004)(38100700002)(2906002)(8676002)(8936002)(7416002)(5660300002)(44832011)(6916009)(66476007)(66946007)(66556008)(41300700001)(316002)(6506007)(6512007)(4326008)(2616005)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?wiThRKD5Up2h3/k/0L6W0xS4XFVSSzlGf7kAqR08ZZf91wcI1p860g7WRsTo?=
 =?us-ascii?Q?rJEWi1v7AMXvbgS8R78RuVy3+JXw05fpUWXH0wLy1OP1rBSfDyGlPyaJjw2H?=
 =?us-ascii?Q?/HknvyQ/p9CyXU8DiMap/FLayiQZThAlazRw7nwRG0xvwU8xkeTcaaobp0Jv?=
 =?us-ascii?Q?4DWpiAiMcWgerfRVugt/uhNbccTO9+cM1zr5i2IJESvg/cD4iyU4BDNN1q0M?=
 =?us-ascii?Q?ACWgSkT0iOAx/UInAXqsp82BRk0aZkdJJU6sqMOt25zuTqWpGSjO6MxmAr3E?=
 =?us-ascii?Q?lDTpm0SC1ivc/0KLKdsEXAskhQCuCKtq6L+eE/aqSIvsf1wDJsglYroIJD01?=
 =?us-ascii?Q?AtDv2HmyiXmeqU3eF9zboNUodLarbkv1g4brb28h7VgQ2Jdjces4biTTKswe?=
 =?us-ascii?Q?347D9sy4vXeG64lG+VsBz0Ehmj1hVJsxlbl7mn0jI+gcVbNHfNEdZrhnBdT6?=
 =?us-ascii?Q?Wn+N1vOzoZ3SxwgHjSDzl1KidSfv384A0P8a+MdC3FwvsXkFNWLXD/1WvrzA?=
 =?us-ascii?Q?S5IDUrl3aTP24U9iZ0IzA4kedYVKBeG/KDjiUv295ezyLE2dLcMoX05cOU+z?=
 =?us-ascii?Q?V76aBEV4YOfcQjuSjXWlO8mum65IDoSVX2D5oyyKG5x1xsJMj9EmEuORv/te?=
 =?us-ascii?Q?ZjTIFfbglGGtgloYeTbH77bnPY8oKQQTPeAqwmR8AKU3hBEgV4ICH6Mg5K16?=
 =?us-ascii?Q?m9Fg+u15XV6PviT/ahvmX1LZJsKgHIojGsm3Ie9F+y0n8DlMR344z9jCGyTp?=
 =?us-ascii?Q?Z3xg9ei0Le+FZumrwU1Nh8rr6VENUe4f/afuG64/nLb+yLm9KApGtcTirTWH?=
 =?us-ascii?Q?6XuVhIAmPOIYRV+ax/ES+cosCMMx64eg2C3Kaf9MjkArhd/nf+EDWggbEKVH?=
 =?us-ascii?Q?w1dyrgjkO+XSb9WbIBlIHiLIyVQRMlEC07sUcnmDRB7oMJ5j8D/Sn63BQyLW?=
 =?us-ascii?Q?55FTcuWQr4xCFMMkqTLXaoT+Li49UzT5EbI4mp4fXbO/9V79/5RrWPpZZjz/?=
 =?us-ascii?Q?0P9xQWVXJ/GgKTmWcsvTgFhoDUTOaX6QfhXudHD15KoyjjWUEbdSRDiD1TG+?=
 =?us-ascii?Q?0T8sPVU0zKEGPSoTeXvKCpLvydit4sgKMJMZGdn4Dx83p7jbEPsl9+eKTam1?=
 =?us-ascii?Q?CnRKONN4eU9djfiVHCLN4hVXp4cBjnMXjRBWNL2ct0emetqeuAuUug6BZ4eA?=
 =?us-ascii?Q?Uwj3hiRqhgFDO21P8A38+6YwBckwZ7EmYZq8GO8nrYS/WSxtAf3uNNwLFWlZ?=
 =?us-ascii?Q?LNUJ/FxSduwXRBh0KdtN/1lun12bUT0aIR4XBt4FvRbemk3ygAINyGM7f6Av?=
 =?us-ascii?Q?z9sNGOHLKTNuwPqK5l81gqp6feXTRnS6P1F35nUXP3SbYjEt9vwGcjVszTZp?=
 =?us-ascii?Q?g4TuWACxBamz6IyUtqiOJ/s0LfKixstbK/DRXce+cscAwzRmVp/QKchZPo2q?=
 =?us-ascii?Q?emLLRZ8bsHyHn555Q9uCJvtqQLshnQ9baYqdnhXLqZRkWbyOVHFmGKfRr0W2?=
 =?us-ascii?Q?sW8nccjqtnqOnL+eZSt4bLKeu/tTLguuzOdy4onSSZJPMgM27y4pa0R6m1yj?=
 =?us-ascii?Q?FcNIxkNAd+3I9f68gsQ/xePhUsisNujI4UKf5LRp7ma/Y63FOjtwPPFNjlG3?=
 =?us-ascii?Q?SR2VDT5ewsTPhP21BGa0XKjqm4keXP14Z2zO4yKuB2FUqkStP1UdIEkkc2lj?=
 =?us-ascii?Q?KYdjaw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 507718f9-5a87-45b0-b3a4-08db52282d9e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2023 14:01:12.2416
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Hz3CtzpR4VjzyCu+kkMi7GsCFPCzoVCM9QnBOQGL2SkJA7td7R+exwUI20HeSFmE9Y1kAJG+L6UdnccKxuKjJjRDGKBdg4JqGPA2oxqNnpM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR13MB5581
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 11, 2023 at 05:38:07PM +0530, Harini Katakam wrote:
> Add support for optional rx/tx-internal-delay-ps from devicetree.
> - When rx/tx-internal-delay-ps is/are specified, these take priority
> - When either is absent,
> 1) use 2ns for respective settings if rgmii-id/rxid/txid is/are present
> 2) use 0.2ns for respective settings if mode is rgmii
> 
> Signed-off-by: Harini Katakam <harini.katakam@amd.com>
> ---
> v3 - Patch split:
> - Use rx/tx-internal-delay-ps with phy_get_internal_delay
> - Change RGMII delay selection precedence
> - Update commit description and subject everywhere to say RGMII delays
> instead of RGMII tuning.
> 
>  drivers/net/phy/mscc/mscc.h      |  2 ++
>  drivers/net/phy/mscc/mscc_main.c | 35 +++++++++++++++++++++++++-------
>  2 files changed, 30 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/phy/mscc/mscc.h b/drivers/net/phy/mscc/mscc.h
> index 9acee8759105..ab6c0b7c2136 100644
> --- a/drivers/net/phy/mscc/mscc.h
> +++ b/drivers/net/phy/mscc/mscc.h
> @@ -374,6 +374,8 @@ struct vsc8531_private {
>  	 * package.
>  	 */
>  	unsigned int base_addr;
> +	u32 rx_delay;
> +	u32 tx_delay;

rx_delay and tx_delay are unsigned...

>  
>  #if IS_ENABLED(CONFIG_MACSEC)
>  	/* MACsec fields:
> diff --git a/drivers/net/phy/mscc/mscc_main.c b/drivers/net/phy/mscc/mscc_main.c
> index 91010524e03d..9e856231e464 100644
> --- a/drivers/net/phy/mscc/mscc_main.c
> +++ b/drivers/net/phy/mscc/mscc_main.c
> @@ -525,17 +525,14 @@ static int vsc85xx_rgmii_set_skews(struct phy_device *phydev, u32 rgmii_cntl,
>  {
>  	u16 rgmii_rx_delay_pos = ffs(rgmii_rx_delay_mask) - 1;
>  	u16 rgmii_tx_delay_pos = ffs(rgmii_tx_delay_mask) - 1;
> +	struct vsc8531_private *vsc8531 = phydev->priv;
>  	u16 reg_val = 0;
>  	int rc;
>  
>  	mutex_lock(&phydev->lock);
>  
> -	if (phydev->interface == PHY_INTERFACE_MODE_RGMII_RXID ||
> -	    phydev->interface == PHY_INTERFACE_MODE_RGMII_ID)
> -		reg_val |= RGMII_CLK_DELAY_2_0_NS << rgmii_rx_delay_pos;
> -	if (phydev->interface == PHY_INTERFACE_MODE_RGMII_TXID ||
> -	    phydev->interface == PHY_INTERFACE_MODE_RGMII_ID)
> -		reg_val |= RGMII_CLK_DELAY_2_0_NS << rgmii_tx_delay_pos;
> +	reg_val |= vsc8531->rx_delay << rgmii_rx_delay_pos;
> +	reg_val |= vsc8531->tx_delay << rgmii_tx_delay_pos;
>  
>  	rc = phy_modify_paged(phydev, MSCC_PHY_PAGE_EXTENDED_2,
>  			      rgmii_cntl,
> @@ -1808,10 +1805,34 @@ static irqreturn_t vsc8584_handle_interrupt(struct phy_device *phydev)
>  	return IRQ_HANDLED;
>  }
>  
> +static const int vsc8531_internal_delay[] = {200, 800, 1100, 1700, 2000, 2300,
> +					     2600, 3400};
>  static int vsc85xx_config_init(struct phy_device *phydev)
>  {
> -	int rc, i, phy_id;
> +	int delay_size = ARRAY_SIZE(vsc8531_internal_delay);
>  	struct vsc8531_private *vsc8531 = phydev->priv;
> +	struct device *dev = &phydev->mdio.dev;
> +	int rc, i, phy_id;
> +
> +	vsc8531->rx_delay = phy_get_internal_delay(phydev, dev, &vsc8531_internal_delay[0],
> +						   delay_size, true);

But phy_get_internal_delay a signed value.

> +	if (vsc8531->rx_delay < 0) {

This comparison can never be true due to the unsigned type of rx_delay.

> +		if (phydev->interface == PHY_INTERFACE_MODE_RGMII_RXID ||
> +		    phydev->interface == PHY_INTERFACE_MODE_RGMII_ID)
> +			vsc8531->rx_delay = RGMII_CLK_DELAY_2_0_NS;
> +		else
> +			vsc8531->rx_delay = RGMII_CLK_DELAY_0_2_NS;
> +	}
> +
> +	vsc8531->tx_delay = phy_get_internal_delay(phydev, dev, &vsc8531_internal_delay[0],
> +						   delay_size, false);
> +	if (vsc8531->tx_delay < 0) {

Here too.

> +		if (phydev->interface == PHY_INTERFACE_MODE_RGMII_TXID ||
> +		    phydev->interface == PHY_INTERFACE_MODE_RGMII_ID)
> +			vsc8531->rx_delay = RGMII_CLK_DELAY_2_0_NS;
> +		else
> +			vsc8531->rx_delay = RGMII_CLK_DELAY_0_2_NS;
> +	}
>  
>  	rc = vsc85xx_default_config(phydev);
>  	if (rc)

---
pw-bot: cr

