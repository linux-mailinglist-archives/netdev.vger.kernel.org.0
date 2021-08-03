Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C67ED3DE9DA
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 11:41:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235056AbhHCJl6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 05:41:58 -0400
Received: from mail-bn8nam11on2115.outbound.protection.outlook.com ([40.107.236.115]:33888
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235038AbhHCJlZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 05:41:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O1v/s3fRv1N6TVLVqfnaQA4U38+i7zuaAs8q59uWbnGD3E4gFU+Iticp678bPYpRT4tV7AQwh/V2I30C9Xw+FMlFLf4vtJTluhMAhou5r0piBnnHfaQB2AdLAUQ/ZbSEZvFFtUufsj5aIOg6OakD3IuWVgWkFzAS5UFAHBEZFAuOMC9BtADsZ5PyXPPQCZ/2aD7ZWoAmqPUUNjpawghfYEERb67iecKUFVokQuMZFwkxnVASdm2cJmCJMwmB9o5KYJDDRbGPLpMWPBsPfxDeFxVQp7XwfdfuW6nC6qYCkp2/hJGQ6F7MvxNacXUYzv0k+H+pFjNxRj7N3jw5NJwmEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=53Z0UWOoBH8G4GqRmB3TwR4FiupFckFSp54nTIZw+FA=;
 b=G6gRzQF4gY8zOYk7LXHpRzEUSKMnG7J5/tsg/W2i8zXrBtOtC87b9wdInTXTGAu7oYxnJpUAUIxDJmFD4ojWQIYkG03Io6PBUzHNgcUiqD+Z4KYVSqQhsO5/vDGFA8luoBI8qeyzXD/bo+2d/M4WikCMkdgeRCajG4RwtUrIpA5324yKdusThxy5sIXT+WHWpaeoh/+SkemO5v1YcX1MwaRHoRl8AXT8KblYxAUsVEr0IRbLE3NUhMqIuUIYIzO+w8Hti2vujxcyC63dcOZi7zyA6Pb5pR5+J7DTwgpFALUsYQc4qXtYCf7V6j5lNkWGRa9EPNd6AgD0I1Mulxn3eA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=53Z0UWOoBH8G4GqRmB3TwR4FiupFckFSp54nTIZw+FA=;
 b=kxX/rknXUNvBYBP8YVJ7SJd6rWBSAF88WGZR5Jg6ea7vReW1rxYertxfJrpMryR70HWE2uZSG6Ov2mjiU6yTYUG2YVL/PI+6bgkaDqzLeNm/gF03sqR5m0MUArVHWwMtG+5kyBj4zEz0a6chcxfbjzczhTCFk5fMUxi+QNCCGwc=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4988.namprd13.prod.outlook.com (2603:10b6:510:94::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.6; Tue, 3 Aug
 2021 09:40:40 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::cd1:e3ba:77fd:f4f3]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::cd1:e3ba:77fd:f4f3%9]) with mapi id 15.20.4373.023; Tue, 3 Aug 2021
 09:40:40 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Bijie Xu <bijie.xu@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next 2/2] net: sched: provide missing kdoc for tcf_pkt_info and tcf_ematch_ops
