Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9BC71606A1
	for <lists+netdev@lfdr.de>; Sun, 16 Feb 2020 22:08:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726962AbgBPVIG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 16:08:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:58914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726043AbgBPVIG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 16 Feb 2020 16:08:06 -0500
Received: from localhost.localdomain (unknown [151.48.137.85])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C47F20726;
        Sun, 16 Feb 2020 21:08:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581887285;
        bh=U1NnfrWpx16BXVIZpOChV4m/YhGrQ9FrOazanTtPzRE=;
        h=From:To:Cc:Subject:Date:From;
        b=pTGxfniGou6+U0mxtrZy5E6Yz0UrcW2WgTs2hAwrQCm+0ArtZEFFflG238B1If5N1
         uczbvccoVf3/jIdA4wrkqhPnEAyTedasZfbvCjR+1bwhe907mUc1s71+/qQ71jJ7L4
         nWjs1XFJof6/b6W1sS/c8B9Oh3O/+rEEg6FVdDKM=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     ilias.apalodimas@linaro.org, davem@davemloft.net,
        lorenzo.bianconi@redhat.com, brouer@redhat.com
Subject: [PATCH net-next 0/5] add xdp ethtool stats to mvneta driver
Date:   Sun, 16 Feb 2020 22:07:28 +0100
Message-Id: <cover.1581886691.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rework mvneta stats accounting in order to introduce xdp ethtool
statistics in the mvneta driver.
Introduce xdp_redirect, xdp_pass, xdp_drop and xdp_tx counters to
ethtool statistics.
Fix skb_alloc_error and refill_error ethtool accounting

Lorenzo Bianconi (5):
  net: mvneta: move refill_err and skb_alloc_err in per-cpu stats
  net: mvneta: rely on open-coding updating stats for non-xdp and tx
    path
  net: mvneta: rely on struct mvneta_stats in mvneta_update_stats
    routine
  net: mvneta: introduce xdp counters to ethtool
  net: mvneta: get rid of xdp_ret in mvneta_swbm_rx_frame

 drivers/net/ethernet/marvell/mvneta.c | 227 ++++++++++++++++++--------
 1 file changed, 163 insertions(+), 64 deletions(-)

-- 
2.24.1

