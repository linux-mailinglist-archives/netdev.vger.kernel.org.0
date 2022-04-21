Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4B2950ABBF
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 01:01:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392377AbiDUXER (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 19:04:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1392305AbiDUXEP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 19:04:15 -0400
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10067.outbound.protection.outlook.com [40.107.1.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B536347AC5
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 16:01:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DfbtLkcsZTEIXH/Hnv7GBj0c66CBOpbW+3dmQ0rjT1cZkfmIQ0rLXjcX9ewLNJfKaxv4b7xzTVpstqeZENi9cnUK/KRDmvqcUQJga+uu0HdGbsYyX05DGsikkSrB+2zZ1J81KR5Trl5gRHACH3mVC/hyDB5H8e0ZfW4owmilmnTpA2Lpg4oDYYy1VV2l1ZXhe6k5FZoJwL0ULNX06wieq0ycxvK4GbiCd/agQAW59Gv3QrZoqnrEDh3AxP4O+QEJ4yBvwI0vmSm1I1YKU9HViRzY9OKWKt+S8zMOTvzFpTgZkVxeEam9kaBHEe5GBGhzzdSQ65AIoojvScyWk6dIFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ca9W5G58yyjDYMKK48rLmi93ZNNHpPZmpMLIYLHO4fU=;
 b=PSOR8cq52l1Evui7KOeAcnBoevoygtMZhfh3SHgEW7/i+TRzqoWzBy3OmR9fqRBcuVCvv2pB1bEOQedE2hDEcAdjBXGXmtLAigpL6D3fiGfw2XiYzc7D7mak7KZmRXaa6o1H1yQ9gAFv8VCtZZzC/jK2VcOqiedtYXEQNV7d9G2qBOU2aXSNoYih9wnmO6g2m/sLZa5pXMbhDEpNu+x9MqaBvwjfBI/om1OE2KQgOnb25T53MJfP8cxyRbNk/hWnmetV+2Oo3Naj0LKAY/eHZcqqupSaCulhaxZpyZc7rc2Du5LtpOGLeRXqRBnMEjXv/9ev84Oz0/Z+TtUMxfxZNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ca9W5G58yyjDYMKK48rLmi93ZNNHpPZmpMLIYLHO4fU=;
 b=Av5cY8+prWiG5odYDnlo5cMu7bHQorVi/N9Cu1zyho645tbkc83UJi63XijJYGczITv3KV29EsqEJ4Uc4918a0bOiTKqDkqbLncne/2tb4RhNZAgB6yfJa5Urfg+BAT+4N7mNv3rDM11Sy7RMiBJ+j5bZOqErhm+43Flvs+uX7Q=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4077.eurprd04.prod.outlook.com (2603:10a6:803:4b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Thu, 21 Apr
 2022 23:01:19 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e%3]) with mapi id 15.20.5164.025; Thu, 21 Apr 2022
 23:01:18 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net 1/2] net: mscc: ocelot: ignore VID 0 added by 8021q module
