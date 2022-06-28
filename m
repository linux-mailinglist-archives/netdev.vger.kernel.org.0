Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 607BC55EAE4
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 19:21:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232648AbiF1RU4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 13:20:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232147AbiF1RUz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 13:20:55 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2079.outbound.protection.outlook.com [40.107.22.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0112737A87;
        Tue, 28 Jun 2022 10:20:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IZEqM6eh9RPyRbtGSHgsujGQPFHiCymjlDNU7zkwIguHAHwKG1jbEEVRvcsMI/ZFZOg+JSoNlq4Gxdsg0upscFIvzcrLQ/4Ht+K/pSihr01pkhby30aOMVIp/fEeiu0ZP51mJtcB79hbZwwpju6pY4od7PMyWXanVEIUP2dO7xuTPZKVlddp07w8eQbGvFdO0/Aaq3MbJxEuPx5czT1ZJBToOj9tgYkj57PyZpZcrL75widFA32WqkAeE2eMjvcT+MCCbeJQOtMPytVL8ZoWfcHbGzVIRMLf2MFKeHtQ3djmq8KyZPsPzx8kvJlH2bPQvyIbxrAkW14CA6xFwuWWFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GlkfyU6H4IJiORFm5pP6Ys3IHB8f9SuKomr5DXQSzPY=;
 b=Lk/MJJfQPiCLQ4FMvUgP8wNie8wM99y2aCXRLF+CYBRxcw4RaHb1Isyutm5JN2LmfzbxIPtzh84raoB9MXp8XeVskiA0HBGvj47fHwRF3oo3vZHhoFpJX/reHaxim9u5yNoRRXTuf1u/EtgGzvxUHFAOkLPwkROobNaatsSfT/V3qkAruKQxzo6IhKfiBTOnpsGsPvPKgQ5a4dzAD4Mcsm6umBk2ohJ03+WFP4jY5dcbEDf/bSmbwVtZ5qGZwX+YO3iWwuzk3Md5Giig0pc+Mar9bcCsd5iz4JfkJ5t+Zo5yLYA7IKhytCSKlpnB787K9IefXKqW5gPzYKOKG7DkZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GlkfyU6H4IJiORFm5pP6Ys3IHB8f9SuKomr5DXQSzPY=;
 b=afL0UkU1/WxwFHodYn+l9ynl0jpcoSrtAVswRt3zz9c7IG+XgYn9e7MzNZdggFzz5WcR8Wxa1HLKOoqirZ17BFiXIWCtLtDYzlIC9Q/FnjjKOvjeZGiHXvnAjLTPNfg9ltBkIeEPowmu1O3/1cA0O6jgDIk5bfHVioGyiAE4lN4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR04MB4337.eurprd04.prod.outlook.com (2603:10a6:208:62::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Tue, 28 Jun
 2022 17:20:52 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::94fe:9cbe:247b:47ea]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::94fe:9cbe:247b:47ea%7]) with mapi id 15.20.5373.018; Tue, 28 Jun 2022
 17:20:52 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Colin Foster <colin.foster@in-advantage.com>, stable@kernel.org
Subject: [PATCH stable 4.19] net: mscc: ocelot: allow unregistered IP multicast flooding
Date:   Tue, 28 Jun 2022 20:20:13 +0300
Message-Id: <20220628172016.3373243-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220628172016.3373243-1-vladimir.oltean@nxp.com>
References: <20220628172016.3373243-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BEXP281CA0012.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10::22)
 To VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 05578410-3a08-4d89-fde9-08da592a8da5
