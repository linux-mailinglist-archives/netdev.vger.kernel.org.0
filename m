Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEED2212969
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 18:29:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726616AbgGBQ3T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 12:29:19 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:47392 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726297AbgGBQ3S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 12:29:18 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.61])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 22997600B3;
        Thu,  2 Jul 2020 16:29:18 +0000 (UTC)
Received: from us4-mdac16-62.ut7.mdlocal (unknown [10.7.66.61])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 23079800B0;
        Thu,  2 Jul 2020 16:29:18 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.66.37])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 9CE798005F;
        Thu,  2 Jul 2020 16:29:17 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 4A8CCB4008C;
        Thu,  2 Jul 2020 16:29:17 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 2 Jul 2020
 17:29:12 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH v2 net-next 04/16] sfc: move modparam 'rss_cpus' out of common
 channel code
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <52336e78-8f45-7401-9827-6c1fea38656d@solarflare.com>
Message-ID: <d0a39fa8-8c15-24bb-1632-3b1fae844198@solarflare.com>
Date:   Thu, 2 Jul 2020 17:29:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <52336e78-8f45-7401-9827-6c1fea38656d@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25516.003
X-TM-AS-Result: No-0.007800-8.000000-10
X-TMASE-MatchedRID: EApzmY5DLHO4WGh1vUSL//3HILfxLV/9+LidURF+DB3Ib96UUXRrm1uq
        YpIDwN0+28G4m+3NScjEaiEZ/VWDnShwCmnYdDTlqJSK+HSPY+/pVMb1xnESMnAal2A1DQmscij
        MZrr2iZ2t2gtuWr1LmmbpUJbxMF84FJAZ9GWS7vTJ/bVh4iw9hr7DirSpOYvI0SxMhOhuA0Qcvv
        sM78SKaAE2DjEevfnaJkB8cahV/fllJTodqNqEzp4CIKY/Hg3AtOt1ofVlaoLWRN8STJpl3PoLR
        4+zsDTt+b70DEg6M4b3sIHM55KR1kxpcERscFomX2T8q8NKh6J4+WUAZI5ZSOrU76pbrr6cAjo2
        TIt/Vp6+DPqHEjiZhHALEBJy3Sr4Amv+iCkokRd85uoYr0mmWaKdpX90rRoSErdW3Lyhe2TZKwv
        JjiAfi8C+ksT6a9fy
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--0.007800-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25516.003
X-MDID: 1593707358-7h2tOCLAFRq2
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of exposing this old module parameter on the new driver (thus
 having to keep it forever after for compatibility), let's confine it
 to the old one; if we find later that we need the feature, we ought
 to support it properly, with ethtool set-channels.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/efx.c          | 3 +++
 drivers/net/ethernet/sfc/efx_channels.c | 4 +---
 drivers/net/ethernet/sfc/efx_channels.h | 1 +
 3 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index 2725d1d62d25..6094f59d49a7 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -68,6 +68,9 @@ module_param_named(interrupt_mode, efx_interrupt_mode, uint, 0444);
 MODULE_PARM_DESC(interrupt_mode,
 		 "Interrupt mode (0=>MSIX 1=>MSI 2=>legacy)");
 
+module_param(rss_cpus, uint, 0444);
+MODULE_PARM_DESC(rss_cpus, "Number of CPUs to use for Receive-Side Scaling");
+
 /*
  * Use separate channels for TX and RX events
  *
diff --git a/drivers/net/ethernet/sfc/efx_channels.c b/drivers/net/ethernet/sfc/efx_channels.c
index 50356db39ae5..466257b9abbf 100644
--- a/drivers/net/ethernet/sfc/efx_channels.c
+++ b/drivers/net/ethernet/sfc/efx_channels.c
@@ -32,9 +32,7 @@ unsigned int efx_interrupt_mode = EFX_INT_MODE_MSIX;
  * Cards without MSI-X will only target one CPU via legacy or MSI interrupt.
  * The default (0) means to assign an interrupt to each core.
  */
-static unsigned int rss_cpus;
-module_param(rss_cpus, uint, 0444);
-MODULE_PARM_DESC(rss_cpus, "Number of CPUs to use for Receive-Side Scaling");
+unsigned int rss_cpus;
 
 static unsigned int irq_adapt_low_thresh = 8000;
 module_param(irq_adapt_low_thresh, uint, 0644);
diff --git a/drivers/net/ethernet/sfc/efx_channels.h b/drivers/net/ethernet/sfc/efx_channels.h
index 86dd058d40f3..2d71dc9a33dd 100644
--- a/drivers/net/ethernet/sfc/efx_channels.h
+++ b/drivers/net/ethernet/sfc/efx_channels.h
@@ -12,6 +12,7 @@
 #define EFX_CHANNELS_H
 
 extern unsigned int efx_interrupt_mode;
+extern unsigned int rss_cpus;
 
 int efx_probe_interrupts(struct efx_nic *efx);
 void efx_remove_interrupts(struct efx_nic *efx);

