Return-Path: <netdev+bounces-7365-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F177471FE58
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 11:52:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 809D01C20AFC
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 09:52:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 349EA1800C;
	Fri,  2 Jun 2023 09:52:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FE9817AC2
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 09:52:04 +0000 (UTC)
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2078.outbound.protection.outlook.com [40.107.7.78])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4835133;
	Fri,  2 Jun 2023 02:52:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SfdXc5Dcd6lWAudyMxMaUQrWfdrzVvj9cv5YjVeGGyEb3DJuEb+N07ahRElU8VyV/5UB1Ck7kyLrcNi6HyUJa682HfpQtl/7nM+Ch+7MKzM9iefHvjzTmwVPB7RrRvT66M3vTNA81gVLWvzCjCYxj4bRwzV+pu1D1CPQEkP2VTjp4B/y0Zpa1IMLtHgreYxXX13lmYDoQono6OEwQladfU36lLSPTvbsvsnCFUd5VGUTxZID5yxFJRSlLeNdKwbH+OJsk59IWQqdLF+eGLNlSGjYvJCGwGsPUPdVwyKUJhxgekQ6fCD0OD7sjGSPSIdF28T3TgeklkRq1zz/CYQTTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vkqLFC/kchqxIkF1WNrIpFC/bBUjjIRYS/T3h65wS3E=;
 b=bYOLyyIMl8Av1nYoQFRMFcXXIoxuTnynmIPuarGp5QCALaLwxnhPnfpEQGlwyjBNPGF3iDx/n1V57dB+PPSnYXrYq67BQAZfRBDeQdwJ6s7wGh5gYXZL1U24vi0IiUBi4SvtTHlv2SlterTMSLPQAXhFp12ytPSpKuP4oz+MLobEFmhSJ4pnPF6TT+Hio2B3Y9HDyShb6cprzUHfcSHqE0TgxVDTGoU4iuD5m55a7c4IPF0LfJb/YaRfSQ0NqYm+jaHXHiifrCtPkm68DPiJYdEOWRjc9hHxtnpxYpmv3k4Cyloyza234WnVO2d5CvDppFjZsuQi4HH3Z66y+U6lKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vkqLFC/kchqxIkF1WNrIpFC/bBUjjIRYS/T3h65wS3E=;
 b=qY0tZR4IWNnmgSS/YNjsJtSqkS8qYax5GnmZVVf0Je8b15VNHZf4lG32z1MzoNK1AAPqB+nA2wd/AOmCYPtsr1oqXjnFLjdXl4Vv2rdUl7TM1JWAq3uBEBQak+hFuGkxhgyLN2JaKVjpkwkJOFGcYvvnE/5SXyT8hf/dGZ+ULlk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM5PR04MB3139.eurprd04.prod.outlook.com (2603:10a6:206:8::20)
 by AS8PR04MB8165.eurprd04.prod.outlook.com (2603:10a6:20b:3fd::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.23; Fri, 2 Jun
 2023 09:51:59 +0000
Received: from AM5PR04MB3139.eurprd04.prod.outlook.com
 ([fe80::682b:185:581f:7ea2]) by AM5PR04MB3139.eurprd04.prod.outlook.com
 ([fe80::682b:185:581f:7ea2%4]) with mapi id 15.20.6433.018; Fri, 2 Jun 2023
 09:51:59 +0000
From: wei.fang@nxp.com
To: claudiu.manoil@nxp.com,
	vladimir.oltean@nxp.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.or,
	pabeni@redhat.com,
	ast@kernel.org,
	daniel@iogearbox.net,
	hawk@kernel.org,
	john.fastabend@gmail.com,
	netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH net 1/2] net: enetc: correct the statistics of rx bytes
Date: Fri,  2 Jun 2023 17:46:58 +0800
Message-Id: <20230602094659.965523-2-wei.fang@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230602094659.965523-1-wei.fang@nxp.com>
References: <20230602094659.965523-1-wei.fang@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI1PR02CA0043.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::19) To AM5PR04MB3139.eurprd04.prod.outlook.com
 (2603:10a6:206:8::20)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM5PR04MB3139:EE_|AS8PR04MB8165:EE_
