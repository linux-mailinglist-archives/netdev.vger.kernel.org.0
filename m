Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC7B35033F5
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 07:48:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356531AbiDOXdF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 19:33:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356517AbiDOXc4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 19:32:56 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8241AF39;
        Fri, 15 Apr 2022 16:30:26 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id bv19so17596465ejb.6;
        Fri, 15 Apr 2022 16:30:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=WmCZ9hRbB62an5GsVNkCfotTv1C+Pq+pqfoG0trXrYw=;
        b=NrbgmZ7/sPHWBOqLS6fclHUEmJUNvSvN9gBhl1GoqYHpgGoY89hGlVoYoznxsVSNEZ
         AJR2v03lgl2RPZLbZJv8UgzTD6qs9DG0JPODms2dHK+3QLCEZfZ2zZwRjRXsNt+mfmP2
         vyx/H/Uzcsq3E8/Md2jppak6QVUgilREVt/RRkJvHJr5tGJy9vYPxChotcbnEwuY74vT
         UCtbclayPhrKTlq+lJyTdo6D/NLnTdBtnF7NHYpWS03n3oEXuox/qRxek2vVsH3r+4zo
         1s3S1rGp/OzZUWFttzxjPo9523FeYwobI9fShTnTK1BQ/y6ziuLwOP1mUDjjNQvDSV0z
         BkyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WmCZ9hRbB62an5GsVNkCfotTv1C+Pq+pqfoG0trXrYw=;
        b=59yBGsLT3WLWKkfqVb5vtISuwCxangOLcWuH5bIw7qyBv8KRx3Cy0WfrL+D1CKtd3W
         5PqO2dsdy3lCwDBHX2ZhmBjtoUnmAihYhbzRw//wdbpP87voKI3kSBh4GaQhVDx/lKEB
         lvCHm9IrfcWXIpgrJAwZ8lZyT2Ux3EezjIVoNAc/e7nkxeIEQxbNarR0Az9XD5HuY5Ve
         A/ohTy2R4xwdznAoo7f3YxHH787QDJTm7b5bbiHBJX76dkR657/mIpAWWdSyaLtCmLGp
         XbItZim7ppbhJVNSCSvF3y5CKuzKtil6dRdKCaQhE421dgf/txctTMK5Gyoaxx77g5Or
         ihSg==
X-Gm-Message-State: AOAM530jnUFj02uIuYfrxd5HTtEGAJhjbMr/MmWnh6ORCIlIa0fx93D7
        dtyFwvJTIRyasUcrTXEL3vA=
X-Google-Smtp-Source: ABdhPJyt5wwii3OM3X+TFE42Z8wIB4/a5Emck5TpNUKAsDkl7Bfdive4nTTH4BiJgXjMSr74OTzobA==
X-Received: by 2002:a17:906:3707:b0:6e8:6bfe:da0e with SMTP id d7-20020a170906370700b006e86bfeda0emr999346ejc.78.1650065425018;
        Fri, 15 Apr 2022 16:30:25 -0700 (PDT)
Received: from localhost.localdomain (host-79-33-253-62.retail.telecomitalia.it. [79.33.253.62])
        by smtp.googlemail.com with ESMTPSA id z21-20020a1709063a1500b006da6436819dsm2114588eje.173.2022.04.15.16.30.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 16:30:24 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Ansuel Smith <ansuelsmth@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [net-next PATCH v3 4/6] net: dsa: qca8k: drop dsa_switch_ops from qca8k_priv
Date:   Sat, 16 Apr 2022 01:30:15 +0200
Message-Id: <20220415233017.23275-5-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220415233017.23275-1-ansuelsmth@gmail.com>
References: <20220415233017.23275-1-ansuelsmth@gmail.com>
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
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/qca8k.c | 3 +--
 drivers/net/dsa/qca8k.h | 1 -
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 24d57083ee2c..ef8d686de609 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -3157,8 +3157,7 @@ qca8k_sw_probe(struct mdio_device *mdiodev)
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

