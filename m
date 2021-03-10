Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72528333CE3
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 13:52:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232147AbhCJMwQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 07:52:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231993AbhCJMwP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 07:52:15 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44EA6C061760
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 04:52:15 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id r3so25070550lfc.13
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 04:52:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=42SiVyZh8edce6RravWC5/J0Ena3Q7WSf5MxDdvC78I=;
        b=p4G7wY/rwGwCgEH3HhL8ysG+1+ZpTWBYtB09IeBbYwpKwz388j4paFZi3TnZkjeQyD
         dh+Ms1J90izV8r7pK8xCjSUZJHIAj+VNYMAA8L9GzKrBtaQX5MpLxrh8EIvq8pjUDYte
         4m1CtP6wBFxNH1knNtyKYAZyipnzDy+kaFVXYLMOsJWKxY4yh6KSajUBMMOOV5brBteg
         DMyRR8wvEOxjpbcHeMX+iINnhBJh8V8KQaN3CsJl8YzVKckhoY09v4YGf7RgrDCAKHRZ
         8Yioic/qA5gGOU+jqgIaEDRCSawkyGIjnWVVTSaC6+2eES2Wlojm99NKAaAglWtGAzYu
         Bcuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=42SiVyZh8edce6RravWC5/J0Ena3Q7WSf5MxDdvC78I=;
        b=TYLoceyIvqTV0NTM2Vpmcl6HyD/zoC5VI7FcBX7G7GDKe019bgMOgRRbL+jlXVPKIt
         +QzFabHpTZUVQ6tSvetdT1cOWnx7SJ9kyDrybvY88EYiIRIZAPOIKE991Vk5/s56zVpF
         GlzjcE4dO/TpdbEplVGcQsNcJVfbFp7Kk2xgjkN9xlWSpvPwH8LQqMDQrKlins2wzgs8
         dbfr6KtCB7asfiynR3qwC9K4MWZSG6tc4j9Ku3mAPIr2rJCqFOcS/wIgh9LPQZgJ6adr
         oiIeMD4k8q94M/j06YUs4xpa2KEDYmK54GfIpyyMDPDt99rxTGCectxi9B1SJ0Jt+yJH
         LE+Q==
X-Gm-Message-State: AOAM5313gvS2hcbO9EdaBJvBRBbt654Raavk4+jb2kXRJEevcPFkpEbE
        h7D/Fn7cqynSKrAX+qTgnHrdq4q4qlc=
X-Google-Smtp-Source: ABdhPJwDTKVkkiI+bgsX9j59zV4yU33wYZy2bFIt7tiOcPKHDP5ECYaZRyznTH4lX+zoU5gyzqwVEg==
X-Received: by 2002:a19:7412:: with SMTP id v18mr1902937lfe.234.1615380733652;
        Wed, 10 Mar 2021 04:52:13 -0800 (PST)
Received: from localhost.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id f8sm3124737ljp.24.2021.03.10.04.52.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 04:52:13 -0800 (PST)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH] net: dsa: bcm_sf2: use 2 Gbps IMP port link on BCM4908
Date:   Wed, 10 Mar 2021 13:51:59 +0100
Message-Id: <20210310125159.28533-1-zajec5@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

BCM4908 uses 2 Gbps link between switch and the Ethernet interface.
Without this BCM4908 devices were able to achieve only 2 x ~895 Mb/s.
This allows handling e.g. NAT traffic with 940 Mb/s.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
 drivers/net/dsa/bcm_sf2.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index 7583fc12a9d7..d183206c4bb4 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -114,7 +114,10 @@ static void bcm_sf2_imp_setup(struct dsa_switch *ds, int port)
 		/* Force link status for IMP port */
 		reg = core_readl(priv, offset);
 		reg |= (MII_SW_OR | LINK_STS);
-		reg &= ~GMII_SPEED_UP_2G;
+		if (priv->type == BCM4908_DEVICE_ID)
+			reg |= GMII_SPEED_UP_2G;
+		else
+			reg &= ~GMII_SPEED_UP_2G;
 		core_writel(priv, reg, offset);
 
 		/* Enable Broadcast, Multicast, Unicast forwarding to IMP port */
-- 
2.26.2

