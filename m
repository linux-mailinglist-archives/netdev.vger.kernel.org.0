Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E01F4D4E43
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 17:13:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241094AbiCJQOk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 11:14:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241066AbiCJQO3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 11:14:29 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam08on2083.outbound.protection.outlook.com [40.107.101.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8E90EBADF
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 08:13:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SmisNkaEvjNeAhfEx5ldzCjKyOcqT27p1oqjqukStM0jyz6/1ihIS7KD8XET4QwYno6ZngrztiREGsgzGWp8TDBjjsco2Yhr7lfe3Y/htKfIofcfQHdxWv4/yfpyu5WSrWJpFrEI8/IDGoq6M2/h3Bq6/hkYm9wQOjuorC+QkvqExsdikP8I4ueOY8Ge0oYwAyqCFvEv3lAAQbKu0eWLlTB5/Owou0EHwq2lZJqMwPeVX5T9UuAZEsdSX7oVaeJH8zpkYsocvQu20k8oZNFbMN8FjHj4kMShgzx+MooRYnDY5DW9mXfVBV/37aD2HaXCO+cmTu6/L1+cW48ti3/RCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1ls7aHhWLLaRG8fNNPJX7mAUuXp+TISS6XubplGdelc=;
 b=TS/FvorukvMXBx/ZSvYCEpwyF/VY4OpT2HdX8VuojW5aclutHy8GHu/navAQY1AuK6eBksc/Vk4LgFKQbYsVB1YkcZ5NPgD+3wPlr36J14vPhYW0vJ0QHwDoAYQHZvsZbk11D2DjbelmRO+fcb+MxGsyXZFTR9Gr4i8kcdDrQ/E3FLF0gZd+JnvQk1DNZMhXPrCEZmRUUPtCawZjwQStYJ97JEh3mVZ8ma4f0IIOFcKBacSW1l2+meyVOD2yVW5iXEqvuD4tH7en6lS/NFpA2yv8SHqUJ0g/jTNCGDUEj2cs/XpEw261nweYWd2+eDbdx+lsJyUEGdFv/I9MPJ7D2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 203.18.50.14) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1ls7aHhWLLaRG8fNNPJX7mAUuXp+TISS6XubplGdelc=;
 b=Atj+y2bIN0e1osuo/jTLWM4TTJtXxhsmOgYukbXaCz83dzJ2vlMZGufWdhAL8OpVFXKyytFI0Joywibl45RIVn8sn8R8VicLthJEKxcNe5j0KOnBlcdWIFY/cNK8QltpSdvltMBYHNgfSHbDSD9ThCcECNzCXMC3Yj2sxlzDTNTbw5aRKQHBvLLB5p6I13vZ6kRLvjv12WMnSQPcXPyoussszrH5V34QTjDBhf7k8TNX8JqvyifDAP3YmD0hE7SroCKoPE7mnlCOxIKRKP6a5UY68lo/f70wZN3F++KwBngiipMd3wqfNAhRnWbFYwvtGhh11EY0w8KUJV0TTC0+Qw==
Received: from MWHPR20CA0014.namprd20.prod.outlook.com (2603:10b6:300:13d::24)
 by MN2PR12MB3455.namprd12.prod.outlook.com (2603:10b6:208:d0::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.15; Thu, 10 Mar
 2022 16:13:26 +0000
Received: from CO1NAM11FT044.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:13d:cafe::7d) by MWHPR20CA0014.outlook.office365.com
 (2603:10b6:300:13d::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.22 via Frontend
 Transport; Thu, 10 Mar 2022 16:13:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 203.18.50.14)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 203.18.50.14 as permitted sender) receiver=protection.outlook.com;
 client-ip=203.18.50.14; helo=mail.nvidia.com;
Received: from mail.nvidia.com (203.18.50.14) by
 CO1NAM11FT044.mail.protection.outlook.com (10.13.175.188) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5038.14 via Frontend Transport; Thu, 10 Mar 2022 16:13:25 +0000
Received: from DRHQMAIL101.nvidia.com (10.27.9.10) by HKMAIL103.nvidia.com
 (10.18.16.12) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Thu, 10 Mar
 2022 16:13:24 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Thu, 10 Mar
 2022 16:13:23 +0000
