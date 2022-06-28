Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2BA855EAE6
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 19:21:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232890AbiF1RVN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 13:21:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232882AbiF1RVF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 13:21:05 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2081.outbound.protection.outlook.com [40.107.22.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A766037A93;
        Tue, 28 Jun 2022 10:21:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V8g6Lsh9UNxEF8DtYayi2NK+vYtob9LUkKghdrbHrtUsN5MAOftyR/4sF/DgBf5zf9n+hPOmvJM+YvOLnHDB+oLsRAH1CsPLOMl/UNoOIMqin3ou6GjU3E2n60j5L8Fb6vLT2AaJsOSWjbrBjVrRd6e/rwbdIVaGw3J2nQ3zc5cPh5QiUlF4NrLiM8ukVEFW1pGWPlk7kunw4Ub/Aqmn73z3h7+UqIJzJMXtxNsgJGj7nt9F0QCdkwZrE67dGqg5jBNIIHr2lZ4GmvU2jYHKtmMNHIMCRLGYR6trDoSxiu47/NavDDrex7gdcYwTIvK+s7zMVUkptl4qxOwj2iBnSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8qN4flHz1N3fIIaFXWh5ss4jnwyT2pTJ7a4hyWnrrY8=;
 b=Xc6L04dIH5Z6Hz1THMmHyHCLq+YjYWY8Dd8GAptyM2maekSKJwp9mGUUgA+g2BDuz/3XjmHdw7Uw1W88kJSWp9x9Yrvd4DO+JFDTDD4U5eWAL7/nwpey1w63qaEBXBLtfFG4fm7V1DNSR1NbyeNpEXF0OCanQd+IpxFuDry4x8XuSoUHd0y5kbaLFWyT/bOm9uMm1VZ6xfqZ72domBcpAWVkOV4oKHvsNj1cBq0xBoEVapyJ5uYbRrh7OXMt7jfIDXkxTTwuj0btuBwPhF8j3pz/5s8NFmdkM2UyKQ41Y78SN+5mp/b3N4WVIm+mibA9PPMr38ic3DfcRi/vPojwkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8qN4flHz1N3fIIaFXWh5ss4jnwyT2pTJ7a4hyWnrrY8=;
 b=Vq7UcXiav4ky6WTfGF31qyaCO4YBJmi3ZykzxMTkATJGHONmZj4uZ+kffIT82YJhuNaltmF/jQNNRmL/3p2yv00CSctX2aumO7qQwFeixp9WGIr8Ry8d+n4hDtS/LWYaNum2L//NvbijxMMalSwDdVpXuoVnv4Hn7ZPJrP5bXZo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR04MB4337.eurprd04.prod.outlook.com (2603:10a6:208:62::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Tue, 28 Jun
 2022 17:20:57 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::94fe:9cbe:247b:47ea]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::94fe:9cbe:247b:47ea%7]) with mapi id 15.20.5373.018; Tue, 28 Jun 2022
 17:20:57 +0000
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
Subject: [PATCH stable 5.4] net: mscc: ocelot: allow unregistered IP multicast flooding
Date:   Tue, 28 Jun 2022 20:20:16 +0300
Message-Id: <20220628172016.3373243-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220628172016.3373243-1-vladimir.oltean@nxp.com>
References: <20220628172016.3373243-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BEXP281CA0012.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10::22)
 To VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 84456f60-fa83-418a-829b-08da592a9060
