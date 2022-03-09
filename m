Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 175A74D278E
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 05:07:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231387AbiCIC3R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 21:29:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231279AbiCIC3Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 21:29:16 -0500
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D21B625D
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 18:28:18 -0800 (PST)
Received: by mail-oi1-x22e.google.com with SMTP id h10so1302122oia.4
        for <netdev@vger.kernel.org>; Tue, 08 Mar 2022 18:28:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jpHO9fkUE6XbIIOkljYdl6NapX6XDanLVOJBL4+d9m4=;
        b=HrzzAA/uD6313o2jtMKi2U2ouHwUC2Rf0m5adxJUX9nR+qMguilP/2oHBqrZkDtTAH
         cQ/nWN2vOuikrdl9O38/2DSDIzRSwyGpUQY5HEP222r9vxYAasOCFRyxHWHP7IPKcZCR
         ROvLA9sypXbMcKGR0Gmz7KwXrbETQhl1nZJXWL/FQwphq0bh1RlMiK700uD9rd9Sp2cX
         A9XEFQ4X21l8mqN6v9hX2POgJYbANAhmbo499Q0WrN0f49l2+ifno7G6kvljV/KxrDtg
         GZ6kKshV6c+OXq7ziO5qDiJfMh8P45H4Fwj8IiNgl8VR8y5uqWhhXZQCsJuVJqRkjrAx
         YznQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jpHO9fkUE6XbIIOkljYdl6NapX6XDanLVOJBL4+d9m4=;
        b=z7jULWFmEStTPQbb4yiuyGVMwuitNJp9+3W5FVzJt44G8nHzGO1XGmLQVGP8rvBU1a
         3DfgtFT8vr3n3F7YDIgg1IbgaWC2PPBPU97SwrqG6pCPiG30uaCDkR5Mvpkyd/yQB3Lw
         MLGybQgquANPfbw9DB4B+8X2YoD10HBO7Od1D31nN+KuMiHH0ntrtYJ44KzS2FlpNjs/
         2PYB3OaRxe74N9aTpG8IDF6NdNQfklpq+Md8Awxp1hcKF+DiAC4YoASUH/zptLSZT0FX
         u2WPEbZFsxLYqV6Djltw1N/rgo8ExPIat7UnyZrCxc5wokjq0cflEgTcdCpuwxrpnpIU
         +nKQ==
X-Gm-Message-State: AOAM532wVLBW3HjOlZKE656bEQkpAr699fZ4ZNPLQ5EsI3/49JzDKCFn
        VWIt8E1JqI3XzJIUZwJeJzmW+ZWrAnZamA==
X-Google-Smtp-Source: ABdhPJxmQiXf7BToFK2xY2a2nU1/azJT3JNulyHQsjp2Sje4v6JecVmHkNfhXuh0vOb3i0ZN6gdHuw==
X-Received: by 2002:a05:6808:138b:b0:2d9:a01a:4bb7 with SMTP id c11-20020a056808138b00b002d9a01a4bb7mr4782071oiw.222.1646792897959;
        Tue, 08 Mar 2022 18:28:17 -0800 (PST)
Received: from tresc043793.tre-sc.gov.br (187-049-235-234.floripa.net.br. [187.49.235.234])
        by smtp.gmail.com with ESMTPSA id k15-20020a056808068f00b002d91362e56esm339045oig.1.2022.03.08.18.28.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 18:28:17 -0800 (PST)
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org, alsi@bang-olufsen.dk, arinc.unal@arinc9.com,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Subject: [PATCH net-next v2] net: dsa: tag_rtl8_4: fix typo in modalias name
Date:   Tue,  8 Mar 2022 23:27:58 -0300
Message-Id: <20220309022757.9539-1-luizluca@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

DSA_TAG_PROTO_RTL8_4L is not defined. It should be
DSA_TAG_PROTO_RTL8_4T.

Fixes: 7c33ef0ad83d ("net: dsa: tag_rtl8_4: add rtl8_4t trailing variant")
Reported-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
---
 net/dsa/tag_rtl8_4.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/dsa/tag_rtl8_4.c b/net/dsa/tag_rtl8_4.c
index 71fec45fd0ea..a593ead7ff26 100644
--- a/net/dsa/tag_rtl8_4.c
+++ b/net/dsa/tag_rtl8_4.c
@@ -247,7 +247,7 @@ static const struct dsa_device_ops rtl8_4t_netdev_ops = {
 
 DSA_TAG_DRIVER(rtl8_4t_netdev_ops);
 
-MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_RTL8_4L);
+MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_RTL8_4T);
 
 static struct dsa_tag_driver *dsa_tag_drivers[] = {
 	&DSA_TAG_DRIVER_NAME(rtl8_4_netdev_ops),
-- 
2.35.1

