Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8D22504E1
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 10:51:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727942AbfFXIvK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 04:51:10 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:32810 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725916AbfFXIvK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 04:51:10 -0400
Received: from localhost (junagarh.blr.asicdesigners.com [10.193.185.238])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id x5O8p6gx011105;
        Mon, 24 Jun 2019 01:51:07 -0700
From:   Raju Rangoju <rajur@chelsio.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     nirranjan@chelsio.com, dt@chelsio.com, rajur@chelsio.com
Subject: [PATCH v2 net-next 0/4] cxgb4: Reference count MPS TCAM entries within a PF
Date:   Mon, 24 Jun 2019 14:20:33 +0530
Message-Id: <20190624085037.2358-1-rajur@chelsio.com>
X-Mailer: git-send-email 2.12.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Firmware reference counts the MPS TCAM entries by PF and VF,
but it does not do it for usage within a PF or VF. This patch
adds the support to track MPS TCAM entries within a PF.

v1->v2:
 Use refcount_t type instead of atomic_t for mps reference count

Raju Rangoju (4):
  cxgb4: Re-work the logic for mps refcounting
  cxgb4: Add MPS TCAM refcounting for raw mac filters
  cxgb4: Add MPS TCAM refcounting for cxgb4 change mac
  cxgb4: Add MPS refcounting for alloc/free mac filters

 drivers/net/ethernet/chelsio/cxgb4/Makefile       |   2 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h        |  53 ++++-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c |   8 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c   |  40 ++--
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_mps.c    | 242 ++++++++++++++++++++++
 5 files changed, 313 insertions(+), 32 deletions(-)
 create mode 100644 drivers/net/ethernet/chelsio/cxgb4/cxgb4_mps.c

-- 
2.12.0

