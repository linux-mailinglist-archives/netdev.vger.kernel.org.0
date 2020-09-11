Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 379A926685F
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 20:45:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725846AbgIKSp2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 14:45:28 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:35588 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725802AbgIKSpX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 14:45:23 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.137])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 753FB2007D;
        Fri, 11 Sep 2020 18:45:22 +0000 (UTC)
Received: from us4-mdac16-3.at1.mdlocal (unknown [10.110.49.149])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 72F716009B;
        Fri, 11 Sep 2020 18:45:22 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.48.236])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 1718222004D;
        Fri, 11 Sep 2020 18:45:22 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id D4AB7400059;
        Fri, 11 Sep 2020 18:45:21 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 11 Sep
 2020 19:45:17 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next 3/3] sfc: cleanups around efx_alloc_channel
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <d176362d-cf04-a722-b41e-afe9342ec4b1@solarflare.com>
Message-ID: <d9169aec-f710-09eb-2364-2a45fc98b356@solarflare.com>
Date:   Fri, 11 Sep 2020 19:45:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <d176362d-cf04-a722-b41e-afe9342ec4b1@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25660.000
X-TM-AS-Result: No-1.483600-8.000000-10
X-TMASE-MatchedRID: 2/Vc0kgrzVqPIr9Wpu0YXHYZxYoZm58FNLwfRzvNjMsTLunq7JxcvdIk
        lxunVj5b06uB/j0KNNRTvVffeIwvQwUcfW/oedmqnFVnNmvv47tLXPA26IG0hN9RlPzeVuQQpMb
        O+d2P/XFbdScq6YVMbiurvnT8r9Rm7DLY2FGw/JsPe5gzF3TVt6Ym1jSJJ8n9np9KgXcu34zC/0
        CJsmUqcLoaAxIVVU84kZOl7WKIImrvXOvQVlExsAtuKBGekqUpnH7sbImOEBSUuaFR2hh3x5nxt
        l0sD/lHBgP0p/DfVB2jHU9QpMXUL8pk/0qO6oaCv6mtZKPZP0OlxXCnQmOaKCeshzGLAVW6ccOY
        zTzs49rtfQ1SPvnqTJqVXUXjGsjz2F+vBZls4K+yaqc7gc0b5V8I4oUq5Vga
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--1.483600-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25660.000
X-MDID: 1599849922-K-A45GOcXJdT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The old_channel argument is never used, so remove it.
The function is only called from elsewhere in efx_channels.c, so make
 it static and remove the declaration from the header file.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/efx_channels.c | 5 ++---
 drivers/net/ethernet/sfc/efx_channels.h | 2 --
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/sfc/efx_channels.c b/drivers/net/ethernet/sfc/efx_channels.c
index dd4f30ea48a8..f05ecd415ce6 100644
--- a/drivers/net/ethernet/sfc/efx_channels.c
+++ b/drivers/net/ethernet/sfc/efx_channels.c
@@ -505,8 +505,7 @@ static void efx_filter_rfs_expire(struct work_struct *data)
 #endif
 
 /* Allocate and initialise a channel structure. */
-struct efx_channel *
-efx_alloc_channel(struct efx_nic *efx, int i, struct efx_channel *old_channel)
+static struct efx_channel *efx_alloc_channel(struct efx_nic *efx, int i)
 {
 	struct efx_rx_queue *rx_queue;
 	struct efx_tx_queue *tx_queue;
@@ -545,7 +544,7 @@ int efx_init_channels(struct efx_nic *efx)
 	unsigned int i;
 
 	for (i = 0; i < EFX_MAX_CHANNELS; i++) {
-		efx->channel[i] = efx_alloc_channel(efx, i, NULL);
+		efx->channel[i] = efx_alloc_channel(efx, i);
 		if (!efx->channel[i])
 			return -ENOMEM;
 		efx->msi_context[i].efx = efx;
diff --git a/drivers/net/ethernet/sfc/efx_channels.h b/drivers/net/ethernet/sfc/efx_channels.h
index 2d71dc9a33dd..d77ec1f77fb1 100644
--- a/drivers/net/ethernet/sfc/efx_channels.h
+++ b/drivers/net/ethernet/sfc/efx_channels.h
@@ -31,8 +31,6 @@ void efx_stop_eventq(struct efx_channel *channel);
 void efx_fini_eventq(struct efx_channel *channel);
 void efx_remove_eventq(struct efx_channel *channel);
 
-struct efx_channel *
-efx_alloc_channel(struct efx_nic *efx, int i, struct efx_channel *old_channel);
 int efx_realloc_channels(struct efx_nic *efx, u32 rxq_entries, u32 txq_entries);
 void efx_get_channel_name(struct efx_channel *channel, char *buf, size_t len);
 void efx_set_channel_names(struct efx_nic *efx);
