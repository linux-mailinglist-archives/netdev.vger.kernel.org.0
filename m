Return-Path: <netdev+bounces-938-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B232C6FB6B6
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 21:23:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 01D70280D99
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 19:23:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10E2D11195;
	Mon,  8 May 2023 19:23:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF4414411
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 19:23:25 +0000 (UTC)
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2119.outbound.protection.outlook.com [40.107.102.119])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05924E7;
	Mon,  8 May 2023 12:23:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dik/wJecQnlmJY8bp3s+XgeR2Ir+37/fO5N5VQezo1bxgSg1W7NgphTdoe1N6Y+QgrmqnY1TCC9ABqddtjsXnp2N1WHU1T8KT6M3s5Fvnmy12lHEWNk0jO+zK1o4ODGLm/o7bTqyFuWryqkDp0jhyp1yC8dOx+LvDT1ECO5v4sKMUQsD1bmWinVw9Pw3rKw93V6OxwAjpiZwxoiD5RscFDpaktdPzii8p9qFAX0pzFfEt5IV7zCC18NCa1RUE05guXeZTE3FYWRz9I3zAQWVxm0oVhLLA24yFEoabVPNf8Ltd/v7wO/auMkDB+6mUm2FT/acrMPtot/wr7Bf4AD7wQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fPPbLfFta5OYEfnB5GoxmXUgLFITd081RyAnR8iZsf8=;
 b=ZZQ8t1JAbuarl7u4e8MsRhaNk8BNGubixa7RwiGNsLXFrTq5gXrHDoZAPx5mE5xQgRMsmxfLAcO+EGH3lkM1pvdlGGsDKcQBLOcusPYPaQONE1KscZpUc6f3rtBt+K8buqCrlSa4ZIVz7EHKdFwX/il9+vS1fSBtHl/ENpPifFJKEElQLW8oMcl/WG1pYjr0hScoyJn+Ql5z9S89jcDNE5xnYRmRbCCBxBtJgw8kPeLVXvlSFTo5M+t+kfsntfWuSWUbXEejAuW4C1hY3q9kjHPPaXibhZ5PU/Xv+UdrDD3fSIZ1W+hogF1yFjZ9PZ7yUpSNEr3EesooRyn4Wu7EpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fPPbLfFta5OYEfnB5GoxmXUgLFITd081RyAnR8iZsf8=;
 b=LWBDNljVZPuYnAtet1RTWxpuKpKBvNR+F6QdgvI6faDZlBFPYcEvTBNqHArlRPQFZ/6I3c8Tn/UgWmleM/UxPRYPnzcdAAnTMe6GpXloFjKBNIuiyNRBbHiMBAhLgTC7VjjmgqFpy7OoaKTuLKH4Bpv8HQNsqj6NbMCki7kLg+g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from BY3PR13MB4834.namprd13.prod.outlook.com (2603:10b6:a03:36b::10)
 by BN0PR13MB4695.namprd13.prod.outlook.com (2603:10b6:408:125::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.32; Mon, 8 May
 2023 19:23:20 +0000
Received: from BY3PR13MB4834.namprd13.prod.outlook.com
 ([fe80::d98b:da1b:b1f0:d4d7]) by BY3PR13MB4834.namprd13.prod.outlook.com
 ([fe80::d98b:da1b:b1f0:d4d7%7]) with mapi id 15.20.6363.032; Mon, 8 May 2023
 19:23:20 +0000
Date: Mon, 8 May 2023 21:23:13 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: netdev@vger.kernel.org, Doug Berger <opendmb@gmail.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>,
	Peter Geis <pgwipeout@gmail.com>, Frank <Frank.Sae@motor-comm.com>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 2/3] net: phy: broadcom: Add support for
 Wake-on-LAN
Message-ID: <ZFlMIUB4rKQMQq9v@corigine.com>
References: <20230508184309.1628108-1-f.fainelli@gmail.com>
 <20230508184309.1628108-3-f.fainelli@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230508184309.1628108-3-f.fainelli@gmail.com>
X-ClientProxiedBy: AM0PR03CA0009.eurprd03.prod.outlook.com
 (2603:10a6:208:14::22) To BY3PR13MB4834.namprd13.prod.outlook.com
 (2603:10b6:a03:36b::10)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY3PR13MB4834:EE_|BN0PR13MB4695:EE_
