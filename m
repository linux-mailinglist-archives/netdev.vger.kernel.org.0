Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C416F4BCA6E
	for <lists+netdev@lfdr.de>; Sat, 19 Feb 2022 20:14:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243095AbiBSTOf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Feb 2022 14:14:35 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236928AbiBSTOe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Feb 2022 14:14:34 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9C953B0;
        Sat, 19 Feb 2022 11:14:14 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21JCZbhS007199;
        Sat, 19 Feb 2022 19:13:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=tKz23U7CLWq5I1MAfqBjhjjjjs+n+wrwgU4RuthXKsY=;
 b=hTsKVM5P/JzSzc6gKhSI4S9IPD3UioOf4UP2t3G6OTaFRBSjpYrLnA7B1W5lL9AQTi/s
 w8gJ6hqPjxcP1Y+mnEDwp9eXC5/pqpJaw4KegD9nBVK4Fh9oW8E6jo1hbp6WeFJ/7O2d
 YSUCIZCnRJ1J6vyIEJ4ng9iK8p+lHYv5sOh/x4uAseMkIfMv74y0OnfQ+/yWyjgX3QHb
 ilBXamrHKt/CvwglxQbOwHl0npufnJzpSPcyh4yI70bqYWc38NVJwWOHwruakRLWhVM5
 orKD7lO/U3589RSvZx7kECTJWE/c3KwHHUMkYwdUaAlzOj+QuJ9jL/xVuchyh6xKsScy Rg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3eas3v0utx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Feb 2022 19:13:09 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21JJCI12025018;
        Sat, 19 Feb 2022 19:13:08 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2042.outbound.protection.outlook.com [104.47.73.42])
        by aserp3020.oracle.com with ESMTP id 3eb47x39mf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Feb 2022 19:13:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TKKfqQJ0lIiune5aciNLwQVE/3AE+E2hX/MBvVWG9glEbk8bMBiNHxNYye+q8b1Z1oanh6vRXdIRr1fZIFRqn5lfI+LybWDvgO8SeogDcs5dYBTchKFcZIYSdL8Lr5vFOMxQqMcLN4nXGKp/uupc6/u11za73G7RpvAVSrTT8IrpXqRv3HMf8sIXl72h1Ds7wYDYlpVWxlwf7fPstxOwKsu1WEpO1DYhidV4BrqjS9GubUaGSalK4WuNTcXrJMqjD/B9fgVicli3HLTR96D/48wicf1VPe5/D1YGilvdBl3S7ajUSww7aN1zh9eJ5cqRAkpv6U5wioJAKL8oDzSYHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tKz23U7CLWq5I1MAfqBjhjjjjs+n+wrwgU4RuthXKsY=;
 b=NvyLq9OYrsog8uKtl6kZ0t6P5xeWw6ABJBVyAx1Zk+kM4+49nB6/IGzTRIn9mpDN6t9xtysmsOmtBPbSiVzNR439M1tmhzVk9qjlpaKXitYlPloi3IQX8EQvkkyD3+J++VMTNNIxoM+aG4tOySVg2leCmzbfLtAoA9rSzQtxhxabct7TjfYRgvz925h7aCNAv/qpA2jH/4r7muhCo1t5buk4oZXa9FFzQYGoYlFdbpCHdTjrjZF6pn51M65zXPs+86zcgK8rAa6HZ3841srNxBBLEtgXWmz4pBnJQywYv07wcOyviecmJBXvQVqIkRZ9KkOzbZS8zUhVvqYWgQDxew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tKz23U7CLWq5I1MAfqBjhjjjjs+n+wrwgU4RuthXKsY=;
 b=vKWt6rkdaV6Y/z1Yh0+f0BdaOYcF+phExPzrzrbQaKvtnfdwgBUFIdPWXTjZ+Oxj9fUSqNkgxUZzszIa5Q2hgkOFQqyiBD9985m0Ggv3+NtV3zX6kV04ZrdnaYB4eWzkLfFoj4A6JYURs0VjD5mqVnmL3C2CI7rPD00sVhese1Y=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by SN6PR10MB2928.namprd10.prod.outlook.com (2603:10b6:805:d2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.22; Sat, 19 Feb
 2022 19:13:07 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a0d5:610d:bcf:9b47]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a0d5:610d:bcf:9b47%4]) with mapi id 15.20.4995.024; Sat, 19 Feb 2022
 19:13:06 +0000
From:   Dongli Zhang <dongli.zhang@oracle.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        rostedt@goodmis.org, mingo@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, imagedong@tencent.com,
        joao.m.martins@oracle.com, joe.jin@oracle.com, dsahern@gmail.com,
        edumazet@google.com
