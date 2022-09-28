Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FD665ED986
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 11:53:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233418AbiI1JxP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 05:53:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233459AbiI1Jwx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 05:52:53 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70088.outbound.protection.outlook.com [40.107.7.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5EFAABF3D;
        Wed, 28 Sep 2022 02:52:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xxde/gp+l7FjhCFPXeD+EkEFkVUjFgahU4miSkUP8s6Wuk5/wNeIor3JrV0PEBxp+RP/4hRpnVATYLrJYx4+PTZpnNYAf+W3kMP4ZOKzdqii/oqG6RmwNIiYdX4GCE5zWaw+TIwISvC8kSQI2QfLMHA3r09HKyr2C35j3sMWqqA37jCgpBpMKVZo8HZ3W0aNLQN/c2CuSsshLbbh9ig5ohVxYOox62IIvSGX1S6Bjl7r2gEUxk7ziLgtvdiELBSPkkFVm5oEZoRGq/ZjLhzXgcAuC+yBOkPcTAzSTLxvudGL/3kuW+1gb7xy6MrBo6rRaWmlz+VMAYUY9RgsOAVKIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3+CTWgfk5gVOajkWlBPC/DR+CcBeZgQ3OCvOzER7mSc=;
 b=M0AjPyKSFngEKCXb3TEVw+aMQXmjm5aXKhew8820+YwEZY0pahQKpg3jEo09oWY1hRXyshnslm/Yo+oosYeNaGgEn0GFdqpbr5taC2JWbKtcbCgwDt1aPw7PbcfiU0Mu6QcoeNIf9zD4SC3vE2fK6ni32w5zme5ibUV1IqbY0TzhEdbTJmzDFo2AGbfvjC6s8F87k8INMw3fCJjUvXH2zdgQ3VZ7ghxRlfuvra5SoCfC4IesneqNgVPbCelyvLVXXAMTe6P50jvqCHHjxlLXVHx/5o8P7Fn6bhBEmicEuDsPGLNBL6XNWimUWH88C6S+L4VTQYRBud7FnA6nFol0Yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3+CTWgfk5gVOajkWlBPC/DR+CcBeZgQ3OCvOzER7mSc=;
 b=FV2cDigQHkkhfnWj39UUvmV5McyRhRnPTxiO7g7mQOmCDteNnIIzGC8GtgPkx2/HFQD9AmorvBMUl011P13UgR70N5p0NRo7ZE9Y1b9AF+l2AMjnLDfYwxMKLoLHm8DcbaqLYdtuEP3F8y38BjoPdH9HEo019MO7vjQDLx1hLdI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB7752.eurprd04.prod.outlook.com (2603:10a6:20b:288::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.15; Wed, 28 Sep
 2022 09:52:24 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5654.025; Wed, 28 Sep 2022
 09:52:24 +0000
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
        UNGLinuxDriver@microchip.com,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Michael Walle <michael@walle.cc>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Colin Foster <colin.foster@in-advantage.com>,
        Richie Pearn <richard.pearn@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, linux-kernel@vger.kernel.org
Subject: [PATCH v4 net-next 4/8] net: dsa: hellcreek: refactor hellcreek_port_setup_tc() to use switch/case
Date:   Wed, 28 Sep 2022 12:52:00 +0300
Message-Id: <20220928095204.2093716-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220928095204.2093716-1-vladimir.oltean@nxp.com>
References: <20220928095204.2093716-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0501CA0006.eurprd05.prod.outlook.com
 (2603:10a6:800:92::16) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AS8PR04MB7752:EE_
X-MS-Office365-Filtering-Correlation-Id: 95354c07-7ef1-4e8f-e89e-08daa1372502
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IQBlgrfMQ8ZZRAckJLk6zsJfg+O1cW9Yzj5vN/yf81D0QusYX7QFf+oNaqAkFzDnAGUgw4sxLdzSi52g4HRqZzejQB6EeCOrMK/MObyXonsL6yVWoZEx6DkInl6VShmMohnR/HFRa5GoiEVSqawcQwNfbW+r7c7BPmzh3q8IPjSI8HkvpO2dXBaZJc3uhcuQUQDDw/16lyVq/9ayd2ZPEHVGPQAdpmmNmDoEdXoezlALlcATTDF+oG0xpuQMIuvPoPfPFW+Hr4qTy4RvEMuIsBimQdeejNnceVTUBNXuHtNc4h6c+ddjZKICGnm81va2bQmsjA8ZKG7gU768Nmva/79pNY8N1pBrqwWE2mf/gA0PjQroDuMwFWv5kvqQ8T/hspa0F8UT9B2REnn3qmNEZd1Df8iNdVjSh5hc3GVXgN8f3vsov9W6xfmNl6F8gGep0zJqh9jNgobVxlFEdCtkw3gHpcwj+YkembOmujE6fubHlLZvw8mQwbtbGaEuJ7Re033h5kRSYcXyxjGTMcy0iu1kiisHTagrqLBVBun0b6vVy6rslXYMn3FR+TUvC+VmFeWayVKcAJH/MUKMKPl1ZHwPp87OUXRjar25nhKCAv73FQt55J76eAU02ylchLiQuKaUJFjo0mwvplBmDzyMNqA9qlZgmM8tIBc2O1Ee2DkxyVlPiHcHZ/fz50WeV6BSzt2vLZ+yt4SF6nadhDYg5WcfbnmZkQJdSiSyhMQN2lYQ4AY5xU6ozIySqD8Tg4NaUjwSYE3G7YUZK+8wENWEtw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(346002)(366004)(396003)(39860400002)(451199015)(38350700002)(38100700002)(5660300002)(6506007)(52116002)(6666004)(6512007)(8936002)(7416002)(2906002)(41300700001)(44832011)(36756003)(6486002)(478600001)(86362001)(54906003)(6916009)(26005)(4326008)(83380400001)(1076003)(186003)(8676002)(66476007)(66946007)(66556008)(2616005)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?S0Tg/W/R3Wyqrm3Pn/HQJEv4zYXKuiqBU1zaeZbmiDr5UwD4q+dBKqIc5fZA?=
 =?us-ascii?Q?7k8dfVUN2P4Kv2mky0EwQ6pDjjqNWG8Fd1sRj35lWRCeVBw1BV5NybH0Ep/T?=
 =?us-ascii?Q?YaklM9G32nS7Rir7EkfbVd5TPesbncYVfiRalt5NmHZptWlXpUsD2jMQujk5?=
 =?us-ascii?Q?GcMWhb+LMHJhCvgkM+qBufQ05U4bd4PDDKGfP2C6tPZw8nCdgoXNcxDf/5mm?=
 =?us-ascii?Q?EgWmotCJd0ELY8d67XUIZkW3nwm/V1W2MwraAy1iRTZTcNQJG4mekLwTLkT2?=
 =?us-ascii?Q?stHjrDmvnlFTDkmQQ3drYeaq1iAnxARjV6jM13sryXGLiTWdRAsdHGeC79Nn?=
 =?us-ascii?Q?AEXTqIaQd344ItIhwpdbyyDN2kXZOBbqennmbj1i3qUl2OMDfXhIeuIsvmRW?=
 =?us-ascii?Q?594E/Kl3HuT7zN7XM+9tRiQ1kfRmFONUzJp/tZv2mykReqFEBZFrJAmbI0zO?=
 =?us-ascii?Q?1eLPilLOPzMEwzrJOdcuecqm1yNXNzE7wiF0kwtyWj1J3A6Kbju3mVokV8FZ?=
 =?us-ascii?Q?9gcoajvyAdFYYzqViUxYemtpCm2utSn3RGkeF/y06neHYjorbcog/UjNc3Pz?=
 =?us-ascii?Q?y6s9oFi9Uo89ueb/arFcas9Kf115hJ3tSwvJs2RhkJJ3mnXeWC9Y21p7CneY?=
 =?us-ascii?Q?NLlE7dp1Q1pyE0yJiEnGc+VEb+kOP1eB9yE1J6Qi+ibGtUGQwm5DNTPnHAEe?=
 =?us-ascii?Q?9nxvn6avmn9qbK5sfXK+jSY3Z5IoAjdCLKxYGf06DBZQ4EkhgIxh8Kc4nm/I?=
 =?us-ascii?Q?ItY7NEeUcV52Af61Fhb10LNp3fmr0++2/CbeRk+XouSVjXswi8DEjYCxq08Z?=
 =?us-ascii?Q?XcqAO+mRYGEMHVn/qfzHWeizNqMXec8Wr1DUdQZ2HfT7UyI8tWgOv4O8Sz4r?=
 =?us-ascii?Q?XLCvPB9kFkn1pu4+tnkGZx5UreZ+80U89nLXiEblrHfO5rXjuy5zNi7scH4i?=
 =?us-ascii?Q?FR3iR2xcOFiXCrS4YK1D9ID6eeOMAhqb+B8KTxPO63mF4jgOcDIwSIEvS4hs?=
 =?us-ascii?Q?pbVuoz1jRmZ942017cns+DHPzXFq030vW+twLHV+F++wmzlKNTX9I9jehLGC?=
 =?us-ascii?Q?XFWlr6/Pe6s8TmYNFOXAandgYeltwPFhmV0NayqRU7kKhfXtT/Io1zozK0Mn?=
 =?us-ascii?Q?IcBZ4VTNwGl5TXIA+ZF1j4AOjxX+eEwUNXHwqdJN+WXfTZzX03xP22BWGxPE?=
 =?us-ascii?Q?eRtQgGrqMtyxIgYkzNq5U3k5Z9pO3mlm5euBJnc7EmMLinL24fiz3Sw1JoSs?=
 =?us-ascii?Q?/N80tOTqbWfwp5zLVl7GIgktHRf5qG0rIwzJgVNBPeL4AU0P5SW+5V4sYHTC?=
 =?us-ascii?Q?wFJuSu3rFs6oiOnsQ6M80H7ILlaxeF1zn1E2WdyueaVHhN6TVmiPaRueLBlD?=
 =?us-ascii?Q?jvvuC8q95NBq/Kk5TG1PK0kRYEROgMpnCx84ONnVLSsD1KgWMkTqCghiqnoQ?=
 =?us-ascii?Q?9gc3J1zEdHZeQeB2eH9EK7XlwbRPuyZSSL+ZF/+lB3mY3DK0C3nPd5a5rQjL?=
 =?us-ascii?Q?LNJABLDmBMgeXdJud5RbhBRZ/zHZ92JIF6/hSoTqKrelsdy+Kd0aHLl7GWbb?=
 =?us-ascii?Q?QyqQUy3Yn1Tdo6lD2TJkqVgVDuIS7ZMz3ELENY5pynO1ZzEXIeW/8JQ/LkRu?=
 =?us-ascii?Q?fg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95354c07-7ef1-4e8f-e89e-08daa1372502
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2022 09:52:24.4598
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B/uBlX/LmJFg6g70uBzqXDEOOmXYLp1wbB9M3A7jVplEzlEtIeez9BvPZUUWYXTAx+6Iv9KL9c/SWv7TS0DLVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7752
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following patch will need to make this function also respond to
TC_QUERY_BASE, so make the processing more structured around the
tc_setup_type.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v2->v3:
- patch is new
v3->v4:
- fix broken patch splitting (hellcreek_tc_query_caps should not have
  been introduced here)

 drivers/net/dsa/hirschmann/hellcreek.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/net/dsa/hirschmann/hellcreek.c b/drivers/net/dsa/hirschmann/hellcreek.c
index eac6ace7c5f9..19e61d4112b3 100644
--- a/drivers/net/dsa/hirschmann/hellcreek.c
+++ b/drivers/net/dsa/hirschmann/hellcreek.c
@@ -1812,19 +1812,23 @@ static bool hellcreek_validate_schedule(struct hellcreek *hellcreek,
 static int hellcreek_port_setup_tc(struct dsa_switch *ds, int port,
 				   enum tc_setup_type type, void *type_data)
 {
-	struct tc_taprio_qopt_offload *taprio = type_data;
 	struct hellcreek *hellcreek = ds->priv;
 
-	if (type != TC_SETUP_QDISC_TAPRIO)
-		return -EOPNOTSUPP;
+	switch (type) {
+	case TC_SETUP_QDISC_TAPRIO: {
+		struct tc_taprio_qopt_offload *taprio = type_data;
 
-	if (!hellcreek_validate_schedule(hellcreek, taprio))
-		return -EOPNOTSUPP;
+		if (!hellcreek_validate_schedule(hellcreek, taprio))
+			return -EOPNOTSUPP;
 
-	if (taprio->enable)
-		return hellcreek_port_set_schedule(ds, port, taprio);
+		if (taprio->enable)
+			return hellcreek_port_set_schedule(ds, port, taprio);
 
-	return hellcreek_port_del_schedule(ds, port);
+		return hellcreek_port_del_schedule(ds, port);
+	}
+	default:
+		return -EOPNOTSUPP;
+	}
 }
 
 static const struct dsa_switch_ops hellcreek_ds_ops = {
-- 
2.34.1

