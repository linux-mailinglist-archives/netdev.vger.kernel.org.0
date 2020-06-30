Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4360920F441
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 14:14:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387535AbgF3MOY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 08:14:24 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:57170 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732036AbgF3MOX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 08:14:23 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.137])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 2641320099;
        Tue, 30 Jun 2020 12:14:22 +0000 (UTC)
Received: from us4-mdac16-8.at1.mdlocal (unknown [10.110.49.190])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 246306009B;
        Tue, 30 Jun 2020 12:14:22 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.49.6])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 88AFB220072;
        Tue, 30 Jun 2020 12:14:21 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 4FBB3B00073;
        Tue, 30 Jun 2020 12:14:21 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 30 Jun
 2020 13:14:16 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next 11/14] sfc: initialise max_[tx_]channels in
 efx_init_channels()
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <14a93b71-3d4e-4663-82be-a2281cd1105e@solarflare.com>
Message-ID: <d4f8e408-4829-6e89-8fde-758af2d40aa1@solarflare.com>
Date:   Tue, 30 Jun 2020 13:14:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <14a93b71-3d4e-4663-82be-a2281cd1105e@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25512.003
X-TM-AS-Result: No-0.080800-8.000000-10
X-TMASE-MatchedRID: W4G0h3GCi0mh9oPbMj7PPPCoOvLLtsMhqnabhLgnhmgHZBaLwEXlKIpb
        wG9fIuITKtCISd3FwWPiBiWevqr/K01+zyfzlN7ygxsfzkNRlfJIWseC5HlebfoLR4+zsDTtjoc
        zmuoPCq2/hDV1Ro5VjYzhTWNdiCGtjigZi9VFYyB8D7zXRcjU4tOW6P+GCI8NQymOaJ0F/dZPlr
        UHVdLgcK3gpxfal3zW9vyLK0+GYKoXxY6mau8LG3IJh4dBcU42f4hpTpoBF9JqxGCSzFD9MrDMW
        vXXz1lrlExlQIQeRG0=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--0.080800-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25512.003
X-MDID: 1593519262-a3P04ZB388fP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/efx_channels.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/sfc/efx_channels.c b/drivers/net/ethernet/sfc/efx_channels.c
index 2c3510b0524a..2f9db219513a 100644
--- a/drivers/net/ethernet/sfc/efx_channels.c
+++ b/drivers/net/ethernet/sfc/efx_channels.c
@@ -566,6 +566,9 @@ int efx_init_channels(struct efx_nic *efx)
 	efx->interrupt_mode = min(efx->type->min_interrupt_mode,
 				  interrupt_mode);
 
+	efx->max_channels = EFX_MAX_CHANNELS;
+	efx->max_tx_channels = EFX_MAX_CHANNELS;
+
 	return 0;
 }
 

