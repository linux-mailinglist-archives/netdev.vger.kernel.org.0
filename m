Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72EC96C847D
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 19:07:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232230AbjCXSHc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 14:07:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232026AbjCXSHS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 14:07:18 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3990212AF
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 11:06:06 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id h17so2652761wrt.8
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 11:06:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679681165;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=b80cRpolEKKWCSZ2bzobqFlHKgz1wpNhHuUs2CSAl30=;
        b=lCru/jm1ZwAngrixs3Hy2WK+bIcK5WHE0c099BV4LBR3NjKVpeVLI1pox9iYM7v54r
         WyMAOCm1INkYDODxho1TU6QPnVOo3SKjVecJy6Y+tXY9KMCYsepMgMCOaPJJggoAVgUw
         MEOy1MkwOqVQF1NnDXXyXrtZC84D16yoJ3Kz14KZxRvKhZWB/wgWVhSU2wFPSH1mOnV9
         suuxPrqoxyyYor1IP2v4r+ZG84bGr/7cgtxf8KZ4Y0+5f9PDfrRkQtv/E/XG3nM2RwFl
         fkCvk2xFdhoeXH5yJdtrCkamtA+ol+40VYQ/jCFl4dLuWZI1YQu2L/F5Q455P+QcJwd5
         QmyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679681165;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=b80cRpolEKKWCSZ2bzobqFlHKgz1wpNhHuUs2CSAl30=;
        b=hhgkz11W3gV07PVH8tg2sAWjFGI8TLS/f73Y9R2QpTB0FELZEoilOtxqcI9oqqpKO6
         Sjb6ZOFqsOQqPdpuA+CpBPRZ3Avgw8NohqaQyTzhO5CqJf29xrw8xxYkPSJ2YNPd6tW1
         tT1FQ2E5xnkcDTnLHUb7WHdq6Y7GGpD2Mkon6IXWWxaGgnoTufSPxbYSDgCOdEx8nf1Q
         C2Ft2yDTWcydpgQ4pQI5zQuAmHqQHHQtf6BB24G2r/wA1x/u6EEHe6OYya6Mteq6/kaa
         jwT0d8S0EzHvADBjTqF6bGxJ/IIDSoTA0567SkWoIWdMJ96ADcv0lYMYW87LZ7SAxuzo
         mOwA==
X-Gm-Message-State: AAQBX9dvATu2or6TMgXxKy+RL7PL35HDyEyWDXH/5uasRrVal8IHx5Af
        hLpvmqRQjnef81Advd3lPcA=
X-Google-Smtp-Source: AKy350aCl49v2ztgP9utXoOttSLe84T+ngX++1cPJvdl8UBcPN+Q0Icn/DoQJMVCjg6kSgUESe97og==
X-Received: by 2002:adf:f78e:0:b0:2cf:e5d7:e8d5 with SMTP id q14-20020adff78e000000b002cfe5d7e8d5mr2849328wrp.40.1679681164770;
        Fri, 24 Mar 2023 11:06:04 -0700 (PDT)
Received: from ?IPV6:2a01:c23:b926:df00:a161:16e2:f237:a7d4? (dynamic-2a01-0c23-b926-df00-a161-16e2-f237-a7d4.c23.pool.telefonica.de. [2a01:c23:b926:df00:a161:16e2:f237:a7d4])
        by smtp.googlemail.com with ESMTPSA id a18-20020a5d4d52000000b002d1e49cff35sm18830410wru.40.2023.03.24.11.06.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Mar 2023 11:06:04 -0700 (PDT)
Message-ID: <97e1f180-ae4e-7314-a736-748bb6746d82@gmail.com>
Date:   Fri, 24 Mar 2023 19:03:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: [PATCH net-next 1/4] net: phylib: add getting reference clock
Content-Language: en-US
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <0c529488-0fd8-19e1-c5a9-9cf1fab78ed3@gmail.com>
In-Reply-To: <0c529488-0fd8-19e1-c5a9-9cf1fab78ed3@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Few PHY drivers (smsc, bcm7xxx, micrel) get and enable the (R)MII
reference clock in their probe() callback. Move this common
functionality to phylib, this allows to remove it from the drivers
in a follow-up.

Note that we now enable the reference clock before deasserting the
PHY reset signal. Maybe this even allows us to get rid of
phy_reset_after_clk_enable().

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/phy_device.c | 6 ++++++
 include/linux/phy.h          | 5 +++++
 2 files changed, 11 insertions(+)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index c0760cbf5..6668487e2 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -3096,6 +3096,12 @@ static int phy_probe(struct device *dev)
 	if (phydrv->flags & PHY_IS_INTERNAL)
 		phydev->is_internal = true;
 
+	phydev->refclk = devm_clk_get_optional_enabled(dev, NULL);
+	if (IS_ERR(phydev->refclk)) {
+		err = PTR_ERR(phydev->refclk);
+		goto out;
+	}
+
 	/* Deassert the reset signal */
 	phy_device_reset(phydev, 0);
 
diff --git a/include/linux/phy.h b/include/linux/phy.h
index fefd5091b..6d6129674 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -11,6 +11,7 @@
 #ifndef __PHY_H
 #define __PHY_H
 
+#include <linux/clk.h>
 #include <linux/compiler.h>
 #include <linux/spinlock.h>
 #include <linux/ethtool.h>
@@ -595,6 +596,7 @@ struct macsec_ops;
  * @interface: enum phy_interface_t value
  * @skb: Netlink message for cable diagnostics
  * @nest: Netlink nest used for cable diagnostics
+ * @refclk: External (R)MII reference clock
  * @ehdr: nNtlink header for cable diagnostics
  * @phy_led_triggers: Array of LED triggers
  * @phy_num_led_triggers: Number of triggers in @phy_led_triggers
@@ -719,6 +721,9 @@ struct phy_device {
 	void *ehdr;
 	struct nlattr *nest;
 
+	/* external (R)MII reference clock */
+	struct clk *refclk;
+
 	/* Interrupt and Polling infrastructure */
 	struct delayed_work state_queue;
 
-- 
2.40.0


