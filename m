Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE97C38E891
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 16:20:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233008AbhEXOVj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 10:21:39 -0400
Received: from mail-mw2nam10on2057.outbound.protection.outlook.com ([40.107.94.57]:24591
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233004AbhEXOVf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 May 2021 10:21:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ab2YQ1JWq3HW8gdddPk6ybOE7j4sp+QtCGSWrS64LKettIlgnp23bRshYVrrO7RmtRc7XkFhYOBAq0XNLZCcKCOR5YF8phPR5FtuZiUcO5O188pokxDmOp45wETMGdp1r7ZP1mVC7GNc3nWKbsshtMNxgEjMl1z7cCoDFge3IuHPadWszKO1L1hRa40CD1AfOZUxSr4/1HNqtWjNwFVVbpd3VQ8nSm8RZAGy2OgYZcSJ5NeJnsEAbmZNv6mn5U+z3QLBbe9sTZWxPrBH6DaToIBZbx0zo7Hm3vLQXQAvTG5hdiBJKOKZ6g7H7lVWdVBY28jQLim4iOBI1GJXzphsFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SIRsUFHjxvyf/j490lcYq+dX8j0+hNZfFXB50F1VcrI=;
 b=LpNMQy3BgUJ9V/lUOo/WwY1wld5CuE0rJtQnfJVF1kuJvobRlfa5UrDBXbhYJT70rY203ZwIAR4tBioHqyjrxKbNI/9kcxS8uuRhpDuHLLyPmxls0iWZPx0w6PbCyPijsq7P/YtU0QZfE9bMD3LtSdh/EHoNxHPn6FNPJqOxw5fSV995Gg7die3bGwv9QCZu9xzsvPg9bqu3NCHdHGDZ/T0+qmGIuiO2Ft7irdzIAgSlFoHanA4p2DOo6f3aWtYjYhQcvpJudtgyyA+G5w72Lw46M8VbN7qrUUN/l45jmxqVhqUZp6UV2fUSjkfzdVMoW3l9VIziZrrHsbW2m6TIgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=thebollingers.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SIRsUFHjxvyf/j490lcYq+dX8j0+hNZfFXB50F1VcrI=;
 b=XXpMVDJj3bY0ESY250YKHqclWPKHZM3UJqH21hvWPU46mMfTZSXxhQApOKU7ulSye16WDQ4s0QpZjQpzjvPmKchkn+Q4z0vOLe1DMFmGfC6bSH5/WZq/jx5C13xpDxG0qFTaf6wNuCkYdIYR9PItSvhOW4UxRDVt7SxS1MWAiFPskslq4i2ENaf3Ob/StVtTNoF/+tiwqqwVkgYFrAugvERmC2L3PG3nXLoU5LQeCgeglPR0F4mTpHSQ98DrF1ZIsyxRFZ4yZjsR5hhtGXWiZseTE+HufIZ7BA8tDIW3DzMuRLeCQFnZTGnAfdj0PYYnDJbROQMgfPA9JDB9h/hWVg==
Received: from BN9PR03CA0048.namprd03.prod.outlook.com (2603:10b6:408:fb::23)
 by BL1PR12MB5047.namprd12.prod.outlook.com (2603:10b6:208:31a::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23; Mon, 24 May
 2021 14:20:06 +0000
Received: from BN8NAM11FT049.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:fb:cafe::26) by BN9PR03CA0048.outlook.office365.com
 (2603:10b6:408:fb::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23 via Frontend
 Transport; Mon, 24 May 2021 14:20:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; thebollingers.org; dkim=none (message not signed)
 header.d=none;thebollingers.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 BN8NAM11FT049.mail.protection.outlook.com (10.13.177.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Mon, 24 May 2021 14:20:06 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 24 May
 2021 14:20:04 +0000
Received: from vdi.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 24 May 2021 14:20:03 +0000
From:   Moshe Shemesh <moshe@nvidia.com>
To:     Michal Kubecek <mkubecek@suse.cz>, Andrew Lunn <andrew@lunn.ch>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Don Bollinger <don@thebollingers.org>, <netdev@vger.kernel.org>
CC:     Vladyslav Tarasiuk <vladyslavt@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>
Subject: [PATCH ethtool v2 4/4] ethtool: Update manpages to reflect changes to getmodule (-m) command
Date:   Mon, 24 May 2021 17:19:00 +0300
Message-ID: <1621865940-287332-5-git-send-email-moshe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1621865940-287332-1-git-send-email-moshe@nvidia.com>
References: <1621865940-287332-1-git-send-email-moshe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ef59edb9-e271-4aaf-aeb7-08d91ebf0796
X-MS-TrafficTypeDiagnostic: BL1PR12MB5047:
X-Microsoft-Antispam-PRVS: <BL1PR12MB50477A93ED6457373477302BD4269@BL1PR12MB5047.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uzXSG/louNhU4g7tDHo1iE1758jwCNMAxCk2Z7ENz2/qfsk1hlVTEUmr34P8Iu24VsG/lEwY+aL/lh/aTgheCyy4vn+dpcJDOuAT0Zlehvs2cPtGjOCqC73Gr0z76Hz9mLAaEo6f/RW0wPW3R3btyULrtoMiRhPHo28yHOPBR5Y4bfqx/pSd3akbG9vh66n5Z+x8I7BQuUdaqTh0emtHuzzUKYl6s7teWSiQL8UHlIPZEdlyz+VquuOILbou2sx0W0ZIciuQFgMfRPIyZE/xwA/uREF7Z8BY3sHu4aJagMeyQ7fOptW3KZrnsv6JJtXzskbdB98BRtDBpQU+FVjRQBTPHtKjm1x6xgf9uy5EowrNk5OVI6HAifZnvDZC7OPeJHh/l41g9TcpWIOS460oawDJczOnuUYVQx6KPJDHm1qFoEGnpOJDpyjBavnI7Kszub521HzpPlGnLOgF2pYXyCDqVIkT6/xuKJeiqaIantWiQPS+6MnLNeQBlXbX7bBFapCTZ6W2SBFk7QtSVkW0dpC88SJszH2mOZNuB6WhaRWsy5/0KwoW7DNh3aQM7SV7hVHgsmGK+nU6I1zYqe5uosA5SQJqak/w82iOE+gMY79xhENkKBbWGg04yIAozQYSadDihU/nHROqHN9dOrgDKQ==
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(376002)(396003)(346002)(136003)(36840700001)(46966006)(7696005)(82310400003)(47076005)(8676002)(8936002)(83380400001)(356005)(316002)(336012)(36906005)(2616005)(86362001)(36756003)(7636003)(26005)(5660300002)(4326008)(110136005)(186003)(2906002)(426003)(70206006)(15650500001)(478600001)(107886003)(54906003)(70586007)(82740400003)(36860700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2021 14:20:06.2859
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ef59edb9-e271-4aaf-aeb7-08d91ebf0796
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT049.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5047
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
2.18.2

