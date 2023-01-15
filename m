Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 528A766B201
	for <lists+netdev@lfdr.de>; Sun, 15 Jan 2023 16:19:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231214AbjAOPTq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Jan 2023 10:19:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230494AbjAOPTp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Jan 2023 10:19:45 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7332744A1
        for <netdev@vger.kernel.org>; Sun, 15 Jan 2023 07:19:44 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id q8so6539396wmo.5
        for <netdev@vger.kernel.org>; Sun, 15 Jan 2023 07:19:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eaCPm5Hinn1eniYbRr5OWrqTj6tTQJAVUJSjLSS/QD4=;
        b=jNvf7rJeU+1mgCIJLh/onx2OCkFCPpMuASxmlALSJKTiAg3E/Sj3Vt4fJesJu0Yiho
         +x2P0VGq5N7/MlIZfXL63t7Mh5SZMqHVh/HVcLXNP/Yw/s9IvXjVOBNdpUeCaREXiMAj
         8MRYgvvI84FzNeo0jvnJ2mlHS9Yd4t2SXL1mmEcFKHuG+4XIZQBT9CkOF20m/cEPE8qM
         bukE4u7M6nwCHAI4Qebff1lvSw2dYQlr5Wuq3FoTUHbxiwlJYD12PldT7DL9ap16kyCJ
         1wGdkrBkYRC8OM5Uuk4kXMih5HrwMwGMLB45dPNWtQVswZuSA1scCGAEjOA2I2JnNsAo
         kvvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=eaCPm5Hinn1eniYbRr5OWrqTj6tTQJAVUJSjLSS/QD4=;
        b=0j5IPx+xPBoTRYLyTx+ojoM+qcRYhf04E/+tfq2Rn8EmC508Qp5auEP4sYrJ0lIchI
         GDDWDJOLvcLznafyvZrLYdhxZb/a3O0ubbQWCr5vWKX3lLuj2tEW6oUdlLyZtxzQ7Cxe
         XuKLbQBX+pLbLONap6rozfQ5tjn+jLIK9X9kzkOqiGFtySpzbuh4keFNd+eoNnI3s2Bd
         xM3NSbvUqFdDRWO1C4/6df2MeglSf8k7hd+/i6W0h09FXqoFwFmb4zeYNB52rJeqfx4l
         FbUfP2LwZcnzqMCtdIS6/XHkKJMRde+hluSJNsKKaoNsx2HRYj+a5IXTcwaQQQmCTADF
         b4AA==
X-Gm-Message-State: AFqh2krfFb0FYFt+XhvLdp1axowe5fAauw6qMBNqINQZZ2G/4nj2yecU
        43QxF2HJAKa/D1XNqYNwMyo=
X-Google-Smtp-Source: AMrXdXudPxk8N5DX5zzZlJ0F+fu4HIYrlmr1R3gJHjK/XhsOZN2QxxoX/tyatBMtbr3YdYIQAa1JOg==
X-Received: by 2002:a05:600c:c10:b0:3da:f5e6:a320 with SMTP id fm16-20020a05600c0c1000b003daf5e6a320mr2753661wmb.22.1673795982958;
        Sun, 15 Jan 2023 07:19:42 -0800 (PST)
Received: from ?IPV6:2a01:c22:6e61:8c00:154f:326e:8d45:8ce7? (dynamic-2a01-0c22-6e61-8c00-154f-326e-8d45-8ce7.c22.pool.telefonica.de. [2a01:c22:6e61:8c00:154f:326e:8d45:8ce7])
        by smtp.googlemail.com with ESMTPSA id l24-20020a1ced18000000b003d99da8d30asm35272436wmh.46.2023.01.15.07.19.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 15 Jan 2023 07:19:42 -0800 (PST)
Message-ID: <d75ef7df-a645-7fdd-491a-f89f70dbea01@gmail.com>
Date:   Sun, 15 Jan 2023 16:19:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Kevin Hilman <khilman@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "open list:ARM/Amlogic Meson..." <linux-amlogic@lists.infradead.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] net: phy: meson-gxl: support more G12A-internal PHY
 versions
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On my SC2-based system the genphy driver was used because the PHY
identifies as 0x01803300. It works normal with the meson g12a
driver after this change.
Switch to PHY_ID_MATCH_MODEL to cover the different sub-versions.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/meson-gxl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/meson-gxl.c b/drivers/net/phy/meson-gxl.c
index c49062ad7..a36d471b8 100644
--- a/drivers/net/phy/meson-gxl.c
+++ b/drivers/net/phy/meson-gxl.c
@@ -262,7 +262,7 @@ static struct phy_driver meson_gxl_phy[] = {
 		.suspend        = genphy_suspend,
 		.resume         = genphy_resume,
 	}, {
-		PHY_ID_MATCH_EXACT(0x01803301),
+		PHY_ID_MATCH_MODEL(0x01803301),
 		.name		= "Meson G12A Internal PHY",
 		/* PHY_BASIC_FEATURES */
 		.flags		= PHY_IS_INTERNAL,
-- 
2.39.0

