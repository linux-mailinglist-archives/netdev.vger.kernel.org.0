Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFC4951B791
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 07:44:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243818AbiEEFsT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 01:48:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243729AbiEEFsL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 01:48:11 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam08on2132.outbound.protection.outlook.com [40.107.101.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76BBC369F0
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 22:44:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BHf+rg0gR5YpjhwZ1oczmWKjV/5TK2AHgPsujZc0yyrrNfr3duPsSb2DLNDHiqCG03gnWm5zKIiEVJ3MI/14Sc2rUwOpkv1KfQjUkxEbwQ3iLxGrB1512iKCu8jSOQr6KzVZgHRlVpIljBTtxiP+NMmJuBKfjgl6pcXYzWvjWhrqzIJA3n367um9omMS6OAWBd3TdKUiHml8jz7ajYvW1bBj5LlQVUb4jLuxp18SetWZ2Zft4DRtrTplO/wATXJjANgrg4U3nE3XJhxcOHzYL1hNeR2V60vnMm26Jcdtc6ugUzo3nY8dRVnfoy3d69qabYwMUY7NK9nmo8Q4tQoiyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lQUqytnT1r7TioqCsB2Nh/ckTb4QQUdzmxs8OgmdxdY=;
 b=XiY1/z+usbMJb02VtSyYGsV88ExIWgO6N9D+ZYvFjrlekx33lvH2ioJZOspWrNgeycGVLuuMMkDD88hsyPLWQK+1gHL54iVPwsKNAPySXSf8TaztfLrKB03UCoNNbxS7MQuI30LBgWPv77uioRsKCqrPXoAodZYGLhi1M6ZGDhRPqq9H/6M8Jc5ZkCOGvFn4/+xx1C/3M21pNrw2rVnikCmNMXNkDXfpsxIlWgh05NJ6M5KzngQqF+aIxtgYRExQTnSJzKcudPr2z/VpHzRZsLy+8leStFpOBm90bVDWllwPuiW58rkYS20kGmCSjg6tbqnmLe2arP9SkeUiAWq6sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lQUqytnT1r7TioqCsB2Nh/ckTb4QQUdzmxs8OgmdxdY=;
 b=uuYCvjVHp8tnxP6l73BWT4jLaCcg6kP4gLAznHMZtW5UIOD+hCNTQnELPEomDdqsc/3A4doZ641tdIso3u9nptlYPKIwqwBVj0W6b4kaDH/nZLcamqCjUU8P5Xeabugtz6P7Ekk0RD+0/ogQIzI4mWmcNGtpV/SxXxOA/6EPGjI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BN8PR13MB2609.namprd13.prod.outlook.com (2603:10b6:408:82::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.14; Thu, 5 May
 2022 05:44:16 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::8808:1c60:e9cb:1f94]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::8808:1c60:e9cb:1f94%3]) with mapi id 15.20.5227.006; Thu, 5 May 2022
 05:44:15 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com
Subject: [PATCH net-next 9/9] nfp: flower: enable decap_v2 bit
Date:   Thu,  5 May 2022 14:43:48 +0900
Message-Id: <20220505054348.269511-10-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220505054348.269511-1-simon.horman@corigine.com>
References: <20220505054348.269511-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0082.jpnprd01.prod.outlook.com
 (2603:1096:404:2c::22) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 54fe2472-f992-4863-7467-08da2e5a4a58
