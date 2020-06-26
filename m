Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F072220B06D
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 13:28:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728532AbgFZL2H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 07:28:07 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:55936 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728523AbgFZL2H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 07:28:07 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.144])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 5C15F2006E;
        Fri, 26 Jun 2020 11:28:06 +0000 (UTC)
Received: from us4-mdac16-59.at1.mdlocal (unknown [10.110.50.152])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 5B0B6800A9;
        Fri, 26 Jun 2020 11:28:06 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.49.104])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 0737A4004D;
        Fri, 26 Jun 2020 11:28:06 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id C1BF4B8005D;
        Fri, 26 Jun 2020 11:28:05 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 26 Jun
 2020 12:27:59 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next 02/15] sfc: determine flag word automatically in
 efx_has_cap()
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <1a1716f9-f909-4093-8107-3c2435d834c5@solarflare.com>
Message-ID: <c4c79b03-b91a-456f-14b5-773328a6c311@solarflare.com>
Date:   Fri, 26 Jun 2020 12:27:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <1a1716f9-f909-4093-8107-3c2435d834c5@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25504.003
X-TM-AS-Result: No-0.986600-8.000000-10
X-TMASE-MatchedRID: s87GQfVN3I6wIZP5FYus+6iUivh0j2Pv6VTG9cZxEjJwGpdgNQ0JrHIo
        zGa69omdrdoLblq9S5q/nbinVJUgUmqlda3GsGxBNDrSVZCgbSsEa8g1x8eqF2KlK5+L2DIQiZs
        lgYzLMZCWkqk2IvguWhlUBrHxgzzBpg8tcTqC4r9lpwNsTvdlKQokziiS8fleSLM0mI0IXo1x1B
        wqk2Gx7SHCwXF3ObcxLFEi64+oS36gydWvvusR8Raon88GOG1alCVC/a5T8eKbKItl61J/ycnjL
        TA/UDoASXhbxZVQ5H+OhzOa6g8KrYoIcsPxTZiyqtehtrTiwrM9Rpq+eKTYH/KAztQlhSiJqKFS
        w+mrNMnXrXZZLAJhpr2lF1GjjoPRtJoAIOQRjIedXKv6hht4oxfFjqZq7wsbcgmHh0FxTjZ/iGl
        OmgEX0mrEYJLMUP0ysMxa9dfPWWuUTGVAhB5EbQ==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--0.986600-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25504.003
X-MDID: 1593170886-FLg5tl7X2LcD
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that we have an _OFST definition for each individual flag bit,
 callers of efx_has_cap() don't need to specify which flag word it's
 in; we can just use the flag name directly in MCDI_CAPABILITY_OFST.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/mcdi.h         | 5 ++---
 drivers/net/ethernet/sfc/mcdi_filters.c | 8 ++++----
 drivers/net/ethernet/sfc/ptp.c          | 2 +-
 3 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/sfc/mcdi.h b/drivers/net/ethernet/sfc/mcdi.h
index b107e4c00285..db9746a751d4 100644
--- a/drivers/net/ethernet/sfc/mcdi.h
+++ b/drivers/net/ethernet/sfc/mcdi.h
@@ -332,10 +332,9 @@ void efx_mcdi_sensor_event(struct efx_nic *efx, efx_qword_t *ev);
 #define MCDI_CAPABILITY_OFST(field) \
 	MC_CMD_GET_CAPABILITIES_V4_OUT_ ## field ## _OFST
 
-/* field is FLAGS1 or FLAGS2 */
-#define efx_has_cap(efx, flag, field) \
+#define efx_has_cap(efx, field) \
 	efx->type->check_caps(efx, \
-			      MCDI_CAPABILITY(flag), \
+			      MCDI_CAPABILITY(field), \
 			      MCDI_CAPABILITY_OFST(field))
 
 void efx_mcdi_print_fwver(struct efx_nic *efx, char *buf, size_t len);
diff --git a/drivers/net/ethernet/sfc/mcdi_filters.c b/drivers/net/ethernet/sfc/mcdi_filters.c
index 455a62814fb9..7b39a3aa3a1a 100644
--- a/drivers/net/ethernet/sfc/mcdi_filters.c
+++ b/drivers/net/ethernet/sfc/mcdi_filters.c
@@ -828,7 +828,7 @@ static int efx_mcdi_filter_insert_def(struct efx_nic *efx,
 		efx_filter_set_uc_def(&spec);
 
 	if (encap_type) {
-		if (efx_has_cap(efx, VXLAN_NVGRE, FLAGS1))
+		if (efx_has_cap(efx, VXLAN_NVGRE))
 			efx_filter_set_encap_type(&spec, encap_type);
 		else
 			/*
@@ -1304,7 +1304,7 @@ int efx_mcdi_filter_table_probe(struct efx_nic *efx, bool multicast_chaining)
 	rc = efx_mcdi_filter_table_probe_matches(efx, table, false);
 	if (rc)
 		goto fail;
-	if (efx_has_cap(efx, VXLAN_NVGRE, FLAGS1))
+	if (efx_has_cap(efx, VXLAN_NVGRE))
 		rc = efx_mcdi_filter_table_probe_matches(efx, table, true);
 	if (rc)
 		goto fail;
@@ -1927,7 +1927,7 @@ static int efx_mcdi_filter_alloc_rss_context(struct efx_nic *efx, bool exclusive
 		return 0;
 	}
 
-	if (efx_has_cap(efx, RX_RSS_LIMITED, FLAGS1))
+	if (efx_has_cap(efx, RX_RSS_LIMITED))
 		return -EOPNOTSUPP;
 
 	MCDI_SET_DWORD(inbuf, RSS_CONTEXT_ALLOC_IN_UPSTREAM_PORT_ID,
@@ -1948,7 +1948,7 @@ static int efx_mcdi_filter_alloc_rss_context(struct efx_nic *efx, bool exclusive
 	if (context_size)
 		*context_size = rss_spread;
 
-	if (efx_has_cap(efx, ADDITIONAL_RSS_MODES, FLAGS1))
+	if (efx_has_cap(efx, ADDITIONAL_RSS_MODES))
 		efx_mcdi_set_rss_context_flags(efx, ctx);
 
 	return 0;
diff --git a/drivers/net/ethernet/sfc/ptp.c b/drivers/net/ethernet/sfc/ptp.c
index 04c7283d205e..15c08cae6ae6 100644
--- a/drivers/net/ethernet/sfc/ptp.c
+++ b/drivers/net/ethernet/sfc/ptp.c
@@ -352,7 +352,7 @@ static int efx_phc_enable(struct ptp_clock_info *ptp,
 
 bool efx_ptp_use_mac_tx_timestamps(struct efx_nic *efx)
 {
-	return efx_has_cap(efx, TX_MAC_TIMESTAMPING, FLAGS2);
+	return efx_has_cap(efx, TX_MAC_TIMESTAMPING);
 }
 
 /* PTP 'extra' channel is still a traffic channel, but we only create TX queues

