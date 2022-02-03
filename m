Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0A3C4A87D2
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 16:38:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351936AbiBCPiv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 10:38:51 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:49842 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1351912AbiBCPir (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 10:38:47 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 213F9VeW032744;
        Thu, 3 Feb 2022 15:37:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=fiMSUoEZKmsk6sl6lfuYto6lgx6LX6oCOGuF6I/Lf78=;
 b=XOtLqO8+R68pmxgqBkCjcxQnWHydTFmt9Jx2zTiruFj+aBY/rcXYTd/PQbr84DzjO8ad
 JcS6q1d1mlhsgGgyGC7X3cbyDo6ubQjWFk0fJISyFbr1/A/SHBjWkhnwgZ/0SgPp/bhW
 zHuL7RgGNnNg9/CEvgdPs5p5f6aBKLUumDs3mtcHyvsoYQAOkqyb/D9BSEqa8v8pfrj4
 98A9l1MJ6e1R6BS5RVfxB9GWTBK5Y9hJoMj5PE1m41oYZyu6yczML8m20oVA6YHwa9hY
 3enj6G1NHPymDHlsAVPu/vD7rQWaW61gjofZ2i/QtjInUgZNzYLj6y8t5uoNvwGMS/RW dA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e0het835f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Feb 2022 15:37:48 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 213FVIM2184560;
        Thu, 3 Feb 2022 15:37:47 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2045.outbound.protection.outlook.com [104.47.57.45])
        by aserp3020.oracle.com with ESMTP id 3dvwdaj9de-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Feb 2022 15:37:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iSdcdUlihkHNjZLleKt8eVefHcX447VgjoDy+norsG/Iahf9dxZNcA/nnt+jaKOmSUlW4RG+GOgjgUAvlemVfhU+rct+vIvArPbbJneFo+aqptzBpBjwVdKzSg1u9T6EgG+c9dBJbAarFCTPe/H+ceAfIMyVUTtG4vWBckZxqyyKvbPMnnYajUe073vt4ObUtk5HcdFZHmsEoaZGt6iq5qj/dGfzkMSc5WQBK6xpPC9bAhdb1t5ghd5L7Pub6fRMcoZa6on7yO1WANu0xKXiglDbq4OcTYmceYOMDgeNeb1DtO6VzcenKUMprlO64e4D8Sa48VfPeDh4PMwDqCjSpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fiMSUoEZKmsk6sl6lfuYto6lgx6LX6oCOGuF6I/Lf78=;
 b=hC4kydUnQkeIbK83AjjnGqIgtCxwjw1WQFu+IZ6g7f6ZtWewGYNV1k1rhNev3HUSGjg4IoaaFTSVsQxHykt5NhDWK3pea+GTxeRLvyFwCFDHi6jjryfFPwW00XgZNTi7ktMW1S5ScHorz/QqU+dPwYt7dU46Y3O0aBGH6Mrv3iHxTQ9ZdE/F64TDRNzGnOjIIaar0y99RjvoEOUhUWufMWcH9jxfDexLQKTlNCWaU8n6tAeoUlgjgk6kwBEwXNc/u2pFYOW605+2yx3/YFHo3xlNLaCnjsKkqNzryxFLIsbcCisv2iOlegv0Uug2CHkxpPf+9xp/MOt/6pLcj7hNxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fiMSUoEZKmsk6sl6lfuYto6lgx6LX6oCOGuF6I/Lf78=;
 b=CniI9vkPATFD+Yl8Da7KcDo1qVuodwtZXI4OmWDDXZ8yJNmjIFav4qTRr5/Hev/KaZcq7Y160Oa3VJZmK5n7TdadegiJKzgH0TgKm2NM631K/Cprsy5jC5fOg2yE3LQdrqU0ZqtHIgnyORZbyJ14Nd5s0gQ6RI+O5ZwzTJvqdP8=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by BN7PR10MB2436.namprd10.prod.outlook.com (2603:10b6:406:c3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.11; Thu, 3 Feb
 2022 15:37:45 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::60be:11d2:239:dcef]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::60be:11d2:239:dcef%7]) with mapi id 15.20.4930.021; Thu, 3 Feb 2022
 15:37:45 +0000
From:   Dongli Zhang <dongli.zhang@oracle.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, rostedt@goodmis.org,
        mingo@redhat.com, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        imagedong@tencent.com, joao.m.martins@oracle.com,
        joe.jin@oracle.com