X-MS-Office365-Filtering-Correlation-Id: 6bd598d5-000d-41f6-0b3c-08db634f01d5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Ywrleg1xFWKRNmP24Yq0sCaFUWJjhflLmUcSzY9YVC478eKGoHIHWaUuThhUZnnHB4cISmfhszgdbRr3N+G0jwm0WPKkTJ4GslZpzaAHPsqTWGZBMYKv23Hph/8YLNBQ7nXecPpEz3o/akHl0AIiatwSbFaloWs88cYvQfcnuocxMOJs4mAZVpQqoBdVC4M5gqCSe9nuaLhqfwrcHU5vNvlu6RBObwsJV4Z4XJrR1jN4ONRijVtnAjFwsPYr8hu+zD6PgaxJL7/Fsc0Y5wTKFancIItSqb2nSkemSCAAScSgpmynxQF9yTjwywGt6TGh9y8gbB/F3m8rWQ17zjAcAfTKHeBDz2+47LNZpRRP750pN5KdqvVphoDBTJPX9o/jdZAbaS5D/1L714QBRm169w0zOSAccZO/pLWkJAvoYC2ftPOzheoSkF111M+d2nlVga+To4KMRvuBcE+aRw2P/CZYdbJTI/DDxt2lO86WmRuzk88FGuMKLkJ6j5E5KzFREJu5u2OfCaXkqB3z+JYgVArYH8sy/7bDNLhyoh2rldP+I3Rib/qJh9kBsSPRUmH4kFslik0JF2HDoO079I5LFrue7i7NZfRjsnrpl74tK7LRFBbqpaxbT3AuL7orkaQCpX3t8a5Ch/77TnRjXNSNPA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3139.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(39860400002)(376002)(346002)(136003)(366004)(451199021)(9686003)(1076003)(6512007)(26005)(6506007)(83380400001)(186003)(38100700002)(38350700002)(41300700001)(6486002)(52116002)(2616005)(4326008)(478600001)(66946007)(66476007)(921005)(66556008)(316002)(5660300002)(7416002)(8936002)(8676002)(86362001)(2906002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?sopJXL7ssz+2+jrfUlqKVBerFqzAI6Rfty8z9HSkFPvgsV6FRbA9SVAd6BYf?=
 =?us-ascii?Q?fVJDPTqlyF6wwJtCWavleD6kvH1E0TVHZvmtHOLt5hZWFkllRJzVXjhAxxfk?=
 =?us-ascii?Q?VMbIgZIN9xvpLnN4CXfavrQgPtSWXBdOVDf1Nb72ru7cFVvimghcuec/MKMk?=
 =?us-ascii?Q?ArnlIAcurZmdgvW4ru6mTC02sg07CwzUs+87Iwb1lPVe9fA0MYGC5MBfCqn4?=
 =?us-ascii?Q?6MmD6LLjWkuqTWCqSBwghVaSQSXE/YkXVOTp1YD06/W6unr1n7wEyQVODapZ?=
 =?us-ascii?Q?bKF1W0/TIWpn67MKl9i9mq8uQJPbHrT4TfEbH+isOGkhuNjosEt6qInLX42c?=
 =?us-ascii?Q?hJfkeTixxVAr4+xQx3/raf0FPm3YLu/d8NB7784J4AKO5gKkSFvbICWpcnfn?=
 =?us-ascii?Q?v/7/HkRBGxdx/SLimJKolrPWqaB3Zwpmnr2ICtN46fUxb8QgighrHbWNF5j2?=
 =?us-ascii?Q?GoFZCP7RhLgh27TacmAoVLlu5l/mpZB4OtUjyvxtDdUlBP3sNp+XftEOyJ4P?=
 =?us-ascii?Q?4ZOi7LYtMn5wgygru9Z9eEmRFpqsD3c38nSsIunGntFPc+UDsqccJaiFs5Tb?=
 =?us-ascii?Q?3GaFf0rlrFYS4ejM2u3nH7hoFCKuGiqngm2h7qZyYRs5Kpxm62BAM3MDCGkv?=
 =?us-ascii?Q?75EiFfrHcgTeFXCEVhU91D09TwMRmwXllLYIn/fZzHU18Kli/olNjQO1LQ/4?=
 =?us-ascii?Q?Oh485WCtds/Di1hjTc7RDpk/nGIkbXd1Vq9K7ggabxBPM9oh1wSIqLriqTRe?=
 =?us-ascii?Q?tcILm8RFG4PdHHmleTYDLqKrnDm3bYYbwDX9/rXxZYhKxv3hk7NMZuXYYm0q?=
 =?us-ascii?Q?nSjldV7bJBZrs9vMR+FxCHe81SmgG70Ul/ip4QAAGqhkAm/9R0W0xJAodXC9?=
 =?us-ascii?Q?9vWEHPvy3s5+V8HKObVJseouGGeL4AuPTqhtJHp04o2WolTxJu5d6mg8FClZ?=
 =?us-ascii?Q?LiO5K4Rg30f8mG+fvfXAkCEOHjgLZyDyaRtRByeQLfRSQOLNc/n23RppSUBG?=
 =?us-ascii?Q?hEBsXURz/77caDdY0i9h0hhu33F7rkbNNCfN2dmj/JyqZTDliTDDZqnoy61p?=
 =?us-ascii?Q?b1KnQSy/dJOsDk/Kj0VydKb/Gh5vUj1/AJ7FJinJn22Tcj1fra9fSD7kEsKg?=
 =?us-ascii?Q?1fTCs1q+Y2d+/ZKkZ6EmZLAfSEN1O54KB768IOPPckq5JN/5ozuNsQyVF9rL?=
 =?us-ascii?Q?InNVbA0dRCO0rheqBaPh7dePZG+bIBwU3ZeIimRwM4nKYrCKU7J+EU9iBw7t?=
 =?us-ascii?Q?fbUc8xVzDK+RR9eOltj5UBAyvcjmX2KVQwIQU4mjpq987ljIVfdtah+62lt+?=
 =?us-ascii?Q?zWelFCVCeI2MUVAfVbUg/OT4xv34fU6OB6IE6UX3JF2Y/oJYNu5eHR+Jwq0p?=
 =?us-ascii?Q?oQDxmW4u6p9XqsXrpYKb11DxY/IyAIHc1rwpvyIdEq6tEtPzmsgtul+hEHgi?=
 =?us-ascii?Q?vD2Mb0m2snfCYou16LaL1T/TpR9gdc4P7kfUcI/PJJsZYkUQ17k5+ahsH20K?=
 =?us-ascii?Q?waQYTzplDME5r127jX3JT2/YfXwqqC3eIfAQ40E32+8AeEJ0vGcASt0iH44w?=
 =?us-ascii?Q?UagfmhtWQ3wOS293syJuifPue+oaRwnOGzkv6+HW?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bd598d5-000d-41f6-0b3c-08db634f01d5
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3139.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2023 09:51:58.9090
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W8IXeHS6yGVFg8+zeB+AZlMTTnAIbNBNvfwfDHeqElF1KdSr3Z+Uo3SPwKEOb6fe4+xkqFB9lTDnAUeo2E76fA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8165
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Wei Fang <wei.fang@nxp.com>

The rx_bytes of struct net_device_stats should count the length of
ethernet frames excluding the FCS. However, there are two problems
with the rx_bytes statistics of the current enetc driver. one is
that the length of VLAN header is not counted if the VLAN extraction
feature is enabled. The other is that the length of L2 header is not
counted, because eth_type_trans() is invoked before updating rx_bytes
which will subtract the length of L2 header from skb->len.
BTW, the rx_bytes statistics of XDP path also have similar problem,
I will fix it in another patch.

Fixes: a800abd3ecb9 ("net: enetc: move skb creation into enetc_build_skb")
Signed-off-by: Wei Fang <wei.fang@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 3c4fa26f0f9b..d6c0f3f46c2a 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -1229,7 +1229,13 @@ static int enetc_clean_rx_ring(struct enetc_bdr *rx_ring,
 		if (!skb)
 			break;
 
-		rx_byte_cnt += skb->len;
+		/* When set, the outer VLAN header is extracted and reported
+		 * in the receive buffer descriptor. So rx_byte_cnt should
+		 * add the length of the extracted VLAN header.
+		 */
+		if (bd_status & ENETC_RXBD_FLAG_VLAN)
+			rx_byte_cnt += VLAN_HLEN;
+		rx_byte_cnt += skb->len + ETH_HLEN;
 		rx_frm_cnt++;
 
 		napi_gro_receive(napi, skb);
-- 
2.25.1


