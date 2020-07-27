Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86C4622EBB0
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 14:06:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728071AbgG0MF7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 08:05:59 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:54832 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726989AbgG0MF6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 08:05:58 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.64])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 6CF0960053;
        Mon, 27 Jul 2020 12:05:58 +0000 (UTC)
Received: from us4-mdac16-9.ut7.mdlocal (unknown [10.7.65.177])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 6A1612009B;
        Mon, 27 Jul 2020 12:05:58 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.66.35])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id EC75922005B;
        Mon, 27 Jul 2020 12:05:56 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id A3DDE480072;
        Mon, 27 Jul 2020 12:05:56 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 27 Jul
 2020 13:05:51 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH v5 net-next 16/16] sfc_ef100: implement
 ndo_get_phys_port_{id,name}
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <72cc6ef1-4f7f-bf22-5bec-942beb6353ed@solarflare.com>
Message-ID: <357833f5-bafa-42c7-8c78-f48dd1315741@solarflare.com>
Date:   Mon, 27 Jul 2020 13:05:48 +0100
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
X-TM-AS-Result: No-2.279300-8.000000-10
X-TMASE-MatchedRID: Nndoh8f4x+xAEjf8JRFbHLsHVDDM5xAP1JP9NndNOkUGmHr1eMxt2UAc
        6DyoS2rIj6kCfX0Edc6tL1mMSnuv19J+QjwsijM7HPYwOJi6PLnAqRukGkkpQockQTW2P5j0+NY
        BZrpe1untp8eQSZp9k2IlxuxNQIAzhSCxa/xQsJ8HtOpEBhWiFjxWJr0lgcJAR2YNIFh+clHZnl
        3Zzq2mdqoMs5ie4OWJYNI7+yLTVqr1Yq2jDpf9L8n9tWHiLD2GV+i3zVbUXsibKItl61J/ycnjL
        TA/UDoAA6QGdvwfwZbkwjHXXC/4I6u+08oqCcwYVc0swsY6c30xqZ/lvcqG9qVgcXhceesAmunS
        wamAC7Jz9SUB2hNRTh6c7oqiTl+h5XwGrZzjrraXVwGz2YMtzhu+5UArfeSokERyuRHFgnhSMqc
        7UpUorBKRsPC6bTvOqrQxXydIwG+dGcx97VaKlFZca9RSYo/b
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10-2.279300-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25566.005
X-MDID: 1595851557-VwAY_3rvoAav
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/ef100_netdev.c |  2 ++
 drivers/net/ethernet/sfc/ef100_nic.c    | 21 +++++++++++++++++++++
 2 files changed, 23 insertions(+)

diff --git a/drivers/net/ethernet/sfc/ef100_netdev.c b/drivers/net/ethernet/sfc/ef100_netdev.c
index d1753ed7aaca..4c3caac2c8cc 100644
--- a/drivers/net/ethernet/sfc/ef100_netdev.c
+++ b/drivers/net/ethernet/sfc/ef100_netdev.c
@@ -208,6 +208,8 @@ static const struct net_device_ops ef100_netdev_ops = {
 	.ndo_open               = ef100_net_open,
 	.ndo_stop               = ef100_net_stop,
 	.ndo_start_xmit         = ef100_hard_start_xmit,
+	.ndo_get_phys_port_id   = efx_get_phys_port_id,
+	.ndo_get_phys_port_name = efx_get_phys_port_name,
 };
 
 /*	Netdev registration
diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
index 1161190391b1..6a00f2a2dc2b 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.c
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -403,6 +403,20 @@ static int ef100_reset(struct efx_nic *efx, enum reset_type reset_type)
 	return rc;
 }
 
+static int efx_ef100_get_phys_port_id(struct efx_nic *efx,
+				      struct netdev_phys_item_id *ppid)
+{
+	struct ef100_nic_data *nic_data = efx->nic_data;
+
+	if (!is_valid_ether_addr(nic_data->port_id))
+		return -EOPNOTSUPP;
+
+	ppid->id_len = ETH_ALEN;
+	memcpy(ppid->id, nic_data->port_id, ppid->id_len);
+
+	return 0;
+}
+
 static unsigned int ef100_check_caps(const struct efx_nic *efx,
 				     u8 flag, u32 offset)
 {
@@ -459,6 +473,8 @@ const struct efx_nic_type ef100_pf_nic_type = {
 	.rx_write = ef100_rx_write,
 	.rx_packet = __ef100_rx_packet,
 
+	.get_phys_port_id = efx_ef100_get_phys_port_id,
+
 	.reconfigure_mac = ef100_reconfigure_mac,
 
 	/* Per-type bar/size configuration not used on ef100. Location of
@@ -541,6 +557,11 @@ static int ef100_probe_main(struct efx_nic *efx)
 
 	efx->max_vis = EF100_MAX_VIS;
 
+	rc = efx_mcdi_port_get_number(efx);
+	if (rc < 0)
+		goto fail;
+	efx->port_num = rc;
+
 	rc = ef100_phy_probe(efx);
 	if (rc)
 		goto fail;
