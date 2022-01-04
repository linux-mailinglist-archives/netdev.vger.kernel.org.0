Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F7784846C0
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 18:14:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234257AbiADROs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 12:14:48 -0500
Received: from mail-eopbgr150045.outbound.protection.outlook.com ([40.107.15.45]:22762
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234468AbiADROf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jan 2022 12:14:35 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lDYz1Ox/MqLZObD9CHek0ynyrthFyI10HgM1GOuHVnHeDUKF2rioWwOixvLCbM3jTAaPN8d/8bgGUQdlV6d7HNq4yshC/T/OUgUloeBYw8vAhwjRcM/fyUEP31MqVrYr7oRs60k7pkvX51EDLORxHvWcpsOCZ5Zw5mIcB/5SqWAAFNoaQs7Dl7Y8FUcjaglcs22B7yBXVQtRR+mXox2hygQnBbAoXts1cczlE/6NJPs0CuicxNSGAbjIzrEXzjzoyAFzLVCvkYtpV2+2TfpW4h1vVtFqmuZvsqcy7M5EhGD2GXxWxW1A44pGhj+w2zgESrUsL0BMGp1+l9dUKsRn5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mAjQywCGYPvm8zhovPLxFR83VcGDnmZeVl6iG+dONdM=;
 b=XrE5FOn1S/W5RaZunnEwUkdksdyKuphUv6ZDqnZeaD1AGOT3mtLBfv9p6+UyPBV1E17/jiYPG9YHBjrHjkC96JVu4mTpHVcL4te5kmsd3e7FkNMrDc8ZIPfbx4rLWLNNiMasa5lsEZnKshfTFLnWbZooaUiG6viaKTiP9lvK29bCpH8bMtzEVPY6X9LgFyI8YLwa9+rtL+B3s13xp1Nb/IkwaF3UBoz7H8MZdYXnAF8I7mYf3hTCZIifmitgXFoMTtzaWWYq+MYi0u8Eh6qBok959aXuAIg0eRy1EAqNEEyS8TPGoHTA/RQlGU1op/kPyosMZ+Q0D6K+Z3a8/soPLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mAjQywCGYPvm8zhovPLxFR83VcGDnmZeVl6iG+dONdM=;
 b=F3D47UTS5cc78VAQci6afqQptK800WLAnfRPsgdsa8yJWAw8NM++tBytwgDaAUwtmASAamm2a5osNQzQ7R9ig18kOR94zh4OCoKb+Wofy5dwIqnVvamkOQjnZ345ydjlwmKUyDJbmr+bDlDLecvSe9Fb6FgSNPR/FFwp3CmSOLU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB7104.eurprd04.prod.outlook.com (2603:10a6:800:126::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Tue, 4 Jan
 2022 17:14:30 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4844.016; Tue, 4 Jan 2022
 17:14:30 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        George McCollister <george.mccollister@gmail.com>
Subject: [PATCH net-next 00/15] DSA miscellaneous cleanups
Date:   Tue,  4 Jan 2022 19:13:58 +0200
Message-Id: <20220104171413.2293847-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0192.eurprd02.prod.outlook.com
 (2603:10a6:20b:28e::29) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 55fb3b9c-8232-477b-94ab-08d9cfa5ab5e
X-MS-TrafficTypeDiagnostic: VI1PR04MB7104:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB7104B42ABFB7F944AA59633AE04A9@VI1PR04MB7104.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tbzWqr8CR6dOyKXlxE6KrXL8AckJf4tSDBNyZsxd+PluUXvxoGPUnZfUMxkHIqLGVWX7E7/CfcA5gsNcMrDvQvtYJOKIi87sQmWnLBAzBwLMMbXpM+GcPfecfcuTdizgIXnec1u7AjkSM2Xg3O04eGdjxGfnYbM7RnUgzpzlfKTtFmSZ/b9t3NEX/AcUWnKk2drB3hytQlZzt+dZITopxRXfzluAJ+Z+h+L55dsRlLuL3Bm2qZbWaX0q75UEvj6DZGNdKcfHwDtb8Ru5D5hbIV3l6Ql/iC/n4zhEi2oiHwCLAia2l5K6zxBDwWTPZPj8FUspmhRx3SKZWGisEjL+A1RtMchzQ4Lmn71rkzMteFe+pk2PQleC9tQJNWDD+yCc2Y4ysY8EX+/5Bjn7zHQrXm7YA4GaELfWDkkZsx91kgJHNzPbJ8frxC2Ys6tqbAl/B9PyPyL/P97eHt8n4C9r98hFn2xzzXpPzhqPGK9r17SIr1dE+Y1Rbdm7Xc7kK1OT8Vs6ARlsccUs5q4OpTKJiwVHj+hbY4WF5TTCvZtLa/xBW8HuJHPJlMyOnmDT6EVID1eSMLB1bar+yU3Ag1iAvubzk+unys+OIKYsJ2JNegL0etX6U67+HZQ2lW6AhxCv0quMBqD9gy8jNNd0WiGreDD3b6pQK7rR9/FLgz/VG72xdWcgCIL0Nwk8yc4bM+LyMsW1G6Hg2EjJahyUXqqm/g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(54906003)(86362001)(8936002)(8676002)(5660300002)(66946007)(6506007)(52116002)(186003)(6486002)(26005)(6916009)(66476007)(66556008)(4326008)(508600001)(38350700002)(38100700002)(6666004)(36756003)(1076003)(2906002)(83380400001)(316002)(6512007)(2616005)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?S/z3d/JsFx6ANFSPjtgONljIuQyZs0IUolc6ONzxt+M43b7iU5WX1vXIinru?=
 =?us-ascii?Q?zO18n4wf779D6+tU8bGf0n3v8SkclOJ4L2K7Riy1vLMAj4X517uBZRVdQb5h?=
 =?us-ascii?Q?W/9p3oewpvz4N3/y2x+uA18gr4ia+xTMBHiWh3eSTvQR1yEqOEWEyk1x6yrO?=
 =?us-ascii?Q?tp8WFqTIFUEUBwDVBHyvZFM9B5NDXKTntTIgiw7ZhNYS9aLn888nPH6OfmWz?=
 =?us-ascii?Q?YZTvVUT44hMd3cmFtAGSgZZ5kX36TDmvpn+o8LG0kN2/YaRh1Le65/r1lwqT?=
 =?us-ascii?Q?GbxEUrJUwpdoT/LHeU7+RNrxb3P+O1Jmb8SydzB6b8tcDSgXNLqLJeT7RHVZ?=
 =?us-ascii?Q?CRA0FEeFrAAzvMR2oRlZX87NurvvX62IdLpfzokaA02V2sr45MBkCxV/+l3a?=
 =?us-ascii?Q?mGOWISXeK6Dm9pXCMfGxpvrRo8yWCfTC3YZRLV0N9pAcTVT4JjO4EpReZPWw?=
 =?us-ascii?Q?hCI/1WzSGo0RMsL1qf96H15vZ+23xh2xs2q+Iefiz0mnS/ZzdBNk+Rrz2yR5?=
 =?us-ascii?Q?vs/IyXpnMddJ5zeA3i46bCTfNZG4QKGI64fqrWWI5umv9D2qDmSerqnJWYYr?=
 =?us-ascii?Q?QS36t12uCBPqKN+fH6FNqiYUjIA+VIif5TheLNgf60H7q1LT3T2Lg285Oaaj?=
 =?us-ascii?Q?FiIAKu39tcVVf3qxRRxvtmHvCn1FtfmTwoSTtruPBqa5mUUKIvL4ej5ekD16?=
 =?us-ascii?Q?byy0SWF5w9AOsCLfNbbUMNoEVRKEGzrdySvGqs8lmWk+CYjyilPK77YgYEur?=
 =?us-ascii?Q?ZKb3zybv5QBWws3DUyPtK0rdDriABCsysNZbLgkLMEbVYc1EymukrRl4LIRk?=
 =?us-ascii?Q?1qqRgnArZyUKRzw/cBrJ7M7UeQjxWbzGZ6+nYKOyIyK+K76pTrsqVCX9qKLz?=
 =?us-ascii?Q?9o1ElBQmTLklK8+k8uFtEPBgVFgMucNFwW3ao7FT9MGiStwnWKMjSkwvyD3E?=
 =?us-ascii?Q?PeIeOsyWdFEzAmzcrz8s7Niqu2XxiFVxd2zOHMMFhDdgwHLAGmajmU6PGrZ5?=
 =?us-ascii?Q?wdtmD9CGaOx8mJGx0xlkw3xrmqA893oSUDbqdLDoon9WhhGoD341vVsbm5Ii?=
 =?us-ascii?Q?W5cYBFxmpA2anCWxd5SRfIOusqMyQTTsEwkkWIrNdbIR2gTtrk2CvYG7ZrZn?=
 =?us-ascii?Q?P4QJiaC1b1+wCcDcqmIEiUgewJlUotmYXfO8i45t8UipnuE73ReP9Yn37Ywe?=
 =?us-ascii?Q?pEThAl7hKzXafuJ+8AHXmbskRwIFV38bZcULBaTgwSULJJaQDbBnTKAMNNFA?=
 =?us-ascii?Q?fS7Dg9/cZYdYnKR4FgINuivxMAcK6P4uCV2cfpD/tcFqLpH8r43mtzI7agva?=
 =?us-ascii?Q?3528Fr2AnWL2GoxTEF6b1JW3Z+8NEBI/qKOpJtY26UBFqM8hz5P8QlejOkwA?=
 =?us-ascii?Q?n7eORwu6v2vLZFWorZNQ0qU1LmdTENBENF+HoV27YCFRAh9S3uQE2ieFrEUj?=
 =?us-ascii?Q?97OEpEJUKexJ9HMPDOkpzjitQjZjM8sJrDfm8yP4mGeG2YL2rdpauWIkEuFd?=
 =?us-ascii?Q?r82YucLxzhpRznFFIzgTxfwQXPNA+eJC+vhHkv1EIFz8FIwNpN+F30hJa3CN?=
 =?us-ascii?Q?MsskCadHzLG+Wa2IMS2MlzLYjXjdlVnlBhEfvFdkXh3H2oU19wLcxcLNuYkM?=
 =?us-ascii?Q?fAepyoJ+OTJCo4/0c7dqPSQ=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55fb3b9c-8232-477b-94ab-08d9cfa5ab5e
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jan 2022 17:14:30.4103
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bEC4uJmPIxsnpZTiS09wKCmYmW7rEGVhVsT1jDig2h7IXonJy/blLYXfQ5NUD2ojg8GcxZ58IpAQkKGIwPYaaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7104
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an assorted set of cleanups with the purpose of consolidating
the development work done recently, and preparing the code base for more
changes.

- delete one unnecessary code path for DSA master initialization
- less frequent rtnetlink locking during DSA slave initialization
- symmetric DSA switch tree initialization and teardown
- deleted no-op cross-chip notifier support for MRP and HSR
- struct dsa_port reduced from 576 to 544 bytes, and first cache line a
  bit better organized
- struct dsa_switch from 160 to 136 bytes, and first cache line a bit
  better organized
- struct dsa_switch_tree from 112 to 104 bytes, and first cache line a
  bit better organized

Cc: Horatiu Vultur <horatiu.vultur@microchip.com>
Cc: George McCollister <george.mccollister@gmail.com>

Vladimir Oltean (15):
  net: dsa: reorder PHY initialization with MTU setup in slave.c
  net: dsa: merge rtnl_lock sections in dsa_slave_create
  net: dsa: stop updating master MTU from master.c
  net: dsa: hold rtnl_mutex when calling dsa_master_{setup,teardown}
  net: dsa: first set up shared ports, then non-shared ports
  net: dsa: setup master before ports
  net: dsa: remove cross-chip support for MRP
  net: dsa: remove cross-chip support for HSR
  net: dsa: move dsa_port :: stp_state near dsa_port :: mac
  net: dsa: merge all bools of struct dsa_port into a single u8
  net: dsa: move dsa_port :: type near dsa_port :: index
  net: dsa: merge all bools of struct dsa_switch into a single u32
  net: dsa: make dsa_switch :: num_ports an unsigned int
  net: dsa: move dsa_switch_tree :: ports and lags to first cache line
  net: dsa: combine two holes in struct dsa_switch_tree

 include/net/dsa.h  | 146 +++++++++++++++++++++++++--------------------
 net/dsa/dsa2.c     |  71 ++++++++++++++++------
 net/dsa/dsa_priv.h |   6 --
 net/dsa/master.c   |  29 +--------
 net/dsa/port.c     |  64 ++++++++------------
 net/dsa/slave.c    |  12 ++--
 net/dsa/switch.c   |  88 ---------------------------
 7 files changed, 167 insertions(+), 249 deletions(-)

-- 
2.25.1

