Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83C5A4B590C
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 18:46:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349864AbiBNRqs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 12:46:48 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240999AbiBNRqq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 12:46:46 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2071.outbound.protection.outlook.com [40.107.20.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7F0DBC3B
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 09:46:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BXrlN4S6xKpvZVn3qUm27AsVZzNKgA2n/Ck2ErwVlDw7tlYEk9u3DHUovmclKTvoCa8d8gbH90lj5hD+6xI7BLXAC7bS7YWO3Mr1urSgb1hxQFQW9BXYUYjMCr0GaekPD/N32NbkbHgwfXJf0SQ8cKBxUnl44gg9RKs1eEzuqCLm4vVsPll+9QuU2HsWgC4M2KaZOnEyMb0hgoPL6Kir6X5dAkOJQAaNQZj01Xc8MBtGUcXsZq2crbE/g8RrF0DhY6qx0zT2yDWpvIfa74xGpZq8oQfmaQ58Gnz+CHcDjiL1AAoXrhme/aKeIs8vG7Y+eA9UIS/Yx7mkniwAx/JROw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e5wybaANLAd/pQYbvhcc7KcG97RP1ouEzCCh0bk4Ejk=;
 b=a6KVBgTuFXi4Nr10J5jck4PUvICmENnzMH7I/zStwD84+KAKc2nMEk5QRVCNY9m/agHjZ1yRrgXmzj5PfOz0A6HjvfLB4CKQg76/Mm/nttfDm12CMJYf3BB5Ig7dRYDvW+mur2wkUEDE1Vf+tAQvOkIFiQ0CbyhEqlftAAld+rGJZ9TJqoLJcxFMSgXZVccFO5FhBQk4Qmng8Ly9xdbl4o7CTHkRh2XGPuA5fr3/xBykhtzYm+n/AviMJHoKroJinftBeRF4MOuym0evzWmSu4fQ5zOvTx9WGO6hm7tyZQblHVdPzy7OOX/NQtlIDsXlqVO8SKFjEY9kt9dd/iqkog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e5wybaANLAd/pQYbvhcc7KcG97RP1ouEzCCh0bk4Ejk=;
 b=MT0eF9kNB+u4zFcYgwrx01aYDvsg+gq4Cw+Wtrd+tRoiYv/8hRIwkub9qf+ivhm3q50I861WMC69KqYZxW84eZRLPFGVVP7sl5CqPHpolb0ckBBWJyklIxKGAMyiuHef0u8w7dT08JLC9LawrGhw9ysFOd4Godu+yi4eV04410M=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5903.eurprd04.prod.outlook.com (2603:10a6:803:e0::10)
 by VI1PR0402MB3728.eurprd04.prod.outlook.com (2603:10a6:803:1f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.19; Mon, 14 Feb
 2022 17:46:36 +0000
Received: from VI1PR04MB5903.eurprd04.prod.outlook.com
 ([fe80::c1c5:68b4:ab53:d366]) by VI1PR04MB5903.eurprd04.prod.outlook.com
 ([fe80::c1c5:68b4:ab53:d366%5]) with mapi id 15.20.4975.018; Mon, 14 Feb 2022
 17:46:36 +0000
From:   Radu Bulie <radu-andrei.bulie@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, ioana.ciornei@nxp.com, yangbo.lu@nxp.com,
        Radu Bulie <radu-andrei.bulie@nxp.com>
Subject: [PATCH net] dpaa2-eth: Initialize mutex used in one step timestamping path
Date:   Mon, 14 Feb 2022 19:45:34 +0200
Message-Id: <20220214174534.1051-1-radu-andrei.bulie@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: AM8P189CA0022.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:218::27) To VI1PR04MB5903.eurprd04.prod.outlook.com
 (2603:10a6:803:e0::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f32b729e-a209-4a0f-c042-08d9efe1f224
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3728:EE_
X-Microsoft-Antispam-PRVS: <VI1PR0402MB37289D9E72470C4A42E268CDB0339@VI1PR0402MB3728.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 01DPHE2GVsN3b8YKZXim7yvqUlHgNjZP6CDWGP0NpTEyCrBqgB3w9L1penxQb/sV6KsyV7S4oiBN7s9LnxG/VWIIuWVujCVC0FWQ/3GJ8dMa2PTxkAUUA9fgjtJHm7L3SakA4H76eJQBb9W86jvQQ2UT8BKrAktwddilEA1bE2tMz4TdzUNjG2o40NnNZT4cpEUORXAI81GaaLnYr/T2s0T569TzDOuH4uN8+VIszImWaqLNnT3sGUaHtje+juH+J7nbj43xjQvvQjXbEfanlZgkS5qh63aliVZy54NHSfPnd3btJcDyHPVkk7ousZTwwJ/ojIzmiinNxbGrIRG99i3mC63RIteEpGNYaoqXLxobwXWYAhJUp8Pj3t93mENvWUEmzZ6PlcDixVYVhwjtkVLxSJQzfzAdhc7OQ1qCUDvBLmUUS61VtYudBpRIwAvVS/hypAFvuBBKpOz7Q+nRFLgRrJ+WYn1/7ElAI646k9V/+9W6YjZYDr0N7+cZciS2rIbDApsYOY3FjUTUuo8gfeVtrcT6TNFmaPNWcpeIvIVZ4vgfhl8vWnMZvVdYgsgXi/PgZ/hB7o8ugxw6jzfByKDxdRYyhbEQ4Pio6dPtkE/IvxfPivnuX2GL4pDRJ5F5Sz8vJK39MKu69yHNBwSUGTmKowzyoxgUkehvaAsJmd02OpBGn0AQDWlYCphnML8xn3AjiMo4eEJKeoJHCxP1JA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5903.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2616005)(66476007)(5660300002)(26005)(6506007)(6512007)(38350700002)(66556008)(66946007)(186003)(1076003)(38100700002)(4326008)(8676002)(52116002)(83380400001)(6486002)(86362001)(2906002)(316002)(508600001)(36756003)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/yFbBP/tzAxl4DNGTvzZLVDS7tfFPAary/9eb324TowdZHx4kahU8TRZ9I8P?=
 =?us-ascii?Q?XzDuB+qsQEiHW794CUovxi9mQB3QFEShXomQvF048rBcbdH/pH8GPfdQez1B?=
 =?us-ascii?Q?4lY4cC/SO+nIgH1B+/mieJzlovowbSNiJI4VAAxKOO6uo9H17zc3Yhfv7Sha?=
 =?us-ascii?Q?GSV1d+OfKEqFrv7n21pCVFmEqcRPOkpWDf6Lnr/5Jh8bBAt96bqf97L6v6TK?=
 =?us-ascii?Q?BGH5P2peRgu4JL5NJQC4rL5Z64qxdKt69DFPNJcrr6yFAeHkPjEmRQvj0ge4?=
 =?us-ascii?Q?jxKHAlBPMMxECogXatoQ8CnrHp77dK3SmvpKaqWLmgThzTCs0O3LWU51jjuT?=
 =?us-ascii?Q?LBAl2i8vRBwhcexJrq18U0uzhotz4FKBdgLBc0WE7QIOkwm8WZsKqAADgtqA?=
 =?us-ascii?Q?ST11zd3ibuA8rwqjS+Sc/YuVt2EyeRLmzd+FjUQTyaQdYwwInsnmLg2PKGzj?=
 =?us-ascii?Q?eaIESvzpVmMEd5SSZ8SZl8cH1433rbhvPEYwtBA7xYZqhQP77llgd/58elWz?=
 =?us-ascii?Q?w2V5cqmep+L7sgKhOG9GDmcciDqnT1gpSv2HPZ5Kc2uA747Hw/cgO1kkIoha?=
 =?us-ascii?Q?oe4reLSzGy6exwf9NytuYyN7xFz10IVJ/rYCbR7QO+4ABHtx7/B5VaGob+LX?=
 =?us-ascii?Q?MzNCR864fIwIz05v3ERzpVlef6gP9gXvVCS5bfbw/ddyl81WZiqgf4+qdkRC?=
 =?us-ascii?Q?Rtm/CRHh43Wj72W85Cn9KIzhzAf5waLcuebHW4OZrTzOzl4n1Kc2bNAEm/rZ?=
 =?us-ascii?Q?eg6ec4Nk8YUrBd7/2ePCp5hAGjzZxDCvOAPGfumX9jRDub+IWLrVQlUtfBjU?=
 =?us-ascii?Q?uQ5qJaIkXonTkqs2jX0CysTYQsksL8q2nvH1V6zIK1PdasNHATeTo5C8T+eO?=
 =?us-ascii?Q?yTwmRiYby5exb/QLPq6BHDOq0U5UeNZwCWFxDTHm9G4tweoO0iTvsH53s+3B?=
 =?us-ascii?Q?WAkvj1gXb9QWhVVf4hbgV4/yUMXLaz2ZUHVBdwwnp/65npZSmEjiyqnH6FZ/?=
 =?us-ascii?Q?pUyI9v4HlrvQl0K4zTZ+2pFDTnzleo0V7YqAdJhNDbj+OiI9PBJvjnocRux5?=
 =?us-ascii?Q?dfvD4+1y9ninRdynnkAN4EGxjLXEWcABMqPtSnbIQCyA0FUApLq340po26jP?=
 =?us-ascii?Q?gd+/OQ+w3hkOhFwll/4Iq/P+IKQH2tgjJHcA8n4O1w5IP6M7Z7aydsUBENwK?=
 =?us-ascii?Q?hNVA0JbhQLj+CIyHelBdpTVBmg816dQ5T7B2F70ZXqBoS96p0iEBWFi40yqy?=
 =?us-ascii?Q?GHCE6jceXmip9BSobEv8ybD047nvyFjHI50JXfS5DtSGEMmxfUB/TWcSjGqw?=
 =?us-ascii?Q?OSu6K/QTmb9zbuhZvX5qic/AYGeX8WTB2r9yDvYRk7AOZgOFD8gDUQeWtJZc?=
 =?us-ascii?Q?aVvxrlpCQu4E+baSzPyJDIQKxk+tWGbJ7TYzGcO/k+14DEv5flGYiK3su7va?=
 =?us-ascii?Q?P6kmJovrFo77agW6/uvPUS2NyD2TpF5SKcNEKZVQv5ALhf4NNCxzBMwzBYUG?=
 =?us-ascii?Q?kW7FvIN3XJvxDoz6waWbsXs9AcDNW5h8NLPNYMZSYDxjd71VGcsTE2TXDI3W?=
 =?us-ascii?Q?enhce5KFFYfKcYnTRFuQ5iZGOeo29suk0U8kndNWoVb9s4Bwj7x2rHXhUg7m?=
 =?us-ascii?Q?ZFsx9bfwwUZ/ZPpcJ4jtfyxnsvO5s6XiMgK9x3Oe8eti05tghqnl8ubEoy68?=
 =?us-ascii?Q?26Vntw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f32b729e-a209-4a0f-c042-08d9efe1f224
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5903.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2022 17:46:36.1623
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yDuv0D2eVVcjbZjdZypIbTn1L3w9RX6l/09ZEFOvMOc39PL0P0hB8uJxqP5brILFzCeSphh7bfKqPx717riIBVyVrmjmIFS3dBaQKLF8wIA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3728
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

1588 Single Step Timestamping code path uses a mutex to
enforce atomicity for two events:
- update of ptp single step register
- transmit ptp event packet

Before this patch the mutex was not initialized. This
caused unexpected crashes in the Tx function.

Fixes: c55211892f463 ("dpaa2-eth: support PTP Sync packet one-step timestamping")
Signed-off-by: Radu Bulie <radu-andrei.bulie@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index dd9385d15f6b..0f90d2d5bb60 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -4338,7 +4338,7 @@ static int dpaa2_eth_probe(struct fsl_mc_device *dpni_dev)
 	}
 
 	INIT_WORK(&priv->tx_onestep_tstamp, dpaa2_eth_tx_onestep_tstamp);
-
+	mutex_init(&priv->onestep_tstamp_lock);
 	skb_queue_head_init(&priv->tx_skbs);
 
 	priv->rx_copybreak = DPAA2_ETH_DEFAULT_COPYBREAK;
-- 
2.17.1

