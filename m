Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85BB333F0BD
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 13:56:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230169AbhCQMzb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 08:55:31 -0400
Received: from mail-bn8nam11on2078.outbound.protection.outlook.com ([40.107.236.78]:64321
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230154AbhCQMzK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Mar 2021 08:55:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TxGC9H3TJViSCkaxXk3MwYbJqJHnSXxnVMZ6e/aYXzH9is4dWPOHsXP1JT7Q0/vNn8cdKdZHI4VSYNO4LJAQj7+c8EVW0WdtLxClzBfUKVcGKt6E+pEhP0ngZKZS9LlaEEmjaZwXnEAwjGpN2pI7RnRdTbDgcebEZJbLKdYFszU2lGbEHNH97gOiqK/zywgDNZVMIWPcXsIXegMR9mZGfO0v8WsOWJz8GYdlWcuBaiuKAz0kI33MdfwyJqjdjSFPb69Iu4inR336o6x4X7g/+DeHj4/ZhHWCwrb7L3Oi1egnpJYhwbluOOn1ip77v3JFIF3tlIkkr+ctuC2JhIuaPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qOLvHl37FTBu4aiyVABEztfa+PmHInU/IFkoTG2qzfE=;
 b=f/30519LtIE7GmqVNVxt+WfX1Z6DNPhDwzBYMC569UvWRR4n+FdZyv0BEAkGK90g+fVvi/XidUJvaWA6z7MNEWnWO4PNuU4VD2x5G4PW7l/Ye4AgNhgCFclwv4KC8keaI6ujpP8uaUOuUY1ZXUGWisHRqBr9ibavfgmQ01HD7xBa20VutuPFHeHKMIs+n5nCNUaCVGKNA6JzqeBZ4KUIPV0Kj+tZSB5dPTK1A8GaX9YOx0PzUfb3QffFoggrwP/3gW6o8LcSG2CPwgZg6+SQO6Q/3BWxnJfSW+g1UzMYfKSO4aXEzpCGukzeB8qJDUh4/tO3kFrK3wgLOsEhGkshug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=networkplumber.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qOLvHl37FTBu4aiyVABEztfa+PmHInU/IFkoTG2qzfE=;
 b=nBPMEZFIi0MbVBi19gsIWOALl7WrbCPMIJWmEVBnG77TDaPcy+/yxFItflSGi3e+Q2JaUyIfxGviYm6JuvKzbrMWzWy2xsaR0McRfhITY5dd+OIuAxyGLFD2qr+tZktsG+L3QVWudBfR0pcvtj7rwwicYhQhNEEi4y3NFfITi3sOPNVA9l8e9JXMz8niXeaJAh9qLu2txT5F/hLKdM2aAP1dlnbH30QkWRkMAy1PyN53hKbo9hSDgAP7fvyCna5pruK+RM/6bXlHUkKQyhNEcc5XoyXyXPZqAM5YswtDUQPhuMbUe8NNWYY+/My/vHNXLHVSBZ6dTuPhdyVreRUsSg==
Received: from DM3PR11CA0015.namprd11.prod.outlook.com (2603:10b6:0:54::25) by
 BYAPR12MB2725.namprd12.prod.outlook.com (2603:10b6:a03:6b::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3933.32; Wed, 17 Mar 2021 12:55:08 +0000
Received: from DM6NAM11FT057.eop-nam11.prod.protection.outlook.com
 (2603:10b6:0:54:cafe::21) by DM3PR11CA0015.outlook.office365.com
 (2603:10b6:0:54::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend
 Transport; Wed, 17 Mar 2021 12:55:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT057.mail.protection.outlook.com (10.13.172.252) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3955.18 via Frontend Transport; Wed, 17 Mar 2021 12:55:08 +0000
Received: from localhost.localdomain (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 17 Mar
 2021 12:55:05 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>, <dsahern@gmail.com>,
        <stephen@networkplumber.org>
CC:     Ido Schimmel <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>
Subject: [PATCH iproute2-next v4 2/6] json_print: Add print_tv()
Date:   Wed, 17 Mar 2021 13:54:31 +0100
Message-ID: <ea4080dcbaf5a19c621416db5c30e87ad77850e3.1615985531.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1615985531.git.petrm@nvidia.com>
References: <cover.1615985531.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6cf376af-7b6b-4408-6dd1-08d8e943e4c0
X-MS-TrafficTypeDiagnostic: BYAPR12MB2725:
X-Microsoft-Antispam-PRVS: <BYAPR12MB27252C05FAE23F53E28561CBD66A9@BYAPR12MB2725.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xerhwkekUdE6vEYnLQNfosROeLFtuZGyNzHVEoGfvdYU57Nb72D7D+jaT2TeX5jIq0WYHBnliVvx1cqa9Npmm/iiqexw5nY/EkUC9HYUXVhZg/xKJX0uJ4MsV8yJt5k4liclytAp1Cx0caBnhf0e6F3SzqSIvtegLUjxRTYGDALOBAopXmSAJVN39DWLwZhfffyDFWZmIj2Bhqz4hR5x6lN6ZvBSGOn4eyqfCBQqJIYZYW6SdHDI2lps/wgVdZe8e21El3ylO5kwhohTIYM9iLBkUbdPHHefyKlWtxH3sonELGORZmTqTtuOzjTEj7JLC8glYq6obYM8mcomLXjeATxvez2U+anBVtjWaQmsLQr209WrqGeTlokTlh0mM40hVX1qEBs4ClUtf5Kp884PXj4q2FyeZvqu/rP9mAVycGmLqQi6NS56WgibN6IsPoO/fTHZfXWazxbKJncGGQLu0Zm+4Ou+0kI2istUcmCwIWiA9KklD8bNu4RFCus93RPeq6i3sxBsnbxkYC5bH015vXShCNO3HTUOKhLkC8BFdtu6mvkZmONMUBpYXNlGcubU3DbrwTtARIFUO0pDqyKTL7tflSOqMl1OaYlYLFif8pBAJbDJvKxUWzgKRQnbya6D4W1Q+5Z5v/g2Y5gIdbd38+YQzlZ8sG8BtU5ji8tyJrQRZrd5Ejycl7KlCh18yp5O
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(376002)(39860400002)(346002)(396003)(46966006)(36840700001)(6666004)(356005)(70586007)(2906002)(70206006)(86362001)(82740400003)(47076005)(36860700001)(36756003)(5660300002)(34020700004)(7636003)(8936002)(2616005)(8676002)(16526019)(426003)(26005)(186003)(110136005)(4326008)(36906005)(478600001)(316002)(107886003)(54906003)(336012)(82310400003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2021 12:55:08.1682
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6cf376af-7b6b-4408-6dd1-08d8e943e4c0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT057.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2725
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a helper to dump a timeval. Print by first converting to double and
then dispatching to print_color_float().

Signed-off-by: Petr Machata <petrm@nvidia.com>
---

Notes:
    v4:
    - Make print_tv() take a const*.

 include/json_print.h |  1 +
 lib/json_print.c     | 13 +++++++++++++
 2 files changed, 14 insertions(+)

diff --git a/include/json_print.h b/include/json_print.h
index 6fcf9fd910ec..91b34571ceb0 100644
--- a/include/json_print.h
+++ b/include/json_print.h
@@ -81,6 +81,7 @@ _PRINT_FUNC(0xhex, unsigned long long)
 _PRINT_FUNC(luint, unsigned long)
 _PRINT_FUNC(lluint, unsigned long long)
 _PRINT_FUNC(float, double)
+_PRINT_FUNC(tv, const struct timeval *)
 #undef _PRINT_FUNC
 
 #define _PRINT_NAME_VALUE_FUNC(type_name, type, format_char)		  \
diff --git a/lib/json_print.c b/lib/json_print.c
index 994a2f8d6ae0..e3a88375fe7c 100644
--- a/lib/json_print.c
+++ b/lib/json_print.c
@@ -299,6 +299,19 @@ int print_color_null(enum output_type type,
 	return ret;
 }
 
+int print_color_tv(enum output_type type,
+		   enum color_attr color,
+		   const char *key,
+		   const char *fmt,
+		   const struct timeval *tv)
+{
+	double usecs = tv->tv_usec;
+	double secs = tv->tv_sec;
+	double time = secs + usecs / 1000000;
+
+	return print_color_float(type, color, key, fmt, time);
+}
+
 /* Print line separator (if not in JSON mode) */
 void print_nl(void)
 {
-- 
2.26.2

