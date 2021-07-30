Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 733D83DB976
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 15:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239051AbhG3NkT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 09:40:19 -0400
Received: from mail-eopbgr20123.outbound.protection.outlook.com ([40.107.2.123]:37764
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238998AbhG3NkE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Jul 2021 09:40:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LbG64gcwMvKTjujD25JxjLVy6sYsIhVChDiqyHeLyxhjm3CtQraVP9q4lF+S9csnd2Jih97Ic3o5yDZglEe2qmnE2Xoehn9PDTeindyjCZjQz+pPQZMO7c6XUQc6lsO9oNPKKXDLr+WP3PiqcvFtE20PgIusO4KykKozuKD8BrvUVniI83Eaj6bCRVhXnRD50zvarLeySVsZCxc2d7NIQP0aug59woBSNXi6ucnzy3JpTBwlI8YX4Id1afYvajeMnM0QsP2Vwp+rJSOAIWmr9BYoVr644qQgGEOMtFyc0Q207y0pHrHvTY3cG/EShu+w7mvkQWdx0b2809n9L8qVuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Updd4LK5y+Mb4J3QtjY2wJ+YrGUTiwmZqwpNzn6iIrQ=;
 b=C5XQNLpThPwgCib6ieDq8dvIHV0LEZ/MXWOY82k77UOAsn4CW++Y+kfOP/08LS+fv56FnJ7zheYuGl/7ESthrcvVr8bpRPBLrSt9NDMsT8iAndBDVwLT5O38TuCiCwR+ZSqJst4jZ0/X0dunH10rXtKMI48vD0Hjs/RNg2rd5GgTKc2b/2xz0eNPc2QP/erqrYzC8n5WrcXOP3pGyrmGcWZDV4qvnt2lI/Ldyv7Hj/2+ZDdF3s64Wnv+R8hYYQryKRpLD6W7tvWtoegPECymTKjMm+9PlsicyyQsGRG/MMiGWukLbr9oh985BeEfqbgBF3dVRBtOiGTo7LRGB/wutg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Updd4LK5y+Mb4J3QtjY2wJ+YrGUTiwmZqwpNzn6iIrQ=;
 b=JIjEIn1Ft7Hd3+R0Sg6c14j8ZC/dVFtTePpNoxsTOcz6Wl9J7TNDRb2aceTugeYVB35DIAJI+oRwuvUhS03L/juqvKOTPNQL6HGVyXcHT7UOpR1i8ktNjYH4LtKy+K4Ap1M9Vmp3+VVjbG2uWW5kiIwaICMdETEQF8JNhNwsi4k=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=plvision.eu;
Received: from AS8P190MB1063.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:2e4::5)
 by AS8P190MB1271.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:2b6::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.21; Fri, 30 Jul
 2021 13:39:42 +0000
