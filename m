Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1CFC437CB5
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 20:44:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231997AbhJVSqm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 14:46:42 -0400
Received: from mail-vi1eur05on2043.outbound.protection.outlook.com ([40.107.21.43]:44121
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231511AbhJVSqk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 14:46:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hqWF0fX2oWy8DMsdlmJUxSOAEfn+F7ab6GvM3gmLxe2G/231vxSZiw4GrpBJ7GMLYkf66ESdsIOxhnxfWVLIRYHRb2kj6VcDeY6tHP4QOhT8EGHFF1/3uBAih4zRyMNiGqLQRM6/WlzuTbFX4/0mteiE4OMEq7GDvqW7EQ4NegBidRk8Vn7CvQCoESndwGq1dw24jPDjdYflLd3xh21SXpQg/k9hUzEbqv9KJe2yCaVaZHutDEizZhMji+L+2hSck1wBP9aDI2hCooJMiFvaVueSQnM+Q+9qcKPmgHXDc/ScZ5OYN5zyiFaSqbkbSkr2d45ZA2qvE28PMckO4YjN+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PhCHvJlCYsVl5bczf9ib8G5ayfW026TbDngvBFgLJ/U=;
 b=gx9PQDKRJku1cpw0GymkzaEnWXX/TE217OkSO1F2eB7nujO0qcZwBF4VzBnFbRQ4h+5Qe3Eg3HXmbCZi3XLCqZrnROGu34ycynXEqWp5YLMmnT555thN3MKCbcHEiwmP6UDBx73yqchfsTAI2KTFEF5I0s7TkIJqBr3V9VpcMUcDpLIKgrl8g4NfJk75He3sW4WcFuMJQprG00zLOyvo95qfc4sDxwTmUcKN/ZwX8P4M5WFURj8JbR/G2x3PLwX3s3Bl1FAKMJKEp99qZmvgUPXIEfbRDaKbU1+HPCo8yIUoFTcrP43MkfN5U4/aOZj8r5PfA2uwXiwMn0Qnrm+T4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PhCHvJlCYsVl5bczf9ib8G5ayfW026TbDngvBFgLJ/U=;
 b=Ii/KBms72bei4QoDP9lyOfw+9r/wBLHVm6gJm81ziCsSmEeF0AgwOcN7fbwq+73F3vRJ9QqY8JF9IErqRfHe7DJEt0vmSd6xJySQB3zw0vcqfy71SmSM1/OtnqQpnLRf2rPw813NatYnz5MQJZ5o6RfHgGRMEo06O/tBze+gCnQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB2862.eurprd04.prod.outlook.com (2603:10a6:800:b6::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Fri, 22 Oct
 2021 18:44:20 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4608.018; Fri, 22 Oct 2021
 18:44:20 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
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
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: [PATCH v4 net-next 0/9] Drop rtnl_lock from DSA .port_fdb_{add,del}
Date:   Fri, 22 Oct 2021 21:43:03 +0300
Message-Id: <20211022184312.2454746-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR01CA0103.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::44) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.174.251) by AM0PR01CA0103.eurprd01.prod.exchangelabs.com (2603:10a6:208:10e::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18 via Frontend Transport; Fri, 22 Oct 2021 18:44:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cc62fd5d-9dfe-44e5-b297-08d9958bf561
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2862:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB2862D45DE26009729A1EBDECE0809@VI1PR0402MB2862.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /Clzn9uJ2ySti/gk/hSU4wpGRG24iqTo6JJf2RVX3iiyaOA8nYNiXdy+ud8eOJtTx4hWkQrb/G9bFwkQxSWH7eW3ZVGoYSWY4ceRr4X/EN9Mb3pYN9mFwXFYtZEAz/+a8usAXS/3ExKiDIRyqswVPyom93IVLPOd9EkGUczKm75iwmy55/oz5j0nqojQnm77GM9rzCHUpJ6WRlkrAEiHn8J3jLSfTUyspM0nVRMoqZncYIDAxzwWAFEbvqUBStftR4uF9IMmF0UCnr5H2DYT1gMaHEzzv/cHFCzeKhnmMNpBP2dr5LxHcBE1P1/5FuA9hVJqipmyYK3kfN3YI6dl8BqqLc+AMLfV4DMSeHjh7Ii1SQ31Gfy7hiMqH+FqvZsUfF0+gOfs54izhYP8xC0Nu7xc+3seREsLcROPQ9tnR1iVI3f3+m81lgv4yURmcN6079uty8fGtvrynLamRWks1o0BdPMIRe8FFvd5WB35oFHopE7kE3lsKv8s5Dh/G6gfanQwG2eIuGcffQQMOg9CvInNg++g2fcmd8xck8n5uCzb9Rnvg3wuLcNBFxyo+8QpxoNKpW0iqlHKPaIgjDZ6UxZvPkuj/xx5AeJ++VITj56pTWlT8A+SO/2HHHsjMEQ5vSSnZJxErwtSi1vhHbmdSbm1m6/7USec5LslDXZSJ0vOPH6Uh8uKHy8DlsDOtJYnBjd9ze0fjDvi1u9v3adxwVIFJj7DHBf2Mic/f1ArFk9nAChshQ2r8lD/GM/whsnoqbEALJD9+b6/UjOZuF2L2UJswk1/+/C4YeDA9UYTs0Gtt70LD4V5BQf9bCJxnT3l
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38350700002)(2906002)(38100700002)(83380400001)(52116002)(508600001)(1076003)(36756003)(6512007)(6666004)(54906003)(6916009)(86362001)(6486002)(966005)(316002)(956004)(66946007)(2616005)(44832011)(4326008)(186003)(7416002)(6506007)(8676002)(8936002)(26005)(5660300002)(66556008)(66476007)(142923001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?E5c5Dlxf9fa0DJvlWRzUmOAgkeGTBWCLU9Efnu4LC360+9Kw6909/lMGulcQ?=
 =?us-ascii?Q?f8fvlEYrXg9cgYBQXuhx277P/omyotoRfsyA3P1SS1OePc4RbOal5mtCLoeU?=
 =?us-ascii?Q?aCXFG9K0icPvyTHcR/+TEttYueCy4psWSZQUCFT66h5gGBg3eQsXoiq6zNc2?=
 =?us-ascii?Q?0nMV5QzX4pbQbRD/PDka+/U4JuIN5/zQcwPLujcO+KRS1sTbAjPFXEj2Ip8O?=
 =?us-ascii?Q?zN4POGKJ5xFxv3Tpsxx2gR62K5Ml1c4xCZjF+OMtEszGP9uH23BuVxhGX/dw?=
 =?us-ascii?Q?VmRjiVMaSCg3tzzwz/uCPbUMlHJR1gBBtOcVhIZNE1NbEYpYLuLzflM619bO?=
 =?us-ascii?Q?V6e4NxWG2Nfyiquxc71huH7pcNsO35szRse14QXNXQ/ZROETOd3CiCD7zw5b?=
 =?us-ascii?Q?uL85ZCJ52lehlXd29vxgjqD/2SEKaMVmLsKi4U7yFjE93V1qrktPS0llfEx3?=
 =?us-ascii?Q?RFIsimgYx5a5P5klxIiekJ0EEYV8J1VGtEW102wlC9pc06/TBhauzij51W8P?=
 =?us-ascii?Q?vSwOcs4oDNSB7zQ55l6ckOSb0yF1KMaII5s7F9F0FPaF30Tw1znpYGwk3zf+?=
 =?us-ascii?Q?1N7SVm9oVHPqUMNvD13XoP/eQieGBu7/HWF+cpDzDlGX6iJU8m9yIjjLf/tw?=
 =?us-ascii?Q?+XqfJjCUenqNZG4B/YXN3acdRDrveLdiehIvlhorPDRVT5K0yoTRPIOb0aUC?=
 =?us-ascii?Q?0LSa7OYYmTOTfQxKkLU5LEdEY7VV1/5A2iwmfQwsha3pJNzNbJZvX2jd5vAa?=
 =?us-ascii?Q?dOlDsOGzL10Khj1VhihDFucF3qBtMCCdNcp5l/Peu0PCBNmam4R/Ib3AzHj1?=
 =?us-ascii?Q?FK58Ho4xQQUBbx3YfmE9M4lN1FQEfU6UVM4R9Q9G8lu7u/ArUxiPRP8rHA0e?=
 =?us-ascii?Q?Sugl55N941jXcLvwR3+6/WtUvfistUNJc0glAU/6skFJBGiwwqckY8BA5vX/?=
 =?us-ascii?Q?73P/uvKp9H18TwuYwCWBbmB9mCsTMEbZqFO1j+1fvAR94jUcr0zlAqB3zl0R?=
 =?us-ascii?Q?YIONoSbj7C5xt60f6hpbEYUCKkLziVwjm5HOYvF3ayn4iux6A2ERDR/TlVSC?=
 =?us-ascii?Q?uRCGdDr2iPBC8IF9qAR6Q+UCO0h6yFCqSGqXlQitfgrFJGwMd9mRTm5Un8KT?=
 =?us-ascii?Q?TVT1Y+nHeiULZG1WalS3jL9/TDhpCQMJLSJqHAdBD/YmOaUSQD9/jnajdKgu?=
 =?us-ascii?Q?8DQwgrEgWBQdx45KnxG5OY55HASd0WVCvSknDiMqrK5qMORAM6/mpunvZGUL?=
 =?us-ascii?Q?cvUdOIZ5PIvDeL2ql4eY1PVSJud9Mzd4EGPUdHeIZb7tMisF2Wg6Vqkkaawh?=
 =?us-ascii?Q?dsL04New7pY7YXgbFYHTbHfJkGKUDxExFxW3CMM2EjXwmlKC/3auXyhfz7v7?=
 =?us-ascii?Q?YRuK+XoyV1Ei47uGIbJ5qGXlf0O4Ia4D42Pckh9/rzAhx6LywBA4MwGCaZp4?=
 =?us-ascii?Q?4Dyq/jiTrNkSM85gx/qgwqE13Ys1tLMk?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc62fd5d-9dfe-44e5-b297-08d9958bf561
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2021 18:44:20.1887
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vladimir.oltean@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2862
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

Changes in v4:
- Use __must_hold in ocelot and b53
- Add missing mutex_init in lantiq_gswip
- Clean up the selftest a bit.

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
 drivers/net/dsa/b53/b53_common.c              | 40 ++++++--
 drivers/net/dsa/b53/b53_priv.h                |  1 +
 drivers/net/dsa/lantiq_gswip.c                | 28 +++++-
 drivers/net/dsa/sja1105/sja1105.h             |  2 +
 .../net/dsa/sja1105/sja1105_dynamic_config.c  | 91 ++++++++++++++-----
 drivers/net/dsa/sja1105/sja1105_main.c        |  1 +
 drivers/net/ethernet/mscc/ocelot.c            | 53 ++++++++---
 include/net/dsa.h                             |  1 +
 include/soc/mscc/ocelot.h                     |  3 +
 net/dsa/dsa2.c                                |  1 +
 net/dsa/slave.c                               |  2 -
 net/dsa/switch.c                              | 76 +++++++++++-----
 .../drivers/net/dsa/test_bridge_fdb_stress.sh | 47 ++++++++++
 tools/testing/selftests/net/forwarding/lib.sh | 10 +-
 15 files changed, 283 insertions(+), 74 deletions(-)
 create mode 100755 tools/testing/selftests/drivers/net/dsa/test_bridge_fdb_stress.sh

-- 
2.25.1

