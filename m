Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E87C07707B
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 19:44:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387922AbfGZRo1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 13:44:27 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:57098 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387411AbfGZRo1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 13:44:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=3vKOPJZThkOv1kf7F//R9kojftOFbBCGcOAdJDG7E+A=; b=X4UogjFDqqXqZrz7ZqH9uKVJX
        yuMZImTkC+/k4Dq/pKADdtj3h/+DNF2pWP+x5O3Ogs9zsaal3KTpKL7PDTCqk7hTrkj0mjdvFAxvv
        VzEBV60VBb/NGE4xmClZaTm3CdcXzShBdKEEean5zpDUeg5MVsHttdSZg5CU4mP47eYiExmOjKvLp
        O0PpTfjpFOXjwv1cop5R9QQjTDQ2xFCmsUVxCLURnRO1TZMKMHsSu2EtBFHNesI/Q5vFEsV0FWfya
        jG/7K/h5Umh/NMSXI8IKh3mh0dA3JepjlDWPir91M8rXM/zPIbA89ELhARtdNorreGbCmvXn3LM6t
        sP+Ft/S6A==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hr4GY-0001nA-Kd; Fri, 26 Jul 2019 17:44:26 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     davem@davemloft.net
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        netdev@vger.kernel.org, aaro.koskinen@iki.fi, arnd@arndb.de,
        gregkh@linuxfoundation.org
Subject: [PATCH 0/2] Fix Octeon to build on !MIPS
Date:   Fri, 26 Jul 2019 10:44:23 -0700
Message-Id: <20190726174425.6845-1-willy@infradead.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

I typo'd the conversion to skb_frag_t in the Octeon driver, but didn't
notice because you can only build it on MIPS, and the buildbots seem
overloaded right now.

So I've constructed some stubs which let me build it on x86.  I'm sure
somebody could do a better job of those stubs, but really the split
between this driver and the support code in mips is all wrong.

I'd suggest this pair of patches go in through net-next since the first
one depends on patches already in net-next, but the second one could
probably go independently through the staging tree.

Matthew Wilcox (Oracle) (2):
  octeon: Fix typo
  staging/octeon: Allow test build on !MIPS

 drivers/staging/octeon/Kconfig            |    2 +-
 drivers/staging/octeon/ethernet-defines.h |    2 -
 drivers/staging/octeon/ethernet-mdio.c    |    6 +-
 drivers/staging/octeon/ethernet-mem.c     |    5 +-
 drivers/staging/octeon/ethernet-rgmii.c   |   10 +-
 drivers/staging/octeon/ethernet-rx.c      |   13 +-
 drivers/staging/octeon/ethernet-rx.h      |    2 -
 drivers/staging/octeon/ethernet-sgmii.c   |    8 +-
 drivers/staging/octeon/ethernet-spi.c     |   10 +-
 drivers/staging/octeon/ethernet-tx.c      |   14 +-
 drivers/staging/octeon/ethernet-util.h    |    4 -
 drivers/staging/octeon/ethernet.c         |   12 +-
 drivers/staging/octeon/octeon-ethernet.h  |   29 +-
 drivers/staging/octeon/octeon-stubs.h     | 1429 +++++++++++++++++++++
 14 files changed, 1467 insertions(+), 79 deletions(-)
 create mode 100644 drivers/staging/octeon/octeon-stubs.h

-- 
2.20.1

