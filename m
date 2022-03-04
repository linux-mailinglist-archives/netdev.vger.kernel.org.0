Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFB404CCDD5
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 07:34:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236635AbiCDGfP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 01:35:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236206AbiCDGfN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 01:35:13 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08E258F637;
        Thu,  3 Mar 2022 22:34:26 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2240ePKp028305;
        Fri, 4 Mar 2022 06:33:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=2DWjt5HPOE/iGb2pLyFQOVu7deB+DUCKw27oSHEgmmE=;
 b=W9BihdJCXARuEoKbUjoqI4j1I2FZkTh6i8YVMAdg5DOQHu3whF97Hncc5ANV5FXsvshI
 Pi9ZfNFqZQofV4CZfBGVt7RVSxe0NWD1tgwFRE5t6J+ibyZJWopi+Oho/sWlxgDsHm9n
 MZfXvC46Ux/mOo5MKsIBsrpTXNzMZDgfi5f6gvTInc+KnE/UwAowbVtmGI8VvuNY5NQM
 KYujCsn9aTboN9d/NpjiNLuKrjTBDDEn1clgHV0ghHeVemBVXsTyHKzZrL6g6ssQEA4S
 +luMqrZXEqPPER4cjfuqll9hXGq2TGb7VslfXSFvydOfK/H2wiRgdhF22o6R+t0pykMH oA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ek4hw0xg6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Mar 2022 06:33:25 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2246Vef1004202;
        Fri, 4 Mar 2022 06:33:24 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
        by aserp3030.oracle.com with ESMTP id 3ek4jge39t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Mar 2022 06:33:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nuU79s3pmGIo6JdejGeY0STgK8kW9ZIacUzSZenb7trUvce+/bo7qzEjOQyVV37XsADH5HfjX0E52sp4e0tEtWBReyCykT3ImdyvrqEjwAAicKQf1FVBNGPxEk3zAkcc+OSOek2GUzpOF2rT4fENXsGCAE2WXmp6tVlmZl07Q65E8X1u6JGBVwujP/dzD7o8wtXDpDgV85RzQHOoV1TZNxRAIghP7Mpad+oenaWWjH+WZn2mYDzx6d29lU52MkydA97bPHr/7lK6JqnTZ+Wmhuw28wLXTLcG6T+MVVaaJcdjkfABwHAeFUPOjyNuy7FSznfA43ipGvdow3cEXXpjxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2DWjt5HPOE/iGb2pLyFQOVu7deB+DUCKw27oSHEgmmE=;
 b=OMPynYidZJxXBNDm4V6RP2PcUN20cu5WXIks0Hr9TzsQcS2wjAXBYwZkJf+ckAe8VxKibq0VfC91efa+cTT2uJ16OyaLX7x749941PqgSF11r6+RRwZfzYkvciY0DYm6zzRSw8pkPtLtBYxweJS1Mno7mez0POtsXEXgGAKeKkkG2w+y2EqSl6bKtUcL30fUzZiEbg+WPiOUiREwfLuF/wuYYD1CUVOHBS3Q0LzraWkBjY/4ZFCMTcgBjqqpZI/NMV07msF4pqBMvs8J13qlX/wNvPU7gJrEfK87apHJDYp9RevJ3od97eBdUcJAhKumqHIS7bN4IRBkNK/Xsjae+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2DWjt5HPOE/iGb2pLyFQOVu7deB+DUCKw27oSHEgmmE=;
 b=H77DVXKUpBYU+jeuX2M+mrTJulXx5GX+3YE0i0pzjDlydY2FXL0Az5HBF4XNN6EjS2SZqNWs2FAZlnRuafD0xy8/VgJBBG3+8FwYedFgqRkXj1NVEK4tbyHRQqQW65soguPwP5NGdfIEYi+KpCrH/1SV/m+IBFiEgpBNqdWto7k=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by SA2PR10MB4603.namprd10.prod.outlook.com (2603:10b6:806:119::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.24; Fri, 4 Mar
 2022 06:33:22 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a0d5:610d:bcf:9b47]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a0d5:610d:bcf:9b47%4]) with mapi id 15.20.5038.017; Fri, 4 Mar 2022
 06:33:22 +0000
From:   Dongli Zhang <dongli.zhang@oracle.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        rostedt@goodmis.org, mingo@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, imagedong@tencent.com,
        joao.m.martins@oracle.com, joe.jin@oracle.com, dsahern@gmail.com,
        edumazet@google.com