Subject: [PATCH v2 1/3] net: tap: track dropped skb via kfree_skb_reason()
Date:   Sat, 19 Feb 2022 11:12:44 -0800
Message-Id: <20220219191246.4749-2-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220219191246.4749-1-dongli.zhang@oracle.com>
References: <20220219191246.4749-1-dongli.zhang@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: SN7P222CA0017.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:124::15) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 90f38ff0-efcb-4dd5-4ff1-08d9f3dbdc17
X-MS-TrafficTypeDiagnostic: SN6PR10MB2928:EE_
X-Microsoft-Antispam-PRVS: <SN6PR10MB2928390FD74CF79AB67C51A2F0389@SN6PR10MB2928.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ypqO29OAMtahjQZSETAGDELL/+s32BERwhP80he/7+cGTM4A456sTm5QP95nLSo4htUT6o9c4nbGLGEcodjncxIFoxzpvjkpUDgzgOOkqmqM2mWdzuijGb5/018tmNJ2ff4S/IS0b14rOsExAUEoXCIcXw3iIqVD3dI2QrJ68VnUMpDfJxxYwO/oX5jxiLv6Az3skZxGKs7ja0V8y3XdCzK/mCv4WztOHQWfrM/beGBcKRFcROlQpzFhmi9UOWKOJ1tacC2dq5Tp6busWM9qs+t75anGkFtlsFlwU6amH7fxXSm1P3jIeNEGKaMvW/k8rq4zpfk/TdYVExtYPRf1QCBdGRGnZnttlLT5/uwb+6bqUHFFVWTWikAUGmiAJLBTGa2x7M0ZmsJ4Kblen2me7Lnb8kluOLETpHMv2sGRxgshLcsIDZ+uQlAZisTOpkyfv6pwDgsPnw+99XZZ+ozHqv5YNilek9mlzA3CqFQH2F7/tXpJAIERN9BNmL+s5xlu6YSINuwY1qrLoRDqaS5MpG97ekejaxRAccj/0CJQygyI6mcOOAn6u5a5pz1IGERYvwRh3gaCOiHCA2qX+OeQ4QnnAzL5b98uTJ5IaCdOV01wbN9PIMjHZHLqZc8YfNITUImIx2QRE0bHq/5wBgHsfyNzn1GIs/qG0kx0BoQ5h4c06D57AxfCbJSxf7ime2a3P2qXRONwJLB9vwwia4AsRg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(7416002)(5660300002)(8936002)(86362001)(316002)(508600001)(8676002)(4326008)(66946007)(6506007)(66476007)(66556008)(52116002)(6666004)(44832011)(38350700002)(186003)(26005)(38100700002)(2616005)(1076003)(36756003)(83380400001)(6486002)(6512007)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?R2xOl1YSLb6/qEv7AcUu1OedqpIQGfu3ZkptTggcDHWyYMZW9F1prpbKgj/n?=
 =?us-ascii?Q?nAajkddX/OYwXVehBEHNaIyxtuMGArANd58L3O7JCayQ4V4CVyAycwoIbS+o?=
 =?us-ascii?Q?FDmZcX3YA3kkUMxjh77fmoqZj93D8FEQeS2IrGpTSx/9BBglP6mgSAl519Jr?=
 =?us-ascii?Q?6uZZo85UB37cgkU1YwBY2DN/05AfkQYhjmZSaX7ACnodFZoakRhId6jBweHj?=
 =?us-ascii?Q?oZtPhOoszALC+10lzwUwDe09cgWe/q4urPldBvMQa/1LJuu8ZGXel7+eE9DJ?=
 =?us-ascii?Q?wsuBLkSx1CyA0uorr0G76+cQwr7jxe4qIZ3HehJXTF6AKjybb+54gYEshWjN?=
 =?us-ascii?Q?pSeIY3arCfyhBo5RCWF8dlS9Zlz3Xuo2Q7XCmzQcYVQRR2BhS7kdgOGaPpoa?=
 =?us-ascii?Q?yBhreGVxkIvasgui0z9BZudWexV+BgeltruAUO91YWYTCPqjb1tTIo6EgnC3?=
 =?us-ascii?Q?S7/U7BMjbjHqEMlfhwYs+qDpMY/USAxKz3sqZl+y3k8FXqJtmAIaFLIr46KS?=
 =?us-ascii?Q?/la1ffbvmTAZiYrtLtKOeb8iY11VHdGQLU63CwDsHdWmXWL3cA3THo8sh2HD?=
 =?us-ascii?Q?DNYozApAO/JmT+6zsjPwruNjKpKsb5lPf0kf4svEd4XkYzUESyDl3/SoH5b0?=
 =?us-ascii?Q?1NdHZ+waNXJHREOgNy+oPgbxcUVp9Wiku7RBY3H64GxWDuo+gfqX8JPvs/du?=
 =?us-ascii?Q?KPEK9zDSPLzuPTO/2GqbPgRYdWXXrFcwBxbsgqgI88YsSL+alKYbgQLkxvwK?=
 =?us-ascii?Q?OJ9nD15A83Le4iNpWRa1TlQlo16ssTrZxC4BrCfoO4LtIazhNWd6nftJgvzo?=
 =?us-ascii?Q?H7o9wsWtDj/oVKzSSKFbotSOILFgFwPK9+6zJhHARxohSgOuOYcsxBHg4dhZ?=
 =?us-ascii?Q?rMWPbvSCFZDtuB50pFTeTl+qBNzwgQcmdJFrEG/KPU7PpaOIOc1lRh+394e+?=
 =?us-ascii?Q?4SciaNXfMwBxWUQ5N184TtCx1b/tzqsOz/Dygc9YfUVkgAEQtGaktDOj3DlT?=
 =?us-ascii?Q?8oR8wPemvy3eD93SrvQW4oa+Kdmk3J3eQQfCOR36fkMKlnuJYgsZ4Sg0KbQB?=
 =?us-ascii?Q?Xm/gmFOaLigBZjYsTJ97Sqp8zlIfJZMWDLaZP/ipyQ2iKVMQ7QAsBUSOh1By?=
 =?us-ascii?Q?fDdzWBL37JTobs4osrzzc7UnEQSWC2077LiYYUWcZICPPHVUQfllUdPbRXJe?=
 =?us-ascii?Q?viVNNTAaHaXqTR4vrAlLig2lAEWxwHXUzy/TuT0myNOAiR7Znq4KgTLBRG4M?=
 =?us-ascii?Q?WuCn4usq7lrHEFY2WQa74FKLBBgy5GrSoNW/UZpm4WWnaMe3H6nLV5M2qoLT?=
 =?us-ascii?Q?2bdQvElHURwxn8GQ5K+2knrW0jJZE/r3agAAQgjr6GDiSEVR+iiKI34DPXTW?=
 =?us-ascii?Q?wTQZYp5bAl1SZ9mAS/OGZIN40yfpJNkeuRzFeZHQ2QdK3Kn9xxDcNAvYyQmr?=
 =?us-ascii?Q?lezy0YpdSuQ9xSh4zqktTt3wOQx3mV9JJiOc9MR3WG4R3S2mEWHJGyvDexpX?=
 =?us-ascii?Q?dhuREH3hnLB16kZ31St41QO5o3BXZtYWtS90nsbxnMGa0/+x0W8EPo9mNc9S?=
 =?us-ascii?Q?fUzX2L+8bPIXjOiBJXLSTSCXjTwZbXZ0mwrMGLe14vcuXtNpTaAQHEuoPCRy?=
 =?us-ascii?Q?2dYHKg+ZXuSgoiW9BUduwLA=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90f38ff0-efcb-4dd5-4ff1-08d9f3dbdc17
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2022 19:13:06.7413
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I6xqkaN3T6XOJU/ffgXd11plZwL15A82AbBOvg5P1qFY697H03INmQkEZ3E1pzN5/86vqMcyFtguEusHuXpxSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2928
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10263 signatures=677614
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 phishscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202190125
X-Proofpoint-GUID: 3d_n8Arj0eLz5Q7HxP8Hnu7e6wE76FNI
X-Proofpoint-ORIG-GUID: 3d_n8Arj0eLz5Q7HxP8Hnu7e6wE76FNI
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The TAP can be used as vhost-net backend. E.g., the tap_handle_frame() is
the interface to forward the skb from TAP to vhost-net/virtio-net.

