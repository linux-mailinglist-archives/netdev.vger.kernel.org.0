Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E6C83F54C2
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 02:55:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234784AbhHXA4c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 20:56:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:47870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233953AbhHXAze (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Aug 2021 20:55:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 231CE61527;
        Tue, 24 Aug 2021 00:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629766486;
        bh=F9yoIotIzFik7ysVZVflN4Wd+6wIU7YL3+6ONdX9auI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZtcEwvV+oE/ACKj0cd4T215lgfAEoFxLfCPWnkn5SmUJqYzTxeuE5Vb9CynekVlJK
         4b4mbzV3JtIm9D0flrgqFFD08rQDQAZmSxt2Nb5P1B6Oxttc25OBZL/mQuPiTkGgqU
         1VHF46ZI9AmRtAkgYyMN/YJ3qnb9GY2x2CLW4uEwtqAtLxvtiiYtap/kZtAU37IgaP
         PhxlwHVYgth15CxM/NMDvxH2/3Tl3lL/830aJ0niWQTIAJ8sUYjL15fX0NDqu+Hnpr
         w9q+4nKUXa6LqWi7sK278HWKPBfqjb4+WIREaud/jClcXpu/Zwqup73ya88BEt5asA
         YErEldcqABjVA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shai Malin <smalin@marvell.com>,
        TOTE Robot <oslab@tsinghua.edu.cn>,
        Ariel Elior <aelior@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 10/18] qed: Fix null-pointer dereference in qed_rdma_create_qp()
Date:   Mon, 23 Aug 2021 20:54:24 -0400
Message-Id: <20210824005432.631154-10-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824005432.631154-1-sashal@kernel.org>
References: <20210824005432.631154-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shai Malin <smalin@marvell.com>

[ Upstream commit d33d19d313d3466abdf8b0428be7837aff767802 ]

Fix a possible null-pointer dereference in qed_rdma_create_qp().

Changes from V2:
- Revert checkpatch fixes.

Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Ariel Elior <aelior@marvell.com>
Signed-off-by: Shai Malin <smalin@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qed/qed_rdma.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_rdma.c b/drivers/net/ethernet/qlogic/qed/qed_rdma.c
index da864d12916b..4f4b79250a2b 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_rdma.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_rdma.c
@@ -1285,8 +1285,7 @@ qed_rdma_create_qp(void *rdma_cxt,
 
 	if (!rdma_cxt || !in_params || !out_params ||
 	    !p_hwfn->p_rdma_info->active) {
-		DP_ERR(p_hwfn->cdev,
-		       "qed roce create qp failed due to NULL entry (rdma_cxt=%p, in=%p, out=%p, roce_info=?\n",
+		pr_err("qed roce create qp failed due to NULL entry (rdma_cxt=%p, in=%p, out=%p, roce_info=?\n",
 		       rdma_cxt, in_params, out_params);
 		return NULL;
 	}
-- 
2.30.2

