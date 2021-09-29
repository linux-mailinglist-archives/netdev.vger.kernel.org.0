Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFCDC41CDC8
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 23:07:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346132AbhI2VIp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 17:08:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346024AbhI2VIm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 17:08:42 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A709C061766
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 14:07:00 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id e15so16198108lfr.10
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 14:07:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5IQ8G0uxxR5Pb6926edFohGE/OhQAa2EdYE4PQBssMg=;
        b=pyONePkp8ygMO06zowvqr60r1rWLX5j3ewHNiRBxldS1WUXRh+tO9zubNTEXKacDR0
         Kr+kf3tyWHbTqXBKbTnuIlIABTAIv0pyfiKAwaB0afn0ykQDK42VLQfVvmRDWB4uF9H/
         h+BZvGoezp1cgE+ypSz8OgFGTZn0cxi0swc7CWYYpueHCtFsQiOakiYTPfC3z9/PgGPC
         0FF5WUggMow7mGnWL7sCF/n2NSxUatOJxMuzz14SpiPs7n4bd3cWSiF6WKkOE1MjVLu1
         TgfnE1fiu/pG/cLKAmGZ3wb8v/UDZGFWdVOW0XkoPN1S3oQu5J3gIKpUINGOZqRjy5Qg
         Ivxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5IQ8G0uxxR5Pb6926edFohGE/OhQAa2EdYE4PQBssMg=;
        b=lvH3IEeTZ+XkBfkMai8Gttzj2fUnBAtRO7B0DTEB0ytMyXiKIaOpokOhGJWolLRSRB
         MhfK4ypBKzk/AtcnN8F30MHvx2DaUWXcT+j66/w18XxA0+fnCtdi4+vfpwG+WfM8TkTV
         Q3ZyNo5sIsRN4HBzs3iPMpUTW/9x8dOED2E59PdRsg0c6sb5I1udtdpokamQoo8eWCqj
         wnCGNM5fzQ5/WUrQbIa3QMqbxkCYdUOO22DMu1I4a8VkdxGX99FMqzvz9L+77d/WVTJ9
         CaMh+P/XbzEaTFH3z5G8N6BAhIQbadqSkfOyKGNa33MlGqKT2M7qln186aIrFptk41ll
         mVLg==
X-Gm-Message-State: AOAM531SOu97yoFHvrfy+e+YmxCFHiXV668j/QdmPX+gwrRTTg8knygd
        VyzeGy4Bu6RzoCnho+ma7g3Tnw==
X-Google-Smtp-Source: ABdhPJwnUvwn+bBwa6+IuBprbE/+bWsgoSGxDyiAAtUhyot5EpM3vFX/xSsU4XG6tIHSp69rDLz66A==
X-Received: by 2002:a05:6512:3196:: with SMTP id i22mr1800249lfe.416.1632949618790;
        Wed, 29 Sep 2021 14:06:58 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id s9sm112613lfp.291.2021.09.29.14.06.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 14:06:58 -0700 (PDT)
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
Subject: [PATCH net-next 3/4 v4] net: dsa: rtl8366rb: Support fast aging
Date:   Wed, 29 Sep 2021 23:03:48 +0200
Message-Id: <20210929210349.130099-4-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210929210349.130099-1-linus.walleij@linaro.org>
References: <20210929210349.130099-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This implements fast aging per-port using the special "security"
register, which will flush any learned L2 LUT entries on a port.

Suggested-by: Vladimir Oltean <olteanv@gmail.com>
Cc: Mauri Sandberg <sandberg@mailfence.com>
Cc: DENG Qingfang <dqfext@gmail.com>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Alvin Šipraga <alsi@bang-olufsen.dk>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
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
index 52e750ea790e..748f22ab9130 100644
--- a/drivers/net/dsa/rtl8366rb.c
+++ b/drivers/net/dsa/rtl8366rb.c
@@ -1359,6 +1359,19 @@ rtl8366rb_port_bridge_flags(struct dsa_switch *ds, int port,
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
@@ -1771,6 +1784,7 @@ static const struct dsa_switch_ops rtl8366rb_switch_ops = {
 	.port_disable = rtl8366rb_port_disable,
 	.port_pre_bridge_flags = rtl8366rb_port_pre_bridge_flags,
 	.port_bridge_flags = rtl8366rb_port_bridge_flags,
+	.port_fast_age = rtl8366rb_port_fast_age,
 	.port_change_mtu = rtl8366rb_change_mtu,
 	.port_max_mtu = rtl8366rb_max_mtu,
 };
-- 
2.31.1

