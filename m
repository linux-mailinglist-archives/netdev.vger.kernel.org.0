Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 727C4618A38
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 22:07:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231419AbiKCVHS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 17:07:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230012AbiKCVHL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 17:07:11 -0400
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-eopbgr140053.outbound.protection.outlook.com [40.107.14.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C326221254;
        Thu,  3 Nov 2022 14:07:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VEL0k8Vx0BaYSzQa9JtrfHvWQ1wZS27f25JySxCu0YcOB/A2IEcYsyX9WioMidJQJFNqssbpLBbQ4AbyNC22HPqSCSzPjN7tI/Jm7e3MDaoF2BILgVN3HonTz0paBRXErNkwxc66uh3H70aERxwzRoGiWGljb4PKWGqVb7frYzS6Nf8F1M1Ess9yNNjnIa/J5ZijoBa96sxj35kt1JHkDS1E/xU08u3eXfB8y2vbjN4vQE/Ex97WXYz1jfdUlOdAommSJ5BsXUqL6SSoh6X0TeqMp7EvCWWICo/lg1O/FMaEn4/lLYLL+hDBOObp3AluFHya8cZPJQc9G5F59BiR+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RbGswBWDLCsP3eJPxSSJJM0p1nxBrU6A1jUu3DhFUo4=;
 b=k7kXcOCCbVaqZVchpxPxPJg2koQk5QucZvpdDJWsRrBPas5nsTvApXw/ObryAIPfNkmmdGGjgFpGPyhGm4S4/CZo8ZYRWQFlerYdp/ZKoTU+zDAkSbmyS62lzCHoufcrUj0c9pENnpDl2hF1EJk2ogcih2ToFaUOTp3h7jPxlSKBek2HqbOIeVbH03LP1U8vK10JoqfbsKSXwwXWzKm0EyjGUWq/tzU/QhXRB5szdRDeeSxvwIvBecysO+w4V0csHbS5jCetaDPaQNgKlBxrroFSIDvxguYFmqUQirmAyMhQsd+kJti3qdFtf3jDbJTZJ3wcQOqsnI3TB/Lf+YR+Yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RbGswBWDLCsP3eJPxSSJJM0p1nxBrU6A1jUu3DhFUo4=;
 b=ey1KFeOuR12hSMyLiBk6Vx6EtXGr+SNDceo4fEjQZv9tFYXIqJZy7OxSKfWytafhgXtn5WcBzaq2Z/HSEaA81hrISp/XVrE3u9vIZSgKOpzaQAdPXeIMFDc0ttn1FGVuGgJNdJ4VfJ4cK94ZIVMOJPRYrPYOloK8oCrxRLuyoXbTtrtjZB51wDQFW1WFPNtP2rXSHCOGp8LB0z2kuvZdL4hG8yi6A9NXWuybtYZO/1iJ3d3IRh6sdq40RUKt2L4SvzF0eiicDJksaVnVy+YbjLvQmtzTAnf9tqNXQuHH12pEJImultEYAGEmbVeXmKRG8nfgUpO0zmLDgbwdnEI5yg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by PAXPR03MB7746.eurprd03.prod.outlook.com (2603:10a6:102:208::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.15; Thu, 3 Nov
 2022 21:07:08 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::e9d6:22e1:489a:c23d]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::e9d6:22e1:489a:c23d%4]) with mapi id 15.20.5791.022; Thu, 3 Nov 2022
 21:07:08 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net-next v2 03/11] net: dsa: ocelot: suppress PHY device scanning on the internal MDIO bus
