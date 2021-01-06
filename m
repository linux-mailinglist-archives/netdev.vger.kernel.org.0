Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D8EE2EBCB1
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 11:51:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726359AbhAFKuk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 05:50:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725925AbhAFKuj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 05:50:39 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CC9EC06134C
        for <netdev@vger.kernel.org>; Wed,  6 Jan 2021 02:49:59 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id g185so2229630wmf.3
        for <netdev@vger.kernel.org>; Wed, 06 Jan 2021 02:49:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sv8+etW+yK2uhdrudJJQBqucmERfPpVDUieqOwNOibc=;
        b=iaD6IW6J+80GrIbKbJ1yJ9XAQ0mNArIsnYcq/uQoION6zsGCrx1dt4iJqmJdVs/9T0
         BmWsW35Kxm6JZjw4/8fQUa75CTqEm3wXBmflmIm2MO9MYKJxG7wkmt7kV1bcfZSEOeDJ
         QutWqhJ/bPb082g03SLi5Qhn1Z7x08sL3RhgZCq27hvr25BDiti5C3aCIOq5i9rAO+ct
         Q+Pc7kWfd6mvI23O7E5Tu2aACYjwCj5khqjgUJGIBrxFOh038HledO33A5V7UDy0EVOa
         OMDLmqKMAaNRYL4qB+KZDdjpSXRzyP/iXdhoHggfIFD2UC2Qeq5kEXDskGykRBeX7NOJ
         7OOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sv8+etW+yK2uhdrudJJQBqucmERfPpVDUieqOwNOibc=;
        b=MB5d4I29fqdJ5J4KXz3t9vNvMM8uBG6JrT0xWLs0vqBxX+witmmoLXWmYwqXDSyKKa
         7nXqlCqN7MQDbOxiA0qaNmgYaHAaNBxldmg/G1g2NE6yXlaZQh98a9XMOboZ1pvSkMNG
         J13nNCqQv2EnS2wWQJWbBSaldGWYanKLCBWY8Yh9hwFePWFNvoY6dkHDqouvi2ViRBvH
         Q3c4g1ORQvPGscK3cpAnnmwg1VMnp0gW1TMgJbvTGbmmtSSMFR6fDD4lOIMu+XQZ8vGR
         uUvIGGV30Lmwf5R2HYRAvIuo+4iG2xzT46cOTS719WzgtqIO43kOR3kwN1ShiMl71TyI
         0Tpg==
X-Gm-Message-State: AOAM531MezsBxIbrsEuZ/C4FXclL8O6j28Yt57JnbLzY7aWkrpUeYJD5
        GG0ud4ZHLjvA8tNCbRb0rBvNiK+Viz8=
X-Google-Smtp-Source: ABdhPJyobVlQRKc77fS+h+njEdK+xXYYu3ZHkPGeVollLVu1s3wcRYeuy5mTusIU1oaC9Dlp03Kzeg==
X-Received: by 2002:a7b:cb9a:: with SMTP id m26mr3130244wmi.130.1609930197724;
        Wed, 06 Jan 2021 02:49:57 -0800 (PST)
Received: from ?IPv6:2003:ea:8f06:5500:e1db:b990:7e09:f1cf? (p200300ea8f065500e1dbb9907e09f1cf.dip0.t-ipconnect.de. [2003:ea:8f06:5500:e1db:b990:7e09:f1cf])
        by smtp.googlemail.com with ESMTPSA id l20sm2685912wrh.82.2021.01.06.02.49.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Jan 2021 02:49:57 -0800 (PST)
Subject: [PATCH net-next 1/2] r8169: move ERI access functions to avoid
 forward declaration
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <9303c2cf-c521-beea-c09f-63b5dfa91b9c@gmail.com>
Message-ID: <ba36dff0-b20c-1987-d417-99a0c2fcc901@gmail.com>
Date:   Wed, 6 Jan 2021 11:47:08 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <9303c2cf-c521-beea-c09f-63b5dfa91b9c@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

