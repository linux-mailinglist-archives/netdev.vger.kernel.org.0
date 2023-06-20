Return-Path: <netdev+bounces-12242-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 28D87736E18
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 15:58:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D79912810EB
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 13:58:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 521E4168AE;
	Tue, 20 Jun 2023 13:57:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E97916414
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 13:57:01 +0000 (UTC)
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2067.outbound.protection.outlook.com [40.107.96.67])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E326A4;
	Tue, 20 Jun 2023 06:57:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A4bkY3jAP6IQCGZaGouWLeVCEkdr1woK4hDaEdn4os3U4NSppZgU03v26UG3Tr3Porx7rHQ7V7pyJyuxWVATliylvsNjDqHXGohq5KOY24MmwJqFrl7e6rkmckwpc0SKhlVAT/l4NEXgJoTFpA8SYPqsuioetPpLxIaeBKeR8a5TjBcPfdxeJrGqKZ3Py9ooeLMlK9PysNFUxkGBY9LjuZk/AW7Bq+OB6UFkYjpw7JfX65YkkUsUhzuOVPlYXC4HkosCYYh8SQmvDgzXzq4ytVOB7jbM6wpOgUG0OUKkNbro2enDwZ1SEU9uQCTn+mmw2R79NQsCxTf++yhPDboKEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aRoiKkxgxEmWFne9y0QScbldsXc6MBYAX9tu5Od4mU8=;
 b=H0p1a2PbLS/zT3SEa7kLbAVxKjtYD9m59aZv0Xff1ANe+JsY+Y891ZyJ3HcCsBVsm8oC1fOBDx99pezkPNEWSP0+06fh3SoYtPTVDImuxgPWaPYlkmcDDMakdy3E0R8vYrmgl+4rH9KClE+dc9fr/X3D2faN02jl/y1dfAkL5sffzzlfucJoVrx/zNq0na06ctzShaKoOr7eOZW/XHIG2dPxmYCitRQMxOR+qO3WAsq8v8WzhcnT+u6z308eRuW7cXWHdJrYH4269HmsRCOrRoTpkqTbYqyPmS/u4AUPq2fhwiN71oqK3Y/wcsLHKktnoxyIvqrLGFWiZR+1gXNHHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aRoiKkxgxEmWFne9y0QScbldsXc6MBYAX9tu5Od4mU8=;
 b=GF4Ct7xtPQOh+hpCkuMn5Xtsw5WmZEXvPcaLCSfmJPR7Y5QEjwu5LG7YcX4hiIXvwxv3F5lOeLxmZgCOrETCp45kBevPl7HRp84sg173Nc88vYKe5Ufn/cFU7FqMRlh//3FZvyx8nAUlM5tWdp5pdsQ3EjKLWGm0rKj36S/vLS53LXsSi/KxDwskMjxvPGty1dP9un6TW4FW+Aa9u/WzInk4jqgulsky2r98wJJlmTl2tkSGWvpVr77+JYQx/yTbvGqE7Eqpna0b8BXl3cSt4kMoO7mrg+c+JtsXuXriAzpgDasz2i3mQX0l0uoR2cHayU2e3ngV8aJTJFrAJYmpaQ==
