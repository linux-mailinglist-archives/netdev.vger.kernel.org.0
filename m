Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23581383B1B
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 19:19:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236222AbhEQRU6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 13:20:58 -0400
Received: from azhdrrw-ex02.nvidia.com ([20.64.145.131]:52736 "EHLO
        AZHDRRW-EX02.NVIDIA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232996AbhEQRU5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 13:20:57 -0400
X-Greylist: delayed 901 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 May 2021 13:20:57 EDT
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.177)
 by mxs.oss.nvidia.com (10.13.234.37) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.858.12; Mon, 17 May 2021 10:04:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mJ6HjC5yG96axcpGw6lR3BhE9+nW8fyLqxfyg+q19XjDyIQdBxchUbRhOlMOolSJCdqfORCfZldD4JvqlpgOE7fLgRcvHCn+g7UCTf8rmhEamqzS+Toq/WXMRJTY45v10CthChY/wRKvhZ85/riFM1UXJBEJ09SJBk1aDIYXqmI/OPzaOSBEaoTRlGSkgh8ilRHpJTqVxQjssd/MyqT5M/cGKu8RnvvAO1Pz7pIcI4tNP4ARxUVoGbhKTYyvnQuh1YF9jlBs/qPEEiU9l9BuGHrbUMoiFoUBVRXo+YT7ncHjsteAPrd+ZBiBQE6PVA/XQ6/vBdthHeffTE6UpIm6TQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RCRYPwM81ozgS6edZZImDljsiyyjG2BigCm41nxllnE=;
 b=Kf/eoAL+83M2mEzXnYXvDokjEGiFOag75oiK4i5qjBjlNnaLL/KjrsZX41FEy+ecTigQ6JDG4XaPimX+IZHUIvwXCvtc4njKrYIpMac3ZC8KjV1EDHvW8RVy7dOYgptSRfPdyZy6v2QqQ5C/lhuKYiijiJ9Kw/08D9t/qtlFZfi7K3zU9fMI2SwA0CJVf1B0G4R/CoZCZqWPILBqteSCy63NXonulrc/dj8uzR7bYHhg/5SsIAFsCCTRg/fkmwo1dJJkh3i1qO4KZVSDs5fAGbh/aEazl4Kc77Nwn/IszOVSMXURxqoL/8SAAnSkFbtIvM7AOUVG9K/1mp5YFzKXwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RCRYPwM81ozgS6edZZImDljsiyyjG2BigCm41nxllnE=;
 b=XGC3CIA7AGIQFLTNq8RCYZDBJOklN1nuPElhOkVQz8NMJUWopmouO1c0Pf74tvQbijZTVCq40WqYoJAbnhVRIaYMFg58FLzwhcyiVW0AmjhU+adzcB/MLR6qQ5yebx3ZHNFIflekSgcWN6oH45GvDHYzVOm4dOqqAP0JZgquM7RfsMQfFMsjfOWZiZjAxfDWMX8q1hJnTokopo7VvLhboPZz+QprWzCu+8CQmHhcNSEWWDzS/EsEyanXVRQUAv1VLCiyIzIzZD6dzXwuIPi/xkYHFMTJkkXx98V2t+a3hg3uYmgV+Q+dmQolKp7TBGBq05DHzmSYA9nYaB6qG6EGnw==
Received: from DM6PR17CA0029.namprd17.prod.outlook.com (2603:10b6:5:1b3::42)
 by DM4PR12MB5184.namprd12.prod.outlook.com (2603:10b6:5:397::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26; Mon, 17 May
 2021 17:04:37 +0000
Received: from DM6NAM11FT008.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1b3:cafe::f3) by DM6PR17CA0029.outlook.office365.com
 (2603:10b6:5:1b3::42) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend
 Transport; Mon, 17 May 2021 17:04:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT008.mail.protection.outlook.com (10.13.172.85) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Mon, 17 May 2021 17:04:37 +0000
