Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC50022FDD2
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 01:30:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727928AbgG0XXz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 19:23:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:34698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726171AbgG0XXy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 19:23:54 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DB95520809;
        Mon, 27 Jul 2020 23:23:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595892233;
        bh=Iz5tUY4gfrdU2cdZyw0Xqf8QtUvX+KWg12EojTs4aaY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M3N6lNSPfPorGsO3KDTFGfLGeL/KBUYC9/v4OIt+1+RLs4ASIovRRYSRiSriYKHUx
         60k1/oSA5gL77Ki20MOFAXwN4Ef+B6a544I9Tt1aoEDfdm9nggKzWpmyYXlR6nqZFn
         wrf4v/NZ9HRSDqF2J4r4dtMPaSNyVDuuOR4Db15s=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Laurence Oberman <loberman@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 05/25] qed: Disable "MFW indication via attention" SPAM every 5 minutes
Date:   Mon, 27 Jul 2020 19:23:25 -0400
Message-Id: <20200727232345.717432-5-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200727232345.717432-1-sashal@kernel.org>
References: <20200727232345.717432-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Laurence Oberman <loberman@redhat.com>

[ Upstream commit 1d61e21852d3161f234b9656797669fe185c251b ]

This is likely firmware causing this but its starting to annoy customers.
Change the message level to verbose to prevent the spam.
Note that this seems to only show up with ISCSI enabled on the HBA via the
qedi driver.

Signed-off-by: Laurence Oberman <loberman@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qed/qed_int.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_int.c b/drivers/net/ethernet/qlogic/qed/qed_int.c
index 9f5113639eaf0..4bccaafca8b28 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_int.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_int.c
@@ -1172,7 +1172,8 @@ static int qed_int_attentions(struct qed_hwfn *p_hwfn)
 			index, attn_bits, attn_acks, asserted_bits,
 			deasserted_bits, p_sb_attn_sw->known_attn);
 	} else if (asserted_bits == 0x100) {
-		DP_INFO(p_hwfn, "MFW indication via attention\n");
+		DP_VERBOSE(p_hwfn, NETIF_MSG_INTR,
+			   "MFW indication via attention\n");
 	} else {
 		DP_VERBOSE(p_hwfn, NETIF_MSG_INTR,
 			   "MFW indication [deassertion]\n");
-- 
2.25.1

