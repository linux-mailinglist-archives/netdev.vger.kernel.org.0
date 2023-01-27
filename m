Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABB4C67EDAF
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 19:39:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233351AbjA0SjX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 13:39:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235051AbjA0SjW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 13:39:22 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2047.outbound.protection.outlook.com [40.107.237.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14F101448F;
        Fri, 27 Jan 2023 10:39:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CVZtmerk0HP7SgTYTtzVVldr2ugOHXKkO8xW7kXz478xNzHPJmK//tLZGsui4bQnNKqCJALJcHLrP+LMeBGiYQtPrTlyXWne9W0qSPwh8EKlKQdZgOss/LyurD8zolSvOzfceg/3kpgJ0Z8Zn9ANDgzPpuODGQefYQy48b/CqMLv71uPNYmJm0MEgMNRSzCLUVJmEZ9WWkXGsduOpa8OIGQn0gCLo9u21flfKhyhIbyT1DdwU0Bekqf5QLrqKwgI63OYtNdSxcztJWV2TdBdTYtRga2E9Mx9QS16mj6gHk3chhRSxNU5w1ii9Hn7J9pl3NYhiSYO/bA/3at43DelrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I+2WBzns9J30VcVXoKQxCv+O25C4UexQOgEBymUbmx8=;
 b=KxhSRZ7ComSdEOJxYVI9Az5MItklImcHDibIYh40qzhtL1wFf6eeIc3gPxf8o/j6OIxa7wZtp+g2HDSje6iGxHyMboC4w9q0MJVTbgghjMN/Tv9MCIAuL5HxMK/D4WQKil0mlPmiTsdaLibRsHez+ANKn6ZIQavEBfntjwQlAmTJVjCiyO8R9NZiLldhyVHXPxxsEoieAAvuI6Zy2Wbu0HG5Gy8RozjtscrrQ0spcCzUCkysoFD5zhyJJSXUdUZUcUJmhjWQizmt5XLSzjxuzkR9V2iDxypM1NHgTYLqePjM17z52cbec3ai/41NTf2KBxFeWkYvtBD874EJ3grOCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I+2WBzns9J30VcVXoKQxCv+O25C4UexQOgEBymUbmx8=;
 b=aVjiLFbL7jWBvzUMpL8pSHOMnlfiHW/rcAuFmi1OJG/S1RuFrOjL3B8OUnQErSPbGk9103xVkPblgg1+R2QxBuAmp27Cm3nvKJZ3vhzbXJWsoQbo20PXKZeIMBQIBfRTvS2kQ/4raDQpjiNx72ZI6FMrsCpPJDPf31QW7kQOVB4ROtqhZhgwr+5QZIwV10PNNkP9S1AQLIvCYySwOZXFINef3CTR5HktGD64YsoiizOuOdJCVBon2LF6Mf3CzJTliJL5jJx+49tpDzis5rzM8uep0btnBxLNY6fJ1h/mGpej6OkvFdKTf7te8txkXdPNx2wps4dBTfZEDS3U7NgwuA==
Received: from BN0PR02CA0042.namprd02.prod.outlook.com (2603:10b6:408:e5::17)
 by SJ0PR12MB5485.namprd12.prod.outlook.com (2603:10b6:a03:305::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22; Fri, 27 Jan
 2023 18:39:10 +0000
Received: from BN8NAM11FT044.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e5:cafe::9e) by BN0PR02CA0042.outlook.office365.com
 (2603:10b6:408:e5::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.25 via Frontend
 Transport; Fri, 27 Jan 2023 18:39:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT044.mail.protection.outlook.com (10.13.177.219) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.25 via Frontend Transport; Fri, 27 Jan 2023 18:39:09 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 27 Jan
 2023 10:38:58 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 27 Jan
 2023 10:38:58 -0800
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Fri, 27 Jan
 2023 10:38:55 -0800
From:   Vlad Buslov <vladbu@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <pablo@netfilter.org>
CC:     <netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <ozsh@nvidia.com>, <marcelo.leitner@gmail.com>,
        <simon.horman@corigine.com>, Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net-next v5 0/7] Allow offloading of UDP NEW connections via act_ct
Date:   Fri, 27 Jan 2023 19:38:38 +0100
Message-ID: <20230127183845.597861-1-vladbu@nvidia.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT044:EE_|SJ0PR12MB5485:EE_
X-MS-Office365-Filtering-Correlation-Id: d91037d1-a76f-4515-f02f-08db0095c720
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Yo/xj0UucvMRA+iQqQaOIcCMW6p9AFRtd+Rh9MQ3BX5/ioDYzx3eAvPvqAhpGlJ+oHMHVB6dP70rKI1uY/yYGFyK49Z1zqWB/CfwipARuzD/VRZCWSlT+HPxmULkk+ixpaP3C8rudsgzXAa0AZy0LpzrOoNnnE5QLV3Zi9Wn7w9hhYNI7maHWZ+cIdm4ykBqj/xz6jlTBk1bGgqtoVXhvucPURof7EC+sTkzEsicyljo5LORZUgKxlQDNI1yaVeexr8h2SugW2R2vurannKsEUOmpjTf8CKiZrfM0qvR+w28/XLwnSiRjb3XUP/WY3YG0CfY0ePo/VCkIVcB7aFLiRLaZmlVRMDFK5SMsuJXphG1klZGFiG+4a8M8U7eH0BxOXez09A66eZhXh/v5+zqZLasvE1ih5QBNcThcq7EMt7VOicRtyF++Oy4U7CYllp3pKeRJ4YRdhiQ+fRXjX/zIhBvnJsZfGQknQDkF5HMU49npJ+6Epf3T+/OqDjMM254VpSquD11n/eF57svh3u/D+w+7VyMU0Igy5aVo/fhF/dCQ2L+TY1OxbjCsZ/urpopjLd/eCluuLnUTTrpDkIsmbh0ukxfqPjlsI2Ev5tu7MdDfjZh1F8lP8nLFCSI/YEKq49mzZ4q7fOzi5vvqcv9GDqxiLQ34r/1glMJ42JxRhwZ2OnTnf7ALg5/Hgh4QBaBGhosbxtaISq3ZXEWS4mShg==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(376002)(39860400002)(136003)(396003)(346002)(451199018)(36840700001)(46966006)(40470700004)(356005)(70206006)(40460700003)(40480700001)(83380400001)(6666004)(107886003)(2616005)(26005)(336012)(186003)(316002)(478600001)(70586007)(8676002)(36860700001)(7696005)(7636003)(4326008)(54906003)(82740400003)(86362001)(1076003)(110136005)(47076005)(426003)(82310400005)(2906002)(5660300002)(7416002)(36756003)(41300700001)(8936002)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2023 18:39:09.2134
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d91037d1-a76f-4515-f02f-08db0095c720
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT044.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5485
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

- Add new flow_table flow "ext_data" field and use it in act_ct to track
  the ctinfo of offloaded flows instead of assuming that it is always
  "established".

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
  netfilter: flowtable: save ctinfo in flow_offload
  net/sched: act_ct: set ctinfo in meta action depending on ct state
  net/sched: act_ct: offload UDP NEW connections
  netfilter: nf_conntrack: allow early drop of offloaded UDP conns

 .../ethernet/mellanox/mlx5/core/en/tc_ct.c    |  4 +
 .../ethernet/netronome/nfp/flower/conntrack.c | 24 +++++
 include/net/netfilter/nf_flow_table.h         | 14 ++-
 net/netfilter/nf_conntrack_core.c             | 11 ++-
 net/netfilter/nf_flow_table_core.c            | 40 +++++---
 net/netfilter/nf_flow_table_inet.c            |  2 +-
 net/netfilter/nf_flow_table_ip.c              | 17 ++--
 net/netfilter/nf_flow_table_offload.c         | 18 ++--
 net/sched/act_ct.c                            | 99 +++++++++++++++----
 9 files changed, 174 insertions(+), 55 deletions(-)

-- 
2.38.1

