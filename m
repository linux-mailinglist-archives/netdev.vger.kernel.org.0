Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3D24211F6E
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 11:06:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728182AbgGBJGV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 05:06:21 -0400
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:48754 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728165AbgGBJGT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 05:06:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1593680779; x=1625216779;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=w3hRwZkaK6LvFOZiwqgQ/5IpxIzOYzQj5VYFHgbR1Fo=;
  b=DNjGF3GsS08wZ0atNHz6bBaKouyVkyzT+yMY+wkXUqohDZsUrfu9AMVW
   Qr7ACA1aKkhHyWUvQpuSFRjk05qeDfPFnKZNScjiIYaCm15TiWah9gCIN
   uBXBUg9bQ60HwLOt1g1RNM85hFEYG383Wccnn9K0Z7I8ktjR6SZj+O0MD
   qzOhDViR194uWA3hLa9oqNzmv74+RCXaJxHtcn9SlgPS6RnznCaUKwc/B
   UESUUwVHxcn+knEQvMQX55xvtxxAdzo3ssqP7AX2hDEzhJ5+j19hdX1lK
   SU2p8Yxirc/YlSZCmbGbCZSGgXF81roL6jbNpEmO1ZMEwcAUYv2ankyt9
   A==;
IronPort-SDR: Ye/lsms62gQmkit866RQA7C//vC7EeXDV4sIeQ4OivJ8OMF9zU9WDN/V2VZav3kEDPURsihhlM
 KxoUI33YM1cPB1mxRrL98YM96sFDLo0GdghpZSo22vJf+PQkpvA3uxgmhUaATOjmjaVTjouWY8
 40KQ3Pj9bfdEzHl8iuozdg85eVPHnnRyOHHoxuPyPbbV8HGWU/e5wKqkf9v9gL6VlQPshzQZLC
 FpIWxkE4w+bPAbUcnGtJwODut2Tue8b+bM/70imztTtx61r5p+1fxIu/J6nBGdVnmlgT3fCuGm
 +D4=
X-IronPort-AV: E=Sophos;i="5.75,303,1589266800"; 
   d="scan'208";a="81642878"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Jul 2020 02:06:19 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 2 Jul 2020 02:06:18 -0700
Received: from m18063-ThinkPad-T460p.mchp-main.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Thu, 2 Jul 2020 02:06:15 -0700
From:   Claudiu Beznea <claudiu.beznea@microchip.com>
To:     <nicolas.ferre@microchip.com>, <davem@davemloft.net>,
        <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
Subject: [PATCH net-next v2 4/4] net: macb: remove is_udp variable
Date:   Thu, 2 Jul 2020 12:06:01 +0300
Message-ID: <1593680761-11427-5-git-send-email-claudiu.beznea@microchip.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1593680761-11427-1-git-send-email-claudiu.beznea@microchip.com>
References: <1593680761-11427-1-git-send-email-claudiu.beznea@microchip.com>
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
index c31c15e99e3c..6c99a519ab06 100644
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

