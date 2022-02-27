Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B71B94C5934
	for <lists+netdev@lfdr.de>; Sun, 27 Feb 2022 05:00:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbiB0EAd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Feb 2022 23:00:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229776AbiB0EAc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Feb 2022 23:00:32 -0500
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5430A1DAC79;
        Sat, 26 Feb 2022 19:59:57 -0800 (PST)
Received: by mail-oi1-x230.google.com with SMTP id ay7so10711219oib.8;
        Sat, 26 Feb 2022 19:59:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Yc4Md8uQ1K2PiNkAhQu02D29TgOkrggKvXdUOlqcNUY=;
        b=EWJKvI4iumVT90vWtS4NE38dV9ZdJY048t8Yz4gL4QEpH+fZ1CTS5EKgrDDoQEr8h3
         NObBs2YwTCk9eTOVndOmtWVSA2T7XgSzkKXCHZu5TLRxDmZDnuAWo7lcOH/cYUZQUzMm
         b5Qot4L5cvoXc4FkpdELazj3I3yRYOZFS1RADQ58Cyq/wO2sVkjtSSIzKemHI3Ccow8S
         W3u3EA5JnN0WKOP3hbBR2M5hrWUH0K+w/eAM1nrdXG836ajSCrMe2n122p0LBDTYnxwx
         Oa0qJr9vrt3lyvsMhbw+AMZvqT9YvAlmtak+9CiBzN1N3gBhJRzz02/BdR4xa9Nz0EJ9
         YdNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Yc4Md8uQ1K2PiNkAhQu02D29TgOkrggKvXdUOlqcNUY=;
        b=SwdQdVtKSW2VUGrXCbqns/pl7Sr/DF29k/JW7cBOV/o/Mx3JPzn9rDJlG7Cq3XWzWl
         RA/u4oFOeLCaug6ePEKyxz9uSaUuhc80WVZoFFKbRXLJ4KRpiod+M+6vMXdxJZcHodka
         faHuCK3MjOQdF2Dh2LGQvgCoGXU3MvKJ+mqrjcYiZjth8/IBiat2hyLqzk5f49aHEJtK
         pZY/xe/wUHhkySuuC5sghQnxzJQ6BkqkCJJFdkN+mZU/ApoJlVW44qXF+hIrR+IjbyW9
         5FlyZ1w80wIFZm0A9SaFYoGzux1YBzZOkvhfSchrZGznBYDP0RKQHVz8VEf3bLd5AebS
         Dvdw==
X-Gm-Message-State: AOAM530DlBYQ93vshVgKi988UKyx/KCELcOG7Z4OV0Lwv0S1wjLzHul4
        pEctvA3n5HezNWm0ALiOCeI2MOCkMZqbdA==
X-Google-Smtp-Source: ABdhPJzRUl2SRB8VMrdQodk0yhOgjS/Z/YjbMR1DbovTQb921A8A5jp04IvONZcF1GIBMY+/521BPg==
X-Received: by 2002:a05:6808:1385:b0:2cf:491e:157d with SMTP id c5-20020a056808138500b002cf491e157dmr6585067oiw.12.1645934396531;
        Sat, 26 Feb 2022 19:59:56 -0800 (PST)
Received: from tresc043793.tre-sc.gov.br ([187.94.103.218])
        by smtp.gmail.com with ESMTPSA id t9-20020a056871054900b000c53354f98esm3010285oal.13.2022.02.26.19.59.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Feb 2022 19:59:56 -0800 (PST)
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org, alsi@bang-olufsen.dk, arinc.unal@arinc9.com,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        devicetree@vger.kernel.org
Subject: [PATCH net-next v4 1/3] dt-bindings: net: dsa: add rtl8_4 and rtl8_4t
Date:   Sun, 27 Feb 2022 00:59:18 -0300
Message-Id: <20220227035920.19101-2-luizluca@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220227035920.19101-1-luizluca@gmail.com>
References: <20220227035920.19101-1-luizluca@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FROM_FMBLA_NEWDOM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Realtek rtl8365mb DSA driver can use and switch between these two tag
types.

Cc: devicetree@vger.kernel.org
Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
---
 Documentation/devicetree/bindings/net/dsa/dsa-port.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml b/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml
index 702df848a71d..2e3f29c61cf2 100644
--- a/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml
@@ -52,6 +52,8 @@ properties:
       - ocelot
       - ocelot-8021q
       - seville
+      - rtl8_4
+      - rtl8_4t
 
   phy-handle: true
 
-- 
2.35.1

