Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F8AE4BF9B0
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 14:43:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232514AbiBVNoN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 08:44:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232496AbiBVNoL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 08:44:11 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 974F511E3E3;
        Tue, 22 Feb 2022 05:43:46 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21MCVTpK024367;
        Tue, 22 Feb 2022 13:43:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=w065e8T15duAeNX7gLsaO4eE8pvu3IA9enuSM8fg/Q4=;
 b=fyAbsrbO/lCXIuhu5wt4pf9ypxhD1o/nWrkRYoNNMeHKjVq4fCGuB656yqpmPZMSsgWY
 JAI2HPdPOGpvHK2uBB4jUJ3AX3xeuE7qRUlIgDC2YcmzllKb3mAGtHEAMAzHcngvyTYj
 QbdKikSTv2fNqkEIvRUU8PH6CGqPSXGv6GC6yEcdg9Uu0TlikFJK3hVir/gZ+61u8NOD
 7Otr8PyTKZ2aGfymd7vMKkEhXOFRtMdWETRpd3XSIDnmd24cfCCLQr8kZQpaidN2P3o6
 qF9Eq1wZp0W7kVVb50onDgDF04EMayRPhKQi/ps6H0QHlnSJvv2cD8j7ZHytV7Siz+d1 rQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ecvar0v0m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Feb 2022 13:43:31 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21MDeqlk012737;
        Tue, 22 Feb 2022 13:43:30 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by aserp3030.oracle.com with ESMTP id 3eapkfxycm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Feb 2022 13:43:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cEL9BoS6XsfD+FUlvvV/SimfB++6SoeMJMRLosS3P9TjV5SM6nISLkrnH+3JOHYKL/NkHetd8zpahmYpp5Ln/ubbHMf6MHkm6EF0FJf2YSPAIblIU+L7jI62C659PLRHyz4NDt/aPCOLBYm9wJvJjemASqLd0JLtiHEDtzSaSBrPtAk64Rmom8bgco5triy0n74bsw2fAj9rd9JpwJox/G8qjgKzfXrbukhToFmu0hreR+NBuHAZyLUTXaAXp5Tq3+SLjNUPBXfoy6f1DFG68E7Mb+9lFI9+G1QB0xFnocPLdltIWwIB+Koa9ECd8nJYLxevg2UYhAomLqgohmyGyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w065e8T15duAeNX7gLsaO4eE8pvu3IA9enuSM8fg/Q4=;
 b=IgbIiEjmFMd0jJ3U3gQ6SXxMv3drlp/OKp04mblxxs3spy6Ms8x+5gsLUJYzlGAojEsHLDwyXyGt5IjXTkyeiFIORxbRq1M/Ce2GMlxoHDsveWydkWmZuug+/cOpJj+V7bAKFqXeaqFDWIuF4GDNDeXRuTBXtu74D8jmmTHeBBIXU15+U24fXlQvUnIAv0/bgXAunucRJBuAYlKXZ2ohDQ+H/yJGPscY1LOMPwFb6QKDFSiy8zsSa5aqen+s98IJ8NHuKHEz1pet8iSpdbu60LxeSDkCCIEjcpS4qAaGdHAkXDyRWcbJEW0tTa+IP9oHSC4VBELd7af6/S5qEyeaFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w065e8T15duAeNX7gLsaO4eE8pvu3IA9enuSM8fg/Q4=;
 b=RsMCydtIjRkHXMdymMYdEas2AJ/QkizIRs/yMvWvjQY5eLtYuHQL1H/HkhLm1P45Fhv2iv0vgteKZkPt4BbfMW6QFb9Sd+340zLCCDhlKBc32x+ywlmA5/u3Xw9nKur508C9OB/7xXPcI/1iO47xNCZTP7rfRfqo95kCzcahPqc=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by BN8PR10MB3700.namprd10.prod.outlook.com
 (2603:10b6:408:bc::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.21; Tue, 22 Feb
 2022 13:43:28 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::2c3d:92b5:42b3:c1c5]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::2c3d:92b5:42b3:c1c5%4]) with mapi id 15.20.4995.027; Tue, 22 Feb 2022
 13:43:28 +0000
Date:   Tue, 22 Feb 2022 16:43:12 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Jon Maloy <jmaloy@redhat.com>,
        Richard Alpe <richard.alpe@ericsson.com>
