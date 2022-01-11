Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E76DB48B9B7
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 22:34:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245353AbiAKVez (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 16:34:55 -0500
Received: from mx0c-0054df01.pphosted.com ([67.231.159.91]:36885 "EHLO
        mx0c-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S245503AbiAKVem (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 16:34:42 -0500
Received: from pps.filterd (m0208999.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20BCxNPo017415;
        Tue, 11 Jan 2022 16:14:33 -0500
Received: from can01-to1-obe.outbound.protection.outlook.com (mail-to1can01lp2055.outbound.protection.outlook.com [104.47.61.55])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3dgjrs97yj-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jan 2022 16:14:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VraCVA0IMvtHq1ynw5HD+215j2pwznNw7VQHsYMa5UIjgVaX7ZsxUdjsfDWgYfQlAuCmV9B5v2nMF5aoQx3Vb6e0buhr7AM1CW4G405GVDjcPb7O0bBt9FHhuJ8cZrKzTIYAiqBi+/dEhO59bBM6Xrn64NNgiHN3+7CfG0OkI5HsjHSxXXQW6DMg8E30ssz24sDqDERogKPX9n2YXwa6E9uGzJ5ovSMCQEV5hP8hnzSlydFeYaBAf6QKmn7OvjCBXdjz7r+zyV8T49c+c5Dl1vuM7/V8Iw/iMbGEfvwrK+lS5T5YcWuLgzwQRLulIYPJng/FO3ABhc49eXW3kVVUzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NELenvXBA63kf6Snn4EX7z1qhoNmazk74Onyhix7id4=;
 b=ZxxOkrBFDiXWxjkD2nNsHzIvjLBrOPSquweEhNiX/4pfSsTQKnyKlrwj4hHak3uyDaDJsyN1GQpnwWxmKec69Eq5mHlPa358pIS6w/1HeJEA2pB1tTdicIza8/kKT6qXsrr3Vtsg3Y6+D0T1x8zwSe52SMee0FYN3P/dtqmY9at2CfQfIpgLr7HAfKH6P00kMQN1JBAQF+zvjVI629GqOx4uzeQirZWrj6dkKtMBS9po/PAsaQwP74D7GwvMwSAOO0UdoQAMm1UjZOJq5x2PvLQmULLSxWBe2kqTO3HY4DFPOjWnwdL4txtHblmokOzLWv/g+4rvbU8K2+sP10grvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NELenvXBA63kf6Snn4EX7z1qhoNmazk74Onyhix7id4=;
 b=xZ4JtQ2rF3L+DJATHX/+10EW+3S66f2gDTyxxC1FLD1hHr3P2zyuS7r4ne3nQzcZqM3aQ3I9yB/e8NvPUTZk7BJE51A6CpkIvsVTjZ7JjeSdcqDhlT/IeDIkAQbLCorIp86ibvJFNRuYRvoDxkS+I5K5lXv/b4h7uNTGs64WFzk=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YT3PR01MB9218.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:a0::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.10; Tue, 11 Jan
 2022 21:14:31 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::d1f6:d9e4:7cc7:af76]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::d1f6:d9e4:7cc7:af76%5]) with mapi id 15.20.4867.012; Tue, 11 Jan 2022
 21:14:31 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     netdev@vger.kernel.org
Cc:     radhey.shyam.pandey@xilinx.com, davem@davemloft.net,
        kuba@kernel.org, Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net 6/7] net: axienet: fix for TX busy handling
Date:   Tue, 11 Jan 2022 15:13:57 -0600
Message-Id: <20220111211358.2699350-7-robert.hancock@calian.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220111211358.2699350-1-robert.hancock@calian.com>
References: <20220111211358.2699350-1-robert.hancock@calian.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR07CA0049.namprd07.prod.outlook.com
 (2603:10b6:610:5b::23) To YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:6a::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bce36c4c-56d8-4304-a1ea-08d9d5475bff
