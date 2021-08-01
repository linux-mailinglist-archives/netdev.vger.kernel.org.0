Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB3513DCC33
	for <lists+netdev@lfdr.de>; Sun,  1 Aug 2021 17:06:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232068AbhHAPG7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Aug 2021 11:06:59 -0400
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:33826
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231940AbhHAPG5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Aug 2021 11:06:57 -0400
Received: from localhost (1.general.cking.uk.vpn [10.172.193.212])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id 96E773F043;
        Sun,  1 Aug 2021 15:06:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1627830408;
        bh=O0MWsrFV/8FqTq3uVdIOdB4tqLqx6mBbBBdu5wpJA5w=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type;
        b=vqA00Mx9z0gyMmSlkqwK+n0eVHpSKnuV61GywxZxO8ipOfDOPP/UOcqAr+q54GkJL
         U+cTSWSACJ7ia8H8qEC91+WfNgVlaPZO5VzKAP/+1FOoz5+JFUPfsWeofUNb3K8lgi
         X9+Eyo+hxxS83lcZthJQdQfFSELOeiVF+1Vq7EWsGwEJXtr5KkvvceFWMDCQxXHhG2
         NGPqHe3ZvxBrB5/X2GUddRwB5HugwMjXXl0wTppaiZ4NgwzG4+ZWeL9uZWS1MZV53v
         zoa5Vx8RiKQ6GDoF6fyvGNzdkF7pi+qWwtMKTiUcwOmeT+jkRvainAvawLZPsvQyTc
         Ca9yswsiHmQZg==
From:   Colin King <colin.king@canonical.com>
To:     Mirko Lindner <mlindner@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: marvell: make the array name static, makes object smaller
Date:   Sun,  1 Aug 2021 16:06:47 +0100
Message-Id: <20210801150647.145728-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Don't populate the const array name on the stack but instead it
static. Makes the object code smaller by 28 bytes. Add a missing
const to clean up a checkpatch warning.

Before:
   text    data   bss     dec     hex filename
 124565   31565   384  156514   26362 drivers/net/ethernet/marvell/sky2.o

After:
   text    data   bss     dec     hex filename
 124441   31661   384  156486   26346 drivers/net/ethernet/marvell/sky2.o

(gcc version 10.2.0)

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/marvell/sky2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/sky2.c b/drivers/net/ethernet/marvell/sky2.c
index 743ca96527fa..4f51882d83ca 100644
--- a/drivers/net/ethernet/marvell/sky2.c
+++ b/drivers/net/ethernet/marvell/sky2.c
@@ -4884,7 +4884,7 @@ static int sky2_test_msi(struct sky2_hw *hw)
 /* This driver supports yukon2 chipset only */
 static const char *sky2_name(u8 chipid, char *buf, int sz)
 {
-	const char *name[] = {
+	static const char *const name[] = {
 		"XL",		/* 0xb3 */
 		"EC Ultra", 	/* 0xb4 */
 		"Extreme",	/* 0xb5 */
-- 
2.31.1

