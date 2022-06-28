Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1629E55F13E
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 00:32:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231295AbiF1WRq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 18:17:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231487AbiF1WPi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 18:15:38 -0400
Received: from EUR02-AM5-obe.outbound.protection.outlook.com (mail-eopbgr00064.outbound.protection.outlook.com [40.107.0.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3611937AAC;
        Tue, 28 Jun 2022 15:15:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bryx4hkifV5M8ISJS20QRI2ZVdgv2xjXNuWtT0QdjHJ8Os9wVrAXeauYaAxM5wmzwe7hYAaEnI15yshrSNrPOx7XVdykbNPiwXyUV0gWnmOgZnVZGYsfOgI2HCkIMSiAQltqjk3DIfeSZoWJqiZ7RSk93wv1LxvxMvgAXksVkAB2zTF7v0AEVVl3TorDmy6fCSanUt7OYlagdFu3E506aPkbLuc6xmI759vR1mW3W5drHOBXWZnHzpDY6zvTNzUGJGwaeCraneIxFB9oOoFBLhL9nuaXOkHphAHLomRCUqdxQ8SCL3+oEFl/YTyIawBybjcLybaVbpxjeX6Lew3OMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/xrnQ3BEPKqzcOGdsEl6PELVzYS8aCEaVWAk+Xtejew=;
 b=PA6L5arZ4WKG4s56IW/1ubKZS/1fS4cGhMZNOOs9X6RikXNQ9AeogR1MEWJ4VBqmYkn33h/wVo18n4KjgfB17KoEBJE/fMNE3sY7/Mevz4cp+qRohTbeXogpK3MII9z/pHGpO+bW6ilUOwG+J9H9M/E6WcIqJw5JWh2bX5rbl0goL/1r7zJviv+JhBJAWEuSJCgGHUpoaloV2r3BuKZ3TreAzitGMB12/w7sV8aBoUMs50Y8LCE3/NCMUFBExdZ6YK2nGFGx4lQBeBXdCaHl9w+P4L1OZF3FxF4zfC9FzsALaUX28PGXT5NMomWN77Om4nVUaM0mCCknCczqJ1m6rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/xrnQ3BEPKqzcOGdsEl6PELVzYS8aCEaVWAk+Xtejew=;
 b=lZG1AznNsi+zSPiZptz1IgRTdGv8piZq8YH3Qan3Briy9yu7Vth9Py0TU454Erq57NT+T1zr703BH8Ps8S4tRbHrFOO2FsPt32ONJuF5PUJvQAneLCThlUL6w0SJdvQXJj2PZd4gMoHk4R9X0HFZgP6YYxijXKlU8Ux0LpiDgoIjcM67rOOavj/srHXWrl+g8hpA3S+Vpf9pYOVn8Ht6j3MuROHbe0vdvGnV95ofoEfGKiKNMEaYgKNMZLHxafQpiovzd7uqbvjBSvXOEWXgknrnI1pDwvnnZA3Wsn4nbWdpoMojj9LTJbt+o4AvVi0IRUIy9NRxuwdVVjhSEAGwyg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DB6PR03MB3013.eurprd03.prod.outlook.com (2603:10a6:6:3c::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Tue, 28 Jun
 2022 22:14:53 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1%6]) with mapi id 15.20.5373.018; Tue, 28 Jun 2022
 22:14:53 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-arm-kernel@lists.infradead.org,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net-next v2 22/35] net: fman: Specify type of mac_dev for exception_cb
