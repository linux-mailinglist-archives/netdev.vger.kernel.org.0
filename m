Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 145C95A6DF5
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 21:59:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231817AbiH3T7z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 15:59:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229842AbiH3T7v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 15:59:51 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2063.outbound.protection.outlook.com [40.107.20.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D00FE252;
        Tue, 30 Aug 2022 12:59:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JYkx59xgOznERSpAqElt7wdkSgrQtIkjneGXc4gSfAWTGPGeiTwtuWv+XLrfouo7oMlNWVw4TPCUZC47fffXoZScVORGJVzAPkp3EYIWC+2/nvkg9YEUdZbYCjOiea9UDpZnT0EMmmkT6JCrWnrk/EG+J8INxnH3j328D5jnDRTAXmla44UTiTMCgWZ8igKpzVfd+gFI15XrmCWeROdjEVZNweKkxzjsqOzCb88GkpUsObx3jKVaztvuAhiMFySNXX7SzjHsJXpL2Kyhi4Kv5p/IYCE0Tzu92vC/gqFz1vBYP8f5cDB9EoNGb0C2EXWHI2ITZs7V8EGi26753LnDTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZQNuxSredIr7K400qHd+wTVjoByguZ0F4DKTZHP04xY=;
 b=GblM57gEe0M0EjFaCjTLoB9saH2pf9VVVdKedqEH57vJVmE3Rc0/+9mchdY5Ls+ynyjYi6A/LbCnZhyb0dEm/a/Dogl5BcONagi0yscmHBon0h/9uBUbE3s5Ug8z3QYUowczUYeQPw79qDWwxq0wOfxrwVIDuU+uEma3ekr/qeHdFSiz070outBPuqCXv1Sszgyay+ER3Q0psHc+W6RN3p1vZUyHpLP+uWFtxmloowhLk/lo5ht+DyKmPBqhzIDviMY+eJmJwIEOpr4gKMLunBdOxzE6y818wooCBz7MWjGh+UagA89CDHiJ1BYsLzkUJWnAJpmS8LL9tmhoP/RM8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZQNuxSredIr7K400qHd+wTVjoByguZ0F4DKTZHP04xY=;
 b=ZdvsAgb/qAn5EV3IdZFETAmexTQzDnqsqQVpZ7Z7IIbj9NEtQyjTScCdt13vCrJJkSmby/5lksrJczWR2lCnG8m6el11mrYW5fnZkWrRGPBejPNRD+3elHXQhi8I3l1K6AugnwMTVd6H/1p8xXhT1pNvBs4MTdpuz07AnJifB4k=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6270.eurprd04.prod.outlook.com (2603:10a6:803:fb::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.21; Tue, 30 Aug
 2022 19:59:42 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3%5]) with mapi id 15.20.5588.010; Tue, 30 Aug 2022
 19:59:42 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Colin Foster <colin.foster@in-advantage.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>