X-MS-TrafficTypeDiagnostic: AM0PR04MB4337:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a2tXVhbSIoSyX7gpAtj4hF//USS3oPFBX9td8rEQCjdmiNEDflDDRfPuqWDZJ0Nen82fNvH4WvS8Z3ukrXBX/t53CorJnOjRyqYHU7jEy+hLwiQPPi8k/ZtfpQCboCxFtcU81300Zuxl1z2AeqJLNgbZncaNtEb0aw3cGj0yjX+UCNwdNgAymsoMlCucDOq/rXirv2TSRqz+rlgntwNLviX1xCCsjAm3nOP6I3PS16xwdNjhncRUgcipRANbGKdrmDbjxoYGwkuyF1CkhLDLjLJwLgeQUqKVmHLP0nC1r7nuZwPYwDyn+AXjvrzNj1O41D5ue0pgQoHl1or4/lSgc4UWktDbBY9KOPep4011Ko2NsgiP7SrhHN+AeidDLgxqQIz2SuV7vPKOTaS/HNL6JYZKHJn7BV8QbdHV9L5bO7YA+lzs204cEiYyPCEPtvxJLps998neyvoarpFM6ZVES5lmVjfb2DZAwIE0qp2ZuRvkwNKQQINMgZtrpm2BE6JAh7waGUdKRoCUfwMjub480PAfdSBbWjtJCaGe2PLq6Kx+h3l7XmAwbXxIaAisjjHFjfbO8nHUmUq0oYo1/SyPAMykmgymTX/AvFqPoEYRRqZIPyquhmUc9HVhQ+GiJ4JIFFgNC1VNGe3yVi/1wSlfrzLRJJa1PVMgnYYHnkZVRec9EvwJZUqQl5SAp3Zn3V+Fad/rp+Al/2b9Wf13sBzpYFnr3JfdqDs2AS02AdVpU33h1A5BE5929dnlicB5HrOhabfQuhkNDebnwexCuk6yAAo+z2CdmiC/p5xMxAOMkPI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(366004)(346002)(396003)(39860400002)(376002)(2616005)(110136005)(38100700002)(36756003)(38350700002)(5660300002)(54906003)(2906002)(316002)(186003)(41300700001)(4326008)(8676002)(52116002)(6506007)(26005)(86362001)(6666004)(66946007)(6512007)(7416002)(478600001)(66556008)(44832011)(6486002)(83380400001)(8936002)(66476007)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TmDX30s0J1lTNPLv5ZhZnP1LIGsgKTK1h9KS223MqiU9+0rAv0UAkxq07uXi?=
 =?us-ascii?Q?HeWPiRZslrg5dd+jJw2agvbjdIMxXfDVTl0etdJZEEzSrGOnFGfEUxFq0Ldf?=
 =?us-ascii?Q?hQgdDWU0n+Y99F72PxcmmX3lS7qVt/YeHvopitC+yYnqAK2eAe2sAicG6Ffs?=
 =?us-ascii?Q?dWigIFGqWjZVGv8CriK2B3NDGA3cygl6ltrJmAsqeNRfpwE58Q+57EW2V7hj?=
 =?us-ascii?Q?rZZAnsezLiiuvJrXDZfuZZSh/C8zDiWPEnU2zIDYrfMkF02aUQDgB5skrLvt?=
 =?us-ascii?Q?1Xaj9vPv1YaNLAxUCQpOFE1wzpHbKJZiTTIYBfiW2tVZONPiZm2BtoDF59NJ?=
 =?us-ascii?Q?CNy/EvZnmmLuXuPJQgZ/+CpJZNdoX3saqpADkV0NZhpW3JmFk305Rj/E+jWJ?=
 =?us-ascii?Q?1PGoHTXa0MDwUNvhCeh6kB1vbqyoP9AAD0eX5iFiH5rl+uGfA2Wmp7OnNCvY?=
 =?us-ascii?Q?55n3h5kSGlzH6pFc4Pi/f9Pn9/wM7n6IAINJUst9e4p+xJQBk/xwHbOzP9de?=
 =?us-ascii?Q?ohni4ctxjYeNLyiYV0O80uy6I5AF2OxSWjFuSqvgMNyUwg6OSC9YMNjQOyR+?=
 =?us-ascii?Q?NXOk/w0LcVS9aTRxeUoBWTKGMF15T4GW/njEm8AGGQQPJJe7+OMIpKlrDjf6?=
 =?us-ascii?Q?vqpmFFPRLW3pKHabEaGYZwLh9OYQ+am/ikUILKCxzVmu7Kp4Cod0ZhWfmLMP?=
 =?us-ascii?Q?7S1VcfZC4fZXqnBULiKXrUjUCiUz6F3TxeWUevGnRbcU/Lff2RVtoTrHPosy?=
 =?us-ascii?Q?C7wgNWIaHYgcaK6VWMnsU4shcr5Ue0o4zI8Qo9OUI4ksv3HMWH8+Jh7qBi9c?=
 =?us-ascii?Q?puZALfIIxf+f5uibrmJhGhs8UQkyLhf/Dm8hrYKofpXmilQEWiyK9Feyh5Ik?=
 =?us-ascii?Q?SjxSGHQKph8FxT4Im8MNLMfA7xgTtNLXVXWr0/rJLJTrwE5o7CxPOemRLtUM?=
 =?us-ascii?Q?cMJAqOG+8MvTbA/I4vNOWoXv/dNVqScmhXTqtoccILhrD49G7DPfJSgUaafc?=
 =?us-ascii?Q?4WK9OtgqDHiDsAGnYP9m+kZH4wjtJ+oC/cx4n4b1TLHXVS8yXOwVcuubcDjl?=
 =?us-ascii?Q?6/ermb5d0Qu7/VnH7JAZGnaLBeGgHULMoJr+35dA7m73ZexVIza3oQvA46gE?=
 =?us-ascii?Q?e5Us680oH6lvkd90SqAObzjTLd2zyUW6+eS+7esXDpfm1tEgpr91DtrgERz6?=
 =?us-ascii?Q?YfBVc2kpKt+PSkfJYz6KQtMi9w60w1sq0coT5uaXT2nQDFB3oU17K4sNHw54?=
 =?us-ascii?Q?JGmpwgYPZj2/EJGNkwoEYJ6qAfv0sq6ZXKp9FG++WgtEvT2YPLD2iHIZJmv7?=
 =?us-ascii?Q?Ug4nNV/KMlcLlgkLv0cguRnEth8RGY/kEZpgSze8dlnWxrp5H5354jMz6gG6?=
 =?us-ascii?Q?dFqwTGwfBizdglgn8PeuAvs/sR8jiWp4Bke44hAzsOoxxOJlx1/ILJQq0GK+?=
 =?us-ascii?Q?ybQlzu7c5rDynZsmVBs7NEMBdj/Eg4uGH5xely9FR9nL1MwtVx0LPHAyoDWA?=
 =?us-ascii?Q?Pp+Qmc7ghibIungEDHnmJRg9DK6Ajp0bFXub4tFZJf1ARU9gb6K+CK9Um+a1?=
 =?us-ascii?Q?zgc/soXP+kVuV6We5H4wl8pU/7tzmiO8fRL03Nd+2dB2YllvmPYTZLEVNWcX?=
 =?us-ascii?Q?hA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84456f60-fa83-418a-829b-08da592a9060
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 17:20:57.3651
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ik0CX0IFfDOxx0mcX5+nkfK6D8YG2lXnaP9QvgxdtPhnV9Z6/zGDyYNSYP9DNMhXoJHt0xqhCP5OWH2imnj/6w==
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
index bf7832b34a00..acddb3aa53de 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -2153,8 +2153,12 @@ int ocelot_init(struct ocelot *ocelot)
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

