Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B912A19EB7E
	for <lists+netdev@lfdr.de>; Sun,  5 Apr 2020 15:39:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbgDENjO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Apr 2020 09:39:14 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56850 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726556AbgDENjO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Apr 2020 09:39:14 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1jL5UQ-00034b-KJ; Sun, 05 Apr 2020 13:39:06 +0000
From:   Colin King <colin.king@canonical.com>
To:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] brcm80211: remove redundant pointer 'address'
Date:   Sun,  5 Apr 2020 14:39:06 +0100
Message-Id: <20200405133906.381358-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Pointer 'address' is being assigned and updated in a few places
by it is never read. Hence the assignments are redundant and can
be removed.

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 .../net/wireless/broadcom/brcm80211/brcmfmac/commonring.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/commonring.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/commonring.c
index 49db54d23e03..e44236cb210e 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/commonring.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/commonring.c
@@ -180,14 +180,8 @@ brcmf_commonring_reserve_for_write_multiple(struct brcmf_commonring *commonring,
 
 int brcmf_commonring_write_complete(struct brcmf_commonring *commonring)
 {
-	void *address;
-
-	address = commonring->buf_addr;
-	address += (commonring->f_ptr * commonring->item_len);
-	if (commonring->f_ptr > commonring->w_ptr) {
-		address = commonring->buf_addr;
+	if (commonring->f_ptr > commonring->w_ptr)
 		commonring->f_ptr = 0;
-	}
 
 	commonring->f_ptr = commonring->w_ptr;
 
-- 
2.25.1

