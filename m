Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E146209E2A
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 14:11:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404429AbgFYML3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 08:11:29 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:37037 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404222AbgFYML2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 08:11:28 -0400
Received: from localhost (scalar.blr.asicdesigners.com [10.193.185.94])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 05PCBP5V025234;
        Thu, 25 Jun 2020 05:11:26 -0700
From:   Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nirranjan@chelsio.com, vishal@chelsio.com,
        dt@chelsio.com
Subject: [PATCH net-next 0/3] cxgb4: add mirror action support for TC-MATCHALL
Date:   Thu, 25 Jun 2020 17:28:40 +0530
Message-Id: <cover.1593085107.git.rahul.lakkireddy@chelsio.com>
X-Mailer: git-send-email 2.5.3
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series of patches add support to mirror all ingress traffic
for TC-MATCHALL ingress offload.

Patch 1 adds support to dynamically create a mirror Virtual Interface
(VI) that accepts all mirror ingress traffic when mirror action is
set in TC-MATCHALL offload.

Patch 2 adds support to allocate mirror Rxqs and setup RSS for the
mirror VI.

Patch 3 adds support to replicate all the main VI configuration to
mirror VI. This includes replicating MTU, promiscuous mode,
all-multicast mode, and enabled netdev Rx feature offloads.

Thanks,
Rahul

Rahul Lakkireddy (3):
  cxgb4: add mirror action to TC-MATCHALL offload
  cxgb4: add support for mirror Rxqs
  cxgb4: add main VI to mirror VI config replication

 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h    |  21 +
 .../ethernet/chelsio/cxgb4/cxgb4_debugfs.c    |  69 ++-
 .../net/ethernet/chelsio/cxgb4/cxgb4_main.c   | 487 ++++++++++++++++--
 .../ethernet/chelsio/cxgb4/cxgb4_tc_flower.c  |  16 +-
 .../ethernet/chelsio/cxgb4/cxgb4_tc_flower.h  |   3 +-
 .../chelsio/cxgb4/cxgb4_tc_matchall.c         |  57 +-
 .../chelsio/cxgb4/cxgb4_tc_matchall.h         |   1 +
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c    |  16 +
 8 files changed, 626 insertions(+), 44 deletions(-)

-- 
2.24.0

