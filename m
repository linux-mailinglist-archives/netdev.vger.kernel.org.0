Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BFBA47C1E2
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 15:50:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238647AbhLUOuQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 09:50:16 -0500
Received: from mail-bn7nam10on2085.outbound.protection.outlook.com ([40.107.92.85]:64928
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238643AbhLUOuP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Dec 2021 09:50:15 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fJjpzTgFafJ4slov+Hl0WK9bzGQQXjYy98nBR4O07yjOqfn5CVCILS8LH0NBdW3uvwKLf7mGKEG5LBtBuMUgn9Owr7JbqNaM6bHyPP2dYOod45mlMe3byi4SDhU4ywiMPFqXiNBYhfEdMwxsmWlBiM2Ag/FWFo2MVZcHCqcTvoSIcPhdySC5seBzbwL3jWCjvC53todmg4XPGDBi7BByhN1u+vp090qMFJkXyxIUdp8ylpMPdu9ZLP1fC7FGlB64ruSlvdXGdlJpRjowyUyClqCVsYz72Wwlzg61IhG3VL8t9mBGXMD6rZCKZMzAqv0aJu9aeTgtp6uSBNS+Q7NbtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XPLWX7FFfVt2WrR+jB0Julfr0cA+3alViQKIlR+0mmU=;
 b=cK+FWo/i7uHZ2QQy2ixbRTgc/aSXdiUW3veiiS98gkisCELWoGjqipywgnD30LfHYpIy4Wz+yIkgNXkuFUl+mik91yPmLiJHnPR3CqAmHTiDQ9sOVi09+bN7TgAv0BYQdGALoQBrJ3irybt4UhXzasOshXJlw9zgPXFgt/w8ODia1otspoV2Bg+G2sb957Ra7P0z7q0wyot8PC0KZItcM0Gxs3zbDDBRtyxiT9APIQ5rTT1ygxRb/yed/qe9+7vSAjmgyNabijwD0RWodmTTzomRm8cTTxRCXzfrLncHo8FP+yfEmFj2xlN/EaVH1ooQh/zzMmV2PRMm6bC/pVriJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XPLWX7FFfVt2WrR+jB0Julfr0cA+3alViQKIlR+0mmU=;
 b=lHdun5XriLGredBglKM7mFU0o9xW8EdOaI7FGu9P8/1hY4ysehRgTAzlDEHCSCwerzRa9pNy8rlhREXw6Ke4XtH03HWHN1E0mz48ais7cra05wyXAkraySeM1Dt3g8trteZr+qIg8hQJ/6WCZkWFogHLStQbfQzoVIg5+0iuC/A1uXe3iw5geoBCjqJKFPNajUExhOY7R+hA0rmxt/anC2piepfXgz/+utgjueK+57teXyfcO2x8n/jdax2JMKyh2kyLseHU+qth6ljN+YWv4Fnbcr/tSkpddhHr9w21NBxTzxIAnmBirDVlAjA84WPXZifZuvKfdvhNhjlqUhcVag==
Received: from MW4PR03CA0319.namprd03.prod.outlook.com (2603:10b6:303:dd::24)
 by BYAPR12MB3159.namprd12.prod.outlook.com (2603:10b6:a03:134::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.17; Tue, 21 Dec
 2021 14:50:13 +0000
Received: from CO1NAM11FT056.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:dd:cafe::84) by MW4PR03CA0319.outlook.office365.com
 (2603:10b6:303:dd::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.14 via Frontend
 Transport; Tue, 21 Dec 2021 14:50:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT056.mail.protection.outlook.com (10.13.175.107) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4801.14 via Frontend Transport; Tue, 21 Dec 2021 14:50:13 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 21 Dec
 2021 14:50:12 +0000
Received: from dev-r-vrt-155.mtr.labs.mlnx (172.20.187.6) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.986.9;
 Tue, 21 Dec 2021 06:50:09 -0800
From:   Amit Cohen <amcohen@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <mlxsw@nvidia.com>,
        <idosch@nvidia.com>, Amit Cohen <amcohen@nvidia.com>,
        Petr Machata <petrm@nvidia.com>
Subject: [PATCH net-next 2/8] selftests: lib.sh: Add PING_COUNT to allow sending configurable amount of packets
Date:   Tue, 21 Dec 2021 16:49:43 +0200
Message-ID: <20211221144949.2527545-3-amcohen@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211221144949.2527545-1-amcohen@nvidia.com>
References: <20211221144949.2527545-1-amcohen@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 222c7356-fad3-44f6-0915-08d9c49131af
X-MS-TrafficTypeDiagnostic: BYAPR12MB3159:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB3159E6B96D0D9334C1C51C16CB7C9@BYAPR12MB3159.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vKTDFm8/r9MJn0Py+Xk64alWN6AzCJ38594TfXIfvKFuxX+tnIt9MGSfL2y5eNJp/yAh2taalyWgZFIrpazr9/mT/W6+4GqLjJP45V2vrQk3s6svsCjxrJtDwxzp3PQ4VX1w6z+/+qqu2PazSktJFL2RYHZBco/Y7Saq1cW9/ka12LV4isvJ1f3a2Y5n1BbmSy0jZ0/CRqZ3Xz/MKWQIAq3SLD07orFdI7bhJ3DEsYaKu+y2JufQsq1qiZQHjGQXXyjW3Xg2VtN/9DR+CYSdnYX2C8xCaLRo9Z89lfuTtkq/7GTMpukNM57oD/g6mnxCVdgwpzy2bhTygwMrSkh+Ac9S80YRba9vEX2qHmKDotMqEhQqz7b1toZllEej0a2i1VAA/5p3DPK5kQ54yl2OjCRldYekxbJR2YviLV23Z24WgQisgekSX5joO4An1UIyRu2OYIoWgRz+mQhru5TYusOo92QcHGPggn3Kc8Gp4L0JgtY+rxk5gmAsXnd0apo3jTGxVe/Lb5+aKNafzmSeZ3f0eXI/ATphu/gpWWv4Hws96EiXJ/iAMSVbSoiipNpQcxMAqMXyaqx3Y9yqubg/kW98E2yQJRF8VOjKkzMu1Jh3+Uv95Duhj8ZXXvGW+TBVezuJJmzWYxcmfRYwY5hAcnUZqNbXd+LsTZbck6DZczceafPVT+ilmN/6w+GuN0Eq2n4yOKXXSgZx36K2Mo5I3rlqYfHnfnHVzu/6jgVwKXFJHI2XHYh3t64lIqqjKY9Bi8MKaSQUN/GEiXFVPhl/8MYAps/o2QXMlLFhwa+1BbjG8+0wxwMY04fKa5P5TZFC8t3VMiI3Wb9LwC2VkTQ7ig==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(46966006)(40470700002)(36840700001)(83380400001)(316002)(40460700001)(8936002)(107886003)(2616005)(508600001)(186003)(6666004)(426003)(6916009)(336012)(16526019)(47076005)(8676002)(36756003)(1076003)(81166007)(26005)(34020700004)(82310400004)(70586007)(54906003)(70206006)(2906002)(36860700001)(356005)(86362001)(4326008)(5660300002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Dec 2021 14:50:13.1398
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 222c7356-fad3-44f6-0915-08d9c49131af
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT056.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3159
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently `ping_do()` and `ping6_do()` send 10 packets.

There are cases that it is not possible to catch only the interesting
packets using tc rule, so then, it is possible to send many packets and
verify that at least this amount of packets hit the rule.

Add `PING_COUNT` variable, which is set to 10 by default, to allow tests
sending more than 10 packets using the existing ping API.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
---
 tools/testing/selftests/net/forwarding/lib.sh | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/forwarding/lib.sh b/tools/testing/selftests/net/forwarding/lib.sh
index dfd827b7a9f9..7da783d6f453 100644
--- a/tools/testing/selftests/net/forwarding/lib.sh
+++ b/tools/testing/selftests/net/forwarding/lib.sh
@@ -20,6 +20,7 @@ NETIF_TYPE=${NETIF_TYPE:=veth}
 NETIF_CREATE=${NETIF_CREATE:=yes}
 MCD=${MCD:=smcrouted}
 MC_CLI=${MC_CLI:=smcroutectl}
+PING_COUNT=${PING_COUNT:=10}
 PING_TIMEOUT=${PING_TIMEOUT:=5}
 WAIT_TIMEOUT=${WAIT_TIMEOUT:=20}
 INTERFACE_TIMEOUT=${INTERFACE_TIMEOUT:=600}
@@ -1111,7 +1112,8 @@ ping_do()
 
 	vrf_name=$(master_name_get $if_name)
 	ip vrf exec $vrf_name \
-		$PING $args $dip -c 10 -i 0.1 -w $PING_TIMEOUT &> /dev/null
+		$PING $args $dip -c $PING_COUNT -i 0.1 \
+		-w $PING_TIMEOUT &> /dev/null
 }
 
 ping_test()
@@ -1132,7 +1134,8 @@ ping6_do()
 
 	vrf_name=$(master_name_get $if_name)
 	ip vrf exec $vrf_name \
-		$PING6 $args $dip -c 10 -i 0.1 -w $PING_TIMEOUT &> /dev/null
+		$PING6 $args $dip -c $PING_COUNT -i 0.1 \
+		-w $PING_TIMEOUT &> /dev/null
 }
 
 ping6_test()
-- 
2.31.1

