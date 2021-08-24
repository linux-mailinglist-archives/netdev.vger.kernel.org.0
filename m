Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F01343F54E4
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 02:57:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235068AbhHXA52 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 20:57:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:48386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234601AbhHXA4A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Aug 2021 20:56:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 94263615E3;
        Tue, 24 Aug 2021 00:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629766506;
        bh=1NAE8l39Y1pohaMnXk2jdMQqlPqRWVWj5BfpOvUOJEc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SvbA7HJGx8lHsoj2ZknZvuo4Og7dumHxh0fbX5ToOaD9tF4lL1feMh2ckI1qBLjL1
         VbAj8A4CICw2KnsUdCp6wds7LLp+sXlU085z+jHikxdCmDfAXgM/pd72TBFPDn0WK5
         HmXY9eV62WjG48S+kLWF3LAmqtRLOvq4WyYqs5xaItsCLtGpTuESMS5/UsFqjNNpuP
         Eumwm9K+Z7xoYZRdpYgxQHJbiPsqGx7gRPd+GQyB789Iigns6B48TDCKoP5jmGUJOJ
         xuYJCIOz3uzpzj4lOqz0uGbD7zsQEaAEomM49Yd1rYYjRTufDlhngtIdOdghqv8fSe
         fIpnev5AmmdIg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shai Malin <smalin@marvell.com>,
        TOTE Robot <oslab@tsinghua.edu.cn>,
        Ariel Elior <aelior@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 06/10] qed: Fix null-pointer dereference in qed_rdma_create_qp()
Date:   Mon, 23 Aug 2021 20:54:53 -0400
Message-Id: <20210824005458.631377-6-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824005458.631377-1-sashal@kernel.org>
References: <20210824005458.631377-1-sashal@kernel.org>
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
index 38b1f402f7ed..b291971bcf92 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_rdma.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_rdma.c
@@ -1245,8 +1245,7 @@ qed_rdma_create_qp(void *rdma_cxt,
 
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

