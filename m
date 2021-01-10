Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AE962F0727
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 13:18:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726853AbhAJMSm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jan 2021 07:18:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726832AbhAJMSl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jan 2021 07:18:41 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0208DC061786
        for <netdev@vger.kernel.org>; Sun, 10 Jan 2021 04:18:01 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id c5so13473954wrp.6
        for <netdev@vger.kernel.org>; Sun, 10 Jan 2021 04:18:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=XL1NRKWCJhTyK7gKZWMCKWJH+4Rps1TqExGYFVIk2Qo=;
        b=gqestvpc+Vp27J92aplleGhJOVMB9vhB6nx/jM4Rwxn+A1meyQbH/kYCl6R7WZBJpw
         /Y4BpRO5PJznjP+39gmbYcFqapwt/qYST+WYXDroUV3pOO7V7GNnWYfbK64v8NbLYewb
         BsBPUMWlHUTusMXEVU/qiP2ZRonYrTbOvXuRDWBk1NGgWC8kl8tI5SBWYK7sXzPsfIF0
         TSD67A7cgUTSJlySLnMZ0wLkG89+x2ULF4w2yMRz/WIvglwg39pCRTJxPfkpw/H0X38O
         ZErKAPceyX27VumsZUGXLJfT5MSfbtgFhWxFqk1RBHBHiiZ0zRXfgHfYXZHW7PdpFOeh
         fWPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=XL1NRKWCJhTyK7gKZWMCKWJH+4Rps1TqExGYFVIk2Qo=;
        b=bQbRXmYFwzVBEXZAPsQerBHeb6I1ZUMOY2/fJ+JTVVqru64H1XIJCsWMm/F0r159dN
         VHV0h7gDg7k5/8elKlY/cUrzFoZ/Cr9GHUCaLteD4WWqrMw26WzZhM/cAvvWXItxdDpJ
         oO4H2eR9HiDzEpT057n5xIuSGSFZFzT9rG2uzOuyTd/V36bbbCQTWCjIT6KpogMcx46V
         YgzLw5UC5hIXs1REgXYtlJsoYTBs/U2DTtxL6JnVstHUCae2DSm5Ci8diT5bWuaYvL3W
         w2CGXqC5SInNi84JLN1BrUBX588ybh/je4XKJ0BWw7kA7KN0gSKPwwt5AWlngBVzD/Mx
         0dzw==
X-Gm-Message-State: AOAM533My77fKQYHM2b7dtpbMthq5aytXJp2BiGxTBlUlwhRsle+brw+
        7vBxbntP2+fXfrG9hwHqGESxA72d+1o=
X-Google-Smtp-Source: ABdhPJzip0BscjAKLZTN3gbJKeqcACK0NlAKvri1YnxiK4TGi34Z0W25MNN58+67fucxUgfdwCOmPg==
X-Received: by 2002:a5d:5005:: with SMTP id e5mr11663893wrt.279.1610281079495;
        Sun, 10 Jan 2021 04:17:59 -0800 (PST)
Received: from ?IPv6:2003:ea:8f06:5500:45c0:cdfd:d838:af6f? (p200300ea8f06550045c0cdfdd838af6f.dip0.t-ipconnect.de. [2003:ea:8f06:5500:45c0:cdfd:d838:af6f])
        by smtp.googlemail.com with ESMTPSA id c18sm22966245wmk.0.2021.01.10.04.17.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 10 Jan 2021 04:17:58 -0800 (PST)
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH v2 net-next] r8169: deprecate support for RTL_GIGA_MAC_VER_27
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Message-ID: <ca98f018-a0e1-8762-e95c-f0ad773a0271@gmail.com>
Date:   Sun, 10 Jan 2021 13:17:52 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RTL8168dp is ancient anyway, and I haven't seen any trace of its early
version 27 yet. This chip versions needs quite some special handling,
therefore it would facilitate driver maintenance if support for it
could be dropped. For now just disable detection of this chip version.
If nobody complains we can remove support for it in the near future.

v2:
- extend unknown chip version error message

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index f72b1497d..b4ecefb7d 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -2001,7 +2001,11 @@ static enum mac_version rtl8169_get_mac_version(u16 xid, bool gmii)
 		{ 0x7c8, 0x280,	RTL_GIGA_MAC_VER_26 },
 
 		/* 8168DP family. */
-		{ 0x7cf, 0x288,	RTL_GIGA_MAC_VER_27 },
+		/* It seems this early RTL8168dp version never made it to
+		 * the wild. Let's see whether somebody complains, if not
+		 * we'll remove support for this chip version completely.
+		 * { 0x7cf, 0x288,      RTL_GIGA_MAC_VER_27 },
+		 */
 		{ 0x7cf, 0x28a,	RTL_GIGA_MAC_VER_28 },
 		{ 0x7cf, 0x28b,	RTL_GIGA_MAC_VER_31 },
 
@@ -5250,7 +5254,7 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	/* Identify chip attached to board */
 	chipset = rtl8169_get_mac_version(xid, tp->supports_gmii);
 	if (chipset == RTL_GIGA_MAC_NONE) {
-		dev_err(&pdev->dev, "unknown chip XID %03x\n", xid);
+		dev_err(&pdev->dev, "unknown chip XID %03x, contact r8169 maintainers (see MAINTAINERS file)\n", xid);
 		return -ENODEV;
 	}
 
-- 
2.30.0

