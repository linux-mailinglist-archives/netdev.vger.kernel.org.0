Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A5C926CA3E
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 21:53:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728137AbgIPTwp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 15:52:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728058AbgIPTwU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 15:52:20 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61242C06178A;
        Wed, 16 Sep 2020 12:52:08 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id e11so2930168wme.0;
        Wed, 16 Sep 2020 12:52:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NIgP1IMD11EmFdVElztj04n1KpP4IeEEjiU3R2832Rg=;
        b=rj1jdJwVzMdpe+tET8OP9eBonAt5oW5u0kil8bVAGkwKZkWhj/ygksEx2cvBaHUHo/
         CXNh1WI84B3yy2cPSJF9kEFsPBAA3uyQOUM7rqKl3FIGPSEbdvo0WtWoqbWf9Elz7h24
         8JWEriQdFTGziiZyMsQlcJhOBOYrcBqIkHxwE9KTo6O61nbH1JjpNvfP84Ol1ESua5+1
         E9mluf9Vm8jWlEaT6F9v9byad76rFrG+OtvnxePDkWhjAkpSfjogonxabXHyc9PqI/aY
         BpbR/xGmtuZ6YleCwY7UilvhAgZY1CTwZByS0u7PjmLINKHO/UI/Oyy2RiubZvue0ji1
         NYHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NIgP1IMD11EmFdVElztj04n1KpP4IeEEjiU3R2832Rg=;
        b=hrbrGu2KE9xI0lN1v4nhnozzNfd7Lb1bk21YoGIEMvJ1IwFjdIQ8+4rGSwg80LPI/B
         bujwIQ9EMAUfgME6t2h8yaZQrJ9ggFq2fkiQEB+W3mYwqr7W5G0j0coITslLOZXr/oNM
         Yg4wljKVxcFK1KK2ia0KJn2uMmrXsJr2yEpWIFGALIThUoiGF0Xj6pGrUJxEAA8r+Faa
         zg/r/F/hvOA0VL69Z1ksiTeN2/Ub13PFU7AfbGE3mKxJXfA0xO0dc32V4ruL4/4/Wdtz
         Lw3aifxoNcUrJg5LIdsXEnPfU2a5EW67JaD0YEzAeEFphvW5ZqV8mbv+OmD0NKFDYF2w
         3WVw==
X-Gm-Message-State: AOAM532kS+7M8adTmEFzhRarRxK+iJR9e4KSdHn4fxyWVBFnEhvh5TvT
        kpQ8ljkOxEf/FWNgQoEbwn8=
X-Google-Smtp-Source: ABdhPJwprPQA3V/Ml0Wj9p+zL+JldStv1T4Rk+gCoW48cV+AInlv2N5BcogiOEb/p3kDieiOtFI3rQ==
X-Received: by 2002:a05:600c:2109:: with SMTP id u9mr5997086wml.147.1600285926318;
        Wed, 16 Sep 2020 12:52:06 -0700 (PDT)
Received: from localhost.localdomain (cpc83661-brig20-2-0-cust443.3-3.cable.virginm.net. [82.28.105.188])
        by smtp.gmail.com with ESMTPSA id g131sm7077036wmf.25.2020.09.16.12.52.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2020 12:52:05 -0700 (PDT)
From:   Alex Dewar <alex.dewar90@gmail.com>
Cc:     Alex Dewar <alex.dewar90@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Landen Chao <landen.chao@mediatek.com>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: dsa: mt7530: Add some return-value checks
Date:   Wed, 16 Sep 2020 20:50:17 +0100
Message-Id: <20200916195017.34057-1-alex.dewar90@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In mt7531_cpu_port_config(), if the variable port is neither 5 nor 5,
then variable interface will be used uninitialised. Change the function
to return -EINVAL in this case.

As the return value of mt7531_cpu_port_config() is never checked
(even though it returns an int) add a check in the correct place so that
the error can be passed up the call stack. Now that we correctly handle
errors thrown in this function, also check the return value of
mt7531_mac_config() in case an error occurs here.

Addresses-Coverity: 1496993 ("Uninitialized variables")
Fixes: c288575f7810 ("net: dsa: mt7530: Add the support of MT7531 switch")
Signed-off-by: Alex Dewar <alex.dewar90@gmail.com>
---

If it is not expected that these functions will throw errors (i.e.
because the parameters passed will always be correct), we could dispense
with the use of EINVAL errors and just use BUG*() macros instead. Let me
know if you'd rather I fix things up in that way.

Best,
Alex

 drivers/net/dsa/mt7530.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 61388945d316..157d0a01faae 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -945,10 +945,14 @@ static int
 mt753x_cpu_port_enable(struct dsa_switch *ds, int port)
 {
 	struct mt7530_priv *priv = ds->priv;
+	int ret;
 
 	/* Setup max capability of CPU port at first */
-	if (priv->info->cpu_port_config)
-		priv->info->cpu_port_config(ds, port);
+	if (priv->info->cpu_port_config) {
+		ret = priv->info->cpu_port_config(ds, port);
+		if (ret)
+			return ret;
+	}
 
 	/* Enable Mediatek header mode on the cpu port */
 	mt7530_write(priv, MT7530_PVC_P(port),
@@ -2275,7 +2279,7 @@ mt7531_cpu_port_config(struct dsa_switch *ds, int port)
 {
 	struct mt7530_priv *priv = ds->priv;
 	phy_interface_t interface;
-	int speed;
+	int ret, speed;
 
 	switch (port) {
 	case 5:
@@ -2293,6 +2297,8 @@ mt7531_cpu_port_config(struct dsa_switch *ds, int port)
 
 		priv->p6_interface = interface;
 		break;
+	default:
+		return -EINVAL;
 	}
 
 	if (interface == PHY_INTERFACE_MODE_2500BASEX)
@@ -2300,7 +2306,9 @@ mt7531_cpu_port_config(struct dsa_switch *ds, int port)
 	else
 		speed = SPEED_1000;
 
-	mt7531_mac_config(ds, port, MLO_AN_FIXED, interface);
+	ret = mt7531_mac_config(ds, port, MLO_AN_FIXED, interface);
+	if (ret)
+		return ret;
 	mt7530_write(priv, MT7530_PMCR_P(port),
 		     PMCR_CPU_PORT_SETTING(priv->id));
 	mt753x_phylink_mac_link_up(ds, port, MLO_AN_FIXED, interface, NULL,
-- 
2.28.0

