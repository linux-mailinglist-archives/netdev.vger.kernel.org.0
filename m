Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0710A501C93
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 22:22:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231304AbiDNUXr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 16:23:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346258AbiDNUXp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 16:23:45 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80119.outbound.protection.outlook.com [40.107.8.119])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DC10C6B79;
        Thu, 14 Apr 2022 13:21:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AyEhBdOYEbM0yRhI5+nr1MGyPyhnxRJiIDnZuJfBLedTlRh6VvPVQ9kpDF6Yn6VJoc3yGiw8YpWCDElkla2FQmxTg8Qo/whT+DPf4HUC+inK48z2iVH2KMoZyx5za58bbR4GBYlqlyWspalZ6Hi3k0jc49ObWR3MzklAUcCrnS7Z8tOd7jVjO0DtEBtMj9KuoP8slv533/SmkiV6B8c91wStChmR6uEWefMCmf2K42nbEX63plml86fMY6aNn5rJoi7HaMhsGGfnbe7Wy2YnaweVGeLB+oG/ZeejQhTyLgXsQG1j8wTYBWtylgScnwkMFQTJXMtuLlhCH7t8bJV2xQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a+wHA5EI11JerEr5o/Vhk8DA5Zqvje8Co8z0AHceqvw=;
 b=jdJUe2tcFrxYol2zLlWbCunfm/J3gpEfk8iPQZHc9a83dn12Zijxxqc3E+s7LNBuUEqgo59yTK16682VuQpJoVgi79++mJl6IhazbnfbyeD7W+Wkvkbj1zXyE6E8GBa9irDd0Ely+wcyUPh9PfMwmyLmELGsYviVKKsBeg1/gRuE/i6I9c4MKS3WWVFdm16kZqQ3nZVgTp1pYUUD7amufW8aomjjJMwyOGhizJfqKUOJCgi2FPSkcOBNkDLlIZyq4W9oEQVmL0TrwPrVfVj4MmRZ1tUT8u1buC9G17bdW5Z5LaYNg4MQO+FCpOaxCGmvgJyl1EfkuU4TVgF+tcX6Og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silicom-usa.com; dmarc=pass action=none
 header.from=silicom-usa.com; dkim=pass header.d=silicom-usa.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=SILICOMLTD.onmicrosoft.com; s=selector2-SILICOMLTD-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a+wHA5EI11JerEr5o/Vhk8DA5Zqvje8Co8z0AHceqvw=;
 b=gcHHbD3zhB8Y3Ji/8iFiCYB0kUNNWkIvPPThSAoX52ijRjNXf0Wued6EyoEQAbUMudsmBizBEVGEinbyJc3pDP8g8HPThyuVrkIe2V0pgF39D/CEAO/yQBfoNCN+eeABtFsyrolgo9vM7c64nk4OsJ3GpSCP1GTrA4JF4zlcA80=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=silicom-usa.com;
