Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 821A067431B
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 20:51:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbjASTvo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 14:51:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbjASTvn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 14:51:43 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2063.outbound.protection.outlook.com [40.107.101.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77BCC75A0C;
        Thu, 19 Jan 2023 11:51:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ThjpBDYksoGm6YXPFAK3UsdcGQOKXdx69eACeoMvUggZUXdsd7i/cfPbiDQa+WYfvqlgpAz008CTiRmX7Ox+IYdsa4uADuYMli/YYx/XYsLaaOLd/yVmjMLUPWyf7eIRMic+hLSmlxKlysSYz2+S41ERty06RagmlbmALY0IqiJ9Ob8Rvx81VMI+Qaz7S/R5X9k5Gm3Dz8qddd4TlnzkY3YdTTVFJzSS/X3s8NHIadRkboAdZphHmfY+DMIJ4zM1FVBuhXOCf6UPxcxmun0pGAy2DCWc8AJBBjr3EO4y3+bK4oulIPmtTI44Gizb2XDJGD3FkIbgrEJY7A1TU7AZWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ztbpgkJO2OiMyvP7ww87YCGntZkeU+hYfYccarCo2nc=;
 b=P0UrFZ9gg5ReAVMFcJmNd43OHqLkeZ/JJxjRm7iXC2MezbN9wGKc9R9jtwz+z3kGo2WKU4wek5rrEmXMhxrHGhv1m3n0x2GE7q4zTjMl/gR4B0fRPm4yTaieDXxrPRFKQs9l8wmPytyjr/KfrqYiXMfGit6/ZRdXT1lSqRJTGnA6lqvOSuTHMH727KwRKNCrZ+85LMeH8TuwqtSO5PyTp5uQ+cgkrNA+HC1WCe6Hy3I5k/ViEQZSQnRQxwt/I8JFIfzIAEm1FMOxEzMOP2FnPLNtpEf0evdBEnm7Jx5w4J9IrZucVURNxohzOVErcCEfcocpSjJ8osVNHrl21R8Awg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ztbpgkJO2OiMyvP7ww87YCGntZkeU+hYfYccarCo2nc=;
 b=RMkZQOO4pxaJvdiqpfy9p4wRtb8E4g5v1XMg4FvnzCTANC4LMgQ7krob/79604jdXyZ8rvXgFPTnYzi10zB9nqmsCiec1ZlJT+bmtUMbTEarOVvTFyQU1mlel+9+l+48jEMAXhq83hWSQcVcGHa86y9ZtjYAeGmCzVePkegtoCoEJUVL6ekMJIafiK4zzlvoHZw+I+hhb6C7BKXOcAKeu+ZARcC91DX2orT5R9E4KHspcRajH3Nky18kgpRDzzfOnPruIL/njKG/DFNsdNiiqMjefjChnhw0NxAmnznvC7TrZotSm4fyF88M4L4+B0fWDXSCkE2a4AA2Isr0gaUOKA==
Received: from BN9PR03CA0620.namprd03.prod.outlook.com (2603:10b6:408:106::25)
 by BL0PR12MB4932.namprd12.prod.outlook.com (2603:10b6:208:1c2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.24; Thu, 19 Jan
 2023 19:51:40 +0000
Received: from BN8NAM11FT087.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:106:cafe::c2) by BN9PR03CA0620.outlook.office365.com
 (2603:10b6:408:106::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.26 via Frontend
 Transport; Thu, 19 Jan 2023 19:51:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN8NAM11FT087.mail.protection.outlook.com (10.13.177.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6023.16 via Frontend Transport; Thu, 19 Jan 2023 19:51:39 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 19 Jan
 2023 11:51:23 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 19 Jan
 2023 11:51:23 -0800
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Thu, 19 Jan
 2023 11:51:20 -0800
From:   Vlad Buslov <vladbu@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <pablo@netfilter.org>
CC:     <netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <ozsh@nvidia.com>, <marcelo.leitner@gmail.com>,
        <simon.horman@corigine.com>, Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net-next v3 0/7] Allow offloading of UDP NEW connections via act_ct
Date:   Thu, 19 Jan 2023 20:50:57 +0100
Message-ID: <20230119195104.3371966-1-vladbu@nvidia.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT087:EE_|BL0PR12MB4932:EE_
X-MS-Office365-Filtering-Correlation-Id: 7705c503-74fc-41a2-eddc-08dafa569510
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GugVGL84Ps50Qhih5Op7d2xQ6XmN1ENQcUkPZsdIpKuLJbvDPJzElwOnJ3Ed2H4n/q8aHekpJYUX1qqwOu7LAr/ncjwOL+AhkTxPxpWSmXmsGCpZ7ZF8BgKGGudVHJHrx1xyDKYCqVAZV7iPnmVwnjEbOG7dV/MPUhgsHhMeLLaJWbNiK08KSEsa+HVsvE9Wx0h750FLFedKDM9X9wpJHnrn7Lk062wWKjIUbaTeVp+p8fqYbNIi86lmO6eQQcNZdW8Ac6331xpYK9bSgZFi6iXIyzEveQm+eYSr0U5lW024oUH+3joklfDDhOWW+HTqRm+8EWPkHTTnsGTKo4oVNG4XLclfGqtuddvYw7tNh1l9Mbk9lbxqZZnXRU72tiHzn5THfEZh81kiIM4Gi7zWenX1GT99rrN5jf1yUJgmzVTst+4CAaA+PNSgoj/+Chr44rcLStyA5FnPHcHLTYshYc+vhWmFRLiw+fmoV+4maJofYx4myNRfyZV6vekVDfbyCFaOZuaBqJuNWjldyFbQ88om8LE5IQfHCIZYiXPDZ5CZagvghH7l1vKMwwnesA3Fd41sfY+lPFNAETz/gNNx3xfgmDBUSRo9WRGssNiOn7KrV1xaxGO+Gas8Mf4gsaIF2t8+6hDWvwxQzKfVNujNE4Um7Gvta7AqHzDh3qL4GYPgthDNLTi7WG8kLGX/vh1P
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(376002)(396003)(346002)(451199015)(46966006)(36840700001)(356005)(86362001)(70586007)(70206006)(2906002)(7416002)(8936002)(5660300002)(7636003)(36860700001)(82740400003)(478600001)(110136005)(316002)(7696005)(54906003)(107886003)(426003)(6666004)(47076005)(36756003)(26005)(40480700001)(8676002)(4326008)(1076003)(41300700001)(336012)(82310400005)(2616005)(186003)(83380400001)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2023 19:51:39.9517
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7705c503-74fc-41a2-eddc-08dafa569510
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT087.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4932
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently only bidirectional established connections can be offloaded
via act_ct. Such approach allows to hardcode a lot of assumptions into
act_ct, flow_table and flow_offload intermediate layer codes. In order
to enabled offloading of unidirectional UDP NEW connections start with
incrementally changing the following assumptions:

- Drivers assume that only established connections are offloaded and
  don't support updating existing connections. Extract ctinfo from meta
  action cookie and refuse offloading of new connections in the drivers.

- Fix flow_table offload fixup algorithm to calculate flow timeout
  according to current connection state instead of hardcoded
  "established" value.

- Add new flow_table flow flag that designates bidirectional connections
  instead of assuming it and hardcoding hardware offload of every flow
  in both directions.

- Add new flow_table flow flag that marks the flow for asynchronous
  update. Hardware offload state of such flows is updated by gc task by
  leveraging existing flow 'refresh' code.

With all the necessary infrastructure in place modify act_ct to offload
UDP NEW as unidirectional connection. Pass reply direction traffic to CT
and promote connection to bidirectional when UDP connection state
changes to "assured". Rely on refresh mechanism to propagate connection
state change to supporting drivers.

Note that early drop algorithm that is designed to free up some space in
connection tracking table when it becomes full (by randomly deleting up
to 5% of non-established connections) currently ignores connections
marked as "offloaded". Now, with UDP NEW connections becoming
"offloaded" it could allow malicious user to perform DoS attack by
filling the table with non-droppable UDP NEW connections by sending just
one packet in single direction. To prevent such scenario change early
drop algorithm to also consider "offloaded" connections for deletion.

Vlad Buslov (7):
  net: flow_offload: provision conntrack info in ct_metadata
  netfilter: flowtable: fixup UDP timeout depending on ct state
  netfilter: flowtable: allow unidirectional rules
  netfilter: flowtable: allow updating offloaded rules asynchronously
  net/sched: act_ct: set ctinfo in meta action depending on ct state
  net/sched: act_ct: offload UDP NEW connections
  netfilter: nf_conntrack: allow early drop of offloaded UDP conns

 .../ethernet/mellanox/mlx5/core/en/tc_ct.c    |  4 +-
 .../ethernet/netronome/nfp/flower/conntrack.c | 24 ++++++++
 include/net/netfilter/nf_flow_table.h         |  4 +-
 net/netfilter/nf_conntrack_core.c             | 11 ++--
 net/netfilter/nf_flow_table_core.c            | 25 +++++++--
 net/netfilter/nf_flow_table_offload.c         | 17 ++++--
 net/sched/act_ct.c                            | 55 ++++++++++++++-----
 7 files changed, 107 insertions(+), 33 deletions(-)

-- 
2.38.1

