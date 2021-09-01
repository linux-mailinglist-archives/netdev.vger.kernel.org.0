Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 788F33FE5DD
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 02:33:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344914AbhIAWwp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 18:52:45 -0400
Received: from mail-eopbgr00087.outbound.protection.outlook.com ([40.107.0.87]:32899
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S245624AbhIAWw0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Sep 2021 18:52:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GDbjaI1z8+0pfwGdTUpu0ELtpX4psesNSJdF7AdMfbFrA5+Ej1DasRxg6JNGLPi+PCcpVcKWWGBwN7HdWFWmYPrkJLwSbTOwBNXjGwCKL2swpGHaOQjtuaCs4R1sWVvI4WCywu6DyudM4t5+9Wl1jlwZsIdZzQ2VQekvgJL+1Ynh24mYLfyg6jOxiax5p7s437VOrqtOu4tPWjTrQeVH6cMnOlzkFhiKhR1jidwrleNS+gcRSKa73ef6GYruHzaRSafP0YqVr5P1tjqeSFL/3V6Lq9q/dkTyh5zUXIKaaUSuyEQUxjJPkCsL1uD0FG73clxQJjp5q1miMz2iQqFRQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=+HgTtnB8nMO1RfbJjwju+iPYZi9GWPjMwGFOVRbuIkk=;
 b=n7BRowV+oyHmEecu7qlBBQl2/bc2Ol3HefMJdNSIpeWAJ3nGrgdxFxF4jlBKfU71vRlUO752gRK6gIR9Go2LFjTA3MTy+XYnDPRiElA7p21g2BKQsy7iTADPk06CKUMD8qAbXk5ZJDmSW0j4wcKeWYQ9veR5dSYZwB3biql+dcQqe/CSk2VpwKQVfBG5vDeS6Cm4nosGGhuJBsPsx+PFpl43bMOHn5XQsm/xAHdLwOXyLe03R6K5FlsFzFPZlw3Lpsa3gyWYcp4OXBelPdBGw1S6r9ccLAE8uUPq3fI9xgIytvPdF+aCM1QhgOvTRueRLh5DdqIFWPO9qY3wYJb/xQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+HgTtnB8nMO1RfbJjwju+iPYZi9GWPjMwGFOVRbuIkk=;
 b=cIhA0QVnh7bkz3+boFOF70Djc/iDaFe0Y/i5R0Qg4Fs8ZGPXv9zVTJBjxUa4bv6ckrwOjA+bl9l7qBOjxlMZXpx6jCYDb1W1AwZ0f4ZDkkrDvWx630Jy8veD2jNEhJ1K2O7ByswQ2yWrDiFjuRbDI0weaB5YozGU+ZK9ohRR30Y=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6015.eurprd04.prod.outlook.com (2603:10a6:803:d8::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.19; Wed, 1 Sep
 2021 22:51:10 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4457.026; Wed, 1 Sep 2021
 22:51:10 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        kernel-team <kernel-team@android.com>,
        Len Brown <lenb@kernel.org>
Subject: [RFC PATCH net-next 3/3] net: dsa: allow the phy_connect() call to return -EPROBE_DEFER
Date:   Thu,  2 Sep 2021 01:50:53 +0300
Message-Id: <20210901225053.1205571-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210901225053.1205571-1-vladimir.oltean@nxp.com>
References: <20210901225053.1205571-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR04CA0130.eurprd04.prod.outlook.com (2603:10a6:207::14)
 To VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.78.148.104) by AM3PR04CA0130.eurprd04.prod.outlook.com (2603:10a6:207::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.19 via Frontend Transport; Wed, 1 Sep 2021 22:51:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 70d707b9-24c7-4346-867a-08d96d9afdc7
X-MS-TrafficTypeDiagnostic: VI1PR04MB6015:
X-Microsoft-Antispam-PRVS: <VI1PR04MB60156730901C3CE74FC6C2E0E0CD9@VI1PR04MB6015.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fZkwuLHjB1kzK/2ZbDKGNhrRvquzw6rXOw5INPIT8UEyhMaU6U/rBpzPuwlQPligjHVa0TBiH3L7KHlfinmGOhNoPF2JH6BN0DjT+N6UB8RRQ1rIO7uAGUMpGsz4ARdpfV8scs/W6bK4C68eCPlke+RN5jHxnYupmZLDh3qfD5hTcf/76ELiFILF5rh1quO/zZOZ327o8tyQ9x3bSOjplnOw6XfRd86gUNEcm4/P30lkvKzviNaf2pyubsjcL5RXFrK0A2nOMbI+GEcW5fl2aSyObXN7TMGmFE7g++8d2aUsL3e7cNCzM6tZ7SDssHaBoiv/JdxpvtiKULrHoQnlDWXVDtTxS1B2iEED/Hr9wft69y8c0Fh1okoR00HYhGA2i0AyH5ypw2cCuL+aN5MO/oAaPRPGY27SImS4MNhjwmwb0KJECa9DYLY61U4rRrtlgT8tB+nejho5CzvoV3qshoaaqKgkVT+a0JXbyNF1U2JHSNvbn15K/eDQg5i17Uzi9LOly/PlsLZ+Z6A1NtiODrhnuwSTSjpDPPFGn9cicxm+yDwCOOq88dRVLYB0HVjbdNzYuC5HKw2KviOKzVmDwtRM8QDmq3FJv6C2XquVi+kGzTwqjLuozFPaO2kRHrV9ax7sI35bKTaNB3tcd3AO6002arrAozjE0QY3M5mv2hwh8/90cip9HDyHTXlanwjYSxsSTXOozbbOAGoU0lsP9g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(396003)(39860400002)(376002)(346002)(66556008)(66476007)(186003)(8936002)(66946007)(26005)(6506007)(52116002)(316002)(36756003)(478600001)(5660300002)(6916009)(2906002)(7416002)(4326008)(6666004)(956004)(86362001)(2616005)(6486002)(6512007)(44832011)(1076003)(38100700002)(54906003)(8676002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KkOoPhiEIntsG9fdVBkZE1/o9kylCb+0AxCniwYl2ZlduGWJS0Tq91MTtzi2?=
 =?us-ascii?Q?uWy4eMHTyUDoKW8DIoQhFopSoAAcgJ0/agTruDvDCumgpiRsXu3iTDSjADQR?=
 =?us-ascii?Q?ANq2gVMiUWl+P2kZZXStWPMOLUT1k7ScgTzqwesx1pp2GcEOx8Yceo5308nK?=
 =?us-ascii?Q?elSJA6/FaIwXMiU9wPKBt3ZFiPxPhQZ+XLW+utBjw+OrqDTNBtznC/r6xEGd?=
 =?us-ascii?Q?AC5PSx47AKhXEvQiwMV06HA7qD5FCABKzatvX8MHzXLAJ4/vWAUR4XLw/pQU?=
 =?us-ascii?Q?3accBrZjFsVqmv9NbIOtU6NlxPzHWKhnY59FZ/ZvCUXA1HezSLMuvVk3sIke?=
 =?us-ascii?Q?9ltKElsr8rxqgnznJWFH6vUqO7NxaCdxesKFG3Ult6vE11gGZ3EC82MAidMN?=
 =?us-ascii?Q?WTvuZBfB2CFlcIEdFEUa/QZsFADXxOPozHGMCI3lSd+L/YECxcLPDf+LkJST?=
 =?us-ascii?Q?sn9uVTH3fHsi42mez9rm+P4OzvfX8QJWIZsoCpSU94GO/TSb7P1B/RAypw+f?=
 =?us-ascii?Q?5aDkERoANOAQdUoIN4HSMEA4vwjWWdYTMFuWKf+ZNuRA3r6lpTRjKHAVYheP?=
 =?us-ascii?Q?KVp2s/0DCnY0sD7zq3i6YSx5xHNDw4q/LZPXM31BzodtHu+Y2c/fnKjdw7XV?=
 =?us-ascii?Q?04sSbWBROBcK97CHy/JQoWJ3aMcMeaYXjkdOpIrCWIQ/HPRXi3cE6Je7Nv1F?=
 =?us-ascii?Q?bGS/gQzp7sglens0FAxnnQxL4jj9VQ7i0/MKWJywGeO174w6ekw9Wy4duw4P?=
 =?us-ascii?Q?ajPTVAcS7E4wtKe3X3DLdNRYwn3IGfIVi72xY8ZKfyz3kc3row2fiZq2xrl8?=
 =?us-ascii?Q?pNMM1fV5e1+h+BJwb+4g/1kSZlfxx4LflR7CM7bHeDPi7pFtsuG+Insw0U8q?=
 =?us-ascii?Q?/PMMVc7lCbvdOkW7EuoWahioNucVz0xTwTAIBXhAllKwntsUcvIilBUmbZQr?=
 =?us-ascii?Q?1fawrNmvxD+1K1XwHJIQwbBvFgQ8Mfbpvh7gZGazRZ/Dh+HruGQR0NvmDjw4?=
 =?us-ascii?Q?75Z0wmRH3/NjDl7tMgxK4fX9ujxc2kruGVIpl7TSyT1F1zVfpUXDVHoqC/kH?=
 =?us-ascii?Q?1xCqgnWJtvAmTap9jCOsELGkzbhNElSY8wcgzvFQflaZz0Cw9krb016udnt3?=
 =?us-ascii?Q?RJoxSESckQobdjo9z5yV8MFMeD1AXoq6KdG1ezB3dkew11kBD6t4YliCYHFi?=
 =?us-ascii?Q?7QTaTshuJO7RMxYH6eHudq2GaYVk0wyWgxnE3M7E1v7nGd0bR5ia/Tgj8513?=
 =?us-ascii?Q?neHuDM62jMP9hXHkqgAwYe/TSdmaQnVeFg2e+2NkgyMkTzRemtIN1Mvo+YQv?=
 =?us-ascii?Q?ikwGEgjSQvpU2H0GoVQtGNgG?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70d707b9-24c7-4346-867a-08d96d9afdc7
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2021 22:51:10.1067
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ksqwgnxC2LLGMWJABNAqVvqVVtRfNd5nDFWpgoAefGms7aILFNg9CKRGqRM7eWEY5hBmrl7sDCK9yw/Hcv73bg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6015
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently DSA ignores any errors coming from dsa_port_setup(), and this
includes:

dsa_port_setup
-> dsa_slave_create
   -> dsa_slave_phy_setup
      -> phylink_of_phy_connect
         -> ...
            -> phy_attach_direct

This is done such that PHYs present on optional riser cards which are
missing do not cause the entire switch probing to fail.

Now that phy_attach_direct tries harder to probe the specific PHY driver
instead of genphy, it can actually return -EPROBE_DEFER. It makes sense
to treat this error separately, and not just give up. Trigger the normal
error path, unwind the setup done so far, and come back later.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/dsa2.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index e78901d33a10..282bdebac835 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -912,6 +912,8 @@ static int dsa_tree_setup_switches(struct dsa_switch_tree *dst)
 
 	list_for_each_entry(dp, &dst->ports, list) {
 		err = dsa_port_setup(dp);
+		if (err == -EPROBE_DEFER)
+			goto teardown;
 		if (err) {
 			dsa_port_devlink_teardown(dp);
 			dp->type = DSA_PORT_TYPE_UNUSED;
-- 
2.25.1

