Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7742C46E391
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 08:57:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234118AbhLIIBT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 03:01:19 -0500
Received: from mail-dm6nam11on2063.outbound.protection.outlook.com ([40.107.223.63]:40800
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230042AbhLIIBS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Dec 2021 03:01:18 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vic4xUzSVlU0PEIzrskmHjflpa2t8gKxpJR/5HB616BlQWZvJ46IaqKOzQyHXJIsDw0I1Xv/i5RpoltV06NmFaEVSdrsAQUlSVoKMPZTULCDLYM91UQguyDFmzY/szYUPnL2o9ywUPIvYka+KYIV5qC72AnX/VBje3tmOrZXukXlMcWSANwU+4vNa63bmM3FXI+E4po8wkv9bOrVQWy6DcSqK5d/85vPtmyD/FP0ekKBqdS8zwDKarFhwk8kPKAmYC8JEokPQqiyfPWQoL0l1c1vNDxQdl/4639gJO4//djgJKyvM/jd6DgLYDnClGSRGrFl/r7iz0oYIWhtO9u51g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=McYMyKqESpSKuPoKCqaIh9ZV32lL/ZUkGfub+uBhNYI=;
 b=mSh1KrXQ3VFw/hA20epFF6SpbdFwZd3RGf0wogFCQbuilfA2ZlP4vaR5t/DL+7kmxOdi9u5Kc60oyStl7Na446yxB0aweNwlbhB0yeiigwusdFO9IpE1aDdWNdcNjDIxpt3OCrzhGBnsvEWCkKqIecnvuLhGp22Seg40fOdkmFZCmqH9IkuwXO7sMMopoLXuSLY3S/Qn+i210/jgJMcoIKufC9wdQJm9TwWrmU7AKKQ3m9BHrwz8U10QW08/JjN31TGbEoLXGs0LPa+uZA4SZPXOzYw2c6K+UP1gJ/DmSIVbP0WGiSJhsTfKH5KyPnQMKbXHn+FBmHJZMk8AElAeZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 203.18.50.12) smtp.rcpttodomain=ovn.org smtp.mailfrom=nvidia.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=McYMyKqESpSKuPoKCqaIh9ZV32lL/ZUkGfub+uBhNYI=;
 b=RSAU0MESfyuJlwFgeN20G6AyqtN6sc2hSfEK43RevnPgYK19LAm98dXGe7JBJS6h+NRf6P/1JqxROHB1MGlq74pxxbdIqEdY5PTlA9z5fyl6VRe5nu1kh7Zu2o+Zwjd/Oj/f2LWm5jncQogo1H35pf9c15kU8wAwrgb2XAjBRvtHERQCBRt227qwaoMPXTFXXWEbGhXL9DcK9d8cEAX5+/sCRC5soTwV3OfBHOJLzkD0Ca83ySGBugkBSdct+zR67Fv+1rNSSmChr1qcuk+9mid90lWTDMAXK89D0n/b+2RtQ57nd0id3OZIGwnhhGbWH2l2u6TTYojGAc0UhxZ8tg==
Received: from BN9PR03CA0331.namprd03.prod.outlook.com (2603:10b6:408:f6::6)
 by MN2PR12MB2957.namprd12.prod.outlook.com (2603:10b6:208:100::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Thu, 9 Dec
 2021 07:57:42 +0000
Received: from BN8NAM11FT021.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f6:cafe::be) by BN9PR03CA0331.outlook.office365.com
 (2603:10b6:408:f6::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.22 via Frontend
 Transport; Thu, 9 Dec 2021 07:57:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 203.18.50.12)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 203.18.50.12 as permitted sender) receiver=protection.outlook.com;
 client-ip=203.18.50.12; helo=mail.nvidia.com;
