Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B5AC33D1B0
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 11:21:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236642AbhCPKVb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 06:21:31 -0400
Received: from mail-eopbgr760058.outbound.protection.outlook.com ([40.107.76.58]:9162
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236295AbhCPKVN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 06:21:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jwZG7frf5TcskJscjymuDMTjeDpcU7LSO8MKb2Cz2JlNqHI3G462wagOWtwhQVXS2O9rYkAvvpmerJ49SW02wMACzMJCOAfqKf9whjo7Iurc0gMXXJA9erKEccgBFcHO9vZ1QbtQDDNrPOHNjzNlXrp5SD1UvWrbHCcuWEhNT5IRTMvjJH342Dfnj8iiGafkflpWGWzXWneZZ69cbRRZFC7leKsugC/lRecftbhMv8xCBO6K6lszr/f72wCXelz/HwSaw2RXscDmBE9uSt968MLkXIS0av+W46lyLjb+TDgr1Bo+eGptMlBh6eniPdmAULybyaELT+WeGHrJ0/EhKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NisMVXNbyB6hiNoXSyUH8kMatxBXFUxokbytJR0tyhw=;
 b=hh4Nr3RjT5sEyf0J/jVGOVARBHhyFHS5HvN0xuNmMUpqi/Upv9pHSLFuaI3gt1dLLQsM72LrRqpYBLJckDTFfwABp//9avRhjeCk3jSfdCfXoS/31vKuzXuu3KbYvx0URb6Dk2OlAwr3Xa7EeQG5FO2noth+quBQhK1Vi+lyggFDq1gUF9Qk2FYX9/m1r42T4EFNUADPqWqoARcxJVhdXih15mGBwYshS+QCRK1ArulaAdxtsGUH5RVISotfGtAmFGBZlqWrRgXddul+lBQ4lRIj8AM2riDjHjD44xHEzdAlIRx4VxxJJFW9iNH9+IJde8KY0H1O9giRUmkp5xKxzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=networkplumber.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NisMVXNbyB6hiNoXSyUH8kMatxBXFUxokbytJR0tyhw=;
 b=VHmj1QWZdUgEsYlULjVzk6Zy/CJDCFi4IO286Z9MzWK9Hm4FA5zLHnTydODM4cTgLH4pyb38G+5sXvcHHWlfSTeUfk4LUn76wpUZH9HG8KcdpArm5yEBPQB6M9Y/kR8fEUykoEgniOdLIqRvFnooq8FQx7yXODfSAmTGW6bKDoiQMkJ0A4jZaFY5XaWIYAq4jCM2GIkN7ev+eN/XKrL5ZuTrJDTKC7W+VExTnC9yzcbxyydBkJqSSJBB6emmOVNhogKGOypAFZ2hP03ka19GX0xFcBfuU7qn/equ9ixbD60JHda+j2ylaYRHmAuvmqUu+v3Rkrihf5x8MZsRwUhPDw==
Received: from BN9PR03CA0185.namprd03.prod.outlook.com (2603:10b6:408:f9::10)
 by MW2PR12MB2522.namprd12.prod.outlook.com (2603:10b6:907:f::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31; Tue, 16 Mar
 2021 10:21:11 +0000
Received: from BN8NAM11FT036.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f9:cafe::8b) by BN9PR03CA0185.outlook.office365.com
 (2603:10b6:408:f9::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32 via Frontend
 Transport; Tue, 16 Mar 2021 10:21:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT036.mail.protection.outlook.com (10.13.177.168) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3933.31 via Frontend Transport; Tue, 16 Mar 2021 10:21:10 +0000
Received: from localhost.localdomain (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 16 Mar
 2021 10:21:04 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>, <dsahern@gmail.com>,
        <stephen@networkplumber.org>
CC:     Ido Schimmel <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>
Subject: [PATCH iproute2-next v3 2/6] json_print: Add print_tv()
Date:   Tue, 16 Mar 2021 11:20:12 +0100
Message-ID: <ef15d0e8dc8b58f93537116dd2a43f7d188a8fb6.1615889875.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1615889875.git.petrm@nvidia.com>
References: <cover.1615889875.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eec84da2-d34c-48ad-5624-08d8e8653875
X-MS-TrafficTypeDiagnostic: MW2PR12MB2522:
X-Microsoft-Antispam-PRVS: <MW2PR12MB2522B903A71DF55D97BBF0C2D66B9@MW2PR12MB2522.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: USvP+p0FR3vzWvFYE3hFjVcE00lF/RH2SRVdi8iXcr+E1A6gOF6X0nQh283xpTznbgPMRM0a4IEeX5fMQmZO/qk8su/vowBwYCOMyPvXkHW1yQCLqX9Va8l5O2xPvKUwXGhXMYYnxp1q2RZVA2bNpf9pOrWmF80Ljo4nb8GdtbDrchdtvWF7+K4MDBXDczQnCie6wuhAx1raaNL5K83LPeKLNkIUFRXeblJGnCMonywFV/IRLeJeFi8hJauyHRX8bFyxhMg7V1o2Q8aJb8Q+BBAqNGZUvaR+A0JYwRZVTt9ExlQLJGX+lQ9e6EW5t4PcwpQk/66qlOBfbrTIBwLVD7SUQUAi8UYNS9xFwvsZPBQE7Hh+dbVPSbvNUjM7RcsjlRX2WrQJKnyCyCBsb+aR9SYK9VSwXHZ6KlUi5UZKu368b0Ch5gPDDeyZjq5QAM3Yb4Fuj/CzRMs5BZQ5AbUuGmzJdkgWg/pQWvOI6nN1LtvO2ZCFukjRZwn79nH+hXEnJVx1/RWDy4eESfMAnJxyGPnPqqTOauif+lZKciZf8lQ1Eod2mc/Jhb480LG1t949nOs/E0qZ4zgjYmsXpq4PeZN4QDPeLpJF37qn68YGzOfotUOMkfZjiYR4n/5Lki7zgKT4sTP9mJVTuNpt7Ga5TIlvI3lnd3x7WI1kVkDenEblrDmreoh+IUfAtJvAMj97
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(376002)(136003)(346002)(396003)(36840700001)(46966006)(8676002)(5660300002)(34020700004)(110136005)(336012)(82310400003)(2906002)(26005)(54906003)(426003)(2616005)(36756003)(86362001)(8936002)(47076005)(4326008)(16526019)(186003)(356005)(316002)(70586007)(7636003)(36860700001)(107886003)(36906005)(70206006)(82740400003)(478600001)(6666004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2021 10:21:10.7930
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: eec84da2-d34c-48ad-5624-08d8e8653875
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT036.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR12MB2522
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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

