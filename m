Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B3341D579D
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 19:23:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726632AbgEORXP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 13:23:15 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:45782 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726254AbgEORXP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 13:23:15 -0400
Received: from localhost (scalar.blr.asicdesigners.com [10.193.185.94])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 04FHN7dq028033;
        Fri, 15 May 2020 10:23:08 -0700
From:   Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nirranjan@chelsio.com, vishal@chelsio.com,
        dt@chelsio.com
Subject: [PATCH net-next 0/3] cxgb4: improve and tune TC-MQPRIO offload
Date:   Fri, 15 May 2020 22:41:02 +0530
Message-Id: <cover.1589562017.git.rahul.lakkireddy@chelsio.com>
X-Mailer: git-send-email 2.5.3
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patch 1 improves the Tx path's credit request and recovery mechanism
when running under heavy load.

Patch 2 adds ability to tune the burst buffer sizes of all traffic
classes to improve performance for <= 1500 MTU, under heavy load.

Patch 3 adds support to track EOTIDs and dump software queue
contexts used by TC-MQPRIO offload.

Thanks,
Rahul

Rahul Lakkireddy (3):
  cxgb4: improve credits recovery in TC-MQPRIO Tx path
  cxgb4: tune burst buffer size for TC-MQPRIO offload
  cxgb4: add EOTID tracking and software context dump

 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h    |  30 ++--
 .../ethernet/chelsio/cxgb4/cxgb4_debugfs.c    | 144 ++++++++++++++----
 .../net/ethernet/chelsio/cxgb4/cxgb4_main.c   |   3 +-
 .../ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c  |  17 +++
 .../ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.h  |   1 +
 .../net/ethernet/chelsio/cxgb4/cxgb4_uld.h    |   5 +
 drivers/net/ethernet/chelsio/cxgb4/sched.c    |   3 +-
 drivers/net/ethernet/chelsio/cxgb4/sge.c      |  40 +++--
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c    |   8 +-
 9 files changed, 190 insertions(+), 61 deletions(-)

-- 
2.24.0

