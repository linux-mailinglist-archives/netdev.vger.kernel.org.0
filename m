Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B80362B407
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 08:35:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233092AbiKPHfV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 02:35:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233104AbiKPHe4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 02:34:56 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2052.outbound.protection.outlook.com [40.107.94.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCB62F7
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 23:33:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HlBLZbRM5AWldk7tmSWoM/Itazl4kzc85GhGd89sLNyLQSygXAt4zPi+QPdylGS7yW6eGxX62hS+bmLEIMEziI3CvQqXpur1oYeQaXD+SoKaRz5u6zGu+H4IBLUMBXiETSd31G5Y0mA/OLSfSLBZX8ciaH/P/8ac4k/AnvJNpt/jgbPbDA6yLBw581tI3tYwE4awVm6lCrI+PSTxfZ+B+gr6O6KSEZnOU2s+my2arRqYWZo/9lHpKPfm2lWTiqIslQ1T9spDJlQpKpSbm1bl8kP4unpr/C4OMIhc8cNDrVNcz1nAH6nbJeeayN2CUNfyDNZhfl+wNO3ZwNPUv0yRCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=11LkzNdyLnR3ZTFNKATVgoiJvDRCAIS+zkz044sn3wA=;
 b=l9Xxj13pT6/mAPpymnpa2AzwM9oxLCCOprPzLPOHPM3t+XtkPGAQqEhvJeGeD5/Y9irpXJNdZ37N0quHtH+4+BIsf81asv9dY6L0FHNd18+RVkXAzqsHGHERypxpxJTjXK6nVDA23n2K0WnutRgV+tTt3LcLhTy2Cnt+01iYk8Tq+tQ3TZh/G6EgkBblPSg5imEWbgMxzpyU3OMh3oi4WXUCBQWKpSBN64szTYiQkwer8zi8NRCB5QVNIqwkv65vir0/LCBemb00a4IVvrGR9uPZHvf7qfs7RLk7LibZyfkV4ZS35/zLEwpD4GDp5nqs6eV/gLRJpApBJOxPvsc+mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=11LkzNdyLnR3ZTFNKATVgoiJvDRCAIS+zkz044sn3wA=;
 b=bXEPnXx1I6/psID2BQJRizHPv/Qj+QdCbVm2KLozEr1zDwrDhXvW4wEr1ZFs8bmlG+FNF45V7ZA7m+IUZ8+DXxM7x6sJn2j8vweIS9rcwSoaAldZqJg7REtRPpWFi3kqRFr/opu0c2E7fOdKFNozy4JIC49zfjYsBJnz+SbLND2X9yNrARgx9zPbuDo0Bgjq43s5A4p0LDw7FlyPa/rhKtsYNwW7mz4WdD97/B/qu94xZYFPCNn5/aw3E/DGANGjr5zgOH2nhUHuC0dKv2ysK+UkN3eT/81UKzNt3NfZAXzRvVrtlVeVb4CUj9Lx83Ieyq6W7kUknZuPZ0CVhqmi5A==
Received: from BN0PR04CA0025.namprd04.prod.outlook.com (2603:10b6:408:ee::30)
 by SJ0PR12MB6831.namprd12.prod.outlook.com (2603:10b6:a03:47d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.18; Wed, 16 Nov
 2022 07:33:56 +0000
Received: from BN8NAM11FT026.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ee:cafe::8e) by BN0PR04CA0025.outlook.office365.com
 (2603:10b6:408:ee::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17 via Frontend
 Transport; Wed, 16 Nov 2022 07:33:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BN8NAM11FT026.mail.protection.outlook.com (10.13.177.51) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5834.8 via Frontend Transport; Wed, 16 Nov 2022 07:33:55 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 15 Nov
 2022 23:33:36 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Tue, 15 Nov 2022 23:33:36 -0800
Received: from dev-r-vrt-138.mtr.labs.mlnx (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.36 via Frontend
 Transport; Tue, 15 Nov 2022 23:33:34 -0800
From:   Roi Dayan <roid@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Roi Dayan <roid@nvidia.com>, Paul Blakey <paulb@nvidia.com>,
        "Stephen Hemminger" <stephen@networkplumber.org>,
        David Ahern <dsahern@kernel.org>
Subject: [PATCH iproute2 0/2] two fixes for tc ct command
Date:   Wed, 16 Nov 2022 09:33:10 +0200
Message-ID: <20221116073312.177786-1-roid@nvidia.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT026:EE_|SJ0PR12MB6831:EE_
X-MS-Office365-Filtering-Correlation-Id: 9499a683-a935-4e7e-3f17-08dac7a4eaf9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +gW/OghvJuLmbxPl4XBGTKtfgj0A59Lg+RbKOWL2WSLH7vu3RWIgwGgecM3OgV2ErJhs8gFz8dUXjK2AXfnHqqqRfsAMCvDh0AyKc99WGVGJBKbzj9goMxeR1ZQiJ6sc9c6uEWRAHptCV5QiS9PxzidqCgPyDBqsGyoNUN2RgxuIiftRXlhgL1X7XdKIQBryGRk/uLTfDx6uj9dzzlVtzpwzu2tYXWvPb7XaryiK5wEoQonNGKcuJrZ9AaM3yxagyGw5BV+I5KHwauwGCGxRghp9OAq/kSAe1dFURuE+0Edhmmb0c4S+SlfUrrtq1+AN4evdXh+HaO6qmDzwmq+Ce+Xtxk8kMyo7W7liR1tj86ztFk5KJVg6JN7Bg9cru7Z9oDUGHGQUwAajCCGFEVww+2zPAO3R83a2ZKAIjNLMjE616BG/hJxnIyvdPtY4wJqk/+uipzJULfEqCIkCiCnDcGjCF61dGv0+pNZmd3BGrGJLvNYV7toIXX8D4KjmRUTr5Xe2t3elp2LZDrUm20ATQvICqkxPUBl7J0Fg6XV2mRgaLHmTDONvfXyzt0yjHh5DkOVTk4bU95A5IWWKaSLfiysOTOMb8pJ90hkfXiLypxEPA+TvDWG2wH9KCyGH/B2snixobsaTVwsVte5VnmjH5xjzyZlJqz8JLrHMLErLeepLdNM3uA9ETCgvPsK4Xn/pzVq5uWTRQonW4Pn8rUJ3xk0FbBsuvqN++MhOGgp4nhWqeI4Tfh1UxVpaRI6mgb7sSMSBNaIcq9qXwahbJsn2gg==
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(396003)(39860400002)(346002)(451199015)(40470700004)(36840700001)(46966006)(26005)(316002)(6916009)(2616005)(8936002)(36756003)(8676002)(40460700003)(70206006)(41300700001)(70586007)(4326008)(54906003)(86362001)(40480700001)(2906002)(82740400003)(1076003)(5660300002)(7636003)(186003)(356005)(336012)(4744005)(426003)(36860700001)(83380400001)(47076005)(82310400005)(478600001)(6666004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2022 07:33:55.5082
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9499a683-a935-4e7e-3f17-08dac7a4eaf9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT026.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6831
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The first first is that ct commit nat src/dst should accept
the command even without an address and the driver fills
the address from the tuple.
The second commit fixes a segmentaion fault reading invalid
argv pointer which is passing the available args passed by
the user.

Thanks,
Roi


Roi Dayan (2):
  tc: ct: Fix ct commit nat forcing addr
  tc: ct: Fix invalid pointer derefence

 man/man8/tc-ct.8 | 2 +-
 tc/m_ct.c        | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

-- 
2.38.0

