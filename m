Return-Path: <netdev+bounces-12252-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E6959736E32
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 16:01:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9FA6228132A
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 14:01:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9B1D168A8;
	Tue, 20 Jun 2023 13:57:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B848E2F5B
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 13:57:45 +0000 (UTC)
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2079.outbound.protection.outlook.com [40.107.243.79])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B26B6A4;
	Tue, 20 Jun 2023 06:57:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a1EXqWTMu16683wt9hJ/Po557LF+sm0GiSJUqFdTj9JUJ3pcMWFbR9rKsUwE81240llnPaa32hF1g+yxDkxCrZSgfP8i1UPIvls2iRH8m9RmcIv5VORm6+b3wXKceFodaZK4PnSTIm9Ur8/yDc2JGKL0GK6cPl8N6Y56Gs7fpIMliCo7A8XgQWF1pLrBGOC2dO3B1QNusmsyXIzdED3sNoKfCZBLpHyTGdxoaK/YwAbq/kKevoqhcwkDUguOPg2GbGg5YsuLcHfs8Nl23vICcxgmv2nKIRxkAdTn67mrAwFMgWDjamHuoteO+JAJ6FbeFuYd2P2Eb2ojWdRHF5UvSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IoV+rrUiiDRQxqrN9fGt+4zr+9BT/rWi1cU8DKw1l4M=;
 b=A6CCeLAWq80iZJ8Q1G9VVIq4ut9A1wejZ9SmPFZzM7YFWFbP/q/xkqTUKJQ9uToQjIWDdt81++J7ZU1jk18rnpvaY3IFQrS0Ihc2X/5KleKat9t4CUOIG+4oSUEpaBsu8GlbBjJsZv5sAVs4hWPVKpLj1XU1F27WQb4NVRlGzoGw+y/JEPjd3thz8q8CgwdGdTAI63hclYH5Isxm9DKGejV4Ws5ZpaeGkRJKnyeYjplUme6CZGNpwBQFi+3Plg3fiFzeXfwZdGXNxWRx7DbJJBblRB+fPe8yQUkNQ7WXq0ZK3Z2foFShSDECU3Cyc2rEksalCUiZ19toZFbmTVj6xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IoV+rrUiiDRQxqrN9fGt+4zr+9BT/rWi1cU8DKw1l4M=;
 b=gw9Q+hLL7WQHzjEv9PAdAGaBtQ7Ivgt9ZsyPj3NDV+4vQGUN4mX0+Tq0KcPuEvwGeNRGFbGysgcHUXBQxaDk6D3k2k6ZwyRPxKY1jcL81Xro5m4fKUT89iQ6j6fGMB+jqHs9ORnNhgqug47tTbqeCjej+I54WAlhu2NuxFETFMrnuz/0rtjlwERACiwo1ybQG1lsdwi7HkcemYVf22QquD/A4+OWILxuWSOI0LX3EqWSaN5YmjypqrAlbVnuC2tu1pDlPl1owApswOt4p9H1SZMoOYLqWP1RuLs7/15yUDXpYSO1HcTbhlvE2F0kxuPcCQDG4s8gp+Jf+DR4pxgbwQ==
