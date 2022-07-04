Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A93D5659EF
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 17:35:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234399AbiGDPf0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 11:35:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234066AbiGDPfU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 11:35:20 -0400
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEE991004;
        Mon,  4 Jul 2022 08:35:18 -0700 (PDT)
Received: by mail-qk1-x736.google.com with SMTP id p11so6977995qkg.12;
        Mon, 04 Jul 2022 08:35:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9TZ4414ATBe1OZV0QBg58yBSRyZRYJXmHMNxLNno548=;
        b=TToXzEnMCQqTcBOFk+8pf5RaZQYtGtb2aBNb6PUFYKo2ds0+ojE4+GiNwjvSqglSdL
         B4HDy0hD21ggsbvHB1+eYz4Ceu5Iudm4lz+J6kFSVu6Ndg1eJPTuRF3cP78/sEL30sdR
         yrtBS44DwMN4EwbMJS5Co2IIQ893xfopNmWZZtrY2E6E2rfeNPWmQSLiAcxTgGmPCfJb
         YymGVNYyNwWLRmAsqi5MbKrADvZXDFWfOu4YICSmdhh3t78TPqgMdjrkR+FcUI/lIiuA
         fZUGPnh07WA++IDUFHDY9WzgltWg7flpNsCx1cozMTiQd4hXKIqfRoWN+0qmjrSGelPE
         bI5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9TZ4414ATBe1OZV0QBg58yBSRyZRYJXmHMNxLNno548=;
        b=EHE2yVcxniPD7W8GzcVGe+eHbGdMf//0SPKigJ7W3uHoSZv5Q1v3m3tJJU2w0BC08w
         JpPbiKQXcHIYBX9tMGfuXSKs5Y5uKKgYzVn511+OVUFTlo1nravrkUtJ5qsB3QBYtxJx
         cUEcKscGVmSPj9P13PLCpcgrAC1M7a95U1pe/jVOJvxyPOEbHvcAkfAviBZ6ihWco1D2
         TBSJlAcfiZIVKROirbe3HZYEjF+UpltoUkwCHOWBYpthdghIEvv5Q1KVGlR4fuwyTduZ
         cveg0eESoVJDnI87Kkn59pr3dYiubsWdYk0MlKlWMJxTBf78FF7G4bZ12a2eluLtAic9
         gnbQ==
X-Gm-Message-State: AJIora/THTJNyXNRxKn4NFPWtc0fxFW/iOJZ56o4aFhRP65DPWGv8SHV
        znPTYrxoUot5C4P+RvNspHLMQaQTtTM=
X-Google-Smtp-Source: AGRyM1sCzui8G3Ih0QRlJim/16sY9oo3+REi4j/k+XXn8IVrDNiWUOlI0knM/sRnkb+0l4w0mTRZtQ==
X-Received: by 2002:a05:620a:4505:b0:6b3:7c51:537c with SMTP id t5-20020a05620a450500b006b37c51537cmr3537430qkp.69.1656948917428;
        Mon, 04 Jul 2022 08:35:17 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id b12-20020a05620a0f8c00b006a34a22bc60sm24366909qkn.9.2022.07.04.08.35.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jul 2022 08:35:16 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     stable@vger.kernel.org
Cc:     Doug Berger <opendmb@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        olteanv@gmail.com, andrew@lunn.ch
Subject: [PATCH stable 4.14] net: dsa: bcm_sf2: force pause link settings
Date:   Mon,  4 Jul 2022 08:35:08 -0700
Message-Id: <20220704153510.3859649-2-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220704153510.3859649-1-f.fainelli@gmail.com>
References: <20220704153510.3859649-1-f.fainelli@gmail.com>
MIME-Version: 1.0
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

From: Doug Berger <opendmb@gmail.com>

commit 7c97bc0128b2eecc703106112679a69d446d1a12 upstream

The pause settings reported by the PHY should also be applied to the GMII port
status override otherwise the switch will not generate pause frames towards the
link partner despite the advertisement saying otherwise.

Fixes: 246d7f773c13 ("net: dsa: add Broadcom SF2 switch driver")
Signed-off-by: Doug Berger <opendmb@gmail.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/bcm_sf2.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index 11a72c4cbb92..b838d6bf3165 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -701,6 +701,11 @@ static void bcm_sf2_sw_adjust_link(struct dsa_switch *ds, int port,
 		reg |= LINK_STS;
 	if (phydev->duplex == DUPLEX_FULL)
 		reg |= DUPLX_MODE;
+	if (phydev->pause) {
+		if (phydev->asym_pause)
+			reg |= TXFLOW_CNTL;
+		reg |= RXFLOW_CNTL;
+	}
 
 	core_writel(priv, reg, offset);
 
-- 
2.25.1

