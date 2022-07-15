Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0565576986
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 00:06:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232050AbiGOWEQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 18:04:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232157AbiGOWDD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 18:03:03 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70058.outbound.protection.outlook.com [40.107.7.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C3538D5FD;
        Fri, 15 Jul 2022 15:01:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JdmqnN/MLfT2X779bwbZ8NZNx/PdbccqLRjz0ajquAEUOTLCeLmB7wD+QBSfM5Nsjk50s2XwprCzl721CF3H8wj0Z+9GwDNZyFnv8+zMc/QllZzPDWwfPknFwaQKNvD//8191eFl0BPJQJY3oxt/C1bMDHnUoaEUdG+nGqF13Z2yARD+3OG50Uy9sohgWq79+ayiz5FOhEhJXYXbv3QWcL0MKT4zILgBmC5YrZvBitp9/GzdTmIcp4YaJl2vgp6p2i36c2i2EZ8ZezpPDPBDTkJ47uXg4DHscFOD0qfYFgZlhZ9ml4MLRdaXKLlv/3J0ticamhqRhZaMbGKK+0a8Lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/GAo4xqLGrDuChDFBZVTNQ1ADb77ImdvHxXZi4XmcDo=;
 b=FHbSVK7NgNfqiJcIuWQcU0hAc/HZQ6WxGuMPiDQps3Zk88xnjSe9PG51YWVUDU29iPR5T6O+oev/YSf2p7Jt0SpshNW39s/768xuDDqRmjX23DTn/1sVVFcfPTEf1y8l7aB2yJjnsZS7qnsla2Ii5gLoc/QOeRYAxmtrc2MBiozgG9gsU4iChKKnmh6diOBVEsajAHF+AbVWeTjMUvRihJ4I0EtP3tN/8+CaHs3yalLxDuq3ZAPcdcX4jXPBU9rbmXNYF2X+eBsfXMWh/7HS2dXwbLzr4pa6FaCNcIqG1BeNLIcZgXDicSCdwkHOOVFy8MMX6keYnEUnpc/nMFc7/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/GAo4xqLGrDuChDFBZVTNQ1ADb77ImdvHxXZi4XmcDo=;
 b=mLcQO8zwobECmCNbUGWqtmvT0XZKmvabs7vW7ck6lnVj5CYXVx475aTeyDaM2n6vmuyCBBpdzJiEzyaP36k7j2EzI88tLB574/oQHu19S0gu5RuYRr/eTtVB9WZvplpY0FhglyxCGMDJxs9PpIID5fCZphGdpUs4dC9wCzYQ25wpKgxgMXw6Wto0JzAGE/uA4LBcf1nPmQUjj/f7PFwEzvg2S420WX7HnKQIgia8KwJjmR244zuOyP/j0Ci3STFjlyRV6YaJFivH+HSlxNuB8WGldZEhB3RGX3OJfc2CSLofQnwffDMHDXksFkqlrNvw56S28gE3BSPvRhl19tPk4w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com (2603:10a6:803:c5::12)
 by DB6PR03MB2902.eurprd03.prod.outlook.com (2603:10a6:6:34::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.17; Fri, 15 Jul
 2022 22:01:12 +0000
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::5c3e:4e46:703b:8558]) by VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::5c3e:4e46:703b:8558%7]) with mapi id 15.20.5438.015; Fri, 15 Jul 2022
 22:01:12 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net-next v3 26/47] net: fman: Mark mac methods static