Received: from BN8PR15CA0010.namprd15.prod.outlook.com (2603:10b6:408:c0::23)
 by DM6PR12MB4925.namprd12.prod.outlook.com (2603:10b6:5:1b7::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.37; Tue, 20 Jun
 2023 13:57:42 +0000
Received: from BN8NAM11FT086.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:c0:cafe::5b) by BN8PR15CA0010.outlook.office365.com
 (2603:10b6:408:c0::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.37 via Frontend
 Transport; Tue, 20 Jun 2023 13:57:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT086.mail.protection.outlook.com (10.13.176.220) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6500.37 via Frontend Transport; Tue, 20 Jun 2023 13:57:41 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Tue, 20 Jun 2023
 06:57:29 -0700
Received: from yaviefel.vdiclient.nvidia.com (10.126.230.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Tue, 20 Jun 2023 06:57:26 -0700
From: Petr Machata <petrm@nvidia.com>
To: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, <netdev@vger.kernel.org>
CC: Petr Machata <petrm@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
	Danielle Ratson <danieller@nvidia.com>, Amit Cohen <amcohen@nvidia.com>,
	Shuah Khan <shuah@kernel.org>, <linux-kselftest@vger.kernel.org>,
	<mlxsw@nvidia.com>
Subject: [PATCH net-next 16/16] selftests: mlxsw: one_armed_router: Use port MAC for bridge address
Date: Tue, 20 Jun 2023 15:56:02 +0200
Message-ID: <8c17b7a1855a639e97e4dedd3534b2c32b3f69ae.1687265905.git.petrm@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN8NAM11FT086:EE_|DM6PR12MB4925:EE_
X-MS-Office365-Filtering-Correlation-Id: e4da7754-5d99-414c-da43-08db71965108
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	AZcYSfwSiyIjYduAM00c8qtfB8rmPoQz+Hawx0K+u2cw015pwaTMWcJDzEZB6N6Ux1OPGIIIsyi8HcELEt4MSxG7XyoAxQkA4vJ0dc4MSTHOmC5s3e3GXq1Xb/vvwYSejN1gor2ABVO6panqh2RHNO0N2dzSWUnDom7knLSZYhHLKp5OQ4EChpRrfrYMGwgTEAe0G8BCVY5H3NtWcinf1ag3heVWK8zAS5KxYk1n8Gy4rUFn+nCy9sDd4KxQXDTRecV3+moFtk7zsJSiMCX/JCQCMG/LC0YcH42RtzUT3uD94w1nngUU+LetRdtz9yAhLnTcMFUutOf27Q+j46sv4wYGYjEUMcC1BAK8e4N3LasgeOpg4or4tJuR43bfFoeyAx8WNjqPCPrsTRig1IhagZFkx1ybL78aCLvxc6gZMBif93OkP7kOrculQYymc5rFXW9XzEdk4Rw1Bbhbc7X+71d2RioHFMuvNOUJZh6J8VEZxn0uKnqxuSJN4AN/uEmO+OuHe+jIbbaEhY/Aq8G00ulLM+jLgTTi+50yEV7rXoperUrsjdkK5GmMQ9OqRWBSCgJoLGu7K2qT9/R0MC4xLN6MOao7QT9omFqbQCF/nSKmNmu1DAVrBhF3ZLIrhFAbmRQ3ppmxQaDmmygakIscxqQP4GSUtfpTJ0YGpEgogBt72AZx41TP58r+w8fi5iOCop77/m4vmlt63wYG+7ucqnwLd2GtUur1D4wseANg8Fo=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(136003)(346002)(39860400002)(376002)(396003)(451199021)(46966006)(40470700004)(36840700001)(186003)(16526019)(107886003)(40460700003)(26005)(82740400003)(36860700001)(47076005)(2616005)(40480700001)(7636003)(356005)(336012)(83380400001)(426003)(82310400005)(66574015)(478600001)(6666004)(41300700001)(4326008)(70206006)(70586007)(36756003)(8676002)(316002)(54906003)(110136005)(8936002)(7696005)(86362001)(2906002)(5660300002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2023 13:57:41.9593
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e4da7754-5d99-414c-da43-08db71965108
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN8NAM11FT086.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4925
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
eventually be anyway. Do the same for this selftest.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Danielle Ratson <danieller@nvidia.com>
---
 tools/testing/selftests/drivers/net/mlxsw/one_armed_router.sh | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/one_armed_router.sh b/tools/testing/selftests/drivers/net/mlxsw/one_armed_router.sh
index f02d83e94576..fca0e1e642c6 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/one_armed_router.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/one_armed_router.sh
@@ -83,7 +83,8 @@ h2_destroy()
 
 switch_create()
 {
-	ip link add name br0 type bridge mcast_snooping 0
+	ip link add name br0 address $(mac_get $swp1) \
+		type bridge mcast_snooping 0
 	ip link set dev br0 up
 
 	ip link set dev $swp1 master br0
-- 
2.40.1