Date:   Fri, 22 Apr 2022 02:01:04 +0300
Message-Id: <20220421230105.3570690-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220421230105.3570690-1-vladimir.oltean@nxp.com>
References: <20220421230105.3570690-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P195CA0081.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:802:59::34) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c055d836-a319-4f12-9557-08da23ead868
X-MS-TrafficTypeDiagnostic: VI1PR04MB4077:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB4077A1CB330A2DFBFDEEDAE3E0F49@VI1PR04MB4077.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CptxqNas8xG/2zwDOiS5WOXsZ5exOY3uy+XL1b3Jfx+GB9SExNjECKCoG1Mqzr0hfk4ei5XRg3/6OTYzegTzu8PLqxrsLgqeU/ZxBIzU6ezRAokPO2uRK4g6PS6V0+gNHUjCC8J0eYt8geyhDG8yj9PgOIAnVOC2pLJluv0tiF9vIxrb9Rqkvm4uaUB4zC/7k44hxT3FWL5ag1HVmJrAWrSnpXZoJ28JDPbgffYJ/AM7Abm28NZEGUfGdDM+Zecy8PWtdglbSveEn/pSv9GvFyHxQmx1xKFI2KSXple67d7Xe0YV5sV9H7FH8BssVASl7P1DoIE6LhOTA7R2YiXURJsdi7e2cXrk5KH3nZRJg81bawUGzPeozINSAFQ1rq0nRJ+rEJX1mfoElenN6Q7iCpl3VUINqHP5GLNRLPi4RefRfxQFZ0LnsxRj09Y2nAhJW7SnxOMPRWjkUOnno+HMds93NVaeFNYK1RSepiB/O6EN4sb2W/4aIwPKXrJ5a7AUiRnTkE+acT2LsVUt11WgPz9O2RvBjqMO4IUBdbmJthAheI43f0ZG9kuyojaO/Jvecr7c0Vbn6eZC35HzT6yn0KTlxAEkdDEVgOydcb03TKVkmFQie17Ofwg6WWitSE2Z4jU4mQ++GYS1OaRDP3UtfeTmxVkVcl9AHkP0Y9rodj+Y06cXQD/7liffvpyEM5t1wIFYjrmudwdgfmDpmPfbRw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(83380400001)(66476007)(66556008)(66946007)(6666004)(6512007)(6506007)(26005)(2906002)(8676002)(54906003)(4326008)(38350700002)(38100700002)(508600001)(186003)(1076003)(2616005)(36756003)(44832011)(5660300002)(6916009)(86362001)(52116002)(316002)(8936002)(7416002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EyM3qVLeRFd2glGkWs5UURaCJv8btN8YXhi41gJ0kj6zy4yQ0cNwhdY+NMGE?=
 =?us-ascii?Q?CYYjSALRQgONTDcyZSHQ0kYMggUwWqmle2ICixu7Se7TW5h8oy19OROTzwTc?=
 =?us-ascii?Q?Ee40Wc2TYyVuf9c37hqZvoOLBdFbPKQIDmzd5LnXeNhkALS8+hTq64ydpJI0?=
 =?us-ascii?Q?6ZCzxknToL1O/BMCgTfmlX6ppYcFrEgPi10tMkxUWq4u0ATCANgzlNOuByaO?=
 =?us-ascii?Q?+vBc4pqXsTyIN8f2IXHPooQoIQP3d7rqdCqkLSPyCnMqC4qhEvIOjNPQJ/o/?=
 =?us-ascii?Q?Qaevo2qHqicZYSveLQCX3uQ9EdP239grLxX5AMyzmx81Z02YdyDSh6syqlCB?=
 =?us-ascii?Q?j4U9AOJHtE6nwOZei5+Lg9G44nyScOrxtL0XyEB9U72oQ65Yog1z7chn0uWe?=
 =?us-ascii?Q?0CKxKF5tMRYgh50yG2uAhaqgHoC55oi5GXUETQeZF5b5HF+kkpd75Y2zDRCo?=
 =?us-ascii?Q?LeDiqzwLeg1DkzqK1xh7hE3eibEAQvqIk4mk9qeeCDBuNYo3YrIIYgMAHOIu?=
 =?us-ascii?Q?Ol8svmOMFy7rWHHL602slNOJWwmfSW5JFoH0Foh++/su7jeS4BiqaelastHg?=
 =?us-ascii?Q?HkuMK7jYCtiAMQ6zuLncxyEo0u3JysqqkNWJzBKZVX+kZpPM+XYKFU/AFnxp?=
 =?us-ascii?Q?h1CC/UxUjIYJCTWL30bjgdg6cj72HpCB/LV21qDLrhMArw079vGqfBCFkOfa?=
 =?us-ascii?Q?QHLtyABRTphXZ3HBOZUOQXcPWJ8oqny1NToj80w8mBZpp2DzJA1hZOhn8hY+?=
 =?us-ascii?Q?GXFOCF+gbUF4uo+7vHuk6vFPvV89904S9ES387eg3sa7JD3mt3AWVHwqFaFQ?=
 =?us-ascii?Q?EHvwElrcayLrPq6nmiWmA+OmD0S+csY/muOdiGD3j3pRc/7kNG3re7YH3+R4?=
 =?us-ascii?Q?76GmUX2uByTpRLJgeME+rIsW+zV/yHcdQepjQgbJ6Yv9W8zK5xrU+zgJh+Nd?=
 =?us-ascii?Q?GVbzuImpe4ueIuHDt5rhCy395PQZmmqepWWC0ah8zy0DQz/Kn9sI13ieF0VO?=
 =?us-ascii?Q?0bb/xzyXtLCciLJXM3bj3wZcKiiifX3Xe1qTbcWOoPgDcfS2ivLw0OObP9ks?=
 =?us-ascii?Q?mhMpfANfwk3MYypgINIXPM7inG++nq0W4JAqlux20+jRCuIqG400pxAqI5Oh?=
 =?us-ascii?Q?L1Im0u8TQXlNJZnU5E1oaNKRr9yK+/Rnya3mGfzuE2SVSLV1ipiz/QJdMgt+?=
 =?us-ascii?Q?jqP1wuTqe1BgwuPTXW+LcC4kjnY/+ENqSii9vdnegVobzC0dMYxStjJwyrV8?=
 =?us-ascii?Q?mNosxW9SUcpx3fwkQh4h1gCyvCvANvLad7U3aM3y7sTyylNQSe/v2t0pIyo6?=
 =?us-ascii?Q?KHC7o7perKOi0HCLKoZ4xcHmfyshQ3rfMHOG8fm78nKbhI9rrNtFiWCni2uq?=
 =?us-ascii?Q?VtlGnbUCtDDmx2+bIQHd4ox1VVuwy/pQZGYqC9bYg916aGtz1FUyvl9Jufk6?=
 =?us-ascii?Q?td9HHvUyA7scCC6Z7j5qT0ee09il21PkQeBewxTBDayiPXp3y9BgER3LuMI5?=
 =?us-ascii?Q?sy+mBfRbJTTWf01n1CNvGzMUlZUaWX8DXW3Q+v5fPfeOkRZMS8/X3qGGmKTk?=
 =?us-ascii?Q?y1WujF3wYZxzhlhAau4kv/ncmlmz7Fh7eL3NGekbHLAOtHHNP547wvMlv9BP?=
 =?us-ascii?Q?UMDVVZ1zyjV+n9F9WlVIiaFUgzOHIKujsrrxurvIaVZzfBnMID6z6dkaurHJ?=
 =?us-ascii?Q?BzI4fNC7ac3ILSiBmeSKORHoNJGyOxe/hFbojTnBZO/Nl5Baf15XpziteBtf?=
 =?us-ascii?Q?gYoeBDiWP7rvEz6WMuvuG8thuNM4gkA=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c055d836-a319-4f12-9557-08da23ead868
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2022 23:01:18.8585
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CQBC3H6Hbt+98zpF5+pgASU2ipLTvYhkRYafvRAgZwz4+ZAiK235ciAXqUWd9VfnfyFoZa+dD95+FOd6yVcUUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4077
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Both the felix DSA driver and ocelot switchdev driver declare
dev->features & NETIF_F_HW_VLAN_CTAG_FILTER under certain circumstances*,
so the 8021q module will add VID 0 to our RX filter when the port goes
up, to ensure 802.1p traffic is not dropped.

We treat VID 0 as a special value (OCELOT_STANDALONE_PVID) which
deliberately does not have a struct ocelot_bridge_vlan associated with
it. Instead, this gets programmed to the VLAN table in ocelot_vlan_init().

If we allow external calls to modify VID 0, we reach the following
situation:

 # ip link add br0 type bridge vlan_filtering 1 && ip link set br0 up
 # ip link set swp0 master br0
 # ip link set swp0 up # this adds VID 0 to ocelot->vlans with untagged=false
bridge vlan
port              vlan-id
swp0              1 PVID Egress Untagged # the bridge also adds VID 1
br0               1 PVID Egress Untagged
 # bridge vlan add dev swp0 vid 100 untagged
Error: mscc_ocelot_switch_lib: Port with egress-tagged VLANs cannot have more than one egress-untagged (native) VLAN.

This configuration should have been accepted, because
ocelot_port_manage_port_tag() should select OCELOT_PORT_TAG_NATIVE.
Yet it isn't, because we have an entry in ocelot->vlans which says
VID 0 should be egress-tagged, something the hardware can't do.

Fix this by suppressing additions/deletions on VID 0 and managing this
VLAN exclusively using OCELOT_STANDALONE_PVID.

*DSA toggles it when the port becomes VLAN-aware by joining a VLAN-aware
bridge. Ocelot declares it unconditionally for some reason.

Fixes: 54c319846086 ("net: mscc: ocelot: enforce FDB isolation when VLAN-unaware")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index ee9c607d62a7..951c4529f6cd 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -629,6 +629,13 @@ int ocelot_vlan_add(struct ocelot *ocelot, int port, u16 vid, bool pvid,
 {
 	int err;
 
+	/* Ignore VID 0 added to our RX filter by the 8021q module, since
+	 * that collides with OCELOT_STANDALONE_PVID and changes it from
+	 * egress-untagged to egress-tagged.
+	 */
+	if (!vid)
+		return 0;
+
 	err = ocelot_vlan_member_add(ocelot, port, vid, untagged);
 	if (err)
 		return err;
@@ -651,6 +658,9 @@ int ocelot_vlan_del(struct ocelot *ocelot, int port, u16 vid)
 	bool del_pvid = false;
 	int err;
 
+	if (!vid)
+		return 0;
+
 	if (ocelot_port->pvid_vlan && ocelot_port->pvid_vlan->vid == vid)
 		del_pvid = true;
 
-- 
2.25.1