Subject: [PATCH RFC 4/4] net: tap: track dropped skb via kfree_skb_reason()
Date:   Thu,  3 Feb 2022 07:37:31 -0800
Message-Id: <20220203153731.8992-5-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220203153731.8992-1-dongli.zhang@oracle.com>
References: <20220203153731.8992-1-dongli.zhang@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: BY5PR03CA0017.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::27) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f89b20b2-440d-450b-0ab8-08d9e72b1f5f
X-MS-TrafficTypeDiagnostic: BN7PR10MB2436:EE_
X-Microsoft-Antispam-PRVS: <BN7PR10MB24368B0574B2C72CDD03E412F0289@BN7PR10MB2436.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aBQyXhklxMrz1ISvXM8aADRSmlvmTYXfjpmmcdME8bzzfeVBYmAEensN95zx9t1/1T2S6jUF1NMq69CB55OsKmiiGk126QWhtMn9Rf2pLW30DNvIPobKydtGZDdgpSjYbaiBgkYcUKLMO0mA89tRjYwqrxgai0rqDsKVJ7z1f8wDmxXFmxHZpy5G82zZtlJ1FSE4rfDkdka8F29O1wzLfgq7WeF05xgwi+1eI6E4aKuE55XoGrRgJ2cZNM2ILBQ4hLYuWyo+scnng60GU55U65pQpV1SPKza6eNkRQPscfcVS1AD8yGt+yGda2uSEtOWufJQ16O4bz5tPVgqdS+OaFpylImdgnvfDbEWlZd7NWMWAJ7nLr6HFKEr2SBOtgBpHoO8E6PRUBra5yl1yKx80MJ2rBzZ8pt5MX5haIsfMpp2YLkdrtne1X+hT7rpDk6z38CHT3wzyF4WOf++FBoiaO6fyr/an9emVfPtQdZr3hFbZsc/64SoH9jk5Z/k6xxnNRcFtDiuPg7iw3RjEqEppyRjNrxRVSAegEN+CkTFmi1rR95ZUs4CUEaBg8uMekIVKm9tp6eeoyR9d+1bOaH8CZcT6w/PRKXv1vXw8+O0zlNQOXxrCbDD1+QV5k5qaNtB7TVflG9QsXRbcu5gVdxkJKIsKspsdozuWu3kwGlx9n7TR08bpq+KnPwLavR5ndePWdmtU1Zu/sAbrN9weCkWgg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(44832011)(66476007)(52116002)(6512007)(107886003)(7416002)(2906002)(8936002)(66946007)(6506007)(2616005)(66556008)(4326008)(86362001)(6666004)(508600001)(5660300002)(8676002)(186003)(26005)(6486002)(83380400001)(38100700002)(38350700002)(36756003)(316002)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kuwVQnooQwYolJl4gx4Jbzab74crPWxuYixVnI4aSDxCwusuT1rKgFHdlpub?=
 =?us-ascii?Q?6aMWSslv9sdbC7XUf+rWY0oV4vYNk3poTaz4wJtCjuytuCAnlWRypErlEZdG?=
 =?us-ascii?Q?ixAHED2pnnOL//JuM3cpdGTFsrI6KwxDyQ7RKkMkQFM0OWWqa4sPCkw3oCpy?=
 =?us-ascii?Q?3tneO06uALahg7plZt04ZwqtXItbtgwTQwzu5w49gwuW3QX+mqga/haWbBQK?=
 =?us-ascii?Q?hUT5LPv5WsvGh9D5HPFAtJaix9QlRDRmqvzEjGtRqVX4mFOdxCSs/eU9bdKW?=
 =?us-ascii?Q?pOZ54ZHDmdDus0eSqmn7Vh93KxJRprxRKataI0g19xZ4984T4qgCaJ+eqaQX?=
 =?us-ascii?Q?lRxjzkndKhviRL81gnQL86tb3yzvV2vx9eD/V5lDx3EvM4wgiDM93Ykyov/Y?=
 =?us-ascii?Q?Jk0KOwVScz1v5RsEb6Rr13Dy+geqVMzMUNKYYsT1UH6oX+1AePHcN1r/+sEi?=
 =?us-ascii?Q?cg61RMPYPJ9vs2NFYmxRKg+waE9BtCdUZBoUWWIoIzp7dwXxJIQi0xrMr8xA?=
 =?us-ascii?Q?a9DpUcTvVFTiNvNt84WSfIOksAOw/zdMDxYPYFmxpEoc8mApODgD/0Niu70Y?=
 =?us-ascii?Q?/N3lb/pWybEPMzfuy3C3j754BsPA++WSTijzJVsK6zt2vuBzWndd79o0tYvE?=
 =?us-ascii?Q?O5GgGqyJOw1Rbwnd0amDHCRB+/77QHpoiQ5Ax2sjQhbGe7XiuXaskGiu3Vd3?=
 =?us-ascii?Q?iOF7dhkLAPFQefvMXFzBGMLjBe77zvZ4wDTKvQbmhZErm2869Hm4FCYIY7Lo?=
 =?us-ascii?Q?RxusC8FJUxtVN/rt+xrwUSCng680dqPgya3rmkZSn6KIz4C33E9fgmikxK68?=
 =?us-ascii?Q?s7W9/iVSxY6gmhFMr8VcWnIrQ+FBKV2wEFNP9Op7+4FbwoQU30y7EFsj874r?=
 =?us-ascii?Q?Zqm4stgN5FtIriAtRT0JMdGF8MsO7ZhIPaPLH2I6FFdCO/5Euv5sUbmvKzBm?=
 =?us-ascii?Q?p4ILqaLVKi6DzsXb2ajbdlG3F+8DPGgD6G+M1xw/83Njy4U/NHil4WzvKUga?=
 =?us-ascii?Q?qsBSGGCfy7VytH3FCZAugBBQUOHxSK6tMa7hxap+mHwbPX5N7kXbpGt7xbmJ?=
 =?us-ascii?Q?qFlmIovAXwPaan3xssRMyySu+JyYCvrz7ZST2eT3RBdb9Eop/QclxZISNzFm?=
 =?us-ascii?Q?cih+AVRacHED858bwHWyINXTG8ZjahoGJ2Qm8qFn7h+No3RWjPgKbtWrDG3y?=
 =?us-ascii?Q?QeSTrPgqrXqKaMcVaAuQ/knqCckJ+Nd0AnWLCTQ+0QV8/pVaxJB5448e/f7u?=
 =?us-ascii?Q?Gcbc9bCvw3TmI9pP7n7a5UhFIUMlVm8lr3nGBLjfSMtD7+3b40N3d89oMK6p?=
 =?us-ascii?Q?cUQzkWmuVBq7VDcZRSoWXIx/L9SGN6p18W6Vc9Ewcylt+3mqS/kXb/frwZ/Y?=
 =?us-ascii?Q?X1Ww3xlt/a6J+yvFALGO0KQIYbs5E1H2kdL1gTPdBNB3X7yB8/GzJGeW9zwu?=
 =?us-ascii?Q?mLE+MwbWrrpbP7TYkX8VOwYRNOMun4pVyGc5srOgAR97lHxN0iQB/G4uSut6?=
 =?us-ascii?Q?U3S0CSrapmb1xZJCBuN9yPzOlVPqCRtGYgggdazGPZqNxeAOGwz96ohK7CLK?=
 =?us-ascii?Q?9VyVrIcrlRp19sNwpx/BWAFwGfP7OiJgXo2V27tCb39QZ+fTnK4kmLQPKMNo?=
 =?us-ascii?Q?UrnczmhVyRYGG46dZBhbpns=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f89b20b2-440d-450b-0ab8-08d9e72b1f5f
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2022 15:37:44.7130
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QwmVP447cr5j5nCVNlZ39zZJK6nef5DTfvLGRxYqKBtDiELM4XpH1S6xxq/DT8cd9ZXcaYeUhG1AalYeZrL02w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR10MB2436
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10247 signatures=673430
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 malwarescore=0 bulkscore=0 mlxscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202030096
X-Proofpoint-ORIG-GUID: LRor1LffhsW_LdCVKx6g8dGwFhKy4Fv1
X-Proofpoint-GUID: LRor1LffhsW_LdCVKx6g8dGwFhKy4Fv1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The TAP can be used as vhost-net backend. E.g., the tap_handle_frame() is
the interface to forward the skb from TAP to vhost-net/virtio-net.

