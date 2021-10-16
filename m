Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78A9E430085
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 08:24:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239910AbhJPG0e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Oct 2021 02:26:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239451AbhJPG0d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Oct 2021 02:26:33 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C21BFC061570;
        Fri, 15 Oct 2021 23:24:25 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id l6so7726542plh.9;
        Fri, 15 Oct 2021 23:24:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZvOvoZcvvH/Tx90si2pKJuiA/fIC5HYugtK+5A8dZIs=;
        b=adWh4ygPqc92epNkTraqhJCi7bUk4sjO5zyT+A14oTHay7XdUEdrusc0T7n4dkJWr8
         iuYo+Wx9Twyue8mGvq71xjUsiHbNgE07aZSGVxQhDBv7t2zmYCjzpcYDD0Lwa3Oewc1O
         ncs3GLLEsK2mqJt3jrezh6hJ7sDe7oub0C7Q2E0raaAzhpeRysyKDnS7ALzmIgSI7W5J
         iFVAeygq2FgIZqnuCK2xjln6M6LtSIXKitatPcbCy9tEQJGYyv77WE3dnq+eL+dPLefR
         Qoie4B4uSaOBdnXp58iT0M0aUVkp7uTxAaQegU6Jz6R/trZj//vVu6CTwYjfQSVd3cBv
         P12A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZvOvoZcvvH/Tx90si2pKJuiA/fIC5HYugtK+5A8dZIs=;
        b=uztWHbeQFZlLdZLn6qiwpyzP6kTMY6CbB3xZIBZaTRUTtCMr2c+Gh9zLVWzHsubf4x
         rZHYzNwDHyPh2JS9PhKSNqpfWnNlbP2N6rbW/zMGpAdn631bgBPc1sNdpMNv56dCGg1M
         LvcxH1490DMlrs+ngkTPGhckjsIVZ/Efmq1wOvOhOjFjhrKz4mAlcogx0h7tB/YKMmo2
         QR6fbDrfKjf+83mWw0iFr9faGCy+pzYAwZKcHkmhUEjACbgXmxZXudQMg3LecSVIuhnn
         jFHnQGcXN8dAVlOJ6GsywJw3yHAsnDBrLT+4K/+zO/68GBLdx5vMC4eK20FRn1YAEbOh
         s4QQ==
X-Gm-Message-State: AOAM533RIWhwpxwN/84ac3vlSqecFXAej8z/05AjThT1ez558CMWQnWO
        BzKYBBHCmRUT4hmmW5JH0Wg=
X-Google-Smtp-Source: ABdhPJzaqUWxXy8civOeDMmAst1Ydj5bQI6jj4MORNLBbMI0BSepJ0kkZcvj9C/q3tDNOeRM/XNQXA==
X-Received: by 2002:a17:902:e846:b0:13f:551b:ba23 with SMTP id t6-20020a170902e84600b0013f551bba23mr14791681plg.77.1634365465100;
        Fri, 15 Oct 2021 23:24:25 -0700 (PDT)
Received: from localhost.localdomain ([171.211.26.24])
        by smtp.gmail.com with ESMTPSA id z11sm13147334pjl.45.2021.10.15.23.24.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Oct 2021 23:24:24 -0700 (PDT)
From:   DENG Qingfang <dqfext@gmail.com>
To:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: [PATCH net] net: dsa: mt7530: correct ds->num_ports
Date:   Sat, 16 Oct 2021 14:24:14 +0800
Message-Id: <20211016062414.783863-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Setting ds->num_ports to DSA_MAX_PORTS made DSA core allocate unnecessary
dsa_port's and call mt7530_port_disable for non-existent ports.

Set it to MT7530_NUM_PORTS to fix that, and dsa_is_user_port check in
port_enable/disable is no longer required.

Cc: stable@vger.kernel.org
Signed-off-by: DENG Qingfang <dqfext@gmail.com>
---
 drivers/net/dsa/mt7530.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index a3b49abd32f1..dbd15da977b5 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -1035,9 +1035,6 @@ mt7530_port_enable(struct dsa_switch *ds, int port,
 {
 	struct mt7530_priv *priv = ds->priv;
 
-	if (!dsa_is_user_port(ds, port))
-		return 0;
-
 	mutex_lock(&priv->reg_mutex);
 
 	/* Allow the user port gets connected to the cpu port and also
@@ -1060,9 +1057,6 @@ mt7530_port_disable(struct dsa_switch *ds, int port)
 {
 	struct mt7530_priv *priv = ds->priv;
 
-	if (!dsa_is_user_port(ds, port))
-		return;
-
 	mutex_lock(&priv->reg_mutex);
 
 	/* Clear up all port matrix which could be restored in the next
@@ -3265,7 +3259,7 @@ mt7530_probe(struct mdio_device *mdiodev)
 		return -ENOMEM;
 
 	priv->ds->dev = &mdiodev->dev;
-	priv->ds->num_ports = DSA_MAX_PORTS;
+	priv->ds->num_ports = MT7530_NUM_PORTS;
 
 	/* Use medatek,mcm property to distinguish hardware type that would
 	 * casues a little bit differences on power-on sequence.
-- 
2.25.1