Received: from VI1PR0402MB3517.eurprd04.prod.outlook.com (2603:10a6:803:b::16)
 by AS8PR04MB7654.eurprd04.prod.outlook.com (2603:10a6:20b:290::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Thu, 14 Apr
 2022 20:21:17 +0000
Received: from VI1PR0402MB3517.eurprd04.prod.outlook.com
 ([fe80::5dd5:47e1:1cef:cc4e]) by VI1PR0402MB3517.eurprd04.prod.outlook.com
 ([fe80::5dd5:47e1:1cef:cc4e%6]) with mapi id 15.20.5164.020; Thu, 14 Apr 2022
 20:21:17 +0000
From:   Jeff Daly <jeffd@silicom-usa.com>
To:     intel-wired-lan@osuosl.org
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        intel-wired-lan@lists.osuosl.org (moderated list:INTEL ETHERNET DRIVERS),
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] ixgbe: Fix module_param allow_unsupported_sfp type
Date:   Thu, 14 Apr 2022 16:21:04 -0400
Message-Id: <20220414202104.900-1-jeffd@silicom-usa.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR13CA0015.namprd13.prod.outlook.com
 (2603:10b6:208:160::28) To VI1PR0402MB3517.eurprd04.prod.outlook.com
 (2603:10a6:803:b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a09b88a0-0ac4-4df4-177d-08da1e5454c1
X-MS-TrafficTypeDiagnostic: AS8PR04MB7654:EE_
X-Microsoft-Antispam-PRVS: <AS8PR04MB7654171EB586ED58CDCE3DB7EAEF9@AS8PR04MB7654.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: B6itvDrv6MDsnKdwbmb4jevLo9XsCCjH6uv/xVpD/5tvu9ixBppTtZF1DUs4l/x+jfZhnuNPURNdSbPTgb2cckEX0aylUHa6sr1nKrsHpLIhrLOpwUJrs9d/8zy6ttfOOmAXbM120lGtDSGokJK1aahYGT7AU17HVB9at99bZFI39ep3LMPB47yG1tBLSP67+yH+VlY9LGH4pbLdtuj5bS4kiXKQkwl6aDGXT3RMlUG2WbgAmsTfvTwcYoNXJlHWScitaNbigdPQL77xpgo8+jdPvCas8VFIrciqKInIXQubTl4IOu34u9tNQCpXbjo1X9QynwKhJDIpPa+vWfu32Z+4oTzqMxlcd6e/8fNZb73KeKLgw3fvwJOhTE5wb+88lVBvmUFQgalIJVGtrjDE2MlQeIjrmp+MANTXzMy0TkY0a1JYDAoHhnP/hQdAkc8AE8BoNvmmBZ5aLWY14cINQp2VYP8D+gkmuBjrgKfUNIjbkwHUMxPTrgZxjEufvvauPXOi6XUN6vC+ifwN7u04B9yvBqH/PG5gQdRty7NGEAYIqexc3cDohknQMr4JNJV36kXVjik4SUXLuQqvm//G6V3Mc7qzppq2xOrxUkoYlTflW/rYgZSg5JqOMlsBrdWfibYWaYk0iTQHeBMIthe5Wu4oC0wDWZgKwsNxKHRJkV+2v8/v32wic9DWlp5dNgpcRwfiO8sHi25wXEG58au+3Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3517.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8936002)(38100700002)(38350700002)(5660300002)(36756003)(2906002)(6512007)(1076003)(186003)(26005)(6916009)(6506007)(54906003)(2616005)(8676002)(508600001)(66476007)(316002)(52116002)(66556008)(4326008)(6486002)(6666004)(66946007)(83380400001)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7W/HxFiF52icMbcaUWhLZnZVAoMo+qWZ75eu/5K4jUzOUA7J980JrVfUdz1u?=
 =?us-ascii?Q?qUQqqRhhAlt2HNWdySnepwC/zS3nIFNarFYKK9S+DoO1wnOSQvuj8db4AgT8?=
 =?us-ascii?Q?6PG9C6HMxt5ZytX4a2JfilHuXhKEqdIcYCCRHUNhNEOnpgp9adLurj122sWU?=
 =?us-ascii?Q?GwtT+fC+sA966u0pYSMjki0UlpvOReYNIWaemsNtP8GNFvHWIujyKaL8BEAm?=
 =?us-ascii?Q?SBxnlpbK83w5YM8a3Id5nw+IPwen6BbMpJ19FTB++bDCX4Xx1U5OqrzG1TI4?=
 =?us-ascii?Q?K0pAXaUHorM9I9rJxWymi2CP78iGj8EzljElmoLW6jokz2VnPVC1gp8RRp7F?=
 =?us-ascii?Q?ch3iQuAR5HIJ+9+EFARZkq5ipjTR9F8c6+sj7EVEWqYx4boZ8ZoQcPV0asxF?=
 =?us-ascii?Q?KfMxIQb783Z5BBZetly3aITdLVrnA+ai7BnpzkU0CyWsiQU356XPO2ykXTux?=
 =?us-ascii?Q?YgnkTfwNO4LB0fWNb+QgDtaYhi+WRZXKGVA1pBCnqPYE1yAewtujmw+X4ckI?=
 =?us-ascii?Q?4/kceGEkKpIrSfe3ftq36Qg+g30kAsDjsar/mbb99+f+leUq/Tl86FfdsRDX?=
 =?us-ascii?Q?2ew6lhVwpZdEppL6uTUH2hGLGe4k/jsnFaIkTlxkrfEYvBTqjZ4ZM4eMlgGr?=
 =?us-ascii?Q?NuR7L+e9xpzhQzs3qHfUYDx8zJQy1t41+FZtLkjqhY5XlRPmBhyKgfEYfik9?=
 =?us-ascii?Q?Lqw+eKrX6lP7ysahpJGeWQMxXCxZ4jbZioRgZXi/yCcni9XKgLrp21V7Ta+9?=
 =?us-ascii?Q?qJSUg7m2QRrp/hWSCHxgs0w2iZ8P2nCEYh8MZEiGBEr4BNIi7rRNj01u2yeE?=
 =?us-ascii?Q?TKcVdvLQ3ESLo8K7kCe6MucGnXM2HxiCVDmhrZuxOGLSgQKdMgyT5+zA1DV5?=
 =?us-ascii?Q?MP7YkFeRT82EKBtAWDXnEQEVESnoiBlQLpp3LEmuoULpKKm/VbBlHUVDEbKK?=
 =?us-ascii?Q?VdAMnKriYncNEDe162t5SAJF+qXdy1i4Ko0aOCT9eLj77uy+ekLvB7D9AkPz?=
 =?us-ascii?Q?ffKvckQg/ILCBUv5qoaOaMnFCqfgmcqchFO9p8zfBFVx0mpBKfGoAc0AmGlw?=
 =?us-ascii?Q?IUaPc5o1h5t3ZLjsGopIl9TUDT9hSbZXGXtXDNcNdQkSxyBt1G6/GLsKf10D?=
 =?us-ascii?Q?6gwN/LFoiroZQAh6tRbfbmh7ftAlStp/XmPjO9ciZoYVWfgSJba9zf2gGLZ6?=
 =?us-ascii?Q?Ok41BorNKy2tMz/VqGw03s3LzZSTZkMqzkFKFq7o/w0x6ZQUGo/O5dt/F6Ev?=
 =?us-ascii?Q?Yura+cDYoHJzM2m08CjO7S80O6PPe0jHRmAegx+qGTB/gKKsaeOqj31iXFvm?=
 =?us-ascii?Q?9XuRfNjJ+N5rVcmiyl0XHa5Tio22l42asaKJSgVeRhVJCXgRZX9xt6RL2+eh?=
 =?us-ascii?Q?U8hmQ16IFgPQIM8YJU94cJVPZUeiluUsVKrFVc0dFIqC5iuEOxMiQ6QGZkU8?=
 =?us-ascii?Q?bUln8oc6O+2pjpXpqEGRrpBNw04LHrbXtbZlBmkvaEYBMv8+QUr28XXe2FvX?=
 =?us-ascii?Q?FlLDgCvj5ISGDBaA3qaBHlGM4s6Tk//FD7SApykyU8Hib2InjKsAKrNdIFrg?=
 =?us-ascii?Q?MQfxZou1aBSXEIuWV+myqwxyiyQhDLAmB3vd9/N4lQGlzEimPf04eCzSwiQX?=
 =?us-ascii?Q?FwQIorQ2cS6IOkXrfr5UAA3iAatIzQVEqZndBd+6MV8fdMTVaewNfHw3Gl2c?=
 =?us-ascii?Q?OwK5LKMjShE43lrJrsHRfSQYQMkb26JRyp43rbiBhAb3sVYlLuvvUAe077jP?=
 =?us-ascii?Q?H6qLqndl8A=3D=3D?=
X-OriginatorOrg: silicom-usa.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a09b88a0-0ac4-4df4-177d-08da1e5454c1
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3517.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2022 20:21:17.6873
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: c9e326d8-ce47-4930-8612-cc99d3c87ad1
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lfeRH/enCZy+UXTUB44pP0UoK8oQIeU+UY7DGNXfqXEFQQkdIUy+oS+QU9sFNQT2Trj+/Xn+ixb54IjyEmJTgg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7654
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The module_param allow_unsupported_sfp should be a boolean to match the
type in the ixgbe_hw struct.

Signed-off-by: Jeff Daly <jeffd@silicom-usa.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index c4a4954aa317..e5732a058bec 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -151,8 +151,8 @@ MODULE_PARM_DESC(max_vfs,
 		 "Maximum number of virtual functions to allocate per physical function - default is zero and maximum value is 63. (Deprecated)");
 #endif /* CONFIG_PCI_IOV */
 
-static unsigned int allow_unsupported_sfp;
-module_param(allow_unsupported_sfp, uint, 0);
+static bool allow_unsupported_sfp;
+module_param(allow_unsupported_sfp, bool, 0);
 MODULE_PARM_DESC(allow_unsupported_sfp,
 		 "Allow unsupported and untested SFP+ modules on 82599-based adapters");
 
-- 
2.25.1

