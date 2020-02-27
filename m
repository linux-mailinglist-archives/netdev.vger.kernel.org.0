Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50E84171224
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 09:13:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728464AbgB0INz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 03:13:55 -0500
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:7779 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726999AbgB0INz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 03:13:55 -0500
Received-SPF: Pass (esa1.microchip.iphmx.com: domain of
  Allan.Nielsen@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa1.microchip.iphmx.com;
  envelope-from="Allan.Nielsen@microchip.com";
  x-sender="Allan.Nielsen@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com -exists:%{i}.spf.microchip.iphmx.com
  include:servers.mcsv.net include:mktomail.com
  include:spf.protection.outlook.com ~all"
Received-SPF: None (esa1.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa1.microchip.iphmx.com;
  envelope-from="Allan.Nielsen@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa1.microchip.iphmx.com; spf=Pass smtp.mailfrom=Allan.Nielsen@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: 24Ny2aUo0utO4M6NmwpR4nGfArcRv3Zaw3Zw8Z6HkpoVLVuLfA4ggTwLNW02VyH8MuC1kqp9ug
 HqBaniYT4rhBrIgNyYT4hwgZCpNPkvvaQWkXg9aotiGYXD1admrMYdUA0+x8m+wV9RKsM7JGK9
 nM/OoV5daer+rPvOxuZgqvn4Jt5uIEqRUsG0vxAa1zZhNZVqKE67j+A+AxACrAfbeE6cmoGdoN
 QJ/pcQefm1ofPDmgPDWNhunI051YIvk1w4UNFTrm3caayutyR/ZxpvcmqFadrIS2oMs7tzKdCN
 L30=
X-IronPort-AV: E=Sophos;i="5.70,491,1574146800"; 
   d="scan'208";a="70002279"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Feb 2020 01:13:54 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 27 Feb 2020 01:13:46 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Thu, 27 Feb 2020 01:13:58 -0700
Date:   Thu, 27 Feb 2020 09:13:45 +0100
From:   "Allan W. Nielsen" <allan.nielsen@microchip.com>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     <davem@davemloft.net>, <horatiu.vultur@microchip.com>,
        <alexandre.belloni@bootlin.com>, <andrew@lunn.ch>,
        <f.fainelli@gmail.com>, <vivien.didelot@gmail.com>,
        <joergen.andreasen@microchip.com>, <claudiu.manoil@nxp.com>,
        <netdev@vger.kernel.org>, <UNGLinuxDriver@microchip.com>,
        <alexandru.marginean@nxp.com>, <xiaoliang.yang_1@nxp.com>,
        <yangbo.lu@nxp.com>, <po.liu@nxp.com>, <jiri@mellanox.com>,
        <idosch@idosch.org>, <kuba@kernel.org>
Subject: Re: [PATCH net-next 06/10] net: mscc: ocelot: remove port_pcs_init
 indirection for VSC7514
Message-ID: <20200227081345.dswh2p76nlkl5irm@lx-anielsen.microsemi.net>
References: <20200224130831.25347-1-olteanv@gmail.com>
 <20200224130831.25347-7-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Disposition: inline
In-Reply-To: <20200224130831.25347-7-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24.02.2020 15:08, Vladimir Oltean wrote:
>EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
>
>From: Vladimir Oltean <vladimir.oltean@nxp.com>
>
>The Felix driver is now using its own PHYLINK instance, not calling into
>ocelot_adjust_link. So the port_pcs_init function pointer is an
>unnecessary indirection. Remove it.
>
>Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
>---
> drivers/net/ethernet/mscc/ocelot.c       | 19 +++++++++++++++++--
> drivers/net/ethernet/mscc/ocelot_board.c | 24 ------------------------
> include/soc/mscc/ocelot.h                |  3 ---
> 3 files changed, 17 insertions(+), 29 deletions(-)
>
>diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
>index 3de8267180e2..2fc10b89bbcb 100644
>--- a/drivers/net/ethernet/mscc/ocelot.c
>+++ b/drivers/net/ethernet/mscc/ocelot.c
>@@ -442,8 +442,23 @@ void ocelot_adjust_link(struct ocelot *ocelot, int port,
>        ocelot_port_writel(ocelot_port, DEV_MAC_MODE_CFG_FDX_ENA |
>                           mode, DEV_MAC_MODE_CFG);
>
>-       if (ocelot->ops->pcs_init)
>-               ocelot->ops->pcs_init(ocelot, port);
>+       /* Disable HDX fast control */
>+       ocelot_port_writel(ocelot_port, DEV_PORT_MISC_HDX_FAST_DIS,
>+                          DEV_PORT_MISC);
>+
>+       /* SGMII only for now */
>+       ocelot_port_writel(ocelot_port, PCS1G_MODE_CFG_SGMII_MODE_ENA,
>+                          PCS1G_MODE_CFG);
>+       ocelot_port_writel(ocelot_port, PCS1G_SD_CFG_SD_SEL, PCS1G_SD_CFG);
>+
>+       /* Enable PCS */
>+       ocelot_port_writel(ocelot_port, PCS1G_CFG_PCS_ENA, PCS1G_CFG);
>+
>+       /* No aneg on SGMII */
>+       ocelot_port_writel(ocelot_port, 0, PCS1G_ANEG_CFG);
>+
>+       /* No loopback */
>+       ocelot_port_writel(ocelot_port, 0, PCS1G_LB_CFG);
>
>        /* Enable MAC module */
>        ocelot_port_writel(ocelot_port, DEV_MAC_ENA_CFG_RX_ENA |
>diff --git a/drivers/net/ethernet/mscc/ocelot_board.c b/drivers/net/ethernet/mscc/ocelot_board.c
>index 8b83a10083e2..5e21d0cc8335 100644
>--- a/drivers/net/ethernet/mscc/ocelot_board.c
>+++ b/drivers/net/ethernet/mscc/ocelot_board.c
>@@ -212,29 +212,6 @@ static const struct of_device_id mscc_ocelot_match[] = {
> };
> MODULE_DEVICE_TABLE(of, mscc_ocelot_match);
>
>-static void ocelot_port_pcs_init(struct ocelot *ocelot, int port)
>-{
>-       struct ocelot_port *ocelot_port = ocelot->ports[port];
>-
>-       /* Disable HDX fast control */
>-       ocelot_port_writel(ocelot_port, DEV_PORT_MISC_HDX_FAST_DIS,
>-                          DEV_PORT_MISC);
>-
>-       /* SGMII only for now */
>-       ocelot_port_writel(ocelot_port, PCS1G_MODE_CFG_SGMII_MODE_ENA,
>-                          PCS1G_MODE_CFG);
>-       ocelot_port_writel(ocelot_port, PCS1G_SD_CFG_SD_SEL, PCS1G_SD_CFG);
>-
>-       /* Enable PCS */
>-       ocelot_port_writel(ocelot_port, PCS1G_CFG_PCS_ENA, PCS1G_CFG);
>-
>-       /* No aneg on SGMII */
>-       ocelot_port_writel(ocelot_port, 0, PCS1G_ANEG_CFG);
>-
>-       /* No loopback */
>-       ocelot_port_writel(ocelot_port, 0, PCS1G_LB_CFG);
>-}
>-
> static int ocelot_reset(struct ocelot *ocelot)
> {
>        int retries = 100;
>@@ -259,7 +236,6 @@ static int ocelot_reset(struct ocelot *ocelot)
> }
>
> static const struct ocelot_ops ocelot_ops = {
>-       .pcs_init               = ocelot_port_pcs_init,
>        .reset                  = ocelot_reset,
> };
>
>diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
>index f63266a4ca70..31bcbc1ab2f9 100644
>--- a/include/soc/mscc/ocelot.h
>+++ b/include/soc/mscc/ocelot.h
>@@ -402,7 +402,6 @@ enum ocelot_tag_prefix {
> struct ocelot;
>
> struct ocelot_ops {
>-       void (*pcs_init)(struct ocelot *ocelot, int port);
>        int (*reset)(struct ocelot *ocelot);
> };
>
>@@ -479,8 +478,6 @@ struct ocelot {
>        struct mutex                    ptp_lock;
>        /* Protects the PTP clock */
>        spinlock_t                      ptp_clock_lock;
>-
>-       void (*port_pcs_init)(struct ocelot_port *port);
> };
>
> #define ocelot_read_ix(ocelot, reg, gi, ri) __ocelot_read_ix(ocelot, reg, reg##_GSZ * (gi) + reg##_RSZ * (ri))
>--
>2.17.1
>

Reviewed-by: Allan W. Nielsen <allan.nielsen@microchip.com>

