Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C08DD6EFA79
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 20:55:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239430AbjDZSzW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 14:55:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236122AbjDZSzP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 14:55:15 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4FA683F7;
        Wed, 26 Apr 2023 11:54:58 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id d2e1a72fcca58-63f273b219eso3759413b3a.1;
        Wed, 26 Apr 2023 11:54:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682535298; x=1685127298;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=7om461OI/LjhPCQ00bZ+IVTvWddH+7Li64Kb9mQvwjY=;
        b=dA2viRZxkPIUj46GrtvdWPfEcRLj5gNItAOQt2nFpcWWZb593LOxICm+e2NZcnINp8
         tLHnRlqcrhQ6Yi8KlbiAUHXGemOz1qWCTyb+E1WgedrCtksEJrgJtdElwM66z2Tx71Jp
         oXl8fRRB2YbnxyJJKPHSJADm9jxr7IeWY/vxYYjYFcOg+GgCaBBhDiTyn6Frhb6XbGEh
         TeMeTDuS3HpHZJikOBWp5f9JwJJQLx2Yx2OLd8209GUzfd8Zwe4ANHJv0bM98Du+lKmE
         iVCpDmjC8Lxh5IvWVsJt7BmDdw2Os/z2qnBXDoiaxnojJUB5z7z/1xQqYEN0z+WU9gD9
         xR7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682535298; x=1685127298;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7om461OI/LjhPCQ00bZ+IVTvWddH+7Li64Kb9mQvwjY=;
        b=KdWHNoWXzsJhKpQuRhnCZQvm4VijbGcKEe4Gh7L1Fo5OVyrSwqKOaZBXJvmOS4IvFW
         FbzpLbp74FCG6LRbvfR9k4OSGvuYxSJh2lQr4ubVeXCtAaTSp63NVEkYOseS2uJUfNvR
         YvH0TcOeAnK2ZLVfLc2X7+cKrlWzigUdAARi8DtPZgu0AWeOoD9We+W2vbKpgB94eyRY
         DOpr9IUoHgUC56EcYcJ1onH4aDHdDmXuedBNF/3jv11i3IX5tF6HdiwI3/GnH0dUmFqB
         vxwymmQVTjE5O2Ddop90QomE9cfrKZx2EWKuBL9MVvulEfxIOpPcbpt9YYoWmvn+8EiY
         EqCg==
X-Gm-Message-State: AAQBX9cta4v0LTTQwnT6Neq3S0EGCCw0rpNOt+WairIGrKa2EiYYTVlq
        7OJ85IiQh63JC2mX1CmCP/hMNGKnJBPO/A==
X-Google-Smtp-Source: AKy350bRV2U7foEPKMVz9+6QLCQge6e6/2YXskUnlLN8kzLZHv83HvAMhBi4nTETHHBaeN5Nufb5nQ==
X-Received: by 2002:a05:6a00:23c5:b0:63a:8f4c:8be1 with SMTP id g5-20020a056a0023c500b0063a8f4c8be1mr30303575pfc.10.1682535297914;
        Wed, 26 Apr 2023 11:54:57 -0700 (PDT)
Received: from stbirv-lnx-2.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id y72-20020a62644b000000b006372791d708sm11639254pfb.104.2023.04.26.11.54.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 26 Apr 2023 11:54:57 -0700 (PDT)
From:   Justin Chen <justinpopo6@gmail.com>
To:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        bcm-kernel-feedback-list@broadcom.com
Cc:     justinpopo6@gmail.com, justin.chen@broadcom.com,
        f.fainelli@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, opendmb@gmail.com,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        richardcochran@gmail.com, sumit.semwal@linaro.org,
        christian.koenig@amd.com
Subject: [PATCH v2 net-next 5/6] net: phy: bcm7xxx: Add EPHY entry for 74165
Date:   Wed, 26 Apr 2023 11:54:31 -0700
Message-Id: <1682535272-32249-6-git-send-email-justinpopo6@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1682535272-32249-1-git-send-email-justinpopo6@gmail.com>
References: <1682535272-32249-1-git-send-email-justinpopo6@gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

74165 is a 16nm process SoC with a 10/100 integrated Ethernet PHY,
utilize the recently defined 16nm EPHY macro to configure that PHY.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Justin Chen <justinpopo6@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/phy/bcm7xxx.c | 1 +
 include/linux/brcmphy.h   | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/net/phy/bcm7xxx.c b/drivers/net/phy/bcm7xxx.c
index 06be71ecd2f8..5c03c379cb5e 100644
--- a/drivers/net/phy/bcm7xxx.c
+++ b/drivers/net/phy/bcm7xxx.c
@@ -913,6 +913,7 @@ static struct phy_driver bcm7xxx_driver[] = {
 	BCM7XXX_28NM_GPHY(PHY_ID_BCM7278, "Broadcom BCM7278"),
 	BCM7XXX_28NM_GPHY(PHY_ID_BCM7364, "Broadcom BCM7364"),
 	BCM7XXX_28NM_GPHY(PHY_ID_BCM7366, "Broadcom BCM7366"),
+	BCM7XXX_16NM_EPHY(PHY_ID_BCM74165, "Broadcom BCM74165"),
 	BCM7XXX_28NM_GPHY(PHY_ID_BCM74371, "Broadcom BCM74371"),
 	BCM7XXX_28NM_GPHY(PHY_ID_BCM7439, "Broadcom BCM7439"),
 	BCM7XXX_28NM_GPHY(PHY_ID_BCM7439_2, "Broadcom BCM7439 (2)"),
diff --git a/include/linux/brcmphy.h b/include/linux/brcmphy.h
index 9e77165f3ef6..e11c2e9a5398 100644
--- a/include/linux/brcmphy.h
+++ b/include/linux/brcmphy.h
@@ -44,6 +44,7 @@
 #define PHY_ID_BCM7366			0x600d8490
 #define PHY_ID_BCM7346			0x600d8650
 #define PHY_ID_BCM7362			0x600d84b0
+#define PHY_ID_BCM74165			0x359052c0
 #define PHY_ID_BCM7425			0x600d86b0
 #define PHY_ID_BCM7429			0x600d8730
 #define PHY_ID_BCM7435			0x600d8750
-- 
2.7.4

