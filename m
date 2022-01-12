Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A224448C9EF
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 18:39:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343822AbiALRiz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 12:38:55 -0500
Received: from mx0c-0054df01.pphosted.com ([67.231.159.91]:28092 "EHLO
        mx0c-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241269AbiALRi0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 12:38:26 -0500
Received: from pps.filterd (m0208999.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20CE6nAx020453;
        Wed, 12 Jan 2022 12:38:05 -0500
Received: from can01-qb1-obe.outbound.protection.outlook.com (mail-qb1can01lp2051.outbound.protection.outlook.com [104.47.60.51])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3dj0fcg53p-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Jan 2022 12:38:05 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EGxM14P0SI9Ck7iQYueMotkDvI2oivLtal/LOHmtfxQTeT+kUEe8SHybi61Jems/hnmasFs1iqCvk3IzTIqANGcTxkFGdwypQtpoDqwSxmNDT2PgpPNxBWGznel+xsgFtIFiC2/ucGV1aXeCAFFPZxns3XvUyD8nuIn5oMIRDv2HlproBoGN0/qu55jQdRXAe6KDX504kWZzLzCRjxa5CZYzvbmOGf4xHxpl+zL7I4JuVdeylwUC+rc0602glw71eWpXk5jvZ5yz4+dC0WdH6sLHu2p8c/yBQsdqZG+l7ewRzTq5oVNUDYpKwo/jXSuckBpwYovM/C1nrarJnua4Ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=51+qJ3HUjZ4+DjkO06j8XK3STQZLOzifhN7quYniat4=;
 b=gDk7ohhaeFUS6Qgn7ytvdEDW/L/7aygPr7GaS2TZbjW7iChpZfYxfizU6RR0rYrDpRp0dyj2dJIx6ePzhp+TazwhMXj/4Z0Vp27aRZSltMarNYTvepLpMDaINmjH7TSF+XecRPomfl56f3UugTY35j0MNRMftBwOLfQW5f1Tq7SPG0L/GCfET21OkPrL+7dPuDHAeJgJf4lTF/EcswS/EC/z60BNaeGTuOpBn3LEZn3azvyxDhhqXfAFTpNG3hYEFKcMQJF1lusFJnIGKYicArFLsGXqUKVdtgIAYO0PTZD3VK5ZraPegbRpJbg1h3vAgLyc5W8yuun/0P4Ek5pPBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=51+qJ3HUjZ4+DjkO06j8XK3STQZLOzifhN7quYniat4=;
 b=IryDyLoDChT3TjDlXIvUCV89P2OSGlIKHa/RNCGSQ7AI38i/1vSXRUv8hsEMP2j6pPauXbDegjjZOPnnzLdINo4CNmIyedTEndfBP683YS/rFwpkC9I8dcXF4m9pmkSIpZLrA/4Qsk+Ois1PDFPz2r8nPBhuoEjWYlHJOSMUn1Q=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YTBPR01MB3424.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:1a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.9; Wed, 12 Jan
 2022 17:38:03 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8%2]) with mapi id 15.20.4888.010; Wed, 12 Jan 2022
 17:38:03 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     netdev@vger.kernel.org
Cc:     radhey.shyam.pandey@xilinx.com, davem@davemloft.net,
        kuba@kernel.org, linux-arm-kernel@lists.infradead.org,
        michal.simek@xilinx.com, ariane.keller@tik.ee.ethz.ch,
        daniel@iogearbox.net, Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net v2 8/9] net: axienet: fix for TX busy handling
Date:   Wed, 12 Jan 2022 11:36:59 -0600
Message-Id: <20220112173700.873002-9-robert.hancock@calian.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220112173700.873002-1-robert.hancock@calian.com>
References: <20220112173700.873002-1-robert.hancock@calian.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CO2PR05CA0061.namprd05.prod.outlook.com
 (2603:10b6:102:2::29) To YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:6a::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b94b9e49-6bb6-48f1-0069-08d9d5f24943
