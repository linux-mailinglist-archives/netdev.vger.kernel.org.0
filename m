Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C95A256007
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 19:51:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727818AbgH1RvR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 13:51:17 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:47590 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727020AbgH1RvO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Aug 2020 13:51:14 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.144])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id AA64C200E2;
        Fri, 28 Aug 2020 17:51:12 +0000 (UTC)
Received: from us4-mdac16-24.at1.mdlocal (unknown [10.110.49.206])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id A8B74800AD;
        Fri, 28 Aug 2020 17:51:12 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.49.74])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 4D7D940073;
        Fri, 28 Aug 2020 17:51:12 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 0116180063;
        Fri, 28 Aug 2020 17:51:12 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 28 Aug
 2020 18:51:07 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next 4/4] sfc: return errors from efx_mcdi_set_id_led, and
 de-indirect
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <57fd4501-4f13-37ee-d7f0-cda8b369bba6@solarflare.com>
Message-ID: <10231dae-64b3-ec1c-2418-28b2d9f86baf@solarflare.com>
Date:   Fri, 28 Aug 2020 18:51:04 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <57fd4501-4f13-37ee-d7f0-cda8b369bba6@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25630.005
X-TM-AS-Result: No-0.854500-8.000000-10
X-TMASE-MatchedRID: FSBaN85e6mdup+Fvuju4dzKVTrGMDe/D3V4UShoTXacHdnpVZivvnNye
        3V8KIGlWRVWmp4RlJdGVbXLNvAI4tuBwT9J7hz0BqJSK+HSPY+/pVMb1xnESMnAal2A1DQmsSlR
        0ZvLHomNFSgFpgI/Uf3DlPghqPnfyYlldA0POS1JTwo7VqN0EPJKLNrbpy/A0CyKtPCTkUEJ1gn
        ekL1c23oSIScQc4CjWDVNFmW/Go7gcvw2fLc9Qi6IBnfMCFBiCovA/6ONsv0qHX0cDZiY+DX1pa
        9OL1UpKBamXvGLN/H9Art0TmqQObLuz8zGC5XEHRXgK+YLiGCb2hUAowGKip0l/J9Ro+MAB1KG8
        hyHCM67K+xabey19MDAb3vofMJ1GTX7PJ/OU3vKDGx/OQ1GV8t0H8LFZNFG7CKFCmhdu5cWIEmy
        V2u4YzF//Y1vlkcV73lACMOJ3ecuslZT0/RMWYBVWus1PuaPi0mWTCrTEGhBxp+fSZW6DFhy5Y6
        oBVP/By/eIG6yaLMRazAigVxdXeiNlTYIDFiQj+C4IK5rEYL08DQfgROz55Z6oP1a0mRIj
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--0.854500-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25630.005
X-MDID: 1598637072-wSJYzE9rw-FF
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

W=1 warnings indicated that 'rc' was unused in efx_mcdi_set_id_led();
 change the function to return int instead of void and plumb the rc
 through the caller efx_ethtool_phys_id().
Since (post-Falcon) all sfc NICs use MCDI for this, there's no point in
 indirecting through a nic_type method, so remove that and just call
 efx_mcdi_set_id_led() directly.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/ef10.c       | 2 --
 drivers/net/ethernet/sfc/ethtool.c    | 3 +--
 drivers/net/ethernet/sfc/mcdi.c       | 6 ++----
 drivers/net/ethernet/sfc/mcdi.h       | 2 +-
 drivers/net/ethernet/sfc/net_driver.h | 2 --
 drivers/net/ethernet/sfc/siena.c      | 1 -
 6 files changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index 4b0b2cf026a5..0b4bcac53f18 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -3955,7 +3955,6 @@ const struct efx_nic_type efx_hunt_a0_vf_nic_type = {
 	.start_stats = efx_port_dummy_op_void,
 	.pull_stats = efx_port_dummy_op_void,
 	.stop_stats = efx_port_dummy_op_void,
-	.set_id_led = efx_mcdi_set_id_led,
 	.push_irq_moderation = efx_ef10_push_irq_moderation,
 	.reconfigure_mac = efx_ef10_mac_reconfigure,
 	.check_mac_fault = efx_mcdi_mac_check_fault,
@@ -4066,7 +4065,6 @@ const struct efx_nic_type efx_hunt_a0_nic_type = {
 	.start_stats = efx_mcdi_mac_start_stats,
 	.pull_stats = efx_mcdi_mac_pull_stats,
 	.stop_stats = efx_mcdi_mac_stop_stats,
-	.set_id_led = efx_mcdi_set_id_led,
 	.push_irq_moderation = efx_ef10_push_irq_moderation,
 	.reconfigure_mac = efx_ef10_mac_reconfigure,
 	.check_mac_fault = efx_mcdi_mac_check_fault,
diff --git a/drivers/net/ethernet/sfc/ethtool.c b/drivers/net/ethernet/sfc/ethtool.c
index 4ffda7782f68..12a91c559aa2 100644
--- a/drivers/net/ethernet/sfc/ethtool.c
+++ b/drivers/net/ethernet/sfc/ethtool.c
@@ -50,8 +50,7 @@ static int efx_ethtool_phys_id(struct net_device *net_dev,
 		return 1;	/* cycle on/off once per second */
 	}
 
-	efx->type->set_id_led(efx, mode);
-	return 0;
+	return efx_mcdi_set_id_led(efx, mode);
 }
 
 static int efx_ethtool_get_regs_len(struct net_device *net_dev)
diff --git a/drivers/net/ethernet/sfc/mcdi.c b/drivers/net/ethernet/sfc/mcdi.c
index 5467819aef6e..be6bfd6b7ec7 100644
--- a/drivers/net/ethernet/sfc/mcdi.c
+++ b/drivers/net/ethernet/sfc/mcdi.c
@@ -1868,10 +1868,9 @@ int efx_mcdi_handle_assertion(struct efx_nic *efx)
 	return efx_mcdi_exit_assertion(efx);
 }
 
