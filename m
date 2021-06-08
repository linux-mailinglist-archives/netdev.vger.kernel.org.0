Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9142E39F3A3
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 12:34:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbhFHKgS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 06:36:18 -0400
Received: from mail-bn8nam12on2053.outbound.protection.outlook.com ([40.107.237.53]:58721
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231438AbhFHKgP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Jun 2021 06:36:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S2769JIfyL8rKi54iaYHrQpsBpX1bvU2iGLRLJeFi5md2JUg6XrBIzcIAS6MlMFW9WDgoGqOTK/nYEYk5hjI1rFqKpS6wBKiYYovTrLt1ABCCWXeqhaHmPJUPUv9aes5M4wAWw5Sa0K+DRr4wEMpG1oQpE/okj0DqGxOOWdkW5js3e8r+y+VhvwcqF+QZP9tAYoh5ARmJ7h9TxCGUjyzZ9avXYARu/FYPV18PDfjE2cAlWDUuq4RO9MInYgQ9H/BgNctvF4zSmhAfSjtpBu0C5P2CDaEU/9Vz4b4AcmE5PC3uZdLWus6RWXCmBQ9FODes4PVFjmjuLprtOp7X/dZGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+dT5gHbta4Hau03EVDF7CHy3gGSjj3e/OpJQ4TaS38o=;
 b=Bh3KpbuNciG85tITpjApr09+U57o7tAjZPIdNqBaz1T0YGB2XGE6QOcd7tMATOT0A4+oZjQWAWzR8FpkAn+GqJxuUqdhBSZtnBUpraQxz3mx+K5lQd53R5EopwAIxgxrqN7/leekFjy3nWx3p33SSY5HhozUS/glC+2FqAVA4YnCSZ0YR7t38coDVAT6dzxiwQotz4YnSpTf1BpHrNHogw6EF+DXGI/U42feALScZQVKHda7l905TKPP+LeK6FVtBjK0YOHlN/es8iBXCyVbuISAMgCjWKEqCULPWPZdWZ8UNvKpqgQZdI0XNy9cYjAVGdsAEmop3UX+LGRvulQZfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=thebollingers.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+dT5gHbta4Hau03EVDF7CHy3gGSjj3e/OpJQ4TaS38o=;
 b=X92JMmUvwRpFxyMqk2IvryZs51ONck57BfJ8wvN6m4W6tzFR9sx1rDj8p4NeIe02pjoXVN7xH3EkCjcCemj3c6U+OpWvhY9alVjp7wzNlID3cSJ1Y4WkbeOMiCy0dG6TOTh/R73P8GdO3Fk6ejS6RYRMQUDwWYRMhXPTrdvHzi5UZnkOyz9KUO0x7Hq2UW/ypbCPd+fL6zjfnDN7ODpkAkiY2DJObHXeuF7eRmd99iw94dyxiJaV9XG2mecp8jrbWEwpnZG8ZP+uI8P3DjgCWA+WX5k3O6sZgevySkPVoZ4wW9k+HsIe8j2L3LkWa+ehiq0f7AgZ29KITlEqZQauUQ==
Received: from DM5PR07CA0138.namprd07.prod.outlook.com (2603:10b6:3:13e::28)
 by DM8PR12MB5400.namprd12.prod.outlook.com (2603:10b6:8:3b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.24; Tue, 8 Jun
 2021 10:34:21 +0000
Received: from DM6NAM11FT068.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:13e:cafe::4) by DM5PR07CA0138.outlook.office365.com
 (2603:10b6:3:13e::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.23 via Frontend
 Transport; Tue, 8 Jun 2021 10:34:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; thebollingers.org; dkim=none (message not signed)
 header.d=none;thebollingers.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 DM6NAM11FT068.mail.protection.outlook.com (10.13.173.67) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4195.22 via Frontend Transport; Tue, 8 Jun 2021 10:34:21 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 8 Jun
 2021 03:34:20 -0700
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 8 Jun 2021 10:34:16 +0000
From:   Moshe Shemesh <moshe@nvidia.com>
To:     Michal Kubecek <mkubecek@suse.cz>, Andrew Lunn <andrew@lunn.ch>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Don Bollinger <don@thebollingers.org>, <netdev@vger.kernel.org>
CC:     Vladyslav Tarasiuk <vladyslavt@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>
Subject: [PATCH ethtool v3 4/4] ethtool: Update manpages to reflect changes to getmodule (-m) command
Date:   Tue, 8 Jun 2021 13:32:28 +0300
Message-ID: <1623148348-2033898-5-git-send-email-moshe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1623148348-2033898-1-git-send-email-moshe@nvidia.com>
References: <1623148348-2033898-1-git-send-email-moshe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ad77b8c4-3108-46e6-b7aa-08d92a68fa55
X-MS-TrafficTypeDiagnostic: DM8PR12MB5400:
X-Microsoft-Antispam-PRVS: <DM8PR12MB5400860DCE23A4BB70C02690D4379@DM8PR12MB5400.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: INHdsTN8pJWZDtjqJpoaJK3iuF/w0RUXkjNZgOs7osBG10G2DfDc+rxIA6sPK4n1/3BN0BxgkxmFjCZ8kVvJz61ww6/O5mD1FYkVqGY1i1Gkw6wsJ6YJJRPBqKzpN8dKYgIbbqxJC9ZQFUWiLgIcIgmcCUWUrZUdWn13KwqZcMYSesCXu0mp4N08teEaAJeWuUoTAJJFmSFHipAzSduUGJvFD4NtsA92sO9WI2zsxp3OFyupUD81c1Oz1azE2ONDMwUfkgUB7nDyOU+amSbvvlrBK3EWp9sSxdsfKEM3Q7rurMoka/lB6gtxzuNMZnrROYfj0Y+gP48ZpGqWxE67P4y0rX+GN32/1hXNXinwcPNIRW1ZiSwEzEzkR/RVy32vkB/gAok4j5rEaRiMBp3JZkvhQ1rdp2Wr8+ngHKEL5ZSNJnU/fVvK+vP7Cax6/K56XTeqNs9NmM11VRi09oER0dZGdS7e8O/HT9JskfS9FAeh2pv0yu6VliDHpkR0nZShBv6wRa34ube5Epm1z6QdSl55ks6xhdQa2uN34Ig0ryk+TZGu688wqt6XmoqGDk58SNyiMh+w+3jvrYYzKA+FzE/NXvdiNgvwbxodLmkYUfNBojdjyabRC9RddcLXJohPLggXaz2jKO4usJiu0pWsxg==
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(376002)(39860400002)(136003)(346002)(36840700001)(46966006)(36756003)(6666004)(5660300002)(70586007)(2906002)(86362001)(70206006)(7696005)(82740400003)(47076005)(83380400001)(356005)(336012)(316002)(4326008)(110136005)(54906003)(107886003)(36860700001)(8936002)(15650500001)(8676002)(2616005)(426003)(186003)(478600001)(26005)(7636003)(82310400003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2021 10:34:21.3519
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ad77b8c4-3108-46e6-b7aa-08d92a68fa55
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT068.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5400
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

