Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 423C03691FC
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 14:23:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242538AbhDWMXY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 08:23:24 -0400
Received: from mail-dm6nam12on2068.outbound.protection.outlook.com ([40.107.243.68]:23233
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231338AbhDWMXW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Apr 2021 08:23:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mSc2M/HUhtsWVhr1jqqi99+xZyaprQdWz+YYRzKFHm4qWEzMNAiqCOwCWm6lJ2kq3672JiCq4BZ0eOc8UvsACNiKUDW6A/liDrGcCCZXhnh+sm+krW+fWmu8u3SK+vOWm72AHq+vdi9o1UeEmF/WYTo/tgGjOEsySttDgKFxfEhuIHOBwTYWHDAnspPVIKsBt152RjMSlcWcFKmiK5ZHpKG14x9PYyLjt6IdTW7BcAnbLkd/J9OvqH0E5WOqVojoXkwZgjmVN3VI1N4/UOT+6L+cxAnHL/EUbzjthwTNQ4OxNOv+rtreHTB9MenCHegPbWjgOyvJ4U4BXRxQTFcokA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZNXs1CquO1Wlue8e7sqNekAyzy/QaKsPg3LcNoOp8S8=;
 b=iWDVgqCKZTAEXWoZMTRQxaQhzCfVBSjuqcaTEcTxL+JRhqP1xT0QIfELbx0gTFmDV/qn8gZkywkuaZYSgRbyY/4TozMe37RP4tLwfNcdGbCNhgh519DhT/Cisk58+k+4aeMy7l8BFh4iJjLY9wWw8zTM1u3YMeQxDdiEdBYX5kGz5vqiqqM1T/+JY8vJ9S28k+DkuTeh1ZCsb7Mv7Kh27m43iBtD35vpGRjJLMApnb8CEp+JGc0lO0zSdprGQHqwubziH7pa2YLNxW2c1T71PJsNXyN6Df8862GCfyEmb+kazI0lDZxVnZWDzJCIOUM/zgcQML+WdwxrHaPu7sUJjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZNXs1CquO1Wlue8e7sqNekAyzy/QaKsPg3LcNoOp8S8=;
 b=bmx0JHrz6eO2egykYKH/z6U3YOTvbst5G1y+dUtdRERA0oONdDKBBi6n+PoqWwLPl5VdygNyEPreg4EKaG6uDOqKxJAEPsiV9yiD51y2AlprVRonYHHvgJT6eiFF5ZztXuFbtQ413AVBOMGR3nRlYv3Uk8yZ2H0jw8ySnEZ0CYVj1Qn6abqLsYMmqHKJzuxkbsIE5jqC+d0jAxb5f+xZFBYDBiAdwmD2cl0ka1J+wA3iuh7HRkl9zPU6sg7BPCXV4sS2ui89TlZ9vqLE08ju6DDlLAmY6iEb+f1yqiAre3uQRoZeDo4DAkDKwXdLEcBwb2bRTA+tnpp8Aiz3oEiU1Q==
Received: from BN6PR13CA0050.namprd13.prod.outlook.com (2603:10b6:404:11::12)
 by CH2PR12MB3672.namprd12.prod.outlook.com (2603:10b6:610:2d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.19; Fri, 23 Apr
 2021 12:22:44 +0000
Received: from BN8NAM11FT020.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:11:cafe::d3) by BN6PR13CA0050.outlook.office365.com
 (2603:10b6:404:11::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.17 via Frontend
 Transport; Fri, 23 Apr 2021 12:22:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT020.mail.protection.outlook.com (10.13.176.223) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4065.21 via Frontend Transport; Fri, 23 Apr 2021 12:22:44 +0000
Received: from localhost.localdomain (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 23 Apr
 2021 12:22:41 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <mlxsw@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Danielle Ratson <danieller@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>, "Petr Machata" <petrm@nvidia.com>
Subject: [PATCH net-next 1/6] selftests: net: mirror_gre_vlan_bridge_1q: Make an FDB entry static
Date:   Fri, 23 Apr 2021 14:19:43 +0200
Message-ID: <37c81f146401e9c24db019a60163a65d598a7657.1619179926.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <cover.1619179926.git.petrm@nvidia.com>
References: <cover.1619179926.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5ad321aa-5834-461b-0fea-08d906527f84
X-MS-TrafficTypeDiagnostic: CH2PR12MB3672:
X-Microsoft-Antispam-PRVS: <CH2PR12MB367291E0C1039366FB5B18CDD6459@CH2PR12MB3672.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:972;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UEYaRt/z+KRt7TIJtuvVLUdAVV3tu4Gnoj2c5JQ3XnoliJ+duE8aVHXLkFApTX8FLUCsLT5PbahauoP6ZaDWIwFyt0EQCQloIyuQz9jlCqv4VIrmJ24Idww1PE4sRQrATvFMCxMCo43l5V+T64dTa5j/kVBZ/FlIKqMVLX6LOBvwe/4ZAsbIgqJIz1xZKYyPY4XegTHPGhpaFtlsvZb8kFn/CmOgfRtDT+HFncAIvr69v/hDQuBV92QRTTfDILzCYwbhy+hBIkIDy5v41YjR+eqvxnUv1QOip+jFj8yWDsYxCybdzzLHnWIkXsufMkMTQDpdld/F8GRQ4Layik9IN4TN2GYhW8NhFzGavQghCaCirJ6tq9czvQ7+JexmpZxOprRoODjj5VcTdIEBQcOW+8mYmc5t2aIDyjoYUtaQwZXOpzGKQ46jLS0xnBTD003k1sU5Mst28V7MAvWFV8KHJQNJfSeOUFNor5IL/L+6eBGvckZonB1ntGkwZxea7n4mJPl0XIiqAhcsnSXeho85he0gUVybxUmRTGtGbmhSuCBZG3yRYFgbn5pQFxuO5dOk/MVji0ZYEooeoOKX1FZzXybRWBGJPJJJeuTHetKrXhDp2425+e46YnojRlWZmWoiO62moDIUVdDU4z2v9Hm4jub3YVamJ/nlxUQkl6yCO9M=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(396003)(39860400002)(346002)(136003)(46966006)(36840700001)(2906002)(82740400003)(70586007)(426003)(83380400001)(54906003)(356005)(82310400003)(86362001)(316002)(4326008)(16526019)(8936002)(5660300002)(6916009)(186003)(478600001)(26005)(107886003)(47076005)(2616005)(8676002)(36860700001)(36906005)(70206006)(336012)(7636003)(36756003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2021 12:22:44.4333
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ad321aa-5834-461b-0fea-08d906527f84
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT020.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3672
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The FDB roaming test installs a destination MAC address on the wrong
interface of an FDB database and tests whether the mirroring fails, because
packets are sent to the wrong port. The test by mistake installs the FDB
entry as local. This worked previously, because drivers were notified of
local FDB entries in the same way as of static entries. However that has
been fixed in the commit 6ab4c3117aec ("net: bridge: don't notify switchdev
for local FDB addresses"), and local entries are not notified anymore. As a
result, the HW is not reconfigured for the FDB roam, and mirroring keeps
working, failing the test.

To fix the issue, mark the FDB entry as static.

Fixes: 9c7c8a82442c ("selftests: forwarding: mirror_gre_vlan_bridge_1q: Add more tests")
Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
 .../selftests/net/forwarding/mirror_gre_vlan_bridge_1q.sh       | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/forwarding/mirror_gre_vlan_bridge_1q.sh b/tools/testing/selftests/net/forwarding/mirror_gre_vlan_bridge_1q.sh
index c02291e9841e..880e3ab9d088 100755
--- a/tools/testing/selftests/net/forwarding/mirror_gre_vlan_bridge_1q.sh
+++ b/tools/testing/selftests/net/forwarding/mirror_gre_vlan_bridge_1q.sh
@@ -271,7 +271,7 @@ test_span_gre_fdb_roaming()
 
 	while ((RET == 0)); do
 		bridge fdb del dev $swp3 $h3mac vlan 555 master 2>/dev/null
-		bridge fdb add dev $swp2 $h3mac vlan 555 master
+		bridge fdb add dev $swp2 $h3mac vlan 555 master static
 		sleep 1
 		fail_test_span_gre_dir $tundev ingress
 
-- 
2.26.2

