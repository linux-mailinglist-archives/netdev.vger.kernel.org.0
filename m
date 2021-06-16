Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52F953AA0AC
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 18:02:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231516AbhFPQEN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 12:04:13 -0400
Received: from mail-eopbgr60121.outbound.protection.outlook.com ([40.107.6.121]:61575
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230515AbhFPQEL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Jun 2021 12:04:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RaRxjE/SalksiBnirskI7zyEOl8da4m4w1JRmkTHk02c20o2KiJ8ujXMXp2kgyypULz62DPkc77hXSNwkF7MYDQ109DGF5vicLu6S6V+xAkD7Z1ZfEs8lcPsDOUswsaWjs5AnrrcveuAg+2/lUpMrmrTZqi30Ya9ZacM6oJozIpn9+tUk3IhTfGA8do0iy5yER6wUtxq73LHJERlYRm3qXl58tBY1y/R1WAWaXVRYZiEWB1Fk37orObAS7mZaYL0IlJu2qbA1BNs9AdZvLda0y1rRWJTMvbhU5PkDDelxw0eTivZh4Exn/M9W2c1tkUG7ej49Crrw36e1OBik2Uj5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B7pEb7eqIuXbBIS7EE/I7WCzPW63mC/utD6IQ7O6Fk8=;
 b=XrIx4ulhl1E+Jd7wWY1jek3y5vJyJMAvOuyU8+SshOpwxsKZR66+WbH60v1z5IdEBV5+WpPAZ3Jeiy2Zwunn+muDRXhDbLjMHn3L+7uHD1cArS0Ufo/8S+M2d1FrDNdrR7Nb+9/WPIedjCPUj0rVrA/2VF/qkXEnk3gTU09L7Gl2Kied5l/V3Vxr6Z8hct+j4rd/xPqOlt2tZEsehclcYVDKtGcMp6vtIO07YJJnVy+yIwJ8TIquIg00xJEFlyfiDJZHTV4oM2fBsSuntS5ZAcnUviw6cGqYbHOv9eBczqo9rZiEek7KjEsqMwOsR0sWqNYQZ8wEc/17576wWeMMjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B7pEb7eqIuXbBIS7EE/I7WCzPW63mC/utD6IQ7O6Fk8=;
 b=u872iT84EIUJn3GFSNZ5SGWGeusVbzMdYW/iTwamnXQwDslOfAIaWZV/iJsgLf6Hz5HocQ0BFPft+o1jF/ZTaBuVFoz/cSIdJEYA3BWAUHzV5vuYR+RvHWQ9/gZ2kibKqpYJMwvUQULQLsLMQszEVFEUu6ILQjbZ75yzvcO1Y1s=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=plvision.eu;
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) by
 HE1P190MB0090.EURP190.PROD.OUTLOOK.COM (2603:10a6:3:ca::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4219.23; Wed, 16 Jun 2021 16:02:03 +0000
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::e58c:4b87:f666:e53a]) by HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::e58c:4b87:f666:e53a%6]) with mapi id 15.20.4219.025; Wed, 16 Jun 2021
 16:02:02 +0000
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     Vadym Kochan <vadym.kochan@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        linux-kernel@vger.kernel.org,
        Mickey Rachamim <mickeyr@marvell.com>,
        Vadym Kochan <vkochan@marvell.com>
