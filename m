Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85DA833949D
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 18:25:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232613AbhCLRYf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 12:24:35 -0500
Received: from mail-eopbgr680041.outbound.protection.outlook.com ([40.107.68.41]:55357
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232530AbhCLRYN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Mar 2021 12:24:13 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O0Ewp3BjAXaJEboCXyml04liMrTSBONJhyL71jXpuli9T9K6jqdAJSjMY9A0g3UXX2aQ4amX0ZRWCbnqCDDb5bGKzRQt7/wRRxL/vwyZwIaCbt/QXuqHFeMB/Q/akOC/035Rh5JrHEFs4M6yKWJm4aGs4cjkfyA8ty8zB9mSAZSHrs/jAjamp7FoBqXYhg0MoIrSrXhiX/y4M9GYmI8FgfN4Pee3AtDUnZiH/wKQP/0MdmoXTHmpUUDgjFa7IHwsgB5hnac5cu3VPUcaw4kEREc65oKCXcsytDpOCZwMqmWqDlDYOY9bSsCMt2xC1CIow0FTSIcouzHee/lcNriYdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/ok/doblIRG4rn6r1iqKIICkELgKMHd6dsybsQer1Mw=;
 b=FADfCEy1sdJpIc8Y6rDhHnJcGFRWqH16v3wNJw/CEpDurxrq9Iz9vYYLs4NQf4fyn0cX1RlzUIlW/2rFBh1AZJJXEtaDJ46U8dKT6Un3n3lvpCD/imaYmvVxR27LkNJNMKP/+PNz8B8ecryoJkTIajrYaKK+YHT6nWE6n8NI5JiVf3blCbrVgeVqJ4kQP+ddyXT8mwZ93t+C314v93QPrImb5O2SqGxoOEjNVjEdN58MR0HhyXEcZTGDP63PiqCkFlxh0Je/kjULZBJEBl83lPybyMAcd6c9h6d7KnWomhnitlYg1fwoGugwyM/+aKRP+xAfQyIRR3JYK/YZdsdg0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=networkplumber.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/ok/doblIRG4rn6r1iqKIICkELgKMHd6dsybsQer1Mw=;
 b=TuQrexEnpD1dKHSy1T+Gsgbz5kKsFchNL/YBheP0XKxqOSMI82SEkVseR2tibyJeZvH+bSUe6/m90MHhykjiERhWujItUzbxsesf+5szlWHRTtL9PapWWJV462QFwuq19rjtMjE/w7u7RxipJUei+nE6ZCkvs3fGzyTtyZEwbj9+PHSVoNDZQoo3hFZwi663SYrZfT6rZL+phNXFwmVHkn1QlatNQoipQ+qxV1koKWZcIyyCC7PxaivnBbSuwz7M5BcGobF21r9zHFLdpuI63Cpbvw8xKZ+XZz6UN4Y1MgnJPNrMTi24NUNtGUZcXQSFn2+FLkk3LQUkCoH8a5vlEQ==
Received: from MWHPR1701CA0006.namprd17.prod.outlook.com
 (2603:10b6:301:14::16) by BN6PR12MB1538.namprd12.prod.outlook.com
 (2603:10b6:405:4::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Fri, 12 Mar
 2021 17:24:11 +0000
Received: from CO1NAM11FT040.eop-nam11.prod.protection.outlook.com
 (2603:10b6:301:14:cafe::9d) by MWHPR1701CA0006.outlook.office365.com
 (2603:10b6:301:14::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend
 Transport; Fri, 12 Mar 2021 17:24:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT040.mail.protection.outlook.com (10.13.174.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3933.31 via Frontend Transport; Fri, 12 Mar 2021 17:24:11 +0000
Received: from localhost.localdomain (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 12 Mar
 2021 17:24:08 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>, <dsahern@gmail.com>,
        <stephen@networkplumber.org>
CC:     Ido Schimmel <idosch@nvidia.com>, Petr Machata <me@pmachata.org>,
        "Petr Machata" <petrm@nvidia.com>
Subject: [PATCH iproute2-next 2/6] json_print: Add print_tv()
Date:   Fri, 12 Mar 2021 18:23:05 +0100
Message-ID: <24b7728566932f41e825bf20098375016a9c01c2.1615568866.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1615568866.git.petrm@nvidia.com>
References: <cover.1615568866.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8f770a80-f573-4693-f780-08d8e57ba699
X-MS-TrafficTypeDiagnostic: BN6PR12MB1538:
X-Microsoft-Antispam-PRVS: <BN6PR12MB15385B81ED76CEA8D7F5D76AD66F9@BN6PR12MB1538.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BCAGXvEvZOrXWm3V1wMfWgcIlzHTL+x7ijZ4+E3UwBjuvt+mcNsBQJGnlL5edPurgBIm4T9kXDFTOzGTJTFeRSJFHT6IwA+fQa+x7YmEoc/Ak3jh1VVJKchWAXc2uyT1RZfRTFfrz+YFS6Wms71RQHz4V6RGi/50xER9MlGuVuTzu97SLzoyyw4zJHcHgxtBYyeXGgdy2yTHW2GeovGz4W2VO+p4DegbHnW/nxukKbY8UowfHYkwvlNW4pXkLE1yVqYyFbeVivaDiuVKupOakImIAJJ8cMfaCX6rKcxJBLC7JvJ1VQgUFFAzzqA4BJgpbzOyh9IIdA2bbUeWRFHTlT+pzljBRvpSKPWkucfeWkM2/sZrd/LNmLp1spE3YpmkYjBSBejclYu+F2Px+Z7gMW84sLindkBQiDpIRsvP9ttOyp1M1CttelQ4lnxyTUr6cyYIdbwaeX5nAQ1Ey5dD3IjIGUugAUl2znJfgYzDMmv3u0h2i93g2hPgQ9yp8dVoevyRbQXdXB7+y8nJ7KVE1wPgoQgBvIhUiY3YE3RafqMmpdOfFaAACKNXWswvnLSrsFLNJa5fGMbCwfRzyfGaPQed0sFtwstC8YbhA+5rIODUQO6Vf5HLVEQ9LtfEq3zDvGvuHYyeEnXWaMFg2hdcMcVWBUbiH4b9gAm2xlRTAHvQI/UE7ewfIF4bHSj98G7F
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(376002)(136003)(39860400002)(346002)(36840700001)(46966006)(82740400003)(356005)(47076005)(336012)(7636003)(82310400003)(70586007)(70206006)(34020700004)(36860700001)(36756003)(316002)(2906002)(5660300002)(26005)(426003)(86362001)(2616005)(8676002)(4326008)(54906003)(107886003)(478600001)(110136005)(6666004)(36906005)(8936002)(186003)(16526019);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2021 17:24:11.0692
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f770a80-f573-4693-f780-08d8e57ba699
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT040.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1538
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <me@pmachata.org>

From: Petr Machata <petrm@nvidia.com>

Add a helper to dump a timeval. Print by first converting to double and
then dispatching to print_color_float().

Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 include/json_print.h |  1 +
 lib/json_print.c     | 13 +++++++++++++
 2 files changed, 14 insertions(+)

diff --git a/include/json_print.h b/include/json_print.h
index 6fcf9fd910ec..63eee3823fe4 100644
--- a/include/json_print.h
+++ b/include/json_print.h
@@ -81,6 +81,7 @@ _PRINT_FUNC(0xhex, unsigned long long)
 _PRINT_FUNC(luint, unsigned long)
 _PRINT_FUNC(lluint, unsigned long long)
 _PRINT_FUNC(float, double)
+_PRINT_FUNC(tv, struct timeval *)
 #undef _PRINT_FUNC
 
 #define _PRINT_NAME_VALUE_FUNC(type_name, type, format_char)		  \
diff --git a/lib/json_print.c b/lib/json_print.c
index 994a2f8d6ae0..1018bfb36d94 100644
--- a/lib/json_print.c
+++ b/lib/json_print.c
@@ -299,6 +299,19 @@ int print_color_null(enum output_type type,
 	return ret;
 }
 
+int print_color_tv(enum output_type type,
+		   enum color_attr color,
+		   const char *key,
+		   const char *fmt,
+		   struct timeval *tv)
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

