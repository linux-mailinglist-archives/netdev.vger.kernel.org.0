Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 581D8688880
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 21:46:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233215AbjBBUqn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 15:46:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233105AbjBBUqa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 15:46:30 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 127CF79F1F
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 12:45:42 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id n13so2374459wmr.4
        for <netdev@vger.kernel.org>; Thu, 02 Feb 2023 12:45:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DJUiYTQ1taG/LOwyCcjL43MPAWD51ybFnY0ZUS3dCqY=;
        b=KXyqPG5tu737wJxVVX5VB2sp/LzI8W4VNgkRmihb/T66rfehZuq0dfR7ddT4ABwBWW
         b3Rz+D9MJ2+RRO7e2i5M/jgzfZObDXNIsavC20go4OglCqzZsVNKma8h6j4lRF/2sS1t
         f4akLv3rGBD/zl1qWPoFYzfIegCVC9Wm71ueB/4SwEz7TOxWHu1Odisz1uhvjmmL43FN
         5vXRQr/nTfNWLXuQkUd7pft3Hw1uq3wm38NFln7ETcdxVKTmqDon9i4dZ9a6KqraT5ti
         xibSAdetJ7gBGKyt1sxUyN1ludA5o4Tuablecow7tF5EmAxi0TKkETjo1uG5EpFtPYTc
         jZpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=DJUiYTQ1taG/LOwyCcjL43MPAWD51ybFnY0ZUS3dCqY=;
        b=hCnzMhqaxM5BoU52wBo5Dk7qCnTRaEXPmBjU83TU7j8KcFdG+c7Mv7APRQmbcLtI8N
         ZD5BOjYct/JOCQq9m7OwNOebZAe00MyXVO8+U/4p/ZHuGv345IYI+hvcwYbYyzQh4PD+
         rm7dcdAUudg+zOwuK/Llm8WSQsbvnFACJ0rpfGkprjcmjaX2/y1I6cgjUqonXFUzTLDC
         ZbJJfVPsLsIcQ6XcELvjqUC7v0ZCu45Z9izWU59k1EGaEGAMBAsJl06/MOmjo6srUNGI
         Hd9LvTjzlH2z7EF+yyblJbLTrT8lUIxWYMBgR1ZjYzrWAP/6/kAsCMIoRdDzzlHd/GLy
         KnmQ==
X-Gm-Message-State: AO0yUKXaTYsaMbtCHVrWeCmPSXfdL1bCjAvpuX2KmedfgxC/EfLvb5QH
        QYA/Ba5pqqUHNSfcuvinRMM=
X-Google-Smtp-Source: AK7set9ADFaNOhib79hvEJuo0y9MhgRtlRe07c7YZDBCDpcNWwrERWgr++a4PQ0y2CkFx0Wcm7FCdw==
X-Received: by 2002:a05:600c:3d98:b0:3df:50eb:7cd9 with SMTP id bi24-20020a05600c3d9800b003df50eb7cd9mr5645205wmb.14.1675370738204;
        Thu, 02 Feb 2023 12:45:38 -0800 (PST)
Received: from ?IPV6:2a01:c23:c579:1b00:d49:d5e1:60f0:ebae? (dynamic-2a01-0c23-c579-1b00-0d49-d5e1-60f0-ebae.c23.pool.telefonica.de. [2a01:c23:c579:1b00:d49:d5e1:60f0:ebae])
        by smtp.googlemail.com with ESMTPSA id j25-20020a05600c1c1900b003daf6e3bc2fsm8643763wms.1.2023.02.02.12.45.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Feb 2023 12:45:37 -0800 (PST)
Message-ID: <84432fe4-0be4-bc82-4e5c-557206b40f56@gmail.com>
Date:   Thu, 2 Feb 2023 21:45:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Kevin Hilman <khilman@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "open list:ARM/Amlogic Meson..." <linux-amlogic@lists.infradead.org>,
        Chris Healy <cphealy@gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH v2 net] net: phy: meson-gxl: use MMD access dummy stubs for
 GXL, internal PHY
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

Jerome provided the information that also the GXL internal PHY doesn't
support MMD register access and EEE. MMD reads return 0xffff, what
results in e.g. completely wrong ethtool --show-eee output.
Therefore use the MMD dummy stubs.

v2:
- Change Fixes tag to the actually offending commit. As 4.9 is EOL
  this fix will apply on all stable versions.

Fixes: d853d145ea3e ("net: phy: add an option to disable EEE advertisement")
Suggested-by: Jerome Brunet <jbrunet@baylibre.com>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/meson-gxl.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/phy/meson-gxl.c b/drivers/net/phy/meson-gxl.c
index c49062ad7..fbf5f2416 100644
--- a/drivers/net/phy/meson-gxl.c
+++ b/drivers/net/phy/meson-gxl.c
@@ -261,6 +261,8 @@ static struct phy_driver meson_gxl_phy[] = {
 		.handle_interrupt = meson_gxl_handle_interrupt,
 		.suspend        = genphy_suspend,
 		.resume         = genphy_resume,
+		.read_mmd	= genphy_read_mmd_unsupported,
+		.write_mmd	= genphy_write_mmd_unsupported,
 	}, {
 		PHY_ID_MATCH_EXACT(0x01803301),
 		.name		= "Meson G12A Internal PHY",
-- 
2.39.1