X-MS-TrafficTypeDiagnostic: AM0PR04MB4337:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2dwXtnP+K5HHcMBpnkqiGlbLLBxHd9g7l9DTDaaZzd2FOnVY383Eiq6QTFhtT9pNFhgSB2HAodJV9Izxw8RRCRHhO2PiL6VloJS1cyNd7qjJhA9KZ+4iv/v95vfw/GuiSyR7UQR5W5FeVdWtkx86bibggkomy7G33zT1gP2FwX97n6hHy/fglPHFATtMVNkdtGNDhtQA7gcFVV8NGTW9O1umQOUz/uVJCkfHOSdYnT5N8nxWgjagjDGTp2OpKNIvPS6RmsA1a2j2YfxkluFpL9o9xILziosEDVD4vudXHwm1qCan0YVQ7scHqohs3oToJZoFzRSTHKq+4k86x1sMK6vNh3F+amVPYkIqx5/9ww8g70HPWkb7imGXeMxcxurOQXPP635S89Iq44cTXnYg/J08vYn0SueEVadWWAWSRDqKtpehp6d5gRDxxGEjgtU7J6egdfKgwCbQXOfK/fvq6XvK3RrmY9I4k5F20jrnRVPMnDZQeK+bREDNRDWXQfbZkWN67LhRFOLK/KcIZwYLRw9/1Ulmklty7AeY1M7N6w8+HpA9d1QG7v09qL9gOqa98liO65gw54emj/texWqSWAi3CkE2Z6XN8Gb4mJxanipsDIVeRZW7fhXl7Xc/xqFTXmC8VvSO/UlQO1XpkUTUDXcQMcEBdN2uR+lKZCmo1xz+XHAhUVpdr/ycZ5q/Qe5fkl+l10OAy5FWZ332v5PgVN9lkEngBrLFVsetMmJDk6d6QpV5pvYcFlno+Q6P+SYOlaZcOLNhQPc6Nh6VywiOqz1TGfr5+erBY/4uXkcjVSY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(366004)(346002)(396003)(39860400002)(376002)(2616005)(110136005)(38100700002)(36756003)(38350700002)(5660300002)(54906003)(2906002)(316002)(186003)(41300700001)(4326008)(8676002)(52116002)(6506007)(26005)(86362001)(6666004)(66946007)(6512007)(7416002)(478600001)(66556008)(44832011)(6486002)(83380400001)(8936002)(66476007)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bySmhPoLvVlt0OxaEcaWrvEpQYLT7RFow5IDY7FA5ZdB70arGFdw8JaSSpZ2?=
 =?us-ascii?Q?43cMpboiAR1xNu1xKOht3xboek9nYeYLrkIWKTdCsQzxzm+MBtbe84pCCdLy?=
 =?us-ascii?Q?fNqpIKWXagCoOrMQClPp452noMmwz1+0+wD26QaKghtAP+GI95yGMiroTWOe?=
 =?us-ascii?Q?BSajeKTs1lIW6f4UJkgrFt8rKfIwWSKNvJPT9pVAL5OdOP5XC2SN645lTWGq?=
 =?us-ascii?Q?/SxiL3CAeQyu587WUdcq/OnnmXN43toKnyieMFhBk3nQrmjt1ViHIqTq9QSo?=
 =?us-ascii?Q?pPRVlwqpiZOTceOukdRUUZo12gWTARY2WK10muT6XoVAb3yUHMmEW9Y2MjJj?=
 =?us-ascii?Q?7QpeRtB9zfB1PR2q6MqfG4e3XurrviinJg2E0U1rx7MVMRNU0dqP9XRzS5TF?=
 =?us-ascii?Q?rhagV4eEHlIxZuC7MSJhFV2mSerf3W25lSbuAjBotsCb0VH+JoR3aBUorfeq?=
 =?us-ascii?Q?oP0vyRoYwZz8TnlFPj/PjYpqNFoxBNQvz1GDPII84b6HIt2hLc1cNnp8BtZm?=
 =?us-ascii?Q?GvLC6lS4jQyg+L/2mgoABcWGkOXXejzsNvwrnrBHdEtQZUPLYYpF+AmCDMg5?=
 =?us-ascii?Q?toVdCnONU7tD1XjmyjFvGIjA0tbyfoEHrUbCO6hwDWF0uHdRKuE0nKkZA9/j?=
 =?us-ascii?Q?xXFfJCKC9wpUmi5QhyKj8PtWDhWapuhSdorazAfELBJ7dnLTxzn4iOBFS9DP?=
 =?us-ascii?Q?gmnq7uvxev6QSicW9vb3Q//jsiajBBKkhspiKEu/ecUBGdQuJkORjZLBrv/0?=
 =?us-ascii?Q?E96J3V+xRJXXuMOlcUK4+1jodyz8ZXp2S4dRuhxDyIVZGsjSyeNJwjtZsjd9?=
 =?us-ascii?Q?uZB6HjX4U/9KAuvJZ7bv1kzg2m9StlOYyZ7Eo30Q4svW4WGMvHb/N3LF0eao?=
 =?us-ascii?Q?2pXYIXu8DFvMjR26vwGPuvcJqnkxHxQpJDOupVAnm/qmV4Zgk240MbYUyYLV?=
 =?us-ascii?Q?jH+cBya5LhqBH3ScnJn6y7P8RdIMXUTY78Xf7YQp8MmRaEeqyyL8HxeA6azP?=
 =?us-ascii?Q?bpeelTLSEUuvZSWNSTCZFkkumnAF7Xg0p8D7sUCaMc2EX8Xj+nGSeHoWMH+G?=
 =?us-ascii?Q?fEUKF1huCFtprpfXe7TGg2bIwT9C7Z0fKf8/ucf4Rq7Rsj8gs7IGxqg4WgAt?=
 =?us-ascii?Q?4zuH0RALNRRexrfWZa854wROMi2AQwiGP4zAInynq4dfT8stQ62M1Ugoy7zL?=
 =?us-ascii?Q?1yTGdHbSWp7ixh7UaeFXnUB45oXdWbqARHeKeJwTpwgC0cE2PX7NYjW+//DF?=
 =?us-ascii?Q?fDf0odZRLML2+u15YxvQ90fW12MVbrij4+UUw5BULf7yksd2hIa258qs4Ipo?=
 =?us-ascii?Q?aLGcIiQSLnxwHo/PnHUzql088udzLlWWrM06Bi/QLiMZyecmCWgcENCFpfmw?=
 =?us-ascii?Q?1j3K/vB7aMlZK5gxaBZKjCk7ZOYBWyYXjG08/Xlpa3V0wE5KC2FryGkBbLc+?=
 =?us-ascii?Q?/Ocu507AHiQfFhVD6SPdya4U6eBfgLnJ0tkIiEKea5o0TB/n++ULKyfci5Nz?=
 =?us-ascii?Q?uhS0FgXHXV6w//+IGtwXrnuE4zjTwrFjro0uFQE4Y6WbGkpUCPQ8UDSfDlm6?=
 =?us-ascii?Q?3LM3ZjwTDmMONOhS+mVZuNyXcuqSME0Kr9rYLmGUBjlgkilhjgC+NuYAOKaQ?=
 =?us-ascii?Q?2Q=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05578410-3a08-4d89-fde9-08da592a8da5
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 17:20:52.7717
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CMy9qPPB6AD7wx72pR8XBxZbN7yT2ui+g1S2pA1OGy9ibSt7q+mAynJ9MSuDMwMa99yXd+u0B7EJ1/7Gzb5hkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4337
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Flooding of unregistered IP multicast has been broken (both to other
switch ports and to the CPU) since the ocelot driver introduction, and
up until commit 4cf35a2b627a ("net: mscc: ocelot: fix broken IP
multicast flooding"), a bug fix for commit 421741ea5672 ("net: mscc:
ocelot: offload bridge port flags to device") from v5.12.

The driver used to set PGID_MCIPV4 and PGID_MCIPV6 to the empty port
mask (0), which made unregistered IPv4/IPv6 multicast go nowhere, and
without ever modifying that port mask at runtime.

The expectation is that such packets are treated as broadcast, and
flooded according to the forwarding domain (to the CPU if the port is
standalone, or to the CPU and other bridged ports, if under a bridge).

Since the aforementioned commit, the limitation has been lifted by
responding to SWITCHDEV_ATTR_ID_PORT_BRIDGE_FLAGS events emitted by the
bridge. As for host flooding, DSA synthesizes another call to
ocelot_port_bridge_flags() on the NPI port which ensures that the CPU
gets the unregistered multicast traffic it might need, for example for
smcroute to work between standalone ports.

But between v4.18 and v5.12, IP multicast flooding has remained unfixed.

Delete the inexplicable premature optimization of clearing PGID_MCIPV4
and PGID_MCIPV6 as part of the init sequence, and allow unregistered IP
multicast to be flooded freely according to the forwarding domain
established by PGID_SRC, by explicitly programming PGID_MCIPV4 and
PGID_MCIPV6 towards all physical ports plus the CPU port module.

Fixes: a556c76adc05 ("net: mscc: Add initial Ocelot switch support")
Cc: stable@kernel.org
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index ea30da1c53f0..a4e20a62bf8d 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1733,8 +1733,12 @@ int ocelot_init(struct ocelot *ocelot)
 	ocelot_write_rix(ocelot,
 			 ANA_PGID_PGID_PGID(GENMASK(ocelot->num_phys_ports, 0)),
 			 ANA_PGID_PGID, PGID_MC);
-	ocelot_write_rix(ocelot, 0, ANA_PGID_PGID, PGID_MCIPV4);
-	ocelot_write_rix(ocelot, 0, ANA_PGID_PGID, PGID_MCIPV6);
+	ocelot_write_rix(ocelot,
+			 ANA_PGID_PGID_PGID(GENMASK(ocelot->num_phys_ports, 0)),
+			 ANA_PGID_PGID, PGID_MCIPV4);
+	ocelot_write_rix(ocelot,
+			 ANA_PGID_PGID_PGID(GENMASK(ocelot->num_phys_ports, 0)),
+			 ANA_PGID_PGID, PGID_MCIPV6);
 
 	/* CPU port Injection/Extraction configuration */
 	ocelot_write_rix(ocelot, QSYS_SWITCH_PORT_MODE_INGRESS_DROP_MODE |
-- 
2.25.1

