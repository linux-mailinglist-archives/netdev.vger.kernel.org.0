Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3586349F349
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 07:06:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346293AbiA1GGZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 01:06:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346302AbiA1GGW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 01:06:22 -0500
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77AE7C061747
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 22:06:22 -0800 (PST)
Received: by mail-oi1-x234.google.com with SMTP id b186so4325795oif.1
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 22:06:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7kZ9WO66ZNSDGNgHPQhhXctIvQgelMAuZayhbDQhfE0=;
        b=XtGcPB1Z4oN1Z1WxUc5S/lzTCsSHUCnkhO2iy6xOwMW9v1Eih98tPdagOvxOIViWz6
         /aAEc8f+lJWTNLZlf2PJtbiuhV1mc2us8mBMmtzC594cb2RBkWgeZt4dBdPawWWyYAIQ
         /Stl9n6Z1n6ZorJ9aE0WASsUOmbmBcerkLs9xs3TfhAspBUrG+NfsZxarJbFuqPUBEeD
         /2v6zkoMz6XG/n54Fe8RKn0pzphKShZO+SXV4JOaa1aWyH0LZgHYm5jZdDwUoJv4uYNf
         kHc1V3Rf7khTZU4vaeRnrNdFkko1PvgOQUyymZ4ll13p59zPk6H8ldatw2wA2BYSdsR/
         AHYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7kZ9WO66ZNSDGNgHPQhhXctIvQgelMAuZayhbDQhfE0=;
        b=KscWvmpYCkTWk7E3s8ieYQQSILreMhiDPlg8ZUpU/c+LoIsPdXj1Rn8wMiAoK04iyp
         npT3eYSS4TyWTCqBr2qp6K0j8/ROyuAxKtbK/qhY1WjhqchIUwbLvAjPkBDvpstg4Jvd
         emBKQFdES/yQtXt5RflbFUFjwz+TRvrtK0yZ4DwOQd+o7XdBRhGDZNuFXpKcH5329DKB
         nmeKk1kFmgrEjSFDMwtMKNivs+0oj99NooL/OPI/5DNXihi1nUEHbzARwPCGrnfKxw+B
         bs5mw/kWyUes/jkWTU56WWDAS9EQ/VTXMKbk4fY5lcOlF0NaPj0MV0XnuoCTLT2r638X
         E0PA==
X-Gm-Message-State: AOAM533LvxSg/GqipBgu/5ELCgboojI6jBNXtnA9RYy5zVxv7kRhaJKm
        vQ8G6juYHAvhc++fchH5qhX4ja/KunNltg==
X-Google-Smtp-Source: ABdhPJwGm78VZqOEUKcWodtWLD5O2GS1Eaub1nw7I4woqWN0jyAubNf/SCzTjeaaPVKs3qQzhV1miw==
X-Received: by 2002:aca:59d4:: with SMTP id n203mr4810107oib.293.1643349981639;
        Thu, 27 Jan 2022 22:06:21 -0800 (PST)
Received: from tresc043793.tre-sc.gov.br (187-049-235-234.floripa.net.br. [187.49.235.234])
        by smtp.gmail.com with ESMTPSA id m23sm9790229oos.6.2022.01.27.22.06.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jan 2022 22:06:21 -0800 (PST)
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, alsi@bang-olufsen.dk,
        arinc.unal@arinc9.com, frank-w@public-files.de,
        davem@davemloft.net, kuba@kernel.org,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Subject: [PATCH net-next v6 12/13] net: dsa: realtek: rtl8365mb: allow non-cpu extint ports
Date:   Fri, 28 Jan 2022 03:05:08 -0300
Message-Id: <20220128060509.13800-13-luizluca@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220128060509.13800-1-luizluca@gmail.com>
References: <20220128060509.13800-1-luizluca@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

External interfaces can be configured, even if they are not CPU ports.
The first CPU port will also be the trap port (for receiving trapped
frames from the switch).

