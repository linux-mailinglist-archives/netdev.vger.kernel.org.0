Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1428C6641E3
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 14:32:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238281AbjAJNcD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 08:32:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232892AbjAJNbb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 08:31:31 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2079.outbound.protection.outlook.com [40.107.100.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85D6C2DFC;
        Tue, 10 Jan 2023 05:31:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ak2kiobU3HY2xj0s+iWdfiOJKtzmKvdKNzf653u50CEj2VbZ3Q4OgZgktFfHiNBtwuBwEpLtmutP6nF4Ptx3MzUX064LXh4C7FT2WDnDQrLI2MViMmNS3zAiJVnnFhGOFrKRDIKXWTEGTm5IKu7BIkiTWUXfIlMzl/Wbl+FTgeY1q9dW9zItHB0psbH7uAakKqPIlp5g0QGpcKZt0c5Yjg2hs5rVYanu0+fHhDjCCcnWMPumdPxORigJhBXRB+OPF7dFL1mWFN0vyY7Ex+Py8KtsKoDMlfROg7/WSl1tRMS/VMyWH/8s+X/vuoIYOKdaWOisYpVAXgv+jDebzzNJdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ciq8UUN0gvkcFTVqiQIpLh1OYypUHTPyPDDSQWDbzzE=;
 b=AHAKCqseNgi0hQZuJdJ6AX9Ax4BNiGJ+l8mHAaMKvBHGR3UDHX9Rh2WcpJWqNxtcb+YUExKUog2EsZXYCmKomS+LjLHnuIhVYVFmDqJupZDxCor6BmRb/HLIX+tznMV6Z+8M1vRpSkFxuvxAP65CG1dqr2307rzsGjl5PX7N6JH7770dJtEKSO/BiSJzI1q4CmnKIxIuF2K7/pNhHOp9erfPodbwDBmPGR9hkpRJ0ToYAuX4G6DyI+gUA27yzdmv1GK6sqGjyDgYTmnMQcDpQwyt9NGEsZ0acMe9hflIUvBgmaemtyCdXU4s/7XpSJxO083UZfp5pv9uiRpmZTVG/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ciq8UUN0gvkcFTVqiQIpLh1OYypUHTPyPDDSQWDbzzE=;
 b=pSHuuGmsf6RuAzSMOn+thEGyKEXTHru2pgddTu2O98Cdb8u3ed7qbK+OaLg5iUE1I0AZ+QFADKlFJff/OoFeQ3ica6x1xt2ea+ZSNBXfNuZnD9m8WnnRRKyf3QoH6jiZamsFoLRlCG+CneOSO9wn/sQb45+fMptsVGxXgB9kQXpm1MvBwFlZZTUWfCMGCkLN8dQU3CJVtJkVKU/gxTjjb4b1RTMWW5V/aLNYsiF5qU7n7XxRtJbz+o7IS4AFrv8eDIZbMSQh/uEo6SZrcJUp/wj8ys/f4NTgdQmRrjs4tdcf0BnE8z+RZWxX7quJgb1Unc2tlsy0J/PPLP0sTF4dHA==
Received: from BN9PR03CA0596.namprd03.prod.outlook.com (2603:10b6:408:10d::31)
 by DM4PR12MB6445.namprd12.prod.outlook.com (2603:10b6:8:bd::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Tue, 10 Jan
 2023 13:31:28 +0000
Received: from BN8NAM11FT052.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10d:cafe::8d) by BN9PR03CA0596.outlook.office365.com
 (2603:10b6:408:10d::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18 via Frontend
 Transport; Tue, 10 Jan 2023 13:31:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT052.mail.protection.outlook.com (10.13.177.210) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5986.18 via Frontend Transport; Tue, 10 Jan 2023 13:31:27 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 10 Jan
 2023 05:31:06 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 10 Jan
 2023 05:31:05 -0800
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Tue, 10 Jan
 2023 05:31:02 -0800
From:   Vlad Buslov <vladbu@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <pablo@netfilter.org>
CC:     <netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <ozsh@nvidia.com>, <marcelo.leitner@gmail.com>,
        <simon.horman@corigine.com>, Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net-next v1 2/7] netfilter: flowtable: fixup UDP timeout depending on ct state
Date:   Tue, 10 Jan 2023 14:30:18 +0100
Message-ID: <20230110133023.2366381-3-vladbu@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230110133023.2366381-1-vladbu@nvidia.com>
References: <20230110133023.2366381-1-vladbu@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT052:EE_|DM4PR12MB6445:EE_
X-MS-Office365-Filtering-Correlation-Id: 3f035816-a9f1-4832-a842-08daf30efa0f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: g6sl7L2IkJgOhSTkr85M8bNH3BwQYyLm3R0jLyI/o9J66yvH2UaQ/9yMLdK5iSi6aKwj/hV+eigtqYYuXrDzaS5FBY42Zi1IfphLxCceKPuPr/35qIapsbGfdXU4RGcG7o1Qr+nQOZuyUIVsFuM0uRKuBOqh8fNpA3rEKZQzBYyZc66ooe6cpi6iYwXyZW1mmeBxJ346j/OFUHhOfvy3ZCLQV9lPAEmfxuqhFg8pZ9ZRY7Deyk16hk8tKfVBbNwQFk07Yl/Gik9AmSrIFhAPWz7CCIpCTigqIkvZ1gNCs5vRdVYDzkczcwh9zyokuGE2207NSD81ppjus9y+f4nsB9FiQDuVGFhswHTIocwBRReyAyL8IHbBG95VQJiXni5KSLZxzz/FS/vTNwncd5ANCFVn13WmiheRYVDyqsQgvCHyAG+NJfnWDKnmw5045+24bYN4axpCeLi6Gg/t1jzs2EgL2ewGlhpDHBEDWFf3dlmFNUg5ia2TMJcgBAppRXrpK1OQop+7CZiPw5/sXDRibDf4zbweMAo5aXRcYetK0nNeUMi2uKK9MATEWYx1V+N0luuLO8KiSt+gBNat9LQkz0w/5I7l2a11AbHvFtFTtRJ/CJ5/CK1sc7uIQKpPmDxso57m0nRKvl3cYgFGCmuDnzyjkXQV72E2eV5DTc3JWNVAnBP73k3BiZrV35dF0CtRYiaSaP5HFv9dskZA7y+3nntBgNrgMKDZ7ylB0O6jq/k=
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(376002)(39860400002)(136003)(396003)(346002)(451199015)(36840700001)(46966006)(40470700004)(2906002)(82310400005)(47076005)(83380400001)(336012)(36860700001)(426003)(2616005)(1076003)(7696005)(7416002)(5660300002)(40480700001)(107886003)(6666004)(8936002)(26005)(186003)(36756003)(478600001)(7636003)(70586007)(110136005)(70206006)(54906003)(8676002)(41300700001)(356005)(86362001)(4326008)(316002)(40460700003)(82740400003)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2023 13:31:27.4737
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f035816-a9f1-4832-a842-08daf30efa0f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT052.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6445
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently flow_offload_fixup_ct() function assumes that only replied UDP
connections can be offloaded and hardcodes UDP_CT_REPLIED timeout value. To
enable UDP NEW connection offload in following patches extract the actual
connections state from ct->status and set the timeout according to it.

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
---
 net/netfilter/nf_flow_table_core.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 81c26a96c30b..04bd0ed4d2ae 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -193,8 +193,11 @@ static void flow_offload_fixup_ct(struct nf_conn *ct)
 		timeout -= tn->offload_timeout;
 	} else if (l4num == IPPROTO_UDP) {
 		struct nf_udp_net *tn = nf_udp_pernet(net);
+		enum udp_conntrack state =
+			test_bit(IPS_SEEN_REPLY_BIT, &ct->status) ?
+			UDP_CT_REPLIED : UDP_CT_UNREPLIED;
 
-		timeout = tn->timeouts[UDP_CT_REPLIED];
+		timeout = tn->timeouts[state];
 		timeout -= tn->offload_timeout;
 	} else {
 		return;
-- 
2.38.1

