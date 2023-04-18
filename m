Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B06296E6010
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 13:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231524AbjDRLkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 07:40:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231175AbjDRLkO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 07:40:14 -0400
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01on2074.outbound.protection.outlook.com [40.107.14.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D494C4215
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 04:40:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TMw+yLhyzY11agnNbn9nw6yndalfxZVE2X7c5LFZNfQZnoEGidTz3SI9IKZZVKqu9OOOj++u6T2Ed3wfwvAsVhVJcgs/MHGjWs8AsrL0wprQH9en1UoS2u1l0S3Vy1muS0RoS+7/P7TITzlR5Ru/d/m1vcZK1b1PHibRUqrdYlDHSZUeoTLTSeEoAd2PtiCITlmbPuEh+O0D0xYQqiCo4Xel52/AwV2Fmrg9RsuVgP1355kPQjB0j+nz9WvWYbZFwAtTxR1JumAkA1LnOIlNdUC1gSlSy5NLNTAESnWZzyaP0a8QBO/wySvd92fRPJ7Z7U4dRbeHxI54loOEcYYy8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bBdOFlwPE0mTA1Ez6YflXy0jP/LSyYDVT9/kX8gwLSM=;
 b=moH9NKZR+LABGJnCZi/9WX2JrEYc7l2MzmdSI5L2Z+qhWYx4zMUaOefEaPZ3Z4MeTYJFXEO9G8WoUhds53Lt2y3/Dyb2AYOGyMN9w5erdv9O47W+Tjrd5PbIIr3vrSZmj9AKVAodgHh/ZyfQz/uKqRWf83SM5vHiwmKjU2gToOctcmvqOMf4gnzDbBw/DKeVGYPaA5afVu9PoBQKA64He/vmGiiCqgdMB/Jyfhbe/bj/mWX2ktFSpuweSQPss/ZMihfPqbMeXdvWYpLw0xFhBj/EytxVuoiKQxtNk5rSB7/gX4xnJkTnTBARVFotdyZh02NDeDCN5rWBo0KtilXYXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bBdOFlwPE0mTA1Ez6YflXy0jP/LSyYDVT9/kX8gwLSM=;
 b=Omcv+ghte9WSK1fHSkCriesnnLPrI2JkdISEQFpsGuHtKRtDSFwfqc6rmN5nfRjxZGhCcgBzUSDxfza1D6QRRLOXE+9cHoG7HEXIXQXUK6rnOhB3qtL3hxYIzipWGNCoRz32Z++a20VxgFCycP9iA0XPPbt9C3NI71czCxk0iY4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by PAXPR04MB8557.eurprd04.prod.outlook.com (2603:10a6:102:214::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.20; Tue, 18 Apr
 2023 11:40:09 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b%5]) with mapi id 15.20.6298.028; Tue, 18 Apr 2023
 11:40:09 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH v2 iproute2-next 06/10] tc/taprio: break up help text into multiple lines