Cc:     Ying Xue <ying.xue@windriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Erik Hugne <erik.hugne@ericsson.com>, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net] tipc: Fix end of loop tests for list_for_each_entry()
Message-ID: <20220222134311.GA2716@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ZR0P278CA0187.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:44::9) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2b7d695a-124a-42fa-1154-08d9f6094e89
X-MS-TrafficTypeDiagnostic: BN8PR10MB3700:EE_
X-Microsoft-Antispam-PRVS: <BN8PR10MB3700193E0A48B1879F71C71C8E3B9@BN8PR10MB3700.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6sF0d/JownJ0n28tAGRjb7V1FjD7/YB4GFd5+DhxasYa9dZ3p1OpV2wiioD3HBp+JYC6xVkLoU2x+1AVvFwl4C6xdv432fL5Qsv0xlEMR818K2tLfvn0aqndP4xqQUuCObc6VsS7umZRAmEuxhcjtevkTgWCLnXTsocWkb2iRbYfQp+Ew+iiPJpl1rZ4FWIqcsSyCsMQ9jizrD9/mPmRZjHGunO6Y+0D4NoenIHjSUHzCPtmd6qIr9GaPbmVCH1qqZojfAM3j7UfPR3kwOhrcB+fu0zkTsyJqzNRxpyGWRRQJF4dSPhS6bm61vIr3kp5Fez4bIpIG/XiaeBVj6A46NEGnfPx6p8wJb1+jbtZY4jO5hqPlMxxsdpiaG6MET8+4y/6zt7n6SzrW4eDRnZkrEuR4Bd0VX4v0yAL7FWYSg5OtU7F0yUaIchHFtkHD55TXZh/x2hXsOur1TBPSk8DJDS7QcsBHBtTSSTs5NHkmFumx4b/RSpma1CV7JHyCVhCNnO4gwg7jVO6BuhOtnTFwtOGtyQpS/ZEORf2oKcgQBrxF/CY/zicdYNdG1JbeLT4reCQ/+OXWOirR46uhfF8BcA3J+Ia3sfkinbrORRmP3DLMivRo0Uv0ixSTpOsWZ3sx3iNXA0RazYD3lvioVrzudhVb+2usDoY3OD6ydgRemSGOIywLjqhGaCe/UDd7opq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(66556008)(66476007)(8676002)(66946007)(4326008)(508600001)(2906002)(33656002)(6486002)(316002)(6666004)(38350700002)(38100700002)(44832011)(6506007)(52116002)(83380400001)(54906003)(5660300002)(1076003)(9686003)(6512007)(110136005)(26005)(186003)(86362001)(33716001)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tWCsCXD+XQ6f/7TRk1tMWEuI4hcV3+0fA8X/sEq4G1DbHYJHSZFqRCvh60C3?=
 =?us-ascii?Q?fUj4WcWMXTYgxuVHkvT2h/nE4evcbbGmsxPbNdfcA7XNbc7cNAaJ8NtL/9EP?=
 =?us-ascii?Q?u2Od//AXgION8GyM3D0aRSMc+3mmRRvua5Dtl3gXJdW64m/DmhHENqWsPksJ?=
 =?us-ascii?Q?6jAfBXghL2KEZ5F+tVzK5V/nV8iBFgjqVokShGN5KAnpIHwj2Ac9D0gwQ47q?=
 =?us-ascii?Q?/tkdziX42lZlHCzI4kZOPrDran+i57K1vG9i8KOp2ECdZ0tRbMjyqyicv7O3?=
 =?us-ascii?Q?QRey592hCt9btQzlQQisybbmeuRgAgpV5XOBTJIwzvGWb49u3dqasDFTAMX9?=
 =?us-ascii?Q?U/p5ExHMbT91wTdmQeSw67r8bQdwWco1yBNJ1AD+/GHLf4yWVLb01LJ4ZVjW?=
 =?us-ascii?Q?OPhQX8LxZoMdHkQtnG+KOPQIz4STp65guMsx6EqDtiFsuNe6FnSnR3HimLar?=
 =?us-ascii?Q?tjLpABADVXb4BZxUf57RJSy0UlOSwOp55GoiICmFIytKjGWHJE0FWPUYrrsH?=
 =?us-ascii?Q?KoyBCuEyxFJgMI1cMR0zOVp5gyx/gJ4S9tWKQCpIUvEJYAANkN6lpkc7OWHA?=
 =?us-ascii?Q?sEcm6GFH+I3uvs18ZqmYOpDs30IMDSsvN8oDHmgXstdMRkAlbSh7yiZlB3HS?=
 =?us-ascii?Q?g/4pcRXfadG6Y8pMi6CsVQzRd/HG0Gf4TDq9h5XiFzegKh+Yk6FqssglYtAg?=
 =?us-ascii?Q?f1y0qA0y1fetk7MlE/CKXpIkv4X6adS2FaOhRyocrvFWb2RiIVWSk5JQtyRN?=
 =?us-ascii?Q?ADNYvkLxTSNYEs8bTNnpieRkrur0JCeUGikYryOgFT7GyEsrvVkwFWDrGNms?=
 =?us-ascii?Q?8hjWHvdn6+l9YasS/eSEWOFulrYP2dca1eSXsNs/xGZxlV/LK2Tj0/68eCUJ?=
 =?us-ascii?Q?UOEBuZXXcAbVgxn8H6xuLe1I3hV42h8tChIPZcIxn7/qyxdNPq9kSlvgyOS7?=
 =?us-ascii?Q?cIL64a4arWwfzTJ4YJT6Rn69xFng01Ne+11Xs1r/YJMNWOtP5yXNDIJ6gYUs?=
 =?us-ascii?Q?Qddr1N3xTSnJiWb8/IN+8IQKB4EurtqfuGnk4Fcs2zSm50w0XxKMvPta5BYb?=
 =?us-ascii?Q?rq/qTu3Qr31RNeJ69bURMlSGr3IbVK0FyOqhO+dA2QS/4C+rkvLDaXW8XtWe?=
 =?us-ascii?Q?7q84CuYRGJHmahrZswLBmYIM6OdwBdyliK0qNgZ4/UZdvslyxQJWFT/cPREs?=
 =?us-ascii?Q?UVnnWZffiZmx9rX1YIoyf3HH4VatBIwL9Db0162Uk8RYMIgCD+qJGUQHe1zz?=
 =?us-ascii?Q?6Vkrq+zYWS9l7xLFoEch2VkewI5O9VS0LRjl/PZT+CEQpCsoahxKu017Adv+?=
 =?us-ascii?Q?5VU6iShF/9sC7lbFeo6s8nDqrqt7uvutwFJ6FJDS3EJfvZ4dKtxiwDSrB295?=
 =?us-ascii?Q?npwj+D3zOSQPrQzUowsG8HTFqFrKrAJdTsL6dzDODpbmnv3NKpydcJGYmTaF?=
 =?us-ascii?Q?JHtc7GwWZFNzw36kh+qN9VJG+ONlonUnni3Q72ITPWljop3135ybDx287kuX?=
 =?us-ascii?Q?1L2upq6zHaxi1u5+JCkfgrmZkjQBKscQcuK48ZVCfTDzJO9wHD1wX6NJsbeI?=
 =?us-ascii?Q?v/pIc7fUI6MZCDZKu/F+4eFN25jnQtPeKsMt+akNS3ZPoe3b2AJJlmVwoQ9I?=
 =?us-ascii?Q?bqusU23EOPZSgKetRX6TggV36/wBoSzcx/lbWdS/PiEYrhII0UimKA1B9rof?=
 =?us-ascii?Q?vXNX5A=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b7d695a-124a-42fa-1154-08d9f6094e89
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2022 13:43:28.5817
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0Kc3sHGBkVl+ehR2b1dyeHFwRbidD/h+DZCcR+lWqrkSKEFOIbNDe66DPTFuVKtwslRROX6Q0XUFMSNJPXiILxLu4TPUa44FJ7W5SfDPhuk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR10MB3700
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10265 signatures=677614
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 mlxscore=0
 spamscore=0 mlxlogscore=999 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202220083
