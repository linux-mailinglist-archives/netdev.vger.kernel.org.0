Return-Path: <netdev+bounces-12238-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B5F6736E07
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 15:57:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 26CF7280637
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 13:56:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7C9B16414;
	Tue, 20 Jun 2023 13:56:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5B3D1640C
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 13:56:46 +0000 (UTC)
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2051.outbound.protection.outlook.com [40.107.212.51])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2702210DA;
	Tue, 20 Jun 2023 06:56:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=blvtMd8ag6lLFNtqZA416Ehqgh7206C3b+eee6YAIDjkljaiV53ODqNESgzvMOht7OYGFglmv/1oeQzcqzpy5uJtv5QeJsllMKq5rh72TfKFTQc3iUYtHJvb++zPERxaj2MnC6AUVR5Q0dQhQyeIpdDDLQfQQRmxLPunkBHVxnnq0KVjFGowQx6fW5tlxpOyx/0Ja0GnoevLEm1MokZV831/L2qU4XwuqulZTbBEcNoF38Nts/soZLJdbWT4aZhL2hDmtSBlB8khE/JZAp9Qh+Q6wFNU3u0jyEsOObZs1wA9wrG09tBMoMFEDcwipIQpgdyqAVG33gQi1xs2NXBOGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C0x0VaWpp0PiJFPvFFyOP3MwACgHvSq+EIKu9mh7SDA=;
 b=FmmUJZ0mMID2D1bIdiVAXr35qmjxOShJO8CNRLSxF3aHDHoC4FEjMm83Mhy5x5JWD043ecbhAqSrqCqDoAm74IhgWuh6lW5UD5xmsrLm40OWDcqwZ1j/MRNphTpfq30fkB29SGr5BzoW7BJrWFHlnQI6GPZV3R+fVeYJ53qvWNnpSSlgKkc8gw04ciuxUJUd8akC2i3rUoasJt/Fc9rvDT2zLoCZAzqDv3WxhRJVLIqljcqWQ5XdljrVnwnOYV9Zan4PcU59o3cSicnE9YmmUGUpjXe74Iv4MPI4SWUJ/2Bz1fitK6I7ApOn9CsT6c94Zhat49WY/4kcsxtX8J8Q5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C0x0VaWpp0PiJFPvFFyOP3MwACgHvSq+EIKu9mh7SDA=;
 b=KzzBBB2zM5uDPMSplNTLJ7lyGWsJL7/ONIvMDgXU6wrxonwzPI5mwI2Qq8DS4cNvLqndO5cQ7wlv0TCOsv4sD+9ENAdYrGbaNGMrDZtF4XY53iITezNMaSBI81B9xrE9x8w0G9mjLnpNaFsHjMeF0Ih93XJYRboIYoCq9bk6RECLgaNSPTILstwSpl6xbEXUmgs7lPZ6c8afqznoL+rR2EqeqcTexNVILk60TDBUalSlnOQwxq88RaQyjFx2+ahLtNtjJlCbZmQQNAoC8dtQ7OwI/KZbZ/UzThdgIdmOcQHfeS3dpSnKXSoKBlQEpiMge2U1fUflefGL6xChAJq70g==
