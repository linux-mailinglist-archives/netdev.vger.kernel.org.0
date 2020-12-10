Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C72672D62FB
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 18:06:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390921AbgLJRET (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 12:04:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388290AbgLJREJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 12:04:09 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97025C0617A7
        for <netdev@vger.kernel.org>; Thu, 10 Dec 2020 09:03:29 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id p4so4690862pfg.0
        for <netdev@vger.kernel.org>; Thu, 10 Dec 2020 09:03:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eRcirKkczqUwPjfzJ1m1K31YYmn9lbP0Ojco8kH6qww=;
        b=fEUkmcpMf+8Vk4ezAJBrMWMvdJAxJgERulmR6uMHHh9CJKjkhoIk9w4eH9cL1AXk79
         7Eb0EkNThEnn2fzZYxiahVyH59Z0LlGhy0iUFCZ4qgSopEf5TYLJ94MzHLgaFkHKLt5F
         hLd+I5mawe4HTX1q/7J9RQSRFW/1Eb0Mp5I04OI2pXsIKhHTbYYDTSANznv5XUThXOo7
         gUpOBX2FHvCZyG18eKWbdXRa96lm5sHKLjFKbIRJEAaEPcofYHdTdVWpdT0i6m+kDUJ5
         cTTnaFW0aAbrKSxXUfymEvVt73mTKIL2rYTW5PVPjhe26nNyplTrj09EXTQC+YdZ14lh
         AkUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eRcirKkczqUwPjfzJ1m1K31YYmn9lbP0Ojco8kH6qww=;
        b=bfQrhJV8r+D+7uxOTfA4xGZtgAtc3NRm2BKHlCtYJbQ8bQ0E4I9x2o3MdUDlsHuGMb
         kAlu6PQIz1J1q/bhmUvchdWN0lCb0oKHQduo+Qm0CVE4OAd6sm57YsPqzTGusxzTCEx5
         Z1RxqwIYsCpit5qsYPLY9QIJ/LMucKmixFCzgYnyfVJ2aPPWy8rqpY27AKzSrfd8Wpsf
         N3EkiKB6VWQnyCsQIw+ZwyMfG0nszXL1dWLYcaOaGJ5KyPRJB1c+SjjWCmj3//amtwmg
         Ec9ddLt9ljY4jNn+lwAOwJNHntgIEUt1otpwpwnvYdhcWwGJHjiPRdEcW2Rc4sbTF9Uw
         o5fA==
X-Gm-Message-State: AOAM533jgXC7fbUaihDdEWL203KNrQh+thDJw+myoxlphso9dZkGuxOJ
        MrKdexGgaDQv4MWXzq6aABBpRQdlETFUBbbXycA=
X-Google-Smtp-Source: ABdhPJyEWgOjT095zKQ46nRfysxXucdy1M7MntGxBJ3lkXo3bYoyFlRe2bxAORpp4HAYHVJeLIEKCA==
X-Received: by 2002:a17:90a:8b8a:: with SMTP id z10mr8672792pjn.67.1607619809005;
        Thu, 10 Dec 2020 09:03:29 -0800 (PST)
Received: from container-ubuntu.lan ([171.211.29.210])
        by smtp.gmail.com with ESMTPSA id u12sm6495318pfn.88.2020.12.10.09.03.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Dec 2020 09:03:28 -0800 (PST)
From:   DENG Qingfang <dqfext@gmail.com>
To:     netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Subject: [PATCH net-next] net: dsa: mt7530: enable MTU normalization
Date:   Fri, 11 Dec 2020 01:03:22 +0800
Message-Id: <20201210170322.3433-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MT7530 has a global RX length register, so we are actually changing its
MRU.
Enable MTU normalization for this reason.

Signed-off-by: DENG Qingfang <dqfext@gmail.com>
---
 drivers/net/dsa/mt7530.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 99bf8fed6536..a67cac15a724 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -1657,6 +1657,7 @@ mt7530_setup(struct dsa_switch *ds)
 	 */
 	dn = dsa_to_port(ds, MT7530_CPU_PORT)->master->dev.of_node->parent;
 	ds->configure_vlan_while_not_filtering = true;
+	ds->mtu_enforcement_ingress = true;
 
 	if (priv->id == ID_MT7530) {
 		regulator_set_voltage(priv->core_pwr, 1000000, 1000000);
@@ -1895,6 +1896,7 @@ mt7531_setup(struct dsa_switch *ds)
 	}
 
 	ds->configure_vlan_while_not_filtering = true;
+	ds->mtu_enforcement_ingress = true;
 
 	/* Flush the FDB table */
 	ret = mt7530_fdb_cmd(priv, MT7530_FDB_FLUSH, NULL);
-- 
2.25.1

