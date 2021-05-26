Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 788F73916F3
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 14:02:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234263AbhEZMDV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 08:03:21 -0400
Received: from mail-bn8nam12on2057.outbound.protection.outlook.com ([40.107.237.57]:35617
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233203AbhEZMDN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 May 2021 08:03:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uf+Hn5oOY5pI7KacFb8mcm47Jz41iZgeXMFlaW7Kk0pIPinFiabdPZmQDaO/qyekQIpGbxF+4w8kACx7y6u2T/nlPyG0fUvKDS5VbWTv61wsJlBcJl4RshdWOdxxjbZENfWAyIoWWPbOT80IGRTlgLTDvqAwlQAufkTlifL0s6j3vMG2ovpcMKy423s3aBMpUGBBK/CWDHxU8vFEjATte+O7a6Au+/o02/pvdsZpDf3955+M+8064t07n4YmVYKVk3RaGyBAACIamkoor7AQdB7k8+ZFaWO+DAPpATXndJlLYmFQnvU4zS4T75mhOLJ8ucra3k+MOuLgHp4bc/SUow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E+WSe9UwMbwu8YqblmRLM0HskzdUFtBQWHklUr2ts/Q=;
 b=kqi2U7QQiSfCi+/SmcBkM3H/DDSK34cGayXxr6Fz6so9eLPe46mkSH+Hx/fDFG7U4O2fxaLLFANwTVEj7gh7kxH1bH4ioQbQM2M9e2XCoanjDrKa3pikegKQFW2FGoFgPvotTcklabVOcKt0ruuWRZbtnwLYVurOhNUzFuVnMRCcZW71LYZ/kO/6gpJgj50QnQfD0PAdlxZc7zfLlU0I8s9p5YxMOddfCbtVKg3cV01lZSz+hz7kyScJOubm+Y9lTRFEYFo4D0l4Zzp5ZvQtCBHgNIgFNr8n3h+oAtzNvE5nRHQ6nrQkCUGIqJJy4vgGYK6+rDUhCCrro8UIAdyAWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=networkplumber.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E+WSe9UwMbwu8YqblmRLM0HskzdUFtBQWHklUr2ts/Q=;
 b=eBxcn2+jiTXWweTwKrUtsELARSzyDMHHOIo+lraDrSO5PDQxm0KL5onBkkIeLA3IatPIMNcJ1uIH2jTSFerM+NsROd2wQw4VHl4X5TDFYcw0QYQqCTOgitBew7Ewe2EQ+/NSq0i1Q4ibE4iKRGbhZfIcNfVHW1TYGE6BQxpzhBA/p6kcePxRHd4ZbTB/SiCCR2CH1SKMK54tObaJ5qmU2I5XWbwY/XOgPtJMuVWmLrLKVOrapT3NojPZ4FENkhwcOebbrDIecE/GE+lsPirqMneK/9oZsOHfWPhN+sO0R3Is8u9dF3x30HyWvkkDvXmRtq4XoezXpiFxEvUx51fjkg==
Received: from MWHPR21CA0048.namprd21.prod.outlook.com (2603:10b6:300:129::34)
 by BN8PR12MB3218.namprd12.prod.outlook.com (2603:10b6:408:6b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20; Wed, 26 May
 2021 12:01:38 +0000
Received: from CO1NAM11FT004.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:129:cafe::e7) by MWHPR21CA0048.outlook.office365.com
 (2603:10b6:300:129::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.2 via Frontend
 Transport; Wed, 26 May 2021 12:01:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 CO1NAM11FT004.mail.protection.outlook.com (10.13.175.89) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Wed, 26 May 2021 12:01:38 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 26 May
 2021 05:01:37 -0700
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 26 May 2021 12:01:35 +0000
From:   <dlinkin@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@nvidia.com>,
        <stephen@networkplumber.org>, <dsahern@gmail.com>,
        <vladbu@nvidia.com>, <parav@nvidia.com>, <huyn@nvidia.com>,
        Dmytro Linkin <dlinkin@nvidia.com>
Subject: [PATCH RFC net-next v3 08/18] selftest: netdevsim: Add devlink rate test
Date:   Wed, 26 May 2021 15:01:00 +0300
Message-ID: <1622030470-21434-9-git-send-email-dlinkin@nvidia.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1622030470-21434-1-git-send-email-dlinkin@nvidia.com>
References: <1622030470-21434-1-git-send-email-dlinkin@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c32f714d-3648-48a2-e032-08d9203e0465
X-MS-TrafficTypeDiagnostic: BN8PR12MB3218:
X-Microsoft-Antispam-PRVS: <BN8PR12MB32182ACB1018E1A36378FFA3CB249@BN8PR12MB3218.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2399;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SgT93dL/sQikB5biEUt57Qes6XR2VuaKGSYElpTWdc132wqBLvK71kyDAn7byXZlRtLbp52J7emsq5xGJEKVjuPslupE8T4c/eZVSCfUCiUVaaqtVYk6pW2AbScln6Q88UHFBQvsXwp8/E/FGoqu4jRxVADamoeaiUBif2ezBLssIIBJaDNbRRE4TTvXL88SGQtbsFvpeEz8BwyhqxvWc9c9n735Snidxy0o9SGRBfjPqDYN+aktBPKMuxNidUkN4JZnDD4p0eEbENTswU9FgIclxmSitZwEiYZw7lGXIGaiTBhPZfYEpNSM5rq0UHok0H+2Y431A2b/QjQitsbRe5SF8On3IVjKiPto3+fDSOXMCn11g/O41gND84V3KAECcFOd6G5heAhOAolmL140RswqNzoeccvf0jeIMgZqLn6ZyKVn+8EV1yNfFlLsMh3sdy5fxnVtrl0Onq7tV9jgnirKMhNMnBCY9icQe/R7KNueGwK3OZsJtmsdS2l1hlU9NQKRPiDMNg+03YdVhtW6ovHqOHBEm+Tlr8OWwbYwvr3c5wr9q5wDm5K6STI2UBWe7IPieEJSOACJlO9LDtlA1I6RWVz0kvnQr2Wgi43zwaqOOFUyo26+/Uk8uoAJL0qs42QKOoE4QC4i01/gSOTBGA==
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(39850400004)(396003)(376002)(136003)(46966006)(36840700001)(426003)(2616005)(82310400003)(8676002)(8936002)(2876002)(54906003)(4326008)(26005)(5660300002)(7696005)(83380400001)(2906002)(336012)(6666004)(70586007)(82740400003)(70206006)(107886003)(316002)(6916009)(47076005)(7636003)(36860700001)(478600001)(36756003)(186003)(356005)(86362001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2021 12:01:38.1663
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c32f714d-3648-48a2-e032-08d9203e0465
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT004.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3218
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmytro Linkin <dlinkin@nvidia.com>

Test verifies that all netdevsim VF ports have rate leaf object created
by default.

Co-developed-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Dmytro Linkin <dlinkin@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---

Notes:
    v1->v2:
    - s/func/function in devlink command

 .../selftests/drivers/net/netdevsim/devlink.sh     | 25 +++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/drivers/net/netdevsim/devlink.sh b/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
index 40909c2..c654be0 100755
--- a/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
+++ b/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
@@ -5,12 +5,13 @@ lib_dir=$(dirname $0)/../../../net/forwarding
 
 ALL_TESTS="fw_flash_test params_test regions_test reload_test \
 	   netns_reload_test resource_test dev_info_test \
-	   empty_reporter_test dummy_reporter_test"
+	   empty_reporter_test dummy_reporter_test rate_test"
 NUM_NETIFS=0
 source $lib_dir/lib.sh
 
 BUS_ADDR=10
 PORT_COUNT=4
+VF_COUNT=4
 DEV_NAME=netdevsim$BUS_ADDR
 SYSFS_NET_DIR=/sys/bus/netdevsim/devices/$DEV_NAME/net/
 DEBUGFS_DIR=/sys/kernel/debug/netdevsim/$DEV_NAME/
@@ -507,6 +508,28 @@ dummy_reporter_test()
 	log_test "dummy reporter test"
 }
 
+rate_leafs_get()
+{
+	local handle=$1
+
+	cmd_jq "devlink port function rate show -j" \
+	       '.[] | to_entries | .[] | select(.value.type == "leaf") | .key | select(contains("'$handle'"))'
+}
+
+rate_test()
+{
+	RET=0
+
+	echo $VF_COUNT > /sys/bus/netdevsim/devices/$DEV_NAME/sriov_numvfs
+	devlink dev eswitch set $DL_HANDLE mode switchdev
+	local leafs=`rate_leafs_get $DL_HANDLE`
+	local num_leafs=`echo $leafs | wc -w`
+	[ "$num_leafs" == "$VF_COUNT" ]
+	check_err $? "Expected $VF_COUNT rate leafs but got $num_leafs"
+
+	log_test "rate test"
+}
+
 setup_prepare()
 {
 	modprobe netdevsim
-- 
1.8.3.1

