Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ED8F29F359
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 18:35:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727386AbgJ2RfM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 13:35:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727324AbgJ2RfL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 13:35:11 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 216ADC0613D5
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 10:35:11 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id e2so643247wme.1
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 10:35:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bn6Ffq1R0Fbj3HDTfO/FvuE7XasQ79ljvJbpZcCEY44=;
        b=JjmvbWUj/fUdpbGtjgwPjPJg1iZBpgQsuDXxssn3p+tCIu4sDWVk4UkChLAr2v81py
         a/lZpl3ix6XhU0W+J5Nozc6jTSncvxipr7dbbZd6A5Alyl/1Cb0Z4TvJ+1w70GdjqVDO
         XemQlTSX6EfgHgcZhS8JZqzCCpRNvgqQr4O/SGXU178nvLNuQoJjkidmYehj+Js18c1X
         lakvTv6HOZEAGT9e+Rmf7xI4nSB90A2QhtIt603i1Lg0EXwmF5iNwWe+QUzHoN0tLr+b
         BMvGjdZg7aKNhAikY5wkgslUWDbRN4qKLZUtUAIY5CT+EcL6BFch4qxsqqcnxm3LGY+h
         Wang==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bn6Ffq1R0Fbj3HDTfO/FvuE7XasQ79ljvJbpZcCEY44=;
        b=m1g/jbANQvpuDhbCKflS7K9lI51JJFvxdhVB119Sh++4ghMNbNCQbM/zX3MPgd3Rdv
         05K8Y3NKYFjsET4WYYEtIr7o4up3+wxZZZGevdKEx4jOOdF6rTITonkLKHwKefbrIo+K
         JfYZNhG6Edqud7U66WvmopyZ/RRKcKf7oZ75tWQubREToNHo9PpjDxNoA/ifqOVBWH0a
         vnXR1e8nA2dUeycgFAQ75fZmnYvho7FSYOHTFckY4XYmrdmYw1j5zNYgY2mfuD2xA/i2
         hzRCli+J2Ah+1EbQfL3nAel4kVg+0ce1Zt5M7u55w82KTlTsD3f686Jm2W8g3pTmxZ8d
         iwGQ==
X-Gm-Message-State: AOAM532ZUY8vqZRB90qGk6Oq3iv+7+t3nuhbBovKddRqtr2o5cbf/X0H
        dLz4pQ6wHJLaJnUKccIUwaho+4JyAww=
X-Google-Smtp-Source: ABdhPJx6MeF0rUO3XhuLuSIZz7T19Ir/AtxdT40ulWsTQ3Bwqk1AqGnPbwTuV9UbhJDs6Jo+y3px5w==
X-Received: by 2002:a7b:c20d:: with SMTP id x13mr1023939wmi.83.1603992909541;
        Thu, 29 Oct 2020 10:35:09 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:2800:a990:f24b:87e1:a560? (p200300ea8f232800a990f24b87e1a560.dip0.t-ipconnect.de. [2003:ea:8f23:2800:a990:f24b:87e1:a560])
        by smtp.googlemail.com with ESMTPSA id y206sm820851wmd.34.2020.10.29.10.35.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Oct 2020 10:35:09 -0700 (PDT)
Subject: [PATCH net-next 4/4] r8169: remove no longer needed private rx/tx
 packet/byte counters
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <1fdb8ecd-be0a-755d-1d92-c62ed8399e77@gmail.com>
Message-ID: <abd09ca2-2d88-b9bb-7709-0792da2b857f@gmail.com>
Date:   Thu, 29 Oct 2020 18:34:39 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <1fdb8ecd-be0a-755d-1d92-c62ed8399e77@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After switching to the net core rx/tx byte/packet counters we can
remove the now unused private version.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 34 -----------------------
 1 file changed, 34 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 0ef30ad8a..b6c11aaa5 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -584,12 +584,6 @@ enum rtl_flag {
 	RTL_FLAG_MAX
 };
 
-struct rtl8169_stats {
-	u64			packets;
-	u64			bytes;
-	struct u64_stats_sync	syncp;
-};
-
 struct rtl8169_private {
 	void __iomem *mmio_addr;	/* memory map physical address */
 	struct pci_dev *pci_dev;
@@ -600,8 +594,6 @@ struct rtl8169_private {
 	u32 cur_rx; /* Index into the Rx descriptor buffer of next Rx pkt. */
 	u32 cur_tx; /* Index into the Tx descriptor buffer of next Rx pkt. */
 	u32 dirty_tx;
-	struct rtl8169_stats rx_stats;
-	struct rtl8169_stats tx_stats;
 	struct TxDesc *TxDescArray;	/* 256-aligned Tx descriptor ring */
 	struct RxDesc *RxDescArray;	/* 256-aligned Rx descriptor ring */
 	dma_addr_t TxPhyAddr;
@@ -700,27 +692,6 @@ static bool rtl_supports_eee(struct rtl8169_private *tp)
 	       tp->mac_version != RTL_GIGA_MAC_VER_39;
 }
 
-static void rtl_get_priv_stats(struct rtl8169_stats *stats,
-			       u64 *pkts, u64 *bytes)
-{
-	unsigned int start;
-
-	do {
-		start = u64_stats_fetch_begin_irq(&stats->syncp);
-		*pkts = stats->packets;
-		*bytes = stats->bytes;
-	} while (u64_stats_fetch_retry_irq(&stats->syncp, start));
-}
-
-static void rtl_inc_priv_stats(struct rtl8169_stats *stats,
-			       u64 pkts, u64 bytes)
-{
-	u64_stats_update_begin(&stats->syncp);
-	stats->packets += pkts;
-	stats->bytes += bytes;
-	u64_stats_update_end(&stats->syncp);
-}
-
 static void rtl_read_mac_from_reg(struct rtl8169_private *tp, u8 *mac, int reg)
 {
 	int i;
@@ -4416,9 +4387,7 @@ static void rtl_tx(struct net_device *dev, struct rtl8169_private *tp,
 
 	if (tp->dirty_tx != dirty_tx) {
 		netdev_completed_queue(dev, pkts_compl, bytes_compl);
-
 		dev_sw_netstats_tx_add(dev, pkts_compl, bytes_compl);
-		rtl_inc_priv_stats(&tp->tx_stats, pkts_compl, bytes_compl);
 
 		tp->dirty_tx = dirty_tx;
 		/* Sync with rtl8169_start_xmit:
@@ -4541,7 +4510,6 @@ static int rtl_rx(struct net_device *dev, struct rtl8169_private *tp, u32 budget
 		napi_gro_receive(&tp->napi, skb);
 
 		dev_sw_netstats_rx_add(dev, pkt_size);
-		rtl_inc_priv_stats(&tp->rx_stats, 1, pkt_size);
 release_descriptor:
 		rtl8169_mark_to_asic(desc);
 	}
@@ -5345,8 +5313,6 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 
 	INIT_WORK(&tp->wk.work, rtl_task);
-	u64_stats_init(&tp->rx_stats.syncp);
-	u64_stats_init(&tp->tx_stats.syncp);
 
 	rtl_init_mac_address(tp);
 
-- 
2.29.1


