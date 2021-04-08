Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA58D3584EA
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 15:40:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231637AbhDHNkT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 09:40:19 -0400
Received: from mail-mw2nam12on2060.outbound.protection.outlook.com ([40.107.244.60]:43552
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231795AbhDHNkQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Apr 2021 09:40:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jF8TZfv5dGzOpa5bHhgqHX8wap17ydUntflLc8J+wI6O9o7UNl+EmzWVvBIfNGIR9rImLC6Appv4oY6LznY7Gv2G/OxsejE0PuNyMX0uZfdZOGqBx5lFn+Mehf2GhHKBxs0RZs1SC7vD0y9E1Jh0uzpYt7C972c0d4Ssor15GUl9Ne0oQP5ANBwh20XXz4HgxOo4QrE9JNskiT3hBY7WRf83mQaAQ6UM4HsolrQ6G5Ya//NfUrbo18mV2WHgN9NACFuF+YfKlWncXycA2JBA7h2kCbybNd8kf9lu5bIPH3i5WCOLImj8QQjujq2UmuchzoI/1pD8yNzGE8TYnsi1uQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XI/7TKI9bjXtRgi+mfq/fGYau9oENFEOuMwetmyb9Tk=;
 b=flsaet4Pk+KK1PHhO4Nnmut+yhrEIxRjZzkqWnn7p8zaD5dqdNL8AIAX46YfWf5d8N9aKbyZTrQLl3V3AsoOZdEnJVg5t0Jx3hA1jKbHYgtdELr/RtLAOxePrpVjKRBaIN/OkYfTixij+AAG4FwEADN0ZYBkv8ZpEF2w6y4BSPbJUekJvHXGEcrJ8yF5g9FM/IFQpCZSb4A42epoF3KNZ49WwraIcdyI7QmB+V9Ez8o9YVrZnJlH3ZwiKRU2EBE6l6t18oSMnG1ritqV+NjHZaXabXIRRr+/SllUrb/jy/JnKvBRwlnpIrO1vxlJzMr3LYagRbNyLh7Xu/U9V8qWJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XI/7TKI9bjXtRgi+mfq/fGYau9oENFEOuMwetmyb9Tk=;
 b=O3DYbNeiVBsbgLtMbZ/OgioarVOeAZr6mW6kH3RFWGd50xJXdb0XWgSAVRSKhMHR6RSH12zcrQP1720M7TyuUNQ7Q/nLMk9FEpLkLoR1batvBebEHScq28+2lgxEwK3K1I5mHuZF+hUbjxMhYNL1cKZhj1yETnAnUlUvMtbpHTSgfEDkwUFhEpY+uCgP0gGAplDMZeikbLBEt+Z7Pa28pqG8gXB73njOiuCyqdZWcM7cbNXB2e3GF4GVqFhram5o6RusCWk9tY/uzI1fVIienkJb0yKAX5zJv2K9TmrCzPxjzISSofhU1nhWT6+kZ3nRkWZodn9tqsC8mSbJTngz7w==
Received: from BN6PR22CA0047.namprd22.prod.outlook.com (2603:10b6:404:37::33)
 by BN6PR12MB1331.namprd12.prod.outlook.com (2603:10b6:404:17::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.32; Thu, 8 Apr
 2021 13:40:03 +0000
Received: from BN8NAM11FT021.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:37:cafe::8b) by BN6PR22CA0047.outlook.office365.com
 (2603:10b6:404:37::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16 via Frontend
 Transport; Thu, 8 Apr 2021 13:40:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT021.mail.protection.outlook.com (10.13.177.114) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4020.17 via Frontend Transport; Thu, 8 Apr 2021 13:40:03 +0000
Received: from localhost.localdomain (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 8 Apr
 2021 13:39:59 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Petr Machata <petrm@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>
Subject: [PATCH net-next 3/7] devlink: Add a new trap for the trap_fwd action
Date:   Thu, 8 Apr 2021 15:38:25 +0200
Message-ID: <20210408133829.2135103-4-petrm@nvidia.com>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210408133829.2135103-1-petrm@nvidia.com>
References: <20210408133829.2135103-1-petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1330876f-bf18-42bc-1b8d-08d8fa93d052
X-MS-TrafficTypeDiagnostic: BN6PR12MB1331:
X-Microsoft-Antispam-PRVS: <BN6PR12MB1331006BA6F3E67276E0FF68D6749@BN6PR12MB1331.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2582;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +epNI/iiojebvAJgQRxn1rTorZ4jjWIiWWRobXGkGAVKNONNGjOs6J1MTiBkib3iTMbLZOC4kRQJNHz7GfBh293v+2rdezbJO0sJ9wjeoMQUPcYhyJtMSoQimWlbvDcKZsqsTP77hA+CC7i7z0DQc3eodWE2dtsZgJex3zZEcHXWtl6apftVf3hFsrkqFHVmsVO3An/wTKBcgiropqOv3Es3v2kmgqHsUmlz+WqkYHz7QcsDjeKEphwFZuTSptGo+zXijSmFxskIP5ub1LoCK+7kAr8xg6yQUZksmfI+uA+xbQAx9dD8ItsXPNo/iiaLZSQkARcApYo1cVb7qE6Vbpap1JlLeX73W72UDvsH9uKsXHBDAPB2yHkp+czMG68liGnV16j8eON0tnwFtxbCVGL7df9a2otgKodsumk+xBqBKpMAj5uUnD2cv05y/hH3KZAwESBQMKsj8eQQnwrpLT7VAZWumTLb+0R4BWVQq5MMnSLwxl/Os1WS2PTkWt/JI9LhiUHdBT/YAea2n+iK12mJlxE0qwj+brArRMOC4P8J+ZOvZK63U0EgFwYETur3VnetK9XhqmFG79YtAfh7fE0d7JxiftH+7+3vIyWiTh2nELplzh7yGdlTkUiCVQTwa12VHlBQ06UMM59BhJIs8g==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(376002)(136003)(39860400002)(346002)(46966006)(36840700001)(7636003)(8676002)(16526019)(82740400003)(54906003)(2906002)(6666004)(6916009)(4326008)(8936002)(316002)(36906005)(478600001)(1076003)(2616005)(336012)(70206006)(36860700001)(70586007)(83380400001)(26005)(86362001)(47076005)(356005)(5660300002)(36756003)(426003)(186003)(82310400003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2021 13:40:03.3364
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1330876f-bf18-42bc-1b8d-08d8fa93d052
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT021.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1331
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new trap so that drivers can report packets forwarded due to the
trap_fwd action correctly.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
 Documentation/networking/devlink/devlink-trap.rst | 4 ++++
 include/net/devlink.h                             | 3 +++
 net/core/devlink.c                                | 1 +
 3 files changed, 8 insertions(+)

diff --git a/Documentation/networking/devlink/devlink-trap.rst b/Documentation/networking/devlink/devlink-trap.rst
index 935b6397e8cf..3f1c0f89d284 100644
--- a/Documentation/networking/devlink/devlink-trap.rst
+++ b/Documentation/networking/devlink/devlink-trap.rst
@@ -405,6 +405,10 @@ be added to the following table:
      - ``control``
      - Traps packets logged during processing of flow action trap (e.g., via
        tc's trap action)
+   * - ``flow_action_trap_fwd``
+     - ``control``
+     - Traps packets logged during processing of flow action trap_fwd (e.g., via
+       tc's trap_fwd action)
    * - ``early_drop``
      - ``drop``
      - Traps packets dropped due to the RED (Random Early Detection) algorithm
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 853420db5d32..967e70363ba9 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -845,6 +845,7 @@ enum devlink_trap_generic_id {
 	DEVLINK_TRAP_GENERIC_ID_PTP_GENERAL,
 	DEVLINK_TRAP_GENERIC_ID_FLOW_ACTION_SAMPLE,
 	DEVLINK_TRAP_GENERIC_ID_FLOW_ACTION_TRAP,
+	DEVLINK_TRAP_GENERIC_ID_FLOW_ACTION_TRAP_FWD,
 	DEVLINK_TRAP_GENERIC_ID_EARLY_DROP,
 	DEVLINK_TRAP_GENERIC_ID_VXLAN_PARSING,
 	DEVLINK_TRAP_GENERIC_ID_LLC_SNAP_PARSING,
@@ -1053,6 +1054,8 @@ enum devlink_trap_group_generic_id {
 	"flow_action_sample"
 #define DEVLINK_TRAP_GENERIC_NAME_FLOW_ACTION_TRAP \
 	"flow_action_trap"
+#define DEVLINK_TRAP_GENERIC_NAME_FLOW_ACTION_TRAP_FWD \
+	"flow_action_trap_fwd"
 #define DEVLINK_TRAP_GENERIC_NAME_EARLY_DROP \
 	"early_drop"
 #define DEVLINK_TRAP_GENERIC_NAME_VXLAN_PARSING \
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 737b61c2976e..478d4bc01a39 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -9744,6 +9744,7 @@ static const struct devlink_trap devlink_trap_generic[] = {
 	DEVLINK_TRAP(PTP_GENERAL, CONTROL),
 	DEVLINK_TRAP(FLOW_ACTION_SAMPLE, CONTROL),
 	DEVLINK_TRAP(FLOW_ACTION_TRAP, CONTROL),
+	DEVLINK_TRAP(FLOW_ACTION_TRAP_FWD, CONTROL),
 	DEVLINK_TRAP(EARLY_DROP, DROP),
 	DEVLINK_TRAP(VXLAN_PARSING, DROP),
 	DEVLINK_TRAP(LLC_SNAP_PARSING, DROP),
-- 
2.26.2