Date:   Fri, 15 Jul 2022 17:59:33 -0400
Message-Id: <20220715215954.1449214-27-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220715215954.1449214-1-sean.anderson@seco.com>
References: <20220715215954.1449214-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR10CA0009.namprd10.prod.outlook.com
 (2603:10b6:610:4c::19) To VI1PR03MB4973.eurprd03.prod.outlook.com
 (2603:10a6:803:c5::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7c2c91c1-56e1-4035-a4cc-08da66ad880c
X-MS-TrafficTypeDiagnostic: DB6PR03MB2902:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CuSXjYXPyAsINzTOtwNsOItgPTLsbwNIeM+Eow4d8gj+gFxXaz46zpKnNEOS3PU7vJNyv8WpkExWEtURY+u3fQaSRykSe9DQpJuG+EDnqEX3NiT2dK+rbIGSu6Tx8As4yQ7JZxqeiE0WFKxE7Zn/p3BaAEtrTznJde7KM9VAHDi8am6Q8ljwFyTskpHMWZLrQNc+vPS8q2Oe5y4ez0tYzoCe6bL7zqYuy6XHQFbWrpxB1tSIW5FyYK6DHheTiwIoLveeFUfbvW+CfyXyrf4vaCY51h3Bx6Z9yLkXsFprCCtB92vn55vxREmFO997mj9KyFSSHSI2oFWAvhf1TtozJVv6tbMCkj3MXtkHipMR2qFbMn0UAKm8BERCzoFhpwCP5fzAyDiUr1EKUmYYN5DjVbdx0ZK/9Mgkxtchfc42xuu/Pa6pYGYRByKjbjpGAD+uUy6Xl0sH7Wa9SgPYxlvSCPpsvfnqY2yv2lh0EKH0RlKCkvQ5WOh50dNNalT1kdpW3NeKGheKa/Hqebk+yzLqPiwDiea4dfScsNFn8BgGNsN6dIlfPb4DgNW69TFZHZxHVdkumWdg2SjNj0znfoLeTVqNkxU44ioS3XUQYMN8SMPDoSdLcvo8GcgbgGAekJhFfiLLaSi4k0TTqk7R+27ARCQPsxAjQURBKekuKWG8iF74GpuKQccDC0aqlo+EaB6O6H3LBB/a2S2or2W1WWcaDg7M04BlL4xoDBciIv5hsgUWJKz8qpUptXlvDe02n2u+W1DtXQ01loZjA83IQp90Rjh7Nt98tEz2HM+QsESNePTxt6bTFAP3hrdd9NszxKRK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR03MB4973.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(366004)(39840400004)(136003)(376002)(396003)(86362001)(5660300002)(83380400001)(6512007)(1076003)(107886003)(38350700002)(38100700002)(186003)(2616005)(36756003)(26005)(6486002)(52116002)(316002)(41300700001)(6666004)(478600001)(6506007)(110136005)(54906003)(2906002)(8676002)(66946007)(66476007)(66556008)(44832011)(4326008)(8936002)(30864003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zlKLsaD9p/uI2hlJ4dvuxftDPfk1p7L1mY4tk43fp4Dek/aI7RWLdiik3pYx?=
 =?us-ascii?Q?BUw0UU2/Bg9NH9R4LMCyd5RzRPXXlAA1OdmUNgW27T39vCZ0t1QCJD9a8KxV?=
 =?us-ascii?Q?n3LoQXF2KfgPWi3POcVY4fhpdRoaOJlzzw63roMVyX9d+OhhGNf/0azxxwhk?=
 =?us-ascii?Q?16HOurAlWg40ADz0F/EJLHlmghLeup7S3wxUv3Ck2ulZo9zEtamlq+oyptip?=
 =?us-ascii?Q?mhlgJf3rpbzT39wGFR9qQZuEAm9LURptdRRZAV3iaOE0IVEfRpcAcazuVyr9?=
 =?us-ascii?Q?3WOdU+EdSvvPr3k+a4bcsZE1RxhZJP14z6+Q4aEsPYavLsbDUOvAE41yca8A?=
 =?us-ascii?Q?7+Vbg2pRwjx9sRJQjxxkd8FguSG1gdP9eSkR6LACwX5yxw/hx6betk6vU7mL?=
 =?us-ascii?Q?lmMeHi2ZsFNZqSOnErzqa9Wj2qVkwJhrfEzoJFnwnVLeyXyk0tjprWzmoBPA?=
 =?us-ascii?Q?qxem/WSU84BLSjiE04t69gkuvpmv/WOLyjaohCa2hFmhNo6Der6B2o/MH7eE?=
 =?us-ascii?Q?8XBhvRAHmgOxINDCmf0fIkUo5soE9AE1B1y3E1dWMWN7dQ+iihEZbf6vLGvo?=
 =?us-ascii?Q?Zd/s7P79UkU/9tXeldmJeYaeDfzz6anZNxv5xkLVjS5QUEAlWjW00dmUs/zL?=
 =?us-ascii?Q?kbF6hQOMEMfpuUbTUUPksvprzPVFfv8AhKCUNnv1VM3MQdu8K05yy0/5klK2?=
 =?us-ascii?Q?/RtvIbaGfCzrXMlfmVdDiDt3Ax661RWhV9Slrt//VR9tNUVltKIDuKH/Giwn?=
 =?us-ascii?Q?NYd5jp4mCSHjm9KJ10CjbPlrrWxONSXsi8p2ttyIDsyCgV/Fk8XFr1cQpL3Z?=
 =?us-ascii?Q?gqlHIWS5NlT/jVm2jEYjQKL9MDIecL7eXboEoFeyEtH39rPs8UxGR1sQI4bG?=
 =?us-ascii?Q?nZpO/9gExv3KP/8aIlgsfzH9VABivqwECSyq+c5Wsz+raa7mgOYlqMOkNJLE?=
 =?us-ascii?Q?0leLubALEXLzRfJo5kxGpBUc3VNFOkM37BzXss5XFPt9Dt19sCjYmKRtYCqS?=
 =?us-ascii?Q?TeNPB/DvyetP/fyfvyyfl86Uk2BMybfrwSRFsUFiMNNvlXZepfmoszSfpXYp?=
 =?us-ascii?Q?MEDUyNcfa16KP6xL9YjIExFFv/GfosxZqNz9d8zXoR09yHDb5NPM7PkEpDvg?=
 =?us-ascii?Q?9/M+DHYOR7iGjCrcaBAPC373HUyZkZE+hbLRtua2FQqnpdcKsJuCpLQhJerf?=
 =?us-ascii?Q?sY6qNXpaKhTNI/+pPt/UILFq77AdAuLZgSSHKRO+eGg4fclR7hYf94tT8tck?=
 =?us-ascii?Q?SCOg47Yj+BrKfBmXJwL2puwExjYdwiASVn7tocCHPDrKVLYDkxsECAWV6fJ5?=
 =?us-ascii?Q?WJ+Ifglvh/au1jYX7CbdpgtkvgCa95pgLMaGkJTjOCvxIMjuns+cWgdaHLBv?=
 =?us-ascii?Q?aUSqOmUA4yr4XhX9s1N1ezt8w2SbW6mwI2MakKAo4PeneUa5p+VFU2YjFwij?=
 =?us-ascii?Q?2b9ToBXH5ynWGRATweaJQkPvYQnSteOkEgI+RJfDdKLdYKPxeEPBpwwUCZHW?=
 =?us-ascii?Q?VqdbLCBpimTm+UQTckWXCfHNAqOyNcoujRoCOISyjAPn9wHsLEXlsKpVW+Ru?=
 =?us-ascii?Q?dB03bdgpyw+7iaTTUrfOuY6iwodzVEyhwuaANUex0ocim95vrNp8uFT3fqls?=
 =?us-ascii?Q?HA=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c2c91c1-56e1-4035-a4cc-08da66ad880c
X-MS-Exchange-CrossTenant-AuthSource: VI1PR03MB4973.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2022 22:01:12.6595
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7qVDGWkMw1rrGFU97PfmGz5U0KnTggGnckmQ8sxUjjAmRUBVAnsnivCFPxJdUoLZqMstzcA3BJc7k0msWca5Eg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR03MB2902
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These methods are no longer accessed outside of the driver file, so mark
them as static.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

(no changes since v1)

 .../net/ethernet/freescale/fman/fman_dtsec.c  | 48 ++++++++++---------
 .../net/ethernet/freescale/fman/fman_memac.c  | 45 +++++++++--------
 .../net/ethernet/freescale/fman/fman_tgec.c   | 40 +++++++++-------
 3 files changed, 72 insertions(+), 61 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fman/fman_dtsec.c b/drivers/net/ethernet/freescale/fman/fman_dtsec.c
index 92c2e35d3b4f..6991586165d7 100644
--- a/drivers/net/ethernet/freescale/fman/fman_dtsec.c
+++ b/drivers/net/ethernet/freescale/fman/fman_dtsec.c
@@ -814,7 +814,7 @@ static void free_init_resources(struct fman_mac *dtsec)
 	dtsec->unicast_addr_hash = NULL;
 }
 
-int dtsec_cfg_max_frame_len(struct fman_mac *dtsec, u16 new_val)
+static int dtsec_cfg_max_frame_len(struct fman_mac *dtsec, u16 new_val)
 {
 	if (is_init_done(dtsec->dtsec_drv_param))
 		return -EINVAL;
@@ -824,7 +824,7 @@ int dtsec_cfg_max_frame_len(struct fman_mac *dtsec, u16 new_val)
 	return 0;
 }
 
-int dtsec_cfg_pad_and_crc(struct fman_mac *dtsec, bool new_val)
+static int dtsec_cfg_pad_and_crc(struct fman_mac *dtsec, bool new_val)
 {
 	if (is_init_done(dtsec->dtsec_drv_param))
 		return -EINVAL;
@@ -872,7 +872,7 @@ static void graceful_stop(struct fman_mac *dtsec)
 	}
 }
 
