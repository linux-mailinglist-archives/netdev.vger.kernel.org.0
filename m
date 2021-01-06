Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBB2C2EBE4A
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 14:11:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726706AbhAFNLM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 08:11:12 -0500
Received: from mail-am6eur05on2065.outbound.protection.outlook.com ([40.107.22.65]:34081
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725828AbhAFNLL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Jan 2021 08:11:11 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xnc6AECK7cQpMYAcbtnc8hmeWRc//iLMjmW0++IH82SX6cBUzy+DnuO0UweMTgtEpEXrZ5lo1ahktCIRUWTyxosa4zapOMb7orz9Yix9LVOqlR9d5z/XZuI06ly6M1OxXRYsPvJT8iJHAcsL8mzyF1QDbKpGiCGZ4cJ0KKalYcjWRagrlehnyxqzgK1lnFlX8VuRR1eyXX4qrakxsBXGdpWM6Zotrcc4M6c/WFgzd21IxFTuav7RACesXsYy+vjNH44zF7uml5YlGUen0PZ6yymS/Om5EsPEBtXNDgRrT3sF6wWxLg3OeqYD++PlGlxC2sFJ6ma0VPm2zw3uyHFxlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HHjj3ipmtYu3zkHdBtfLNQdp2+yrS8r2S/V42wSuXR4=;
 b=L3B0XvVj2TzKYX23MgUUzSPKMVe9Bq+rLE+Zx0KVpDZWuKN35BukzvJER2pEF5RAMoaEFQRESs461ExP6WAZmI4aUkVM+QPhiFdXGvDw3Sv05NbFZPWP1TKZkGLLb36qCnW0eph4tlQWyP02qp/286ArdyKEL1warmi0wqEb7OrSu43/czZOVH6zT/yEctZV0mIdmT42ccOvnK3LQGMTT5NkkSy/s6V+ix/sMGvesOGxfZs76qnobfADNxI069VD6/EMmama8MRMOc27H2aPA5JplW3OC0JsLF5u9bsyj0nXjb1/pZJSjuo/2Q/Ap/R/ggG0r3DlUSz4tXUOpqdpBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HHjj3ipmtYu3zkHdBtfLNQdp2+yrS8r2S/V42wSuXR4=;
 b=pGpTnZJwICKgq+tmkrXMbM509QX4m/au3evn4hhR/+Q+rVxFzCtKqktq4vxeNyDCviYlVGD0I2yEvWF8wAYZSaM/XHseBVBN8QRptfKOw049aAGWt2Uwutu4KzZnni5OWtDSV0ohYM3Z40U0ureH2+qb/3viFvWKrVjaZDY+Pog=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from AM0PR05MB5010.eurprd05.prod.outlook.com (2603:10a6:208:cd::23)
 by AM0PR05MB6418.eurprd05.prod.outlook.com (2603:10a6:208:13e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Wed, 6 Jan
 2021 13:10:22 +0000
Received: from AM0PR05MB5010.eurprd05.prod.outlook.com
 ([fe80::f463:9a6:abe8:afec]) by AM0PR05MB5010.eurprd05.prod.outlook.com
 ([fe80::f463:9a6:abe8:afec%5]) with mapi id 15.20.3742.006; Wed, 6 Jan 2021
 13:10:22 +0000
From:   Danielle Ratson <danieller@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     mkubecek@suse.cz, f.fainelli@gmail.com, kuba@kernel.org,
        andrew@lunn.ch, mlxsw@nvidia.com,
        Danielle Ratson <danieller@nvidia.com>
Subject: [PATCH ethtool 0/5] Extend uAPI with lanes parameter
Date:   Wed,  6 Jan 2021 15:10:01 +0200
Message-Id: <20210106131006.2110613-1-danieller@mellanox.com>
X-Mailer: git-send-email 2.26.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [37.142.13.130]
X-ClientProxiedBy: VI1PR06CA0138.eurprd06.prod.outlook.com
 (2603:10a6:803:a0::31) To AM0PR05MB5010.eurprd05.prod.outlook.com
 (2603:10a6:208:cd::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by VI1PR06CA0138.eurprd06.prod.outlook.com (2603:10a6:803:a0::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Wed, 6 Jan 2021 13:10:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5599776a-adf9-4be8-1095-08d8b2446c92
X-MS-TrafficTypeDiagnostic: AM0PR05MB6418:
X-LD-Processed: a652971c-7d2e-4d9b-a6a4-d149256f461b,ExtAddr
X-Microsoft-Antispam-PRVS: <AM0PR05MB6418D2FA93FFC4B070F7C902D5D00@AM0PR05MB6418.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3jAwcgB4IKj64tOHi8N9XuM7wpMv4/ZLl2QpmhY+kamAeahkbYiC2mo8GevgA9S81o4PoCy+aAOMYmiQ6nfxwqgzxnR33mjY0F/pmDUqGBoxXQDwM5mBkGnngr+MAXLC/5QGjn26z7VhW1mEfSYGhLPU40vStvobe4FBDxFTgo6mnkPawAW2jIEK3QjoNajZLJpEk0yxd7kdesphr9ccKsc4ZhcjrvvtkF7n6Z3jkVGmFKzcDHKrSvHgpfB8WZbJk32z5a5XaoX8MiGOV8+JO0azu1E7Td8X7/4st69P224rW+qRUkA4oh55SfIp3UFzbm5VeJIjcdke/0JOam3KdetbxjiJeO89KvNZfOL9lBwUug4SXAXHbMH+pylgp8wYONcjZHz5GeRjRfyEs9wscw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB5010.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(396003)(39860400002)(136003)(366004)(26005)(8936002)(16526019)(186003)(6486002)(6512007)(316002)(6916009)(5660300002)(6666004)(4326008)(2906002)(6506007)(956004)(2616005)(86362001)(1076003)(8676002)(66946007)(478600001)(66556008)(66476007)(36756003)(52116002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?CGvUF96XdBSYuEFFNXjlnok/clSnM0xa0lLzcuJD9LRwU9v3JVa7iJZT3EKx?=
 =?us-ascii?Q?1qYeoyXKR3St6+u040pUazz+nDfvvw/SvqBziSEl84A7wY5BvEhBM2K503yc?=
 =?us-ascii?Q?/g9viJZMp8lzxg+t9FHxNb3VlUOArRhnodlzdqs3mLmb9bFHhdAl4BLHCIqo?=
 =?us-ascii?Q?wa71qr0yqroUlh1W4Tb2GsDY1IeCNelIi/SotFzHuKrd2qcLJDLxcKKiI0vt?=
 =?us-ascii?Q?ysLbtbwNOMVcmPChRMTH8X4VpwRi7dIOWGzIpU7CrQXTz8GPfJvsInCWS3JW?=
 =?us-ascii?Q?yuOXDHZSRLyK4a1Lw+8yCLHj/Hz/i5kRPQ86aR5dZPNiQ+py9xtnvxZFnrof?=
 =?us-ascii?Q?cRpqHT8ArhPDtf3XxHe4VfY8NwVRPoF3AQvxcjVXkXJacY2W0H/dfhwLUq82?=
 =?us-ascii?Q?M9ClqtNc8dxiMsGmqEEkSlt44fnvGjeNgQldFGt9E57P4bCcXtFmHTnfhDmf?=
 =?us-ascii?Q?mJnPdWSNaJ9k849sbBEFOSVHsY5GWDkAyBivps+/b1SlFJ+DuzAPOZ2Yfwrn?=
 =?us-ascii?Q?KtsZe/++fJUKEEV4JN0HxrabPvNZUS9z+vQS+EyfxXtAGksxYhxOG8UM7jaV?=
 =?us-ascii?Q?EvddzR9VkChdYcTdF68zveXtkrtITXjonzdO56BWyXbI6e1irBIuvDOIfAO5?=
 =?us-ascii?Q?zRmavzSHvJYfzE7bXWNQXQkvO93an9wd88HYM4oWPVO3+mjowbm2cNHPAPKo?=
 =?us-ascii?Q?EzYc1OPpEhrSIzO5i8evCdWObopmYV3JwO9z0P+12G3cECN7hW0jW777zsvL?=
 =?us-ascii?Q?YqIZVif5B+R/OkzR0pBV/Z1RjpCrz9XMZGVMZfsPfLfvmlKbixA7KBx8FUvF?=
 =?us-ascii?Q?lDhio4Ni2ZtnghAnGf5HqkptSXzqLiA3HWhP2xX9ULtjcEFEWf6Joq7ZtTJt?=
 =?us-ascii?Q?N8GPULlPn9TQcbJ67W2XilCGLJE1krgqCUGtG2+azMilpdAxL/Kpg+xbeDIy?=
 =?us-ascii?Q?w5CCv9mR9J/xVDYIq7xbEMh0GmVcTeS0YNyOfHAdu/JFOms88mdGqZc/TT5K?=
 =?us-ascii?Q?5JN/?=
X-MS-Exchange-Transport-Forked: True
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-AuthSource: AM0PR05MB5010.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2021 13:10:22.0937
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-Network-Message-Id: 5599776a-adf9-4be8-1095-08d8b2446c92
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e1AVRT38tc0qKJArO/KQGhZqPiXhRtEXMcnlCmEGLO1xZt8jnnjtqpxzU5TVGtHu17r7w16BI3WHXafZVLcsew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6418
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danielle Ratson <danieller@nvidia.com>

Currently, there is no way of knowing how many lanes will be use to
achieve a wanted speed.
For example, 100G speed can be achieved using: 2X50 or 4X25.

In order to solve that, extend ethtool uAPI with lanes as a new link
mode setting so the command below, for example, will be supported:
$ ethtool -s swp5 lanes N

Patch #1: Update headers with the new parameter.
Patch #2: Support lanes in netlink.
Patch #3: Expose the number of lanes in use.
Patch #4: Add auto-completion for lanes.
Patch #5: Add lanes to man page.

Danielle Ratson (5):
  ethtool: Extend ethtool link modes settings uAPI with lanes
  netlink: settings: Add netlink support for lanes parameter
  netlink: settings: Expose the number of lanes in use
  shell-completion: Add completion for lanes
  man: Add man page for setting lanes parameter

 ethtool.8.in                  |  4 ++++
 ethtool.c                     |  1 +
 netlink/desc-ethtool.c        |  1 +
 netlink/settings.c            | 17 +++++++++++++++++
 shell-completion/bash/ethtool |  4 ++++
 uapi/linux/ethtool.h          |  8 ++++++++
 uapi/linux/ethtool_netlink.h  |  1 +
 7 files changed, 36 insertions(+)

-- 
2.26.2

