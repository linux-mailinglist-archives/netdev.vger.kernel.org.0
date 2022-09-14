Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56A475B8BFC
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 17:35:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbiINPee (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 11:34:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230246AbiINPeB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 11:34:01 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2084.outbound.protection.outlook.com [40.107.20.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F28E5A880;
        Wed, 14 Sep 2022 08:34:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KFgVmkSznY5qI6YYFdAa3uv70hL6bK8/y2wxOQYBs8BPZEiva6DtLdlv+dAPyyQ7hc5emzga8H5plXHaIopRjPisDCIvSVSi/yo65fNQwfJvgaEc38/PTahI6G6h/J9dtGispWzQkLPlu9HSgUccqIloJ491XROSOHTPW8vzXhjPWSc0A5eedlS08xFye1oNJsMbArpcjRXkRk7dCLMbitNLrqJBFgTQfsYWeGlo/1WEWaDaR3oybAo3C/I3U07ZupcZz8Wf8IJM1t3OPX6x4Tt5SSwxDq8bC2Vh1S8/y/9v9MlbqHdsbpUk5LYCYiSumSKPtcE0zoal7l9K1ir7ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iUNlSxjO/C9Ja7fCE+202VezZwbWskiFJIdooMHS4qU=;
 b=fdX4dlaOJYYAZ1i/+BBO+DT6Not5y0T3Q1Ogb/OHXuuPa7IhQo489g/Ao168MBPHZxhZEF92DUCkyzZkHIu+blt5/GOIX3Gyw5JKewkew0XnCIikLS01qhf9A7Zh1cj9SUihTi3Zyi0+kL+gHEBUcWRgVQjksYh5uMnyI8+306OczAmkf/IMDkZZt13PZE+PmTdXjdT+ttmHRuQWB36qC3DJFzTrTXMx75pun6ecQHiSs5kyP9xXOtGuwYaN3tUX53gV3cP+tYDcVtr0Er4BpCpAoZyOXJOYbKbKANk/QPYEyySqocuYj5T/FoHcczafTxH3ExV+u3TRRSR9V7nPyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iUNlSxjO/C9Ja7fCE+202VezZwbWskiFJIdooMHS4qU=;
 b=no/VtTuN3/9wUsMPZfeNvtECtC+2eveCE7FmIXnXXP43g2PpYSLfJMqnvu/XkcQj36F1jkjV3QJlrKisXbmoBTAJhBaFPCPKQ7LVIeoYReJ+HHjwOWmKdlDIAspXvGJxMraHQ95tRd3YWg62LGZuTMlu9I8NFWftKCyS/u2xPzw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM8PR04MB7908.eurprd04.prod.outlook.com (2603:10a6:20b:24c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Wed, 14 Sep
 2022 15:33:58 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5612.022; Wed, 14 Sep 2022
 15:33:58 +0000
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
Subject: [PATCH net-next 12/13] net: stmmac: deny tc-taprio changes to per-tc max SDU
Date:   Wed, 14 Sep 2022 18:33:02 +0300
Message-Id: <20220914153303.1792444-13-vladimir.oltean@nxp.com>
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
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM8PR04MB7908:EE_
X-MS-Office365-Filtering-Correlation-Id: 5bef213d-3788-416b-d572-08da96668a6d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WiCKRlsCOT09a40C4hTgrhnMeHa5kT3wnQzs+A52YsmVGDDn6LZqyKbTktGOWcgH8f7UN/xcsjZ4Sjbdw+iZWjLHOxYmIb/ZvJohWGIhj2VDqSrCiPtPz0gOG3e1znLqvAj75/XFeqSk4xLQ/E+ZSzfTjwnyQ7qxnGs/XFPOLeStqY2O4mZYQSdYTat+4grZOECQHWfT9qtB6i4fxE5NfsPAgKbcRMFMJaa+WnWbb59Ay2jbgkabXetUat33cC03qbR+u2PmF62n2zNhe6/Vl74yuU36W9g55QzHAA9jvNW6oBw6pbQzpUumk8XHcFzwfI6aH3yDOonMUN2XKXb6bYnHltdLSWdiUtcnz3jV8ECUwyssoMVMpq0zy6D3kyjZaRzzHF0rtaBfeVx1f2s14Ml93h22DmmEBzoM6DMlSRtLYfZiH8fhJ/GQrgBxUzeaRzoluytXzarLBS5TzBJYaaNoQEOae69/NUp4+xLpgOA9eBvZnyZweod2HGsdEr4h9X2PCf8Q+q91gmkqVLlTvKqpG7kVp0Cp/O5ugd8Wu6IaSSGMmrG3z0zah3sW6j9eL2v2Nyj/MMSMFDMu8aaRFZ4tQu8Rcb4CjvQeaoSDwNw3iMsJB2/YQXbsSR+1KKrF2EwfvULQHNd+vSC3gCl2N95AXfHUxmAWuwnxizGYmG3hfaEZ3INIWYJ7CXu6wCaOMIv5QrXzY+93AKB3+Coz/NvcmXgWT7eog78aWVYWCo9FFnO5dqg3j59FTDBs/+xpZRlxXIWO+PrQTt/R3eE/xlGDZ+goP95pUeKxNqy0E1jEcOzHQ2NG4sN65d2qdv1m
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(39860400002)(366004)(136003)(346002)(451199015)(6486002)(83380400001)(186003)(2616005)(1076003)(8676002)(66476007)(6916009)(54906003)(44832011)(6666004)(4326008)(5660300002)(66556008)(86362001)(52116002)(66946007)(6506007)(7416002)(6512007)(38100700002)(316002)(8936002)(38350700002)(478600001)(2906002)(36756003)(41300700001)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uk9ImEY15PtVAz4Qu6STwoTzl24YX9OIYnFtTu00kHP1Cl0Y0EqEri/A2XkL?=
 =?us-ascii?Q?P2mrCfRBkO1Ur6Mau+ZFYlGXjil2ZxwRwyD+u5VzpU7koRYMOatNG0a5eFxe?=
 =?us-ascii?Q?kJ4bIUqkRyxFQBS2Xoj+zidspxYZ2v84+N5CMQqqbh27mKx7cMczxgRSkoE7?=
 =?us-ascii?Q?eEvX6rDcvjc7wL+qFaoYm0n69zVKxUcQpz2GJPhRwuilJDUKbVbGZxwo05WD?=
 =?us-ascii?Q?UtjdcCwAlrGqG+OpRZpVRZLVBu+ig/tSfs8dY5LYn8hi+do3HAywQiCMH+28?=
 =?us-ascii?Q?VQUrwEa3A/LXHDUDP0SVWyEsXU8f6Cqogy4khqBnEkW1Q4mG/pmIAZQ5Y9mn?=
 =?us-ascii?Q?r6qrdvhu3BlV9cEvG5mpmb/ofJoTrwE2St3rr4wipl3UoMgkUY5h/8sv+1qq?=
 =?us-ascii?Q?BPT8t8rFg0XM/E3TRNtCVDNarqH8ni0A+segmtdxw0a9x3ocXLDsreZDfOGI?=
 =?us-ascii?Q?6l3mHzKnfy7zNF2Xdu1d+t6URZC7hFfhoBNnTCxFh3yxbrmKaewPMTfuxKT+?=
 =?us-ascii?Q?3KtkVVp2BXCAEjqVxWiLxpo7pebtDiA/YXWJ9WGtbeXBXcGbyWKzlvtMsTBI?=
 =?us-ascii?Q?ZQqGFTOycIAYeKV3awEz4CZ6A2eUaGcklvMP3H+qe7MXzCn37Zpz2DsTLZpF?=
 =?us-ascii?Q?0eQlinYsmL1z0YI3pML425DxWwapHsCgUxs/VWUoSPCdogsusjajQvisjBdh?=
 =?us-ascii?Q?WB4hCWY8HCrZv3cqR50HbF4vcKTpPB1l+2ZY+lFqECNBhPVvv/o0t0CTlHah?=
 =?us-ascii?Q?3ZTzHIaM9NuUadPc+8CMgGFqqPKb8bAPWqOh0V5nBY432eJy2LGRCHZvwCdi?=
 =?us-ascii?Q?Jo53W9ivTc0DbcPmGS0zAVcNYNl+7l4WWQVCqE9B1j24S22g6S4Ykz2zKBKi?=
 =?us-ascii?Q?HD1A9y3X1hVdLoBkumjRQqgdfoeNeSTPZq88uAsxRkFeYcYjwjhNatgXdxcT?=
 =?us-ascii?Q?vZqJczPfbX2xmjvp2dUmvczFAghrdsrmEU4447QHucFnECbavvFbOlC4HR6q?=
 =?us-ascii?Q?QZaCD+pU1+GjS2vCYN2JKw84NAET5rn9yGmoPtmregLmr+ZZxQ0G01wgqyAg?=
 =?us-ascii?Q?lIpKf+LlyQcPmsxDfpLu8eZzQrOnvdrq7e8o1wNv0SoTsxGxJ+v7V0YuHOi1?=
 =?us-ascii?Q?JiV4WFBvf3QJ2HGnbMn3Yb7ywdGIGCFw/MLvE1VDF7Q4Xx6JpE/kNac1f11B?=
 =?us-ascii?Q?2v8fUFjDOXLmDb/YJg71qTuGN0GsFl1BLtOpuZwHZcm4SEyjvXUi+AldpM9Q?=
 =?us-ascii?Q?vGs4dMEAxJp2tS2jf/SVlZk3+/TnZ3NN0PDemp1RSkM3ZajW3kpCMBofrBUa?=
 =?us-ascii?Q?mQZ0jLH3DCbSRYzJiQK7oSwEykxYCDcVS99842IyJXyLzqJTjjAsh/GqanAp?=
 =?us-ascii?Q?NqbWwhhjdyJd2naO1/ELdl1t1PSDak2kvYS/0ezky4HzxXxTPgRJ9YSuoKfa?=
 =?us-ascii?Q?mcjNcZXqATte32dL6IaOH4c1z3P123iYWioAr/wXK0A4YIzXlMrg6KkIBgEY?=
 =?us-ascii?Q?MleblXsCou5MCjKKhhlgpWXiwscDDsi8EalNGUsRBz1udGypS2+gvMR7Ro3f?=
 =?us-ascii?Q?uqGmjcnyEvk1pC40yAtuZu8QJJlzE4PDProtakqOcgbJCIF+n2IpkpiCyKlE?=
 =?us-ascii?Q?uw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5bef213d-3788-416b-d572-08da96668a6d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2022 15:33:58.1505
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ou1p6AlWHkHQoMbN0Da4fgun5AOUtEI1MljTMrYcrlUe9HPSOaf5jn7nfNjwB/6deJ/3m0brmIwyAKxJazmjiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7908
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
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
index 773e415cc2de..8e9c7d54fb4c 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
@@ -922,13 +922,17 @@ static int tc_setup_taprio(struct stmmac_priv *priv,
 	struct plat_stmmacenet_data *plat = priv->plat;
 	struct timespec64 time, current_time, qopt_time;
 	ktime_t current_time_ns;
+	int i, tc, ret = 0;
 	bool fpe = false;
-	int i, ret = 0;
 	u64 ctr;
 
 	if (!priv->dma_cap.estsel)
 		return -EOPNOTSUPP;
 
+	for (tc = 0; tc < TC_MAX_QUEUE; tc++)
+		if (qopt->max_sdu[tc])
+			return -EOPNOTSUPP;
+
 	switch (wid) {
 	case 0x1:
 		wid = 16;
-- 
2.34.1

