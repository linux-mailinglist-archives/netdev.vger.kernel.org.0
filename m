Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F0CB33BD8B
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 15:38:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236583AbhCOOhA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 10:37:00 -0400
Received: from mail-co1nam11on2086.outbound.protection.outlook.com ([40.107.220.86]:1344
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236587AbhCOOf5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Mar 2021 10:35:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F0l/zeZV466tUyawGQ/TkJeHgxP5PuO5RwgVqndFo5URBaTiNYjaR1yJHrdFBo80ULbHbxd86p53DMHJ2tP97o7I/+UxX8yLXA6eEFydl9kH9ujSMnV64ir2264zp58mYpHV2B2UslvAR1pbG7w++7qbqEyHBWhZb9KJOIgAQsrdGPtlQgjYBg1pWUdKVmt4QYUTRin8YJQb33qEmmgfl/cYcXCMkmf0bjdKPBTD5rTrhkGKy46S4ChvQ+zED8A3sCnGZmrS0rSrMz0AleiUdyROQOCOTcyONIaPCL8E9ixF29M0iXNA+AutgJ9javX9AjEDVhmzQWj/ZV04pewmjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NisMVXNbyB6hiNoXSyUH8kMatxBXFUxokbytJR0tyhw=;
 b=d8s8ViIzrfI3qPxxISVB3F0ErMMjQs0DmOqUauDwyZhSLhT633pJGtEocI2STEH+Gwz/qhyn8zLnGhfv1AR/D5SUqRfmtwb18Ifns5rjzTd3y5/m24m3xwxv9ZYI1xvHKwKLSwly/3RIRgUo7m80VZ+AGv1VtoIReyBpF5bYdDbJbC9f5fnoBshHPFsDqP3wxsKTR+yu8OrYFa8I4ZvDC1GT62+CXCzvIsmLis22liK/+EqbHwBcjj6Y25XIItvedGrMu1zk/MhrmiFUlxK2cn7yMycKq1ugmAjDbVcisKWj1MbKdRzSJHmzcg282l2DRS4U16ICZ+peFXlq2XL99A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=networkplumber.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NisMVXNbyB6hiNoXSyUH8kMatxBXFUxokbytJR0tyhw=;
 b=YQTTi2pRmCeb5a7KdVCNxWCOIgHK1jXfwDhFzHnsJMtp8ZUNFhgElubQ1A0mbd+2fapeO9xAyOmG3QZLHyswT7dVACt5e46KV9QlR7n5z0Vqg9CY+rEtGspTng47B/PyoU5pNrYx7Q3lWB01QVl0AuMqMi7bXHRRcsuT2IRl1ZWlkpgaw2FMdXfjdatlCKDty6fhOGXGPdA63sGpEXVGHmWvri/3gek70PNypSPOt6dJ4p7r64zfN4mDhfNP5TAGldG2a2VLU4IJhyw3LskfteVXV/jJsxJVvb6H17B+xE3eXyJfWOvUbj8fMwToAszVYTVUyGX73Xac1aaT4ywypg==
Received: from DM5PR19CA0025.namprd19.prod.outlook.com (2603:10b6:3:9a::11) by
 DM6PR12MB3930.namprd12.prod.outlook.com (2603:10b6:5:1c9::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3912.28; Mon, 15 Mar 2021 14:35:55 +0000
Received: from DM6NAM11FT023.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:9a:cafe::b4) by DM5PR19CA0025.outlook.office365.com
 (2603:10b6:3:9a::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31 via Frontend
 Transport; Mon, 15 Mar 2021 14:35:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT023.mail.protection.outlook.com (10.13.173.96) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3933.31 via Frontend Transport; Mon, 15 Mar 2021 14:35:55 +0000
Received: from localhost.localdomain (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 15 Mar
 2021 14:35:52 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>, <dsahern@gmail.com>,
        <stephen@networkplumber.org>
CC:     Ido Schimmel <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>
Subject: [PATCH iproute2-next v2 2/6] json_print: Add print_tv()
Date:   Mon, 15 Mar 2021 15:34:31 +0100
Message-ID: <ef15d0e8dc8b58f93537116dd2a43f7d188a8fb6.1615818031.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1615818031.git.petrm@nvidia.com>
References: <cover.1615818031.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ed84a229-5285-4f40-6c15-08d8e7bfa442
X-MS-TrafficTypeDiagnostic: DM6PR12MB3930:
X-Microsoft-Antispam-PRVS: <DM6PR12MB3930AA61F841A57B1B01943DD66C9@DM6PR12MB3930.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MWC1nHc4TahaWM9PI+e43VUycBEESg8QfoFIpNUj2VixeWAUFaL9Mpwp+ls2W4Dm6fo0N/qwb5x1fPWGA/StnabZ04Hs5OnjuNnHMjIOe3akFx9P2CguI4DsScGZwG7bjGTRqv+lCJUR/6AJyR1TBaZlCqw0SDGqmkfCcTQHWby6f1Y0Nhu3knSUHyn8TR8Glv1Hji82KeJ12hgTigo9fBVVkKhQ8xSWBphuXh3TBOmss79H89w9Pcp2ye/+kEeK4N8e5Xdtex2u+2lnSqfaYhv1iV0JLQVu24FcKLWzxz3ckeRmbLat1Iiu7YoEztYJnK1C3p1oJTE+1x/rfCgF+WbPoXSvTsemiaSJYQpzts4YDiOw9au9GzmmglID3ZBzX4cEYF3ppHypbceyzEjRypa9v94PSujFYXeCogdzLmPYmQTMt2Rfn5IgIrSgHyh/QlesxwloH4xTAk0DXJr4o6DN7sWNJYg6pyoJ4ElWymKPRpX/TPaEty+jnKTF4x6j+ch1xyVG8yYxTJCO5Fn+OFgv2Yg0erME1XaQxBMRhls+nGQnjySvQfQ70yXbG2GvzA2zY3hY3zI+UHu9bjxdXaV/ysKljAPjzL83bkfmuW7K50tBoWGga7qTodRv7D7C4sVefiwO2niFo4NAB857brYIq37ZowxXu2ElobG6JFAju1enNlsBIw7NjWjep/2n
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(39860400002)(376002)(346002)(396003)(46966006)(36840700001)(70586007)(26005)(16526019)(70206006)(107886003)(336012)(5660300002)(47076005)(4326008)(186003)(36756003)(2906002)(36860700001)(54906003)(2616005)(110136005)(34020700004)(316002)(36906005)(6666004)(82310400003)(8676002)(86362001)(356005)(426003)(8936002)(82740400003)(7636003)(478600001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2021 14:35:55.2042
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ed84a229-5285-4f40-6c15-08d8e7bfa442
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT023.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3930
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