Subject: [PATCH net-next v2 0/2] Marvell Prestera add flower and match all support
Date:   Wed, 16 Jun 2021 19:01:43 +0300
Message-Id: <20210616160145.17376-1-vadym.kochan@plvision.eu>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [217.20.186.93]
X-ClientProxiedBy: AS8PR04CA0027.eurprd04.prod.outlook.com
 (2603:10a6:20b:310::32) To HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:7:56::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc60716vkochan.x.ow.s (217.20.186.93) by AS8PR04CA0027.eurprd04.prod.outlook.com (2603:10a6:20b:310::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.15 via Frontend Transport; Wed, 16 Jun 2021 16:02:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d05f8fec-f0c5-42bf-2754-08d930e0148b
X-MS-TrafficTypeDiagnostic: HE1P190MB0090:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1P190MB009024B8BA1CA642AF023706950F9@HE1P190MB0090.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZIdilDyx3/PUOyl+EiNqjDSFa8qnrxsOMxPGXNhjqmWHgJMJ1A+OImZGQIKvt9KVj513D3ysgfMmXQ/kFilfTAZ/OJh/opR+PFwVkCo4jtzqKxMJ+RtGa8AwMLqw3RKwc1OTgxAlp8MRiexFHeFUYWpthpurPKzdy2CcZrOFmNekDKsDQNPzJ2kZb7i5qFIECxM7dpBANmIVIVQWp0kTXwe7R+MylKB/6v8XLl0QOU0O57CzcecLZJjyxyRWHAaQlfWtvnbvK/nXcw+HpFPYL0n2VgBn4YtNgNTdBUS1fj9MKNceXrBGuDkdK3WN2lwipyYlMXPYK6yuuy3rHM7DvXyP5iwHsNeovetit5gI6CuHB7NA25okS+R6loicS8+QYstaNvxQ+VR+PNwHvWBQpBidEA7FTJPgU3za/UZP4CSt6hEUgFFVLbDK/8w9AAl8QQnW01Vyh4ZcPOxJx/9UVdcJN95Av1Eo1xosXBnXEnXf+Ni4tFAyRva6JzXemTU1RLAf+2jvMUbAMDaYkNdDMsG8uq3g1iW7UqF2umHLI+eQtZIibhoRM3yee1u6wxKgz+HQdbp/107kM2G385SeDHHLV8zMlAyraZasRNoUws1XPmDhxsYRpAJHBIu84M2OUps1/iHQTE+5Bq7ak7WSqQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1P190MB0539.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(39830400003)(346002)(366004)(136003)(396003)(376002)(1076003)(5660300002)(54906003)(2616005)(956004)(4326008)(6506007)(52116002)(44832011)(83380400001)(16526019)(38350700002)(38100700002)(2906002)(26005)(6666004)(36756003)(66946007)(8676002)(86362001)(316002)(8936002)(66556008)(110136005)(6486002)(6512007)(66476007)(186003)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TXt4X4Db2IgCzMYoQXqWqH5Rl+WOOZ/GEhBYqxHor6Yxy9y10xK0b8w5wRdR?=
 =?us-ascii?Q?XmFbkE40mQConmBsYkXgB2iYRo/141aqG/aeDa+qFOHyHHu6uqrmPCwSkk7z?=
 =?us-ascii?Q?TGt6w++aZyMe65b0JGawjoShn9X/E9RzlEueem4b9QjkxTQcLVX0idCt3HPx?=
 =?us-ascii?Q?JtDbFNSfDvk/IU8Um2qOPY5H8U5Szq3iYIZ/UachusxQTI/A/e8e5cMCmmUC?=
 =?us-ascii?Q?TwppURFL7EMkraTkMeuquL7r1j55a+swETDhhP61dLss4V24+LU8GnkJ/1CL?=
 =?us-ascii?Q?IC5YA31hXKzmY54nKKRJ8vMAXYlblV0lRTUM2nxZV3nzsBskJmQDbicTCBgQ?=
 =?us-ascii?Q?oMScsWhpiLvp/blaXixqxN3Hv8rI5BJ2SNaoed9dRHAk51SQ6HnoHl3b7aJc?=
 =?us-ascii?Q?dO+cq8lvGnd+f/mVENqTKOQmN9CNMkNHSKi54OJ0EUeEu9OyzZiF+BZ+ezuZ?=
 =?us-ascii?Q?CBTM+g5NzzhjrudK0yTW4eDHl+rswxjTxnI5E39ZmCNDBjlbwWd+pA22TJQ6?=
 =?us-ascii?Q?oDPpFblRnc4BT005FrSnALex/CTtj3JgBhtCUTsjTKUwls9byc1UlxK/PdGx?=
 =?us-ascii?Q?BVeas19HlkJVYfUNFVwbvHMR6FkMZKcqTTfs8Zpb71ydEhbA3pUDkmUOixCm?=
 =?us-ascii?Q?uf33IBadTRP/JGVIDPQAQVCHiuQIs5F0We/4Fc7Aw7yXy04vs1+w3bxgVO9j?=
 =?us-ascii?Q?DhdgNspykQgbUUyd1CwYZOBYkLV6qn5opEjrvKjcVgDPZmTwZtgb91xoA/1K?=
 =?us-ascii?Q?y0X92sd4KaLMEwHSQ2dIyYDozKXiN3+wz6U5V/dUTlTgNYosZYgC81k9B61s?=
 =?us-ascii?Q?mirit2c+ffK4xdcJ2NIIcrrTql8v+r+jT8rFqLNQmaOVVLHkXtJC1ntGoYW+?=
 =?us-ascii?Q?uIIZM+n6JZTOImQbxjcQABAWjMq5kWjELpBr7CFjFYZCUeGYc0jIuyAQ+L04?=
 =?us-ascii?Q?/Oo+FyQ76QZaLP8ud7MeYkaCMlLcFcPLegfIbSBb+VkErYlXvb9aPVqfjgKS?=
 =?us-ascii?Q?m3Uazj/w7xyqH+bAWkuoK8BRtrOl2kXmuTfSEb6wiwjhwkLOkSZupN57ejZM?=
 =?us-ascii?Q?vGPpUp3SwgxlNcw326Ol1QWyDhqYlmEALfrnfJK0kerKQYAbuyUnupx+aStH?=
 =?us-ascii?Q?DRkLsBrDTZHQ1BFF9IgT+LZSNSu7ZNPuHATnFv1KLgemW5omJUjoZEnHpCwh?=
 =?us-ascii?Q?834IBFnUmTKxsCanabknermrxx7nE1B8hQYdFQf6BnHHlqctsKXMETNmnZRo?=
 =?us-ascii?Q?/d8OjenRR49rtC8QrMUSEpIMA8XkVxQLhKcDw+PLIaTwoGP5nWtX/azKLb12?=
 =?us-ascii?Q?dd8DaaQJCMpiu7wjaQvg9BXr?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: d05f8fec-f0c5-42bf-2754-08d930e0148b
X-MS-Exchange-CrossTenant-AuthSource: HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2021 16:02:02.7415
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Pf32udByIX5O0ZteZnOXMJ3xx4qfD3LKFqqP/wLhVUPk2CiSUcWYPvQQL083SKaqPdEoxB06yXc5AhBJ4cViI0sXLSbyMIaMsr13iUE+KYo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0090
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadym Kochan <vkochan@marvell.com>

Add ACL infrastructure for Prestera Switch ASICs family devices to
offload cls_flower rules to be processed in the HW.

ACL implementation is based on tc filter api. The flower classifier
is supported to configure ACL rules/matches/action.

Supported actions:

    - drop
    - trap
    - pass

Supported dissector keys:

    - indev
    - src_mac
    - dst_mac
    - src_ip
    - dst_ip
    - ip_proto
    - src_port
    - dst_port
    - vlan_id
    - vlan_ethtype
    - icmp type/code

- Introduce matchall filter support
- Add SPAN API to configure port mirroring.
- Add tc mirror action.

At this moment, only mirror (egress) action is supported.

Example:
    tc filter ... action mirred egress mirror dev DEV

v2:
    Fixed "newline at EOF warnings" from "git am" by
        re-applying with --whitespace=fix

    patch #1:
        1) Set TC HW Offload always enabled without disable it     [suggested by Vladimir Oltean]
           by user. It reduced the logic by removing feature
           handling and acl block disable counting. 

    patch #2:
        1) Removed extra not needed diff with prestera_port and    [suggested by Vladimir Oltean]
           prestera_switch  lines exchanging in prestera_acl.h

        2) Fix local variables ordering to reverse chrostmas tree  [suggested by Vladimir Oltean]

        3) Use tc_cls_can_offload_and_chain0() in                  [suggested by Vladimir Oltean]
           prestera_span_replace()

        4) Removed TODO about prio check                           [suggested by Vladimir Oltean]

        5) Rephrase error message if prestera_netdev_check()       [suggested by Vladimir Oltean]
           fails in prestera_span_replace()

