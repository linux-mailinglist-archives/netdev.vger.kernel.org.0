Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A59B73DF116
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 17:09:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236560AbhHCPJg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 11:09:36 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:57128
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236685AbhHCPJT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 11:09:19 -0400
Received: from localhost (1.general.cking.uk.vpn [10.172.193.212])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 87E4E3F070;
        Tue,  3 Aug 2021 15:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1628003344;
        bh=yujcAW928JS1+WAa5ppXQvA0AiE4xUVDj/s66hatc0A=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type;
        b=mREzlHPwx8jgCXwCQp5AweexjLomZrqnpv852tP8GEMfnDNQ9EJZuB1sab7bJNrGk
         D7QfrRHgwLxawch47XtG9QsCVQPOGIvpgWHr9SDIg4f0MgRHnL21bIUQVP2+lKueKF
         rQOEhkLmppi2Cu5ldSdAZmpjBIL8PyThXJuBTn8v47zgboCQ+mtaKrMNVaCgRcR76q
         +rGSxnkpHTe/HkOjautuv4a3h4TvjTJX2hajKOnSSLz9oXKWYardQxD98JjMDR3Igu
         jr//IdPSl+37xIHBh7CDoSUnpfddVTA3gkeTcmcXkrDffArQJxK9mAkPKq6n45huO4
         F+/KQhEPocRXw==
From:   Colin King <colin.king@canonical.com>
To:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] brcmfmac: firmware: Fix uninitialized variable ret
Date:   Tue,  3 Aug 2021 16:09:04 +0100
Message-Id: <20210803150904.80119-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Currently the variable ret is uninitialized and is only set if
the pointer alt_path is non-null. Fix this by ininitializing ret
to zero.

Addresses-Coverity: ("Uninitialized scalar variable")
Fixes: 5ff013914c62 ("brcmfmac: firmware: Allow per-board firmware binaries")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
index adfdfc654b10..4f387e868120 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
@@ -680,7 +680,7 @@ int brcmf_fw_get_firmwares(struct device *dev, struct brcmf_fw_request *req,
 	struct brcmf_fw_item *first = &req->items[0];
 	struct brcmf_fw *fwctx;
 	char *alt_path;
-	int ret;
+	int ret = 0;
 
 	brcmf_dbg(TRACE, "enter: dev=%s\n", dev_name(dev));
 	if (!fw_cb)
-- 
2.31.1

