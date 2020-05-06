Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 593EB1C7880
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 19:47:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728803AbgEFRr2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 13:47:28 -0400
Received: from inva021.nxp.com ([92.121.34.21]:36630 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728082AbgEFRr1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 May 2020 13:47:27 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 16E2A200CBE;
        Wed,  6 May 2020 19:47:26 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 0B242200CC0;
        Wed,  6 May 2020 19:47:26 +0200 (CEST)
Received: from fsr-ub1864-126.ea.freescale.net (fsr-ub1864-126.ea.freescale.net [10.171.82.212])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id C19DD205C6;
        Wed,  6 May 2020 19:47:25 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     hawk@kernel.org, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 0/2] dpaa2-eth: add bulking to XDP_TX
Date:   Wed,  6 May 2020 20:47:16 +0300
Message-Id: <20200506174718.20916-1-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.17.1
Reply-to: ioana.ciornei@nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set adds support for bulk enqueue in terms of XDP_TX packets.
XDP_TX packets are qeueued no longer than the end of the NAPI cycle or
until the array of frame descriptors stored per frame queue is full.

The first patch just cleans up the bulk enqueue and creates a new routine
to enqueue all frames for a FQ while the second patch actually adds the
bulk enqueue for XDP_TX packets.

Ioana Ciornei (2):
  dpaa2-eth: create a function to flush the XDP fds
  dpaa2-eth: add bulking to XDP_TX

 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  | 129 ++++++++++++------
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.h  |   8 +-
 2 files changed, 92 insertions(+), 45 deletions(-)

-- 
2.17.1

