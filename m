Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8E4F4FE743
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 19:37:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358425AbiDLRj0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 13:39:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358453AbiDLRjS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 13:39:18 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28A9562A0A;
        Tue, 12 Apr 2022 10:36:57 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id bg10so38779451ejb.4;
        Tue, 12 Apr 2022 10:36:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LtZCMAaqO/VG5YpfRuO+UKadnxV+qlzoG2jHc4egOys=;
        b=BhFlfM7WlDWeQoL2oBPd1wdD5+QfBwB3o37cqrfIeRYLcN8LhGUW/3FRIoXiw2zssZ
         pMsBvqP2XmGk1/t/lPq9UaKDY/NCVEsbejHkvAk1f6/2gt5/3Nfh+WPV+MAJZrLdnwIT
         R1rudQaoZpMYYTmisjTx4dDSWnQ+VsE6ocgY4be+JodlEy+1crl9xhXHjRWs7SXehYzt
         KUMXhT5/Cdxa9RvZm6TgYYmgbb5e7H43zsbv7myXFz1ZHDpiiQ/k6VcN1aeOcpgJOcn7
         /0px6ND5ozbN0MGiLpw3mmxU0aJaF0P7CHeCftw8udgjbcRgb7eeE6k6cBuUPbzZBcqH
         rKfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LtZCMAaqO/VG5YpfRuO+UKadnxV+qlzoG2jHc4egOys=;
        b=FT0U5qPc7ConXgRf4vG/C0hxV6+pVDtM26qmBvII6F9qFMmvk+I0JtDGWJqN+tYeLs
         bF3/4542z+aR8cKWKSDR0fyRLJWxOtD2+y9S8MSRmZ3+4Nx21Wr9Rls3FKH7Euw448J4
         JGc3kwNrK6tXXtnkbSbY1bug65ZZZVu4FUpgZiIAdISZAhvkteaKkJPRuXVpZR+eVXye
         Pl8LiuPrHeNp3FEr9Eo2AQRILmCc1QuSVQhv/E/8p0BDZADwS/HFrbmrv6+KaByVX47O
         yQna9lJWDSkYaoiacJrcbBdI1xjB2WZNzv9CHcb3JxpZp7SWfF3c3QdOqVaxHSgZPag6
         Q75g==
X-Gm-Message-State: AOAM5306rhH/yPAZsiMuEiYexyT/3zQoTaI9QsuL7BE8n99CmHniu1CP
        PwWUuSYxFx9r6uMBlAKGc0M=
X-Google-Smtp-Source: ABdhPJwBpvYMW9Rop2D/kRLqtKhVc9292ewqg60QqdMXSB5mXpLFNudGe4Aea/oqfX56vmp9ucWXIw==
X-Received: by 2002:a17:907:6289:b0:6e0:eb0c:8ee7 with SMTP id nd9-20020a170907628900b006e0eb0c8ee7mr33978446ejc.245.1649785015404;
        Tue, 12 Apr 2022 10:36:55 -0700 (PDT)
Received: from localhost.localdomain ([5.171.105.8])
        by smtp.googlemail.com with ESMTPSA id n11-20020a50cc4b000000b0041d8bc4f076sm48959edi.79.2022.04.12.10.36.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 10:36:55 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next PATCH v2 4/4] drivers: net: dsa: qca8k: drop dsa_switch_ops from qca8k_priv
Date:   Tue, 12 Apr 2022 19:30:19 +0200
Message-Id: <20220412173019.4189-5-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220412173019.4189-1-ansuelsmth@gmail.com>
References: <20220412173019.4189-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that dsa_switch_ops is not switch specific anymore, we can drop it
from qca8k_priv and use the static ops directly for the dsa_switch
pointer.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 3 +--
 drivers/net/dsa/qca8k.h | 1 -
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 9c4c5af79f9a..48a71d85b4ff 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -3160,8 +3160,7 @@ qca8k_sw_probe(struct mdio_device *mdiodev)
 	priv->ds->dev = &mdiodev->dev;
 	priv->ds->num_ports = QCA8K_NUM_PORTS;
 	priv->ds->priv = priv;
-	priv->ops = qca8k_switch_ops;
-	priv->ds->ops = &priv->ops;
+	priv->ds->ops = &qca8k_switch_ops;
 	mutex_init(&priv->reg_mutex);
 	dev_set_drvdata(&mdiodev->dev, priv);
 
diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
index 8bbe36f135b5..04408e11402a 100644
--- a/drivers/net/dsa/qca8k.h
+++ b/drivers/net/dsa/qca8k.h
@@ -394,7 +394,6 @@ struct qca8k_priv {
 	struct dsa_switch *ds;
 	struct mutex reg_mutex;
 	struct device *dev;
-	struct dsa_switch_ops ops;
 	struct gpio_desc *reset_gpio;
 	struct net_device *mgmt_master; /* Track if mdio/mib Ethernet is available */
 	struct qca8k_mgmt_eth_data mgmt_eth_data;
-- 
2.34.1

