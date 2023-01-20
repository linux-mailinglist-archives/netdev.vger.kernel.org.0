Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DA46675AAD
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 18:02:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbjATRCQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 12:02:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230084AbjATRCP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 12:02:15 -0500
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AFF73D907
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 09:02:11 -0800 (PST)
Received: by mail-ot1-x334.google.com with SMTP id a1-20020a056830008100b006864df3b1f8so3433842oto.3
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 09:02:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=0N0aXy6f6wnbghPoHStvgU1CYwjHyN9JwqHH9S/wW7A=;
        b=quRkWJvZt6o86a/xLdJ1eif+njhXLfyqF5lw+8l1TAXGdc56bdxCLddjjl2FWIY0E/
         qxn7g07Tlv2Xw4VI9UH4vMwBQmhR19LZoWdgtEYOivn/I9gqW2xuwGsGQBzozZjjyjY+
         FI5a2sySOzud9IRC37c6Pxq3fDQbekNSKGqrTSoQq4elAycoGXddQYKsI4wmYTIlKWeL
         E7H8D0xXLn27PNxl6R8Hi79bjewdXkLvSr0hSojZhJGhInJIZdx2ueMauB5MIoTLshJv
         Df5ryknvtr3XxQGYRYiZIbp/3VpJX3bw3tETRdE5hYVpIpYbPr37BiuEo6hYj/nmUuDq
         4o+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0N0aXy6f6wnbghPoHStvgU1CYwjHyN9JwqHH9S/wW7A=;
        b=7L/dxraokattA9/2XraWZPNvat+zMTf2w9PFcTo4T/FaQLAFXTkR6vr8ivNT9vXNOf
         NByr6yr1szAa4TmfxY0ZAY+ZT3gI7lX9cVFHGxi4ORoXVQer29h1rFkDnBxZ8GlWzKfj
         58mTV8GyciyY/0YWwqsf4vtJFQscsvKaaSnHy8+7iOFyvF6oSWTSC4GWmovYzzkRsDMm
         w6/HJEsANsA2UqehXykwq2+Lt1BsbV+D7e0pC4nC8/qv4Nm7Ty0xy+EtxuQCPInFklni
         W6WVH6H86tePH8ITpNmDeR/gR9uckqXiMZBFO1eE12pSUGPRbUvE++krwVym3rfsXVHZ
         6kCw==
X-Gm-Message-State: AFqh2kq1sJ6fNRZLqplRU9VwytpzVbeweO18bsvTXdpPd1BKfvMftf7U
        dEBYllqKBUM3SdvNwGoM/khpQQdS15D9X8zk
X-Google-Smtp-Source: AMrXdXt+txhGjFaCeAdnWcS09CZvW3ifSEBl07xS40Qv2j11cBNffK/LCnA/v+Tevy3w8zT77BNMQw==
X-Received: by 2002:a05:6830:44d:b0:684:e099:389f with SMTP id d13-20020a056830044d00b00684e099389fmr6617728otc.27.1674234129747;
        Fri, 20 Jan 2023 09:02:09 -0800 (PST)
Received: from tresc054937.tre-sc.gov.br (177-131-126-82.acessoline.net.br. [177.131.126.82])
        by smtp.gmail.com with ESMTPSA id q2-20020a9d6542000000b0067088ff2b45sm21281403otl.37.2023.01.20.09.02.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Jan 2023 09:02:08 -0800 (PST)
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, alsi@bang-olufsen.dk, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        robh+dt@kernel.org, krzk+dt@kernel.org, arinc.unal@arinc9.com,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Subject: [PATCH net-next] net: dsa: realtek: rtl8365mb: add change_mtu
Date:   Fri, 20 Jan 2023 14:00:26 -0300
Message-Id: <20230120170025.20178-1-luizluca@gmail.com>
X-Mailer: git-send-email 2.39.0
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
 drivers/net/dsa/realtek/rtl8365mb.c | 63 +++++++++++++++++++++++++++--
 1 file changed, 59 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/realtek/rtl8365mb.c b/drivers/net/dsa/realtek/rtl8365mb.c
index da31d8b839ac..da9e5f16c8cc 100644
--- a/drivers/net/dsa/realtek/rtl8365mb.c
+++ b/drivers/net/dsa/realtek/rtl8365mb.c
@@ -98,6 +98,7 @@
 #include <linux/of_irq.h>
 #include <linux/regmap.h>
 #include <linux/if_bridge.h>
+#include <linux/if_vlan.h>
 
 #include "realtek.h"
 
@@ -267,6 +268,12 @@
 /* Maximum packet length register */
 #define RTL8365MB_CFG0_MAX_LEN_REG	0x088C
 #define   RTL8365MB_CFG0_MAX_LEN_MASK	0x3FFF
+/* Not sure but it is the default value after reset */
+#define RTL8365MB_CFG0_MAX_LEN_MAX	0x3FF0
+
+#define RTL8365MB_FLOWCTRL_JUMBO_SIZE_REG	0x123B
+#define  RTL8365MB_FLOWCTRL_JUMBO_SIZE_MASK	GENMASK(1,0)
+#define  RTL8365MB_FLOWCTRL_JUMBO_ENABLE_MASK	GENMASK(2,2)
 
 /* Port learning limit registers */
 #define RTL8365MB_LUT_PORT_LEARN_LIMIT_BASE		0x0A20
