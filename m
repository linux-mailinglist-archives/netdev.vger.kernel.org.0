Return-Path: <netdev+bounces-4931-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8320470F3C3
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 12:09:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CAFDB281100
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 10:09:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCE6DC8F5;
	Wed, 24 May 2023 10:09:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBEE4C2FD
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 10:09:32 +0000 (UTC)
Received: from EUR02-VI1-obe.outbound.protection.outlook.com (mail-vi1eur02on2056.outbound.protection.outlook.com [40.107.241.56])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CF0FC0;
	Wed, 24 May 2023 03:09:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SLaZ2xJDVsnswKM7N65CY1cNPjaKWaz5R7FhVf77l7bg4PhG3rbf+EOXdczd1RgJysvC2Ip3mbYdRhAJSpaD7lnQ5gOhtmdqFBONkWiYqLvqd1WFrlgbaiLyNhyw1Qo996OC064rXllfQ6DoefIk+uDunbfcsa/alOj75X5sO4nNAn4g70JWnok209waAknpirCK7U46mRJgFZevuuwBTe+ywCiZq5/uDQWc40Mxah8BQ6ReIHvmWWUgrXakIsktfRut84hucRnI3y4Mq800D2TE72OwMG+3yu3Q3IVxBHWezc9IAjEBjFjerHBgXl2y1WqdzTjOKkfXpAQNXgMSSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UchupbWIPHgRZt7OTRW978kpskveo/4f1kcmLAQUKR0=;
 b=GnJsAZa/cvUryi/usmxBAVJN6CnD+nmrHUUmSGnoeywhmzSF5ZkWL//hV6ZbBmntWUdmHH/oFPiWFCSPXV1nt2Pb3kvpWRNKG+0NhdGx/rC42GNBVxlZQ1ypRK73fzVUU8vxCDxwMMyf2Q0z5ZSqZPebYRgKvNRy5542kCq5AvpLMf+urkO6QJxlgUsbnsdol39Yqpk0j/rYVQl/t+hDm1Q9r3TszJxAESnSGrcZq9AFI3/5na1w/67POSuB21NqoAp5wGUitxwacgMKTB1zqkWkaMnpWrheUooEF2VnbXsVbIlviJiByREcH7eRWEQ22wg2lOtZFfNZW42MsI+0KQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UchupbWIPHgRZt7OTRW978kpskveo/4f1kcmLAQUKR0=;
 b=YhyO6IQ0bgqqsLyKWRm8qpNrbKA3VHA9Ld1OCJ+o/32MJ3S2ESRA0f/U3r/SMWY6Dt7FPsxCTNTj9SovIq1DLYVkfeZZgzJfBcLYY/12ZllQvIFbCnqDf6INw9xiVDvISm4HD0L2I3xFHl06uqM3z21xQnFuJUpZSYL24tcloWI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AM8PR04MB7732.eurprd04.prod.outlook.com (2603:10a6:20b:237::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.29; Wed, 24 May
 2023 10:09:28 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::b027:17aa:e5f5:4fea]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::b027:17aa:e5f5:4fea%6]) with mapi id 15.20.6411.029; Wed, 24 May 2023
 10:09:28 +0000
Date: Wed, 24 May 2023 13:09:24 +0300
From: Vladimir Oltean <vladimir.oltean@nxp.com>
To: Harini Katakam <harini.katakam@amd.com>
Cc: andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
	davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
	pabeni@redhat.com, wsa+renesas@sang-engineering.com,
	simon.horman@corigine.com, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, harinikatakamlinux@gmail.com,
	michal.simek@amd.com, radhey.shyam.pandey@amd.com
Subject: Re: [PATCH net-next v4 2/2] phy: mscc: Add support for RGMII delay
 configuration
Message-ID: <20230524100924.ty37zfndvh2nlgj3@skbuf>
References: <20230522122829.24945-1-harini.katakam@amd.com>
 <20230522122829.24945-1-harini.katakam@amd.com>
 <20230522122829.24945-3-harini.katakam@amd.com>
 <20230522122829.24945-3-harini.katakam@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230522122829.24945-3-harini.katakam@amd.com>
 <20230522122829.24945-3-harini.katakam@amd.com>
