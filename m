Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E791B7783E
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 12:45:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728165AbfG0KpS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jul 2019 06:45:18 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:51992 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725975AbfG0KpR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jul 2019 06:45:17 -0400
Received: by mail-wm1-f66.google.com with SMTP id 207so49946107wma.1
        for <netdev@vger.kernel.org>; Sat, 27 Jul 2019 03:45:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=flPq+/YQ1uqvVszpeAz/m9awgfW+msXaKhravDEcd1s=;
        b=i1hPeW+rhRhNftuS0VzMLoKDGP4DMynKqbRXYK5abNggVid9oh1m3d4fHOFuXdSv2R
         m5/TfKRkwWZbQZNXOkPnHoIJEcUBfM2NuMk7XsrBrNTTpyhBHp1rtMBsfJ+UfEh399k+
         hOLDp/KXPfckTydVmoXcODzgQlT8Xq6AGVu+o2zLqvaQjzjzMfrIFPkocYqr/661qyhZ
         etqlsLd4PjH0XDeHmKp2R6h6xx2SojWtfvvu7ruKx3iSrhGk8FfT0UoFerdZqS1PRtVH
         kDRFlV1uauC/9jcCbaVmThb2KFg2xwdUgN0jASLwG5YEWUPkl9Ku0rM0+Hp01dEFknL1
         cGBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=flPq+/YQ1uqvVszpeAz/m9awgfW+msXaKhravDEcd1s=;
        b=R55601wgZqW/joEbYVK+pjoCe1Y0qxoRmLi4oReNCdg7zhZe7Kh3hUivueUXs9dYAe
         GqccmV0qooe/WvgEtdnFE8T2a1YV6rJlvoJILyTU21kXRc+wGel/lL4Azb55TjhDCwIV
         PI7zDRoOcVBYUCOZmL8Vk6/LCmp8Vhey06YzGxNxDydGRDWYvt+X4GiAF37xnFsgmK63
         atMO45jpSoF7bBp9NEzFMOBEWU+poQKdaIgFG4Ull9uX5wgccI/LIyl4C9IjyoEtDW8Q
         8jv3U8BbolfyTXO33Jc0qFQQwjxATRPIia2kRM7agoO5EvgYOhW57YyaUwIKsqe+VhIZ
         8Zfg==
X-Gm-Message-State: APjAAAVDsGBwZFmxcd164dyAUtPxWhAevz1JFNI5f6C150gQMTGVeFSS
        L4Re1jf53H2RaXHrgtydufI=
X-Google-Smtp-Source: APXvYqwF2p1V96aaer1pWoVR5+8+oVksX86CNoSrzxW2zj4YO8iWYhSXS4RxmJFZeNGzhWrPtXLCTg==
X-Received: by 2002:a1c:5453:: with SMTP id p19mr83615073wmi.148.1564224315579;
        Sat, 27 Jul 2019 03:45:15 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f43:4200:c0a4:381:9a20:d2e8? (p200300EA8F434200C0A403819A20D2E8.dip0.t-ipconnect.de. [2003:ea:8f43:4200:c0a4:381:9a20:d2e8])
        by smtp.googlemail.com with ESMTPSA id w23sm57612537wmi.45.2019.07.27.03.45.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 27 Jul 2019 03:45:14 -0700 (PDT)
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net] r8169: don't use MSI before RTL8168d
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        =?UTF-8?B?RHXFoWFuIERyYWdpxIc=?= <dragic.dusan@gmail.com>
Message-ID: <97eb41db-f9a1-47ce-81c6-10f6c8572a73@gmail.com>
Date:   Sat, 27 Jul 2019 12:45:10 +0200
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
This version of the fix applies on kernel versions up to 5.2.
---
 drivers/net/ethernet/realtek/r8169.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
index 6d176be51..038a034ee 100644
--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -7105,13 +7105,18 @@ static int rtl_alloc_irq(struct rtl8169_private *tp)
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

