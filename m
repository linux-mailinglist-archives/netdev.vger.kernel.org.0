Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E130E4E3694
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 03:21:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235434AbiCVCRc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 22:17:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235370AbiCVCRW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 22:17:22 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCEB8245B5;
        Mon, 21 Mar 2022 19:14:39 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id h4so5070524wrc.13;
        Mon, 21 Mar 2022 19:14:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4e4qPKq8sPq7QTzJDHmma/b/Tofj4GtIBeiWbSSZTeU=;
        b=YNZ5DgH6/1NoZacr7qT+3PEBFsjWiYDKBXmU7Asw57xhxohy6dB4I7hzagd9h5XpN6
         u72wALuNNgpg0bmdLZGl+YSLdHR5Isye4A9yBDQs1NT8XJINE9fL+qEVXfwzb2UTQmlt
         qUdfk0sDQKJocGUWvGTtFA/QHZ0sYMBVMv6G6M/lJFe16BELEBpK51ESljWmHZEeWgH9
         NocZx6981JPByVBQFQ5ZJxWSeS9i6V3+Q7Ldvs3CpMJ27Q17ihZECAcvFNrfq8pGQPum
         bPbpKUubJJq2F+q3f9SGPZ9e/Hd0lEIM9zg5yGEW+DTp0xGkUT+rzR9eWehdeWJXNTFO
         JPEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4e4qPKq8sPq7QTzJDHmma/b/Tofj4GtIBeiWbSSZTeU=;
        b=p8Eoj+mazcNajT8VutL3XrjSNxXdbNk76AbQcu3dhq8JzNGuttfGBAD0eJtKj0BCGE
         I8fkM8pTmXnauLzoID0PmClbW+kQA0VueZv+sotvtD9L4hjpGoHGCscRvH+U51WYo6R5
         8PdFEODPcly9qvXWiJed0rlmdvJceFzyk7IYs7gIkwGOpwdj13pxdGgRUvShbhcjTQeg
         3RhdW+q0uOEhK0XyN8f24C/Kv1nayTh0zyscEfKPBuXfmPH4Ic+lrJWyHKS0c5AccIxU
         crcawVi2OrkImsy39QtMuxs8DS1cFMqVry8/9NTAvxsj1P7VM06CDGShA0l8/S2lnxsT
         ZIpQ==
X-Gm-Message-State: AOAM533USzFgNnYCuDKaQ2w9kIg7Yt1PjFzC6odH8PVbtDtYNU77RtXZ
        uBEntJ9Qp1xX+tsovRuhjZM=
X-Google-Smtp-Source: ABdhPJwVqBIAkIhwQPknJL4WIrRPIV67cJTRB6J0Dl+eIow16WwcWdXgO9Mv1abtugRBvKjBOyMTMQ==
X-Received: by 2002:a5d:4491:0:b0:203:f63a:e89b with SMTP id j17-20020a5d4491000000b00203f63ae89bmr14937568wrq.342.1647915278309;
        Mon, 21 Mar 2022 19:14:38 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-69-170.ip85.fastwebnet.it. [93.42.69.170])
        by smtp.googlemail.com with ESMTPSA id m2-20020a056000024200b00205718e3a3csm177968wrz.2.2022.03.21.19.14.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Mar 2022 19:14:38 -0700 (PDT)
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
Subject: [net-next PATCH 4/4] drivers: net: dsa: qca8k: drop dsa_switch_ops from qca8k_priv
Date:   Tue, 22 Mar 2022 02:45:06 +0100
Message-Id: <20220322014506.27872-5-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220322014506.27872-1-ansuelsmth@gmail.com>
References: <20220322014506.27872-1-ansuelsmth@gmail.com>
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
index c837444d37f6..38567080e7b3 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -3177,8 +3177,7 @@ qca8k_sw_probe(struct mdio_device *mdiodev)
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