No functional change here. We just move a code block to avoid a
function forward declaration in a subsequent change.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 128 +++++++++++-----------
 1 file changed, 64 insertions(+), 64 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index a569abe7f..dd56f33b2 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -746,6 +746,70 @@ static const struct rtl_cond name = {			\
 							\
 static bool name ## _check(struct rtl8169_private *tp)
 
+static void r8168fp_adjust_ocp_cmd(struct rtl8169_private *tp, u32 *cmd, int type)
+{
+	/* based on RTL8168FP_OOBMAC_BASE in vendor driver */
+	if (tp->mac_version == RTL_GIGA_MAC_VER_52 && type == ERIAR_OOB)
+		*cmd |= 0x7f0 << 18;
+}
+
+DECLARE_RTL_COND(rtl_eriar_cond)
+{
+	return RTL_R32(tp, ERIAR) & ERIAR_FLAG;
+}
+
+static void _rtl_eri_write(struct rtl8169_private *tp, int addr, u32 mask,
+			   u32 val, int type)
+{
+	u32 cmd = ERIAR_WRITE_CMD | type | mask | addr;
+
+	BUG_ON((addr & 3) || (mask == 0));
+	RTL_W32(tp, ERIDR, val);
+	r8168fp_adjust_ocp_cmd(tp, &cmd, type);
+	RTL_W32(tp, ERIAR, cmd);
+
+	rtl_loop_wait_low(tp, &rtl_eriar_cond, 100, 100);
+}
+
+static void rtl_eri_write(struct rtl8169_private *tp, int addr, u32 mask,
+			  u32 val)
+{
+	_rtl_eri_write(tp, addr, mask, val, ERIAR_EXGMAC);
+}
+
+static u32 _rtl_eri_read(struct rtl8169_private *tp, int addr, int type)
+{
+	u32 cmd = ERIAR_READ_CMD | type | ERIAR_MASK_1111 | addr;
+
+	r8168fp_adjust_ocp_cmd(tp, &cmd, type);
+	RTL_W32(tp, ERIAR, cmd);
+
+	return rtl_loop_wait_high(tp, &rtl_eriar_cond, 100, 100) ?
+		RTL_R32(tp, ERIDR) : ~0;
+}
+
+static u32 rtl_eri_read(struct rtl8169_private *tp, int addr)
+{
+	return _rtl_eri_read(tp, addr, ERIAR_EXGMAC);
+}
+
+static void rtl_w0w1_eri(struct rtl8169_private *tp, int addr, u32 p, u32 m)
+{
+	u32 val = rtl_eri_read(tp, addr);
+
+	rtl_eri_write(tp, addr, ERIAR_MASK_1111, (val & ~m) | p);
+}
+
+static void rtl_eri_set_bits(struct rtl8169_private *tp, int addr, u32 p)
+{
+	rtl_w0w1_eri(tp, addr, p, 0);
+}
+
+static void rtl_eri_clear_bits(struct rtl8169_private *tp, int addr, u32 m)
+{
+	rtl_w0w1_eri(tp, addr, 0, m);
+}
+
 static bool rtl_ocp_reg_failure(struct rtl8169_private *tp, u32 reg)
 {
 	if (reg & 0xffff0001) {
@@ -1009,70 +1073,6 @@ static u16 rtl_ephy_read(struct rtl8169_private *tp, int reg_addr)
 		RTL_R32(tp, EPHYAR) & EPHYAR_DATA_MASK : ~0;
 }
 
-static void r8168fp_adjust_ocp_cmd(struct rtl8169_private *tp, u32 *cmd, int type)
-{
-	/* based on RTL8168FP_OOBMAC_BASE in vendor driver */
-	if (tp->mac_version == RTL_GIGA_MAC_VER_52 && type == ERIAR_OOB)
-		*cmd |= 0x7f0 << 18;
-}
-
-DECLARE_RTL_COND(rtl_eriar_cond)
-{
-	return RTL_R32(tp, ERIAR) & ERIAR_FLAG;
-}
-
-static void _rtl_eri_write(struct rtl8169_private *tp, int addr, u32 mask,
-			   u32 val, int type)
-{
-	u32 cmd = ERIAR_WRITE_CMD | type | mask | addr;
-
-	BUG_ON((addr & 3) || (mask == 0));
-	RTL_W32(tp, ERIDR, val);
-	r8168fp_adjust_ocp_cmd(tp, &cmd, type);
-	RTL_W32(tp, ERIAR, cmd);
-
-	rtl_loop_wait_low(tp, &rtl_eriar_cond, 100, 100);
-}
-
-static void rtl_eri_write(struct rtl8169_private *tp, int addr, u32 mask,
-			  u32 val)
-{
-	_rtl_eri_write(tp, addr, mask, val, ERIAR_EXGMAC);
-}
-
-static u32 _rtl_eri_read(struct rtl8169_private *tp, int addr, int type)
-{
-	u32 cmd = ERIAR_READ_CMD | type | ERIAR_MASK_1111 | addr;
-
-	r8168fp_adjust_ocp_cmd(tp, &cmd, type);
-	RTL_W32(tp, ERIAR, cmd);
-
-	return rtl_loop_wait_high(tp, &rtl_eriar_cond, 100, 100) ?
-		RTL_R32(tp, ERIDR) : ~0;
-}
-
-static u32 rtl_eri_read(struct rtl8169_private *tp, int addr)
-{
-	return _rtl_eri_read(tp, addr, ERIAR_EXGMAC);
-}
-
-static void rtl_w0w1_eri(struct rtl8169_private *tp, int addr, u32 p, u32 m)
-{
-	u32 val = rtl_eri_read(tp, addr);
-
-	rtl_eri_write(tp, addr, ERIAR_MASK_1111, (val & ~m) | p);
-}
-
-static void rtl_eri_set_bits(struct rtl8169_private *tp, int addr, u32 p)
-{
-	rtl_w0w1_eri(tp, addr, p, 0);
-}
-
-static void rtl_eri_clear_bits(struct rtl8169_private *tp, int addr, u32 m)
-{
-	rtl_w0w1_eri(tp, addr, 0, m);
-}
-
 static u32 r8168dp_ocp_read(struct rtl8169_private *tp, u16 reg)
 {
 	RTL_W32(tp, OCPAR, 0x0fu << 12 | (reg & 0x0fff));
-- 
2.30.0


