Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55E2539FCB
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 15:04:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727209AbfFHNDz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 09:03:55 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:35456 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726976AbfFHNDx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jun 2019 09:03:53 -0400
Received: by mail-wm1-f65.google.com with SMTP id c6so4296048wml.0
        for <netdev@vger.kernel.org>; Sat, 08 Jun 2019 06:03:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=CLqH0w/I6sunkxJ22Wy2o1Iuu5mQCzkmSEeU1R8OL+4=;
        b=eRfIxTS1nNMDW36zkPzwuCMsmUcsF/Erb80aRrxbeqVdEPUc8Vfe+gZZ56IhVCNaMZ
         Ip5UVhMAorkEm05H2YO3xtINasMm5ZngWTPGpEPmz4rcPIADtSajmTlfQWGigY9lBYs3
         /+67FDgMieumyigs4bOWof7uyQmy9A+WcvVY/OYXAcmUOXBypXtA14GlWVCXIpfAr4Zd
         KeBAwyg2LZgKBXX3CFskjpATTkXAWOo5cho86b9HmP1s/OvPTZrYJeH1aw0M71SCU8aL
         1NoowHmpZbTu+rItD/DmEBg8cgIDkWRXFNBDpKWSY5+I9OSSGea1LJPM6grVPEFdwrxS
         WOIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=CLqH0w/I6sunkxJ22Wy2o1Iuu5mQCzkmSEeU1R8OL+4=;
        b=S/I3o3HXvRCPBbVt8cTKkB1THqeVu9r+/atiMaMl43omRmPRbAz03VSdbAT/FuHO5x
         U32QEjIFpevAjZodqxkvCwXL1IGGYS1YHA6EvfC6Edh2EEwycI9Az8cwV2RaJY76d1ej
         gWxY4XRwewa0sQEkW1apSjVhif+Nf9T5WP5eFCfvxJtHWNhSg/BSuhVl8xA+ot0dTEKJ
         hl9IPvTEBXJHBZ7rvV2jG4FqDrcf78rI91llbhRVggdeON+lvcHOh0gepFD8Ltk85JUb
         DQkj6/7DHnl3UvDT3JSL9jM6MeqglvLsZ6K4TZm2GKezdwxJ7Osfdpvv/AP5h0Ew/Apk
         yGaA==
X-Gm-Message-State: APjAAAVsmXM2MDG5EvVplvaz5YA2rxcU4SiS00kxEWWfVUVLr3vzp2/z
        Tt9ON1Zx3wKd4HHGazBnJlE=
X-Google-Smtp-Source: APXvYqzUfOqgCnplc0syQBZuMKIRB8LPpQLCvJkjzFzd4pJsusWKa0k2Hc44AAyT9M14SrUgaHXYhw==
X-Received: by 2002:a05:600c:c6:: with SMTP id u6mr7296462wmm.153.1559999031434;
        Sat, 08 Jun 2019 06:03:51 -0700 (PDT)
Received: from localhost.localdomain ([188.26.252.192])
        by smtp.gmail.com with ESMTPSA id 128sm4632766wme.12.2019.06.08.06.03.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 08 Jun 2019 06:03:51 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 1/4] net: dsa: sja1105: Use SPEED_{10,100,1000,UNKNOWN} macros
Date:   Sat,  8 Jun 2019 16:03:41 +0300
Message-Id: <20190608130344.661-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190608130344.661-1-olteanv@gmail.com>
References: <20190608130344.661-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a cosmetic patch that replaces the link speed numbers used in
the driver with the corresponding ethtool macros.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
Suggested-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 15bee785fd6d..580568922f35 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -689,12 +689,12 @@ static int sja1105_parse_dt(struct sja1105_private *priv,
 	return rc;
 }
 
-/* Convert back and forth MAC speed from Mbps to SJA1105 encoding */
+/* Convert link speed from SJA1105 to ethtool encoding */
 static int sja1105_speed[] = {
-	[SJA1105_SPEED_AUTO]     = 0,
-	[SJA1105_SPEED_10MBPS]   = 10,
-	[SJA1105_SPEED_100MBPS]  = 100,
-	[SJA1105_SPEED_1000MBPS] = 1000,
+	[SJA1105_SPEED_AUTO]		= SPEED_UNKNOWN,
+	[SJA1105_SPEED_10MBPS]		= SPEED_10,
+	[SJA1105_SPEED_100MBPS]		= SPEED_100,
+	[SJA1105_SPEED_1000MBPS]	= SPEED_1000,
 };
 
 /* Set link speed and enable/disable traffic I/O in the MAC configuration
@@ -720,17 +720,17 @@ static int sja1105_adjust_port_config(struct sja1105_private *priv, int port,
 	mac = priv->static_config.tables[BLK_IDX_MAC_CONFIG].entries;
 
 	switch (speed_mbps) {
-	case 0:
+	case SPEED_UNKNOWN:
 		/* No speed update requested */
 		speed = SJA1105_SPEED_AUTO;
 		break;
-	case 10:
+	case SPEED_10:
 		speed = SJA1105_SPEED_10MBPS;
 		break;
-	case 100:
+	case SPEED_100:
 		speed = SJA1105_SPEED_100MBPS;
 		break;
-	case 1000:
+	case SPEED_1000:
 		speed = SJA1105_SPEED_1000MBPS;
 		break;
 	default:
@@ -786,7 +786,7 @@ static void sja1105_mac_config(struct dsa_switch *ds, int port,
 	struct sja1105_private *priv = ds->priv;
 
 	if (!state->link)
-		sja1105_adjust_port_config(priv, port, 0, false);
+		sja1105_adjust_port_config(priv, port, SPEED_UNKNOWN, false);
 	else
 		sja1105_adjust_port_config(priv, port, state->speed, true);
 }
@@ -1311,7 +1311,7 @@ static int sja1105_static_config_reload(struct sja1105_private *priv)
 		goto out;
 
 	for (i = 0; i < SJA1105_NUM_PORTS; i++) {
-		bool enabled = (speed_mbps[i] != 0);
+		bool enabled = (speed_mbps[i] != SPEED_UNKNOWN);
 
 		if (i != dsa_upstream_port(priv->ds, i))
 			sja1105_bridge_stp_state_set(priv->ds, i, stp_state[i]);
-- 
2.17.1

