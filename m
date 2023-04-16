Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F1416E382F
	for <lists+netdev@lfdr.de>; Sun, 16 Apr 2023 14:42:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230313AbjDPMmd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Apr 2023 08:42:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230282AbjDPMmc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Apr 2023 08:42:32 -0400
Received: from mail.marcansoft.com (marcansoft.com [212.63.210.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 843881737;
        Sun, 16 Apr 2023 05:42:30 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: sendonly@marcansoft.com)
        by mail.marcansoft.com (Postfix) with ESMTPSA id 580D3447CF;
        Sun, 16 Apr 2023 12:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=marcan.st; s=default;
        t=1681648947; bh=Mkd1JPhb3nS2pj7N8smN5I/IKmBOuca+sSQG67P1+dk=;
        h=From:Subject:Date:To:Cc;
        b=vVkaE07bZiUVG7gtA4MidB59VajJKt1rkQ4TQGlkO4MKwOFudLwx3dJXVcRnTg1XZ
         klkdsoZq3VOLGGjFk5YY/Xwy5JFwvu/V1mZ6w0TeVegzhI7rJKMANTqUjsIDDgpWZR
         FGfgF/nAUxRNlnW8mWUMf6BgNSG65YwukgL9C71vhRaY3JTlK76FJNPbmjVIh7vKJH
         gnJGHs3HeadL7sFbkXdAlRR54jBYrY/kHbWa/8oiDoeNM66e7wWGi7Rbw+UmxwygqC
         8OzX4TBZ+w5cVvzZYE17g/Vgf34FxOhZ5A8xlRGo0lg3UWspAmA04v6Nn3nWUQvmim
         V66w5/8fNIEmg==
From:   Hector Martin <marcan@marcan.st>
Subject: [PATCH 0/2] brcmfmac: Demote some kernel errors to info
Date:   Sun, 16 Apr 2023 21:42:16 +0900
Message-Id: <20230416-brcmfmac-noise-v1-0-f0624e408761@marcan.st>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIACjtO2QC/x2NQQqDMBBFryKzbjBOShCvUrqYxInOwiiTWgTx7
 o1dvvd5/BMKq3CBoTlB+StF1lyhezQQZ8oTGxkrA1p09tl5EzQuaaFo8iqFDQbi3vXOJxyhRoG
 qDEo5znf28RaPNqjkad/ufVNOcvwPX+/r+gEA4845gAAAAA==
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1405; i=marcan@marcan.st;
 h=from:subject:message-id; bh=Mkd1JPhb3nS2pj7N8smN5I/IKmBOuca+sSQG67P1+dk=;
 b=owGbwMvMwCEm+yP4NEe/cRLjabUkhhTrt7ru07SCfl5rmW3R5x16bpXI86Mc6klakxYp7Y+Te
 GETl3C/o5SFQYyDQVZMkaXxRO+pbs/p59RVU6bDzGFlAhnCwMUpABP5mcLI8NXrfNq2qTnZNflc
 y7uYv+Su4xC6mGH/P0Pi8wXZDQl2DYwMF9+5r1/orvoxO1pC14GNn+FpBN+Ok4/L+IR/KBcdaDr
 GAAA=
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

brcmfmac has some messages that are KERN_ERR even though they are
harmless. This is spooking and confusing people, because they end up
being the *only* kernel messages on their boot console with common
error-only printk levels (at least on Apple Macs).

Then, when their system does not boot to a GUI for some other reason,
the brcmfmac errors are the only thing on their TTY (which also does
not show a login prompt on tty1 in typical systemd setups) and they are
thoroughly confused into believing their problem has something to do
with brcmfmac.

Seriously, I've had 10 or so people mention this by now, and multiple
confused Reddit threads about it. Let's fix it.

Signed-off-by: Hector Martin <marcan@marcan.st>
---
Hector Martin (2):
      wifi: brcmfmac: Demote vendor-specific attach/detach messages to info
      wifi: brcmfmac: Demote p2p unknown frame error to info (once)

 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bca/core.c | 4 ++--
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cyw/core.c | 4 ++--
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c      | 4 ++--
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/wcc/core.c | 4 ++--
 4 files changed, 8 insertions(+), 8 deletions(-)
---
base-commit: fe15c26ee26efa11741a7b632e9f23b01aca4cc6
change-id: 20230416-brcmfmac-noise-2bae83836f2d

Best regards,
-- 
Hector Martin <marcan@marcan.st>

