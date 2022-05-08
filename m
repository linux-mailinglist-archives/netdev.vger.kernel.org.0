Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 264D451EBDB
	for <lists+netdev@lfdr.de>; Sun,  8 May 2022 06:54:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231175AbiEHE5c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 May 2022 00:57:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230353AbiEHE5b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 May 2022 00:57:31 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2069.outbound.protection.outlook.com [40.107.93.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39D09E0B8
        for <netdev@vger.kernel.org>; Sat,  7 May 2022 21:53:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f/3wwLe5typuHHCcPc+X+DCY94jpdqwJfoRXgeexNbRkG0ApgYBdv6SxDZ2Fv1zKOM/+9D30sS/QdPu1X6KevN71a/UrADUy7dHrl0TelrYQgUbIlhbnWzopFH++y83aSnK+IlxJy2Pd3gr2GetPd7c4KXoucwsviKKAAAq/QGfvptOHsguO2SIWjMBojo0FMMuCBWR64g32AWA+oeG/HBrLBv4gCN/on6mdY0nMYYEqU2yO9TQKLGFmE8hGCHBEq3ZT6MZSA4lJGXnUZUpU6CWkNohhp/pHrKoTvbSBYsSmXHdKaOCW77hEnY8UwdAAFKjkt8j9oyO2BSBduXjClg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1sKKiQJTD00yHU0+TkUIT6htxSYxQAD/mWIHprQQg34=;
 b=mSEJVTbYOfOF50hbYPjIIraHPtEbJFJtBtw845bCtXvOIF3xBUwLg8AhSkWD5KAWuV+FdEiU0awITrnzCZS7hBbFBtdCZwMVa12cDyxtVWWk4tuG5dw4ehG2udZRTRzB0R8nd+2UQedBEDWBvOjANObPvd+X7TijR6pKCHAb63OyOTCLKxIKfZOZ1F1+VvXRiM/7vJOUdn2uQ9HUa9l3im85Ru6zjWbCoPX/RCHtY3KCWT/Md1rAps35XZqF1mDmelk0oIMdxplUugkVRoHTJIMaJI8pX0J3hDn9Cbmro9C+TBUClRNwXvogVUe0gCA7dzOYC/wo9VLBedpXClQ2Uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=networkplumber.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1sKKiQJTD00yHU0+TkUIT6htxSYxQAD/mWIHprQQg34=;
 b=cSU/0sWJKvL9KkuVSU14fyiD3ohXHbvz6bnCjyGm4dmiS+XBA4Hn3oKvMbq16lxLsNQ5CNNMuXqplpdIeVcoEY3LcEYy97ONESDHD756m8ay3n5YbTfS+FUbYte0wqm4r61iGzpE2KVZvnrIldKvpwAtVthN8/n8QlCQ3uVgWDC0gi1/qtdwwGPVId4vvfmn1duLgpQrlnRtGkJprmlvcSIJUXxhKECmaO2D3G9YUlDkqtdZbSwUcI2fYzFiI0ptV//RKW9/4soqQr3zGJIHPQgFLsCnKG+fEb8DInxXQTnuSyFv+AKdDwI5IVXjGVKdrGv9TSRaSIr5W+I7TXYDiQ==
Received: from DS7PR03CA0040.namprd03.prod.outlook.com (2603:10b6:5:3b5::15)
 by CH0PR12MB5026.namprd12.prod.outlook.com (2603:10b6:610:e1::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.20; Sun, 8 May
 2022 04:53:39 +0000
Received: from DM6NAM11FT008.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b5:cafe::20) by DS7PR03CA0040.outlook.office365.com
 (2603:10b6:5:3b5::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24 via Frontend
 Transport; Sun, 8 May 2022 04:53:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT008.mail.protection.outlook.com (10.13.172.85) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5227.15 via Frontend Transport; Sun, 8 May 2022 04:53:39 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 DRHQMAIL101.nvidia.com (10.27.9.10) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Sun, 8 May 2022 04:53:38 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Sat, 7 May 2022 21:53:38 -0700
Received: from localhost.localdomain (10.127.8.14) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.986.22 via Frontend
 Transport; Sat, 7 May 2022 21:53:38 -0700
From:   Roopa Prabhu <roopa@nvidia.com>
To:     <dsahern@gmail.com>
CC:     <netdev@vger.kernel.org>, <stephen@networkplumber.org>,
        <razor@blackwall.org>
Subject: [PATCH iproute2 net-next v2 0/3] support for vxlan vni filtering
Date:   Sun, 8 May 2022 04:53:37 +0000
Message-ID: <20220508045340.120653-1-roopa@nvidia.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: db95ce43-593a-43f7-6309-08da30aeb7f4
X-MS-TrafficTypeDiagnostic: CH0PR12MB5026:EE_
X-Microsoft-Antispam-PRVS: <CH0PR12MB50266EB0804EBAD4F753CE82CBC79@CH0PR12MB5026.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PxECTbcgCYxbTxHnmfZnWSooKCGuJnp0pDirzImj6PxtculTMF6Z3GH/4s0cJ9bCyRHQ9MntkV4Gq41R1PJdmJaXMrMybT85RxWti1LcSVGON3CObuTQSH6obV8tvtBmYq4burGk1om30Th/4LJqXEoL/d3XrCvebzh+j06+b18YDQt7EyaarORowS7ATChvCu7yrM9S2iW5FovbLhhawDuBu8PuEaRfnrfKpzD6IXC0QDN+bBLYB1NCe2UZ38ZCMA8Wk2bk51XMtQnYiN3gQiWa1FKjm79PyuFYFTdob2+2dQ3WM6P4nNC4tcXd5OlprFFUUa6JmWZoC8PpgDYvmyITqX4Oy9xZs3dOTG6rWdkcWH+Cuxyt6Yn2dc+I1JkVDfQKxJu7EQ4ecBqCtxVTZRrZwiQH3hpPOcpXMT1Wl15rX9qjZakjkmzT0CZW6LQheguleHnKP08frCRzGc4QctKhdmDWB77SyTUYsrucUU+qI/dUHwWkQ0dOmZ981XoMaSeWOQDnonTKR79akCRM/lQKNMSE9am9h4DXlOrxzRRsMfzHJY6bSwiO15mXGrZLu42NMrodeGbhYmEYZ78bvi3JyLIo95yI+9C2o7K016NvYuHr/OoW1I8xzglguC7ei2THvtcpqPcxHL4OuO4TxHU5ad8EeiVWpC1Uy+FajTSLTcMWd+3SMmCh2N53uzORd+A8astnVhLj7AACkzLI8A==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(8936002)(54906003)(86362001)(6916009)(1076003)(4326008)(70206006)(2616005)(316002)(356005)(8676002)(70586007)(26005)(81166007)(508600001)(2906002)(426003)(82310400005)(40460700003)(336012)(47076005)(83380400001)(186003)(36756003)(5660300002)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2022 04:53:39.3785
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: db95ce43-593a-43f7-6309-08da30aeb7f4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT008.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5026
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
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

v2 : replace matches by strcmp in bridge/vni.c. v2 still uses matches
in iplink_vxlan.c to match the rest of the code

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

