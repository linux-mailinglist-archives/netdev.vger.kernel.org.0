Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BCFB5675D0
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 19:32:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232965AbiGERcV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 13:32:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232838AbiGERcK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 13:32:10 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2042.outbound.protection.outlook.com [40.107.104.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0DDA6308
        for <netdev@vger.kernel.org>; Tue,  5 Jul 2022 10:32:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DYDD2x7Rjeb29BkQyqJsnSNu4ijsSv2FsMHCb8bg5J1GYnHtHUSur2WjCZbnToQxK2zaZrpRDhQ3lo4jq/aeIkyN/OvF+SRseSJQK/1RlT6nm+8/zN1g2/kyUGxyxHRu0t3m6ymIybvMhewlj+zCyOI4VuRCtZrWMPFd3q04/zEsBbbWgZJjJeFHEOxEAEBkcjsXLXA3fmYmTAUD21zrRU4v4chxEbQ4baRPQLpFRzEduJVZCUAfZhMtyHXgZvMD5Ik3PbTQX13b4iJtnimoyyrJJAi0GReiugt/uj6xuTWTWBbPpaNHAKwqhLZPFg4Wg69EJVzvTo86akSiECG7Xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C/1OnXauW0P3u4PZn/kUNVh2wOpW8JUD5DKFxCxTSPs=;
 b=PIdPJUhTamdr0ezWg+2+DiPV4QNFMhjMpkuehoDryQxa3zTdAbqojkJubVL/tsQEGUsbTYQAeQvTxh5aDApBUMYziG/iOE+R9tSdDvLEQ5AP21jL/0FuOc6J44zXQIr4/YOXhznDqJRApAk9mkxsiSIKQM9D8h63xCMBFcXOXorhJF26Pj/JJtivq1wjMtyYIuWwllz7xf73/ai78shL5QHZX3M7ITNq9iWw1sEx1b2hdWECMN1FVDEQnpPekQlJ4uZFMHZBgCXSXq53+h/9qQPIvPO5VDL5z1Kbf3g9WyDKLJIV/eg2Ofy6BWymLfpRCuVni8eOP/jbyvy9qyHVUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C/1OnXauW0P3u4PZn/kUNVh2wOpW8JUD5DKFxCxTSPs=;
 b=A5n1l3E+/oF+wRU+Kqlpkfh9MycO8jiM8AQGJddcXsUc5IDXFmxPBL2+o6DiZjCIxkFQr9sCi1IwfqVctDryjYequwTtbeH5iqrwTOcOxQA9nqTXcA3ub4cRd7jEwnZDSODdY7jWQS5WP+gPmZwtwUSB8pc38wsHVddTvlr6Ns4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB7PR04MB4251.eurprd04.prod.outlook.com (2603:10a6:5:28::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.21; Tue, 5 Jul
 2022 17:32:06 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5395.021; Tue, 5 Jul 2022
 17:32:06 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Petr Machata <petrm@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [RFC PATCH net-next 3/3] net: dsa: never skip VLAN configuration
Date:   Tue,  5 Jul 2022 20:31:14 +0300
Message-Id: <20220705173114.2004386-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220705173114.2004386-1-vladimir.oltean@nxp.com>
References: <20220705173114.2004386-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0057.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:4b::8) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 40b662cb-1b7b-45b8-7349-08da5eac4851
X-MS-TrafficTypeDiagnostic: DB7PR04MB4251:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jGD+CU9J7MZQK7jueOQ5JM/Wl9GOgTY3J22OesmGBx5tnDcb30Ub4wNMdUDc1r+A0mb9+2/cwF+USbrSBOldTXPRoQ3BhBzDnE+x7iIQpllqPNBVMp1uao0H2/HlRYlJmK+fRIuJT76e5mo8zWS+iQxOcLme1d4CY5X3OZB8ij/GWMhWnhWaV/+xq3mCD7r7AVet2EnBHI2t8addwb/AxzFvN1TtkWmLvURzR0sbXkjWrFt+xT5FLluYPl9gt15kJiXN1HGdtRkrNtHNjKed0cD8quNy9TLsWrcsuMvLhdwRLURWMISiFbwyRiKJfjCnPuZZV3wVJvqVZjxCWdCXt6OMFsHuXvxgX8o7KdHkFapViBioq4cCYgn3iYzAlOPl3jNdW+PNEBVshGhMBp66I28i4rLsG4F8hSCPkvUYXZIdf4dfq7rwInKp71I8sZEoIMu3aqQejiyNXpvGx0Jh4QOOjewiOL9ameYOT1EZVCQaCVKJGhOkAX44GofH1LY9nZEEbQkQ4IJIF5JXnWelpb2iZ7RYhpcyKTWd2Gq2MapJQgTkilqW3STbC9aMRiX525cGOOzMqDBEzICzZkQuXmhS3neqc5I60n4c09IzKjTX0vNEuSm1vzsY3dFKvKEn1+8Z2j3fOFsWRy0u0mg9cU0hznr91SGjJ/8aaqqk9X7bRBeLK2lAhdZmeNcrKyNMiBENxg8L8WlJ8xIN/81VxUBBgb0TzcGJXsTL5qxcJghT+g8zQu52TZipfOLDMNco7xQtCojFCLA80sc29GgUds3DYgkmpZ2pHvVL3/d+Ka9z6ZIDpiXueQ0cdI3s0pa0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(396003)(366004)(376002)(346002)(136003)(8676002)(4326008)(66946007)(66556008)(1076003)(478600001)(66476007)(6486002)(186003)(6666004)(52116002)(6506007)(41300700001)(2616005)(54906003)(6916009)(83380400001)(316002)(26005)(86362001)(6512007)(2906002)(38100700002)(38350700002)(36756003)(8936002)(7416002)(5660300002)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KOWNoKuy+F50UMj2TW5tevseOGQCmFFt3Xv/91euwr7w0zGO8ozKdiPfL/WX?=
 =?us-ascii?Q?asqKby87CHTO4OCHg7+yTGw94qWZ3i+pkKSV1CXt7lsH2wdFrCd74Wy3Rv4K?=
 =?us-ascii?Q?gszrCNDilXKnnCxAJYfsojJIcHT94H+0zLagd2ZRxu8DqXCO0F9k9o1uD11C?=
 =?us-ascii?Q?q2F7Ux9ObSTDpOhIEfJLQSrBDEraAdcjeEd56go10l8uHYGWIC3TYWYov6fm?=
 =?us-ascii?Q?wFVxd2PnvVuUwsKwFKcumIdiIJnIsbNrlIRQ3+nqwdplwglnxOyAfUWi+KVB?=
 =?us-ascii?Q?VN0b9Lv6YN8bt23FbH8d9Z4eDoJc/F7JkVyOBjXuSWscKxL/pTMeWwkLcjb0?=
 =?us-ascii?Q?MjQLZOe/CUNauBhwe4kWXnoLC8geBv1Eo43oCdCRE+0KGp/u3CDIooI66vS+?=
 =?us-ascii?Q?1sRKOHVWjrldt+jQRICSSvXvILtdACsDIvPLJ3D0hdKGTfAI+jg4c8Jxnvjc?=
 =?us-ascii?Q?AlfOC8VVPvLToozYx5ONX/DELebKQfngnDCOwOA7TGfZUZ0lpV8NrLt09apH?=
 =?us-ascii?Q?qwZszMSYfF55vEvApx0pB8WabmqXbHYBuFbRCHpQ7po/jFnN59V66OnYUtbg?=
 =?us-ascii?Q?XmoDqufh/wzFF2j0HIboCHOf286kttaYv2TyWRQI+KwGNGQ+BC1wyvlbLM9W?=
 =?us-ascii?Q?eRmkybxvNukFsFjoZgaM6pDTnTtCB3IQWJC1KYdImBWSMumnP3S6LKy0DAy+?=
 =?us-ascii?Q?jZarwVxbXVU3fuZzrV2/1f3bWC5IqCSF9RbAJM+Zu5UX8xmxSKiEaEzok0xl?=
 =?us-ascii?Q?FoOX/7MxZwS9yi64nLNH8YjeWGGsbuUZYYxqHP8j6Xe1G4TnaZvJ971okPCf?=
 =?us-ascii?Q?GfdQ4EXsTGb7oCOQeA1pVF4gGDFB02vyOUyo/ykQ3wIPhTTC70T/quyn0pYh?=
 =?us-ascii?Q?sIsEFfrX4ALKWRYzxG6zUujgm7MY5xGYAY1Zcba/OBl6plv4fJw9tB9KJoF1?=
 =?us-ascii?Q?pzufCWxQh54GlxwOvhj99BKga3KJ7x5SM5ItUe3M5nCDdgjH/OF6Z4fx5Way?=
 =?us-ascii?Q?xil8qSBYFL9ULU0d1AuCKNMC7bDpRBcW8T6wPOHWy+DaPolrhF7FrLfsqGGw?=
 =?us-ascii?Q?NKhIOXe4HhGSRPFenvguCUJyM0YjDI1qoygsY7Lif2+kKfuYd+7BS8wQxc6f?=
 =?us-ascii?Q?aEayuv9vzfddkhGCv6j6PfpBRuwguIZUlDd3ZlIN2Az/M5HQGJ0tX7Dc2AMH?=
 =?us-ascii?Q?TnFvjdxsl+vFD7mlQrLmQpD7n8g/WJGp3hVingewtJNHEH5A0G/QWi83d2vZ?=
 =?us-ascii?Q?FC+Rhiq6leRIgejgJdNfTojfiqCDNjvaYpe5gHOFHjP/Fh5KA7es/u5CuPU1?=
 =?us-ascii?Q?zB+h1TFh3+KPnuWJtg3UQwqcL29aVufFTZxIEIu4tUPB3o5hRv4NV5U/y02B?=
 =?us-ascii?Q?jBIH0dq7S/hdYVXyJM0NzEUCr3LNI5YQxWD+ksq3YQS7oc7iYsSdWEk6xXaJ?=
 =?us-ascii?Q?JmGNHJu1cEdzbmy1L/AcXXptDZlbsgvXLigb3AS4V8uBtk9u5N7v9sE8w7r/?=
 =?us-ascii?Q?6HvgmJUNo+JoGzzsetwXdXPPhDtSXqAqVeI6/B8nYjjsyEib851fKIAMK6dO?=
 =?us-ascii?Q?SX5K3tQJzqDTzzZEyQKFhwtJtDmMdkRvLOk6k8FqyV06qh3N8X6s8ba/Sgj0?=
 =?us-ascii?Q?dw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40b662cb-1b7b-45b8-7349-08da5eac4851
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jul 2022 17:32:06.8748
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B9uO1hKWE7pJqYCNLtHmrgS53lsg2KfsOWeqqKKK6PEvc9JPr1vWkAsuNl8Z7ZN1iCZMBayIpSGTQ2+KKj7lnQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4251
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stop protecting DSA drivers from switchdev VLAN notifications emitted
while the bridge has vlan_filtering 0, by deleting the deprecated bool
ds->configure_vlan_while_not_filtering opt-in. Now all DSA drivers see
all notifications and should save the bridge PVID until they need to
commit it to hardware.

The 2 remaining unconverted drivers are the gswip and the Microchip KSZ
family. They are both probably broken and would need changing as far as
I can see:

- For lantiq_gswip, after the initial call path
  -> gswip_port_bridge_join
     -> gswip_vlan_add_unaware
        -> gswip_switch_w(priv, 0, GSWIP_PCE_DEFPVID(port));
  nobody seems to prevent a future call path
  -> gswip_port_vlan_add
     -> gswip_vlan_add_aware
        -> gswip_switch_w(priv, idx, GSWIP_PCE_DEFPVID(port));

- For ksz9477, REG_PORT_DEFAULT_VID seems to be only modified by the
  bridge VLAN add/del handlers, so there is no logic to update it on
  VLAN awareness change. I don't know exactly how the switch behaves
  after ksz9477_port_vlan_filtering() is called with "false".
  If packets are classified to the REG_PORT_DEFAULT_VID, then it is
  broken. Similar thing can be said for KSZ8.

In any case, see commit 8b6836d82470 ("net: dsa: mv88e6xxx: keep the
pvid at 0 when VLAN-unaware") for an example of how to deal with the
problem, and test pvid_change() in
tools/testing/selftests/drivers/net/dsa/bridge_vlan_unaware.sh for how
to check whether the driver behaves correctly. I don't have the hardware
to test any changes.

Cc: Arun Ramadoss <arun.ramadoss@microchip.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>
Cc: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/lantiq_gswip.c         |  2 --
 drivers/net/dsa/microchip/ksz_common.c |  2 --
 include/net/dsa.h                      |  7 -------
 net/dsa/dsa2.c                         |  2 --
 net/dsa/dsa_priv.h                     |  1 -
 net/dsa/port.c                         | 14 --------------
 net/dsa/slave.c                        | 22 +---------------------
 7 files changed, 1 insertion(+), 49 deletions(-)

diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
index e531b93f3cb2..86acf8a4e53c 100644
--- a/drivers/net/dsa/lantiq_gswip.c
+++ b/drivers/net/dsa/lantiq_gswip.c
@@ -893,8 +893,6 @@ static int gswip_setup(struct dsa_switch *ds)
 
 	gswip_port_enable(ds, cpu_port, NULL);
 
-	ds->configure_vlan_while_not_filtering = false;
-
 	return 0;
 }
 
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 28d7cb2ce98f..561a515c7cb8 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -927,8 +927,6 @@ static int ksz_setup(struct dsa_switch *ds)
 
 	ksz_init_mib_timer(dev);
 
-	ds->configure_vlan_while_not_filtering = false;
-
 	if (dev->dev_ops->setup) {
 		ret = dev->dev_ops->setup(ds);
 		if (ret)
diff --git a/include/net/dsa.h b/include/net/dsa.h
index b902b31bebce..2ed1c2db4037 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -400,13 +400,6 @@ struct dsa_switch {
 	/* Keep VLAN filtering enabled on ports not offloading any upper */
 	u32			needs_standalone_vlan_filtering:1;
 
-	/* Pass .port_vlan_add and .port_vlan_del to drivers even for bridges
-	 * that have vlan_filtering=0. All drivers should ideally set this (and
-	 * then the option would get removed), but it is unknown whether this
-	 * would break things or not.
-	 */
-	u32			configure_vlan_while_not_filtering:1;
-
 	/* If the switch driver always programs the CPU port as egress tagged
 	 * despite the VLAN configuration indicating otherwise, then setting
 	 * @untag_bridge_pvid will force the DSA receive path to pop the
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index cac48a741f27..47a2e60b6080 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -890,8 +890,6 @@ static int dsa_switch_setup(struct dsa_switch *ds)
 	if (err)
 		goto unregister_devlink_ports;
 
-	ds->configure_vlan_while_not_filtering = true;
-
 	err = ds->ops->setup(ds);
 	if (err < 0)
 		goto unregister_notifier;
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index d9722e49864b..63191db45d02 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -224,7 +224,6 @@ void dsa_port_pre_lag_leave(struct dsa_port *dp, struct net_device *lag_dev);
 void dsa_port_lag_leave(struct dsa_port *dp, struct net_device *lag_dev);
 int dsa_port_vlan_filtering(struct dsa_port *dp, bool vlan_filtering,
 			    struct netlink_ext_ack *extack);
-bool dsa_port_skip_vlan_configuration(struct dsa_port *dp);
 int dsa_port_ageing_time(struct dsa_port *dp, clock_t ageing_clock);
 int dsa_port_mst_enable(struct dsa_port *dp, bool on,
 			struct netlink_ext_ack *extack);
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 3738f2d40a0b..79853f673b65 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -834,20 +834,6 @@ int dsa_port_vlan_filtering(struct dsa_port *dp, bool vlan_filtering,
 	return err;
 }
 
-/* This enforces legacy behavior for switch drivers which assume they can't
- * receive VLAN configuration when enslaved to a bridge with vlan_filtering=0
- */
-bool dsa_port_skip_vlan_configuration(struct dsa_port *dp)
-{
-	struct net_device *br = dsa_port_bridge_dev_get(dp);
-	struct dsa_switch *ds = dp->ds;
-
-	if (!br)
-		return false;
-
-	return !ds->configure_vlan_while_not_filtering && !br_vlan_enabled(br);
-}
-
 int dsa_port_ageing_time(struct dsa_port *dp, clock_t ageing_clock)
 {
 	unsigned long ageing_jiffies = clock_t_to_jiffies(ageing_clock);
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index ad6a6663feeb..d1284f8684d8 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -533,11 +533,6 @@ static int dsa_slave_vlan_add(struct net_device *dev,
 	struct switchdev_obj_port_vlan *vlan;
 	int err;
 
-	if (dsa_port_skip_vlan_configuration(dp)) {
-		NL_SET_ERR_MSG_MOD(extack, "skipping configuration of VLAN");
-		return 0;
-	}
-
 	vlan = SWITCHDEV_OBJ_PORT_VLAN(obj);
 
 	/* Deny adding a bridge VLAN when there is already an 802.1Q upper with
@@ -571,11 +566,6 @@ static int dsa_slave_host_vlan_add(struct net_device *dev,
 	if (!dp->bridge)
 		return -EOPNOTSUPP;
 
-	if (dsa_port_skip_vlan_configuration(dp)) {
-		NL_SET_ERR_MSG_MOD(extack, "skipping configuration of VLAN");
-		return 0;
-	}
-
 	vlan = *SWITCHDEV_OBJ_PORT_VLAN(obj);
 
 	/* Even though drivers often handle CPU membership in special ways,
@@ -642,9 +632,6 @@ static int dsa_slave_vlan_del(struct net_device *dev,
 	struct dsa_port *dp = dsa_slave_to_port(dev);
 	struct switchdev_obj_port_vlan *vlan;
 
-	if (dsa_port_skip_vlan_configuration(dp))
-		return 0;
-
 	vlan = SWITCHDEV_OBJ_PORT_VLAN(obj);
 
 	return dsa_port_vlan_del(dp, vlan);
@@ -660,9 +647,6 @@ static int dsa_slave_host_vlan_del(struct net_device *dev,
 	if (!dp->bridge)
 		return -EOPNOTSUPP;
 
-	if (dsa_port_skip_vlan_configuration(dp))
-		return 0;
-
 	vlan = SWITCHDEV_OBJ_PORT_VLAN(obj);
 
 	return dsa_port_host_vlan_del(dp, vlan);
@@ -1655,11 +1639,7 @@ static int dsa_slave_clear_vlan(struct net_device *vdev, int vid, void *arg)
  *         - no VLAN (any 8021q upper is a software VLAN)
  *
  * - If under a vlan_filtering=0 bridge which it offload:
- *     - if ds->configure_vlan_while_not_filtering = true (default):
- *         - the bridge VLANs. These VLANs are committed to hardware but inactive.
- *     - else (deprecated):
- *         - no VLAN. The bridge VLANs are not restored when VLAN awareness is
- *           enabled, so this behavior is broken and discouraged.
+ *     - the bridge VLANs. These VLANs are committed to hardware but inactive.
  *
  * - If under a vlan_filtering=1 bridge which it offload:
  *     - the bridge VLANs
-- 
2.25.1

