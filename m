Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2524C40F706
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 14:03:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243266AbhIQME5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 08:04:57 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:34436
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235036AbhIQME4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 08:04:56 -0400
Received: from localhost (1.general.cking.uk.vpn [10.172.193.212])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 83D263F101;
        Fri, 17 Sep 2021 12:03:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1631880213;
        bh=qKExn8zNk6nsAIHi1Nyl0mehaAZ/+D0UQp34tRUlXHM=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type;
        b=J0xfL2A0sgFrs4khVn+6rd5dfU4WfKc2r70vQ0BLAb6vESII+zzT+Urq+Qnm2YDeV
         o+cxdc1v7DCNDOTaTjev2TfdQZmZ/4tSeErZSYI5vhsjws1GtZaiu+mtdbYuhBnPO6
         vDJkOnOCkxkIkN27P9gdiiSSCcEkgN9gLSACBEsddQ4hL1qBtchuOkmhx/RJ2MMLFZ
         deBsBz1DwOFohnZPqalQ6EMUqqKJTXr5Ju8ZnZ9tPpQkd9Ui/vyXxxiFOUpTANQ9io
         ZzSSRv2BIW99tpL+27p8PsVOroK/QtuQ2/EjIyCFiCsWuTLuD41SmUUMWFPUO4Tf9G
         SGA1M2MnhONgQ==
From:   Colin King <colin.king@canonical.com>
To:     Sunil Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Jerin Jacob <jerinj@marvell.com>,
        hariprasad <hkelam@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] octeontx2-af: Remove redundant initialization of variable blkaddr
Date:   Fri, 17 Sep 2021 13:03:33 +0100
Message-Id: <20210917120333.48074-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The variable blkaddr is being initialized with a value that is never
read, it is being updated later on in a for-loop. The assignment is
redundant and can be removed.

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
index 3bba8bc91f35..5909173ff788 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -1294,7 +1294,7 @@ int rvu_get_blkaddr_from_slot(struct rvu *rvu, int blktype, u16 pcifunc,
 	int numlfs, total_lfs = 0, nr_blocks = 0;
 	int i, num_blkaddr[BLK_COUNT] = { 0 };
 	struct rvu_block *block;
-	int blkaddr = -ENODEV;
+	int blkaddr;
 	u16 start_slot;
 
 	if (!is_blktype_attached(pfvf, blktype))
-- 
2.32.0

