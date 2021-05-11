Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A65B1379C9C
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 04:09:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231486AbhEKCKO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 22:10:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231262AbhEKCJL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 22:09:11 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7737FC06138B;
        Mon, 10 May 2021 19:07:38 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id l14so18489584wrx.5;
        Mon, 10 May 2021 19:07:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=q2k47yfXQ6N5mq8ul+N9N9tXITaHlPGjSLKh+GAf2aw=;
        b=SI6Zac0Ug2XzXY2mJP+jxISa46VJrR9ek6Hv02XKB97dE4HttHiIbUIM12dGyRzGUS
         8AduuBkYOVqtbDYMsjTnc2ShzuJuBAJGnd+iwIbFYCOF6O3TcBbb8Fz0SyIc05ApkoVF
         pjUVBpl+id1PAyU56bJKyuDdpCxofxWEMZ+g4hKb9m/ht2bMOJu5sFAX2ihijN3ztwk/
         pcmIrS+OhGIS2eqovTcyrI/YqWEg8dn+fHTkOggyCF5cNGvR16DOnMSFbPumQCcvm8G8
         p7FB8h5ves67lpFfo4YygkasW8utDk31uLGwKQ+Kw0bQp/czDI6V5LXxndzvnAwEobwk
         BbBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=q2k47yfXQ6N5mq8ul+N9N9tXITaHlPGjSLKh+GAf2aw=;
        b=N8mZeR/dZ3yhC1fEQBILkL5HrzJxoMsZyBOPyHmLK61pMYiMnFCDalb3YHMYWmbu1F
         y6YFdOs2ofmn2FsL+nG/x4Zcdvm1dUox2+65kLrU7xV5jY2OWl/M+CMK2NUz/Xnl5LsN
         VPeUSg9/nvzeZx98ETCvgBpOBflz924Ftq7Hu4ayG/yre2HMDrsD0F8GvItQf1F+6V25
         2E8xvZInwaODki+7DFol+731bFA2D6CNy0rGvGBWP87LSQkjXiQfdOfQg1mSp1X+vzSg
         ZIq8pU33pY/+B1t4zhDUlvlN2U/+uKffMqW1yMTiYAllX3HU7tINijVtlwi/hmqr8qhb
         jsXA==
X-Gm-Message-State: AOAM532rOLYGj+X2uBG6bPZAjPg3a0kuR1kRZCtR/KnTLc9iSk9q2KC3
        ZOgTRoaxACziceOO1erRS5tz4Kkr/ZDrpQ==
X-Google-Smtp-Source: ABdhPJyrIDq80h8UnHWRwTpw9oYi4yrCaUpsCvclgJ1QHtn+NhWzEBY82Cmzf2VYeMfsDF4CRqJOKA==
X-Received: by 2002:a05:6000:136b:: with SMTP id q11mr34084035wrz.350.1620698857143;
        Mon, 10 May 2021 19:07:37 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id q20sm2607436wmq.2.2021.05.10.19.07.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 May 2021 19:07:36 -0700 (PDT)
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
Subject: [RFC PATCH net-next v5 15/25] net: dsa: qca8k: add ethernet-ports fallback to setup_mdio_bus
Date:   Tue, 11 May 2021 04:04:50 +0200
Message-Id: <20210511020500.17269-16-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210511020500.17269-1-ansuelsmth@gmail.com>
References: <20210511020500.17269-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dsa now also supports ethernet-ports. Add this new binding as a fallback
if the ports node can't be found.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/dsa/qca8k.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 35ff4cf08786..cc9ab35f8b17 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -718,6 +718,9 @@ qca8k_setup_mdio_bus(struct qca8k_priv *priv)
 	int err;
 
 	ports = of_get_child_by_name(priv->dev->of_node, "ports");
+	if (!ports)
+		ports = of_get_child_by_name(priv->dev->of_node, "ethernet-ports");
+
 	if (!ports)
 		return -EINVAL;
 
-- 
2.30.2

