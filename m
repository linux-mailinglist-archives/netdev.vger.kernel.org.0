Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ED903F2B9B
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 13:58:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239192AbhHTL6l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 07:58:41 -0400
Received: from mail-eopbgr50067.outbound.protection.outlook.com ([40.107.5.67]:25139
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238099AbhHTL6k (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Aug 2021 07:58:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=migV8/gDcjzP8IO0/sL1Bpphv+hOTX1pkqQhKPyVaG0xW1/5/cNBJg51uETgFlETlDQiaYjgdotrMjTQ9/N/C8P5Tj3/z/H/WDDGpQBK+nw27LoMSyxmk2pk7g4fujmCd6SmXTnRE9NskmBD+ZPEPDl6vUY1wKmF1LlFk9/EiJZFKo21RrfGilzufaGX+KvrdcWItmLye7m95yzzylQFLelUlrj3XI7BGK3KGEYNJ7DSW7jUxASa8ba5Rs5mTvJcoeXBSFYw/vJCg12yvmzMDQs9aLakdyurJOdRBjWR//8gI8UFwEFc+YkGkiT/tKNTGXbP8t+YVjX9TmXqW/O8xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B0VfFnOhJEXLxO3AAm/ssO+uF2DF2mIqQAZt9xvTrnE=;
 b=EcTJsxETklyzzJ0R8uKCAX9jhhoCmd0EmUjbL6B2G/MWETHG9VVkWd4MSVvsGthpCkZvTmRET8dfKy7BN4i0z7JgCEimlBpQNrQ0Qf0nQ2gKcpIp0MbVpmxxZTkMgclMvG06Fr3cTFFOquMqJWb5QWC/QPipoqoR9LYFDDE/zt4osSSmHxx0RXZoCra2E/fLZSaokWOk4+YIghogswaUvLJOjtw+tkYfK+qJhpsfCApmi9ba2HfeofiFOaXSF06C4MDYX65KSoW2tiPKuJJBjw7sfUQ3Q/YqoUpcgkxf/+5ZRVjQ+je/9a2b/wsGXEppba76rV7xd1w3dmLP/Jg1Pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B0VfFnOhJEXLxO3AAm/ssO+uF2DF2mIqQAZt9xvTrnE=;
 b=cByIaN8AfCBIyfvmxAwRyZRWi4ZhUMOywIZpn4TvLurk/+29O02/cHXGdCG63n6kQLP0zFmBy40MQFXvqxVr2BMtfDgvStFwg7NL8nh6zMgdI+Z/13F1xMzUj2NuqfbqGcQ/SGGmrIUQyXi8NQXZMGaeCZHhhhms0XZsX4Vij2I=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3839.eurprd04.prod.outlook.com (2603:10a6:803:21::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Fri, 20 Aug
 2021 11:58:00 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4436.019; Fri, 20 Aug 2021
 11:57:59 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        UNGLinuxDriver@microchip.com,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Marek Behun <kabel@blackhole.sk>,
        DENG Qingfang <dqfext@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Jianbo Liu <jianbol@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        linux-s390@vger.kernel.org
Subject: [PATCH v3 net-next 0/7] Make SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE blocking
Date:   Fri, 20 Aug 2021 14:57:39 +0300
Message-Id: <20210820115746.3701811-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR04CA0010.eurprd04.prod.outlook.com
 (2603:10a6:208:122::23) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by AM0PR04CA0010.eurprd04.prod.outlook.com (2603:10a6:208:122::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Fri, 20 Aug 2021 11:57:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: af9c0f02-08eb-49f0-ad67-08d963d1c15f
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3839:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3839B0B6481F0C358B7EE649E0C19@VI1PR0402MB3839.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uTs6FqY2QBknZLEU1BHKIiMFpeLTXyvVV5MyOj+r8nG8sWIrJJGfBrxjf0nuv2Hukioqwogi24aSpYPX0Tz6LfFU8Q9nFHuDwr1LRiQUlDd0IP9VOe9JE9+T6MAm4gt98kcbM4sbmlRDDiDRTPU74CTUbdtklCJFK9xdhgtqwRG8spI098CiQ01PK9ilFiL5xf/kG1tZr/LDYJiX0MFIUN/e/qkePqXeq6Q5OFWAbTF2irX018x+ftdmXRPm1KoJ5yoQaD7T13lb19XknOdvKM2vqArnyd+ECqr0MYerXwwX/JIfkprnWCqd2+u8Ab60HRH9PyRr8S9zfE14uo3mTcdEGmGqLI/GRisdSwrg59A1jMFVxy5L8sI9kN6SRwJspAM7/qdEnr/G9w+ALqWnUXK7QhajiNra3VWTFWx0sdUEYRt0NxZw3tQ09kviNK81db8HZltg6DO8fE5QJhXyhCu+a+cEhW5bBCKaC0p2U7pjxMC3xR+pjgo16yqrVzR2mFZqH8co8c5/ly3Ytktv7U/GVv8hKInx2Fr9JILa/jZioSmLrhQOTYYHrQbL9OjfqownpqiygjkBbTNlFghJQm+YT2UyeOYVkdNosmYLk73OoDs+b1QN6upFRAm+jE7ghHDjSKnWELGnjbXKfkwdtfO0+RvdeitrhRc3O7VxZDbNoDacM17xh94RbMZsbZe3UsNsIufCGHA7cl0OgYZq7ZpakVnuZRYjJ7TDuJXAV04M2rP59DqfNrGbRzoouATzH2kGEGNAwRAUay4an8aVbQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(366004)(346002)(376002)(39860400002)(8936002)(8676002)(26005)(6506007)(6486002)(38350700002)(38100700002)(5660300002)(66574015)(66476007)(66556008)(83380400001)(1076003)(6512007)(66946007)(52116002)(7416002)(7406005)(186003)(110136005)(36756003)(54906003)(478600001)(316002)(966005)(956004)(2616005)(44832011)(6666004)(2906002)(4326008)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8+BO1CtrXAspnGRcFSdS78nWyLbJZRAI1PF3pXox2Nks+cbXxMzQJLrPlJO4?=
 =?us-ascii?Q?t0W3xRAups7G1OYHjAf8AEpZRy5Jhs/9Re58SqJUF8tZWtTh80JnJjo+pJCi?=
 =?us-ascii?Q?sae3Mu1LXfmAlaYO1BeP9ujh8hQQkaRmCIQVQUoR+fieKyy0/Ef1na8Myv6i?=
 =?us-ascii?Q?iR4ygyxsqRLCxXo7R+EZ4yqEezRtRAhc1JD1bWjk/ttJgazfjt1Wa7TKrWIo?=
 =?us-ascii?Q?Z86GKUrPSW2ua4bh1lXKPzFUwV8OmuLN3F3jSJQdD+vYEWmtkGOA/o3R8mXu?=
 =?us-ascii?Q?0Pf7vGLkmAxHGHVyEB5pa6VhH8U+ifbleFjktaU7PAvVmUoG7zCVpontodU3?=
 =?us-ascii?Q?Wxsd8zGoKppM8E0rUB7nUXtji3giOx7f5x/QoMB5jplV+B9vkq4rOO/MFImG?=
 =?us-ascii?Q?oLZELKDzkgoFJ9zm508JlsbKblWyTP9S+hoPHIW7otsu311MYKSQirpD7GYv?=
 =?us-ascii?Q?SaHGTt0xQuWBvqX76T4Mga46/vQdMbpNEqRfjUfP2+J/w4KTYOiRk2CVLONC?=
 =?us-ascii?Q?9gZBLuEdPRp9V1dh0j5trosa6mAGcjLucmA0m6jdoC20qOWSqVIJpX1c+Ov6?=
 =?us-ascii?Q?+jzhAS0iHwQvu9ORU0I+F/nU+2RWmdkPTNPjI3hcVGptme70bvJxTZ5EtIDu?=
 =?us-ascii?Q?zLRoCXtlhJPBaF40AN/yycgP3jU4LcoWg9aNEoW3ik9HDbtEFDrxXUFCG8FP?=
 =?us-ascii?Q?2ehIPRcoL4BOriFC8pLdW2MvihRvEVH9IXXkYASlhA+yyvlPJvVHBUyrWk1B?=
 =?us-ascii?Q?5qOvugPnnWIKgB5hq31Rf1KyHiBfaLtRdXceVtGSNBiAJ2vUG8obvQ4T6oE2?=
 =?us-ascii?Q?lSJW7uJV4TEvbE0JXj3w1YuVK4XsM4N+ra2R4Q4dsNW6GRp1gj7El0vGGI8v?=
 =?us-ascii?Q?vVieIMdWJrlC/eUCNqgnGOogzrOn+JpR710MfafCkRcemtT8AMR4b0+U8SeA?=
 =?us-ascii?Q?v6zLaPWiucdZRQ2qxh0/Bs0gJAbA5/jjcqjhbTwY3FOvlJOsldx4QSGzB2yQ?=
 =?us-ascii?Q?ut28k1cGf+PZoin8IOHDfY5o8OOpYdKT+kV8CvGcj+fGYVAPebWcqbn5t/e+?=
 =?us-ascii?Q?LqQK68bnGGSAHWp94SEHbCscqBmkX+IRdKzpFbNa9fDoKD0ngjsOqGSUdDT4?=
 =?us-ascii?Q?w6Ane1YtrWPZ6tLZoO0dtZ8xuAikXQhNYQVu0IPhNpds0AnSTjJZZ1CkcFhr?=
 =?us-ascii?Q?EyH2K6jGztZkev9JbZ92kXLE6eeECuP9QiR8n0enj6A6deL/4ajlwsZXOg5C?=
 =?us-ascii?Q?AVyI8uRCsq6quKuvbte+fDWKgs71DtsJVJI0XuW27b3cj29y80pNk2twKKuF?=
 =?us-ascii?Q?EciN1+qnx1qeFObZok6BjdE3?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af9c0f02-08eb-49f0-ad67-08d963d1c15f
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2021 11:57:59.6081
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FhekU67jikgtjrmJWbxGuirewtCl4G44S24g14jVB33UX0HCtc3pXVQ11cu/E5N9Ryhnq1kgWn/InhviIlhilA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3839
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Problem statement:

Any time a driver needs to create a private association between a bridge
upper interface and use that association within its
SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE handler, we have an issue with FDB
entries deleted by the bridge when the port leaves. The issue is that
all switchdev drivers schedule a work item to have sleepable context,
and that work item can be actually scheduled after the port has left the
bridge, which means the association might have already been broken by
the time the scheduled FDB work item attempts to use it.

The solution is to modify switchdev to use its embedded SWITCHDEV_F_DEFER
mechanism to make the FDB notifiers emitted from the fastpath be
scheduled in sleepable context. All drivers are converted to handle
SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE from their blocking notifier block
handler (or register a blocking switchdev notifier handler if they
didn't have one). This solves the aforementioned problem because the
bridge waits for the switchdev deferred work items to finish before a
port leaves (del_nbp calls switchdev_deferred_process), whereas a work
item privately scheduled by the driver will obviously not be waited upon
by the bridge, leading to the possibility of having the race.

This is a dependency for the "DSA FDB isolation" posted here. It was
split out of that series hence the numbering starts directly at v2.

https://patchwork.kernel.org/project/netdevbpf/cover/20210818120150.892647-1-vladimir.oltean@nxp.com/

Changes in v3:
- make "addr" part of switchdev_fdb_notifier_info to avoid dangling
  pointers not watched by RCU
- mlx5 correction
- build fixes in the S/390 qeth driver

Vladimir Oltean (7):
  net: bridge: move br_fdb_replay inside br_switchdev.c
  net: switchdev: keep the MAC address by value in struct
    switchdev_notifier_fdb_info
  net: switchdev: move SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE to the blocking
    notifier chain
  net: bridge: switchdev: make br_fdb_replay offer sleepable context to
    consumers
  net: switchdev: drop the atomic notifier block from
    switchdev_bridge_port_{,un}offload
  net: switchdev: don't assume RCU context in
    switchdev_handle_fdb_{add,del}_to_device
  net: dsa: handle SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE synchronously

 .../ethernet/freescale/dpaa2/dpaa2-switch.c   |  75 ++++------
 .../marvell/prestera/prestera_switchdev.c     | 104 ++++++-------
 .../mellanox/mlx5/core/en/rep/bridge.c        |  65 +++++++--
 .../ethernet/mellanox/mlx5/core/esw/bridge.c  |   2 +-
 .../ethernet/mellanox/mlxsw/spectrum_router.c |   4 +-
 .../mellanox/mlxsw/spectrum_switchdev.c       |  62 ++++++--
 .../microchip/sparx5/sparx5_mactable.c        |   2 +-
 .../microchip/sparx5/sparx5_switchdev.c       |  72 ++++-----
 drivers/net/ethernet/mscc/ocelot_net.c        |   3 -
 drivers/net/ethernet/rocker/rocker_main.c     |  67 ++++-----
 drivers/net/ethernet/rocker/rocker_ofdpa.c    |   6 +-
 drivers/net/ethernet/ti/am65-cpsw-nuss.c      |   4 +-
 drivers/net/ethernet/ti/am65-cpsw-switchdev.c |  54 +++----
 drivers/net/ethernet/ti/cpsw_new.c            |   4 +-
 drivers/net/ethernet/ti/cpsw_switchdev.c      |  57 ++++----
 drivers/s390/net/qeth_l2_main.c               |  26 ++--
 include/net/switchdev.h                       |  33 ++++-
 net/bridge/br.c                               |   5 +-
 net/bridge/br_fdb.c                           |  54 -------
 net/bridge/br_private.h                       |   6 -
 net/bridge/br_switchdev.c                     | 128 +++++++++++++---
 net/dsa/dsa.c                                 |  15 --
 net/dsa/dsa_priv.h                            |  15 --
 net/dsa/port.c                                |   3 -
 net/dsa/slave.c                               | 138 ++++++------------
 net/switchdev/switchdev.c                     |  61 +++++++-
 26 files changed, 550 insertions(+), 515 deletions(-)

-- 
2.25.1

