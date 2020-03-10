Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89CA6180B44
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 23:15:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727775AbgCJWPL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 18:15:11 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:36512 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbgCJWPL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 18:15:11 -0400
Received: by mail-wr1-f67.google.com with SMTP id s5so62260wrg.3
        for <netdev@vger.kernel.org>; Tue, 10 Mar 2020 15:15:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=IMGMWD1SzEVhpre/VzcHA4hjobDm1dY17JddbcTPIWg=;
        b=toLPULWYKJnW5LGF6XxK8j8Ab+RzO2C3sRwkec0i0a3Y0mM0xOP7ofZbbaQOIs2Uwz
         FQmzDBbWusUj1MJv2C9UY8Cgt5t9TP7hDQks4UWE22okDS2W/LEdivK5+5QLSMiUesIL
         cgjtosRCODUOgm6J2OPpqtcGFe51HHHE05jayOQlPxerjrYqp+ciPyZ5Kls4/a3Qs41w
         +c2UHHdKOUupVK6jHcJ/mJiQG6H8BMS7DMEsiKWGkBBhnNZOQHKDaxI56vPPcJHZ+VFN
         RkIIfC3UFsRosmZ7bGie/w6SoeZvhxCvJ2Fgh2enl0L+dzMoUyGKLmEVps/xKWGM0t8S
         PQsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=IMGMWD1SzEVhpre/VzcHA4hjobDm1dY17JddbcTPIWg=;
        b=aZ/13/oP3dR5Ars8Ki7cSA5A0pDxMn0o4FAIzFelv1UYd57O6eH0u2TognhJ+wgzB1
         kIaPWCmfCIlPYLZZygSrRYYsxX/qZWTS8+l9eLRc/Vd5v6eTvcLTEHaprQMLChVUIhYG
         AqbJLu/TJLOyGlf6FRYdv7ITgVUaMPTec8NuWeZfrsbE7KgTi0NE9ZLPhZUfyBRoe2cz
         zLGw5wM9FLIh48N6J8CFzrjakrtqgkSB0d+JjXQcgoRMZU1H1YdpFG5IMdefUbycI9Nk
         m+lPgJSij5Znoof58WocDlcb8/Ck2xP4hMCNLaoED/ufxpcHJLyjX3tw0VFwnKH1uQe1
         9eHQ==
X-Gm-Message-State: ANhLgQ2YR0+m3Zl1/70UH7gvf6BZk4EhgDJaWLjoLMDUiSfZqiHJj+3q
        rvRseGzRwgsaWrHnhYtkTj75WU6B
X-Google-Smtp-Source: ADFU+vsRbrZyEdAWeEAV9stcPmYaV7ePhm9Cl/xEEm+2td7H5pmJFSEhhjLzT8IlJ90GNMuU/6srLQ==
X-Received: by 2002:adf:e789:: with SMTP id n9mr35244wrm.140.1583878509271;
        Tue, 10 Mar 2020 15:15:09 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:6583:5434:4ad:491c? (p200300EA8F2960006583543404AD491C.dip0.t-ipconnect.de. [2003:ea:8f29:6000:6583:5434:4ad:491c])
        by smtp.googlemail.com with ESMTPSA id c4sm5989078wml.7.2020.03.10.15.15.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Mar 2020 15:15:08 -0700 (PDT)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] r8169: simplify getting stats by using
 netdev_stats_to_stats64
Message-ID: <5b4bf717-934b-b0c6-0f66-585dbe3f774d@gmail.com>
Date:   Tue, 10 Mar 2020 23:15:00 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Let netdev_stats_to_stats64() do the copy work for us.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index c0731c33c..ce030e093 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4827,6 +4827,8 @@ rtl8169_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *stats)
 
 	pm_runtime_get_noresume(&pdev->dev);
 
+	netdev_stats_to_stats64(stats, &dev->stats);
+
 	do {
 		start = u64_stats_fetch_begin_irq(&tp->rx_stats.syncp);
 		stats->rx_packets = tp->rx_stats.packets;
@@ -4839,14 +4841,6 @@ rtl8169_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *stats)
 		stats->tx_bytes	= tp->tx_stats.bytes;
 	} while (u64_stats_fetch_retry_irq(&tp->tx_stats.syncp, start));
 
-	stats->rx_dropped	= dev->stats.rx_dropped;
-	stats->tx_dropped	= dev->stats.tx_dropped;
-	stats->rx_length_errors = dev->stats.rx_length_errors;
-	stats->rx_errors	= dev->stats.rx_errors;
-	stats->rx_crc_errors	= dev->stats.rx_crc_errors;
-	stats->rx_fifo_errors	= dev->stats.rx_fifo_errors;
-	stats->multicast	= dev->stats.multicast;
-
 	/*
 	 * Fetch additional counter values missing in stats collected by driver
 	 * from tally counters.
-- 
2.25.1

