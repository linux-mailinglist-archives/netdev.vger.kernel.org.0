Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8880865E66B
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 09:05:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231428AbjAEIFD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 03:05:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231266AbjAEIFB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 03:05:01 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2078.outbound.protection.outlook.com [40.107.223.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D42C2544E5
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 00:05:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hl2Kqgdula+Nr2nfnQmuIZp+/NnHQcpCNoDBu/Lt28RU3475DC3JfVHnVgLr1fU0JFjB9iRji4yCOvmWshE+o/eGIBq2CQZW0TKsic3EpRyPz4dbH3OIuCwwBStxRjmTzBVzpCnvJjz4vp/jI3N8m6pu9SMeQT8E27D1qZYWe2dbMNBw4/Aq5nDMt3w5s/PWfXdGqYwi2ba4uMsnn/cXmU7lLSweOuIj0T2M0h9HoAqseT1lKu1SEL/e8Kvr2KpUDLijCDz54M4TXssyiC9ux4+hhjbFz/B1p8MDSO030eYNNjfs49z77upsfSG6BJ72lX+gwUvR+knP5AE+zB/dgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=68t5NsV4p6KwyYpZdzovIb9BYzqQtqSd8KhSr1wLA8I=;
 b=YFVUKU/vbPRcdB+Bxwr/jS2B/V+0SUYqtuJVp0Q56NocNCRlL2jDCwIJqfvju0c9EOp8UGux62BxVaaYj7Ph01y3uNTAdaQ2Nb+Asa4p2OZIjxBDrtoozdbgyXFMDV3AgNFwyNt4Z/Y44BzVJWHvMSa1tvoZfSNkKXUGMFdJGCM6W8gfSKPB5UvordLiBiJ85DnuMMDWZ83esR0mHORyKV3fITBj26EmUADmnpolZrv8pQX+O2mpRCrhOGDCdwPi9OGf8ixRz/5lBSivCfZnlx5XddyUxCsHpL91IOEb0ioonIUq6yEXsQ+uevMDNyHpMmvAQFuE95KpdLaIxNz/Mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=68t5NsV4p6KwyYpZdzovIb9BYzqQtqSd8KhSr1wLA8I=;
 b=ReEvG1z4MNpl+tXHJWbm/ILm3qH+DR6/kYT4H0W5uhgyleXPrh4WwqJAZUjtrjp0gWh9o2CFyEwOMU/c1VNizwMtHNkIU/we0Iw/nY+vpYYhLZvYIElobrfA+mvUFgEzQzMtlfOMTm75CXL26L/Q9n3e0c1gHGX/nY6s2F9DCZ/uYBr+P2wB2dS3/jJDXL3ZlXNYVJnqtgf0+Fy2cs4b72s+h9XS4dPPWXxLTn9J/8mwOjPTvGMveWSShHQyXNFcynQ0vfsKqhzoMyBP1IHNEIBoXFTH01Hn1n0z+8efZf/wFq/8eYZ8wGXn7obgaI92YGgUQvi+8LuTSH2R94G01w==
Received: from DM5PR08CA0058.namprd08.prod.outlook.com (2603:10b6:4:60::47) by
 CY5PR12MB6346.namprd12.prod.outlook.com (2603:10b6:930:21::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5924.12; Thu, 5 Jan 2023 08:04:59 +0000
Received: from DM6NAM11FT061.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:60:cafe::94) by DM5PR08CA0058.outlook.office365.com
 (2603:10b6:4:60::47) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.15 via Frontend
 Transport; Thu, 5 Jan 2023 08:04:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 DM6NAM11FT061.mail.protection.outlook.com (10.13.173.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5986.14 via Frontend Transport; Thu, 5 Jan 2023 08:04:59 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 5 Jan 2023
 00:04:49 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Thu, 5 Jan 2023 00:04:48 -0800
Received: from vdi.nvidia.com (10.127.8.9) by mail.nvidia.com (10.126.190.182)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Thu, 5 Jan
 2023 00:04:46 -0800
From:   <ehakim@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <raeds@nvidia.com>, <davem@davemloft.net>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <sd@queasysnail.net>,
        <atenart@kernel.org>, Emeel Hakim <ehakim@nvidia.com>
Subject: [PATCH net-next 0/2] Add support to offload macsec using netlink update
Date:   Thu, 5 Jan 2023 10:04:40 +0200
Message-ID: <20230105080442.17873-1-ehakim@nvidia.com>
X-Mailer: git-send-email 2.21.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT061:EE_|CY5PR12MB6346:EE_
X-MS-Office365-Filtering-Correlation-Id: 6294c3d5-6a60-4c12-55e6-08daeef38a92
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zDB9dWT859tomvLuZsZrRhvgIDQCuR5N8eqQ7PjF3uK1wxI1RUxf6Q8cJGfSxDUO/egoA1FIxGc8DH6mCDev15edmswb9WlF7Ipx/4c/HNaUD7u5Gax7KRh0KrrbPp/0itZdq+L+Rd0PxKMBKLCYMM00aAWp/7zIr+aflRinXN+hpIwHQaNTEW1roagW3VzfMm0qRd8UMdrTFJIQhvBM7tBVl2Ouw0FR9HsVwVcxZbEgYZHdEdfaMiDciQj1nWxWhqIyN5z4eR8xexyOjgXYwPtJAalvu9V4hMNSt78eHe+gDWzcqBeNhg4of/0lTzXwh/ceRzp/E2ejFltxDmBfJ9nzfK3dxe9VML3MkHK5FfSuRFUR5FPtHmoqrKfSoYjinDa1T19TrwNIq20Of8Z+JZ0mKv2yj1w4o4Zm22NFg3lEBKLCxrUHm+ym1dYEFO8WJwHqR9BR/rKvK46QU7kaxJj2szSl+RxaZ2714MQ2e7xMLHn3b7FbD2XkBpcOUaiufecazwWquHHuX60ohdhU0sLHFUQNBwBSux5jwrZhndDn90RoMbk9pxzwmNrW3oU4LeGQ5f3/cdnbKl7GCRkuAzbT6Koa6QU/6O9B7KRDCtgFXGNVwMrbm+xulwDvSH0D9C/i8ioK0oam3Pi1j1w1Ret+W4tG93/CeZ1S7jwQZ9YCgBeSuLkhNlVObXIxeaSic0sU3zPNu1IOxCE8SPfe2w==
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(376002)(396003)(346002)(451199015)(36840700001)(46966006)(40470700004)(40480700001)(4326008)(8676002)(41300700001)(86362001)(70206006)(5660300002)(70586007)(6916009)(4744005)(15650500001)(8936002)(356005)(82740400003)(316002)(54906003)(7636003)(82310400005)(83380400001)(478600001)(40460700003)(2876002)(2906002)(107886003)(186003)(6666004)(7696005)(26005)(36756003)(36860700001)(2616005)(426003)(47076005)(336012)(1076003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2023 08:04:59.4406
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6294c3d5-6a60-4c12-55e6-08daeef38a92
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT061.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6346
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Emeel Hakim <ehakim@nvidia.com>

This series adds support for offloading macsec as part of the netlink
update routine , command example:
ip link set link eth2 macsec0 type macsec offload mac

The above is done using the IFLA_MACSEC_OFFLOAD attribute hence
the second patch of dumping this attribute as part of the macsec
dump.

Emeel Hakim (2):
  macsec: add support for IFLA_MACSEC_OFFLOAD in macsec_changelink
  macsec: dump IFLA_MACSEC_OFFLOAD attribute as part of macsec dump

 drivers/net/macsec.c | 127 ++++++++++++++++++++++---------------------
 1 file changed, 66 insertions(+), 61 deletions(-)

-- 
2.21.3

