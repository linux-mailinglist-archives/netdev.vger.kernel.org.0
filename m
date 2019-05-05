Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9EF713EDE
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 12:34:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727259AbfEEKei (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 06:34:38 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:33089 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725873AbfEEKeh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 06:34:37 -0400
Received: by mail-wr1-f67.google.com with SMTP id e11so378211wrs.0
        for <netdev@vger.kernel.org>; Sun, 05 May 2019 03:34:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7HnSG3ixxwd4HmP0lbVQXBMAx+Y0nYREDJ0QgUs+OrE=;
        b=rDRF5+aNLIshz4fdK8IQVX5RbkbVXgn8AyNUfqNG0YanECe97IrRKaf63jIIN/ZlRt
         TpgokaeqqIxjipDHfX9GZSdX/o3pXIaxOjZdYSJ+IIs6chNUl6hMXtJqix2ZTjBRufOK
         PWXqyd2mI0HVf/keMxiut15l3/rSWd1f+HwIr7JaDfAJMacqP68RHiHS+oPYne8mncNQ
         wobwT0mUTsA067AGs4ZgwyXcH2j8J7+Ccqw4sdGr7/UGLiYR2LkLkFmWBLL8MeJr45eJ
         7yCpUXGyPejJOfryHC3K8ol4TEsOdlCoXd0xJe4g1WZVQhq2h/qNNB4ne4SHuFfihkkc
         Ca7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7HnSG3ixxwd4HmP0lbVQXBMAx+Y0nYREDJ0QgUs+OrE=;
        b=Y/+Z6r/SO8d7WTZ/l7tA8nOoo9r8kUUywEMmPEdi3a/CvuNs51GBFUsGHb7bWC0f28
         WnYZgTI90nkaKAT3F6TLsqF+pj0zTRsxzPIUWcSNu9xWprlD9DpcMn9KZp1WkkR7kl3+
         HIhUboF+E/bqxVYMGn0bHEoY6ueGuHXTWmCnSh3xLigcEzW/4KWwE1n8cPwDItFEcamk
         +tvSfkGw4yrQx4XEig0bF5MhzQUk3KSi27qB/ZTlRJU958cAifIEceI8ijATV/IYHq2P
         U51VFdei19PIGId3H8XCOA9tmc22+X1KEXb0pwYn4XHHkxwLqLvuVeDi64wRc5xrWogA
         0oeA==
X-Gm-Message-State: APjAAAXmC22aE/AtjeYZkQ9sSw5VPEsSba/+h5E+dcl7x4ZTxo30p5Xq
        ypRnNSxf/WbB9/L/j53h0IFckdoQwYM=
X-Google-Smtp-Source: APXvYqzKMeo6IA+RYa6IDb8hD6qrkP76LR4SH4JSu72ay99ccBNAA2hgb3szWDRY0EldEPZh+OS4zg==
X-Received: by 2002:a05:6000:c2:: with SMTP id q2mr3396433wrx.324.1557052475314;
        Sun, 05 May 2019 03:34:35 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bd4:5700:d9a7:917c:8564:c504? (p200300EA8BD45700D9A7917C8564C504.dip0.t-ipconnect.de. [2003:ea:8bd4:5700:d9a7:917c:8564:c504])
        by smtp.googlemail.com with ESMTPSA id n6sm6031928wmn.48.2019.05.05.03.34.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 05 May 2019 03:34:34 -0700 (PDT)
Subject: [PATCH net-next 1/2] r8169: add rtl_set_fifo_size
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <68744103-d101-6c47-b5bd-a3ed383d5798@gmail.com>
Message-ID: <7a9dff9f-1110-8d4e-140d-027c8f5bf465@gmail.com>
Date:   Sun, 5 May 2019 12:33:40 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <68744103-d101-6c47-b5bd-a3ed383d5798@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Based on info from Realtek replace FIFO size config magic with
a function.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169.c | 28 ++++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
index 75c99c392..ed63c98a6 100644
--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -4756,6 +4756,16 @@ static void rtl_hw_aspm_clkreq_enable(struct rtl8169_private *tp, bool enable)
 	udelay(10);
 }
 
