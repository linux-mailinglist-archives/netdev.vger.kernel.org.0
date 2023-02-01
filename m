Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9394B686B39
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 17:12:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231685AbjBAQL7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 11:11:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230200AbjBAQL6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 11:11:58 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2040.outbound.protection.outlook.com [40.107.223.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8352265F3D
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 08:11:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g7zTLtUlh/DGRlRaCGS8FKdBHpakz0BCXdFlUPjQ7rFBBTPN/01i35J81T5z4TUVSR5t+zGnCzajqrm4C9I67GVcQbIRgBD4PIoxNscvM7K5h6zcqPCeka2DSpcBR7t0HbBaSuc36m0Xzp/xeG0+SM/2oGtbA3kPFSfIdSnkI7xSPr/br4AyXbl+cecsfrrs8QrQEhf3op2eY8zSNTZRKUAH9oWpxLejlolDWWScANPu42anY+aM3pafL07C/RMTKV0ZTKYZ+jc8A+muzQodWDLsurHSU1smxzLRLl1I1czVRbav9KGrkuT9jGZUsLLcDM1iA7gyWs3o8YzbgGI5xA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Yp5crgyHSmpk8i9WC8TruC0Bu3MCMUwxBQJ3c4bwZPY=;
 b=RjiOd1WhP4r50HJ1X2lo1qMukkdLuCThWtrM6q6baT0JMrGUq65OuUeMX6CIhWo7bn9xql+Qnqk22BrDwiEn4eVaaVZxndvFYE34TsiFcqhuNdkgKmbmqGXtF60sYER3rT984g7N9TYYdPtXR55nN7yhHDEAIzc7G8CdnW9EZVzcJQSgYF7Kbt/Pb4xOHE7QzgX2fvdIUW3LXrqe5AKETGzkP7rqQfYXR7x3xj/kB2pMgjdx3bZNP9+lVPuwzEtkFLqy81fpJaQ32uVBKaKeK8PgEOy3KXK8LweSjYwUQ7pR+OKyzwc2GYJRe8BW+vrajXdqBDjav+tXqxlZuL1obA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yp5crgyHSmpk8i9WC8TruC0Bu3MCMUwxBQJ3c4bwZPY=;
 b=mQ6FoWa9uekwrfIVSh22i5SOWdMEZshFCkbxbUYUQk/FRBjEMjDaJ0KOhjkGGRumj1RB1UUikZTTMJmpO6Ip31QHI0DxPaPkU+qBGA1kH7bVv08g/sZkaOjNVjZrp3U3H9HgZHli4/4MfQCV9yohd0BXntC6up4EVqlifvG+axTCreR/IxW2BmvhIsnF0HfpOwnf0rnger+MJRAmMQPqd3pWOkTSzSojToi1Hhwb8OtICvuyQJx70H8XfZW2lfJjMWfl49Nqtdn5RgkVZ9hKKs00dmABwTZPTQ4lxZMC6OxR9/06PSUci+0cElGM67Ga/9ueJxLC3DBear9G5H6fDw==
Received: from DS7PR06CA0024.namprd06.prod.outlook.com (2603:10b6:8:2a::8) by
 MW4PR12MB7384.namprd12.prod.outlook.com (2603:10b6:303:22b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38; Wed, 1 Feb
 2023 16:11:54 +0000
Received: from DM6NAM11FT062.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:2a:cafe::25) by DS7PR06CA0024.outlook.office365.com
 (2603:10b6:8:2a::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.25 via Frontend
 Transport; Wed, 1 Feb 2023 16:11:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DM6NAM11FT062.mail.protection.outlook.com (10.13.173.40) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.25 via Frontend Transport; Wed, 1 Feb 2023 16:11:53 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 1 Feb 2023
 08:11:46 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 1 Feb 2023
 08:11:46 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.129.68.6) with Microsoft SMTP Server id 15.2.986.36 via
 Frontend Transport; Wed, 1 Feb 2023 08:11:43 -0800
From:   Oz Shlomo <ozsh@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Saeed Mahameed <saeedm@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        "Jiri Pirko" <jiri@nvidia.com>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        "Simon Horman" <simon.horman@corigine.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        "Oz Shlomo" <ozsh@nvidia.com>
Subject: [PATCH  net-next 1/9] net/sched: optimize action stats api calls
Date:   Wed, 1 Feb 2023 18:10:30 +0200
Message-ID: <20230201161039.20714-2-ozsh@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230201161039.20714-1-ozsh@nvidia.com>
References: <20230201161039.20714-1-ozsh@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT062:EE_|MW4PR12MB7384:EE_
X-MS-Office365-Filtering-Correlation-Id: 0b9fd9bd-c294-4422-9efb-08db046f08cf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4i3nBF86E7rk5UecXdy6i37hPQccsckSWj7VWU/Tm5HnM6ukijih4aerDrCTlX8xMhE9CFnk+wgtCIVKpbQjTNt93VaSTfk01DdjwhdXIaCnudB5qycUEE+mkIuVbt/+uNdPM643fFCfjReq6cR/FJqnS4SAGB4WCquYwW7hTT3ZjJNrlnv96XafCNVqAzss/7aOSKT7yVKoJLkgvPPVYOpI8jACVHaz/aRRv3EIoj5jgFaAW2qjZBx3zutpkiZkXj/WF65XB1lFUyA3Izjy/gv/xTez9+1T0kc9hNqqdJaVcl9ainErWSBNzHNsD9qgL0G/OHfo0VZqlDQfDWSIPSnWYJaHdr7Gp/PQdQuV+K1iMb05SfOV330A/F4M6HupVSiGtugLoLLMjRdamNqa0Dn9XO4m1fkK/5A1dJHfG8Ca+aBKdht3RdFMYsiyW6QkXTxLnSWBw+7irfOaTbbivBm6QZhzR9Xhk5t0kkumxi8bdYyo7AcgEB3NR+ZT0RuJInA6E2oJTLTHM/ElaWprVtiBXndLOY+Xia1xKVwUoY+R1UgUS+ia56e9u3F5k2ZeAFs6UVaHTRVHjYG4XRWx4UBZ5Kox8tZ4b1saD5J8hp4vehzk2FGOWCToY+PQGxWyEvlm6eDQ9f3Xh90ictLyTJ/SulNoysQ+l4aGHLa360ck8H0Kd3tBtxxPCYlR7eclSeTFwv8AD1Aybfp1I1V4cw==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(396003)(376002)(136003)(346002)(39860400002)(451199018)(40470700004)(46966006)(36840700001)(40460700003)(336012)(478600001)(8936002)(2906002)(186003)(107886003)(6666004)(1076003)(41300700001)(8676002)(4326008)(70586007)(6916009)(70206006)(5660300002)(316002)(2616005)(54906003)(83380400001)(86362001)(82740400003)(7636003)(426003)(40480700001)(26005)(82310400005)(356005)(47076005)(36860700001)(36756003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2023 16:11:53.7356
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b9fd9bd-c294-4422-9efb-08db046f08cf
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT062.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7384
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently the hw action stats update is called from tcf_exts_hw_stats_update,
when a tc filter is dumped, and from tcf_action_copy_stats, when a hw
action is dumped.
However, the tcf_action_copy_stats is also called from tcf_action_dump.
As such, the hw action stats update cb is called 3 times for every
tc flower filter dump.

Move the tc action hw stats update from tcf_action_copy_stats to
tcf_dump_walker to update the hw action stats when tc action is dumped.

Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
---
 net/sched/act_api.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index cd09ef49df22..f4fa6d7340f8 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -539,6 +539,8 @@ static int tcf_dump_walker(struct tcf_idrinfo *idrinfo, struct sk_buff *skb,
 			       (unsigned long)p->tcfa_tm.lastuse))
 			continue;
 
+		tcf_action_update_hw_stats(p);
+
 		nest = nla_nest_start_noflag(skb, n_i);
 		if (!nest) {
 			index--;
@@ -1539,9 +1541,6 @@ int tcf_action_copy_stats(struct sk_buff *skb, struct tc_action *p,
 	if (p == NULL)
 		goto errout;
 
-	/* update hw stats for this action */
-	tcf_action_update_hw_stats(p);
-
 	/* compat_mode being true specifies a call that is supposed
 	 * to add additional backward compatibility statistic TLVs.
 	 */
-- 
1.8.3.1

