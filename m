Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79DBB20D233
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 20:50:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729278AbgF2Src (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 14:47:32 -0400
Received: from inva021.nxp.com ([92.121.34.21]:55842 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726447AbgF2SrU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jun 2020 14:47:20 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 14747200F8A;
        Mon, 29 Jun 2020 20:47:19 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 08CE7200226;
        Mon, 29 Jun 2020 20:47:19 +0200 (CEST)
Received: from fsr-ub1864-126.ea.freescale.net (fsr-ub1864-126.ea.freescale.net [10.171.82.212])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id C6A68205DE;
        Mon, 29 Jun 2020 20:47:18 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH RESEND net-next 0/2] dpaa2-eth: send a scatter-gather FD instead of realloc-ing
Date:   Mon, 29 Jun 2020 21:47:10 +0300
Message-Id: <20200629184712.12449-1-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.17.1
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set changes the behaviour in case the Tx path is confroted
with an SKB with insufficient headroom for our hardware necessities (SW
annotation area). In the first patch, instead of realloc-ing the SKB we
now send a S/G frames descriptor while the second one adds a new
software held counter to account for for these types of frames.

Ioana Ciornei (2):
  dpaa2-eth: send a scatter-gather FD instead of realloc-ing
  dpaa2-eth: add software counter for Tx frames converted to S/G

 .../freescale/dpaa2/dpaa2-eth-debugfs.c       |   4 +-
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  | 179 +++++++++++++++---
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.h  |  12 +-
 .../ethernet/freescale/dpaa2/dpaa2-ethtool.c  |   3 +-
 4 files changed, 166 insertions(+), 32 deletions(-)

-- 
2.25.1

