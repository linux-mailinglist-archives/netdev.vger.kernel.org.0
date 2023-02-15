Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E0AE697A2A
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 11:46:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234186AbjBOKqh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 05:46:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234183AbjBOKqg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 05:46:36 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43EBE34306;
        Wed, 15 Feb 2023 02:46:35 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id mc25so9761584ejb.13;
        Wed, 15 Feb 2023 02:46:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dtAqLJjb8kXNprDpI0ZhXk+okZoB2I39B1lgMZMQzzg=;
        b=lt63oOVP5qUE2gyjmgluFbV+pfWGnpvPL5yplwbqtYs1oD6uoCjiyPN7DyFtHX3Z3V
         QSl9evIvowezyMNR7hU27QrpBUhtAkDlY9YbrlBMCHWO5yy/1TSLVZBfFIpof95/Yxfn
         mUNpUSbMGannFPCcgAow46tbPaNQSSdkbGYsd1HHVCtrPqHeDJdQCF+BMOf2vt2ytgPW
         +9SL0U+lKkNN9rsAl6T6dpIb9umSi8qbKqK8xwDrkvDEv1NmF8Rm8uMs3NX7eNALE3YF
         wnMu0OEGPWevO/a139cdzlUAedF6rJukpOdc413plVknkQZzMw4N/8CkVySlN5X56gaj
         Jd7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dtAqLJjb8kXNprDpI0ZhXk+okZoB2I39B1lgMZMQzzg=;
        b=t9pII/3LCEH2Jtzkimawm7A8iYZJo2LihuuSL7+VyE8eIb8U8qv6FX2ife5B9mkzvI
         ZhITeXciorc2sLAC9yVP4S/LrVnm0FJKpZoQ18ZYjiOCQOOfeLlzqW7L/DPP2CnNJ/2r
         WJuD1/+2BRFMo5Gm11B7g8rIcGlrS07DImWpAP1HbD9h/wKxTVVG94KYxJkM5qE2g3DZ
         +t5XnNLr9RFIKaPVld0gdHm7x82hCmfV0UdXzaOedXgqlAW5WNd+VVNXmyspo3QgJ/b4
         OPr1BX5xMdnIYO76ClMadnZPzoKLcSQeJBFRcYfc+ZMgNx7tS2VxC1avIqQGFjLyy2P6
         JIvg==
X-Gm-Message-State: AO0yUKXbxX9t9N5JghBE3FGLslnAXqEqKsyPsQ7r3K8JMPQUek9ZFzkS
        Gps9xGeZ+KvM2cfJ29AMpXI=
X-Google-Smtp-Source: AK7set9p4byJT4a67ATaz4GPxWN199dFQnPC5T0vRGeHQ+qvsIatOq202sACz4oADpSyrPFIbNqzbA==
X-Received: by 2002:a17:907:d30d:b0:8af:2cf7:dd2b with SMTP id vg13-20020a170907d30d00b008af2cf7dd2bmr2232679ejc.13.1676457993711;
        Wed, 15 Feb 2023 02:46:33 -0800 (PST)
Received: from felia.fritz.box ([2a02:810d:2a40:1104:983e:41b3:46f3:e161])
        by smtp.gmail.com with ESMTPSA id kt13-20020a170906aacd00b008b13b0dabcasm1141025ejb.182.2023.02.15.02.46.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Feb 2023 02:46:33 -0800 (PST)
From:   Lukas Bulwahn <lukas.bulwahn@gmail.com>
To:     Colin Foster <colin.foster@in-advantage.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: [PATCH] net: dsa: ocelot: fix selecting MFD_OCELOT
Date:   Wed, 15 Feb 2023 11:46:31 +0100
Message-Id: <20230215104631.31568-1-lukas.bulwahn@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 3d7316ac81ac ("net: dsa: ocelot: add external ocelot switch
control") adds config NET_DSA_MSCC_OCELOT_EXT, which selects the
non-existing config MFD_OCELOT_CORE.

Replace this select with the intended and existing MFD_OCELOT.

Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
---
 drivers/net/dsa/ocelot/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/ocelot/Kconfig b/drivers/net/dsa/ocelot/Kconfig
index eff0a7dfcd21..081e7a88ea02 100644
--- a/drivers/net/dsa/ocelot/Kconfig
+++ b/drivers/net/dsa/ocelot/Kconfig
@@ -14,7 +14,7 @@ config NET_DSA_MSCC_OCELOT_EXT
 	depends on NET_VENDOR_MICROSEMI
 	depends on PTP_1588_CLOCK_OPTIONAL
 	select MDIO_MSCC_MIIM
-	select MFD_OCELOT_CORE
+	select MFD_OCELOT
 	select MSCC_OCELOT_SWITCH_LIB
 	select NET_DSA_MSCC_FELIX_DSA_LIB
 	select NET_DSA_TAG_OCELOT_8021Q
-- 
2.17.1