Subject: [PATCH net-next 0/9] DSA changes for multiple CPU ports (part 4)
Date:   Tue, 30 Aug 2022 22:59:23 +0300
Message-Id: <20220830195932.683432-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE0P281CA0005.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:a::15) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9da0c8dc-43a9-4c46-99ba-08da8ac22d8f
X-MS-TrafficTypeDiagnostic: VI1PR04MB6270:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GVQD9uMF20R8vkWllR2K2WeP9kIGD9ZahYsuQ7MCGf2eQnj5yOJCbWknxiPEp7yDdSu6c/s/3HD0Ck5o4jhAgPZEYaPWL6eNEkHzXWCYuZRDmmmq8vBaUwqC93WmT31tRLLEZBjp+ePFJpDDzyziLLQ/7VLdu9Jvrd++cJQapJ3rXqiTu6m/IJKyhDUTgquFe44klrdgRWPDBn+hzNmX5fmyQD3jFFbWa8Siw3GR4sB0+hNTUcmwfGUXpn5oT9xdUspwW/pZxwTBE+0420MQ7YARm/pIJb4g7kBjbvNJy4l6MBROIiWAgXyThVYyI5b9+yPhRWZOTmE2ZLqavkNflcBMsTcnxeXARD6WpZ8eXTt3fzIwI5LTaLKhUtBoXb+BR7lY2o+Ll1R/i26E/90OWT5lEeE7BxwLgqA7No0wbzPJJoUc1fg7W2H6WsS6a8e29lU3s7/TVSaGQOnV5RTpAMmkzhzk+LRlHa8zNk30aE2z2GK2DVXnIsvGnmcl4ZHU14+1KVw4uraO+vgoZhmiRupa6WDQbEDl0wfUut0AEer5U0iyqWjp0s1yclYCKDxgYN/EdP6sWQSrhih8+b8IMTo7xeJRqufCqoJ+Aw8FFmdPHKp/cAD0GEyIRi/v2a4vq+2nic0Lm7ldVieqkiO5+JkIWzkQPgVdbeNCkO/NwgluuR2fybPOTV6cQLLGYzhWL6n0F3u3FJxctdi1pMuNSvNURQQMQwmh8OP9TfTfLvFuuCaoReJegjxH0CftmiTD2sDLb0+VSUYYdUWWrMn+Hil3S3l5c0dYkkG5bvimVlKbw+c5adkKZ1rGyh8xLA6ESuzvv3ndm52tKyvk+0WEOQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(346002)(366004)(39860400002)(136003)(376002)(41300700001)(66476007)(6486002)(8676002)(4326008)(66946007)(478600001)(66556008)(52116002)(2906002)(83380400001)(966005)(44832011)(26005)(5660300002)(6506007)(6512007)(7416002)(6666004)(8936002)(2616005)(316002)(86362001)(6916009)(54906003)(36756003)(38350700002)(1076003)(38100700002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KrGQoroWjx1nqMQ/uyq1nlI2OScrL8cl9+F7NOCeGLIt8Mmpm5m4d3wzYsvA?=
 =?us-ascii?Q?yUvPwcUD7lB7J3WzPUg5wcbm+OfpjKUmMQ5xbTDWKLwyT2TZ27BCLzkl3kcS?=
 =?us-ascii?Q?CTWZKLfUOQZoFgcuIiDqBpA7NBrpIIP4QM4VLzGIi1KHh3lnHSCmT1s9MbFG?=
 =?us-ascii?Q?ttAOWNn91V6hA4oI8gadZUUC78mplooiB09Iac3MUSuWJ6TUGPQcbJdgCmZJ?=
 =?us-ascii?Q?hECElZ5yEk3UKVjGDeWO86jijHS2ZwhmnKrk5j8mw4sSGRjBmjaIENKxEDQ0?=
 =?us-ascii?Q?ujpEwEAvN/4aoVO+1UuR7IX4tfpJb3h4PWRK5LNIRzrZC8mTx98bVaud09lR?=
 =?us-ascii?Q?wuZeuLxWpbQumFXce2V3AEW+jO710zLfOU1GGYzr+9BsMoVK/KF4ZZZYgKsp?=
 =?us-ascii?Q?kAN/+4u/p7nU9Gkhso0ioeqDgsX4FCAUJFuOPwMhOJlQcE+X27OQXVTVdazE?=
 =?us-ascii?Q?IKZsfjX/6gMJ1QrmcNCzGrYClhvygTtgGXwM3skCIP4jJTHXEPrjNp59SPQa?=
 =?us-ascii?Q?UR06dkwmOg1UJmDFYG4Ajx7x3Z4W4M0JLfLdImF0cHPx8G314pkI1IM3/obK?=
 =?us-ascii?Q?8BrTQEg6MxSy2h+vby2Bg5/q1vAySVFnMz76sqJRPKz7g8cuYlpK7WAbTkpE?=
 =?us-ascii?Q?Cd9/cs1j1u8sLFyTNGIsMceM9+w26CTlb63YZeuqZj3UziMoB1y6koKTC8Xa?=
 =?us-ascii?Q?3paLTHIatBx+zuEEgnw1gXOsNfUy+rm/dmyaDp50VfIGPvaztBKqyPzRu6ve?=
 =?us-ascii?Q?qY4uUUgRV9sIAKA7YGUXDfaXDUBMnkVD49071KLZBIunI86US6eVXRnhoxne?=
 =?us-ascii?Q?7y3iOs3aflMDesXn5COe0iToot6QJtrmpYSP5FcvmlZD+stqhwXXKhtubWX8?=
 =?us-ascii?Q?jg1zmuzmi08EguYNqOfSu/aAcjasUVDc84ej9gmenusxjVxAW7xNwdaz/Xgi?=
 =?us-ascii?Q?D3NaBKb74Jec/ss24Y1qTDmuO62F30M28OXBgpX620pS+6NiLplm7ZP3rwv8?=
 =?us-ascii?Q?1J0lUPhtsK0Kw5UW8XB4dKyCLw/e4ZNp7J+yBE5hzhEmQ0CVChmTvr17F+S9?=
 =?us-ascii?Q?KV9J4U2/miTajxEZNP1Fl5RTDaRPjotMHItnrwsmZwiaq7EV9rbLY/Vd5IzJ?=
 =?us-ascii?Q?Jg0UOyIRcTrrjc0FEv1hbRB6N65vWSMydB6vGqzP2sfWibMFmpFMiKV9/tO5?=
 =?us-ascii?Q?W7LsATmj1dzhwCiMynYIvaMRJ1ngd+FtCzApg4v6YQBQ7f269dw4v8Xt3QXd?=
 =?us-ascii?Q?TQiFDl/5qYvwtDNktPS5dtExKBXoLDJz+DPOViUociiQgOyzyzzCBPjBxGM+?=
 =?us-ascii?Q?wkakRIlD+ABFlkX9CrgJh+x6mzMH3orL1BFjAcSwA9z/ZVlBzIUoyYPqt6Xd?=
 =?us-ascii?Q?MnqpfFih1R70REOs149rPDXFjVDd0lAZHc3SHjjYCxvE/AHmEkTOMcvYryfb?=
 =?us-ascii?Q?f9XhBDWY31MXefOS0IQDCtFEplI+2RdTJffLa+/H1NNZl+vWClWAywzNsISg?=
 =?us-ascii?Q?KYw6XGc7/vBCDgIVlxt9Xxpdac6M5TJ+o51zUSC3prA2Y1jzRMjQ3qzmRxJa?=
 =?us-ascii?Q?zjQRDOf61EyP+QvjgCJ1q+aiwnIlM6KAWkWJI0OGhYRpcG6WjxDnlU7JM62F?=
 =?us-ascii?Q?Tw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9da0c8dc-43a9-4c46-99ba-08da8ac22d8f
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2022 19:59:42.1676
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vK4rykdE/a/f24GcHnh/ovvBqK+4SpX7zF2jXiChgYJys6d1fuKwDSGCWmAV5s0Ge47O8wtCkh9nFYe0/waywA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6270
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Those who have been following part 1:
https://patchwork.kernel.org/project/netdevbpf/cover/20220511095020.562461-1-vladimir.oltean@nxp.com/
part 2:
https://patchwork.kernel.org/project/netdevbpf/cover/20220521213743.2735445-1-vladimir.oltean@nxp.com/
and part 3:
https://patchwork.kernel.org/project/netdevbpf/cover/20220819174820.3585002-1-vladimir.oltean@nxp.com/
will know that I am trying to enable the second internal port pair from
the NXP LS1028A Felix switch for DSA-tagged traffic via "ocelot-8021q".

This series represents the final part of that effort. We have:

- the introduction of new UAPI in the form of IFLA_DSA_MASTER

- preparation for LAG DSA masters in terms of suppressing some
  operations for masters in the DSA core that simply don't make sense
  when those masters are a bonding/team interface

- handling all the net device events that occur between DSA and a
  LAG DSA master, including migration to a different DSA master when the
  current master joins a LAG, or the LAG gets destroyed

- updating documentation

- adding an implementation for NXP LS1028A, where things are insanely
  complicated due to hardware limitations. We have 2 tagging protocols:

  * the native "ocelot" protocol (NPI port mode). This does not support
    CPU ports in a LAG, and supports a single DSA master. The DSA master
    can be changed between eno2 (2.5G) and eno3 (1G), but all ports must
    be down during the changing process, and user ports assigned to the
    old DSA master will refuse to come up if the user requests that
    during a "transient" state.

  * the "ocelot-8021q" software-defined protocol, where the Ethernet
    ports connected to the CPU are not actually "god mode" ports as far
    as the hardware is concerned. So here, static assignment between
    user and CPU ports is possible by editing the PGID_SRC masks for
    the port-based forwarding matrix, and "CPU ports in a LAG" simply
    means "a LAG like any other".

The series was regression-tested on LS1028A using the local_termination.sh
kselftest, in most of the possible operating modes and tagging protocols.
I have not done a detailed performance evaluation yet, but using LAG, is
possible to exceed the termination bandwidth of a single CPU port in an
iperf3 test with multiple senders and multiple receivers.

There was a previous RFC posted, which contains most of these changes,
however it's so old by now that it's unlikely anyone of the reviewers
remembers it in detail. I've applied most of the feedback requested by
Florian and Ansuel there.
https://lore.kernel.org/netdev/20220523104256.3556016-1-olteanv@gmail.com/

Vladimir Oltean (9):
  net: introduce iterators over synced hw addresses
  net: dsa: introduce dsa_port_get_master()
  net: dsa: allow the DSA master to be seen and changed through
    rtnetlink
  net: dsa: don't keep track of admin/oper state on LAG DSA masters
  net: dsa: suppress appending ethtool stats to LAG DSA masters
  net: dsa: suppress device links to LAG DSA masters
  net: dsa: allow masters to join a LAG
  docs: net: dsa: update information about multiple CPU ports
  net: dsa: felix: add support for changing DSA master

 .../networking/dsa/configuration.rst          |  84 +++++
 Documentation/networking/dsa/dsa.rst          |  38 ++-
 drivers/net/dsa/bcm_sf2.c                     |   4 +-
 drivers/net/dsa/bcm_sf2_cfp.c                 |   4 +-
 drivers/net/dsa/lan9303-core.c                |   4 +-
 drivers/net/dsa/ocelot/felix.c                | 117 ++++++-
 drivers/net/dsa/ocelot/felix.h                |   3 +
 .../net/ethernet/mediatek/mtk_ppe_offload.c   |   2 +-
 drivers/net/ethernet/mscc/ocelot.c            |   3 +-
 include/linux/netdevice.h                     |   6 +
 include/net/dsa.h                             |  19 ++
 include/soc/mscc/ocelot.h                     |   1 +
 include/uapi/linux/if_link.h                  |  10 +
 net/dsa/Makefile                              |  10 +-
 net/dsa/dsa.c                                 |   9 +
 net/dsa/dsa2.c                                |  34 ++-
 net/dsa/dsa_priv.h                            |  17 +-
 net/dsa/master.c                              |  82 ++++-
 net/dsa/netlink.c                             |  62 ++++
 net/dsa/port.c                                | 159 +++++++++-
 net/dsa/slave.c                               | 288 +++++++++++++++++-
 net/dsa/switch.c                              |  22 +-
 net/dsa/tag_8021q.c                           |   4 +-
 23 files changed, 924 insertions(+), 58 deletions(-)
 create mode 100644 net/dsa/netlink.c

-- 
2.34.1

