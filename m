Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7877167D86
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 13:30:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728112AbgBUMax (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 07:30:53 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:10668 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727063AbgBUMax (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Feb 2020 07:30:53 -0500
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 624C54482AD94FDFCB19;
        Fri, 21 Feb 2020 20:30:50 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.439.0; Fri, 21 Feb 2020 20:30:43 +0800
From:   Chen Zhou <chenzhou10@huawei.com>
To:     <stas.yakovlev@gmail.com>, <kvalo@codeaurora.org>,
        <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <chenzhou10@huawei.com>
Subject: [PATCH -next] ipw2x00: Use bitwise instead of arithmetic operator for flags
Date:   Fri, 21 Feb 2020 20:24:13 +0800
Message-ID: <20200221122413.149787-1-chenzhou10@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This silences the following coccinelle warning:

"WARNING: sum of probable bitmasks, consider |"

Signed-off-by: Chen Zhou <chenzhou10@huawei.com>
---
 drivers/net/wireless/intel/ipw2x00/libipw_rx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/ipw2x00/libipw_rx.c b/drivers/net/wireless/intel/ipw2x00/libipw_rx.c
index 0cb36d1..15f8119 100644
--- a/drivers/net/wireless/intel/ipw2x00/libipw_rx.c
+++ b/drivers/net/wireless/intel/ipw2x00/libipw_rx.c
@@ -871,7 +871,7 @@ void libipw_rx_any(struct libipw_device *ieee,
 	case IW_MODE_ADHOC:
 		/* our BSS and not from/to DS */
 		if (ether_addr_equal(hdr->addr3, ieee->bssid))
-		if ((fc & (IEEE80211_FCTL_TODS+IEEE80211_FCTL_FROMDS)) == 0) {
+		if ((fc & (IEEE80211_FCTL_TODS | IEEE80211_FCTL_FROMDS)) == 0) {
 			/* promisc: get all */
 			if (ieee->dev->flags & IFF_PROMISC)
 				is_packet_for_us = 1;
@@ -886,7 +886,7 @@ void libipw_rx_any(struct libipw_device *ieee,
 	case IW_MODE_INFRA:
 		/* our BSS (== from our AP) and from DS */
 		if (ether_addr_equal(hdr->addr2, ieee->bssid))
-		if ((fc & (IEEE80211_FCTL_TODS+IEEE80211_FCTL_FROMDS)) == IEEE80211_FCTL_FROMDS) {
+		if ((fc & (IEEE80211_FCTL_TODS | IEEE80211_FCTL_FROMDS)) == IEEE80211_FCTL_FROMDS) {
 			/* promisc: get all */
 			if (ieee->dev->flags & IFF_PROMISC)
 				is_packet_for_us = 1;
-- 
2.7.4

