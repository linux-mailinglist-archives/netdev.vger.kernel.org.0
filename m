Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 536292D8DCF
	for <lists+netdev@lfdr.de>; Sun, 13 Dec 2020 15:12:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405302AbgLMOLN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Dec 2020 09:11:13 -0500
Received: from mail-am6eur05on2086.outbound.protection.outlook.com ([40.107.22.86]:11936
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2395383AbgLMOJs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 13 Dec 2020 09:09:48 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k/U5lzPG1KyXTaeRKACIppTrzFvSusrFTK8qILET02v0W0H0689I48R/RvqlN6gkoaSzCTdkc9t4hVm6uf5PaIMVF9F1i2EJXasTI+PtfBHOEeJU6EYOjvZ2h7upm2KzOQrAypuSwo5anfZ5PKOhvNvkYgbjBCrd2p7cYTtTXRnn+UsD8X4la/53tjt0IShmwLnSvMv4BgalLJSeCwXoKnfKnyMI27DlytMf7WP3irS5ot1zL1wMVSfMDf8nhfObNT7s88vjQJeu/foHAM1ogPf8qEdJMgJVKa+qGjMeZGoH6JGoRXgVga1UAPqGw+E8+1e/JJ647xRMbs1AeetyWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s2bs6wjP01PW5Fad76RKvfY026BE7RB8NdqhFE9PvJo=;
 b=O3b3m1BQmTfp8fHqgtQzwBxoyxgiun+gP5EzCOkuuyUz96OoquUNlPtbm8pXJ55Y9uSlHB6pLu+oiT5vmt4vjYAtCBSu0b4/WW92Dmxj3+pJnLBfBw13dG3EAuva2EYQR+ZAeZKVTF5dFXumsP66iq4IhGxN/jp+YMcKgrjp+hdnKs8vYj8u25Zfbz0rnsddloqnXHfDf91mC+uyHRiFSmqvYhbOqv0/DkBmMFXUeIEnEI0YBWCUIxGCnbkPoAUM3nk8n/6UKCRlldZwufZ0hBit0gOa4gvXA9hYfruL1sGCWlRx7j2scTJanJjtKM57NT6qsnGxpd0WOAFG28yLAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s2bs6wjP01PW5Fad76RKvfY026BE7RB8NdqhFE9PvJo=;
 b=JSJI5e1ft4noqga99M3i+wQXi4obZApCNUKG792R+RWIQ2IGQk+i1al/Km2BhSAtOFbIFRWg4Y1nVhTIc4BONjj2Kfwo4wbZg5soQBEKeGADWc5VyHdDFOPM/A3unmEXJD6J1vzpnKgQUkDz4nr3TnJsmLPuhjaSYxzWquW+8cE=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VE1PR04MB7341.eurprd04.prod.outlook.com (2603:10a6:800:1a6::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.18; Sun, 13 Dec
 2020 14:07:40 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3654.020; Sun, 13 Dec 2020
 14:07:40 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     DENG Qingfang <dqfext@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Marek Behun <marek.behun@nic.cz>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH v3 net-next 5/7] net: dsa: exit early in dsa_slave_switchdev_event if we can't program the FDB
Date:   Sun, 13 Dec 2020 16:07:08 +0200
Message-Id: <20201213140710.1198050-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201213140710.1198050-1-vladimir.oltean@nxp.com>
References: <20201213140710.1198050-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.25.2.120]
X-ClientProxiedBy: VI1PR08CA0235.eurprd08.prod.outlook.com
 (2603:10a6:802:15::44) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.2.120) by VI1PR08CA0235.eurprd08.prod.outlook.com (2603:10a6:802:15::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Sun, 13 Dec 2020 14:07:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 3f7d4ec3-7128-498c-a5fe-08d89f7073fb
X-MS-TrafficTypeDiagnostic: VE1PR04MB7341:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB7341D4587F1B8152F166EA92E0C80@VE1PR04MB7341.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WNc12Jsfx6PewFes+2XWv+Qx2hbpDvZ4vr3fXmEVHYd5gMjeem12T3oRmvBytvmhUfKOJU38GKIqcpKoLnCIabNRGH04/eZQDpRMeZfSy1IFuieWacQHqtJWS2wDs+SQRUJ9902gVsPoKr7oBKOI7m2nnfMOTvWLXQKm7N9FNaPMa6kXGLOtN5DiWTJedz8v2dOL+coX1ZOfWHMYgUyiAeYYHC4CcZH3ZcoVuACNliZt2g13NsXwOAjaErdSGLs3qrsnteY9B+7/nHDgDjv2SfILe16+mAeSVfXhtrONJljuqrVRzwZCLyt2tnzymgVuDLI6nuUKlWkZz8vpz0UMmvluzc0U5E/U0jjy3+v/ATSEC+drw5pooI2gtUYUIXDY7zKMlBeftGM0/Qh31N8lPA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(396003)(136003)(376002)(39850400004)(478600001)(52116002)(7416002)(5660300002)(1076003)(6666004)(316002)(16526019)(186003)(86362001)(83380400001)(8676002)(26005)(6506007)(44832011)(2616005)(956004)(69590400008)(2906002)(4326008)(8936002)(921005)(66556008)(66946007)(66476007)(54906003)(6486002)(110136005)(36756003)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?8coaiFf8TonLyBW2r4355HcG2ulUQh9uNv6onI6fj65PTTCZRZVTgvCqcAJX?=
 =?us-ascii?Q?uPUQYS/xKmNYxmqLq4N+G8sYynNooXeiKRP0XMMrlK8Xc2oEtu4KIMQv125u?=
 =?us-ascii?Q?9heeUU/t0sM3hnIQHtscVerbsWqPYAU/21hAIz+QUWE0AiLPo7iibAm/ETTL?=
 =?us-ascii?Q?BQlIj9FdN6MXOws56shYCUHm/LWClLaD9UTzhcYmF6PJ7XOyRXBPXmJ+R7OW?=
 =?us-ascii?Q?07lxhzvLAiTj1T9eYQMPcmP9bzpYcZa5iiQa0WPG+rZcKzqVGjHwfEZlQjV3?=
 =?us-ascii?Q?CAzIAw2qdq9TWyYi9AhbbdHnV488Sdg2U0cs1yHCfdN7zcENcnBfFK5sfwAz?=
 =?us-ascii?Q?+Rdw7H6SujXgVCv+EDu8gZykrhXNBWHWk+QGAre5tdRD6MC1OnMzeKj5UWOQ?=
 =?us-ascii?Q?d4AtAHqEXM01ZaJOuRXf/G1zKpl/uL4SjL1pN0RAcRkkH6plYipv+qDec1Vh?=
 =?us-ascii?Q?WDYAKtpR3CmekIboa3IkbXo6CoX3x8N6qXE7cBwiNYs20Sf3YKd+snBR5qfr?=
 =?us-ascii?Q?TVPg5e2Fshfe4HmqhazT/jcg5PiCgiY1QZrixnWM2V71LoL0da1AlK89a8Im?=
 =?us-ascii?Q?Bbiu72Fs/ho2C3IVkzfmzX20U6TiJuH/7qZnNxDGTSeop6h1MWUvGqnO2M+Z?=
 =?us-ascii?Q?T4CsfUtuU9YhS+PbMrEDXaGdx/THt+O20FtWFeAfTlz22dhKUnIt0S0OhSQr?=
 =?us-ascii?Q?WaKG1+N3UlqoYiPKMcV4Y9cOGsv5yGBsC4TxVzmCUooEsHCWh1YxZLbUl0fu?=
 =?us-ascii?Q?SxmN1dlw9fc1FLyTH/O+Q/A47Gft/kQ/aBCUUKCFRG1mh4Rafe2gz1k2nUiW?=
 =?us-ascii?Q?IESGYBhjtPQZ1KaIzn8yWcVN4AU+poKP9CLdsRrge3AA4UhSNgSoOpwZxyRo?=
 =?us-ascii?Q?/DtHXUTcKyQDIIfECa37tupnv0P80T8vNz43pZNfDNZ0dRfoHwsm1S53TDH8?=
 =?us-ascii?Q?yqcqFZmkEsISm0L/PSmtNm9YkkvYhH+czfWZkZuzoAV0SuAsbo8E0+qYGf1n?=
 =?us-ascii?Q?kCQU?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2020 14:07:40.3440
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f7d4ec3-7128-498c-a5fe-08d89f7073fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QXHTc5z1kA50dSujjzPfxrRtfKoeX1KEyZI+P35NaQ2CRp8CLq8wk5Eo5tEQNmQph2XUWzFg/jRDFc+m9I72/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7341
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Right now, the following would happen for a switch driver that does not
implement .port_fdb_add or .port_fdb_del.

dsa_slave_switchdev_event returns NOTIFY_OK and schedules:
-> dsa_slave_switchdev_event_work
   -> dsa_port_fdb_add
      -> dsa_port_notify(DSA_NOTIFIER_FDB_ADD)
         -> dsa_switch_fdb_add
            -> if (!ds->ops->port_fdb_add) return -EOPNOTSUPP;
   -> an error is printed with dev_dbg, and
      dsa_fdb_offload_notify(switchdev_work) is not called.

We can avoid scheduling the worker for nothing and say NOTIFY_DONE.
Because we don't call dsa_fdb_offload_notify, the static FDB entry will
remain just in the software bridge.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v3:
s/NOTIFY_OK/NOTIFY_DONE/ in commit description.

Changes in v2:
Patch is new.

 net/dsa/slave.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 42ec18a4c7ba..37dffe5bc46f 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2132,6 +2132,9 @@ static int dsa_slave_switchdev_event(struct notifier_block *unused,
 
 		dp = dsa_slave_to_port(dev);
 
+		if (!dp->ds->ops->port_fdb_add || !dp->ds->ops->port_fdb_del)
+			return NOTIFY_DONE;
+
 		switchdev_work = kzalloc(sizeof(*switchdev_work), GFP_ATOMIC);
 		if (!switchdev_work)
 			return NOTIFY_BAD;
-- 
2.25.1

