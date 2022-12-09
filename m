Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7A49648A7F
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 23:05:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229798AbiLIWFi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 17:05:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230001AbiLIWFc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 17:05:32 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00A4EA5DC3;
        Fri,  9 Dec 2022 14:05:28 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id w23so6277968ply.12;
        Fri, 09 Dec 2022 14:05:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B93RUhcGlOdcjG8078NRsmxgJ4o9UlwylsjSLK8WyL4=;
        b=Eft2HN1Aa+Fes3KClMnyUKLbxQaVjTIJIE8akn5tbOZdXlTJ466a/2Kt3SxNsgIEFj
         uCF2LVW8sXpZyv76rF9arHw3lUKswRXGgNfkVj6e97xM1r/+OMp9xdLGMfVtWozlUyvy
         7W7Q7KuJzOLUUDDIgzEPTFpOKcQf5nqX6jd1pW52faZ/onZdv3rAG9/vP4BVoxwa0sHR
         JhlZBugE65ZVy4GUH3RF6z8Q5b8AxBnDQUxsm/0j7Jvultwlbd84CnL+cNzXER6nkp5O
         B+H120WEXUuDTnZRIIvx3nV6zks5yyzmKmNFAnm9uEtEhRatk+MryIyP7bvDXQKCcA9C
         wElw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=B93RUhcGlOdcjG8078NRsmxgJ4o9UlwylsjSLK8WyL4=;
        b=tCRGWfyXUqJ/j2fovdcPY5ajzEhFoop6JoVm44gLoKsZS0e4XTk/RxoUPl2VVVLlq0
         HnU3lvQObh340n7jVv4IZatyLn0/JW/40aapCPQtAIRHvZdY1zI9N0WCwdJrAb/EMkmi
         rr4MqE6zPdQaYRw0i4bO5M5dAOUdALzkIrspUiYDXIX+lfKIjfRM6DHWJm6xamOhVf/O
         Oyw7OIfY+bBYvdT4qJ+PdSFhsyj2E8URPxblT5TxWeGkjNj8lTMDrU+bwa+fbOMcASI0
         AtaL/cBkUaYriVYLRviYQxcdHNNE5TFYo9MyAWZo9FiLIEW6scwWfUL3LQRA2gG1Uixu
         x/3g==
X-Gm-Message-State: ANoB5pnA+pdwDlUb9aCUDlUr3lA4IcfdG4KN7pA3AUPNgrkLck61fgLL
        rAdVr9/h70m2PiPUccGaCikPcz3E0+3GJA==
X-Google-Smtp-Source: AA0mqf7aQBwOLaZVNE46AhU+2bWzaO7Lv8121oGCC18K+bpm6E0W9amuwbHR7v3Kjn5Q1dmvMX8WmQ==
X-Received: by 2002:a17:90a:ec0e:b0:219:661f:9d8c with SMTP id l14-20020a17090aec0e00b00219661f9d8cmr7367014pjy.3.1670623528201;
        Fri, 09 Dec 2022 14:05:28 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id h7-20020a17090ac38700b0021870b2c7absm1528096pjt.42.2022.12.09.14.05.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Dec 2022 14:05:27 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>,
        NXP Linux Team <linux-imx@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        linux-kernel@vger.kernel.org (open list:IRQCHIP DRIVERS),
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED
        DEVICE TREE BINDINGS),
        linux-arm-kernel@lists.infradead.org (moderated list:ARM/FREESCALE IMX
        / MXC ARM ARCHITECTURE), Clark Wang <xiaoning.wang@nxp.com>,
        Wei Fang <wei.fang@nxp.com>,
        Shenwei Wang <shenwei.wang@nxp.com>
Subject: [PATCH net v2 1/2] MAINTAINERS: Update NXP FEC maintainer
Date:   Fri,  9 Dec 2022 14:05:18 -0800
Message-Id: <20221209220519.1542872-2-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221209220519.1542872-1-f.fainelli@gmail.com>
References: <20221209220519.1542872-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Emails to Joakim Zhang bounce, update the list of maintainers per
feedback from Clark Wang and designate Wei Fang as the primary
maintainer.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 MAINTAINERS | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 1daadaa4d48b..78d8928741ed 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8183,7 +8183,10 @@ S:	Maintained
 F:	drivers/i2c/busses/i2c-cpm.c
 
 FREESCALE IMX / MXC FEC DRIVER
-M:	Joakim Zhang <qiangqing.zhang@nxp.com>
+M:	Wei Fang <wei.fang@nxp.com>
+R:	Shenwei Wang <shenwei.wang@nxp.com>
+R:	Clark Wang <xiaoning.wang@nxp.com>
+R:	NXP Linux Team <linux-imx@nxp.com>
 L:	netdev@vger.kernel.org
 S:	Maintained
 F:	Documentation/devicetree/bindings/net/fsl,fec.yaml
-- 
2.34.1

