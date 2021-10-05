Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 818954230FC
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 21:49:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235745AbhJETvJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 15:51:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235793AbhJETvH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 15:51:07 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5B41C061762
        for <netdev@vger.kernel.org>; Tue,  5 Oct 2021 12:49:16 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id u18so476319lfd.12
        for <netdev@vger.kernel.org>; Tue, 05 Oct 2021 12:49:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DpxUMZjEmbxwlgRUpAcp+St9BsqthlNtt9JsygSxW+o=;
        b=NItpHXRHgiq33607CdbclkJ/3iYXWL8iQwjOqx4tweEMNnJw/aXQhMnyvX9Pav05ab
         8tyelQGc8qU+rXPL6CpWcoZy7UTV4Ru2huT95KInCFw2+MzHYqeTezZ5I754XOQ72yQJ
         masF7BIjWrClAhsluduG89Ztseoc1azIWVAhiQ6+CWOA3te8Ij8gcO0c0uuvZiZIPfiD
         fmlGfze2G2C/gQgs0C7kWYaq1FxhWobfLZyLCBz9MBRgD4wfHZVONq+Yn+eSAaWQMkZ9
         p9AFdC88n9xdMHbXRlvpXZfZLhyRmX0UluVO44wzAqZz/hzugzbo4vcXih8K81i5pFSb
         irNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DpxUMZjEmbxwlgRUpAcp+St9BsqthlNtt9JsygSxW+o=;
        b=pYZ6bZ0OcvZKt0nly9FwZHI05EYolb8n7spVpHspYohvg8iVBS6g1VRkaIQxJbNkCE
         75+Esao/XmrBw/mSAQtlNHk8Aq4jN8ioixmq0PFJMYsF7CWMj7CSGGBeV4FJrwljReXa
         rzsSWcUaG4e/VpsFEneUXtqQNvUiKDTPtfNnGajFdp+6pmWrAlWwlioJkAaQTjhAlLaI
         EA89prWEDUKY+gkEyKeNSXlaJVYxy5pAXmmNpLWweToItzYf4B6vaWGVnBgppNFkslxk
         oyk3B3G5bbN14SIwq95iYGykcbLgh2bRDlJCHmqPrPoHLocsT3zCrat7amxoB5gFfxKI
         ay+Q==
X-Gm-Message-State: AOAM531aWWzhauqi/GZKnUmkd5feEOC6hFQmQsMiOJUdlD4nno1ZxPv+
        GM9Ck2/c+zyne/SJd6LWTR/G4w==
X-Google-Smtp-Source: ABdhPJx2Tt7FPg+9G7A1zHKb3UIl7O+5AIRaP4Vi5RXdWlwI0aGPyqWqd8w1EWW/Xl3WVg6M5acemg==
X-Received: by 2002:ac2:5e9c:: with SMTP id b28mr5292950lfq.468.1633463355147;
        Tue, 05 Oct 2021 12:49:15 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id k28sm2083577ljn.57.2021.10.05.12.49.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Oct 2021 12:49:14 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Mauri Sandberg <sandberg@mailfence.com>,
        DENG Qingfang <dqfext@gmail.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>
Subject: [PATCH net-next 2/3 v5] net: dsa: rtl8366rb: Support fast aging
Date:   Tue,  5 Oct 2021 21:47:03 +0200
Message-Id: <20211005194704.342329-3-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211005194704.342329-1-linus.walleij@linaro.org>
References: <20211005194704.342329-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This implements fast aging per-port using the special "security"
register, which will flush any learned L2 LUT entries on a port.

The vendor API just enabled setting and clearing this bit, so
we set it to age out any entries on the port and then we clear
it again.

Suggested-by: Vladimir Oltean <olteanv@gmail.com>
Cc: Mauri Sandberg <sandberg@mailfence.com>
Cc: DENG Qingfang <dqfext@gmail.com>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Alvin Šipraga <alsi@bang-olufsen.dk>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v4->v5:
- Update changelog a bit what else can we do.
ChangeLog v3->v4:
- No changes, rebased on the other patches.
ChangeLog v2->v3:
- Underscore that this only affects learned L2 entries, not
  static ones.
ChangeLog v1->v2:
- New patch suggested by Vladimir.
---
 drivers/net/dsa/rtl8366rb.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/net/dsa/rtl8366rb.c b/drivers/net/dsa/rtl8366rb.c
index b3056064b937..c78e4220ddd1 100644
--- a/drivers/net/dsa/rtl8366rb.c
+++ b/drivers/net/dsa/rtl8366rb.c
@@ -1308,6 +1308,19 @@ rtl8366rb_port_bridge_flags(struct dsa_switch *ds, int port,
 	return 0;
 }
 
+static void
+rtl8366rb_port_fast_age(struct dsa_switch *ds, int port)
+{
+	struct realtek_smi *smi = ds->priv;
+
+	/* This will age out any learned L2 entries */
+	regmap_update_bits(smi->map, RTL8366RB_SECURITY_CTRL,
+			   BIT(port), BIT(port));
+	/* Restore the normal state of things */
+	regmap_update_bits(smi->map, RTL8366RB_SECURITY_CTRL,
+			   BIT(port), 0);
+}
+
 static int rtl8366rb_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
 {
 	struct realtek_smi *smi = ds->priv;
@@ -1720,6 +1733,7 @@ static const struct dsa_switch_ops rtl8366rb_switch_ops = {
 	.port_disable = rtl8366rb_port_disable,
 	.port_pre_bridge_flags = rtl8366rb_port_pre_bridge_flags,
 	.port_bridge_flags = rtl8366rb_port_bridge_flags,
+	.port_fast_age = rtl8366rb_port_fast_age,
 	.port_change_mtu = rtl8366rb_change_mtu,
 	.port_max_mtu = rtl8366rb_max_mtu,
 };
-- 
2.31.1

