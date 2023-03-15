Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E7D66BA5CB
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 04:52:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229506AbjCODwb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 23:52:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjCODw3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 23:52:29 -0400
Received: from mail-oa1-x36.google.com (mail-oa1-x36.google.com [IPv6:2001:4860:4864:20::36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC2E1125A7
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 20:52:26 -0700 (PDT)
Received: by mail-oa1-x36.google.com with SMTP id 586e51a60fabf-17ac5ee3f9cso856834fac.12
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 20:52:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678852345;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=9IlRZaVdETODnIeJiH7tzFm53sIPKv5rZykUvVgbm0I=;
        b=TBxmaqT0Nfmkb5YUrmrok20lzpcinvnn6Cq6ag3XEpgMYUV68G0k3saOvIjCELH2uS
         GOU9E1IixVkEp/sxns/B2BMxTVZ9UeSfy843XJj1Y+dFBT/xapbFQhv+OwUaOceZshBA
         xw3N9Tw41eSNYyany+3vxbAp637ddoMpm0Nn59ceF3qiXuN4j4tPilGfs2tB/WV7Nh5b
         d/p4CuJzElyyEyLBHZySORw9c/1Oe2l4NwOl2QQee2M/gFk1m5jDAmU2kbrQ5fwFBHd3
         z3egu9E6uhu6tDrngCRCXOEF/+gMxw9Ymfz5encqCecKY4fZ47DzS7+3lXPX6a/L8jHe
         rDLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678852345;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9IlRZaVdETODnIeJiH7tzFm53sIPKv5rZykUvVgbm0I=;
        b=Qwp6n7geq+pzbNc3hT/tj2H9r6w4tPEHiRE+7V0XLKTmXACCDVBbpzIFLJZgpBmZ2a
         q1cmplJEoV6IRe3HsnFv46BouAUfZcGIRBMSB6tARWPUlgnQM69nvkpd7Sb5j2e2RFbY
         HLqx+ooOCHf8E4yHkdXN4EHSxKNh024fFyVnvdWYhriTUwFcJ3zPZ9XJQw868VCMgXoB
         +2hBuegM+mYfu5rxaFEDLdoyz+SwiP+jd2qApscDMTTVwMPkvsiOTgOqZ5zpUCv8K0MK
         tsOaVU/kKoA1kFj1LDV+HW6HRiVbHvGHGsSeDu+DQMkXqublKafxj3L0UIIqBxCg16NP
         poIg==
X-Gm-Message-State: AO0yUKVS+UOiVrqjzQT1Qvb/l26i54aM5ZNtHY3gr+iPmsBPSR3Ftr5r
        WQQ3jfNVdqSITVJ3zR5Lit8rT9ruiL32EA==
X-Google-Smtp-Source: AK7set8vSLJbcV7DnzCR+YpQ8b816HZz71FE1hGY5Bc7hZaG8rcLhNVYdkxqMbGuY+6+y+5AEiOIZg==
X-Received: by 2002:a05:6871:88:b0:177:8154:f7e3 with SMTP id u8-20020a056871008800b001778154f7e3mr11217590oaa.42.1678852345310;
        Tue, 14 Mar 2023 20:52:25 -0700 (PDT)
Received: from tresc054937.tre-sc.gov.br ([187.94.103.218])
        by smtp.gmail.com with ESMTPSA id o14-20020a9d718e000000b0068bd5af9b82sm1913069otj.43.2023.03.14.20.52.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 20:52:23 -0700 (PDT)
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, alsi@bang-olufsen.dk, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        robh+dt@kernel.org, krzk+dt@kernel.org, arinc.unal@arinc9.com,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Alexander Duyck <alexanderduyck@fb.com>
Subject: [PATCH net-next v5] net: dsa: realtek: rtl8365mb: add change_mtu
Date:   Wed, 15 Mar 2023 00:49:22 -0300
Message-Id: <20230315034921.30984-1-luizluca@gmail.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
inspired by the rtl8366rb's initial frame size. However, unlike that
family, the rtl8365mb family can specify the max frame size in bytes,
rather than in fixed steps.

DSA calls change_mtu for the CPU port once the max MTU value among the
ports changes. As the max frame size is defined globally, the switch
is configured only when the call affects the CPU port.

The available specifications do not directly define the max supported
frame size, but it mentions a 16k limit. This driver will use the 0x3FFF
limit as it is used in the vendor API code. However, the switch sets the
max frame size to 16368 bytes (0x3FF0) after it resets.

change_mtu uses MTU size, or ethernet payload size, while the switch
works with frame size. The frame size is calculated considering the
ethernet header (14 bytes), a possible 802.1Q tag (4 bytes), the payload
size (MTU), and the Ethernet FCS (4 bytes). The CPU tag (8 bytes) is
consumed before the switch enforces the limit.

During setup, the driver will use the default 1500-byte MTU of DSA to
set the maximum frame size. The current sum will be
VLAN_ETH_HLEN+1500+ETH_FCS_LEN, which results in 1522 bytes.  Although
it is lower than the previous initial value of 1536 bytes, the driver
will increase the frame size for a larger MTU. However, if something
requires more space without increasing the MTU, such as QinQ, we would
need to add the extra length to the rtl8365mb_port_change_mtu() formula.

MTU was tested up to 2018 (with 802.1Q) as that is as far as mt7620
(where rtl8367s is stacked) can go. The register was manually
manipulated byte-by-byte to ensure the MTU to frame size conversion was
correct. For frames without 802.1Q tag, the frame size limit will be 4
bytes over the required size.

There is a jumbo register, enabled by default at 6k frame size.
However, the jumbo settings do not seem to limit nor expand the maximum
tested MTU (2018), even when jumbo is disabled. More tests are needed
with a device that can handle larger frames.

Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
Reviewed-by: Alvin Šipraga <alsi@bang-olufsen.dk>
---
 drivers/net/dsa/realtek/rtl8365mb.c | 40 ++++++++++++++++++++++++++---
 1 file changed, 36 insertions(+), 4 deletions(-)

v4->v5 (commit message only):
- rename packet size to frame size
- added more info about the lower initial frame size

v3->v4:
- removed spurious newline after comment.

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


diff --git a/drivers/net/dsa/realtek/rtl8365mb.c b/drivers/net/dsa/realtek/rtl8365mb.c
index da31d8b839ac..41ea3b5a42b1 100644
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
@@ -1135,6 +1137,35 @@ static void rtl8365mb_phylink_mac_link_up(struct dsa_switch *ds, int port,
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
@@ -1980,10 +2011,7 @@ static int rtl8365mb_setup(struct dsa_switch *ds)
 		p->index = i;
 	}
 
-	/* Set maximum packet length to 1536 bytes */
-	ret = regmap_update_bits(priv->map, RTL8365MB_CFG0_MAX_LEN_REG,
-				 RTL8365MB_CFG0_MAX_LEN_MASK,
-				 FIELD_PREP(RTL8365MB_CFG0_MAX_LEN_MASK, 1536));
+	ret = rtl8365mb_port_change_mtu(ds, cpu->trap_port, ETH_DATA_LEN);
 	if (ret)
 		goto out_teardown_irq;
 
@@ -2103,6 +2131,8 @@ static const struct dsa_switch_ops rtl8365mb_switch_ops_smi = {
 	.get_eth_mac_stats = rtl8365mb_get_mac_stats,
 	.get_eth_ctrl_stats = rtl8365mb_get_ctrl_stats,
 	.get_stats64 = rtl8365mb_get_stats64,
+	.port_change_mtu = rtl8365mb_port_change_mtu,
+	.port_max_mtu = rtl8365mb_port_max_mtu,
 };
 
 static const struct dsa_switch_ops rtl8365mb_switch_ops_mdio = {
@@ -2124,6 +2154,8 @@ static const struct dsa_switch_ops rtl8365mb_switch_ops_mdio = {
 	.get_eth_mac_stats = rtl8365mb_get_mac_stats,
 	.get_eth_ctrl_stats = rtl8365mb_get_ctrl_stats,
 	.get_stats64 = rtl8365mb_get_stats64,
+	.port_change_mtu = rtl8365mb_port_change_mtu,
+	.port_max_mtu = rtl8365mb_port_max_mtu,
 };
 
 static const struct realtek_ops rtl8365mb_ops = {
-- 
2.39.2

