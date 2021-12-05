Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB80B468B07
	for <lists+netdev@lfdr.de>; Sun,  5 Dec 2021 14:20:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233466AbhLENYU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Dec 2021 08:24:20 -0500
Received: from mail-mw2nam10on2057.outbound.protection.outlook.com ([40.107.94.57]:26958
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232425AbhLENYU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Dec 2021 08:24:20 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AWbHvxu5ko4ZufARroIRt/JRd1kMj/U+WgxwZScikCeS6m49MeXzDQ2VovHHXt3V3hwQ3KST4mjnzE1/RW9jtCM7PYBsr/mozSid1/UPS6EJ/zSFzU1nzvRLwZ76umGza85hr0ZjcFYIw2uj9ovcCdFgrCOqBzLVaZl2kRRWoH55W8IlErzysBYVJgZf7rdiPBnNQxvAk4g7XAfj8ycq1hJQfIUtiEt3Ffj5ruKXPD5/AZiHMuwm67PHk/cbRp9u6sMncTjQ61K3vuhIi4gBwT1DX4qvCBxXPJQJHazbVEzpYmf0SIvhuLSS0q77e6IMMx5snVIZ8FGbF+sOAku9Lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NV12cvh9Mq5zGzexol47u0+a4eZQgw/oDcGXjggMCgA=;
 b=ApTYaQvKuD9VFFwZnzfK38mcxT8PfQHSS8N5s7VcHEBMXCb4DJJwyPpTSfJY10CRAw1XKoTzVx0H9g4Ha3VwVlFw3xOoliySOBrt53InmrWoYMR4ba628sUdEOO0gkBGd8ZlOaF0ICuOVJCrCUhiBBZaNqm6GN50NKLgRJ2Df3VCWxkm0y9Q5jTc5MswU6Mu5z0HqIMDjZiV2QQX7mafr1Ds/iW6mW+8qfl47IvWGJDlFIFUgvJEELT3PrRI+Nmj6fOa+STQxvkvm/NlUEzeDxmgYhf4n5zeQI6JEbrj8O0+9KYdI/n2KLgHjxuS3Vab1VBgL7+CfomMZqrUVY0Z0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=networkplumber.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=quarantine sp=quarantine pct=100)
 action=none header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NV12cvh9Mq5zGzexol47u0+a4eZQgw/oDcGXjggMCgA=;
 b=HFHji7z8bMbqHHHY5aDrQQ4qa97i9PhPoQxwFAISTG4hAXpHoSzU3rwVXIpCzLrWXFJmfewMehqQCDN+wFeD5T8KJ6322jWnDIr8AXllpr6jUFK7DdXtYyoKmTKGGYBxAw/1P2UphOy/5R139xj8p0DlJKJSVQ0HUMkGs+XZGVuUYOUZy7UipY178GXIHCvWSBNp0G1MTCEZVUnbFANZ8SaIY7C5+U6Y+OAu1I0x0A4Sbh3I1cGEZHg9YwqFyLDvMQLCGwDNZpTP6cBdVRWvSu1zYg/3R6JbQGBsfqDKP6899/rK2rBuXy3DGA4AFGTfncH7G1WcPYDz/txNvkDBgw==
