Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B78803FBE96
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 23:53:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238835AbhH3Vxz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 17:53:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237167AbhH3Vxv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 17:53:51 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBBA1C06175F
        for <netdev@vger.kernel.org>; Mon, 30 Aug 2021 14:52:56 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id f2so28418607ljn.1
        for <netdev@vger.kernel.org>; Mon, 30 Aug 2021 14:52:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=90s4wpKUIcwIEvdTTZxL4JGPoTprkT4Ft/euRw6mn8k=;
        b=MHlrErK7NQ3Ky/kK8DzH2Px7FATj7UAsOrCRLH5vTGWa0V2LXb3UhFmH1dLEX+rLui
         Mk/RDykwIN4Ccv7AkL5GsZCcer4+Hyb3VEv+Zyiqb3awJrofWwFkehOl78NmuJEsQ4OJ
         gufmSopoedLkVhkY3mxB+WTt7GYKNUxSedxxJk2eX2kIreEonBBYXnb8OgJHi4QDov7n
         AeRfq4zhmuHdCX2N3VXqy8NDi8W9Dh2ks63DK6kCaAOt/5bBLPvDCkg1D2f3IPK+VcIf
         faUBZS4JppGIvKQe4BdhxXHE24idvqsogttT80Qxk0QjlAdRc1Xg7H8nVjtNGdTk6J42
         4nzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=90s4wpKUIcwIEvdTTZxL4JGPoTprkT4Ft/euRw6mn8k=;
        b=fGcUkS2mvy85rqVJ1IR6ig/mhLMB/j4OM4dIq+HnngUycr//SQtPyH9ka9kfjjBTna
         ZbmJeVemUiOkN81HQ8HpO9im/6s58pL0XfmVf603Cb8FAE2bHYjJJuH4icm3xxZdWUVx
         Mo52iU3eJgF/6jDMabGh0Fy1UvLtOWdao0d6C55Z49LXYcOXbTTsptJ9ttx+637C1VJt
         7XFHnJdibSCD9Ygdy/e8OsseqM/vUtGLprFRher6XgEm5bNP2rkd4BnMlwivqtN8v5oi
         fV+Z7J7YgxOH70oUFP8QsnRiWdLGRnkbMJqQV7Kr5zRTXumsCB6s4DhQAe+QIBvF3asu
         eABg==
X-Gm-Message-State: AOAM532uldLLYgUPPhzPXlwidrhop6T80ZsrhLrgnHIdRCXWGBDE2Y5I
        S7kGBMO1LahJIviisEN+AvexDg==
X-Google-Smtp-Source: ABdhPJzPxORbmoU7WVlv4KC9wL2YIshT3p+5xKnZ/bx7GEKfXoofQesNnV/sAgd899mewd3L4YpUbQ==
X-Received: by 2002:a2e:6808:: with SMTP id c8mr22729019lja.70.1630360375088;
        Mon, 30 Aug 2021 14:52:55 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id h4sm1514049lft.184.2021.08.30.14.52.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Aug 2021 14:52:54 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Mauri Sandberg <sandberg@mailfence.com>,
        DENG Qingfang <dqfext@gmail.com>
Subject: [PATCH net-next 5/5 v2] net: dsa: rtl8366rb: Support fast aging
Date:   Mon, 30 Aug 2021 23:48:59 +0200
Message-Id: <20210830214859.403100-6-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210830214859.403100-1-linus.walleij@linaro.org>
References: <20210830214859.403100-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This implements fast aging per-port using the special "security"
register, which will flush any L2 LUTs on a port.

Suggested-by: Vladimir Oltean <olteanv@gmail.com>
Cc: Alvin Šipraga <alsi@bang-olufsen.dk>
Cc: Mauri Sandberg <sandberg@mailfence.com>
Cc: DENG Qingfang <dqfext@gmail.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v1->v2:
- New patch suggested by Vladimir.
---
 drivers/net/dsa/rtl8366rb.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/net/dsa/rtl8366rb.c b/drivers/net/dsa/rtl8366rb.c
index 4cb0e336ce6b..548282119cc4 100644
--- a/drivers/net/dsa/rtl8366rb.c
+++ b/drivers/net/dsa/rtl8366rb.c
@@ -1219,6 +1219,19 @@ rtl8366rb_port_bridge_flags(struct dsa_switch *ds, int port,
 	return 0;
 }
 
+static void
+rtl8366rb_port_fast_age(struct dsa_switch *ds, int port)
+{
+	struct realtek_smi *smi = ds->priv;
+
+	/* This will age out any L2 entries */
+	regmap_update_bits(smi->map, RTL8366RB_SECURITY_CTRL,
+			   BIT(port), BIT(port));
+	/* Restore the normal state of things */
+	regmap_update_bits(smi->map, RTL8366RB_SECURITY_CTRL,
+			   BIT(port), 0);
+}
+
 static int
 rtl8366rb_port_bridge_join(struct dsa_switch *ds, int port,
 			   struct net_device *bridge)
@@ -1673,6 +1686,7 @@ static const struct dsa_switch_ops rtl8366rb_switch_ops = {
 	.port_disable = rtl8366rb_port_disable,
 	.port_pre_bridge_flags = rtl8366rb_port_pre_bridge_flags,
 	.port_bridge_flags = rtl8366rb_port_bridge_flags,
+	.port_fast_age = rtl8366rb_port_fast_age,
 	.port_change_mtu = rtl8366rb_change_mtu,
 	.port_max_mtu = rtl8366rb_max_mtu,
 };
-- 
2.31.1

