Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 521812A6A7
	for <lists+netdev@lfdr.de>; Sat, 25 May 2019 20:57:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727196AbfEYS5u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 May 2019 14:57:50 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:40697 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726343AbfEYS5u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 May 2019 14:57:50 -0400
Received: by mail-wm1-f67.google.com with SMTP id 15so12099938wmg.5
        for <netdev@vger.kernel.org>; Sat, 25 May 2019 11:57:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=nhDr/+pv7qLlrKMuQ84kiF6ULJaq9JthdEesTy9k5sQ=;
        b=C9qtzC1+wi9pKpfmJFUvHA0vTICG6by94EBsphHWtw/jFe6ho0U8Gp+8JqRQ9lbTsY
         rTEFlvsJK6LxPjuSZczwhe25hHoldd2kZrx6xMP8kLgqwcEsT49kBAYhX7lcyQraZeCe
         UVLjg89sMQVVou26+u67Dxe5Oi5KDRWWOSufaomIlrezSqVlSKPggG5UOc3JVZx9S6o0
         aLZLB7I+56+0OFOVFlAhkAi8DjVDGXL/PZzcLu9ejYjia844uW2f9FyAA/hejaMkI7GY
         p9x7r2XDhN63vOCi+mcJoU/5FNPlhMRmPJtU5VuG+r0ieme8bxr6177oBJJXR6b8vvzS
         E7yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=nhDr/+pv7qLlrKMuQ84kiF6ULJaq9JthdEesTy9k5sQ=;
        b=VtOragKgwq4yL+O5MaCpDASLhYhZ9LIZ6zXBQKaszaM9+t5LRqLa9WskFdFeBU/9ms
         HTwonXtofWUpLRXjtBt7lA+lWjQtm1mcKHHVRiaPt2LgYv66hKiThuPH6JW+quxEMpJE
         WvODNXP8rWOTkozFroslXBWTqrpSpjSVJwAoVh5Gs2PmXGWeh9j4TerbqsperadTz7nV
         ZQjJIDE9BYggG2aehmj78HraQhjvKYuNVIAf2FNwBLHSWoziQsVogcH90ukycv6bIteo
         6MpvlpX0l8nT342JSCOq8YTAy8USsrOH2NdMChRuPVbtP69rDmdBjbPSVQM0mghTrls0
         64/Q==
X-Gm-Message-State: APjAAAWL2gINftbp7SpI6UJUt7zfUvdvwnwsbwEH2W86ab0Rl67mN5X5
        ogzoOUEM2y176Qc4aLmstpcV+GXk
X-Google-Smtp-Source: APXvYqxQBbxAZpZRDVg74Kcrs2THsMgY7NxKp20Vw6y97rj1xSERyTy9WAD0m/lwD1IzJW+72nqsNA==
X-Received: by 2002:a1c:e718:: with SMTP id e24mr4306659wmh.27.1558810667240;
        Sat, 25 May 2019 11:57:47 -0700 (PDT)
Received: from ?IPv6:2003:ea:8be9:7a00:74ed:7635:d853:6c47? (p200300EA8BE97A0074ED7635D8536C47.dip0.t-ipconnect.de. [2003:ea:8be9:7a00:74ed:7635:d853:6c47])
        by smtp.googlemail.com with ESMTPSA id l13sm5490621wme.37.2019.05.25.11.57.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 25 May 2019 11:57:46 -0700 (PDT)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] r8169: improve RTL8168d PHY initialization
Message-ID: <a0697e71-d695-19af-974d-56e53cb1a3a0@gmail.com>
Date:   Sat, 25 May 2019 20:57:42 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Certain parts of the PHY initialization are the same for sub versions
1 and 2 of RTL8168d. So let's factor this out to simplify the code.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169.c | 153 +++++++++------------------
 1 file changed, 52 insertions(+), 101 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
index 1a6b50c3f..940ff0898 100644
--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -2910,50 +2910,59 @@ static void rtl8168c_4_hw_phy_config(struct rtl8169_private *tp)
 	rtl8168c_3_hw_phy_config(tp);
 }
 
