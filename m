Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03F0324A103
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 16:02:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727000AbgHSOCd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 10:02:33 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:35569 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726763AbgHSOCN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 10:02:13 -0400
Received: from localhost.localdomain (vardah.blr.asicdesigners.com [10.193.186.1])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 07JE1bcO027304;
        Wed, 19 Aug 2020 07:01:42 -0700
From:   Vinay Kumar Yadav <vinay.yadav@chelsio.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        herbert@gondor.apana.org.au
Cc:     secdev@chelsio.com, Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Subject: [PATCH net-next 0/2] crypto/chelsio: Restructure chelsio's inline crypto drivers
Date:   Wed, 19 Aug 2020 19:31:19 +0530
Message-Id: <20200819140121.20175-1-vinay.yadav@chelsio.com>
X-Mailer: git-send-email 2.18.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series of patches will move chelsio's inline crypto
drivers (ipsec and chtls) from "drivers/crypto/chelsio/"
to "drivers/net/ethernet/chelsio/inline_crypto/"
for better maintenance.

Patch1: moves out chtls.
Patch2: moves out inline ipsec, applies on top of Patch1.

Vinay Kumar Yadav (2):
  chelsio/chtls: separate chelsio tls driver from crypto driver
  crypto/chcr: Moving chelsio's inline ipsec functionality to
    /drivers/net

 MAINTAINERS                                   |   9 ++
 drivers/crypto/chelsio/Kconfig                |  21 ----
 drivers/crypto/chelsio/Makefile               |   2 -
 drivers/crypto/chelsio/chcr_algo.h            |  33 ------
 drivers/crypto/chelsio/chcr_core.c            |  42 +------
 drivers/crypto/chelsio/chcr_core.h            |  84 -------------
 drivers/net/ethernet/chelsio/Kconfig          |   2 +
 drivers/net/ethernet/chelsio/Makefile         |   1 +
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h    |   3 +
 .../ethernet/chelsio/cxgb4/cxgb4_debugfs.c    |   7 +-
 .../net/ethernet/chelsio/cxgb4/cxgb4_uld.h    |   8 +-
 drivers/net/ethernet/chelsio/cxgb4/sge.c      |   4 +-
 .../ethernet/chelsio/inline_crypto/Kconfig    |  38 ++++++
 .../ethernet/chelsio/inline_crypto/Makefile   |   3 +
 .../chelsio/inline_crypto/ch_ipsec/Makefile   |   8 ++
 .../inline_crypto/ch_ipsec}/chcr_ipsec.c      | 111 +++++++++++++++++-
 .../inline_crypto/ch_ipsec/chcr_ipsec.h       |  58 +++++++++
 .../chelsio/inline_crypto}/chtls/Makefile     |   0
 .../chelsio/inline_crypto}/chtls/chtls.h      |  88 ++++++++++++++
 .../chelsio/inline_crypto}/chtls/chtls_cm.c   |   0
 .../chelsio/inline_crypto}/chtls/chtls_cm.h   |   0
 .../chelsio/inline_crypto}/chtls/chtls_hw.c   |   0
 .../chelsio/inline_crypto}/chtls/chtls_io.c   |   0
 .../chelsio/inline_crypto}/chtls/chtls_main.c |   2 +-
 24 files changed, 334 insertions(+), 190 deletions(-)
 create mode 100644 drivers/net/ethernet/chelsio/inline_crypto/Kconfig
 create mode 100644 drivers/net/ethernet/chelsio/inline_crypto/Makefile
 create mode 100644 drivers/net/ethernet/chelsio/inline_crypto/ch_ipsec/Makefile
 rename drivers/{crypto/chelsio => net/ethernet/chelsio/inline_crypto/ch_ipsec}/chcr_ipsec.c (88%)
 create mode 100644 drivers/net/ethernet/chelsio/inline_crypto/ch_ipsec/chcr_ipsec.h
 rename drivers/{crypto/chelsio => net/ethernet/chelsio/inline_crypto}/chtls/Makefile (100%)
 rename drivers/{crypto/chelsio => net/ethernet/chelsio/inline_crypto}/chtls/chtls.h (81%)
 rename drivers/{crypto/chelsio => net/ethernet/chelsio/inline_crypto}/chtls/chtls_cm.c (100%)
 rename drivers/{crypto/chelsio => net/ethernet/chelsio/inline_crypto}/chtls/chtls_cm.h (100%)
 rename drivers/{crypto/chelsio => net/ethernet/chelsio/inline_crypto}/chtls/chtls_hw.c (100%)
 rename drivers/{crypto/chelsio => net/ethernet/chelsio/inline_crypto}/chtls/chtls_io.c (100%)
 rename drivers/{crypto/chelsio => net/ethernet/chelsio/inline_crypto}/chtls/chtls_main.c (99%)

-- 
2.18.1

