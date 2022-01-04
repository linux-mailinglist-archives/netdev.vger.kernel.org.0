Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41D87483C72
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 08:29:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233342AbiADH3R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 02:29:17 -0500
Received: from marcansoft.com ([212.63.210.85]:46264 "EHLO mail.marcansoft.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233324AbiADH3O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jan 2022 02:29:14 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: hector@marcansoft.com)
        by mail.marcansoft.com (Postfix) with ESMTPSA id 1C1BA41F5D;
        Tue,  4 Jan 2022 07:29:04 +0000 (UTC)
From:   Hector Martin <marcan@marcan.st>
To:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Dmitry Osipenko <digetx@gmail.com>
Cc:     Hector Martin <marcan@marcan.st>, Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Mark Kettenis <kettenis@openbsd.org>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hans de Goede <hdegoede@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "brian m. carlson" <sandals@crustytoothpaste.net>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com
Subject: [PATCH v2 11/35] brcmfmac: msgbuf: Increase RX ring sizes to 1024
Date:   Tue,  4 Jan 2022 16:26:34 +0900
Message-Id: <20220104072658.69756-12-marcan@marcan.st>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220104072658.69756-1-marcan@marcan.st>
References: <20220104072658.69756-1-marcan@marcan.st>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Newer chips used on Apple platforms have a max_rxbufpost greater than
512, which causes warnings when brcmf_msgbuf_rxbuf_data_fill tries to
put more entries in the ring than will fit. Increase the ring sizes
to 1024.

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Hector Martin <marcan@marcan.st>
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
2.33.0