X-ClientProxiedBy: FR3P281CA0001.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1d::10) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AM8PR04MB7732:EE_
X-MS-Office365-Filtering-Correlation-Id: 2443c480-9664-4596-fc8d-08db5c3ef584
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	9qKfE6vq5FBhw/DeNfAzo48OIPsH7H/7YWVLJA3Q5ESJkdJVsoU28M+HQNUJlb/oxjlZ3XotNgMVQ5O0yCOGFFuAQJYc1jUEOBQdALArYmStOhlciT16uWimjZV+jhHgKixRinc6rbECOj9GDjSk2gafTE2LpnYufTnlUcIGtPUeYjOvPfacXMnMF4++z7naeajBKztvGw85QAVjXOzsqzf5l/L+3Bt9r+l3fWt5TaxC2O2GfmA/NpKbL2qf5NCRAgbX89NT3rUciAlFK5Q3By75yTkseCpJzbJmf1EUsEpdTMgPE94VhYaXIJgLVUTuehirRQIIB7lnJsURMDsR5MpESVXRHiWd9djun5kKEMr6IioOQ3gZcvidirehGagjnVAjsUN1w4Gj8Z9sfs9D2GVMCwhuxIzLlqykqN752j5ljYzTFudQyHMaYxidG42kjuYP3rj4+DnRB8xvQqI27OtIsm4s1afTkoBqjsthpJQKsuXHdrx7eZLjMGpIDIKNmKqgPkyJJsMQ7DYieZaPjoP5vGDqxnd2qOlz7ruFYhKn8pu3rTQs4dalUrUbcUh/
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(7916004)(366004)(136003)(39860400002)(396003)(346002)(376002)(451199021)(33716001)(6512007)(1076003)(26005)(6506007)(9686003)(186003)(41300700001)(8936002)(40140700001)(8676002)(83380400001)(66556008)(6666004)(6486002)(66476007)(44832011)(7416002)(478600001)(38100700002)(4326008)(6916009)(86362001)(66946007)(316002)(2906002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jxqF2tDVLG3pqqFAuhDvqoPywBI932Wuysd6M/loliqh+1ETDaN4P/SdNmxr?=
 =?us-ascii?Q?/qWB7Mk8i45uOt3PKqG7xDZvfYQIijiPtAyG4D+6MGOP6Uzi6DToLFgmzTVH?=
 =?us-ascii?Q?oyYsfcKMtMsOg8Mng5VKsxkIM6H05E1IxdUXjPUpECHT9wIvOvhxBY5MrqPY?=
 =?us-ascii?Q?S16rHHJj7ab3K3bKs9HdP6/ApgbNrqMKM6kocWRei7s/EaEvW4B+0RBLHYpf?=
 =?us-ascii?Q?71WZtLvadDFbaeaSizORXfrRenlhZSpgxw1lzcurc6I0yzkPj4xNMDmIIiko?=
 =?us-ascii?Q?QyRQ+xbWkzhNNbiaCeJD1x+Y9kka0++OyZSuPN/r3Jl49kFZtafu/+FI4okV?=
 =?us-ascii?Q?iXMx2gBCf3x8F6QnkHOJ47cXGtjRh2ZIIJv+LSzZW+5pjyhAvI8HjgmbpgME?=
 =?us-ascii?Q?sEvPS9s4tFu8H+b5Y9SybTVCCi9HKxVmYWtoVuV73OlLnBo4goftaQeb5vf5?=
 =?us-ascii?Q?WPfk9qUvS26Y3A84BG+DSg1dbGbuPUaEf+yZ2XaIx9C1+JIg33D4BrX43oov?=
 =?us-ascii?Q?ELnh9V/0/zd5KMhXsCBFwZlFUa808Ifb+kuevYVWAg/AFlswzaB7xRbU+xeF?=
 =?us-ascii?Q?+fmWGR6RDT+At1PipPzi2lWfzHj2mdZHWzhSeE9JhvAvnb4U3sgOIMQJ6zWB?=
 =?us-ascii?Q?MqaQ/xaMizaQ+PVkComkEjWLsHCOZ/U9K/lbV9AWVmDj3vwjaEJT811CtB4L?=
 =?us-ascii?Q?lDNF9C8OTqAkFa1LvkNVw5r7TQLH0tl9h6rCV2qOLQv3FGR8mBZRwI/5IX2C?=
 =?us-ascii?Q?M+JuyXT0CF1drL7CWbT1FdkUzUuPEevokGcJKKIDCiTe8CpacO5kKcpkpCuu?=
 =?us-ascii?Q?+FS6KI/RpV1onbQ8qsH6AjmdTeAn6iuASgcPdZof0qWzLBriERh4EXMyxlLI?=
 =?us-ascii?Q?mLdYnZiWPWVEMST0Q5NiQ+4bMJxn8FofPwgig8GIQZEQgdmcbCTUXxFPTw7M?=
 =?us-ascii?Q?fjcz5qlfwrWslxIQqLY/5Bg3gQDmTdscXoMveisLPigHLkNEtqzvKJPPtqsO?=
 =?us-ascii?Q?5zAt9al8Jn44ne7sp9eDEqdJgHXCHkCZAca5VzJ5pzpDodMZCE0JBGoLqy6e?=
 =?us-ascii?Q?1ocDGIp4xW42ajYlYcos+Sb8oKI7yXCXj7YzWMEiSMOlpG/bBG4EGpEYp3UT?=
 =?us-ascii?Q?8q9naEFdUgtY4MVIkG9KiWslCeRq5Tq7YqN3yoePkvxdgzKOQ3p3p7KQoStK?=
 =?us-ascii?Q?cRDT6gsWtqJme9v2p0fXHZUbT647rpAEmz3RcKqvuSvaOnU0hvVKT/3Ftvxi?=
 =?us-ascii?Q?dLeZa1pE1m9LWiNZsnat8yixRw9ayRC2Rz/U1HHoG1JQoERRDZV0lKrgRWAN?=
 =?us-ascii?Q?4RIVa/li9WhJVDyOWTRyBlYVJP7sxy9NUadlpQsW0ySvj1yDqqqSlIhbqAus?=
 =?us-ascii?Q?ZX1MNITkVS8wqkJmDbKenHjmKBnBSbuHkF3yGeCvBciQapWpJiqRAclWYH9T?=
 =?us-ascii?Q?vADtTEBewo3KT6p8nUH/FBVjYGPTruOwPRGju5HMGW0OqD9am49ksSfmXNkP?=
 =?us-ascii?Q?PZhjUaQUQjI4CdmrhAd/YOsIzmew3qFYhm4Ii6A15DhJX/PPy6UVrf7doHuh?=
 =?us-ascii?Q?63ARCzK9aHhZxlIvkTTR0DD7ogSU6DeaTzPyJuNzG27JvQHk8Q5eCDazS/o2?=
 =?us-ascii?Q?OA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2443c480-9664-4596-fc8d-08db5c3ef584
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2023 10:09:28.2289
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M61gB/6Yx6jsll8033zwigXsMUjl0lgWi/iwKINFoANA5qWxgnsTVX9VYkItoxHrszMg84WE9WBHftDJdJTxQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7732
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 22, 2023 at 05:58:29PM +0530, Harini Katakam wrote:
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

What about vsc8584_config_init() -> vsc85xx_rgmii_set_skews()? Who will
have configured rx_delay and tx_delay for that call path?

Isn't it better to absorb the device tree parsing logic into
vsc85xx_rgmii_set_skews(), I wonder?

And if we do that, is it still necessary to use struct vsc8531_private
as temporary storage space from vsc85xx_config_init() to vsc85xx_rgmii_set_skews(),
or will two local variables (rx_delay, tx_delay) serve that purpose just fine?

>  
>  	rc = phy_modify_paged(phydev, MSCC_PHY_PAGE_EXTENDED_2,
>  			      rgmii_cntl,
> @@ -1808,10 +1805,34 @@ static irqreturn_t vsc8584_handle_interrupt(struct phy_device *phydev)
>  	return IRQ_HANDLED;
>  }
>  
> +static const int vsc8531_internal_delay[] = {200, 800, 1100, 1700, 2000, 2300,
> +					     2600, 3400};

Could you please avoid intermingling this with the function code, and
move it at the top of mscc_main.c?

Also, vsc8531_internal_delay[] or vsc85xx_internal_delay[]? The values
are also good for VSC8572, the other caller of vsc85xx_rgmii_set_skews().

>  static int vsc85xx_config_init(struct phy_device *phydev)
>  {
> -	int rc, i, phy_id;
> +	int delay_size = ARRAY_SIZE(vsc8531_internal_delay);
>  	struct vsc8531_private *vsc8531 = phydev->priv;
> +	struct device *dev = &phydev->mdio.dev;
> +	int rc, i, phy_id;
> +
> +	vsc8531->rx_delay = phy_get_internal_delay(phydev, dev, &vsc8531_internal_delay[0],

You can just write "x" rather than "&x[0]".

> +						   delay_size, true);
> +	if (vsc8531->rx_delay < 0) {
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
> +		if (phydev->interface == PHY_INTERFACE_MODE_RGMII_TXID ||
> +		    phydev->interface == PHY_INTERFACE_MODE_RGMII_ID)
> +			vsc8531->rx_delay = RGMII_CLK_DELAY_2_0_NS;
> +		else
> +			vsc8531->rx_delay = RGMII_CLK_DELAY_0_2_NS;
> +	}
>  
>  	rc = vsc85xx_default_config(phydev);
>  	if (rc)
> -- 
> 2.17.1
>

