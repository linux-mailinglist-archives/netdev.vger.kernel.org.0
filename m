Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0EB6692C44
	for <lists+netdev@lfdr.de>; Sat, 11 Feb 2023 01:50:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbjBKAuk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 19:50:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbjBKAuj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 19:50:39 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on20623.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8a::623])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65572795C7
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 16:50:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m+qPv0dO4tFoiHCW6CcoBd2MlpEjjegkcOvrAm9DH0+EN0w+6Du85g7EbShUtOrJKTEnDzZLlxdeMfXIhA6Bk+edjRnEedm9ctkP4749XC51T+Igjj++K5PvwRvSrY49M/tPTt+hsJb3PS3OYzWJvgTbDFPUXfuk2XKObbUTmqIpd7mFe4z+yBaKhKwhamJkbuqgUrSlafFem7wTnIQt4a6/QCUY1VefJhB1OYq/+0A4kP2C4jGzyZeVNX2FC1l3k6MVY1WABJ6VzHmOpIxkx+57BPS3eqLhqTW12T2o64F8IRIEsM7pPFaIMCQ2fatYNoFn7v2jDq3b8OkfYRCDnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t5mE4P5EARWyQ1uZL5okG1E5l2LuAe470KDQ4dxy+Ac=;
 b=IoQQ8r8zHkuoxxZD1oZjQULr2MNAndSZR47227vYW2E2XKXA/jWxwy0Jv5afNgL4hWl2hyFaEyuzLvXqVkR/MCHOOlIlmllrS6cKD2x/QSKDAXeqjPUhBIZnE0uJbh5p9IttpCPC3dX/SAMKiWNw0jEH9PXjtzQ1kL5YiXKrLYV+KiZpUzbRmOKTb/1NeD2hUDgu+NumvCynRc76mT85C3eN9PyfDliJI9pBjy2bjjUsBHI/K3fPgs54xFYs5QsvZW1CH15OVDGt/OedpOeZ5W1A1uMoEYb/alcJX3tYU4ucQG9HcxsbbCKQcbzJXcgJ2bv63dfIA9pDsHyc55j85w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t5mE4P5EARWyQ1uZL5okG1E5l2LuAe470KDQ4dxy+Ac=;
 b=OQitn+N7NXMn2ZUaARAqH0+KQbFIX76jXNPZMQzWtpIrQl2XAArpjnLXnLqKfR/JuP5H2v+1ab/CxUf15ppC1RnHakkhZrMy5sCyuSzcgexEARa2OfSIIrXQWyfblJ9+8dUQua2UpTdIS4M+LOUtt5mbOy461yxuLli7jmToMDs=
