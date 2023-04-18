Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64EEE6E600F
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 13:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231517AbjDRLkU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 07:40:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbjDRLkN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 07:40:13 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-db5eur01on2052.outbound.protection.outlook.com [40.107.15.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4643D1713
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 04:40:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mw7WXPHthZN7AdiArhM+mupom/kN8pnLMr6ms6ZCFx7o9Vsas4nV4+lpalLsSLZyoJ4fMsj+JHtzYIpHK5bAkinVx78e18bF0lqyFxm+c62FVvb8CW9FLYOv5bBNGA6nkcb8uHQE+nhHKWf5kaDeLQEeFoCM0j1OptNO8m20tgCexE6aPREy6iTKHhaRcPHnxja6VRmc2otIpd/e8wkG5KZyXiHmfOxFZyaShG2MNxdQC7aYv/2u2FLtUdAXBdcqraxAlTe2OLPXjmGjIOgdsBVh2qQDjvKdl4yJ87ETFoW1mlJDT6Hp5e7LRjclZ1+zQAxKFHve1H42U/K4nx4s5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HUecmt+nSkaSY3R5+VXxthBovsGOjQGo/OMIDun1hKE=;
 b=YNho/04hCO/CoWVX8zwRgs7SXe8xuzZCaNpdnd7/DrT4/n40vbO1QxeEY1MKcQk9ZcWE/VyXjuKT2OVf8QOTjfiu54bK84tlLLAp0GAxBOt+Ih8cSz0rv5idIlx4wT/PoFxeJ5FpEVtb+h9u0MGiTGi+O1ULtGCRu1BbrG8hfJzoxfcDq2UG230tH4wDc3h18suZC3ypKZLbCMBrCaCKJ5Wibi3IY7JfNAGl22H5dlosnfySin3GkJH10Du+qql659FoXoNusJBganz5hmdMS4kSNgv8Jy44f2JLdpgay3m+tcgYUIuRbCkid76TgnRPzr9sll4SjyaG+lgQ5QMesw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HUecmt+nSkaSY3R5+VXxthBovsGOjQGo/OMIDun1hKE=;
 b=Hw5pcL/tpqfF0b74W8Ma/wQaMujSpMp2DxAUFi/ju3GVZyAtkjrXFKllwei+r8D1th4iRVjtGGPfwcMFkLV0RBdzQJyxsbwOobwFD9chna8NPDOqkZvxfRWoxyqJkPwa1PDqaxe2WpaJuCpVrfel1wB0XjLurtdcP57XLrc3Q7c=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by PA4PR04MB7824.eurprd04.prod.outlook.com (2603:10a6:102:cd::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Tue, 18 Apr
 2023 11:40:07 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b%5]) with mapi id 15.20.6298.028; Tue, 18 Apr 2023
 11:40:07 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH v2 iproute2-next 03/10] tc/mqprio: fix stray ] in man page synopsis
Date:   Tue, 18 Apr 2023 14:39:46 +0300
Message-Id: <20230418113953.818831-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230418113953.818831-1-vladimir.oltean@nxp.com>
References: <20230418113953.818831-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0501CA0003.eurprd05.prod.outlook.com
 (2603:10a6:800:92::13) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|PA4PR04MB7824:EE_
