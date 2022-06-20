Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB0AB552125
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 17:36:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234546AbiFTPgY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 11:36:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234315AbiFTPgX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 11:36:23 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2063.outbound.protection.outlook.com [40.107.236.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50E5813F5D
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 08:36:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VpvtzsvNNXQW8RebsoWFen9h+ETHLzgfVdvk6aMngZMgwXwU9nU5M3Fo3dZEbqYEQdNIEXtaNmm1VhHCw1GT8fGefjj28de9CG6X2tyhQ4AjZ9eCyeLV1JFPxvc0gPUmtMKIqoUh21ikK7lm4vvuExgKdgmxXa+0mXzRIZjJ5uuIqqSnWilUFvWiOr8ndchbcmM0EbNyIosCLo4ZikGNT3U9FmN8lmPrTUKx5WrCs2bIoWW1tp+s4dR7fMeTQzAhfGzN/s6wBK8Ca7DfUb0ryiX68wdsr5B4TxgQavvLIsmG1cmtLuOeJbnbeykXycvhZ4qsAvP9Bn1XJHaDk/dkKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qV2A0obkLlHjdJbrbKuw+gfuAw9NSSrPfVS0NZFIbgE=;
 b=fMSvKDQw8IbFugv3mJ/m+70Nl0pk/x70iCCTrbKEN0tk8sCiG4t3hEbIWEdjGkGNQCTJCnCOqvqx9e/TffmfGQ8A7tcAuHFNoflTycaJbEkZJZ1OuWCry0HnhIQl3OdiaSQ1AG4dbY3SgtWuhiKSjnVqiEfL6UprUmyo7clcwx2nIFVnWIZuh+azTKoXQChB8tMTV6maI5MXllbpA60m4lOmBuJHofwNLmYb2uCv6e7Guv7rXvRkrRBFUbvW8yb/vb9mMGR+kX32v5jwtgpa94019zm/gMRED9/rsg1oRGjjlJ/6nJz1Vujn0w+b3uGWH7bNUGbG2Py9K3D2RHmXmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qV2A0obkLlHjdJbrbKuw+gfuAw9NSSrPfVS0NZFIbgE=;
 b=I7SfiTB7tvynDkRR+plaoimAey5nluviGHI4vYBjTOtrBAhEocmiiEeTXwD6toqo4GXwDHpYMkq5qypmt6ekcPZK+u3kPefbexuJKesQKMkfzz3ArciX5Zoahe5ftFRd21ijCRsRwq8gbaBd128vQPAYtt7vqG/k9mQ+5CZqN/lrwSma0hnldkcVuuSeBbWZMiabu4Uab+0CvEwDDTADBohwshGI7ncBdKQ4AHon+ptzJO8pLkZ/Q8vb6vmckK4adorRPhZlwnukCmPxYIs2rgnfZYInpt8ofhQSLovJAr2NNIeidSAG3lHKZTDw9AKLMSMRubjG2RKuLKHsDkCxlA==
Received: from MWHPR14CA0060.namprd14.prod.outlook.com (2603:10b6:300:81::22)
 by DM5PR1201MB0121.namprd12.prod.outlook.com (2603:10b6:4:56::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.18; Mon, 20 Jun
 2022 15:36:20 +0000
Received: from CO1NAM11FT049.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:81:cafe::72) by MWHPR14CA0060.outlook.office365.com
 (2603:10b6:300:81::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.15 via Frontend
 Transport; Mon, 20 Jun 2022 15:36:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT049.mail.protection.outlook.com (10.13.175.50) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5353.14 via Frontend Transport; Mon, 20 Jun 2022 15:36:20 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 DRHQMAIL109.nvidia.com (10.27.9.19) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Mon, 20 Jun 2022 15:36:19 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Mon, 20 Jun 2022 08:36:19 -0700
Received: from vdi.nvidia.com (10.127.8.13) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.986.22 via Frontend
 Transport; Mon, 20 Jun 2022 08:36:17 -0700
From:   Dima Chumak <dchumak@nvidia.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@kernel.org>
CC:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "Paolo Abeni" <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        Dima Chumak <dchumak@nvidia.com>
Subject: [PATCH iproute2-next 3/5] utils: Add get_size64()
Date:   Mon, 20 Jun 2022 18:35:53 +0300
Message-ID: <20220620153555.2504178-3-dchumak@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220620152647.2498927-1-dchumak@nvidia.com>
References: <20220620152647.2498927-1-dchumak@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 11c23aa5-1fa0-4412-4b91-08da52d29fbc
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0121:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1201MB0121D3AB7AB3BEC453D3DB69D5B09@DM5PR1201MB0121.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Fk42rehc0l1300x5LPYoFCrCfKtVzYo764B4vcd95vs0q8cxMYENmYioiYtOeCGjKMiy8bXaeuri3Ca54+dgRHTnIX4FSHGobNXPdqQR6UdWKfsoJFdodIdh9ps2nQOgSWe22zf8MFmjsZ9DE4GSShfP56X6oa1LAb3m9OOZ/V1uvTAFneelA0rzsp2H+HU/mtzh8SFAb3zrdj05kUN90FIFSjVqyh8uxHJjJYKFjmT6tHelS4XQW4rBiPjnmFXuYW38Mgeoud4nVkvf9CIGjBPjMD7huhW7YfdKcXy+tCiSCa9VdJe3RVG8NrZud3zbhwHhjtCto8CXLo4lQ2xUncR6KnYNV07RnxGnmmap/svdGdvr9cwvhEVbCTd8gJCsg6iFF29I9JUY6BNNFAY6jXOZqFARilfLFQNMxPnevXEH2j6zRqoVi4VyBZwUAmQBv7rO3RMJpXmkmoBgwmkS/Cy1dXw+ID67/n9aNDx5fIcsgbWMqAZZbsifR56CdGJVa8oHm5Ih1KZB/XT4nZxpuaD3pb/GrS3L/Vyma+v/8E46OuTgJL3iwttOgQMRHqu/RnENHueNFf1MydvP/aKykMFmxCuhFibl66CEUP8zeqr+V4a8FcYo4gdBjEA/xw6Q12k7Mn58Jhqzo3+ACoW6KVA6CdRxwqi+Tl3Lwzs2ZkjX97vWCjmsrDV7Xj45IaMNPwO5VuUWosuqyckVZCPZWLqNwB2dgAeUbJvBNwOInfIiE/E7L92tHHMQIGcuZA78
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(136003)(39860400002)(376002)(396003)(346002)(40470700004)(46966006)(36840700001)(478600001)(8936002)(41300700001)(110136005)(54906003)(316002)(26005)(36756003)(7696005)(8676002)(6666004)(2616005)(356005)(82740400003)(82310400005)(47076005)(186003)(336012)(70206006)(426003)(107886003)(70586007)(1076003)(86362001)(5660300002)(40480700001)(36860700001)(4326008)(40460700003)(81166007)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2022 15:36:20.1467
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 11c23aa5-1fa0-4412-4b91-08da52d29fbc
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT049.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0121
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce a 64-bit version of the existing 32-bit get_size() API.

Signed-off-by: Dima Chumak <dchumak@nvidia.com>
---
 include/utils.h  |  1 +
 lib/utils_math.c | 30 ++++++++++++++++++++++++++++++
 2 files changed, 31 insertions(+)

diff --git a/include/utils.h b/include/utils.h
index 9765fdd231df..82007ec1057a 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -158,6 +158,7 @@ int get_addr64(__u64 *ap, const char *cp);
 int get_rate(unsigned int *rate, const char *str);
 int get_rate64(__u64 *rate, const char *str);
 int get_size(unsigned int *size, const char *str);
+int get_size64(__u64 *size, const char *str);
 
 int hex2mem(const char *buf, uint8_t *mem, int count);
 char *hexstring_n2a(const __u8 *str, int len, char *buf, int blen);
diff --git a/lib/utils_math.c b/lib/utils_math.c
index 9ef3dd6ed93b..903404b0f93c 100644
--- a/lib/utils_math.c
+++ b/lib/utils_math.c
@@ -121,3 +121,33 @@ int get_size(unsigned int *size, const char *str)
 
 	return 0;
 }
+
+int get_size64(__u64 *size, const char *str)
+{
+	double sz;
+	char *p;
+
+	sz = strtod(str, &p);
+	if (p == str)
+		return -1;
+
+	if (*p) {
+		if (strcasecmp(p, "kb") == 0 || strcasecmp(p, "k") == 0)
+			sz *= 1024;
+		else if (strcasecmp(p, "gb") == 0 || strcasecmp(p, "g") == 0)
+			sz *= 1024*1024*1024;
+		else if (strcasecmp(p, "gbit") == 0)
+			sz *= 1024*1024*1024/8;
+		else if (strcasecmp(p, "mb") == 0 || strcasecmp(p, "m") == 0)
+			sz *= 1024*1024;
+		else if (strcasecmp(p, "mbit") == 0)
+			sz *= 1024*1024/8;
+		else if (strcasecmp(p, "kbit") == 0)
+			sz *= 1024/8;
+		else if (strcasecmp(p, "b") != 0)
+			return -1;
+	}
+
+	*size = sz;
+	return 0;
+}
-- 
2.36.1

