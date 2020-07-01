Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5145E210BCE
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 15:09:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730878AbgGANJT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 09:09:19 -0400
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:32587 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729402AbgGANJP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 09:09:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1593608956; x=1625144956;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=s42Du4fy5NBs3k4rUKT5UAKJ01NC2TLYOSaV8P+ljQQ=;
  b=1oqn7WJuxl1pv2fGShyUhWEtKNyqT/ueAfEZeLuMl4OzZc+L1rhEHCDo
   gLZGfiPTL6CJKsUUNmKLO4mzZdTH/9Mc5odDTowxsnmx7Pgs+vz1PuHXe
   JeeWfkkLQT1VYtBlqOtPqXeglcjQhTBIIc8gBNavqiHl6AKARgF+vyZpD
   5I9mr8bQTghHboNuTlMIHwvZ4gM/YckHeL3cjUMiV0tKIjyO1za8tTaS2
   fa3jmYhjHuw1XmyoSgcefkKuxjQQPDNSDY5vZ8Jm15XXqjFJ6xe3935wP
   JBhtJSNR7aOfl8sRvGwoXB0G/COCB1rx1b8+Dia18EjyWSGU/StCxMzOb
   Q==;
IronPort-SDR: TUbdAMFTwHMlnO7qwylfeSNJJtIZwk6Ja71BbbAuQxP86iVDFZj+77afZHCPQJEB+MWop7O0kg
 t5GzuI3Gdj6Qaz7WRpvQ20hFlSgjNbhgshgBSI9YigCI/WelxXMph1itrlJl3/HK18jf0lLIKU
 k/W9jmyBHAZu00zw+DZdTG2qY/vGDI0/31Mk0yn/VERMVyJQ7IrMddSZzm4f0GnkZGb/Pjyzgf
 bEE1a2Ad2LzzCwo5KOcD8Gl+rl4QrftX2cDmtzf48v8JalE8L8HwBHnrt0KgqX1Ey6avzt83mG
 fiM=
X-IronPort-AV: E=Sophos;i="5.75,300,1589266800"; 
   d="scan'208";a="81529538"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Jul 2020 06:09:11 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 1 Jul 2020 06:09:10 -0700
Received: from m18063-ThinkPad-T460p.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Wed, 1 Jul 2020 06:09:07 -0700
From:   Claudiu Beznea <claudiu.beznea@microchip.com>
To:     <nicolas.ferre@microchip.com>, <davem@davemloft.net>,
        <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
Subject: [PATCH net-next 4/4] net: macb: remove is_udp variable
Date:   Wed, 1 Jul 2020 16:08:51 +0300
Message-ID: <1593608931-3718-5-git-send-email-claudiu.beznea@microchip.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1593608931-3718-1-git-send-email-claudiu.beznea@microchip.com>
References: <1593608931-3718-1-git-send-email-claudiu.beznea@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove is_udp variable that is used in only one place and use
ip_hdr(skb)->protocol == IPPROTO_UDP check instead.

Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
---
 drivers/net/ethernet/cadence/macb_main.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 3603ab707e0f..4e7317747f54 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -1933,7 +1933,7 @@ static netdev_tx_t macb_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	unsigned long flags;
 	unsigned int desc_cnt, nr_frags, frag_size, f;
 	unsigned int hdrlen;
-	bool is_lso, is_udp = 0;
+	bool is_lso;
 	netdev_tx_t ret = NETDEV_TX_OK;
 
 	if (macb_clear_csum(skb)) {
@@ -1949,10 +1949,8 @@ static netdev_tx_t macb_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	is_lso = (skb_shinfo(skb)->gso_size != 0);
 
 	if (is_lso) {
-		is_udp = !!(ip_hdr(skb)->protocol == IPPROTO_UDP);
-
 		/* length of headers */
-		if (is_udp)
+		if (ip_hdr(skb)->protocol == IPPROTO_UDP)
 			/* only queue eth + ip headers separately for UDP */
 			hdrlen = skb_transport_offset(skb);
 		else
-- 
2.7.4

