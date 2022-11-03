Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D784F617B95
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 12:34:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231192AbiKCLeb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 07:34:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbiKCLeZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 07:34:25 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E185612098;
        Thu,  3 Nov 2022 04:34:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WbZupPO0hseVC6vofa62bXAaDdHqdVN2hR72PL5UlH2CjBMQHn5rNlxJ+0sAP0HI8LYiRIvOxmawVgXBRpj7aR2xsM01vQV6v+eVjrDM2vlOqDJWVDfqTMWa/vkMEQoerAz1u+tS7Mq3eflSIpfZEEgRv0zEO91znx3iNPys7E+eMxh5zHyTLbHRHVStAm+f6u65kx+wbTRpsu+KgaDBCZOFZrxkTj5V2L57hYXM6WAT89xr2FjgAP72YI0axbg1Gzy5joUBQb3hU/+H6npy1SJLnKtI8vlB4E2yVsKH+oG46K9d/8mHVTh/ks2ENXK1sic3cTc07A/2FFCdqzvRMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k1f1RHVgxteoHgG/rt4MXhHsn89bG9adaJ/8nkAE/Vo=;
 b=I0f8tvgMXPUSrsun7jHnIdDy0Idvq1bkJvcelKoiWftEcyRS1/fZfjgSXs3NoKucKp3/I4OgmJ8B9eSp5sebjSXaoFqa6CjtvEr8jGjenMGRmUiS8bolmK04HXGDRgDK3YVFEyeO14tvVtyg/QTvwF5QCgQq8YLNyfnCNQyj58lAV994N9M0V1xqkorCmQbcePyVTAGHkD6PjYXq6Kh/wd0MX5n6xRUepqqCyEwDH/Wz1/LODXJbjAIhWR1rHXNI9lL0acpQl3LEMwMTm/ez2rr/QjOa9SwM+SF9I/9wwp7JY3NZnZsZBos8zp8jppbZbpa9k1krLMzvujVkBeHW1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k1f1RHVgxteoHgG/rt4MXhHsn89bG9adaJ/8nkAE/Vo=;
 b=POM9Uhb3+5FDDV4XIlITSI3b2dcPiVsBsNC6vPGTWMUtZQZTA0qGPdNwwUFv0x4G3RYx7HnHSUxDBLsZaFroi2S35jOw4n0idgHpcKULxX1nImWagS1BQ3lnu4FVMbPVtP4QvQHFySix/PaO1O6CE7xYFGhLhjbo7zf521Bi13c=
