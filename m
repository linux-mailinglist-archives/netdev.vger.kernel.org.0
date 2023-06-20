Return-Path: <netdev+bounces-12250-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 02C93736E30
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 16:00:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 33C7B1C20C97
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 14:00:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BF45168BA;
	Tue, 20 Jun 2023 13:57:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F2C41641D
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 13:57:39 +0000 (UTC)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2045.outbound.protection.outlook.com [40.107.92.45])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3B5D1A1;
	Tue, 20 Jun 2023 06:57:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hU1cX4/sT4mjZj1E4pHYhtuX8rcVO2lnVG09R0v6D18jZg8EHr/5dRDDd7Wd3FLMxgROMhePpua5dhdlTtTKePeHwGZiB2u8Vopnr9REGebPF/iqvoCin1+8fGiLbY/9GybLCalxgjCeCGGyVrlSt114SqCwkOK+oBNsL0iqzUnNu5fegb+oZZpFAOgWHowqHq0vPXwdpCEvoeYhxxd3dcrn3GMaPADTe4gKGpKFeYfuM9Ec7mvl6PA7s5t2yeKWzkXgty1NqVcVSLqfr0/M/VNWoKxKlg2A73rXJMeJLHaokoqPuiR3c263K7T4GMfyTJWYZXLawzaYANE3H0tHkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c92p6tBb/yNkE6UKCCllA52Ca4V6GpP1NGcN8uAPo+s=;
 b=M/deJ3JFpQrbrzU4XvimaJCW9K3TObVeT6ed/+PqK99NbCEFFO9pkr5Aku4RuT1PHwZ0Mgk835xZ7I9wxkCP2O9V90pj1fqY1lomTcr9zH6YBaYcLj+vEnvcryEH20BDxrOH6LVfFSCcXV/9LrwwRdOfIoBs1twaRKuT94FBbgbJC+8rbHQ5dvEgfnLdtYDG/geWTqbFS9vr74Ex9ki028BY1EgBkOP/JSYl0mFSJ1kS90ddZTkjarVyzn8Nn9Io82jzqcNKbzubGyJ6ozHxkrJpVFQY602BNy9IoqEIwTPrRP1Pw86mON0ylN+UQjyPPFvdZhj6xteyKz+rbu0wwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c92p6tBb/yNkE6UKCCllA52Ca4V6GpP1NGcN8uAPo+s=;
 b=hQHovYWtfcyr64MfApbWlQpTgknpeC0ZvI4HsVNFL2t5nryULPZeiifByiPLDN350APpmZ4WNZvwzCdVCANU1JMupsGTeTqST7x8ChWWObLzNT4mw8Y5icp4G9lWw5QD3CBICIUkSUJTCvG2HUHOkHQ5UAw1QBNddjrloks6BXHAPR2Fe+Lvn3WaKWIJVOngA8zlFj9aXSUzzqP4sAYUP9kwO0UXepgcwGGe50tMI5cd70rIYB7CrC1BR3JvW5Sns7kEcIu8A8drL0ud2b2eTSEmjr6zYcDoa2EU81rcGPlLPP/D8vjxYmKoNul0/U1jLT1PLDG9IFdTag4gD32BFg==
