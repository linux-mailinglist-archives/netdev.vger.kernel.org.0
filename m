Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E2D35B8BE9
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 17:34:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbiINPeL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 11:34:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230023AbiINPdk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 11:33:40 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2089.outbound.protection.outlook.com [40.107.22.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0961948CAB;
        Wed, 14 Sep 2022 08:33:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D3bU8H8uXa4/5s4sd3DMe0pNzCJxHoZgVBEz6WiHu0+wHrjRVSjvTLz1qOQCytbVevKQvuJPQOoDPzLUmcqEhuRMGTkaX2hIMhbz620qFsRyr+or+9Ci1VToZXSv4sYWnxbTVtpz6LtzTzwNp5U/IYcx7pMovcfH7tblL6RH/cCTWj2NpbJBiaXCtCkCtthYAJRze3Oxr8QX8jiRB63dmTjmu8aYPF8jy+95NxuSu1YHxEso2T36NHLVRk0dxTE2Ovcwo7bUMKe/6SgW1uuMNP49a+yKDHD5ou7oxSo0gARMLbFCquWL+PGadyY3/8trJEMS8KRc4UDszkgDaPbbXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gkK9DYZgwlUxmhoatoYAIzomh1elz1DJ6vTt8KpZkqI=;
 b=RBRYk82DNtktI3lg6n1meV2HNb+72JJra+czB6/iHCLZ//+Ip5YYGGa1ujITjIlh9XY7MERZchgmxjMJ6NTkYg/Bp5apT3W63GAqGhSarUqhV61YWLnaVx0r5mqwOmznObER+E+uvXZmfQYtHDnQNWSasiXj/VmEF7rAdBdao1vMd2FvM9Fpj7/0rbZZ9C4dt6lvpdwd+jHFXvKVGWjCr6XsEQqxhTP5a+dFnXWZTbaMKR2wLHkKojTyrM+kclR/vQRSOn5uQ7qlnqy2E5dfRK8X9ILqqLWNzUMRo5auq2DH8KA5naTYa/OExBbmb5VwDIK4WA0vN0BvBMp+MGR29w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gkK9DYZgwlUxmhoatoYAIzomh1elz1DJ6vTt8KpZkqI=;
 b=oFbLMnvF5agasc/tTttcolsHTQNYvHngpYW7/NXg908fqwq22R3sqZaXYfx+aDjw9WLzIV0dtl1QVLOsp58PaL2BdoQiYsn88DiTtIvAUcfMW6SC8b7KU9hCXmfvuTTblzDJf7q8pjzNEHJ5Oz1eVbWPfOUdxRtvB04VPvwhnU0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DU2PR04MB8949.eurprd04.prod.outlook.com (2603:10a6:10:2e0::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Wed, 14 Sep
 2022 15:33:37 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5612.022; Wed, 14 Sep 2022
 15:33:37 +0000
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
Subject: [PATCH net-next 05/13] net: dsa: felix: offload per-tc max SDU from tc-taprio
Date:   Wed, 14 Sep 2022 18:32:55 +0300
Message-Id: <20220914153303.1792444-6-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 3261fd48-d474-4d74-04c7-08da96667df8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: f+xP0yr4JvuLCRxdm0IjUCuInYQSdxVcSgYGpyZaU4WdtJFNUHR+b4Yfrc7TSGs1dYHw+679JlvkFCnYYBLLptI/PcK4k6W+faa85ldzKYtOUnTneYoao/xPwo6aS5TIlK7nupBONF1GXgF0McxPE6mSxzILUg5lAnVSUfn1/9aRz3PWFGnKDzWwgTF8Ylzl0nF6RVKPpOuPaqA/vl+lYJxdwe77YVU5sP7zuPJP/njPF3EUcYenPdOnuVziimXDyKYittIePDetr3qk19oJ41i6F+w0maUBdl+D8Qh2Rx+DEaFq8UaEeeSuXRqbKbAGNljPTYZn3m2gzPGEhST/MqI5RQ7wPe2Cmj46O7EUdpnYCYGNlAVkzq2aGHwSrDm78C7H8Vqz0orTHruQE3zscS1HAXxv7CzigGnopbQvYgClKWxQ4pNrGpD+qLVt1g0NekUGhYAHbn51gq4nDEtgQAD+jjQwxRehmMGWhieAcTt7dJ2++AxfjucP5nt0BbJULu2RI2HllsKgzFL2ahCL5aHzStGOL8ntwsHZGyuvP7PugG8UC1+OYk5P+e0hhN97OIUEu1A4Pz6rmDI1XMDJEh+SjJhntN+YBs0EdHywF1oEotU999QNwa0jC2KThOOr4NeBrJVbbif/BmxJWt3yRVDm5wi3aMuvA+cKS75q+9SwR+zejhXMn0bj/qzzpmPb95a5lBbyT7wXZCIln2w2/u+tjTi5uJzDVBeqouWsC5GfY78dUnqSBnGA/G2OEKyBXJZgk8Jt1ICY5Mxv1WISIg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(136003)(396003)(366004)(39860400002)(451199015)(6512007)(2616005)(52116002)(66476007)(44832011)(4326008)(41300700001)(66946007)(316002)(26005)(8936002)(2906002)(36756003)(6916009)(54906003)(6666004)(86362001)(38350700002)(1076003)(38100700002)(5660300002)(6486002)(186003)(66556008)(7416002)(478600001)(83380400001)(6506007)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?282J7k1Sfol99XXwd4/QoKlNHLJtF8SopLFC0YChv1W4UMs+z7x+INC8+HjM?=
 =?us-ascii?Q?glri2Ms5+DUhh64NjqiC2Z9fsccLnw52TU13x/0xUdc70fOi3uiYzuzpzOKw?=
 =?us-ascii?Q?B41reD8hUPvZ1+W3z23uLYKTpBoDsaoreW2Glf1agqnTNGuSucGRUqUVSsfv?=
 =?us-ascii?Q?97awAz8k8zHj56QzQN+wbUWIEmjOvde04G39ScCZaGZrP8jApnSL6l7y2jb3?=
 =?us-ascii?Q?ZTYm3KMkrncWGs0Blx2tfIinBNaKkwGXo1Uc8ecjE8slsQ/PXiQ8F9Zvd0vm?=
 =?us-ascii?Q?PPtunLe+W9QmtxbVZj3ZyPKXberWwU4LOuXDhMIml4vz6Vl2BRoPPNgpOOcU?=
 =?us-ascii?Q?4ElnpgMsxlDZs+xZL8hzWi5jIXOtihPv3Ow8iZRp4hI4hZl0/cJTcwROnAyc?=
 =?us-ascii?Q?xKUapTkvw85hv6S8RT4Vxw2IVoPb2IODWOaC5OQwr7vd7cSxeGK4ksKQSB0b?=
 =?us-ascii?Q?flYciXdp8Bm/KFUT53V/ZAO2qCWQtVggibx2dtTh94Zas0CPgaPJ6jTvVERt?=
 =?us-ascii?Q?L/PwxOtRYFEQLeaT1gGymYthFlOkiY+klZGsaXjENVFMCA2daRrBq10auygR?=
 =?us-ascii?Q?ef40km1iWSrDCO70IcCe/0++KhUl82ntXZ/ssvRM1QN3I9gXEqp3yeBp33Yw?=
 =?us-ascii?Q?+fxfzTfxZfbdsJUuEwLiX4fvl2EGqOGTKRGdUcoCTHEdrjiy2YqlU2HuIw6F?=
 =?us-ascii?Q?kSOW6a6DjovIHoGwEkA0/Vpj+XPGoRqMmdoMF7Hd+wZsWIjzgzYkJurqDNUJ?=
 =?us-ascii?Q?KkcHlM6Km3G2CjwPaqtzjitv/ZGc5Atq1sSJDSe3MtDG6me8GUTY3slkN7ce?=
 =?us-ascii?Q?qY4T5CwemdGZ6RaedfHPohH46FDyMpTdv2lVQHd60e+f73Fweqw2foMvOj7w?=
 =?us-ascii?Q?lIfH2rs+Y1C0bPAn6YmAehJnwmBr6e7a/HJk53Mm8rvOerqRqDl8q0nwArO/?=
 =?us-ascii?Q?8paUG5D6vIbtpC8Ril3p9PIf8MCDzRBB9jN8LtJ4B53KIWOm0n7/Yrmm6LTf?=
 =?us-ascii?Q?+X11cSAcDXGxgo+anfuU7N1PO+SqqC78mkbxBMtrBZjTR2Y0OtfMneBZV5SP?=
 =?us-ascii?Q?Eqa4bo0I5dUUwMFjEyQ7tsyXV/Sf9RXi7NtYAJ+ZceiUV0j+detRYsRXi8w6?=
 =?us-ascii?Q?913Ci8O0g7hirWqcegBqy8e3sKV2VhfVZZibF6WuV0qtNmMIN1Q5Qf0ZRccQ?=
 =?us-ascii?Q?hf7ENBAahzQFTljqomEUpvr4ESSNPMMTxjmMlEJS8ogG5j2NSQawe14mONEe?=
 =?us-ascii?Q?98UCeVLw4zGKBHE7qxe0Gb7rUa/QqvO10ToF4PQZ4eO0mVZa5olb6Cba0PTj?=
 =?us-ascii?Q?kQ+Fihrs5DkAdEp7AWZUwEPDD+Qh4orOEkco9ycI0IfrAApIByaPIAxbqFsb?=
 =?us-ascii?Q?0ako3D3S01p4MCwVNRFMdhf0t92zFwJ3G3poZ018kNsNZ9kZv1Q3wPREh9U6?=
 =?us-ascii?Q?9nm2uWePHA6lrLnw/bqU7IuScZco+FKnt21g4MC6ZNIXHngUthEkmnb3Nn47?=
 =?us-ascii?Q?X9HAYt4T2JquaJLRd5Aa+yh4ldtnJb5SJ0fsppZWZGdCzWpWdr3nTKpSCTvn?=
 =?us-ascii?Q?vAz0FVyKN2iKPJ4gwVNRqGXxLYfONomc69K6ddQEjsQTFocGjODY7Jhm6Xo9?=
 =?us-ascii?Q?Pg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3261fd48-d474-4d74-04c7-08da96667df8
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2022 15:33:37.3239
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AcVo/q3At505J+gCYUtzsetPBlGGZ5DLO7kChNWKplIX3Uve5H6lyP43hRXOTmr4vNPMCwRwNCr0ShmAbpca0Q==
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

Our current vsc9959_tas_guard_bands_update() algorithm has a limitation
imposed by the hardware design. To avoid packet overruns between one
gate interval and the next (which would add jitter for scheduled traffic
in the next gate), we configure the switch to use guard bands. These are
as large as the largest packet which is possible to be transmitted.

The problem is that at tc-taprio intervals of sizes comparable to a
guard band, there isn't an obvious place in which to split the interval
between the useful portion (for scheduling) and the guard band portion
(where scheduling is blocked).

For example, a 10 us interval at 1Gbps allows 1225 octets to be
transmitted. We currently split the interval between the bare minimum of
33 ns useful time (required to schedule a single packet) and the rest as
guard band.

But 33 ns of useful scheduling time will only allow a single packet to
be sent, be that packet 1200 octets in size, or 60 octets in size. It is
impossible to send 2 60 octets frames in the 10 us window. Except that
if we reduced the guard band (and therefore the maximum allowable SDU
size) to 5 us, the useful time for scheduling is now also 5 us, so more
packets could be scheduled.

The hardware inflexibility of not scheduling according to individual
packet lengths must unfortunately propagate to the user, who needs to
tune the queueMaxSDU values if he wants to fit more small packets into a
10 us interval, rather than one large packet.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix_vsc9959.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 459288d6222c..3c9a15dc7f59 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -1248,6 +1248,14 @@ static u32 vsc9959_port_qmaxsdu_get(struct ocelot *ocelot, int port, int tc)
 	}
 }
 
