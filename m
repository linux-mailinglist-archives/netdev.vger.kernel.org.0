Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22E437783A
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 12:43:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728724AbfG0Knj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jul 2019 06:43:39 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:39638 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725975AbfG0Knj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jul 2019 06:43:39 -0400
Received: by mail-wm1-f66.google.com with SMTP id u25so39233209wmc.4
        for <netdev@vger.kernel.org>; Sat, 27 Jul 2019 03:43:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=yEyllR/cK1KkKTiZwvL1bzPkU4LAp7OhdY6j7BrLlzs=;
        b=dC1ma82hX7Oguz53yC7mf3dTB+dXN4BdPUt6q4lwC3r0lH5myX89jlUa0ZAYaOtwhZ
         n6/EKCzvndt228EzPykzsCeaJocRTUmgk5E3msMYSMB0xpJtFpvK+bZz8Z4reRqJr4nJ
         s5+Yw9IwEILmU2xC4+boNKXTd8P7rk/ZdzbKcJkENnhVB2Gk6oLC8B2qWmFGOEMGpFTI
         FK/Pvqt1xCeYze0dJ3UHK4eBLF6R5exIwp8A7JhyJwVvDZ2V+gJDWGgzdVkR5jyWjUKv
         9Sn7iXC8gUUwzx+1E2ObeListaUl30v1fHyHgcsVLTHqQY1UhhmENn19HWKq2uaZzBGj
         ovBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=yEyllR/cK1KkKTiZwvL1bzPkU4LAp7OhdY6j7BrLlzs=;
        b=uNpVN0teayo4m0toxO6dPmKWeNgj9PTAcSKlbmUmgeRv9J4zgn++7KfJm/tbSnj6L2
         4ghghK1KIGbdQd1yeBQNGZVvKHfiPrgH3iQMjA4elWPmZsFz4K6Frq5s0US7MNvxO0d9
         PTi4ewirOwV96vMTCWrXXyJB0m6LEh3TXZRilSbjbRmOE1fs82Jh/6WA0c4eVl9/S6d1
         lCSNA+sXM672kY7pb2B3CfpmxBIdTnJq56CdFXYJ3YxNUdEKH01AFyj8DIMV0p3fGeuG
         Q4kEn5NCI1AJTLdV0eFCT/lusw7Vqnd6NBtKjJT0xkpKMdNxO8DKjdXAWb18rrQ1jLfP
         ds6g==
X-Gm-Message-State: APjAAAWd1Q3XCnNZMcT945OlcIQcScgO2zvwiZotlCXvneNlvoFVmX2j
        lqjMglrQQhxPNWvaNZO4k/c=
X-Google-Smtp-Source: APXvYqx+kkYqBUJrkSgGVFeQjnzdP16sNngeH+wJ4ThShBaqFg/kWnVGzzBtOIpVA/yOWQ4ulvnpLg==
X-Received: by 2002:a7b:cbcb:: with SMTP id n11mr87031355wmi.54.1564224216914;
        Sat, 27 Jul 2019 03:43:36 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f43:4200:c0a4:381:9a20:d2e8? (p200300EA8F434200C0A403819A20D2E8.dip0.t-ipconnect.de. [2003:ea:8f43:4200:c0a4:381:9a20:d2e8])
        by smtp.googlemail.com with ESMTPSA id c11sm93583362wrq.45.2019.07.27.03.43.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 27 Jul 2019 03:43:36 -0700 (PDT)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        =?UTF-8?B?RHXFoWFuIERyYWdpxIc=?= <dragic.dusan@gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net] r8169: don't use MSI before RTL8168d
Message-ID: <c9f89cfc-ec16-62dc-a975-1b614941e723@gmail.com>
Date:   Sat, 27 Jul 2019 12:43:31 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It was reported that after resuming from suspend network fails with
error "do_IRQ: 3.38 No irq handler for vector", see [0]. Enabling WoL
can work around the issue, but the only actual fix is to disable MSI.
So let's mimic the behavior of the vendor driver and disable MSI on
all chip versions before RTL8168d.

[0] https://bugzilla.kernel.org/show_bug.cgi?id=204079

Fixes: 6c6aa15fdea5 ("r8169: improve interrupt handling")
Reported-by: Dušan Dragić <dragic.dusan@gmail.com>
Tested-by: Dušan Dragić <dragic.dusan@gmail.com>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
This version of the fix applies from 5.3 only. I'll submit a separate
version for previous kernel versions.
---
 drivers/net/ethernet/realtek/r8169_main.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index a71dd669a..e1dd6ea60 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -6586,13 +6586,18 @@ static int rtl_alloc_irq(struct rtl8169_private *tp)
 {
 	unsigned int flags;
 
-	if (tp->mac_version <= RTL_GIGA_MAC_VER_06) {
+	switch (tp->mac_version) {
+	case RTL_GIGA_MAC_VER_02 ... RTL_GIGA_MAC_VER_06:
 		rtl_unlock_config_regs(tp);
 		RTL_W8(tp, Config2, RTL_R8(tp, Config2) & ~MSIEnable);
 		rtl_lock_config_regs(tp);
+		/* fall through */
+	case RTL_GIGA_MAC_VER_07 ... RTL_GIGA_MAC_VER_24:
 		flags = PCI_IRQ_LEGACY;
-	} else {
+		break;
+	default:
 		flags = PCI_IRQ_ALL_TYPES;
+		break;
 	}
 
 	return pci_alloc_irq_vectors(tp->pci_dev, 1, 1, flags);
-- 
2.22.0

