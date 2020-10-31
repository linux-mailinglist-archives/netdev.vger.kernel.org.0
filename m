Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBCBE2A152E
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 11:29:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbgJaK3c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 06:29:32 -0400
Received: from mail-am6eur05on2066.outbound.protection.outlook.com ([40.107.22.66]:21857
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726697AbgJaK3c (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 31 Oct 2020 06:29:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BCivb7MDsMJpbrEMpx2jETY3mH/jklkVxNmEsga561oCXwC1x0CjOktUvwA5hRPLHDVPkLwdse8jQ8u4iz2cAAPbaoy1IDQdO91ILA5DUPTOvlrqgbBqQrCK6Q8d+6xfpksqKMgqRvhs0lo2k7m3/Ip/mJX91xpTvMxeV2jM3VEfTXw5/SRvS5CTa6ZKkWHeLcGzRzXciiGKdTySPASDZdYErW7h6WWA/+DINN8mpEYw+VFnqrDEU5mFEiYpBKv/8bqViBfyF79Lmw9zFOOKJhCRiFB9BKKFqDKF7mrZHjyUtpgihwRe81uEiqARnlqmtpPgWBiqHrL5YFlGNJw0eQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ScqLLXlvO74C+VrDtEMU/kiYDZ6OmqNnvuwuNwG2kk8=;
 b=DG+YAFlDtOxZ66R8S6/g7EPlh2jgOOYddU3AJlSRgJjDM1HRnpSY0wgCGi58m9Av6g27H/svzcKzfv0gZmmRBEmFlaoj58n44rhysIplZ/LBU+X0HbmuMjD8pqe5kWEy0ZfIiWWJuy4VQt6evWVCJ0yRVTFmPk0q4xjzk5waLMp/OZ9FClmle8yFvKIE3JPE+wK7g9zNPWRGwf9m8o0IEJTOECNLiwAuvvesz5VvSwf9qAOpd7qcqxcFYeUo95aBf+MQtKMoJp/uu4ybK6lNOjex1ZbNg1VJ3wQ590ifwHenkREgFPqHB1IhjrTjqrfEupzDym2Qf+H2l9fNkALzcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ScqLLXlvO74C+VrDtEMU/kiYDZ6OmqNnvuwuNwG2kk8=;
 b=d4i1YwyYUOJA0KMEXuP57jCJ0RmAqeSIWnTbMvboKA+T91oUskYVcZuRf1tRzWker9izkqY18yFNBWt+q7FaSKp1j99lTVQowAWvKsIHXVrBs3gqM6n/WTWhCBWUHQ9lZSsDk87erw61ie0YW3bXovGMq1Cb5U2w9sc0iS/pBBY=
Authentication-Results: microchip.com; dkim=none (message not signed)
 header.d=none;microchip.com; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VE1PR04MB6637.eurprd04.prod.outlook.com (2603:10a6:803:126::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.27; Sat, 31 Oct
 2020 10:29:27 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3499.029; Sat, 31 Oct 2020
 10:29:27 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/7] VLAN improvements for Ocelot switch
Date:   Sat, 31 Oct 2020 12:29:09 +0200
Message-Id: <20201031102916.667619-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.25.2.177]
X-ClientProxiedBy: VI1PR08CA0170.eurprd08.prod.outlook.com
 (2603:10a6:800:d1::24) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.2.177) by VI1PR08CA0170.eurprd08.prod.outlook.com (2603:10a6:800:d1::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend Transport; Sat, 31 Oct 2020 10:29:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f3280244-dbe1-4a38-ff29-08d87d87d7dc
X-MS-TrafficTypeDiagnostic: VE1PR04MB6637:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB6637FF37DC91862931A2A3A0E0120@VE1PR04MB6637.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mTt4zuupIa4yExw9MkTmXq7tXetTGn+MKTVS/RB8uZLCMLLMFpQJfHqME7G3R8woi48rUjC1TIF3qYWP0TglBxKHepRd7Ul9axSU4QPcncvv+J8GwHPYe9eImbdxxeV1yXVQbvf8QR6kIUl2/aovEzR/khMeHJKaPv/BYxz88rTJXmeet+Vr0/6oxpZBhJHdFlp1Uf+a/i7CobJgXATQ09B2fmvNcyN+KZxFuPAGc/kkQHHr9yhhRwVnNXbX/G3YfdnGULqUaD/S4e6kSPtOMVsRHpP3RnZQUhxx+6lxFQ7mWtTBEJfZztp4rB/NdPwOuKC8WNV2e+OgqAv8loY1+9xRUXKVHfxqgq5eNm79fs1SEdcMDRUpR5IWkWsUijDXrBTRyN+nuPOUnamNT7UpyB8k6Lbaf7JU9ZSoDq/vavoICgsHjBfD/VqA3hhIjEWvfUZVw2ca73xBYFVcwwaMaTkSEBTz1MmNynY3oWpgeRc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(396003)(39850400004)(366004)(66556008)(1076003)(316002)(956004)(86362001)(66476007)(8936002)(83380400001)(2906002)(110136005)(66946007)(8676002)(36756003)(6512007)(6666004)(16526019)(186003)(52116002)(6506007)(44832011)(26005)(966005)(6486002)(69590400008)(478600001)(2616005)(5660300002)(921003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: b6Cl5i8Gdw10+rjj5O/1kbDLlgn+2Jrk7YubXupcHeEr1+Qud7utjSIVheKHRKsspqb/Lc94rX7L1uFayy2LAGix7/LWMm/uX6DlY0oVqzFy5UNnck/bIgKzeVZ9V/vfLZxFhLNFPloOEkbWE14p1y2bfIi42aBIVeJ4UzhT4sDQ08OsEDm3vdZhYOiy/pgHucVmgSh5zyfxOc0ou5/dMC774TPlTzkUSG6IvxAHvm6QvyLLJFtx2JWUkPma54QCk2+uazZxc2I9hopNLiIHKgVUNzDbFodoIpmLkqpz91bhMeYfKmcQ6fOL/nDn4u4F/3cvD3xbzvaYAL27Ed4uCAFGeE2U3FJe3aj4TFWG4+vTE9wtJ6aLsV8LB6rRU4XaZZu6vexsx6nzoJeljjirlL2V2k+9nwu75OhBSMzdT0FMuDrEO1e2/Hw5HtdKHrErJ/9kyxeZoNeT0Ar4RyUGCV7YiOuIaxEg2duiwRpduPoDg1N4poGJv+lj7e4tYm9VT4J3Vf0JrXguDweAqYaYRqL/uw4C5clj6IFYjwvvJVRu4Xtsxplo1eDvlNtQvOq7MWg/qub4KSRj47JF2wzYyotlcdqGP4asFjgqV2o19ASuvTNfSHZRKPjnGXaFr9DxBPE7shC7QRAQ24deAmAB1w==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3280244-dbe1-4a38-ff29-08d87d87d7dc
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2020 10:29:27.1105
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tIQTHsku5XA8pz+/NYec4jLiTxXyTwD4cBr+hCHnTAQuie9wisfATjnnJiXeWl9AAMR8YatNlSOKt8eCdoMBiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6637
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The main reason why I started this work is that deleting the bridge mdb
entries fails when the bridge is deleted, as described here:
https://lore.kernel.org/netdev/20201015173355.564934-1-vladimir.oltean@nxp.com/

In short, that happens because the bridge mdb entries are added with a
vid of 1, but deletion is attempted with a vid of 0. So the deletion
code fails to find the mdb entries.

The solution is to make ocelot use a pvid of 0 when it is under a bridge
with vlan_filtering 0. When vlan_filtering is 1, the pvid of the bridge
is what is programmed into the hardware.

The patch series also uncovers more bugs and does some more cleanup, but
the above is the main idea behind it.

Vladimir Oltean (7):
  net: mscc: ocelot: use the pvid of zero when bridged with
    vlan_filtering=0
  net: mscc: ocelot: don't reset the pvid to 0 when deleting it
  net: mscc: ocelot: transform the pvid and native vlan values into a
    structure
  net: mscc: ocelot: add a "valid" boolean to struct ocelot_vlan
  net: mscc: ocelot: move the logic to drop 802.1p traffic to the pvid
    deletion
  net: mscc: ocelot: deny changing the native VLAN from the prepare
    phase
  net: dsa: felix: improve the workaround for multiple native VLANs on
    NPI port

 drivers/net/dsa/ocelot/felix.c         |  27 ++++-
 drivers/net/ethernet/mscc/ocelot.c     | 147 +++++++++++++------------
 drivers/net/ethernet/mscc/ocelot_net.c |  38 +++++--
 include/soc/mscc/ocelot.h              |  17 ++-
 4 files changed, 138 insertions(+), 91 deletions(-)

-- 
2.25.1

