Return-Path: <netdev+bounces-12244-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DF4C736E1D
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 15:58:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ED95228130E
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 13:58:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F19181642D;
	Tue, 20 Jun 2023 13:57:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF4F314293
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 13:57:13 +0000 (UTC)
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2071.outbound.protection.outlook.com [40.107.220.71])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B75939D;
	Tue, 20 Jun 2023 06:57:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=he7XYta6kgb5n6VvIfLOtGxzlv62V/MLpSFTDD4djJk6AdIn3inIfcANOdr2O8s1XC8RIZI0iOZxqN2PiUhA6jHeJqbxrjuslyxGrc4c4vO07asNYCPNCh0Xt7lOZyDhXFsXupOG9yg5HugdAOrcvMaVcrDZ/sr+WxPYrI/eIKmrQfC65NqD57gDFDMUflskdwwPkmzs7Hkvxbj0pl57HUVujF98KzS5EWqd04bSDsFNyhY6JaXzhCbtAwM0UX48XNdV2fj0Qpa3qsJWPLXTM3qv9WcI8lSLRg3X0L1s7Q5ZRnKtgw0fmxhgHOPbIFRvxdtsZBjOW5qTW78iutrb7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sQHo8Xc16Y3bI+peSWn6wZV7cZvT1PE48GGYarOPQ+Y=;
 b=izgE5q0UlKNEDkt2sBO/m8VoXwOG7GWDqP+BEM4cojxUKYLivABLE9VhfiyyvUbN09k2rcBSxQhPzx5Okg6qSbcXO06GDpG8OE47vFLR1sq8VT4NUyiZ1Du7wWSPkGdf9DWWYBHC+RLplpjs/Al2RlQQGvCDLPfmt5ZpRkXgl3G+gf0hcQUN8LSkSR9UN3ZliX87fJCbp//k4VoWW1Dzc+kSb4XQm3whN0n5G1/iG9Us+Wmfr3GitxpJghvWgsi2S2Y4X05RvB5WEdLve6yp7ldcloQd7zn0xQXgVR+kOhCekQoPya/UyTWl8F2wZvAs3qqkfVH3rpeT2q3fLdnqTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sQHo8Xc16Y3bI+peSWn6wZV7cZvT1PE48GGYarOPQ+Y=;
 b=LvBGlXpNhTuKuWbWI/tscn9aGYPxL5SkATtVTbJ3oLQmPP9kU0dC3ionbdJcoGC7ln6J7+ybq+vZ6ly5oXqJQw5qJ0I26pmqG4oeogTM11+PAFp8PbRk9++wGR/mVLLzgMg+88/WBiz9xgh9AShstTnv9kTRaVljpBRLIgfGWilpyrP/u6JGQIJdmIRVD/8gnWMxdl+25f2awiJpiHpS/NSyjWQ4RMWUEqnuDAmQbjHn5ozmzy0u4XxoC5CTtOzsobkDTNR/BT4n4B1qT/TsFzAKdcKNUd+lC63TorjqC8iS8tt2soIZTh/G/Br285tAPBeGn98YVw8Hj61/0HhIRw==