Subject: [PATCH net-next v5 2/4] net: tap: track dropped skb via kfree_skb_reason()
Date:   Thu,  3 Mar 2022 22:33:05 -0800
Message-Id: <20220304063307.1388-3-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220304063307.1388-1-dongli.zhang@oracle.com>
References: <20220304063307.1388-1-dongli.zhang@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: DM6PR01CA0018.prod.exchangelabs.com (2603:10b6:5:296::23)
 To BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1d84bde0-36c7-4abc-bf98-08d9fda8e10c
X-MS-TrafficTypeDiagnostic: SA2PR10MB4603:EE_
X-Microsoft-Antispam-PRVS: <SA2PR10MB460309700002F3DB7B00F7ECF0059@SA2PR10MB4603.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a3vT/YiZIgXafMvxA3dtDf0r0Hp9bloUVnDxlHcUOt2v7Vi23h2zLJNFLWMpR/MJOPhreUxdFtO1jnhlIA/3GMwbtZWUc3rZ9wk7cFBWeubyiXzmmbkYmmCSGARsBZOWZP01G8yMqYg8VbyqLR3EmCBqQoxCb+eLnHyunCRsSi2vywIJAcIvhjAzEt+xulCRBdYI9Sob1I3/DXDoVDS4hIF3ELYwJKpf7SOfwBcWzFqcIxOtoalar8hugjq83oWdFimE0zSnkCFXmdV6BUe4nGIEVf92loEh56jyzNv6lCysFKzBuEgbSPlrNh5CnHVLtfSv3G4ZWeijY6s55undWqfN4LRaOJUcwFSJl0e5THbAjBg0+xq701WjMQ3JehTT4XBanN3T6orclrG9eNayFv4/yube9M3l5fGL0TgzdI8a5nMqnTF9cAG3KUkgBmzS7GHTOwN2o31BKdlaEANSz+0bEq2B9nT7df4XKiA/p4RoT+i/G2nTFFU4zJMaC4eYYrgxCqqmToxWXZA2SQq3oMc5R1MlP7gs0Pu+v6H1aIfB7FnytGsPrN+GEnNhb5/TFVU5QmWdLw0n0ey2bnq7pX8zAaBNNN8fU+MFD9tcdrHBBcFJU5SCBYPcDCXE28yEK7mqxoyRzbouPEEee17sTiG+tpbQKvG4Wg6BcBFHUstt4Y4bGyUikilYlCuIMFEGecPV/bQ/QAqtcLGHx/okKA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(4326008)(8676002)(66946007)(66476007)(66556008)(1076003)(5660300002)(8936002)(7416002)(52116002)(6506007)(6512007)(508600001)(83380400001)(6486002)(86362001)(6666004)(2906002)(38350700002)(38100700002)(26005)(186003)(36756003)(2616005)(44832011)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wvgoLWuePYptnIroTFXjMs2trM7wheiEFVFOq57XWq+RUM6gs+p6BC3NOsCb?=
 =?us-ascii?Q?oZUgjlYwM5Ft96eSfG6Ozg69GpiUJ+cW7sGKx5y1VB/QC+lwdpIFHxP14Kdm?=
 =?us-ascii?Q?VSYZjWstTCnfTsgXIQXhIm1vW/tdb0ymqblmdKn+nDIi2EI3ai44HwaGoANE?=
 =?us-ascii?Q?6MC6oUgYjskekFCD2PRuDBmP+vzA1iUzJHOwmu1D7FbQseXV5kMT03n0NneM?=
 =?us-ascii?Q?xTLl9HGUW6BTzn4jkpzxsiy6TWqrtkG//4dTRqr3MXzYbe+T30Q8SgjGyslo?=
 =?us-ascii?Q?IbEj9Eg2pJ9vi1i0m+ouvl+K0nsL3NPWm9wd6jPsoYjaxVbqy4IORoA+CyNp?=
 =?us-ascii?Q?e2vJx1q+dvFunuFmK09AFNd1a24fhvn8dXGBrHBMRMMnfBreWUb4CO8jqjAp?=
 =?us-ascii?Q?VfHITecOSkU+u2gw0qHX4ygjs2oHADD/27ytse6xy9XuKS9ehwimTteZA1iq?=
 =?us-ascii?Q?o/HSu8SJ90XrY8jqm/eXC3a4pv9wdJr/E72ZSVnnZ/26o0h7RMrmPbtEqtz1?=
 =?us-ascii?Q?bgzrcBLVYfvODXL2DJUbw7lZKwNwrYq6+KleZZLE/kBcQo3uI4VkGbxJjIy4?=
 =?us-ascii?Q?sEursTfiLYfl5dMHZSggYFvPmDYTx4fv9REwZrvih04lpg+pWh9kLWa2uQUH?=
 =?us-ascii?Q?UzeFzR+ECpwzikwTcuKwEZh/R7FyK9bNp5wbHag6Q/4pZ7RQSmQTIg1F74Em?=
 =?us-ascii?Q?6ryhJovZUyjwxSvgz2DEM4lLif8RUgor02n9OpGx0Hi25j97KLNnzp+wagn+?=
 =?us-ascii?Q?ueE+ripxVn0MWirhcEeMFt7hYSQ/Wgr95XDwlI0nB+HTe6XA8C4v56UJt4Eu?=
 =?us-ascii?Q?lsSoy0Knji8Swk8hxlNXs9AsOlIQcU1V00nu3a3VKDrOEzDXvuSkLPHcz5fS?=
 =?us-ascii?Q?HhR+FpUCNCRWkMBN0flSgLa4ZpvhiM3tCbbQDJvOuI60qzVrkMTct/ZYyH+h?=
 =?us-ascii?Q?G/NTK7Ze7XjzlnwvZP82IdOx3tjCy1wJqwNRGd5MkkiN5+Oy1pGV+cHLXVda?=
 =?us-ascii?Q?P+lYjkCq9a0OU//+oxkxipvn2MvITRgRpNjbd2oRTag9nrJKhIq3lW1yQgxU?=
 =?us-ascii?Q?ox7Xd05noNkqJft3u1PZN+dtuT+Bb1lbL1QUBjYdJDyHpH31gpxp0dU4hx28?=
 =?us-ascii?Q?SvQM04ruyFW3NsxVOuzvk6KgutF1I8ce6VTpAk8mLj//ppMxSINoxXyX8Ugx?=
 =?us-ascii?Q?8o+5FPZ37hEStlJuqA4W+8CirhJdLV3l+OCQcrngcB45TLFpI0WoMse74lnX?=
 =?us-ascii?Q?DOiW4pLR+c3Z6y4Gs9jesq3b7dGoZLUNoBY97eme2mC5d9t9t3yuo7JO7Dhn?=
 =?us-ascii?Q?LgPYdJ0FweULD1qf4rV3V7e3XhPrOlxnDXDI3fB2Jloy26IJXouu58kXSCRu?=
 =?us-ascii?Q?GEycvMzRpBJdRN+3fSw2dWV+k3GZQ6dOI8r6Nc0XS82iPRsvOa5V287pRM3s?=
 =?us-ascii?Q?w92Yl8irmFvgCnr3pRtDNbFCCD83fa4UOF6uQXraPyy1psDpcVBU0YHyn/7S?=
 =?us-ascii?Q?wDPVCvA2DFpc74x44yHIkt89l5+BqNBwWbLEV4bEzDg8p3KNRQUR1Vtb+l/I?=
 =?us-ascii?Q?KJfjU8hHik1ws5ERXeM291zezvqMW6BiD53Bz2JYDEKwC43R30jab2zOxySt?=
 =?us-ascii?Q?pAIW/rxLptOSWwt1omwtTbY=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d84bde0-36c7-4abc-bf98-08d9fda8e10c
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2022 06:33:22.3240
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ff4q/TRW/jX5lwgvXvx+jzfIG82APFiAsIHYOrzk4g7Mq2XXld8c5lcj2xou5kcsJdxlxC91WP6kzpj/iGbLbw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4603
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10275 signatures=686983
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0 mlxscore=0
 malwarescore=0 bulkscore=0 suspectscore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203040031
