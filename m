Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 012424D5FF2
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 11:43:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232037AbiCKKoc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 05:44:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229865AbiCKKob (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 05:44:31 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2114.outbound.protection.outlook.com [40.107.237.114])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22463C7E9B
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 02:43:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FvWqvlekc6qkItWL96vDg3iEr14MpoRLvmgl8MNjrlfblSKw1hQsF2Y+UjFbcVXfF1QSV4qW+QWzHCGh/x8WIimOQB5/Y1ZUrB9fcQxZ1woRBKrQ3RxzxpJIzl/6BxLVoGEDi0RWgRvtpaAxeL+1TrFj5AdjRiwEKM3II1HvcEnU+8M96gWrc5WgercvD8HDnIiWZU1NRxP0GZZFzbnPWT8RJcMoyjzEO2sm1lilcvTeTccOkEP5bRpr+rqot1ufelt9gJvxp8H21Kp9zmL1uEfoMfIA47uT06L5bnFv1SsHYy+FYaVxXXZQldoxNr60aJViujC9GJYsWByDjGD4IQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a3lhmXkzKkgOxpX7JenIZ+zcWXaEiGEcfvI34Ut57Hc=;
 b=Dj7JhAQeuoNDyH1yuq4TQpJPpWasqKiqv50/TdHNm3adY6T86Gb39hCXfl55bUcl5vXvArqqhTsLIBmbrDgWhxkP+n+Rs/og+kj0lOHy0ImnPwx8mOjYC+y1s38TdtNOLfae/M+40N7W1uNxCpILnZzDaAK/YaGVI9CBs0OHWouw6iRBctfoo1NgBQ+eILDGkJkE/Oc9LrZmALZkgrprRKJnMlRGqZA4rAyMJJQyx5RKt1s8/5arZQMeFUxiRd9YUE+4bhTlSGPLZ9ewYIiL/QdpPXxAaLO7xoV6X5rxx/VRiG6AKObI3hnIMolMcglkzQ97Gc7Uy9Zb22/ke/QDUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a3lhmXkzKkgOxpX7JenIZ+zcWXaEiGEcfvI34Ut57Hc=;
 b=XUvcue9D7rH/QdaJwUDJN7XBofnjAipwIbXkK1fXlEb72UZeyIDQCRgPOU/mB8zZ4ZJW+5hsVNU/R4kiWrSOzoWzAbngID5ogMx4Nrl2EY9vwEd499LYz2J/ZL93sQJRTas2FGvSD1YY1BMxqRsCSN6GVXj+7gK9ZsBZ5bXFsIc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MWHPR13MB1184.namprd13.prod.outlook.com (2603:10b6:300:e::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.8; Fri, 11 Mar
 2022 10:43:25 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::d27:c7d9:8880:a73e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::d27:c7d9:8880:a73e%2]) with mapi id 15.20.5061.018; Fri, 11 Mar 2022
 10:43:25 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com
