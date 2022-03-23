Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E460B4E525A
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 13:41:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242840AbiCWMnQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 08:43:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242800AbiCWMnQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 08:43:16 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA6B77B56B
        for <netdev@vger.kernel.org>; Wed, 23 Mar 2022 05:41:44 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id a8so2556948ejc.8
        for <netdev@vger.kernel.org>; Wed, 23 Mar 2022 05:41:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pqrs.dk; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9q5ZrmCokPC9Z7aa+GyRBFxvGpy5QI7QHPk6WFQeE0M=;
        b=Zx3FPQO5Pfom62MHOXFBrl64+TkzH3F2U669lkfasjC11tVbYCWhl+/77hdZpHW3HW
         iFG1x7z+lA0SpUvLm1hHZ8OYGkMIv3aGdEJ5gHzMDZK04Wi1nZnDQBmX9T+NIcEg1vQj
         itML3nEsEqaNgISKf15fp5CJ0wCkJlUtSpSj4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9q5ZrmCokPC9Z7aa+GyRBFxvGpy5QI7QHPk6WFQeE0M=;
        b=y+s3ZkqYkOYp8D+NtIOMlGXlUqCdvJ/v/e7/zS4JvBvu1XUBOu9FrAnaNx9lgiWBhw
         Tqmm/ISsJMvEzNaGQ+okmj/qKZuRA5GwWzYZegq9LQN9Qwuo1ULChQDTybkGvY3UoEDy
         YkDJggjt/eNOoidMgkv2P3dUmy1+dX1WNij5ShKziAI8ZsUs8Jn13SsM557aO9ldwl/C
         h5KA/VakP5XxZT5UaMZs8m2zF34gC134KfD0CU7dvwf6+gDXFmwB6V6getxvjzXSvrz0
         uxIQgUHgnOHJhpasryEVCmhTc8TORo9Vua12RZY/+8z6DiN+T0aW0RR/3PbB4i1BoVn3
         81oQ==
X-Gm-Message-State: AOAM532NxRkMzx7jwXxWmagEXSTvzSY7zAHTtj6M2tKJH0xBsD/SQpLR
        ddY4nbxhbla1pRO1K4ULT4zRZQ==
X-Google-Smtp-Source: ABdhPJzh6y7QzcDdSiCG83MPvyvc0Nv29zmMPcPFTu+6qrbD3YKQb8M3tLFElBn55Jw5T5H8an4MMA==
X-Received: by 2002:a17:906:c344:b0:6b4:c768:4a9a with SMTP id ci4-20020a170906c34400b006b4c7684a9amr32011159ejb.151.1648039303495;
        Wed, 23 Mar 2022 05:41:43 -0700 (PDT)
Received: from capella.. ([193.89.194.60])
        by smtp.gmail.com with ESMTPSA id r11-20020aa7cfcb000000b0041902ac4c6asm8888597edy.1.2022.03.23.05.41.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Mar 2022 05:41:42 -0700 (PDT)
From:   =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alvin@pqrs.dk>
To:     Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next] net: dsa: realtek: make interface drivers depend on OF
Date:   Wed, 23 Mar 2022 13:42:25 +0100
Message-Id: <20220323124225.91763-1-alvin@pqrs.dk>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alvin Šipraga <alsi@bang-olufsen.dk>

The kernel test robot reported build warnings with a randconfig that
built realtek-{smi,mdio} without CONFIG_OF set. Since both interface
drivers are using OF and will not probe without, add the corresponding
dependency to Kconfig.

Link: https://lore.kernel.org/all/202203231233.Xx73Y40o-lkp@intel.com/
Link: https://lore.kernel.org/all/202203231439.ycl0jg50-lkp@intel.com/
Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>
---
 drivers/net/dsa/realtek/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/dsa/realtek/Kconfig b/drivers/net/dsa/realtek/Kconfig
index b7427a8292b2..1aa79735355f 100644
--- a/drivers/net/dsa/realtek/Kconfig
+++ b/drivers/net/dsa/realtek/Kconfig
@@ -12,6 +12,7 @@ menuconfig NET_DSA_REALTEK
 config NET_DSA_REALTEK_MDIO
 	tristate "Realtek MDIO connected switch driver"
 	depends on NET_DSA_REALTEK
+	depends on OF
 	help
 	  Select to enable support for registering switches configured
 	  through MDIO.
@@ -19,6 +20,7 @@ config NET_DSA_REALTEK_MDIO
 config NET_DSA_REALTEK_SMI
 	tristate "Realtek SMI connected switch driver"
 	depends on NET_DSA_REALTEK
+	depends on OF
 	help
 	  Select to enable support for registering switches connected
 	  through SMI.
-- 
2.35.1

