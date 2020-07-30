Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EA1323349C
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 16:39:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729658AbgG3Oji (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 10:39:38 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:34552 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726535AbgG3Ojh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 10:39:37 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.64])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 9D982601EB;
        Thu, 30 Jul 2020 14:39:36 +0000 (UTC)
Received: from us4-mdac16-8.ut7.mdlocal (unknown [10.7.65.76])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 6D67D201A9;
        Thu, 30 Jul 2020 14:39:28 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.66.31])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id A72D02200D5;
        Thu, 30 Jul 2020 14:39:27 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 22BD09400AA;
        Thu, 30 Jul 2020 14:39:27 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 30 Jul
 2020 15:39:14 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next 09/12] sfc_ef100: functions for selftests
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <abac4f27-7fac-2bd4-636b-4cfc401603ae@solarflare.com>
Message-ID: <25ea3c4b-4cdf-c9aa-7886-1245810bd7fd@solarflare.com>
Date:   Thu, 30 Jul 2020 15:39:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <abac4f27-7fac-2bd4-636b-4cfc401603ae@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25572.005
X-TM-AS-Result: No-2.852500-8.000000-10
X-TMASE-MatchedRID: EAa86knd6j58CONowvwu66iUivh0j2Pv6VTG9cZxEjJwGpdgNQ0JrEAc
        6DyoS2rIj6kCfX0Edc6c3101Na/2QgH6fkEt04KVogGd8wIUGILyCvICuK46ckWw8G9zeWcKsz8
        QWnnsobaKzszP76WBxP0Q2hVz5gMVJtllgBC70flIcJTn2HkqsTrZR4dvqaRPQ/Yj4rl784Gy18
        vpZ8JjMScJc9vAi8aXKHiw7uVx0/e+zVeD5435mglpVkdtt3WuYFTPdN5lYYrRLEyE6G4DRA0/c
        jFmbp1nnxtmsJVK9Um9TnZXLseR1k1+zyfzlN7ygxsfzkNRlfLdB/CxWTRRu+rAZ8KTspSzvgc/
        Vz/IsnjpXlSwONYSlVFQOhwcXe+1wbCQGEGZD9GtE9n6QIS6yArri88Bju7p5Ill0Wa6x/unzDO
        fCoZ6ty/hg5U1zyC7WswIoFcXV3ojZU2CAxYkI/guCCuaxGC9PA0H4ETs+eV+3BndfXUhXQ==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--2.852500-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25572.005
X-MDID: 1596119968-1SV_bjw6WE5k
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Self-tests for event and interrupt reception and NVRAM.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/ef100_nic.c | 47 ++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
index 424a0a2065e4..5079f00c1b97 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.c
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -630,6 +630,50 @@ static int efx_ef100_get_phys_port_id(struct efx_nic *efx,
 	return 0;
 }
 
+static int efx_ef100_irq_test_generate(struct efx_nic *efx)
+{
+	MCDI_DECLARE_BUF(inbuf, MC_CMD_TRIGGER_INTERRUPT_IN_LEN);
+
+	BUILD_BUG_ON(MC_CMD_TRIGGER_INTERRUPT_OUT_LEN != 0);
+
+	MCDI_SET_DWORD(inbuf, TRIGGER_INTERRUPT_IN_INTR_LEVEL, efx->irq_level);
+	return efx_mcdi_rpc_quiet(efx, MC_CMD_TRIGGER_INTERRUPT,
+				  inbuf, sizeof(inbuf), NULL, 0, NULL);
+}
+
+#define EFX_EF100_TEST 1
+
+static void efx_ef100_ev_test_generate(struct efx_channel *channel)
+{
+	MCDI_DECLARE_BUF(inbuf, MC_CMD_DRIVER_EVENT_IN_LEN);
+	struct efx_nic *efx = channel->efx;
+	efx_qword_t event;
+	int rc;
+
+	EFX_POPULATE_QWORD_2(event,
+			     ESF_GZ_E_TYPE, ESE_GZ_EF100_EV_DRIVER,
+			     ESF_GZ_DRIVER_DATA, EFX_EF100_TEST);
+
+	MCDI_SET_DWORD(inbuf, DRIVER_EVENT_IN_EVQ, channel->channel);
+
+	/* MCDI_SET_QWORD is not appropriate here since EFX_POPULATE_* has
+	 * already swapped the data to little-endian order.
+	 */
+	memcpy(MCDI_PTR(inbuf, DRIVER_EVENT_IN_DATA), &event.u64[0],
+	       sizeof(efx_qword_t));
+
+	rc = efx_mcdi_rpc(efx, MC_CMD_DRIVER_EVENT, inbuf, sizeof(inbuf),
+			  NULL, 0, NULL);
+	if (rc && (rc != -ENETDOWN))
+		goto fail;
+
+	return;
+
+fail:
+	WARN_ON(true);
+	netif_err(efx, hw, efx->net_dev, "%s: failed rc=%d\n", __func__, rc);
+}
+
 static unsigned int ef100_check_caps(const struct efx_nic *efx,
 				     u8 flag, u32 offset)
 {
@@ -666,6 +710,7 @@ const struct efx_nic_type ef100_pf_nic_type = {
 	.mcdi_poll_reboot = ef100_mcdi_poll_reboot,
 	.mcdi_reboot_detected = ef100_mcdi_reboot_detected,
 	.irq_enable_master = efx_port_dummy_op_void,
+	.irq_test_generate = efx_ef100_irq_test_generate,
 	.irq_disable_non_ev = efx_port_dummy_op_void,
 	.push_irq_moderation = efx_channel_dummy_op_void,
 	.min_interrupt_mode = EFX_INT_MODE_MSIX,
@@ -682,6 +727,7 @@ const struct efx_nic_type ef100_pf_nic_type = {
 	.irq_handle_msi = ef100_msi_interrupt,
 	.ev_process = ef100_ev_process,
 	.ev_read_ack = ef100_ev_read_ack,
+	.ev_test_generate = efx_ef100_ev_test_generate,
 	.tx_probe = ef100_tx_probe,
 	.tx_init = ef100_tx_init,
 	.tx_write = ef100_tx_write,
@@ -718,6 +764,7 @@ const struct efx_nic_type ef100_pf_nic_type = {
 	.rx_restore_rss_contexts = efx_mcdi_rx_restore_rss_contexts,
 
 	.reconfigure_mac = ef100_reconfigure_mac,
+	.test_nvram = efx_new_mcdi_nvram_test_all,
 	.describe_stats = ef100_describe_stats,
 	.start_stats = efx_mcdi_mac_start_stats,
 	.update_stats = ef100_update_stats,