Received: from mail.nvidia.com (203.18.50.12) by
 BN8NAM11FT021.mail.protection.outlook.com (10.13.177.114) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4755.13 via Frontend Transport; Thu, 9 Dec 2021 07:57:42 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HKMAIL101.nvidia.com
 (10.18.16.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 9 Dec
 2021 07:57:41 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 9 Dec
 2021 07:57:39 +0000
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (172.20.187.5) by
 mail.nvidia.com (172.20.187.18) with Microsoft SMTP Server id 15.0.1497.18
 via Frontend Transport; Thu, 9 Dec 2021 07:57:36 +0000
From:   Paul Blakey <paulb@nvidia.com>
To:     Paul Blakey <paulb@nvidia.com>, <dev@openvswitch.org>,
        <netdev@vger.kernel.org>, Saeed Mahameed <saeedm@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "Pravin B Shelar" <pshelar@ovn.org>, <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>, wenxu <wenxu@ucloud.cn>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
CC:     Oz Shlomo <ozsh@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Roi Dayan <roid@nvidia.com>
Subject: [PATCH net v2 0/3] net/sched: Fix ct zone matching for invalid conntrack state
Date:   Thu, 9 Dec 2021 09:57:31 +0200
Message-ID: <20211209075734.10199-1-paulb@nvidia.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c6517d1f-e3d6-433b-05cb-08d9bae99447
X-MS-TrafficTypeDiagnostic: MN2PR12MB2957:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB2957CD074812B1021D7F8BC4C2709@MN2PR12MB2957.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hc5HYzKDn7AWtgqvRMy5u3QKrvHGNr2BEDfjSC1Dlo0UEQORQzKaaqd1zLuZJGmJurArlv50O8tR4fFXb8+5mKdnZ2YBllnVgIkPTawK7/JD+r4JD8gDV+UJOK2uxfMXBxgh9Fnx0QYZ1Xxk9MNyPhDxXAfqSFuKW99CQkw3NscMr2lHKlvo6WCKSHy7Qh8irJWDCgiU2hrTU2wJ9WCer4P0sj48LU3w48ZwwcZSrVx0rBSyrKo2X0I/rCEhF9jAf3TaZfRfpr98hbisqVce5ppm9sFiUXBcQUAj3KUIJuGP9vsRv/1P1kUQO/a4ZNHwJbWExy1zMxcfAWjrq+p1vXZSxIMURqc9gthOubqd6G8TaGR55HGwG9Oedy3uuItgpKCRy6czjgijsBZ/rXgZdlkqjw7kT0GQpT9AUAkKwlhXTy1EAiShqklUU248pgBSuMI9g2ozb0M67wrpyamO9z3mYmx5IpRrWza6D7fwIFlc9JVCfS5M+AhOsY1Hzelr/tmKX77ho5lQcxIUBOAIiNvjY7jvUQ/8AT2mEvuof2P9LmK6BPigN7Awj3lpH/YTR7qpS414xPc50QpepaWoMY8Ii4cgOqFmlHQFWSOfPGWKAr+VicWVUJpdty5JxGGFwN3nVbnYNxx3uCl2LGIemYKOTbQxKonmMkDbZZDC4C5h9UeWOh+Nz1eugZE65d1ROoNYOm21S8aC127eVkZN7FPiJxY/tCv+OgYor6nZ5IoA7MvQc6RUDhlZ2RLDjAsSFHIx/UFavl7ElbXArLO/hI3gaodqV9i8qGbSp3BKZ5d/3InghxsbVWnaLjN4fJUa
X-Forefront-Antispam-Report: CIP:203.18.50.12;CTRY:HK;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:hkhybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(40470700001)(8936002)(2616005)(7636003)(83380400001)(508600001)(8676002)(86362001)(40460700001)(36860700001)(356005)(2906002)(186003)(54906003)(1076003)(426003)(70206006)(5660300002)(4326008)(36756003)(336012)(6666004)(70586007)(82310400004)(107886003)(34070700002)(110136005)(47076005)(921005)(316002)(26005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2021 07:57:42.1840
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c6517d1f-e3d6-433b-05cb-08d9bae99447
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[203.18.50.12];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT021.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB2957
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
	1->2:
	  Cover letter wording
	  Added blamed CCs

Paul Blakey (3):
  net/sched: Extend qdisc control block with tc control block
  net/sched: flow_dissector: Fix matching on zone id for invalid conns
  net: openvswitch: Fix matching zone id for invalid conns arriving from tc

 include/linux/skbuff.h    |  4 ++--
 include/net/pkt_sched.h   | 16 ++++++++++++++++
 include/net/sch_generic.h |  2 --
 net/core/dev.c            |  8 ++++----
 net/core/flow_dissector.c |  6 +++++-
 net/openvswitch/flow.c    |  8 +++++++-
 net/sched/act_ct.c        | 15 ++++++++-------
 net/sched/cls_api.c       |  7 +++++--
 net/sched/cls_flower.c    |  6 +++---
 net/sched/sch_frag.c      |  3 ++-
 10 files changed, 52 insertions(+), 23 deletions(-)

-- 
2.30.1