Serhiy Boiko (2):
  net: marvell: Implement TC flower offload
  net: marvell: prestera: Add matchall support

 .../net/ethernet/marvell/prestera/Makefile    |   3 +-
 .../net/ethernet/marvell/prestera/prestera.h  |   7 +
 .../ethernet/marvell/prestera/prestera_acl.c  | 376 ++++++++++++++++++
 .../ethernet/marvell/prestera/prestera_acl.h  | 124 ++++++
 .../ethernet/marvell/prestera/prestera_flow.c | 194 +++++++++
 .../ethernet/marvell/prestera/prestera_flow.h |  14 +
 .../marvell/prestera/prestera_flower.c        | 359 +++++++++++++++++
 .../marvell/prestera/prestera_flower.h        |  18 +
 .../ethernet/marvell/prestera/prestera_hw.c   | 361 +++++++++++++++++
 .../ethernet/marvell/prestera/prestera_hw.h   |  23 ++
 .../ethernet/marvell/prestera/prestera_main.c |  34 +-
 .../ethernet/marvell/prestera/prestera_span.c | 239 +++++++++++
 .../ethernet/marvell/prestera/prestera_span.h |  20 +
 13 files changed, 1770 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_acl.c
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_acl.h
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_flow.c
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_flow.h
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_flower.c
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_flower.h
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_span.c
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_span.h

-- 
2.17.1

