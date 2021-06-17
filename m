Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1F2D3ABA3D
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 19:05:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230457AbhFQRHr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 13:07:47 -0400
Received: from mail-bn8nam11on2078.outbound.protection.outlook.com ([40.107.236.78]:15392
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231630AbhFQRHf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Jun 2021 13:07:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UYjLs2eB6zwclBlnhngmd6raRKTYdX6NcvYYpecR7rK3yhIUmHsOj+syAc7jRhUw2dOlJRVTKC3okC+RDxQGJuwnyBjnsS8Agcnm0r+U0ImnBGVqRtasnRlIA1cFJT5YakY3EADyiLk+fiJSBKewReJHe9fJGuVyNSRC3qDIQFCitFaFi7U344WX9ODVsxy7Cuyxsga2WQZMfWzyI88C62+3cdaj8Jtvdza0GKB0Qc2Lq6LJcswr92epo/ke05DbGgPa+OMiH7MTNtO9NvnrKetVolBe+xfZ4GCWulGc/8UrxRSbIIDvpuuM4q3WU8ugcGjfXNWpLD1VfGZNlwTzew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+dT5gHbta4Hau03EVDF7CHy3gGSjj3e/OpJQ4TaS38o=;
 b=IZlQyOvKbvW5axVbLSnJM8wMRF/PaPOiKVUsm4OdMohvQepOXdz8Fluc8bEosw4TzpbDq9hSjLm7tiHBVBunIfzROk8mG4ibUISHxJ94O+5dVLxePx7UZZ/DwDFoVooEpc9gYEvcmNUneWSSWjRNGyccEbu5WLvSA5vGKss1Z6PAfw2EjGrAs9R/F/ERvGb04d7SGxlGuLlR6ggNrN+p7foIYp+Mkni4EYojpuAvq/Z0pNAf93hV3Cb0/iQHGGDhmjgKRfaT8GqaYAXfaXxre1o8BT3IGR9FqMEClMI/AuGmRAJPrrj5IxiOMLRSHUsv9H1F7zCZUExVc9Bazo28Ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=thebollingers.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+dT5gHbta4Hau03EVDF7CHy3gGSjj3e/OpJQ4TaS38o=;
 b=Q6ziozFYSqVQ+ZzFUm+9qWuf0eWVpBdoeszMjH4wstVDFUyRYMXXFx49fxKQe8DQ/RwMIpj8KbWjKvXuu1LQ/xcIDecRbeNGM2oa6LhpSxPoPHz7iS5LdYRzbBa91vSpCWhjbHWRJh9wkTwH4bg80WRjKvY2mH8LbXpPF0bA4kx9RJv5/KuDg29GU3nhpyDsoCs+siTjyv+STkZ06pRkkcEqBy7aiQwrT1RaDk9gKFUrglSnx30R4YnUKmh3xvAf+zdP66dPp1vs/3LwaHdvtOwXsyA+9P/Zxh93/tRB5BsWT16lahRcY4/nR2WSLWCgh/fb6V9dA7HVsd8OR8b5Bg==
Received: from DM5PR05CA0008.namprd05.prod.outlook.com (2603:10b6:3:d4::18) by
 BY5PR12MB3667.namprd12.prod.outlook.com (2603:10b6:a03:1a2::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.24; Thu, 17 Jun
 2021 17:05:25 +0000
Received: from DM6NAM11FT015.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:d4:cafe::14) by DM5PR05CA0008.outlook.office365.com
 (2603:10b6:3:d4::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.9 via Frontend
 Transport; Thu, 17 Jun 2021 17:05:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; thebollingers.org; dkim=none (message not signed)
 header.d=none;thebollingers.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 DM6NAM11FT015.mail.protection.outlook.com (10.13.172.133) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4242.16 via Frontend Transport; Thu, 17 Jun 2021 17:05:25 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 17 Jun
 2021 17:05:25 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 17 Jun 2021 10:05:23 -0700
From:   Moshe Shemesh <moshe@nvidia.com>
To:     Michal Kubecek <mkubecek@suse.cz>, Andrew Lunn <andrew@lunn.ch>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Don Bollinger <don@thebollingers.org>, <netdev@vger.kernel.org>
CC:     Vladyslav Tarasiuk <vladyslavt@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>
Subject: [PATCH ethtool v4 4/4] ethtool: Update manpages to reflect changes to getmodule (-m) command
Date:   Thu, 17 Jun 2021 20:05:04 +0300
Message-ID: <1623949504-51291-5-git-send-email-moshe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1623949504-51291-1-git-send-email-moshe@nvidia.com>
References: <1623949504-51291-1-git-send-email-moshe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b8dec889-420b-4d7c-f0d2-08d931b219de
X-MS-TrafficTypeDiagnostic: BY5PR12MB3667:
X-Microsoft-Antispam-PRVS: <BY5PR12MB3667ADFCBCD46D9D287F1D19D40E9@BY5PR12MB3667.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5ak+NBQ7kGpHBHWKS8tslHC4MtOZ9W3LuXvV1TcIQSbEOc7T4IiXmPgngP3lN2dkJHnZ/vH68ot9MhCB7VA1fOh9J72Eaxw9oQEpFmYiUUoaPBfwgMHcHtEPvanfXuTtmRq6Kfux93ZUSLHZ5WbzhNR8NPO5V4idERe9TigGZUsaCLB0OLl9LIsxgGb4BLTe3efDJge4zqg8nQm/IeV61ML9whbJdVLLGB20++MoJ5qE2l6UHZfJj9vPf6TEl7Tb3g2eiXKN28siLT9RuCuNuT+/TFt4btRoB1B40MC1UeDcQzFpiozEf1sF17BSNmfUceBHb8nH8Urc/5WoM8UOlJ6jDrosxLZsSlrK3tQ5HPNbb/6NDYJBotFcXBhuN3Hf3L39w9wgGYJOlBW1Is6aUqutWC2rF0uG9Z93KRynEgXOv2K/PNazgMg5CqETO88DXCvXx+jX+lzPO3Xa/Mc7oltwHOkpkA2pWCPKVmtKadhJkx3Q86U/WuDuGgFDXiRMAWDRHU2GwHbZx18uOz+CWVtqR2D70HZyEjTLTi70NUNbTVxKSKsFMxlEG1PTovE+YsVWEXZlzjbHSHtoXV6Gflef4yaU6M+LQZlgGgq7AHbLBvDgkVBAZJ7Eg0lKJ2GjGpyUi3ygpq7FVn29UqbCUg==
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(39860400002)(136003)(376002)(346002)(46966006)(36840700001)(336012)(36860700001)(2906002)(2616005)(426003)(7636003)(47076005)(82740400003)(7696005)(26005)(186003)(82310400003)(5660300002)(8676002)(54906003)(70206006)(70586007)(36906005)(83380400001)(110136005)(478600001)(6666004)(316002)(356005)(36756003)(86362001)(107886003)(15650500001)(4326008)(8936002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2021 17:05:25.6007
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b8dec889-420b-4d7c-f0d2-08d931b219de
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT015.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3667
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladyslav Tarasiuk <vladyslavt@nvidia.com>

Add page, bank and i2c parameters and mention change in offset and
length treatment if either one of new parameters is specified by the
user.

Signed-off-by: Vladyslav Tarasiuk <vladyslavt@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
---
 ethtool.8.in | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/ethtool.8.in b/ethtool.8.in
index 5afde0d..115322a 100644
--- a/ethtool.8.in
+++ b/ethtool.8.in
@@ -365,6 +365,9 @@ ethtool \- query or control network driver and hardware settings
 .B2 hex on off
 .BN offset
 .BN length
+.BN page
+.BN bank
+.BN i2c
 .HP
 .B ethtool \-\-show\-priv\-flags
 .I devname
@@ -1173,6 +1176,17 @@ Changes the number of multi-purpose channels.
 Retrieves and if possible decodes the EEPROM from plugin modules, e.g SFP+, QSFP.
 If the driver and module support it, the optical diagnostic information is also
 read and decoded.
+When either one of
+.I page,
+.I bank
+or
+.I i2c
+parameters is specified, dumps only of a single page or its portion is
+allowed. In such a case
+.I offset
+and
+.I length
+parameters are treated relatively to EEPROM page boundaries.
 .TP
 .B \-\-show\-priv\-flags
 Queries the specified network device for its private flags.  The
-- 
1.8.2.3

