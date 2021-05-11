Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7B69379C8E
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 04:08:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231378AbhEKCJo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 22:09:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231154AbhEKCIs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 22:08:48 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2544C06134B;
        Mon, 10 May 2021 19:07:35 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id n2so18537248wrm.0;
        Mon, 10 May 2021 19:07:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pxoAtd6bXHfxKa7cETX7w7wJY2h0SKtno26/K3HwcI0=;
        b=FGb39c3jCsnT2VcOFILqqlWOwQAdh1R1jzk6UCQuEy9Qg0X0FycBIQDnKTFuS+Et2Y
         SvvQj4GEULZujj5SyBqgX+ODLEcoF4fz/exD9oQ8Lan2WmnO0kTLHT3QkPGL3+C7jw/3
         pdn4M3NVJaQ4bQE9BH9oPHED8sVf0Tq8RethSSCgtbKo8dFuB0wwkLOdSVZhJi0O0auH
         x62cJoi0n4JJ5QJPP+Gdm5ddnAOavHak9Bxewvl5Y2R8cy3MxI7HNBLvD+OwmRM88iGY
         Tjv9DaGoWzbA/W1groEDEJ9XNEfIKxWbfz+YKPb1I5Pygj0IKJETlYR1MSs7Qbm2bkDZ
         gR7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pxoAtd6bXHfxKa7cETX7w7wJY2h0SKtno26/K3HwcI0=;
        b=JupHhx2wK83AM6LSYhWIygzeT5nj+NCyEl7syMtMlKLTPCDqUx/f3WpcI8KH6eyXTD
         2l06gU5cNHW9yRov85oRzta4Dza1ezgYYkMZy39OWqw1S3eXtyVbpoP8MMOdV+/svNtQ
         uRI75UO4+MtGEGVwTNXV5AoTf3O9U0uXOxaYtDdMdnXx6Z7YymaOmbJeuCrbaxKyhWDD
         ZArHYi5dgLh0l0qRVf3rz8qS4bhPJT9+7GY2Kss9orzsqFnBjkj+Gch9mepAiV+OlfBr
         VF5mKj0aviVpJRPlDfY4+9Z/zwfxF71Qs4NZvk5ZdaJxgRN0IBuiXR+8EFFiwl0z+Sc/
         0BvQ==
X-Gm-Message-State: AOAM531aK/VvxaOk5dp3MZltGnzqjumVyXI7FdHgK8cpXhaA9gFkgXqA
        7f/rWWKDtO1M8tHoKJz3yDY=
X-Google-Smtp-Source: ABdhPJxDIfPh68QOlysG9TGEb4u7Su6rNXf+o0eEDXXhLXYY2u3ZcTnw5kZ8qHhtrwT5NFJLbhCaMA==
X-Received: by 2002:a05:6000:186a:: with SMTP id d10mr35022391wri.41.1620698854337;
        Mon, 10 May 2021 19:07:34 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id q20sm2607436wmq.2.2021.05.10.19.07.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 May 2021 19:07:34 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED
        DEVICE TREE BINDINGS), linux-kernel@vger.kernel.org (open list)
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [RFC PATCH net-next v5 12/25] net: dsa: qca8k: limit port5 delay to qca8337
Date:   Tue, 11 May 2021 04:04:47 +0200
Message-Id: <20210511020500.17269-13-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210511020500.17269-1-ansuelsmth@gmail.com>
References: <20210511020500.17269-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Limit port5 rx delay to qca8337. This is taken from the legacy QSDK code
that limits the rx delay on port5 to only this particular switch version,
on other switch only the tx and rx delay for port0 are needed.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 65f27d136aef..b598930190e1 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -1003,8 +1003,10 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 			    QCA8K_PORT_PAD_RGMII_EN |
 			    QCA8K_PORT_PAD_RGMII_TX_DELAY(QCA8K_MAX_DELAY) |
 			    QCA8K_PORT_PAD_RGMII_RX_DELAY(QCA8K_MAX_DELAY));
-		qca8k_write(priv, QCA8K_REG_PORT5_PAD_CTRL,
-			    QCA8K_PORT_PAD_RGMII_RX_DELAY_EN);
+		/* QCA8337 requires to set rgmii rx delay */
+		if (priv->switch_id == QCA8K_ID_QCA8337)
+			qca8k_write(priv, QCA8K_REG_PORT5_PAD_CTRL,
+				    QCA8K_PORT_PAD_RGMII_RX_DELAY_EN);
 		break;
 	case PHY_INTERFACE_MODE_SGMII:
 	case PHY_INTERFACE_MODE_1000BASEX:
-- 
2.30.2

