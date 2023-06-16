Return-Path: <netdev+bounces-11403-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BD51732F96
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 13:14:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3EE041C20F81
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 11:14:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3919C134B9;
	Fri, 16 Jun 2023 11:14:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2602213AC1
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 11:14:32 +0000 (UTC)
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2080.outbound.protection.outlook.com [40.107.6.80])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5593413E;
	Fri, 16 Jun 2023 04:14:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CSAM4DBWEwLull/mQa2CKpZnjj7yswRYp9BbLVoFuROcDKBcVq9VWoECYnH2Fswefcvztxm9n11s/1lVnDiyVOXZ8fJoEptwZnVavySqO1/fzcC1ft8jTwh9wyHBOC1dVWsEsxv1wu5LkIS7M9ey5XILwVcEUUTvVKVYy69eQhHPyxAOH4CFSPMunkS1+IUI8F7ly98YhGOwuhreyJ/UL8Mpxz4Lzeqasu8qfVYaG5xW7dbke/xvEDgjTbFePhDIn0/oG8yx0Xfayf3jmq6i0rz55IznvyUxJCBr/y6TIlm9Y9DWXI1Rv4z6yG3A+0RaHeaxDrM5KiqL38xZ3emtOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zi///9VArwf/g5asxXvmxXXw8gbc/2TDISEdzhgBNWs=;
 b=fClILJQd3IQVIl2MjDTZvq5ot3dURBdgiWqu64X8OlnfhwxIZZB0iXLHLtwSb/hw1nzetxi5RucYfS7nbFTimN4798/eaSiPHyNRv9KHB6P5yvCce9fsBtj/bHXCg9IuD6geCTrPgESsCinm0UISzpcUNpnu0j5SWYko1gTMIEgoESDEHe2kfMC63Z9clvG3gyLj+r9OsCeRg3a04behxgApgZp6EMDWZBr2I+ZzfoMfBtPiBCy4kDv9kN8hWkHDTIKd8mQKJ3qaUT/MU9BaFOukLuyYMCnwMLe+z/hthxSC9ilsnNKQeE7zMhlifXEWQollBlzXRJCF8D10njlvmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=solid-run.com; dmarc=pass action=none
 header.from=solid-run.com; dkim=pass header.d=solid-run.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=solidrn.onmicrosoft.com; s=selector1-solidrn-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zi///9VArwf/g5asxXvmxXXw8gbc/2TDISEdzhgBNWs=;
 b=aDQM/6/7DlBDidclKwYPXkFdqcjbJANQOe0OB+F4G6hywG7Rmk2rOc7IcE6isILbY3nagRw337ZIewLRhBSoMvdeEC07CP2MTU5voxGCCN1tRHbcbOkfckJ363qeCZ/0KmIUqdWF96uXOhLce5vABxNeuF/XpXUgnoPTlyIujs4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=solid-run.com;
Received: from AS8PR04MB8963.eurprd04.prod.outlook.com (2603:10a6:20b:42e::18)
 by AM9PR04MB8258.eurprd04.prod.outlook.com (2603:10a6:20b:3e2::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.29; Fri, 16 Jun
 2023 11:14:28 +0000
Received: from AS8PR04MB8963.eurprd04.prod.outlook.com
 ([fe80::5a4:421d:f180:9105]) by AS8PR04MB8963.eurprd04.prod.outlook.com
 ([fe80::5a4:421d:f180:9105%6]) with mapi id 15.20.6500.025; Fri, 16 Jun 2023
 11:14:28 +0000
From: Josua Mayer <josua@solid-run.com>
To: netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Josua Mayer <josua@solid-run.com>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Russell King <linux@armlinux.org.uk>
Subject: [PATCH] net: dpaa2-mac: add 25gbase-r support
Date: Fri, 16 Jun 2023 14:14:14 +0300
Message-Id: <20230616111414.1578-1-josua@solid-run.com>
X-Mailer: git-send-email 2.35.3
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0059.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:49::7) To AS8PR04MB8963.eurprd04.prod.outlook.com
 (2603:10a6:20b:42e::18)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS8PR04MB8963:EE_|AM9PR04MB8258:EE_
