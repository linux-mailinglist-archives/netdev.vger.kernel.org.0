Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B5CB3ECAFD
	for <lists+netdev@lfdr.de>; Sun, 15 Aug 2021 22:42:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231229AbhHOUme (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Aug 2021 16:42:34 -0400
Received: from mail-mw2nam12on2128.outbound.protection.outlook.com ([40.107.244.128]:21409
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230472AbhHOUm2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 15 Aug 2021 16:42:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jFqLn7uUkE2weN/D1bH+G35rXo+ezpS/hnWjUDq/c9gM7HHUPBeI8BpM/rjBcC7VLw932rwytuv3i6x1CQ6F46wr8WF7O3bmGTN9CX2xLuFEtoFlfU+4QBAPimC6XAwqhxoxSpnfc8Fm73jHqMc6zGiN6PQkztgfzmmwCRb9sAmYz3C7wvw8NSiGVNUGpUKtYiTrGUG2drtOdlkm9ZOduFqroA24kHzddi7XBAtRISJHDX6fNIKCQ/gW4aYprk7hu1uUVM5rxZOrQN6LdO8GZnkDi44eQxvLVjxViEGTDSVKZmGBUDAbPhKORUrrKz4/BPTND7TG4qaCQptxJh45VA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pVt+M6TQpZh39x1bf31jl9fwM65rp+mGX/CUA7Zi4D8=;
 b=hrW2sgTo0mz5ZddGw6bFA3sotBwlhRiSJraAiSZspY7gLjayniJu01NLkjUVVrfxVg9mVGDXs3ufgYCmSW3O9EjItodi3hhgJyh+h0v1OtyNhOmRpBpLUbEZ0tjQ2o98wE0SrdBSkiVFwSeTPvipRPQ8rAUcWol8wDW6FWHzyKkyBkeJqu4+nJ8K0CCh0b6uDgw8IacJFQm/we3T4GV+1d5nepGlPx7D8XPrHLSzTHZ0WHap2OBKARraS+iYTQyDJ4xtfS3Ax773lRr3YJfVQ7d3Ge9fer43v+2LCSarjKLJGAheDAg9eO7ar1XfO+Cf+45GQu7bfPMjOeSqrD6HpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pVt+M6TQpZh39x1bf31jl9fwM65rp+mGX/CUA7Zi4D8=;
 b=COPcN1bRWmnl1WhpoSjcUT2dqV/bdOmKt34Chpk5rDHYzMSU3+0t4z0tMhOxDAvUmk29Dg0Vek0Jyy1HJiGGh9q5hi3M8BYmCKjySj7xHbsJjexq1Izk3It+SRB3Z7In3X1+kElTgMlitxbU8W59UJk9VGLKzm195A3M1P3QVnM=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MWHPR10MB1696.namprd10.prod.outlook.com
 (2603:10b6:301:8::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14; Sun, 15 Aug
 2021 20:41:55 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::e81f:cf8e:6ad6:d24d]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::e81f:cf8e:6ad6:d24d%3]) with mapi id 15.20.4415.022; Sun, 15 Aug 2021
 20:41:55 +0000
Date:   Sun, 15 Aug 2021 13:41:49 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v3 net-next 09/10] net: dsa: ocelot: felix: add
 support for VSC75XX control over SPI
Message-ID: <20210815204149.GB3328995@euler>
References: <20210814025003.2449143-1-colin.foster@in-advantage.com>
 <20210814025003.2449143-10-colin.foster@in-advantage.com>
 <20210814114329.mycpcfwoqpqxzsyl@skbuf>
 <20210814120211.v2qjqgi6l3slnkq2@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210814120211.v2qjqgi6l3slnkq2@skbuf>
