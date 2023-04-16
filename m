Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B7756E3834
	for <lists+netdev@lfdr.de>; Sun, 16 Apr 2023 14:42:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230352AbjDPMml (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Apr 2023 08:42:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230354AbjDPMmf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Apr 2023 08:42:35 -0400
Received: from mail.marcansoft.com (marcansoft.com [212.63.210.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F5E31989;
        Sun, 16 Apr 2023 05:42:33 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: sendonly@marcansoft.com)
        by mail.marcansoft.com (Postfix) with ESMTPSA id 0EAC245038;
        Sun, 16 Apr 2023 12:42:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=marcan.st; s=default;
        t=1681648952; bh=Oed00WIG2i1FOEsKp+TIqwPNzIqbhmI68XB4y4RUhKM=;
        h=From:Date:Subject:References:In-Reply-To:To:Cc;
        b=R0doWUEm+c+NHfn1g00jecwfdIrCtGszsKkH3xYVxmwKs7/t0D2QfX4ogZEvLtjy3
         0y/e/3EsE/rfCEZ55YCMAvAjt8ZiqUfTar1VOPf/Wy+OF3lpz81wPlN6QmbCgPtPb5
         +zI/D6AagD4BcB/ZeqAlGpSMw7L2knGrGPJNyRUCUlF5MhL8cYyzLPxnupu3qmeUO9
         9nScNRtqE8iam5KmLhNQgcsf/PdSJmBlGN0s2K34P8FlgsVe2ECEWtvclPmpu+2fzr
         q0kn5dpXNaDpwBCo6plS9DrcvoRmksvqI7uMqPCYTZUV1Hl10sKIBX4MNp29wGI2SJ
         +RzDvNcAfUeDA==
From:   Hector Martin <marcan@marcan.st>
Date:   Sun, 16 Apr 2023 21:42:17 +0900
Subject: [PATCH 1/2] wifi: brcmfmac: Demote vendor-specific attach/detach
 messages to info
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230416-brcmfmac-noise-v1-1-f0624e408761@marcan.st>
References: <20230416-brcmfmac-noise-v1-0-f0624e408761@marcan.st>
In-Reply-To: <20230416-brcmfmac-noise-v1-0-f0624e408761@marcan.st>
To:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>
Cc:     linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, asahi@lists.linux.dev,
        Hector Martin <marcan@marcan.st>, stable@vger.kernel.org
X-Mailer: b4 0.12.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2643; i=marcan@marcan.st;
 h=from:subject:message-id; bh=Oed00WIG2i1FOEsKp+TIqwPNzIqbhmI68XB4y4RUhKM=;
 b=owGbwMvMwCEm+yP4NEe/cRLjabUkhhTrt3rCzgd5Jyz3td5pf8vTZEOkWVvO1WPPnIw7V6e3b
 XE+7tTTUcrCIMbBICumyNJ4ovdUt+f0c+qqKdNh5rAygQxh4OIUgIm432Nk+Ljy4z0B4eD9KzYW
 OEZcfLUrrWPThZT86VErc3JmCqxI6WH477pweknKhTULNdxn7p4icT/0+sGTKj/0q6aWqPNvD92
 xnQ0A
X-Developer-Key: i=marcan@marcan.st; a=openpgp;
 fpr=FC18F00317968B7BE86201CBE22A629A4C515DD5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

People are getting spooked by brcmfmac errors on their boot console.
There's no reason for these messages to be errors.

Cc: stable@vger.kernel.org
Fixes: d6a5c562214f ("wifi: brcmfmac: add support for vendor-specific firmware api")
Signed-off-by: Hector Martin <marcan@marcan.st>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bca/core.c | 4 ++--
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cyw/core.c | 4 ++--
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/wcc/core.c | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bca/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bca/core.c
index ac3a36fa3640..c83bc435b257 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bca/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bca/core.c
@@ -12,13 +12,13 @@
 
 static int brcmf_bca_attach(struct brcmf_pub *drvr)
 {
-	pr_err("%s: executing\n", __func__);
+	pr_info("%s: executing\n", __func__);
 	return 0;
 }
 
 static void brcmf_bca_detach(struct brcmf_pub *drvr)
 {
-	pr_err("%s: executing\n", __func__);
+	pr_info("%s: executing\n", __func__);
 }
 
 const struct brcmf_fwvid_ops brcmf_bca_ops = {
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cyw/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cyw/core.c
index b75652ba9359..e39d66b07831 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cyw/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cyw/core.c
@@ -12,13 +12,13 @@
 
 static int brcmf_cyw_attach(struct brcmf_pub *drvr)
 {
-	pr_err("%s: executing\n", __func__);
+	pr_info("%s: executing\n", __func__);
 	return 0;
 }
 
 static void brcmf_cyw_detach(struct brcmf_pub *drvr)
 {
-	pr_err("%s: executing\n", __func__);
+	pr_info("%s: executing\n", __func__);
 }
 
 const struct brcmf_fwvid_ops brcmf_cyw_ops = {
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/wcc/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/wcc/core.c
index 02de99818efa..133d274b4025 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/wcc/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/wcc/core.c
@@ -12,13 +12,13 @@
 
 static int brcmf_wcc_attach(struct brcmf_pub *drvr)
 {
-	pr_err("%s: executing\n", __func__);
+	pr_info("%s: executing\n", __func__);
 	return 0;
 }
 
 static void brcmf_wcc_detach(struct brcmf_pub *drvr)
 {
-	pr_err("%s: executing\n", __func__);
+	pr_info("%s: executing\n", __func__);
 }
 
 const struct brcmf_fwvid_ops brcmf_wcc_ops = {

-- 
2.40.0