However, there are many "goto drop" in the TAP driver. Therefore, the
kfree_skb_reason() is involved at each "goto drop" to help userspace
ftrace/ebpf to track the reason for the loss of packets.

Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Joe Jin <joe.jin@oracle.com>
Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
---
 drivers/net/tap.c | 30 ++++++++++++++++++++++--------
 1 file changed, 22 insertions(+), 8 deletions(-)

diff --git a/drivers/net/tap.c b/drivers/net/tap.c
index 8e3a28ba6b28..78828dd1b74b 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -322,6 +322,7 @@ rx_handler_result_t tap_handle_frame(struct sk_buff **pskb)
 	struct tap_dev *tap;
 	struct tap_queue *q;
 	netdev_features_t features = TAP_FEATURES;
+	unsigned int drop_line = SKB_DROP_LINE_NONE;
 
 	tap = tap_dev_get_rcu(dev);
 	if (!tap)
@@ -343,12 +344,16 @@ rx_handler_result_t tap_handle_frame(struct sk_buff **pskb)
 		struct sk_buff *segs = __skb_gso_segment(skb, features, false);
 		struct sk_buff *next;
 
-		if (IS_ERR(segs))
+		if (IS_ERR(segs)) {
+			drop_line = SKB_DROP_LINE;
 			goto drop;
+		}
 
 		if (!segs) {
-			if (ptr_ring_produce(&q->ring, skb))
+			if (ptr_ring_produce(&q->ring, skb)) {
+				drop_line = SKB_DROP_LINE;
 				goto drop;
+			}
 			goto wake_up;
 		}
 