@@ -309,6 +316,14 @@
  */
 #define RTL8365MB_STATS_INTERVAL_JIFFIES	(3 * HZ)
 
+/* FIXME: is k in {3,4,6,9}k 1000 or 1024 */
+enum rtl8365mb_jumbo_size {
+	RTL8365MB_JUMBO_SIZE_3K = 0,
+	RTL8365MB_JUMBO_SIZE_4K,
+	RTL8365MB_JUMBO_SIZE_6K,
+	RTL8365MB_JUMBO_SIZE_9K
+};
+
 enum rtl8365mb_mib_counter_index {
 	RTL8365MB_MIB_ifInOctets,
 	RTL8365MB_MIB_dot3StatsFCSErrors,
@@ -1135,6 +1150,44 @@ static void rtl8365mb_phylink_mac_link_up(struct dsa_switch *ds, int port,
 	}
 }
 
+static int rtl8365mb_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
+{
+	struct realtek_priv *priv = ds->priv;
+
+	/* When a new MTU is set, DSA always set the CPU port's MTU to the
+	 * largest MTU of the slave ports. Because the switch only has a global
+	 * RX length register, only allowing CPU port here is enough.
+	 */
+	if (!dsa_is_cpu_port(ds, port))
+		return 0;
+
+	new_mtu += VLAN_ETH_HLEN + ETH_FCS_LEN;
+
+	/* FIXME: We might need to adjust the jumbo size as well. However, the
+	 * device seems to forward at least up to mtu=2018 (test device limit)
+	 * even with jumbo frames disabled.
+	 */
+	/* This is the switch state after reset */
+	/*enum rtl8365mb_jumbo_size jumbo_size = RTL8365MB_JUMBO_SIZE_6K;
+
+	regmap_update_bits(priv->map, RTL8365MB_FLOWCTRL_JUMBO_SIZE_REG,
+			   RTL8365MB_FLOWCTRL_JUMBO_ENABLE_MASK |
+			   RTL8365MB_FLOWCTRL_JUMBO_SIZE_MASK,
+			   FIELD_PREP(RTL8365MB_FLOWCTRL_JUMBO_ENABLE_MASK,1) |
+			   FIELD_PREP(RTL8365MB_FLOWCTRL_JUMBO_SIZE_MASK,
+				      jumbo_size));
+	*/
+
+	return regmap_update_bits(priv->map, RTL8365MB_CFG0_MAX_LEN_REG,
+				 RTL8365MB_CFG0_MAX_LEN_MASK,
+				 FIELD_PREP(RTL8365MB_CFG0_MAX_LEN_MASK, new_mtu));
+}
+
+static int rtl8365mb_max_mtu(struct dsa_switch *ds, int port)
+{
+	return RTL8365MB_CFG0_MAX_LEN_MAX - VLAN_ETH_HLEN - ETH_FCS_LEN;
+}
+
 static void rtl8365mb_port_stp_state_set(struct dsa_switch *ds, int port,
 					 u8 state)
 {
@@ -1980,10 +2033,8 @@ static int rtl8365mb_setup(struct dsa_switch *ds)
 		p->index = i;
 	}
 
-	/* Set maximum packet length to 1536 bytes */
-	ret = regmap_update_bits(priv->map, RTL8365MB_CFG0_MAX_LEN_REG,
-				 RTL8365MB_CFG0_MAX_LEN_MASK,
-				 FIELD_PREP(RTL8365MB_CFG0_MAX_LEN_MASK, 1536));
+	/* Set packet length from 16368 to 1500+14+4+4=1522 */
+	ret = rtl8365mb_change_mtu(ds, cpu->trap_port, ETH_DATA_LEN);
 	if (ret)
 		goto out_teardown_irq;
 
@@ -2103,6 +2154,8 @@ static const struct dsa_switch_ops rtl8365mb_switch_ops_smi = {
 	.get_eth_mac_stats = rtl8365mb_get_mac_stats,
 	.get_eth_ctrl_stats = rtl8365mb_get_ctrl_stats,
 	.get_stats64 = rtl8365mb_get_stats64,
+	.port_change_mtu = rtl8365mb_change_mtu,
+	.port_max_mtu = rtl8365mb_max_mtu,
 };
 
 static const struct dsa_switch_ops rtl8365mb_switch_ops_mdio = {
@@ -2124,6 +2177,8 @@ static const struct dsa_switch_ops rtl8365mb_switch_ops_mdio = {
 	.get_eth_mac_stats = rtl8365mb_get_mac_stats,
 	.get_eth_ctrl_stats = rtl8365mb_get_ctrl_stats,
 	.get_stats64 = rtl8365mb_get_stats64,
+	.port_change_mtu = rtl8365mb_change_mtu,
+	.port_max_mtu = rtl8365mb_max_mtu,
 };
 
 static const struct realtek_ops rtl8365mb_ops = {
-- 
2.39.0

