Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B3726D4E0E
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 18:37:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232869AbjDCQg6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 12:36:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232831AbjDCQgz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 12:36:55 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2050.outbound.protection.outlook.com [40.107.94.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3211E269D
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 09:36:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CjMRoTdkMVPy8c96LwbNZsthBnn1Km3qLFlQuxJ7TRfdJrqlOkW8xpZxifEgcuoYAABIfkN/8MISljnmlm+5zSIEoi/fnlr5jOmgIaV5y5rnjWmVzImHXdOtwSun5IrkPDX5mc9WTpVvbwDhJaHpoTrfVFvf79p4G7yuqeEuefY26k3MgXkLOYWV7TgJ6+Sc8hjQh/OLBaxrDE0rkUieAydCJW+SR8M42BMMmSEOYZMWBms4LFy2S0Gagb8uC3jKr+bGiGyPtLbLcg5w6z6i689ZGEEdKNcz0TXfre8IorlbMs2LfxuRc1MVk+4AFWsyWvLpCMqwLFzSSgZw9Hd0UQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X8sGdCkxJZZEBSISNejvJgk/5gL9/P17fJKr1D8a6/o=;
 b=KzH+BtjdF89DTFcJIJVAJEPzJUQL3hC84/8Gt25N05y+sUNe31fXDjXvqwJBmtImTBS0pdAC0kL3ooUyuqx+4qHWEfM2YPwF/DXoofRvc0myAx0UBmOMQEq+aSc6qonvppUU5g7gBEOKhyHl1O8TnyN8CQ+Xo2RLkek3uwn6dvKvNf+vrnL3vc5Aolr7r/tDHg8SGD/ijgnUH1ErIa2IWqYhdBFA38U7pdXMRcz6s5kRXRxW1lSe/rpdHBOikiJGRxEryZK0zglniTxKRe+oW+U9/0bymziDEHkyFat/B9L6GonB59FrnuBDgpZOlcc6P0ahkLzlM+fBmwGsxsvpkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X8sGdCkxJZZEBSISNejvJgk/5gL9/P17fJKr1D8a6/o=;
 b=v4OgbdsrFDcBn0lc3Ifq9M9NllTEEkT7AxspUVDeLpK2iQAPbMQvVVPGTYJYLay5fQFvDHzm/AfEpINzIO7lRt6FyCmfUlVuXwLCa5YVEU3b+3EQNBZu/Yd40vwo1o/uhvjtxv/Imz249GP6zT7TvtW32fa9KrAIrQeBk+oKX9I=
Received: from MW4PR03CA0152.namprd03.prod.outlook.com (2603:10b6:303:8d::7)
 by DM8PR12MB5461.namprd12.prod.outlook.com (2603:10b6:8:3a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.30; Mon, 3 Apr
 2023 16:36:49 +0000
Received: from CO1NAM11FT104.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8d:cafe::b2) by MW4PR03CA0152.outlook.office365.com
 (2603:10b6:303:8d::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.20 via Frontend
 Transport; Mon, 3 Apr 2023 16:36:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT104.mail.protection.outlook.com (10.13.174.220) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6277.26 via Frontend Transport; Mon, 3 Apr 2023 16:36:48 +0000
Received: from SATLEXMB08.amd.com (10.181.40.132) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 3 Apr
 2023 11:36:48 -0500
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB08.amd.com
 (10.181.40.132) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 3 Apr
 2023 09:36:47 -0700
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34 via Frontend
 Transport; Mon, 3 Apr 2023 11:36:46 -0500
From:   <edward.cree@amd.com>
To:     <linux-net-drivers@amd.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@google.com>
CC:     Edward Cree <ecree.xilinx@gmail.com>, <netdev@vger.kernel.org>,
        <habetsm.xilinx@gmail.com>, <sudheer.mogilappagari@intel.com>
Subject: [RFC PATCH net-next 0/6] ethtool: track custom RSS contexts in the core
Date:   Mon, 3 Apr 2023 17:32:57 +0100
Message-ID: <cover.1680538846.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT104:EE_|DM8PR12MB5461:EE_
X-MS-Office365-Filtering-Correlation-Id: d119693c-3225-4691-c744-08db34619f3e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Q+ZsSSAFdYjLoSaYObPu0V1sBb94om0/ey9p96q49w+ufb0Tae6MYuOG9xNZu1E4MopADxEwY82KNKh1MAbm6OY3t1hFZF4nYbI331unGW62JcOBlomPiadRdvuD6FldB8BhySNen+oDACMjorGPVYmlpix2FEFmLeHjL4ZeoIi3l9JMX9McYaOmNN3iQMcCkRCnxPT3jkelWTU9LZI7B8Z7zg0FSjv01DqOvuGYMxprn8B7DDeOFcgkx3TTDxLjUdq5LPeyyea8swvJugBJrgKeBtZVOEl9nUIOMDTHip9Bt0kNvYlsK+bHX2OnIHeDFxWi4ocHYjz7VbPQ0EQY0FEPwF76QjZMqIKLczZiAzZsW449e+lqXiMuKT4cI7dZ/f+GZv/GDmVZxKmIj8f5A2LFlWuOSsRtBpVTT8XlKL/PYNlrm5p6Khe15wP/R3U7R0SZUs8n+Xm+frFnLrmN0pMAWQoF1byjsBGbz1K5ZalEIQN/A2SHEsiPvNB/NlcWTw7GIGtS+ULuw7ML6+dQuAzEhcg0HXF4kSSo2b5k3AMEFTp6/KJ+gytO2xt6PYBE9AwxvskOT6EPzZbfbeALlFg8orouNAcdMs8djMtgVAjLx7nuMyI3AFxaRZsSxjdZlIneMSvGqTs2MWTyJCtQMpVM4qmGBz9VP7XEwYPOPzupQzXDJxN/IMLGaEGxOLD6gGS+/FAgv8nWc4667CsI1OAhgH4b/+57tMJbEoCZtt4=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(376002)(39860400002)(396003)(136003)(346002)(451199021)(46966006)(40470700004)(36840700001)(41300700001)(8936002)(82740400003)(82310400005)(4326008)(81166007)(26005)(356005)(110136005)(316002)(5660300002)(55446002)(86362001)(54906003)(8676002)(70586007)(70206006)(36860700001)(478600001)(2906002)(47076005)(83380400001)(2876002)(426003)(336012)(40460700003)(186003)(40480700001)(36756003)(9686003)(6666004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2023 16:36:48.9658
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d119693c-3225-4691-c744-08db34619f3e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT104.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5461
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edward Cree <ecree.xilinx@gmail.com>

Make the core responsible for tracking the set of custom RSS contexts,
 their IDs, indirection tables, hash keys, and hash functions; this
 lets us get rid of duplicative code in drivers, and will allow us to
 support netlink dumps later.

This series only moves the sfc EF10 driver over to the new API; if the
 design is approved of, I plan to add patches to convert the other
 drivers and remove the legacy API.  (However, I don't have hardware
 for the drivers besides sfc, so I won't be able to test those myself.)

Edward Cree (6):
  net: ethtool: attach an IDR of custom RSS contexts to a netdevice
  net: ethtool: record custom RSS contexts in the IDR
  net: ethtool: let the core choose RSS context IDs
  net: ethtool: pass ctx_priv and create into .set_rxfh_context
  net: ethtool: add a mutex protecting RSS contexts
  sfc: use new .set_rxfh_context API

 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   |   2 +-
 .../marvell/octeontx2/nic/otx2_ethtool.c      |   2 +-
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  |   2 +-
 drivers/net/ethernet/sfc/ef10.c               |   2 +-
 drivers/net/ethernet/sfc/efx.c                |   2 +-
 drivers/net/ethernet/sfc/efx.h                |   2 +-
 drivers/net/ethernet/sfc/efx_common.c         |  10 +-
 drivers/net/ethernet/sfc/ethtool_common.c     |  96 ++++++-------
 drivers/net/ethernet/sfc/ethtool_common.h     |   4 +-
 drivers/net/ethernet/sfc/mcdi_filters.c       | 131 +++++++++---------
 drivers/net/ethernet/sfc/mcdi_filters.h       |   8 +-
 drivers/net/ethernet/sfc/net_driver.h         |  28 ++--
 drivers/net/ethernet/sfc/rx_common.c          |  64 ++-------
 drivers/net/ethernet/sfc/rx_common.h          |   8 +-
 drivers/net/ethernet/sfc/siena/ethtool.c      |   2 +-
 include/linux/ethtool.h                       |  66 ++++++++-
 include/linux/netdevice.h                     |   8 ++
 net/core/dev.c                                |  36 +++++
 net/ethtool/ioctl.c                           | 107 +++++++++++++-
 19 files changed, 359 insertions(+), 221 deletions(-)