Received: from BN0PR08CA0016.namprd08.prod.outlook.com (2603:10b6:408:142::35)
 by DS0PR12MB8444.namprd12.prod.outlook.com (2603:10b6:8:128::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.37; Tue, 20 Jun
 2023 13:57:34 +0000
Received: from BN8NAM11FT043.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:142:cafe::66) by BN0PR08CA0016.outlook.office365.com
 (2603:10b6:408:142::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.21 via Frontend
 Transport; Tue, 20 Jun 2023 13:57:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN8NAM11FT043.mail.protection.outlook.com (10.13.177.218) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6500.37 via Frontend Transport; Tue, 20 Jun 2023 13:57:34 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Tue, 20 Jun 2023
 06:57:18 -0700
Received: from yaviefel.vdiclient.nvidia.com (10.126.230.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Tue, 20 Jun 2023 06:57:14 -0700
From: Petr Machata <petrm@nvidia.com>
To: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, <netdev@vger.kernel.org>
CC: Petr Machata <petrm@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
	Danielle Ratson <danieller@nvidia.com>, Amit Cohen <amcohen@nvidia.com>,
	Shuah Khan <shuah@kernel.org>, <linux-kselftest@vger.kernel.org>,
	<mlxsw@nvidia.com>
Subject: [PATCH net-next 13/16] selftests: mlxsw: qos_mc_aware: Disable IPv6 autogen on bridges
Date: Tue, 20 Jun 2023 15:55:59 +0200
Message-ID: <ac5ac3c95fd19bbb9caf5544217aaae3e995afc0.1687265905.git.petrm@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN8NAM11FT043:EE_|DS0PR12MB8444:EE_
X-MS-Office365-Filtering-Correlation-Id: b845cf94-76d8-4e66-672d-08db71964c59
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	/cZw1Zou+lI54KNHxirk5pN5pUZJrF1P1dYVQXvj2o6ybgfhVTxvdk824c+MmvM0ovvzYoDtF64CJtcaN2Eo33vjowxyiLosPg9PkWeoE0TCXYIBozSJk5unXibLyifHu/R8pfel3Hema4dpphAg1arsgfO2WVIaR0pUTCG0NGDMuMXfnVBW0VzYsA1zRdSFwsbF/I8Z/cmvty8Noumc88qwMi40xbmQq5+H5vp/3NxPfA8wuAlvQ/47ZURoqZeH6Gl6UxsxjmulU0qsrZYbIaOWcBbiNOLVgPc0M6esWGZCWk9PuFhmcyXtGNLnOVPnx4+cWK4BTkgJYiAJFmQqR5sQzY8lTT/9aEEH6aJSQ9CaSjHU2xW0DRWNac94dBPvEs2D+vZdHh4R5QqK3pMo48lM2PwnF2xKer5RjMT2D9+3GWa/pti5nISxgz2kJVcnEDRafguGNw+3LQt90KP0WYe3xvMgskTTfuHJ9mb984E/nMU2vUM0gtG51Yd3v4H/1nb1lJa+HOKMoj4Kj/PV++Irb6h8BeLCNyKnOAQxH4Vl4aN+VXRE0lmDJEdsGBuGRMQZlZLvkGP7sc/O3bno6otSVU9kl6OUYsnbx+B7iE/GBSL0Oze9VZnd6S6/tM4/9VSc7zqG/b6D+iDC5PPL4rbaAAsSv7YmVxSCTuAOm7NvIj2KSWbKOfiNtrqldphvO9DeknnRcg1k9mrXUOCtQM/Wg7i/LvRWL7K69I1UvJA=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(396003)(39860400002)(376002)(451199021)(40470700004)(46966006)(36840700001)(36860700001)(7636003)(82310400005)(86362001)(8676002)(356005)(8936002)(5660300002)(82740400003)(316002)(336012)(41300700001)(83380400001)(70586007)(70206006)(426003)(110136005)(4326008)(66574015)(47076005)(54906003)(2616005)(478600001)(186003)(36756003)(26005)(16526019)(107886003)(40460700003)(2906002)(7696005)(40480700001)(6666004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2023 13:57:34.0986
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b845cf94-76d8-4e66-672d-08db71964c59
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN8NAM11FT043.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8444
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

In a future patch, mlxsw will start adding RIFs to uppers of front panel
port netdevices, if they have an IP address.

At the time that the front panel port is enslaved to the bridge (this holds
for both bridges used here), the bridge MAC address does not have the same
prefix as other interfaces in the system. On Nvidia Spectrum-1 machines all
the RIFs have to have the same 38-bit MAC address prefix. Since the bridge
does not obey this limitation, the RIF cannot be created, and the
enslavement attempt is vetoed on the grounds of the configuration not being
offloadable.

The selftest itself however checks traffic prioritization and scheduling,
and the bridges serve for their L2 forwarding capabilities, and do not need
to participate in routing traffic. The IP addresses or the RIFs are
irrelevant.

Fix by disabling automatic IPv6 address generation for the HW-offloaded
bridges in this selftest, thus exempting them from mlxsw router attention.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Danielle Ratson <danieller@nvidia.com>
---
 tools/testing/selftests/drivers/net/mlxsw/qos_mc_aware.sh | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/qos_mc_aware.sh b/tools/testing/selftests/drivers/net/mlxsw/qos_mc_aware.sh
index c8e55fa91660..6d892de43fa8 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/qos_mc_aware.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/qos_mc_aware.sh
@@ -135,11 +135,13 @@ switch_create()
 		prio bands 8 priomap 7 7 7 7 7 7 7 7
 
 	ip link add name br1 type bridge vlan_filtering 0
+	ip link set dev br1 addrgenmode none
 	ip link set dev br1 up
 	ip link set dev $swp1 master br1
 	ip link set dev $swp3 master br1
 
 	ip link add name br111 type bridge vlan_filtering 0
+	ip link set dev br111 addrgenmode none
 	ip link set dev br111 up
 	ip link set dev $swp2.111 master br111
 	ip link set dev $swp3.111 master br111
-- 
2.40.1