X-ClientProxiedBy: MWHPR2201CA0049.namprd22.prod.outlook.com
 (2603:10b6:301:16::23) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from euler (67.185.175.147) by MWHPR2201CA0049.namprd22.prod.outlook.com (2603:10b6:301:16::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.17 via Frontend Transport; Sun, 15 Aug 2021 20:41:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 042b1c85-047c-4682-0502-08d9602d1d7a
X-MS-TrafficTypeDiagnostic: MWHPR10MB1696:
X-Microsoft-Antispam-PRVS: <MWHPR10MB1696F7D55B378DDB893BFC9EA4FC9@MWHPR10MB1696.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VaDHs+kWTmUTBW+M2sHYI921NFE/tRngwK6P4bcufYGr+huq+8og591lQhEXL41vSmMXqMyraNbBRvsDuxYYMYNyEHA3rKAkZ7oeoMFczqpWZWlM0PBCLtBtXLwtSMD+Oxvehc8cCrvTTdYKQNyZTEHwg+CNPzt2qpiv8A2vCw3cxMUHPsk5PdJuyg09YVCTjSSu+d4unRv6efi4ZyLsj90p5S1cBhbSq7zEyjuSkmH1jcG7xTiq53wDA5s8Sl/gbmLMSmBgymcJgiVbrvOqtHEa0AR7bN6CKGzkmYyKhySrvEBG3++Di5B5gqcocF8utrq/ukAM1dvEd/fpWzEK9Ba8OAeQiRxvF1VqZvyEVGnOD/dqqX+7X6ro/ym1rYjvroQ6gwAKW+EhJL7x8ZPb+8Vf2JINyXzFsEHrm7+y6YDuyUzpATMI25G1AeFKcG/w5LYBB4JS9sSSbF2kx4hXwvgoqCL/4eAHR33Ov09+NVfyFchWwSHrhfz7WpR6h5TsP3zF2k6y2VtP3Pi5wIXQXuJSTlSL2vVUTXkBJt9rhhQRUEwHhAdpMQC0aAfsEaC+2t+pF2oY2nJafFurr3RG0XLFK6rIP4pfUvKyqW7yynHi7uqN8BLVCSMCP5/u45E007BDupIlZWOQIcZgVc0w0nmKEubBafptt+MGPD5BgNiCkYI4O+8mkttsc03CVlnsVuw46iCAAFvQ2BwmB6jjOUjq7VHQnws3fOmqAFCKWI0iVJD6RHctjA2XAAlra34BL7fS5oO4MZQ7zWnL8gqSng==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(376002)(366004)(396003)(39830400003)(53546011)(5660300002)(83380400001)(956004)(6666004)(44832011)(9576002)(508600001)(52116002)(7416002)(6496006)(316002)(8676002)(33716001)(4326008)(186003)(30864003)(966005)(26005)(1076003)(9686003)(2906002)(33656002)(38350700002)(38100700002)(86362001)(66476007)(6916009)(66946007)(8936002)(55016002)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mhu99+E/Q6mpUEw8IHUeFBm/D3usnhV24JEoEm1I79U0mXDLwM2SWyxO952k?=
 =?us-ascii?Q?dn26mAv1tn9JPaEwSYGz8Bwq/CoP7LCKRURCWHEE1wjvx6aLZZH3E8t8Tq8V?=
 =?us-ascii?Q?PuHKM8akBvt1xT3lHqoCOTiZn5cEOliUe1ZoF9l/x3xFv/hRtLd3eVP0lBVT?=
 =?us-ascii?Q?7/j6AodsnvSl5gGTVn0gjwXAlOyZe8u+DARWYG2TwsxbzHE4d9eEf+8mR5Ls?=
 =?us-ascii?Q?xHfJX/AN6CtVBSbnpKka8jYdf4l46eKGGXSDW8vGJgRw0DM1y3+k1c2STIY2?=
 =?us-ascii?Q?10od+WhIv3Vudv6s35mlPgko/NnPLT+LZejhkbFtKIkvkTtjofhX1ZJKbqIA?=
 =?us-ascii?Q?DxvgkZoD9HeILoeCXYG6fPJJxMgVUhYtf7p79ahVuo/Vb2hauFPVJ8WI3fb7?=
 =?us-ascii?Q?iwBi8/AsL+VsnUJzh4PKBCIO1QOOYWb9baI7csr7SOCLubPYOwBZBSagKSzZ?=
 =?us-ascii?Q?odM6Lzs0Lh17tof4trxqAvLOaoH7m8SIapzUWL5Qgfmw4wTQaD8Ipu3yUt4u?=
 =?us-ascii?Q?1CHg4z5DFXGIjxbKV7Y5ptnIATbm4v449sCE1gsnIxgSM/4QZOrCBqr08haP?=
 =?us-ascii?Q?vXah2c7V93hKWi6ecHk5cyDchf8zKjOaVTOdZvmyaFyb2uxySNHdxAeUaUIY?=
 =?us-ascii?Q?0nlIUe7QctlKc26rBc+i+PMPITwpDkKlZGHW6u6w5Vv3uOOGWqoPUxD1rrPl?=
 =?us-ascii?Q?dNhjPHCQ5dMR0Ni82FQfvNkPzOekWSwXZDbaM/5wTJEkCWrHucJSwKSiw7Vt?=
 =?us-ascii?Q?rncEJ4ZtejT26n/vP3O/3xYUcQ5gNsah0v3sUUw370IH9fpzUzKsbNpS8+4t?=
 =?us-ascii?Q?31e6oNdPj6K/MXROpCOgJ08F1W5i3hYLrKuo3yhx+GFjP5NaQlrarnfFu2e4?=
 =?us-ascii?Q?QAvP+w3I5QvmDn5uXUh9vzXu53hOMbGumM5O/Y+xuUoqegdsPowk+2sNJPq9?=
 =?us-ascii?Q?8AzXgDpf0lXPOZKIDcKd/9vodxV+iyEVdEZvnjD+YFvtAdDeFJmY86CDmp1o?=
 =?us-ascii?Q?5qbGBUJViyP05LV+0G6WVqa30HQf0k/wdB0/TL4TzPev+3nZJcXt62P/xC9h?=
 =?us-ascii?Q?zhQGObpbKsC8AF4oQlTQKKCV76iXHYrmaj6GiESoJU85lktjW/QptxTt3fGq?=
 =?us-ascii?Q?7tXRhOJNfpp2Glr3agvTwtxrp87Qrd/pMNyUNQOBDu6HKKsH0z7uES/jYfVT?=
 =?us-ascii?Q?ftQADy1kSZFXBtRkqKj4xPs4HnenlMVSUyT9ydhfyvY9VpSuIfCeNeY6uEmQ?=
 =?us-ascii?Q?bI5cyU6EdNT9Xw8A8mcAYK+ZeCUUL0zU0XdO/2O7Tur9nRG6SOmMGiEDk5a7?=
 =?us-ascii?Q?yh+6QXOwilFRhiku+jOB3qWd?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 042b1c85-047c-4682-0502-08d9602d1d7a
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2021 20:41:55.2456
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WVnMBZXDMl+TpNn5I22HP8nupXUe4HGwWxcpmXhisEj2L4sbAn3ST8JX0kfuPt8RjnJYJUzLvJfV/5HDC/FAHnEob+KBpYHjBbxpFDmJ1GE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1696
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 14, 2021 at 03:02:11PM +0300, Vladimir Oltean wrote:
> On Sat, Aug 14, 2021 at 02:43:29PM +0300, Vladimir Oltean wrote:
> > The issue is that the registers for the PCS1G block look nothing like
> > the MDIO clause 22 layout, so anything that tries to map the struct
> > ocelot_pcs over a struct mdio_device is going to look like a horrible
> > shoehorn.
> > 
> > For that we might need Russell's assistance.
> > 
> > The documentation is at:
> > http://ww1.microchip.com/downloads/en/DeviceDoc/VMDS-10489.pdf
> > search for "Information about the registers for this product is available in the attached file."
> > and then open the PDF embedded within the PDF.
> 
> In fact I do notice now that as long as you don't use any of the
> optional phylink_mii_c22_pcs_* helpers in your PCS driver, then
> struct phylink_pcs has pretty much zero dependency on struct mdio_device,
> which means that I'm wrong and it should be completely within reach to
> write a dedicated PCS driver for this hardware.
> 
> As to how to make the common felix.c work with different implementations
> of struct phylink_pcs, one thing that certainly has to change is that
> struct felix should hold a struct phylink_pcs **pcs and not a
> struct lynx_pcs **pcs.
> 
> Does this mean that we should refactor lynx_pcs_create() to return a
> struct phylink_pcs * instead of struct lynx_pcs *, and lynx_pcs_destroy()
> to receive the struct phylink_pcs *, use container_of() and free the
> larger struct lynx_pcs *? Yes, probably.
> 
> If you feel uncomfortable with this, I can try to refactor lynx_pcs to
> make it easier to accomodate a different PCS driver in felix.

I believe I'll need to rebase this commit before I send it out to the
maintainers, but is this what you had in mind?

I also came across some curious code in Seville where it is callocing a
struct phy_device * array instead of struct lynx_pcs *. I'm not sure if
that's technically a bug or if the thought is "a pointer array is a 
pointer array."

From 323d2f68447c3532dba0d85c636ea14c66aa098f Mon Sep 17 00:00:00 2001
From: Colin Foster <colin.foster@in-advantage.com>
Date: Sun, 15 Aug 2021 13:07:47 -0700
Subject: [RFC PATCH v3 net-next] net: phy: lynx: refactor Lynx PCS module to
 use generic phylink_pcs

Remove references to lynx_pcs structures so drivers like the Felix DSA
can reference alternate PCS drivers.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/net/dsa/ocelot/felix.h                |  2 +-
 drivers/net/dsa/ocelot/felix_vsc9959.c        | 10 ++++-----
 drivers/net/dsa/ocelot/seville_vsc9953.c      | 12 +++++-----
 .../net/ethernet/freescale/dpaa2/dpaa2-mac.c  |  7 +++---
 .../net/ethernet/freescale/dpaa2/dpaa2-mac.h  |  3 +--
 .../net/ethernet/freescale/enetc/enetc_pf.c   | 12 +++++-----
 .../net/ethernet/freescale/enetc/enetc_pf.h   |  4 ++--
 drivers/net/pcs/pcs-lynx.c                    | 22 +++++++++++++++----
 include/linux/pcs-lynx.h                      |  9 +++-----
 9 files changed, 46 insertions(+), 35 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index c872705115bc..f51e9e8064fc 100644
--- a/drivers/net/dsa/ocelot/felix.h
+++ b/drivers/net/dsa/ocelot/felix.h
@@ -58,7 +58,7 @@ struct felix {
 	const struct felix_info		*info;
 	struct ocelot			ocelot;
 	struct mii_bus			*imdio;
-	struct lynx_pcs			**pcs;
+	struct phylink_pcs		**pcs;
 	resource_size_t			switch_base;
 	resource_size_t			imdio_base;
 	struct dsa_8021q_context	*dsa_8021q_ctx;
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index a84129d18007..d0b3f6be360f 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -1046,7 +1046,7 @@ static int vsc9959_mdio_bus_alloc(struct ocelot *ocelot)
 	int rc;
 
 	felix->pcs = devm_kcalloc(dev, felix->info->num_ports,
-				  sizeof(struct lynx_pcs *),
+				  sizeof(struct phylink_pcs *),
 				  GFP_KERNEL);
 	if (!felix->pcs) {
 		dev_err(dev, "failed to allocate array for PCS PHYs\n");
@@ -1095,8 +1095,8 @@ static int vsc9959_mdio_bus_alloc(struct ocelot *ocelot)
 
 	for (port = 0; port < felix->info->num_ports; port++) {
 		struct ocelot_port *ocelot_port = ocelot->ports[port];
+		struct phylink_pcs *phylink;
 		struct mdio_device *pcs;
-		struct lynx_pcs *lynx;
 
 		if (dsa_is_unused_port(felix->ds, port))
 			continue;
@@ -1108,13 +1108,13 @@ static int vsc9959_mdio_bus_alloc(struct ocelot *ocelot)
 		if (IS_ERR(pcs))
 			continue;
 
-		lynx = lynx_pcs_create(pcs);
+		phylink = lynx_pcs_create(pcs);
 		if (!lynx) {
 			mdio_device_free(pcs);
 			continue;
 		}
 
-		felix->pcs[port] = lynx;
+		felix->pcs[port] = phylink;
 
 		dev_info(dev, "Found PCS at internal MDIO address %d\n", port);
 	}
@@ -1128,7 +1128,7 @@ static void vsc9959_mdio_bus_free(struct ocelot *ocelot)
 	int port;
 
 	for (port = 0; port < ocelot->num_phys_ports; port++) {
-		struct lynx_pcs *pcs = felix->pcs[port];
+		struct phylink_pcs *pcs = felix->pcs[port];
 
 		if (!pcs)
 			continue;
diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index 540cf5bc9c54..8200cc5dd24d 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -1007,7 +1007,7 @@ static int vsc9953_mdio_bus_alloc(struct ocelot *ocelot)
 	int rc;
 
 	felix->pcs = devm_kcalloc(dev, felix->info->num_ports,
-				  sizeof(struct phy_device *),
+				  sizeof(struct phylink_pcs *),
 				  GFP_KERNEL);
 	if (!felix->pcs) {
 		dev_err(dev, "failed to allocate array for PCS PHYs\n");
@@ -1029,8 +1029,8 @@ static int vsc9953_mdio_bus_alloc(struct ocelot *ocelot)
 	for (port = 0; port < felix->info->num_ports; port++) {
 		struct ocelot_port *ocelot_port = ocelot->ports[port];
 		int addr = port + 4;
+		struct phylink_pcs *phylink;
 		struct mdio_device *pcs;
-		struct lynx_pcs *lynx;
 
 		if (dsa_is_unused_port(felix->ds, port))
 			continue;
@@ -1042,13 +1042,13 @@ static int vsc9953_mdio_bus_alloc(struct ocelot *ocelot)
 		if (IS_ERR(pcs))
 			continue;
 
-		lynx = lynx_pcs_create(pcs);
+		phylink = lynx_pcs_create(pcs);
 		if (!lynx) {
 			mdio_device_free(pcs);
 			continue;
 		}
 
-		felix->pcs[port] = lynx;
+		felix->pcs[port] = phylink;
 
 		dev_info(dev, "Found PCS at internal MDIO address %d\n", addr);
 	}
@@ -1062,12 +1062,12 @@ static void vsc9953_mdio_bus_free(struct ocelot *ocelot)
 	int port;
 
 	for (port = 0; port < ocelot->num_phys_ports; port++) {
-		struct lynx_pcs *pcs = felix->pcs[port];
+		struct phylink_pcs *pcs = felix->pcs[port];
 
 		if (!pcs)
 			continue;
 
-		mdio_device_free(pcs->mdio);
+		mdio_device_free(lynx_pcs_get_mdio(pcs));
 		lynx_pcs_destroy(pcs);
 	}
 	felix_mdio_bus_free(ocelot);
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
index ccaf7e35abeb..484f0d4efefe 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
@@ -270,10 +270,11 @@ static int dpaa2_pcs_create(struct dpaa2_mac *mac,
 
 static void dpaa2_pcs_destroy(struct dpaa2_mac *mac)
 {
-	struct lynx_pcs *pcs = mac->pcs;
+	struct phylink_pcs *pcs = mac->pcs;
 
 	if (pcs) {
-		struct device *dev = &pcs->mdio->dev;
+		struct mdio_device *mdio = lynx_get_mdio_device(pcs);
+		struct device *dev = &mdio->dev;
 		lynx_pcs_destroy(pcs);
 		put_device(dev);
 		mac->pcs = NULL;
@@ -336,7 +337,7 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
 	mac->phylink = phylink;
 
 	if (mac->pcs)
-		phylink_set_pcs(mac->phylink, &mac->pcs->pcs);
+		phylink_set_pcs(mac->phylink, mac->pcs);
 
 	err = phylink_of_phy_connect(mac->phylink, dpmac_node, 0);
 	if (err) {
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.h b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.h
index 13d42dd58ec9..d1d22b52a960 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.h
@@ -7,7 +7,6 @@
 #include <linux/of_mdio.h>
 #include <linux/of_net.h>
 #include <linux/phylink.h>
-#include <linux/pcs-lynx.h>
 
 #include "dpmac.h"
 #include "dpmac-cmd.h"
@@ -23,7 +22,7 @@ struct dpaa2_mac {
 	struct phylink *phylink;
 	phy_interface_t if_mode;
 	enum dpmac_link_type if_link_type;
-	struct lynx_pcs *pcs;
+	struct phylink_pcs *pcs;
 };
 
 bool dpaa2_mac_is_type_fixed(struct fsl_mc_device *dpmac_dev,
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index 31274325159a..cc2ca51ac984 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -823,7 +823,7 @@ static int enetc_imdio_create(struct enetc_pf *pf)
 {
 	struct device *dev = &pf->si->pdev->dev;
 	struct enetc_mdio_priv *mdio_priv;
-	struct lynx_pcs *pcs_lynx;
+	struct phylink_pcs *pcs_phylink;
 	struct mdio_device *pcs;
 	struct mii_bus *bus;
 	int err;
@@ -855,8 +855,8 @@ static int enetc_imdio_create(struct enetc_pf *pf)
 		goto unregister_mdiobus;
 	}
 
-	pcs_lynx = lynx_pcs_create(pcs);
-	if (!pcs_lynx) {
+	pcs_phylink = lynx_pcs_create(pcs);
+	if (!pcs_phylink) {
 		mdio_device_free(pcs);
 		err = -ENOMEM;
 		dev_err(dev, "cannot create lynx pcs (%d)\n", err);
@@ -864,7 +864,7 @@ static int enetc_imdio_create(struct enetc_pf *pf)
 	}
 
 	pf->imdio = bus;
-	pf->pcs = pcs_lynx;
+	pf->pcs = pcs_phylink;
 
 	return 0;
 
@@ -878,7 +878,7 @@ static int enetc_imdio_create(struct enetc_pf *pf)
 static void enetc_imdio_remove(struct enetc_pf *pf)
 {
 	if (pf->pcs) {
-		mdio_device_free(pf->pcs->mdio);
+		mdio_device_free(lynx_get_mdio_device(pf->pcs));
 		lynx_pcs_destroy(pf->pcs);
 	}
 	if (pf->imdio) {
@@ -977,7 +977,7 @@ static void enetc_pl_mac_config(struct phylink_config *config,
 
 	priv = netdev_priv(pf->si->ndev);
 	if (pf->pcs)
-		phylink_set_pcs(priv->phylink, &pf->pcs->pcs);
+		phylink_set_pcs(priv->phylink, &pf->pcs);
 }
 
 static void enetc_force_rgmii_mac(struct enetc_hw *hw, int speed, int duplex)
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.h b/drivers/net/ethernet/freescale/enetc/enetc_pf.h
index 263946c51e37..c26bd66e4597 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.h
@@ -2,7 +2,7 @@
 /* Copyright 2017-2019 NXP */
 
 #include "enetc.h"
-#include <linux/pcs-lynx.h>
+#include <linux/phylink.h>
 
 #define ENETC_PF_NUM_RINGS	8
 
@@ -46,7 +46,7 @@ struct enetc_pf {
 
 	struct mii_bus *mdio; /* saved for cleanup */
 	struct mii_bus *imdio;
-	struct lynx_pcs *pcs;
+	struct phylink_pcs *pcs;
 
 	phy_interface_t if_mode;
 	struct phylink_config phylink_config;
diff --git a/drivers/net/pcs/pcs-lynx.c b/drivers/net/pcs/pcs-lynx.c
index af36cd647bf5..bdefcb36e913 100644
--- a/drivers/net/pcs/pcs-lynx.c
+++ b/drivers/net/pcs/pcs-lynx.c
@@ -22,6 +22,11 @@
 #define IF_MODE_SPEED_MSK		GENMASK(3, 2)
 #define IF_MODE_HALF_DUPLEX		BIT(4)
 
+struct lynx_pcs {
+	struct phylink_pcs pcs;
+	struct mdio_device *mdio;
+};
+
 enum sgmii_speed {
 	SGMII_SPEED_10		= 0,
 	SGMII_SPEED_100		= 1,
@@ -30,6 +35,15 @@ enum sgmii_speed {
 };
 
 #define phylink_pcs_to_lynx(pl_pcs) container_of((pl_pcs), struct lynx_pcs, pcs)
+#define lynx_to_phylink_pcs(lynx) (&lynx->pcs)
+
+struct mdio_device *lynx_get_mdio_device(struct phylink_pcs *pcs)
+{
+	struct lynx_pcs *lynx = phylink_pcs_to_lynx(pcs);
+
+	return lynx->mdio;
+}
+EXPORT_SYMBOL(lynx_get_mdio_device);
 
 static void lynx_pcs_get_state_usxgmii(struct mdio_device *pcs,
 				       struct phylink_link_state *state)
@@ -329,7 +343,7 @@ static const struct phylink_pcs_ops lynx_pcs_phylink_ops = {
 	.pcs_link_up = lynx_pcs_link_up,
 };
 
-struct lynx_pcs *lynx_pcs_create(struct mdio_device *mdio)
+struct phylink_pcs *lynx_pcs_create(struct mdio_device *mdio)
 {
 	struct lynx_pcs *lynx_pcs;
 
@@ -341,13 +355,13 @@ struct lynx_pcs *lynx_pcs_create(struct mdio_device *mdio)
 	lynx_pcs->pcs.ops = &lynx_pcs_phylink_ops;
 	lynx_pcs->pcs.poll = true;
 
-	return lynx_pcs;
+	return lynx_to_phylink_pcs(lynx_pcs);
 }
 EXPORT_SYMBOL(lynx_pcs_create);
 
-void lynx_pcs_destroy(struct lynx_pcs *pcs)
+void lynx_pcs_destroy(struct phylink_pcs *pcs)
 {
-	kfree(pcs);
+	kfree(phylink_pcs_to_lynx(pcs));
 }
 EXPORT_SYMBOL(lynx_pcs_destroy);
 
diff --git a/include/linux/pcs-lynx.h b/include/linux/pcs-lynx.h
index a6440d6ebe95..5712cc2ce775 100644
--- a/include/linux/pcs-lynx.h
+++ b/include/linux/pcs-lynx.h
@@ -9,13 +9,10 @@
 #include <linux/mdio.h>
 #include <linux/phylink.h>
 
-struct lynx_pcs {
-	struct phylink_pcs pcs;
-	struct mdio_device *mdio;
-};
+struct mdio_device *lynx_get_mdio_device(struct phylink_pcs *pcs);
 
-struct lynx_pcs *lynx_pcs_create(struct mdio_device *mdio);
+struct phylink_pcs *lynx_pcs_create(struct mdio_device *mdio);
 
-void lynx_pcs_destroy(struct lynx_pcs *pcs);
+void lynx_pcs_destroy(struct phylink_pcs *pcs);
 
 #endif /* __LINUX_PCS_LYNX_H */
-- 
2.25.1

