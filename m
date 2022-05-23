Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7C5D530E59
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 12:43:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234182AbiEWKnZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 06:43:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234146AbiEWKnX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 06:43:23 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3773F2458D
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 03:43:11 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id jx22so14424756ejb.12
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 03:43:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8U0JbIv2eD/dHwgHzViQz0b6VPekMW4JDJchg5/en9Y=;
        b=FPrBsncOVKyAMz7yoch9GqLr3u5dCG2WqMf/bynwfa+VR4q8Ae1doMeEJ0NJFo8qk7
         M3WjKBpoCqMLibPgUSt7L+WJf8pnCpHgpySSe63EwDNF4zcwMIvU5x00F4IYOlQka7D8
         dlAj0lh109fIB6cQUI+V8MFlhqF9iiwyr6pMToO4D4+ncBoV/nQH/JC7i9douPrVdLBE
         Bp8/saPmrKm9N6eKv/fZdJ0MDx9XWTmR85kDPCodn7iZrqGmDzA59VK41QohO/2Rkao/
         DYWvcsknFC+Yi9nfwdjudPRnkT6TvtM6oxBuIR6M3H9Db+hCj39+5y7Uzyd6ppOghm+Z
         xqXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8U0JbIv2eD/dHwgHzViQz0b6VPekMW4JDJchg5/en9Y=;
        b=3Cd0HTyNP/6lPf96cHWulHnxGKppojTHtCeoK1wJBPinZMhhK/NkR3sdsJGAN5Swpd
         nvH0XZ6+RjWoAFkNKVbmNuJo+yJe7EyIiA37t0FyHKZ9frcIkA67DFGvh7AS441bv2kD
         f8FPK/b1/HT7QqRWOYtEXbDiXN+sgRjxt+1uiWlL9kX6gKoVP68TFrAv4rlEFrTft7uD
         TR8tp54aN2hycJ0b0qQL345lQ0XRG1JEv7IZnparCNmOMoaHcsXFYOpnq3A66mMcLl2E
         7waQY2/SzJtu/hrK63Sf/iIQcfmNcTBvEDM607riL10ky+8dm00EmgWrAchz5MqyeaHB
         sGvg==
X-Gm-Message-State: AOAM53325rZL6NPDrzDdkzXSMxU49NES3req5urliDVkoQYLnzsz68o9
        gsDEV2Vzc9rJP6yEmG+Ns8xiw5Y51mQ=
X-Google-Smtp-Source: ABdhPJzVIIempDtEV13XMfGwjM23lb5ZJURZnuCpxs7Jn3y0PTu5tLcCwaYuPPl9fopDeLHk9TH19w==
X-Received: by 2002:a17:907:62a9:b0:6da:7953:4df0 with SMTP id nd41-20020a17090762a900b006da79534df0mr18916117ejc.316.1653302588908;
        Mon, 23 May 2022 03:43:08 -0700 (PDT)
Received: from localhost.localdomain ([188.25.255.186])
        by smtp.gmail.com with ESMTPSA id j18-20020a1709066dd200b006feb875503fsm2584822ejt.78.2022.05.23.03.43.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 May 2022 03:43:08 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Colin Foster <colin.foster@in-advantage.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Frank Wunderlich <frank-w@public-files.de>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [RFC PATCH net-next 04/12] net: bridge: move DSA master bridging restriction to DSA
Date:   Mon, 23 May 2022 13:42:48 +0300
Message-Id: <20220523104256.3556016-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220523104256.3556016-1-olteanv@gmail.com>
References: <20220523104256.3556016-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

When DSA gains support for multiple CPU ports in a LAG, it will become
mandatory to monitor the changeupper events for the DSA master.

In fact, there are already some restrictions to be imposed in that area,
namely that a DSA master cannot be a bridge port except in some special
circumstances.

Centralize the restrictions at the level of the DSA layer as a
preliminary step.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/bridge/br_if.c | 20 --------------------
 net/dsa/slave.c    | 44 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 44 insertions(+), 20 deletions(-)

diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
index 47fcbade7389..916c051f0f0b 100644
--- a/net/bridge/br_if.c
+++ b/net/bridge/br_if.c
@@ -568,26 +568,6 @@ int br_add_if(struct net_bridge *br, struct net_device *dev,
 	    !is_valid_ether_addr(dev->dev_addr))
 		return -EINVAL;
 
-	/* Also don't allow bridging of net devices that are DSA masters, since
-	 * the bridge layer rx_handler prevents the DSA fake ethertype handler
-	 * to be invoked, so we don't get the chance to strip off and parse the
-	 * DSA switch tag protocol header (the bridge layer just returns
-	 * RX_HANDLER_CONSUMED, stopping RX processing for these frames).
-	 * The only case where that would not be an issue is when bridging can
-	 * already be offloaded, such as when the DSA master is itself a DSA
-	 * or plain switchdev port, and is bridged only with other ports from
-	 * the same hardware device.
-	 */
-	if (netdev_uses_dsa(dev)) {
-		list_for_each_entry(p, &br->port_list, list) {
-			if (!netdev_port_same_parent_id(dev, p->dev)) {
-				NL_SET_ERR_MSG(extack,
-					       "Cannot do software bridging with a DSA master");
-				return -EINVAL;
-			}
-		}
-	}
-
 	/* No bridging of bridges */
 	if (dev->netdev_ops->ndo_start_xmit == br_dev_xmit) {
 		NL_SET_ERR_MSG(extack,
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index d8768e8f7862..309d8dde0179 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2674,6 +2674,46 @@ dsa_slave_prechangeupper_sanity_check(struct net_device *dev,
 	return NOTIFY_DONE;
 }
 
+/* Don't allow bridging of DSA masters, since the bridge layer rx_handler
+ * prevents the DSA fake ethertype handler to be invoked, so we don't get the
+ * chance to strip off and parse the DSA switch tag protocol header (the bridge
+ * layer just returns RX_HANDLER_CONSUMED, stopping RX processing for these
+ * frames).
+ * The only case where that would not be an issue is when bridging can already
+ * be offloaded, such as when the DSA master is itself a DSA or plain switchdev
+ * port, and is bridged only with other ports from the same hardware device.
+ */
+static int
+dsa_bridge_prechangelower_sanity_check(struct net_device *new_lower,
+				       struct netdev_notifier_changeupper_info *info)
+{
+	struct net_device *br = info->upper_dev;
+	struct netlink_ext_ack *extack;
+	struct net_device *lower;
+	struct list_head *iter;
+
+	if (!netif_is_bridge_master(br))
+		return NOTIFY_DONE;
+
+	if (!info->linking)
+		return NOTIFY_DONE;
+
+	extack = netdev_notifier_info_to_extack(&info->info);
+
+	netdev_for_each_lower_dev(br, lower, iter) {
+		if (!netdev_uses_dsa(new_lower) && !netdev_uses_dsa(lower))
+			continue;
+
+		if (!netdev_port_same_parent_id(lower, new_lower)) {
+			NL_SET_ERR_MSG(extack,
+				       "Cannot do software bridging with a DSA master");
+			return notifier_from_errno(-EINVAL);
+		}
+	}
+
+	return NOTIFY_DONE;
+}
+
 static int dsa_slave_netdevice_event(struct notifier_block *nb,
 				     unsigned long event, void *ptr)
 {
@@ -2688,6 +2728,10 @@ static int dsa_slave_netdevice_event(struct notifier_block *nb,
 		if (notifier_to_errno(err))
 			return err;
 
+		err = dsa_bridge_prechangelower_sanity_check(dev, info);
+		if (notifier_to_errno(err))
+			return err;
+
 		err = dsa_slave_prechangeupper(dev, ptr);
 		if (notifier_to_errno(err))
 			return err;
-- 
2.25.1