-static void rtl8168d_1_hw_phy_config(struct rtl8169_private *tp)
-{
-	static const struct phy_reg phy_reg_init_0[] = {
-		/* Channel Estimation */
-		{ 0x1f, 0x0001 },
-		{ 0x06, 0x4064 },
-		{ 0x07, 0x2863 },
-		{ 0x08, 0x059c },
-		{ 0x09, 0x26b4 },
-		{ 0x0a, 0x6a19 },
-		{ 0x0b, 0xdcc8 },
-		{ 0x10, 0xf06d },
-		{ 0x14, 0x7f68 },
-		{ 0x18, 0x7fd9 },
-		{ 0x1c, 0xf0ff },
-		{ 0x1d, 0x3d9c },
-		{ 0x1f, 0x0003 },
-		{ 0x12, 0xf49f },
-		{ 0x13, 0x070b },
-		{ 0x1a, 0x05ad },
-		{ 0x14, 0x94c0 },
+static const struct phy_reg rtl8168d_1_phy_reg_init_0[] = {
+	/* Channel Estimation */
+	{ 0x1f, 0x0001 },
+	{ 0x06, 0x4064 },
+	{ 0x07, 0x2863 },
+	{ 0x08, 0x059c },
+	{ 0x09, 0x26b4 },
+	{ 0x0a, 0x6a19 },
+	{ 0x0b, 0xdcc8 },
+	{ 0x10, 0xf06d },
+	{ 0x14, 0x7f68 },
+	{ 0x18, 0x7fd9 },
+	{ 0x1c, 0xf0ff },
+	{ 0x1d, 0x3d9c },
+	{ 0x1f, 0x0003 },
+	{ 0x12, 0xf49f },
+	{ 0x13, 0x070b },
+	{ 0x1a, 0x05ad },
+	{ 0x14, 0x94c0 },
 
-		/*
-		 * Tx Error Issue
-		 * Enhance line driver power
-		 */
-		{ 0x1f, 0x0002 },
-		{ 0x06, 0x5561 },
-		{ 0x1f, 0x0005 },
-		{ 0x05, 0x8332 },
-		{ 0x06, 0x5561 },
+	/*
+	 * Tx Error Issue
+	 * Enhance line driver power
+	 */
+	{ 0x1f, 0x0002 },
+	{ 0x06, 0x5561 },
+	{ 0x1f, 0x0005 },
+	{ 0x05, 0x8332 },
+	{ 0x06, 0x5561 },
 
-		/*
-		 * Can not link to 1Gbps with bad cable
-		 * Decrease SNR threshold form 21.07dB to 19.04dB
-		 */
-		{ 0x1f, 0x0001 },
-		{ 0x17, 0x0cc0 },
+	/*
+	 * Can not link to 1Gbps with bad cable
+	 * Decrease SNR threshold form 21.07dB to 19.04dB
+	 */
+	{ 0x1f, 0x0001 },
+	{ 0x17, 0x0cc0 },
 
-		{ 0x1f, 0x0000 },
-		{ 0x0d, 0xf880 }
-	};
+	{ 0x1f, 0x0000 },
+	{ 0x0d, 0xf880 }
+};
 
-	rtl_writephy_batch(tp, phy_reg_init_0);
+static const struct phy_reg rtl8168d_1_phy_reg_init_1[] = {
+	{ 0x1f, 0x0002 },
+	{ 0x05, 0x669a },
+	{ 0x1f, 0x0005 },
+	{ 0x05, 0x8330 },
+	{ 0x06, 0x669a },
+	{ 0x1f, 0x0002 }
+};
+
+static void rtl8168d_1_hw_phy_config(struct rtl8169_private *tp)
+{
+	rtl_writephy_batch(tp, rtl8168d_1_phy_reg_init_0);
 
 	/*
 	 * Rx Error Issue
@@ -2964,17 +2973,9 @@ static void rtl8168d_1_hw_phy_config(struct rtl8169_private *tp)
 	rtl_w0w1_phy(tp, 0x0c, 0xa200, 0x5d00);
 
 	if (rtl8168d_efuse_read(tp, 0x01) == 0xb1) {
-		static const struct phy_reg phy_reg_init[] = {
-			{ 0x1f, 0x0002 },
-			{ 0x05, 0x669a },
-			{ 0x1f, 0x0005 },
-			{ 0x05, 0x8330 },
-			{ 0x06, 0x669a },
-			{ 0x1f, 0x0002 }
-		};
 		int val;
 
-		rtl_writephy_batch(tp, phy_reg_init);
+		rtl_writephy_batch(tp, rtl8168d_1_phy_reg_init_1);
 
 		val = rtl_readphy(tp, 0x0d);
 
@@ -3023,62 +3024,12 @@ static void rtl8168d_1_hw_phy_config(struct rtl8169_private *tp)
 
 static void rtl8168d_2_hw_phy_config(struct rtl8169_private *tp)
 {
-	static const struct phy_reg phy_reg_init_0[] = {
-		/* Channel Estimation */
-		{ 0x1f, 0x0001 },
-		{ 0x06, 0x4064 },
-		{ 0x07, 0x2863 },
-		{ 0x08, 0x059c },
-		{ 0x09, 0x26b4 },
-		{ 0x0a, 0x6a19 },
-		{ 0x0b, 0xdcc8 },
-		{ 0x10, 0xf06d },
-		{ 0x14, 0x7f68 },
-		{ 0x18, 0x7fd9 },
-		{ 0x1c, 0xf0ff },
-		{ 0x1d, 0x3d9c },
-		{ 0x1f, 0x0003 },
-		{ 0x12, 0xf49f },
-		{ 0x13, 0x070b },
-		{ 0x1a, 0x05ad },
-		{ 0x14, 0x94c0 },
-
-		/*
-		 * Tx Error Issue
-		 * Enhance line driver power
-		 */
-		{ 0x1f, 0x0002 },
-		{ 0x06, 0x5561 },
-		{ 0x1f, 0x0005 },
-		{ 0x05, 0x8332 },
-		{ 0x06, 0x5561 },
-
-		/*
-		 * Can not link to 1Gbps with bad cable
-		 * Decrease SNR threshold form 21.07dB to 19.04dB
-		 */
-		{ 0x1f, 0x0001 },
-		{ 0x17, 0x0cc0 },
-
-		{ 0x1f, 0x0000 },
-		{ 0x0d, 0xf880 }
-	};
-
-	rtl_writephy_batch(tp, phy_reg_init_0);
+	rtl_writephy_batch(tp, rtl8168d_1_phy_reg_init_0);
 
 	if (rtl8168d_efuse_read(tp, 0x01) == 0xb1) {
-		static const struct phy_reg phy_reg_init[] = {
-			{ 0x1f, 0x0002 },
-			{ 0x05, 0x669a },
-			{ 0x1f, 0x0005 },
-			{ 0x05, 0x8330 },
-			{ 0x06, 0x669a },
-
-			{ 0x1f, 0x0002 }
-		};
 		int val;
 
-		rtl_writephy_batch(tp, phy_reg_init);
+		rtl_writephy_batch(tp, rtl8168d_1_phy_reg_init_1);
 
 		val = rtl_readphy(tp, 0x0d);
 		if ((val & 0x00ff) != 0x006c) {
-- 
2.21.0