X-Proofpoint-ORIG-GUID: 5nMh1HXMf75N2yo2w1GoiqOhgPhB40Zn
X-Proofpoint-GUID: 5nMh1HXMf75N2yo2w1GoiqOhgPhB40Zn
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
- SKB_DROP_REASON_SKB_GSO_SEG
- SKB_DROP_REASON_SKB_UCOPY_FAULT
- SKB_DROP_REASON_DEV_HDR
- SKB_DROP_REASON_FULL_RING

Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Joe Jin <joe.jin@oracle.com>
Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
---
Changed since v1:
  - revise the reason name
Changed since v2:
  - declare drop_reason as type "enum skb_drop_reason"
  - handle the drop in skb_list_walk_safe() case
Changed since v4:
  - add 'computation' to SKB_CSUM comment
  - change COPY_DATA to UCOPY_FAULT
  - add 'metadata' to DEV_HDR comment

 drivers/net/tap.c          | 35 +++++++++++++++++++++++++----------
 include/linux/skbuff.h     | 13 +++++++++++++
 include/trace/events/skb.h |  5 +++++
 3 files changed, 43 insertions(+), 10 deletions(-)

diff --git a/drivers/net/tap.c b/drivers/net/tap.c
index ba2ef5437e16..c3d42062559d 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -322,6 +322,7 @@ rx_handler_result_t tap_handle_frame(struct sk_buff **pskb)
 	struct tap_dev *tap;
 	struct tap_queue *q;
 	netdev_features_t features = TAP_FEATURES;
