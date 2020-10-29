Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 177DE29E29E
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 03:28:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391164AbgJ2C2U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 22:28:20 -0400
Received: from mail-db8eur05on2074.outbound.protection.outlook.com ([40.107.20.74]:10036
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726741AbgJ2C2R (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Oct 2020 22:28:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NtDmGs84R3QY5XMikLaG7J1GZLDDNdWGkAeP2UcHJs3G1Wv4r5z2bVWX2GHw+bHFozke+ZOm8hgmCNYulzAZ0vgNmcQ1OdELLjXey/LgiCGytPMEyZCpRG+Svc6XDzbtbCnc3KFRnacZ5aEn4VMG4kDnbHXivS3WiA7AZi0pr/dkGTJleNzXOjl+kMPim/z5sKCrcnRF5j4e4VxMgjus0SGizuRUlAqgLKs2F61ZK9hIG6AxKt5cVFk5a5g8WbtLz47CD/LWqKgmdWTBw1W9FkuIBEtNISmK/u6Zsyuj/IB/bPWZnwqT1+NZaPlBFCSaz6EpMz3G1KkW6ML4ltokmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vC/teyT3LI4lVg/NApky36sT6UJWtotZHBCKLc1ZyH4=;
 b=JCq6xFRLZ2AkMwP49zoGepgXVB9DpmsFg+yxqj/hYZq7oae+frWyzbmRQzJbJ1/yeq1WN8oKw6tpSTuQ1PEszlBWG/AHQqJuo2GehZqPaTodEQkdd2A6gqDSYBcDOf45Jd5PaY7lrYvo/RYsKwwKtARBtYvuCPz5B9Op6xR/OWdJGcW5ClwjyxRRtZlcK/VVS6W0g20qIhbRpzW8+84zxah/4X9mIDLMrTp6+0GQI4bDhD+BylnmgqTdRDrWfbgfOkudOzYj/qna0dQJVJeYP4S6FzzmtXYkAyaNsS6sj2AyKaICpKpoezVkzLCJJB9h+X9f3lBDzM0J1NyvkWDs8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vC/teyT3LI4lVg/NApky36sT6UJWtotZHBCKLc1ZyH4=;
 b=MKdlouiW2UvObm0Q8WOD8hTGmp2C8pJ2JHMIBbcXVB+bEnILvhQzSg7OgiIytF17VTAxznv39CBtvpcGh5GmissM02bwzJ2jQ0qSzL5+wiGqoBKXNyM4+R9JE0UFNCmJmbY9419OrV7QeJx1aqocEyRrapPUfcVgck0rqPI1jCg=
Authentication-Results: microchip.com; dkim=none (message not signed)
 header.d=none;microchip.com; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB6942.eurprd04.prod.outlook.com (2603:10a6:803:136::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Thu, 29 Oct
 2020 02:28:01 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3499.027; Thu, 29 Oct 2020
 02:28:01 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 3/5] net: mscc: ocelot: remove the "new" variable in ocelot_port_mdb_add
Date:   Thu, 29 Oct 2020 04:27:36 +0200
Message-Id: <20201029022738.722794-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201029022738.722794-1-vladimir.oltean@nxp.com>
References: <20201029022738.722794-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.25.2.177]
X-ClientProxiedBy: VI1PR0101CA0052.eurprd01.prod.exchangelabs.com
 (2603:10a6:800:1f::20) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.2.177) by VI1PR0101CA0052.eurprd01.prod.exchangelabs.com (2603:10a6:800:1f::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.19 via Frontend Transport; Thu, 29 Oct 2020 02:28:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9adc87bd-c4d2-491e-e38e-08d87bb241c6
X-MS-TrafficTypeDiagnostic: VI1PR04MB6942:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB69421701C78BF295CBC132DAE0140@VI1PR04MB6942.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:431;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hpVuoz04Ej1oKNIeWGuswdmzHAqwakV0gd4y1Dwxq4DsyX2AcYyhMLb6LjQtUS1mJPQ8JZ7Tk4vXu4FHiR2/TbXtB0ydRfGKNUrXjZt5eWtd5ORQshXdWY2AW6EDw357bPKfgmemOqKEx5dFRSGGCYuLJ0s2lWZoLEnTxf8vsz8/j/IUntREsLlLstvKwf88eWMpVJdwoutA2Uyq45l0YVfxNykGhIFezeFktzHg1gEV4QiAp/ZvEvdKU1oCEw85U6CZy+uuaAVEzQVVxb1II+0C2wvE5zmjkn/drHIVw2YPvA4gdAIr1hKskf7VA+L0aOot7oixhBUiYYtgkCmxtnV6zeM0+JTUCXromC8plQI9+CGuZ4YkHzIkq8LyYjW+CbnRM1zzrUxhzY8gfMgKXA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(346002)(376002)(366004)(396003)(6486002)(110136005)(186003)(5660300002)(44832011)(83380400001)(1076003)(316002)(6666004)(2906002)(86362001)(69590400008)(26005)(8936002)(16526019)(6506007)(2616005)(66556008)(8676002)(66946007)(52116002)(66476007)(36756003)(956004)(6512007)(478600001)(921003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: RHMhFnCd1ilL6DWyNjnU982pkOuOiT/Re/PwJPYS15x/kFfXSTG56j22UqwbltwaJQEOa48Di/aFdP2w4DYYPSFzpJYOxCebzsLY18mb10rR2hw/MhBOl2bY4GGQmLvQSCsa1FC3xjew7DXl3OigjZc9gbVm3Y/V/FpohBN4q4pOCTa4TyJVbN2kdnFLmwrCo5/M32c1ju+SYaOXOIBPFUQOQ2ALGjhzLrZwNzEOagebtm3lptorE/fo8CpU7/9O+b55kLBki/on4i+45c0FxMdSEkoDTzH5/nv4QdZnCEuybnAUJQJRgP9h7zSrt/cPIvdwavaUq4bDoIPC7qXGcD82aHFrQ5BpkzJ7XJytLxackrkAP6gBT2iBeO6acpHV/wugTXgvwwcscrCeZEzu//Lown8/JwQytecoX7lBhUYV7hPZFak6SwfWwLxOukSQ12g/8LXEOaLup9wR2xgTqcGG5NM3jdnQZkpbkJCdizH4guvGB0unoGTzTbY1yP2JKoAA4bAdcdDqOvIAzkfqTHXm0l4kInibkx+GdBCJBCmtme900b7eP3LV3vu3XlfB9FMPoGpfHv/FoJrLmOR3SyW0Od49ltfuRnoOBpjLwCLFZ6sUCIKJc2uBVksr6FwVD7DU4eV4DZiueC60VSlUlw==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9adc87bd-c4d2-491e-e38e-08d87bb241c6
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2020 02:28:01.2382
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fUubfzt/8t+lFCTCNkLOYIL3LA7Xhd1CQSxM7H2CjdPvSkh7aCd0K4O2U3rR7xvhLLyC+ofOZOIddJM6I8PqAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6942
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is Not Needed, a comment will suffice.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 763d0277eeae..ea49d715c9d0 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1017,7 +1017,6 @@ int ocelot_port_mdb_add(struct ocelot *ocelot, int port,
 	unsigned char addr[ETH_ALEN];
 	struct ocelot_multicast *mc;
 	u16 vid = mdb->vid;
-	bool new = false;
 
 	if (port == ocelot->npi)
 		port = ocelot->num_phys_ports;
@@ -1029,6 +1028,7 @@ int ocelot_port_mdb_add(struct ocelot *ocelot, int port,
 
 	mc = ocelot_multicast_get(ocelot, mdb->addr, vid);
 	if (!mc) {
+		/* New entry */
 		int pgid = ocelot_mdb_get_pgid(ocelot, entry_type);
 
 		if (pgid < 0) {
@@ -1047,10 +1047,7 @@ int ocelot_port_mdb_add(struct ocelot *ocelot, int port,
 		mc->pgid = pgid;
 
 		list_add_tail(&mc->list, &ocelot->multicast);
-		new = true;
-	}
-
-	if (!new) {
+	} else {
 		ocelot_encode_ports_to_mdb(addr, mc, entry_type);
 		ocelot_mact_forget(ocelot, addr, vid);
 	}
-- 
2.25.1