Subject: [PATCH net-next 01/11] nfp: remove defines for unused control bits
Date:   Fri, 11 Mar 2022 11:42:56 +0100
Message-Id: <20220311104306.28357-2-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220311104306.28357-1-simon.horman@corigine.com>
References: <20220311104306.28357-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0P190CA0026.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:190::36) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 871bc5b5-020d-44c3-3bff-08da034bf729
X-MS-TrafficTypeDiagnostic: MWHPR13MB1184:EE_
X-Microsoft-Antispam-PRVS: <MWHPR13MB1184D6042829D719D2A4AB41E80C9@MWHPR13MB1184.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: q39Tn0e7E3T/q3bXFrOOCaLTRGWO6BwQIx9yFlzOkRjs44YuA+tM2rJA91ft8mSJjk6rTA3bTp2j8FIiMzZbk7yY1SgonX65iacuMQF0iDcUqCYPq1KG/GV6jytCIXdbHmMZGC0SY9Ws08jq5DQyEULhdDsIb7LPvbRgpBCJme5x8OKk4ZzA3FN1SSbKeECZxfB8Q2IYT10o0f3JDb6HV2HfP9LWrVLCXW16vtkJzH43IC1FvO0NoAUyLtzgN2VNXziLxZ2y7isduZFp3rUYRU7GqmENkdk7Kasmb4KRlvYoyia0eMRmM8Jrk5QH8t4q6pKrnTrQ/A+9Y8VMGJbOuDN14xqmWq8JuWVJYGPqX5/A8LyQ8DWn3HiadbJpANgsT7m6SUMBXzGSXtpppS5jvA/8VkpHGJjsSejXkgXRvJWyavttGq6KCqslbesfu2cm71iyWwiEHC4157yO5m/XGdD5IXAxOUstlLmeJpv9agbuHhlsxk6/dD1UZ6zCB5UQbXNkPngGiYesRouxQ3kTFJYmRh7DtbNFPp6U89X2Zf0T4j9fhmDn19k4673850PVpE6oL7e7qJQaA45cIvvz+Wa8ThC25lzMw22sy9CoOcRn1pcLM5HDJpj8ll3SYeOgtv1DRWF9dO124v/nCJJNUQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(396003)(376002)(346002)(39840400004)(136003)(36756003)(5660300002)(2906002)(44832011)(66556008)(8936002)(66946007)(6486002)(110136005)(86362001)(316002)(508600001)(6666004)(2616005)(1076003)(186003)(38100700002)(52116002)(6506007)(6512007)(4326008)(8676002)(66476007)(107886003)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Mck0sA9cpCS2qlypGUH7kJF/KEhk9AuP4uaISRw68iMCuxDj17zuKqEr/C9e?=
 =?us-ascii?Q?qfuTP0SbBwNudxBythEULd916W9qvdbn8JBgZ1cM2rcNc3KKr6BWZI9ShhMJ?=
 =?us-ascii?Q?ChXHF/sq9kps5dQ/rG12+f/syjk8UaZSsq4KOZFO8abK8Cu7wztO3BwePFW9?=
 =?us-ascii?Q?VXjjarAIPDK059pQA73diiPKio3zj3ZinZRhTUMXh/FVYDdOWqjumqlsWnUL?=
 =?us-ascii?Q?MRvVTwbvPUJNyuQWDHMobg1wevwYGxQYfDsJUIbSYEH/VuYpRMRv2nDnHCbd?=
 =?us-ascii?Q?BEg2rB4YVUxKhJkT8uQclcMeWIgR+nwfA7fW5pzTdLvXPmkhAZ8HcUqqTbs7?=
 =?us-ascii?Q?0GlrgMSa+28Ckm3dzKyQ/S+ITU4HIdMRsmTYiIUPmxp7KWJO0CNWgjCTL4Bs?=
 =?us-ascii?Q?aCFShxPo6xayNAKgD519kJfsSArOWPFzMYwmSvdK3fFCzFKIy/fepiPNnAoF?=
 =?us-ascii?Q?yMzNh9fi/laYGQct8R7diMXNkdhJCJxAuccouDK4nwoA1YPTKBNG1Uz+J/iS?=
 =?us-ascii?Q?qKSTSOCw0GpHP+yX39XC1JyS8Mr6d1HSeh/ljG10KkW4CYpk9uJQGtDFIrr9?=
 =?us-ascii?Q?BTDjl5rmCaZuxzvvlZplX782oON6gkjFhdbGiVoDHL0Es+WZS+pr3hoZlHub?=
 =?us-ascii?Q?S3JnsC4ncygCficGX6fYuUigik5Og3GRcl0oRlOC8bzvFh4JLhueAymMuTFN?=
 =?us-ascii?Q?3qftDboWBshmiYvJMcAffdbeDQG1+GQLwhz0FpGcSE3gKCJOsvsBct/TgK/h?=
 =?us-ascii?Q?IgQfPxQ7/4X//q2Pr6oScEUpzIPO+CITn4wIMg/k4E3RSwJPlDYOh67lXaqY?=
 =?us-ascii?Q?yUwOsJo7OaK5Mlt0KIEzuX49btMOqNJd7hk8H8SOFLoeTEQtsCW3T53QqvXV?=
 =?us-ascii?Q?HMSpNfH3GavXs8QOsyIa5wLd7o3SgD0xWTOnuaNLa7V45sn24P/ylo0NG0F9?=
 =?us-ascii?Q?Tg9simIwSsrdcnEVMxZ9wuKgKNyZNwBnXTzEJRudEm8xM3Af+Im/kc/+klRF?=
 =?us-ascii?Q?42RW67vnPaobwet/iZh6Rx/Yk+r3UZZ+kC1p8YFk8ftaE/cR0/+6i40wTVZj?=
 =?us-ascii?Q?DegWydIxWCnpf57DH0E0k+No5ovtYT0cIOa4KmLMeSZqwH3EB/Hviss+IrAc?=
 =?us-ascii?Q?pRYcPbpYLsKliyRpVEEj6PrwTkPHQdCXrzpqjAVczju3tba0HyqJNz2z0mC4?=
 =?us-ascii?Q?IEyOkH9AAD4FVLT+gzgDRr8UBEFFlHF3LcKRJYi/AlJsJDLl9Hf+2NuE/Kes?=
 =?us-ascii?Q?FHam1H5ABgiTs13kyjr4CEzeriG9Q0IPLZXk88Wx1OvV3zMyQXOIXYuieGQ3?=
 =?us-ascii?Q?1aKDHYGLiGvrQDw4WGxmsKUXwrcRNZb65M0YkqEnJ/jG1OI/yaPjP4oFv0K7?=
 =?us-ascii?Q?5b58Ta21xT1jcmzQxry99ltn+epEgfdg+j+He0ynGu5PUz1UhbiVQAXpZBjv?=
 =?us-ascii?Q?/uGc2DwhpxsTrmQkUNx05+9XumwXb3cqIuH9LEw7Q64Et/rH+eoqB2oBvlDf?=
 =?us-ascii?Q?fnhdfORA80qYpS9ob/lOdFOzLzvDjCrc4OJCjJZRRBOpDeGK81/NfgMacg?=
 =?us-ascii?Q?=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 871bc5b5-020d-44c3-3bff-08da034bf729
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2022 10:43:23.1545
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OwPEM7b8ePwkOOQrJWrjF7eeYHaJDSEvy+5GZ9aBQH4h8SC161sPawQQKVl6HvdbeO4GIaNl7WV671qkrs74xB3cJjlVS3uIdcOX4L7pv2k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR13MB1184
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>

NFP driver ABI contains bits for L2 switching and ring
prioritization which were never implemented in initially
envisioned form.

Remove the defines, and open up the possibility of
reclaiming the bits for other uses.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Signed-off-by: Fei Qin <fei.qin@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h b/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h
index 50007cc5b580..33fd32478905 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h
@@ -92,7 +92,6 @@
 #define   NFP_NET_CFG_CTRL_RINGCFG	  (0x1 << 16) /* Ring runtime changes */
 #define   NFP_NET_CFG_CTRL_RSS		  (0x1 << 17) /* RSS (version 1) */
 #define   NFP_NET_CFG_CTRL_IRQMOD	  (0x1 << 18) /* Interrupt moderation */
-#define   NFP_NET_CFG_CTRL_RINGPRIO	  (0x1 << 19) /* Ring priorities */
 #define   NFP_NET_CFG_CTRL_MSIXAUTO	  (0x1 << 20) /* MSI-X auto-masking */
 #define   NFP_NET_CFG_CTRL_TXRWB	  (0x1 << 21) /* Write-back of TX ring*/
 #define   NFP_NET_CFG_CTRL_VXLAN	  (0x1 << 24) /* VXLAN tunnel support */
-- 
2.30.2

