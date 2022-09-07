Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6E885AFE0E
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 09:49:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229944AbiIGHtc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 03:49:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230138AbiIGHsf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 03:48:35 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 780B0A6C40;
        Wed,  7 Sep 2022 00:48:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Iqv2ZNon/0V6qOMjnZaExwEfo5N/cA+0Vtwvr2YuKdI=; b=mWJWvBM1m/S7CL4dvzyBjROmxo
        5rFaJJoJ66DRyZu21oef3k9y+x9JMg7zhISAhZoHaWTBjmCxhRT68Wt+iU+m/JMm//1YIQvthDuIO
        PuFLFnFjj+UspsBO1VsRs8zR3IWe/hTO9hz2gzwXIKr+DBclOGVk2mtx4uo2wao/OSC2YEeXBnXnB
        ks4G5UU1d7vUFxgbRsq4Mbi+KgXywEXUw+YAtx1s7HOJjSb5FktUq9iLGOUb2Qg3FSMS22based3d
        vrLdN47qwljLKT854SzRjnqYyBd0Uq0ZgysCfq5aCkjZlZfCOliUB35NTr0U5lbvJlHtFynbsYYV7
        g0c1yNaA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:51102 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1oVpnQ-0004x1-3P; Wed, 07 Sep 2022 08:48:28 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1oVpnP-005LC8-CO; Wed, 07 Sep 2022 08:48:27 +0100
In-Reply-To: <YxhMaYOfnM+7FG+W@shell.armlinux.org.uk>
References: <YxhMaYOfnM+7FG+W@shell.armlinux.org.uk>
From:   Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
To:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>
Cc:     Alyssa Rosenzweig <alyssa@rosenzweig.io>, asahi@lists.linux.dev,
        brcm80211-dev-list.pdl@broadcom.com,
        "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Hector Martin <marcan@marcan.st>,
        Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        "Rafa__ Mi__ecki" <zajec5@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        SHA-cyfmac-dev-list@infineon.com, Sven Peter <sven@svenpeter.dev>
Subject: [PATCH net-next 09/12] brcmfmac: msgbuf: Increase RX ring sizes to
 1024
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1oVpnP-005LC8-CO@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Wed, 07 Sep 2022 08:48:27 +0100
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hector Martin <marcan@marcan.st>

Newer chips used on Apple platforms have a max_rxbufpost greater than
512, which causes warnings when brcmf_msgbuf_rxbuf_data_fill tries to
put more entries in the ring than will fit. Increase the ring sizes
to 1024.

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Hector Martin <marcan@marcan.st>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.h
index 2e322edbb907..6a849f4a94dd 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.h
@@ -8,10 +8,10 @@
 #ifdef CONFIG_BRCMFMAC_PROTO_MSGBUF
 
 #define BRCMF_H2D_MSGRING_CONTROL_SUBMIT_MAX_ITEM	64
-#define BRCMF_H2D_MSGRING_RXPOST_SUBMIT_MAX_ITEM	512
+#define BRCMF_H2D_MSGRING_RXPOST_SUBMIT_MAX_ITEM	1024
 #define BRCMF_D2H_MSGRING_CONTROL_COMPLETE_MAX_ITEM	64
 #define BRCMF_D2H_MSGRING_TX_COMPLETE_MAX_ITEM		1024
-#define BRCMF_D2H_MSGRING_RX_COMPLETE_MAX_ITEM		512
+#define BRCMF_D2H_MSGRING_RX_COMPLETE_MAX_ITEM		1024
 #define BRCMF_H2D_TXFLOWRING_MAX_ITEM			512
 
 #define BRCMF_H2D_MSGRING_CONTROL_SUBMIT_ITEMSIZE	40
-- 
2.30.2

