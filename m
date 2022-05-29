Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B08015370AA
	for <lists+netdev@lfdr.de>; Sun, 29 May 2022 13:10:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229954AbiE2LK2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 May 2022 07:10:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229937AbiE2LK1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 May 2022 07:10:27 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE09F7A463
        for <netdev@vger.kernel.org>; Sun, 29 May 2022 04:10:25 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id m20so16006143ejj.10
        for <netdev@vger.kernel.org>; Sun, 29 May 2022 04:10:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Iy/F7uqP/QJ+JhJfiMPaLwgsjVlSR1sJFsXemWM3y5M=;
        b=UD/IIWn1gRH+c3m2RcFFnI/6dzrWKsaPfaKlE/5FHsXq+P6MmJf9bjE6eR0BGNdQGV
         isYY9q4ss901WSypLH0hEZQLxNVVK//qZ2VPw/JkwgPm2DnCTjlniBj8FrS37QJJ8xVz
         lkCY9mz9loP0fSJxFYoHVBIXTobXxk7el8bfQ0gWnFstc+g+FBXcOn9qT259CYURBMLQ
         9eSkks2nCNBbAll+7pyuWPgy5tgZh9745/mrKz4swOGQ0JBdRUY0VdF/iQnnBvr/b+J3
         UzP5zVo8783Ktqsx0MGXb79w1ulcJekQuSxG5afNW7fP6AU0wThoBIOnf8nabOJUebR5
         tS3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Iy/F7uqP/QJ+JhJfiMPaLwgsjVlSR1sJFsXemWM3y5M=;
        b=W1F4AuhQowOtZHQZCU6aHmphNkhLyOdF26E216ehNUV+qRHoA1aOeX+/bUMx4TYGNL
         uD3zv0M1NFfr2qyjYedfQO3GnzjcRpN5uaPLeew2aY331j4OrDO7W9qAFtGEo83bvNih
         aH04iJagiNDQA0oM65FMzmZJOu7fXecfqzV+L77srIF3gjVz8AtQGSyNxPI+06V2YY1w
         ziGaoIftG+Fm5mQW0oWL8StZqRhArKi5id+uozyXTmyd18gdWzC9jqBgz2hV3N28im//
         E5BoSnAztFjSlOw28XJaUW/e5zAHiT9aJLZ5H9tT0IaT1QnikJMlfUhQ7qPr2rTBsZwi
         EnBg==
X-Gm-Message-State: AOAM532hoOcpxf9zrHfMgyD/8SR4b9etAzSYI9ByWiDodE0UNlbLP338
        EGKm8l9KDaLim/96kJL9fteYuQ==
X-Google-Smtp-Source: ABdhPJyJ1wAI1x+8OgmzP9eOjOPL/AP7OqXQtjePyQU8l4VkCQrTwGs/pAVpjCfcxOmFsJgEdcL+Lw==
X-Received: by 2002:a17:907:6294:b0:6e1:ea4:74a3 with SMTP id nd20-20020a170907629400b006e10ea474a3mr44381372ejc.168.1653822624272;
        Sun, 29 May 2022 04:10:24 -0700 (PDT)
Received: from localhost.localdomain (xdsl-188-155-176-92.adslplus.ch. [188.155.176.92])
        by smtp.gmail.com with ESMTPSA id d3-20020a1709063ec300b006fee2bdf6c6sm3073996ejj.169.2022.05.29.04.10.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 May 2022 04:10:23 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To:     Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Joel Stanley <joel@jms.id.au>,
        Andrew Jeffery <andrew@aj.id.au>,
        Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-aspeed@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 1/2] net/ncsi: use proper "mellanox" DT vendor prefix
Date:   Sun, 29 May 2022 13:10:16 +0200
Message-Id: <20220529111017.181766-1-krzysztof.kozlowski@linaro.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
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

