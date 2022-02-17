Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 793234B9AE2
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 09:28:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237533AbiBQI2r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 03:28:47 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233554AbiBQI2q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 03:28:46 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2073.outbound.protection.outlook.com [40.107.220.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6EF91F3F01;
        Thu, 17 Feb 2022 00:28:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E3GHyDgYQEXkjjcjSg5K61opBcjQ4m2xulsd6ozi8lMR2VR/ceH898GglcYFIOxGkFehV2xyRSxOpg23kwshwJC6Tb5bXO7s0U0pj/1JJtRfSRlWvjYnjwaF8AO87nhjnfso24G/GxOnk3ksX0tpUTffeQAwN3FDTNEPqDZkFAnvFL+1lmwIss6ZY+Y9BW3qHUwOmtiwqzYysSRQFF1wLjfpvEcxaRkasjIq1jlzixSjwJuZY6PSzeutyWK4Jmey577tzo4fvfggxdakleQm0uh1xxQMDJJCch3fzpYDZsgUkh87yuXRN5ZCiUPqT3IfnPfx+tlWFBAR+O09cvCSRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c6r44nGTqTFWDgZRiwhFVjss+bih3touwgbapVPUqkw=;
 b=e17791RYGwTWGWMaW/vW39ywaXFyxnXp1QRZqTm0mWLKQnRrDb5rYKod5vEKJmzxEUjjktHJcUysnk6KixxS+UqC4MZ9Kn7CUeo0Ka7D4Qo66VQEkYScecErrEKGtFIY6nhFI36JbX4JBO7sFYF1syWncKdiKFkS7YWDYG6ZyMMEAH4g1areH3wsAuH6jwu5brdEsNeijcgx6YumUvdTwriIxUcj7i+vBQLn1wIhgIBMJbKnPkb/iq3I6vojEDBbe7cAtjexxjUK/+IQDBxNRdejIvPF1kLCxvWr1mJzilTDQcDuQoTY0Mi5j/HzUF7UHdA0H8/7Lkey6Voj4WHQ3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=chelsio.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c6r44nGTqTFWDgZRiwhFVjss+bih3touwgbapVPUqkw=;
 b=k2OTT1mihzZs/Bo9rJagZ8OARkf5B4L/O5RvlLMYZU7iW+tTNDIjvMfupgAf9CWcVK5hXD2q15j0IWWxT84/p2XNRHEjeY9EkcrCzjBDbbsRx78+LTmQasxsVhJhJOK5p34p0cYJJ6e88gU1Hx3W8fW59RSV+6VKBm63hUqEGaJLOMMEVTE3nwT1LzaobEsEeTIgE1ojI0qapZlTiAgUUmAMNAWDdSPsaCDVt4poDAXpN+n1VyjykxQPZOfCYeV5du+FIERuPwyar3TIzCRGl6Ees7NNnZ/R2NDOoGNfzAdCO4Yt5LHbqGfBITD94AKp25c+DZwKC0kzmlwAYRYXSA==
Received: from BN6PR17CA0005.namprd17.prod.outlook.com (2603:10b6:404:65::15)
 by MW3PR12MB4508.namprd12.prod.outlook.com (2603:10b6:303:5b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.14; Thu, 17 Feb
 2022 08:28:31 +0000
Received: from BN8NAM11FT014.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:65:cafe::49) by BN6PR17CA0005.outlook.office365.com
 (2603:10b6:404:65::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.19 via Frontend
 Transport; Thu, 17 Feb 2022 08:28:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 BN8NAM11FT014.mail.protection.outlook.com (10.13.177.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4995.15 via Frontend Transport; Thu, 17 Feb 2022 08:28:30 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 17 Feb
 2022 08:28:24 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Thu, 17 Feb 2022
 00:28:24 -0800
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.9 via Frontend Transport; Thu, 17 Feb
 2022 00:28:17 -0800
From:   Jianbo Liu <jianbol@nvidia.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>
CC:     <olteanv@gmail.com>, <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <rajur@chelsio.com>, <claudiu.manoil@nxp.com>,
        <sgoutham@marvell.com>, <gakula@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>, <saeedm@nvidia.com>,
        <leon@kernel.org>, <idosch@nvidia.com>, <petrm@nvidia.com>,
        <alexandre.belloni@bootlin.com>, <UNGLinuxDriver@microchip.com>,
        <simon.horman@corigine.com>, <jhs@mojatatu.com>,
        <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <baowen.zheng@corigine.com>, <louis.peens@netronome.com>,
        <peng.zhang@corigine.com>, <oss-drivers@corigine.com>,
        <roid@nvidia.com>, Jianbo Liu <jianbol@nvidia.com>
Subject: [PATCH net-next v2 0/2] flow_offload: add tc police parameters
Date:   Thu, 17 Feb 2022 08:28:01 +0000
Message-ID: <20220217082803.3881-1-jianbol@nvidia.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 92b16e2b-9378-4ffe-086d-08d9f1ef7a81
X-MS-TrafficTypeDiagnostic: MW3PR12MB4508:EE_
X-Microsoft-Antispam-PRVS: <MW3PR12MB450862A84FEBC6B1257DA580C5369@MW3PR12MB4508.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O7FkOElQuwwWAHhSELDKxmThyq4vYON4g7HpDH3PpFes+dZ3ljQP0NDCINA2CBpq6aZXPPBlK0r0H1NC6vwWQuaPmSijD2HBqkEeS1RA6xJrPk9+jddcyWv4SDxvIZgonJFJjSMwYvB86Ujy1AL1LklvHEolGHi5RffIBhuZ5mkgVpCkd09mS65HsFmcyoOk3whIkHA+5QtM/DJCQO/vVF2WKmHK68RFOJega5EuVoX5moh/7wL+IVjQOSpUP5Dpi/U+1l8IcEtbk35YDXvzF3Xgn87Gs0OiNADikiQDr/ldZITRs5F66gfa8Wr1cxmc3bJ7tD2sRtrixpD9x8JBVOkwYHO6xKUA+avQl0OfV4AdvKAczuaz1CIibR5GV1zRvyVcjZ43J8k73VQZfIXZ0apmc/Fp/t8OgDYac/C05FvKwPkTPdSGc5SN5/2ERONWFCGkZIcMetwwPkQmTTqSUZ3r4relcqssnhEvz9GvfEKYMT2bZ9ytLJhcgSSCgVr73is5lC6k4hwQ8PLj/D5juYIEEIOc9CVo/UBQRi0OX0J+9uA0Yp3Box9FSOYbi1/F08efEfsqylSvaFbgx3KQhfT5Qa9gcwVglSAgcnUa8SU5BZy0dSQetZY+/6jrqo2uapMV8Azc4NPmL891oPlDpGQ95TFGyNCd7roKAk6RbnyNxWTaRMfsAho3uWl69KpNgr1iJp21IfI7YZR0QziVNQ==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(336012)(83380400001)(40460700003)(508600001)(426003)(36756003)(186003)(26005)(7696005)(6666004)(2906002)(86362001)(82310400004)(356005)(7416002)(5660300002)(316002)(1076003)(110136005)(107886003)(2616005)(4326008)(47076005)(36860700001)(81166007)(70586007)(70206006)(8936002)(54906003)(8676002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2022 08:28:30.2827
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 92b16e2b-9378-4ffe-086d-08d9f1ef7a81
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT014.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4508
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As a preparation for more advanced police offload in mlx5 (e.g.,
jumping to another chain when bandwidth is not exceeded), extend the
flow offload API with more tc-police parameters. Adjust existing
drivers to reject unsupported configurations.

Changes since v1:
  * Add one more strict validation for the control of drop/ok.

Jianbo Liu (2):
  net: flow_offload: add tc police action parameters
  flow_offload: reject offload for all drivers with invalid police
    parameters

 drivers/net/dsa/sja1105/sja1105_flower.c      | 27 +++++++++
 .../chelsio/cxgb4/cxgb4_tc_matchall.c         | 55 +++++++++++++++++++
 .../net/ethernet/freescale/enetc/enetc_qos.c  | 31 +++++++++++
 .../ethernet/marvell/octeontx2/nic/otx2_tc.c  | 54 ++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 27 +++++++++
 .../ethernet/mellanox/mlxsw/spectrum_flower.c | 27 +++++++++
 drivers/net/ethernet/mscc/ocelot_flower.c     | 28 ++++++++++
 drivers/net/ethernet/mscc/ocelot_net.c        | 27 +++++++++
 .../ethernet/netronome/nfp/flower/qos_conf.c  | 28 ++++++++++
 include/net/flow_offload.h                    | 19 +++++++
 include/net/tc_act/tc_police.h                | 30 ++++++++++
 net/sched/act_police.c                        | 46 ++++++++++++++++
 12 files changed, 399 insertions(+)

-- 
2.26.2