X-MS-TrafficTypeDiagnostic: YTBPR01MB3424:EE_
X-Microsoft-Antispam-PRVS: <YTBPR01MB3424BE903747A5075639B1FCEC529@YTBPR01MB3424.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j9427KXUS0AFJxCAJ1wMWSjvy0DhA5AJ8XYgK2Jajd0Nz/65r42VgMeYWS9V7E63ngyUPiD7VJnUyf9nWXhRvf7TEiIHhq9YUEOdvAgzn+jlh1hpJLnvkMysgd+ecCnhfMle+hCX7gOn/w8mFxHCYTcTleaf2luqDLYFwhSz3WLJQpQoKwFa0QPC9HhCqrnw63fz4RuAX6wXQIicUJ+VryRWFq6RG+QapXT3KBqoGuqEBzh25n5BZ27vRmhusAiVjcD+j/Mc2RtqhBHZoTGUnqsDksvuePWfASQKqn+U0H3j8oit3oGmInf3JmQgn+5BEmHSiaqVZch1ZOW3DQ2BuamiQnEaEySSDds9wCSBdGQdrS8Neug3zJZXClL3+Oj0QfmOCz8lUWaBAkmzJ1vdlyparj8u/K6kyt2iaJMHS34PIN3TpZ76v8zTnSHPsHSEXv35d5F8aneRjvxaBz1xrOmTj4CoMwprjd1MhxcOLUErH4InTCF8nbB8FDPb/a4/8AdMEzkDJq0dK9z0SPzcTE9+51gOTpFOf4YFnkVl1yAqIhafvWens9SWY9tOXVjY6+YErwnWIDLa4BoS0AT0aen/4P6tzJBtZF4pE0kJc56xbMTk/eAUCza2pYZ2fWYRomAbEwYVtvlx62/mDB9MBWnlB69lD/FlsjaebL8qOqb8+snHqJK251h06yG/F3Zuar1P/61BTTrvtgtNW4lxDw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(6486002)(6666004)(107886003)(186003)(66476007)(44832011)(38100700002)(26005)(52116002)(6506007)(6916009)(8676002)(508600001)(66556008)(83380400001)(8936002)(6512007)(86362001)(38350700002)(2906002)(4326008)(1076003)(316002)(5660300002)(66946007)(2616005)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?s3sat5LdVA5jPRYMm8UUknxBKakadpkWiahIz9SzoqLyjuB+roekH5xPzKvQ?=
 =?us-ascii?Q?PEiRHG04DsZwrlpZ2g5jcOhNlfOsJPzzDaZC6OmSWzLtMYxTXDlDtNcMqt3p?=
 =?us-ascii?Q?UpVV8vRev1X4IYO1Pu9Ac4OoGYYNYz/zTLwx66xqOo4Xd1oQcuPwRRzvpsA8?=
 =?us-ascii?Q?6qOWvfXl0DoAL6fjDLG7nHBEH8CTNQgxuqrYy/DBHcIZ64X1wTa4na/Xjp7m?=
 =?us-ascii?Q?TQ86K+IOmn4bNbe67JXRvDUvZIqdNZXvjPGI6Vf61ZXQEpV7/GE1ha1JayGD?=
 =?us-ascii?Q?6JWR3JnNi603icrB+DtSVGvU6oafkb2wK2vGgt9e9r4l9IkLVIfLT1Z7koHJ?=
 =?us-ascii?Q?NrGUqmvCAlukzX07o9ah4l9ykdQny50q3WmIk8iFc5pCstHzw1KXYaULn1UB?=
 =?us-ascii?Q?fRotFMJp+5gRN89oIDng6k0AXvqFKtVHrTNuLpq0UplfOBTwvIBd/fas8KkY?=
 =?us-ascii?Q?WgPfTJE2x5oVahFl1IQrxpRlb0Zf3+hSHaOzkDSpfKy15LHb1QWih0bhStzz?=
 =?us-ascii?Q?GXP7yuKB3qARka+N/I/rzQ8koxb2n8+8HcANq4HsLWfQ6Q8DuWxa7JFOsW1s?=
 =?us-ascii?Q?ZyUr4Hs0nDij+s6rA43wYhUCn3zvE0BNexsnUWJ40YqC/dY5gM/94wWgqYVl?=
 =?us-ascii?Q?fqQs7CzLd8fNcoOgR8733e691EOnoYq7K1VganLWCF4o89eax4EbUYPjrNjp?=
 =?us-ascii?Q?NdUADIc3YwYTz9B58fF4l4yB8X38rZZgkG/N6AGs8Tsf8CZtw0szdG1gSJ1X?=
 =?us-ascii?Q?VP0ypKg+N1YtsVHJebCU9ID3yhi+RJiIMTV/gmE3aD1s+u33WzahvvS1pyR1?=
 =?us-ascii?Q?CYMgzrwg7LH+ggeK0GaklU9/eSzKjVA+r649s3Oou2zEoWL4wOU9ZwIBvbeO?=
 =?us-ascii?Q?MKymf2YNVsfDWgNGyIpwqXIWt8K4FViRWtWIkB3iPC4dMwtHgjTrp5FbblUD?=
 =?us-ascii?Q?WoI2PyC4GmD3ZNhHKUMrVhZ/aTk5kDDVqgj852fefxFHLlz8zsrQ2n3rd9GJ?=
 =?us-ascii?Q?v3d0P++Cr70xycgeXqR9FYHIDjnFDtK6fyohLUWr1eizrcr7lA2dYAXC0uNY?=
 =?us-ascii?Q?tGUoRoiQEV4VFWPkU/nYlx9n9pIVcA/SCssAlxot3pc5RuG1JxSCtTlyp1ql?=
 =?us-ascii?Q?faxEbnb7xaitojoPzlQhGpgNAT34RMFUXKo8RPkL7iCuSXkrt8WG0mzWE8HY?=
 =?us-ascii?Q?Z5h82VS3g5UajYFGq314nlAuEmBbVgt1w/+fjO+a86w2jFDDpeRXs9xLmHxd?=
 =?us-ascii?Q?+uTe3ylQ2XRtQxun0iq3A9bf7gIv9TroO0clFTQpVVH3lPcUIlm2gQ7oe91Y?=
 =?us-ascii?Q?K8vXISmKorAuE1DMdheyow6Xac9R7NQqYhl9UrfjT+i162ctWNkMx9Caj8qC?=
 =?us-ascii?Q?7FA3Z2tIedVmxwgDByuxQ9/dla4VhUkq/8HBjhHAb3QF7kXPkqjQDiF/9lpW?=
 =?us-ascii?Q?Swn6mm3hYqsHsJW5KsZMGhSFpXRTMwZUzFoSc0Kv88ErpHTBbJi/PxYvUe1V?=
 =?us-ascii?Q?/qRtQD7soeGhybYZPkMNVnxmvSJtI9NCM453REZ0WPdquVUsbrIzGWdvC5AP?=
 =?us-ascii?Q?O2uhacLrjYD9016wfCl9oz7br8dpYL/C501eVqGmqD9oM8BoCPMdUZwIrcPv?=
 =?us-ascii?Q?X2PkXQHxs98Zk0rBkbg2lpBPA+aHbRz4/7EYej05Zdx25KQzggAFvc5rRhi3?=
 =?us-ascii?Q?NrKrJNgVCAFfk+a9gLTd2LWG2xg=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b94b9e49-6bb6-48f1-0069-08d9d5f24943
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2022 17:38:03.8190
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Tqzg9ylnFQrqRA1yUIaMckJ0//7HbfqvlEy4invULf9QK8MkZOqz99U9tzNuTllin/w8i+zD6mOl+zdeR11vpmzIl9Ufwf83ty38qclAmH8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YTBPR01MB3424
X-Proofpoint-GUID: nHzxSpE1v2tJ-FYMR-4p9_WYiomheZW0
X-Proofpoint-ORIG-GUID: nHzxSpE1v2tJ-FYMR-4p9_WYiomheZW0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-12_05,2022-01-11_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=690 spamscore=0
 mlxscore=0 adultscore=0 malwarescore=0 bulkscore=0 lowpriorityscore=0
 suspectscore=0 impostorscore=0 priorityscore=1501 phishscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201120107
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Network driver documentation indicates we should be avoiding returning
NETDEV_TX_BUSY from ndo_start_xmit in normal cases, since it requires
the packets to be requeued. Instead the queue should be stopped after
a packet is added to the TX ring when there may not be enough room for an
additional one. Also, when TX ring entries are completed, we should only
wake the queue if we know there is room for another full maximally
fragmented packet.

Print a warning if there is insufficient space at the start of start_xmit,
since this should no longer happen.

Combined with increasing the default TX ring size (in a subsequent
patch), this appears to recover the TX performance lost by previous changes
to actually manage the TX ring state properly.

Fixes: 8a3b7a252dca9 ("drivers/net/ethernet/xilinx: added Xilinx AXI Ethernet driver")
Signed-off-by: Robert Hancock <robert.hancock@calian.com>
---
 .../net/ethernet/xilinx/xilinx_axienet_main.c | 86 ++++++++++---------
 1 file changed, 47 insertions(+), 39 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index c5d214abd4d5..8ac277ef1f99 100644
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
@@ -748,19 +749,14 @@ axienet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
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
+		if (net_ratelimit())
+			netdev_warn(ndev, "TX ring unexpectedly full\n");
+		return NETDEV_TX_BUSY;
 	}
 
 	if (skb->ip_summed == CHECKSUM_PARTIAL) {
@@ -821,6 +817,18 @@ axienet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
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

