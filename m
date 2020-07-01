Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 184C8210E09
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 16:52:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731549AbgGAOwh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 10:52:37 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:35972 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730264AbgGAOwg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 10:52:36 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.64])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 456FC600CA;
        Wed,  1 Jul 2020 14:52:36 +0000 (UTC)
Received: from us4-mdac16-16.ut7.mdlocal (unknown [10.7.65.240])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 43C46200AC;
        Wed,  1 Jul 2020 14:52:36 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.66.36])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id C85CF220059;
        Wed,  1 Jul 2020 14:52:35 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 79300B40056;
        Wed,  1 Jul 2020 14:52:35 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 1 Jul 2020
 15:52:30 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next 03/15] sfc: move modparam 'interrupt_mode' out of
 common channel code
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <3fa88508-024e-2d33-0629-bf63b558b515@solarflare.com>
Message-ID: <1d88fcb3-4aa4-85e9-a6ad-d23b6194e4f1@solarflare.com>
Date:   Wed, 1 Jul 2020 15:52:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <3fa88508-024e-2d33-0629-bf63b558b515@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25514.003
X-TM-AS-Result: No-4.852300-8.000000-10
X-TMASE-MatchedRID: 0TVqDj6zTEUfLZjRGBdfQZzEHTUOuMX3SWg+u4ir2NM4WKr1PmPdtciT
        Wug2C4DNl1M7KT9/aqCJYZ+Td59n+wihmwiXCMoGPwKTD1v8YV5UENBIMyKD0TnZfxjBVQRbPHx
        PHi4pd17iuuhb5xYVDwJ74qV+6XUmutbsRFhsjTJH+PTjR9EWkn10QHPrN0RXVWQnHKxp38h3k/
        FAWsJP18eTa8QdNdOm7TeekfXJOLUZxRzC/w7oVBIRh9wkXSlFpKS8Vb1YbZ0OYjxa8oCpSKPFj
        JEFr+olA9Mriq0CDAg9wJeM2pSaRVgXepbcl7r7EYRX4ckA/XrfGbNLispjIylIpiEf/bOqYhxA
        zDyvkU7Sj9SX3VPbYaOVJT8NLMvdbIEodwAK3lU7P/ILLscVlAtZi5nTYuhZMcKpXuu/1jVAMwW
        4rY/0WO2hZq8RbsdETdnyMokJ1HTiaosWHm9+bH7cGd19dSFd
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--4.852300-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25514.003
X-MDID: 1593615156-o7J7ObX92ewu
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

EF100 only supports MSI-X, so there's no need for the new driver to
 expose this old module parameter.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/efx.c          | 4 ++++
 drivers/net/ethernet/sfc/efx_channels.c | 5 +----
 drivers/net/ethernet/sfc/efx_channels.h | 2 ++
 3 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index 418676aba43a..9e0dbf8648ee 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -64,6 +64,10 @@ void efx_get_udp_tunnel_type_name(u16 type, char *buf, size_t buflen)
  *
  *************************************************************************/
 
+module_param(interrupt_mode, uint, 0444);
+MODULE_PARM_DESC(interrupt_mode,
+		 "Interrupt mode (0=>MSIX 1=>MSI 2=>legacy)");
+
 /*
  * Use separate channels for TX and RX events
  *
diff --git a/drivers/net/ethernet/sfc/efx_channels.c b/drivers/net/ethernet/sfc/efx_channels.c
index 2220b9507336..e93bc37e6a7a 100644
--- a/drivers/net/ethernet/sfc/efx_channels.c
+++ b/drivers/net/ethernet/sfc/efx_channels.c
@@ -23,10 +23,7 @@
  * 1 => MSI
  * 2 => legacy
  */
-static unsigned int interrupt_mode;
-module_param(interrupt_mode, uint, 0444);
-MODULE_PARM_DESC(interrupt_mode,
-		 "Interrupt mode (0=>MSIX 1=>MSI 2=>legacy)");
+unsigned int interrupt_mode = EFX_INT_MODE_MSIX;
 
 /* This is the requested number of CPUs to use for Receive-Side Scaling (RSS),
  * i.e. the number of CPUs among which we may distribute simultaneous
diff --git a/drivers/net/ethernet/sfc/efx_channels.h b/drivers/net/ethernet/sfc/efx_channels.h
index 8d7b8c4142d7..c9f0f4d0caa9 100644
--- a/drivers/net/ethernet/sfc/efx_channels.h
+++ b/drivers/net/ethernet/sfc/efx_channels.h
@@ -11,6 +11,8 @@
 #ifndef EFX_CHANNELS_H
 #define EFX_CHANNELS_H
 
+extern unsigned int interrupt_mode;
+
 int efx_probe_interrupts(struct efx_nic *efx);
 void efx_remove_interrupts(struct efx_nic *efx);
 int efx_soft_enable_interrupts(struct efx_nic *efx);