+	enum skb_drop_reason drop_reason;
 
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
 
@@ -356,8 +361,9 @@ rx_handler_result_t tap_handle_frame(struct sk_buff **pskb)
 		skb_list_walk_safe(segs, skb, next) {
 			skb_mark_not_on_list(skb);
 			if (ptr_ring_produce(&q->ring, skb)) {
-				kfree_skb(skb);
-				kfree_skb_list(next);
+				drop_reason = SKB_DROP_REASON_FULL_RING;
+				kfree_skb_reason(skb, drop_reason);
+				kfree_skb_list_reason(next, drop_reason);
 				break;
 			}
 		}
@@ -369,10 +375,14 @@ rx_handler_result_t tap_handle_frame(struct sk_buff **pskb)
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
@@ -383,7 +393,7 @@ rx_handler_result_t tap_handle_frame(struct sk_buff **pskb)
 	/* Count errors/drops only here, thus don't care about args. */
 	if (tap->count_rx_dropped)
 		tap->count_rx_dropped(tap);
-	kfree_skb(skb);
+	kfree_skb_reason(skb, drop_reason);
 	return RX_HANDLER_CONSUMED;
 }
 EXPORT_SYMBOL_GPL(tap_handle_frame);
@@ -632,6 +642,7 @@ static ssize_t tap_get_user(struct tap_queue *q, void *msg_control,
 	int depth;
 	bool zerocopy = false;
 	size_t linear;
+	enum skb_drop_reason drop_reason;
 
 	if (q->flags & IFF_VNET_HDR) {
 		vnet_hdr_len = READ_ONCE(q->vnet_hdr_sz);
@@ -696,8 +707,10 @@ static ssize_t tap_get_user(struct tap_queue *q, void *msg_control,
 	else
 		err = skb_copy_datagram_from_iter(skb, 0, from, len);
 
-	if (err)
+	if (err) {
+		drop_reason = SKB_DROP_REASON_SKB_UCOPY_FAULT;
 		goto err_kfree;
+	}
 
 	skb_set_network_header(skb, ETH_HLEN);
 	skb_reset_mac_header(skb);
@@ -706,8 +719,10 @@ static ssize_t tap_get_user(struct tap_queue *q, void *msg_control,
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
@@ -738,7 +753,7 @@ static ssize_t tap_get_user(struct tap_queue *q, void *msg_control,
 	return total_len;
 
 err_kfree:
-	kfree_skb(skb);
+	kfree_skb_reason(skb, drop_reason);
 
 err:
 	rcu_read_lock();
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index bb00f86791e0..e5d5371a543b 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -394,6 +394,19 @@ enum skb_drop_reason {
 						 * entry is full
 						 */
 	SKB_DROP_REASON_NEIGH_DEAD,	/* neigh entry is dead */
+	SKB_DROP_REASON_SKB_CSUM,	/* sk_buff checksum computation
+					 * error
+					 */
+	SKB_DROP_REASON_SKB_GSO_SEG,	/* gso segmentation error */
+	SKB_DROP_REASON_SKB_UCOPY_FAULT,	/* failed to copy data from
+						 * user space, e.g., via
+						 * zerocopy_sg_from_iter()
+						 * or skb_orphan_frags_rx()
+						 */
+	SKB_DROP_REASON_DEV_HDR,	/* device driver specific
+					 * header/metadata is invalid
+					 */
+	SKB_DROP_REASON_FULL_RING,	/* ring buffer is full */
 	SKB_DROP_REASON_MAX,
 };
 
diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
index 1977f301260d..9d91ec9755b8 100644
--- a/include/trace/events/skb.h
+++ b/include/trace/events/skb.h
@@ -45,6 +45,11 @@
 	EM(SKB_DROP_REASON_NEIGH_FAILED, NEIGH_FAILED)		\
 	EM(SKB_DROP_REASON_NEIGH_QUEUEFULL, NEIGH_QUEUEFULL)	\
 	EM(SKB_DROP_REASON_NEIGH_DEAD, NEIGH_DEAD)		\
+	EM(SKB_DROP_REASON_SKB_CSUM, SKB_CSUM)			\
+	EM(SKB_DROP_REASON_SKB_GSO_SEG, SKB_GSO_SEG)		\
+	EM(SKB_DROP_REASON_SKB_UCOPY_FAULT, SKB_UCOPY_FAULT)	\
+	EM(SKB_DROP_REASON_DEV_HDR, DEV_HDR)			\
+	EM(SKB_DROP_REASON_FULL_RING, FULL_RING)		\
 	EMe(SKB_DROP_REASON_MAX, MAX)
 
 #undef EM
-- 
2.17.1

