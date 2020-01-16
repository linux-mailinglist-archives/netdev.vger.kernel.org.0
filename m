Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 689A113E47B
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 18:08:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389485AbgAPRIq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 12:08:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:43070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387629AbgAPRIo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 12:08:44 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB36A21D56;
        Thu, 16 Jan 2020 17:08:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194523;
        bh=/BomwU7BzLsXWZlAm+sEkga800aiL6dN51sInZMjMYU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fz3UzSrtMtDse0uHaTXmbLOeu7d/LcJ2y8gxiwegxJ2cvlM2ZgzoGpSwmcCy8C59n
         LZzpilmkAPkLH6n1D0NwRq3q68uEcj6e8WeMZb7PW//6seGYdm+75IF1HRGa737tE9
         lKuXrZ8+W3uj3E5VbH1eIdFVgeFRVHHU/ILth5J8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michal Kalderon <michal.kalderon@marvell.com>,
        Ariel Elior <ariel.elior@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 414/671] qed: iWARP - fix uninitialized callback
Date:   Thu, 16 Jan 2020 12:00:52 -0500
Message-Id: <20200116170509.12787-151-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Kalderon <michal.kalderon@marvell.com>

[ Upstream commit 43cf40d93fadbb0d3edf0942a4612f8ff67478a1 ]

Fix uninitialized variable warning by static checker.

Fixes: ae3488ff37dc ("qed: Add ll2 connection for processing unaligned MPA packets")
Signed-off-by: Ariel Elior <ariel.elior@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qed/qed_iwarp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_iwarp.c b/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
index c77babd0ef95..39787bb885c8 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_iwarp.c
@@ -2641,6 +2641,7 @@ qed_iwarp_ll2_start(struct qed_hwfn *p_hwfn,
 	cbs.rx_release_cb = qed_iwarp_ll2_rel_rx_pkt;
 	cbs.tx_comp_cb = qed_iwarp_ll2_comp_tx_pkt;
 	cbs.tx_release_cb = qed_iwarp_ll2_rel_tx_pkt;
+	cbs.slowpath_cb = NULL;
 	cbs.cookie = p_hwfn;
 
 	memset(&data, 0, sizeof(data));
-- 
2.20.1

