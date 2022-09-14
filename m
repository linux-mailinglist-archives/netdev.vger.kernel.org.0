Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 360235B8BEC
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 17:34:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230316AbiINPeV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 11:34:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230215AbiINPdw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 11:33:52 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2070.outbound.protection.outlook.com [40.107.22.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C67EE48CAB;
        Wed, 14 Sep 2022 08:33:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UQ42O+zs2JIfxf8/r18LtWtsH+tGFVlKBQ91bjYKu92Ouex2MI3Qtc2T3FOz0WYa+oq22PdhGTeztJ0zlAhP4dpljzKUV8R14PUF2+btZowhHSpSkytWKs0hvTYIrXJX86frm9tBDUx3i3rMVts3V49Wg5tDzFEM+ZLQgkgh4b5vhq7ZiqReL1KSREH+7T9J2VaVhglCFY6/J/lBMff5Kc8iZHqX6iGp9m85wjOHAoaQjW3v8DghnZ0VhZbR3n3sInwfSPgzzHiWD5WLCc0Mhm/OuuJs3i9S/3SdMgIHGpuL4S9jeV/BuP1WsML4AcAGufWbjS7n0MX9waG1N7KX1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Rqcc9JjhHFretRhuHEGlsXIGH1ZJ7ucmmVhSW7EV9SQ=;
 b=IL3iAGmZuhnf95YnPVe6N3TksA4P+py4TOGD2SMjKA/lWPfoD7CCiUV+srU7tklReDWY2nHOKnC80XJhNmZgzLIpBNt6sxA8NOtuOgl9lQOd49pfQrLpS7C17QFOrylH8EweiAURs078J6jRspT0QeRZWlEnfc6XpOBWaweTjOfMJUuk6JnXDf8qTdUPuXiRtES4Ibx8HmQdhbyxc886/dUroU9UorfMOlVamlRAL9L9N481eUotuUOmKDDRiqmqff3dcLBqdMR+T5ZOxf0CKAHmRwhfzwP0eATkd0of6Lu6gS/a73Nba+NNTWTRK7Q+DRX+ZU4BURRZ8K/upqDK1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rqcc9JjhHFretRhuHEGlsXIGH1ZJ7ucmmVhSW7EV9SQ=;
 b=cOzgWCRBwNL82G0RHLz67fjrtuAqHscOcpcnT+0DLfEjIeNta6Ea1HNzYexbtmO9UoTSQPP0wAkQYdf8cNlhW1+p4xUYtaLJGwAt6VLyq0cdfwpbcLpGeP8M4/H4TOb8QSyg/kiHZeZYV+4f8r/Fe0pgCL0tkS+J1XhMHINux+E=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DU2PR04MB8949.eurprd04.prod.outlook.com (2603:10a6:10:2e0::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Wed, 14 Sep
 2022 15:33:49 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5612.022; Wed, 14 Sep 2022
 15:33:49 +0000
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
Subject: [PATCH net-next 09/13] net: dsa: sja1105: deny tc-taprio changes to per-tc max SDU
Date:   Wed, 14 Sep 2022 18:32:59 +0300
Message-Id: <20220914153303.1792444-10-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 51748065-56af-4d60-2b0b-08da96668539
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MDR+djkG+QRtBD1aJuyPBzvFouEbk5l5xy0o+jl9zPz28EiL+FPtc4g4KUC4zKu1kuYYRDFP5XSaMx6z7yyyfJvgvs5k4BKBw0nZOaZfIlhVlIdVlUHh8dA2WZZvniYZp9Im6ng65X5yxYwDIWLZfOtKguDZsxNaTprE6ki3DzL+TO6YUn2fPMHdykl45tgkZAmkOHQvUQvX9fJkTsHzI+8Qmh3vdn+H/9tlxXpNZg1OSNN/5ZJJ3m6MwHv/dzl90G4fE1sAgWU92cnqVJ9uHjfCSLScZa5HAIzATrjRbJRRA/vfSq9U60QM3O9iuI6zXq9QOGkz04htwyK48rP+s02i8BCWddEfxKBKkMU95jlrLIjxmI9JkqL2g1Kq/Uh+AmcZeBbO7++cGibHzfa801SsYNAsONKs78GYZa2ykdztqUgXdjyrMnQjZSMzM4DrsNACvT3G09HwD8U4ZVRk/XmL0ObYD0/usfSs1a0se6FrO78kqX8TucjivlUNf1BKysDhSw9qaKbszmtu+5EAW2bvaZ6tqCxryipAniHsVyGgzp5bo27iNchyODcD2d26NGyD4QTN3MKbueL0m1JGmBoVRBlA0+HnkJE74hTh8r3N8k0i4JbchZCfft9TjZNsMDzZ8/D9d4i3LbwMar2e0vWS8Jfe2teU62zkpNbvg0yuv+atN71IKzWDW3FjfFVpprVm4yG79pWLK9avvmshqaVKrgo4PSHUxUcm5RQ6IEG6h+i0XynIp3X1sCBnCC3l8vLi/pMksd+Ir9j6COU2Wg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(136003)(396003)(366004)(39860400002)(451199015)(6512007)(2616005)(52116002)(66476007)(44832011)(4326008)(41300700001)(66946007)(316002)(26005)(8936002)(2906002)(36756003)(6916009)(54906003)(6666004)(86362001)(38350700002)(1076003)(38100700002)(5660300002)(6486002)(186003)(66556008)(7416002)(478600001)(83380400001)(6506007)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ifgXBnCtACpE6d/Tl8Va8924bVyhLmSUJRrEahbIQaAshlqQ1XtvU/g04n5F?=
 =?us-ascii?Q?43DN0oKKum8fauNjhyjmoFFAwHMskZndaaD6qT7rUy/xagBJsRVeIe78GTDA?=
 =?us-ascii?Q?fbRjb7AgGnnX7nPTKBYgCVmt2tWx2xwtntuM3pVmsjfsuuR3KYnQ8wqQHsc1?=
 =?us-ascii?Q?EknRS2MNSdB6uddbIq5jP7jgoAFq4CpH1oW1nUtwhXZpHgf2BQYV5Vd3LW35?=
 =?us-ascii?Q?cDOu4g3I2ZIou2VC2w9vnKduuuHSCKMS2t+jVaGMKC/fkrARATNI/tx9fGEk?=
 =?us-ascii?Q?8AoaRUGUiCiERlMIBE4hg7xH7S9vOjjPgVZd4iQPaGgLtNMDZ24HxxA6P0Ms?=
 =?us-ascii?Q?HMxOeD3x5fAJ3Yfsm1UKLz4y9yKYkX9z7fUEZuC2QpvHiLMyhm18zfj+EK5h?=
 =?us-ascii?Q?x7dgnPCsPTQftuQ9ZU3oueygTWx1vOIlSOYDx7bPc0AeiT7VDgezCuY2Ibzq?=
 =?us-ascii?Q?aQhr79FKiea5NaiRW1zJ8aQCkNcQuilxOGY5HhfhUHovb0YSCiTJ4OBLikO8?=
 =?us-ascii?Q?YPu3pKGKszG7M+8REVfnzIW4aB3Kr6fnHrhh4sJy+lkmmUetBcrqNg7+RAAg?=
 =?us-ascii?Q?I199rp5ZjA0Bbn2bGU95KpUCqkJI3iJMQI/n9DuVjmsUz3E0Rnhrdxa1jLfv?=
 =?us-ascii?Q?bEopdJO3k+tbAXwL63/JQWjR8Nn3V8caXl/QKRKIkw8gboPhbni3xvVyCDt3?=
 =?us-ascii?Q?zTwxbmidhBwdDO8Vrvlwm3ulFawjr7mb8O6NSAcBthK1xF7mEE9vBQoe2lPQ?=
 =?us-ascii?Q?UO/cxWCmfD2DZiB5a4y5wRQ/gtMUSgelAmG5t8XqjOuIa9M6Ni09fnE5obPT?=
 =?us-ascii?Q?AsxyLKZvCQKr5FE5Gzupy0v5i+aejtGzl6KHjpb+6MYrjohbCmePMr6PFKr2?=
 =?us-ascii?Q?hw8Aw/2DTFB2+g9SUDnUCuP1FPS79BuLyONsh+Nk6AS0S+G2+q/9dIovkwxH?=
 =?us-ascii?Q?Klla2huyz8s9SJGQ40NwdL+/JDk6+9DaiqM7su3p/syK4RPXkeB7bsKQ8MTE?=
 =?us-ascii?Q?RD/zJLUEwsPMdfMZr2zMohMX2INp0azRopxYTOyuVcDSMT8jheER7QhVpt1H?=
 =?us-ascii?Q?Dgy0uXpKyr/UhHjymijNIwOwC2q19s0dDv5v74Rn9U6Z5+/q2aq6NBXo+gF1?=
 =?us-ascii?Q?FA1+AjfgDlnEJLe0OqgDSWnyEGRggjCrLFbn70pUv1MSHDtS1V6tnGQys8hC?=
 =?us-ascii?Q?xz4XVAXzMDyRNIqThl245y76a/zvUv4hTU0hNSCGcf4QPF/o93il5uBrT70f?=
 =?us-ascii?Q?merAY3Kt31A95pdS0gHzVb8+HQPOQsODI/Hnf7LnXqEc6zYBzAMFHSoEED7o?=
 =?us-ascii?Q?YuqtSaPM0QkT4DqwC0JICXhW9UbkjO00+xiD9UmujCn4+k7hViT590imlC1n?=
 =?us-ascii?Q?koP4jpMLgUZDAsPHsHJspBHHtSzHr7lmRNe314iof06q/H9dKiqMptC+r+Vt?=
 =?us-ascii?Q?MU7zK6zjRP2WShnZfPiIgoljMozD2j+eCjeyGmSDDL8ZDCPczg7DwP4ZfhP5?=
 =?us-ascii?Q?T+iwUCn6T6/v8FrPgCu1Mq4YL9S0eQHa+xcutL29Zh50rjYoEor47Axznvu5?=
 =?us-ascii?Q?Z6n8PFP2JaucACgD/ZZWJSiFX2zjK/a+HM3vG18yrMafI3W6bkVKZyfMZ0qt?=
 =?us-ascii?Q?ow=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51748065-56af-4d60-2b0b-08da96668539
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2022 15:33:49.4324
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sDD/XMa0JlYtHB4WrwyIi6IJZcYb2snW7xsHkMoKMae36uQrLnvhpPM3cd8I/qBlLZuVgEhIEn1LlA2I19rnhQ==
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

Since the driver does not act upon the max_sdu argument (which it
should, in full offload mode), deny any other values except the default
all-zeroes, which means that all traffic classes should use the same MTU
as the port itself.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_tas.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_tas.c b/drivers/net/dsa/sja1105/sja1105_tas.c
index e6153848a950..607f4714fb01 100644
--- a/drivers/net/dsa/sja1105/sja1105_tas.c
+++ b/drivers/net/dsa/sja1105/sja1105_tas.c
@@ -511,7 +511,7 @@ int sja1105_setup_tc_taprio(struct dsa_switch *ds, int port,
 {
 	struct sja1105_private *priv = ds->priv;
 	struct sja1105_tas_data *tas_data = &priv->tas_data;
-	int other_port, rc, i;
+	int other_port, rc, i, tc;
 
 	/* Can't change an already configured port (must delete qdisc first).
 	 * Can't delete the qdisc from an unconfigured port.
@@ -519,6 +519,10 @@ int sja1105_setup_tc_taprio(struct dsa_switch *ds, int port,
 	if (!!tas_data->offload[port] == admin->enable)
 		return -EINVAL;
 
+	for (tc = 0; tc < TC_MAX_QUEUE; tc++)
+		if (admin->max_sdu[tc])
+			return -EOPNOTSUPP;
+
 	if (!admin->enable) {
 		taprio_offload_free(tas_data->offload[port]);
 		tas_data->offload[port] = NULL;
-- 
2.34.1

