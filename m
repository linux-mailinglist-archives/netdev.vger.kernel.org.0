Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3779AA0B7C
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 22:29:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726820AbfH1U30 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 16:29:26 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:37324 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726315AbfH1U30 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 16:29:26 -0400
Received: by mail-wr1-f68.google.com with SMTP id z11so1118532wrt.4
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 13:29:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=AOgz7Tb91jUSRfZhoxyhI620yzpgzcGdmZwJVxUTKMQ=;
        b=W3V3DXPtbO4dqOvUrsKDbn/cmoUu6eMQtYyMaBwVhg5sQ5Tu3vikqlFJCA4ep0Cb6g
         QFHnpBT2Olr9XNO+6HJk9HDsUYt4LL3RkZ+/EVs+8tMOmqpuDeGC1SJN9rU318cQFnsm
         UakHxOn5g1m7wtZGYTGEXcud6bLOcZSP1tlxyLmfjI7XEEIn2hUY/YM3btlfb7PxQ9L8
         m0QVbpLcQ7+8DzfKoUVagp1FqqH6HdgFyFBXeq0KGK9gXdRPmBOjxU4+xCHO+NA0LKs8
         auNisfN03nlaepzTvNxR3cEiYJ2EG/Uk/o3o3JtrPHEnwX9aHB3Md/jZ/zU6Fi1PytJd
         wHmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AOgz7Tb91jUSRfZhoxyhI620yzpgzcGdmZwJVxUTKMQ=;
        b=ZjFnTkOyoHz+3VIaHS+tuFPgvIC0nIHFelGPLYVNFuw7j+hrzNdV2IpjcXdVETwAsk
         ZNh9ulPjLFtXiG9vyIqjylsvBKhSPmAzRP2zNQf8RnZOkUg/KUbV7LJg/YrJY6IZu9kl
         yl/rmwBGI3AVJvwKcyx6z96S1XRmQN9hs7i10wkLeDp/7ntyGGcvmYNAp10lj0F0I55E
         EMw0T+/WOPUvhlO15r4WvDBbfKsol0rE4aVIUWuKN36nBdXEbSq3bxNjAARKy9V9NlKt
         wC7RKN4P6eucEvq1T/2qkeCscbW3jaMRJaIs0wZhmRohvvNUcHxVitAOjOGvHBeXXXcJ
         TbeQ==
X-Gm-Message-State: APjAAAUKhzrkCrXAMPUA+YcqIXtPqBoNzvI89zbcNfTAMi0mL9ReXvdO
        TA/52ZhAoYu0DOxIT4vZ6BLzlI7k
X-Google-Smtp-Source: APXvYqwkuEumwDm/HIorMDEGHnDVvPWACpE7vWKlHwQCrLgjtkwAVBe6lo3csaWu6JHxK+juUA8J5g==
X-Received: by 2002:adf:a1c4:: with SMTP id v4mr6755785wrv.108.1567024163681;
        Wed, 28 Aug 2019 13:29:23 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f04:7c00:ac08:eff5:e9d6:77a9? (p200300EA8F047C00AC08EFF5E9D677A9.dip0.t-ipconnect.de. [2003:ea:8f04:7c00:ac08:eff5:e9d6:77a9])
        by smtp.googlemail.com with ESMTPSA id j17sm183586wru.24.2019.08.28.13.29.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 28 Aug 2019 13:29:23 -0700 (PDT)
Subject: [PATCH net-next v2 1/9] r8169: change interrupt mask type to u32
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Chun-Hao Lin <hau@realtek.com>
References: <8181244b-24ac-73e2-bac7-d01f644ebb3f@gmail.com>
Message-ID: <56f1823d-e0c0-f54d-978e-c2430b964339@gmail.com>
Date:   Wed, 28 Aug 2019 22:24:13 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <8181244b-24ac-73e2-bac7-d01f644ebb3f@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RTL8125 uses a 32 bit interrupt mask even though only bits in the
lower 16 bits are used. Change interrupt mask size to u32 to be
prepared and reintroduce helper rtl_get_events.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index faa4041cf..bf00c3d8f 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -645,7 +645,7 @@ struct rtl8169_private {
 	struct page *Rx_databuff[NUM_RX_DESC];	/* Rx data buffers */
 	struct ring_info tx_skb[NUM_TX_DESC];	/* Tx data buffers */
 	u16 cp_cmd;
-	u16 irq_mask;
+	u32 irq_mask;
 	struct clk *clk;
 
 	struct {
@@ -1313,7 +1313,12 @@ static u8 rtl8168d_efuse_read(struct rtl8169_private *tp, int reg_addr)
 		RTL_R32(tp, EFUSEAR) & EFUSEAR_DATA_MASK : ~0;
 }
 
-static void rtl_ack_events(struct rtl8169_private *tp, u16 bits)
+static u32 rtl_get_events(struct rtl8169_private *tp)
+{
+	return RTL_R16(tp, IntrStatus);
+}
+
+static void rtl_ack_events(struct rtl8169_private *tp, u32 bits)
 {
 	RTL_W16(tp, IntrStatus, bits);
 }
@@ -1337,7 +1342,7 @@ static void rtl_irq_enable(struct rtl8169_private *tp)
 static void rtl8169_irq_mask_and_ack(struct rtl8169_private *tp)
 {
 	rtl_irq_disable(tp);
-	rtl_ack_events(tp, 0xffff);
+	rtl_ack_events(tp, 0xffffffff);
 	/* PCI commit */
 	RTL_R8(tp, ChipCmd);
 }
@@ -5854,9 +5859,10 @@ static int rtl_rx(struct net_device *dev, struct rtl8169_private *tp, u32 budget
 static irqreturn_t rtl8169_interrupt(int irq, void *dev_instance)
 {
 	struct rtl8169_private *tp = dev_instance;
-	u16 status = RTL_R16(tp, IntrStatus);
+	u32 status = rtl_get_events(tp);
 
-	if (!tp->irq_enabled || status == 0xffff || !(status & tp->irq_mask))
+	if (!tp->irq_enabled || (status & 0xffff) == 0xffff ||
+	    !(status & tp->irq_mask))
 		return IRQ_NONE;
 
 	if (unlikely(status & SYSErr)) {
-- 
2.23.0


