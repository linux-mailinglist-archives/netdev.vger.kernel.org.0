Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FC831CD9DC
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 14:30:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729959AbgEKM3o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 08:29:44 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:58156 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729544AbgEKM3o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 08:29:44 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.64])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 8F0756008E;
        Mon, 11 May 2020 12:29:43 +0000 (UTC)
Received: from us4-mdac16-20.ut7.mdlocal (unknown [10.7.65.244])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 8DAC52009B;
        Mon, 11 May 2020 12:29:43 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.66.37])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 0AE5522006C;
        Mon, 11 May 2020 12:29:43 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id AEFDFB4005A;
        Mon, 11 May 2020 12:29:42 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Mon, 11 May
 2020 13:29:37 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next 6/8] sfc: move rx_rss_context_exclusive into struct
 efx_mcdi_filter_table
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <8154dba6-b312-7dcf-7d49-cd6c6801ffc2@solarflare.com>
Message-ID: <b73dbc35-da87-abc2-36c4-efc63779caa2@solarflare.com>
Date:   Mon, 11 May 2020 13:29:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <8154dba6-b312-7dcf-7d49-cd6c6801ffc2@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25412.003
X-TM-AS-Result: No-2.588600-8.000000-10
X-TMASE-MatchedRID: m7WZ8aMCXJBAzKbF/mdxtuW/ghHXKl4uB4Id7CiQcz9jLp8Cm8vwFwoe
        RRhCZWIBnvBWG5GT8Jdw5T4Iaj538mJZXQNDzktSR/j040fRFpK6hgVvSdGKo1VkJxysad/Is20
        IP1TczPgh1dFwqj8QiF+AaPS23fvgwlUZfPqWFzIqsMfMfrOZRRA5wxKjT3bqi7p9NckzZOsVAs
        f1+cZFJ9u9HSeKDBZ/avgXozbP4yzgYQ4tT+k+HVkxnoxnQfVSOtlHh2+ppE9D9iPiuXvzgXPWW
        DY7hSSV8pUbVzcvWp8dF8BZ6EBXsE1+zyfzlN7ygxsfzkNRlfLDm6Dz1lUoy/oLR4+zsDTtfxVE
        I3DSSIOpobK3g/0DgnwT/XVNWktlAYgUr3OsuNkBqoxZw3y8IEoaO9Ch2Wx8yBaSZex8oQgw3FP
        h5NOljL3yZEEcxDgddU/2kdQe0J585uoYr0mmWaKdpX90rRoSErdW3Lyhe2TZKwvJjiAfi8C+ks
        T6a9fy
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--2.588600-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25412.003
X-MDID: 1589200183-eBy4wMLQChha
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It's both set and used solely by mcdi_filters.c, so there's no reason
 for it to be in ef10-specific nic_data.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/mcdi_filters.c | 10 +++++-----
 drivers/net/ethernet/sfc/mcdi_filters.h |  2 ++
 drivers/net/ethernet/sfc/nic.h          |  2 --
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/sfc/mcdi_filters.c b/drivers/net/ethernet/sfc/mcdi_filters.c
index d3c2e6eb3191..e99b3149c4ae 100644
--- a/drivers/net/ethernet/sfc/mcdi_filters.c
+++ b/drivers/net/ethernet/sfc/mcdi_filters.c
@@ -2031,14 +2031,14 @@ void efx_mcdi_rx_free_indir_table(struct efx_nic *efx)
 static int efx_mcdi_filter_rx_push_shared_rss_config(struct efx_nic *efx,
 					      unsigned *context_size)
 {
-	struct efx_ef10_nic_data *nic_data = efx->nic_data;
+	struct efx_mcdi_filter_table *table = efx->filter_state;
 	int rc = efx_mcdi_filter_alloc_rss_context(efx, false, &efx->rss_context,
 					    context_size);
 
 	if (rc != 0)
 		return rc;
 
-	nic_data->rx_rss_context_exclusive = false;
+	table->rx_rss_context_exclusive = false;
 	efx_set_default_rx_indir_table(efx, &efx->rss_context);
 	return 0;
 }
@@ -2047,12 +2047,12 @@ static int efx_mcdi_filter_rx_push_exclusive_rss_config(struct efx_nic *efx,
 						 const u32 *rx_indir_table,
 						 const u8 *key)
 {
+	struct efx_mcdi_filter_table *table = efx->filter_state;
 	u32 old_rx_rss_context = efx->rss_context.context_id;
-	struct efx_ef10_nic_data *nic_data = efx->nic_data;
 	int rc;
 
 	if (efx->rss_context.context_id == EFX_MCDI_RSS_CONTEXT_INVALID ||
-	    !nic_data->rx_rss_context_exclusive) {
+	    !table->rx_rss_context_exclusive) {
 		rc = efx_mcdi_filter_alloc_rss_context(efx, true, &efx->rss_context,
 						NULL);
 		if (rc == -EOPNOTSUPP)
@@ -2069,7 +2069,7 @@ static int efx_mcdi_filter_rx_push_exclusive_rss_config(struct efx_nic *efx,
 	if (efx->rss_context.context_id != old_rx_rss_context &&
 	    old_rx_rss_context != EFX_MCDI_RSS_CONTEXT_INVALID)
 		WARN_ON(efx_mcdi_filter_free_rss_context(efx, old_rx_rss_context) != 0);
-	nic_data->rx_rss_context_exclusive = true;
+	table->rx_rss_context_exclusive = true;
 	if (rx_indir_table != efx->rss_context.rx_indir_table)
 		memcpy(efx->rss_context.rx_indir_table, rx_indir_table,
 		       sizeof(efx->rss_context.rx_indir_table));
diff --git a/drivers/net/ethernet/sfc/mcdi_filters.h b/drivers/net/ethernet/sfc/mcdi_filters.h
index 15b5d62e3670..03a8bf74c733 100644
--- a/drivers/net/ethernet/sfc/mcdi_filters.h
+++ b/drivers/net/ethernet/sfc/mcdi_filters.h
@@ -55,6 +55,8 @@ struct efx_mcdi_filter_table {
 	u32 rx_match_mcdi_flags[
 		MC_CMD_GET_PARSER_DISP_INFO_OUT_SUPPORTED_MATCHES_MAXNUM * 2];
 	unsigned int rx_match_count;
+	/* Our RSS context is exclusive (as opposed to shared) */
+	bool rx_rss_context_exclusive;
 
 	struct rw_semaphore lock; /* Protects entries */
 	struct {
diff --git a/drivers/net/ethernet/sfc/nic.h b/drivers/net/ethernet/sfc/nic.h
index 46583ba8fa24..8f73c5d996eb 100644
--- a/drivers/net/ethernet/sfc/nic.h
+++ b/drivers/net/ethernet/sfc/nic.h
@@ -368,7 +368,6 @@ enum {
  * @piobuf_size: size of a single PIO buffer
  * @must_restore_piobufs: Flag: PIO buffers have yet to be restored after MC
  *	reboot
- * @rx_rss_context_exclusive: Whether our RSS context is exclusive or shared
  * @stats: Hardware statistics
  * @workaround_35388: Flag: firmware supports workaround for bug 35388
  * @workaround_26807: Flag: firmware supports workaround for bug 26807
@@ -405,7 +404,6 @@ struct efx_ef10_nic_data {
 	unsigned int piobuf_handle[EF10_TX_PIOBUF_COUNT];
 	u16 piobuf_size;
 	bool must_restore_piobufs;
-	bool rx_rss_context_exclusive;
 	u64 stats[EF10_STAT_COUNT];
 	bool workaround_35388;
 	bool workaround_26807;

