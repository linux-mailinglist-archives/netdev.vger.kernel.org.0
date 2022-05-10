Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4C2D52229F
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 19:28:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348225AbiEJRcY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 13:32:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348211AbiEJRcS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 13:32:18 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2077.outbound.protection.outlook.com [40.107.223.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21E79527F7
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 10:28:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g4mLmHQNfKvaakDD0CxBx8AafpJoJSgoTP46gFl9Eb6SF/SD3yXCcFp8ECFSD3sFHVqG/O8TRrOHJURSpLHwfwDxaIpiI1E8VfMxrxt+ZueS+ZaOdmQN9+UsdxqGqtHVy7LMoWBYtvgypE3qFFezfm26exMKhaGP41Uab15e50cnAdJawuOzgDfowAQeqUPo7AFUh7sz3yuNJn5xTOLuRmPgGy8XKROzszQoacutoaJd25qMTk/2SwPtO2yQYwkebpFqLN+AkzclcdK80HignRMSHiKDCgEYERsZi5gfI1k59ykkk6Juu3OVCmCcKfQemKqSlGoyjw5qtgMpZUNrOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c2+8F1X9wHCD/hmO+Ue9PRskKkH8xbAryevJnfnZ0is=;
 b=nQyJHynSv7pXUgLtIf7u1vchMnpZ9CNBsipZEetbTloC/z+XNFivnQJD3I2az6YUweKPKIW9/pwvF4PXz9Mcdv0Jzuj6k0xZH90lxu5nnUlXVdYTRGqurcEWVO2KqzH6F5T1Xv617DjX3PkteY1oMMXSVBcydFuVDIhZX3t2jeHlKxYfgVwfv13ph2NLUytAWp4nky+qpM9hwxP7Pgpy34AifMvUzmv8WsuYsEMHc1tfYnNZNYSW5l0wImVWj6228OpKx8YwTfKzJJJ20IFJREEpXEAwhFYHRrKyAo9dqIr8IrMzMVz2RqbbBFuNaRYJs3dHRo7fOSy0PZ1PDG8v+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c2+8F1X9wHCD/hmO+Ue9PRskKkH8xbAryevJnfnZ0is=;
 b=NUhCOyN+sbzvl6JwJtwqBwH+UwJQ7w32KXnZYNfmEARYDhNrhh5uoNA5s+/S9T+1iah1Ey+0TtrhxLnlZiOEY+qmBrl2nYMsAzDbz6jq2nqZYruaRAsCTv3RgPbNCEpyWjna2IgxvJBY9X9JafXQBQ1emcabdICgWKOn67ikfRnukDHuglg4JzAQd4y31gQvEjK864OBMQSmKXiMcyb4c03ylMh85ap41dJDJ8tyuA9m5ioIaPZIMlopRh2NHYALd7yEjiLPjsE8lKhAGP9rDJ6EJ5R3drGLacoAazR7uzwxgpuUT05IByoLzJP4xUfkvG7wNm7jXvU+Hkagw/e24Q==
Received: from MW4PR03CA0070.namprd03.prod.outlook.com (2603:10b6:303:b6::15)
 by DM6PR12MB5517.namprd12.prod.outlook.com (2603:10b6:5:1be::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.20; Tue, 10 May
 2022 17:28:07 +0000
Received: from CO1NAM11FT014.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b6:cafe::d2) by MW4PR03CA0070.outlook.office365.com
 (2603:10b6:303:b6::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24 via Frontend
 Transport; Tue, 10 May 2022 17:28:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 CO1NAM11FT014.mail.protection.outlook.com (10.13.175.99) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5250.13 via Frontend Transport; Tue, 10 May 2022 17:28:06 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Tue, 10 May
 2022 17:28:06 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Tue, 10 May
 2022 10:28:05 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.22 via Frontend Transport; Tue, 10 May
 2022 10:28:03 -0700
From:   Tariq Toukan <tariqt@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Ahern <dsahern@kernel.org>
CC:     <netdev@vger.kernel.org>, Aya Levin <ayal@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net] net: ping6: Fix ping -6 with interface name
Date:   Tue, 10 May 2022 20:27:39 +0300
Message-ID: <20220510172739.30823-1-tariqt@nvidia.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 35f4eeda-6ec7-4255-a6f3-08da32aa7238
X-MS-TrafficTypeDiagnostic: DM6PR12MB5517:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB5517015B8C7E7906D0141016A3C99@DM6PR12MB5517.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D4jWaVXKoz15C90RrymL5F5CSooVqdUsswEUA+cs8d737mcZx/fSX5DgZyfBrYeomG0+DDA6GjMn5hQK/DRaDQzIN1FEoYXCKSnrMS5tatUJDySvzfBq1UEBE0UFQr1sgwXUBgC44u2L0istAtlxqxaFodPePOIFZwHo0AQ2Cy2tTe46HNrHdOPmCZOpi4xUMJUIzlY+4yhgDbtY4sqI4r/tMqHynYUI/TKeJLPveacQ68m/YDug7kf6yowx3GzaXZHu5PAr8iWwg5ef7FQyU78uYa0mUc1HUd3ftWweuZBesIp2lJMTS4dJgG7fwo3fu8UXUvNR0oaEPX+5wq2f/pUx/AiBZ/byWKBo0jElLybg8P9IPAMRU0IwvZCkASa51nuQCpuqnQLEKIT4yCOfwYJZp66+CpAq/400nCrx97x3vA8p39udyQg+ny+vmQUYYYB0vex3uqmo4TrNsNFjwj9OK6/sZRcZip8d7G4lb/Dv/C3hmBRBoKFMdKrA2W1+zAO2Jkhk/HjcT6CHvALkFzZQvKHWaEZmSzykvr/rc9SsxZwH14SXu4mRGQtsx58rmtd8r/5pRA07S8X6yBZ5Zn2mvb5w3z3tfHhjtXiKU1zH1QaXH3iLO8osVIwdmVs8KOg0oe/pSFWGcTLJZ4NMH/+3PTyH2H2v8bCayqVLyRqlbGrOxRoWmgOuQTHaGMddltupo/17WZvn/tXyQAD5uw==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(508600001)(316002)(8936002)(54906003)(36860700001)(110136005)(356005)(4326008)(86362001)(70586007)(70206006)(8676002)(6666004)(26005)(40460700003)(7696005)(1076003)(2616005)(82310400005)(107886003)(186003)(336012)(2906002)(426003)(47076005)(5660300002)(36756003)(81166007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2022 17:28:06.7397
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 35f4eeda-6ec7-4255-a6f3-08da32aa7238
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT014.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB5517
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

When passing interface parameter to ping -6:
$ ping -6 ::11:141:84:9 -I eth2
Results in:
PING ::11:141:84:10(::11:141:84:10) from ::11:141:84:9 eth2: 56 data bytes
ping: sendmsg: Invalid argument
ping: sendmsg: Invalid argument

Initialize the fl6's outgoing interface (OIF) before triggering
ip6_datagram_send_ctl.

Fixes: 13651224c00b ("net: ping6: support setting basic SOL_IPV6 options via cmsg")
Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 net/ipv6/ping.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv6/ping.c b/net/ipv6/ping.c
index ff033d16549e..83f014559c0d 100644
--- a/net/ipv6/ping.c
+++ b/net/ipv6/ping.c
@@ -106,6 +106,8 @@ static int ping_v6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 
 		opt.tot_len = sizeof(opt);
 		ipc6.opt = &opt;
+		memset(&fl6, 0, sizeof(fl6));
+		fl6.flowi6_oif = oif;
 
 		err = ip6_datagram_send_ctl(sock_net(sk), sk, msg, &fl6, &ipc6);
 		if (err < 0)
-- 
2.21.0

