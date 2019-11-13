Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A517FB2CF
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 15:47:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727845AbfKMOrl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 09:47:41 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:21296 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727831AbfKMOrl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 09:47:41 -0500
Received: from localhost (scalar.blr.asicdesigners.com [10.193.185.94])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id xADElZ7D007503;
        Wed, 13 Nov 2019 06:47:36 -0800
From:   Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nirranjan@chelsio.com, vishal@chelsio.com,
        dt@chelsio.com
Subject: [PATCH net-next 0/2] cxgb4: add TC-MATCHALL classifier offload
Date:   Wed, 13 Nov 2019 20:09:19 +0530
Message-Id: <cover.1573656040.git.rahul.lakkireddy@chelsio.com>
X-Mailer: git-send-email 2.5.3
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series of patches add support to offload TC-MATCHALL classifier
to hardware to classify all outgoing and incoming traffic on the
underlying port. Only 1 egress and 1 ingress rule each can be
offloaded on the underlying port.

Patch 1 adds support for TC-MATCHALL classifier offload on the egress
side. TC-POLICE is the only action that can be offloaded on the egress
side and is used to rate limit all outgoing traffic to specified max
rate.

Patch 2 adds support for TC-MATCHALL classifier offload on the ingress
side. The same set of actions supported by existing TC-FLOWER
classifier offload can be applied on all the incoming traffic.

Thanks,
Rahul


Rahul Lakkireddy (2):
  cxgb4: add TC-MATCHALL classifier egress offload
  cxgb4: add TC-MATCHALL classifier ingress offload

 drivers/net/ethernet/chelsio/cxgb4/Makefile   |   3 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h    |   4 +
 .../net/ethernet/chelsio/cxgb4/cxgb4_filter.c |  18 +
 .../net/ethernet/chelsio/cxgb4/cxgb4_filter.h |   1 +
 .../net/ethernet/chelsio/cxgb4/cxgb4_main.c   |  78 +++-
 .../ethernet/chelsio/cxgb4/cxgb4_tc_flower.c  |  21 +-
 .../ethernet/chelsio/cxgb4/cxgb4_tc_flower.h  |   6 +
 .../chelsio/cxgb4/cxgb4_tc_matchall.c         | 335 ++++++++++++++++++
 .../chelsio/cxgb4/cxgb4_tc_matchall.h         |  50 +++
 .../ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c  |   5 +-
 drivers/net/ethernet/chelsio/cxgb4/sched.c    |  56 ++-
 drivers/net/ethernet/chelsio/cxgb4/sched.h    |   1 +
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c    |  11 +-
 13 files changed, 549 insertions(+), 40 deletions(-)
 create mode 100644 drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_matchall.c
 create mode 100644 drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_matchall.h

-- 
2.24.0

