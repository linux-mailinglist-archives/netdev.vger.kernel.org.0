Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55F582037CF
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 15:21:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728237AbgFVNVc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 09:21:32 -0400
Received: from mga09.intel.com ([134.134.136.24]:27253 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728100AbgFVNVc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jun 2020 09:21:32 -0400
IronPort-SDR: m+54dLw1hTXgT5gdCfb8CRxDrLQnw+fo6KaUdTFas1f0Hfnrux8+KPa2g3WAin1cEqFpEA7oXi
 SXSEpC+si9Sg==
X-IronPort-AV: E=McAfee;i="6000,8403,9659"; a="145265627"
X-IronPort-AV: E=Sophos;i="5.75,266,1589266800"; 
   d="scan'208";a="145265627"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2020 06:21:31 -0700
IronPort-SDR: +faZkv575xRaTaIYiSbzI2FbIhmWuiugNq5gCXMwHgI3vfq2nuDqe05sLrJTuCIzybd0n32mtM
 SSS6Xy/451Pw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,266,1589266800"; 
   d="scan'208";a="422628508"
Received: from juergenr-mobl.ger.corp.intel.com (HELO localhost.localdomain) ([10.252.33.83])
  by orsmga004.jf.intel.com with ESMTP; 22 Jun 2020 06:21:29 -0700
From:   Magnus Karlsson <magnus.karlsson@intel.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com,
        intel-wired-lan@lists.osuosl.org, jeffrey.t.kirsher@intel.com
Cc:     maciej.fijalkowski@intel.com, maciejromanfijalkowski@gmail.com,
        netdev@vger.kernel.org
Subject: [PATCH net-next 0/2] i40e: improve AF_XDP performance
Date:   Mon, 22 Jun 2020 15:21:21 +0200
Message-Id: <1592832083-23249-1-git-send-email-magnus.karlsson@intel.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This small series improves AF_XDP performance for the i40e NIC. The
first patch optimizes the Tx completion path for AF_XDP and the second
one removes a division in the data path for the normal SKB path, XDP
as well as AF_XDP. Overall, the throughput of the l2fwd application in
xpdsock improves with around 4% on my machine.

This patch has been applied against commit 29a720c1042f ("Merge branch
'Marvell-mvpp2-improvements'")

Thanks: Magnus

Magnus Karlsson (2):
  i40e: optimize AF_XDP Tx completion path
  i40e: eliminate division in napi_poll data path

 drivers/net/ethernet/intel/i40e/i40e_txrx.c | 15 +++++++++----
 drivers/net/ethernet/intel/i40e/i40e_txrx.h |  1 +
 drivers/net/ethernet/intel/i40e/i40e_xsk.c  | 34 ++++++++++++++++-------------
 3 files changed, 31 insertions(+), 19 deletions(-)

--
2.7.4
