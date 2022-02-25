Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 583CD4C4159
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 10:24:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239006AbiBYJXh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 04:23:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239003AbiBYJXg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 04:23:36 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2086.outbound.protection.outlook.com [40.107.22.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6009C1A6F8B
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 01:23:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PWwFNdmcwKjmo0Yn/6djqIuz1AOP+diqTaTO8T4tBfM+m95FMAiZ5zEAL3UOIxqEQWXnJGK/aglRpgcvIl/3xlufm22GjaiVxZ9m9CzciJCNF6lsOVNlqwaLbqHmhlR9QH3AoU4R+4+ZdpoHcE5BvxAOVZE7yl7t+7v5nesmsgqfuGyHP73tdRYogu/mrmjwPf3oYgLmlU389G03mOTYAYMKjiZ5PmaQR5COJs2XBd+gOVrDBNiN4QbjvspA07tuAELFbpFFqqkf8U8dBikueQFgEMn8vLfj2LCMmT4gVz09XJTbUluoqjJ6yG59/w0v10vXMJk3L87n7ktpJTi5lA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=woUwrj4d6yXYhqp8Aap9/P5t0Ywi1K1ZAEaR8Ol92M4=;
 b=MZILV9zV5uFDuIRC+LLV3KHzkCdfMOWgLe6r9AN8MjbPwyUYzyWDIi40EW1y5JpHSEC0lYOVh3ktUsOmWLmBv+de27+a0EUU7DGcAdiA9Q5xNYlh0Lyi1kwhC8wIDkwXvZtOOsXUr79Xt6BkkoXYXSs8Th5S6OywawQ9q5cnL17wuFk1PEmayMp/s+6FpRSuF0gUnFiasdVZde3k2AAsAlvgBodcVFGJo6npBxt4TG5kqd0j0evE9V1oTR+u6NsgtKFTYzNwBDPbTRHSxfnc8HuPLLPPmVkI15PLamJw6MENMffLGqdDqBxLV1NUJmPh68JJNJsHJ0Ff/9kYG/1b6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=woUwrj4d6yXYhqp8Aap9/P5t0Ywi1K1ZAEaR8Ol92M4=;
 b=S/4/HAXaTJJnd/Ha1jddwz8m3pLvhB1+zziLQbuUgHA6JvRpyi5B3vS+5GMp5TL2afSsqdhgwOFbhCFLjh2c71Te80uN3mx3rRDekZxIUwHiq1seSySVUYa0KIRZGdg4Ft9VnkF+VmHlfriTIoDkXONSywEccKgCp0KpciMYF+I=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5008.eurprd04.prod.outlook.com (2603:10a6:803:62::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.25; Fri, 25 Feb
 2022 09:23:01 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Fri, 25 Feb 2022
 09:23:01 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        George McCollister <george.mccollister@gmail.com>
Subject: [PATCH v2 net-next 00/10] DSA FDB isolation
Date:   Fri, 25 Feb 2022 11:22:15 +0200
Message-Id: <20220225092225.594851-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR02CA0065.eurprd02.prod.outlook.com
 (2603:10a6:802:14::36) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ce5bc9e1-ec5a-49a3-f064-08d9f8406afe
X-MS-TrafficTypeDiagnostic: VI1PR04MB5008:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB5008932EAA4BA12758757E94E03E9@VI1PR04MB5008.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W9i97SL+FjjLT4kvU1tT2EJkFvfYnhQ5/vfAXGnHIiipwzP+AYQFGh+VK+9b4dx+UPnMIzTak4RH1XdARDcIltB/RSSeNQvgK/pnGehMCm62jYah6W1UNew11e/WfZvrEQa8BWTJfnC9uOCr7fbqjDoJwhmdDvEUqE/kdXXRwWTAUlYFnRQ1kFkWAQr5BvbbYguZJPVfFo+PNrLc62OWF7dW/pqVzbpDibSDMvUgzYOcOxc367IbCoR7VCPURtqk9o5N3jrBpl4KXfvDjH/0Y1p8PJ9AYniiIvkOh6eRehEw1sPbl7oWHT5wJ3oQpMtoIifwCMqMr8l9+bvMCrXr+H8GswVBVED+raubAP/sUHCjwrjwgoEHev+V/CPAXH9MLC87N/duvqRSyfevKUBTFyzuQXStBIACXoSWzrKYDR5tq/ybsIiKkmm2wf1CBKuZShoKEB4euKujxU6iHOTfySgQJpqunZhKBTjNEGU1Tay5Qzvci+WJm0Cnyds6oh4W61WRi0gaySMz6Ovo0jzlZmudkwaDofXJghJwKiW4CE5kCY8MT4yEexl4dxKf5l+ybaBAQJ+gWbH9TB+5+xpTMxYcaRfCMV5fjE0QP4DnB0Umh6mzysQR/gRJFgvMxhBVTSKnESziXu+HizGJZ1WB53mAXT+NPj4/8wUmtoUXwJm7bW8z2P8/7/hKhD/uF6/9bALdqTm80s4eIGnaHdqSljgwwe3pRBtC9lN8n+aweZe5M38kEtbYD9Tj6JkxwbQZmC5jLFxBh6U54GiXchHzlSzlD5ZnsIaFQ7vSOGpjgkKFyoFvPrZnXMuNuRC57L1D6w2tg+TW+e+/36O4jgOKhQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(4326008)(6666004)(38350700002)(38100700002)(54906003)(83380400001)(508600001)(6486002)(966005)(110136005)(36756003)(5660300002)(52116002)(6512007)(7416002)(6506007)(8936002)(44832011)(316002)(2906002)(2616005)(1076003)(26005)(186003)(86362001)(66946007)(8676002)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vfvh0dNcFHepmtJ+FXKZZ272TCryfRJoM3kaFNVNhtn2wxG8JdESFhjN89xA?=
 =?us-ascii?Q?gMqMcD6Uk+p3NjeH9TNCZnVXYzV1CVbhvMYBvMS+rDsjpZbeSpYKmE5fOZUw?=
 =?us-ascii?Q?LvNNz1pJYWXQs3cBQRfXiR0nFMHTdpYrqrU+msPdb0dsROQDczRY9I5nT2Lk?=
 =?us-ascii?Q?Lg1K5O/LVdnRimPPGJ1VSj4/pN2F8BHFAgBnzSSMeHE//RfDbiMlkKLubrus?=
 =?us-ascii?Q?Uwvh6sFEgoJCWZ4a/EOhIiiX1wqfUW/ds0ydtwOnwsQGvJxPdBvRxiiy10ac?=
 =?us-ascii?Q?iUF/bkFevELQZgZMpmGaeLzOzggO5fvkM390PcSZn3SEGpPE/IMlf/54uUF/?=
 =?us-ascii?Q?leZgofrGLjpyt+PhIfs5hnnZT6jQkB6QyJl5RmymX17jKqfVrpgZ1soGtsYN?=
 =?us-ascii?Q?U/U2KjnlCsdBjc69V4R+gTY1HkyN1qpvuUUleTYdPozOhDOtkD/a9/KDsxcV?=
 =?us-ascii?Q?SWJIwkKc533MA+7pUTIlIBEfDiuqf3GtWABmRahn62Wpqn9Z4OjcAoq8bJIi?=
 =?us-ascii?Q?spxi30HNuugn0vku3Z1Ex4QY+qlEwuhtIJeA91lOgBRsBzpIcAGnILq+niuK?=
 =?us-ascii?Q?ZBMhoC1Gzi0/d1ol6K7gGODY25pw5TGQsH3guC8bmHBXDyB2iiRkmpQhB5Kw?=
 =?us-ascii?Q?EouUS6JM82gbqQwqXU8b3MN7DpbYfBPO4MoGpskUrprmD3pZjHihFOSpjNJX?=
 =?us-ascii?Q?4vfMoaKtCY+LPEOm/lFfPTHvVobWkwA2xuEQsNmxzI+mpevpuZir0QnCskL6?=
 =?us-ascii?Q?d97+dCcD5eOVX1kZFdciBlzWyS8Colr0Sab335XARbPKFzgC9Ojg4FQgE9Vj?=
 =?us-ascii?Q?TpmF0lRcWiKumZzVnW2xK/fGzaRR9KDxUMREoROUa3CTugzs45R0ZM1wBooD?=
 =?us-ascii?Q?mCyx4DIqZICfYZlvp01A9p4ikN9VcQ3+dG06G+XYmGLGFrtar60lB+McDqx7?=
 =?us-ascii?Q?W6ZP7igjGR4EkSkyoDeyTY39Exp0tuotOiSXVCADXc4kDu5cRMsO6CAzs6mz?=
 =?us-ascii?Q?Htm5Zf/FO38PQe6SGstuXZsh9xv+qA9Grh8gpUdD0S8LD08w2wYMkmOSg083?=
 =?us-ascii?Q?AAcGHaiMXp5lsUilUu/+AOFVesqIvw8GZNNSqhDO3HSg/JBJCLuwOWN8tirE?=
 =?us-ascii?Q?n5AAaJrYSbkOiQE5pZVJibSW3fjyipzj4+RvzGzAKLFCw2ODcDbYwaY9N1f3?=
 =?us-ascii?Q?XYF5Vtaeuxz3XitubXqC9fg8Ty+QT+E/W5VS4BUEtK26MGcQFQkVoqkJAPQA?=
 =?us-ascii?Q?lOL9yoccUF5DRcNixDuVbFmJ87B3Nr02fYHkJ98pxIOBwcNILkxXtn1NvVM3?=
 =?us-ascii?Q?jtuxQXciMNtzau4Sa5BDntvGpHKEAav1dj6LyxZdZfNA4sLzOXQK5RBj2N44?=
 =?us-ascii?Q?cq9nPy07P+cgEWvZ9cUArSGIS1NuYSE5dlE5JV9PR2+cwdp3nJAFXhXcJKTG?=
 =?us-ascii?Q?Tg6bGdoE3WJeh4DnxIS6jg45ceLVey5WnaXFhfG2uxvD3baKd41TPa5iS5w/?=
 =?us-ascii?Q?X3BslL/LfBlX2QL6mDYOeaG5rus8Nl7rjWNmvGOOWH9142H4F+c6mvZItCiG?=
 =?us-ascii?Q?tntJjN9dh8xDyguRk+uAR9eg0HDxl0YKPRjsq4i9Azfmq1PEkciVroJQqd1j?=
 =?us-ascii?Q?4bptb6749s1UIQwrlakWF+g=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce5bc9e1-ec5a-49a3-f064-08d9f8406afe
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2022 09:23:00.8979
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lXuMM54NrFLinRU0QRb7kQ7Q9iqIFwUpzSzBaHUDqm6sAG8QHjSH4nDOi8f7FvmC2S7wfGt5Xjhti1B/lUb6MA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5008
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are use cases which need FDB isolation between standalone ports
and bridged ports, as well as isolation between ports of different
bridges. Most of these use cases are a result of the fact that packets
can now be partially forwarded by the software bridge, so one port might
need to send a packet to the CPU but its FDB lookup will see that it can
forward it directly to a bridge port where that packet was autonomously
learned. So the source port will attempt to shortcircuit the CPU and
forward autonomously, which it can't due to the forwarding isolation we
have in place. So we will have packet drops instead of proper operation.

Additionally, before DSA can implement IFF_UNICAST_FLT for standalone
ports, we must have control over which database we install FDB entries
corresponding to port MAC addresses in. We don't want to hinder the
operation of the bridging layer.

DSA does not have a driver API that encourages FDB isolation, so this
needs to be created. The basis for this is a new struct dsa_db which
annotates each FDB and MDB entry with the database it belongs to.

The sja1105 and felix drivers are modified to observe the dsa_db
argument, and therefore, enforce the FDB isolation.

Compared to the previous RFC patch series from August:
https://patchwork.kernel.org/project/netdevbpf/cover/20210818120150.892647-1-vladimir.oltean@nxp.com/

what is different is that I stopped trying to make SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE
blocking, instead I'm making use of the fact that DSA waits for switchdev FDB work
items to finish before a port leaves the bridge. This is possible since:
https://patchwork.kernel.org/project/netdevbpf/patch/20211024171757.3753288-7-vladimir.oltean@nxp.com/

Additionally, v2 is also rebased over the DSA LAG FDB work.

Vladimir Oltean (10):
  net: dsa: tag_8021q: replace the SVL bridging with VLAN-unaware IVL
    bridging
  net: dsa: tag_8021q: add support for imprecise RX based on the VBID
  docs: net: dsa: sja1105: document limitations of tc-flower rule VLAN
    awareness
  net: dsa: felix: delete workarounds present due to SVL tag_8021q
    bridging
  net: dsa: tag_8021q: merge RX and TX VLANs
  net: dsa: tag_8021q: rename dsa_8021q_bridge_tx_fwd_offload_vid
  net: dsa: request drivers to perform FDB isolation
  net: dsa: pass extack to .port_bridge_join driver methods
  net: dsa: sja1105: enforce FDB isolation
  net: mscc: ocelot: enforce FDB isolation when VLAN-unaware

 Documentation/networking/dsa/sja1105.rst |  27 ++
 drivers/net/dsa/b53/b53_common.c         |  14 +-
 drivers/net/dsa/b53/b53_priv.h           |  14 +-
 drivers/net/dsa/dsa_loop.c               |   3 +-
 drivers/net/dsa/hirschmann/hellcreek.c   |   9 +-
 drivers/net/dsa/lan9303-core.c           |  16 +-
 drivers/net/dsa/lantiq_gswip.c           |   9 +-
 drivers/net/dsa/microchip/ksz9477.c      |  12 +-
 drivers/net/dsa/microchip/ksz_common.c   |   9 +-
 drivers/net/dsa/microchip/ksz_common.h   |   9 +-
 drivers/net/dsa/mt7530.c                 |  15 +-
 drivers/net/dsa/mv88e6xxx/chip.c         |  18 +-
 drivers/net/dsa/ocelot/felix.c           | 221 +++++++++-------
 drivers/net/dsa/qca8k.c                  |  15 +-
 drivers/net/dsa/realtek/rtl8366rb.c      |   3 +-
 drivers/net/dsa/sja1105/sja1105_main.c   |  94 ++++---
 drivers/net/dsa/sja1105/sja1105_vl.c     |  16 +-
 drivers/net/dsa/xrs700x/xrs700x.c        |   3 +-
 drivers/net/ethernet/mscc/ocelot.c       | 200 ++++++++++++--
 drivers/net/ethernet/mscc/ocelot.h       |   5 +-
 drivers/net/ethernet/mscc/ocelot_mrp.c   |   8 +-
 drivers/net/ethernet/mscc/ocelot_net.c   |  66 ++++-
 include/linux/dsa/8021q.h                |  26 +-
 include/net/dsa.h                        |  48 +++-
 include/soc/mscc/ocelot.h                |  31 ++-
 net/dsa/dsa_priv.h                       |   8 +-
 net/dsa/port.c                           |  76 +++++-
 net/dsa/switch.c                         | 109 +++++---
 net/dsa/tag_8021q.c                      | 319 +++++++++--------------
 net/dsa/tag_ocelot_8021q.c               |   4 +-
 net/dsa/tag_sja1105.c                    |  28 +-
 31 files changed, 925 insertions(+), 510 deletions(-)

-- 
2.25.1