@@ -369,10 +374,14 @@ rx_handler_result_t tap_handle_frame(struct sk_buff **pskb)
 		 */
 		if (skb->ip_summed == CHECKSUM_PARTIAL &&
 		    !(features & NETIF_F_CSUM_MASK) &&
-		    skb_checksum_help(skb))
+		    skb_checksum_help(skb)) {
+			drop_line = SKB_DROP_LINE;
 			goto drop;
-		if (ptr_ring_produce(&q->ring, skb))
+		}
+		if (ptr_ring_produce(&q->ring, skb)) {
+			drop_line = SKB_DROP_LINE;
 			goto drop;
+		}
 	}
 
 wake_up:
@@ -383,7 +392,7 @@ rx_handler_result_t tap_handle_frame(struct sk_buff **pskb)
 	/* Count errors/drops only here, thus don't care about args. */
 	if (tap->count_rx_dropped)
 		tap->count_rx_dropped(tap);
-	kfree_skb(skb);
+	kfree_skb_reason(skb, SKB_DROP_FUNC, drop_line);
 	return RX_HANDLER_CONSUMED;
 }
 EXPORT_SYMBOL_GPL(tap_handle_frame);
@@ -632,6 +641,7 @@ static ssize_t tap_get_user(struct tap_queue *q, void *msg_control,
 	int depth;
 	bool zerocopy = false;
 	size_t linear;
+	unsigned int drop_line = SKB_DROP_LINE_NONE;
 
 	if (q->flags & IFF_VNET_HDR) {
 		vnet_hdr_len = READ_ONCE(q->vnet_hdr_sz);
@@ -696,8 +706,10 @@ static ssize_t tap_get_user(struct tap_queue *q, void *msg_control,
 	else
 		err = skb_copy_datagram_from_iter(skb, 0, from, len);
 
-	if (err)
+	if (err) {
+		drop_line = SKB_DROP_LINE;
 		goto err_kfree;
+	}
 
 	skb_set_network_header(skb, ETH_HLEN);
 	skb_reset_mac_header(skb);
@@ -706,8 +718,10 @@ static ssize_t tap_get_user(struct tap_queue *q, void *msg_control,
 	if (vnet_hdr_len) {
 		err = virtio_net_hdr_to_skb(skb, &vnet_hdr,
 					    tap_is_little_endian(q));
-		if (err)
+		if (err) {
+			drop_line = SKB_DROP_LINE;
 			goto err_kfree;
+		}
 	}
 
 	skb_probe_transport_header(skb);
@@ -738,7 +752,7 @@ static ssize_t tap_get_user(struct tap_queue *q, void *msg_control,
 	return total_len;
 
 err_kfree:
-	kfree_skb(skb);
+	kfree_skb_reason(skb, SKB_DROP_FUNC, drop_line);
 
 err:
 	rcu_read_lock();
-- 
2.17.1

