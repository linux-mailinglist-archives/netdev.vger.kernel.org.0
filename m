Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CD3A6E7048
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 02:12:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231753AbjDSALB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 20:11:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231623AbjDSAKw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 20:10:52 -0400
Received: from mail-qv1-xf29.google.com (mail-qv1-xf29.google.com [IPv6:2607:f8b0:4864:20::f29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B447F93E4;
        Tue, 18 Apr 2023 17:10:44 -0700 (PDT)
Received: by mail-qv1-xf29.google.com with SMTP id o7so27475370qvs.0;
        Tue, 18 Apr 2023 17:10:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681863043; x=1684455043;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=VoyOtevA7zWVcY2FMaSNxcWdqWdjwOkjpS+Kg2w2jSA=;
        b=sFykKzA97PqsK5KYynP+h9AsjamexIk+Nn10QGXknsUrLemzpQYJQ87TqQT9VO71m3
         EySGCOwets/U/hy0lFm7hVA42oJtCjU5VWVYoiJDulRErN+FD4m292/qDV9e5BfNbCRM
         5VpHOIPBJ64a37DqgoJSCHE+6jPLZrxrP9967Hq/BqG8LhhaTXe8kIkTSZ1HNCJeydrg
         ElgHVXbowPSnKEEiEPE/r4sVSZ3Wgs9VglaaIz6Y39OivnoLVFe51J/cKNR6EUKikwnl
         0XqC5pDhuRrfxNAbCUQycn4gL/8rG6CJ+I7z7ulNgTVqyqh+k1aQN0I0GvOR3elKPxPV
         APRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681863043; x=1684455043;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VoyOtevA7zWVcY2FMaSNxcWdqWdjwOkjpS+Kg2w2jSA=;
        b=cbdyIcEbv9bWzqswPJXt6NnnlZ817/GpVr47jqYdd6XWXkGWkuvwydofhBsVnUlOep
         RdWXn7i8+0lU27ajJV8w7haLxZKVFjnbAbtrOTbvezes6T4aR2DVLNeJI1JNiPhASMpU
         ITDlaKuMmnuXDUcC883oJiHdOLfmPHIu0sa0uiu+9U89uLz9YedQNVkb5/C20VP8Ql8s
         0kk0X6l9mbM5GCgE4dD1TkVstkaJ0SfXWwZewCfevngJx+6hKL6nG1f4PQpbTb2enWbg
         sLejYyyPiOMfjT5cJsc6aQG/v4Ioy1OH7cC/akH/R4M1bBpI+OdE/W8Yog7fjkLeBMnS
         mIDQ==
X-Gm-Message-State: AAQBX9dQvZSOOybzh5IwPYTb50hfG5grVUodnpElCBPtWEOo9Cmeb0JI
        yL7Ms8mEeJIduHj4t5sQjVo67F/g2u9IVA==
X-Google-Smtp-Source: AKy350ZfbVnjm7WTZXlNXTdPmRjM6xggqlbBTZwnwChNwmErHuEZDhi4LipIpV3OEHwNKezANor72w==
X-Received: by 2002:a05:6214:20e2:b0:5ef:4655:192e with SMTP id 2-20020a05621420e200b005ef4655192emr22363479qvk.36.1681863043415;
        Tue, 18 Apr 2023 17:10:43 -0700 (PDT)
Received: from stbirv-lnx-2.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d14-20020a37680e000000b0074d1b6a8187sm2639035qkc.130.2023.04.18.17.10.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Apr 2023 17:10:43 -0700 (PDT)
From:   Justin Chen <justinpopo6@gmail.com>
To:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        bcm-kernel-feedback-list@broadcom.com
Cc:     justin.chen@broadcom.com, f.fainelli@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, opendmb@gmail.com,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        richardcochran@gmail.com, sumit.semwal@linaro.org,
        christian.koenig@amd.com, Justin Chen <justinpopo6@gmail.com>
Subject: [PATCH net-next 4/6] net: phy: mdio-bcm-unimac: Add asp v2.0 support
Date:   Tue, 18 Apr 2023 17:10:16 -0700
Message-Id: <1681863018-28006-5-git-send-email-justinpopo6@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1681863018-28006-1-git-send-email-justinpopo6@gmail.com>
References: <1681863018-28006-1-git-send-email-justinpopo6@gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add mdio compat string for ASP 2.0 ethernet driver.

Signed-off-by: Justin Chen <justinpopo6@gmail.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/mdio/mdio-bcm-unimac.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/mdio/mdio-bcm-unimac.c b/drivers/net/mdio/mdio-bcm-unimac.c
index bfc9be23c973..6b26a0803696 100644
--- a/drivers/net/mdio/mdio-bcm-unimac.c
+++ b/drivers/net/mdio/mdio-bcm-unimac.c
@@ -334,6 +334,8 @@ static SIMPLE_DEV_PM_OPS(unimac_mdio_pm_ops,
 			 unimac_mdio_suspend, unimac_mdio_resume);
 
 static const struct of_device_id unimac_mdio_ids[] = {
+	{ .compatible = "brcm,asp-v2.1-mdio", },
+	{ .compatible = "brcm,asp-v2.0-mdio", },
 	{ .compatible = "brcm,genet-mdio-v5", },
 	{ .compatible = "brcm,genet-mdio-v4", },
 	{ .compatible = "brcm,genet-mdio-v3", },
-- 
2.7.4