Date:   Tue, 18 Apr 2023 14:39:49 +0300
Message-Id: <20230418113953.818831-7-vladimir.oltean@nxp.com>
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
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|PAXPR04MB8557:EE_
X-MS-Office365-Filtering-Correlation-Id: 57743141-501d-4bd9-ab9e-08db4001a9de
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 76drLe4XISJFwM528G5j+RXHc/TosYtJjp90PFzRu4romZMzy2u1obtRPjw9wLkyvUbf4Xw5HzIGG8b2u8HX14y+GTEkwGd/Mqlc1M/s0HyiY3Xyjygu5Vxv0I7eBuUZo5urDi7huf5BeUhYHrgfijB7J7NysmPAx42Eq/MnUiaNesV1b9w29N4rK/X8LJZsLRBg67CiIrm+cgyj0W7vgPCJo6DP0sX+SAXXXQtuHd69j7re4ZAB+8cKFM93uMxl2+9HYVnZWq5qOx+4XLaW3bG8iddjUHKxj1fJQKVFTOSbk3lkeQn8nfvcig3MFbdWjeMOiThrly9AXoE0z7y8nzl7TfkbkBunpue5grYIoh+iSHH/BzpZJTEZbKZuhrlhM6TdiJFYI4IJB/nC/qnbv3R6h/IS8VA0PF1CUedMwOnfylj+Mx8N98ddYXCo7EmQ12ZIxRLewjcLIJ5uMd62QrorNz0x6lSAsLqsXp5Ns1v4EvbcWRtylBb7qUOrzsukXTo49qUt9W72rXOsrh6BWiAdbE86KyOfsnBJbc1rCpbQCSh9W8xuxB/Hkjf8qeoB5Rpv2EF+aRNpu2tG0EbYDiXsGpLG+1R/DnsjH60xzbHTWv46zq9j5i80h6ExPLSu
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(39860400002)(136003)(346002)(376002)(396003)(451199021)(316002)(4326008)(66946007)(66556008)(66476007)(6916009)(478600001)(54906003)(8936002)(8676002)(5660300002)(44832011)(41300700001)(38100700002)(38350700002)(186003)(83380400001)(2616005)(6486002)(6666004)(52116002)(6512007)(6506007)(1076003)(26005)(86362001)(36756003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Iydy7PLaO9/lHsDFrRB+ATB+/chADKlcArIqY0WLstyDYzA3/Vh44z3k5OIc?=
 =?us-ascii?Q?VkN6HGuP4xGvfvX/ioqtN6MEXavkxMzTSnBDHgLjpNpTm7ADAekaj5QoygVq?=
 =?us-ascii?Q?iFylfePOjpeEJ+Of68JwHGBfkuHDE2uZMb2TtuGwZb88qsGOsVxWnFukw9BU?=
 =?us-ascii?Q?oWP4TZzi/ezt4TYU8W5LLYfew/tl7FuHl8EPTKnadvZwIJQuSFaohB0+04Vy?=
 =?us-ascii?Q?etwniK5aC03FB+RWLa2M+DLWhtLCe0gRoEGW0jPXr+0efBZiL0yqKCwES+du?=
 =?us-ascii?Q?uPP1vi9OcjvkmkZNRaDySHlkDpn7iUlE/xkYWVKeIEUqkHCm8VyKC3A3Z/PV?=
 =?us-ascii?Q?5JbKUZpNrvV8nGIuvk/S7uD/gWi+VjJGjdWYVqWt0ze55KlOGPma8UYBSDvK?=
 =?us-ascii?Q?uNXpApqMvW7av7xeSWhEQaC14zIpfUEs7nNPUBlxInWINAxjcIHMhUhVl75M?=
 =?us-ascii?Q?ed5kNXNPxKBXR47XvKJWNQy2ONjiPg06LCMQej8iSXDgkGHzngKRJtZEDy3+?=
 =?us-ascii?Q?EX62PZnNKO5jlZUI2TXbr3PnHNBsE7EamvKBLa4S8hT5/SEnfJOoJZGf6Ci7?=
 =?us-ascii?Q?WvMg4t4TXxt9XiEyjCq+QunmntbQ6Dzjnx7K4khCAOeer8LfRiW1c7LtGvER?=
 =?us-ascii?Q?O5pGnBJcD2UW/T+LQAnvhdMzD13dZ79ijQmUHA7arAXTO/9YsFo5hr1UBGNS?=
 =?us-ascii?Q?DCxiAOjdd/hxtHRdshIHSAtj0TTPgPWc+aLNIckg0UC31xGBXlHOEbrmsD8g?=
 =?us-ascii?Q?MGdZyqhomoJQWj6HWRCfTiLK6wJiDynsgGFoArFpDe5RBvfXMd1l0bA9qjm+?=
 =?us-ascii?Q?haw2ykNDz00xd/XtGpfXbqfGCh4IAwFNwg69dkwhIw9UyRePzJleiA+wHZ3H?=
 =?us-ascii?Q?Lq3ArRtF6NBHXC6cLwgj/NlLkeLlxwks9+TuM4o7J9bM8F9IcdTPNjPdDI7h?=
 =?us-ascii?Q?43zzsqq+0Nv2maKhG/Z8EQIanJOs36ZCCyVyLgYdjlozV8mw/OYOCc7mB3Er?=
 =?us-ascii?Q?ljK/Ftqj7+UpvmpnbkpH1rMoy/Y3jcfOgGMEjX8wkcEhvctit1wi447nrXnc?=
 =?us-ascii?Q?HKXcjMzLTLcxnev5pbGzCO5CQNw335JR5s3RO4lLH/r8kIpLTYFU1li3CV/A?=
 =?us-ascii?Q?RmH8Y1r8qVXlJK6K2O/OP1rVFxuEzm7RI2GTBORaRJSBA1sWiXxtEkSZo/u4?=
 =?us-ascii?Q?/jV+su+Lbps7UoENS17I9QN8CI0ysgivnfOU4v/Gp+pnse5buQjFol/seAjI?=
 =?us-ascii?Q?kkuhAlbLOdad++GoZvFNjBH8ejcET6tQk1/n8PCyTWV1tOG7gSIIVm3Y0mNm?=
 =?us-ascii?Q?Sw0CAyRRXHRh1sd0HU55EdWujbqelETIkk//JWbFnuKdSH7UkulYRj0dWTfh?=
 =?us-ascii?Q?oW8VTDHg8girzaKApp0BbI5XvK8l0a7L/a7qyYuTI2LaKaX9kPj9QiI/gUjW?=
 =?us-ascii?Q?nTjQNcEM88VuvLrbgLyJzUCt8oieUgu1TNBOas2R/VvbgE8AngkwgMxJIbJN?=
 =?us-ascii?Q?hKNo4cd4DJIK4c7HZIy+F7fVZu31aBUCvmtjM3liQLfvmLOSMT/hx4Nr026l?=
 =?us-ascii?Q?i7+mdc81AUbSo+XodrPuR8NAWoSfwwpdcvON4KOYavnauC8vkTkobotNNKhb?=
 =?us-ascii?Q?Ng=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57743141-501d-4bd9-ab9e-08db4001a9de
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2023 11:40:09.3604
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fesV+dFG9K1+8tVp9VlYfBA3ZNB3cgqPlglZ8pWGlNNaS4c7pOwhIHKP0O9yOBBsQvQOqIi+XGbaTKFMLn+A0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8557
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, the output of "tc qdisc add dev lo taprio help" looks
absolutely horrible, it looks better in the source code. Put new lines
in the output everywhere where the text switches to a new line in the
source code.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: patch is new

 tc/q_taprio.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tc/q_taprio.c b/tc/q_taprio.c
index e00d2aa9a842..c0da65fe3744 100644
--- a/tc/q_taprio.c
+++ b/tc/q_taprio.c
@@ -45,10 +45,10 @@ static void explain(void)
 {
 	fprintf(stderr,
 		"Usage: ... taprio clockid CLOCKID\n"
-		"		[num_tc NUMBER] [map P0 P1 ...] "
-		"		[queues COUNT@OFFSET COUNT@OFFSET COUNT@OFFSET ...] "
-		"		[ [sched-entry index cmd gate-mask interval] ... ] "
-		"		[base-time time] [txtime-delay delay]"
+		"		[num_tc NUMBER] [map P0 P1 ...]\n"
+		"		[queues COUNT@OFFSET COUNT@OFFSET COUNT@OFFSET ...]\n"
+		"		[ [sched-entry index cmd gate-mask interval] ... ]\n"
+		"		[base-time time] [txtime-delay delay]\n"
 		"\n"
 		"CLOCKID must be a valid SYS-V id (i.e. CLOCK_TAI)\n");
 }
-- 
2.34.1

