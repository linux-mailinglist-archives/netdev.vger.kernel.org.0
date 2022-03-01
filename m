Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0C354C82CF
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 06:06:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232486AbiCAFGT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 00:06:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232495AbiCAFGO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 00:06:14 -0500
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam07on2055.outbound.protection.outlook.com [40.107.95.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B35974619
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 21:04:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OFZnk6RZn5Ezwif8lyvyamWuXiuTZ7L0tKu2h6wIqmdLotXhrxK7XArM2FjWptVE+K6Aqw0/2Nq33UEVZ9Si5mPt9K6YAHBzLUYGcCOfJ2eQCP0cf4iZ4WMXUeVxEg3hTFBR2aWO5K/NsAfv/TniRk9Kqg63u8GXrCSJRWxeLe8F3K7qUjzlOYflO6G7Bx6jVitrujkC1YIMvKJEy05drpj9jjLn9olmyxwnVD1CZ0RDaKFf5TqxOvOmWm6tRb6lRpOfLc9Lol1lDfpDbO57OZ4+Mu9wtEmcnaV3ndkN8GIxMora6JIx93hSQDXHfStW/dXdPRngdnlXnI1FMs69qA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2esf111GtPrgylCZ29AWW/U6CAr1xnDY7ueoVOsBtvo=;
 b=KTxKgA0qrpxcPSHppxXhgstIkmLMJq4ZJRJeJ/xtgjw3XVQ7tKCns5pRBI2gQESwOuyCX9ULKKXLnbm3//YRaj18LnOL7ApwmH8STkwUyeV9ubNIeB3Emw7X3R+a78m/QAsb8Wpfn80aF9MunHzQBwVWnhVZqoqZ1Y82/8MDBoJULkPA7DfEX0asK3gnggRvfIQfaaW1tZI/gtiRi8StT1KalysGoaF8OKR+zUmp11vx3P6veKRvVYfiYuxpHjPwgOklCuUk8QXyFoxUok2QH2sa0gO9t7ZoXvs9j0b5PLPF8P/pWefsDSPWi+qTqLGctgxEg5uA3oo25O0rlImjUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=networkplumber.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2esf111GtPrgylCZ29AWW/U6CAr1xnDY7ueoVOsBtvo=;
 b=rorGwKYnRouk1oz+ViFmZ2IPJ00nPSUG2B7Dj9qC9dYudRHOymusxOt/8Q+qUWu5XvvzqRIo9bngXefYEyxTLr4p2nezm6e4XaLLuqpDUZvckAstycc1qK03gQ/8rLfY6jRe8qd0ojcQE1VQ1iKRTgXsrJhyFe8KGMtO3Q/HNIMRDFAoFjR2/sPFWcZC+o239pN1a5FRlmneTAs7KEs5N7ipXGEFSgzL3yWewFV4N1+oSzfbITcC6cC/m2N7yz3CB2lUWEhugoMyXdtm0r/VB3QAywIo3AiNd7hnTEa3qwAKgYBHG13UJNZ24H0SFKujrWz8K3xLlxT6XB9w3V2cIg==
Received: from MWHPR04CA0040.namprd04.prod.outlook.com (2603:10b6:300:ee::26)
 by PH7PR12MB5974.namprd12.prod.outlook.com (2603:10b6:510:1d9::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Tue, 1 Mar
 2022 05:04:42 +0000
Received: from CO1NAM11FT004.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:ee:cafe::26) by MWHPR04CA0040.outlook.office365.com
 (2603:10b6:300:ee::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.21 via Frontend
 Transport; Tue, 1 Mar 2022 05:04:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT004.mail.protection.outlook.com (10.13.175.89) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5017.22 via Frontend Transport; Tue, 1 Mar 2022 05:04:41 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 1 Mar
 2022 05:04:41 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Mon, 28 Feb 2022
 21:04:40 -0800
Received: from localhost.localdomain (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server id 15.2.986.9 via Frontend
 Transport; Mon, 28 Feb 2022 21:04:40 -0800
From:   Roopa Prabhu <roopa@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <stephen@networkplumber.org>,
        <nikolay@cumulusnetworks.com>, <idosch@nvidia.com>,
        <dsahern@gmail.com>, <bpoirier@nvidia.com>
Subject: [PATCH net-next v3 01/12] vxlan: move to its own directory
Date:   Tue, 1 Mar 2022 05:04:28 +0000
Message-ID: <20220301050439.31785-2-roopa@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220301050439.31785-1-roopa@nvidia.com>
References: <20220301050439.31785-1-roopa@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b08847cf-a845-459d-1594-08d9fb40feb8
X-MS-TrafficTypeDiagnostic: PH7PR12MB5974:EE_
X-Microsoft-Antispam-PRVS: <PH7PR12MB597494CCA0CE5CB6832B2954CB029@PH7PR12MB5974.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XhMPA9j5MFLs0p5NmyvCvyY7QjH7Bw53SuEgFbCocjpTqkG67LPSRbPANTSeC7Mns/KMnKIQqvbseE/A7/J/XwuuXm/P7sk3w2GplPH8nP2hhpLohULYGmvpAwbA3MFC9KbSjn4hyJkZL0D9kKRrcBtkSgj4gKzIAg0mbp19Ml5VREFXT8UWGQD5ymlgy/Ba2KZgbMFB0cK1BDVAASbx0sN2ayu0WL2WDF+BHi1BysYURsQTrYnHJf7zIMRRjFezMCtkZpxodwIxmbfHfPK6nAoSznSIKSJSKtIiW+JF36nUP3TjD/3f6XAjenkU13EWP4eFsSfSnJxSTe1LZZSzDTdEBfIkiiVfvWwFrwE5AD9KFVUs+RM7RtZcwc/6SV1Tes7r7YKds0hPUpNZ+3aw7FnnXj1swOK0H5W1cE4t3EIULI2lznxjqWoq+2HBINr48v67UFMBiVg2wDIr7ryobvsj0RfCyI+wtAE5/iJ0uUA5x/Yv4A/us0QQ+HXxasR1LFOeldD3RG8vtG8Wi00BhynsLwy1keEWGOkwVn7Zw2E3fJcyi9ttZrKpvT8Jl4jitEiIW95gh499NdL0bhwXabc36rAoosZawyVB2Ayo2IxBsNh66orjPDsOXcBAOOujgW8Vn6X4waNbprZPmBYSgwGyh6r8wpD/4h3YeQJarGxdSKfkN+k24HYrYh7QE7M0Yz2f7VaniYrntlQ85Hywlg==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(316002)(356005)(4326008)(6666004)(426003)(83380400001)(47076005)(36756003)(107886003)(186003)(508600001)(1076003)(2616005)(26005)(336012)(8936002)(2906002)(40460700003)(5660300002)(54906003)(110136005)(70206006)(70586007)(86362001)(36860700001)(81166007)(8676002)(82310400004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2022 05:04:41.8497
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b08847cf-a845-459d-1594-08d9fb40feb8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT004.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5974
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

vxlan.c has grown too long. This patch moves
it to its own directory. subsequent patches add new
functionality in new files.

Signed-off-by: Roopa Prabhu <roopa@nvidia.com>
---
 drivers/net/Makefile                        | 2 +-
 drivers/net/vxlan/Makefile                  | 7 +++++++
 drivers/net/{vxlan.c => vxlan/vxlan_core.c} | 0
 3 files changed, 8 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/vxlan/Makefile
 rename drivers/net/{vxlan.c => vxlan/vxlan_core.c} (100%)

diff --git a/drivers/net/Makefile b/drivers/net/Makefile
index 50b23e71065f..3f1192d3c52d 100644
--- a/drivers/net/Makefile
+++ b/drivers/net/Makefile
@@ -31,7 +31,7 @@ obj-$(CONFIG_TUN) += tun.o
 obj-$(CONFIG_TAP) += tap.o
 obj-$(CONFIG_VETH) += veth.o
 obj-$(CONFIG_VIRTIO_NET) += virtio_net.o
-obj-$(CONFIG_VXLAN) += vxlan.o
+obj-$(CONFIG_VXLAN) += vxlan/
 obj-$(CONFIG_GENEVE) += geneve.o
 obj-$(CONFIG_BAREUDP) += bareudp.o
 obj-$(CONFIG_GTP) += gtp.o
diff --git a/drivers/net/vxlan/Makefile b/drivers/net/vxlan/Makefile
new file mode 100644
index 000000000000..567266133593
--- /dev/null
+++ b/drivers/net/vxlan/Makefile
@@ -0,0 +1,7 @@
+#
+# Makefile for the vxlan driver
+#
+
+obj-$(CONFIG_VXLAN) += vxlan.o
+
+vxlan-objs := vxlan_core.o
diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan/vxlan_core.c
similarity index 100%
rename from drivers/net/vxlan.c
rename to drivers/net/vxlan/vxlan_core.c
-- 
2.25.1