X-MS-Office365-Filtering-Correlation-Id: 8e9230a8-6bad-49b1-57e0-08db4001a8e4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ypKj3VNsMIBerlhP8UUOnEBMCQcqAF/oE/9gCuc5rqmaPFXmsUaBiVAwasrvQK3VdM2T2gS0RmAwGHRjezWDoLXbiiQvkeVOBhg3AeDzkdvay9j/e6RLbBx5CQLfBi8rddpF/eUnf9dcAui+thgFOI5803G0G9PSMIjidE9olQZV1v3PxgdJEJONznRWj6XoODUO+tGqqVgvGLQzj966pAa3dV6vUmUZ+cxM6vwhD5zctudBNmrtgL9e3aQJzr5paHq4KQE2xiDs3bsyg3srANWStY8CYrfnrv4riZJiWwNehqvgd+ATENJih66mEaA19ly/oM/UzYjZaXoL5Vapepaa3SqnbrWrI1PbLJu1gWBC3ykxwx9Er78wouE+QFtJkK2VjpxubSzWREajBQxUY1GreKyWkaVRYAoefwd2XwzfciL8utj+S6mYpoafFIc4XiTjkUelp0i/SzZkyHr0XUgDB3RkMfawo6I36YRE87Q9cj50q873UemERh3oAiVaf3Msa0dE9/x+G5zdx+DaD0vwpHMPvK0rSawsny8k/tpZXdi4i5dMMiLEMHXr/mx0oIFUuJTsucVlwseDEsLyw/G2hQ+q8E2Qp4rgz5bTtCx/gR5OeZ+c7fu7UYV12wmf
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(136003)(366004)(346002)(396003)(376002)(451199021)(6916009)(4326008)(316002)(54906003)(66946007)(66556008)(66476007)(186003)(6506007)(6512007)(1076003)(26005)(38350700002)(38100700002)(2616005)(83380400001)(5660300002)(41300700001)(8676002)(478600001)(52116002)(6486002)(6666004)(8936002)(36756003)(86362001)(2906002)(4744005)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9xYRmWrz8JbH+VBgIKHwuYNHOawdr6QI0R/WinmGUyeKKSRoL+tC2p1/CMfp?=
 =?us-ascii?Q?lPrF/4Sfl6YNXmRYA5FEp8PMiFDwB8d39TRhYgdmYrFnHHAulTMe7qIP77Cd?=
 =?us-ascii?Q?0PA/7VAS4ZAdLntAwxemm7UkrN3X+68J2IbFc23DQrEM5GipjLOcUf/HbCMf?=
 =?us-ascii?Q?83Yxyh8MjM8JUl+awMKl7hjpH6DwLUCYDuShYJEUMkyUZ/Hmp5AVpMREN1Vc?=
 =?us-ascii?Q?pP/iadxj5qZAigiRQoMltBLgu3Of3TkH8lX+cowdeeBfjMo1zfTPqVCj2GL5?=
 =?us-ascii?Q?bMlMoB8W1Puz+sXewtvSxtdYtf0PjdCw+YmJg+DIdcOQnkM2kLsQ5CmFAnm7?=
 =?us-ascii?Q?+Kf0+1++z7sG0iSESahetWh37X+R4tPmBWREtICeG6WFmhlBC4uYOR3m9Z1J?=
 =?us-ascii?Q?/W4YRZOcy9JOgOYJHb5+ts+UeIYK45nBGPFPxwBXK0nuAyJvIzK3nPAw3OUQ?=
 =?us-ascii?Q?GaeZzELnVrroNDtP3ty4Py3zA55Hh5vtXkJDhW3l5yq8QIpK6yDJ7DyFiW/i?=
 =?us-ascii?Q?pH5PUGBAA+0WPgOIpIgipk5fZCE/68xMVNNGLFsOLpeOKm3RW4hGuMPK4/3u?=
 =?us-ascii?Q?PE7vf+nr6ZFFt2T/jaZ2S+HoLvRMc102XNEg9lwyX2+egCglDYPN1FyQ0A7E?=
 =?us-ascii?Q?RFAgB/XNO5OR6p8iW0oFXPsyX8XAdJQ3VlFYXGOZZOMM6AZ7O7td/G22fUSW?=
 =?us-ascii?Q?BQFVKpQDgaB95xyZiXG3cfp/mmBjS5Mall03ZPxM8rNe3VPLMBsJsYkmU+n/?=
 =?us-ascii?Q?ht/MfsPNFLjCesgcC4c/wxfzpLOgtXA3K/G7NJy5aZD36IqAMxfmxDLS5eaM?=
 =?us-ascii?Q?ZtFVle2+HLXiUIo6TgmnwXzghUSe6o/zC0BWSeZIxoSjdori/g5hjDGNOvwF?=
 =?us-ascii?Q?mtLz/he8UsxG9uJ+XIm51rBmA/d3SMuGWJ3pd6dVciOzMmG/irGgweLGn1LO?=
 =?us-ascii?Q?ITNIy5uHbpPqLudAd/lhe646tBs38KjZE7zLGJYA33Ptr8bzjerjMJlLj2yC?=
 =?us-ascii?Q?0em3B/aRNognXmB1WHHzKD3d+ag3Kmk2Us+PDfwIH0C/1knXx0saxGPKkzPD?=
 =?us-ascii?Q?iSPLHGwPsCd92nFtvu/GXYHvW0qoulCjWtJ8yRcI0AL4LCk9xo/LMjv0QVT/?=
 =?us-ascii?Q?aqIn0Id9xYMrflNwb9kdi7i1iZPGb//czeIeHKMblb6VSXm8EaMQ5ZnkTz3j?=
 =?us-ascii?Q?wipaxTdt7LiHdLnp0Pa+0M7Chc1TtTR3A50/8d5P0fy6T58AGkefH9Ty6uVd?=
 =?us-ascii?Q?3qGV7Xj52ec2MECzADs579KB037eK0am2VV9bm0Rrjdyw/l9cqzRPRcNd42r?=
 =?us-ascii?Q?bxVrECJvvdNsn3+DMLVozxaAoZdkUvHAmBidUV9stxmp+pHYUd+tUSHBy+Bc?=
 =?us-ascii?Q?OtKb/8C9wTfVsFzFBuJeDIdNa0FNZntFAa+4DHcD3XxyNe5OSn91VNC3Dqb3?=
 =?us-ascii?Q?Xt2tMUYWW761b7DilG3kQMBq2FysillB2OG6t0eqjHv6UnhYA2tQedruNLrm?=
 =?us-ascii?Q?g7v6LWshCz2JTLK1AWdQallbXw5NaL4XgNJ7AqMLzyqyrrooQxasTgPowhfh?=
 =?us-ascii?Q?wADYtW1HJueyDb314U1a4zax0QNvyjhwT1OHGMMFFTz8ojvLmuWoMzdkxgys?=
 =?us-ascii?Q?mw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e9230a8-6bad-49b1-57e0-08db4001a8e4
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2023 11:40:07.7692
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zOkyVTX2yuBqHMLe+RVI/awQ8/L+uuazeAQW8dzDu513mRiE7UDHxZWhJytHOq+RETznuE+dlkl3icm3vxnnKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB7824
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The closing ] bracket doesn't close anything, it is extraneous.
Remove it.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: none

 man/man8/tc-mqprio.8 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/man/man8/tc-mqprio.8 b/man/man8/tc-mqprio.8
index 16ecb9a1ddea..51c5644c36bd 100644
--- a/man/man8/tc-mqprio.8
+++ b/man/man8/tc-mqprio.8
@@ -17,7 +17,7 @@ count1@offset1 count2@offset2 ...
 .B ] [ hw
 1|0
 .B ] [ mode
-dcb|channel]
+dcb|channel
 .B ] [ shaper
 dcb|
 .B [ bw_rlimit
-- 
2.34.1

