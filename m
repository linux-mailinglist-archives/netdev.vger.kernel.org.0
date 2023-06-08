Return-Path: <netdev+bounces-9201-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A363727EE8
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 13:37:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CA4BB28169C
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 11:37:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB46C11189;
	Thu,  8 Jun 2023 11:37:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A56D1BA4D
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 11:37:04 +0000 (UTC)
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2094.outbound.protection.outlook.com [40.107.243.94])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90622E6C;
	Thu,  8 Jun 2023 04:37:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fAkpQuxzonP15m6gnQCmy9SGXWJbswd9OzL5wH/wmuIfvHJDgTwOcItyNfqZC2C5AB44cq5GCttnQoM91oyHwCpWKA/ZpmkmMTePIXElXboIQeuJTeLIB3TCXOEq9sUw+5ZVfC/iKVOissSfNbV2s1cLlVr4XeoRSh/RV3X9gcPCulWFZDsmw5QGBDFTllcP1Gm+pvkFvcyS9bcFc4wyO86AzkW1np06wDQk0F1u2t8HTBOLtLtG8N21u/CSkmRiAaT3svLeBaKOSV58YgpCcvh0gf9+FTtELfgBn6FuCcUWeNLxDXwgfvjpAJ3U/Yq73V5gLcNo4KJizrZknLpayw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BWP7x1n+zFZP4gGJohPdinTaoF0sz/bXoNBc5mzyPAw=;
 b=Y9OV9+kOs0XOxk6ow+xT/KAqea/TRV2kW1/8Jb1mNWIOpureKztn2B3/d7aOMO3OaAW5/y5okXBm891iLoJDrVksJVhEJwNy6tzWHfR4ASE8WKrfSNSb4mHDohFT6ZyZTKsG0ZAfgoz/VFGWipVqVMRFPc0HTya/7GeYwZi9OHHXpgH6QXEW4WG2RBf+HuNcd732ST7yATDFRmH5GRXvpqAPk7zG10MaR9yxbROxjyr0Z2Yp+YIPh2t4O5H0WEwiRyqR9biOyXIwwBo6Y1rZ7CWsfssdD10YoWVmiiZlqaAIYat1XZCByT6tllJ0NAKO6x9t3dwVfboTE0YeyJW1ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BWP7x1n+zFZP4gGJohPdinTaoF0sz/bXoNBc5mzyPAw=;
 b=rBk7d0EyQWkErOyb6S3egoNzqxDQMtKmrq8/ECoUaYv/M6t2wdtLTfvauErYG3778ESe1/ioMsSLwc5+FurGddpLzXlxckflwj5JrHlFytnPca/Ad+Oep2p2lCRr3fp0a3xUby+Ws930h71je4SMBB37D7NOsVdRXlgsIPKLncc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH2PR13MB3623.namprd13.prod.outlook.com (2603:10b6:610:98::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.41; Thu, 8 Jun
 2023 11:36:58 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%4]) with mapi id 15.20.6455.030; Thu, 8 Jun 2023
 11:36:58 +0000
Date: Thu, 8 Jun 2023 13:36:50 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Florian Fainelli <florian.fainelli@broadcom.com>
Cc: netdev@vger.kernel.org, Doug Berger <opendmb@gmail.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] net: phy: broadcom: Rename LED registers
Message-ID: <ZIG9UnGz+no4feYT@corigine.com>
References: <20230607183453.2587726-1-florian.fainelli@broadcom.com>
 <20230607183453.2587726-2-florian.fainelli@broadcom.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230607183453.2587726-2-florian.fainelli@broadcom.com>