Received: from MWHPR11CA0040.namprd11.prod.outlook.com (2603:10b6:300:115::26)
 by MWHPR12MB1885.namprd12.prod.outlook.com (2603:10b6:300:114::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.20; Sun, 5 Dec
 2021 13:20:51 +0000
Received: from CO1NAM11FT016.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:115:cafe::8e) by MWHPR11CA0040.outlook.office365.com
 (2603:10b6:300:115::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.17 via Frontend
 Transport; Sun, 5 Dec 2021 13:20:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 CO1NAM11FT016.mail.protection.outlook.com (10.13.175.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4755.13 via Frontend Transport; Sun, 5 Dec 2021 13:20:51 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 5 Dec
 2021 13:20:31 +0000
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (172.20.187.6) by
 mail.nvidia.com (172.20.187.10) with Microsoft SMTP Server id 15.0.1497.18
 via Frontend Transport; Sun, 5 Dec 2021 13:20:30 +0000
From:   Paul Blakey <paulb@nvidia.com>
To:     Paul Blakey <paulb@nvidia.com>, Oz Shlomo <ozsh@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, <netdev@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
CC:     Simon Horman <simon.horman@netronome.com>
Subject: [PATCH iproute2-next 1/1] tc: flower: Fix buffer overflow on large labels
Date:   Sun, 5 Dec 2021 15:20:25 +0200
Message-ID: <20211205132025.15596-1-paulb@nvidia.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5a42bc17-e0da-46b0-657e-08d9b7f20f4d
X-MS-TrafficTypeDiagnostic: MWHPR12MB1885:
X-Microsoft-Antispam-PRVS: <MWHPR12MB188561DD5DD980B1966CC64DC26C9@MWHPR12MB1885.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r3roRRfHNRjsnnuAsGhn8i5GflS51S2m7SLXWPLdovNWLxEsy9U3lnWoC1vYUbzDSXPrjMIGuYl1rYg3SLpXsFIeuyEwMjdKHmews3HwSjpFXi+e38gQB59Fis29bfpXSvw+mmrolbsIEsmcHoGgiFw79Xef3RYvVZTSn9yIc3LRd+9KgNDksHa/eOg7vX/OPqj3i1nBnRLWKd2sk9VH1KcG+1Eb81EEKnN+yEt6nssgSsJeF7uTzlAgw9F+UWxA36+DQoHgfULvnN3yvH7N5U47NPgi6TaC8+8nizQUrtHccuwCYvWXzdlLKQ958yWDz/Vi83BNKSIOrsS2EHPRdWyoQ8veN4gNiQdgvu8Lm7ThdZwboYpNkTz9bckdGZocXv6hLNiD6cl3T3/6iKak/07jIq6VZP4o1g5o0/wIXL/jtS2DCPi807ozZf0rlZuK3uU1JVaveziY1XVEXbNP0OHsah99IUbaF/QnszNr1bzjtgOAtuoSE2xiLkq41KZhlkjKxtPU6DSUrO+KJEAaxIzHBD13Y+Kl2GuN5UN2zOU8M7ZAaTlzTSxk5PY0egYG+MRRK6yUXRt1X2wJ2yqhsNuUUCUyAqB5SGYGVwS05WQsAH3qsJ1TsAJaDgRYlrtBIdohpynt3/BnoGNQ+3S9LcbQVV/L+CIf/UhwAqCWg/8Izuah3RF9ygD/x5rH9BP1YKghPJtiULCM2MWb8gWgG/cy1f1T20EEvCYz0eXC4JW0rA8J2WOvn9yyCmWbFFNndbGVrat+nlVyH/t3B0ArVA==
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(40470700001)(2906002)(316002)(86362001)(336012)(6666004)(36756003)(70206006)(426003)(26005)(356005)(83380400001)(4744005)(7636003)(186003)(36860700001)(110136005)(5660300002)(1076003)(47076005)(8676002)(8936002)(508600001)(70586007)(4326008)(82310400004)(2616005)(40460700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2021 13:20:51.3210
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a42bc17-e0da-46b0-657e-08d9b7f20f4d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT016.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1885
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Buffer is 64bytes, but label printing can take 66bytes printing
in hex, and will overflow when setting the string delimiter ('\0').

Fix that by increasing the print buffer size.

Example of overflowing ct_label:
ct_label 11111111111111111111111111111111/11111111111111111111111111111111

Fixes: 2fffb1c03056 ("tc: flower: Add matching on conntrack info")
Signed-off-by: Paul Blakey <paulb@nvidia.com>
---
 tc/f_flower.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tc/f_flower.c b/tc/f_flower.c
index 7f78195f..6d70b92a 100644
--- a/tc/f_flower.c
+++ b/tc/f_flower.c
@@ -2195,7 +2195,7 @@ static void flower_print_ct_label(struct rtattr *attr,
 	const unsigned char *str;
 	bool print_mask = false;
 	int data_len, i;
-	SPRINT_BUF(out);
+	char out[128];
 	char *p;
 
 	if (!attr)
-- 
2.30.1

