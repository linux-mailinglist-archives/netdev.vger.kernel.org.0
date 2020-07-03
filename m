Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A4AC213CAC
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 17:36:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726443AbgGCPge (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 11:36:34 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:55282 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726152AbgGCPge (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jul 2020 11:36:34 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.143])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 8FABD20080;
        Fri,  3 Jul 2020 15:36:33 +0000 (UTC)
Received: from us4-mdac16-62.at1.mdlocal (unknown [10.110.50.155])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 8D35A8009B;
        Fri,  3 Jul 2020 15:36:33 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.49.31])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 3114E4006E;
        Fri,  3 Jul 2020 15:36:33 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id EFC23300065;
        Fri,  3 Jul 2020 15:36:32 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 3 Jul 2020
 16:36:28 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next 15/15] sfc_ef100: implement
 ndo_get_phys_port_{id,name}
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <14d4694e-2493-abd3-b76e-09e38a01b588@solarflare.com>
Message-ID: <828362ba-e678-9e6b-d564-40ccf369c5d6@solarflare.com>
Date:   Fri, 3 Jul 2020 16:36:25 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <14d4694e-2493-abd3-b76e-09e38a01b588@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25518.003
X-TM-AS-Result: No-2.678400-8.000000-10
X-TMASE-MatchedRID: MwN0zTUhCXFAEjf8JRFbHLsHVDDM5xAP1JP9NndNOkUGmHr1eMxt2UAc
        6DyoS2rIj6kCfX0Edc6tL1mMSnuv19J+QjwsijM7HPYwOJi6PLnAqRukGkkpQockQTW2P5j0+NY
        BZrpe1untp8eQSZp9k2IlxuxNQIAzZSU6HajahM5tawJSSsDgSdxWLypmYlZz+Z4lF/CW5gbfel
        djYKxB4miAAE3uIJmQxmvfL5pGlen8xKK47P3yZcgVrCfx7T+rSkWlzdsmIx6as/p1ZgI0lKPFj
        JEFr+olA9Mriq0CDAj1MHKyrhxIFgtuKBGekqUpUfEQFBqv0meV0PlKZqRFl9tBMR61QclvdJKr
        /G7tmepV5XUm4vE96k3CKjCzsATSX/jOAvQ3c4oHH3gwlkFX+GIpEXd0nZ0v2XYrptJGCDntfQ1
        SPvnqTJqVXUXjGsjz2F+vBZls4K+yaqc7gc0b5ehxodtyrclRwL6SxPpr1/I=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10-2.678400-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25518.003
X-MDID: 1593790593-i6Yw4gZvlBTz
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
index 3e4e7241d9a8..66e6c1159c0f 100644
--- a/drivers/net/ethernet/sfc/ef100_netdev.c
+++ b/drivers/net/ethernet/sfc/ef100_netdev.c
@@ -214,6 +214,8 @@ static const struct net_device_ops ef100_netdev_ops = {
 	.ndo_open               = ef100_net_open,
 	.ndo_stop               = ef100_net_stop,
 	.ndo_start_xmit         = ef100_hard_start_xmit,
+	.ndo_get_phys_port_id   = efx_get_phys_port_id,
+	.ndo_get_phys_port_name = efx_get_phys_port_name,
 };
 
 /*	Netdev registration
diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
index 7c914b2f71c5..de7c428c63bb 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.c
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -406,6 +406,20 @@ static int ef100_reset(struct efx_nic *efx, enum reset_type reset_type)
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
@@ -460,6 +474,8 @@ const struct efx_nic_type ef100_pf_nic_type = {
 	.rx_remove = efx_mcdi_rx_remove,
 	.rx_write = ef100_rx_write,
 
+	.get_phys_port_id = efx_ef100_get_phys_port_id,
+
 	.reconfigure_mac = ef100_reconfigure_mac,
 
 	/* Per-type bar/size configuration not used on ef100. Location of
@@ -542,6 +558,11 @@ static int ef100_probe_main(struct efx_nic *efx)
 
 	efx->max_vis = EF100_MAX_VIS;
 
+	rc = efx_mcdi_port_get_number(efx);
+	if (rc < 0)
+		goto fail;
+	efx->port_num = rc;
+
 	rc = ef100_phy_probe(efx);
 	if (rc)
 		goto fail;