X-ClientProxiedBy: AS4P189CA0023.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:5db::11) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH2PR13MB3623:EE_
X-MS-Office365-Filtering-Correlation-Id: 45f56ac7-c27a-4573-e682-08db6814ab07
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	BRiXgGDJwkeK7VClDIew35U7vfP0V6OKovu0CWqJz4vRy+SMbTZpb5YtG/WXU8onSvHD5/RXmwVKbRH2S3oAoS5oFNjotqqV5mhTcYx9u2QkzUUyinHCj9Jau5NeaVcaZXsnfuoZ0yKXZnqIrGlK1m41qh42o4PjUX3wb9XXoGky1AvCAaOCN8cA/xpfsMzdzJL018YAwlmZkh7IY2ElrrlfO2JLbg56tG+spuymY+6SY+2/cfPGupu/sSkDsx/hfTZJaOszsIkNEwUs5Ico8YxoA5qSQ7UWdAraMHxY7E+XeQvO2fteUzhx0NqjkCIjU+8hQ6upaS4+l6wZ2CpBBSGWZF/b+Di90+mtlwwDVlZQkD2sBOJ9orkQ51UGiB0WJ+ptYfQwwllt7OcuG6rD0l8zsTRjBmT/4PYxY+S2+G2V96iPo8tMecdEfbUaeIocRAHZ924Dfr4DODa26poQCqCu+qrOVVeUbM50iPnFhdZCbzY/XlNzgXkvvtTb488E5nIZ47woLJdAIclV4budZoVvsjeUxlvEx1AhEKECvy/sbbuG9bbBoIv+ldkwJQPG60ynzzvfadF3/c1VY1VhMUgsrMO/hp7rDO9ZYEUN1eQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(136003)(366004)(396003)(346002)(39840400004)(451199021)(86362001)(36756003)(66556008)(54906003)(478600001)(6916009)(4326008)(316002)(66946007)(66476007)(6666004)(6486002)(8936002)(8676002)(41300700001)(5660300002)(4744005)(2906002)(7416002)(44832011)(38100700002)(2616005)(6512007)(6506007)(186003)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?urj7ZhZqNIMsxaBJlJhJmWR3Nccju1etZ7wWzbXvdyXaKwJERRlcwqH49Lsr?=
 =?us-ascii?Q?k+RdYNs0sjJaiqMQJBm4KGMZzDB+i/b6UlvE7vbeMq+mq7KYehF/1e8iKCLS?=
 =?us-ascii?Q?pC+F34igkRfMKb7W0eqZvu/3lYsUgyNNkY/GHH7oRih39Duo+sn+Migm4zsO?=
 =?us-ascii?Q?Ox6CHBbChdnfFdHj3DcoeGPTrNtcXJrM1esiqO6g27281qOqF57NadgmA9Qf?=
 =?us-ascii?Q?iuc6DWk4WEYElsFdE31Gw9c1jWM2j6zEhj1MGBmW4GSSj0ETxJOBM/pENGeq?=
 =?us-ascii?Q?x+RaXRWm6h4CAq59DNRBVKw3vT/IR+XOZt9K7lLAS10DtVILXNnNROaRTIE8?=
 =?us-ascii?Q?2ikCsSRIfGGddRbh1c3G2fddgojOhaygQKanAyMFMEH5z+9Xt5XpwDwzJ8lc?=
 =?us-ascii?Q?a1nSpcaho7b8xKVGkxMrLNGamGekCWlvnHx45/jRrd61i3Eh0+aI7pv4LJmx?=
 =?us-ascii?Q?XRn8DHLtwNpGnUSfY5uSPSJajt7smCF2d/R0yU+HhiT6zosse61SmMroSSBQ?=
 =?us-ascii?Q?8aDAns59rRGaWG3zzXrjFAiCyoAS7wn/599pHVgjAXIdepGUFtV2YMsxuySt?=
 =?us-ascii?Q?GUBrV4SbF3U3Y3wCLtu/hyVWt7jb3VlNLIMNM/uzOLMnP3UkBNSQcM9pDrrV?=
 =?us-ascii?Q?93dp4ucw6L8f+fj0gRIYXpzQLbY8XKJFHnnwp0TQ71Q3/jeeyBTcy7ZPaMvD?=
 =?us-ascii?Q?2mdAHmL5zB4mFvzrFf1effCeOy7RKEK5q98QJxGszJN+sroIGdrZJZIvZJhu?=
 =?us-ascii?Q?hZImHDYYIkw//O8YsVxbTqynqlho9D30nfMjt4V6VZm8SUf08sOi6vgrAeoM?=
 =?us-ascii?Q?Y8k04oSAGmODOXgHsMHGDwQwhdLtE3LCyMNvb2sZ374bWHTIpVZO5/XkazAE?=
 =?us-ascii?Q?tE5N5CyPAAJbHbz8kDd3mZbALN7eOyCqDC9nZ2pvdN3U1I+oqdQ2ZtUpBqwG?=
 =?us-ascii?Q?PKdwNHvYDhQI2B1smahmjLtIVR6RZljD2p8dBtKBS0dAj5kzTASj487RrK2Q?=
 =?us-ascii?Q?xRCF/+aoGmwrAyN/OGyx2/cccGXuTi1YKNazRunEYBTtW7ClEH4Nlzv0gTS2?=
 =?us-ascii?Q?YaHbAPn+DWkKijK2h7tqEbdxpq6IlCkLQoSFRYzn6698evK9qqLNuM2ty4tT?=
 =?us-ascii?Q?s/jMRsSYrf4uZOP79AYjgu9KEifQyhzlncs8H1LklcW8wGVAUPtHjPXU29fM?=
 =?us-ascii?Q?fICmsz58E87L+wbEiPAnuJmM7iu2JaF769v/gMF04cprkZENnq/YrgP9B3Ch?=
 =?us-ascii?Q?pLMcGPCB0D5NMJZYsXcyoK7qKlxQZo34c51DPT5JEURh/EL4VpyGnQsGm3+z?=
 =?us-ascii?Q?kTXKFyeEPGtRrLHEPyXSPWXqwXa86P5hKQ+/bc7/5XYcjtwIz7EHRP3hR9Lg?=
 =?us-ascii?Q?pMKbh7Gni76SAacLh30nurNSTqlDg9pTjsdpbH45LLO5hNqHXfjtl2ryZptz?=
 =?us-ascii?Q?5GJLlYzcFJfPa0p7fDNl47BGUlHcAoUnaU2ghsdYFjUf1jYbhbchdHfZxf7m?=
 =?us-ascii?Q?3SdhFye+o4VOwE8eLCp+T17YF8f5gav6Y5rj/l6dLCNi0XG/K3XtK6zKFpA8?=
 =?us-ascii?Q?Z4WTBi2PyfaPQpUYERhxtUm0XjLRhUh9a9YeCSh3GlcvM7+0tb/FKP1nWayo?=
 =?us-ascii?Q?PWDoi9focPGfoyZGKepUB3gd36MD7mDiGMHZVg5oE0mjyLtzRgma/Fw9mnZg?=
 =?us-ascii?Q?EBxT2g=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45f56ac7-c27a-4573-e682-08db6814ab07
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2023 11:36:58.3039
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9s5BQVa2tANDQ0XhDxhpfCGeDF7KmkIQsOxPfebBV3sW3o4EzBKtcS0+1ngq74R5aTvxoZU76hE6GEE34ntkleSUF0yuUTzNwJLmB6YEKV8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB3623
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Jun 07, 2023 at 11:34:52AM -0700, Florian Fainelli wrote:
> These registers are common to most PHYs and are not specific to the
> BCM5482, renamed the constants accordingly, no functional change.
> 
> Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>



