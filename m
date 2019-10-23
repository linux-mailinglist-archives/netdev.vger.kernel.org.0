Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38179E1562
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 11:09:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403777AbfJWJJQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 05:09:16 -0400
Received: from inva020.nxp.com ([92.121.34.13]:34276 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390604AbfJWJJO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Oct 2019 05:09:14 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 9A6F31A0123;
        Wed, 23 Oct 2019 11:09:13 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 8EA001A0016;
        Wed, 23 Oct 2019 11:09:13 +0200 (CEST)
Received: from fsr-fed2164-101.ea.freescale.net (fsr-fed2164-101.ea.freescale.net [10.171.82.91])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 49282205FE;
        Wed, 23 Oct 2019 11:09:13 +0200 (CEST)
From:   Madalin Bucur <madalin.bucur@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     roy.pledge@nxp.com, laurentiu.tudor@nxp.com,
        jakub.kicinski@netronome.com, Madalin Bucur <madalin.bucur@nxp.com>
Subject: [PATCH net-next v3 6/7] fsl/fman: remove unused struct member
Date:   Wed, 23 Oct 2019 12:08:45 +0300
Message-Id: <1571821726-6624-7-git-send-email-madalin.bucur@nxp.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1571821726-6624-1-git-send-email-madalin.bucur@nxp.com>
References: <1571821726-6624-1-git-send-email-madalin.bucur@nxp.com>
Content-Type: text/plain; charset="us-ascii"
Reply-to: madalin.bucur@nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove unused struct member second_largest_buf_size. Also, an out of
bounds access would have occurred in the removed code if there was only
one buffer pool in use.

Signed-off-by: Madalin Bucur <madalin.bucur@nxp.com>
---
 drivers/net/ethernet/freescale/fman/fman_port.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fman/fman_port.c b/drivers/net/ethernet/freescale/fman/fman_port.c
index bd76c9730692..87b26f063cc8 100644
--- a/drivers/net/ethernet/freescale/fman/fman_port.c
+++ b/drivers/net/ethernet/freescale/fman/fman_port.c
@@ -435,7 +435,6 @@ struct fman_port_cfg {
 
 struct fman_port_rx_pools_params {
 	u8 num_of_pools;
-	u16 second_largest_buf_size;
 	u16 largest_buf_size;
 };
 
@@ -946,8 +945,6 @@ static int set_ext_buffer_pools(struct fman_port *port)
 	port->rx_pools_params.num_of_pools = ext_buf_pools->num_of_pools_used;
 	port->rx_pools_params.largest_buf_size =
 	    sizes_array[ordered_array[ext_buf_pools->num_of_pools_used - 1]];
-	port->rx_pools_params.second_largest_buf_size =
-	    sizes_array[ordered_array[ext_buf_pools->num_of_pools_used - 2]];
 
 	/* FMBM_RMPD reg. - pool depletion */
 	if (buf_pool_depletion->pools_grp_mode_enable) {
-- 
2.1.0

