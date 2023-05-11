Return-Path: <netdev+bounces-1774-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AA6186FF1B4
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 14:40:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E17022817D9
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 12:40:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 408BE1F928;
	Thu, 11 May 2023 12:40:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32DE265B
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 12:40:54 +0000 (UTC)
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2101.outbound.protection.outlook.com [40.107.243.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A531826B7;
	Thu, 11 May 2023 05:40:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i/fQaDT8fn+zc5sZUlnUveV1FvpaXfFVRsATJ0g/W5AULlHWjWINLOs+nf+OsHkic8rTzMDB9EPqykwbV1BYPuxZcnORD0TOs0cCke8aTNNAMkU2nRe8qF9ikJO//T5WFseIf47rK8t9MRy8IB8C/p06f3hBiwilisQl3WPIIfI9/f5qdV31WyZ4eRqiJGKdxZE+swflVuRjYRKZve36C7jMkJHsAaeNqAkaxeWE7rCR/nxLrbzWnKpEaXkMuGcj5UFkVJzEch/VsxVtXQud+hygZFJ2I8elF2W4fsgLMeYORmoO0iRdVAlmSOezmD0EZdcp+JIHSbxCus2PeTs1+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0MvIYagl//tRv0ZmiPSm9QPDK0XaJa8x6Px6UDM3FqY=;
 b=j6h3EU9k//avUxLML0xuVa+J6X9Vwp6JUf22APb4HrxjzdB/uO8HYO+njOlflWEQNgVfL7nZWEyETZ2QDydsgm5ZbqJQBHQkj7cXWdKuw6MXFhrQJ+lQIS5TAe5VhhqR2m7h23RzAHH+oRPYHWLjVdbHJjYjkF7v3kwf6EbnxKGyBrSV3QU397GLRxP5lI3ZGStlyIpenaVN/+4KMEgkrgrgkSDYV+r3SbCNw9DTfngPuU2o+jxQQaHBgqn3HYGpgK8cFZgrDepZx3Y/Qme37Rj4vN+CAkZli2H2W5fLmARUI/V2CDJ655Uj/lAyJmhWhe1IUZwhG4mBwefbtPooIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0MvIYagl//tRv0ZmiPSm9QPDK0XaJa8x6Px6UDM3FqY=;
 b=O2u6cZKDspkVRDq+Nrn72tlGkPUOFwoC5OSEg2lo67oSh6tUrje6vsmcltdZcMXMlsNYI4fE1s2rM9fsc13tobwfxDc+OHVC+J6IPFUIchKASV4Bg1KgAv2heY1AcWH7Nt1a0lGj0Sv/WYgrQDmMfVakqsnXO06MK2D2GbK7qB8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW5PR13MB5904.namprd13.prod.outlook.com (2603:10b6:303:1ce::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.20; Thu, 11 May
 2023 12:40:43 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.020; Thu, 11 May 2023
 12:40:43 +0000
Date: Thu, 11 May 2023 14:40:36 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Yan Wang <rk.code@outlook.com>
Cc: andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux@armlinux.org.uk
Subject: Re: [PATCH v4] net: mdiobus: Add a function to deassert reset
Message-ID: <ZFziRIzP/sXZMgiU@corigine.com>
References: <KL1PR01MB54480925428513803DF3D03AE6749@KL1PR01MB5448.apcprd01.prod.exchangelabs.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <KL1PR01MB54480925428513803DF3D03AE6749@KL1PR01MB5448.apcprd01.prod.exchangelabs.com>
X-ClientProxiedBy: AM0PR08CA0014.eurprd08.prod.outlook.com
 (2603:10a6:208:d2::27) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW5PR13MB5904:EE_
X-MS-Office365-Filtering-Correlation-Id: 77b63915-c0f9-4207-4dd6-08db521cef37
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	NfnWglxtc4XpFG9ACKtyhLCZ/D15pZSLPgh7FAnqtjjy455xtOfwPAay2WDrHwOcC2jgMgRGPNcS9I3qPlWsRfTWhC6dqWuZl7MRJrVg5iuSoBsotcWcVA7MEjyGBojdliR5KSIU5YPeJkZCtc4YwplsjO9jUc5DOJMO9IP+RcT9bFz77F+BfMdpkpJ3wkDTfHlxis9jilgOT0slR/HLZM/AdldSPOPRj2O0nBn54ipYR9yBp0zWMJEtNcjLpmXqRA/LmbZtt0F9ln6ftESzyiORypzjXARC4SGa4BN7qAzPTMk/5NdvxQI++Y2GyprgjEC6QsszsDzBZbkhtUv4kF2I4Cvh5ToGSpfgSUedVPHaYQ7dSN6a2jHsDHS6SvRUTSh3CEtGWr4r8y73fASiS3Jl9zLFHbMdr1Oz5I2Q7AArfOhLoCS3niPUCwdzwsPcMGDihjIDjFiXlGrk6Mk+I/TPHliTyeQbqOMQ3MCBJgpFrm/vIZfYMhuloE+kXEWhC3OLu8hnjet/s0Vzk6lgTxxTD25q1R9dWHJpDnqJhSo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(366004)(136003)(376002)(39840400004)(346002)(451199021)(38100700002)(478600001)(2906002)(2616005)(83380400001)(36756003)(45080400002)(966005)(6666004)(6486002)(5660300002)(316002)(7416002)(8676002)(8936002)(44832011)(66556008)(66946007)(4326008)(6916009)(66476007)(41300700001)(186003)(6506007)(86362001)(6512007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ALAEj1Qv+ObosDmG49dbYI2kqRdNpZsRe8ZS1D+N3SLAX95rPV2zPdNsjB+/?=
 =?us-ascii?Q?JeC5GVhqa5PzNyNvym29OWB/PnwFCkwV5uAl8w+zoeOk30iZnnKFG4lYYLt4?=
 =?us-ascii?Q?2O11IwROLR9iajsFHHbBO6mUuPqJ7x/a4GtQL0H2+jms/hOYKVq7bG73VYnp?=
 =?us-ascii?Q?pLAc//iH/3KssSocRJePa3WHWjLeFXz3fOxw1oQWX/YS1N7Kef1WKU6J+dSv?=
 =?us-ascii?Q?PMG578J0ceuF37TZ057Dv6p30QPZ5O/75pMezzid8H2cjsXcpte89sDU6gfL?=
 =?us-ascii?Q?4supSaQw6MBNT2rUmOSbL8aZTt/Fq9OrJrf8jacPSk/JrFbTlTa8EQi2tbbC?=
 =?us-ascii?Q?CUCWoRllWwAXkLE2fHzIOU0ReATBZDTT0Hmt31lI93MnQRilmKhR2iz4MjsS?=
 =?us-ascii?Q?erVTCLG3+f2mniIXKdhvQbaFN9Xs/orBHLhgqbkfLbMJfDfCj8Eznu7Tllou?=
 =?us-ascii?Q?S3710bubwrnlZ3Say1VzzRwZnAxLWwCJ9JfGCbojTOlIL3c4x+uKErxh5A6J?=
 =?us-ascii?Q?QYsKLSAo+zUP3OL1n8R0StCBtUYMMInbRGa3R9VPwtEe90REkJ9ZKarjQaeL?=
 =?us-ascii?Q?quF4C+FrJusMUgz+pUykEAlRn274JcBvbVsIKpzRbWPrqKYUnv8+tRQtrABO?=
 =?us-ascii?Q?jR9RqY814+HX1utMshcQomcLz8nk45VevXsblzE+TnVpZz0rP/zUu6NHAzaW?=
 =?us-ascii?Q?MHD0QOyvLNEJsvTzPOZBvtzQP7xh+J+Z4qu2ndTMnK9SwAFbi898JR9U0hZU?=
 =?us-ascii?Q?tmPIMTD78Jfrj34goProyv1OxblRveF+WjUn9SO3WhMCZq6QkrSU8gVu3PaP?=
 =?us-ascii?Q?9Jq7IsE6a+U4ddMGq8bkxR1pQCosC62w8cB2bZEMSoWjMAreWho3KqlvF7y2?=
 =?us-ascii?Q?HrT6gHvG60/0jrealoXzxhWYNPowgplPieHDQy5Rjh4YqKzb0qWzfgh9jdpG?=
 =?us-ascii?Q?dj/+/uNpsiagZS+nwI1K8OUN3n2QlUiUuc3g9FaENHwahrO+3w0PtJNQCyDf?=
 =?us-ascii?Q?XLKromFes2eirll7HtbfzvKBWXcAB/QOo7K+qgJp4KQqcmpn7LkiV+IS6nbp?=
 =?us-ascii?Q?1OWhonoLuE5YmAKBtaUPvS4tmCG/HqhsVfV6o3X1rLrPQPtzXOxrjjYEpCcZ?=
 =?us-ascii?Q?BZD5zslVEhYEalHrTF3zbxJ37MzoYajjJYiSANKol2Itgt2pNw5TFg+BbUmo?=
 =?us-ascii?Q?YmEIETzwECLLr8tmK6VhZVQtPPOcrDCQzwqlg+2xMlPSUpfL8O7ncj40xYCA?=
 =?us-ascii?Q?KOGrebH/mCMVO8d8q7v7o/FA62RgsqfR01/VV2/p1FNYv4ioKx5FCiTcSODe?=
 =?us-ascii?Q?cGohtMXCqq6ecXQN06tc1L0C1Pce0oN9xcD0jAvhTx3VE7LP04QVxMvYieUZ?=
 =?us-ascii?Q?gZET5WgeniZVQFqC1R5qgvKE1NSRqASqXrLeNVwAb9HCteuBXin1fi9QTJ9s?=
 =?us-ascii?Q?KJaGpSWudjzhroAZosiemgGWvKGL4KbxoY6oz+R9DeFCiBIjTdK2WzDrkCV7?=
 =?us-ascii?Q?uInou8dsn5y6KjjT1DpD5JvffsDHB4+ui0qIynomeNLlPHx97BaQTP+p5mp0?=
 =?us-ascii?Q?oZpyoSwmCrM8LS6ta7x0vaGKyjgpyrMdRa9ABDcFY2ClMMOXLqv7fW8uQy1z?=
 =?us-ascii?Q?lrr00JpOC0RJZy9ByuntaXZvZVQw4ROk8jpu5cq1gxvByyiUZEK9PvAmIwS6?=
 =?us-ascii?Q?uMPYYw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77b63915-c0f9-4207-4dd6-08db521cef37
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2023 12:40:43.1168
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B1Hn7qxiwGU+4B7bVuZipwTf5FdyAoRO0kyED21v6k6YIwPGhbLXrxg6wyiXcHVuVpON6/fPsixOOKfiMJhY/8jJf0w7x79jSfa+eyueT2E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR13MB5904
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 11, 2023 at 02:59:09PM +0800, Yan Wang wrote:
> It is possible to mount multiple sub-devices on the mido bus.
> The hardware power-on does not necessarily reset these devices.
> The device may be in an uncertain state, causing the device's ID
> to not be scanned.
> 
> So,before adding a reset to the scan, make sure the device is in
> normal working mode.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Link: https://lore.kernel.org/oe-kbuild-all/202305101702.4xW6vT72-lkp@intel.com/
> Signed-off-by: Yan Wang <rk.code@outlook.com>

...

> diff --git a/drivers/net/mdio/fwnode_mdio.c b/drivers/net/mdio/fwnode_mdio.c
> index 1183ef5e203e..9d7df6393059 100644
> --- a/drivers/net/mdio/fwnode_mdio.c
> +++ b/drivers/net/mdio/fwnode_mdio.c
> @@ -11,6 +11,7 @@
>  #include <linux/of.h>
>  #include <linux/phy.h>
>  #include <linux/pse-pd/pse.h>
> +#include <linux/gpio/consumer.h>
>  
>  MODULE_AUTHOR("Calvin Johnson <calvin.johnson@oss.nxp.com>");
>  MODULE_LICENSE("GPL");
> @@ -57,6 +58,35 @@ fwnode_find_mii_timestamper(struct fwnode_handle *fwnode)
>  	return register_mii_timestamper(arg.np, arg.args[0]);
>  }
>  
> +static void fwnode_mdiobus_pre_enable_phy(struct fwnode_handle *fwnode)
> +{
> +	struct gpio_desc *reset;
> +	unsigned int reset_assert_delay;
> +	unsigned int reset_deassert_delay;

nit: Please arrange local variables for networking code in reverse xmas
     tree order - longest line to shortest.

> +
> +	reset = fwnode_gpiod_get_index(fwnode, "reset", 0, GPIOD_OUT_LOW, NULL);
> +	if (IS_ERR(reset)) {
> +		if (PTR_ERR(reset) == -EPROBE_DEFER)
> +			pr_debug("%pOFn: %s: GPIOs not yet available, retry later\n",
> +				 to_of_node(fwnode), __func__);
> +		else
> +			pr_err("%pOFn: %s: Can't get reset line property\n",
> +			       to_of_node(fwnode), __func__);
> +
> +		return;
> +	}
> +	fwnode_property_read_u32(fwnode, "reset-assert-us",
> +				 &reset_assert_delay);
> +	fwnode_property_read_u32(fwnode, "reset-deassert-us",
> +				 &reset_deassert_delay);

Does the return value of fwnode_property_read_u32() need to be
checked for errors?

> +	gpiod_set_value_cansleep(reset, 1);
> +	fsleep(reset_assert_delay);
> +	gpiod_set_value_cansleep(reset, 0);
> +	fsleep(reset_deassert_delay);
> +	/*Release phy's reset line, mdiobus_register_gpiod() need to request it*/

nit:

	/* Release phy's reset line, mdiobus_register_gpiod() needs to
	 * request it.
	 */

> +	gpiod_put(reset);
> +}
> +
>  int fwnode_mdiobus_phy_device_register(struct mii_bus *mdio,
>  				       struct phy_device *phy,
>  				       struct fwnode_handle *child, u32 addr)
> @@ -119,6 +149,8 @@ int fwnode_mdiobus_register_phy(struct mii_bus *bus,
>  	u32 phy_id;
>  	int rc;
>  
> +	fwnode_mdiobus_pre_enable_phy(child);
> +
>  	psec = fwnode_find_pse_control(child);
>  	if (IS_ERR(psec))
>  		return PTR_ERR(psec);
> -- 
> 2.17.1
> 
> 

