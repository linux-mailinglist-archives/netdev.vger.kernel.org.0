Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A4DB6641DC
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 14:31:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233351AbjAJNb1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 08:31:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbjAJNbX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 08:31:23 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2081.outbound.protection.outlook.com [40.107.94.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8337EB8B;
        Tue, 10 Jan 2023 05:31:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MiFt1WIBnZfWsz9maLgADmoE/S0ikubicDW2bSr1hbGQEWlb5YoG6bhEZKm7k74aap4oLdjRkEFGb9sGw44Bs/MhVkjYwRgPInOeI1JaLkvO8XjIzF4JzEx3vPa48RHzf9sm6BJZSmEX+sMR55PglDcEmAK7GHrMJgXd3dcMAHq9KQ24HlIpJHA0wbQhWagRSUd3bOdBmv6lvTfWeTESYb3zlVwWS9nuxXrDodn778VmZM61y3kvKguHTXZZVukcBtke7rf9idiALfkbLFL+aK5fnbcS+ifk1ASnJNMyrx0KIsGbodF0AcsYbQ0CdOIgXjm1e5Ef40aRr1B9P2/Ppg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xvgu5dqIF8GXdHXj1qO1v2NpgK8tO7JdH5A73On0J+o=;
 b=YPRoJQiWdEt88NQr3OGjcW8h/eKO1fVAj3TcdRuqQUVV4bSVUl881cUnt72aJ6p/s2kF73WyIIAdh4sbUZV7eDN83mgPnIiwcYlowK/R3EELYwvQInmmNfTiLboPQDu6n8bQUvoh5JXW40+UuSySTb+zD8qtgcRhQm9cGm4be7Sh0SFLU+RzNRRrpo9wPhCEo8pTR9atq5l3DDRw3IRjyZB45DGA7IlZo13oDsND929opIaN8Q3Hznox7+75Sl44H0Jc3sSf/mO0eX0Z/zmksXhN2Frcak9vDEMhOMx9yzGeRIoI/LhoLfYn/OPlX3/pbf/+/50m2e47aCCulRVKEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xvgu5dqIF8GXdHXj1qO1v2NpgK8tO7JdH5A73On0J+o=;
 b=CCISGpIrC7Crjz4MMOFTIUDj9et0LZrMnFQKnCd/a8vaeXCUtisZ//M2/ilPqaxWQmM+UIqvFEe+jNmzXDLe8IELDdlt3ti8/HRino5wVVJRs6QdRIl1tQhdCCdE0uSdVzDTweLvCnQaKXS44QIkKpgjgi0FivleumIxV3NX6G6GMcMMR8NLQXsw0EqzSFl1Tg4Rc5GRYaibVZW6Du9jzAX0Kp8tD17sPuItG4uuoLlalDL1JAGkGtgisKuHPVObTIU1KsPj6cbMkx+WZDL4OVSOTsXTQD/j7knCkEI7rN7JvyYijzeSMT5rPwCUwnVBv2olMfr62aBQ8JR2atw1mA==
Received: from BN8PR04CA0045.namprd04.prod.outlook.com (2603:10b6:408:d4::19)
 by CY5PR12MB6624.namprd12.prod.outlook.com (2603:10b6:930:40::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Tue, 10 Jan
 2023 13:31:20 +0000
Received: from BN8NAM11FT099.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:d4:cafe::de) by BN8PR04CA0045.outlook.office365.com
 (2603:10b6:408:d4::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18 via Frontend
 Transport; Tue, 10 Jan 2023 13:31:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT099.mail.protection.outlook.com (10.13.177.197) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5986.18 via Frontend Transport; Tue, 10 Jan 2023 13:31:19 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 10 Jan
 2023 05:30:58 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 10 Jan
 2023 05:30:58 -0800
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Tue, 10 Jan
 2023 05:30:55 -0800
From:   Vlad Buslov <vladbu@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <pablo@netfilter.org>
CC:     <netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <ozsh@nvidia.com>, <marcelo.leitner@gmail.com>,
        <simon.horman@corigine.com>, Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net-next v1 0/7] Allow offloading of UDP NEW connections via act_ct
Date:   Tue, 10 Jan 2023 14:30:16 +0100
Message-ID: <20230110133023.2366381-1-vladbu@nvidia.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT099:EE_|CY5PR12MB6624:EE_
X-MS-Office365-Filtering-Correlation-Id: 7331e3da-c507-489b-ab4b-08daf30ef561
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SjcnJrayqPy5fI9T8HLpMIvPvGMvhkjNbwGSE1b8szyRu1u1cdYmzUtZs1Dad9JHPMv8+Cft4UBNbdXh+NnN5lkq+RwMmXOMzBKlUo3UjV35HOhbW8QRTkvPio5uix+hDSr5UFAuh2qHqZvP1X26SoanNA9c5oCof42IWidrQ4/eEj96BarzfKDQI54x17RZVHcLf+GBGXqxQtSDBUNTz2L0IwJtINWcIdXMkzFIdRvYegPVqVn+XuBx3YYQHiYTxBgW2+gi0BL35QW3JTYh3BV8hT8gWLRS1wTp9pmeIQE1kUrJkklOEaIux7kHDJ9lLCOrY2n+NbWaON+fNedoipIMcTtdwkQVnmwmtaAnGZD2aSFO03meJLq0DIF0DkbR7sWnE1d3BzVCf4ykwl/4KMNX8N2btiPvtCp4Oy5rinFPiVuKTcU4TH2DIBtQbmcXpnkqJL09CukBKAyqA5E5p5JV7/l50lpkvsiH+S/yP0qa5Hcu0GYKZXPHgJBVKaIhDz2ojzVCTpKApX274bKeuCRxmaohpXpYpJG8T87TYH1cYxwsI9/ni9JphadbKQP6mTfkC+MvUKLIjq4MtJgr0GIRVT8ew2rTaRgvkY5Mo1drgev6dO6y/hsiMOvYHEDRx/hOabQNKj+GoIYBYKTUxwC6QBdCj5/hfq5kh8BpjMK3LxIXpAk4Mz+lGFO+CrfPSEX2rmJYq+4vsu9qfidm38gJEHkX9k5RVIFIBazr83U=
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(39860400002)(346002)(376002)(451199015)(36840700001)(40470700004)(46966006)(1076003)(7416002)(316002)(40480700001)(5660300002)(26005)(7696005)(186003)(478600001)(2616005)(47076005)(426003)(40460700003)(41300700001)(110136005)(54906003)(70586007)(4326008)(70206006)(336012)(8676002)(82310400005)(8936002)(83380400001)(86362001)(36756003)(6666004)(107886003)(36860700001)(82740400003)(2906002)(356005)(7636003)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2023 13:31:19.6225
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7331e3da-c507-489b-ab4b-08daf30ef561
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT099.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6624
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

- CT meta action metadata doesn't store ctinfo as "established" or
"established replied" is assumed depending on the direction. Explicitly
provide ctinfo as a new structure field and modify act_ct to set it
according to current connection state.

- Fix flow_table offload fixup algorithm to calculate flow timeout
according to current connection state instead of hardcoded "established"
value.

- Add new flow_table flow flag that designates bidirectional connections
instead of assuming it and hardcoding hardware offload of every flow in
both directions.

- Add new flow_table flow flag that marks the flow for asynchronous update.
Hardware offload state of such flows is updated by gc task by leveraging
existing flow 'refresh' code.

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

 .../ethernet/mellanox/mlx5/core/en/tc_ct.c    |  2 +-
 .../ethernet/netronome/nfp/flower/conntrack.c | 20 +++++++
 include/net/flow_offload.h                    |  1 +
 include/net/netfilter/nf_flow_table.h         |  4 +-
 net/netfilter/nf_conntrack_core.c             | 11 ++--
 net/netfilter/nf_flow_table_core.c            | 25 +++++++--
 net/netfilter/nf_flow_table_offload.c         | 17 ++++--
 net/sched/act_ct.c                            | 56 ++++++++++++++-----
 8 files changed, 103 insertions(+), 33 deletions(-)

-- 
2.38.1