However, there are many "goto drop" in the TAP driver. Therefore, the
kfree_skb_reason() is involved at each "goto drop" to help userspace
ftrace/ebpf to track the reason for the loss of packets.

The below reasons are introduced:

- SKB_DROP_REASON_SKB_CSUM
- SKB_DROP_REASON_SKB_COPY_DATA
- SKB_DROP_REASON_SKB_GSO_SEG
- SKB_DROP_REASON_DEV_HDR
- SKB_DROP_REASON_FULL_RING

Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Joe Jin <joe.jin@oracle.com>
Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
---
 drivers/net/tap.c          | 30 ++++++++++++++++++++++--------
 include/linux/skbuff.h     |  9 +++++++++
 include/trace/events/skb.h |  5 +++++
 3 files changed, 36 insertions(+), 8 deletions(-)

diff --git a/drivers/net/tap.c b/drivers/net/tap.c
index 8e3a28ba6b28..ab3592506ef8 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -322,6 +322,7 @@ rx_handler_result_t tap_handle_frame(struct sk_buff **pskb)
 	struct tap_dev *tap;
 	struct tap_queue *q;
 	netdev_features_t features = TAP_FEATURES;
+	int drop_reason;
 
 	tap = tap_dev_get_rcu(dev);
 	if (!tap)