+static void rtl_set_fifo_size(struct rtl8169_private *tp, u16 rx_stat,
+			      u16 tx_stat, u16 rx_dyn, u16 tx_dyn)
+{
+	/* Usage of dynamic vs. static FIFO is controlled by bit
+	 * TXCFG_AUTO_FIFO. Exact meaning of FIFO values isn't known.
+	 */
+	rtl_eri_write(tp, 0xc8, ERIAR_MASK_1111, (rx_stat << 16) | rx_dyn);
+	rtl_eri_write(tp, 0xe8, ERIAR_MASK_1111, (tx_stat << 16) | tx_dyn);
+}
+
 static void rtl_hw_start_8168bb(struct rtl8169_private *tp)
 {
 	RTL_W8(tp, Config3, RTL_R8(tp, Config3) & ~Beacon_en);
@@ -4982,8 +4992,7 @@ static void rtl_hw_start_8168e_2(struct rtl8169_private *tp)
 
 	rtl_eri_write(tp, 0xc0, ERIAR_MASK_0011, 0x0000);
 	rtl_eri_write(tp, 0xb8, ERIAR_MASK_0011, 0x0000);
-	rtl_eri_write(tp, 0xc8, ERIAR_MASK_1111, 0x00100002);
-	rtl_eri_write(tp, 0xe8, ERIAR_MASK_1111, 0x00100006);
+	rtl_set_fifo_size(tp, 0x10, 0x10, 0x02, 0x06);
 	rtl_eri_write(tp, 0xcc, ERIAR_MASK_1111, 0x00000050);
 	rtl_eri_write(tp, 0xd0, ERIAR_MASK_1111, 0x07ff0060);
 	rtl_eri_set_bits(tp, 0x1b0, ERIAR_MASK_0001, BIT(4));
@@ -5012,8 +5021,7 @@ static void rtl_hw_start_8168f(struct rtl8169_private *tp)
 
 	rtl_eri_write(tp, 0xc0, ERIAR_MASK_0011, 0x0000);
 	rtl_eri_write(tp, 0xb8, ERIAR_MASK_0011, 0x0000);
-	rtl_eri_write(tp, 0xc8, ERIAR_MASK_1111, 0x00100002);
-	rtl_eri_write(tp, 0xe8, ERIAR_MASK_1111, 0x00100006);
+	rtl_set_fifo_size(tp, 0x10, 0x10, 0x02, 0x06);
 	rtl_reset_packet_filter(tp);
 	rtl_eri_set_bits(tp, 0x1b0, ERIAR_MASK_0001, BIT(4));
 	rtl_eri_set_bits(tp, 0x1d0, ERIAR_MASK_0001, BIT(4));
@@ -5067,10 +5075,9 @@ static void rtl_hw_start_8411(struct rtl8169_private *tp)
 
 static void rtl_hw_start_8168g(struct rtl8169_private *tp)
 {
-	rtl_eri_write(tp, 0xc8, ERIAR_MASK_0101, 0x080002);
+	rtl_set_fifo_size(tp, 0x08, 0x10, 0x02, 0x06);
 	rtl_eri_write(tp, 0xcc, ERIAR_MASK_0001, 0x38);
 	rtl_eri_write(tp, 0xd0, ERIAR_MASK_0001, 0x48);
-	rtl_eri_write(tp, 0xe8, ERIAR_MASK_1111, 0x00100006);
 
 	rtl_set_def_aspm_entry_latency(tp);
 
@@ -5162,10 +5169,9 @@ static void rtl_hw_start_8168h_1(struct rtl8169_private *tp)
 	rtl_hw_aspm_clkreq_enable(tp, false);
 	rtl_ephy_init(tp, e_info_8168h_1);
 
-	rtl_eri_write(tp, 0xc8, ERIAR_MASK_0101, 0x00080002);
+	rtl_set_fifo_size(tp, 0x08, 0x10, 0x02, 0x06);
 	rtl_eri_write(tp, 0xcc, ERIAR_MASK_0001, 0x38);
 	rtl_eri_write(tp, 0xd0, ERIAR_MASK_0001, 0x48);
-	rtl_eri_write(tp, 0xe8, ERIAR_MASK_1111, 0x00100006);
 
 	rtl_set_def_aspm_entry_latency(tp);
 
@@ -5242,10 +5248,9 @@ static void rtl_hw_start_8168ep(struct rtl8169_private *tp)
 {
 	rtl8168ep_stop_cmac(tp);
 
-	rtl_eri_write(tp, 0xc8, ERIAR_MASK_0101, 0x00080002);
+	rtl_set_fifo_size(tp, 0x08, 0x10, 0x02, 0x06);
 	rtl_eri_write(tp, 0xcc, ERIAR_MASK_0001, 0x2f);
 	rtl_eri_write(tp, 0xd0, ERIAR_MASK_0001, 0x5f);
-	rtl_eri_write(tp, 0xe8, ERIAR_MASK_1111, 0x00100006);
 
 	rtl_set_def_aspm_entry_latency(tp);
 
@@ -5445,8 +5450,7 @@ static void rtl_hw_start_8402(struct rtl8169_private *tp)
 
 	rtl_tx_performance_tweak(tp, PCI_EXP_DEVCTL_READRQ_4096B);
 
-	rtl_eri_write(tp, 0xc8, ERIAR_MASK_1111, 0x00000002);
-	rtl_eri_write(tp, 0xe8, ERIAR_MASK_1111, 0x00000006);
+	rtl_set_fifo_size(tp, 0x00, 0x00, 0x02, 0x06);
 	rtl_reset_packet_filter(tp);
 	rtl_eri_write(tp, 0xc0, ERIAR_MASK_0011, 0x0000);
 	rtl_eri_write(tp, 0xb8, ERIAR_MASK_0011, 0x0000);
-- 
2.21.0


