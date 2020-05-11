Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B81391CD9D6
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 14:30:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729852AbgEKM3J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 08:29:09 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:41144 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728084AbgEKM3H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 08:29:07 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.61])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 17D2D6009E;
        Mon, 11 May 2020 12:29:07 +0000 (UTC)
Received: from us4-mdac16-68.ut7.mdlocal (unknown [10.7.64.187])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 16A6A8009E;
        Mon, 11 May 2020 12:29:07 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.200])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 8665880055;
        Mon, 11 May 2020 12:29:06 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 24B5080005A;
        Mon, 11 May 2020 12:29:06 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Mon, 11 May
 2020 13:29:00 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next 3/8] sfc: use efx_has_cap for capability checks
 outside of NIC-specific code
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <8154dba6-b312-7dcf-7d49-cd6c6801ffc2@solarflare.com>
Message-ID: <a10a500f-c0a6-dfb4-a0c9-8227e9cb7063@solarflare.com>
Date:   Mon, 11 May 2020 13:28:56 +0100
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
X-TM-AS-Result: No-3.573000-8.000000-10
X-TMASE-MatchedRID: zZPFt0T/L0Vp0Nopn/8qraiUivh0j2Pv6VTG9cZxEjJwGpdgNQ0JrHIo
        zGa69omdrdoLblq9S5ra/g/NGTW3Mh7jjY8HRMMmNDrSVZCgbStzwDh4RTtcHBpX1zEL4nq3js8
        MyAebIYvv2XMgemP1n/bNVpMEKpoVgwwjflvizAnJ1E/nrJFED0qAhuLHn5fEWkvncDztolvnsl
        jC0VX9i/D1SjBOv1fSPCFkxA7eE67C/SXuUCCGwZ4CIKY/Hg3AtOt1ofVlaoLWRN8STJpl3PoLR
        4+zsDTtSeDAqzk56OfhZniXbJr+RI2bP1BABIAhqE9VzYr/UDSjqeE4EfkMx6KGVwSALwSa0N5j
        py8L7zTPyovlyVPDTTHLuOwqnfPxd/T+eEh5Jr985uoYr0mmWaKdpX90rRoSErdW3Lyhe2TZKwv
        JjiAfi8C+ksT6a9fy
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--3.573000-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25412.003
X-MDID: 1589200147-buJiBwcCS1Nu
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Removes some efx_ef10_nic_data references from common code.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/mcdi_filters.c | 13 ++++---------
 drivers/net/ethernet/sfc/ptp.c          |  7 +------
 2 files changed, 5 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/sfc/mcdi_filters.c b/drivers/net/ethernet/sfc/mcdi_filters.c
index e6268556b030..39f8a91c1222 100644
--- a/drivers/net/ethernet/sfc/mcdi_filters.c
+++ b/drivers/net/ethernet/sfc/mcdi_filters.c
@@ -829,8 +829,7 @@ static int efx_mcdi_filter_insert_def(struct efx_nic *efx,
 		efx_filter_set_uc_def(&spec);
 
 	if (encap_type) {
-		if (nic_data->datapath_caps &
-		    (1 << MC_CMD_GET_CAPABILITIES_OUT_VXLAN_NVGRE_LBN))
+		if (efx_has_cap(efx, VXLAN_NVGRE, FLAGS1))
 			efx_filter_set_encap_type(&spec, encap_type);
 		else
 			/*
@@ -1309,8 +1308,7 @@ int efx_mcdi_filter_table_probe(struct efx_nic *efx)
 	rc = efx_mcdi_filter_table_probe_matches(efx, table, false);
 	if (rc)
 		goto fail;
-	if (nic_data->datapath_caps &
-		   (1 << MC_CMD_GET_CAPABILITIES_OUT_VXLAN_NVGRE_LBN))
+	if (efx_has_cap(efx, VXLAN_NVGRE, FLAGS1))
 		rc = efx_mcdi_filter_table_probe_matches(efx, table, true);
 	if (rc)
 		goto fail;
@@ -1920,7 +1918,6 @@ static int efx_mcdi_filter_alloc_rss_context(struct efx_nic *efx, bool exclusive
 {
 	MCDI_DECLARE_BUF(inbuf, MC_CMD_RSS_CONTEXT_ALLOC_IN_LEN);
 	MCDI_DECLARE_BUF(outbuf, MC_CMD_RSS_CONTEXT_ALLOC_OUT_LEN);
-	struct efx_ef10_nic_data *nic_data = efx->nic_data;
 	size_t outlen;
 	int rc;
 	u32 alloc_type = exclusive ?
@@ -1938,8 +1935,7 @@ static int efx_mcdi_filter_alloc_rss_context(struct efx_nic *efx, bool exclusive
 		return 0;
 	}
 
-	if (nic_data->datapath_caps &
-	    1 << MC_CMD_GET_CAPABILITIES_OUT_RX_RSS_LIMITED_LBN)
+	if (efx_has_cap(efx, RX_RSS_LIMITED, FLAGS1))
 		return -EOPNOTSUPP;
 
 	MCDI_SET_DWORD(inbuf, RSS_CONTEXT_ALLOC_IN_UPSTREAM_PORT_ID,
@@ -1960,8 +1956,7 @@ static int efx_mcdi_filter_alloc_rss_context(struct efx_nic *efx, bool exclusive
 	if (context_size)
 		*context_size = rss_spread;
 
-	if (nic_data->datapath_caps &
-	    1 << MC_CMD_GET_CAPABILITIES_OUT_ADDITIONAL_RSS_MODES_LBN)
+	if (efx_has_cap(efx, ADDITIONAL_RSS_MODES, FLAGS1))
 		efx_mcdi_set_rss_context_flags(efx, ctx);
 
 	return 0;
diff --git a/drivers/net/ethernet/sfc/ptp.c b/drivers/net/ethernet/sfc/ptp.c
index 59b4f16896a8..04c7283d205e 100644
--- a/drivers/net/ethernet/sfc/ptp.c
+++ b/drivers/net/ethernet/sfc/ptp.c
@@ -352,12 +352,7 @@ static int efx_phc_enable(struct ptp_clock_info *ptp,
 
 bool efx_ptp_use_mac_tx_timestamps(struct efx_nic *efx)
 {
-	struct efx_ef10_nic_data *nic_data = efx->nic_data;
-
-	return ((efx_nic_rev(efx) >= EFX_REV_HUNT_A0) &&
-		(nic_data->datapath_caps2 &
-		 (1 << MC_CMD_GET_CAPABILITIES_V2_OUT_TX_MAC_TIMESTAMPING_LBN)
-		));
+	return efx_has_cap(efx, TX_MAC_TIMESTAMPING, FLAGS2);
 }
 
 /* PTP 'extra' channel is still a traffic channel, but we only create TX queues