X-MS-Office365-Filtering-Correlation-Id: df8ee2d7-4df9-4647-5e65-08db4ff9aebd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	dGKK4sLKxWYDNdSPxYf++zyZkiIfdnp16zwlcoaLlz8+qWNToCZa1R4+dL4IrlhSQbOYy47kPc7aHNlpUna7aQWzOzReoYykDZ4MYySZvKGdVsUGyFInIQ45BvkOE2lS4khjV7SJqDwSADg3utEJYKIVG+mngOQKuakXtGrzOqLsb54+zjTCW6JiC82epQ3iPiuOPOBmCxlQfef3W4sVN3kFug/uwZBFPFurFTZFnFh4nkI/88gfbpA91af5YpKvujhSDl/xD++nQFATi1SgIv7SMIpOO3PFj2jaitlf13ijyN7iE43F4/xIeO1u+Q+vuNkcvOKPvqRW4CgKdt7r3/D2ptyLJYTUKIH7+++ZPZ1Eo7TDbiPmGVEOJbgBRiHfpwM1jINENU2xXrJ1a8DEig36xKpZLBuwcTXK/2QZWLb0xOOmTLW/IcGRfmCrlT8SlSaKf5XZEE73IY4LM4kiOJ8dNQK9vptcLndFuuGQASt/71uO+yRcuI9ZWf15yNF9PeMjRD8NkLt7AFCmQapQ2KspKv9AtM/9KD/MzcwyOIo8flcv/+/XI9p/HsSZL5v2h57mGAh7CauysybgHzVtHWBXFaWies/UijVRSOc69M8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR13MB4834.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(366004)(136003)(376002)(346002)(396003)(451199021)(54906003)(2906002)(4326008)(8936002)(316002)(478600001)(66476007)(6916009)(5660300002)(66556008)(8676002)(41300700001)(66899021)(6666004)(7416002)(44832011)(66946007)(6486002)(6512007)(6506007)(186003)(2616005)(36756003)(83380400001)(38100700002)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?U6IpVjmF5UawO9zrRLS2s2/tOv1OVDE4PaTqGzwaE9vzzkpEQnMZL9od7f3R?=
 =?us-ascii?Q?qy1Krar/KCJpaSCner7AhiGbr9bmC651nU5YevO7D0OlndHlWNHSzvtoxGJj?=
 =?us-ascii?Q?FaBZQAnRwSdFAQwPqYB4UXLSrcyWEpIbPEjkvKKtk8B+3nfX/oVHBXkQqNx2?=
 =?us-ascii?Q?uIT86Z79bWypdpalSP3I0FDEp0mB+qfHxkt9PhNnqDfgcRV+BBbVq7M/8xD5?=
 =?us-ascii?Q?WzCvlmdsbXk/4DdmTyZ6FK5WMvn+7WrT7qtNqoI0QtR1+xGYif5Iv4AwuabM?=
 =?us-ascii?Q?VNaSXh874osTdTxMJIlzORFBD/A+Kdxw50gAs7Ce7yD6oBYH7DeUQ73VM4J8?=
 =?us-ascii?Q?GQV5NIY8LhZYxfDv9LYh1r8TummZiH9XzrzC71yR1q4kXS5fRoIORrf7sGB7?=
 =?us-ascii?Q?SZExjK+FL7+jvbr33zKs1spWRvag+D2T77hMZA2lItTlOmwZkmVDP1Wstccl?=
 =?us-ascii?Q?TdtUxnjbQU4ElSkPXvp4TqT3nh+9Qsp+NK5wSQIkHtw1+p5gYT2YCFLjCcDd?=
 =?us-ascii?Q?T+40EqYrnefG7uLHOe6ewHILEgY53FPoukIX7WGNNuPoOsb05hnZPn9d7O9b?=
 =?us-ascii?Q?TLaAG1CzvKnddbFanhOebvdi8vc3uGlR+m1EPg6kKy2UUidT7+6MUzAdZsgC?=
 =?us-ascii?Q?pw0xhJAqfsAK0ZAt/QiMSKDRNGvhAFZVr1Fn3mJwtYZBhokFfLXepBvZemw2?=
 =?us-ascii?Q?ljHsL2wG/8yyncRPyOG1WMJznAzBIXG7DV2bF+XQJ1KnWcMj6PuYj4fPy/FS?=
 =?us-ascii?Q?8SPqAM4M23RlLkAIdow6mZ6P8IDciABpMt6GFY9gJ3dXp20Rt0AKNF+4jULu?=
 =?us-ascii?Q?1Gd4v/pX7Uw04mtWONKRPueU8kN/FD93E6ufrwBlQcPpJGeruLSgyfa/iXv/?=
 =?us-ascii?Q?YIGPE+F7dvEVRUBGDLj4Z8KKhjgHgpEl9Y8+C+lvpXChzr6G0QrrbPIYDJuR?=
 =?us-ascii?Q?yEmjfoUOA5kLGdUxM6OV0zHn5kRDoSKgyu+x1vE/uOHFQspItpQeKjalTSP2?=
 =?us-ascii?Q?KHrNAop7lsCZLmTmnMrjSFPA2O77JX/+6YzW4xxoGO4eOEg9A13qWTPlo8w7?=
 =?us-ascii?Q?WNvUWfiLrEe0h8d1ch6wh58XPrOUop7U5l0PejXOxpBgPM559uNtXz87RiTQ?=
 =?us-ascii?Q?CcSupI4SOO8pJSdXa6//OOhNnJnd3GTMmOE41FA/sVWclciYobc4d+Wd1WXZ?=
 =?us-ascii?Q?CkarUB4aI0ODZgvLk/E5z+IoK2J1ToCead/pNIwlDx7Z09Y5CfWbTHP7xrRN?=
 =?us-ascii?Q?Oj+Z1Eww/u4rMbnLjDJ3p1sALdPtUwotZGZuxhUWczgcfp0jdgxtXVdimrRq?=
 =?us-ascii?Q?zA0Gemz+3RrrqRAzYI/xVJbUd1DvXSLsDnd4qVSO47eBYxaRmS/18j3aos/B?=
 =?us-ascii?Q?DhqJm+K15oqdom9eVP4x9h9IzQTZWH+ojwLL4tdZAVaHYNq7H+Ow1oKh9haJ?=
 =?us-ascii?Q?os9QgULDHP2hy7BqvKlvCYxt29wgUsFz0E1Axw2GDOK3XJH0WW33RDm+v2lB?=
 =?us-ascii?Q?SsdOt8Gqe0LJEsXbNtpctmWwQHDTIVyKkPftHe4HRSIKdSKz5FwGBdAccjfV?=
 =?us-ascii?Q?sYwYfj5YWxVIvq0DQGSr5xl6vNxdqMbR+Vla9FC2jNKB63h7QTOB4LuP9JUQ?=
 =?us-ascii?Q?rlJQ0BmQISt3te+qeG/p9b87dxujuQRa+/Xgp6Yad+Z+3cP8G6u/GePmACuB?=
 =?us-ascii?Q?jo/mnA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df8ee2d7-4df9-4647-5e65-08db4ff9aebd