X-MS-TrafficTypeDiagnostic: YT3PR01MB9218:EE_
X-Microsoft-Antispam-PRVS: <YT3PR01MB92185F8A65F143D73D807902EC519@YT3PR01MB9218.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 40w3suxOELcyseHgXTxj6tBaPMmeka9q2gBT2Pb5SeBcojFS9jR8068OXD4tUGbzps5VyXtWQCdZUDynAt7UQmc9Dfs9OyZir8nz8Uo+rzFVqKCtfQvh7DYON2A2e6jCeAlRekBXWDLxZRbixrSZ/r5ZYxddlbOq55s3v9VUEGtsKs8zOP9o4VmdqXtyQbRRxxour7vjsADBpKlgNkrhXrdNy0HjVB/f+XRAJqWMm4vu07ogM9fmvFNhOVhB8if0m7ywxvxzZDxLGybtqtePHZJ5bLL9Xw+OtGAtW0CmrUeoqcH2FMis/uTSqDCotVKAwgmB6Mg6kyKGnszHTsgcUDRY+w83X5n9kfOl8FHAICJzJrDbK915wQzSNqWLHaeJ8SYiZd/jt5h1lQy1/rBqX6OnaRfDzdppvYi/VWikF3C/Xp7arCSY1APUWssKQIk9L/mUID+bFc/0kGtZWPj0X5ilrVahSdzxDSAPu3oPgfocA33ktyUtELorMauhtQM6NKE90G04F1Gax6e6ZWI0jVykT3QHyQL2uhDVoaW9hqsIPIGcz6F2qFHCJlmoD30IrTDfwcS8LC/SrVrj38sXmNAl7mv4ayU2X/EIUYkMuy79PAIQ01ZpwRwFCwZrjdoO92p86kXBrLNwIT+6T3mYYoSo+q5rtELixot0IkcQfcC9KKuLSvO+u09DWpe5fdKd6hEQF2nkBO7cNhLtEiVpYw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(66556008)(66476007)(66946007)(52116002)(6506007)(86362001)(38100700002)(26005)(186003)(44832011)(2616005)(8676002)(2906002)(1076003)(6512007)(38350700002)(36756003)(316002)(8936002)(6666004)(4326008)(508600001)(5660300002)(6916009)(107886003)(6486002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?U13ecBgl6yfNeutYA3fhLKbyblPXZIjYI2AuAX/nN2KS7doh333X27gD6Dnm?=
 =?us-ascii?Q?oOKGS6vosGdnpJ1E9lkds/WiNQOT0j/xwBxkUcxBLElN+IlPha5klHQVJqCs?=
 =?us-ascii?Q?ojjT/IYu1UDyCFEFOd8fTLcIfsTYxfWIvR/ReUjf17Ve276SRoBFHo2zSrbu?=
 =?us-ascii?Q?ivPzk4hXHy7MGRR02kZNMl2hjCy+yROGZ5A5lX1QCZmWKhQpvELr5fboyfTz?=
 =?us-ascii?Q?LwpGRn5+E1I1SaekGcQp1dp7ov4Os7aPtDTVKqfNvClH+Cvj1B5CV2XABzY2?=
 =?us-ascii?Q?OocCkR7/g5FGhWY73PNHwMqJdMSeoarDsFYbS7Puqe/+3U49c5ZSaMDzhwzT?=
 =?us-ascii?Q?Ew6MM+FbhlSgjk50ozi/2+Yi2y3PAOHgKDOoImunYO7/Eo4bIO/SKlxVnj1m?=
 =?us-ascii?Q?zUkCaKhdJj9NNVGw7n9jOI+y3bopg0dsI2gNMStA+uBj8GMkZO8VHB97u4bc?=
 =?us-ascii?Q?KoGd4FMkwfv/QD0a1pEfxLlAZqGEnkRAgausXGwUR561cQPucN61AW2W/j4c?=
 =?us-ascii?Q?kFSd21bJWFpb4rhgaHn0hYoFHMedvY9ruMOggZd0dnskZv+/8VNqZZHuxKTW?=
 =?us-ascii?Q?Jm7uTfEs82eyguMEAqkmSIfp9DLpYAMg6+/aex6ekdRlcJ0PeKHOa+PIjmIK?=
 =?us-ascii?Q?BxIyjstA+uZtyjybT9B9rzNPW4jB0YKGbj50sclzKE2KKxOCIapddCJ4UD0p?=
 =?us-ascii?Q?ZyI6XWSmziPoFca2cfg5dI19BWkAf50V/ki5kM9Zp77wJ6lz7UnP4J3SLMim?=
 =?us-ascii?Q?8MNnSM6Xd7p0cVjGsJcdQvFxkLLY5mj/9oC+Cfj+s0/gdgLuVOLsCNgcyksW?=
 =?us-ascii?Q?2j5rs+/OgCWexGfIBp4SCVSAVQmY61qJnqyF2VJ+zpLJ+Yrv/xSB8PW7hL5e?=
 =?us-ascii?Q?l70LVoxTZKXm0y2UNBpyyRWvy4U2gCOowTw6BkMmLTITMV4VawUMC3Eg97/7?=
 =?us-ascii?Q?eNJkS06JVLl6HxDqgOHDymamNj/4yzOa/1puUIHUSc8esfR73VnYdHjRzRLk?=
 =?us-ascii?Q?j86iFVHfUbSYKputqPJGvt3rSqIk5R6NfG8XRzRGmcQUPzDo91YFkwPS933a?=
 =?us-ascii?Q?8hR8s787+7/QszQqKOEDFVB2XK/w6PAvimnMwQbcN8KJcg5yhRlUQ73Ul5Ye?=
 =?us-ascii?Q?TZ+az/rlJmJ457A4Mfczasvz1aMCUXEQaJiyGubhppSps/CKwITpwDct9qPC?=
 =?us-ascii?Q?9b1CIA6eezKMJN1Hm0kAueR8DyOUNgMjMAGf44bS7Wf49RlFhRhHJti29tWJ?=
 =?us-ascii?Q?cP2EMmOGupU7NQeIW86e643LPLMh4VqXvBcH15FKsTgoz5mkHBoOAN4lWBOW?=
 =?us-ascii?Q?FYUx/JHj1qBYTc8KEKR9VEkIAtLQbJ9Zkx/8YXQ5jEwJpR+62CF7npbEkUC/?=
 =?us-ascii?Q?D9EvhlNJp9LgYBqrKTytE7t4qIvg9trFDVod9jbxKI1x5nfOXtxlPjtT4kpr?=
 =?us-ascii?Q?fSK8LkoUo7iW0xsmmda8/OHqsopOf9GKa003w4U61oOXC0yRauYePEHQZe3D?=
 =?us-ascii?Q?vIQTIwAVUpVaGrgL+BhYVhHpQqwUkIErZJZPL0Mb7lAnvhtDdE8kGr/bVB/9?=
 =?us-ascii?Q?W3vZJLd9gsHe5IgJKHkXAsRFZh/dMW0d33pPKVJibZK3X+ZWn/YaUF9y9Mtz?=
 =?us-ascii?Q?Ho37bAb3NRqe4aRPeEKC2GZ371JDow/affRsrO2bsC6rX2WNa9kQVjgVYbW6?=
 =?us-ascii?Q?203yBQ=3D=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bce36c4c-56d8-4304-a1ea-08d9d5475bff
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2022 21:14:31.3915
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tXe4ls0O4ylk3uY1Rs/atMiQGnW+LBIDS7oiuMDYCNzDx99+LjRdZhdOfDDWFaQsiMYJHs4TtWAH7LLeW+itVqXbO5tGUpQxd7NWg6zZTqo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT3PR01MB9218
X-Proofpoint-ORIG-GUID: z10hEzwEisIPnPBj_E5qdM0lm5ZcaCIy
X-Proofpoint-GUID: z10hEzwEisIPnPBj_E5qdM0lm5ZcaCIy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-11_04,2022-01-11_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 priorityscore=1501 suspectscore=0 adultscore=0 clxscore=1015 phishscore=0
 mlxlogscore=795 malwarescore=0 spamscore=0 mlxscore=0 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201110110
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We should be avoiding returning NETDEV_TX_BUSY from ndo_start_xmit in
normal cases. Move the main check for a full TX ring to the end of the
function so that we stop the queue after the last available space is used
up, and only wake up the queue if enough space is available for a full
maximally fragmented packet. Print a warning if there is insufficient
space at the start of start_xmit, since this should no longer happen.

Fixes: 8a3b7a252dca9 ("drivers/net/ethernet/xilinx: added Xilinx AXI Ethernet driver")
Signed-off-by: Robert Hancock <robert.hancock@calian.com>
---
 .../net/ethernet/xilinx/xilinx_axienet_main.c | 85 ++++++++++---------
 1 file changed, 46 insertions(+), 39 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index c5d214abd4d5..2191f813ed78 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -660,6 +660,32 @@ static int axienet_free_tx_chain(struct net_device *ndev, u32 first_bd,
 	return i;
 }
 
+/**
+ * axienet_check_tx_bd_space - Checks if a BD/group of BDs are currently busy
+ * @lp:		Pointer to the axienet_local structure
+ * @num_frag:	The number of BDs to check for
+ *
+ * Return: 0, on success
+ *	    NETDEV_TX_BUSY, if any of the descriptors are not free
+ *
+ * This function is invoked before BDs are allocated and transmission starts.
+ * This function returns 0 if a BD or group of BDs can be allocated for
+ * transmission. If the BD or any of the BDs are not free the function
+ * returns a busy status. This is invoked from axienet_start_xmit.
+ */
+static inline int axienet_check_tx_bd_space(struct axienet_local *lp,
+					    int num_frag)
+{
+	struct axidma_bd *cur_p;
+
+	/* Ensure we see all descriptor updates from device or TX IRQ path */
+	rmb();
+	cur_p = &lp->tx_bd_v[(lp->tx_bd_tail + num_frag) % lp->tx_bd_num];
+	if (cur_p->cntrl)
+		return NETDEV_TX_BUSY;
+	return 0;
+}
+
 /**
  * axienet_start_xmit_done - Invoked once a transmit is completed by the
  * Axi DMA Tx channel.
@@ -689,33 +715,8 @@ static void axienet_start_xmit_done(struct net_device *ndev)
 	/* Matches barrier in axienet_start_xmit */
 	smp_mb();
 
-	netif_wake_queue(ndev);
-}
-
-/**
- * axienet_check_tx_bd_space - Checks if a BD/group of BDs are currently busy
- * @lp:		Pointer to the axienet_local structure
- * @num_frag:	The number of BDs to check for
- *
- * Return: 0, on success
- *	    NETDEV_TX_BUSY, if any of the descriptors are not free
- *
- * This function is invoked before BDs are allocated and transmission starts.
- * This function returns 0 if a BD or group of BDs can be allocated for
- * transmission. If the BD or any of the BDs are not free the function
- * returns a busy status. This is invoked from axienet_start_xmit.
- */
-static inline int axienet_check_tx_bd_space(struct axienet_local *lp,
-					    int num_frag)
-{
-	struct axidma_bd *cur_p;
-
-	/* Ensure we see all descriptor updates from device or TX IRQ path */
-	rmb();
-	cur_p = &lp->tx_bd_v[(lp->tx_bd_tail + num_frag) % lp->tx_bd_num];
-	if (cur_p->cntrl)
-		return NETDEV_TX_BUSY;
-	return 0;
+	if (!axienet_check_tx_bd_space(lp, MAX_SKB_FRAGS + 1))
+		netif_wake_queue(ndev);
 }
 
 /**
@@ -748,19 +749,13 @@ axienet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	cur_p = &lp->tx_bd_v[lp->tx_bd_tail];
 
 	if (axienet_check_tx_bd_space(lp, num_frag + 1)) {
-		if (netif_queue_stopped(ndev))
-			return NETDEV_TX_BUSY;
-
+		/* Should not happen as last start_xmit call should have
+		 * checked for sufficient space and queue should only be
+		 * woken when sufficient space is available.
+		 */
 		netif_stop_queue(ndev);
-
-		/* Matches barrier in axienet_start_xmit_done */
-		smp_mb();
-
-		/* Space might have just been freed - check again */
-		if (axienet_check_tx_bd_space(lp, num_frag + 1))
-			return NETDEV_TX_BUSY;
-
-		netif_wake_queue(ndev);
+		netdev_warn(ndev, "TX ring unexpectedly full\n");
+		return NETDEV_TX_BUSY;
 	}
 
 	if (skb->ip_summed == CHECKSUM_PARTIAL) {
@@ -821,6 +816,18 @@ axienet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	if (++lp->tx_bd_tail >= lp->tx_bd_num)
 		lp->tx_bd_tail = 0;
 
+	/* Stop queue if next transmit may not have space */
+	if (axienet_check_tx_bd_space(lp, MAX_SKB_FRAGS + 1)) {
+		netif_stop_queue(ndev);
+
+		/* Matches barrier in axienet_start_xmit_done */
+		smp_mb();
+
+		/* Space might have just been freed - check again */
+		if (!axienet_check_tx_bd_space(lp, MAX_SKB_FRAGS + 1))
+			netif_wake_queue(ndev);
+	}
+
 	return NETDEV_TX_OK;
 }
 
-- 
2.31.1

