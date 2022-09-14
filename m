Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD95F5B8BEB
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 17:34:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230319AbiINPeX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 11:34:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230237AbiINPdz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 11:33:55 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2088.outbound.protection.outlook.com [40.107.22.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B30FB4CA28;
        Wed, 14 Sep 2022 08:33:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NLQQNX4ukfTLPYzjUYgDgNRL8NpFdMVjXk9WCAcYnQkglL/AaqwtmtXlh5tFFdOn8vt8+63DBx7SLqo26TNN7K6B9Rn9gxod4CcF+OzU9HCB/ti1zfODZxJocOA9J/9W/9WyXc5ASQO8mqZJxX78uqxoAG3KqYpPWGZZR5Jyszk3nySusryuI1k4VXNEQhcuqKTCaQtpMEjdAZQKuuSbachbX/ucfKO5lh5QFrVAXSCSXoqgr9HVCC1VV9lFGWazuDg3R66pX4nLC6yspCdEsmnjvXMalD/5bZRrpG0ZMzz23GQACoo0D5BvbUnizWP5S1UwkWCdmT0DPMfFRpdhtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0El6NQDyc+djYREiGiUdjvu1T8eoTGCj+wgmlZaSVfc=;
 b=U9ctBXXB7zOyjw2TGy632a4ZekqzpxuFjeh8pxqdGbJhT3slwi98OBTbgf8HM2yffI0oQ8J+jVTCPlr3ycokbzt22MDhbXMny21EkXXOhY3l9UA69jkiaqyElI1TIigX1CMqvJ3PzCYNiLVGTiGL3MnskAVATA9j/xa4LHAmzl1yGS5zQlRyB1fYRlyvDLD6ARQSaB9R7pzhQXNh8vHuVbjTUOpdpLm2Af6wR26Ewnn2uG09eNa4XvJTzRFCpO2q0eC6EpJPGnx6QQDJ5N0QUYKhUlOKHvqmGO1XLqGyuvvNeZB5qLz3D8AePcsf+lo7/rMVW6mWnrQg17ZOUT9lZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0El6NQDyc+djYREiGiUdjvu1T8eoTGCj+wgmlZaSVfc=;
 b=KqFCcKwd/N1tOjecCXgz+jekwii6Fr9Xciy5BWq7CFEHzNWJ2v2ri5/y+xgl84tUS43cLeCTHnhWYhOCr287LUIGbUMSqk2lfOcuJZKVAoYbSNP3wx+XzTctZgpd1TZi9puN63hgYtrtGF1/OMzDJ2imPrNQT1FhptNLYmxI6Nw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DU2PR04MB8949.eurprd04.prod.outlook.com (2603:10a6:10:2e0::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Wed, 14 Sep
 2022 15:33:52 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5612.022; Wed, 14 Sep 2022
 15:33:52 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Rui Sousa <rui.sousa@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Michael Walle <michael@walle.cc>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Colin Foster <colin.foster@in-advantage.com>,
        Richie Pearn <richard.pearn@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 10/13] tsnep: deny tc-taprio changes to per-tc max SDU
Date:   Wed, 14 Sep 2022 18:33:00 +0300
Message-Id: <20220914153303.1792444-11-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220914153303.1792444-1-vladimir.oltean@nxp.com>
References: <20220914153303.1792444-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4P250CA0023.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e3::11) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|DU2PR04MB8949:EE_
X-MS-Office365-Filtering-Correlation-Id: 472e6d07-2df2-4dab-4a8e-08da966686e6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mSQjj0QATdPl9bw/4PdB04F31FQBwNXnQ9uWjgZe6rdgefUhepxoK3pT6DNy3SI/7I9ibxYjNtn1AkeU5y46+KmiHR2+OVlOPhAnsy7TR/se0ZmdkU3cKz7Z8S23krWtd70FsCGTkOv7EIT8MBuPpRZfw3i057VpueOchATMmbQLHQ4MLxBj+qeRND6m+YUesLpuRPxlQiMU0YXtyfLrcfOjHpI7sP/5deye4CJ+ePmQUTZ9tkOT19DodCiMcmy1AxZw4VL5D7JJNpyIOI+ywRcp8McLefwXetNTVuGIQAanH/Mbt3H+0wJEPG69BDClmEA9RZhU73RlyZHvqNegu48Kb9YqCHrq+gorBqKfDjGblJhy4v4fjVIyffV6P8zz/hjo7Ox1gy1zUBIY0CztmwCys28kSga2RBNunnoyPGakX6GITW2ivQI/7pXxL0d/1SjCdJ5UTkPRbQ5nJKG+zm4rgWKDp6hUarmqZ79NOn2xlZ7k7lLVNJPLj6H6KKaQxv4yYb3QhdOnmJTZsADaW+mv3kjirMHB5HyNOkRv15qYpxpUcmCJUlxoGDiv1QtS6V83wG4mtUynCy/kpIUgI38JubAJm3FTHKnzbbSpHM7GXQpLVSHmrc4crdLP3HGW41ATl26yyFwVWS7ZRmF+B96ah8lK0t8WFEfLvlnL+phYZ4tT56QtEsVDYC3sfd6h5roTeESObA87QxP2lx+iAx1/BdQHvpt5MkGQiFT+opryHthvzknaV/ywMkJIbG0dpN7uldS4ov1VRQUCDBjSdA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(136003)(396003)(366004)(39860400002)(451199015)(6512007)(2616005)(52116002)(66476007)(44832011)(4744005)(4326008)(41300700001)(66946007)(316002)(26005)(8936002)(2906002)(36756003)(6916009)(54906003)(6666004)(86362001)(38350700002)(1076003)(38100700002)(5660300002)(6486002)(186003)(66556008)(7416002)(478600001)(83380400001)(6506007)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ctfkwiN0GdRpL1pOqxzNe+16PfMbE9ZarSRjitBOQ+TS4LTG/JEzuONGx+o/?=
 =?us-ascii?Q?V+ga31gb+5DMhbPKsY3cicYapeJEpy3Tc6djMCAGFYS87KzPgKYdnrb4NUSE?=
 =?us-ascii?Q?+PRWxhU4EXcNgaeY72kF9njpicskvHV+04mMEu7Jw8as+C0tqDRfXGC74NUl?=
 =?us-ascii?Q?9SHhmmL10b6ubzV4Kq/Yfsh1Pm/5y7Dg0Ojl9H7YqyadVCLnpwOP1dMjJiP0?=
 =?us-ascii?Q?TUOyqzdXGiSmDBxpjhuQROwuwvmb32FOIJxOyt2yfmnU0ni/WSNDQSBRDxk5?=
 =?us-ascii?Q?3b9ppESI0GWBk0EtzKl8GI6mto0YrQLDeXflSb5GB8Lf2zFtsZpu2Mx8pXE2?=
 =?us-ascii?Q?p6SBX6THu8VEXA1JiJ+8mJVSXQ4AvSaXYl1bcyWEff7x3Bhn8AKkrzqbCJwG?=
 =?us-ascii?Q?F9lRbBdDDH8V/bFy4LsvbMYV67x6izcAIMhOUIH3StLteBB7j2JKVIRz7Unl?=
 =?us-ascii?Q?kWyee/6jVcYIE2XUTQEilKWtJQnhTec7Lqowq6+nUUCoFs+Mun9crf1mr6aH?=
 =?us-ascii?Q?poqOTbUlAmwm4LvbdNBWUP1Cmeofkicy0DtpFerpdhsYVAbV1Pw4kZZIjAO0?=
 =?us-ascii?Q?dXLve2bbjaZQavpC66wgKlwEGvmB7x94p5MhQZ79C7KlBQosULYJZcRalP9j?=
 =?us-ascii?Q?PomSzR9dn4lNJ8wh+fPgwfwwgjXMpHb1swtQdoW8mLMviwHpDEAY/kAexMZY?=
 =?us-ascii?Q?qmE4wGcvU/oLrxkeXo6g6XdwWYozH7XIIIr7meFId+TK56Y/PXW+n+UXBq8d?=
 =?us-ascii?Q?DHFNPho+v309VXc6XWz3AYD6+JXLP5mCr0HUSnilZzpzKqbdpbkLCp8uamEq?=
 =?us-ascii?Q?8yxCJqYoNtwR+KRI7FNzSFovkT05+SEafGnct1keu8F6bzQp+bjaLFJ62+XW?=
 =?us-ascii?Q?nd3/+oPNv0zKT0Gxz5iPd9loZxM+8dj9u38taevHuHgIkUitmUEl1i9wq/rM?=
 =?us-ascii?Q?5xUBgSUdPU4nORxx3HKwLo6Fe+je03gBKnaBVbToNUIaMuQv0OUvBq1VyFZm?=
 =?us-ascii?Q?UXRlHDniKEl/BGEH5Mmnj5AUKZykXyzhuXYSBQiZs+C+TyHKIa1KXOADI+08?=
 =?us-ascii?Q?IZC+///t+dTnIUtdz5wS4NUb/sy+0JZNXrxWuZdmv5Il/K+T+W0ccCRykRP+?=
 =?us-ascii?Q?W6hK3p5kJ6Hh5A2mht6gt7wxvsAJ653XCcwwgUegEHGcvcFlhH7ZeKPqNxUG?=
 =?us-ascii?Q?KkjLVMXNalGw+27bnHpEegozqpzN6ynQgSjys/KV4Orer2RY4yDkSmg1aSvc?=
 =?us-ascii?Q?S7qFawkCtazaJJs7rJNS6Sg5IIY+VJcLYHd0yiB9fY0lC3uL/7GrKEZKNMfj?=
 =?us-ascii?Q?1roQ+cInukvK1Q4jsgltuCfxrUPgAWnBujY9OFHNG7uRoeSTjmB8dVJmHMN7?=
 =?us-ascii?Q?5eL4Sv1ISuZI2s1zhLZUA94em4fvEB0CFhqDBJXkDlrXRKWIXHZj1twwTI4P?=
 =?us-ascii?Q?wTPgoRnWodiKq1RR15X+sturHYz2KJetGYY2Y+tOd4DaR1ojjs3A+f9Suohw?=
 =?us-ascii?Q?jK7FWoQqeMNhJnARHEx/uZbBHs9LjJ+g0J54zZO5EPWCGaZuiRKiQnNLVSRB?=
 =?us-ascii?Q?qUkhsVAEvxD7Kov9tN+6pWU9yK5p+LFHCxHMUIeDEW7RW54XbrvQ+Kw3JM5A?=
 =?us-ascii?Q?qA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 472e6d07-2df2-4dab-4a8e-08da966686e6
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2022 15:33:52.3072
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ha4svWPcbYrseq1S9xKeiUHuJgrxZh1CDf3IasFxv7HcsleyxjTD8qJOo7HjM1MrN2/88gOkXHX2fFM+D56gqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8949
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since the driver does not act upon the max_sdu argument, deny any other
values except the default all-zeroes, which means that all traffic
classes should use the same MTU as the port itself.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/engleder/tsnep_tc.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/engleder/tsnep_tc.c b/drivers/net/ethernet/engleder/tsnep_tc.c
index c4c6e1357317..82df837ffc54 100644
--- a/drivers/net/ethernet/engleder/tsnep_tc.c
+++ b/drivers/net/ethernet/engleder/tsnep_tc.c
@@ -320,11 +320,15 @@ static int tsnep_taprio(struct tsnep_adapter *adapter,
 {
 	struct tsnep_gcl *gcl;
 	struct tsnep_gcl *curr;
-	int retval;
+	int retval, tc;
 
 	if (!adapter->gate_control)
 		return -EOPNOTSUPP;
 
+	for (tc = 0; tc < TC_MAX_QUEUE; tc++)
+		if (qopt->max_sdu[tc])
+			return -EOPNOTSUPP;
+
 	if (!qopt->enable) {
 		/* disable gate control if active */
 		mutex_lock(&adapter->gate_control_lock);
-- 
2.34.1

