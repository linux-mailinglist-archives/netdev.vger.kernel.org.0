Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 096FE22C9A8
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 18:01:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726717AbgGXQBc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 12:01:32 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:50390 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726493AbgGXQBb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 12:01:31 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.143])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 69C712009D;
        Fri, 24 Jul 2020 16:01:30 +0000 (UTC)
Received: from us4-mdac16-64.at1.mdlocal (unknown [10.110.50.158])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 67F8D800B0;
        Fri, 24 Jul 2020 16:01:30 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.49.104])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id E9A624006E;
        Fri, 24 Jul 2020 16:01:29 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id B2A82B8007F;
        Fri, 24 Jul 2020 16:01:29 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 24 Jul
 2020 17:01:24 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH v4 net-next 16/16] sfc_ef100: implement
 ndo_get_phys_port_{id,name}
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <d224dbb2-ef20-dca9-d50b-7f583b45d859@solarflare.com>
Message-ID: <9c2ba7c3-f56c-6608-1a96-0d48b17e47b6@solarflare.com>
Date:   Fri, 24 Jul 2020 17:01:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <d224dbb2-ef20-dca9-d50b-7f583b45d859@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25560.003
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
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25560.003
X-MDID: 1595606490-yjXBnx8t6sKG
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