Date:   Tue, 28 Jun 2022 18:13:51 -0400
Message-Id: <20220628221404.1444200-23-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220628221404.1444200-1-sean.anderson@seco.com>
References: <20220628221404.1444200-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1P222CA0011.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:2c7::16) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 234d29c7-080d-4a21-0803-08da5953a061
X-MS-TrafficTypeDiagnostic: DB6PR03MB3013:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pomTAVfWZaP2tTQp1hDuFiywkiRCgz7NryvBh4WUH++vDlJbxCZWDm0Ty9UkXpomPICEzzi18H0EFM1cENfHbvTg6HKEzySQc3D/KDRgcJMJiTc/45MdouMkbuzUVIHYxGxFv4pB5mdegEnrCRb0njBRlFIH6jcXhl2nHtvlRaupwCw/uiwe+GDKC3mGxPqu49pg8VG3U39KUU0LOwy6vA/KFxxj7xE2WhuJPAsdLlAy/tM0vnY/UjiH15tuHF3OnHgKrxtJ213Yh+jwvuaS3VBz563Fp9tXDFCHm5sniSK/WOymzR1ZjIEpd2ZmZ3HT/fyZZiACiqWa9RrrAHfJct2XvJFMvRElbSBlpcJlL+7IQCSRo5LQ8mAYaXrDtC64AIXJVKHxtUdMSCB5nl0eTHwqZ9FD/qbP63wN3DJTPwB28s3OG4eY/wTCGbExF3xbpKq5pSiUy3DDS4fvm13wvEcluURO6WbaJot4t6fWKslfvTubQvXDnjZklyhhIIHyMxAUHOHd4vcyTjtrKTWZPGMLURRcr9emrBW8MD32LqxrEJe8DkIxUxIsuBy46RcbMmOPUnuXHq3WWh3i3SKDsBqYeAvOegb6AKo8isYur2Y/WTPos02bjWNNN684dlXPlCWPRi/FkzNqFONtrcuZENsZmBESUrJVtJsttMYnvgMwWAOQGRExD9EqLS670SrPSTILuJpLE3UoJU2KiUIl8uc11uMNTlcBY4Iz5PZWKw5yIvdzWA3DehUJWgIyWX7EkLU+ajSr2OUlQ3xD7WB4z4uz/YHU6jwkB+mC7YXZDls=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(39850400004)(376002)(366004)(136003)(346002)(2616005)(41300700001)(26005)(107886003)(1076003)(66946007)(8676002)(6506007)(6512007)(52116002)(186003)(38350700002)(83380400001)(44832011)(6486002)(8936002)(66476007)(38100700002)(2906002)(66556008)(86362001)(5660300002)(54906003)(36756003)(110136005)(4326008)(316002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cTA2YzKMvdkAARbTryN1OOfFGpPmZKty2rFnfRGZbXp0wD8sXdjwIZsBz5vm?=
 =?us-ascii?Q?gm/2/banswrp2IOAZURf+yYCK3+NCK6LKyH4fEFcEBQRbNjoHS635aDuIl0+?=
 =?us-ascii?Q?/xJ5gbDXHb39Yc1wTJZdTuwgHFIGbOyhMXy5orfTUB8caV/cWMzopruuekpY?=
 =?us-ascii?Q?mhTITQO0PR67o7+89pZg4zzBgTQIvdEAesoniX6PfBxB0rrWmeus1jN6x/HT?=
 =?us-ascii?Q?ws1mBqRqPaQ6aF4H0sZ3OR3PKv+KCRKBc3SFZawltuxu0GDG51zAGNPB3AUc?=
 =?us-ascii?Q?jU98wL7C6KIaBubkMQebF6Ehgrb56yxGfDOsFoEMVrtamfjTGJId31+mKsRV?=
 =?us-ascii?Q?Y1SO7GSkXcTY/DkMIbkYLPaw/tDB9tIiGskHsgOqqOwOFLTDoX+ftGJOp1qq?=
 =?us-ascii?Q?KIDJKb2RYrwM7n09RUVj68rcHj+z8fOgQxZGGHK+9OVFwtgihpfQcecsaWqn?=
 =?us-ascii?Q?ledEm0ZGinPxFMS9w38aXAkpaC4MERSJl6Re6NvCz3zxLHpewNHTw/jPFyh2?=
 =?us-ascii?Q?Lqx2Naw6ND4JyQE/62EngBAUZz8aZuM9HvMwmeTuLs7iQuIrhDlNtYtCB61W?=
 =?us-ascii?Q?jNjYcDLcled7ybaYwz2WybG9MutO9H2k2jXgzPMOgp4NlEzQFDPJu3nLsVRK?=
 =?us-ascii?Q?+W8bjbPwA6PC5biW40RZllvcypYswnZK68xV2rSyHtcr+kIbo7BjI4Owt36W?=
 =?us-ascii?Q?z6Xi4s/NWgm8if5JFb6eYZ9dZJfQUQeSGNbOnPx602mGzLOOxVDOH7k7056s?=
 =?us-ascii?Q?kvDfkTPquHITM1/MbUTX4D48uVBfWSrdw5yv6Ct/MbI1T4jJYZnw9aZcm5HW?=
 =?us-ascii?Q?3+xG3vM12PvzJUshAT9NTVQxy4I49ut4F+k0saeKUof6JatdUSxQGhdjrg2r?=
 =?us-ascii?Q?ymh+OK7tmWPW2QYJbQLzD3oKWc4j8E9RYbNzmPYp1CtorFtkE1n7qdYnx+zK?=
 =?us-ascii?Q?Xo9TIBklxQO4cK0qtbksSO6Jw0OwmqBZJ8PGNCUuu0fEuiMYTS/w8HnkUA+C?=
 =?us-ascii?Q?wR4gwA7UUoVlOP5LM23qSoPVgylQHnLQ2r9npCMg1zaGqwGXpM+mH/OdQa4z?=
 =?us-ascii?Q?ayKdBl9eJjucNvGBt9c3w1xT7yFd+RmXOEkWxOZfi4O8i9hXSyQ/OLF1hIoe?=
 =?us-ascii?Q?hFHrZFTm22AXWud0atNJKs3pmTsLmPyvSvzdfcUG72kyfjidXhKXzAX1ghpl?=
 =?us-ascii?Q?EQ+IkDJBEAda78cwAdoqbt2dpGV7nHllcs96/5QK3lVhHICK98FrU4Pk869w?=
 =?us-ascii?Q?pSgqlFh4W4klPbITO0BU1dGDKZD/a0aeI8h4b/jv1vpY8gpQglSb5upEbDBD?=
 =?us-ascii?Q?iSJoOHNdvqi4bR99UKDjTRlodzfQPjTUa8i9N73MCGdvki6zRTQJ7dHQqm4J?=
 =?us-ascii?Q?QDNUdJ+v4ZEfHjA8eScvcizz1xM/bI6+DzabRUWLCR4XhlmdFM6Zf/FQ6TB7?=
 =?us-ascii?Q?HVjP+z20/e7M+J0VY/ruQ2UMdxqvF0UGXywMB1qu4qF0bksPfQwGJUFOJ2ag?=
 =?us-ascii?Q?iFONqIjEB6+GXhN474zcruaYDDYB/XACG3R9zccnVnJWUBJz2m7b9BFKzWWk?=
 =?us-ascii?Q?15wi4giK8bE8a4qMWuCde1BYDl+/OX0Zu/TMuvsEiRFG3a5TQLOHS20mDyyl?=
 =?us-ascii?Q?lw=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 234d29c7-080d-4a21-0803-08da5953a061
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 22:14:53.5155
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KF8YXc0T4IXLXVSJzvFaZzQ29mGSRFOnYqsf2xqp/UORboKVfn/194BvvVRP0kWvlsPXymuzNJi1q+nbZdOJKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR03MB3013
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of using a void pointer for mac_dev, specify its type
explicitly.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

Changes in v2:
- New

 drivers/net/ethernet/freescale/fman/fman_dtsec.c | 2 +-
 drivers/net/ethernet/freescale/fman/fman_mac.h   | 5 +++--
 drivers/net/ethernet/freescale/fman/fman_memac.c | 2 +-
 drivers/net/ethernet/freescale/fman/fman_tgec.c  | 2 +-
 drivers/net/ethernet/freescale/fman/mac.c        | 5 ++---
 5 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fman/fman_dtsec.c b/drivers/net/ethernet/freescale/fman/fman_dtsec.c
index 09ad1117005a..7acd57424034 100644
--- a/drivers/net/ethernet/freescale/fman/fman_dtsec.c
+++ b/drivers/net/ethernet/freescale/fman/fman_dtsec.c
@@ -301,7 +301,7 @@ struct fman_mac {
 	/* Ethernet physical interface */
 	phy_interface_t phy_if;
 	u16 max_speed;
-	void *dev_id; /* device cookie used by the exception cbs */
+	struct mac_device *dev_id; /* device cookie used by the exception cbs */
 	fman_mac_exception_cb *exception_cb;
 	fman_mac_exception_cb *event_cb;
 	/* Number of individual addresses in registers for this station */
diff --git a/drivers/net/ethernet/freescale/fman/fman_mac.h b/drivers/net/ethernet/freescale/fman/fman_mac.h
index 730aae7fed13..65887a3160d7 100644
--- a/drivers/net/ethernet/freescale/fman/fman_mac.h
+++ b/drivers/net/ethernet/freescale/fman/fman_mac.h
@@ -41,6 +41,7 @@
 #include <linux/if_ether.h>
 
 struct fman_mac;
+struct mac_device;
 
 /* Ethernet Address */
 typedef u8 enet_addr_t[ETH_ALEN];
@@ -158,8 +159,8 @@ struct eth_hash_entry {
 	struct list_head node;
 };
 
-typedef void (fman_mac_exception_cb)(void *dev_id,
-				    enum fman_mac_exceptions exceptions);
+typedef void (fman_mac_exception_cb)(struct mac_device *dev_id,
+				     enum fman_mac_exceptions exceptions);
 
 /* FMan MAC config input */
 struct fman_mac_params {
diff --git a/drivers/net/ethernet/freescale/fman/fman_memac.c b/drivers/net/ethernet/freescale/fman/fman_memac.c
index 2f3050df5ab9..19619af99f9c 100644
--- a/drivers/net/ethernet/freescale/fman/fman_memac.c
+++ b/drivers/net/ethernet/freescale/fman/fman_memac.c
@@ -311,7 +311,7 @@ struct fman_mac {
 	/* Ethernet physical interface */
 	phy_interface_t phy_if;
 	u16 max_speed;
-	void *dev_id; /* device cookie used by the exception cbs */
+	struct mac_device *dev_id; /* device cookie used by the exception cbs */
 	fman_mac_exception_cb *exception_cb;
 	fman_mac_exception_cb *event_cb;
 	/* Pointer to driver's global address hash table  */
diff --git a/drivers/net/ethernet/freescale/fman/fman_tgec.c b/drivers/net/ethernet/freescale/fman/fman_tgec.c
index 2642a4c27292..010c0e0b57d7 100644
--- a/drivers/net/ethernet/freescale/fman/fman_tgec.c
+++ b/drivers/net/ethernet/freescale/fman/fman_tgec.c
@@ -180,7 +180,7 @@ struct fman_mac {
 	/* MAC address of device; */
 	u64 addr;
 	u16 max_speed;
-	void *dev_id; /* device cookie used by the exception cbs */
+	struct mac_device *dev_id; /* device cookie used by the exception cbs */
 	fman_mac_exception_cb *exception_cb;
 	fman_mac_exception_cb *event_cb;
 	/* pointer to driver's global address hash table  */
diff --git a/drivers/net/ethernet/freescale/fman/mac.c b/drivers/net/ethernet/freescale/fman/mac.c
index 0f9e3e9e60c6..66a3742a862b 100644
--- a/drivers/net/ethernet/freescale/fman/mac.c
+++ b/drivers/net/ethernet/freescale/fman/mac.c
@@ -41,10 +41,9 @@ struct mac_address {
 	struct list_head list;
 };
 
-static void mac_exception(void *handle, enum fman_mac_exceptions ex)
+static void mac_exception(struct mac_device *mac_dev,
+			  enum fman_mac_exceptions ex)
 {
-	struct mac_device *mac_dev = handle;
-
 	if (ex == FM_MAC_EX_10G_RX_FIFO_OVFL) {
 		/* don't flag RX FIFO after the first */
 		mac_dev->set_exception(mac_dev->fman_mac,
-- 
2.35.1.1320.gc452695387.dirty

