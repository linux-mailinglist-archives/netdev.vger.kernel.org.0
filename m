Return-Path: <netdev+bounces-1717-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 82EA06FEFB0
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 12:11:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A1DE41C20E76
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 10:11:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B598A1C769;
	Thu, 11 May 2023 10:11:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2AF71C740
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 10:11:13 +0000 (UTC)
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2136.outbound.protection.outlook.com [40.107.101.136])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FCD9A5CC;
	Thu, 11 May 2023 03:11:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WylALXCa0hVYC32y8K2ZCMphx/1/JeNv7PxB2Bq70O+pl9My2NYsoBGyc/+czafzrGN98h3H6j+wAaKQiQt/sVUUObHCb4D2lLP1pRLXhHdh7P/bWCKoeN8SI4EK2DucF0h5vheFrxc8A2xMFxtK4dl8glmyEcSFeQ+cU/oXdJzNFVOFEjQLM6X1asdDHAQ7VaNKiRTCQyEqFrU1edj6wonLa0np6VuTLunVago1GzD1ksov5UHRt/JzdE3vZtGI7dXwHk6O+K9OyH1sLAJrtbK6o6SkddQD8RVeIA6ojx3kEGM92DdRpiziPaPlPqRijiUl3ckCYWspivXA7ntqjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b5WICkkxaEYjdDN9UIF9vMTP8RDRH2wFD6vTZ2uu1Q8=;
 b=ky/CS3b+8wvXoLTHgSiVfrJe4nDZduxu2Em/dE7k8UAwM+KqmUjVtAVX2XIdVs1JyB18JYVmFFJtO0+XtTlNeejo5L73SmD5I+DwUbu3D1RBMCTO7gNikwS5Xt3rAkBNZgQuoytDjLsQsaDgimct8qz7rDdH2MpEBMjxgv1Sj4XtxNCGN6KRpg2TSq4NwMRAsS4jNpAI3Pe3A/IPzMq65a06XNk/iClFOD6ErdQvmiz5bO4mc+0P/fqjfFoWtDZKqdTk/EHjL4eNovrufqQPnGN52apiUckHoGad9a/iz0geXgaOtUV6e33IC/YyLlHbyiLgtpvyLaGcS2cWoMYl7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b5WICkkxaEYjdDN9UIF9vMTP8RDRH2wFD6vTZ2uu1Q8=;
 b=juzdE8IEw/sz9k0E3UqEsvTvKVohS1+dQdWi8QzjNSSBLHFWbsesWeNOtjw82n7/oB1yj+ajLT5UXhiBepKDLQn3LQ5Mhq8oznbCJiGFOnK+PCrjDiYbuobv8RcHgerLj6qbEraxl3EEgakrjdmIH9aKKNM1Y40suxbIKOysHqc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH2PR13MB3848.namprd13.prod.outlook.com (2603:10b6:610:9d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.33; Thu, 11 May
 2023 10:11:03 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.020; Thu, 11 May 2023
 10:11:03 +0000
Date: Thu, 11 May 2023 12:10:55 +0200
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
Subject: Re: [PATCH net-next v2 2/3] net: phy: broadcom: Add support for
 Wake-on-LAN
Message-ID: <ZFy/L+oJZV5xfX0c@corigine.com>
References: <20230509223403.1852603-1-f.fainelli@gmail.com>
 <20230509223403.1852603-3-f.fainelli@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230509223403.1852603-3-f.fainelli@gmail.com>
X-ClientProxiedBy: AM8P251CA0021.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:21b::26) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH2PR13MB3848:EE_
X-MS-Office365-Filtering-Correlation-Id: 175c53c1-bfb9-4c2b-ea5b-08db52080708
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	UePQKqQMGbt7l7LUNV5teYwboWQr4WcyyUg5T2D7bai08vIVEhIZ5Wfnr+JoQlBfGsINCMndO7ZeUP3Si8ebpsKvtUBf450/NXY5Yc7iv3PIh94SwmB+XawQFk75r9OEB0SivYysI45Gg8hKxqL9V5yarUS73PgOIleBVorLFAtnpyyKbZQeBvSB9Hi8Cs/JUalvi4F/vfAq+d3iGO5fYXRBhwPsaBCHtSEF+6oV2BUnjmmLma/XzUqLA50OO9NoPEsBsZ2JpAtgFkR84OMtX0zih4aMqVq+MK/9FADgOE2eKuNd3J54GfB5qsDpkY1R/mVtZofeirN4GNBPheWJjY63lvzKCxaRO6FefSfx/hbzVTTQ5VgjpsZM8QxepfOrnAAbzkjDdvCwocjjWICcp2SmzDFB+TGLcD0uoZPW9nDYBxCN+hrehLFTrTd4fsxteTLUFYBVgthdJIjPosGy+5rRX30up177RxMRzh486J3idI4t6aRlcE3FvKTwnsmowgpOP2IeYYDhTv8dQDoWo+rvhq76iPeMbjgXdnu2UEVV4Q/Ty5zx4qbM+2RsPqB9
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(396003)(376002)(136003)(346002)(366004)(451199021)(83380400001)(8676002)(8936002)(54906003)(316002)(66899021)(6666004)(66946007)(4326008)(2616005)(6486002)(6916009)(44832011)(5660300002)(66556008)(7416002)(478600001)(66476007)(2906002)(86362001)(186003)(6512007)(6506007)(36756003)(41300700001)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?VcrMz8Mv4zAKK27xml94xZ5pc69bzpD7nosiB6OnA3f9OBuDFM/xZZPooxZ6?=
 =?us-ascii?Q?pQUMKf1YLQ/rVeW0Em6F2mzOPiBm6mkAYpJPy/vpOszak6eZjP1OpnB7rglV?=
 =?us-ascii?Q?pWvSCGWHG+Ieyd2NLzf3uzlufGSvEkz8dN/dDVJ5OrykR/yZq6rHMHLgHFkK?=
 =?us-ascii?Q?bd3YhYOnAAZl2iy8LAZVrIF7oTlxoBe3Ndsuc1uXieA3gnfRU/83an9mUh0V?=
 =?us-ascii?Q?z2cTvvbJMtC/Q89rRZk+i5hlt4k5bGKge3m7ms0wzOVzXfRiFqFEE6+WTY7s?=
 =?us-ascii?Q?iDSoco57YJE6bFF3xw2/1+8qGAJzrgMQ3ePH5D07tb023++3HN0ADvYf08cP?=
 =?us-ascii?Q?Q7WM9caFgdV6uIOca5YW7P7BX1Jdn8xzTUxyXkmYbr/9XHMn0EHVgO7QL3kB?=
 =?us-ascii?Q?4xpZOgI4Lz8Lc1U7JVOPvEfa531Mgd/dhMCT8FZTqeILFDsbrbOnqfFOXG8f?=
 =?us-ascii?Q?Tjgb+iuf1C9JppOla0CWobBvcS/ksXlzkieV65Xnc+9/QjNoMRoj3sCrArtz?=
 =?us-ascii?Q?P0+C8wOHt4fmi2WUsNJAbxYi90HR1SaHV/LrK/DW/HvR+PRssGGq+/LVy2gc?=
 =?us-ascii?Q?AIvlfdL9md0pMywVd8N6gCr0I3BIatKSjdnjmXJ30vbQ8Z4JGP3xjA8Gt0P/?=
 =?us-ascii?Q?q1j+rU/NrpeAw0lakkHsWcBi3Aib9p0+usMJ3XnciAiLwvdWya3rNqFq/fYb?=
 =?us-ascii?Q?nux3rgS1QlcGO8JYJpzxbXBVOIX/PWyH0owIPnaevGNfc4OaXBDpVhoevtol?=
 =?us-ascii?Q?EEB7Dn57HDBj5Y4YHnvSaHxYAe0ugg8TZMDUJa02WanZnNM6SsdWAXmP2ZnO?=
 =?us-ascii?Q?jqwXDQEBUpwMz6qxontAy2AeAxsjX0aV4MXZyx13XkXH2YFv5fsCf9x2j1rj?=
 =?us-ascii?Q?g04P3vlA4+Mb4Q7fVz3jxS+xR9c3ZSR2gIkGQx2h0MvHlFVN/souR7A3miYt?=
 =?us-ascii?Q?ai+vYUZeNR7Cx3d4jGpOstyZhGRiahBfLZYTEVzKInvtbNbM3wA/GgsmPyfF?=
 =?us-ascii?Q?wPmMiRxwWfzjRG0FSZvvl3CTXjMu7E35lbagi58kBeiAixa0YMT6AwpfnV/K?=
 =?us-ascii?Q?EGXD1AyVSKyb7FXzbuyoHuNatApszR87f/5dbzBMrjOQOsRQnmNXK1dqqLv7?=
 =?us-ascii?Q?XB+0h1nG4UeiFjvsa1EGuuckf6kiWTTt+bFLbWoY8ARjZkAvqVdy6nYz6iZe?=
 =?us-ascii?Q?ABaola9YU9tC9zsF50hJ5AlZaEoQG/R/F3nzG6jJxiwBFTjj+i6jZkV/2ImX?=
 =?us-ascii?Q?yjuvmcyxsoh/U+zRzdDbekZWZr9r3zW4N2OjGwGci7aDDe7zVfkann39aDfq?=
 =?us-ascii?Q?eb/fcGTkt45JhJCA9jnwI8lU1ULueVXjAqXUftc4KecGyZUvPEkBugznu1xl?=
 =?us-ascii?Q?pZeKQt9ofpT1dkHjvBk/xAKmaaNVaaLtvIYKcVDjLj/M1KRPjRN8jT3BOoQE?=
 =?us-ascii?Q?9S4hmZXUKPFqVVCUic7BowphmIJmJq5VPi9TCbmQpXBJHB/GE309uQoU3uGm?=
 =?us-ascii?Q?pLSP5pk6mMzYrL9AmsHXeCH2Puj6PLKOxTWSWIVmI6xvuhQKe9dqgUYWvNOR?=
 =?us-ascii?Q?5vfz8/OByzh8ooFFydr8H//sG/pYP91iUfoRLd6Lr4yQ9auOlLKNbtcs5K3y?=
 =?us-ascii?Q?9Bk8mFAWOkNePYcLZ/TF71NLMVO3FWabIkMPLh6ayyhxCwqOYaqS47A5/MGN?=
 =?us-ascii?Q?ux7Kww=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 175c53c1-bfb9-4c2b-ea5b-08db52080708
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2023 10:11:03.6034
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 02xK+eIvkkOEYTxTOhw0nfIptsJpfm0k7+bjXRvztTT0Ue59MStoiDWabzws5gOL+CJuyyc9aoCu1yIDZHJKJHSDMkLW6uu6kKwWMjHkNOY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB3848
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 09, 2023 at 03:34:02PM -0700, Florian Fainelli wrote:
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

Reviewed-by: Simon Horman <simon.horman@corigine.com>


