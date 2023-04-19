Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38EC86E7047
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 02:12:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231894AbjDSALZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 20:11:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231718AbjDSAKz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 20:10:55 -0400
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97192D31E;
        Tue, 18 Apr 2023 17:10:48 -0700 (PDT)
Received: by mail-qt1-x832.google.com with SMTP id ff18so9163727qtb.13;
        Tue, 18 Apr 2023 17:10:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681863047; x=1684455047;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=/2vIzbLiLymfxf2AgDpir16B8+TkBntySAPe1DAnU4w=;
        b=B7j563x3k3sFbQ8tcPKuW1KI8WAmt2BvMWhtVVwnSgSFmZLSng25KrLtgS22jcSMef
         f9ETGGwIUFO1nXdLmgnrrHrspOuMVWgFIfyhI7uMZarwU+XSoxl/LmlD9qDWbw0gaYbl
         +Pz6WVhv2rdPPNokLIcZ0MwlJDh7/Kyl3I3Opk+wD31KjOxFxlPjmtVYne6PJ71KXGco
         FK4dxm3Iid9PYfyrWuZpHvXqUJ5eWydwW4k49AgT7Hb/9fim64sqTjHltl/CFI/dXBkM
         5TVoYG2mEDgwQu2YyJpcYwAyP4HczGii417hwg1vE2jHvRNTvURD8UrVjE0TStsmjKJs
         xWcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681863047; x=1684455047;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/2vIzbLiLymfxf2AgDpir16B8+TkBntySAPe1DAnU4w=;
        b=gnCenEUXIE2dgD5rMC5VZSaJeWQjd2KsebdGyhEMJcBk1OURpSwiPBMj9xl3DCrujj
         NuuHzDMmsjmxGIbolq5VBf8tkUhLYeMsIeT03Y+94SLtQtWgJ69keeeu0L7/6JbpB4IQ
         QKAHtE0aay26ELWPFbcIXiBEjmNajXVmNXH/ppy/XU+KpE76HYsD9tF4X5cxSVXgQn0L
         39avyjLIDE6rF0i/sKQXbyjW5G0FCLzqKd3bsgKZyJKfOaAQ9XORnBojY8B/1t714fqH
         vD7jnppE5/Nnw7ncYHV3tSsdPXNDLzB/UMaeTMvFsf4+XSWovSfgv2woYGLEBCL8wMNF
         Yh3w==
X-Gm-Message-State: AAQBX9eci8/YE9Fg3YjHXXmW72RVqeZ8o69xJA5omnLkYNO/HSYluP15
        z/HOXtlAZ3B98lsUJXLjIKOGq130/jQ1jA==
X-Google-Smtp-Source: AKy350YYX3xkMc3JUvVz099jJkT0BT8lDoC1lOhDKEvkClJkM1OMCPtW2W7AMXymPuhTaYfQABlMzg==
X-Received: by 2002:a05:622a:44c:b0:3e6:454f:9a89 with SMTP id o12-20020a05622a044c00b003e6454f9a89mr2958425qtx.14.1681863046793;
        Tue, 18 Apr 2023 17:10:46 -0700 (PDT)
Received: from stbirv-lnx-2.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d14-20020a37680e000000b0074d1b6a8187sm2639035qkc.130.2023.04.18.17.10.44
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Apr 2023 17:10:46 -0700 (PDT)
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
        christian.koenig@amd.com
Subject: [PATCH net-next 5/6] net: phy: bcm7xxx: Add EPHY entry for 74165
Date:   Tue, 18 Apr 2023 17:10:17 -0700
Message-Id: <1681863018-28006-6-git-send-email-justinpopo6@gmail.com>
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

From: Florian Fainelli <f.fainelli@gmail.com>

74165 is a 16nm process SoC with a 10/100 integrated Ethernet PHY,
utilize the recently defined 16nm EPHY macro to configure that PHY.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Justin Chen <justin.chen@broadcom.com>
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