Received: from AS8P190MB1063.EURP190.PROD.OUTLOOK.COM
 ([fe80::380c:126f:278d:b230]) by AS8P190MB1063.EURP190.PROD.OUTLOOK.COM
 ([fe80::380c:126f:278d:b230%9]) with mapi id 15.20.4373.025; Fri, 30 Jul 2021
 13:39:41 +0000
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>
Cc:     Vadym Kochan <vadym.kochan@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        Mickey Rachamim <mickeyr@marvell.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vadym Kochan <vkochan@marvell.com>
Subject: [PATCH net-next 0/4] Marvell Prestera add policer support
Date:   Fri, 30 Jul 2021 16:39:21 +0300
Message-Id: <20210730133925.18851-1-vadym.kochan@plvision.eu>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: AM6P194CA0012.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:209:90::25) To AS8P190MB1063.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:2e4::5)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc60716vkochan.x.ow.s (217.20.186.93) by AM6P194CA0012.EURP194.PROD.OUTLOOK.COM (2603:10a6:209:90::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend Transport; Fri, 30 Jul 2021 13:39:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7be7d327-e1d2-4c3d-6bd5-08d9535f7bfb
X-MS-TrafficTypeDiagnostic: AS8P190MB1271:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AS8P190MB1271FC04376F51D9A8BEBF3195EC9@AS8P190MB1271.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nEFc+fBMCFA4lbuPxvygwCQm/HIpYJr4MnGYgwPbgnqoJnTIp7bGcyKM1eBYPwFEvrzt51Nt8l32OlIDbgg+zDWlUXRCg84Fr1zhNvqorUNS9IBSXcXSaTh9wj8cS2eLW7cwFEe5w8GPLsrQIQNMwi2J6GvY2KArzHprF1/OdjCevTHGwbM+eSfdXgP7fBDhviakGfEPgxL28kWgXxoaWElotDV3sVeQ4tiEzOL8eFH82Wx0Yk/zQDhmUXyJMyeZb4TnOnNbxtnYRLhl1zP0DfCx6cpcRRBtgILzhsTL+UYQl12OXTBwngAiYqyO2YJ12St04Lk63ucIfMtqydLDepWVkxeIXfT0763CLt/HDFvfO20fZB7T6yvNa09nxxInrtmHp2YZIUxNToXVexPsKjUzqaPumXmiHbiCvs+w3xjitYS59vYIaDCTZICS4Am5BZH5UuIOwxzlSVkqkV0u1byFjLmuk467MEKb35+mIND/OARy+e0qYMwR0VcbQ1kGdkR/ttz07vANpdx9AY3PYHIMLYl2DLoWWQFauzI/59+2Sg2WclHk+N3BvKF3d2jKyusPES8Up/82ghNtk9RINEp/6xM9+9WYCqbDEHhUbeKG/OfUVCZdc6TJ2Fugx2g8gst0ZlgOYuZCaghHi1fcv65Vxv2LcwW4rDF6qS/a1VNEsaa3/PhCR9Dd+1+QdIg1cwKYykj9qukn5UgRbaf+IQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8P190MB1063.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(346002)(136003)(39830400003)(366004)(396003)(376002)(52116002)(8676002)(83380400001)(5660300002)(36756003)(54906003)(26005)(186003)(110136005)(6636002)(6666004)(8936002)(44832011)(2616005)(956004)(478600001)(6486002)(2906002)(6506007)(1076003)(6512007)(38100700002)(86362001)(38350700002)(66946007)(66556008)(7416002)(316002)(4326008)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+kyc7HuY+vTqB/ImWpzQ8Tyz561gZi2sgHqE4G98HgjX5QiWyyin6cpsEf13?=
 =?us-ascii?Q?xQyF14BkyS4AT6a0WI+NSUZGSwXMgRWrvL7J77ZMo1Y0nx9l9KNDa9PN6vQ7?=
 =?us-ascii?Q?CGam5bWzV744pf4ijlDXiyzYZXx4GB+Vb8sHsPywEwQKJ6N1+PnDYWlRcFS+?=
 =?us-ascii?Q?nixA6sRz6gNGzWb6ZnKsTZk2sqbMzkHay7lytwSaYasHi7NyVz10/58YEUVn?=
 =?us-ascii?Q?ArwKWjbxB9cHAqf4e20M1hiUFM2Ir+nbAoX64xhVdE5/KXjwt2my9NX+rlZu?=
 =?us-ascii?Q?6y2pqK4r7f0fJ9/S/sLfVwiLDYEgaC6RxVhYsyAuzt59bgyf+x4ORKvml1xT?=
 =?us-ascii?Q?aqWWaTTPbl9+D1Az8aq0xozH6n3TWNuRnK1w7tUPyMlDAPy8IuChXjI4OnFI?=
 =?us-ascii?Q?DkPFuRuYeonZCbh06/r8F66cLoJo/xx61PL3pNL2dmBaNoKHoJBEBazYeFIV?=
 =?us-ascii?Q?JZseASPK6ljN53gNg938sfFJZuSXz5WpFPUB7+jogAxMUZOeevsWmguj1xwQ?=
 =?us-ascii?Q?7Yc7eTgvBEM13JByc20yaF/CiPdBMokMLnqQZqcAbjuOZ5SZO5LZ+ECSSzzO?=
 =?us-ascii?Q?dXF5XN8CAQWWLfHKgwlA3OjzfkQ1b6s/RfIj03Mja3Ny4WsHm6eRNN1RxYig?=
 =?us-ascii?Q?++lkzC8iqYwy0JEi4lIdzrLfXJpy6u6O/ZgYGCa6pxnBEBGfzZBqQkghZhw9?=
 =?us-ascii?Q?ATU4Ul4Ri20Gc7sJ3R3QdAgYICxw8E0hBf6xLs0QV9fVDqrQE5lp+4eJ4jfO?=
 =?us-ascii?Q?GOqpK2LdpXmxI7ujc+nN6cP7nee5uTNK8yL6JNfJQ3vphK9WPKvAZovdb5Je?=
 =?us-ascii?Q?yxfZnjB5WGZ3nbIDbKjJ9TFaBrgqaVUaLp9bZMMY/S8Hb2QwOi3Isn+Fpbfl?=
 =?us-ascii?Q?2cxmG/YuRZdvNhfJ8PvGrRKoNLEm7RapH1NFvGNkrc/np7rI/88M/yWdEFAK?=
 =?us-ascii?Q?ec3RRRngExYbHfw/GuTc5y8vVYkm4z4gtJtP3MgYLda4SevPlNh3q0psH7C1?=
 =?us-ascii?Q?CwvXLGydYbVkKEpGIGQ3uTJg+vSMFw4EbrSJIeFRBlmduSaRK3t0+vKWBabc?=
 =?us-ascii?Q?+5rx1r3gdFr0/XmZjty3MfuomwcCxIBq47VrLpycaWgU2U8S12CoVdMXby+S?=
 =?us-ascii?Q?1ceEfao63J+DiG16Q3J9gj0Jjj91yfH3NU93t1y1Q/UYXYsDUCDr64bNdu5U?=
 =?us-ascii?Q?XmWmHWRiQ8dMK3Yvj8Q/2J/J4UnNrb2ZSnXmPsgZLgKox1+oe5u+CejMjRjL?=
 =?us-ascii?Q?XCJHVM1RtIdrOlaY8ZEzNuSAT6T3M4X14E8tIRPZt+VmFcH/7DplQu3wi2Q8?=
 =?us-ascii?Q?bDFlHZNIdGYzoYPT9JtxbFiO?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 7be7d327-e1d2-4c3d-6bd5-08d9535f7bfb
X-MS-Exchange-CrossTenant-AuthSource: AS8P190MB1063.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2021 13:39:41.8541
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XZ1Wv6ofNDdoIrGjZVpgNwzT815XRMOXncNBOpxGARGhztQiuH1ybZKZXeSXs64j816tptMdHXn6uZaVmLsk/qtzbKDpYKQko8ooCBjcqFA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8P190MB1271
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadym Kochan <vkochan@marvell.com>

Offload action police when keyed to a flower classifier.
Only rate and burst is supported for now. The conform-exceed
drop is assumed as a default value.

Policer support requires FW 3.1 version. Because there are some FW ABI
differences in ACL rule messages between 3.0 and 3.1 so added separate
"_ext" struct version with separate HW helper.

Also added new __tc_classid_to_hwtc() helper which calculates hw tc
without need of netdev but specifying the num of tc instead, because
ingress HW queues are globally and statically per ASIC not per port.

Serhiy Boiko (1):
  net: marvell: prestera: Offload FLOW_ACTION_POLICE

Vadym Kochan (3):
  net: marvell: prestera: do not fail if FW reply is bigger
  net: marvell: prestera: turn FW supported versions into an array
  net: sched: introduce __tc_classid_to_hwtc() helper

 .../ethernet/marvell/prestera/prestera_acl.c  |  14 ++
 .../ethernet/marvell/prestera/prestera_acl.h  |  11 +-
 .../marvell/prestera/prestera_flower.c        |  18 +++
 .../ethernet/marvell/prestera/prestera_hw.c   | 125 +++++++++++++++++-
 .../ethernet/marvell/prestera/prestera_pci.c  |  63 ++++-----
 include/net/sch_generic.h                     |   9 +-
 6 files changed, 197 insertions(+), 43 deletions(-)

-- 
2.17.1