Date:   Thu,  3 Nov 2022 17:06:42 -0400
Message-Id: <20221103210650.2325784-4-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20221103210650.2325784-1-sean.anderson@seco.com>
References: <20221103210650.2325784-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAP220CA0002.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:32c::7) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB7PR03MB4972:EE_|PAXPR03MB7746:EE_
X-MS-Office365-Filtering-Correlation-Id: 8146fd42-bd1d-4db9-0d90-08dabddf5e2e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PuCisP1xpDfpu+qv8nEBYi63X1uL7BmjBjlNMDNuTnyZXcClKzqKl9Py7qozZT8zy0WqAd+9a6fIpHYHmUfhoQhtTPuQbFw1dEtb2Ys/Ag8psd+dlfU3U+jdCLyu/IZvq/yT1TEEhQq4E1Jl0Ke2WOUgkNGCgyV2e9BR5tL7SOeu5aHoUqRyCu+w8AOetu54/BzsgWRWoc4/XVhGEIWuiLl/AtHnWoUWsCUz6Jkqd3Vxjt27ywlUiaYb2NjZVXdYW7cX56lAw9qugi2iimnv2+9mqwxT7UomZVdIPNg3BEZMQRRq9jiXrlrSeJBY7Si3D9QyQtnC/1Z7M8Ah8LF98ze5FMBhEMX1CNVkfxDhwsyfUmrU7ezb0Gsc9mAdgKbkxDILjiBYHby1st8GDkXv0BwtPdqOZBX21IkUJ8H/JC5Z3GkGBIHeOesf3XObCE+1X7shzksVTunI79PezidU+Bc+HTsZe/XovT2Ddyhh4nYbb/tMRzu1WvPN2ejdNdE9hhsXWYI6NojYllxXorl7U6C8J/kZbJmf7dz9fO/JYCBrzMtFJ25PolzV9xM2BrROLPCLRrB5ah3d7SEkPqQm/wAbcOtAsyaKd26+wj847aFfNTDCFC149VYyn/btHgQHyeDrnYexkZzRR6OWjg5YwyPL+PPwDPQSnokWPTN8q50ALGygEWSrEz1/Aaaey42XBRISNwyxQz4F7qNLX4WqbQGetggBHsOs+xXc3cznXdv3xi0ad8/2Ks7pPWkAxEDv
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(39850400004)(376002)(346002)(396003)(451199015)(8936002)(86362001)(36756003)(107886003)(478600001)(6486002)(44832011)(5660300002)(2906002)(52116002)(26005)(6512007)(6506007)(1076003)(38350700002)(38100700002)(186003)(83380400001)(2616005)(7416002)(41300700001)(6666004)(66946007)(66556008)(4326008)(66476007)(8676002)(316002)(54906003)(110136005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?E//kU/FbHL93kgDPsKAtl5J2T+pj9f7twUJ1Tn5bHCyAgXQzJfc0W+MzXHkx?=
 =?us-ascii?Q?IjkK5IQ+xPB4C4MBOHMwEt2O86q8fcTQkm+jfqFOgUc//MykelzEusMVMSSm?=
 =?us-ascii?Q?6tz9thbUfZ/+aFRVHtaLnH8oF8k3LB81zoxHH81QlW+cBReDa3TcygPGybOd?=
 =?us-ascii?Q?UIKJQaqttlV9fHsWn/aOtiF+PCvUudrRupniNJ0ow3NQ7S9r+hZ10JrJLdaJ?=
 =?us-ascii?Q?SeXkxqsBGr0GWG4bo17XNz64WFNQdQ0CL47FfSJ/ILkrb68GL51M1GgUpEKH?=
 =?us-ascii?Q?rxCFSwFJ354hqxI9yUmSK2fTQ0jKbMSVPYWxBFkzFM7U+Ln6AJqu0a8BlvjB?=
 =?us-ascii?Q?yAR+cl+R2jQeS0aPCfGcWcTxNhqopGSVSIq19baObac1QLtc73CPhix0e3Ee?=
 =?us-ascii?Q?07CGSqujKuydR2tVJSLb+cuHwaI+n3Z32PE3RJSivNMH+00pgisluK9azpM0?=
 =?us-ascii?Q?CdfyAGJhwchsSWq3HXKCtaqOsNzBLDJ8Dip/IAiTCVkIQLQpCBCdSa3LzkZC?=
 =?us-ascii?Q?qR6euD0P6kJnzTVp1a/Bay7VSiATuSXI3JF3fVO/mjICptpqDiG6Pmi6EUz3?=
 =?us-ascii?Q?26VHQye9q8t4Kf9WWdfPUpbbEP21yF22hDHe9/bkyCHgtc/213Ynm5rwdN81?=
 =?us-ascii?Q?Mocb7WaqRHS+rq1IaxAgFzx1P1vaecJb87SHYHxUYdtYVuXfPazRZ0fjE0tH?=
 =?us-ascii?Q?WnmQaeti4UJukQreoRXT6dSArmbk5I2oHfzEq/wf+16XXNKX0VckYUjlE8pc?=
 =?us-ascii?Q?WTz4pLH2c9ixanlQzvAYKNrGFe0onK2azBzbBbGeHlIYfH8XmQPPIukTj7NQ?=
 =?us-ascii?Q?X8Di/8aBOdNVUc9rUChzAvdMw7Nb+P3xFy406pu8rpX5hDFvbhbrCaXYjbHF?=
 =?us-ascii?Q?8bHETzNg2RNvy6thl8Iz8wytzeCg3DyE1nIGVeyl49w41TIrsVxG6h3EMKCn?=
 =?us-ascii?Q?3tYPCQcAZy1VJC6qv1AbcCu12YD8y4F/h0OaDxMtJkm4vk3fjABo5qGAwOxP?=
 =?us-ascii?Q?jz+iBlhr4ZgIDKqrblTCi9GywgLgVXF6GqqX/fcSFB45VIxQFDR62vAlANwY?=
 =?us-ascii?Q?vEyREYmM7H2W+r1VhmQIJBF8ua2dixaAMkxHy2JZcPXWUNdgxtSmU190hnPe?=
 =?us-ascii?Q?4aHrerZtt0bopLCcSCDSfo/KyzKSGpAZjnH5xurVU6tAT7KOH6Nka+xbDAh+?=
 =?us-ascii?Q?2ehVJmSYftGAmZ3N+9PzAIjmkdnIoRol6QSWb7FgU6lLINaeUvKn+qwvrCzU?=
 =?us-ascii?Q?vU1RFti3r0yo+qj2XpWEBKyY39zBiRNOweKaGW/5W2oryrRr3ImyIXqQU+Ms?=
 =?us-ascii?Q?R/8g9XJNn4ow2rzFAQg9BG+mQbVLAInUzzmx1VP9bJUajqmH9evy8Dje9eW0?=
 =?us-ascii?Q?P8ULaGrWAKCeieRL7qk+a0Fvk8Y9s6hJdpKQwnfH96I4c3cgc/qO1Z6nKWG+?=
 =?us-ascii?Q?tUtMEnYrsVI1gMVIF30clrqeZrnHpIb46hqPmPcOthZn3+bajFzlkcMVkdvv?=
 =?us-ascii?Q?73GtGisbgWagfhY5hFvIsQzvdOauSOAHfIesTdczWTAWfnjxVvdN8s+6u+3P?=
 =?us-ascii?Q?c3xH6+ptrQaOI8boU4FkaU9Ax21Un/3VTveFqf0jYjCvqn+2eJ+1dv6hGkuK?=
 =?us-ascii?Q?Fg=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8146fd42-bd1d-4db9-0d90-08dabddf5e2e
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2022 21:07:08.3810
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UToT5omneDNC/RqnBZMq+TOBvmqlma3EORakxjzmo31rOXweDleCIG4uOxoMDJP/Tzz4UhI7hTL1sKU2Cfx7yw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR03MB7746
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This bus contains Lynx PCS devices, and if the lynx-pcs driver ever
decided to call mdio_device_register(), it would fail due to
mdiobus_scan() having created a dummy phydev for the same address
(the PCS responds to standard clause 22 PHY ID registers and can
therefore by autodetected by phylib which thinks it's a PHY).

On the Seville driver, things are a bit more complicated, since bus
creation is handled by mscc_miim_setup() and that is shared with the
dedicated mscc-miim driver. Suppress PHY scanning only for the Seville
internal MDIO bus rather than for the whole mscc-miim driver, since we
know that on NXP T1040, this bus only contains Lynx PCS devices.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

(no changes since v1)

 drivers/net/dsa/ocelot/felix_vsc9959.c   | 4 ++++
 drivers/net/dsa/ocelot/seville_vsc9953.c | 6 +++++-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 26a35ae322d1..ba893055b92d 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -990,6 +990,10 @@ static int vsc9959_mdio_bus_alloc(struct ocelot *ocelot)
 	bus->read = enetc_mdio_read;
 	bus->write = enetc_mdio_write;
 	bus->parent = dev;
+	/* Suppress PHY device creation in mdiobus_scan(),
+	 * we have Lynx PCSs
+	 */
+	bus->phy_mask = ~0;
 	mdio_priv = bus->priv;
 	mdio_priv->hw = hw;
 	/* This gets added to imdio_regs, which already maps addresses
diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index 7af33b2c685d..1e1c6cd265fd 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -924,12 +924,16 @@ static int vsc9953_mdio_bus_alloc(struct ocelot *ocelot)
 	rc = mscc_miim_setup(dev, &bus, "VSC9953 internal MDIO bus",
 			     ocelot->targets[GCB],
 			     ocelot->map[GCB][GCB_MIIM_MII_STATUS & REG_MASK]);
-
 	if (rc) {
 		dev_err(dev, "failed to setup MDIO bus\n");
 		return rc;
 	}
 
+	/* Suppress PHY device creation in mdiobus_scan(),
+	 * we have Lynx PCSs
+	 */
+	bus->phy_mask = ~0;
+
 	/* Needed in order to initialize the bus mutex lock */
 	rc = devm_of_mdiobus_register(dev, bus, NULL);
 	if (rc < 0) {
-- 
2.35.1.1320.gc452695387.dirty