Received: from CY5PR19CA0061.namprd19.prod.outlook.com (2603:10b6:930:69::7)
 by CY8PR12MB7196.namprd12.prod.outlook.com (2603:10b6:930:58::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Sat, 11 Feb
 2023 00:50:34 +0000
Received: from CY4PEPF0000C968.namprd02.prod.outlook.com
 (2603:10b6:930:69:cafe::40) by CY5PR19CA0061.outlook.office365.com
 (2603:10b6:930:69::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.21 via Frontend
 Transport; Sat, 11 Feb 2023 00:50:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000C968.mail.protection.outlook.com (10.167.241.72) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6086.16 via Frontend Transport; Sat, 11 Feb 2023 00:50:34 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 10 Feb
 2023 18:50:32 -0600
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, Shannon Nelson <shannon.nelson@amd.com>
Subject: [PATCH v4 net-next 0/4] ionic: on-chip descriptors
Date:   Fri, 10 Feb 2023 16:50:13 -0800
Message-ID: <20230211005017.48134-1-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000C968:EE_|CY8PR12MB7196:EE_
X-MS-Office365-Filtering-Correlation-Id: 969cef5f-05ad-46b8-a51c-08db0bc9fbb2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: t3XC8gTJL8ZydrUs3NZgfhsXABTIotQYzNlHrDtvk4n18XKEszIRHuQZZF31MJArOqNDL5dmRqlKD8529VF4PkjHslIh7kl0TJEJXIj8qWTnOZhlWVJmMJBovXNX57v6TiQNT8k3XAxqe/Q75iRVYVYSQi1IjD3R2XgqT9jNzeUgg0DJt/FWd8o4CNFN8wdWikffAEAG4bwhyENQm7T38Y7rXePz53ktCZ86ZkpvxmXQ9uXk9UB8nzPsnK0JITTUQO53O+PaZ0euV28uuhidm+T1534YZTcdoRwTieyVm3F9vL6Fp4krI6F1nElazhNGQUV8L5WaajzSg9S84AV6sWpfGUADTXmFBvhehag4fLOJbRw4FF44uf9DD3nBSgqDuSDY/9m4AMlybNTyjUaYP+vGaeIqGNP1KfqDtcJGACO8x8Sxl7bk4mnvmVmRdN0vHFV6d6JrIYmZNyHlTzQUgWzEdfbk2cdNXAnJt5W2vOtv+dWDr7TA2IAwtEop9oSZyi3fJyt7CB3SFIKEXiYlhv9HBK3iGfqPkJWj+uWnZs1+iRtv39ojzR/oiE5rWr3mCh+/hcABcgqUu5TW/a04MSrqAUCAJbOZLykN1f5npMxcQQMmkTbG0pM7X9kgXamslvIEw2LxlZUgLqQi21BXDi4Vw1yiAZ/62oUZ0sZbZdHrBdzt/EGAgx2QJ+mOP1B9BFGy13m3iZRG7VeA8NZKa3SweIMKlzjUPUr83v1Mg6o=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(136003)(39860400002)(376002)(346002)(396003)(451199018)(40470700004)(36840700001)(46966006)(47076005)(2906002)(82310400005)(44832011)(8936002)(36756003)(5660300002)(41300700001)(40460700003)(83380400001)(426003)(336012)(36860700001)(70586007)(2616005)(70206006)(4326008)(110136005)(186003)(16526019)(356005)(54906003)(81166007)(26005)(1076003)(40480700001)(82740400003)(8676002)(478600001)(86362001)(316002)(6666004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2023 00:50:34.1084
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 969cef5f-05ad-46b8-a51c-08db0bc9fbb2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000C968.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7196
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We start with a couple of house-keeping patches that were originally
presented for 'net', then we add support for on-chip descriptor rings
for tx-push, as well as adding support for rx-push.

I have a patch for the ethtool userland utility that I can send out
once this has been accepted.

v4: added rx-push attributes to ethtool netlink
    converted CMB feature from using a priv-flag to using ethtool tx/rx-push

v3: edited commit message to describe interface-down limitation
    added warn msg if cmb_inuse alloc fails
    removed unnecessary clearing of phy_cmb_pages and cmb_npages
    changed cmb_rings_toggle to use cmb_inuse
    removed unrelated pci_set_drvdata()
    removed unnecessary (u32) cast
    added static inline func for writing CMB descriptors

v2: dropped the rx buffers patch

Shannon Nelson (4):
  ionic: remove unnecessary indirection
  ionic: remove unnecessary void casts
  net: ethtool: extend ringparam set/get APIs for rx_push
  ionic: add tx/rx-push support with device Component Memory Buffers

 Documentation/networking/ethtool-netlink.rst  |   6 +-
 .../ethernet/pensando/ionic/ionic_bus_pci.c   |   6 +-
 .../net/ethernet/pensando/ionic/ionic_dev.c   |  67 +++++++
 .../net/ethernet/pensando/ionic/ionic_dev.h   |  13 ++
 .../ethernet/pensando/ionic/ionic_ethtool.c   | 117 ++++++++++++-
 .../net/ethernet/pensando/ionic/ionic_if.h    |   3 +-
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 165 ++++++++++++++++--
 .../net/ethernet/pensando/ionic/ionic_lif.h   |  40 ++++-
 .../net/ethernet/pensando/ionic/ionic_main.c  |   4 +-
 .../net/ethernet/pensando/ionic/ionic_phc.c   |   2 +-
 .../ethernet/pensando/ionic/ionic_rx_filter.c |   4 +-
 .../net/ethernet/pensando/ionic/ionic_txrx.c  |  22 ++-
 include/linux/ethtool.h                       |   4 +
 include/uapi/linux/ethtool_netlink.h          |   1 +
 net/ethtool/netlink.h                         |   2 +-
 net/ethtool/rings.c                           |  17 +-
 16 files changed, 438 insertions(+), 35 deletions(-)

-- 
2.17.1

