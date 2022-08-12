Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E500591304
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 17:33:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235653AbiHLPcy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 11:32:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234501AbiHLPcv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 11:32:51 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3401882849
        for <netdev@vger.kernel.org>; Fri, 12 Aug 2022 08:32:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YhreaeIR1SvBX6EPBEiXsbz7J8uXNHLivhB6nUcBvirSgnp393WFEOKsiIW4J5MjWNnS11IDYE8pawVHx6P6CjG7Jp/z82QS5mSouQ+lNa41ezktrvQZf3HLh9+3fgNNGCrJqXqyvqtS36lUmh5PvzM3yEKoEQ3jytmIXsXGDcZcEsoeZFiXQEIpIthr4lfMFmaseVjhSARrtG0eKhPYHqPBQY3B/7FWLRywccKqrxEv9g9PhcZzfIoH7Fq3WLd8RUnV2sdJbXDKYzotUsj8X6v/MPmxDm0SXf1Ibx+cPthEeeSUkrKAaby+FEO+Cdo21gJyhvdeL2ZA8tTMFY0vMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7r4UIkyHk8uRWKP1rHj3JU4Cy/HRpNxXImMtSRlZtK8=;
 b=A5iNHpMAa5XYuRDqQ89PKd7prqP6YIAoWaKvENOuvbBVUNqz5wFC9Cqk9irmuRIXzamUPHsRg3BcsPYXqIG2KdzOTsYcULB5xe6fY7lJADHn26cnKEYbmXYBXCpRd6D5PAMQ0pIwPLxB+tgI3ML7C+JNFTBj7hFfQ4LQrhoubXElQCy59jVwYNJhbWzVHuGs6LqXulwYeXC58XLhA4hrQdVeEXQU9B9vgeUg0BZK0HRK4CDAUyi/ygUqA6vay6wWUecsjJJBc2J/6HggXtOdMqe+CcEr+LZ85u81Qv3BVYB3dAvI5kJ/gAUw2bapq2FfVN3OXYhNNbMKHd9gZKrk8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7r4UIkyHk8uRWKP1rHj3JU4Cy/HRpNxXImMtSRlZtK8=;
 b=SuGrNn2S1a9HoPoi5prd+ui3bvBvYLhH+5+LD8Gasew39yvk7qrlCW6lt0K/H+YBSMjbvKJn5jYHj6zE5tTkUlL9HLQW5FEXRU6TB/a7Pfst4B9HEsaum/uIqRiCK5mfjddGZTNvI6psFWQrh+sbYtDteOros0gl/bCioYhkf6GXEPShXZ+ZrkjQL7h0VBaGvQhjTicSSgrgPBgfhYK8xeu8poFoi8qTYVhiwy7xDE/C8v3q13WtiLibF0Vf3KAh4+WI7i/s8XwI++4TAXmJ63pBkPo/Za33BGn6CowjbTiOcLKNq8McGES8K/nk1aZUfKtDwAe8OMWq+3g5alPIgg==
