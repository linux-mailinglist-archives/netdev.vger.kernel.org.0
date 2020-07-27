Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7B5022EB8C
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 13:55:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728173AbgG0Lzv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 07:55:51 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:49664 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727088AbgG0Lzu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 07:55:50 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.62])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id B4D8060061;
        Mon, 27 Jul 2020 11:55:50 +0000 (UTC)
Received: from us4-mdac16-56.ut7.mdlocal (unknown [10.7.64.50])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id B33BD8009B;
        Mon, 27 Jul 2020 11:55:50 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.66.38])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 48A7F28004D;
        Mon, 27 Jul 2020 11:55:50 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id F167E80005C;
        Mon, 27 Jul 2020 11:55:49 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 27 Jul
 2020 12:55:45 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH v5 net-next 03/16] sfc_ef100: register accesses on EF100
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <72cc6ef1-4f7f-bf22-5bec-942beb6353ed@solarflare.com>
Message-ID: <c5eb157b-9f00-0440-da3c-5b5add581e97@solarflare.com>
Date:   Mon, 27 Jul 2020 12:55:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <72cc6ef1-4f7f-bf22-5bec-942beb6353ed@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25566.005
X-TM-AS-Result: No-0.072100-8.000000-10
X-TMASE-MatchedRID: jedmkgCKCjoYap5fJ/fNIZzEHTUOuMX33V4UShoTXafg+jsHnpr1WAra
        NtW4DkZY8XVI39JCRnSjfNAVYAJRAr+Q0YdVmuyWnFVnNmvv47tLXPA26IG0hN9RlPzeVuQQ0iS
        XG6dWPlvVc5jLkdPArrVpu1+lyOg0/N0WsxWI4Qe+hCRkqj3j07Y6GIm8HMwt0SxMhOhuA0S8c0
        7ZV9N0mvBwk7/Awx+Y+gKXsB0USXAyRPUBpKhgdjVUc/h8Ki+CfS0Ip2eEHny+qryzYw2E8Jkw8
        KdMzN86KrauXd3MZDXQV04oxKezhVTb0GV0FiwXOJnRtxOe9NCRz49GtRP4dose+gBudUCfozrw
        d7N37OJJ+L4F2RFL92qMAyLpFSCXFc74zw+3LnTNH3x5bN0pZUODDY5/BuEsoxrk6Q2mIeSJ+wv
        7oJjhGclmajRS8yWxQwymtxuJ6y0=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--0.072100-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25566.005
X-MDID: 1595850950-iqq1G_nONqjx
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
index 786fda559976..db35beabdcff 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -964,6 +964,7 @@ struct efx_async_filter_insertion {
  * @xdp_rxq_info_failed: Have any of the rx queues failed to initialise their
  *      xdp_rxq_info structures?
  * @mem_bar: The BAR that is mapped into membase.
+ * @reg_base: Offset from the start of the bar to the function control window.
  * @monitor_work: Hardware monitor workitem
  * @biu_lock: BIU (bus interface unit) lock
  * @last_irq_cpu: Last CPU to handle a possible test interrupt.  This
@@ -1142,6 +1143,7 @@ struct efx_nic {
 	bool xdp_rxq_info_failed;
 
 	unsigned int mem_bar;
+	u32 reg_base;
 
 	/* The following fields may be written more often */
 

