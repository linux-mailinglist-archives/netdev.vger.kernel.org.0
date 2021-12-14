Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DA8E474939
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 18:24:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236432AbhLNRYy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 12:24:54 -0500
Received: from mail-mw2nam12on2064.outbound.protection.outlook.com ([40.107.244.64]:42081
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231625AbhLNRYv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Dec 2021 12:24:51 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W8VdsvTWEoWNXidMoaOkqIpQBy/GFN1mbpPM8PeYeUCI2cr29Jxill1q+Dham07RMRT48iFhcpYvOLbRsqGh8r6dOzvFUJuomDjtQO4z9ZzlG4zFZsl+UazODepcyFF1L8Cmrcf8RoiVjizPAKayYpfccXWf26moF4qdaIns5sV8UKabMHK4fRKvjUOpx2+Tqivys/6xx41ZDHGvXYG+/8zKJAC5cuTz5N4VR0bAW3AdDp7AZpTivPtDiuij8bBoZVBXI5HgcGouSYcbk8B8f+WJsVM5zyGrnX6/Lt2vK8hwhnLPP2Z2fbeSdZlEHWnhnPBjvwGN+JVrwluXSJzHvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DUAsR4xy5RTdu3+ZpWFuxBDZZecWFdzDUvjRgnVk9Rw=;
 b=LBL8M++D2WZ3wFkHh2q8pqu6elicVcCpN0qcY6uO3h60MU2pDcbfBxbMx8+JIhCnc1LFQnntuRL1fKswRZeKDvENTblrIp9vdFjKn6OllfT7mfc15bbC5C4ICaxD0GwpKKE92CcDAqPWCjyLveWGKeusRO1dMeSROnSxhOMUm02BXiRPpeeFoUqZMotJ9fy1zH26ig0Ithg4ytnGycEfUbqiTzm7ABAwxf2KH02qSuMvIwI3e208nqe2VWsI9F/AS7q8c8C7nH0ttY5aArcd39n/x5PJyqMdolysTuyCi9ghT9WvXvKCbni/FrT+RGOS1IWueF/uDCo2sOLo55fmfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 203.18.50.13) smtp.rcpttodomain=ovn.org smtp.mailfrom=nvidia.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DUAsR4xy5RTdu3+ZpWFuxBDZZecWFdzDUvjRgnVk9Rw=;
 b=lFS6Do4v+YuKH6pGqHHGBuZDTStAoZsOcSXsXl7NeFfNqqBjZLfdOSvo+eKkcdZG2hLMigkXvyNhFgX8VJCYbjrHchc4Uy1mzAZlW2L0KlgeNH+KfCwyvgGj6bQpxqXMfxsMkiRMAk3srL/Ln8cXK+5QOFLU/muLKvPZnbkF982hTGsliRintBKcxKoweEleQkLaun71NRkxneSTNQA43rt1NyyZKEI7LCURqhNQsERZROnHlD5LfKHVtOkXyzxT3cOZdoPFxsuk+VyyyVbKfQW82Zi7LflgDspLQ+6401Y6oefcVF1os5RPRBdE6h4zYRUvG4vvHNxrGJIE11+gQQ==
Received: from MW4PR03CA0275.namprd03.prod.outlook.com (2603:10b6:303:b5::10)
 by BY5PR12MB4145.namprd12.prod.outlook.com (2603:10b6:a03:212::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.13; Tue, 14 Dec
 2021 17:24:50 +0000
Received: from CO1NAM11FT046.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b5:cafe::97) by MW4PR03CA0275.outlook.office365.com
 (2603:10b6:303:b5::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.14 via Frontend
 Transport; Tue, 14 Dec 2021 17:24:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 203.18.50.13)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 203.18.50.13 as permitted sender) receiver=protection.outlook.com;
 client-ip=203.18.50.13; helo=mail.nvidia.com;
Received: from mail.nvidia.com (203.18.50.13) by
 CO1NAM11FT046.mail.protection.outlook.com (10.13.174.203) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4778.13 via Frontend Transport; Tue, 14 Dec 2021 17:24:49 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HKMAIL102.nvidia.com
 (10.18.16.11) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 14 Dec
 2021 17:24:47 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 14 Dec
 2021 17:24:45 +0000
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (172.20.187.6) by
 mail.nvidia.com (172.20.187.10) with Microsoft SMTP Server id 15.0.1497.18
 via Frontend Transport; Tue, 14 Dec 2021 17:24:41 +0000
From:   Paul Blakey <paulb@nvidia.com>
To:     Paul Blakey <paulb@nvidia.com>, <dev@openvswitch.org>,
        <netdev@vger.kernel.org>, Saeed Mahameed <saeedm@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "Pravin B Shelar" <pshelar@ovn.org>, <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>, wenxu <wenxu@ucloud.cn>,
        Jakub Kicinski <kuba@kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
