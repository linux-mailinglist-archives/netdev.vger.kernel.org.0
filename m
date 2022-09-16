Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F1AE5BB0C3
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 18:03:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229898AbiIPQDw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 12:03:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230103AbiIPQDO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 12:03:14 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD705B56DE;
        Fri, 16 Sep 2022 09:03:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=M1YvgbxuO3J4hqI1ceKg9NSimYPqJ08rzT5LCS0EJfU=; b=FBS/Qby0/CxTRKNVbfEU0rb8dL
        DBNDrCTChN5PBI1BwteRs2YjAWK4yRGv9mlgjY77UGXIskBKvhl4EKmDV1gXP6priSk6BS4ZFUa1D
        6salHc9PPemUPHXBvzWlBrEGxDULpJCzuhPEnfoc9SYxbKfaxmZqJ65BKY/wrtCX/sjKrCn1pEEgL
        DkxI3N9MU0qZRV15Uu4Grr/QCaxLNWVssJeYXgPyaD86xi4GnSivSzlAlm+2/dfnHUry0td+pby6D
        sI0tTW5/w9k1WMuLTW9iSkJvxLtZMEfMkYtma8JV7344HfRtBF4vDwE9DNkNsN/QJYmB7g8Zn7CAa
        gqgJLx9w==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:54034 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1oZDo3-0006vr-Os; Fri, 16 Sep 2022 17:03:07 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1oZDo3-0077ak-2h; Fri, 16 Sep 2022 17:03:07 +0100
In-Reply-To: <YySd3pASZKUh4leX@shell.armlinux.org.uk>
References: <YySd3pASZKUh4leX@shell.armlinux.org.uk>
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
Subject: [PATCH wireless-next v3 09/12] brcmfmac: msgbuf: Increase RX ring
 sizes to 1024
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1oZDo3-0077ak-2h@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Fri, 16 Sep 2022 17:03:07 +0100
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
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
Reviewed-by: Alvin Šipraga <alsi@bang-olufsen.dk>
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