X-MS-Exchange-CrossTenant-AuthSource: BY3PR13MB4834.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2023 19:23:20.7037
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z7vfEQq6u6NCkrpgkBVXFKb1T5mOZyWwwS8qriqsg8mijxG7oRyBjt+3bRnmkfU6hFG3i4tDwKe8wkWdv6F4AvA2xakyRVx/wOx5+fDT+vE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR13MB4695
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 08, 2023 at 11:43:08AM -0700, Florian Fainelli wrote:
> Add support for WAKE_UCAST, WAKE_MCAST, WAKE_BCAST, WAKE_MAGIC and
> WAKE_MAGICSECURE. This is only supported with the BCM54210E and
> compatible Ethernet PHYs. Using the in-band interrupt or an out of band
> GPIO interrupts are supported.
> 
> Broadcom PHYs will generate a Wake-on-LAN level low interrupt on LED4 as
> soon as one of the supported patterns is being matched. That includes
> generating such an interrupt even if the PHY is operated during normal
> modes. If WAKE_UCAST is selected, this could lead to the LED4 interrupt
> firing up for every packet being received which is absolutely
> undesirable from a performance point of view.
> 
> Because the Wake-on-LAN configuration can be set long before the system
> is actually put to sleep, we cannot have an interrupt service routine to
> clear on read the interrupt status register and ensure that new packet
> matches will be detected.
> 
> It is desirable to enable the Wake-on-LAN interrupt as late as possible
> during the system suspend process such that we limit the number of
> interrupts to be handled by the system, but also conversely feed into
> the Linux's system suspend way of dealing with interrupts in and around
> the points of no return.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

...

> @@ -437,14 +460,38 @@ static int bcm54xx_iddq_set(struct phy_device *phydev, bool enable)
>  	return ret;
>  }
>  
> -static int bcm54xx_suspend(struct phy_device *phydev)
> +static int bcm54xx_set_wakeup_irq(struct phy_device *phydev, bool state)
>  {
> +	struct bcm54xx_phy_priv *priv = phydev->priv;
>  	int ret;
>  
> +	if (!bcm54xx_phy_can_wakeup(phydev))
> +		return 0;
> +
> +	if (priv->wake_irq_enabled != state) {
> +		if (state)
> +			ret = enable_irq_wake(priv->wake_irq);
> +		else
> +			ret = disable_irq_wake(priv->wake_irq);
> +		priv->wake_irq_enabled = state;
> +	}

Hi Florian,

If priv->wake_irq_enabled == state the ret is uninitialised here.

> +
> +	return ret;
> +}

...

