Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 700F422EB91
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 13:56:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728277AbgG0L4g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 07:56:36 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:39518 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728096AbgG0L4g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 07:56:36 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.64])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id A70FE60073;
        Mon, 27 Jul 2020 11:56:35 +0000 (UTC)
Received: from us4-mdac16-5.ut7.mdlocal (unknown [10.7.65.73])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id A59282009B;
        Mon, 27 Jul 2020 11:56:35 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.66.36])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 38C99220052;
        Mon, 27 Jul 2020 11:56:35 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id E4F28B40056;
        Mon, 27 Jul 2020 11:56:34 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 27 Jul
 2020 12:56:29 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH v5 net-next 06/16] sfc_ef100: PHY probe stub
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <72cc6ef1-4f7f-bf22-5bec-942beb6353ed@solarflare.com>
Message-ID: <509cc065-22fc-3121-15e8-c323268e3bc8@solarflare.com>
Date:   Mon, 27 Jul 2020 12:56:26 +0100
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
X-TM-AS-Result: No-3.356300-8.000000-10
X-TMASE-MatchedRID: pm5esiOnALUczEPrqnY8wqOknopQLzTu9oVAKMBioqdpsnGGIgWMmer1
        /diGd3x+QOaAfcvrs37++3i1gpyN4kASN/wlEVscuwdUMMznEA/Uk/02d006RQdkFovAReUoaUX
        s6FguVy384sEICMMV1ZKcg2CYAgIT/MSiuOz98mXIFawn8e0/q5UQEUT9GpKNmyiLZetSf8nJ4y
        0wP1A6AEl4W8WVUOR/joczmuoPCq096pAK7wX9Q61B1ZtfcxHZeIWjnTZKGg9ZaGnZUO2gXJb7d
        cx+c8bPmEEDh72km7H97sGvvtUSP50gaOnOtTJPEwfNhVH9xhcXxY6mau8LG3IJh4dBcU42f4hp
        TpoBF9JqxGCSzFD9Mq9DVtyhkQKh
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--3.356300-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25566.005
X-MDID: 1595850995-PNHnprksuk4W
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We can't actually do the MCDI to probe it fully until we have working
 MCDI, which comes later, but we need efx->phy_data to be allocated so
 that when we get MCDI events the link-state change handler doesn't
 NULL-dereference.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/ef100_nic.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
index 875bbbdf606c..802ab0ce00fe 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.c
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -77,6 +77,16 @@ static irqreturn_t ef100_msi_interrupt(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
+static int ef100_phy_probe(struct efx_nic *efx)
+{
+	/* stub: allocate the phy_data */
+	efx->phy_data = kzalloc(sizeof(struct efx_mcdi_phy_data), GFP_KERNEL);
+	if (!efx->phy_data)
+		return -ENOMEM;
+
+	return 0;
+}
+
 /*	Other
  */
 
@@ -193,6 +203,10 @@ static int ef100_probe_main(struct efx_nic *efx)
 
 	efx->max_vis = EF100_MAX_VIS;
 
+	rc = ef100_phy_probe(efx);
+	if (rc)
+		goto fail;
+
 	rc = efx_init_channels(efx);
 	if (rc)
 		goto fail;

