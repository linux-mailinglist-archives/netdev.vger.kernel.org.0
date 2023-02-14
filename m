Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71E7F695F3A
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 10:30:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231294AbjBNJaL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 04:30:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231964AbjBNJ3q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 04:29:46 -0500
Received: from mail.marcansoft.com (marcansoft.com [212.63.210.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A5AD13D52;
        Tue, 14 Feb 2023 01:29:28 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: sendonly@marcansoft.com)
        by mail.marcansoft.com (Postfix) with ESMTPSA id 416A841EF0;
        Tue, 14 Feb 2023 09:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=marcan.st; s=default;
        t=1676366941; bh=AdhmYWfljCcE2txv2eI6D+3+X4JkvmsCqoAX0cB3tE0=;
        h=From:To:Cc:Subject:Date;
        b=JXrDwxsXKNRBghl87ApLzK0C109ntBzTCq/sJurbi2VEtUXRZXXt6N3EeRzisuwS1
         KEGIxkBX64ec3i8RrKhGZ+RpBouXeMcaWsubxZUrUY79474yYFhAngc/e7UTuSrG53
         Fd0RIscSmBntBzNpxUYxKdITTZvpaQCAk9922fkkz+vZ/YiHkybmkXr+pdWXLAXv9Y
         jlGqSosEnwX+erQhqRpNVxOnDYfJswrqYWGZxU+UrOmCZE61ZDw4aicf1OR8g7bCUa
         1apO2k0rQZFMKr7dTog7CgWv640q1jzv7hhGwf+U4QKZPAqrAsVzS7LsZqsWDmKUVQ
         4r4gwfgaH/Z1g==
From:   Hector Martin <marcan@marcan.st>
To:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        asahi@lists.linux.dev, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hector Martin <marcan@marcan.st>
Subject: [PATCH] brcmfmac: pcie: Add BCM4378B3 support
Date:   Tue, 14 Feb 2023 18:28:38 +0900
Message-Id: <20230214092838.17869-1-marcan@marcan.st>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

BCM4378B3 is a new silicon revision of BCM4378 present on the Apple M2
13" MacBook Pro "kyushu". Its PCI revision number is 5.

Signed-off-by: Hector Martin <marcan@marcan.st>
---
Note: This applies cleanly on top of:

 [PATCH 07/10] brcmfmac: pcie: Add IDs/properties for BCM4387

Though the conflict should be trivial to resolve if it is applied first.

 drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
index 7ee532ab8e85..43d666e9038f 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -66,6 +66,7 @@ BRCMF_FW_DEF(4366C, "brcmfmac4366c-pcie");
 BRCMF_FW_DEF(4371, "brcmfmac4371-pcie");
 BRCMF_FW_CLM_DEF(4377B3, "brcmfmac4377b3-pcie");
 BRCMF_FW_CLM_DEF(4378B1, "brcmfmac4378b1-pcie");
+BRCMF_FW_CLM_DEF(4378B3, "brcmfmac4378b3-pcie");
 BRCMF_FW_CLM_DEF(4387C2, "brcmfmac4387c2-pcie");
 
 /* firmware config files */
@@ -101,7 +102,8 @@ static const struct brcmf_firmware_mapping brcmf_pcie_fwnames[] = {
 	BRCMF_FW_ENTRY(BRCM_CC_43666_CHIP_ID, 0xFFFFFFF0, 4366C),
 	BRCMF_FW_ENTRY(BRCM_CC_4371_CHIP_ID, 0xFFFFFFFF, 4371),
 	BRCMF_FW_ENTRY(BRCM_CC_4377_CHIP_ID, 0xFFFFFFFF, 4377B3), /* revision ID 4 */
-	BRCMF_FW_ENTRY(BRCM_CC_4378_CHIP_ID, 0xFFFFFFFF, 4378B1), /* revision ID 3 */
+	BRCMF_FW_ENTRY(BRCM_CC_4378_CHIP_ID, 0x0000000F, 4378B1), /* revision ID 3 */
+	BRCMF_FW_ENTRY(BRCM_CC_4378_CHIP_ID, 0xFFFFFFE0, 4378B3), /* revision ID 5 */
 	BRCMF_FW_ENTRY(BRCM_CC_4387_CHIP_ID, 0xFFFFFFFF, 4387C2), /* revision ID 7 */
 };
 
-- 
2.35.1