The CPU information was dropped from chip data as it was not used
outside setup. The only other place it was used is when it wrongly
checks for CPU port when it should check for extint.

The supported modes check now uses port type and not port usage.

As a byproduct, more than one CPU can be configured. although this
might not work well with DSA setups. Also, this driver is still only
blindly forwarding all traffic to CPU port(s).

This change was not tested in a device with multiple active external
interfaces ports.

realtek_priv->cpu_port is now only used by rtl8366rb.c

Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
---
 drivers/net/dsa/realtek/rtl8365mb.c | 61 ++++++++++++-----------------
 1 file changed, 26 insertions(+), 35 deletions(-)

diff --git a/drivers/net/dsa/realtek/rtl8365mb.c b/drivers/net/dsa/realtek/rtl8365mb.c
index 174496e4d736..34c99e7539e7 100644
--- a/drivers/net/dsa/realtek/rtl8365mb.c
+++ b/drivers/net/dsa/realtek/rtl8365mb.c
@@ -566,7 +566,6 @@ struct rtl8365mb_port {
  * @chip_ver: chip silicon revision
  * @port_mask: mask of all ports
  * @learn_limit_max: maximum number of L2 addresses the chip can learn
- * @cpu: CPU tagging and CPU port configuration for this chip
  * @mib_lock: prevent concurrent reads of MIB counters
  * @ports: per-port data
  * @jam_table: chip-specific initialization jam table
@@ -581,7 +580,6 @@ struct rtl8365mb {
 	u32 chip_ver;
 	u32 port_mask;
 	u32 learn_limit_max;
-	struct rtl8365mb_cpu cpu;
 	struct mutex mib_lock;
 	struct rtl8365mb_port ports[RTL8365MB_MAX_NUM_PORTS];
 	const struct rtl8365mb_jam_tbl_entry *jam_table;
@@ -786,14 +784,6 @@ static int rtl8365mb_ext_config_rgmii(struct realtek_priv *priv, int port,
 	u32 val;
 	int ret;
 
-	if (port != priv->cpu_port) {
-		dev_err(priv->dev, "only one EXT interface is currently supported\n");
-		return -EINVAL;
-	}
-
-	dp = dsa_to_port(priv->ds, port);
-	dn = dp->dn;
-
 	ext_int = rtl8365mb_extint_port_map[port];
 
 	if (ext_int <= 0) {
@@ -801,6 +791,9 @@ static int rtl8365mb_ext_config_rgmii(struct realtek_priv *priv, int port,
 		return -EINVAL;
 	}
 
+	dp = dsa_to_port(priv->ds, port);
+	dn = dp->dn;
+
 	/* Set the RGMII TX/RX delay
 	 *
 	 * The Realtek vendor driver indicates the following possible
@@ -877,11 +870,6 @@ static int rtl8365mb_ext_config_forcemode(struct realtek_priv *priv, int port,
 	int val;
 	int ret;
 
-	if (port != priv->cpu_port) {
-		dev_err(priv->dev, "only one EXT interface is currently supported\n");
-		return -EINVAL;
-	}
-
 	ext_int = rtl8365mb_extint_port_map[port];
 
 	if (ext_int <= 0) {
@@ -946,13 +934,17 @@ static int rtl8365mb_ext_config_forcemode(struct realtek_priv *priv, int port,
 static bool rtl8365mb_phy_mode_supported(struct dsa_switch *ds, int port,
 					 phy_interface_t interface)
 {
-	if (dsa_is_user_port(ds, port) &&
+	int ext_int;
+
+	ext_int = rtl8365mb_extint_port_map[port];
+
+	if (ext_int < 0 &&
 	    (interface == PHY_INTERFACE_MODE_NA ||
 	     interface == PHY_INTERFACE_MODE_INTERNAL ||
 	     interface == PHY_INTERFACE_MODE_GMII))
 		/* Internal PHY */
 		return true;
-	else if (dsa_is_cpu_port(ds, port) &&
+	else if ((ext_int >= 1) &&
 		 phy_interface_mode_is_rgmii(interface))
 		/* Extension MAC */
 		return true;
@@ -1755,10 +1747,8 @@ static void rtl8365mb_irq_teardown(struct realtek_priv *priv)
 	}
 }
 
-static int rtl8365mb_cpu_config(struct realtek_priv *priv)
+static int rtl8365mb_cpu_config(struct realtek_priv *priv, const struct rtl8365mb_cpu *cpu)
 {
-	struct rtl8365mb *mb = priv->chip_data;
-	struct rtl8365mb_cpu *cpu = &mb->cpu;
 	u32 val;
 	int ret;
 
@@ -1830,6 +1820,7 @@ static int rtl8365mb_reset_chip(struct realtek_priv *priv)
 static int rtl8365mb_setup(struct dsa_switch *ds)
 {
 	struct realtek_priv *priv = ds->priv;
+	struct rtl8365mb_cpu cpu = {0};
 	struct dsa_port *cpu_dp;
 	struct rtl8365mb *mb;
 	int ret;
@@ -1858,18 +1849,24 @@ static int rtl8365mb_setup(struct dsa_switch *ds)
 		dev_info(priv->dev, "no interrupt support\n");
 
 	/* Configure CPU tagging */
-	/* Currently, only one CPU port is supported */
+	cpu.trap_port = RTL8365MB_MAX_NUM_PORTS;
 	dsa_switch_for_each_cpu_port(cpu_dp, priv->ds) {
-		priv->cpu_port = cpu_dp->index;
-		mb->cpu.mask = BIT(priv->cpu_port);
-		mb->cpu.trap_port = priv->cpu_port;
-		ret = rtl8365mb_cpu_config(priv);
-		if (ret)
-			goto out_teardown_irq;
+		cpu.mask |= BIT(cpu_dp->index);
 
-		break;
+		if (cpu.trap_port == RTL8365MB_MAX_NUM_PORTS)
+			cpu.trap_port = cpu_dp->index;
 	}
 
+	cpu.enable = cpu.mask > 0;
+	cpu.insert = RTL8365MB_CPU_INSERT_TO_ALL;
+	cpu.position = RTL8365MB_CPU_POS_AFTER_SA;
+	cpu.rx_length = RTL8365MB_CPU_RXLEN_64BYTES;
+	cpu.format = RTL8365MB_CPU_FORMAT_8BYTES;
+
+	ret = rtl8365mb_cpu_config(priv, &cpu);
+	if (ret)
+		goto out_teardown_irq;
+
 	/* Configure ports */
 	for (i = 0; i < priv->num_ports; i++) {
 		struct rtl8365mb_port *p = &mb->ports[i];
@@ -1878,7 +1875,7 @@ static int rtl8365mb_setup(struct dsa_switch *ds)
 			continue;
 
 		/* Forward only to the CPU */
-		ret = rtl8365mb_port_set_isolation(priv, i, BIT(priv->cpu_port));
+		ret = rtl8365mb_port_set_isolation(priv, i, cpu.mask);
 		if (ret)
 			goto out_teardown_irq;
 
@@ -2008,12 +2005,6 @@ static int rtl8365mb_detect(struct realtek_priv *priv)
 		mb->jam_table = rtl8365mb_init_jam_8365mb_vc;
 		mb->jam_size = ARRAY_SIZE(rtl8365mb_init_jam_8365mb_vc);
 
-		mb->cpu.enable = 1;
-		mb->cpu.insert = RTL8365MB_CPU_INSERT_TO_ALL;
-		mb->cpu.position = RTL8365MB_CPU_POS_AFTER_SA;
-		mb->cpu.rx_length = RTL8365MB_CPU_RXLEN_64BYTES;
-		mb->cpu.format = RTL8365MB_CPU_FORMAT_8BYTES;
-
 		break;
 	default:
 		dev_err(priv->dev,
-- 
2.34.1