CC:     Oz Shlomo <ozsh@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Roi Dayan <roid@nvidia.com>
Subject: [PATCH net v3 0/3] net/sched: Fix ct zone matching for invalid conntrack state
Date:   Tue, 14 Dec 2021 19:24:32 +0200
Message-ID: <20211214172435.24207-1-paulb@nvidia.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 72c2ca7a-554b-4737-cdeb-08d9bf26a21d
X-MS-TrafficTypeDiagnostic: BY5PR12MB4145:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB4145FAECF40C9AC548C57E14C2759@BY5PR12MB4145.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kLxZYeYAZejGNPfrAy+JCcm4wlyjQXtAxmO+5SxWJaUbd7UB87VnzQNFGzEmPd1qMJT7JM5L5CGIt1KXxCVTrCr4dC62LyN2Kt6LdxWVRqALyxrigmaP+5tybSX8l1OTSIYf9W+WGxRogvXXM4ebe+a3kAnypSGQhIcKHxLIP0SwBDxdFsEkje4eD1MVDe2d6TbR2zcmPqHKo7FS36+6yv3T+Zfk33MCedYU18CsqMaw8Jq4ixqFf/SZ0SucAFur+vhgyx63Mv920UK3/MG3U4EhyJrQvVvn/+lQU0Gl12uyEwhSYHOB6kSM7/q+TJy2Ludyk+s1TbdmJ+fv2L9tCbMcOd2odsg49jifX/SuY3Rid5fTLKi/ejyYplJ5s2KIqhUO+fGVHlHQl3QQMF29gSpvfkUoJAMGU6q/GDogl9qoRFLDnJQaUm+s6kNNW+FHbPO4jtuNkOjMe4d5e16BNSiYiq8CONWHGMdz4Vef1NUQTQHZHOQtaQdzfLiMbagDOJ4+fn0CsYkOnNkhj/OdIaal7fyfy976Mq12r9WK7lVJ3yMrwRTlLyCr44J1zltdE0e/vzUMJTrQUhKAkIHSMPVbPVU1QydQxbnwtTOXS3BFp0gDSe6Rqcrahs374JLg+8xS5yixWsQoZX1aFoSe84Q4xyhUnG7XhZyUqCPo9KODZga5H2EzRGIwZ7vC+O/5Sitgnb5IJSSzmTmOKO2cmsOUEOntXJmqYXwISb/abw3YqwUq1d8IoHK3anEjX8AWEfo/r/+f3kg18dRECfcW7jahTfTl5NH84P8hy/e8gcxmkgKJwkjJ8ZZUl3t4CCwp
X-Forefront-Antispam-Report: CIP:203.18.50.13;CTRY:HK;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:hkhybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(40470700001)(508600001)(47076005)(5660300002)(83380400001)(36756003)(36860700001)(54906003)(26005)(1076003)(316002)(34020700004)(356005)(82310400004)(8676002)(336012)(86362001)(2906002)(107886003)(40460700001)(186003)(2616005)(6666004)(8936002)(70586007)(7636003)(921005)(70206006)(426003)(110136005)(4326008);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2021 17:24:49.5723
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 72c2ca7a-554b-4737-cdeb-08d9bf26a21d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[203.18.50.13];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT046.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4145
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Currently, when a packet is marked as invalid conntrack_in in act_ct,
post_ct will be set, and connection info (nf_conn) will be removed
from the skb. Later openvswitch and flower matching will parse this
as ct_state=+trk+inv. But because the connection info is missing,
there is also no zone info to match against even though the packet
is tracked.

This series fixes that, by passing the last executed zone by act_ct.
The zone info is passed along from act_ct to the ct flow dissector
(used by flower to extract zone info) and to ovs, the same way as post_ct
is passed, via qdisc layer skb cb to dissector, and via skb extension
to OVS.

Since adding any more data to qdisc skb cb, there will be no room 
for BPF skb cb to extend it and stay under skb->cb size, this series
moves the tc related info from within qdisc skb cb to a tc specific cb
that also extends it.

---
Changelog:
	v3->v2:
	  Moved tc skb cb details from dissector back to flower
	v1->v2:
	  Cover letter wording
	  Added blamed CCs

Paul Blakey (3):
  net/sched: Extend qdisc control block with tc control block
  net/sched: flow_dissector: Fix matching on zone id for invalid conns
  net: openvswitch: Fix matching zone id for invalid conns arriving from tc

 include/linux/skbuff.h    |  3 ++-
 include/net/pkt_sched.h   | 16 ++++++++++++++++
 include/net/sch_generic.h |  2 --
 net/core/dev.c            |  8 ++++----
 net/core/flow_dissector.c |  3 ++-
 net/openvswitch/flow.c    |  8 +++++++-
 net/sched/act_ct.c        | 15 ++++++++-------
 net/sched/cls_api.c       |  7 +++++--
 net/sched/cls_flower.c    |  6 ++++--
 net/sched/sch_frag.c      |  3 ++-
 10 files changed, 50 insertions(+), 21 deletions(-)

-- 
2.30.1

