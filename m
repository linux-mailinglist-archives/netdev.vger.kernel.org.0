Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0D6B6EE17E
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 13:58:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233991AbjDYL5r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 07:57:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233300AbjDYL5p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 07:57:45 -0400
Received: from smtp.smtpout.orange.fr (smtp-22.smtpout.orange.fr [80.12.242.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6634FD338
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 04:57:25 -0700 (PDT)
Received: from pop-os.home ([86.243.2.178])
        by smtp.orange.fr with ESMTPA
        id rHIOpwV85Od5IrHIOpk006; Tue, 25 Apr 2023 13:57:23 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
        s=t20230301; t=1682423843;
        bh=t3xAngYVnplShoMkDBT5wxr82rgMk9+s4xEzp+xQcGk=;
        h=From:To:Cc:Subject:Date;
        b=sLPw0Pw00uQk6bgsbUFMY+a4XjocYbk7duiHnLMdWW1BUkx9fWjVLP1NbmvOG8Gx5
         Vi64m3fz2Gb18SOghspqNFubQlmjD+Usnvswdh5OFSbdGdaItUIlFhNkBdhxPYTDGp
         0EQ0AG/mRUeuUjKQd2I4wbh2Z9EsPhzxoiQlBYuSJWuFt9gAdVkD0S3ClkPctw2/gz
         cyj7XhOoTsRh9UpiZZkMD5xlLlHIoUa35C+Op3twgEMNobeEEwsTicbCeAZEfU69nQ
         gPhVQLauG1wjWlUwecBQ/mCQ3coZ0bx/783BiRYLC4z20BU5IU+Bj6ONHlt7hbHK1m
         zSHIxeo2nNRCQ==
X-ME-Helo: pop-os.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Tue, 25 Apr 2023 13:57:23 +0200
X-ME-IP: 86.243.2.178
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        ath12k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH] wifi: ath12k: Remove some dead code
Date:   Tue, 25 Apr 2023 13:57:19 +0200
Message-Id: <c17edf0811156a33bae6c5cf1906d751cc87edd4.1682423828.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ATH12K_HE_MCS_MAX = 11, so this test and the following one are the same.
Remove the one with the hard coded 11 value.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/wireless/ath/ath12k/dp_rx.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/dp_rx.c b/drivers/net/wireless/ath/ath12k/dp_rx.c
index e78478a5b978..79386562562f 100644
--- a/drivers/net/wireless/ath/ath12k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath12k/dp_rx.c
@@ -1362,11 +1362,6 @@ ath12k_update_per_peer_tx_stats(struct ath12k *ar,
 	 * Firmware rate's control to be skipped for this?
 	 */
 
-	if (flags == WMI_RATE_PREAMBLE_HE && mcs > 11) {
-		ath12k_warn(ab, "Invalid HE mcs %d peer stats",  mcs);
-		return;
-	}
-
 	if (flags == WMI_RATE_PREAMBLE_HE && mcs > ATH12K_HE_MCS_MAX) {
 		ath12k_warn(ab, "Invalid HE mcs %d peer stats",  mcs);
 		return;
-- 
2.34.1

