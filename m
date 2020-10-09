Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38F01288A9E
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 16:20:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387974AbgJIOUn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 10:20:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732056AbgJIOUm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 10:20:42 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90384C0613D2
        for <netdev@vger.kernel.org>; Fri,  9 Oct 2020 07:20:42 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id e22so13345454ejr.4
        for <netdev@vger.kernel.org>; Fri, 09 Oct 2020 07:20:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=vPmdIQhzOZOui0MqANxoii7/A4dUwjEmFus6UgnBHR0=;
        b=V28Rq6+GyAVNp3fW6qsytxOcX+7gVknz3z3W+lV+ZnRTOkTEpPF0z0o7/9oVhdiHB8
         Tveu6sCQorNiGC/WCFFjE/Lyk1eanZL/TX/J03jh/S20XBR/pcpF1rEdl9P33kjgjrbS
         po+wnarSONtGhyBCuAv1xhvMvELdkB4tF/tDgAI1204EBPk83OwGAXVW03U4GxQ3/Gf+
         D2MeLmxRpeJJPKAktTxS7X6rZ/eqgcJTSauB/xMIU3rWzjLYWx82FteP+eMs9qgjpUwq
         XGpAwDRjYvyCOP92ONLaY3ciUS4vLk8smfqeHGlWwEmLkU3nbJX9Fq28oP+2hYF3DxS3
         E9JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=vPmdIQhzOZOui0MqANxoii7/A4dUwjEmFus6UgnBHR0=;
        b=qrmEozoKtsoLeFrc0laYIhfJDDeQWiLjyrxh6btrbKb2QCk7aCvAW8JweixSBXHdKT
         +PnAh00EmUzX19Axmmsm0txuhCSW2Bo/AaBgsyupIj1LbUc2dMgO/NeTDBZ/8Lw+yJ2x
         B5nqQ9LEYsiMHAt2tv6te0ZtSaaQ5t5c0gFx+CAEBnqrvUuBAXIJ1BualOLsTFsoCPwV
         fNpwn/knUDIq14VDby9grL75AiEouaz6owOGXSFhJ14kpDQSIqLI/pG9Ubp1s+XJfNCM
         cqGSoWtMDAjfFsXmanYwRtgkwB/QZ0Hs6H3D4PQLPutQpZPGnriCg/6e5u4ojLsBezg0
         78dQ==
X-Gm-Message-State: AOAM531UFOZx+KvioBmYcNlwgMQbuOC83jhoCfBu0eJekbHk+eE6e/20
        fpbcAbfllf//UVPuczGEe6/NqdM1/qbs/A==
X-Google-Smtp-Source: ABdhPJzBaFhC/InRWp23QQjXjE8ffJmBHS14gYzKXmAETqSKqg3+isID/pDqo8b7dY60RP4DcOhQ6Q==
X-Received: by 2002:a17:906:ad87:: with SMTP id la7mr14342625ejb.85.1602253240936;
        Fri, 09 Oct 2020 07:20:40 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f00:6a00:e538:757:aee0:c25f? (p200300ea8f006a00e5380757aee0c25f.dip0.t-ipconnect.de. [2003:ea:8f00:6a00:e538:757:aee0:c25f])
        by smtp.googlemail.com with ESMTPSA id m1sm1189681edf.79.2020.10.09.07.20.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Oct 2020 07:20:40 -0700 (PDT)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] r8169: factor out handling rtl8169_stats
Message-ID: <dee5d6ec-d7ab-03c0-9c3b-4fd4e9f2b1d0@gmail.com>
Date:   Fri, 9 Oct 2020 16:20:34 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Factor out handling the private packet/byte counters to new
functions rtl_get_priv_stats() and rtl_inc_priv_stats().

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 46 ++++++++++++-----------
 1 file changed, 25 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 9afd1ef57..7d366b036 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -700,6 +700,27 @@ static bool rtl_supports_eee(struct rtl8169_private *tp)
 	       tp->mac_version != RTL_GIGA_MAC_VER_39;
 }
 
+static void rtl_get_priv_stats(struct rtl8169_stats *stats,
+			       u64 *pkts, u64 *bytes)
+{
+	unsigned int start;
+
+	do {
+		start = u64_stats_fetch_begin_irq(&stats->syncp);
+		*pkts = stats->packets;
+		*bytes = stats->bytes;
+	} while (u64_stats_fetch_retry_irq(&stats->syncp, start));
+}
+
+static void rtl_inc_priv_stats(struct rtl8169_stats *stats,
+			       u64 pkts, u64 bytes)
+{
+	u64_stats_update_begin(&stats->syncp);
+	stats->packets += pkts;
+	stats->bytes += bytes;
+	u64_stats_update_end(&stats->syncp);
+}
+
 static void rtl_read_mac_from_reg(struct rtl8169_private *tp, u8 *mac, int reg)
 {
 	int i;
@@ -4396,10 +4417,7 @@ static void rtl_tx(struct net_device *dev, struct rtl8169_private *tp,
 	if (tp->dirty_tx != dirty_tx) {
 		netdev_completed_queue(dev, pkts_compl, bytes_compl);
 
-		u64_stats_update_begin(&tp->tx_stats.syncp);
-		tp->tx_stats.packets += pkts_compl;
-		tp->tx_stats.bytes += bytes_compl;
-		u64_stats_update_end(&tp->tx_stats.syncp);
+		rtl_inc_priv_stats(&tp->tx_stats, pkts_compl, bytes_compl);
 
 		tp->dirty_tx = dirty_tx;
 		/* Sync with rtl8169_start_xmit:
@@ -4521,11 +4539,7 @@ static int rtl_rx(struct net_device *dev, struct rtl8169_private *tp, u32 budget
 
 		napi_gro_receive(&tp->napi, skb);
 
-		u64_stats_update_begin(&tp->rx_stats.syncp);
-		tp->rx_stats.packets++;
-		tp->rx_stats.bytes += pkt_size;
-		u64_stats_update_end(&tp->rx_stats.syncp);
-
+		rtl_inc_priv_stats(&tp->rx_stats, 1, pkt_size);
 release_descriptor:
 		rtl8169_mark_to_asic(desc);
 	}
@@ -4772,23 +4786,13 @@ rtl8169_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *stats)
 	struct rtl8169_private *tp = netdev_priv(dev);
 	struct pci_dev *pdev = tp->pci_dev;
 	struct rtl8169_counters *counters = tp->counters;
-	unsigned int start;
 
 	pm_runtime_get_noresume(&pdev->dev);
 
 	netdev_stats_to_stats64(stats, &dev->stats);
 
-	do {
-		start = u64_stats_fetch_begin_irq(&tp->rx_stats.syncp);
-		stats->rx_packets = tp->rx_stats.packets;
-		stats->rx_bytes	= tp->rx_stats.bytes;
-	} while (u64_stats_fetch_retry_irq(&tp->rx_stats.syncp, start));
-
-	do {
-		start = u64_stats_fetch_begin_irq(&tp->tx_stats.syncp);
-		stats->tx_packets = tp->tx_stats.packets;
-		stats->tx_bytes	= tp->tx_stats.bytes;
-	} while (u64_stats_fetch_retry_irq(&tp->tx_stats.syncp, start));
+	rtl_get_priv_stats(&tp->rx_stats, &stats->rx_packets, &stats->rx_bytes);
+	rtl_get_priv_stats(&tp->tx_stats, &stats->tx_packets, &stats->tx_bytes);
 
 	/*
 	 * Fetch additional counter values missing in stats collected by driver
-- 
2.28.0