Received: from BN9PR03CA0209.namprd03.prod.outlook.com (2603:10b6:408:f9::34)
 by MN2PR12MB4503.namprd12.prod.outlook.com (2603:10b6:208:264::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.10; Fri, 12 Aug
 2022 15:32:48 +0000
Received: from BN8NAM11FT019.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f9:cafe::8) by BN9PR03CA0209.outlook.office365.com
 (2603:10b6:408:f9::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.16 via Frontend
 Transport; Fri, 12 Aug 2022 15:32:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 BN8NAM11FT019.mail.protection.outlook.com (10.13.176.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5525.11 via Frontend Transport; Fri, 12 Aug 2022 15:32:48 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Fri, 12 Aug
 2022 15:32:47 +0000
Received: from yaviefel.vdiclient.nvidia.com (10.126.231.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Fri, 12 Aug 2022 08:32:44 -0700
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     Ido Schimmel <idosch@nvidia.com>,
        Danielle Ratson <danieller@nvidia.com>,
        Amit Cohen <amcohen@nvidia.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Petr Machata <petrm@nvidia.com>, <mlxsw@nvidia.com>
Subject: [PATCH net 2/4] mlxsw: spectrum: Clear PTP configuration after unregistering the netdevice
Date:   Fri, 12 Aug 2022 17:32:01 +0200
Message-ID: <43be9b4596b0588ec1e9d9046a21fd96535dc125.1660315448.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <cover.1660315448.git.petrm@nvidia.com>
References: <cover.1660315448.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b35cf9b0-03dc-4e94-2349-08da7c77e933
X-MS-TrafficTypeDiagnostic: MN2PR12MB4503:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4K/OGP1z2fAbRImgrBDWZZ9qECQZkB3KUIi3I9aefMH/taAyWie0GiQI8GZvEh9diFqEfsNln/fcG9jcRPSrv/eCfWB5EwEArT8KcUgvY7WoAS6AOQ4JrBBlXEAcxX5XEkVv4qlOE/klcvJiI7KLf/zV8a/UEJ7u8itI/jUhpnX1JP/QCMem7IZMM/HXpwuQHPEcIhTkYUEE685Pwxz7K9PhLvuunNHYLKmqreBo4EYiOfb84JPO6O55TIzj/bw7zglYluCQ7Fjt9HuscD9qoYjmA+vrGiS5rmb940oqMtQOOtW6LMAX8LNPrUVGbq7dgvo/3CnvH8zqAk67ZZfSVf+jiyDTZZQrjeaFgddMl3YWstK8JRX5P9vetKeMh7lEQfJ/3KflgYN0kJNxwCRDey9sX+ltGG6qebVusy0/KwV0zy0R+xcsNtDi6q6dhuFkoDfrw88lWhUqB7r2GURBmtNnJJhXkpK3f7LH4V4QckRWcZ7rJ0HZX0irFZuNhsntMNml3NrlCHiJ5u3axow3Wakhm7F2rBXpKuWYq1sb6W0gWusAj20jGZUU17TC3k3wG8MIUOfDKHv0YLAT4xP58a25Ja5hHjx4y/gSmgyaHTM8/rbYA7/OKfo7hLZqgS/YOc19MKoQ8M6nfH/flBxTD8UWO2Da/+fPKiEv69fLyWk+IZRa/spVOMgJZSZtzoqyeRZMC5XYQgEmVIk75Jy3AbYwQlaYARkCuGsRtCerXJaYCxsTUMIzz6ACsfH3/xrWMZIDmp9A1h5ohATza+heg6BBP/+HqtSuTwhCy53OGYJ64nrHZ0M9+TT8P9yjsi9WM4Dg1FXFaC/sqD1QpS1sIg==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(136003)(396003)(376002)(39860400002)(346002)(40470700004)(46966006)(36840700001)(107886003)(336012)(40480700001)(54906003)(47076005)(2616005)(426003)(478600001)(41300700001)(82310400005)(186003)(316002)(6666004)(86362001)(26005)(110136005)(7696005)(356005)(16526019)(82740400003)(40460700003)(81166007)(83380400001)(8936002)(2906002)(8676002)(36860700001)(4326008)(5660300002)(70586007)(36756003)(70206006)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2022 15:32:48.0179
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b35cf9b0-03dc-4e94-2349-08da7c77e933
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT019.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4503
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

Currently as part of removing port, PTP API is called to clear the
existing configuration and set the 'rx_filter' and 'tx_type' to zero.
The clearing is done before unregistering the netdevice, which means that
there is a window of time in which the user can reconfigure PTP in the
port, and this configuration will not be cleared.

Reorder the operations, clear PTP configuration after unregistering the
netdevice.

Fixes: 8748642751ede ("mlxsw: spectrum: PTP: Support SIOCGHWTSTAMP, SIOCSHWTSTAMP ioctls")
Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 1e240cdd9cbd..30c7b0e15721 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -1897,9 +1897,9 @@ static void mlxsw_sp_port_remove(struct mlxsw_sp *mlxsw_sp, u16 local_port)
 
 	cancel_delayed_work_sync(&mlxsw_sp_port->periodic_hw_stats.update_dw);
 	cancel_delayed_work_sync(&mlxsw_sp_port->ptp.shaper_dw);
-	mlxsw_sp_port_ptp_clear(mlxsw_sp_port);
 	mlxsw_core_port_clear(mlxsw_sp->core, local_port, mlxsw_sp);
 	unregister_netdev(mlxsw_sp_port->dev); /* This calls ndo_stop */
+	mlxsw_sp_port_ptp_clear(mlxsw_sp_port);
 	mlxsw_sp_port_vlan_classification_set(mlxsw_sp_port, true, true);
 	mlxsw_sp->ports[local_port] = NULL;
 	mlxsw_sp_port_vlan_flush(mlxsw_sp_port, true);
-- 
2.35.3