@@ -343,12 +344,16 @@ rx_handler_result_t tap_handle_frame(struct sk_buff **pskb)
 		struct sk_buff *segs = __skb_gso_segment(skb, features, false);
 		struct sk_buff *next;
 
-		if (IS_ERR(segs))
+		if (IS_ERR(segs)) {
+			drop_reason = SKB_DROP_REASON_SKB_GSO_SEG;
 			goto drop;
+		}
 
 		if (!segs) {
-			if (ptr_ring_produce(&q->ring, skb))
+			if (ptr_ring_produce(&q->ring, skb)) {
+				drop_reason = SKB_DROP_REASON_FULL_RING;
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
+			drop_reason = SKB_DROP_REASON_SKB_CSUM;
 			goto drop;
-		if (ptr_ring_produce(&q->ring, skb))
+		}
+		if (ptr_ring_produce(&q->ring, skb)) {
+			drop_reason = SKB_DROP_REASON_FULL_RING;
 			goto drop;
+		}
 	}
 
 wake_up:
@@ -383,7 +392,7 @@ rx_handler_result_t tap_handle_frame(struct sk_buff **pskb)
 	/* Count errors/drops only here, thus don't care about args. */
 	if (tap->count_rx_dropped)
 		tap->count_rx_dropped(tap);
-	kfree_skb(skb);
+	kfree_skb_reason(skb, drop_reason);
 	return RX_HANDLER_CONSUMED;
 }
 EXPORT_SYMBOL_GPL(tap_handle_frame);
@@ -632,6 +641,7 @@ static ssize_t tap_get_user(struct tap_queue *q, void *msg_control,
 	int depth;
 	bool zerocopy = false;
 	size_t linear;
+	int drop_reason;
 
 	if (q->flags & IFF_VNET_HDR) {
 		vnet_hdr_len = READ_ONCE(q->vnet_hdr_sz);
@@ -696,8 +706,10 @@ static ssize_t tap_get_user(struct tap_queue *q, void *msg_control,
 	else
 		err = skb_copy_datagram_from_iter(skb, 0, from, len);
 
-	if (err)
+	if (err) {
+		drop_reason = SKB_DROP_REASON_SKB_COPY_DATA;
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
+			drop_reason = SKB_DROP_REASON_DEV_HDR;
 			goto err_kfree;
+		}
 	}
 
 	skb_probe_transport_header(skb);
@@ -738,7 +752,7 @@ static ssize_t tap_get_user(struct tap_queue *q, void *msg_control,
 	return total_len;
 
 err_kfree:
-	kfree_skb(skb);
+	kfree_skb_reason(skb, drop_reason);
 
 err:
 	rcu_read_lock();
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index a5adbf6b51e8..218f7ba753e7 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -346,6 +346,15 @@ enum skb_drop_reason {
 					 * udp packet drop out of
 					 * udp_memory_allocated.
 					 */
+	SKB_DROP_REASON_SKB_CSUM,	/* sk_buff checksum error */
+	SKB_DROP_REASON_SKB_COPY_DATA,	/* failed to copy data from or to
+					 * sk_buff
+					 */
+	SKB_DROP_REASON_SKB_GSO_SEG,	/* gso segmentation error */
+	SKB_DROP_REASON_DEV_HDR,	/* there is something wrong with
+					 * device driver specific header
+					 */
+	SKB_DROP_REASON_FULL_RING,	/* ring buffer is full */
 	SKB_DROP_REASON_MAX,
 };
 
diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
index cfcfd26399f7..842020d532f2 100644
--- a/include/trace/events/skb.h
+++ b/include/trace/events/skb.h
@@ -27,6 +27,11 @@
 	EM(SKB_DROP_REASON_IP_NOPROTO, IP_NOPROTO)		\
 	EM(SKB_DROP_REASON_SOCKET_RCVBUFF, SOCKET_RCVBUFF)	\
 	EM(SKB_DROP_REASON_PROTO_MEM, PROTO_MEM)		\
+	EM(SKB_DROP_REASON_SKB_CSUM, SKB_CSUM)			\
+	EM(SKB_DROP_REASON_SKB_COPY_DATA, SKB_COPY_DATA)	\
+	EM(SKB_DROP_REASON_SKB_GSO_SEG, SKB_GSO_SEG)		\
+	EM(SKB_DROP_REASON_DEV_HDR, DEV_HDR)			\
+	EM(SKB_DROP_REASON_FULL_RING, FULL_RING)		\
 	EMe(SKB_DROP_REASON_MAX, MAX)
 
 #undef EM
-- 
2.17.1

