Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87373516116
	for <lists+netdev@lfdr.de>; Sun,  1 May 2022 02:12:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237705AbiEAAPe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Apr 2022 20:15:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233532AbiEAAPd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Apr 2022 20:15:33 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2061.outbound.protection.outlook.com [40.107.92.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E1BB39153
        for <netdev@vger.kernel.org>; Sat, 30 Apr 2022 17:12:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L+ScsVHJsYJD8An/S70fA+SbhbZrjhiaaI+Tl53eni12CS5fjsRN8FlakapQe+g88dtBu9Jyy9Z7fM4Sa5VLfFBqnEY3wZs1IlMBWF2R9UaG1ldmG06ZKCLgAZeE0EAeU4Qff4OZqbDJFBnc6z9s+68YeTLMGrpwEomVXMxfV37k4eD2ZGP8rshiC/oN7BtsYCVUjfrYqLMhwiRAtmShp5E3RyRvij6PTO1kkwpy1c288Xl679zkzH1dMNkCp5D1oapnAsap9FbY/0XvLjBBY4XYlmQoEPO5PKPqHi4ujvUwmRhIPi2SsCapdzRyjGrtYUh4ul5YA9A/scq8sPQTSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n8Oj+dFa5m9+RvxGwQvBDkRDqhyoXH/HqDCaYHSZfkE=;
 b=ZlmBTnUNzNfMuSv8F8d00LGx4FucvkXTjEMGfuLJyVBKOE4LtfSK8LvOxEhc5VoU2S+uf7UWtq5T8gm2qWLgFXSLYq62v08QEVAA7BGlCVdo0M9AzIR05OgHlgsVtic4W0ca/Kxc79oNAqM0MQgOk40syL9UaKHzTBDkj2lF+38JopZMPaHnz51ssg3HZt/zxUesF7R931w1WIIZZckefBVGKnDB1deOXlxKbkEDdnkoCJZgUDv5C1qMfmCe1F69WamPXwKvIJ0oypAxi8oE1Cto3Sinj/gH81i4HTq8QJe5f/55SO9GneGGMRD8xLea88fgDsiuKcSh/5I3c3A7RQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=networkplumber.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n8Oj+dFa5m9+RvxGwQvBDkRDqhyoXH/HqDCaYHSZfkE=;
 b=GkQXBsPAivWM1ntktHbsNJEZzr4qifKyE8w4sT0OUWINGxBQZxOYGB48ciS6oY0DPp4mZCVf8BjcDVGze3E8XvMUAIyrf8rIdBcorZuFTUgAsgmbyXzHEkfPbuwpEeRZgpGT/j2JtEZ5c8uoozu7PlTrf74NrHZehdfl8L2whVxxyzof0Kpdz5t3kWZj6ifHVqXsb6h7C4oF+o7PJJEd7iX4FkrfO+UAvDuJ2ple9bhz0vBVqkLGPliuWW+P1MzSk4b42aiYnp4aYWHMuE5TSN7KFt8RyMLgJXaRKx+BCe7xUWN4X1LdcyuK9suJsb3pNqvw/JXIeLiqhNUC5zUJHA==
Received: from MW2PR16CA0049.namprd16.prod.outlook.com (2603:10b6:907:1::26)
 by MWHPR12MB1438.namprd12.prod.outlook.com (2603:10b6:300:14::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.17; Sun, 1 May
 2022 00:12:07 +0000
Received: from CO1NAM11FT045.eop-nam11.prod.protection.outlook.com
 (2603:10b6:907:1:cafe::9c) by MW2PR16CA0049.outlook.office365.com
 (2603:10b6:907:1::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13 via Frontend
 Transport; Sun, 1 May 2022 00:12:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 CO1NAM11FT045.mail.protection.outlook.com (10.13.175.181) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5206.12 via Frontend Transport; Sun, 1 May 2022 00:12:07 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 DRHQMAIL105.nvidia.com (10.27.9.14) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Sun, 1 May 2022 00:12:06 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Sat, 30 Apr 2022 17:12:05 -0700
Received: from localhost.localdomain (10.127.8.9) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.22 via Frontend
 Transport; Sat, 30 Apr 2022 17:12:05 -0700
From:   Roopa Prabhu <roopa@nvidia.com>
To:     <dsahern@gmail.com>
CC:     <netdev@vger.kernel.org>, <stephen@networkplumber.org>,
        <razor@blackwall.org>
Subject: [PATCH iproute2 net-next 0/3] support for vxlan vni filtering
Date:   Sun, 1 May 2022 00:12:02 +0000
Message-ID: <20220501001205.33782-1-roopa@nvidia.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 548f1eb3-017b-423a-977d-08da2b073a70
X-MS-TrafficTypeDiagnostic: MWHPR12MB1438:EE_
X-Microsoft-Antispam-PRVS: <MWHPR12MB1438C30650EEAD3D4BDD1B1ECBFE9@MWHPR12MB1438.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1NhLE6ZdMIP0zKcgK0uUIMW3KihnLeveRi+3n6YRP86d6KkIJqba6+ZVJf2cE6tYRmwXggpaxuF+88wgoiMHCO6cN6sUP1gUSKkQATee81bzXDjFfNOHNe9S2WhjuRMqQ3BLTPvi/iRu4uJtJCB/ZaSbc9A1yXVIZkiatrWBV8CVELKoXOUd48eOVgdGzLNRrUMBF4SDvm5AfQ0IBUqeY42ocEf7BdigoobxdHPuSrjI9bKNW6eAiHaVNuo2ktSEw8JWMjqOJeJ44pQV5l4GgBI/vyvRNh5lHpAi17ATUSA4ixKDOeRQ3YKzQCHR4OYkK+xjj768aCjTzhr4UNTnh8ukCGXI9ItdNYQQttd/MlSN+PheEMW+a6nJjB4k9uBWFtYJyaD97wF8++TsKgQa0Mf8gRJAabI/pCb4Ff4OKD7JCLZ2+h/eDRELyAPuKiD/jMvC1NPXj2uJe2YCkxURAiWhSU+czFAdyt1wwe+Gzw1otKrJmfNIbEl12o4+9mOB7oqPAzgDh8+9+klC7Uu+ApRu+WfJee5vy/qnP3PYHNF9p6pFG56637v7EPdUzmSHqB3DZNFziSGtL/Bwbm/+I873iNhBJHyVN/QOvzy8qimOgo/CPzJzZqPPIeXQy2NUDWgF6PhqJzuZS63Q9cea8i0qkpPjFyrr/NSpV7v+82QOGLRTya2LDnDpph/p1z7CCchO6eD3g8UxhUtnpLiB1Q==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(36756003)(70586007)(2906002)(86362001)(70206006)(26005)(82310400005)(4326008)(8676002)(47076005)(6916009)(356005)(6666004)(316002)(81166007)(40460700003)(5660300002)(8936002)(4744005)(426003)(508600001)(2616005)(36860700001)(54906003)(83380400001)(336012)(186003)(1076003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2022 00:12:07.0475
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 548f1eb3-017b-423a-977d-08da2b073a70
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT045.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1438
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds bridge command to manage
recently added vnifilter on a collect metadata
vxlan (external) device. Also includes per vni stats
support.

examples:
$bridge vni add dev vxlan0 vni 400

$bridge vni add dev vxlan0 vni 200 group 239.1.1.101

$bridge vni del dev vxlan0 vni 400

$bridge vni show

$bridge -s vni show


Nikolay Aleksandrov (1):
  bridge: vni: add support for stats dumping

Roopa Prabhu (2):
  bridge: vxlan device vnifilter support
  ip: iplink_vxlan: add support to set vnifiltering flag on vxlan device

 bridge/Makefile       |   2 +-
 bridge/br_common.h    |   2 +
 bridge/bridge.c       |   1 +
 bridge/monitor.c      |  28 ++-
 bridge/vni.c          | 439 ++++++++++++++++++++++++++++++++++++++++++
 include/libnetlink.h  |   9 +
 ip/iplink_vxlan.c     |  23 ++-
 lib/libnetlink.c      |  20 ++
 man/man8/bridge.8     |  77 +++++++-
 man/man8/ip-link.8.in |   9 +
 10 files changed, 606 insertions(+), 4 deletions(-)
 create mode 100644 bridge/vni.c

-- 
2.25.1