Received: from shredder.mellanox.com (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 17 May
 2021 17:04:33 +0000
From:   Ido Schimmel <idosch@OSS.NVIDIA.COM>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@OSS.NVIDIA.COM>,
        <petrm@OSS.NVIDIA.COM>, <danieller@OSS.NVIDIA.COM>,
        <amcohen@OSS.NVIDIA.COM>, <mlxsw@OSS.NVIDIA.COM>,
        Ido Schimmel <idosch@OSS.NVIDIA.COM>
Subject: [PATCH net-next 01/11] selftests: mlxsw: Make the unsplit array global in port_scale test
Date:   Mon, 17 May 2021 20:03:51 +0300
Message-ID: <20210517170401.188563-2-idosch@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517170401.188563-1-idosch@nvidia.com>
References: <20210517170401.188563-1-idosch@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c6198270-0a7a-4a0f-427b-08d91955da54
X-MS-TrafficTypeDiagnostic: DM4PR12MB5184:
X-Microsoft-Antispam-PRVS: <DM4PR12MB51843C722FEA841341E823EFB22D9@DM4PR12MB5184.namprd12.prod.outlook.com>
X-MS-Exchange-Transport-Forked: True
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cJVyEmwheZdhpziSgeOmGPmP+0vX4p+75niZH1MZEwtH6hTannLIZCX5U/rrvyWO0FMIdzwLGseH1NQ+Ox6cgRNNRdIDmAgPbxOHgHc5faz8yxySKUl433LIfk4KQWKoQPmGQINniUUFIk+Jjrdiy+VznGXG47bZRqIpRLcbe1hDjC0bwc6KkLmJvJGXSCyXixhQEfriBwz1F9uz3MtP3Ryc3rR50ozr/SN+C6INiUwzHU1vO+7BitkUg4l/c5ovBTZVradXFObF2Enad9cYq3G63brO1JewCbx9OHmuAB5tDuZdrIlOUMAICOxWfTxtAhkC02fDeQvmHv3fABsZak7jN8BG01PXiHpgruaLmrfcHPuRxY9f8KK09pjWawBb75pSjTJYqA47dorinpfYSVJEMuW8oXF2wEtMF4VeOC2TKYvKA/brk7JOWPlRzHf1GOA4wfOlWuseSb2t+qJOsY8R97fOG19kEP0MXyiaoUGwjvAIL5Kkmr9relgWj4/KjyPkk9OfAY1PF5yXYz0hCVQvlaMb4TIf3Qp5ZvVRsvza25fyrrVwhCr3R/kyP3Q33V3H3oI7O6Hk+2qicmGaCLORJyZ3Rft67Zmc/kAkoX+SSlvlrgaycaSV1GrzpYoJfsuX0LHvohkMVNQTMD8c21HRHsXEU91uHJG1Pm8PoCg=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(396003)(39860400002)(136003)(376002)(46966006)(36840700001)(4326008)(336012)(426003)(83380400001)(36860700001)(86362001)(107886003)(8936002)(8676002)(316002)(2616005)(36906005)(478600001)(54906003)(1076003)(16526019)(82310400003)(186003)(36756003)(7636003)(5660300002)(6916009)(6666004)(47076005)(26005)(356005)(2906002)(82740400003)(70586007)(70206006);DIR:OUT;SFP:1101;
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2021 17:04:37.4336
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c6198270-0a7a-4a0f-427b-08d91955da54
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT008.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5184
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danielle Ratson <danieller@nvidia.com>

Currently, the array of the ports that were split in the port_scale test
is local, so the port_cleanup() unsplits an empty array.

Make the array global so the cleanup will be preformed properly.

Suggested-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 tools/testing/selftests/drivers/net/mlxsw/port_scale.sh | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/port_scale.sh b/tools/testing/selftests/drivers/net/mlxsw/port_scale.sh
index 65f43a7ce9c9..1e9a4aff76a2 100644
--- a/tools/testing/selftests/drivers/net/mlxsw/port_scale.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/port_scale.sh
@@ -7,6 +7,8 @@
 
 PORT_NUM_NETIFS=0
 
+declare -a unsplit
+
 port_setup_prepare()
 {
 	:
@@ -20,12 +22,12 @@ port_cleanup()
 		devlink port unsplit $port
 		check_err $? "Did not unsplit $netdev"
 	done
+	unsplit=()
 }
 
 split_all_ports()
 {
 	local should_fail=$1; shift
-	local -a unsplit
 
 	# Loop over the splittable netdevs and create tuples of netdev along
 	# with its width. For example:
-- 
2.31.1

