Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52BC94C75BD
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 18:55:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235990AbiB1R4U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 12:56:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239692AbiB1RxS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 12:53:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E6B9AB447
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 09:40:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E42E4B815B4
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 17:40:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B760C340F0;
        Mon, 28 Feb 2022 17:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646070045;
        bh=ESg1oCUkXYyZdUr21OHfuMpvFQwFDuGS2Dzxyknrqmc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GqcXL/OkwSaUBkT5hqkLLcHYxCBEpZahaMg53UJwuh3I4MZiJuBXUxCXI+xf34JUB
         3mrpF04IljPM06nzz4zkDncZXQx9HJu/puqVendnDyMlXl4As51KqqC7hngTh0PqPR
         DdRsxH/wbEn8Q+fHOrRwrWjybZDwsN1wuSjOk+WrPxZhb+2ZBGvk1kDMcDuQLStYad
         Bp0SLElV7YgYFYCZcSVa2Zusa4ptCeyC5lETyyishHvsKRNm87zvpEvQf107pQfwlA
         qvLesUhiLB+y2fUWW26OpqvJI8xzizliJ/xUDTd7LpLOgamEKN+Xd3GZuhw7FuerNf
         2hpjI1+gJZRDw==
From:   Mark Brown <broonie@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Yang Li <yang.lee@linux.alibaba.com>,
        Joseph CHAMG <josright123@gmail.com>
Cc:     netdev@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH] net: dm9051: Make remove() callback a void function
Date:   Mon, 28 Feb 2022 17:39:57 +0000
Message-Id: <20220228173957.1262628-2-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220228173957.1262628-1-broonie@kernel.org>
References: <20220228173957.1262628-1-broonie@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1345; i=broonie@kernel.org; h=from:subject; bh=b6Y6zCGZCFz/waAQX4B+4V9K+cYX4557jB2wyzoQ0NU=; b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBiHQcQS9rfMKEDLtN2F/34o7wYOp45cbAJsVp9pu8Q xSeKLa6JATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCYh0HEAAKCRAk1otyXVSH0D7eB/ 92jvq6Qhzu1E7TL30/dCfsViTNmqYs8qr/hQckA3+hjRubGc6Sb5b+uJiypbQE1wdvY659hPdho9oe 5nIMm8rW2ah1b/reGnJsYbGFoBUZP8ZaSczsgagWrP7r3IHjKP2YpQFzA2+R08bh+aKGQcVWfWQ00b tp1nIERhq9woZ+HdG93Rh7yKZb7K+QPtHc2ydAXTesM1cy+cwH3Kmhx16rKcy9d6N0APVK1xRWgfTz SXfWJed+hbkr6D/mOy/2THWH7xOpECEWfoFdByFZcCXREslz/p4gzHzr2IezygsvwmEk/WvzQmb19u L4DLQsz85FHfVhxh1CrkNxfG+lXvaR
X-Developer-Key: i=broonie@kernel.org; a=openpgp; fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>

Changes introduced since the merge window in the spi subsystem and
available at:

   https://git.kernel.org/pub/scm/linux/kernel/git/broonie/spi.git tags/spi-remove-void

make the remove() callback for spi return void rather than int, breaking
the newly added dm9051 driver fail to build.  This patch fixes this
issue, converting the remove() function provided by the driver to return
void.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
[Rewrote commit message -- broonie]
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 drivers/net/ethernet/davicom/dm9051.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/davicom/dm9051.c b/drivers/net/ethernet/davicom/dm9051.c
index b4b5c9c2a743..8ebcb35bbc0e 100644
--- a/drivers/net/ethernet/davicom/dm9051.c
+++ b/drivers/net/ethernet/davicom/dm9051.c
@@ -1225,15 +1225,13 @@ static int dm9051_probe(struct spi_device *spi)
 	return 0;
 }
 
-static int dm9051_drv_remove(struct spi_device *spi)
+static void dm9051_drv_remove(struct spi_device *spi)
 {
 	struct device *dev = &spi->dev;
 	struct net_device *ndev = dev_get_drvdata(dev);
 	struct board_info *db = to_dm9051_board(ndev);
 
 	phy_disconnect(db->phydev);
-
-	return 0;
 }
 
 static const struct of_device_id dm9051_match_table[] = {
-- 
2.30.2