Received: from BN9PR03CA0844.namprd03.prod.outlook.com (2603:10b6:408:13d::9)
 by BN9PR12MB5178.namprd12.prod.outlook.com (2603:10b6:408:11b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.37; Tue, 20 Jun
 2023 13:57:10 +0000
Received: from BN8NAM11FT035.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13d:cafe::ed) by BN9PR03CA0844.outlook.office365.com
 (2603:10b6:408:13d::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.21 via Frontend
 Transport; Tue, 20 Jun 2023 13:57:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN8NAM11FT035.mail.protection.outlook.com (10.13.177.116) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6500.37 via Frontend Transport; Tue, 20 Jun 2023 13:57:09 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Tue, 20 Jun 2023
 06:56:53 -0700
Received: from yaviefel.vdiclient.nvidia.com (10.126.230.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Tue, 20 Jun 2023 06:56:49 -0700
From: Petr Machata <petrm@nvidia.com>
To: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, <netdev@vger.kernel.org>
CC: Petr Machata <petrm@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
	Danielle Ratson <danieller@nvidia.com>, Amit Cohen <amcohen@nvidia.com>,
	Shuah Khan <shuah@kernel.org>, <linux-kselftest@vger.kernel.org>,
	<mlxsw@nvidia.com>
Subject: [PATCH net-next 07/16] selftests: forwarding: router_bridge: Use port MAC for bridge address
Date: Tue, 20 Jun 2023 15:55:53 +0200
Message-ID: <74b370bdbb884b37836d2789474879d75aa978c1.1687265905.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1687265905.git.petrm@nvidia.com>
References: <cover.1687265905.git.petrm@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT035:EE_|BN9PR12MB5178:EE_
X-MS-Office365-Filtering-Correlation-Id: 0acf1bab-9cab-42a7-55af-08db71963dc6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	pBbpRCDQT9pDDUIyYyBOr6DwZOueRvYX1HpbfS0mt5YdwB8fYcMKlwOE8lUSN0bb5TDXA2H7jYIPC9siWwCU+bjfFa+AxHG2XkNQYDstkJAJD8MXxKP5Zf/Fd4qsZEeEE2Rcn4yNBm2H7KWZxezHYNYLkt2BffizrvOHPKOsGURrQZ0+ocRv73ugFEI/nFTomtX3i/xVTaQbO64wIHz76A2VLcIQgwuC1d8w95vYeKPKJA8uko5QieS+B53gPbxVsRYu9d+9wDtyMI6L+hc/1lN7YJlohtITTS/66oidvYGZcBuvZojKuTtBzSq8rCxUc1oUJhxSJ3GGRfNRw0NHGuzu7s1SD7qiQ+hOfOl70VhQBUZj80xff3d88tX10kFrYh7wqBFEZ3eKTghgbDv4oSsINCrg77kLLoyuT57ULGoZQNLIG4q3+SW9RA+mChYIcK8/HU1NjAlfqfiEZgalNLYqfnBmC0qvFW5Y9ecGxXv4alCEkZY+a1ie0cR982/CfK3irWrX+ADdGAAxSWjtnGJ6QR6zgDyLR2V3TytlXFO2Vn1agBOtJeC+BdfJOJLVsXBZCofUMg63dPzjq9/GhzH6vw2oopLq/iuKAsJUJz+1Fv8vmsxoD1DCzCi2miUPHZZY0CGq4wsoleulSUnX7u5hpkzQ6iDd8m99H0h4qyzqwSZcUeZQcFNgcbmwDApViGWPis+PNgzw7cj7gr8uJztWMc2C39pnc0cs6ZIgdVo=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(376002)(136003)(346002)(39860400002)(396003)(451199021)(36840700001)(40470700004)(46966006)(478600001)(40480700001)(2906002)(40460700003)(54906003)(6666004)(7696005)(2616005)(356005)(7636003)(110136005)(336012)(86362001)(66574015)(426003)(47076005)(107886003)(36756003)(186003)(26005)(16526019)(8936002)(8676002)(70206006)(70586007)(82310400005)(5660300002)(4326008)(36860700001)(316002)(82740400003)(83380400001)(41300700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2023 13:57:09.6467
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0acf1bab-9cab-42a7-55af-08db71963dc6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN8NAM11FT035.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5178
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

In a future patch, mlxsw will start adding RIFs to uppers of front panel
port netdevices, if they have an IP address.

At the time that the front panel port is enslaved to the bridge, the bridge
MAC address does not have the same prefix as other interfaces in the
system. On Nvidia Spectrum-1 machines all the RIFs have to have the same
38-bit MAC address prefix. Since the bridge does not obey this limitation,
the RIF cannot be created, and the enslavement attempt is vetoed on the
grounds of the configuration not being offloadable.

The bridge eventually inherits MAC address from its first member, after the
enslavement is acked. A number of (mainly VXLAN) selftests already work
around the problem by setting the MAC address to whatever it will
eventually be anyway. Do the same here.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Danielle Ratson <danieller@nvidia.com>
---
 tools/testing/selftests/net/forwarding/router_bridge.sh | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/forwarding/router_bridge.sh b/tools/testing/selftests/net/forwarding/router_bridge.sh
index ebc596a272f7..8ce0aed54ece 100755
--- a/tools/testing/selftests/net/forwarding/router_bridge.sh
+++ b/tools/testing/selftests/net/forwarding/router_bridge.sh
@@ -38,7 +38,8 @@ h2_destroy()
 
 router_create()
 {
-	ip link add name br1 type bridge vlan_filtering 1
+	ip link add name br1 address $(mac_get $swp1) \
+		type bridge vlan_filtering 1
 	ip link set dev br1 up
 
 	ip link set dev $swp1 master br1
-- 
2.40.1


