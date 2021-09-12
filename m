Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9738407FA3
	for <lists+netdev@lfdr.de>; Sun, 12 Sep 2021 21:15:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235866AbhILTQN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Sep 2021 15:16:13 -0400
Received: from mail.stusta.mhn.de ([141.84.69.5]:43654 "EHLO
        mail.stusta.mhn.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235302AbhILTQN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Sep 2021 15:16:13 -0400
X-Greylist: delayed 572 seconds by postgrey-1.27 at vger.kernel.org; Sun, 12 Sep 2021 15:16:12 EDT
Received: from [127.0.0.1] (localhost [127.0.0.1])
        by mail.stusta.mhn.de (Postfix) with ESMTPSA id 4H6zZr2vlqz4p;
        Sun, 12 Sep 2021 21:05:23 +0200 (CEST)
From:   Adrian Bunk <bunk@kernel.org>
To:     Ariel Elior <aelior@marvell.com>,
        Sudarsana Kalluru <skalluru@marvell.com>,
        GR-everest-linux-l2@marvell.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] bnx2x: Fix enabling network interfaces without VFs
Date:   Sun, 12 Sep 2021 22:05:23 +0300
Message-Id: <20210912190523.27991-1-bunk@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This function is called to enable SR-IOV when available,
not enabling interfaces without VFs was a regression.

Fixes: 65161c35554f ("bnx2x: Fix missing error code in bnx2x_iov_init_one()")
Signed-off-by: Adrian Bunk <bunk@kernel.org>
Reported-by: YunQiang Su <wzssyqa@gmail.com>
Tested-by: YunQiang Su <wzssyqa@gmail.com>
Cc: stable@vger.kernel.org
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
index f255fd0b16db..6fbf735fca31 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
@@ -1224,7 +1224,7 @@ int bnx2x_iov_init_one(struct bnx2x *bp, int int_mode_param,
 
 	/* SR-IOV capability was enabled but there are no VFs*/
 	if (iov->total == 0) {
-		err = -EINVAL;
+		err = 0;
 		goto failed;
 	}
 
-- 
2.20.1