+static u32 vsc9959_tas_tc_max_sdu(struct tc_taprio_qopt_offload *taprio, int tc)
+{
+	if (!taprio || !taprio->max_sdu[tc])
+		return 0;
+
+	return taprio->max_sdu[tc] + ETH_HLEN + 2 * VLAN_HLEN + ETH_FCS_LEN;
+}
+
 /* Update QSYS_PORT_MAX_SDU to make sure the static guard bands added by the
  * switch (see the ALWAYS_GUARD_BAND_SCH_Q comment) are correct at all MTU
  * values (the default value is 1518). Also, for traffic class windows smaller
@@ -1257,6 +1265,7 @@ static u32 vsc9959_port_qmaxsdu_get(struct ocelot *ocelot, int port, int tc)
 static void vsc9959_tas_guard_bands_update(struct ocelot *ocelot, int port)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
+	struct tc_taprio_qopt_offload *taprio;
 	u64 min_gate_len[OCELOT_NUM_TC];
 	int speed, picos_per_byte;
 	u64 needed_bit_time_ps;
@@ -1266,6 +1275,8 @@ static void vsc9959_tas_guard_bands_update(struct ocelot *ocelot, int port)
 
 	lockdep_assert_held(&ocelot->tas_lock);
 
+	taprio = ocelot_port->taprio;
+
 	val = ocelot_read_rix(ocelot, QSYS_TAG_CONFIG, port);
 	tas_speed = QSYS_TAG_CONFIG_LINK_SPEED_X(val);
 
@@ -1302,11 +1313,12 @@ static void vsc9959_tas_guard_bands_update(struct ocelot *ocelot, int port)
 		"port %d: max frame size %d needs %llu ps at speed %d\n",
 		port, maxlen, needed_bit_time_ps, speed);
 
-	vsc9959_tas_min_gate_lengths(ocelot_port->taprio, min_gate_len);
+	vsc9959_tas_min_gate_lengths(taprio, min_gate_len);
 
 	mutex_lock(&ocelot->fwd_domain_lock);
 
 	for (tc = 0; tc < OCELOT_NUM_TC; tc++) {
+		u32 requested_max_sdu = vsc9959_tas_tc_max_sdu(taprio, tc);
 		u64 remaining_gate_len_ps;
 		u32 max_sdu;
 
@@ -1317,7 +1329,7 @@ static void vsc9959_tas_guard_bands_update(struct ocelot *ocelot, int port)
 			/* Setting QMAXSDU_CFG to 0 disables oversized frame
 			 * dropping.
 			 */
-			max_sdu = 0;
+			max_sdu = requested_max_sdu;
 			dev_dbg(ocelot->dev,
 				"port %d tc %d min gate len %llu"
 				", sending all frames\n",
@@ -1348,6 +1360,10 @@ static void vsc9959_tas_guard_bands_update(struct ocelot *ocelot, int port)
 			 */
 			if (max_sdu > 20)
 				max_sdu -= 20;
+
+			if (requested_max_sdu && requested_max_sdu < max_sdu)
+				max_sdu = requested_max_sdu;
+
 			dev_info(ocelot->dev,
 				 "port %d tc %d min gate length %llu"
 				 " ns not enough for max frame size %d at %d"
-- 
2.34.1