X-Proofpoint-GUID: o25lNBGJkkGKb_sMwqygEyvTmHU4AUfh
X-Proofpoint-ORIG-GUID: o25lNBGJkkGKb_sMwqygEyvTmHU4AUfh
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These tests are supposed to check if the loop exited via a break or not.
However the tests are wrong because if we did not exit via a break then
"p" is not a valid pointer.  In that case, it's the equivalent of
"if (*(u32 *)sr == *last_key) {".  That's going to work most of the time,
but there is a potential for those to be equal.

Fixes: 1593123a6a49 ("tipc: add name table dump to new netlink api")
Fixes: 1a1a143daf84 ("tipc: add publication dump to new netlink api")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 net/tipc/name_table.c | 2 +-
 net/tipc/socket.c     | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/tipc/name_table.c b/net/tipc/name_table.c
index 01396dd1c899..1d8ba233d047 100644
--- a/net/tipc/name_table.c
+++ b/net/tipc/name_table.c
@@ -967,7 +967,7 @@ static int __tipc_nl_add_nametable_publ(struct tipc_nl_msg *msg,
 		list_for_each_entry(p, &sr->all_publ, all_publ)
 			if (p->key == *last_key)
 				break;
-		if (p->key != *last_key)
+		if (list_entry_is_head(p, &sr->all_publ, all_publ))
 			return -EPIPE;
 	} else {
 		p = list_first_entry(&sr->all_publ,
diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index 3e63c83e641c..7545321c3440 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -3749,7 +3749,7 @@ static int __tipc_nl_list_sk_publ(struct sk_buff *skb,
 			if (p->key == *last_publ)
 				break;
 		}
-		if (p->key != *last_publ) {
+		if (list_entry_is_head(p, &tsk->publications, binding_sock)) {
 			/* We never set seq or call nl_dump_check_consistent()
 			 * this means that setting prev_seq here will cause the
 			 * consistence check to fail in the netlink callback
-- 
2.20.1

