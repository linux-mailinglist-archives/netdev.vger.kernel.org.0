Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C721169BDE9
	for <lists+netdev@lfdr.de>; Sun, 19 Feb 2023 00:16:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbjBRXLy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Feb 2023 18:11:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbjBRXLx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Feb 2023 18:11:53 -0500
Received: from mail-oa1-x34.google.com (mail-oa1-x34.google.com [IPv6:2001:4860:4864:20::34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03ED0125B3
        for <netdev@vger.kernel.org>; Sat, 18 Feb 2023 15:11:52 -0800 (PST)
Received: by mail-oa1-x34.google.com with SMTP id 586e51a60fabf-171af91a690so1805026fac.3
        for <netdev@vger.kernel.org>; Sat, 18 Feb 2023 15:11:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=IOo899XjDrccg46icxgw4usvBeZgoioUX9efB6xORSk=;
        b=ZIy0Ym37NjYmrjiae97SwYH0Zt1mioSEA2mu28hvNaR2hHfd06EHTTMxZYPjATy6d1
         HOR7KSY7VwedWw158T7ctOnJa7uaw1+uD3yarTMotbxcKF+hU2Pfd+mSZzkhLLRc6we2
         aOtMU8Le65el7dtDZ3R07OLSIAZROTMpji6LfOH7FRHLD/8S2WHI7dGh7ATFlHKye8e8
         numJUJTqT0ozcLH4VMOS+8VN5Xaj8bLQ9qE8MTr3i41BJRPDbOTymmPP+gXwHJzw6G5u
         wqCq/mtjjBwfou9mFYcG2Sq/a4PIoYtAOnv8uEemzj6RlV6tp8MC8JT4tg8LEf2uXYrq
         H9vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IOo899XjDrccg46icxgw4usvBeZgoioUX9efB6xORSk=;
        b=PIukjrgoytR5BDSBCpTujSdKWs36xuRnuc6z5/Gjb0jFLUyQSN/BpTLEsLi+0c4F/y
         MtusHnPvuN8XNvvSXUQOf52iYUv0wYu/JLVi0diVVRBLZf0YWwvDkHlE3O4pkcFLu4js
         QsHfLkx57k6M8nJvuFMD7NDpbNjuhekIzI4bWMbNp+bILjXygOLHtCUx5fGaDrpSZvVL
         ceEbM0DEpW1HAbwSrFNsyL0qFRgk9agdh2pezhZD8lU200sK7pXPc9Of5FFj7zM+/dRl
         RhNv45zAdhFUYYHpPja86yVPYY3ExFLCURB9FToWWGGzL//8ZZSoewc+QNS1VUAZfWEl
         zpog==
X-Gm-Message-State: AO0yUKVd2g4nS1kwP/o74Ydqi5+3qnOfSpVUBiFwkju1aqpCZfXWvWIZ
        Ac0pVvOJR1oA4reo9OuyJpFLJjNRp+TCvw==
X-Google-Smtp-Source: AK7set8AHGbkWHAtj4iKgQ0VKCa6px9rmv6s07+YoXwk9NthjKm3xex7ogP5s4VPj/8ow/L5eneEoQ==
X-Received: by 2002:a05:6870:2397:b0:16e:81e4:867b with SMTP id e23-20020a056870239700b0016e81e4867bmr5234443oap.14.1676761909934;
        Sat, 18 Feb 2023 15:11:49 -0800 (PST)
Received: from tresc054937.tre-sc.gov.br (177-131-126-82.acessoline.net.br. [177.131.126.82])
        by smtp.gmail.com with ESMTPSA id q9-20020a4a7d49000000b004fc4000ae48sm3353322ooe.15.2023.02.18.15.11.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Feb 2023 15:11:48 -0800 (PST)
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, alsi@bang-olufsen.dk, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        robh+dt@kernel.org, krzk+dt@kernel.org, arinc.unal@arinc9.com,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Subject: [PATCH net-next v3] net: dsa: realtek: rtl8365mb: add change_mtu
Date:   Sat, 18 Feb 2023 20:06:37 -0300
Message-Id: <20230218230636.5528-1-luizluca@gmail.com>
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

The rtl8365mb was using a fixed MTU size of 1536, which was probably
inspired by the rtl8366rb's initial packet size. However, unlike that
family, the rtl8365mb family can specify the max packet size in bytes,
rather than in fixed steps. The max packet size now defaults to
VLAN_ETH_HLEN+ETH_DATA_LEN+ETH_FCS_LEN, which is 1522 bytes.

DSA calls change_mtu for the CPU port once the max MTU value among the
ports changes. As the max packet size is defined globally, the switch
is configured only when the call affects the CPU port.

The available specifications do not directly define the max supported
packet size, but it mentions a 16k limit. This driver will use the 0x3FFF
limit as it is used in the vendor API code. However, the switch sets the
max packet size to 16368 bytes (0x3FF0) after it resets.

change_mtu uses MTU size, or ethernet payload size, while the switch
works with frame size. The frame size is calculated considering the
ethernet header (14 bytes), a possible 802.1Q tag (4 bytes), the payload
size (MTU), and the Ethernet FCS (4 bytes). The CPU tag (8 bytes) is
consumed before the switch enforces the limit.

MTU was tested up to 2018 (with 802.1Q) as that is as far as mt7620
(where rtl8367s is stacked) can go. The register was manually
manipulated byte-by-byte to ensure the MTU to frame size conversion was
correct. For frames without 802.1Q tag, the frame size limit will be 4
bytes over the required size.

There is a jumbo register, enabled by default at 6k packet size.
However, the jumbo settings do not seem to limit nor expand the maximum
tested MTU (2018), even when jumbo is disabled. More tests are needed
with a device that can handle larger frames.

Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
---

v2->v3:
- changed max frame size to 0x3FFF (used by vendor API)
- added info about how frame size is calculated, some more description
  about the tests performed and the 4 extra bytes when untagged frame is
  used.

v1->v2:
- dropped jumbo code as it was not changing the behavior (up to 2k MTU)
- fixed typos
- fixed code alignment
- renamed rtl8365mb_(change|max)_mtu to rtl8365mb_port_(change|max)_mtu

 drivers/net/dsa/realtek/rtl8365mb.c | 41 ++++++++++++++++++++++++++---
 1 file changed, 37 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/realtek/rtl8365mb.c b/drivers/net/dsa/realtek/rtl8365mb.c
index da31d8b839ac..05642c617c3b 100644
--- a/drivers/net/dsa/realtek/rtl8365mb.c
+++ b/drivers/net/dsa/realtek/rtl8365mb.c
@@ -98,6 +98,7 @@
 #include <linux/of_irq.h>
 #include <linux/regmap.h>
 #include <linux/if_bridge.h>
+#include <linux/if_vlan.h>
 
 #include "realtek.h"
 
@@ -267,6 +268,7 @@
 /* Maximum packet length register */
 #define RTL8365MB_CFG0_MAX_LEN_REG	0x088C
 #define   RTL8365MB_CFG0_MAX_LEN_MASK	0x3FFF
+#define RTL8365MB_CFG0_MAX_LEN_MAX	0x3FFF
 
 /* Port learning limit registers */
 #define RTL8365MB_LUT_PORT_LEARN_LIMIT_BASE		0x0A20
@@ -1135,6 +1137,36 @@ static void rtl8365mb_phylink_mac_link_up(struct dsa_switch *ds, int port,
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
@@ -1980,10 +2012,7 @@ static int rtl8365mb_setup(struct dsa_switch *ds)
 		p->index = i;
 	}
 
-	/* Set maximum packet length to 1536 bytes */
-	ret = regmap_update_bits(priv->map, RTL8365MB_CFG0_MAX_LEN_REG,
-				 RTL8365MB_CFG0_MAX_LEN_MASK,
-				 FIELD_PREP(RTL8365MB_CFG0_MAX_LEN_MASK, 1536));
+	ret = rtl8365mb_port_change_mtu(ds, cpu->trap_port, ETH_DATA_LEN);
 	if (ret)
 		goto out_teardown_irq;
 
@@ -2103,6 +2132,8 @@ static const struct dsa_switch_ops rtl8365mb_switch_ops_smi = {
 	.get_eth_mac_stats = rtl8365mb_get_mac_stats,
 	.get_eth_ctrl_stats = rtl8365mb_get_ctrl_stats,
 	.get_stats64 = rtl8365mb_get_stats64,
+	.port_change_mtu = rtl8365mb_port_change_mtu,
+	.port_max_mtu = rtl8365mb_port_max_mtu,
 };
 
 static const struct dsa_switch_ops rtl8365mb_switch_ops_mdio = {
@@ -2124,6 +2155,8 @@ static const struct dsa_switch_ops rtl8365mb_switch_ops_mdio = {
 	.get_eth_mac_stats = rtl8365mb_get_mac_stats,
 	.get_eth_ctrl_stats = rtl8365mb_get_ctrl_stats,
 	.get_stats64 = rtl8365mb_get_stats64,
+	.port_change_mtu = rtl8365mb_port_change_mtu,
+	.port_max_mtu = rtl8365mb_port_max_mtu,
 };
 
 static const struct realtek_ops rtl8365mb_ops = {
-- 
2.39.1