Received: from localhost.localdomain (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Thu, 10 Mar
 2022 08:13:21 -0800
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>
Subject: [PATCH net-next 3/3] selftests: mlxsw: hw_stats_l3: Add a new test
Date:   Thu, 10 Mar 2022 17:12:24 +0100
Message-ID: <ead6b7029d44d7a63c8e66f14f002bad25eb3acc.1646928340.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1646928340.git.petrm@nvidia.com>
References: <cover.1646928340.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b6ddff84-9f23-4991-8850-08da02b0e86e
X-MS-TrafficTypeDiagnostic: MN2PR12MB3455:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB3455FD72D722D2AB95822069D60B9@MN2PR12MB3455.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nDrq4bo6cCgosUrROYLeC5eymHOSWbEDIxJSqBb/BDml7aB9/HN89M/pO4Bq7M11G9vdOqUSUSMJ6CsuARtJVJ7yc9YwO8Qdt2JSKN3a6nhUHWupc9lmfLVRkUBSImCXRvG+0W7ZH7hdPX3hY2IKDKFxU8EX5FdyOaNFsuFBiqSaURs6/e7Od3K34yx1Pz+9ehwmSrBEQXQoAPbilFEPABul04+lrTXRMIIZb7Rg+/k9+YJ8z6EhU3DvpNKfb78E/JAX282s657ery1k0V1HrVDjKYg/2JUs0IkDMILXuGLFNmiRRbG48Yi8U9548y3evr/CWJMMBJgqUVaN08AUOW7N/8qaDPZBVVO/QR9BdT+H1BtSt5ohd4TBW+yjnKV+R9JH8pz7g4z4yGSdVj23R4TmHrGv2zXqmxreGffdfEyGT5QwDRg5XFowM69bvlmaqjBp4tqa9UtST2Xi+ogtV8/NS2JX7pD323snUbVwSSMdjaMUiy6+Zji+w1Na+I4k0k1RS+VY7pShi90Hi54MF8bWM5SRb0tz/7KkVaSdAZ+TsRFDfHmiyBfnVD512FPgZINX0YPwnarsBcsizK7tkEv7I1pMe4iopMzI0L0oDXRAB2vIA56AEbEix/UJRPyn/Ae0cL+QXPMQJ2SqzbjopHfNyDyZ6lCTSDrUKFMnUEf13AcdW1nonz02Y/c3G1IR
X-Forefront-Antispam-Report: CIP:203.18.50.14;CTRY:HK;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:hkhybrid03.nvidia.com;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(5660300002)(4326008)(8676002)(70206006)(70586007)(8936002)(6916009)(40460700003)(54906003)(316002)(2906002)(36756003)(2616005)(26005)(186003)(107886003)(16526019)(36860700001)(426003)(82310400004)(508600001)(86362001)(83380400001)(336012)(47076005)(356005)(7636003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2022 16:13:25.9654
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b6ddff84-9f23-4991-8850-08da02b0e86e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[203.18.50.14];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT044.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3455
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a test that verifies that UAPI notifications are emitted, as mlxsw
installs and deinstalls HW counters for the L3 offload xstats.

Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 .../drivers/net/mlxsw/hw_stats_l3.sh          | 31 +++++++++++++++++++
 1 file changed, 31 insertions(+)
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/hw_stats_l3.sh

diff --git a/tools/testing/selftests/drivers/net/mlxsw/hw_stats_l3.sh b/tools/testing/selftests/drivers/net/mlxsw/hw_stats_l3.sh
new file mode 100755
index 000000000000..941ba4c485c9
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/mlxsw/hw_stats_l3.sh
@@ -0,0 +1,31 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+lib_dir=$(dirname $0)/../../../net/forwarding
+
+ALL_TESTS="
+	l3_monitor_test
+"
+NUM_NETIFS=0
+source $lib_dir/lib.sh
+
+swp=$NETIF_NO_CABLE
+
+cleanup()
+{
+	pre_cleanup
+}
+
+l3_monitor_test()
+{
+	hw_stats_monitor_test $swp l3		    \
+		"ip addr add dev $swp 192.0.2.1/28" \
+		"ip addr del dev $swp 192.0.2.1/28"
+}
+
+trap cleanup EXIT
+
+setup_wait
+tests_run
+
+exit $EXIT_STATUS
-- 
2.31.1

