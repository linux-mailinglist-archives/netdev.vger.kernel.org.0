Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BBAA6C1AC8
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 17:01:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233364AbjCTQA5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 12:00:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233532AbjCTQAP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 12:00:15 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A422B3E0B3;
        Mon, 20 Mar 2023 08:50:37 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id t17-20020a05600c451100b003edc906aeeaso1726035wmo.1;
        Mon, 20 Mar 2023 08:50:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679327430;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NmGOzoXiGILw8p8HpY3VfgsDYOA5bH4v8OqaYevH4J4=;
        b=KptaZem0Zxnxtwy+VdrvXw5NY/HSYmbxmV8+mSnoXZgQGHLjW/gCyDXpzRqcSBXIGV
         fvtFTanvZcTCA4f/cyoAkEsqIkmQyDHwEshHutyJEaWN9q3yB5eTAnUcq4z3e7P4nTu2
         +ZOho9zDyRb4r24J6UbiN9ZUzcsuYVQwm1Qz0zJ+63dx+gD20hgCL+7775pvqoFYwgpP
         1ABgO6OngXBB42/L8+ZBwsg3mXy06HuqMLEQK/FmtcXjTml0OaO3S5cJvUdNGsdNrvx+
         kaTtRBBzqin3DRExaIekr/jPzOB3X1oV2TzhInT4SPhtULIah750U4ljBqf92PwnjvHc
         6JDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679327430;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NmGOzoXiGILw8p8HpY3VfgsDYOA5bH4v8OqaYevH4J4=;
        b=GsByHVP16hADSORlzScxFXsjTNWGBbyYNiWQHZzojsE/ffOZrXokZWDNH4GTlB7uv4
         4Gs1NNLT8Bk95OjDvHAm5bJxZGwyfeHZeTqxBpBlGapyqb2D9XGxpYXbF9VaQgd7oKjN
         v7Si3AKtD8g7o//OkdsslkT8JxzhdjmHK0pJN9ssxhHMePGutYkZH+n7JlIrQVaDs7iU
         nvg1lcFLNvn+MrLpNE5r8KMIPdTwGMIOQAuZ1tqttHrGRkfi92KF1p93p/Qn8uDIGO/B
         ocZHPyMlXDh/Q7Qjsy/BihOrW3+cSZm7OomPh8vWhppGKwkxLYCZAsKeDGOjLvfdV2Rf
         lZwQ==
X-Gm-Message-State: AO0yUKW2wNtd5kSfm2dxbqnhxVZrNkzLVVdLsO0eADsnjtWufqMWFS0a
        ZubXW4z6gV3Oqv2lPuWyQDU=
X-Google-Smtp-Source: AK7set8bMf4RMiUM14onDSGmYFsmJuDQ+P9yadvVBWt05IjyUwc/8tNalTsC2hQ62KhoCUpBfCEb7g==
X-Received: by 2002:a05:600c:468c:b0:3eb:38b0:e748 with SMTP id p12-20020a05600c468c00b003eb38b0e748mr10091873wmo.13.1679327430592;
        Mon, 20 Mar 2023 08:50:30 -0700 (PDT)
Received: from atlantis.lan (255.red-79-146-124.dynamicip.rima-tde.net. [79.146.124.255])
        by smtp.gmail.com with ESMTPSA id 3-20020a05600c020300b003eddefd8792sm4812333wmi.14.2023.03.20.08.50.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Mar 2023 08:50:30 -0700 (PDT)
From:   =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>
To:     f.fainelli@gmail.com, andrew@lunn.ch, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>
Subject: [PATCH 2/4] net: dsa: b53: mmap: add more BCM63xx SoCs
Date:   Mon, 20 Mar 2023 16:50:22 +0100
Message-Id: <20230320155024.164523-3-noltari@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230320155024.164523-1-noltari@gmail.com>
References: <20230320155024.164523-1-noltari@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

BCM6318, BCM6362 and BCM63268 are SoCs with a B53 MMAP switch.

Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>
---
 drivers/net/dsa/b53/b53_mmap.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/dsa/b53/b53_mmap.c b/drivers/net/dsa/b53/b53_mmap.c
index 70887e0aece3..464c77e10f60 100644
--- a/drivers/net/dsa/b53/b53_mmap.c
+++ b/drivers/net/dsa/b53/b53_mmap.c
@@ -331,8 +331,11 @@ static void b53_mmap_shutdown(struct platform_device *pdev)
 
 static const struct of_device_id b53_mmap_of_table[] = {
 	{ .compatible = "brcm,bcm3384-switch" },
+	{ .compatible = "brcm,bcm6318-switch" },
 	{ .compatible = "brcm,bcm6328-switch" },
+	{ .compatible = "brcm,bcm6362-switch" },
 	{ .compatible = "brcm,bcm6368-switch" },
+	{ .compatible = "brcm,bcm63268-switch" },
 	{ .compatible = "brcm,bcm63xx-switch" },
 	{ /* sentinel */ },
 };
-- 
2.30.2

