Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C17865548CB
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 14:16:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357034AbiFVLyZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 07:54:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352829AbiFVLyX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 07:54:23 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8C553878A
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 04:54:20 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id e2so12604803edv.3
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 04:54:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NOoIKcOn+fn/RzKHn0fJ4NUU3G2nfTfnTHFn7LdhAks=;
        b=AdfKtmV9Lu5Dt/1foY+ADpByGOmR6vTr3UhT2CHJkEafEFmh+aBZY1LlNvZoL+6oaS
         rfZKXGozkdDUBO74Co9cPX1yn7kFje05B43dvIFiAsXGGqB6iwlQPvn2tiIWz1++4SOs
         QgiYW11SLh3HAii9geZPiPVY1g48pmTO9n/0z8YuUPicJ2OvlWaC8ReKLUFQLTYNtz7n
         Cfdcyp0MYxJGGk+naL5uJCzFbrnxvY+G66l+jUKujcq0qGa1DOiyzy0hpEMOIHQmE4WB
         QZI5t7OXNKMB4jhDsTHdTCSrfGSKz63+A5EXwBAZ6+681cIThUrD8W2vadq/bnTnmnNM
         tARg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NOoIKcOn+fn/RzKHn0fJ4NUU3G2nfTfnTHFn7LdhAks=;
        b=bqZubCYZN9xl1a6gN0sCAiVgUi417qquE71dQYK42JB4JpsO4Plnj/0rDdNfIATJqH
         qLSiyjKXbv8CPX8gdLEcMEnQGUvWuhmbPnOKyjRexMm9rXTfxYa81GKiXsnar8EUIw6I
         YBZmAJGkNhUoWMdnVeGUaPlAzaamytonELP+Xofv3Bjvh7NHdXdezXCeUjSOmZjjdFxg
         gsd4r2+qRcCXQ+PTznEnI0Sx+0qCP96W1aJt866hdLyxg/6iOknVZpUlmh4NgBM99grh
         7dY2GxyIDlspOs49nnDJU0j6vxu9+YimyI6IQQanw9WMRvLrG27RVuEASRuf07xKt/DV
         j6ng==
X-Gm-Message-State: AJIora8uApXQbeNkG094d3+Z0PsJOn4BvYMISGbvCajnpHblxcA20tgn
        VRXGBoHkBZJb5aCAek+1m1jwHA==
X-Google-Smtp-Source: AGRyM1t5fihARfpTKUOLQNCjVONdWR8oHH8X3XzLJMf74aL9Msfa7frCy3ERB9yehacvDsepOq0mPQ==
X-Received: by 2002:a05:6402:2398:b0:435:9685:1581 with SMTP id j24-20020a056402239800b0043596851581mr3658655eda.333.1655898859243;
        Wed, 22 Jun 2022 04:54:19 -0700 (PDT)
Received: from localhost.localdomain (xdsl-188-155-176-92.adslplus.ch. [188.155.176.92])
        by smtp.gmail.com with ESMTPSA id qa39-20020a17090786a700b007030c97ae62sm9063007ejc.191.2022.06.22.04.54.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jun 2022 04:54:18 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To:     Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [RESEND PATCH] net/ncsi: use proper "mellanox" DT vendor prefix
Date:   Wed, 22 Jun 2022 13:54:16 +0200
Message-Id: <20220622115416.7400-1-krzysztof.kozlowski@linaro.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"mlx" Devicetree vendor prefix is not documented and instead "mellanox"
should be used.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

---

Reason for resend: split from DTS patch. The patch is safe to take
independently.
---
 net/ncsi/ncsi-manage.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ncsi/ncsi-manage.c b/net/ncsi/ncsi-manage.c
index 78814417d753..80713febfac6 100644
--- a/net/ncsi/ncsi-manage.c
+++ b/net/ncsi/ncsi-manage.c
@@ -1803,7 +1803,8 @@ struct ncsi_dev *ncsi_register_dev(struct net_device *dev,
 	pdev = to_platform_device(dev->dev.parent);
 	if (pdev) {
 		np = pdev->dev.of_node;
-		if (np && of_get_property(np, "mlx,multi-host", NULL))
+		if (np && (of_get_property(np, "mellanox,multi-host", NULL) ||
+			   of_get_property(np, "mlx,multi-host", NULL)))
 			ndp->mlx_multi_host = true;
 	}
 
-- 
2.34.1

