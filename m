Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59A0A693788
	for <lists+netdev@lfdr.de>; Sun, 12 Feb 2023 14:25:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229524AbjBLNZ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Feb 2023 08:25:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjBLNZz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Feb 2023 08:25:55 -0500
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2055.outbound.protection.outlook.com [40.107.95.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3A96E079
        for <netdev@vger.kernel.org>; Sun, 12 Feb 2023 05:25:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E/ur7c3JKRE1QAPLL4hQwJ4v4qxwQ1SecyNt8hJDbS9/Z7/vjq9AzaBBUOoJmcSrsalER/LmHf2PuDtg8FheCh/BL24fTCEENIxE2J9sRalzx8LTnIZEg7F3fE+Y0S9F+nCsV539Bv/8QPYK9Euv3169EOMI+tDCJ1nwquC00NPEzr4gAgRuYx1zQntolVVfyKIqh30XmR278fDcDhehlqB+55Lbq3m+oR4Q6YLDGYRvw9YCVx8r6pWEwGODIZ+YGrTDZbQGKUjM1mdP9ETqKORiHOoBc/DrqUANPGXrdcNoEm5vFaUYv8a+cNQsMLUTCpVpnb50MYTXjtadI9gjNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i0LE/4kK4bVON/LOT6Vi+6cHXJ9Ccbk/SBeieH1qSpI=;
 b=XjB/oF6xLf/nY1E4mMdznUQLuH46HFgWPvOUIhucHrZIVChHlGJwTzNiiPXmXSO+4rauOKlczUbAiBRbMh7ZlTtcgX0PdQ7IuzSs1GDZjUIdawPd7gcWQtZ/z9QLVQeTUbNYZDS5pS+stvdEtg6yNF+OU44CL7g5fwpeshOS6sx+xD6BgkYwOTyZqlcaXFNdmpO379OoBNaF3TIZQptNRtq15L+BvZB0MpYav7xPI5ODg9dX4ZQfwJXXn7acXG7Frr7tr1J01OaxqSYBznlJ1SirbVCeFqvFAAcr7b6l8xsbKxTitYMr+qMcfR3DAIGLoFkOU+XdH5zDvZWlmDhKOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i0LE/4kK4bVON/LOT6Vi+6cHXJ9Ccbk/SBeieH1qSpI=;
 b=EZixebqe3dhoTCs0upVyvKbWqLSHZav+mftWn2pGerO0/yD6hcpYE6ZB5t384o8xeOP07bEmUPG23u/PUEGmb9kHRjsmUyneUpZkiCE6p8+oyeoc+u1Y7hTZJjGoZ2X9fDPna9/dG2YAthFrH+NZLEN8R7EWYzSJNbUDYSuZkZn1pnmyjoPtPOFA3D69oW+yRsK8/wWWyUMWT9e5uvbrixJErRaIberLq33OJXy0ysHu54DZCyCRHN7wCMZ6glHjapggZSR+6x40FUriEs9lKUfMZEFUPJD3G4D9pXyFIihBvD3UADR0AM+KxDRxDRSRC/xDd41uFYV37J9JCE2j/g==
Received: from DM6PR08CA0046.namprd08.prod.outlook.com (2603:10b6:5:1e0::20)
 by IA1PR12MB6019.namprd12.prod.outlook.com (2603:10b6:208:3d5::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.22; Sun, 12 Feb
 2023 13:25:53 +0000
Received: from DM6NAM11FT044.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1e0:cafe::91) by DM6PR08CA0046.outlook.office365.com
 (2603:10b6:5:1e0::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.23 via Frontend
 Transport; Sun, 12 Feb 2023 13:25:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DM6NAM11FT044.mail.protection.outlook.com (10.13.173.185) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6086.22 via Frontend Transport; Sun, 12 Feb 2023 13:25:52 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sun, 12 Feb
 2023 05:25:42 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sun, 12 Feb
 2023 05:25:41 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.129.68.10) with Microsoft SMTP Server id 15.2.986.36 via
 Frontend Transport; Sun, 12 Feb 2023 05:25:38 -0800
From:   Oz Shlomo <ozsh@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Saeed Mahameed <saeedm@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        "Jiri Pirko" <jiri@nvidia.com>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        "Simon Horman" <simon.horman@corigine.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, Oz Shlomo <ozsh@nvidia.com>,
        "Marcelo Ricardo Leitner" <marcelo.leitner@gmail.com>
Subject: [PATCH  net-next v4 1/9] net/sched: optimize action stats api calls
Date:   Sun, 12 Feb 2023 15:25:12 +0200
Message-ID: <20230212132520.12571-2-ozsh@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230212132520.12571-1-ozsh@nvidia.com>
References: <20230212132520.12571-1-ozsh@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT044:EE_|IA1PR12MB6019:EE_
X-MS-Office365-Filtering-Correlation-Id: b8d1751c-dc5c-46f9-6eba-08db0cfcaa0b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TSlvtfU8fziw5rvQ23IBKcDl+nP6ykx5jtQ0HN4/YEbV78GgAxrpoKjWsUjjI78G2UG7Kk21mOv25u/Z4BMMIXCJeSr3GNkeAhvwpOdv3Mw/4j5olqYSZluKRPXs/Swa1MO41P7O6laSD2Ia2oD4Bhj2T3bCDg4TaKi4fWlPWB2o+UNPW8I/nyyKX/lvEOgp4gCN56vlUCazP6+Ryo1aa4strQAfB07ueXKCIly4XpVSaqVERUcSVKXwd9tfMFCafHjLhmUYy4N3GCspHleY2p3i2LszWQMfDpzyLBf2OPCj8A5bTSAuYBPHruIuE1RU9GtEHaONiTXFBj2luJ8DlIC1N6heb1NUzji5CGw3oLVj/FR+q7t2G6K8P/Psjby+9QO08r1WGVKNHJxnNcKxv9e2AyuJ6egzb/jajxaT1AHES9S0urxHyN+tJk1IWd65CbyKPlPN2htRe8xDGIyydkRtiacaHX7apeVR9ofN7CimPBqS4IVj5mYDWvZdxpl/jlUW9/8Tvm1BrVmdtNJ4Do5hf1jzNgywbfplAYDShFJbXJvzvRC2l39hq2LlfmlylHQ0APAAPHDUIX/n3itBbPtAwdiknnx+HPKmmcB//0jsKyuEwa6vCAww43evk6KjWVcW9+MdaOoKh0ZL0uoFjXrxlYpRcD3TkxaNJEku94L0Xh8Ra1XhqO/s+T1Jj/oolBi7zzhOjqtkNSdlBHJiGw==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(376002)(346002)(136003)(396003)(451199018)(46966006)(40470700004)(36840700001)(1076003)(26005)(6666004)(186003)(478600001)(47076005)(2616005)(336012)(426003)(86362001)(356005)(82740400003)(7636003)(40460700003)(40480700001)(83380400001)(5660300002)(70206006)(2906002)(41300700001)(8936002)(4326008)(8676002)(36756003)(6916009)(36860700001)(316002)(54906003)(82310400005)(70586007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2023 13:25:52.5662
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b8d1751c-dc5c-46f9-6eba-08db0cfcaa0b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT044.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6019
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Reviewed-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
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

