Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26C1E63B6F8
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 02:18:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233590AbiK2BSc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 20:18:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232141AbiK2BSa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 20:18:30 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2060.outbound.protection.outlook.com [40.107.94.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0989931EE1
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 17:18:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qzh7M1HPBwr1C9zY1J8Z8fLUUkTjLHBcrkiMxEOeKFfF5p9Dyao0G+h+HvmWJ8QQDN6rd36QMaIVPqSzhxu8pwe3A5qz3+JM8990af68w3zGW+ENmbGQdzxjg+1O0kTyC8UigB5f6OJwJ6wMESUEgPOUswqzLvZI8tN6HGGEiU+32kuP5olyakXzmoiUNhpDyqCS2vLxgQfaT1jqqSNen11EsQUSlAg0euCuaw5PyIVzpP47rJpfwRFiRCd2E8Es+ZxL28Ur+lef+Y2B8CEaidbChuBnO4fYZNISobKm4mTaRDSuMQyFuq/vQL8Fv5YjO6r44OB68YTDepkuRvpnmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z33y2SesL48AHu/t1kI4GU/dKqVdRzBN4I1yUtp5+mM=;
 b=FMxSHE0nwruDfBXPJ/XgO7L3Z1r+abbGl/h1N8HyKAmuppFfq+rN+56rCP1nG0kQuRc/CwF9zoKAjQ3hgwJIB9ucMriLTF3x/Eew/nbt94kGzGEtAb1Z6F6iwuK98PZswK1l6piTGI2Ie2lsNI8AHq4ixVw6xShozPCG38/ctB3LvKaYwAj0khy4IVXbVNE7SFmRCRqjE6XxIJbkK70TgJ+4i9Y0EwW1uP1T08vBrB1hpBmnv6IhC8BfSb1HN76JUWjGEBaVKfIjkXLJoe1kYrxrDft/xsHx4xPDYXEbu+hvdL4qYQdjO3OynOwbcwtr5HQDZxYxCp67+uOQ92oyBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z33y2SesL48AHu/t1kI4GU/dKqVdRzBN4I1yUtp5+mM=;
 b=OS1JVcgsU1g+57fzJfpDddHPumZvvsNYY4By9j52hCHi9D3EbammkLDXwv/T0qBsJMKtUwYYMLZjcoZNlPu6dxSHDa1TEYH8dMHqxlIlGnWXzc9i9B4OsQzSpgL7+Rp4C58OJEjMW9C6mu7+iPNQGpdYCXhrFRRTckLjpujpGIA=
Received: from BN0PR07CA0007.namprd07.prod.outlook.com (2603:10b6:408:141::24)
 by MN0PR12MB6342.namprd12.prod.outlook.com (2603:10b6:208:3c1::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.21; Tue, 29 Nov
 2022 01:18:28 +0000
Received: from BL02EPF0000EE3E.namprd05.prod.outlook.com
 (2603:10b6:408:141:cafe::e2) by BN0PR07CA0007.outlook.office365.com
 (2603:10b6:408:141::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23 via Frontend
 Transport; Tue, 29 Nov 2022 01:18:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF0000EE3E.mail.protection.outlook.com (10.167.241.135) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5857.17 via Frontend Transport; Tue, 29 Nov 2022 01:18:28 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 28 Nov
 2022 19:18:25 -0600
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <shannon.nelson@amd.com>, <brett.creeley@amd.com>,
        <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <drivers@pensando.io>
Subject: [PATCH v2 net] ionic: update MAINTAINERS entry
Date:   Mon, 28 Nov 2022 17:17:34 -0800
Message-ID: <20221129011734.20849-1-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0000EE3E:EE_|MN0PR12MB6342:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f96c0b9-f050-4816-5483-08dad1a79ef2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CAVK4oCWYI9uhVMQWGavAbDefeIYXPDT3DBwYiuQuvcVr7TZqG1DzWtrfYj42b857f+nuJhh0voqXAhGe/l70jPpfEuqKTc3ZUT5cXAANb3qWdbtWEOCth5Vff+sjefbqNgTv5gwz2hbZIvQcnZQRwrw0fejOffLtJKF4P81DstHAWqOn04xLmK8AEElp13QpCLwImOJrmAVtaL7IN1+piBiuNK9OytrYTo6r9j5FyY/TBGE8EdN19jrsKDK7hSCkyeWgc656636MPBxj1gkyT0QVlw/ANlqIDhKyOMwo5sWzz2H5Jl+DPG+JE1C2WlB3plHkucDlWOcttbn7cAuKCRmSKpzVWzzuRzBuhw4yVnvK/JrUD1G73r0LcswNa9zVvCYSbmonySc/f801iYzFSezruup5rNOB9zhpKwOjHLd4MmbXv3at2nJhEcPF7xQZuDuO8F1cOLnQiIcB//DOsBZaX5n7frV7EbSrQh1/g2Pq3ZzDRG+lThxlWOKTWDYsfq8+geTIqerP7B/YXFOpc4dc4HpJYvPj2Hc7CM37q3BgFet+m4k3Pvjj/Ln53iseWmHy+cI2eCeLdDxgrvVoarhwnwNwvzBKsZGb20IjapZhSY2Gupd2G13Y2aDs3YeSk4Rsi85ljx5s6giVMwRx4GkevnqSHmvHj/WCPZnl/vYU0kpmfTJj0E6GOUsaisZiqzjqikk3A8Vx8FpftEmqxmVhBPR2WSu1n22p15eccI=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(396003)(39860400002)(136003)(451199015)(46966006)(36840700001)(40470700004)(478600001)(82740400003)(36860700001)(356005)(70206006)(40480700001)(6666004)(70586007)(8676002)(82310400005)(2906002)(4326008)(81166007)(15650500001)(83380400001)(8936002)(426003)(36756003)(44832011)(5660300002)(336012)(110136005)(26005)(1076003)(316002)(86362001)(16526019)(186003)(40460700003)(47076005)(41300700001)(2616005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 01:18:28.2302
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f96c0b9-f050-4816-5483-08dad1a79ef2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF0000EE3E.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6342
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that Pensando is a part of AMD we need to update
a couple of addresses.  We're keeping the mailing list
address for the moment, but that will likely change in
the near future.

Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
Signed-off-by: Brett Creeley <brett.creeley@amd.com>

---

v2: added .mailmap entry

---
 .mailmap    | 1 +
 MAINTAINERS | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/.mailmap b/.mailmap
index fdd7989492fc..c12809090d76 100644
--- a/.mailmap
+++ b/.mailmap
@@ -389,6 +389,7 @@ Sebastian Reichel <sre@kernel.org> <sebastian.reichel@collabora.co.uk>
 Sebastian Reichel <sre@kernel.org> <sre@debian.org>
 Sedat Dilek <sedat.dilek@gmail.com> <sedat.dilek@credativ.de>
 Seth Forshee <sforshee@kernel.org> <seth.forshee@canonical.com>
+Shannon Nelson <shannon.nelson@amd.com> <snelson@pensando.io>
 Shiraz Hashim <shiraz.linux.kernel@gmail.com> <shiraz.hashim@st.com>
 Shuah Khan <shuah@kernel.org> <shuahkhan@gmail.com>
 Shuah Khan <shuah@kernel.org> <shuah.khan@hp.com>
diff --git a/MAINTAINERS b/MAINTAINERS
index 256f03904987..44f33c6cddc8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16139,7 +16139,8 @@ F:	include/linux/peci-cpu.h
 F:	include/linux/peci.h
 
 PENSANDO ETHERNET DRIVERS
-M:	Shannon Nelson <snelson@pensando.io>
+M:	Shannon Nelson <shannon.nelson@amd.com>
+M:	Brett Creeley <brett.creeley@amd.com>
 M:	drivers@pensando.io
 L:	netdev@vger.kernel.org
 S:	Supported
-- 
2.17.1

