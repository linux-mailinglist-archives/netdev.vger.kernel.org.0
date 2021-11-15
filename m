Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AEB144FE06
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 06:02:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbhKOFE4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 00:04:56 -0500
Received: from mail-eopbgr1320092.outbound.protection.outlook.com ([40.107.132.92]:52771
        "EHLO APC01-PU1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229488AbhKOFEs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Nov 2021 00:04:48 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qkwk7rWVHb3V8qkTpDbwgA4LJnkVU8cM7Zy3DqdRqaXpLg7Sf8MsuYlxODKk5Xh+0IgBIGL2aCHKt9qDEi4P3XNXOmdLfEuHaPmHg9z0pYUcyfrCRMs8v+FX01GOyMwMmIAyAcDgXQ4giCkXLvEZtiTQjVAB7ih5Lu8KtnD+hoq7zpXnv7eeo1+QpU+LkO5fJXqEcL4P8INucKMWFaLxOgP9LuBD1GRiWuAhuJQD4avQQyI5DBeXyTdLqm4/LvCiHP0gu4oW9RnTLbWQAHsQN+8SGeVTqT48QdrQfaowZsEZ1AAnGGQbG+hRN45Fp++2aMcqgNG8r6yhJTvHxKb2cQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=97IRTGcVexradqIrSx7PArj/WTzygMoaAR2+3qqWHF8=;
 b=A3qscRGgto1vzIKLNJrUu+AurbhSvw/6jN7GOVy6PVHQKXBPq0YIOWL8MxLxR9U6+EnUE92HFGGx5/pau3SyMhkTX3yp9JRyG2DoSFX+VJPvMI+CqELNRBOV/kinFKxEbC+gRARlkG5/7N6tvb+2KCKlOv/rvdzJ4SPk5f52pWkjuFwz00RqZLCQoyKyeUGahu+tJHXT/yHtgYrtNHjfSxCgMvEFxezdSXwBulrE3L/DYyDP8jLCTlH4xq0r5+xrvb5mu0yRRoP1t+yCmFLfu+OgMR1Ovtur2XgkcFqiUE59O51jVAuzigMZfAKkr+ZpPIkDs9qX4rnMfHOJivVgiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=97IRTGcVexradqIrSx7PArj/WTzygMoaAR2+3qqWHF8=;
 b=hLKvrDO9JQmKURp7+kstyF/Aeq48Xsj94irAKodm8zgIpmI11B0ApPsvVailnTWyFUa2+ffG8SHUf0xIlsVYISiuvOc/V7z4K+YQMaNsGOzROgze8sOCkRdRYT9vd3ALt9BhsYhlF17HkT97u4ybEj89p7gdUPKmeM1RnVzL9Tg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from HK2PR06MB3492.apcprd06.prod.outlook.com (2603:1096:202:2f::10)
 by HK2PR06MB3425.apcprd06.prod.outlook.com (2603:1096:202:3c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.15; Mon, 15 Nov
 2021 05:01:43 +0000
Received: from HK2PR06MB3492.apcprd06.prod.outlook.com
 ([fe80::814a:4668:a3bd:768]) by HK2PR06MB3492.apcprd06.prod.outlook.com
 ([fe80::814a:4668:a3bd:768%7]) with mapi id 15.20.4690.027; Mon, 15 Nov 2021
 05:01:43 +0000
From:   Guo Zhengkui <guozhengkui@vivo.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Yufeng Mo <moyufeng@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Sean Anderson <sean.anderson@seco.com>,
        Guo Zhengkui <guozhengkui@vivo.com>,
        Daode Huang <huangdaode@huawei.com>,
        Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     kernel@vivo.com, Alejandro Colomar <colomar.6.4.3@gmail.com>
Subject: [PATCH] hinic: use ARRAY_SIZE instead of ARRAY_LEN
Date:   Mon, 15 Nov 2021 13:00:10 +0800
Message-Id: <20211115050026.5622-1-guozhengkui@vivo.com>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0093.apcprd02.prod.outlook.com
 (2603:1096:4:90::33) To HK2PR06MB3492.apcprd06.prod.outlook.com
 (2603:1096:202:2f::10)
MIME-Version: 1.0
Received: from localhost.localdomain (203.90.234.87) by SG2PR02CA0093.apcprd02.prod.outlook.com (2603:1096:4:90::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26 via Frontend Transport; Mon, 15 Nov 2021 05:01:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 25be90b5-97c8-483b-f1d2-08d9a7f5045d
X-MS-TrafficTypeDiagnostic: HK2PR06MB3425:
X-Microsoft-Antispam-PRVS: <HK2PR06MB342579EA5F6415D98250CA0EC7989@HK2PR06MB3425.apcprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: daIulB/p4xRB7lJCB8MuKnVmg7T7wDmG4JiEDXQ9V7HKavvNUgEGpUFLLy/2NbPWmXa7GY5zEI91FK9RbYP/1lpWlI2h4r9Pkuql5LVSwS8DL3jziSJBFwMh4D4TpI3+LDy69grPeP+96sb0Zv/wN95fd7fHz37/+74ZJtHSQRMhyFWLum+pZB2Z9+FA3nTaQPJd4Hfr1IjMydFlQAPe2xUF/mnHJDynC7u6s38scgHmhzUzyIA6Ya5Aii+P5VhKUYU4YESw9GPha8XTJgIZ7shptEpuCQVyo7xxudHoMVbzuc/5B6vE9KLJOnNMSjDKwt27O7bcOPN1Ed4q/htrfqzHKzoG7sE0pFtyPrhqhbWEWXD3UyXiUmyLgGNrOb1AZILIrYpKZ799zGpcfD0E5ix8A4lLX8vf63b7nkNVh0L0knNoKuQu3GXYQQA6ZMEH1xiJdyBSec5dzU0Q4qpP8tWKoEaUGzl+D6kOVoF92mx04aYKHYyh1cRbLHH/R1m8quImfsazMaOKP28dPPFN6/jCpk4JUBGiFJ15B50X9Vom9B8aLWYdSZybbu9P25IYKM+pnros0J/g5acS17QjVoxd9IWlhBqSJiTi7rJNSlJxdvTD7/QBMzbBquT5Q/jlu386u+IkZHHpcyIkRo2bavudWxbWSyZwJpSayCwwYOrkFBi5S/7Uzdv19T09IhW1u7q+rIkzyuYtlynaoLqAllDQQK5UNjQY+tFyfJRHL1k=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HK2PR06MB3492.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6506007)(38100700002)(38350700002)(6666004)(6512007)(8936002)(83380400001)(508600001)(4326008)(956004)(36756003)(2616005)(6486002)(86362001)(66556008)(52116002)(5660300002)(921005)(110136005)(2906002)(7416002)(66946007)(26005)(1076003)(316002)(186003)(8676002)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/GHFPHRVGYstj/yFC11n1TJq+0fBfnXGfCD4ZjedOEOb9BEw5DATPWpt57o2?=
 =?us-ascii?Q?PCejLAywgexkqoRSdHf2vdRNmZZUxrBYn+3i8roCgpwRPqT5/dEvwYPL/F/Y?=
 =?us-ascii?Q?Qk8nTWy7U2U0Ij/VDaHF6JeP9nTsdeXEG6opUbspGhrExIuBqyR/kQ3MJ/3/?=
 =?us-ascii?Q?QRcAIll7g0y4DVP2X+FdzmxbEXJS5Z/wHdMyPonegKLXCwmXihdzPI1mJKMd?=
 =?us-ascii?Q?xgNbMhiIZJC2yrjHOYiZxDMpgbbyTSYSDnMztbDz+V1yK+QoOXW6gjDP1M0o?=
 =?us-ascii?Q?QvXRKnl6hwYRiuHDAmotNBNBMIDRTfTOtJH+51+Pw6MY8AT+/9+grSVB4atk?=
 =?us-ascii?Q?6Za826CnbTV0akDDTW2gylXv/7rlqqfJcpgOc2zgAmYOa/MPo2Q7PPb/x0t+?=
 =?us-ascii?Q?EdX4g8O06ndQMxBltrHrJSKkl97LgVGD3IJwL9jPl2CvKz5T9mSg03Pi/qbB?=
 =?us-ascii?Q?4bQWYHoKawOhUOmGc6p3PKDRX2lX1ikK0ZT5qIZnw3pD2Me5e23P1iWUdCou?=
 =?us-ascii?Q?cxUwjCou3CzhxF5lPuPhYD/jXJsoipIJzH1Tr1DJLWOFRKEwYO/2rG7Fg6cL?=
 =?us-ascii?Q?L9DmJKyaVh6So1lAltkX54/8qtyzrp/ZIR9A1RRINIniKs3PbjCpmmsQvhc+?=
 =?us-ascii?Q?oHugeqBIRpN4kgwnnGYqiYV7762ilqlYyYZS14jVxhkUYIHHdKY7r31L9B9b?=
 =?us-ascii?Q?5FEST1n1HzTVlMBhWVTXxdHhjq+amZ6AY2w3HAl5NPChEpvqFNgKkUfDeaPJ?=
 =?us-ascii?Q?ZXTP6C8yjLw+qa4XSzQoX/sFVTCM62O8ceV4bjGtx7wag5lYpoEq739IiRzS?=
 =?us-ascii?Q?VKKQB2YpSXwNtkjHZBpx1I7b+9+FAVFGxsCBbzR2X7Qg6rCNzz+fAsQIfGau?=
 =?us-ascii?Q?9qwSQiVSYnJYpDNyjDQJ7J6pAz9LJq7rxP4ZERZcEAWI4heljqVdXegdqpFi?=
 =?us-ascii?Q?+vyhPpByNyD3OtcK3MTVECUKjxLCFc/MR+xpCFSZDB6MwxHF/eP16gXjOeCl?=
 =?us-ascii?Q?HgsQQ5tycUChiJQ2wZ2W/TM5BuMLoY6gF2FTVMUoGEprQ2siscdwMcMF05Q7?=
 =?us-ascii?Q?jpwNDCUWwUurNV6zYHey2za1ynR/D71VZTPhG+YXdVtr9os1bEyZNL7xY/nE?=
 =?us-ascii?Q?hH2iMY/Yd+SEND+LT1ipPjaPUrHteLR17nd7tJQhb1VhJdBcjEOoPuiTkicI?=
 =?us-ascii?Q?cN5oxLh3tZLkpwRWx9N8+qlYl/D0OQri6Iz260gVdA1Z4LZho7Uxt6WuVLs+?=
 =?us-ascii?Q?60ngYYHYQgKH4qA5kwvUvAIUHUOQA8FCD8NdZ52n0M6WiJjHg49gtZv6Ckd7?=
 =?us-ascii?Q?uchqf7B4/owsegA0StJZkRmMcgHbiOrBP18A3KZd27VUFGYPaDy/Zp5c2Z4M?=
 =?us-ascii?Q?Er0FKwNz9wY2p+eqgZjaUHA3Trop8hrJsMbHV+u0GHXIFlMQgERbcnJeZrcx?=
 =?us-ascii?Q?bHctPem66QEaBHeIMxu+rY9mJ5BH0kyl8xrOoeDe0IUweKE9s5xcwnl8061g?=
 =?us-ascii?Q?mT9i37s5mlTl5K93sVq+3FPik8HVSYUpARDDzGvhWfdJDjS7/jXRNl2SAxso?=
 =?us-ascii?Q?9y+EGGLHPmrhw0VMV01El/fhkmeEh59UfE6TXuVlMKx5D7uJjaP9ywlWkG43?=
 =?us-ascii?Q?ehnoRUU2Vg9eaEqmjCFWXnI=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25be90b5-97c8-483b-f1d2-08d9a7f5045d
X-MS-Exchange-CrossTenant-AuthSource: HK2PR06MB3492.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2021 05:01:43.3596
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7BPonnTcxKjiitmGkqjPyyJIzuBoC7D/UyGeyXjrVe/duOAXWaWx6CUu/CWEfpwNfoqIX2zomIGGGbZvTEDoqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HK2PR06MB3425
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ARRAY_SIZE defined in <linux/kernel.h> is safer than self-defined
macros to get size of an array such as ARRAY_LEN used here. Because
ARRAY_SIZE uses __must_be_array(arr) to ensure arr is really an array.

Reported-by: Alejandro Colomar <colomar.6.4.3@gmail.com>
Signed-off-by: Guo Zhengkui <guozhengkui@vivo.com>
---
 .../net/ethernet/huawei/hinic/hinic_ethtool.c | 32 +++++++++----------
 1 file changed, 15 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c b/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
index a85667078b72..a35a80f9a234 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
@@ -1205,8 +1205,6 @@ static u32 hinic_get_rxfh_indir_size(struct net_device *netdev)
 	return HINIC_RSS_INDIR_SIZE;
 }
 
-#define ARRAY_LEN(arr) ((int)((int)sizeof(arr) / (int)sizeof(arr[0])))
-
 #define HINIC_FUNC_STAT(_stat_item) {	\
 	.name = #_stat_item, \
 	.size = sizeof_field(struct hinic_vport_stats, _stat_item), \
@@ -1374,7 +1372,7 @@ static void get_drv_queue_stats(struct hinic_dev *nic_dev, u64 *data)
 			break;
 
 		hinic_txq_get_stats(&nic_dev->txqs[qid], &txq_stats);
-		for (j = 0; j < ARRAY_LEN(hinic_tx_queue_stats); j++, i++) {
+		for (j = 0; j < ARRAY_SIZE(hinic_tx_queue_stats); j++, i++) {
 			p = (char *)&txq_stats +
 				hinic_tx_queue_stats[j].offset;
 			data[i] = (hinic_tx_queue_stats[j].size ==
@@ -1387,7 +1385,7 @@ static void get_drv_queue_stats(struct hinic_dev *nic_dev, u64 *data)
 			break;
 
 		hinic_rxq_get_stats(&nic_dev->rxqs[qid], &rxq_stats);
-		for (j = 0; j < ARRAY_LEN(hinic_rx_queue_stats); j++, i++) {
+		for (j = 0; j < ARRAY_SIZE(hinic_rx_queue_stats); j++, i++) {
 			p = (char *)&rxq_stats +
 				hinic_rx_queue_stats[j].offset;
 			data[i] = (hinic_rx_queue_stats[j].size ==
@@ -1411,7 +1409,7 @@ static void hinic_get_ethtool_stats(struct net_device *netdev,
 		netif_err(nic_dev, drv, netdev,
 			  "Failed to get vport stats from firmware\n");
 
-	for (j = 0; j < ARRAY_LEN(hinic_function_stats); j++, i++) {
+	for (j = 0; j < ARRAY_SIZE(hinic_function_stats); j++, i++) {
 		p = (char *)&vport_stats + hinic_function_stats[j].offset;
 		data[i] = (hinic_function_stats[j].size ==
 				sizeof(u64)) ? *(u64 *)p : *(u32 *)p;
@@ -1420,8 +1418,8 @@ static void hinic_get_ethtool_stats(struct net_device *netdev,
 	port_stats = kzalloc(sizeof(*port_stats), GFP_KERNEL);
 	if (!port_stats) {
 		memset(&data[i], 0,
-		       ARRAY_LEN(hinic_port_stats) * sizeof(*data));
-		i += ARRAY_LEN(hinic_port_stats);
+		       ARRAY_SIZE(hinic_port_stats) * sizeof(*data));
+		i += ARRAY_SIZE(hinic_port_stats);
 		goto get_drv_stats;
 	}
 
@@ -1430,7 +1428,7 @@ static void hinic_get_ethtool_stats(struct net_device *netdev,
 		netif_err(nic_dev, drv, netdev,
 			  "Failed to get port stats from firmware\n");
 
-	for (j = 0; j < ARRAY_LEN(hinic_port_stats); j++, i++) {
+	for (j = 0; j < ARRAY_SIZE(hinic_port_stats); j++, i++) {
 		p = (char *)port_stats + hinic_port_stats[j].offset;
 		data[i] = (hinic_port_stats[j].size ==
 				sizeof(u64)) ? *(u64 *)p : *(u32 *)p;
@@ -1449,14 +1447,14 @@ static int hinic_get_sset_count(struct net_device *netdev, int sset)
 
 	switch (sset) {
 	case ETH_SS_TEST:
-		return ARRAY_LEN(hinic_test_strings);
+		return ARRAY_SIZE(hinic_test_strings);
 	case ETH_SS_STATS:
 		q_num = nic_dev->num_qps;
-		count = ARRAY_LEN(hinic_function_stats) +
-			(ARRAY_LEN(hinic_tx_queue_stats) +
-			ARRAY_LEN(hinic_rx_queue_stats)) * q_num;
+		count = ARRAY_SIZE(hinic_function_stats) +
+			(ARRAY_SIZE(hinic_tx_queue_stats) +
+			ARRAY_SIZE(hinic_rx_queue_stats)) * q_num;
 
-		count += ARRAY_LEN(hinic_port_stats);
+		count += ARRAY_SIZE(hinic_port_stats);
 
 		return count;
 	default:
@@ -1476,27 +1474,27 @@ static void hinic_get_strings(struct net_device *netdev,
 		memcpy(data, *hinic_test_strings, sizeof(hinic_test_strings));
 		return;
 	case ETH_SS_STATS:
-		for (i = 0; i < ARRAY_LEN(hinic_function_stats); i++) {
+		for (i = 0; i < ARRAY_SIZE(hinic_function_stats); i++) {
 			memcpy(p, hinic_function_stats[i].name,
 			       ETH_GSTRING_LEN);
 			p += ETH_GSTRING_LEN;
 		}
 
-		for (i = 0; i < ARRAY_LEN(hinic_port_stats); i++) {
+		for (i = 0; i < ARRAY_SIZE(hinic_port_stats); i++) {
 			memcpy(p, hinic_port_stats[i].name,
 			       ETH_GSTRING_LEN);
 			p += ETH_GSTRING_LEN;
 		}
 
 		for (i = 0; i < nic_dev->num_qps; i++) {
-			for (j = 0; j < ARRAY_LEN(hinic_tx_queue_stats); j++) {
+			for (j = 0; j < ARRAY_SIZE(hinic_tx_queue_stats); j++) {
 				sprintf(p, hinic_tx_queue_stats[j].name, i);
 				p += ETH_GSTRING_LEN;
 			}
 		}
 
 		for (i = 0; i < nic_dev->num_qps; i++) {
-			for (j = 0; j < ARRAY_LEN(hinic_rx_queue_stats); j++) {
+			for (j = 0; j < ARRAY_SIZE(hinic_rx_queue_stats); j++) {
 				sprintf(p, hinic_rx_queue_stats[j].name, i);
 				p += ETH_GSTRING_LEN;
 			}
-- 
2.20.1

