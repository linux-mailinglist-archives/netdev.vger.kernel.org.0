Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A07049CFBB
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 17:31:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243136AbiAZQaj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 11:30:39 -0500
Received: from foss.arm.com ([217.140.110.172]:51526 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234216AbiAZQai (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jan 2022 11:30:38 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 10DEED6E;
        Wed, 26 Jan 2022 08:30:38 -0800 (PST)
Received: from e121345-lin.cambridge.arm.com (e121345-lin.cambridge.arm.com [10.1.196.40])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 1ECF63F766;
        Wed, 26 Jan 2022 08:30:37 -0800 (PST)
From:   Robin Murphy <robin.murphy@arm.com>
To:     simon.horman@corigine.com, kuba@kernel.org, davem@davemloft.net
Cc:     oss-drivers@corigine.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next] nfp: nsp: Simplify array allocation
Date:   Wed, 26 Jan 2022 16:30:33 +0000
Message-Id: <af578bd3eb471b9613bcba7f714cca7e297a4620.1643214385.git.robin.murphy@arm.com>
X-Mailer: git-send-email 2.28.0.dirty
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Prefer kcalloc() to kzalloc(array_size()) for allocating an array.

Signed-off-by: Robin Murphy <robin.murphy@arm.com>
---
 drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.c b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.c
index 10e7d8b21c46..730fea214b8a 100644
--- a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.c
+++ b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp.c
@@ -513,7 +513,7 @@ nfp_nsp_command_buf_dma_sg(struct nfp_nsp *nsp,
 	dma_size = BIT_ULL(dma_order);
 	nseg = DIV_ROUND_UP(max_size, chunk_size);
 
-	chunks = kzalloc(array_size(sizeof(*chunks), nseg), GFP_KERNEL);
+	chunks = kcalloc(nseg, sizeof(*chunks), GFP_KERNEL);
 	if (!chunks)
 		return -ENOMEM;
 
-- 
2.28.0.dirty

