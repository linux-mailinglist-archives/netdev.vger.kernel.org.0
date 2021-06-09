Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D65B3A18F7
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 17:16:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233392AbhFIPSQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 11:18:16 -0400
Received: from mail-eopbgr50127.outbound.protection.outlook.com ([40.107.5.127]:39182
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233257AbhFIPSM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 11:18:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OkDwRlLEqy1tRmnKVM4NWoaY940Ln/4pstvrW2Ghu6T21qgrGk3bB68QvGULb4SHDJZ+VmFRpOqt/IlmkEH/5VN6BdILYOp1htDjzBTPB1JdgeXUlijfafed3bRUI5zlcPjLswTpUe4mWfou0xqRTzdzpMwziCQvHd3/YKgufMHI3GER3kXUGfCu93d73aVB439kF7hGZ1T/B7pJxj3YY+K5AMrGVmuACIajv0VeRVyAVR44OjX6rSjmzO4V0aHfQ1ly5ZdXvA6Q8Uzu5KPtysb/Jew/BSJfA5rc2IOTkG0xT2mmLwiLAGgD0QssyEnHiA3qC1s8aYrHZHlYy6HirA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DAZu146b7e6ypjuMjavajC4ODeIU/lBLsC4MZ+gN/hk=;
 b=iH/CqX5oDg7hwj/7q7gaa4/9BFRPIaGxwJEY2J/9ZiY2YM0nyqR/0g1xv8CoXQyxQZV7CeoUP5s5q5KBc3UDMWY7BnR/A9ywOckB8Og5XsN7SBmEoSlYdBeET5kr2AIlCiocE/SjYP828bkWS5TUW/Jm4LH3xpdOzniYoHQy+zOCWuGYTE4AXmqAWo1+2cTmp+ne01WJ66MyGgsPhK/Wo1COC6faQjFVG4etf+6cXawBCY30GsFDBSResh5C6DN0QCxs1GDYtttknNw9C3WT6MP/bTxzuUtn1CyKrlgZb1HmjaIYHF9zqiKCobwRqWybhZKOgc1LSOXxy09dtstQPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DAZu146b7e6ypjuMjavajC4ODeIU/lBLsC4MZ+gN/hk=;
 b=FgBPhVGT7dyigx+FGyebwQhmxtYhxt7oUC9tVK4oRu4L+HUJA4b80/ph7KIsJm1wUJj1B3Kot2Z81RIEFRLzuqoFABuWw4F9gk0jEkXOcMRMIZYgKlk7MtwoP2/iBoZjDKEyRgNb5exuVOcIxUo613tahwtesOsgtx3p7uKAxU4=
Authentication-Results: plvision.eu; dkim=none (message not signed)
 header.d=none;plvision.eu; dmarc=none action=none header.from=plvision.eu;
Received: from AM0P190MB0738.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:19b::9)
 by AM4P190MB0004.EURP190.PROD.OUTLOOK.COM (2603:10a6:200:65::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21; Wed, 9 Jun
 2021 15:16:14 +0000
Received: from AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 ([fe80::d018:6384:155:a2fe]) by AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 ([fe80::d018:6384:155:a2fe%9]) with mapi id 15.20.4219.021; Wed, 9 Jun 2021
 15:16:14 +0000
From:   Oleksandr Mazur <oleksandr.mazur@plvision.eu>
To:     oleksandr.mazur@plvision.eu, jiri@nvidia.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 00/11] Marvell Prestera driver implementation of devlink functionality.
Date:   Wed,  9 Jun 2021 18:15:50 +0300
Message-Id: <20210609151602.29004-1-oleksandr.mazur@plvision.eu>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [217.20.186.93]
X-ClientProxiedBy: AM0PR06CA0092.eurprd06.prod.outlook.com
 (2603:10a6:208:fa::33) To AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:19b::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from omazur.x.ow.s (217.20.186.93) by AM0PR06CA0092.eurprd06.prod.outlook.com (2603:10a6:208:fa::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21 via Frontend Transport; Wed, 9 Jun 2021 15:16:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 60fbf8af-c5db-47d8-863e-08d92b598576
X-MS-TrafficTypeDiagnostic: AM4P190MB0004:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM4P190MB0004DFE3545533D7A9E04C2EE4369@AM4P190MB0004.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dVskKLvT7ZAFkO31JDMymWjgnnyV7kjpvjDI4N+V5PN9mXWjLLyWXu+Pq23JNG55nTk0XkuIy2LlMtUqwG47r4k5rKvPxq5+hVP3BPq5VX+TQ19DzC+Vq+lrzBbzjpqVRsKlcKjnVVUjgiXp6UtAobKuXP/Cp4iEy2xKjwCMtAWYTljwfCJ8dp0gP9whERVDHupM+7s43TGZNL/SiW111yum9KZYpHkzZ2a5mqIE7Yd1EXgacm1wAy1rV/WPJaLDyvvUbBOGLiYW8E28aKKb1jqlnZy6mwp3oGOinpxcfGdzGHEY9SGdO/gx3JHw6WAUDTPWJKOzXX3wPSKFlKHnzANjbKsa9ED1ff9Gg99S6+MnxGN2QD1loskqm7rYEd/HCRzhMCxyqNtO/UvS2XsgTqYIIV7A+5vtcqMD3kWOuL2NpS7865hfBCHaTBZKQn9uyV/8zYsGKxXoPuA0S3vf/bs8HBr4PIfOPUNgxmZEt0NB9jIaeJRh9Y/cMyDhObj+chLeuWHFgt6Xb8g/w7JB3znebwiwaWH4kqgJJIw7r9jrbncEZWPAGsykc2PPETzixemeuIJKYNmvsBpdiLgEW9DiYSI1aHVeCumqDUTjkrUkvqOoCAPUCm68/Kfww6oHe5nTL7VXIDaaVC3RpRZMWg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0P190MB0738.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(346002)(136003)(396003)(39830400003)(376002)(366004)(38100700002)(38350700002)(316002)(8936002)(36756003)(478600001)(26005)(956004)(6506007)(6512007)(2616005)(5660300002)(4326008)(52116002)(83380400001)(2906002)(86362001)(16526019)(66946007)(1076003)(66476007)(66556008)(6666004)(44832011)(8676002)(6486002)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?DYpt1M0QhGdUB3mHCuYdk0+i1V9JkShQjyfyIKdUKJ67YAvTKd4Id+91wiqG?=
 =?us-ascii?Q?mNREmqtstLu/UMivaTQajsot4ZGUlmiM+91Kf1x6a+O7pbo/6vXnzPgYKKEf?=
 =?us-ascii?Q?EKqASg6dG44dRn7RrBx4CYObSKl8G/50TkgG8xVEc09twXgm4I+rMEdplQh2?=
 =?us-ascii?Q?B/D8ameoVbEH+vpx7k770ZyYPVIEuwO0TM+12KPSbFg91Q1aGjvTTejFllBj?=
 =?us-ascii?Q?SqQvw63IBRhx3lqliiAwiMbSpwnLmpJ99asJnCErCKwNvO72r/FQkUGj4/ZD?=
 =?us-ascii?Q?Q6lw25/QwNQWPqJsBdAe8aSBeOy0ClBcHdsXF/xVW8VcfQzMR+7Myz46uDzA?=
 =?us-ascii?Q?R7YfVmP5fEO7qtuyEFWZVCIUkY7u6YNiXNC8sNm31r5XX9h7CCjq7gjchgns?=
 =?us-ascii?Q?sWQ5M3N0D5GQcnvRH1tzf88Ie9cHfh16ukdjYJXP7v7al46C9gVfOO7l8Y5f?=
 =?us-ascii?Q?tQxyfI7001rvo3Yp527eWxJo8VkGi+4aTIXAUza6VhEHFABPfEJWHON3CdX1?=
 =?us-ascii?Q?aaHHFhQFUVIX/YrdC8nbsR9fmwdeb/BCJtNsmPe0Ae4jfpsEsQZqFX8d2vun?=
 =?us-ascii?Q?8qgyP1VCJ0Of0GuduRQRQigjMzS/SX6FbOW8zt5o4X0+dYDJw/q3ZFXoebuY?=
 =?us-ascii?Q?38C2zEVArvEujduQknM3ltX3rOZcQxVhC5GKYLHQfmP1OZ29lEYi6S0cKCU/?=
 =?us-ascii?Q?4mhwrbzG3uuX8caBrSnHSmjllTxmLjU2kavCXQ01KLRFkv0Y5Q6mRoSgFWwm?=
 =?us-ascii?Q?WvhaUvlkKtA3pII+6ED4IpYpcWEr1rvubmFM/V4xDv/aIwo1dWoQ+3OYYsuX?=
 =?us-ascii?Q?qn4RJOCdlYa+EhoEibJdmVGVdD3j2TBa9y/IodwyJTLI583+PgpnOaiA0AM2?=
 =?us-ascii?Q?RSf08eg/jxZFBrshafX/PNpNux3bljWnExeLRCHg2o6t3MLwY1dNCB8AnsVj?=
 =?us-ascii?Q?Yna8HGrUkdpXE6TUSuxZig8qJH3FiYIx1h9eGHQfTjhqiAlh11YzCmtlDFgr?=
 =?us-ascii?Q?UWpUARQ/DrYWno+BrFQmqaVG7tXzAKCacE+8R1HuIyN8qsjpO4Q4hzvZYh35?=
 =?us-ascii?Q?kZUvzP9vD5WVSOBQPy17IhhMYG0yShtpAI1hqng6WSzvgywjtQDFTIvu4zyb?=
 =?us-ascii?Q?SE8Hvm84BlXNiutDR6IZ5S6xFbp99g8L8BWIElRCX+HF0p+ilg5xOXuRzJtd?=
 =?us-ascii?Q?8dJkSWlqg+ZlXOv5/TPPBEiubeDGhDtRgZtSV0Vpf1TqGsuU5ZsSJhByTZKW?=
 =?us-ascii?Q?X93sR6nTiAwvo9TxgJc4Koe0SRUmsMAKdoCkwp5J26cHV2/OqLD3m/NNd9nI?=
 =?us-ascii?Q?OFpw2E09pqv2a1D+qvdUh6Wn?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 60fbf8af-c5db-47d8-863e-08d92b598576
X-MS-Exchange-CrossTenant-AuthSource: AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2021 15:16:14.2101
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yPd1CZlvtwNso47qzAPpZgZbXqoUqH8r2Cq/bKRejUsCQELQaTmdVWeUFr3yPpC9ql1qOLveUEAUldZd+AqOdpZ/DXFrMS2/ZtIz9ylSvlY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4P190MB0004
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Prestera Switchdev driver implements a set of devlink-based features,
that include both debug functionality (traps with trap statistics), as well
as functional rate limiter that is based on the devlink kernel API (interfaces).

The core prestera-devlink functionality is implemented in the prestera_devlink.c.

The patch series also extends the existing devlink kernel API with a list of core
features:
 - devlink: add API for both publish/unpublish port parameters.
 - devlink: add port parameters-specific ops, as current design makes it impossible
   to register one parameter for multiple ports, and effectively distinguish for
   what port parameter_op is called.
 - devlink: add trap_drop_counter_get callback for driver to register - make it possible
   to keep track of how many packets have been dropped (hard) by the switch device, before
   the packets even made it to the devlink subsystem (e.g. dropped due to RXDMA buffer
   overflow).

The core features that extend current functionality of prestera Switchdev driver:
 - add storm control (BUM control) functionality, that is driven through the
   devlink (per) port parameters.
 - add logic for driver traps and drops registration (also traps with DROP action).
 - add documentation for prestera driver traps and drops group.

Oleksandr Mazur (10):
  net: core: devlink: add dropped stats traps field
  net: core: devlink: add port_params_ops for devlink port parameters
    altering
  testing: selftests: net: forwarding: add devlink-required
    functionality to test (hard) dropped stats field
  drivers: net: netdevsim: add devlink trap_drop_counter_get
    implementation
  testing: selftests: drivers: net: netdevsim: devlink: add test case
    for hard drop statistics
  drivers: net: netdevsim: add devlink port params usage
  net: marvell: prestera: devlink: add traps/groups implementation
  net: marvell: prestera: devlink: add traps with DROP action
  net: marvell: prestera: add storm control (rate limiter)
    implementation
  documentation: networking: devlink: add prestera switched driver
    Documentation

Sudarsana Reddy Kalluru (1):
  net: core: devlink: add apis to publish/unpublish port params

 Documentation/networking/devlink/prestera.rst | 167 +++++
 .../net/ethernet/marvell/prestera/prestera.h  |   9 +
 .../marvell/prestera/prestera_devlink.c       | 664 +++++++++++++++++-
 .../marvell/prestera/prestera_devlink.h       |   3 +
 .../ethernet/marvell/prestera/prestera_dsa.c  |   3 +
 .../ethernet/marvell/prestera/prestera_dsa.h  |   1 +
 .../ethernet/marvell/prestera/prestera_hw.c   |  60 ++
 .../ethernet/marvell/prestera/prestera_hw.h   |  20 +
 .../ethernet/marvell/prestera/prestera_rxtx.c |   7 +-
 drivers/net/netdevsim/dev.c                   | 108 ++-
 drivers/net/netdevsim/netdevsim.h             |   3 +
 include/net/devlink.h                         |  35 +
 net/core/devlink.c                            | 139 +++-
 .../drivers/net/netdevsim/devlink_trap.sh     |  10 +
 .../selftests/net/forwarding/devlink_lib.sh   |  26 +
 15 files changed, 1238 insertions(+), 17 deletions(-)
 create mode 100644 Documentation/networking/devlink/prestera.rst

-- 
2.17.1

