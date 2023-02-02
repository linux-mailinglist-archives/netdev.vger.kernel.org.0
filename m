Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F890687301
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 02:30:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230000AbjBBBa0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 20:30:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbjBBBaY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 20:30:24 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2068.outbound.protection.outlook.com [40.107.94.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B2F46ACAE
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 17:30:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dhQwXD0HfRbXfgbWwG85jHK1AFVH4HmqdpbBM0kHecaH7g5wfYHYkGEOApIwB2Ha9NSCpZSLlg75ijqowhn7JidrRrerOGy+ap3B1Z2ZARhpBkD10tPPyy6ofu/lY4Jaxl3tPDsEVD8s6zRmX0MNKT+mIe/HQI91sumwLq1o2pBE8k8JoTF5Amsg9BXFjeaBIJ61zs595MuhUEnDPnnnT9gqTDD9qmMTdcHew0jPTkf92HAZttPcS+Jz60RbxgUSaUSRn8n0rfCFnUWsbPYpDP/Y88MGYJfCSw4LnzU0UyaFuvpwSzgpHEKw9WZ+ri6c6is9jmZrWRBjgVC995X12w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0YhHPuua5FecNrau8m37ws6KC2MUCtFPFvbqOtuiaxQ=;
 b=GCfIXXvmsl8ao/UJ1H9qK7CZWLguYb2DtZx5AiBS2TwwdyjUji7ESFmRchJ1KsUW4JWvr00+9T4/Q1rDJlHScuk9s9VAcOdWyLrUttKTZRgjwTdHVk1dVavh1svbHES32kY2uKdNniYngnqh83oM/qDrgxufvJdXBTLWZDPoNZRA3NFy5m42dYKycRgaC4d+f4SLa2VsOO5rsuhovnPjGWqi0j+9GIIp/cIwrR7BBKzeHAmlb89/k5iWbIBa4JF7KTA1tCCc+PtR8Jd9ihm7m4I7WnOSrwjZnrJV9af6Lz2GvoYS4yMg4nNmkoucXr8xLBXECtAdc6zUA5NP7xrYBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0YhHPuua5FecNrau8m37ws6KC2MUCtFPFvbqOtuiaxQ=;
 b=eqizVDpPmB2Jn5w+KfQaI4QxFHxJB1axsvsmZ9rss0IO2tuRevSh2ETA4v4b0R2JaGOG8m8LZTVz2JBuApzvV9mvXIXn5cqHSq9SV81NnL94QvLKOKGD2vNvQDPrR6JiHjsmIHnWSu2msSCe6a0BgrFJhRFJaCD9jgSm4du9WM8=
Received: from CY5PR15CA0109.namprd15.prod.outlook.com (2603:10b6:930:7::14)
 by CH0PR12MB5171.namprd12.prod.outlook.com (2603:10b6:610:ba::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38; Thu, 2 Feb
 2023 01:30:21 +0000
Received: from CY4PEPF0000C966.namprd02.prod.outlook.com
 (2603:10b6:930:7:cafe::54) by CY5PR15CA0109.outlook.office365.com
 (2603:10b6:930:7::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.25 via Frontend
 Transport; Thu, 2 Feb 2023 01:30:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000C966.mail.protection.outlook.com (10.167.241.70) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6064.17 via Frontend Transport; Thu, 2 Feb 2023 01:30:21 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 1 Feb
 2023 19:30:18 -0600
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, Shannon Nelson <shannon.nelson@amd.com>
Subject: [PATCH net 0/6] ionic: code maintenance
Date:   Wed, 1 Feb 2023 17:29:56 -0800
Message-ID: <20230202013002.34358-1-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000C966:EE_|CH0PR12MB5171:EE_
X-MS-Office365-Filtering-Correlation-Id: 597b18ff-4d43-4565-e5a5-08db04bd0cfe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 485CgKQccQ2GDCW0I/NmTiYVdiU9qYWjXXvvh6wHoY5QeRS5uDRQ08ChhrPRno+/hYtdZ9nJ+fP7UM3leG5eKOk1Tw384/EsNbkvn+H1Y6/M/+yF/2Zh0fk/o+tFUvgexhfoL/970lknAq2YNkH8a1aQaxZqGawuhFfH/UcqbjBb5cvs8J0b/KXKCkWv/mpiFf+Zlw/CCpbLbROtx7EbJeFwShqNmQJaSkCXgv7YfXIJRDe09tZcdb4U7PT7r/4+Z4VT8PV6bXIwFixFHmMLGkSovNhBEqSFLQt/v8cU5b6G6eWojLgRe9Pa9FZoruhbBcu5M2JDWQPpK3rXz7khnSaEiw85KK1lsc7QouMODF1obFZ+xsYef9BomreUB41FdEODXPwix1DjK9DBxtPn8uU5MFmtYm9IyBGl0w+ZWhpFWvVURDiW4zM9E7vBqjk3lrBXWUmsxVQIxvQTjtTMdRSa/arERHsFlHHqpfDrU8Naq65c4NTf91RvAjdN3zfnBjh4xM4jAdHUTH+5YE+Dx1okKteIk2s7Y3aehXchDTtuA8RsUJ+gp0RFKxLwj/HmcH5p9oXDbQ0EOIlty+phr/ptpK4azHfisP5S9ttiAI6Zs9H74h0p3R/Gr2XDykhvXjoDVMJ6reXYqNItpk1ETDUt+I4pyvkFp78HJvbgEV5DiZ/rX9ICWxvN65ZnWQXZbDAKY6aTX4owb32Mowug22a/0G+qiQZh2Qukca1WUb8=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(346002)(396003)(136003)(39860400002)(376002)(451199018)(36840700001)(40470700004)(46966006)(36756003)(86362001)(70206006)(40460700003)(426003)(316002)(82310400005)(83380400001)(336012)(47076005)(110136005)(54906003)(1076003)(5660300002)(6666004)(478600001)(26005)(2616005)(16526019)(186003)(8936002)(4744005)(44832011)(356005)(81166007)(82740400003)(8676002)(70586007)(40480700001)(41300700001)(2906002)(4326008)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2023 01:30:21.5324
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 597b18ff-4d43-4565-e5a5-08db04bd0cfe
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000C966.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5171
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These are a few fixes for a hardware bug, a couple of sw bugs,
and a little code cleanup.

Allen Hubbe (1):
  ionic: missed doorbell workaround

Neel Patel (1):
  ionic: clean interrupt before enabling queue to avoid credit race

Shannon Nelson (4):
  ionic: remove unnecessary indirection
  ionic: remove unnecessary void casts
  ionic: add check for NULL t/rxqcqs in reconfig
  ionic: clear up notifyq alloc commentary

 .../ethernet/pensando/ionic/ionic_bus_pci.c   |  4 +-
 .../net/ethernet/pensando/ionic/ionic_dev.c   |  9 +-
 .../net/ethernet/pensando/ionic/ionic_dev.h   | 12 +++
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 99 ++++++++++++++++---
 .../net/ethernet/pensando/ionic/ionic_lif.h   |  2 +
 .../net/ethernet/pensando/ionic/ionic_main.c  | 33 ++++++-
 .../net/ethernet/pensando/ionic/ionic_phc.c   |  2 +-
 .../ethernet/pensando/ionic/ionic_rx_filter.c |  4 +-
 .../net/ethernet/pensando/ionic/ionic_txrx.c  | 87 +++++++++++++++-
 9 files changed, 228 insertions(+), 24 deletions(-)

-- 
2.17.1