Received: from BN0PR04CA0117.namprd04.prod.outlook.com (2603:10b6:408:ec::32)
 by CH3PR12MB8209.namprd12.prod.outlook.com (2603:10b6:610:123::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.37; Tue, 20 Jun
 2023 13:56:57 +0000
Received: from BN8NAM11FT090.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ec:cafe::73) by BN0PR04CA0117.outlook.office365.com
 (2603:10b6:408:ec::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.21 via Frontend
 Transport; Tue, 20 Jun 2023 13:56:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN8NAM11FT090.mail.protection.outlook.com (10.13.177.105) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6500.37 via Frontend Transport; Tue, 20 Jun 2023 13:56:57 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Tue, 20 Jun 2023
 06:56:45 -0700
Received: from yaviefel.vdiclient.nvidia.com (10.126.230.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Tue, 20 Jun 2023 06:56:41 -0700
From: Petr Machata <petrm@nvidia.com>
To: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, <netdev@vger.kernel.org>
CC: Petr Machata <petrm@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
	Danielle Ratson <danieller@nvidia.com>, Amit Cohen <amcohen@nvidia.com>,
	Shuah Khan <shuah@kernel.org>, <linux-kselftest@vger.kernel.org>,
	<mlxsw@nvidia.com>
Subject: [PATCH net-next 05/16] selftests: forwarding: mirror_gre_*: Disable IPv6 autogen on bridges
Date: Tue, 20 Jun 2023 15:55:51 +0200
Message-ID: <b589fc6f70c456d91beee4b0dde990c9dbcac662.1687265905.git.petrm@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN8NAM11FT090:EE_|CH3PR12MB8209:EE_
X-MS-Office365-Filtering-Correlation-Id: 760a602e-bc40-41ef-95fe-08db719636a1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	5Zw1uLRQEhIxIAgoJn/yL5vEu51WHCC1Dk8u7JEaY79OU+L2zncj4nNTQ+ptwLqRc2svgoYF4Q8A0BB4kHdabc9Q2JBRzBr+EHgqtLvurUUIbleZ7nO11NW0GnoZP9qg5boHaZ12eOU1HR7dSMEee9Nn0JlUjz1sCxYN/erX10JQ09OIfbFtnhlLhU7FsKOvX5djVNZryZIhAn/LkiIeNEF2u5nC4LA9iSPVxW2dmwBzXtcYBSU0UYUQfyFzA81DukAoLK/kBgfy+o2Iu9Yt5IMoL0SA+n+/cE/0NLj5JQFSnHIxyvTLaCmqt4oqs6ukU+UFVQKrwGE8mZgi9F65fidVDnOMLWUyK2S52HRVpGBPpLtK1/yNeTlxR9FbhaR5IHnOWKomhtsfg34JP2w9Viq7ayouwUMDCMFZ+oCPtEqJHyPGOXtrwfJm+wijiOwt/iqTTUM0RWRrB1wwu8okazRFNsLv/wQGwQOFHwheu9zzzdXhp70WbjcfpW+5ebVDz0bPtM1gcD6zIFMCoCejgM4Umb8GXrPxBkeiwnfZrXg54JLukCwf0REKRxk3HnnK9hHcdUnLyC4FmLQKnesdqk0oZ3QtwHIYSUVAlu4Bj97+Ge8bJHhJxn/KogiqE4BSMwRpFzk151yyZ8t/jimUOE3FWOtSOS/MZ3pciAp2YuVJyxnXxI4sy7Pz5IUJBIeeoUZgp37QI/Dxc+S19JCW0kDTFkSFDOSzZN0l+4c0RSSmpNsTWQrIm+buoeWLV34Q
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(396003)(346002)(136003)(376002)(451199021)(40470700004)(46966006)(36840700001)(7636003)(54906003)(47076005)(16526019)(110136005)(356005)(107886003)(83380400001)(70206006)(186003)(26005)(70586007)(2616005)(36756003)(426003)(66574015)(6666004)(7696005)(478600001)(336012)(41300700001)(5660300002)(86362001)(40460700003)(82740400003)(40480700001)(316002)(4326008)(2906002)(36860700001)(8676002)(8936002)(82310400005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2023 13:56:57.6618
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 760a602e-bc40-41ef-95fe-08db719636a1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN8NAM11FT090.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8209
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

These two selftests however check mirroring traffic to a gretap netdevice.
The bridge here does not participate in routing traffic and the IP address
or the RIF are irrelevant.

Fix by disabling automatic IPv6 address generation for the HW-offloaded
bridges in these selftests, thus exempting them from mlxsw router
attention. Since the bridges are only used for L2 forwarding, this change
should not hinder usefulness of this selftest for testing SW datapath or HW
datapaths in other devices.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Danielle Ratson <danieller@nvidia.com>
---
 tools/testing/selftests/net/forwarding/mirror_gre_bound.sh | 1 +
 tools/testing/selftests/net/forwarding/mirror_topo_lib.sh  | 1 +
 2 files changed, 2 insertions(+)

diff --git a/tools/testing/selftests/net/forwarding/mirror_gre_bound.sh b/tools/testing/selftests/net/forwarding/mirror_gre_bound.sh
index 360ca133bead..6c257ec03756 100755
--- a/tools/testing/selftests/net/forwarding/mirror_gre_bound.sh
+++ b/tools/testing/selftests/net/forwarding/mirror_gre_bound.sh
@@ -98,6 +98,7 @@ switch_create()
 	# Bridge between H1 and H2.
 
 	ip link add name br1 type bridge vlan_filtering 1
+	ip link set dev br1 addrgenmode none
 	ip link set dev br1 up
 
 	ip link set dev $swp1 master br1
diff --git a/tools/testing/selftests/net/forwarding/mirror_topo_lib.sh b/tools/testing/selftests/net/forwarding/mirror_topo_lib.sh
index 04979e5962e7..bb1adbb7b98a 100644
--- a/tools/testing/selftests/net/forwarding/mirror_topo_lib.sh
+++ b/tools/testing/selftests/net/forwarding/mirror_topo_lib.sh
@@ -60,6 +60,7 @@ mirror_topo_switch_create()
 	ip link set dev $swp3 up
 
 	ip link add name br1 type bridge vlan_filtering 1
+	ip link set dev br1 addrgenmode none
 	ip link set dev br1 up
 
 	ip link set dev $swp1 master br1
-- 
2.40.1