Received: from BN9PR03CA0413.namprd03.prod.outlook.com (2603:10b6:408:111::28)
 by CY8PR12MB7633.namprd12.prod.outlook.com (2603:10b6:930:9c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.22; Thu, 3 Nov
 2022 11:34:21 +0000
Received: from BN8NAM11FT090.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:111:cafe::46) by BN9PR03CA0413.outlook.office365.com
 (2603:10b6:408:111::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.22 via Frontend
 Transport; Thu, 3 Nov 2022 11:34:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BN8NAM11FT090.mail.protection.outlook.com (10.13.177.105) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5791.20 via Frontend Transport; Thu, 3 Nov 2022 11:34:21 +0000
Received: from SATLEXMB07.amd.com (10.181.41.45) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Thu, 3 Nov
 2022 06:34:18 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB07.amd.com
 (10.181.41.45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Thu, 3 Nov
 2022 04:33:55 -0700
Received: from xhdpranavis40.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.31 via Frontend
 Transport; Thu, 3 Nov 2022 06:33:52 -0500
From:   Pranavi Somisetty <pranavi.somisetty@amd.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
CC:     <git@amd.com>, <pranavi.somisetty@amd.com>,
        <harini.katakam@amd.com>, <radhey.shyam.pandey@amd.com>,
        <michal.simek@amd.com>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: [RFC PATCH net-next 1/2] include: uapi: Add new ioctl definitions to support Frame Preemption
Date:   Thu, 3 Nov 2022 05:33:47 -0600
Message-ID: <20221103113348.17378-2-pranavi.somisetty@amd.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20221103113348.17378-1-pranavi.somisetty@amd.com>
References: <20221103113348.17378-1-pranavi.somisetty@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT090:EE_|CY8PR12MB7633:EE_
X-MS-Office365-Filtering-Correlation-Id: f0ac158f-82b9-48ef-0039-08dabd8f59e0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ubzZ1xq/JDxj/4DjMvcKUVSFn/VmIXRd3t9gewbigVTEz9DdvBzMhoUiaehHasuPMhartGGmoXcW8PypRnXwif52Su7NQIZTKbphD0ViYx5PbFfHBdF/WERhojIfGD8bvuCp/TXSYurnC3ITmhm0ADUeKUDM3z6jx3THbvHj3LjiDGVirCZWvgalrQagzVq54HmKoMKRtUTTx8ixgZoUg/mZis43+pFqnnP3fL5MTN6taorgo6iANjJBR8soSIELpkxaI+rRWHJz8GqdBI+No18zlNmxtbscf7j+JN/jQ7ZrvbaNAGth/qp3+jYLgFpD/H3QkmKEWGNnWxGEKdkyvQgFz1ehqN9nt2UjcpPlVddYkK1sPybdV1lhy4wbEb1/UIcIppirQqgau0WWnxBL2VNV/rgVL6AAynxR5HItDHX8JNTCyGt1OdUofLTrYSE/k8TVuyQ/tl9cOqSUQfHMcHirxwK+YYV+WMZcLIiea9TCHXiUE+9cjsKHICAZNzIF1ny4lbzlhsuIZIYKUnxLj/Yy4ZOxH2y875dVqcs0dW+ny5bHX24bDiV8uDbFPGvYKuWzVHD3V00lxyJAHsxZG9824p750fdGDSFbTqvhs66CKdaHy+E+cm4IXUDmGnpSlSzQZje4TsRq4GuIp2u0zp6tfZmgD+v88zv/dAzCJLGp0D2VvyQSLvsJ731erwpMLI/hAs42I/Hprkf/aHPmut5i7qYLy7Sck0MpK6+k44uqBoCTsJzMuR+54Kn1a3lulQDnbYRupuqdQghIJsiiXjGgdS+X++doJldilgtF6s0=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(346002)(136003)(376002)(396003)(39860400002)(451199015)(36840700001)(40470700004)(46966006)(2616005)(336012)(1076003)(186003)(26005)(6666004)(36860700001)(316002)(47076005)(426003)(83380400001)(44832011)(40460700003)(40480700001)(2906002)(54906003)(110136005)(82310400005)(478600001)(70206006)(41300700001)(5660300002)(8936002)(70586007)(4326008)(8676002)(81166007)(36756003)(86362001)(356005)(82740400003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2022 11:34:21.1703
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f0ac158f-82b9-48ef-0039-08dabd8f59e0
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT090.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7633
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add new ioctl definitions, SIOC_PREEMPTION_EN, SIOC_PREEMPTION_CTRL,
SIOC_PREEMPTION_STS, SIOC_PREEMPTION_COUNTER, to support IEEE 802.3br.

Signed-off-by: Pranavi Somisetty <pranavi.somisetty@amd.com>
---
 include/uapi/linux/sockios.h | 6 ++++++
 net/core/dev_ioctl.c         | 6 +++++-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/sockios.h b/include/uapi/linux/sockios.h
index 7d1bccbbef78..382f959fb371 100644
--- a/include/uapi/linux/sockios.h
+++ b/include/uapi/linux/sockios.h
@@ -153,6 +153,12 @@
 #define SIOCSHWTSTAMP	0x89b0		/* set and get config		*/
 #define SIOCGHWTSTAMP	0x89b1		/* get config			*/
 
+/* Frame Preemption, IEEE 802.3br */
+#define SIOC_PREEMPTION_EN	0x89b2	/* enable frame preemption		*/
+#define SIOC_PREEMPTION_CTRL	0x89b3	/* configure preemption parameters	*/
+#define SIOC_PREEMPTION_STS	0x89b4	/* get preemption status		*/
+#define SIOC_PREEMPTION_COUNTER	0x89b5	/* read preemption statistics		*/
+
 /* Device private ioctl calls */
 
 /*
diff --git a/net/core/dev_ioctl.c b/net/core/dev_ioctl.c
index 7674bb9f3076..46fb963cd13a 100644
--- a/net/core/dev_ioctl.c
+++ b/net/core/dev_ioctl.c
@@ -409,7 +409,11 @@ static int dev_ifsioc(struct net *net, struct ifreq *ifr, void __user *data,
 		    cmd == SIOCGMIIREG ||
 		    cmd == SIOCSMIIREG ||
 		    cmd == SIOCSHWTSTAMP ||
-		    cmd == SIOCGHWTSTAMP) {
+		    cmd == SIOCGHWTSTAMP ||
+		    cmd == SIOC_PREEMPTION_EN ||
+		    cmd == SIOC_PREEMPTION_CTRL ||
+		    cmd == SIOC_PREEMPTION_STS ||
+		    cmd == SIOC_PREEMPTION_COUNTER) {
 			err = dev_eth_ioctl(dev, ifr, cmd);
 		} else if (cmd == SIOCBONDENSLAVE ||
 		    cmd == SIOCBONDRELEASE ||
-- 
2.36.1

