Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E867B655DF7
	for <lists+netdev@lfdr.de>; Sun, 25 Dec 2022 18:49:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230505AbiLYRtK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Dec 2022 12:49:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbiLYRtJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Dec 2022 12:49:09 -0500
X-Greylist: delayed 399 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 25 Dec 2022 09:49:07 PST
Received: from isengard.anuradha.dev (isengard.anuradha.dev [172.104.61.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6568C6248;
        Sun, 25 Dec 2022 09:49:07 -0800 (PST)
Received: from ninsei.anuradha.dev (<unknown> [112.134.163.9])
        by anuradha.dev (OpenSMTPD) with ESMTPSA id 091ae1d8 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Sun, 25 Dec 2022 17:42:24 +0000 (UTC)
Date:   Sun, 25 Dec 2022 23:12:22 +0530
From:   Anuradha Weeraman <anuradha@debian.org>
To:     Sunil Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Jerin Jacob <jerinj@marvell.com>,
        hariprasad <hkelam@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     anuradha@debian.org
Subject: [PATCH] net: ethernet: marvell: octeontx2: Fix uninitialized
 variable warning
Message-ID: <Y6iLfnODkXm3rFC9@ninsei.anuradha.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Developer-Signature: v=1; a=openpgp-sha256; l=845; i=anuradha@debian.org;
 h=from:subject; bh=4vPF/VviW8SKOwe6a9pdyzkgrpv3GpOVeyzO8eLHKRk=;
 b=owEBbQKS/ZANAwAKAWNttaHZGGD9AcsmYgBjqIpnBpAl1qmBNXLLSfXk+sR3W0nKP0VOkDpKlw6K
 wyF/xVOJAjMEAAEKAB0WIQT1a48U4BTN710Ef8FjbbWh2Rhg/QUCY6iKZwAKCRBjbbWh2Rhg/X4jD/
 9FMybU1Np+OYIxRSU2KKWHMI0oNVnFvOVyb6qZtWKV7SSx3dYfj0NtFtTrnbN1TQ1kswY/i5DUTYbF
 iAJ+Ew6y8zY0vjGTqHAZcE5vpLCY1jKbNk76P0uP0d+UfCbgXdxddL4YOYYoHOT13/FJLvWRF8OnmZ
 oahd9cFNLGU/Ex2ItvqHJZM7pG6RdH9fM4yQcrbLpsY1JnuhZ2zD4mQZKFxIHvp85S/j6ZAekZq62G
 SwMSZGBWQm90VRBxesdhDzh1YqU8lgOyO8J5OHlgriCdhnk1o+CZZrC1zI4xH7nthIURdJZt18EUAp
 j+z0snWB++vTO4rYHlxQWbhwVvxruFfRTtGoXyV5b4LhB3TJmbtUTmqy16MyIyrxQKVekkvfEj8vbo
 lH7tizK9+VASAsyqpQJxhcja2/LLQR3EcU2hFFYN6n/VZncD54yOwWlml+yHyd4QMDaBXuK8FkvcoC
 29z2CXcMVhlZsOatacufP3AWzyCQYleM2PI9uCdnv4YHzzsgNabwCcJNm/HsaMx30cyg0IQUJDtNLN
 uh9C+tnn0Ho2zgyXwS03sRJDX3YDpEmcSYMMSFL20tp1NKOmT4zM9hO3rudnTmZNEYDo7+RKKAJHId
 5Yl7mere3dF72YmiBnXEK7TZxypwkotQVzmIPTUXtZ6ulRDeYTgedQB1j1aA==
X-Developer-Key: i=anuradha@debian.org; a=openpgp;
 fpr=F56B8F14E014CDEF5D047FC1636DB5A1D91860FD
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix for uninitialized variable warning.

Addresses-Coverity: ("Uninitialized scalar variable")
Signed-off-by: Anuradha Weeraman <anuradha@debian.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/mcs_rvu_if.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mcs_rvu_if.c b/drivers/net/ethernet/marvell/octeontx2/af/mcs_rvu_if.c
index fa8029a94068..eb25e458266c 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mcs_rvu_if.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mcs_rvu_if.c
@@ -589,7 +589,7 @@ int rvu_mbox_handler_mcs_free_resources(struct rvu *rvu,
 	u16 pcifunc = req->hdr.pcifunc;
 	struct mcs_rsrc_map *map;
 	struct mcs *mcs;
-	int rc;
+	int rc = 0;
 
 	if (req->mcs_id >= rvu->mcs_blk_cnt)
 		return MCS_AF_ERR_INVALID_MCSID;
-- 
2.35.1