-int dtsec_enable(struct fman_mac *dtsec)
+static int dtsec_enable(struct fman_mac *dtsec)
 {
 	struct dtsec_regs __iomem *regs = dtsec->regs;
 	u32 tmp;
@@ -891,7 +891,7 @@ int dtsec_enable(struct fman_mac *dtsec)
 	return 0;
 }
 
-int dtsec_disable(struct fman_mac *dtsec)
+static int dtsec_disable(struct fman_mac *dtsec)
 {
 	struct dtsec_regs __iomem *regs = dtsec->regs;
 	u32 tmp;
@@ -909,9 +909,10 @@ int dtsec_disable(struct fman_mac *dtsec)
 	return 0;
 }
 
-int dtsec_set_tx_pause_frames(struct fman_mac *dtsec,
-			      u8 __maybe_unused priority,
-			      u16 pause_time, u16 __maybe_unused thresh_time)
+static int dtsec_set_tx_pause_frames(struct fman_mac *dtsec,
+				     u8 __maybe_unused priority,
+				     u16 pause_time,
+				     u16 __maybe_unused thresh_time)
 {
 	struct dtsec_regs __iomem *regs = dtsec->regs;
 	u32 ptv = 0;
@@ -946,7 +947,7 @@ int dtsec_set_tx_pause_frames(struct fman_mac *dtsec,
 	return 0;
 }
 
-int dtsec_accept_rx_pause_frames(struct fman_mac *dtsec, bool en)
+static int dtsec_accept_rx_pause_frames(struct fman_mac *dtsec, bool en)
 {
 	struct dtsec_regs __iomem *regs = dtsec->regs;
 	u32 tmp;
@@ -968,7 +969,8 @@ int dtsec_accept_rx_pause_frames(struct fman_mac *dtsec, bool en)
 	return 0;
 }
 
-int dtsec_modify_mac_address(struct fman_mac *dtsec, const enet_addr_t *enet_addr)
+static int dtsec_modify_mac_address(struct fman_mac *dtsec,
+				    const enet_addr_t *enet_addr)
 {
 	if (!is_init_done(dtsec->dtsec_drv_param))
 		return -EINVAL;
@@ -986,7 +988,8 @@ int dtsec_modify_mac_address(struct fman_mac *dtsec, const enet_addr_t *enet_add
 	return 0;
 }
 
-int dtsec_add_hash_mac_address(struct fman_mac *dtsec, enet_addr_t *eth_addr)
+static int dtsec_add_hash_mac_address(struct fman_mac *dtsec,
+				      enet_addr_t *eth_addr)
 {
 	struct dtsec_regs __iomem *regs = dtsec->regs;
 	struct eth_hash_entry *hash_entry;
@@ -1052,7 +1055,7 @@ int dtsec_add_hash_mac_address(struct fman_mac *dtsec, enet_addr_t *eth_addr)
 	return 0;
 }
 
-int dtsec_set_allmulti(struct fman_mac *dtsec, bool enable)
+static int dtsec_set_allmulti(struct fman_mac *dtsec, bool enable)
 {
 	u32 tmp;
 	struct dtsec_regs __iomem *regs = dtsec->regs;
@@ -1071,7 +1074,7 @@ int dtsec_set_allmulti(struct fman_mac *dtsec, bool enable)
 	return 0;
 }
 
-int dtsec_set_tstamp(struct fman_mac *dtsec, bool enable)
+static int dtsec_set_tstamp(struct fman_mac *dtsec, bool enable)
 {
 	struct dtsec_regs __iomem *regs = dtsec->regs;
 	u32 rctrl, tctrl;
@@ -1096,7 +1099,8 @@ int dtsec_set_tstamp(struct fman_mac *dtsec, bool enable)
 	return 0;
 }
 
-int dtsec_del_hash_mac_address(struct fman_mac *dtsec, enet_addr_t *eth_addr)
+static int dtsec_del_hash_mac_address(struct fman_mac *dtsec,
+				      enet_addr_t *eth_addr)
 {
 	struct dtsec_regs __iomem *regs = dtsec->regs;
 	struct list_head *pos;
@@ -1167,7 +1171,7 @@ int dtsec_del_hash_mac_address(struct fman_mac *dtsec, enet_addr_t *eth_addr)
 	return 0;
 }
 
-int dtsec_set_promiscuous(struct fman_mac *dtsec, bool new_val)
+static int dtsec_set_promiscuous(struct fman_mac *dtsec, bool new_val)
 {
 	struct dtsec_regs __iomem *regs = dtsec->regs;
 	u32 tmp;
@@ -1196,7 +1200,7 @@ int dtsec_set_promiscuous(struct fman_mac *dtsec, bool new_val)
 	return 0;
 }
 
-int dtsec_adjust_link(struct fman_mac *dtsec, u16 speed)
+static int dtsec_adjust_link(struct fman_mac *dtsec, u16 speed)
 {
 	struct dtsec_regs __iomem *regs = dtsec->regs;
 	u32 tmp;
@@ -1230,7 +1234,7 @@ int dtsec_adjust_link(struct fman_mac *dtsec, u16 speed)
 	return 0;
 }
 
-int dtsec_restart_autoneg(struct fman_mac *dtsec)
+static int dtsec_restart_autoneg(struct fman_mac *dtsec)
 {
 	u16 tmp_reg16;
 
@@ -1270,7 +1274,7 @@ static void adjust_link_dtsec(struct mac_device *mac_dev)
 			err);
 }
 
-int dtsec_get_version(struct fman_mac *dtsec, u32 *mac_version)
+static int dtsec_get_version(struct fman_mac *dtsec, u32 *mac_version)
 {
 	struct dtsec_regs __iomem *regs = dtsec->regs;
 
@@ -1282,8 +1286,8 @@ int dtsec_get_version(struct fman_mac *dtsec, u32 *mac_version)
 	return 0;
 }
 
-int dtsec_set_exception(struct fman_mac *dtsec,
-			enum fman_mac_exceptions exception, bool enable)
+static int dtsec_set_exception(struct fman_mac *dtsec,
+			       enum fman_mac_exceptions exception, bool enable)
 {
 	struct dtsec_regs __iomem *regs = dtsec->regs;
 	u32 bit_mask = 0;
@@ -1336,7 +1340,7 @@ int dtsec_set_exception(struct fman_mac *dtsec,
 	return 0;
 }
 
-int dtsec_init(struct fman_mac *dtsec)
+static int dtsec_init(struct fman_mac *dtsec)
 {
 	struct dtsec_regs __iomem *regs = dtsec->regs;
 	struct dtsec_cfg *dtsec_drv_param;
@@ -1430,7 +1434,7 @@ int dtsec_init(struct fman_mac *dtsec)
 	return 0;
 }
 
-int dtsec_free(struct fman_mac *dtsec)
+static int dtsec_free(struct fman_mac *dtsec)
 {
 	free_init_resources(dtsec);
 
@@ -1441,7 +1445,7 @@ int dtsec_free(struct fman_mac *dtsec)
 	return 0;
 }
 
-struct fman_mac *dtsec_config(struct fman_mac_params *params)
+static struct fman_mac *dtsec_config(struct fman_mac_params *params)
 {
 	struct fman_mac *dtsec;
 	struct dtsec_cfg *dtsec_drv_param;
diff --git a/drivers/net/ethernet/freescale/fman/fman_memac.c b/drivers/net/ethernet/freescale/fman/fman_memac.c
index b2a592a77a2a..d3f4c3ec58c5 100644
--- a/drivers/net/ethernet/freescale/fman/fman_memac.c
+++ b/drivers/net/ethernet/freescale/fman/fman_memac.c
@@ -686,7 +686,7 @@ static bool is_init_done(struct memac_cfg *memac_drv_params)
 	return false;
 }
 
-int memac_enable(struct fman_mac *memac)
+static int memac_enable(struct fman_mac *memac)
 {
 	struct memac_regs __iomem *regs = memac->regs;
 	u32 tmp;
@@ -701,7 +701,7 @@ int memac_enable(struct fman_mac *memac)
 	return 0;
 }
 
-int memac_disable(struct fman_mac *memac)
+static int memac_disable(struct fman_mac *memac)
 {
 	struct memac_regs __iomem *regs = memac->regs;
 	u32 tmp;
@@ -716,7 +716,7 @@ int memac_disable(struct fman_mac *memac)
 	return 0;
 }
 
-int memac_set_promiscuous(struct fman_mac *memac, bool new_val)
+static int memac_set_promiscuous(struct fman_mac *memac, bool new_val)
 {
 	struct memac_regs __iomem *regs = memac->regs;
 	u32 tmp;
@@ -735,7 +735,7 @@ int memac_set_promiscuous(struct fman_mac *memac, bool new_val)
 	return 0;
 }
 
-int memac_adjust_link(struct fman_mac *memac, u16 speed)
+static int memac_adjust_link(struct fman_mac *memac, u16 speed)
 {
 	struct memac_regs __iomem *regs = memac->regs;
 	u32 tmp;
@@ -792,7 +792,7 @@ static void adjust_link_memac(struct mac_device *mac_dev)
 			err);
 }
 
-int memac_cfg_max_frame_len(struct fman_mac *memac, u16 new_val)
+static int memac_cfg_max_frame_len(struct fman_mac *memac, u16 new_val)
 {
 	if (is_init_done(memac->memac_drv_param))
 		return -EINVAL;
@@ -802,7 +802,7 @@ int memac_cfg_max_frame_len(struct fman_mac *memac, u16 new_val)
 	return 0;
 }
 
-int memac_cfg_reset_on_init(struct fman_mac *memac, bool enable)
+static int memac_cfg_reset_on_init(struct fman_mac *memac, bool enable)
 {
 	if (is_init_done(memac->memac_drv_param))
 		return -EINVAL;
@@ -812,8 +812,8 @@ int memac_cfg_reset_on_init(struct fman_mac *memac, bool enable)
 	return 0;
 }
 
-int memac_cfg_fixed_link(struct fman_mac *memac,
-			 struct fixed_phy_status *fixed_link)
+static int memac_cfg_fixed_link(struct fman_mac *memac,
+				struct fixed_phy_status *fixed_link)
 {
 	if (is_init_done(memac->memac_drv_param))
 		return -EINVAL;
@@ -823,8 +823,8 @@ int memac_cfg_fixed_link(struct fman_mac *memac,
 	return 0;
 }
 
-int memac_set_tx_pause_frames(struct fman_mac *memac, u8 priority,
-			      u16 pause_time, u16 thresh_time)
+static int memac_set_tx_pause_frames(struct fman_mac *memac, u8 priority,
+				     u16 pause_time, u16 thresh_time)
 {
 	struct memac_regs __iomem *regs = memac->regs;
 	u32 tmp;
@@ -861,7 +861,7 @@ int memac_set_tx_pause_frames(struct fman_mac *memac, u8 priority,
 	return 0;
 }
 
-int memac_accept_rx_pause_frames(struct fman_mac *memac, bool en)
+static int memac_accept_rx_pause_frames(struct fman_mac *memac, bool en)
 {
 	struct memac_regs __iomem *regs = memac->regs;
 	u32 tmp;
@@ -880,7 +880,8 @@ int memac_accept_rx_pause_frames(struct fman_mac *memac, bool en)
 	return 0;
 }
 
-int memac_modify_mac_address(struct fman_mac *memac, const enet_addr_t *enet_addr)
+static int memac_modify_mac_address(struct fman_mac *memac,
+				    const enet_addr_t *enet_addr)
 {
 	if (!is_init_done(memac->memac_drv_param))
 		return -EINVAL;
@@ -890,7 +891,8 @@ int memac_modify_mac_address(struct fman_mac *memac, const enet_addr_t *enet_add
 	return 0;
 }
 
-int memac_add_hash_mac_address(struct fman_mac *memac, enet_addr_t *eth_addr)
+static int memac_add_hash_mac_address(struct fman_mac *memac,
+				      enet_addr_t *eth_addr)
 {
 	struct memac_regs __iomem *regs = memac->regs;
 	struct eth_hash_entry *hash_entry;
@@ -923,7 +925,7 @@ int memac_add_hash_mac_address(struct fman_mac *memac, enet_addr_t *eth_addr)
 	return 0;
 }
 
-int memac_set_allmulti(struct fman_mac *memac, bool enable)
+static int memac_set_allmulti(struct fman_mac *memac, bool enable)
 {
 	u32 entry;
 	struct memac_regs __iomem *regs = memac->regs;
@@ -946,12 +948,13 @@ int memac_set_allmulti(struct fman_mac *memac, bool enable)
 	return 0;
 }
 
-int memac_set_tstamp(struct fman_mac *memac, bool enable)
+static int memac_set_tstamp(struct fman_mac *memac, bool enable)
 {
 	return 0; /* Always enabled. */
 }
 
-int memac_del_hash_mac_address(struct fman_mac *memac, enet_addr_t *eth_addr)
+static int memac_del_hash_mac_address(struct fman_mac *memac,
+				      enet_addr_t *eth_addr)
 {
 	struct memac_regs __iomem *regs = memac->regs;
 	struct eth_hash_entry *hash_entry = NULL;
@@ -984,8 +987,8 @@ int memac_del_hash_mac_address(struct fman_mac *memac, enet_addr_t *eth_addr)
 	return 0;
 }
 
-int memac_set_exception(struct fman_mac *memac,
-			enum fman_mac_exceptions exception, bool enable)
+static int memac_set_exception(struct fman_mac *memac,
+			       enum fman_mac_exceptions exception, bool enable)
 {
 	u32 bit_mask = 0;
 
@@ -1007,7 +1010,7 @@ int memac_set_exception(struct fman_mac *memac,
 	return 0;
 }
 
-int memac_init(struct fman_mac *memac)
+static int memac_init(struct fman_mac *memac)
 {
 	struct memac_cfg *memac_drv_param;
 	u8 i;
@@ -1124,7 +1127,7 @@ int memac_init(struct fman_mac *memac)
 	return 0;
 }
 
-int memac_free(struct fman_mac *memac)
+static int memac_free(struct fman_mac *memac)
 {
 	free_init_resources(memac);
 
@@ -1137,7 +1140,7 @@ int memac_free(struct fman_mac *memac)
 	return 0;
 }
 
-struct fman_mac *memac_config(struct fman_mac_params *params)
+static struct fman_mac *memac_config(struct fman_mac_params *params)
 {
 	struct fman_mac *memac;
 	struct memac_cfg *memac_drv_param;
diff --git a/drivers/net/ethernet/freescale/fman/fman_tgec.c b/drivers/net/ethernet/freescale/fman/fman_tgec.c
index 2f2c4ef45f6f..ca0e00386c66 100644
--- a/drivers/net/ethernet/freescale/fman/fman_tgec.c
+++ b/drivers/net/ethernet/freescale/fman/fman_tgec.c
@@ -393,7 +393,7 @@ static bool is_init_done(struct tgec_cfg *cfg)
 	return false;
 }
 
-int tgec_enable(struct fman_mac *tgec)
+static int tgec_enable(struct fman_mac *tgec)
 {
 	struct tgec_regs __iomem *regs = tgec->regs;
 	u32 tmp;
@@ -408,7 +408,7 @@ int tgec_enable(struct fman_mac *tgec)
 	return 0;
 }
 
-int tgec_disable(struct fman_mac *tgec)
+static int tgec_disable(struct fman_mac *tgec)
 {
 	struct tgec_regs __iomem *regs = tgec->regs;
 	u32 tmp;
@@ -423,7 +423,7 @@ int tgec_disable(struct fman_mac *tgec)
 	return 0;
 }
 
-int tgec_set_promiscuous(struct fman_mac *tgec, bool new_val)
+static int tgec_set_promiscuous(struct fman_mac *tgec, bool new_val)
 {
 	struct tgec_regs __iomem *regs = tgec->regs;
 	u32 tmp;
@@ -441,7 +441,7 @@ int tgec_set_promiscuous(struct fman_mac *tgec, bool new_val)
 	return 0;
 }
 
-int tgec_cfg_max_frame_len(struct fman_mac *tgec, u16 new_val)
+static int tgec_cfg_max_frame_len(struct fman_mac *tgec, u16 new_val)
 {
 	if (is_init_done(tgec->cfg))
 		return -EINVAL;
@@ -451,8 +451,9 @@ int tgec_cfg_max_frame_len(struct fman_mac *tgec, u16 new_val)
 	return 0;
 }
 
-int tgec_set_tx_pause_frames(struct fman_mac *tgec, u8 __maybe_unused priority,
-			     u16 pause_time, u16 __maybe_unused thresh_time)
+static int tgec_set_tx_pause_frames(struct fman_mac *tgec,
+				    u8 __maybe_unused priority, u16 pause_time,
+				    u16 __maybe_unused thresh_time)
 {
 	struct tgec_regs __iomem *regs = tgec->regs;
 
@@ -464,7 +465,7 @@ int tgec_set_tx_pause_frames(struct fman_mac *tgec, u8 __maybe_unused priority,
 	return 0;
 }
 
-int tgec_accept_rx_pause_frames(struct fman_mac *tgec, bool en)
+static int tgec_accept_rx_pause_frames(struct fman_mac *tgec, bool en)
 {
 	struct tgec_regs __iomem *regs = tgec->regs;
 	u32 tmp;
@@ -482,7 +483,8 @@ int tgec_accept_rx_pause_frames(struct fman_mac *tgec, bool en)
 	return 0;
 }
 
-int tgec_modify_mac_address(struct fman_mac *tgec, const enet_addr_t *p_enet_addr)
+static int tgec_modify_mac_address(struct fman_mac *tgec,
+				   const enet_addr_t *p_enet_addr)
 {
 	if (!is_init_done(tgec->cfg))
 		return -EINVAL;
@@ -493,7 +495,8 @@ int tgec_modify_mac_address(struct fman_mac *tgec, const enet_addr_t *p_enet_add
 	return 0;
 }
 
-int tgec_add_hash_mac_address(struct fman_mac *tgec, enet_addr_t *eth_addr)
+static int tgec_add_hash_mac_address(struct fman_mac *tgec,
+				     enet_addr_t *eth_addr)
 {
 	struct tgec_regs __iomem *regs = tgec->regs;
 	struct eth_hash_entry *hash_entry;
@@ -530,7 +533,7 @@ int tgec_add_hash_mac_address(struct fman_mac *tgec, enet_addr_t *eth_addr)
 	return 0;
 }
 
-int tgec_set_allmulti(struct fman_mac *tgec, bool enable)
+static int tgec_set_allmulti(struct fman_mac *tgec, bool enable)
 {
 	u32 entry;
 	struct tgec_regs __iomem *regs = tgec->regs;
@@ -553,7 +556,7 @@ int tgec_set_allmulti(struct fman_mac *tgec, bool enable)
 	return 0;
 }
 
-int tgec_set_tstamp(struct fman_mac *tgec, bool enable)
+static int tgec_set_tstamp(struct fman_mac *tgec, bool enable)
 {
 	struct tgec_regs __iomem *regs = tgec->regs;
 	u32 tmp;
@@ -573,7 +576,8 @@ int tgec_set_tstamp(struct fman_mac *tgec, bool enable)
 	return 0;
 }
 
-int tgec_del_hash_mac_address(struct fman_mac *tgec, enet_addr_t *eth_addr)
+static int tgec_del_hash_mac_address(struct fman_mac *tgec,
+				     enet_addr_t *eth_addr)
 {
 	struct tgec_regs __iomem *regs = tgec->regs;
 	struct eth_hash_entry *hash_entry = NULL;
@@ -614,7 +618,7 @@ static void adjust_link_void(struct mac_device *mac_dev)
 {
 }
 
-int tgec_get_version(struct fman_mac *tgec, u32 *mac_version)
+static int tgec_get_version(struct fman_mac *tgec, u32 *mac_version)
 {
 	struct tgec_regs __iomem *regs = tgec->regs;
 
@@ -626,8 +630,8 @@ int tgec_get_version(struct fman_mac *tgec, u32 *mac_version)
 	return 0;
 }
 
-int tgec_set_exception(struct fman_mac *tgec,
-		       enum fman_mac_exceptions exception, bool enable)
+static int tgec_set_exception(struct fman_mac *tgec,
+			      enum fman_mac_exceptions exception, bool enable)
 {
 	struct tgec_regs __iomem *regs = tgec->regs;
 	u32 bit_mask = 0;
@@ -653,7 +657,7 @@ int tgec_set_exception(struct fman_mac *tgec,
 	return 0;
 }
 
-int tgec_init(struct fman_mac *tgec)
+static int tgec_init(struct fman_mac *tgec)
 {
 	struct tgec_cfg *cfg;
 	enet_addr_t eth_addr;
@@ -736,7 +740,7 @@ int tgec_init(struct fman_mac *tgec)
 	return 0;
 }
 
-int tgec_free(struct fman_mac *tgec)
+static int tgec_free(struct fman_mac *tgec)
 {
 	free_init_resources(tgec);
 
@@ -746,7 +750,7 @@ int tgec_free(struct fman_mac *tgec)
 	return 0;
 }
 
-struct fman_mac *tgec_config(struct fman_mac_params *params)
+static struct fman_mac *tgec_config(struct fman_mac_params *params)
 {
 	struct fman_mac *tgec;
 	struct tgec_cfg *cfg;
-- 
2.35.1.1320.gc452695387.dirty

