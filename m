Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B72C530E58
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 12:43:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234188AbiEWKnO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 06:43:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234146AbiEWKnI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 06:43:08 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3AB260C3
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 03:43:06 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id en5so18568882edb.1
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 03:43:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IG2S0IJHtK1yhe2JNCNBtiyLUGz9p1p+4jsu2s1WXKc=;
        b=R09++ZvwfG6IODhGk8irupCPYJvPmXQkY8FzByolTAZb3A/3zx6WbNXWxq3EyDBdRx
         XD+9iM7k/T57fS0e0wo8cVpldPRzBqiq0DMTPm30JwMoX3SMfcl1/d2yorBRCYiL0Gdh
         D+wGnOYwIn3yhOodvxFQBNYTyBiGPSsZZOE2wrW0emrCnPOiO0n5/Q5Mwc+pkq2qqxIz
         GoEX6QAv8nltXtTJJ9J+Rl9qCLuK6FYigCZVQJRO4K5AQpWAXCJlEIbbz6CS02Ovbb87
         u1/9H4zxwhqL12CeTTbdBU05GwDwklPVOaEfRgimsPJYwyA2kRI9LZx0ueQe2MNdJxhe
         qwDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IG2S0IJHtK1yhe2JNCNBtiyLUGz9p1p+4jsu2s1WXKc=;
        b=dwCAmjPb6wbUR+ylwOj6MfSVwrG8JpM3nHqQE1mHojGXdGPu62CBcGJA2RZp3JuBVy
         mRPxugakngnIeg1bodo8GDCaOaMWk+aLb5LBlZugaHMMUmKgPYq0Je52i6FgZRfJpo2l
         gn9aXYSi7ZjkFwsJotVzU1hT8qKZA8cBTYaOYAxzYsDU0fsYuqfrgA9HAINieDLeaIwf
         L3tX8lQkWnriklJxfJf46YGZOdd7Vjqde2/QC72XJCOuXOiNsK/CvOkbm2CqruEIuxC3
         K/U8xH4MuxFrPPPbH3Zr+laBOMRA/nFmoK5l/7pPR6UwxB/k0rIP4h7ZvuEANUNMzeoe
         c51A==
X-Gm-Message-State: AOAM531qBCg44hEXYukXR08pKOHT4AyQUnp7A7Jv/EBAW5hknSWc/8nL
        tCOL7XxVykel9XtcYFqqDwTGISiXtm4=
X-Google-Smtp-Source: ABdhPJzMt9yVvv7b4rbymzS4rq3+kTyQ22Nn/90CbkcTFQe53yxOoM6ko0gQvG32zX4TaFGioitcoQ==
X-Received: by 2002:aa7:d04d:0:b0:42a:acac:2cf7 with SMTP id n13-20020aa7d04d000000b0042aacac2cf7mr23362552edo.424.1653302584832;
        Mon, 23 May 2022 03:43:04 -0700 (PDT)
Received: from localhost.localdomain ([188.25.255.186])
        by smtp.gmail.com with ESMTPSA id j18-20020a1709066dd200b006feb875503fsm2584822ejt.78.2022.05.23.03.43.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 May 2022 03:43:04 -0700 (PDT)
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
Subject: [RFC PATCH net-next 02/12] net: dsa: walk through all changeupper notifier functions
Date:   Mon, 23 May 2022 13:42:46 +0300
Message-Id: <20220523104256.3556016-3-olteanv@gmail.com>
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

Traditionally, DSA has had a single netdev notifier handling function
for each device type.

For the sake of code cleanliness, we would like to introduce more
handling functions which do one thing, but the conditions for entering
these functions start to overlap. Example: a handling function which
tracks whether any bridges contain both DSA and non-DSA interfaces.
Either this is placed before dsa_slave_changeupper(), case in which it
will prevent that function from executing, or we place it after
dsa_slave_changeupper(), case in which we will prevent it from
executing. The other alternative is to ignore errors from the new
handling function (not ideal).

To support this usage, we need to change the pattern. In the new model,
we enter all notifier handling sub-functions, and exit with NOTIFY_DONE
if there is nothing to do. This allows the sub-functions to be
relatively free-form and independent from each other.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/slave.c | 37 ++++++++++++++++++++++++++++---------
 1 file changed, 28 insertions(+), 9 deletions(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 17c7ec8b2245..8d62c634c331 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2452,6 +2452,9 @@ static int dsa_slave_changeupper(struct net_device *dev,
 	struct netlink_ext_ack *extack;
 	int err = NOTIFY_DONE;
 
+	if (!dsa_slave_dev_check(dev))
+		return err;
+
 	extack = netdev_notifier_info_to_extack(&info->info);
 
 	if (netif_is_bridge_master(info->upper_dev)) {
@@ -2506,6 +2509,9 @@ static int dsa_slave_prechangeupper(struct net_device *dev,
 {
 	struct dsa_port *dp = dsa_slave_to_port(dev);
 
+	if (!dsa_slave_dev_check(dev))
+		return NOTIFY_DONE;
+
 	if (netif_is_bridge_master(info->upper_dev) && !info->linking)
 		dsa_port_pre_bridge_leave(dp, info->upper_dev);
 	else if (netif_is_lag_master(info->upper_dev) && !info->linking)
@@ -2526,6 +2532,9 @@ dsa_slave_lag_changeupper(struct net_device *dev,
 	int err = NOTIFY_DONE;
 	struct dsa_port *dp;
 
+	if (!netif_is_lag_master(dev))
+		return err;
+
 	netdev_for_each_lower_dev(dev, lower, iter) {
 		if (!dsa_slave_dev_check(lower))
 			continue;
@@ -2555,6 +2564,9 @@ dsa_slave_lag_prechangeupper(struct net_device *dev,
 	int err = NOTIFY_DONE;
 	struct dsa_port *dp;
 
+	if (!netif_is_lag_master(dev))
+		return err;
+
 	netdev_for_each_lower_dev(dev, lower, iter) {
 		if (!dsa_slave_dev_check(lower))
 			continue;
@@ -2676,22 +2688,29 @@ static int dsa_slave_netdevice_event(struct notifier_block *nb,
 		if (err != NOTIFY_DONE)
 			return err;
 
-		if (dsa_slave_dev_check(dev))
-			return dsa_slave_prechangeupper(dev, ptr);
+		err = dsa_slave_prechangeupper(dev, ptr);
+		if (notifier_to_errno(err))
+			return err;
 
-		if (netif_is_lag_master(dev))
-			return dsa_slave_lag_prechangeupper(dev, ptr);
+		err = dsa_slave_lag_prechangeupper(dev, ptr);
+		if (notifier_to_errno(err))
+			return err;
 
 		break;
 	}
-	case NETDEV_CHANGEUPPER:
-		if (dsa_slave_dev_check(dev))
-			return dsa_slave_changeupper(dev, ptr);
+	case NETDEV_CHANGEUPPER: {
+		int err;
+
+		err = dsa_slave_changeupper(dev, ptr);
+		if (notifier_to_errno(err))
+			return err;
 
-		if (netif_is_lag_master(dev))
-			return dsa_slave_lag_changeupper(dev, ptr);
+		err = dsa_slave_lag_changeupper(dev, ptr);
+		if (notifier_to_errno(err))
+			return err;
 
 		break;
+	}
 	case NETDEV_CHANGELOWERSTATE: {
 		struct netdev_notifier_changelowerstate_info *info = ptr;
 		struct dsa_port *dp;
-- 
2.25.1

