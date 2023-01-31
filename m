Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DFB9683841
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 22:03:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231843AbjAaVDd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 16:03:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231491AbjAaVDc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 16:03:32 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50D0B2739
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 13:03:31 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id m7so15447795wru.8
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 13:03:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:subject:cc:to:from:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gRUNXSGS7rlhGuB49SDRG+lrGhsOIKZeHh4eRriR12g=;
        b=p07YQSj0WLysf5divFMPFqvl4Ttdg6e34EgMI4n7egBIhe6zSSChlrJDxmlCGB4MMz
         wIhVTceeOD8IEJU+PBOHgC53f4zNBTVYkLZamJCHC3z1d3WYfJ1u/JxPp7SDccQosiU+
         gux6SXkN1Vc/9XSOdtcrhyZJ/uiW3nLLAplgCYggMTeO6LYUuqssVq2KKxY3JyHU90Ub
         rgjHUuyEM2+Gsx0AqSgwgdyN9GvfPV4RfpxjzD8Cvg48xwD2CGmCk8ZZR1JMT6aABhfW
         P2zU1n1qCQbUQVBmH6wHuZSBrmBkBg7TqTlHvIRPK5q4HRFvsIFDJjkn88xxAMV+PkwF
         f9PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:subject:cc:to:from:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=gRUNXSGS7rlhGuB49SDRG+lrGhsOIKZeHh4eRriR12g=;
        b=JnTpMyKBT3ob3nlrbO8PzlHpCAW2t0suj5fp+cgO6SsIPyfzAb0/rbc0sWFqdotg7f
         d/GLIkUFNycn/tMqXDsj2CJUScRnZ06z4nyemd42UWr5VA2QKdrEvReEyDPXloyjwWbR
         T2+iYb6zyztJvoSNQp3/GPkQj+lomHXMdCPzErIDubXIECY1Hhh4GlcRI2fNlkAyyCjH
         5+SoSS0Ddbi2HswmLNm5YCf0K3meEUIADTnJtcMHpIbxeXDX7SxEExFtknhmE8u9zCtD
         hx4xuoMR4h/FnYQSfkIZwxvwr23R/w4pTk+d8x9yNh1AKndUImRkZ+18e6ZaTW89OkRB
         R1Ow==
X-Gm-Message-State: AO0yUKXe0EoeNMxT6HxKXW7hmSe3TBZFcDr1b79vXSkCVjDdzneC6Zp9
        9SqgkvExUm1ypiKV1X9biP8=
X-Google-Smtp-Source: AK7set/F3m+pEBe1tR71tu2oLCZ4P4O2Nf/2y1a4r5IdlUn8aNbFNA8r3ht6SEIaBLCQ0M4jOZEIuA==
X-Received: by 2002:adf:e111:0:b0:2bf:d3c2:a36a with SMTP id t17-20020adfe111000000b002bfd3c2a36amr341635wrz.25.1675199009570;
        Tue, 31 Jan 2023 13:03:29 -0800 (PST)
Received: from ?IPV6:2a01:c23:b8ba:6a00:8d8f:fa1d:c162:c172? (dynamic-2a01-0c23-b8ba-6a00-8d8f-fa1d-c162-c172.c23.pool.telefonica.de. [2a01:c23:b8ba:6a00:8d8f:fa1d:c162:c172])
        by smtp.googlemail.com with ESMTPSA id m14-20020a5d6a0e000000b002bfd09f2ca6sm13691513wru.3.2023.01.31.13.03.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Jan 2023 13:03:28 -0800 (PST)
Message-ID: <23ecd290-56fb-699a-8722-f405b723b763@gmail.com>
Date:   Tue, 31 Jan 2023 22:03:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Content-Language: en-US
From:   Heiner Kallweit <hkallweit1@gmail.com>
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
Subject: [PATCH net] net: phy: meson-gxl: use MMD access dummy stubs for GXL,
 internal PHY
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

Note: The Fixes tag references the commit that added the MMD dummy
access stubs.

Fixes: 5df7af85ecd8 ("net: phy: Add general dummy stubs for MMD register access")
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

