Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DE9B64508A
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 01:45:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229781AbiLGApM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 19:45:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbiLGApJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 19:45:09 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2084.outbound.protection.outlook.com [40.107.220.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0AAA2FFF9
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 16:45:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U5wVF/paTgtHrx0aJZtXawhxLH7emL7B/5/prsIG4VhMRk6wJLHs4VLGbvG9JBVJMygtCl+jsddGMlnMpPumpQfRsPRCdFMYfX2jqC1NLjUBpOZDXBTif8GJnCxk1fYHYECmXBRqPilv5XSLKsk7AuUH0svUk7XhgiOHY7Nb7GEqBjZN+faRAkFj6Ep2PgIulLMxjYXU4j63vHUFVOfrdxDUs5rpA61z39XadelWCQLoNUyVCJjB3Sy8F5+4ChcyYC7uxJhMoqq2P5a99eRtTYTLkQR23fFaajrjOAnudDoXdecfmQbpSmCpPdal2W3BzXOJa+KlRM9316TvZSZmRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lh+npd9Pwun9Ftndp+6Pd+p4gTMLjS1fxR1wvUpQ2ag=;
 b=VQ7zpyjPH5zQfghRvPTNOAnIvBsKLQXQSULyEgaGO2MjOrZserkDuk8XKyCl9zEqifJ0rhFH3rMq0gr2IdR/RLMfJw2PNbnrLaTev54kw3cD5lQsKBt9x4cTGZXpGP1zx3qoyyaiNc/jG9YjjF2P2vTE3OBN1fGGrj67gqoiqkqUy16GOxzPDGzKRPwv2ErQChILsDFS2ljKSsGBFwwJNY6jckNZlPv94h+IgfLwOWkotAK7C5VJS7BSqOnTifDXjck5dCXL4m/+f/S8qrT0cdHMDT0uTaQP9haZLW3lPbeFI/3fQRopPvA3clrM1D6KLbKi1hQcO7PaQ4rLiVHylg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lh+npd9Pwun9Ftndp+6Pd+p4gTMLjS1fxR1wvUpQ2ag=;
 b=J9lMfB2BA1UNARmtK0OBgrjFOcD2hUI/BwOGLmjYonVwcSu+ECIkr8iHv23UrsCagpH9ut375ukbLXfRYImsLS46UpMXHGQmRDXGD77TZKW9OEL60Kg1i22S+xEnhL+eZc+H5KJRTZMgcsI/GSK2gOkFwoIjIlRy5xo46sB1NP0=
Received: from BN9PR03CA0924.namprd03.prod.outlook.com (2603:10b6:408:107::29)
 by DS0PR12MB7704.namprd12.prod.outlook.com (2603:10b6:8:130::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.13; Wed, 7 Dec
 2022 00:45:06 +0000
Received: from BN8NAM11FT010.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:107:cafe::d2) by BN9PR03CA0924.outlook.office365.com
 (2603:10b6:408:107::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14 via Frontend
 Transport; Wed, 7 Dec 2022 00:45:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT010.mail.protection.outlook.com (10.13.177.53) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5901.14 via Frontend Transport; Wed, 7 Dec 2022 00:45:06 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 6 Dec
 2022 18:45:05 -0600
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, Shannon Nelson <shannon.nelson@amd.com>
Subject: [PATCH v2 net-next 01/16] devlink: add fw bank select parameter
Date:   Tue, 6 Dec 2022 16:44:28 -0800
Message-ID: <20221207004443.33779-2-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221207004443.33779-1-shannon.nelson@amd.com>
References: <20221207004443.33779-1-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT010:EE_|DS0PR12MB7704:EE_
X-MS-Office365-Filtering-Correlation-Id: 3ca0da00-4622-4c18-2ec6-08dad7ec48df
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iTq56CW2/XqkUkuyIREfLkEkd/2PXQqArZX7xD27ZuLsbwe6Zy1c81kGTrLiPTw2LPK/WeufsaPN9HWTSIOuT4UeiyK9r5gRNbhq8mqRfykj83BxDR41O+9Nun4cRBZ7MT07N3MgTteW6ZQgEOG8aO9vQW+27GA2H7/jBrR6wwnPSblK+qkTFhF1qkkMypdXgwptx+8BTQch014XzekeMvW/akBActaTOClT01Rs+i3CMu3VjioKjRTfQ82Le1toFRqd5bldq1nRUGBVjCv7fo6UHh7SUcyjkKpkOU/oUU4PcCkuGGNvCFVQVWDfCjUPLf3DcncL8kdGq1468fYutGXlIW6DHU1oezmnwmLr36hHzoUV7oi+TL9n2c2Ev2ZEpKrA/uhVA3FPu4VMKlBMtjsaiz8JmUJpnK7//9+Xs30FXqbgelQ8bK0K8eFzEPFpxraHTtTchwJtVHTdoCcVYmTM8fUFJPk3/MnhptP3dCBdzwrnCrf/nLLNy7uex+syKxZWL6fPcqeqzXXZEOq5Mb+xCoJ0waxrdbOU07U0C320JmrTd4ziH9trD/n5rpv/oGo4So6obwl20hZsC8FhIVHgw/wbawvH9HWpGxk5GSquHKfhf3Pfc/Gdckqa3cz+7oHbk/yN32yMqEUyFQG3eJKU8r99KukKxYdXffuu2lvGF8OQBU4FqefBYTckLW6SW1zVj9QNBZDSCRRWqT9al1Zw93gHyZ0Wwgsi+5vVLm+VD0lxNwwUXblfUmF4aKae8wGYXLVVsNm/hWzVNZFUQw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(346002)(136003)(376002)(451199015)(46966006)(40470700004)(36840700001)(81166007)(40480700001)(1076003)(36756003)(86362001)(40460700003)(45080400002)(478600001)(966005)(356005)(44832011)(316002)(70206006)(4326008)(8936002)(5660300002)(26005)(54906003)(70586007)(2906002)(110136005)(15650500001)(6666004)(41300700001)(16526019)(8676002)(82310400005)(36860700001)(82740400003)(336012)(83380400001)(186003)(2616005)(47076005)(426003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2022 00:45:06.0717
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ca0da00-4622-4c18-2ec6-08dad7ec48df
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT010.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7704
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new device generic parameter to select the bank of
firmware to be used on future boot and/or resets in those
devices that have multiple firmware memory banks.  This can
be used along with the FW_LOAD_POLICY parameter, depending on
the capabilities of the particular device.

Examples:
  $ devlink dev param set pci/0000:07:00.0 name fw_bank value 1 cmode permanent
  $ devlink dev param show pci/0000:07:00.0 name fw_bank
  pci/0000:07:00.0:
    name fw_bank type generic
      values:
        cmode permanent value 1

Link: https://lore.kernel.org/netdev/CO1PR11MB508942BE965E63893DE9B86AD6129@CO1PR11MB5089.namprd11.prod.outlook.com/
Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
---
 Documentation/networking/devlink/devlink-params.rst | 4 ++++
 include/net/devlink.h                               | 4 ++++
 net/core/devlink.c                                  | 5 +++++
 3 files changed, 13 insertions(+)

diff --git a/Documentation/networking/devlink/devlink-params.rst b/Documentation/networking/devlink/devlink-params.rst
index 4e01dc32bc08..7cf1cd68ff08 100644
--- a/Documentation/networking/devlink/devlink-params.rst
+++ b/Documentation/networking/devlink/devlink-params.rst
@@ -137,3 +137,7 @@ own name.
    * - ``event_eq_size``
      - u32
      - Control the size of asynchronous control events EQ.
+   * - ``fw_bank``
+     - u8
+     - Select the bank of firmware to be used on future boot and/or resets in
+       devices that have multiple firmware memory banks.
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 5f6eca5e4a40..3fa26a26fa44 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -510,6 +510,7 @@ enum devlink_param_generic_id {
 	DEVLINK_PARAM_GENERIC_ID_ENABLE_IWARP,
 	DEVLINK_PARAM_GENERIC_ID_IO_EQ_SIZE,
 	DEVLINK_PARAM_GENERIC_ID_EVENT_EQ_SIZE,
+	DEVLINK_PARAM_GENERIC_ID_FW_BANK,
 
 	/* add new param generic ids above here*/
 	__DEVLINK_PARAM_GENERIC_ID_MAX,
@@ -568,6 +569,9 @@ enum devlink_param_generic_id {
 #define DEVLINK_PARAM_GENERIC_EVENT_EQ_SIZE_NAME "event_eq_size"
 #define DEVLINK_PARAM_GENERIC_EVENT_EQ_SIZE_TYPE DEVLINK_PARAM_TYPE_U32
 
+#define DEVLINK_PARAM_GENERIC_FW_BANK_NAME "fw_bank"
+#define DEVLINK_PARAM_GENERIC_FW_BANK_TYPE DEVLINK_PARAM_TYPE_U8
+
 #define DEVLINK_PARAM_GENERIC(_id, _cmodes, _get, _set, _validate)	\
 {									\
 	.id = DEVLINK_PARAM_GENERIC_ID_##_id,				\
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 907df7124157..25a075f0aadd 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -5221,6 +5221,11 @@ static const struct devlink_param devlink_param_generic[] = {
 		.name = DEVLINK_PARAM_GENERIC_EVENT_EQ_SIZE_NAME,
 		.type = DEVLINK_PARAM_GENERIC_EVENT_EQ_SIZE_TYPE,
 	},
+	{
+		.id = DEVLINK_PARAM_GENERIC_ID_FW_BANK,
+		.name = DEVLINK_PARAM_GENERIC_FW_BANK_NAME,
+		.type = DEVLINK_PARAM_GENERIC_FW_BANK_TYPE,
+	},
 };
 
 static int devlink_param_generic_verify(const struct devlink_param *param)
-- 
2.17.1

