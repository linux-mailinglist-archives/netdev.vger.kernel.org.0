Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD239620DB1
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 11:49:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234000AbiKHKtQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 05:49:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233929AbiKHKsu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 05:48:50 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2043.outbound.protection.outlook.com [40.107.223.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D3F743875
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 02:48:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ApYoIDpzlVu+/uEwVYdup6it5vB1e/EdGR2xqQeVqm3XmW+fHDYv2bCfzsNFk96aL3jRKk2ntTy7ZbheaKvIzZBCKzBYFEsm7zp3haeAiEvkyJHSlTkSpL0kmOpMq49IWkKLCRnmSly2smVWOpnOh1M+3kRSvsMbNN4Jn7drAQTpJJo5WhxCZfi6T7BJrZEz9ClXiORnPveIh4a6lLJ971AzP+hgKIuWHV8CyQJpaMBNbXOx73v5meZRrIa/MfYM8KRpUntoOiyCc0AEGtLi/yRxMT5FLjqxpxOhBnvMmV31ohnbIkDsqexi26WZT6n4pCKPvDnWEkyjs56j2mhIog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=opczsBhp0qt6+P5dGe1iYcEVrDktjV1EOsuHM54Wmhc=;
 b=C0umVY6iJ1iML8461KForkhce2yNqdox9eJ2MBW4E5h2iGEI9+alGw0yurzvoiJJJrAR7WA0hlusH6NVC92yQLyXoNkRpD3ZVbet6df4azYO8vcSXidaE1SXT5L8CKXYo0UsTcfrFoy8QgWp94sGcHqR05aCKRcl7tZF2zgTY9gDDgBi0JLxovfB46B6eREFq1uAEW/9112f2Zgm7TvTZA9nLQl9G+tUbUckI0+hyarJqVkIh8/J/88OQ0ltWBBq6HU7M1PgMqfgSCalrmC7RoaVfV1kxwvbaPyNANpDQeYXxOE+qaY0KQmhLUVZNKEnaQIhJu3QxeVSCRlcgk/THQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=opczsBhp0qt6+P5dGe1iYcEVrDktjV1EOsuHM54Wmhc=;
 b=k/D+H0h3/fJzGavrOJjFKUaKLwdC7WiELkuC2OJc7uv2R52WfENuyuotiuzG85PNjyU6lIRrAcCZsSFFSRY7/bh8YkylV+HYfiPpNgbIBTnRzlTZe5MEkO9dLdAKGEM4g/rFI9Pa+rpNQEKP2gN0xSQMd4T/C39tS/l/V2x4Ohe9KD9cNaJvm8ES8oD79wOySJu4pdFAgPZW3gF6JiW6eZ8mt9YGQ0YDlNH7Bn1Wd1dv2Oopl2AuF3/zfJK4BI58tvjHUoBH3XnT2lLwKligqAaly9t23XY7Loezakw8nwPJWA1JqpZEVlRwYHbasRovjUIIO6Z9E9exsvVPSYOCQg==
Received: from BN6PR17CA0025.namprd17.prod.outlook.com (2603:10b6:405:75::14)
 by DS0PR12MB6557.namprd12.prod.outlook.com (2603:10b6:8:d3::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5791.26; Tue, 8 Nov 2022 10:48:38 +0000
Received: from BN8NAM11FT087.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:75:cafe::67) by BN6PR17CA0025.outlook.office365.com
 (2603:10b6:405:75::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.22 via Frontend
 Transport; Tue, 8 Nov 2022 10:48:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT087.mail.protection.outlook.com (10.13.177.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5791.20 via Frontend Transport; Tue, 8 Nov 2022 10:48:37 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Tue, 8 Nov 2022
 02:48:26 -0800
Received: from yaviefel.vdiclient.nvidia.com (10.126.230.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Tue, 8 Nov 2022 02:48:22 -0800
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Ivan Vecera <ivecera@redhat.com>, <netdev@vger.kernel.org>
CC:     Nikolay Aleksandrov <razor@blackwall.org>,
        Roopa Prabhu <roopa@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        <bridge@lists.linux-foundation.org>,
        Ido Schimmel <idosch@nvidia.com>,
        "Hans J . Schultz" <netdev@kapio-technology.com>,
        <mlxsw@nvidia.com>
Subject: [PATCH net-next 13/15] selftests: mlxsw: Add a test for EAPOL trap
Date:   Tue, 8 Nov 2022 11:47:19 +0100
Message-ID: <389ee318ff1a799d1e94ba1a33ab2ff42bae50fc.1667902754.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <cover.1667902754.git.petrm@nvidia.com>
References: <cover.1667902754.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT087:EE_|DS0PR12MB6557:EE_
X-MS-Office365-Filtering-Correlation-Id: 729ce41a-2890-4d43-800c-08dac176ca9c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KG34cutlHhX1BZj1NRrkg1AJLsYy96OHRA7g8ZGQ0JbPgubckIp5lhN4VAdgC5sS1rRweCXMaJBFaDvcgBL/cOjZzDWjW79J2XhNM+QF+LIXa7JekJbsQ5JIZPXjCsC6C3aDVoru8V4efzQ7mEiLobHk2WgAb11Rm8xFaScPxTYdn9nUSfjU8LFpW0NqBaWf/rt5hNSUr20jI9Pm397JpgNiAAKVQNZaAOiop2HDam3QDSuH6obqxKINI17keOQtcLUbK8Zz2t9aPKXAT8wQ2EriYc619ZtCXJpcRLDODr1f52t+obUxzjfbZaCPhQbtUK8ByaFs6l137CXOHz7SdFk/aW/QvBzIcOEEiKgxpP37kgKtkX+68lEfysagqK+8xQCsXzvMpjxfImG13YIj9zLkB4+NvwcpeR+EDk8eJ4nAoJbxTFLtRsee/52gMawkPK4OrKyPdgj31Zm9cYV1AYNgeKMQJq7Z0l6PUIbDU8AaDhn3GrDX6cpBZkXHqGSjB5vA0OEfW8b6yTz66hwu5TCv5yhTnT9hb7OV/Ypv6e6p1hyYhz3RdNNnRxgb0M2ERNfLImkHYlsEGb8pxXx9jV/2CQDUw1r28FmBPM85X/R3U5xpBOVlgwDGGHSip3UCCoXHZKULHpeLyOq9rpYbTRSJMD7XnF30fD4wU5aym70PMNI3oG/WtlI4VjYuklQ9kfzbhGMFl9SrNpfK4A2QP1+oj6Cew1msxVI+OSj4tbQO6CCRy5uHdINTBH2q8w4nA02Rpung8zHJrNVSEKjnSuG17IuoYCRq9riH5tuVp0I=
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(39860400002)(396003)(346002)(451199015)(46966006)(40470700004)(36840700001)(186003)(16526019)(426003)(336012)(36860700001)(6666004)(47076005)(2616005)(107886003)(2906002)(7696005)(26005)(40480700001)(40460700003)(8676002)(54906003)(82310400005)(478600001)(110136005)(5660300002)(41300700001)(316002)(8936002)(4326008)(70586007)(70206006)(86362001)(36756003)(356005)(82740400003)(7636003)(473944003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2022 10:48:37.3871
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 729ce41a-2890-4d43-800c-08dac176ca9c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT087.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6557
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Test that packets with a destination MAC of 01:80:C2:00:00:03 trigger
the "eapol" packet trap.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 .../drivers/net/mlxsw/devlink_trap_control.sh | 22 +++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_control.sh b/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_control.sh
index d3a891d421ab..64153bbf95df 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_control.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_control.sh
@@ -83,6 +83,7 @@ ALL_TESTS="
 	ptp_general_test
 	flow_action_sample_test
 	flow_action_trap_test
+	eapol_test
 "
 NUM_NETIFS=4
 source $lib_dir/lib.sh
@@ -677,6 +678,27 @@ flow_action_trap_test()
 	tc qdisc del dev $rp1 clsact
 }
 
+eapol_payload_get()
+{
+	local source_mac=$1; shift
+	local p
+
+	p=$(:
+		)"01:80:C2:00:00:03:"$(       : ETH daddr
+		)"$source_mac:"$(             : ETH saddr
+		)"88:8E:"$(                   : ETH type
+		)
+	echo $p
+}
+
+eapol_test()
+{
+	local h1mac=$(mac_get $h1)
+
+	devlink_trap_stats_test "EAPOL" "eapol" $MZ $h1 -c 1 \
+		$(eapol_payload_get $h1mac) -p 100 -q
+}
+
 trap cleanup EXIT
 
 setup_prepare
-- 
2.35.3

