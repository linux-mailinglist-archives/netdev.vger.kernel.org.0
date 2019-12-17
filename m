Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7E5F1224E7
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 07:43:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726767AbfLQGnB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 01:43:01 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:28502 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725886AbfLQGnA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 01:43:00 -0500
Received: from fcoe-test9.blr.asicdesigners.com (fcoe-test9.blr.asicdesigners.com [10.193.185.176])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id xBH6grfr026325;
        Mon, 16 Dec 2019 22:42:54 -0800
From:   Shahjada Abul Husain <shahjada@chelsio.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nirranjan@chelsio.com, vishal@chelsio.com,
        dt@chelsio.com, Shahjada Abul Husain <shahjada@chelsio.com>
Subject: [PATCH net-next 0/2] cxgb4/chtls: fix issues related to high priority region
Date:   Tue, 17 Dec 2019 12:12:07 +0530
Message-Id: <20191217064209.8526-1-shahjada@chelsio.com>
X-Mailer: git-send-email 2.23.0.256.g4c86140
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The high priority region introduced by:

commit c21939998802 ("cxgb4: add support for high priority filters")

had caused regression in some code paths, leading to connection
failures for the ULDs.

This series of patches attempt to fix the regressions.

Patch 1 fixes some code paths that have been missed to consider
the high priority region.

Patch 2 fixes ULD connection failures due to wrong TID base that
had been shifted after the high priority region.

Thanks,
Shahjada Abul Husain

---
Shahjada Abul Husain (2):
  cxgb4: fix missed high priority region calculation
  cxgb4/chtls: fix ULD connection failures due to wrong TID base

 drivers/crypto/chelsio/chtls/chtls_cm.c       |  2 +-
 .../ethernet/chelsio/cxgb4/cxgb4_debugfs.c    | 22 ++++++-------
 .../net/ethernet/chelsio/cxgb4/cxgb4_filter.c | 33 +++++++++++--------
 .../net/ethernet/chelsio/cxgb4/cxgb4_main.c   | 13 +++++---
 .../ethernet/chelsio/cxgb4/cxgb4_tc_flower.c  |  3 +-
 .../chelsio/cxgb4/cxgb4_tc_matchall.c         |  2 +-
 .../net/ethernet/chelsio/cxgb4/cxgb4_uld.h    |  9 ++++-
 7 files changed, 50 insertions(+), 34 deletions(-)

-- 
2.23.0.256.g4c86140

