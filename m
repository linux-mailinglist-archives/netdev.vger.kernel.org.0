Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00E2A4AB79A
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 10:41:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244959AbiBGJTF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 04:19:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349907AbiBGJMy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 04:12:54 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2089.outbound.protection.outlook.com [40.107.92.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34608C043185
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 01:12:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P/gslkL129dPk7Hp1A7bod0saSm4DH95QipzIn9dedoAZQnuYaaR/dEZv+H0/FZxK/b2KyjaKI+DtuyAc8c4VVEJ7KJQhBo7txcZ4uR6vDiqdMVhzoCtKTbij7lMDNeHmL/7C3e57Le5y6My/meTUbiQXxPbAeaUVAkHKFxa6gL5zh0xDWv4m2hyrGpPB2/lt1uvs++tiC3twRfydLFxjg00bHItW5Zo2O5dTrrI1fdVqyLaTrJ1TiA9mDEOgZRnPh2BmYCFdPCe7BQfv5tXmhr3wLiZfo6+hTjlYI5MNset8O9PcnVyRFqDuPbA1fDka7MhIdYdVepm8jeiBuvJKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g1zge4CoakHawSV4RVMk8Stw0iFTdApSNuYHPhlC2K0=;
 b=f7Sb6yhAr1PoZVd1cNaEnXK/bl9tJBGGAnVaG+L5fXRiz9zZC8v15UNJzXErBzTeEFAbYJkof9svSxT/WWYGvW0owp6RlsvIL1uwfLSlHGFVFLyUuDa29s6NMBbMf5PJFqdNhnvIxVWIjfFRfY1X7Sk0s/4YUKQSMa9HrCmp1BdEKNz2qNVUCSe7o/h0F4RCWxtNT6QBivFt1lcLOq4HXPs+NM4cyN7AQADiuyt6DcNAGuua/p0MWkEbSm7TKDO4P74LJ6Na61jp4t6ElPEloJiJWW5C0v1+2A1pjBKASafRP286wcSkcq4RHwOLUmBpOr3/SMSbBAM9gGSSoJhqMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=suse.cz smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g1zge4CoakHawSV4RVMk8Stw0iFTdApSNuYHPhlC2K0=;
 b=sZnqTy+ft4KeouSI7iDIDsRcukvlM/vYFcgD1Mz0Ao9gwnt5Vy5T7fvtemfLjh6zsZZ8VoECZGiHq5c0sVHL44jXFzqyCe7rKttJqMnFaGss8X6u94vald4V6s13RulOBcx8ERNEqrdRPmN2OW0clV2OupRvCrBlWQ/uq5uvsLeOxQs6CsDOqE5XI9buIFw5e8D3USwUhYbDX7iqz2f0XKyA6NBgzOVyqOq9LMkwirbyIBbzYtlmQGI1QvdwolEzkcjfuTZTIxM41ae9qBmCac/veas3Fn4VmggyY8QjYra8phsylbNC1VSTkXIhCDUCjrdqUynkJGzGLZkiwNonlQ==
Received: from BN6PR14CA0001.namprd14.prod.outlook.com (2603:10b6:404:79::11)
 by DM4PR12MB5359.namprd12.prod.outlook.com (2603:10b6:5:39e::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Mon, 7 Feb
 2022 09:12:51 +0000
Received: from BN8NAM11FT060.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:79:cafe::7f) by BN6PR14CA0001.outlook.office365.com
 (2603:10b6:404:79::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12 via Frontend
 Transport; Mon, 7 Feb 2022 09:12:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT060.mail.protection.outlook.com (10.13.177.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4951.12 via Frontend Transport; Mon, 7 Feb 2022 09:12:51 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 7 Feb
 2022 09:12:50 +0000
Received: from dev-r-vrt-156.mtr.labs.mlnx (10.126.231.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9;
 Mon, 7 Feb 2022 01:12:48 -0800
From:   Danielle Ratson <danieller@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <mkubecek@suse.cz>, <vadimp@nvidia.com>, <mlxsw@nvidia.com>,
        "Danielle Ratson" <danieller@nvidia.com>
Subject: [PATCH ethtool-next] ethtool: Add support for OSFP transceiver modules
Date:   Mon, 7 Feb 2022 11:12:31 +0200
Message-ID: <20220207091231.2047315-1-danieller@nvidia.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2111242a-add0-451c-ef9b-08d9ea1a0461
X-MS-TrafficTypeDiagnostic: DM4PR12MB5359:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB535940AE2DC0DFC4E7B7D1DDD82C9@DM4PR12MB5359.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3vob0yrrsjvsEEr61CN5N31f7B/UZCQpJe/Uxds6k4m4tiJNgmxnBiJMeIWiTI58UL82yTziBNSl1DSgja5aN4LtzCHJ5lY0TnN3yGBgU7wGswtfiaEmJ344sMDs9caQjjJIwCaZXcI19O8xxFngICZ1KM0ftqRLoIKcxtTjE5tYFVFvwjQQk3YjnQiD6uj4uypeXOy4gcwJHBVJS6M8ljQeYdtYY/UQbPkM+AEk3ipJetFLWoNz/IVG3vLPmNE0MwU3i/51qJE8HXIKvcfLy+3vH0qia8iqqTAMd83NIwG9dex2Ih+aoRDMncEr/NW5C6a+3RGY9WNPFFdQBvhXcSOsf6WZQO7DAZ/D6nqH9FHNaXIWU8bxzY27BoarmeRwGqyvQtZcfAlA6iHtE8hLOz/QN4xFsPMvrttBFCcrPYWvja3BFb7/EW1/HaNyWpMe/WbMNQv9oi/mKs8XHZo8QBxKiGtYRoVEWU6ZDpKoL9zQSzqzgW46thPVs3ErYqSDN8n5ctneJIm+QRgAfWz7ppoPXqgGHvJOGWzW1ClfVX2pU4cK/yEvaiOejKINwS1gJQccOdsnTwA86eV62T+iw/GJdaGtp6b2ydAHXDd1dgdD+56VCNX3xEnX18lZxcxQI/TGiNcoNZlO4l1RdTGPaRioZxOJ93utXyq6gicDCzWoFcuxruhtIpsPLQgF7mqim+IJZemN8j/2eX2NZ99XyA==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(82310400004)(5660300002)(40460700003)(508600001)(6916009)(54906003)(6666004)(2906002)(83380400001)(86362001)(4326008)(70586007)(70206006)(8936002)(316002)(8676002)(47076005)(36860700001)(107886003)(2616005)(81166007)(186003)(1076003)(16526019)(26005)(36756003)(336012)(356005)(426003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2022 09:12:51.1493
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2111242a-add0-451c-ef9b-08d9ea1a0461
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT060.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5359
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

OSFP transceiver modules use the same management interface specification
(CMIS) as QSFP-DD and DSFP modules.

Allow ethtool to dump, parse and print their EEPROM contents by adding
their SFF-8024 Identifier Value (0x19).

This is required for future NVIDIA Spectrum-4 based systems that will be
equipped with OSFP transceivers.

While at it, add the DSFP identifier to the IOCTL path, as it was
missing.

Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
 netlink/module-eeprom.c | 1 +
 qsfp.c                  | 4 +++-
 sff-common.c            | 3 +++
 sff-common.h            | 1 +
 4 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/netlink/module-eeprom.c b/netlink/module-eeprom.c
index f359aee..49833a2 100644
--- a/netlink/module-eeprom.c
+++ b/netlink/module-eeprom.c
@@ -223,6 +223,7 @@ static int eeprom_parse(struct cmd_context *ctx)
 	case SFF8024_ID_QSFP_PLUS:
 		return sff8636_show_all_nl(ctx);
 	case SFF8024_ID_QSFP_DD:
+	case SFF8024_ID_OSFP:
 	case SFF8024_ID_DSFP:
 		return cmis_show_all_nl(ctx);
 #endif
diff --git a/qsfp.c b/qsfp.c
index 57aac86..1fe5de1 100644
--- a/qsfp.c
+++ b/qsfp.c
@@ -947,7 +947,9 @@ void sff8636_show_all_ioctl(const __u8 *id, __u32 eeprom_len)
 {
 	struct sff8636_memory_map map = {};
 
-	if (id[SFF8636_ID_OFFSET] == SFF8024_ID_QSFP_DD) {
+	if (id[SFF8636_ID_OFFSET] == SFF8024_ID_QSFP_DD ||
+	    id[SFF8636_ID_OFFSET] == SFF8024_ID_OSFP ||
+	    id[SFF8636_ID_OFFSET] == SFF8024_ID_DSFP) {
 		cmis_show_all_ioctl(id);
 		return;
 	}
diff --git a/sff-common.c b/sff-common.c
index 2815951..e951cf1 100644
--- a/sff-common.c
+++ b/sff-common.c
@@ -139,6 +139,9 @@ void sff8024_show_identifier(const __u8 *id, int id_offset)
 	case SFF8024_ID_QSFP_DD:
 		printf(" (QSFP-DD Double Density 8X Pluggable Transceiver (INF-8628))\n");
 		break;
+	case SFF8024_ID_OSFP:
+		printf(" (OSFP 8X Pluggable Transceiver)\n");
+		break;
 	case SFF8024_ID_DSFP:
 		printf(" (DSFP Dual Small Form Factor Pluggable Transceiver)\n");
 		break;
diff --git a/sff-common.h b/sff-common.h
index 9e32300..dd12dda 100644
--- a/sff-common.h
+++ b/sff-common.h
@@ -62,6 +62,7 @@
 #define  SFF8024_ID_CDFP_S3				0x16
 #define  SFF8024_ID_MICRO_QSFP			0x17
 #define  SFF8024_ID_QSFP_DD				0x18
+#define  SFF8024_ID_OSFP				0x19
 #define  SFF8024_ID_DSFP				0x1B
 #define  SFF8024_ID_LAST				SFF8024_ID_DSFP
 #define  SFF8024_ID_UNALLOCATED_LAST	0x7F
-- 
2.31.1

