Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B39CB3E3AD4
	for <lists+netdev@lfdr.de>; Sun,  8 Aug 2021 16:36:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231866AbhHHOgR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Aug 2021 10:36:17 -0400
Received: from mail-eopbgr70088.outbound.protection.outlook.com ([40.107.7.88]:17029
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231765AbhHHOgN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 8 Aug 2021 10:36:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TYa4iTscKzYIULR3iOxZPegfI+KRAwnEeq7ynSAU4fKKhVmzcNGFPgLSHPV74zlQGYkM6mCUGuBy34BzfFOkdAYWOFB2DkcOLNvvpp7o72doJOXtlBrmUNiBUOrSMN5L2/oKzyknElfWxtbQcga+c9Caz7n04sbKfayAtMHWKREjL7KiCHBt/gIWyetB1pmc9qpPM/Qr5VZNK0nzbPW/f9p7H+xVQSV3MtDt6ly6io9Ct5QK4XymNh8m+FXTaRMnLeVg8QmfzfyjCq67UclpjCWytMfZEduXvvGjMQ22PJwyt/V9EbdMbjoe57a9BEw8ebEI6ikABojdIWBCv3+NJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gd00sXVJX+WGtM8ltf4zdGhsuTcw6VAjMl/mqF9fvxI=;
 b=OgcEZHnrSP+UVx+rDIluScLRHN2z8B22Dp4GrfO3sY+t3mOSy2CYwYsoE7WHQ9CNcmA0pmEHIeMBTFteVj0+dxyKjVxnMgTWQQ2540fbXlFFTECfDq6AGKeb1ddp04UDYkv0T07ohYlZxAHB6Ej/mtagUSUsjz2KyNwQn9qhlJ1ZCzBAQ+jzmEcva7TCXaVcy0vJYOt8JQ6/dVgsTOogsbdpXZK8/Pe0TjVB4zj+oiLjUlywWb/4FYnqDP7lbrBuKDqmlKJeo7+1XpVrMdNjGF/nMbaA9/5wrgyRZTq1XdO/mHoh05Zp/5ENBDuc/M4E0e0pbt3dA7tf/ss0KfxuxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gd00sXVJX+WGtM8ltf4zdGhsuTcw6VAjMl/mqF9fvxI=;
 b=RLS7Xh0NMmB+/hq1YY2IGyPCu6JdFq4RGryiaM0AnHHhV0Bas592AQEUncLDWmxCXaKJsqHQ0fr5F1Q2yApvjo4E5rTjRUT1W3Tkdq0X9tliGz/6ZdK95GS+RTczwi6aJHjsVXqC+3Q4QXwo35+YLRcRzsoifLb0E+XqEdZMsuE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2301.eurprd04.prod.outlook.com (2603:10a6:800:2e::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.17; Sun, 8 Aug
 2021 14:35:48 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4394.022; Sun, 8 Aug 2021
 14:35:48 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 0/5] Fast ageing support for SJA1105 DSA driver
Date:   Sun,  8 Aug 2021 17:35:22 +0300
Message-Id: <20210808143527.4041242-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0601CA0003.eurprd06.prod.outlook.com
 (2603:10a6:800:1e::13) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by VI1PR0601CA0003.eurprd06.prod.outlook.com (2603:10a6:800:1e::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.16 via Frontend Transport; Sun, 8 Aug 2021 14:35:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 04cf3794-4680-457a-7459-08d95a79d01e
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2301:
X-Microsoft-Antispam-PRVS: <VI1PR0401MB2301B3910D674C42EE3FE3E3E0F59@VI1PR0401MB2301.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5Kxwn93lP+s9gIup9LAFofXfdD3LED7faV6aig0Jse8dVad16ynGhybyvsuXdAlh0pFU82RHTkCy/tBEoEK0jTHSOQo8eR3ek7uB8By2HeH6mL4/QiXwcdESp/uWbb4BLNsaWIjXDvlUwoT01fyjKzI70UvoQDEnpDihF3lIf3MkaXhvWmSI3t5F9K2khB40VAdh+LP04AREXLspv1SHt9s8G/Q9k4+sga/mpo6et96dYnhB4KI2nhJ0Uzznk8CqFVl8TwPs+rYuN8yjFS8Osj/aLRpQXWUMMQ+b1WWsLM+CeYrtDx15aYYKuiNs2gssgLRAuf2OYmUKurFBRpSHWGs5Xmuopybr3Huv/GYAb//Rl1WGjrzpmaA4uxbmvPwqW00y1lN34xgsGnUWKTOkJ/0l8vTbUIpl6J+kJY/iAMf1XpnThqR5P1KnavfnJAFpCFLbqA6qmlty/qta5SkIrwKrEHcAPle0fpIsIWuo3klZGi/EoK283XkyTBxb2tOPMu0gRwlbHqCojIYLXxXsZVn1w1qB+JqWUkqoynK945LzIkv4vePNm/lIb4DEeb5vO5EJWbqA4sbAlcyAWCeQm2+a7wMjNbZ3znqd4G/qQK4W9AnOW2OOdE5fav11rsS3mUSHIXVt/Y8qdiHlkUdCX1wD4rsALK+f6sdjMNaaR5Cu0I7Nllrg6qopsyHXVklancWrjFNCs/C2mVu/nFqNxA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(7416002)(36756003)(8676002)(6486002)(6512007)(956004)(2616005)(44832011)(4326008)(6506007)(186003)(2906002)(1076003)(38350700002)(38100700002)(26005)(52116002)(66556008)(66946007)(66476007)(8936002)(83380400001)(6666004)(110136005)(54906003)(5660300002)(508600001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EZacQ+X+VChHsEXNq6Wb12CbMJ+ue1EY7IlBDo3DBceYAmUf7llkiCt3q8WG?=
 =?us-ascii?Q?TSA825O36t1EqIB/Xg8ISjflh5OF0rObpgL/kevHN1L26Dg8D1C6JnsKDG1r?=
 =?us-ascii?Q?TUW8ApNW9bJ3xkUi6fyZwU4CJ87W0ZYd5LNR0gSrBiPxoHmjx4WvafDlHgTQ?=
 =?us-ascii?Q?HWrLiSzuKfgw87F7qGkLIj9mkSojH00oDUEa/3DPIt88Mke9w3nj6dtJV+eg?=
 =?us-ascii?Q?KAY2EWshp0OfaTirUyRr2uEIc1+yLuaPuLArk/XwF1gyzTW2HwWQwnR5dGRa?=
 =?us-ascii?Q?/dJFFs7g3r4x0taITSUVWm26T/bhFFQx1pQrlUupTiY/REIySlwSZNPfjKIb?=
 =?us-ascii?Q?cXVce7UGdy/Ww+MpAhBUTzfOWNeXBErBMOY4Vboh3c0mpsjLgCRQzYQEsB9d?=
 =?us-ascii?Q?pAl1zvlK2sfm7SgL61b8GKiZInSTaYKomzM8m4ixWWKhEDNrvvQsntCtwMo4?=
 =?us-ascii?Q?Ev0087GF5q3aMvhKUIgN5pqTwVSkz9aGNclgSxm9lIsPCZm+gfrPxiTriDac?=
 =?us-ascii?Q?aR5EY1LXc4jGkCRcNxJNkui64O6jsIOJsVTqGjwYQK0UlgS2OFfYw8g5sHJd?=
 =?us-ascii?Q?00Z3cAn7OgGRl9FdrpdSYPXkPJPawpvP6cdyhqovHmk6JZzsTxjwJ1Ggteib?=
 =?us-ascii?Q?GgBjQ+JXSmoXAGsID2gfnNhfDMrgdB3vE0ty/Oiio2tNTiXn/5caJWEQatr5?=
 =?us-ascii?Q?MD+XUTr2Judb6AGywdi3YR3ZyYniYqDFshNVcfFGIaW/FG+PCeFS6bEf4rja?=
 =?us-ascii?Q?AlSP4DSjIQJhlI4Bxf2LsoXDoE+RN4BxSFymzqpynd0B7rbj5JLt8Gy8oyPu?=
 =?us-ascii?Q?MkseIHMIOql9GW2p3PG4i6cbATMarKQKooV6t01I4ytAduyrYUWrXUpKD9pL?=
 =?us-ascii?Q?N6Qmp56TsrDGXl9f5SLR+/RSE2H2xiIn0pDb/VJbDJAFCV8gtodc9abArL7E?=
 =?us-ascii?Q?XVsNdY7ndX3KRJls3hTn8jpcdld2BqfZBqoSFmeSrjRT6TsmqIv6kycIesqA?=
 =?us-ascii?Q?xSUT52VjeYXNIQhJRrdPvwKz9uJrWSOIAkaLVyksn14sAinE9AKtftlpbXDI?=
 =?us-ascii?Q?HtSg5j832tmYaLH4VE3kTjxZew1frit3tvrqug1xXxmsnkQYG3TXd53kL9V/?=
 =?us-ascii?Q?RKnGi0l5OHQFEHwBTjwAvuNQD7NV3HLTCNoFcCpA5yMvupG8vzCQsfsya/Ss?=
 =?us-ascii?Q?iYAnmACZeTVYXjwA9rMVCN1nu7JBXthFSs7RTJrXU2jE2tzd+7vhZ2hhtv9C?=
 =?us-ascii?Q?dPcnt7mFjyIqaN+0KGxXWDQI58hHDXwZRlvdgg7Qbk1xg0nPWI6gsSBdHu7y?=
 =?us-ascii?Q?YZ7eTPtqI9qxs+5K405lzXn0?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04cf3794-4680-457a-7459-08d95a79d01e
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2021 14:35:48.0674
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 66egNeNeFOA7SHoXrmqLGEt0iqzOPCb1b/Rg6i9h/2Eq3gU9j6wmZG4f4ilULXd5FhgjyN2yvx2Kjq3o9Poh1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2301
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While adding support for flushing dynamically learned FDB entries in the
sja1105 driver, I noticed a few things that could be improved in DSA.
Most notably, drivers could omit a fast age when address learning is
turned off, which might mean that ports leaving a bridge and becoming
standalone could still have FDB entries pointing towards them. Secondly,
when DSA fast ages a port after the 'learning' flag has been turned off,
the software bridge still has the dynamically learned 'master' FDB
entries installed, and those should be deleted too.

Cc: DENG Qingfang <dqfext@gmail.com>
Cc: Tobias Waldekranz <tobias@waldekranz.com>
Cc: Alexandra Winter <wintera@linux.ibm.com>
Cc: Julian Wiedmann <jwi@linux.ibm.com>
Cc: Roopa Prabhu <roopa@nvidia.com>
Cc: Nikolay Aleksandrov <nikolay@nvidia.com>

Vladimir Oltean (5):
  net: dsa: centralize fast ageing when address learning is turned off
  net: dsa: don't fast age bridge ports with learning turned off
  net: dsa: flush the dynamic FDB of the software bridge when fast
    ageing a port
  net: dsa: sja1105: rely on DSA core tracking of port learning state
  net: dsa: sja1105: add FDB fast ageing support

 drivers/net/dsa/mv88e6xxx/chip.c       |  7 ---
 drivers/net/dsa/sja1105/sja1105.h      |  1 -
 drivers/net/dsa/sja1105/sja1105_main.c | 73 +++++++++++++++++++-------
 include/net/dsa.h                      |  2 +
 net/dsa/dsa_priv.h                     |  2 +-
 net/dsa/port.c                         | 55 +++++++++++++++++--
 6 files changed, 108 insertions(+), 32 deletions(-)

-- 
2.25.1

