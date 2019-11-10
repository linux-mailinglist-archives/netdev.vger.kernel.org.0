Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9ACB8F669F
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 04:15:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727798AbfKJCmQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 21:42:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:37770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727777AbfKJCmP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Nov 2019 21:42:15 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE2CE214E0;
        Sun, 10 Nov 2019 02:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573353735;
        bh=JimTXPtAbX8YoTT19Gr8WHDW98DSZBe8ND3dur/LtAQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iOK1QRdq1T6pP3u8DQiNuaLLupupY6uSJRwtl8Ac2ofZSwkKAnxG4s4TaKzvWsELJ
         aUbgWoLu9t3mQjgSlEkt0nsvdmV1rPvvbtCY7NhQGVU1bEXCGOFQeUJYejpDifDsOK
         CyXXTiM2lcVcM07w+0v/iquzJWbbd4pV3UwMkwxo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 058/191] brcmfmac: increase buffer for obtaining firmware capabilities
Date:   Sat,  9 Nov 2019 21:38:00 -0500
Message-Id: <20191110024013.29782-58-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024013.29782-1-sashal@kernel.org>
References: <20191110024013.29782-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arend van Spriel <arend.vanspriel@broadcom.com>

[ Upstream commit 59c2a30d36c8ae430d26a902c4c9665ea33ccee5 ]

When obtaining the firmware capability a buffer is provided of 512
bytes. However, if all features in firmware are supported the buffer
needs to be 565 bytes as otherwise truncated information is retrieved
from firmware. Increasing the buffer to 768 bytes on stack.

Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
index 8347da632a5b0..4c5a3995dc352 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
@@ -178,7 +178,7 @@ static void brcmf_feat_iovar_data_set(struct brcmf_if *ifp,
 	ifp->fwil_fwerr = false;
 }
 
-#define MAX_CAPS_BUFFER_SIZE	512
+#define MAX_CAPS_BUFFER_SIZE	768
 static void brcmf_feat_firmware_capabilities(struct brcmf_if *ifp)
 {
 	char caps[MAX_CAPS_BUFFER_SIZE];
-- 
2.20.1

