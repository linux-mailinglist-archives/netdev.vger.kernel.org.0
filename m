Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FEF86D516F
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 21:35:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231991AbjDCTf4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 15:35:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231538AbjDCTfy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 15:35:54 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80DA810DE
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 12:35:53 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id bg16-20020a05600c3c9000b003eb34e21bdfso20542813wmb.0
        for <netdev@vger.kernel.org>; Mon, 03 Apr 2023 12:35:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680550552;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NZa4opcsQoodNo90FIgyVx9zfFS6hTIMu8uKrI/HoBE=;
        b=k0MUwoon6K0lNUnxM5Krlg5gXyH3AhpXn+KQuT/7o9NEjfFF83EqYwFWGNq5rbC4Ry
         k4az95ATeNfp/F8JEKiyDE0JXvqkddGNevtGi5TfKsNmrv96WoQSZUiki57LWHVD0K49
         DxQnCBTFTeOaSef1LNcNTp2gUDeYaHOEj+VZ5Lc7aAAYJiQtSDC9RdADB++8wM4MUp43
         zNd7S/1SOgqCHVjRqZpFhFookWCiqZjC+rO3+lceEGKSo2zyfeI9/Jca4NUmONavz96+
         4J50BMLQO+EqAcKHOV5SPAs+6jbxp36eOxp+slhGow3kyPhnyIIhg9VMgdILd1i9H/lS
         Zikg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680550552;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=NZa4opcsQoodNo90FIgyVx9zfFS6hTIMu8uKrI/HoBE=;
        b=Q3YXoC1RdccEA1Sni0wYetnxB1jDw3bFbwLN3mnHyVKZ9BZQd2t5GsiF1PbwQAkW+6
         lImQhNWVw2Xhi55NDBKBWl//HDbBZlgfaa5oP9KV55/VXlohO064UVOxrTJw7XTOECUW
         bsZKqTqmlzURydGhuG/Pb0A18gWaHm5lbAHVDa4+ykINEFIK4SFLm/OzuohMUxyHyMQp
         H9YGPUhe+lIG5fvQSqw+7N02jbsKxS7xtQHSSK/cmmlLV8CSkErRRcIIWDImu6QDXJXh
         1CHj2XBO1W5OegrIPOYmhJmZKtTaNpf8NYrqSy4NtVZlLdWnt8pRJyA7Y8WcXVZWZOTS
         IMvg==
X-Gm-Message-State: AAQBX9ctI9Mtm8WN9Jx0EJ4D+t5sZh78wguJ/U4rXZ7bXJEYWjuYY0+d
        s4xNGANUQZ4+mk/YfamQUJFAf+PrGUY=
X-Google-Smtp-Source: AKy350aoK99yeB0PWJO20XA2MQsMGkOoctlQcatFgis+Mzn6VXzxU7reL+CTXy9enPnSyw8EpYZsrQ==
X-Received: by 2002:a1c:7c12:0:b0:3ed:29e1:ed21 with SMTP id x18-20020a1c7c12000000b003ed29e1ed21mr381957wmc.37.1680550551618;
        Mon, 03 Apr 2023 12:35:51 -0700 (PDT)
Received: from ?IPV6:2a01:c23:b9a3:9100:5849:b3bc:e358:e393? (dynamic-2a01-0c23-b9a3-9100-5849-b3bc-e358-e393.c23.pool.telefonica.de. [2a01:c23:b9a3:9100:5849:b3bc:e358:e393])
        by smtp.googlemail.com with ESMTPSA id u17-20020a05600c19d100b003dd1bd0b915sm20412682wmq.22.2023.04.03.12.35.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Apr 2023 12:35:51 -0700 (PDT)
Message-ID: <8d309575-067c-7321-33cf-6ffac11f7c8d@gmail.com>
Date:   Mon, 3 Apr 2023 21:35:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Neil Armstrong <neil.armstrong@linaro.org>
Cc:     Chris Healy <cphealy@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "open list:ARM/Amlogic Meson..." <linux-amlogic@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] net: phy: meson-gxl: enable edpd tunable support for
 G12A internal PHY
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

Enable EDPD PHY tunable support for the G12A internal PHY, reusing the
recently added tunable support in the smsc driver.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/meson-gxl.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/phy/meson-gxl.c b/drivers/net/phy/meson-gxl.c
index 3dea7c752..bb9b33b6b 100644
--- a/drivers/net/phy/meson-gxl.c
+++ b/drivers/net/phy/meson-gxl.c
@@ -210,6 +210,10 @@ static struct phy_driver meson_gxl_phy[] = {
 		.read_status	= lan87xx_read_status,
 		.config_intr	= smsc_phy_config_intr,
 		.handle_interrupt = smsc_phy_handle_interrupt,
+
+		.get_tunable	= smsc_phy_get_tunable,
+		.set_tunable	= smsc_phy_set_tunable,
+
 		.suspend        = genphy_suspend,
 		.resume         = genphy_resume,
 		.read_mmd	= genphy_read_mmd_unsupported,
-- 
2.40.0

