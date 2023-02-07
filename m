Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B96F68DEC7
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 18:21:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbjBGRVB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 12:21:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbjBGRUy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 12:20:54 -0500
Received: from mail-oo1-xc2e.google.com (mail-oo1-xc2e.google.com [IPv6:2607:f8b0:4864:20::c2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14BF24EE4
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 09:20:53 -0800 (PST)
Received: by mail-oo1-xc2e.google.com with SMTP id y13-20020a4ae7cd000000b0051a750e2ebdso784208oov.5
        for <netdev@vger.kernel.org>; Tue, 07 Feb 2023 09:20:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=xaIdI+pDtgFlzvHKJ6/6jS24g70+oOOyNEzlBu52axw=;
        b=QCw9lTi2o0MbdkDniDtzIAxw6u7XNPv8rQH2Gy0Shb+vSf1sqpvRIzICVUJOw4+M/H
         gvYMSwqmplnrbVVx2CrN+CtNgjzemasx/6ug984EZHAwsy0w9F1v018eRLeZFjbjY2S9
         vo/PfKyrNiuRKEeH8EG0h4SR9B4ozEPa2wkQr1H4gR4cqGUNAwVN2+mtAkjCUylNADWu
         oy5nDBzaAYMw9UgsNf9/2tjOE4NOTYL853TFo4Itm5cWbC4MWdGdZMzymdBmVkYgoSYM
         PRogwVxT6HGS1EZm1afmk7k4kAcSN89w30MWmdst/sSB6pzgURgkVt7xcGxFNB/v6mJ5
         satA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xaIdI+pDtgFlzvHKJ6/6jS24g70+oOOyNEzlBu52axw=;
        b=Y5AkGAL+z1tuqMH6X03v1s6l+8rCjty0CR7S3DHYOGmafLUXI+Cu7rc8VpzDo/RWOY
         zfd+C/AunNfv4gQM7j7xChsso1q8NDgnYuEbypretWiMUl3SC0pyu9x5gMfAlPYCfh3C
         +q98ue56eZC+DTB6CMMtsS288pEvjJkdASHqa0NfkWzj365x9kIBn828TwFBlVfC3kyX
         u1f9BrJMnQESu8LI+gbPbnj0ZEuGXXfK4iH6VTNO2IEoK0r58Fy1h+vHEJs/2Bx1ijt8
         Tr8NMBHCky1sF7X8ZpKV9WTb4qx/jhPVTIiegeiCMRXcR70I0gerLUvgybuXR1L1n6cw
         cqFw==
X-Gm-Message-State: AO0yUKX+nQoZLgjrhLN9z1quRUMxczKRdjuXWw23Bk3AhpxUrrYYr2dw
        /UlF7nUqCxPemIQfj0LrCacb3ULZlNyBfp/v
X-Google-Smtp-Source: AK7set9Nj0HQb9XI/POL2J+rosTIJ5h/lZuThGCQubLtKwZtYxyP5vcUtQDcc8JKDeXY9/PApLTAEQ==
X-Received: by 2002:a4a:e2c6:0:b0:51a:a3fd:69d3 with SMTP id l6-20020a4ae2c6000000b0051aa3fd69d3mr1795925oot.2.1675790451607;
        Tue, 07 Feb 2023 09:20:51 -0800 (PST)
Received: from tresc054937.tre-sc.gov.br (177-131-126-82.acessoline.net.br. [177.131.126.82])
        by smtp.gmail.com with ESMTPSA id l6-20020a4a2706000000b004a3527e8279sm6249911oof.0.2023.02.07.09.20.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Feb 2023 09:20:50 -0800 (PST)
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, alsi@bang-olufsen.dk, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        robh+dt@kernel.org, krzk+dt@kernel.org, arinc.unal@arinc9.com,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Subject: [PATCH net-next v2] net: dsa: realtek: rtl8365mb: add change_mtu
Date:   Tue,  7 Feb 2023 14:15:58 -0300
Message-Id: <20230207171557.13034-1-luizluca@gmail.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

rtl8365mb was using a fixed MTU size of 1536, probably inspired by
rtl8366rb initial packet size. Different from that family, rtl8365mb
family can specify the max packet size in bytes and not in fixed steps.
Now it defaults to VLAN_ETH_HLEN+ETH_DATA_LEN+ETH_FCS_LEN (1522 bytes).

DSA calls change_mtu for the CPU port once the max mtu value among the
ports changes. As the max packet size is defined globally, the switch
is configured only when the call affects the CPU port.

The available specs do not directly define the max supported packet
size, but it mentions a 16k limit. However, the switch sets the max
packet size to 16368 bytes (0x3FF0) after it resets. That value was
assumed as the maximum supported packet size.

MTU was tested up to 2018 (with 802.1Q) as that is as far as mt7620
(where rtl8367s is stacked) can go.

There is a jumbo register, enabled by default at 6k packet size.
However, the jumbo settings does not seem to limit nor expand the
maximum tested MTU (2018), even when jumbo is disabled. More tests are
needed with a device that can handle larger frames.

Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
---

v1->v2:
- dropped jumbo code as it was not changing the behavior (up to 2k MTU)
- fixed typos
- fixed code alignment
- renamed rtl8365mb_(change|max)_mtu to rtl8365mb_port_(change|max)_mtu

 drivers/net/dsa/realtek/rtl8365mb.c | 43 ++++++++++++++++++++++++++---
 1 file changed, 39 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/realtek/rtl8365mb.c b/drivers/net/dsa/realtek/rtl8365mb.c
index da31d8b839ac..c3e0a5b55738 100644
--- a/drivers/net/dsa/realtek/rtl8365mb.c
+++ b/drivers/net/dsa/realtek/rtl8365mb.c
@@ -98,6 +98,7 @@
 #include <linux/of_irq.h>
 #include <linux/regmap.h>
 #include <linux/if_bridge.h>
+#include <linux/if_vlan.h>
 
 #include "realtek.h"
 
@@ -267,6 +268,8 @@
 /* Maximum packet length register */
 #define RTL8365MB_CFG0_MAX_LEN_REG	0x088C
 #define   RTL8365MB_CFG0_MAX_LEN_MASK	0x3FFF
+/* Not sure but it is the default value after reset */
+#define RTL8365MB_CFG0_MAX_LEN_MAX	0x3FF0
 
 /* Port learning limit registers */
 #define RTL8365MB_LUT_PORT_LEARN_LIMIT_BASE		0x0A20
@@ -1135,6 +1138,36 @@ static void rtl8365mb_phylink_mac_link_up(struct dsa_switch *ds, int port,
 	}
 }
 
+static int rtl8365mb_port_change_mtu(struct dsa_switch *ds, int port,
+				     int new_mtu)
+{
+	struct realtek_priv *priv = ds->priv;
+	int frame_size;
+
+	/* When a new MTU is set, DSA always sets the CPU port's MTU to the
+	 * largest MTU of the slave ports. Because the switch only has a global
+	 * RX length register, only allowing CPU port here is enough.
+	 */
+
+	if (!dsa_is_cpu_port(ds, port))
+		return 0;
+
+	frame_size = new_mtu + VLAN_ETH_HLEN + ETH_FCS_LEN;
+
+	dev_dbg(priv->dev, "changing mtu to %d (frame size: %d)\n",
+		new_mtu, frame_size);
+
+	return regmap_update_bits(priv->map, RTL8365MB_CFG0_MAX_LEN_REG,
+				  RTL8365MB_CFG0_MAX_LEN_MASK,
+				  FIELD_PREP(RTL8365MB_CFG0_MAX_LEN_MASK,
+					     frame_size));
+}
+
+static int rtl8365mb_port_max_mtu(struct dsa_switch *ds, int port)
+{
+	return RTL8365MB_CFG0_MAX_LEN_MAX - VLAN_ETH_HLEN - ETH_FCS_LEN;
+}
+
 static void rtl8365mb_port_stp_state_set(struct dsa_switch *ds, int port,
 					 u8 state)
 {
@@ -1980,10 +2013,8 @@ static int rtl8365mb_setup(struct dsa_switch *ds)
 		p->index = i;
 	}
 
-	/* Set maximum packet length to 1536 bytes */
-	ret = regmap_update_bits(priv->map, RTL8365MB_CFG0_MAX_LEN_REG,
-				 RTL8365MB_CFG0_MAX_LEN_MASK,
-				 FIELD_PREP(RTL8365MB_CFG0_MAX_LEN_MASK, 1536));
+	/* Set packet length from 16368 to 1500+14+4+4=1522 */
+	ret = rtl8365mb_port_change_mtu(ds, cpu->trap_port, ETH_DATA_LEN);
 	if (ret)
 		goto out_teardown_irq;
 
@@ -2103,6 +2134,8 @@ static const struct dsa_switch_ops rtl8365mb_switch_ops_smi = {
 	.get_eth_mac_stats = rtl8365mb_get_mac_stats,
 	.get_eth_ctrl_stats = rtl8365mb_get_ctrl_stats,
 	.get_stats64 = rtl8365mb_get_stats64,
+	.port_change_mtu = rtl8365mb_port_change_mtu,
+	.port_max_mtu = rtl8365mb_port_max_mtu,
 };
 
 static const struct dsa_switch_ops rtl8365mb_switch_ops_mdio = {
@@ -2124,6 +2157,8 @@ static const struct dsa_switch_ops rtl8365mb_switch_ops_mdio = {
 	.get_eth_mac_stats = rtl8365mb_get_mac_stats,
 	.get_eth_ctrl_stats = rtl8365mb_get_ctrl_stats,
 	.get_stats64 = rtl8365mb_get_stats64,
+	.port_change_mtu = rtl8365mb_port_change_mtu,
+	.port_max_mtu = rtl8365mb_port_max_mtu,
 };
 
 static const struct realtek_ops rtl8365mb_ops = {
-- 
2.39.1

