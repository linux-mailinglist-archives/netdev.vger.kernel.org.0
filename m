Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FD542D8DC4
	for <lists+netdev@lfdr.de>; Sun, 13 Dec 2020 15:09:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395153AbgLMOI0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Dec 2020 09:08:26 -0500
Received: from mail-am6eur05on2086.outbound.protection.outlook.com ([40.107.22.86]:11936
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726723AbgLMOIZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 13 Dec 2020 09:08:25 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=crKCDXITDPcKeuxiEgrUTepMy2SciUWZ89UpJhwFb860BRQrwenRYf5NWjdHQfiq4lXip92hOx0iULWspGpH1VLFHTYi4ZW+1L6mY6dRXn+cZodMid4iUBw/g+JcgoIJQaveXhm9z3v3wrm5cUyKo7HivJQ4nVVE7Fb/StkI2+sNQN0FDBI/vMcdCy2myx7+2k71JHFzX9rmYaqNo0tAxGKGCxs9MF/v8ik7bT0/JbZ+xHtYX8guGAC5avO280XxC2CwVs6cYYdRDX3C0GaGWAgkHbgM3JrOHYX7NcDUQb9Xr9Sg/2vKZ97AlRM/ByiL8KR5UJhNBLxD3SBB2qJSkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pNEFJ+R+2iHogsjSqm6aAUG5nmKXkvlRYUcdAO0KiXA=;
 b=W8+BZrx2w3Nv5xrmbNqKh1XDzv7Pf2nGemCXribkb+Y1R3Yo5uFpNZuEF3fzMaqyBEHxNi73z+1x92L1KC8vlrfai6SuvUNcGgNES2Nuz3+FGVPt5rnoQpcMW9kLjGLYzLVHRYZVplKHIlQGqKEKErum1OsBhhppr5YRKCy3v3lFdkZZWt1FC3HVmQfWLG8JTY0GR+s8hVYDEMsVS/lYN4ZnWGp9HrPEwLiMzH/onragOuD5UuouEjLNG0eFeeZiDzXawzvsFDRucAJXeayCngZqvCLWm1wG3JKOhIqzeNau5lMvE+ZedRYFED92uBre0AHgBdGVRUTAkg9J5uS+Mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pNEFJ+R+2iHogsjSqm6aAUG5nmKXkvlRYUcdAO0KiXA=;
 b=PlWAWmuw4OB4vKPeFBXzjB2bAlhg4149o6wu06rRJti26IrkcUWsYN00uIlnO5l31KeIEGbH4aYYOUYY6Li4Y0Kl6z6epiu4GXYbdQp8mI/ZVp2MzGP4MToByFr7MCHUsAKPw1mpBlhNGLB67gRKbvSWDbIopY/eu48eWMHBkng=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VE1PR04MB7341.eurprd04.prod.outlook.com (2603:10a6:800:1a6::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.18; Sun, 13 Dec
 2020 14:07:36 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3654.020; Sun, 13 Dec 2020
 14:07:36 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     DENG Qingfang <dqfext@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Marek Behun <marek.behun@nic.cz>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH v3 net-next 0/7] Offload software learnt bridge addresses to DSA
Date:   Sun, 13 Dec 2020 16:07:03 +0200
Message-Id: <20201213140710.1198050-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.25.2.120]
X-ClientProxiedBy: VI1PR08CA0235.eurprd08.prod.outlook.com
 (2603:10a6:802:15::44) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.2.120) by VI1PR08CA0235.eurprd08.prod.outlook.com (2603:10a6:802:15::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Sun, 13 Dec 2020 14:07:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9c8c09e0-98d3-4be2-5aef-08d89f70718e
X-MS-TrafficTypeDiagnostic: VE1PR04MB7341:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB7341A3D0220BB0C476FFA339E0C80@VE1PR04MB7341.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VvzrbI1GRdYuUzyO8GEdoDKOyz480JbXmbFEyShYzz7tu4zYGKdyUxyh9cJFm6fKlkTsIKDM5fuuVnrEGRufpPQhGM/2W1+xSvOeg/xsv0k9V8JVapr2bBh1q8vjkbY/1xxTWv6jB0lkLkk5pE3oghUn2+q7tdY0AzvnFkUE+Q5aD8eBqAmC0PiSQp3AxaZ8GJcNvNruCUWIg+zJaL63CvFEbI0IcWAlziThQhtuhk+b6PuanLdKKX5tpZ1LT8jeJgW4upcfhuRn5vlYE0mRg7iKAgXdurrbsUKAG1pvDxNXVTkiEe4Ec2IXdUrNrPCLfWS0AHjzmHedBJnRMeJ+u7jifhhZdZmY+pBbs3FC69Io4wUEyp7rEWpS4WSptDK9N9+4aaZ0bvKg1m6eQcajmdRJN9CNjt0HKe+7GJAzN2wkXZS7ux4HXVcxKDMMaTXDzNBM1lM5WSSNlJk57geEcYlELYI2LLjn6Xe5+lJoJQM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(396003)(136003)(376002)(39850400004)(478600001)(52116002)(7416002)(5660300002)(1076003)(6666004)(316002)(16526019)(186003)(86362001)(83380400001)(8676002)(26005)(6506007)(44832011)(2616005)(956004)(69590400008)(2906002)(4326008)(8936002)(921005)(66556008)(66946007)(66476007)(966005)(54906003)(6486002)(110136005)(36756003)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?jtZsCdSmoVPXAJOTpj+l7BXSsNUM12Iz6fC7ihkENF4BCh9p4XYjXG40hsW9?=
 =?us-ascii?Q?+z71sKJI5RPZIaepuSlIpieC7RxnqaWh1TluUxBQ9VPWP7sba2Syo9CJTTdt?=
 =?us-ascii?Q?mYrQ+RhN9bOhs9ld3tg3KcWpAsc/xWqCdpXMVXeh40wtgDxc/tFDmvOxsdkk?=
 =?us-ascii?Q?cbHbFw7q/PiGQFS+nnuJeWpQyjONMUKzDgJ41ErYFfpUNx74UlzNJLVE/sqK?=
 =?us-ascii?Q?qT2sl9sU445cGgRCGqFo0ZmaeIgu/8gRMWITUhrUawUHVTI9fdF+Tbbu6PUV?=
 =?us-ascii?Q?PvHXyS9fCMP2PPRaUETlEqvRjQublqGNzgFtiuyhYYn5A/axiPhYvXf11HFW?=
 =?us-ascii?Q?jfeBnK4c3ffcFFhpAn1/dFHFCGhWzvFxhADPdbUX3jX074NMQLd3G205cU02?=
 =?us-ascii?Q?wYvlyddWfVEQZSwKu0WISbALKUCwhLXnmtmg7zkgcqmVMVetw9zuWpLJsRJg?=
 =?us-ascii?Q?in49mMX5PBJ/m0jMZNCICsNnBQO9QNBXaKtOPAy95cAfx5aNJOUdI60cGW0J?=
 =?us-ascii?Q?lZVsyaK0DTlO8F9w0fGtcyn+FT4OyYnOkl51IsVYNq5dJtNFsk+DiwjvWd0T?=
 =?us-ascii?Q?kju9c+klT4RZoLYukhpGYIRAbe120tra7IKpmLRr82WEGAOKxQh4urAomhlg?=
 =?us-ascii?Q?MUJrpefccS4pIphizKw8UR8pFbmagHE+aWk31fZW4xSFf1RVKEeuPQk9QeWF?=
 =?us-ascii?Q?83YHyLuCIyCvruH6zAZWFY2FKyDPrkgy/5fQ6RLGdzLfZgHT0LJL4IZqqInR?=
 =?us-ascii?Q?YxV7BKA//ug40VopOA8JJ1ya6gXLIUnAUaulvu5xOtYA8GF2tMArrLge/hHX?=
 =?us-ascii?Q?iYeRyFRZ2wLEekRvpUk8Rw7uH+BX4C9YETKko+oXG7h+hQRfjQRgurOh9TJa?=
 =?us-ascii?Q?Mf6XVF4sWmf2jQkI+jdVVtDudgzoFWP/1blwNdAktZW8TMkpxOpdr3qacSIS?=
 =?us-ascii?Q?IeDsvHIZgiu072rDT1gZy4wJMOwqsmJBqJnskX7s9HFj4RB47lmGG/+D/Zbn?=
 =?us-ascii?Q?sdWA?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2020 14:07:36.2124
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c8c09e0-98d3-4be2-5aef-08d89f70718e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qO63xEEAU5n5qEokvpmjwXZaL3x0nAfVm5Umo7XM7pjE4ahuGTQHZdDZ5OMCun5B9gwk8bgx7urdkQdyQH94qA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7341
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series tries to make DSA behave a bit more sanely when bridged with
"foreign" (non-DSA) interfaces and source address learning is not
supported on the hardware CPU port (which would make things work more
seamlessly without software intervention). When a station A connected to
a DSA switch port needs to talk to another station B connected to a
non-DSA port through the Linux bridge, DSA must explicitly add a route
for station B towards its CPU port.

Initial RFC was posted here:
https://patchwork.ozlabs.org/project/netdev/cover/20201108131953.2462644-1-olteanv@gmail.com/

v2 was posted here:
https://patchwork.kernel.org/project/netdevbpf/cover/20201213024018.772586-1-vladimir.oltean@nxp.com/

Vladimir Oltean (7):
  net: bridge: notify switchdev of disappearance of old FDB entry upon
    migration
  net: dsa: be louder when a non-legacy FDB operation fails
  net: dsa: don't use switchdev_notifier_fdb_info in
    dsa_switchdev_event_work
  net: dsa: move switchdev event implementation under the same
    switch/case statement
  net: dsa: exit early in dsa_slave_switchdev_event if we can't program
    the FDB
  net: dsa: listen for SWITCHDEV_{FDB,DEL}_ADD_TO_DEVICE on foreign
    bridge neighbors
  net: dsa: ocelot: request DSA to fix up lack of address learning on
    CPU port

 drivers/net/dsa/ocelot/felix.c |   1 +
 include/net/dsa.h              |   5 +
 net/bridge/br_fdb.c            |   1 +
 net/dsa/dsa_priv.h             |  12 +++
 net/dsa/slave.c                | 174 +++++++++++++++++++++------------
 5 files changed, 130 insertions(+), 63 deletions(-)

-- 
2.25.1

