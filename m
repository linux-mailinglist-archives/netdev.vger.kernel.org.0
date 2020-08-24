Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8845B2500C5
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 17:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727912AbgHXPUN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 11:20:13 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:50246 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725947AbgHXPTD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Aug 2020 11:19:03 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.60])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 9ED31600C2;
        Mon, 24 Aug 2020 15:19:00 +0000 (UTC)
Received: from us4-mdac16-11.ut7.mdlocal (unknown [10.7.65.208])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 9C0FF200A3;
        Mon, 24 Aug 2020 15:19:00 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.66.33])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 299D51C0055;
        Mon, 24 Aug 2020 15:19:00 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id C55EFA800A1;
        Mon, 24 Aug 2020 15:18:59 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 24 Aug
 2020 16:18:55 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net] sfc: fix boolreturn.cocci warning and rename function
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
Message-ID: <7c627a43-4339-cb08-c051-340100466033@solarflare.com>
Date:   Mon, 24 Aug 2020 16:18:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25622.005
X-TM-AS-Result: No-4.183400-8.000000-10
X-TMASE-MatchedRID: woeVJAYvYhNyOVk+FPzL12WnA2xO92Up5xJf2EAcYnAH8UzOewTxw0iK
        cRG5pooKsQK9Ybrx7RJZw8ewls/9KtEYJsLZsWT8cTela9PpnnzRjnAHxymurmMunwKby/AXCh5
        FGEJlYgEDOIfIUNcfgfmpjDPjqvkiYlldA0POS1LfhvTQ/n1nGVB1e7/F/vq5VWQnHKxp38hNwx
        Og0TtaaRE8Rj2cU+bEoXaQ1VGW4+YM8jMXjBF+sDl/1fD/GopdcmfM3DjaQLHEQdG7H66TyJ8TM
        nmE+d0Zg4Ws6XBpZIp//h4FYwN+W8Ui6zqplTyRCzUXe8ZY2+TMlGNYZa4cFaKe9QvllEiKhRnP
        4ZJ3ADE2ibVLBmzrhnLZ5TldIX8ZGhBWFwMpQfUlEjOZsGnBpCAkKbrKkYtno6XmhFfKEURWXGv
        UUmKP2w==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--4.183400-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25622.005
X-MDID: 1598282340-Fvhx3uJ9pSd4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

check_fcs() was returning bool as 0/1, which was a sign that the sense
 of the function was unclear: false was good, which doesn't really match
 a name like 'check_$thing'.  So rename it to ef100_has_fcs_error(), and
 use proper booleans in the return statements.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/ef100_rx.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef100_rx.c b/drivers/net/ethernet/sfc/ef100_rx.c
index 012925e878f4..85207acf7dee 100644
--- a/drivers/net/ethernet/sfc/ef100_rx.c
+++ b/drivers/net/ethernet/sfc/ef100_rx.c
@@ -36,7 +36,7 @@ bool ef100_rx_buf_hash_valid(const u8 *prefix)
 	return PREFIX_FIELD(prefix, RSS_HASH_VALID);
 }
 
-static bool check_fcs(struct efx_channel *channel, u32 *prefix)
+static bool ef100_has_fcs_error(struct efx_channel *channel, u32 *prefix)
 {
 	u16 rxclass;
 	u8 l2status;
@@ -46,11 +46,11 @@ static bool check_fcs(struct efx_channel *channel, u32 *prefix)
 
 	if (likely(l2status == ESE_GZ_RH_HCLASS_L2_STATUS_OK))
 		/* Everything is ok */
-		return 0;
+		return false;
 
 	if (l2status == ESE_GZ_RH_HCLASS_L2_STATUS_FCS_ERR)
 		channel->n_rx_eth_crc_err++;
-	return 1;
+	return true;
 }
 
 void __ef100_rx_packet(struct efx_channel *channel)
@@ -63,7 +63,7 @@ void __ef100_rx_packet(struct efx_channel *channel)
 
 	prefix = (u32 *)(eh - ESE_GZ_RX_PKT_PREFIX_LEN);
 
-	if (check_fcs(channel, prefix) &&
+	if (ef100_has_fcs_error(channel, prefix) &&
 	    unlikely(!(efx->net_dev->features & NETIF_F_RXALL)))
 		goto out;
 
