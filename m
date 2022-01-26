Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8418D49D2B2
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 20:50:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244491AbiAZTuJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 14:50:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231869AbiAZTuI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 14:50:08 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72646C06161C
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 11:50:08 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id s9so872846wrb.6
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 11:50:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:to:cc:content-language
         :subject:content-transfer-encoding;
        bh=zRsPZ66OIEM8bA8LRSqMDZyU2k0C7Et+pBVkEyHVvQE=;
        b=LzfqDM+hFymLyvUWzQGARd38WtF5Zg5/SY7S/M0k5hWMb5JxHZauXnFxHMNUJYapV0
         PVXN8JPdA0nsyum3vjgYeNbPirWQfFOrQshpSSjyCV4wXieG13zx3Eq67OtyTcAkL17I
         eqBfRguJWwR/miZm/z+/Mlr2LEL4keVvRu150qpmaKFPd/kSLRqDEcWpMk4rPWKhU712
         ZCk6OXfdQPXRixAJoVGL9s8ayphjwA/zT3n00X1Tq2ZVErwfCsfuxEZLotvYaBeSFaxe
         HD9L1Mbgfjf1QRgIue9DPA9oeBEpAXmrNDuQdYL3RMVccz1l3oeaED3PvGZGrZ8TI38B
         SMXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from:to
         :cc:content-language:subject:content-transfer-encoding;
        bh=zRsPZ66OIEM8bA8LRSqMDZyU2k0C7Et+pBVkEyHVvQE=;
        b=Hr1iCJSI9HFoJMuO4F6NS04kB/dQRNjf2nrKJDvUuHkEwQvEDrlchRNRGpdhAgeIL5
         iMzjVqhh5M835vb+j17ceayjzdydQZ61rQo2JKuyesZjsboD6d/qFC+bN5abVnO3U7n1
         FMN8Bul18+sD0pB0iJ41VV4tisdBM6bqYwOugI2KMiHoc7Whj7IQ4IfomxDl/juY5PUs
         q0kzccu8yDo9azV6Jfuc6ukfKy9EHn++5oU6Qv+C8dnBt+goitsKPi04ycN2do1GFt3/
         Wi2btk0nQvsw9NzFsoH5Lv//nHqcQJ07opIY9gNk1eeI8pK/lJLdQ7IwHLFhldlizk1e
         7wOg==
X-Gm-Message-State: AOAM533FMQvssF5pznr4ZhXaaWf/CJ5D15/DhNJxB+20Ya5LFEreLvl0
        TqHM/LmbWJDYmlH7fP6H4Aw=
X-Google-Smtp-Source: ABdhPJxzIVid8eVfjfq5sctarsfJsJ4imNblgeSB91hDuNDgI9IaGmGxFvhH0kuAUx+OJvHvkbR2Ow==
X-Received: by 2002:a5d:438a:: with SMTP id i10mr95670wrq.295.1643226606806;
        Wed, 26 Jan 2022 11:50:06 -0800 (PST)
Received: from ?IPV6:2003:ea:8f4d:2b00:4959:c362:fa9a:b656? (p200300ea8f4d2b004959c362fa9ab656.dip0.t-ipconnect.de. [2003:ea:8f4d:2b00:4959:c362:fa9a:b656])
        by smtp.googlemail.com with ESMTPSA id n10sm3907102wmr.25.2022.01.26.11.50.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Jan 2022 11:50:06 -0800 (PST)
Message-ID: <6885d6db-fbd8-a13a-3315-209ad9562c0e@gmail.com>
Date:   Wed, 26 Jan 2022 20:49:59 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Chun-Hao Lin <hau@realtek.com>
Content-Language: en-US
Subject: [PATCH net-next] r8169: enable ASPM L1.2 if system vendor flags it as
 safe
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On some systems there are compatibility issues with ASPM L1.2 and
RTL8125, therefore this state is disabled per default. To allow for
the L1.2 power saving on not affected systems, Realtek provides
vendors that successfully tested ASPM L1.2 the option to flag this
state as safe. According to Realtek this flag will be set first on
certain Chromebox devices.

Suggested-by: Chun-Hao Lin <hau@realtek.com>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 33 ++++++++++++++++++++++-
 1 file changed, 32 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index ca95e9266..3c3d1506b 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -2684,7 +2684,26 @@ static void rtl_hw_aspm_clkreq_enable(struct rtl8169_private *tp, bool enable)
 	if (enable && tp->aspm_manageable) {
 		RTL_W8(tp, Config5, RTL_R8(tp, Config5) | ASPM_en);
 		RTL_W8(tp, Config2, RTL_R8(tp, Config2) | ClkReqEn);
+
+		switch (tp->mac_version) {
+		case RTL_GIGA_MAC_VER_60 ... RTL_GIGA_MAC_VER_63:
+			/* reset ephy tx/rx disable timer */
+			r8168_mac_ocp_modify(tp, 0xe094, 0xff00, 0);
+			/* chip can trigger L1.2 */
+			r8168_mac_ocp_modify(tp, 0xe092, 0x00ff, BIT(2));
+			break;
+		default:
+			break;
+		}
 	} else {
+		switch (tp->mac_version) {
+		case RTL_GIGA_MAC_VER_60 ... RTL_GIGA_MAC_VER_63:
+			r8168_mac_ocp_modify(tp, 0xe092, 0x00ff, 0);
+			break;
+		default:
+			break;
+		}
+
 		RTL_W8(tp, Config2, RTL_R8(tp, Config2) & ~ClkReqEn);
 		RTL_W8(tp, Config5, RTL_R8(tp, Config5) & ~ASPM_en);
 	}
@@ -5251,6 +5270,16 @@ static void rtl_init_mac_address(struct rtl8169_private *tp)
 	rtl_rar_set(tp, mac_addr);
 }
 
+/* register is set if system vendor successfully tested ASPM 1.2 */
+static bool rtl_aspm_is_safe(struct rtl8169_private *tp)
+{
+	if (tp->mac_version >= RTL_GIGA_MAC_VER_60 &&
+	    r8168_mac_ocp_read(tp, 0xc0b2) & 0xf)
+		return true;
+
+	return false;
+}
+
 static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	struct rtl8169_private *tp;
@@ -5329,7 +5358,9 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	 * Chips from RTL8168h partially have issues with L1.2, but seem
 	 * to work fine with L1 and L1.1.
 	 */
-	if (tp->mac_version >= RTL_GIGA_MAC_VER_45)
+	if (rtl_aspm_is_safe(tp))
+		rc = 0;
+	else if (tp->mac_version >= RTL_GIGA_MAC_VER_45)
 		rc = pci_disable_link_state(pdev, PCIE_LINK_STATE_L1_2);
 	else
 		rc = pci_disable_link_state(pdev, PCIE_LINK_STATE_L1);
-- 
2.35.0

