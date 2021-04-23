Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 585A43691FF
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 14:23:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242301AbhDWMXe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 08:23:34 -0400
Received: from mail-mw2nam10on2040.outbound.protection.outlook.com ([40.107.94.40]:14048
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S242556AbhDWMX2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Apr 2021 08:23:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=noRYkpoDoOWGDi+P/Uzwt4ZMjHEI1IJrlXTVVjVHjpA5Ry9RhrEnRlhOvdhiq8wvT+Tivh50cpgQekjByF1nXsWnVMY+oKEq5RU9KjgM3eWOcrJaO2ZAnX+ub8xUXgSW+vNL1ElsBZwVf8aKdTB+voQY6hhDcb8Z+0//b0lfBwE/2wNzTD304phCZTTM44B6fQN9GgYNqZITPqmX33gODzrwInVGD9V3BNr9dvuKVHgRPugIVPD1aeUmK8aKDuBSlRyhoBvzD5Tdcm+5BF2X0nEtdH67Q3Z60n8OVUM/QYIbGAdj6i/d5sZQvBTMhXcoCiEtNYyesV9WD+Phz7eGvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XZnu+pz2wk9QHig2xzx2MkbpH87ZMG8yM812MAlPx3Y=;
 b=IrzhrA3ot0Lv+gO33dso/lK8C/osp2s9vZ3j3j5iGjhWXuhgBKByiTaqfa+cK0NqD3jjFOkmwWgapTlbaBpEpGMk4yrIKh7Yfy1J1rTOTF2QlaN2hDqUXCi5+AtDwe2E9EnzZOg2xiGZomWQlfu81kc8s9mCHeu1FoGTxlRp8lyUCWahZuD8c5scqLXDts4xMImspFb5hoZ79jQplucVspGUEFsr2ciJUfzrm/ckD1OYF2y4heuuUHQa3PHzctLO+qw+VbAXD9Xr9Jo6Fn7/Jsbg1lI1Eoxio1QSteIiOFAaDZWqf3JfGcqNLi+BCsmC4pFRUWDczSE0YsL00G2g+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XZnu+pz2wk9QHig2xzx2MkbpH87ZMG8yM812MAlPx3Y=;
 b=WpBOGvUjO3DRI6Me/dIFpgyBH5ufxxXfwdZwubssWKVwvaqLFuZKcadKIcXQauvVGnnjyWtd260Ycwceajb8mKF2josfDOIfakui3P90+/97nm7UK6eHvmttaD+dbUhAe090yYpUScAzVj7Gw0gecSgsTLZz6wk6GWZKOOZtUOpNFzufo4Lxq1DJRirjw+7d098rK1yybCZcPVO4M/fZhcA9k5AETmPeaGou8qrCy+zjqbmRlmkmmr+XpOmgN1dx+iapIuWNRRTBvb3Guh5BYSFPmHPxhuOhIV7SIikZO71LPZPs47ytgxDHXZ3cHjw7Bz/VPT1kc9DLFdqao1yFEA==
Received: from BN6PR14CA0005.namprd14.prod.outlook.com (2603:10b6:404:79::15)
 by MW2PR12MB2556.namprd12.prod.outlook.com (2603:10b6:907:a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.22; Fri, 23 Apr
 2021 12:22:51 +0000
Received: from BN8NAM11FT008.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:79:cafe::88) by BN6PR14CA0005.outlook.office365.com
 (2603:10b6:404:79::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21 via Frontend
 Transport; Fri, 23 Apr 2021 12:22:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT008.mail.protection.outlook.com (10.13.177.95) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4065.21 via Frontend Transport; Fri, 23 Apr 2021 12:22:51 +0000
Received: from localhost.localdomain (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 23 Apr
 2021 12:22:48 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <mlxsw@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Danielle Ratson <danieller@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>, "Petr Machata" <petrm@nvidia.com>
Subject: [PATCH net-next 4/6] selftests: mlxsw: Return correct error code in resource scale tests
Date:   Fri, 23 Apr 2021 14:19:46 +0200
Message-ID: <792e1fa1bfd0c5df815b910f5a9e1f4ca2d77921.1619179926.git.petrm@nvidia.com>
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
X-MS-Office365-Filtering-Correlation-Id: 9e961282-9c2c-4035-2dec-08d906528399
X-MS-TrafficTypeDiagnostic: MW2PR12MB2556:
X-Microsoft-Antispam-PRVS: <MW2PR12MB2556750C6FDE7DC54317573DD6459@MW2PR12MB2556.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: z7A5yACLhfSnFZf2oFDqq9FcQzdgrmNN4Hi7CwfpqfOhNq19ZhKo3VlhwQzP2XPcVyU+nv2E2MFL9A/hr95sqAmTD3JCRkCHU4HH1Qz4k8uB99dLGMSVrHBQijBCmb1q+nKXxMk5AN4KX6iC+Df4c+uTt2rGABA373MKu85RFFzbc6W2/gIE1IS68Qh2yIRd+tooq/fmkF3W8EY+R1120kTtqK0AcOiArE7HUNe8opOhP26TFBARBwyfR9n21yjXXWbDvTRo56QR8/iYQhAy8K+kboYR3OYVpEV/sFb80ipLEAcbZSukgFh0z33vyagZRxED15Wqg+uYI3r4e9ZanGYYW//Y6aHrrjFEKbZc8Xp+qbvzojcO5unk9N06ILiUA99xeMveRELJTQbRjFyJ4TS1FnToEajiwJ6KhGWV8B6hBQBc06hua3+col+hKExu3CBQf9Uy92v4RwHCAy8PF1s0BC4KnPQjzv0PES0Cq60gvHJ7uoC24T3xZ/1bz/wBOxXV08RAAfvla8/Rxp4GHzcTmp6JHw3jfjfArQMfoe4tGuV8I38CJFQqZ4WQnYj8gP+CpY4ELNTnAk7ImbiK2tm/JZMq/aOOH5rQd41j0M80d0tfGfX+5a43Uy7rehPq6j3xcu5iH0Q73Ng4+RFMPw==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(396003)(39860400002)(136003)(376002)(46966006)(36840700001)(316002)(54906003)(36906005)(8936002)(107886003)(16526019)(356005)(86362001)(4326008)(336012)(2906002)(426003)(6916009)(8676002)(36756003)(82740400003)(26005)(2616005)(5660300002)(7636003)(186003)(83380400001)(70586007)(478600001)(70206006)(82310400003)(47076005)(66574015)(36860700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2021 12:22:51.2715
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e961282-9c2c-4035-2dec-08d906528399
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT008.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR12MB2556
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danielle Ratson <danieller@nvidia.com>

Currently, the resource scale test checks a few cases, when the error code
resets between the cases. So for example, if one case fails and the
consecutive case passes, the error code eventually will fit the last test
and will be 0.

Save a new return code that will hold the 'or' return codes of all the
cases, so the final return code will consider all the cases.

Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 .../selftests/drivers/net/mlxsw/spectrum-2/resource_scale.sh  | 4 +++-
 .../selftests/drivers/net/mlxsw/spectrum/resource_scale.sh    | 4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/resource_scale.sh b/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/resource_scale.sh
index 4a1c9328555f..50654f8a8c37 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/resource_scale.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/resource_scale.sh
@@ -30,6 +30,7 @@ trap cleanup EXIT
 
 ALL_TESTS="router tc_flower mirror_gre tc_police port"
 for current_test in ${TESTS:-$ALL_TESTS}; do
+	RET_FIN=0
 	source ${current_test}_scale.sh
 
 	num_netifs_var=${current_test^^}_NUM_NETIFS
@@ -48,8 +49,9 @@ for current_test in ${TESTS:-$ALL_TESTS}; do
 		else
 			log_test "'$current_test' overflow $target"
 		fi
+		RET_FIN=$(( RET_FIN || RET ))
 	done
 done
 current_test=""
 
-exit "$RET"
+exit "$RET_FIN"
diff --git a/tools/testing/selftests/drivers/net/mlxsw/spectrum/resource_scale.sh b/tools/testing/selftests/drivers/net/mlxsw/spectrum/resource_scale.sh
index 087a884f66cd..685dfb3478b3 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/spectrum/resource_scale.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/spectrum/resource_scale.sh
@@ -24,6 +24,7 @@ trap cleanup EXIT
 
 ALL_TESTS="router tc_flower mirror_gre tc_police port"
 for current_test in ${TESTS:-$ALL_TESTS}; do
+	RET_FIN=0
 	source ${current_test}_scale.sh
 
 	num_netifs_var=${current_test^^}_NUM_NETIFS
@@ -50,8 +51,9 @@ for current_test in ${TESTS:-$ALL_TESTS}; do
 				log_test "'$current_test' [$profile] overflow $target"
 			fi
 		done
+		RET_FIN=$(( RET_FIN || RET ))
 	done
 done
 current_test=""
 
-exit "$RET"
+exit "$RET_FIN"
-- 
2.26.2