Date:   Tue,  3 Aug 2021 11:40:19 +0200
Message-Id: <20210803094019.17291-3-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210803094019.17291-1-simon.horman@corigine.com>
References: <20210803094019.17291-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR08CA0009.eurprd08.prod.outlook.com
 (2603:10a6:208:d2::22) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from madeliefje.horms.nl (2001:982:7ed1:403:201:8eff:fe22:8fea) by AM0PR08CA0009.eurprd08.prod.outlook.com (2603:10a6:208:d2::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend Transport; Tue, 3 Aug 2021 09:40:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8c5acd01-6b8a-493c-7e71-08d95662c12f
X-MS-TrafficTypeDiagnostic: PH0PR13MB4988:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR13MB4988440D7B0ACE8C1EAA9E52E8F09@PH0PR13MB4988.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:949;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Su6gv9n00dJ9WiczDszTWYFN5ksI62hDUpUqk7gFez1qPtVo6XyS8LDE7qT7QzqHafQzXWCNpSMEYFIFEzbgL1kJmDTlRGZLG4Pnxb8H1orSaEj9KOlxLjqvXFnPPnStt1QedI5pdU5L87ktvh2lh+IRaFyFK+SMoH81wfDCfvQJBzW7UZSb4omtQSe8c8w9BzDGWxqYQ9kkxBMUWv2SzDWZl9MovNVuUTFK9gyR5r9ehX0uksNzCmckE4TuHPpGWduSNwKZ3P89UY5faKKIUXnyMJG0fkdQ8F50p/gMC9dzVVJ40pSGaO7L+m3DRDBtVcxkV5eNlV7tYuK+vuSkWMmg0MgzRZPJUNp0pkufn+527B6N/iFPe05f6uIpIrvLKeTlbBCbHypj8/qjYd2wZNJ4Al7BkVE3IiXpnyq63OPX2JIHOjtSNgnAETHT8LjcCsI3Fwkj8C5ML3aLZXXzZCsgiodu1hFC3v3JPftZ5dCFC/2TB5aj3EyCoyUbZcM2Oz68FTEB9PBU7W4EkyO3xWNQH0fX9Rb8Hcfq1TIu5nGhsdxKnx8gbnPY8qHAU6YZVVgX+5WbsOTcbM5rb7IRSNNofftEEexCWWU3vLY8IoCDRYbbvKeogDoJkdOf/5WLWJmwkv++/8kGiF2aSbMxcg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39830400003)(366004)(346002)(396003)(136003)(110136005)(2616005)(86362001)(2906002)(316002)(8936002)(6666004)(6506007)(4326008)(44832011)(54906003)(52116002)(107886003)(508600001)(8676002)(66476007)(38100700002)(1076003)(66946007)(6512007)(6486002)(5660300002)(36756003)(186003)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CkNXKRxNAFc5jWhAJ73AHHHlDu7txCExUiUq+o4pdCU5DtExruSPXWZ7GOzP?=
 =?us-ascii?Q?XaUpLts/vVlPeh2qBJfzRZN1DJ/NTKlY88Ec3l7gbXMfvdMwPtSgVifGi4Fn?=
 =?us-ascii?Q?c7Tz1tTGKzcIIPgaf1zy0tKuKCBBmUIqZ5DHKAcb+XegFw5GVYB4q8mHaE6M?=
 =?us-ascii?Q?PG5740RS7idmigJbssO7ybZSIkSA1ZDJk+jFK4HVHD6uE+vc+DkpgOjwrDZK?=
 =?us-ascii?Q?BOcLLCMHX/7h3IUw63+GlMq5EnhbvomaRRQAjysycZj+6IfIp6nThtWIxWMY?=
 =?us-ascii?Q?QHb46srDp7/WyWF5Ye0pC8prJWHeCWpAF1sToMPSpZPwLrOyf6ldGkPwHlIA?=
 =?us-ascii?Q?mUwXoBaIgWSSYLq5Ei9zlPv0ppWFqwwdyO14mQqpt/l0vI0W5fs/ADFSX7PE?=
 =?us-ascii?Q?4hcsFEexq0Ak1Na4/tOszwC/qykCoZXAC4w0ErdXI0xYH3tqS9YzOrdnpztw?=
 =?us-ascii?Q?xVtKMWFzh5fR3Eub4n4kYM4zfp4FHsRC0hMpE3cbDZFjx/ZIkde+lno6S0j7?=
 =?us-ascii?Q?0JL/4ykz9hDLwGhoUWs5cI9/nNpj+CZKZrYkSsQZRzOW6N1CuT4Vuqk6ezr5?=
 =?us-ascii?Q?BGeyjdR0BInA8nXGbzyAbH10ptrDMc4rZYKGcRVZagSOeeZIheGAdemn9TtT?=
 =?us-ascii?Q?aqHyIBtyPPXWuGXw+ecwT44ldG1vL1L3gBIucVbH7rWeJBV5XCAENu4WaZkL?=
 =?us-ascii?Q?03pkei/dke1DQNBPG1/umKXVLXAuMffV4pVmivMawPe9Gr8nXG25XLLKekMo?=
 =?us-ascii?Q?WkVa0sakxENSeCv15f80mkiS5JT8bJ7AGKnwg6HoRwFW//0NhQOP/uifiD4/?=
 =?us-ascii?Q?m44iMl9Hw49SIYjaXuwg2S797JPGV+u1tN4VCd3lQZC2cXm+jB8wmEMf9UvB?=
 =?us-ascii?Q?B7P0tujyNtujxfASPNVUZsV/nqjMrQTbxPk7TD/JGVKS0vS2u8vn9gAFQlOk?=
 =?us-ascii?Q?F679fKXExIm6wyY9B/+7JK+d0qBOHNWcdcdu58d1aiO2rfrVxr7FpHp2V50p?=
 =?us-ascii?Q?Cs6DKHTcgZLx/NHSyLcb//OiA4sWQRY8BBgXKzCRf48PSoMLlTjdFzkzASqr?=
 =?us-ascii?Q?h5MFYDQl1vqpYu3D+8suj0Dej8rejf5WnVFAiTD1X2yEK+fh1Js16VDa2uoZ?=
 =?us-ascii?Q?qg5xP1sVF3Pvc2hjOYQaLSydyMpDpZgSTxYZJ9zTvntC8R+ZaIKIFejTpcty?=
 =?us-ascii?Q?LphtMD5jZSUMhfZIKP7kxH8lYDklsbonayYSaR+i+k6/+ajIBwTriH9jqUzq?=
 =?us-ascii?Q?iSl2iHE079d82wATIxjRKOV10kxOxT64VV82RNtoPpcdK7XeeYO4yN08aoNF?=
 =?us-ascii?Q?Lkwixu9OZv16LjXVRdoxW2/Fa+NXdMz9LJnAgx1gJV4eKmwHWwz2FQNA6thL?=
 =?us-ascii?Q?STle28nVRI+pi+/ThGEsTk6MxDL1?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c5acd01-6b8a-493c-7e71-08d95662c12f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2021 09:40:40.0382
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IESHKVitj4rNWByUDLZZWHbCaQXXtwyS2DFZqsXHfHY3gatO/Nc6yajB7MWjnKZxB1MjIvl6Ug7QKXWXveChXNeBjvwyAiBMd1npjcq4Ct0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4988
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bijie Xu <bijie.xu@corigine.com>

Provide missing kdoc of fields of struct tcf_pkt_info and tcf_ematch_ops.

Found using ./scripts/kernel-doc -none -Werror include/net/pkt_cls.h

Signed-off-by: Bijie Xu <bijie.xu@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 include/net/pkt_cls.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index dc28fcb6f0a2..1b5100f5e660 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -329,6 +329,9 @@ int tcf_exts_dump_stats(struct sk_buff *skb, struct tcf_exts *exts);
 
 /**
  * struct tcf_pkt_info - packet information
+ *
+ * @ptr: start of the pkt data
+ * @nexthdr: offset of the next header
  */
 struct tcf_pkt_info {
 	unsigned char *		ptr;
@@ -347,6 +350,7 @@ struct tcf_ematch_ops;
  * @ops: the operations lookup table of the corresponding ematch module
  * @datalen: length of the ematch specific configuration data
  * @data: ematch specific data
+ * @net: the network namespace
  */
 struct tcf_ematch {
 	struct tcf_ematch_ops * ops;
-- 
2.20.1

