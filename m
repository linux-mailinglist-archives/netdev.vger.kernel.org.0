Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60824370FAC
	for <lists+netdev@lfdr.de>; Mon,  3 May 2021 01:10:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232512AbhEBXK4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 May 2021 19:10:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232701AbhEBXIZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 May 2021 19:08:25 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76BF9C06134A;
        Sun,  2 May 2021 16:07:32 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id i3so4297555edt.1;
        Sun, 02 May 2021 16:07:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NKTRQprkTz8Es1vpeCKAiDwS5E2KGCF4GkOy7VVlnTM=;
        b=RR+R4svU7HfLRIbW1Dg+ftaXQrrRk8ByYL0bivVB14zKPbA3XTTwUEKjupYLcdYE5t
         A35pwzU+UBxw+yGHkaAZ4r/niC0+IIX5eJGzFlcAZCysgv/Nk264jhvw0a9wDsZfdHwR
         5G2UwDTJ4Um2pQa+tlQo/k6ewxFUwpiTRbiV1FhC7Rzj8K1wixckAxHYZ38tx7PuN2bB
         6vMa9D6CNOVC+WHTROVN5iBdq677cVrsyO4P9dvbiukqfIKO8ilHLcQvd9Hay86lf0Jm
         40Fs0VBm+48f+3wZ99/4wCq1r62WflscgC1R5TAeF9Mw9SV6pQSAeo1boNo1HtsGqy98
         LEDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NKTRQprkTz8Es1vpeCKAiDwS5E2KGCF4GkOy7VVlnTM=;
        b=XslJplmBimrRLRzpQVmijmwq1fcaKcRALIz//CTV9ggKmoPrysjDRoG+oU6KBa1mKW
         oOhCelobF64YD8cmq6e9G+oM6gZLm3JvUKYw5DbcIjcNU+Y/TKNeqlB7QuekdKifvQTR
         YrDYlaLSgZ4wr6uvL9TQZHFbe5b8SiBlwm9I3ML3eUsGV7EWduV6EVeb+zR/LiLN57+Y
         5rRJaoRvDt3B0lbE5f2fSzK0mp5OmNbzM+77CwPQSKCrd9T4ZWItlB8ehyVytf1f0dcg
         tsaGYflHa84Vr8k7Z5P6Dhtiu8q0KQF9KqN41FH3NaVCpviiU3TIiQcAejk6feix6JPD
         n+Bw==
X-Gm-Message-State: AOAM533QWQZQYJ9GLgXrRMRnCpAPHl6Fgg9qhwfSgXLN8u2zheNXApJB
        L2xaeOXNscqSoDCc075ZM8A=
X-Google-Smtp-Source: ABdhPJzil6UL6gdwAawl8DttnSW9epvdA2SgFnr0bFzzRh2HoEuaDioZ7AjZXKevFnvtA1pd2YOomQ==
X-Received: by 2002:a05:6402:7d1:: with SMTP id u17mr17306853edy.312.1619996851190;
        Sun, 02 May 2021 16:07:31 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id z17sm10003874ejc.69.2021.05.02.16.07.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 May 2021 16:07:30 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH net-next v2 16/17] net: dsa: qca8k: pass switch_revision info to phy dev_flags
Date:   Mon,  3 May 2021 01:07:08 +0200
Message-Id: <20210502230710.30676-16-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210502230710.30676-1-ansuelsmth@gmail.com>
References: <20210502230710.30676-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Define get_phy_flags to pass switch_Revision needed to tweak the
internal PHY with debug values based on the revision.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 7f72504f003a..1be1064586ae 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -1646,6 +1646,24 @@ qca8k_port_vlan_del(struct dsa_switch *ds, int port,
 	return ret;
 }
 
+static u32 qca8k_get_phy_flags(struct dsa_switch *ds, int port)
+{
+	struct qca8k_priv *priv = ds->priv;
+
+	pr_info("revision from phy %d", priv->switch_revision);
+
+	/* Communicate to the phy internal driver the switch revision.
+	 * Based on the switch revision different values needs to be
+	 * set to the dbg and mmd reg on the phy.
+	 * The first 2 bit are used to communicate the switch revision
+	 * to the phy driver.
+	 */
+	if (port > 0 && port < 6)
+		return priv->switch_revision;
+
+	return 0;
+}
+
 static enum dsa_tag_protocol
 qca8k_get_tag_protocol(struct dsa_switch *ds, int port,
 		       enum dsa_tag_protocol mp)
@@ -1679,6 +1697,7 @@ static const struct dsa_switch_ops qca8k_switch_ops = {
 	.phylink_mac_config	= qca8k_phylink_mac_config,
 	.phylink_mac_link_down	= qca8k_phylink_mac_link_down,
 	.phylink_mac_link_up	= qca8k_phylink_mac_link_up,
+	.get_phy_flags		= qca8k_get_phy_flags,
 };
 
 static int qca8k_read_switch_id(struct qca8k_priv *priv)
-- 
2.30.2

