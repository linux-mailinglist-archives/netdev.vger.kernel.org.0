Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5CA53D97E2
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 23:55:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232116AbhG1Vy6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 17:54:58 -0400
Received: from mail-eopbgr80074.outbound.protection.outlook.com ([40.107.8.74]:44933
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232059AbhG1Vy5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Jul 2021 17:54:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iuRMYnpF1ZVBePIVTzRaCctZAkW0a/Hcq0j7chB7rKwR70iNcIWMvzSPcIMynJidWajUIVXr4mHB2Ltxof5Iu7gBuJ9C8p4hDZj4zLoNyoeSUBAdSzxGk+zqeIemLrC1BHoVTMUVhmk2OpCbc7/0Ysjh8myYTkiMv9GAsvqHCs2CjFpKzeyrZ/a1XrVnlAmvJ0/Jx9gLsjT4j3FoXHyjt8WoiKS+DNBNkDwIdjmbS0rLWreXgHlTLrMC7NS7zC6X6hUSbMAH8AT96satemUWiUN+vltBgYGo3QtFo8v/v3mRfYA9e2HKTC/nS4YZD8kHHEL0iSsTJUnw2RZw0rP3iA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tFLbwWEAH2uDz9gcDFmHLwbqU0MEgdaafwpJtqRKDB0=;
 b=jFvJmXp1p4HSj8fwdtBQ/I7QT9mJovE61uHQDxTfkhHzjOl6iSCys4eU6uWPXQofcCgRyF3XFKDl34Q7U8QEiIumrKJzNdlRger6ZaIP2EkPJ4zgbTFMGKxiteMQ5XwaRupqlExdnBJtvgZN4YwnqTdWckTBizDqQ4P31GTXz55QMb0zl+G/cNHz0pvPWa4hz+vD2kp0HwRdBtGjHi4DaeKz7GMjCoP5xaaioApRUg5PkesNU0fe3x/cY29SDDei+qK8sbgT93Lxyer2TvrTO00W2ibH5WLjtlv8Pvhn3m2FY7zgJQq8EI/zXGOyolRGVck7l7eN3+yzTP6hmJv69w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tFLbwWEAH2uDz9gcDFmHLwbqU0MEgdaafwpJtqRKDB0=;
 b=AVQKeAzhX/reuMboIEub6ys9DRrOSYPAVtL+4F+mQKhW2hAj6Zl0z0kIlE8AKtf91B12EU4/D//P4xlmYtNXzm1jxJbXdtDUhWeXIvmlo5fl+k34cpY2Ma5kdhnbWVLmYaFYXdgNjPLp1Ajc8q/FLzxd2t7usTsCqPhY59kZNa0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by AM0PR04MB4564.eurprd04.prod.outlook.com (2603:10a6:208:74::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.17; Wed, 28 Jul
 2021 21:54:53 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::8f3:e338:fc71:ae62]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::8f3:e338:fc71:ae62%5]) with mapi id 15.20.4373.018; Wed, 28 Jul 2021
 21:54:53 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next 0/3] NXP SJA1105 VLAN regressions
