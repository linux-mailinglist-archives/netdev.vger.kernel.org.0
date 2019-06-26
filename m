Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0AA35677A
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 13:21:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727278AbfFZLVQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 07:21:16 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:40361 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727084AbfFZLVP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 07:21:15 -0400
Received: by mail-wr1-f66.google.com with SMTP id p11so2277632wre.7
        for <netdev@vger.kernel.org>; Wed, 26 Jun 2019 04:21:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=KEBkrYbSpnqh89/UMI9D7zZ+6imd3dfq5vlm/rSJyDY=;
        b=P7wA9loMVfKOeUy55BbAeW/+JmbC5jxKTN1kwxyoa+8+jXQA3TnvLYXE/vhXGTzdlI
         RYX8FvgSB0hvowBU61jNpXuAnHwqnKocs5KikfE0Dn9nDGwhHGLKRVjyUHT/2FCMREFH
         M3jremRfsSFk4EmuteaUGunBFj2fpsyl8I8+fll8cSgBXhO5HfIZ7MYbSrFA1oGI06i1
         Bj3xh70KKFF7psQfKlnAhrGashgFwY2A7u4KmlnM1NKVEQpw2/DQBHs1jXMh2Ah0s3yA
         08Z9hUNhr8VNBF2eStbeF2+SdGCS6kez0UwBU/M8yiV9qwx7zN8iZ0t/ByfK997RgNBp
         mh1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=KEBkrYbSpnqh89/UMI9D7zZ+6imd3dfq5vlm/rSJyDY=;
        b=f8K/gd6B2ys/gxuAXnpw3+t+vOqlVFoNXMsN2fdNE9Qx7zwqxjG9E5N+VcAlQo02Wo
         GtBPqOsyf+Q+coLDSOBTJHj8QwXlJfWc+pdPrJj9BQSRtzlIdMhRIb/aA1Z8FO/Cu6TO
         wEXt2PpCMb3xVUrhy6ZUPKHrB3HAXxYUIG+zRxHs8VwNYa/+w4xgRpZXd2+wW33/wk+c
         wVZw2eXWUaArUi+6UcTbSv+xt73CzLF1WuSe6kCHUynoj+vU6MI2C8baeDH1RsmHZTde
         bG8TjDpvKU1GWFiEaW3dxwntgXljha+gSUfn30hM9OuBpLiXUymxh62aZ2gVFqKAaEZD
         DT+A==
X-Gm-Message-State: APjAAAXl8DuBB031Leh3Y9rPO2xdMlkXPy+mqG5cRVP7o7wc+jmL2i/1
        vYiFz9WfW4A0GDgnd5E8IKg=
X-Google-Smtp-Source: APXvYqzK8fdK9vx39CzI+t0iSU24ag3zEqTIAwcc7Hxco835D/kgYyOQJ+AjHush2KpbCeq7mGoEGA==
X-Received: by 2002:a5d:528b:: with SMTP id c11mr2239241wrv.25.1561548073665;
        Wed, 26 Jun 2019 04:21:13 -0700 (PDT)
Received: from localhost.localdomain ([188.26.252.192])
        by smtp.gmail.com with ESMTPSA id h14sm6233701wro.30.2019.06.26.04.21.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 26 Jun 2019 04:21:13 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     rmk+kernel@armlinux.org.uk, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, andrew@lunn.ch, davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 3/3] net: dsa: sja1105: Mark in-band AN modes not supported for PHYLINK
Date:   Wed, 26 Jun 2019 14:20:14 +0300
Message-Id: <20190626112014.7625-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190626112014.7625-1-olteanv@gmail.com>
References: <20190626112014.7625-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We need a better way to signal this, perhaps in phylink_validate, but
for now just print this error message as guidance for other people
looking at this driver's code while trying to rework PHYLINK.

Cc: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index ad4f604590c0..d82afb835fb7 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -806,6 +806,11 @@ static void sja1105_mac_config(struct dsa_switch *ds, int port,
 	if (sja1105_phy_mode_mismatch(priv, port, state->interface))
 		return;
 
+	if (link_an_mode == MLO_AN_INBAND) {
+		dev_err(ds->dev, "In-band AN not supported!\n");
+		return;
+	}
+
 	sja1105_adjust_port_config(priv, port, state->speed);
 }
 
-- 
2.17.1