-void efx_mcdi_set_id_led(struct efx_nic *efx, enum efx_led_mode mode)
+int efx_mcdi_set_id_led(struct efx_nic *efx, enum efx_led_mode mode)
 {
 	MCDI_DECLARE_BUF(inbuf, MC_CMD_SET_ID_LED_IN_LEN);
-	int rc;
 
 	BUILD_BUG_ON(EFX_LED_OFF != MC_CMD_LED_OFF);
 	BUILD_BUG_ON(EFX_LED_ON != MC_CMD_LED_ON);
@@ -1881,8 +1880,7 @@ void efx_mcdi_set_id_led(struct efx_nic *efx, enum efx_led_mode mode)
 
 	MCDI_SET_DWORD(inbuf, SET_ID_LED_IN_STATE, mode);
 
-	rc = efx_mcdi_rpc(efx, MC_CMD_SET_ID_LED, inbuf, sizeof(inbuf),
-			  NULL, 0, NULL);
+	return efx_mcdi_rpc(efx, MC_CMD_SET_ID_LED, inbuf, sizeof(inbuf), NULL, 0, NULL);
 }
 
 static int efx_mcdi_reset_func(struct efx_nic *efx)
diff --git a/drivers/net/ethernet/sfc/mcdi.h b/drivers/net/ethernet/sfc/mcdi.h
index 658cf345420d..8aed65018964 100644
--- a/drivers/net/ethernet/sfc/mcdi.h
+++ b/drivers/net/ethernet/sfc/mcdi.h
@@ -348,7 +348,7 @@ int efx_mcdi_nvram_info(struct efx_nic *efx, unsigned int type,
 int efx_new_mcdi_nvram_test_all(struct efx_nic *efx);
 int efx_mcdi_nvram_test_all(struct efx_nic *efx);
 int efx_mcdi_handle_assertion(struct efx_nic *efx);
-void efx_mcdi_set_id_led(struct efx_nic *efx, enum efx_led_mode mode);
+int efx_mcdi_set_id_led(struct efx_nic *efx, enum efx_led_mode mode);
 int efx_mcdi_wol_filter_set_magic(struct efx_nic *efx, const u8 *mac,
 				  int *id_out);
 int efx_mcdi_wol_filter_get_magic(struct efx_nic *efx, int *id_out);
diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
index 062462a13847..338ebb0402be 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -1217,7 +1217,6 @@ struct efx_udp_tunnel {
  * @start_stats: Start the regular fetching of statistics
  * @pull_stats: Pull stats from the NIC and wait until they arrive.
  * @stop_stats: Stop the regular fetching of statistics
- * @set_id_led: Set state of identifying LED or revert to automatic function
  * @push_irq_moderation: Apply interrupt moderation value
  * @reconfigure_port: Push loopback/power/txdis changes to the MAC and PHY
  * @prepare_enable_fc_tx: Prepare MAC to enable pause frame TX (may be %NULL)
@@ -1362,7 +1361,6 @@ struct efx_nic_type {
 	void (*start_stats)(struct efx_nic *efx);
 	void (*pull_stats)(struct efx_nic *efx);
 	void (*stop_stats)(struct efx_nic *efx);
-	void (*set_id_led)(struct efx_nic *efx, enum efx_led_mode mode);
 	void (*push_irq_moderation)(struct efx_channel *channel);
 	int (*reconfigure_port)(struct efx_nic *efx);
 	void (*prepare_enable_fc_tx)(struct efx_nic *efx);
diff --git a/drivers/net/ethernet/sfc/siena.c b/drivers/net/ethernet/sfc/siena.c
index a7ea630bb5e6..16347a6d0c47 100644
--- a/drivers/net/ethernet/sfc/siena.c
+++ b/drivers/net/ethernet/sfc/siena.c
@@ -994,7 +994,6 @@ const struct efx_nic_type siena_a0_nic_type = {
 	.start_stats = efx_mcdi_mac_start_stats,
 	.pull_stats = efx_mcdi_mac_pull_stats,
 	.stop_stats = efx_mcdi_mac_stop_stats,
-	.set_id_led = efx_mcdi_set_id_led,
 	.push_irq_moderation = siena_push_irq_moderation,
 	.reconfigure_mac = siena_mac_reconfigure,
 	.check_mac_fault = efx_mcdi_mac_check_fault,
