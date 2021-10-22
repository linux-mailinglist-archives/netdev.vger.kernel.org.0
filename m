Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0D23437BE5
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 19:30:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233685AbhJVRc1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 13:32:27 -0400
Received: from mail-eopbgr150072.outbound.protection.outlook.com ([40.107.15.72]:27678
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233582AbhJVRc1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 13:32:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MC8IQxr9JQ6kjUtv9ySPT6WUELGrmbWHFZHTG20B5f87Bz5gldApskHL8o0G+TfO2n3OuVGwdIUsnEhb1qlv9d1525ImFR4LGcntpSjlLTJ4p0jWthxmWxJGgYLvNjxuklnhcn6zCpP3x623pdbTOuklJvlGArSlDHc50gREsPg3bsHt9MS2wfhuy8dI5TLft/+gzMM9nM1oDS07aC0nSqXMM4mrlmz7waAJqaOp7wj7oQ9y11DweCSsALCAob3ECT+KSLnTWevqPuVJB8ZKzhHbXTLleSSTH3bwFg8BpiZZ951PEbg7WOmyh22UorUXmb6NoVVDG16aYcs7j1NQyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WKuVglgaytX2vimvD0GA3kJZ9N7UwVkNTv/Ch7JyVrY=;
 b=PTcrhg36jeK5dCuQ4PjyylKiUcO7mhqoncUrqOyjhH8UTfM9tScCNoQn8RAuTCBwWjugqkOB/RsKVQx8CN++2+nQyGtWMu+/gFYM/S1l9cz6L8wf+NJz824fJ2Uqyegf55ylox95n4wrN3QPGuvQwD8/7kwodlmQpimvIv2Nspm12kPXX40A6x51EreVRE4umE0ie0qETtUSud93yncDujJ2JfR44LuESmwIuhfkQ9Y5BUb2fLAJe/UqXb9IEtn/+HvwDZdIkXvPF0bX6+R3reDEHr8JzEEQcaE8229oq9N9mYS/1joXv1RUw6s2ljdtrndpzCIOy+9IaMiQoVRUAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WKuVglgaytX2vimvD0GA3kJZ9N7UwVkNTv/Ch7JyVrY=;
 b=QuFi59LxeBiVUQTJJFAWdWnekCbrHmK0eFvo+MvGtOrGbOfx80xgaR4P1EdkYQWDezeT6b5jdm/GVQK9C3lpPX7adImYbvPJsrhR/5hy/QXV/yjQNlj0rv/OvH/Ul/JMD/RLwtW4VlN4QxgY0oCyyw9m6Jl4GzVlfmiEa1gz9hE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5504.eurprd04.prod.outlook.com (2603:10a6:803:d8::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Fri, 22 Oct
 2021 17:30:06 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4608.018; Fri, 22 Oct 2021
 17:30:06 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        UNGLinuxDriver@microchip.com, DENG Qingfang <dqfext@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>,
        John Crispin <john@phrozen.org>,
        Aleksander Jan Bajkowski <olek2@wp.pl>,
        Egil Hjelmeland <privat@egil-hjelmeland.no>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Prasanna Vengateshan <prasanna.vengateshan@microchip.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>
Subject: [PATCH v3 net-next 0/9] Drop rtnl_lock from DSA .port_fdb_{add,del}
Date:   Fri, 22 Oct 2021 20:27:19 +0300
Message-Id: <20211022172728.2379321-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR08CA0003.eurprd08.prod.outlook.com
 (2603:10a6:208:d2::16) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.174.251) by AM0PR08CA0003.eurprd08.prod.outlook.com (2603:10a6:208:d2::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18 via Frontend Transport; Fri, 22 Oct 2021 17:30:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 938daa69-528d-4a0f-b2e7-08d9958196e7
X-MS-TrafficTypeDiagnostic: VI1PR04MB5504:
X-Microsoft-Antispam-PRVS: <VI1PR04MB550401707D0C5EF6860CFFC7E0809@VI1PR04MB5504.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2657;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MOwVt85wLx0V6zOsVzR7tq77Voqs5kgUQOmLT7LGpCP1NbaNvGTRa/utRxbO5BOcPAzGhHiyngndB/q/u9hICcRb1v4KRe8G4NquZQR7Io/281qYcsMjkGXmEG7MeFZhab79QvFp3Bre8/DqihMFDb1PHkFCS7U1FaLMXWMgYwfbviYoq3XuR3nsHKBAQ8OgfQFjYRoqxI28Y4cBsiJoqQdx5EEvIhOo+QWVhTEcb542RIloFsSoD/SIpNeOPk8rtscvmUVEVzOKS1j3fM/JP5gCefkvAVlquaXSqUpiyKASqY5Sidetdgc6knR91CyGiOrSx5uyWJmqhIoJY2kU9y+apb0v/UACKVfpVyyGC7Sm/dreiHpu6qrgUR6YMGzHhfRFDuyY3FZ+L0DAIURYNj5BD1fQ6OgVlORJ64wcDYj9TCPOF0txHxD7O75RBjPONIdV4xno0wk7K5i0uYlYOOTx26q3n6rgS0id/9C8bWh1z0/EnZCGzfdnWbRCWRvGxYHbZiJMNFMFjrcahSiSEVAV3TNZg+r+5Y5FKvU8jgeNZraJ9jkVavHAXHgLK7Amx3z3uvOFfHgOX8ve/1xENlc6xpYJSjdiAIiBjDZdxKw+nT7Fhjsc81Z9mi7nfBfCcWvb6f4uF3AB1r1sE3yAOH1F3KBTDC1sYV6vPl3jUW6zq/RB8i/8r5eFV9LCOBbVuET8doVvTnAexuuMnqUMVpQ4R2ye7ReXimQPmxFtH1UlHW1dr7u96WTdsIBIUVP4feMD2O3RK6WcHwLfR+LeVJQnAWk5UDJ7yjwuUd5RNCc2FjV6x27l5UIpzZQ3sEw0w18vzut/SLXthqxYNgVDPOlCSbsH2CZgNWoD/huIcVc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6666004)(6506007)(83380400001)(4326008)(966005)(6916009)(52116002)(66556008)(38350700002)(38100700002)(66946007)(44832011)(6486002)(956004)(8676002)(2616005)(86362001)(36756003)(8936002)(6512007)(26005)(2906002)(66476007)(5660300002)(186003)(7416002)(316002)(54906003)(508600001)(1076003)(142923001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1iJXbo+SllfzPenfY++hn/ALTmdFQXhxYYF5eqCPStrysEGhjmtD/BBrjc3/?=
 =?us-ascii?Q?7oofwXJWJI9PmsmXB53G00b6xj619CLNcNlnKV/RBWOKTeG329qwi53DlwTf?=
 =?us-ascii?Q?3waTwV9TUgEWGGur4dJAFmHh6ZHBzm5/9Y9940/aFOJZJxOMY01l4v0Tmo+d?=
 =?us-ascii?Q?WhZePrxRwKZ3o2HCaraHJw3Fbgl0a3F/ryyn8GauPsV50JTnOeSGH9LJP/+M?=
 =?us-ascii?Q?e4w0xqBkd5U3eR9wI3CCOvbCLboclfZB9PAzTWWfBg2ARYbWKWniqB4THJV/?=
 =?us-ascii?Q?VwwE5jxp0bU6rQSNWoxYOu/rqtOGRsqu4PZTf3M47TjwN3GgYjPXCmG1PvcE?=
 =?us-ascii?Q?Fy7AAvWjRWsl4re3Dd8/zdDkaV40Vq3HhVE3poODutROwb5sfsDXqrdh9NqH?=
 =?us-ascii?Q?H/6B9sOU1lVkIH70Cs7XkWdGfA1SG9kwenU34MSU55uVqyhkQ5lH8ZVwgKli?=
 =?us-ascii?Q?36/U1xQlWGsI+CRjWMEp8uLabfE9SvvL7AwHebJDJSOIFn/9bFRR4LNgNmdw?=
 =?us-ascii?Q?mvN4nCdmbxRHA6tV4loHNUv6Y2pExoGK/NFxE6/GkHmRFLhNf4LjcRS514bi?=
 =?us-ascii?Q?LehSRVxy60NzsjZ/yxI3Ymlt1vWx368tp7s4072KgyZWUAAatFCPr5ob2ctP?=
 =?us-ascii?Q?9LiyEt38cFJmoJ4iuTJqTrwxLLrkw8j/v/sfWSQBhSLYcZu8TimwQq8DFroo?=
 =?us-ascii?Q?2+i0FZ5HaZF1EVfCtCDhEld36A0pUhfENio98YP9I9dLI7xvp9GdpRpvpA4X?=
 =?us-ascii?Q?1ipCNidKh+8vRPmPK6zUMPNvo8ife3nrX4xRYjgv3CsT4rOK0xr6jTyR2myO?=
 =?us-ascii?Q?oII4V/3CM/OM4C961aqWGWi5iRKLZrH9/QuKOCcLCcoNLqnLcXnWL7+sCasv?=
 =?us-ascii?Q?cZItBn09hdXK410hKzfwuQxX8dMN3l5hNP9QU3z/jsdGRB8OBqefnl3wcwzS?=
 =?us-ascii?Q?WKT9XAXG5HN2qZb4O2TzG+JhFJXR8EwfspMTAbWLdwjUYxFq0WwlqCxEnUav?=
 =?us-ascii?Q?5rdhNH5yikhJd3EAmCzLfU1x1+RPIlieWi3tHsd/5x+Xxk0YlxCOtV/gzhx/?=
 =?us-ascii?Q?eGq9IoyhriditSvFzWI5rzvBv7+4tzDrSDF30c2in7o+skH6JPj64G2HBaDY?=
 =?us-ascii?Q?gJ+SMTbimI9FL8wAeVTdLmxAeIe65pik9PzMOFnQKUlTuiMsHv3eU8THA3bD?=
 =?us-ascii?Q?gGWXoG4m1zS/3bDwTxvhT6675SNfTv6kB2pPd9wVlzUZnakfbsGfH2ay2W7B?=
 =?us-ascii?Q?Fe+qB9Fwy37XH6OeN7HtFVHAVkRAqU3k5/b5B/HvFdp/42gjv3XX7r/XBj+e?=
 =?us-ascii?Q?VPl9RYj9bM8rH/2vrwSgJvwZVWu+iZ+r6pDNM/1C4/6ESmFTuqmuxbdns7Ib?=
 =?us-ascii?Q?8FrNp7NtrgsGQoCOuLyaFiBcHESg4wCn0e5F9DcFpcT01Z2234XRk/17OD5E?=
 =?us-ascii?Q?MHJ1oL43riaptMfPw3wCD+oJZyGEn5tw?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 938daa69-528d-4a0f-b2e7-08d9958196e7
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2021 17:30:06.6961
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vladimir.oltean@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5504
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As mentioned in the RFC posted 2 months ago:
https://patchwork.kernel.org/project/netdevbpf/cover/20210824114049.3814660-1-vladimir.oltean@nxp.com/

DSA is transitioning to a driver API where the rtnl_lock is not held
when calling ds->ops->port_fdb_add() and ds->ops->port_fdb_del().
Drivers cannot take that lock privately from those callbacks either.

This change is required so that DSA can wait for switchdev FDB work
items to finish before leaving the bridge. That change will be made in a
future patch series.

A small selftest is provided with the patch set in the hope that
concurrency issues uncovered by this series, but not spotted by me by
code inspection, will be caught.

A status of the existing drivers:

- mv88e6xxx_port_fdb_add() and mv88e6xxx_port_fdb_del() take
  mv88e6xxx_reg_lock() so they should be safe.

- qca8k_fdb_add() and qca8k_fdb_del() take mutex_lock(&priv->reg_mutex)
  so they should be safe.

- hellcreek_fdb_add() and hellcreek_fdb_add() take mutex_lock(&hellcreek->reg_lock)
  so they should be safe.

- ksz9477_port_fdb_add() and ksz9477_port_fdb_del() take mutex_lock(&dev->alu_mutex)
  so they should be safe.

- b53_fdb_add() and b53_fdb_del() did not have locking, so I've added a
  scheme based on my own judgement there (not tested).

- felix_fdb_add() and felix_fdb_del() did not have locking, I've added
  and tested a locking scheme there.

- mt7530_port_fdb_add() and mt7530_port_fdb_del() take
  mutex_lock(&priv->reg_mutex), so they should be safe.

- gswip_port_fdb() did not have locking, so I've added a non-expert
  locking scheme based on my own judgement (not tested).

- lan9303_alr_add_port() and lan9303_alr_del_port() take
  mutex_lock(&chip->alr_mutex) so they should be safe.

- sja1105_fdb_add() and sja1105_fdb_del() did not have locking, I've
  added and tested a locking scheme.

Changes in v3:
Unlock arl_mutex only once in b53_fdb_dump().
Reposting mainly because v2 got mlxbombed by a net -> net-next merge
conflict that got fixed in the meantime by commit 016c89460d34 ("mlx5:
fix build after merge").
https://patchwork.kernel.org/project/netdevbpf/list/?series=568621&state=*

Vladimir Oltean (9):
  net: dsa: sja1105: wait for dynamic config command completion on
    writes too
  net: dsa: sja1105: serialize access to the dynamic config interface
  net: mscc: ocelot: serialize access to the MAC table
  net: dsa: b53: serialize access to the ARL table
  net: dsa: lantiq_gswip: serialize access to the PCE table
  net: dsa: introduce locking for the address lists on CPU and DSA ports
  net: dsa: drop rtnl_lock from dsa_slave_switchdev_event_work
  selftests: lib: forwarding: allow tests to not require mz and jq
  selftests: net: dsa: add a stress test for unlocked FDB operations

 MAINTAINERS                                   |  1 +
 drivers/net/dsa/b53/b53_common.c              | 37 ++++++--
 drivers/net/dsa/b53/b53_priv.h                |  1 +
 drivers/net/dsa/lantiq_gswip.c                | 27 +++++-
 drivers/net/dsa/sja1105/sja1105.h             |  2 +
 .../net/dsa/sja1105/sja1105_dynamic_config.c  | 91 ++++++++++++++-----
 drivers/net/dsa/sja1105/sja1105_main.c        |  1 +
 drivers/net/ethernet/mscc/ocelot.c            | 53 ++++++++---
 include/net/dsa.h                             |  1 +
 include/soc/mscc/ocelot.h                     |  3 +
 net/dsa/dsa2.c                                |  1 +
 net/dsa/slave.c                               |  2 -
 net/dsa/switch.c                              | 76 +++++++++++-----
 .../drivers/net/dsa/test_bridge_fdb_stress.sh | 48 ++++++++++
 tools/testing/selftests/net/forwarding/lib.sh | 10 +-
 15 files changed, 279 insertions(+), 75 deletions(-)
 create mode 100755 tools/testing/selftests/drivers/net/dsa/test_bridge_fdb_stress.sh

-- 
2.25.1

