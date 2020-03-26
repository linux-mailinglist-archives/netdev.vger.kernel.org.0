Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91256194969
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 21:46:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727495AbgCZUqa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 16:46:30 -0400
Received: from mail-eopbgr80041.outbound.protection.outlook.com ([40.107.8.41]:8149
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726034AbgCZUqa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Mar 2020 16:46:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zi8bSTwJuey3sgbKvRC/ArA3wqxjyUE7qKlaF40CptHFu0POEwuSsH9GfpePhjlM//k4hgrdQ251VcssdGUJ9cGKhkofOIhlPtufRlQ5iyf67kp5XniSWX8xfFGnBh0lBcaUM3IwD4PdxnY5XLB9RgApYidwzY1i1zOFDFzaArcDL6ObeCbo/zkigIDOEEgRmJN4bFv9Gprw8+eUKJLsu1ZPEOfOmmeJqpKNQ5D+9l0h1TvloCCOQlwfY6iu4lBzbLDHe1tjBSxPCYQduP/rnj/G+O81G1EODdn9ng/2yt/18wktIETjWVyPJjguyo9uJ8TaUW4fM2T/aE5tJYb+lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YbSAPWYFZOIuDUoLm4JyydWzVd0Vnb8bvjghm4BwbHI=;
 b=DZ/bnVfFaTRUk8Bkn0+NwFPBb79T5mHlAK1TUDsD8ntvZrqIC+JRPUPZwV0Wd0UyYMGuNfYdn6TtPdjC3C9AOaTxCyxTb0JJ0UvIGELSdUPtS9uZpCE0xEFZ4vLMakg92WmH0aV5JSeHFGhQGOXh6xvIhE6gTjly5yQZo341cM5syGdyZfbQPH5IMv2fV2AhXN5w2XD7Kq/90lJDn5t/wIB3VmO8+0uwDumrjumBY44sWza0QddmmEWMKRzXEyfpo5rKUclpvHsk/WPzvTDJLx1AJBnTvleZK8D2IoMPuu0P7L+O4dypN8kfj7suMurZegWo75vZ5t6vBCRL/a+fyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YbSAPWYFZOIuDUoLm4JyydWzVd0Vnb8bvjghm4BwbHI=;
 b=RPvJeyt2Gg9RuJAKbfpVkkts8Mt2sSBr7aLBPay4O1eEDE3Nc3T4FCX2A0rCMyN+OVq6wDnfuZhOrfACQ1LutNzVgIvwFy560mpN9BBOA+raszB5fXFRocerJpdAvseZ9N7dzXz7gw/jEnsCqj+L8Ohhr1YRNX5CyZNBPl2VRkM=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=petrm@mellanox.com; 
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (20.176.168.150) by
 AM6SPR01MB0020.eurprd05.prod.outlook.com (20.177.39.223) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2856.18; Thu, 26 Mar 2020 20:46:26 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::e9a8:7b1c:f82a:865b]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::e9a8:7b1c:f82a:865b%6]) with mapi id 15.20.2835.023; Thu, 26 Mar 2020
 20:46:25 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>,
        Petr Machata <petrm@mellanox.com>, idosch@mellanox.com,
        jiri@mellanox.com, alexpe@mellanox.com
Subject: [PATCH net-next 0/3] Implement stats_update callback for pedit and skbedit
Date:   Thu, 26 Mar 2020 22:45:54 +0200
Message-Id: <cover.1585255467.git.petrm@mellanox.com>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PR0P264CA0043.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1::31) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by PR0P264CA0043.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.19 via Frontend Transport; Thu, 26 Mar 2020 20:46:24 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 88b9a5cb-dffa-40e0-b5d0-08d7d1c6c019
X-MS-TrafficTypeDiagnostic: AM6SPR01MB0020:|AM6SPR01MB0020:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6SPR01MB0020D701F42B60768A19AD15DBCF0@AM6SPR01MB0020.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 0354B4BED2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(346002)(39860400002)(396003)(136003)(376002)(366004)(26005)(66476007)(86362001)(107886003)(54906003)(16526019)(956004)(186003)(2616005)(5660300002)(66556008)(66946007)(4326008)(316002)(52116002)(8936002)(6506007)(8676002)(6512007)(478600001)(6486002)(2906002)(36756003)(6916009)(81166006)(4744005)(81156014)(6666004);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AHt6/z01hYfnsRF27lzTza2iL+6HoBSNF4f+ncFqhXc/Z+DmydtCZNWK6i6UgjZARP0h9vimDEM9y6Pg+7UAQvCOR/oz4tUt21FrOekntkN8v6Re+FHkoTAUAimyFxPpVnTuJQnGj4toMBHOAjTzfSguhZG/Pz+KFI5/Dx/IVyGteMoPUzFsmSAxX9NU6gjzfZTWckCGF5twNqM5D+3pe6+s3xxXBgN89iXehb+MUrEkg3I6DMotKC5w9EbLTIITY7IFhwGgoo3x96pX06sMy2mAeEht59m9GcrFEqNbtW1tH2idUqzeZPg17PiFIyB5dh7FiB79gmNjXCPDaGbXrzsTYLXVlO3bU16zjzmCXOT0mCn5efENbDzcFMxrv8EN2Dc2cDvjnsEXeetywfmlaf+q/e1VKlkulEm5NRFI6zHTS8l+Cl9L8Bu5Jt411dvV
X-MS-Exchange-AntiSpam-MessageData: pL/Nun8ubJkC1hfB6lCgKnm+lPvEfJbgkU98gXxGWeY5V5Zhy08jJTNUfjiMjl5rjN8AVCTcAdP3RNXB07pbUxtoRtl+KBJhaCSMvG+hGXfmeE1KuhhCyKhXQCNzpCk23M5/xy35cO4BDoh2Wh4pcw==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88b9a5cb-dffa-40e0-b5d0-08d7d1c6c019
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2020 20:46:25.6632
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EDFMkleWjabJiPPvoYhDI1a22zzgXworZ8xuj+Wi+imoa/DAxbIGTH5zvY0lCwo+ZhR5Uyd2DF5GncpwN2tFqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6SPR01MB0020
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The stats_update callback is used for adding HW counters to the SW ones.
Both skbedit and pedit actions are actually recognized by flow_offload.h,
but do not implement these callbacks. As a consequence, the reported values
are only the SW ones, even where there is a HW counter available.

Patch #1 adds the callback to action skbedit, patch #2 adds it to action
pedit. Patch #3 tweaks an skbedit selftest with a check that would have
caught this problem.

The pedit test is not likewise tweaked, because the iproute2 pedit action
currently does not support JSON dumping. This will be addressed later.

Petr Machata (3):
  sched: act_skbedit: Implement stats_update callback
  sched: act_pedit: Implement stats_update callback
  selftests: skbedit_priority: Test counters at the skbedit rule

 net/sched/act_pedit.c                                 | 11 +++++++++++
 net/sched/act_skbedit.c                               | 11 +++++++++++
 .../selftests/net/forwarding/skbedit_priority.sh      |  9 +++++++--
 3 files changed, 29 insertions(+), 2 deletions(-)

-- 
2.20.1