Received: from BN9P221CA0002.NAMP221.PROD.OUTLOOK.COM (2603:10b6:408:10a::9)
 by MW6PR12MB8736.namprd12.prod.outlook.com (2603:10b6:303:244::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.35; Tue, 20 Jun
 2023 13:56:38 +0000
Received: from BN8NAM11FT077.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10a:cafe::fb) by BN9P221CA0002.outlook.office365.com
 (2603:10b6:408:10a::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.21 via Frontend
 Transport; Tue, 20 Jun 2023 13:56:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN8NAM11FT077.mail.protection.outlook.com (10.13.177.232) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6477.29 via Frontend Transport; Tue, 20 Jun 2023 13:56:36 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Tue, 20 Jun 2023
 06:56:26 -0700
Received: from yaviefel.vdiclient.nvidia.com (10.126.230.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Tue, 20 Jun 2023 06:56:21 -0700
From: Petr Machata <petrm@nvidia.com>
To: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, <netdev@vger.kernel.org>
CC: Petr Machata <petrm@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
	Danielle Ratson <danieller@nvidia.com>, Amit Cohen <amcohen@nvidia.com>,
	Shuah Khan <shuah@kernel.org>, <linux-kselftest@vger.kernel.org>,
	<mlxsw@nvidia.com>
Subject: [PATCH net-next 01/16] selftests: forwarding: q_in_vni: Disable IPv6 autogen on bridges
Date: Tue, 20 Jun 2023 15:55:47 +0200
Message-ID: <d4ca3991e8174898411576b13e5fa2601994af3b.1687265905.git.petrm@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN8NAM11FT077:EE_|MW6PR12MB8736:EE_
X-MS-Office365-Filtering-Correlation-Id: a0347fcb-a205-49d0-7349-08db71962a37
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	zaWbPWL8kiNZApx2UEFgDgAk/IKhDBYJjZZMDPr+tYQvA1+2oIyOAx/tgFe06yQWbDNw+vHpopazy5/yC5OU7jvZp60WNi4BA2MoYda+/7IPYhB7G33Kn2YGXPjwhUyfPZw76DmMhgo18a+ikCc00Io6O175kL5acztffEMJcEDaaGTNO3QrbJ+uK0Q+4RE8+KrSXR4u8CiDFDaD+p/PBAThLbeEfnMm+at0kPs2lcoe7fPrpPBGkWOBPxxpVsDrC79sGg0f+SEEyioYmbfQdOBny+ksiGjqmqkULF10wzNuech7KWKcydM2Uc3MxFFTn5cuoeSrSPWWbBd4nKoVG/D6xmmQJcwhfDrgXQt9BXVdnh1R75CfD2k/I+Tp9r05Xj+4VvXgF3egmg+3B9P+pVCD+coNC3bXCowm6ubpMNFrDrbo6HZG8JS/bSsv/v+FCdyXKeWo/l8tXvIAXknI/Duh0Thm1ITwBOlCus/NiPPnls6i9tjxV1xDF5UrFziAjvKTgYmivoNsP2Bzlx1kz41Klml1MhRGOhu5rdw3X3N9uminCet/HQQZQz9WxEu3x75GVRT1/tm31G3HLMjy+ZT6ZSMDKIbQeifhbcJpiKyR2R8nIZpNfStdMZase369eUtlyTX3gb3up4LAj5rvvbcRklZAPEroltLjJPTc2N9i+XziSQvKxYovj8ZlQkIWM1zgM5F/Q+z3nmqiPG5+tw2RF0Z6zi1rLP+7DJK3Dkv3WM1hBurQ8WSmS8p82WUL
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(136003)(376002)(396003)(39860400002)(346002)(451199021)(46966006)(36840700001)(40470700004)(107886003)(356005)(7636003)(82740400003)(40460700003)(36860700001)(478600001)(2906002)(40480700001)(6666004)(7696005)(54906003)(316002)(47076005)(66574015)(82310400005)(41300700001)(426003)(336012)(5660300002)(70206006)(70586007)(110136005)(2616005)(36756003)(26005)(86362001)(8676002)(8936002)(186003)(4326008)(16526019);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2023 13:56:36.8336
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a0347fcb-a205-49d0-7349-08db71962a37
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN8NAM11FT077.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8736
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

In a future patch, mlxsw will start adding RIFs to uppers of front panel
port netdevices, if they have an IP address.

This will cause this selftest to fail spuriously. The swp enslavement to
the 802.1ad bridge is not allowed, because RIFs are not allowed to be
created for 802.1ad bridges, but the address indicates one needs to be
created.

Fix by disabling automatic IPv6 address generation for the HW-offloaded
bridge in this selftest, thus exempting it from mlxsw router attention.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Amit Cohen <amcohen@nvidia.com>
---
 tools/testing/selftests/net/forwarding/q_in_vni.sh | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/net/forwarding/q_in_vni.sh b/tools/testing/selftests/net/forwarding/q_in_vni.sh
index 4c50c0234bce..798b13525c02 100755
--- a/tools/testing/selftests/net/forwarding/q_in_vni.sh
+++ b/tools/testing/selftests/net/forwarding/q_in_vni.sh
@@ -137,6 +137,7 @@ switch_create()
 {
 	ip link add name br1 type bridge vlan_filtering 1 vlan_protocol 802.1ad \
 		vlan_default_pvid 0 mcast_snooping 0
+	ip link set dev br1 addrgenmode none
 	# Make sure the bridge uses the MAC address of the local port and not
 	# that of the VxLAN's device.
 	ip link set dev br1 address $(mac_get $swp1)
-- 
2.40.1


