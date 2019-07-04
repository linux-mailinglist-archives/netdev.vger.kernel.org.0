Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27E485F847
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 14:37:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727835AbfGDMgy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 08:36:54 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42109 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727714AbfGDMgy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 08:36:54 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <colin.king@canonical.com>)
        id 1hj0yq-0004CX-8d; Thu, 04 Jul 2019 12:36:52 +0000
From:   Colin King <colin.king@canonical.com>
To:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: ethernet: sun: remove redundant assignment to variable err
Date:   Thu,  4 Jul 2019 13:36:51 +0100
Message-Id: <20190704123651.31672-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The variable err is being assigned with a value that is never
read and it is being updated in the next statement with a new value.
The assignment is redundant and can be removed.

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/sun/niu.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/sun/niu.c b/drivers/net/ethernet/sun/niu.c
index 6f99437a6962..0bc5863bffeb 100644
--- a/drivers/net/ethernet/sun/niu.c
+++ b/drivers/net/ethernet/sun/niu.c
@@ -1217,8 +1217,6 @@ static int link_status_1g_rgmii(struct niu *np, int *link_up_p)
 
 	spin_lock_irqsave(&np->lock, flags);
 
-	err = -EINVAL;
-
 	err = mii_read(np, np->phy_addr, MII_BMSR);
 	if (err < 0)
 		goto out;
-- 
2.20.1

