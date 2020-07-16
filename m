Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E71D22233E
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 15:00:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728484AbgGPNAs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 09:00:48 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:55292 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728225AbgGPNAr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 09:00:47 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.61])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 1FC666012D;
        Thu, 16 Jul 2020 13:00:47 +0000 (UTC)
Received: from us4-mdac16-38.ut7.mdlocal (unknown [10.7.66.157])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 1D1F48009E;
        Thu, 16 Jul 2020 13:00:47 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.176])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 886AA8005B;
        Thu, 16 Jul 2020 13:00:46 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 3EB626800C4;
        Thu, 16 Jul 2020 13:00:46 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 16 Jul
 2020 14:00:29 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH v3 net-next 03/16] sfc_ef100: register accesses on EF100
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <7bb4f1f4-c67f-8c7b-86ba-7bf9f74ffc28@solarflare.com>
Message-ID: <55c13c93-714e-e823-8fba-eabd9ae26f91@solarflare.com>
Date:   Thu, 16 Jul 2020 14:00:25 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <7bb4f1f4-c67f-8c7b-86ba-7bf9f74ffc28@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25544.003
X-TM-AS-Result: No-0.072100-8.000000-10
X-TMASE-MatchedRID: jedmkgCKCjoYap5fJ/fNIZzEHTUOuMX33V4UShoTXafg+jsHnpr1WAra
        NtW4DkZY8XVI39JCRnSjfNAVYAJRAr+Q0YdVmuyWnFVnNmvv47tLXPA26IG0hN9RlPzeVuQQ0iS
        XG6dWPlvVc5jLkdPArrVpu1+lyOg0/N0WsxWI4Qe+hCRkqj3j07Y6GIm8HMwt0SxMhOhuA0S8c0
        7ZV9N0mvBwk7/Awx+Y+gKXsB0USXAyRPUBpKhgdjVUc/h8Ki+CfS0Ip2eEHny+qryzYw2E8Jkw8
        KdMzN86KrauXd3MZDUmWr8IudHaZY7EsD8sJ4RmnZD6xFIV/7RouwLIEV6Ndox0gx1e5kxsj/pp
        vbA6Abxx197nyZNZFi3ndo6wlj4zfCT/60eMLUltXPtBcQqGXUODDY5/BuEsoxrk6Q2mIeSJ+wv
        7oJjhGclmajRS8yWxQwymtxuJ6y0=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--0.072100-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25544.003
X-MDID: 1594904447-TnlVewfZcdby
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

EF100 adds a few new valid addresses for efx_writed_page(), as well as
 a Function Control Window in the BAR whose location is variable.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/io.h         | 16 +++++++++++++---
 drivers/net/ethernet/sfc/net_driver.h |  2 ++
 2 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/sfc/io.h b/drivers/net/ethernet/sfc/io.h
index c3c011bc6a68..30439cc83a89 100644
--- a/drivers/net/ethernet/sfc/io.h
+++ b/drivers/net/ethernet/sfc/io.h
@@ -75,6 +75,11 @@
 #endif
 #endif
 
+static inline u32 efx_reg(struct efx_nic *efx, unsigned int reg)
+{
+	return efx->reg_base + reg;
+}
+
 #ifdef EFX_USE_QWORD_IO
 static inline void _efx_writeq(struct efx_nic *efx, __le64 value,
 				  unsigned int reg)
@@ -217,8 +222,11 @@ static inline void efx_reado_table(struct efx_nic *efx, efx_oword_t *value,
 	efx_reado(efx, value, reg + index * sizeof(efx_oword_t));
 }
 
-/* default VI stride (step between per-VI registers) is 8K */
-#define EFX_DEFAULT_VI_STRIDE 0x2000
+/* default VI stride (step between per-VI registers) is 8K on EF10 and
+ * 64K on EF100
+ */
+#define EFX_DEFAULT_VI_STRIDE		0x2000
+#define EF100_DEFAULT_VI_STRIDE		0x10000
 
 /* Calculate offset to page-mapped register */
 static inline unsigned int efx_paged_reg(struct efx_nic *efx, unsigned int page,
@@ -265,7 +273,9 @@ _efx_writed_page(struct efx_nic *efx, const efx_dword_t *value,
 #define efx_writed_page(efx, value, reg, page)				\
 	_efx_writed_page(efx, value,					\
 			 reg +						\
-			 BUILD_BUG_ON_ZERO((reg) != 0x400 &&		\
+			 BUILD_BUG_ON_ZERO((reg) != 0x180 &&		\
+					   (reg) != 0x200 &&		\
+					   (reg) != 0x400 &&		\
 					   (reg) != 0x420 &&		\
 					   (reg) != 0x830 &&		\
 					   (reg) != 0x83c &&		\
diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
index 0bf11ebb03cf..5b3b3a976114 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -966,6 +966,7 @@ struct efx_async_filter_insertion {
  * @xdp_rxq_info_failed: Have any of the rx queues failed to initialise their
  *      xdp_rxq_info structures?
  * @mem_bar: The BAR that is mapped into membase.
+ * @reg_base: Offset from the start of the bar to the function control window.
  * @monitor_work: Hardware monitor workitem
  * @biu_lock: BIU (bus interface unit) lock
  * @last_irq_cpu: Last CPU to handle a possible test interrupt.  This
@@ -1144,6 +1145,7 @@ struct efx_nic {
 	bool xdp_rxq_info_failed;
 
 	unsigned int mem_bar;
+	u32 reg_base;
 
 	/* The following fields may be written more often */
 

