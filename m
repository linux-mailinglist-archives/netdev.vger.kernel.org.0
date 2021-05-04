Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34B8337327C
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 00:34:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233494AbhEDWcR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 18:32:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233299AbhEDWa7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 May 2021 18:30:59 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A5AAC06134E;
        Tue,  4 May 2021 15:29:56 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id u13so9599819edd.3;
        Tue, 04 May 2021 15:29:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DPVirV8UGk1Xz9SJbGO4OYkBAMfbruJu5dLnSDu3k1w=;
        b=soYGslJUImliMdck2+vHG9TV8KKchdCIETvuML7vPJm18sYU/3VHNRUJlwIBDr1Bia
         LO18ne1Rco1kXJ3M1IVu6HtOrDSPDqb21GWmDwkO3zdf9H6m9L8A9EUHY1AGFixa1ln+
         u2shq61LiAZccMkG/+P5h5TJqgP0EL2A51srjEhTkXdN+XhQpPKq3p0nvi+e3h7ugPs+
         gy7ZmZF9udBvsL5zzFlTOJNx3715qjq5du3mA0QagvC23xCO4vW9/nCpNDJgB9ah3gks
         xOHS4FY82DsGTG44HsE+jDERgSxgTFniR8Y5PpTpUgoz9d80igSpLUnapkyp3fAz5s0m
         RiBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DPVirV8UGk1Xz9SJbGO4OYkBAMfbruJu5dLnSDu3k1w=;
        b=GYUOx1Eys2EwscfPd2e7Z8EWARdnBK3uELHOeb4P++UyGpXyJFwFXe0mTExinv+PAY
         oY7b7buaFykZNRdgHpMEFHKRX18i0F1Jbz5uoXPSRlKnStIIZxWOUL/D9jtgYgLbiiKq
         SzVOC5ijqXuNBM/TfvHnJdP/P4AM6H27E1tLMI9kHIQI0eQaLjQ6CW2qt+MQBbZ8YWTa
         UbByzQJVIrHrkk+VASIEyqfK1hK3wAqq8Zdh1dD3uxEccGIPE00tsrmTcJR5k4ayrTmn
         25vDHw8eOWWPLzB7QYZmY+ju/d605Mzst2498NtX6uqBdLQwn5GZILbveYsZlhzqQK41
         RPYg==
X-Gm-Message-State: AOAM5334otvCwQxFSgRAgm67Fha5IoeD7jyy8mP1qIFL7mY6pGsYmv7z
        ihp5j8IiVKxtvic3zKyWEEQ=
X-Google-Smtp-Source: ABdhPJwP/NhdjzDdpaG0rP6dFGOgc4L5zyHicmqnL9NjmAYZY9A3YiewU3x8e7D/ybhgucA2mNH3HA==
X-Received: by 2002:a05:6402:4313:: with SMTP id m19mr25342891edc.263.1620167394753;
        Tue, 04 May 2021 15:29:54 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id q12sm2052946ejy.91.2021.05.04.15.29.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 May 2021 15:29:54 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH net-next v3 19/20] net: dsa: qca8k: pass switch_revision info to phy dev_flags
Date:   Wed,  5 May 2021 00:29:13 +0200
Message-Id: <20210504222915.17206-19-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210504222915.17206-1-ansuelsmth@gmail.com>
References: <20210504222915.17206-1-ansuelsmth@gmail.com>
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
index b4cd891ad35d..237e09bb1425 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -1654,6 +1654,24 @@ qca8k_port_vlan_del(struct dsa_switch *ds, int port,
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
@@ -1687,6 +1705,7 @@ static const struct dsa_switch_ops qca8k_switch_ops = {
 	.phylink_mac_config	= qca8k_phylink_mac_config,
 	.phylink_mac_link_down	= qca8k_phylink_mac_link_down,
 	.phylink_mac_link_up	= qca8k_phylink_mac_link_up,
+	.get_phy_flags		= qca8k_get_phy_flags,
 };
 
 static int qca8k_read_switch_id(struct qca8k_priv *priv)
-- 
2.30.2

