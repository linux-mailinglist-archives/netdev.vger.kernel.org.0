Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D5D6577223
	for <lists+netdev@lfdr.de>; Sun, 17 Jul 2022 01:08:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232882AbiGPXIT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jul 2022 19:08:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232231AbiGPXIO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jul 2022 19:08:14 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1403186D4;
        Sat, 16 Jul 2022 16:08:12 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id d16so11809423wrv.10;
        Sat, 16 Jul 2022 16:08:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AcH9xqJ0k/4jByViDRihM1a2jjuLTRujm9Mqh/y4WfU=;
        b=Gfcogbmz3/K65c3EnnUC1lbWrysiwjn7PTvEVGPFELRoym4ssg/p1VDUPd8z1VQs/2
         IPCagCFhuGEoQFsFa6usAmm+P8l4tK+MdcYMeVcxwg9GpHfNO+Hxamf4VFXlGsGLSVrZ
         RIQOCOS/qam6UbXgIYcHkiUFlY1c5s2MXcqnt3zEBZwESv2mJ/NX2Lw5pVfxq3KTJ2gt
         qpndMGJewN28lhy0vfDGjQDXpf10nJcZVs0GKQBcFjA3gXq3ad+fkPsUL0uvlPxujyA0
         HV2hssNImYnmKbyshYVQnsfEfj4lnJwEb1EPQKjBQXI7A5jaxecPtqlVJ/JWifihk8uU
         W/9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AcH9xqJ0k/4jByViDRihM1a2jjuLTRujm9Mqh/y4WfU=;
        b=nIHFgoeAK9VWDFD4/v7l6OmCmQfwvTuHYFjkHLpoPRRfS0ORo7ciBhSRQv5SJh3qQh
         khTWBT2h93Inn0lrSjXFZI+A0YjkenR4oxWUcIyMsUuLaemkX0kFSnmjZM89F2v/8yQM
         SM5jUR9QWBhDvtZGMkhU7X43AmcS9fwyQQYnc4dEIhVxY6itU8X+j/lbGPvZZBR8EgkY
         w6rJL7xrD0j+gAMuIOb/r+HakBvi/+jvLmA10Zn9qVjzYWgLHIn1aDDofWCClPMAOly8
         XoFde/u1bEwftqY7LSDUvGFlmHxYbxh9JfbqGPAikGBbHLTRst/QLjEgbrNuTYYb5WjP
         lw9Q==
X-Gm-Message-State: AJIora9nFIreiEgEhXdzy2yVQj/zZ0QplgNRm4QYuEpIihUfyOi7phFC
        rp4lg3ugojeXf9LUu4crU/0=
X-Google-Smtp-Source: AGRyM1tP2PAJFpt2bHiFsNgLLbCwK7Qak01U2580Nyv+iEK/GVTVb7lSi0R1YMZOoK2qrWWj+Mnn8g==
X-Received: by 2002:a05:6000:15c8:b0:21d:babe:e75c with SMTP id y8-20020a05600015c800b0021dbabee75cmr18627124wry.32.1658012891127;
        Sat, 16 Jul 2022 16:08:11 -0700 (PDT)
Received: from localhost.localdomain (93-42-70-190.ip85.fastwebnet.it. [93.42.70.190])
        by smtp.googlemail.com with ESMTPSA id l13-20020a05600c2ccd00b003a2f2bb72d5sm15150755wmc.45.2022.07.16.16.08.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Jul 2022 16:08:10 -0700 (PDT)
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     Christian Marangi <ansuelsmth@gmail.com>
Subject: [net-next PATCH v3 2/5] net: ethernet: stmicro: stmmac: first disable all queues in release
Date:   Sun, 17 Jul 2022 01:07:59 +0200
Message-Id: <20220716230802.20788-3-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220716230802.20788-1-ansuelsmth@gmail.com>
References: <20220716230802.20788-1-ansuelsmth@gmail.com>
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

Disable all queues before tx_disable in stmmac_release to prevent a
corner case where packet may be still queued at the same time tx_disable
is called resulting in kernel panic if some packet still has to be
processed.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 5578abb14949..1854dcdd6095 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -3758,6 +3758,11 @@ static int stmmac_release(struct net_device *dev)
 	struct stmmac_priv *priv = netdev_priv(dev);
 	u32 chan;
 
+	stmmac_disable_all_queues(priv);
+
+	for (chan = 0; chan < priv->plat->tx_queues_to_use; chan++)
+		hrtimer_cancel(&priv->tx_queue[chan].txtimer);
+
 	netif_tx_disable(dev);
 
 	if (device_may_wakeup(priv->device))
@@ -3766,11 +3771,6 @@ static int stmmac_release(struct net_device *dev)
 	phylink_stop(priv->phylink);
 	phylink_disconnect_phy(priv->phylink);
 
-	stmmac_disable_all_queues(priv);
-
-	for (chan = 0; chan < priv->plat->tx_queues_to_use; chan++)
-		hrtimer_cancel(&priv->tx_queue[chan].txtimer);
-
 	/* Free the IRQ lines */
 	stmmac_free_irq(dev, REQ_IRQ_ERR_ALL, 0);
 
-- 
2.36.1

