Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D2C9673593
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 11:34:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230352AbjASKeG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 05:34:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230355AbjASKdm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 05:33:42 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2056.outbound.protection.outlook.com [40.107.102.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1C3B521C3
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 02:33:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Csn3jDoanl9L6GNYBcCk1LLxNZUFitFyP7gjccfjXU9ITh0QBPeXjWpqaWOhNwihgqAQEsE+RIrYkqSTWVLNVurtL4ZPfXa40n++RfMS2pPEWdF96nR+Jxg3tJ3I2CBrWOqbD3Z0ROuX35rpmAQtU63SHT/MfzvawEslzJTpkESziBE6goegTTsI8+bjwvbrDKcAIweM388u4pqrutU8WgwPM/aa5lDs41rFhsld1GgjBtAabAbNoYnf/afLzMoblX0uJnNzwEWP16c2Rz6xCbH2s2r7Ceja3+b65Yu1epeXtP3/gQTyul3RKamcuxAr+PXXHBzWwT1udJmiiGFzSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6vKyRVx6H1le9AER1+for/dWXBjmamk4TX7BKs896HQ=;
 b=MIif6Nwayw+oMhd+6XRc0gRfa9YA2UA6ESEAO77LFBymKYDCKXNehBoi0RSw8lZsT3fQFHAV+bZ9MSahTVF7pygluvK3i14Oo8ipRXaV9kRxD5xdQVS8YBhUtFRJlEYw8Vm5FMYKYE/3acbYQMluU3EX9riVba4HCoXpDRT9pl9NY8/guDc7rXZKOEav46gMuV0mJSARekt3UO/wIdqktWVhKbEncEfjdNYOLxEnL5c7BhMO8sjDiGL/QE0dmubEwyQblP8WXGBVuZZHYJ9tCWfW8dwOoamzMBvZuLaO1mP47thPLi70NCIVHUOJ5mjn1lPBgDldPmxfHGut41/58w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6vKyRVx6H1le9AER1+for/dWXBjmamk4TX7BKs896HQ=;
 b=HTXh5JpAtf1Oz6ZfL3Nwb2hpCHLPZPEIzpe/GgCPi6+QDaFYUeD0wHFYvyX8mu0vSMRcO9tlkTt/ZOGIAWnQKSy0swSzPGx9gvwPmzXtZTFS36cRKo6HQJDY4a7xQP6jpmWPxgcZjaVTJg9Um2R5DqRAEI6P22Efb72/xHKtSOe3JpMtaP/pUE0V1Azh3PAHM+FO64mGd5r/CcYu6FDrwJE7l8Wb6BAC6wrKBVIHy6Tw6hfamCi19B2jrTdHAhIu8/tF5FVcJtDY/fPgmItjHvibROqse8KzMKzp8hRJ0QhAG7gQkm6V4SPvvj0A5Z25j5yFdnrMmjMODQuQPFp1FQ==
Received: from BN9PR03CA0207.namprd03.prod.outlook.com (2603:10b6:408:f9::32)
 by MW4PR12MB7015.namprd12.prod.outlook.com (2603:10b6:303:218::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.24; Thu, 19 Jan
 2023 10:33:25 +0000
Received: from BN8NAM11FT105.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f9:cafe::98) by BN9PR03CA0207.outlook.office365.com
 (2603:10b6:408:f9::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.25 via Frontend
 Transport; Thu, 19 Jan 2023 10:33:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN8NAM11FT105.mail.protection.outlook.com (10.13.176.183) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.24 via Frontend Transport; Thu, 19 Jan 2023 10:33:24 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 19 Jan
 2023 02:33:13 -0800
Received: from yaviefel.vdiclient.nvidia.com (10.126.230.37) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Thu, 19 Jan 2023 02:33:10 -0800
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     Ido Schimmel <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>,
        "Amit Cohen" <amcohen@nvidia.com>,
        Danielle Ratson <danieller@nvidia.com>, <mlxsw@nvidia.com>
Subject: [PATCH net-next 5/6] mlxsw: core: Define latency TLV fields
Date:   Thu, 19 Jan 2023 11:32:31 +0100
Message-ID: <07d9582525982d5cfb4e8a2d8a644a2b25773694.1674123673.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <cover.1674123673.git.petrm@nvidia.com>
References: <cover.1674123673.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT105:EE_|MW4PR12MB7015:EE_
X-MS-Office365-Filtering-Correlation-Id: 7afc6b65-cf9e-4cfa-d310-08dafa08981c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l2YFvzGWr+iBtcaa1dZ7S8z/PB8q9FoW8wP03m5pIdB9lUDOq+tERaMcRmjoC9mCLrxgUNgPvrrMcCURVvU+JkZGx3Yb282wnxThn6rWn9ZDQOCH4eexk5cKpFqFQnqeapFUzwf/IA4bST5qucxuDBRltMX3Q+hZwa/r71cGvvwLuXGWU59zZbofH+NwdSiObRthSMN0UrHfIfwXJ6BYym0O87uvfEjB/enABso40noXXYCUfwwC5h/ErMM6zVYYRskIq+WDiLlXFXlDiegWJIJvVehFod3Hh3L3nu59UtB4NmafAPHcaRm0Ja5+cbXKxOpsMLrjH57O9s/SR0iv5dpUdsuAnIF4v1OBvplEaZb19llURL8iDP/nvHVVCG0MwUO++vVnFd5v4FrOobuyoHNEUZ1bsvA4GiTRkfH4nntcSfYRuVNxnhdfWA/T3sdJgWAozxpix1HfIGb4BPK/m+Canl/+eNm9bKMDZ/GaYaPkp1C+l2IgdpRG9bKUGXPl733QN6RgMjkNExV7obKVUGBcE6LCIolrtrqdwjk02QaZwdLJ4hwjx6Gv9Llptq2iYOOpEYwQ2LFHAbDDigioR2u8IDagexFMiIzyKCacGQbNgOgbDJcPwkr3W3JnQyV3ith7SRrbUIAcl4vRLeqBZTmjTdnKQGj/EXhdxgcOLGhdm9XIHITqjGJE3K2zusrz/r6/Zaw2cZVSGZ+YnlgqHw==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(346002)(136003)(376002)(451199015)(40470700004)(46966006)(36840700001)(7696005)(70586007)(70206006)(54906003)(316002)(336012)(41300700001)(8676002)(107886003)(6666004)(426003)(47076005)(4326008)(8936002)(5660300002)(2906002)(2616005)(36860700001)(36756003)(478600001)(82740400003)(186003)(110136005)(26005)(82310400005)(356005)(86362001)(16526019)(7636003)(40460700003)(40480700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2023 10:33:24.3023
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7afc6b65-cf9e-4cfa-d310-08dafa08981c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT105.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7015
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

The next patch will add support for latency TLV as part of EMAD (Ethernet
Management Datagrams) packets. As preparation, add the relevant fields.

Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index 36ef9ac12296..0ba38c8f7b8f 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -378,6 +378,22 @@ MLXSW_ITEM32(emad, string_tlv, len, 0x00, 16, 11);
 MLXSW_ITEM_BUF(emad, string_tlv, string, 0x04,
 	       MLXSW_EMAD_STRING_TLV_STRING_LEN);
 
+/* emad_latency_tlv_type
+ * Type of the TLV.
+ * Must be set to 0x4 (latency TLV).
+ */
+MLXSW_ITEM32(emad, latency_tlv, type, 0x00, 27, 5);
+
+/* emad_latency_tlv_len
+ * Length of the latency TLV in u32.
+ */
+MLXSW_ITEM32(emad, latency_tlv, len, 0x00, 16, 11);
+
+/* emad_latency_tlv_latency_time
+ * EMAD latency time in units of uSec.
+ */
+MLXSW_ITEM32(emad, latency_tlv, latency_time, 0x04, 0, 32);
+
 /* emad_reg_tlv_type
  * Type of the TLV.
  * Must be set to 0x3 (register TLV).
-- 
2.39.0

