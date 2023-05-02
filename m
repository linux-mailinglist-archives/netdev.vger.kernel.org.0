Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8AFB6F49C5
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 20:36:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233412AbjEBSf6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 14:35:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232830AbjEBSf5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 14:35:57 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 685AC1727
        for <netdev@vger.kernel.org>; Tue,  2 May 2023 11:35:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UTmUetjHmPNZQ+yJHER8Se9rw4Hn/OvNFl2hzX64i9cD3tHkwC/bwYny7QrqStsez4Bblk/FAJO93oKYS0+1q5LBpW/pc0eiIGkXQT9j9jc1L8NI87JCCBrQVJNIeBDJb0Z+cd3wOakJXGmeNtOACTIatpR8wVRBOD+VJfpuIJ8PRE7+x35dNzDqd/XY0JYbvtXI1MhVWXNukOUcSj2RAsvf5cZlaDloW4eIO69Rf2uovE3xvPjdZTgwl352bYLbP8q2aJ7LIhMAtX/gPWJQYTcFTfIR5J2o9Fdlc7oiRGfrPPbZ0AWpyMOdckR4sfjZu+RIB4WcgpZQ0IFBO36+AQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n5w8FJXDTH+KNuqccnTDUhZAtkVPZpkiMTlRBlLTmxE=;
 b=OzgD6+ueDVBbOnNmLMJx6+l4YD27VF14pIvBC63r9qJ4d03olsKxtHBUEWRSUaCMXjYzEPowSrt8/ZWnKtNcCmwSWYhhG8oKO5Al4aQpNwusPgFAQY+ZBP0/aNSPIVLkzoVTaC1L4PsRIuqHAcbbfeB91STU2cEJrJf4/plrhdLdtsIYuM8cU8qD1RIN/sUbGdb9xDdaAxDQoIg7tnOFuKWlTNSMP6MBwLrcAscxSeyvcB4j88mN2l5L4G9r3URrqMW8gzzShsMzh7/67DVzRqu0AIRS8e61FnIcNzh5L1SrN5R6P2/ZZkmcfDpnfY0Y1PwSyUgEV9eKbuVHZI41jQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n5w8FJXDTH+KNuqccnTDUhZAtkVPZpkiMTlRBlLTmxE=;
 b=lcHJsTwG9SHFMhwMs+c5s6HQ7mMwW5WQngzgdhnna5d3TH5vxMP0n06Vw70b0whs9VIE5026FTxzh0BBdGy0ooRfE6/9v2Hd//xbAag061KrUHZoA7a8M39JUeVB0exX3Cl9nNSi7NYxRgyANvh/aHub5ublS4dnzCG1RtC2Um8=
Received: from MW2PR16CA0001.namprd16.prod.outlook.com (2603:10b6:907::14) by
 BL1PR12MB5064.namprd12.prod.outlook.com (2603:10b6:208:30a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.30; Tue, 2 May
 2023 18:35:53 +0000
Received: from CO1NAM11FT009.eop-nam11.prod.protection.outlook.com
 (2603:10b6:907:0:cafe::ee) by MW2PR16CA0001.outlook.office365.com
 (2603:10b6:907::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.20 via Frontend
 Transport; Tue, 2 May 2023 18:35:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT009.mail.protection.outlook.com (10.13.175.61) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6363.21 via Frontend Transport; Tue, 2 May 2023 18:35:52 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 2 May
 2023 13:35:50 -0500
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <kuba@kernel.org>, <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     <drivers@pensando.io>, Shannon Nelson <shannon.nelson@amd.com>
Subject: [PATCH v2 net] ionic: catch failure from devlink_alloc
Date:   Tue, 2 May 2023 11:35:36 -0700
Message-ID: <20230502183536.22256-1-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT009:EE_|BL1PR12MB5064:EE_
X-MS-Office365-Filtering-Correlation-Id: 95f95fae-bfa3-4e40-7382-08db4b3c0ee8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gdlzfe/jvHsHVb5exUDqfdeyd4oqBJW3012f5JYK9OhixSKWlpoBUJADuFpUHqsiCZWWMtxkC130ZtR7e6ORQqGB8fqki79bh4bocIRfudW69q1co7rhUdc34g/PSbAu3FiD+HU7KqLPe9WnrGpD/dD194y2ntQGFoh+4Teb3ZR7i3SXQENv74WEtQkRsCg/+gVpEBS567/nOTig3vB6h29G3LCmApuufEy+3uifCe3n3kOgMZgOzPMTD01qYeTcK7up5hpQuS7GjM7nIXGocqKr7/S991RCE9WO0Cbk+z6ikA1qPRS2tvdgp8ZWXijSsjNb/ZqpuST0CtnkfyaVoOKwIYzj/2dhm3jDeodrw0dtKfE+ikAkFVukgxTNKk3qyM3Wa2Fq655YqBniji9JquFxH6VBhdkn/alhnBVyjMP8OoRX1d9t431p/EL61i4pKP+ueO5Vev9t7o4jZJsPlkotTq6kwj7YtL472m8ExU0e8oEbhpY6vb3Pu6jgh8RPfq/LRvaBoKUQtB4kOKl9TGbyiNkSu/5I0j+5GsXv8YniJABEdKIHvNtMOcrr+Alu+QqpgQYr98XtIzShxFnGT+Xp6U4C2JLdXqjdbi2UGBUl3ZyqlGqM/VxBR4kDCzNakuQerbrfe/rcXYjn9qxzIJ9Q72XOlxAuWIVMwANUKRPD+1/W6H9pl6mfj8thaTQ+oVBQmWHB9iOZJUmQMVWw2LyQLSw7qOa01q1fncFF+xY=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(136003)(376002)(346002)(396003)(39860400002)(451199021)(36840700001)(40470700004)(46966006)(36756003)(86362001)(81166007)(82740400003)(356005)(8676002)(5660300002)(8936002)(4326008)(70206006)(41300700001)(44832011)(316002)(2906002)(40480700001)(70586007)(82310400005)(336012)(47076005)(40460700003)(426003)(2616005)(36860700001)(966005)(16526019)(6666004)(110136005)(54906003)(478600001)(186003)(26005)(1076003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2023 18:35:52.1886
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 95f95fae-bfa3-4e40-7382-08db4b3c0ee8
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT009.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5064
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a check for NULL on the alloc return.  If devlink_alloc() fails and
we try to use devlink_priv() on the NULL return, the kernel gets very
unhappy and panics. With this fix, the driver load will still fail,
but at least it won't panic the kernel.

Fixes: df69ba43217d ("ionic: Add basic framework for IONIC Network device driver")
Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
---
v2 - fixed up the Fixes tag - thanks, Simon
	https://lore.kernel.org/netdev/Y%2F8tj+bqGG1g5InQ@vergenet.net/

 drivers/net/ethernet/pensando/ionic/ionic_devlink.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_devlink.c b/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
index e6ff757895ab..4ec66a6be073 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
@@ -61,6 +61,8 @@ struct ionic *ionic_devlink_alloc(struct device *dev)
 	struct devlink *dl;
 
 	dl = devlink_alloc(&ionic_dl_ops, sizeof(struct ionic), dev);
+	if (!dl)
+		return NULL;
 
 	return devlink_priv(dl);
 }
-- 
2.17.1

