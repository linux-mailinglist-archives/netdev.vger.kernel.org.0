Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42E8768C586
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 19:16:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbjBFSQv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 13:16:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbjBFSQu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 13:16:50 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2084.outbound.protection.outlook.com [40.107.244.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B04F234CA
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 10:16:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z/RYoM3yugwY2bdoHq/I0l2Bm7gksCaDFUkVhRquZygOj+OsuKfxVHQZMH+uZdarrhOfh/d5z8AuvQL5h4kH8v2U0l6AG+ivRZOA9UmfXxoBJ0ZgJfwDMPfHsCkZC+/sAzoQfE1q6tJWFPBNsl5TlL0m2/CXwNb89wEQOUvyEa55rhhK/l/xum88hdrRHwso2OtyK2sg5KgxviQpGk8H/ereQX7/MvXTrsRrWltsA2dyIjvvtuN6Hsp0raISWRv6AZiVhW9H602Zypb2iY5acqkTYMqEUJEGDJLYfmGOQ+vhNruRcqIGCuwafmxFf514IwqOiIfnmiMC0HehpXp7ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=coqb7PZhn7MRDXCN8/IxXwONr0jA/SIbwfR+iqx7m2k=;
 b=fOqqpxe2wMUtykvN7zUsHUTXk2OD5MuUaBsLtu03Lcsrhv56iHe4I4MK1T21GJCJz8dZqvLnuBq0ZAnPnGotTvzFueNmgcEq8MHvBgd/Inq896Yt99SE5HRAbZoBN9/X9mBHaqloaCltptJ061kL64bwZW2IHj/Zwn1oNYnj5gQQ2+up4jPmnyp8sDz+PQ4h03GATmtHvXnFMY1H08Jmlx/Wg24tKbKhSJu7qSJSriPZJ7XQMmMPn/F4Y2ejEKXYbftyY6GCdgTq6JlQHwf/r9eCzoTBf+tgMUgKsJkiKWP+RVJES0SJcCfLmqYV0rplBEvebuf2PE2K1Ja7iJQjfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=coqb7PZhn7MRDXCN8/IxXwONr0jA/SIbwfR+iqx7m2k=;
 b=Cc/XrJ9nx3jno90hEz9DGNmGvERRQs+mbjtIj3pBMIacTiAj1qXHUyKLgkAbPdy0Pi1kTOkRuQ2oBl5R5toC9W5vQkgUE0cXGP3GGT8z6viX4MPvogaf9Uptl3A379CM/9MNHAyKb10WvGay7Wdq1IpXr6yqcjZX2lHT/KVzz0U=
Received: from MW4PR03CA0089.namprd03.prod.outlook.com (2603:10b6:303:b6::34)
 by CH2PR12MB4200.namprd12.prod.outlook.com (2603:10b6:610:ac::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Mon, 6 Feb
 2023 18:16:45 +0000
Received: from CO1NAM11FT066.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b6:cafe::86) by MW4PR03CA0089.outlook.office365.com
 (2603:10b6:303:b6::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34 via Frontend
 Transport; Mon, 6 Feb 2023 18:16:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT066.mail.protection.outlook.com (10.13.175.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6064.34 via Frontend Transport; Mon, 6 Feb 2023 18:16:44 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 6 Feb
 2023 12:16:42 -0600
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, Shannon Nelson <shannon.nelson@amd.com>
Subject: [PATCH v2 net-next 0/3] ionic: on-chip descriptors
Date:   Mon, 6 Feb 2023 10:16:25 -0800
Message-ID: <20230206181628.73302-1-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT066:EE_|CH2PR12MB4200:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f823674-7dbb-42f2-01ee-08db086e4dc7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a+iHVSKtBgiFI/pXrrNCJGOtmfU+FkqMKmxpt981Hh1SUeaSKBvg8CkMMJ2mnlvJJWohnCGHFlaxRshFGAVdzsYhFK2EMtWZBLBXq3aXiJPbE0rQsUPTqEgfgAFA16Wrqt+GKm6nJj7KoYdgY+VkVg2zpj6idC7KUP62c7s/hRFBrUMZIaokBLLljOxVShnLAgNVAp1mIp7TPgzjEsw0ht+BAsGsRNS+eLsAnPiYiS3e1idkn9nF58lKzo6H6OYzEbGsJ3hovTKpB722TTAn1zpB7PZ3XXqFr1++Zn7QCHh9GpU786UbD//z6WkpWQoHjgQR1vkbpAd20AX41TFTRdy+eJWztrXuoAPfOLnKrj1W7i6rnz0VmR5ozNlLzHuObKzPhb52QxmN1qRtNligNQwRrV2sE8NKkz+aZD+8Kb+2ulgI8Yhq/jjLSIcyi7j/RzIMN8Kh20jAwn7q1oJf1A94GuKBRxxAa5zLvmMtZe122z3Vtdj8T6Bvz5cOCyflIkz9IuuZua5e4SSi7/fTqQdgXvRx8xZj1PNLlXtP7lsYvu1lmiYdku7yrh3SEKwe9VNJ9ct5u3XTwuGqVSoQ5biGzFZxLTC1RdH4BIXrKzSqr3BE9bT91ajHYj09A+ebpalqJwbPGgMEGNjQRtzs4lWTZ31c0Ii4/w+JQAETEX01Nw7ZbPbWAXfM0rQs3EwZZPrchpBY5UsBCjSNMBFYLFMkAKlk4PxJBRK8hNR+d4M=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(376002)(346002)(39860400002)(396003)(136003)(451199018)(40470700004)(46966006)(36840700001)(41300700001)(8936002)(47076005)(36860700001)(426003)(83380400001)(40460700003)(82740400003)(40480700001)(81166007)(70586007)(110136005)(54906003)(82310400005)(8676002)(86362001)(4326008)(70206006)(316002)(356005)(2616005)(26005)(186003)(336012)(16526019)(478600001)(36756003)(1076003)(6666004)(44832011)(5660300002)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2023 18:16:44.5963
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f823674-7dbb-42f2-01ee-08db086e4dc7
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT066.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4200
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We start with a couple of house-keeping patches that were
originally presented for 'net', then we add support for on-chip
descriptor rings.

v2: dropped the rx buffers patch

Shannon Nelson (3):
  ionic: remove unnecessary indirection
  ionic: remove unnecessary void casts
  ionic: add support for device Component Memory Buffers

 .../ethernet/pensando/ionic/ionic_bus_pci.c   |   7 +-
 .../net/ethernet/pensando/ionic/ionic_dev.c   |  71 ++++++++
 .../net/ethernet/pensando/ionic/ionic_dev.h   |  13 ++
 .../ethernet/pensando/ionic/ionic_ethtool.c   | 128 +++++++++++++-
 .../ethernet/pensando/ionic/ionic_ethtool.h   |   1 +
 .../net/ethernet/pensando/ionic/ionic_if.h    |   3 +-
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 164 ++++++++++++++++--
 .../net/ethernet/pensando/ionic/ionic_lif.h   |  32 +++-
 .../net/ethernet/pensando/ionic/ionic_main.c  |   4 +-
 .../net/ethernet/pensando/ionic/ionic_phc.c   |   2 +-
 .../ethernet/pensando/ionic/ionic_rx_filter.c |   4 +-
 .../net/ethernet/pensando/ionic/ionic_txrx.c  |  22 ++-
 12 files changed, 422 insertions(+), 29 deletions(-)

-- 
2.17.1

