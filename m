Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FEE24CEBE1
	for <lists+netdev@lfdr.de>; Sun,  6 Mar 2022 15:22:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232073AbiCFOXf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Mar 2022 09:23:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiCFOXe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Mar 2022 09:23:34 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B2AB427C5
        for <netdev@vger.kernel.org>; Sun,  6 Mar 2022 06:22:42 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id q14so3950120wrc.4
        for <netdev@vger.kernel.org>; Sun, 06 Mar 2022 06:22:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc:from
         :subject:content-transfer-encoding;
        bh=kwZNP1RxO5jbKcqcVo5J57WHAPnFKQEGwOPKdKtn4w0=;
        b=mENyr2WdQu1iqLwhmiQsIsXSFNd7PdKKwtQl1rfqmbE/XSLL8YOI+//JgYzsmhT/8R
         vRv46mrhgItcdMH6BMeHhJC1nLlNbS1h8DjcRT8Ut0VS+goJyPfel5t4Hcb7JD13WopS
         FgWf0690mH+MeOv49WmV82CTDu5k8LpZNpjTFovD+6pbTOca8RdDSA8gy+vpR+SScid2
         /7j+SCdGfqqD7twLTBgKRJHLdEPgRe5EqIoDIxv8Bpu+CxWyzEkDXTpKHKNlx22SeUQq
         Ds3kVaLm9k7LQtMRs0Xe9uozSG/fjVq5Md5uNXlPVRs2b4N2F4mncsauOLZcVv5aXG0w
         7hRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:from:subject:content-transfer-encoding;
        bh=kwZNP1RxO5jbKcqcVo5J57WHAPnFKQEGwOPKdKtn4w0=;
        b=rLGkXeCccmKFIPtPGCA0NK6pXxuMzKc/EXEOJrs5c8ooNzvC6kr0zFQC7LjREfDOpW
         g096qk8qtJNuazZLNG++E4kE8G1d5ErL+/F/XmwQ+6eYm5QEp5F3EoG6+QAXVWTViLYp
         lrtC/F+dJz1UFwjntmzgp/OA2P0nJEBiee7nJp1pr7dMQsCWEAzGqHG3PRfa09z3Qjo4
         vp62g9pkYoCQTXwZb+HagaJz4OLWnCyUVu49f5YilkenzRs+GdrgzN2Yhdzpw8P0kUcc
         hAySC+YnEMeQ2wsT94OT5xbgbBHDOhvYmqGeE1XJ5jBM6MgzX4wIzkJgEx03l3BN5l8N
         DIWA==
X-Gm-Message-State: AOAM530RpwKqMhwoHST0unNGST9DeMXlVkV5FxswrAq+C3N/6C7Uz99d
        EVPbwJhhAEoHm1BdOjUO6jg=
X-Google-Smtp-Source: ABdhPJwz0k5f0VBg+0WOZX0k59yimCL4Hji5pMudDyGxj1Tk28EAmeG2dj+7agmnR196RFb4IbISqg==
X-Received: by 2002:a05:6000:101:b0:1f0:2381:7feb with SMTP id o1-20020a056000010100b001f023817febmr5471961wrx.10.1646576560862;
        Sun, 06 Mar 2022 06:22:40 -0800 (PST)
Received: from ?IPV6:2a01:c22:7720:f200:10e7:aa42:9870:907c? (dynamic-2a01-0c22-7720-f200-10e7-aa42-9870-907c.c22.pool.telefonica.de. [2a01:c22:7720:f200:10e7:aa42:9870:907c])
        by smtp.googlemail.com with ESMTPSA id o18-20020a05600c511200b00352ec3b4c5asm12716375wms.7.2022.03.06.06.22.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 06 Mar 2022 06:22:40 -0800 (PST)
Message-ID: <00b4bb1e-98f9-b4e7-5549-e095a4701f66@gmail.com>
Date:   Sun, 6 Mar 2022 15:22:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] net: mdio-mux: add bus name to bus id
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In case of DT-configured systems it may be hard to identify the PHY
interrupt in the /proc/interrupts output. Therefore add the name to
the id to make clearer that it's about a device on a muxed mdio bus.
In my case:

Now: mdio_mux-0.e40908ff:08
Before: 0.e40908ff:08

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/mdio/mdio-mux.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/mdio/mdio-mux.c b/drivers/net/mdio/mdio-mux.c
index ebd001f0e..a881e3523 100644
--- a/drivers/net/mdio/mdio-mux.c
+++ b/drivers/net/mdio/mdio-mux.c
@@ -168,8 +168,8 @@ int mdio_mux_init(struct device *dev,
 		cb->mii_bus->priv = cb;
 
 		cb->mii_bus->name = "mdio_mux";
-		snprintf(cb->mii_bus->id, MII_BUS_ID_SIZE, "%x.%x",
-			 pb->parent_id, v);
+		snprintf(cb->mii_bus->id, MII_BUS_ID_SIZE, "%s-%x.%x",
+			 cb->mii_bus->name, pb->parent_id, v);
 		cb->mii_bus->parent = dev;
 		cb->mii_bus->read = mdio_mux_read;
 		cb->mii_bus->write = mdio_mux_write;
-- 
2.35.1

