Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DE99513D59
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 23:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352188AbiD1VX3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 17:23:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243183AbiD1VX1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 17:23:27 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E1F1DFF5
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 14:20:09 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id i27so11968510ejd.9
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 14:20:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gfehonkgq9oAGuI0F15TUFO6VuH1ItAfHE4pQttPc4Q=;
        b=Clq89t5y7wc5TAW+OiGixxtpXDifBFzUDIzoKOXgggSIeEhH24k99TYOc2CpY/fq3M
         8Wwue28tzgx+GwV6qQbTXtdsyDE74w/DFWSM33tVRyx/4wncIwtbUXje2G+JM66IihXN
         +TODXbV8GC0p3mIOhl11w1q2MfMk1TwQVALX0xkMp4MdUklbyfsXeqSLZ04y7BMiTIOK
         fruWhT5DxcN+d3hCs3SPoRnDZ3acB9SvjP7yPsVwhVrbKb9Ic8Sv7WPrn3eSavxQbfee
         c3KKbzp/Gntrb35IlKjb1c52d62CxmLitAv4xhZCwGB5lylhgVVQUA8uTRPEyydQ6muj
         xloQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gfehonkgq9oAGuI0F15TUFO6VuH1ItAfHE4pQttPc4Q=;
        b=kUSqhN8DdDgbVCA1ara7vrBwQTFyPFFBV+w6Do7WzRmDKdpFZBkIQOiJW47N8kMTlK
         nNbKla74eZzVoBnwZmXVVUkf7GJNc50kErMJekBFD9EgoGHoRgC8LiYSRhDvCH7uf3s0
         5CaTxxJaowRnSCShRhEdDBpZxB1piGMpw0mx1i++H5cPBOSXJO2xZnObmD+THrEl0sA+
         e553R0O9ISEbkFAHe3DvCBeuRAnHG0RFEaX94z2UOfLpk0FLkBLlp/vGf7Xb4i3zHU1P
         62vmruhxv2HfSiJpn1oZVLuxsItcp/QxFMgE3kamjNPwGj9IK4OCHEm4/buYXG/6txe1
         sqbw==
X-Gm-Message-State: AOAM532TsFyr0lTFA/9wQwo/m2ysiRrT2gGjc+iD5Wl+6IEBDDNLZKXl
        ZSkkKbE/Mafrzx5PLdUCgdDZDoYUqkA=
X-Google-Smtp-Source: ABdhPJx41hiHZlHd+PlNIOynvtfPF/IBFpiPLuEWhkpPwntn+Q+TCnBuEdqodbphT7gU5pb8gdbiTA==
X-Received: by 2002:a17:907:7f19:b0:6ef:fe0b:71aa with SMTP id qf25-20020a1709077f1900b006effe0b71aamr32967127ejc.493.1651180807955;
        Thu, 28 Apr 2022 14:20:07 -0700 (PDT)
Received: from nlaptop.localdomain (ptr-dtfv0poj8u7zblqwbt6.18120a2.ip6.access.telenet.be. [2a02:1811:cc83:eef0:f2b6:6987:9238:41ca])
        by smtp.gmail.com with ESMTPSA id h21-20020a1709070b1500b006f3ef214e17sm34117ejl.125.2022.04.28.14.20.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Apr 2022 14:20:06 -0700 (PDT)
From:   Niels Dossche <dossche.niels@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, noltari@gmail.com,
        Niels Dossche <dossche.niels@gmail.com>
Subject: [PATCH] net: mdio: Fix ENOMEM return value in BCM6368 mux bus controller
Date:   Thu, 28 Apr 2022 23:19:32 +0200
Message-Id: <20220428211931.8130-1-dossche.niels@gmail.com>
X-Mailer: git-send-email 2.35.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Error values inside the probe function must be < 0. The ENOMEM return
value has the wrong sign: it is positive instead of negative.
Add a minus sign.

Fixes: e239756717b5 ("net: mdio: Add BCM6368 MDIO mux bus controller")
Signed-off-by: Niels Dossche <dossche.niels@gmail.com>
---

Note:
I found this issue using my own-developed static analysis tool to find
inconsistent error return values. As I do not have the necessary
hardware to test, I could not test this patch. I found this issue on
v5.17.4. I manually verified the issue report by looking at the code.

 drivers/net/mdio/mdio-mux-bcm6368.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/mdio/mdio-mux-bcm6368.c b/drivers/net/mdio/mdio-mux-bcm6368.c
index 6dcbf987d61b..8b444a8eb6b5 100644
--- a/drivers/net/mdio/mdio-mux-bcm6368.c
+++ b/drivers/net/mdio/mdio-mux-bcm6368.c
@@ -115,7 +115,7 @@ static int bcm6368_mdiomux_probe(struct platform_device *pdev)
 	md->mii_bus = devm_mdiobus_alloc(&pdev->dev);
 	if (!md->mii_bus) {
 		dev_err(&pdev->dev, "mdiomux bus alloc failed\n");
-		return ENOMEM;
+		return -ENOMEM;
 	}
 
 	bus = md->mii_bus;
-- 
2.35.2