X-MS-TrafficTypeDiagnostic: BN8PR13MB2609:EE_
X-Microsoft-Antispam-PRVS: <BN8PR13MB26098288BB9DF4FFA0CBB009E8C29@BN8PR13MB2609.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gZqdPoJWxn6EGYj0nnGlAL8R1zCYjTnL8PWTCn2TPqUmtjLJpcChN6/IMj0SFO3A1phhz+Od0YD56DnANtTfSW9JThj7xZZNH3woOG8keXdwrfbdWESshIMSkbNa34/pYID2iMbpaghrwOTaSuTE2pOsRGY+6DfcFs5mXm/RapguYxpFbfesFDPPgYwo5vFYRymvcrF9id7pw9gX2MfYE+zUK7BRpOPms3lSWlO9FLUoPpE34paLJve38vmHd8ZwWknoENkVv/F6EnlA2WdUNSeiQi+zegVe/TtBa/FDnUXNv8SQcWt9wAfs7iQ5YF2BBar11bdysH+vr3jpQs65I4749yEhyuvBu7JEO41bi50cCDymkG2i+AdKsMBgK3PH3Rgb5Ztk7O7nouLlDn5RyH2e/mJWFotZAvMvsq1WaW9G5Be+rrprcGWwnhW1CzO4LFwNMLrp7MqLsy96yL8HqbHD1e4CL2NBU5dpOaCEqG5mi0dINJxodHStsaG6XY0Q7m+6B1ZBjXJ6FBqMifPTpmorgsz/+VlUEkophXldJ4nkAbL/6aFvFDZ6O1lszZAc1EgmwBdSswInHaSSUNh5V6f7z8LC5XRnfRg2AXfIjhaEknJqMWgEddKwqtPO2aesqgrn+YvFP1LN2iwYv+Z0C211oqsFjuoYsAf3wQ6uJZ5xEEnBCxDjWItt+AStJWNaMWIs1YyGPLEXKU86hiaicw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(396003)(366004)(376002)(346002)(136003)(39830400003)(6666004)(6486002)(38100700002)(38350700002)(44832011)(4744005)(5660300002)(316002)(508600001)(2906002)(36756003)(86362001)(186003)(52116002)(2616005)(6506007)(6512007)(26005)(83380400001)(8936002)(66476007)(66556008)(66946007)(8676002)(4326008)(1076003)(107886003)(110136005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uv4DVXyk0Y2reWE4S+od63JkwV9K2oBiR8/Hl2XRbPYeB9pptN1CKmbh4COk?=
 =?us-ascii?Q?/LtJc5i27NvktkrNb+khtZJ5mWMtr9h1/QOiTkidJCKUYfVXWxOFQBq5Pysc?=
 =?us-ascii?Q?e5wZ6Sm5Yyy2Peyv5QB6SSRsIcH6HBkAnyyU75zNHa7iAY5755+9tpxeBPe3?=
 =?us-ascii?Q?unyCFC7+/Ommz46V+3WSWK89vr7V5LhTOR2sigTxczW/enYcbqo+4RfZoYwE?=
 =?us-ascii?Q?02AmzngWunF7nT7LbdxxRtPmSVuX5YsELT4hxkjtX4MalSUD+bUIhmY3VYL6?=
 =?us-ascii?Q?evMfwZ71q6Fi7smIfJe05OHARlvg+A3VJcC+5X69Phag3trLvonB1UDz7mHF?=
 =?us-ascii?Q?x9opwqAOr2qJXMQPVotJSXviEW/29eKUhNjRiqe3qAuyqyoZwNZNaEw3aCQL?=
 =?us-ascii?Q?ctmD6npmu9ftKNyV2j3tMdI+GwpX+dDnGx3gNdVlMCQhlle60eUZEMN1cjuV?=
 =?us-ascii?Q?efpbl4eTxvwu4Cxy8bleIz6hGCw6xWePHkhn8oNCIgHRLM0uK5IABwrqDrz+?=
 =?us-ascii?Q?iW1anSzhegA5/8GTjcbC8tPgFx5/PiYeXikTsuSDehuBgzrRGOonEJI8lfpd?=
 =?us-ascii?Q?GQg5Fw3NJ2ta0UouXpF5GtZ0dgftQ5fn4nB69+V5Vjhho13OE/riO8/HXeMS?=
 =?us-ascii?Q?YO/XrhDDel0nex6O7omYIgPh5zlBABSrHt26/pmxLs7uwsVZMoWRhCSgRfUi?=
 =?us-ascii?Q?NxFPw8yes2B3rZmAOyv8mYQoDvIjnlP2JfFDfojZxoQ1AUFgqK3llBa5FS/O?=
 =?us-ascii?Q?ADm7NQOHvxGt9H50LBQMCkHRx1f20i7YWU1fODVt7XCe3c5ZmO88N3Lhc9v4?=
 =?us-ascii?Q?r8X/QsbKpujbQUMtZBYBDMvY/GRn3G/bYWWIj9SHtx9NdV6SHXTTUnLEz1xH?=
 =?us-ascii?Q?V7coeyLZIMpJVRNhdP5fR3Cdz6dUDjBJ8hNC0KAhjPccngsMPTK4OMO5SKJT?=
 =?us-ascii?Q?aUdrrvmiwn0ay0hr6P+YvzsaerviLiwKJwoZ+Pagsnpp+pV6DbMZZJltiIpT?=
 =?us-ascii?Q?rbD0Dt9ZPgsaMTRNDAVXwUPPcGwrT0KnQVcumOQFN5yJZ84WklA2xudKpD9/?=
 =?us-ascii?Q?etHzb3CUO20JWATgOkhRHfYJPvQ1tTe4kh60zmY1sLyeZG/1GziUS+ji3+ka?=
 =?us-ascii?Q?sjjcAHnsIfAvXQ2m5F+C4OtZrqF5f7FSIO0GqUPEhmvHuAvhK74pwuFZWR5m?=
 =?us-ascii?Q?lpynm+Fudu3dO5+tLC1ohDBKmsYlRxmhdrj1sLuIKCMrKjTr+vTg8DDRvAgM?=
 =?us-ascii?Q?CoV//CtdAnCCTfCA1tU7ItvIPoi1elZrRJ9IFI3vf0xN/oKmjYXq4JMQ684/?=
 =?us-ascii?Q?5UDA95RU4ro7rsHqBZIvpDkh9KRFh4LJCCJGLrpAD+ac3EAKumQXjBvpoIyK?=
 =?us-ascii?Q?GFjqWa+S3dI3bUwD2u1hf643F7SxerzKK2LYnEdoADQQ0AX5LWfVz3snEhkU?=
 =?us-ascii?Q?3vad9QcPJVqHAu2dM0WZKSkenCx/hwQinEqeibYhqD/o8v+ijxgW/cVAuhsr?=
 =?us-ascii?Q?0nn6ktymH8ow8w8pfV7lmhW+7CvuGxlV8wDdF+quN8j+k5Erj1ZejiT54HEZ?=
 =?us-ascii?Q?TkqD121eSN/vHK3G5Lj4jqTCNqVWCTDrYlUbLKFOVikkdBXPTeq3gNwpWVo2?=
 =?us-ascii?Q?Z4OIPaDqEaFrzspFWmceHvbi/M08xk9mQ1CYfZA79OKNLv+w2lYmILHILaR5?=
 =?us-ascii?Q?j83cN5uJIZtfq9dVbSKpEP+bOxx718WBxTFex/htwOZ7VhQWl8CgUDwDAODB?=
 =?us-ascii?Q?jaQjd2n27bUBaikTq1Yod5DgK1a1HEU=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54fe2472-f992-4863-7467-08da2e5a4a58
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2022 05:44:15.7934
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ++VSs1GAGM6eooLiBenSvr1vMiieI3c9ik836OWuuo9NjVWw5aHenTU4CWq1YKjzhh6c1I+o1TKCzEKUzii5QpRsGgIrX+cbPN3OTJtd+7M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR13MB2609
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Louis Peens <louis.peens@corigine.com>

Finally enable the decap_v2 feature bit now that all the
other bits are in place to configure it correctly.

Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/flower/main.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/main.h b/drivers/net/ethernet/netronome/nfp/flower/main.h
index 66f847414693..cb799d18682d 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/main.h
+++ b/drivers/net/ethernet/netronome/nfp/flower/main.h
@@ -68,7 +68,8 @@ struct nfp_app;
 	NFP_FL_FEATS_IPV6_TUN | \
 	NFP_FL_FEATS_VLAN_QINQ | \
 	NFP_FL_FEATS_QOS_PPS | \
-	NFP_FL_FEATS_QOS_METER)
+	NFP_FL_FEATS_QOS_METER | \
+	NFP_FL_FEATS_DECAP_V2)
 
 struct nfp_fl_mask_id {
 	struct circ_buf mask_id_free_list;
-- 
2.30.2