Date:   Thu, 29 Jul 2021 00:54:26 +0300
Message-Id: <20210728215429.3989666-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM8P191CA0015.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:21a::20) To AM0PR04MB5121.eurprd04.prod.outlook.com
 (2603:10a6:208:c1::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.76.66.29) by AM8P191CA0015.EURP191.PROD.OUTLOOK.COM (2603:10a6:20b:21a::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.21 via Frontend Transport; Wed, 28 Jul 2021 21:54:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0c8b1084-88fb-4438-9d40-08d95212547c
X-MS-TrafficTypeDiagnostic: AM0PR04MB4564:
X-Microsoft-Antispam-PRVS: <AM0PR04MB4564F602D98BB1BA92DD379CE0EA9@AM0PR04MB4564.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: drw5fnlDwuDy3eOYM9UlilJyHKz9yBUCUwW5WdMAHZeQMy9rJkYMjUuuxiZtHb1LR6szQcCF6g/5XE/agBvp2YULdfzCr+Vuh6SQVXFNxK/h561rCyN/EowA3TtUtjdtXX7ZJSbwMhUASLYFswOG9LOtONeZPzWn0hnw6lzuyyi+VuAWak1K5sIAtpcG1hYAwDf42UeG3mYX683mjwOv6n9cjE4287ih2dT9tM+rhxEJ2RwjMiQABDRjNCu5ZpTWJZY9/XIJIHEl+pGBad96zxX7IhqejZQJr515ebr3WrnJlI5Lqr8aS8u5hWJXLCMDExjAOunEha/tlo5c7xNcLWZJYlhIPAEDHCYYCZy34L52rtq+5LauX1309/2CkCnrTSM5Q6932GuerRPP2QS5hGZW9gZTdUrc4q8Mfu02E2XLKeAexRYR62EcBem1BTCfayGg9hY7ng1iv95hNcbX2AMW9Ct/jAYCybxkWvCkWVjqo7UthN1C0OSZnxSVobjNuW+c2qjF0+JPRQppSGXzZrnWScM3oSh/5t8w6zrkeHj8RhdD0TZlkVOYH5hyLe/xXsP9XRw8HRsB4z5V+hC4Juvv8uXGz1hIUYggvCRX1QMBlo0MZsnap9ngKcMRMPsxi6RZsXlqlOWO0cZ0/4GO/K0BLHa1ycriKca/s5UYvE4Erj2bntZ/fGMUbI9webf+eZjTBIkIADAaBjhEfqpifUgtW0SZesy9p5FtKsiSHJF9MR/12jlhjtQP+qMoV+JnwyGzc718SM35FsI+RdDJkw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(26005)(83380400001)(6486002)(86362001)(110136005)(36756003)(66946007)(4326008)(316002)(8676002)(54906003)(66476007)(66556008)(6512007)(2616005)(956004)(44832011)(2906002)(6506007)(1076003)(8936002)(966005)(4744005)(186003)(38100700002)(38350700002)(508600001)(52116002)(6666004)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?at5KUQpGhhl4NnQE/lAkKcCI5taROy0R1aEIMca5LevTC4xTm7fl8SzVSgGy?=
 =?us-ascii?Q?R4SWtDSWSSR4rK+EX4jBWiGE2Jk5DTKgR3Cn+t766trATNb/P4Cy8k/t3xO0?=
 =?us-ascii?Q?/cfArPcnPS0MG3Z94WVbSeBjyh+8bmVazJmD/OntfhZGuO+Yp8iBtxweMQIA?=
 =?us-ascii?Q?kMki7GYjkKAjnvf07DVDmHABK9DAwBy0GlE1o8JMskd3BDt/RkUnzSxrd6T2?=
 =?us-ascii?Q?Xsivn54ynVtTMCfv0+o7h2911/PI4sl+XgUmEzpzx4SI9Z/wWWu7Q4LOWzoo?=
 =?us-ascii?Q?/sCWoqA67uQ+RuzzryqIqCH4p6bDMzAPzOxYpvGFH8K/qtx/b/+1rToNLwEd?=
 =?us-ascii?Q?8TGXP/GpTzlG2KrZioIpeCcXDj24O9bZQp8smnXUnDTcHrrKYipGTjuBUEsT?=
 =?us-ascii?Q?0Kg7gW638wx5k8Y7JUpv4d8Ugka2t9as6V2/q7xGYYZj3/HSdQDdGAK2Hv/L?=
 =?us-ascii?Q?GnjiFwQ5L1z5inU1Rx24ZLmOaLr6mhzROV+TvBZNf/tIgm3w1zwpAHYYLZHV?=
 =?us-ascii?Q?B//SiCZDnnjCKi2hr5ekm2FmtNj9GjxRE9eWqgRhuImG9/2R0nEY1SdwKpNL?=
 =?us-ascii?Q?bq84hjTqykGEMTRVa8FSNWiblvqVpkMrbto8Flb1cmLEsh5FNJma7UlhQkD9?=
 =?us-ascii?Q?4pFQZWMzREzTbEy09FvN/6jNQiJrRe6NVwjtZ1wClmNQ6VKJ2ZAv5LSC2gF5?=
 =?us-ascii?Q?pHthNmpSZxnGAgw+IH3ZDaeW71SlBVOIKVMmxflV5CPuGT2VwIIpy8BWFDbJ?=
 =?us-ascii?Q?8f9Flw1BCks/iWgHq/n/IlsgsnODQ63YaXZ8ziHjO6+cCf/iT+CyztgnSUJI?=
 =?us-ascii?Q?ht1vzMeDLF4Wr5Fcu7XbKz3ME0LhwZBON0LUmJqaVvaYRfEgI4W8q2KUc4aO?=
 =?us-ascii?Q?WqFuz6lKZqdDXLiqlbwS07prEovmn4SQa/Uh6WqYhfBMuPWTkc/7/SY+1cmq?=
 =?us-ascii?Q?HLG4wlQOdSk6OozfdppRzAnNodHssl+09r0iS4B7WtQYLDc3+UAqasGDCMhj?=
 =?us-ascii?Q?4IbaUbsFkjotySS779R0OVr9NjfViPzgMWXkh4AUuOtW9seWKTBTcU0VyOAM?=
 =?us-ascii?Q?Lswdjsh1VazRiBKx+FR9J2nJP2VjC2Mwz9LGuPT/1LGjVLrt1FRivDrtZqFU?=
 =?us-ascii?Q?NW9tC0InozsieC82hiYlae4xZDYx4pR0AztouQWujGlmFBh3TF+TOkmD/5py?=
 =?us-ascii?Q?jLTwVPIYdiCORybAaiBlq4rJ7QtR/z5ojhAn2wP0JlMADlYSu/Qdr95zch5z?=
 =?us-ascii?Q?hOaIBaXGYTu4VgUpi860mrVpvxT/0HpjIic79yzbGHLBahS66+rmCsnq22Uh?=
 =?us-ascii?Q?FuQMqPvB/zmVGCnDDI/8otq4?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c8b1084-88fb-4438-9d40-08d95212547c
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2021 21:54:53.4125
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DmalatC3ptPOPtxuZLTBXHayNiojWnXevW2xvz25ysZL4XDtuJv3qBfyCr1qyq+X9NNtp+VObjHcCs94/CGAWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4564
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These are 3 patches to fix issues seen with some more varied testing
done after the changes in the "Traffic termination for sja1105 ports
under VLAN-aware bridge" series were made:
https://patchwork.kernel.org/project/netdevbpf/cover/20210726165536.1338471-1-vladimir.oltean@nxp.com/

Issue 1: traffic no longer works on a port after leaving a VLAN-aware bridge
Issue 2: untagged traffic not dropped if pvid is absent from a VLAN-aware port
Issue 3: PTP and STP broken on ports under a VLAN-aware bridge

Vladimir Oltean (3):
  net: dsa: sja1105: reset the port pvid when leaving a VLAN-aware
    bridge
  net: dsa: sja1105: make sure untagged packets are dropped on ingress
    ports with no pvid
  net: dsa: tag_sja1105: fix control packets on SJA1110 being received
    on an imprecise port

 drivers/net/dsa/sja1105/sja1105_main.c | 134 ++++++++++++++++---------
 net/dsa/tag_sja1105.c                  |  27 ++---
 2 files changed, 98 insertions(+), 63 deletions(-)

-- 
2.25.1