X-MS-Office365-Filtering-Correlation-Id: 75a75f73-6fab-4797-81f2-08db6e5ad98f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	4v8sFP3gQm9BKtmz+d3+c7LpNOjMjjeadOkbohcaIBHsY8vgEAFyELPYcOAnWFnI+pTxaw4y8NzAYO2bBRJYFSfp5cqsAWw7iG1CsTPIPogsx/z/fJV/1ji0nfrypGn8goGwB4A7XhLNx79C4ml5JiOEx8QuZdJUA1lgAb+V/5fJt0B/3kqRusbsvYJXfLvah9I+oiikdQPvgJCMNAD5xxG8Ol2nXuedPgpAt+F7U5Y9hPGunfpDByH2+ghqzIhprTnpNIB3Rhq9M0mCo53g6aRu4cwolrz4PbW1xvP53a83y4xnGCxUSohnkrzchKBUqe7R+KwDLqjebWYA1uv2QtTiO4xd8Uu2ZW1ZLHRfDbquFipw6MTzLNEZT9PBRxwab4NdmMvqqTuZt6pyQSkeTaR0g3EyYk5TG6gVdNH6rw0c6rucf7tjzmvjriO/wLUBQ7gEYwVv/6jXpAUJV+bCo/RaBiIr86Wa//if5uHlmomCNSj2czV2HzC+/qttVFlXnFoTtKVNkNuIFe+1hHQuF/rRt6HOPShPRG2/Pr5nuFYwEHfpzCfAt3Zz6MRnMVx5PA5uNJ/lIyr0xTRFRdj01B0Kh7WcYgFPMKVP5uz9GEFTP+GtI0xvA1cWHjlAirsC
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR04MB8963.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(39840400004)(366004)(136003)(376002)(396003)(451199021)(8936002)(8676002)(86362001)(5660300002)(38350700002)(38100700002)(83380400001)(316002)(41300700001)(66476007)(66946007)(66556008)(4326008)(54906003)(2616005)(186003)(478600001)(6506007)(1076003)(6512007)(36756003)(26005)(6666004)(2906002)(6486002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9IdozhtO53jeNeWEy53pbjW3Eld2CKnpaMwAgzfnFpJ2Q8g0g91qUpyV9MeC?=
 =?us-ascii?Q?pn00ji3XlXoHc4dim+wg8AYAtEhq+v3BGtromDOvhKAzCCMVbL/rVKYn5xyB?=
 =?us-ascii?Q?shp6FAxpdTSA6yx4Hddi3p7GelfmW172VoBjA4U7IcgKLOoHAD8jz9WjaxPF?=
 =?us-ascii?Q?ivJdkOXHfNe5Rr1qScMP02wgbiiTH8Q13Y2nX14DAdhxlPf7O5Bb/dXWs+lk?=
 =?us-ascii?Q?nY6E9olnFWTIycqikkKYfKXU9u2RpK44gSGH+14XlislGEQnHuRXYQk6LoOx?=
 =?us-ascii?Q?JwuxG7URCFZiT7NdznhhpIIeOm7F9ET+ZcBL1OBPoNa4fL/d18gHklfaHIpc?=
 =?us-ascii?Q?MVE7rFouooQjECmtdZKO3L7P8LPpK71r6VLdQIDYQj8Fg+M1wZzSEO5s+qBV?=
 =?us-ascii?Q?rANwhau5VZC65ajqAeZKioxEJ4t+mQEI02AvEwcZPGRYcLu3taT+HQWMP3+A?=
 =?us-ascii?Q?IrWUAwE0I+1MLU0sw+SQQrrWL8kJTJc6qB+qLWf7zIYn6L4NJbe+HgUuCraO?=
 =?us-ascii?Q?fxEMQo1SaqFsCZnN9ioKALNdSNe0X1cIt5Hh/O88MkcdWMF7eL1R2sLTJpiQ?=
 =?us-ascii?Q?ppihhvzUd82sQUQgbFWvZ/0OrYaKjHif+7g32syuvbM6LYX7LRNAEdzGXNCg?=
 =?us-ascii?Q?OzEMc8I2a0UwsLngvq3nG9k15ljr7FOKQQHdOnHC2UihccUcLOxOLMrWcg9t?=
 =?us-ascii?Q?4UG5zn7SAtUbEYyhP4hptcbe58jshCPF5u6TQCKCu/QJ3e0U2DNRYCBZzg8v?=
 =?us-ascii?Q?EQzbfzj+BdDGt4VO6EAYjeT9JJcQdHcv+t00plqP+WNoqs1jKe0ErnFKjLab?=
 =?us-ascii?Q?kCLAeUj7nhloq6j+e75IZhkyI6+4c7PXQGni2cGMUKQ2THfryo9rtFvE+XME?=
 =?us-ascii?Q?FmWKoMTHOGGLlFLKtGnFkfAMqYuFfSHDJsggLFWFGUBaRuol/M/3xl/+oaFR?=
 =?us-ascii?Q?D3jv082JO9gklIgQh6rP9ysEea2MoSSgFyF3+UpUVXAwOL4YYFixeDB7rhf2?=
 =?us-ascii?Q?yUr6TNl3CifcJ+XH/hiVJNzEYWruRHmR26+8zRTXUsxHZQBRMZI5NBF9CeJ4?=
 =?us-ascii?Q?itwrtixVOA2bfBunWdti9dPUvS/fZJzpBBWLJvQohQJveiXJlYP6AFuqTqf4?=
 =?us-ascii?Q?nW5RZOZRtqTiQf0ZFtccqIzTSD/5I1H7oyb/95E2mCLqxCd2a3yBLMlIwhG8?=
 =?us-ascii?Q?+nPfjCxbKABF7mAQn3umUY6XrvBu4HXwer2j9Mn2ONSu3FvXG46YMWDGrSwV?=
 =?us-ascii?Q?04ZDEhgHu6yw+EiooaidvsX+co8yKtMBd/s/eP9XOI1JvtLm+4wlFGK7dVY+?=
 =?us-ascii?Q?DlZhfix8TRzZ+bzM3TPOheypZo0sB+cQmKdR6Qf6G79eh2ikisobE2+FyQnm?=
 =?us-ascii?Q?XUWM7kn2y7TuKL+sUWU1e7n5UzjBWaiMssVAez48H6646ApWrO/sT3+TmDCA?=
 =?us-ascii?Q?JnnDwITgOwI6nZc+zLIDNVp1odLk0WCRwZtDoY4/DuHSZMVscCb/V6UM7kNM?=
 =?us-ascii?Q?ym9y79WSiuegUo1WWmPoP9xcfC4b8FUaH/l9ETD76x3rvChItpZXtSJIS5wm?=
 =?us-ascii?Q?PxYrT97OkoHQAvx/hmJKZ/dyg2BXhN4rJsf+xVCt?=
X-OriginatorOrg: solid-run.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75a75f73-6fab-4797-81f2-08db6e5ad98f
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB8963.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2023 11:14:28.0553
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a4a8aaf3-fd27-4e27-add2-604707ce5b82
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ym3RpefY9CpQIPKpwizJFXVO40bhVmDLQn/4poK+1O8WcLkC+KqbHMzSBK0aLHJ9Ubwb4pTUcqQ8P+N59EH5Vg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8258
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Layerscape MACs support 25Gbps network speed with dpmac "CAUI" mode.
Add the mappings between DPMAC_ETH_IF_* and HY_INTERFACE_MODE_*, as well
as the 25000 mac capability.

Tested on SolidRun LX2162a Clearfog, serdes 1 protocol 18.

Signed-off-by: Josua Mayer <josua@solid-run.com>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
index d860d9fe73af..a69bb22c37ea 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
@@ -54,6 +54,9 @@ static int phy_mode(enum dpmac_eth_if eth_if, phy_interface_t *if_mode)
 	case DPMAC_ETH_IF_XFI:
 		*if_mode = PHY_INTERFACE_MODE_10GBASER;
 		break;
+	case DPMAC_ETH_IF_CAUI:
+		*if_mode = PHY_INTERFACE_MODE_25GBASER;
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -79,6 +82,8 @@ static enum dpmac_eth_if dpmac_eth_if_mode(phy_interface_t if_mode)
 		return DPMAC_ETH_IF_XFI;
 	case PHY_INTERFACE_MODE_1000BASEX:
 		return DPMAC_ETH_IF_1000BASEX;
+	case PHY_INTERFACE_MODE_25GBASER:
+		return DPMAC_ETH_IF_CAUI;
 	default:
 		return DPMAC_ETH_IF_MII;
 	}
@@ -415,7 +420,7 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
 
 	mac->phylink_config.mac_capabilities = MAC_SYM_PAUSE | MAC_ASYM_PAUSE |
 		MAC_10FD | MAC_100FD | MAC_1000FD | MAC_2500FD | MAC_5000FD |
-		MAC_10000FD;
+		MAC_10000FD | MAC_25000FD;
 
 	dpaa2_mac_set_supported_interfaces(mac);
 
-- 
2.35.3


