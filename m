Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 168762B97FA
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 17:35:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728630AbgKSQ3k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 11:29:40 -0500
Received: from inva021.nxp.com ([92.121.34.21]:56576 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727543AbgKSQ3k (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Nov 2020 11:29:40 -0500
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 54BB32004E5;
        Thu, 19 Nov 2020 17:29:38 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 481482002F0;
        Thu, 19 Nov 2020 17:29:38 +0100 (CET)
Received: from fsr-ub1464-019.ea.freescale.net (fsr-ub1464-019.ea.freescale.net [10.171.81.207])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id E819C20329;
        Thu, 19 Nov 2020 17:29:37 +0100 (CET)
From:   Camelia Groza <camelia.groza@nxp.com>
To:     kuba@kernel.org, brouer@redhat.com, saeed@kernel.org,
        davem@davemloft.net
Cc:     madalin.bucur@oss.nxp.com, ioana.ciornei@nxp.com,
        netdev@vger.kernel.org, Camelia Groza <camelia.groza@nxp.com>
Subject: [PATCH net-next v3 0/7] dpaa_eth: add XDP support
Date:   Thu, 19 Nov 2020 18:29:29 +0200
Message-Id: <cover.1605802951.git.camelia.groza@nxp.com>
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

Changes in v3:
- drop received S/G frames when XDP is enabled in 2/7

Camelia Groza (7):
  dpaa_eth: add struct for software backpointers
  dpaa_eth: add basic XDP support
  dpaa_eth: limit the possible MTU range when XDP is enabled
  dpaa_eth: add XDP_TX support
  dpaa_eth: add XDP_REDIRECT support
  dpaa_eth: rename current skb A050385 erratum workaround
  dpaa_eth: implement the A050385 erratum workaround for XDP

 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 457 +++++++++++++++++++++++--
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.h |  13 +
 2 files changed, 440 insertions(+), 30 deletions(-)

--
1.9.1

