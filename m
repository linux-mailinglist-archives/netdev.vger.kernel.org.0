Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5D932B460C
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 15:44:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729982AbgKPOmj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 09:42:39 -0500
Received: from inva021.nxp.com ([92.121.34.21]:54568 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726657AbgKPOmi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 09:42:38 -0500
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id A57D9200111;
        Mon, 16 Nov 2020 15:42:36 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 991652000E8;
        Mon, 16 Nov 2020 15:42:36 +0100 (CET)
Received: from fsr-ub1464-019.ea.freescale.net (fsr-ub1464-019.ea.freescale.net [10.171.81.207])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 416E6202AF;
        Mon, 16 Nov 2020 15:42:36 +0100 (CET)
From:   Camelia Groza <camelia.groza@nxp.com>
To:     kuba@kernel.org, brouer@redhat.com, saeed@kernel.org,
        davem@davemloft.net
Cc:     madalin.bucur@oss.nxp.com, ioana.ciornei@nxp.com,
        netdev@vger.kernel.org, Camelia Groza <camelia.groza@nxp.com>
Subject: [PATCH net-next v2 0/7] dpaa_eth: add XDP support
Date:   Mon, 16 Nov 2020 16:42:26 +0200
Message-Id: <cover.1605535745.git.camelia.groza@nxp.com>
X-Mailer: git-send-email 1.9.1
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enable XDP support for the QorIQ DPAA1 platforms.

Implement all the current actions (DROP, ABORTED, PASS, TX, REDIRECT). No
Tx batching is added at this time.

Additional XDP_PACKET_HEADROOM bytes are reserved in each frame's headroom.

After transmit, a reference to the xdp_frame is saved in the buffer for
clean-up on confirmation in a newly created structure for software
annotations.

Changes in v2:
- warn only once if extracting the timestamp from a received frame fails
  in 2/7

Camelia Groza (7):
  dpaa_eth: add struct for software backpointers
  dpaa_eth: add basic XDP support
  dpaa_eth: limit the possible MTU range when XDP is enabled
  dpaa_eth: add XDP_TX support
  dpaa_eth: add XDP_REDIRECT support
  dpaa_eth: rename current skb A050385 erratum workaround
  dpaa_eth: implement the A050385 erratum workaround for XDP

 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 447 +++++++++++++++++++++++--
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.h |  13 +
 2 files changed, 430 insertions(+), 30 deletions(-)

--
1.9.1

