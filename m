Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7056590184
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 18:00:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237204AbiHKP65 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 11:58:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237736AbiHKP5R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 11:57:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2FF0A8CCE;
        Thu, 11 Aug 2022 08:47:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 892AF616FC;
        Thu, 11 Aug 2022 15:47:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23A5AC433D6;
        Thu, 11 Aug 2022 15:47:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660232860;
        bh=HpKYO8yLmNOnjoqfb463aByInJcdMtKBZ4sTMxhP3BM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UxrWkqzS72exw4cmH8dG0b27ZGaPtuTBmzIQ12sYT5wVFvjBuvyLa2JJn5cRh2y/Y
         ldZvo5MP9jIxUxmeia27xQolsshBBVIf+cELpm6XJ+gkFWhoQiBhSpWSJkpGC25lU/
         QgrzytfS6j4bGWQb09UX/s2QWuhxMZHcofJE/kj6M9HBRuogLomxEfejGRoZ0Cd3w/
         TeDvBqpGLHfZh3cbNJYh9ZbJf08hk+l0QtBQXaoZOegWOodOaS2P2/MU+KLS4yv/b5
         GXB6ZoYxBoeo2Il61iwpaBEcbhzm24Zfl6zGePYAtn1ZHeCVceYalwtdZX28SQR2x2
         MRkb+2tT5AFOg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shijith Thotton <sthotton@marvell.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, sgoutham@marvell.com,
        lcherian@marvell.com, gakula@marvell.com, jerinj@marvell.com,
        hkelam@marvell.com, sbhatta@marvell.com, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 50/93] octeontx2-af: fix operand size in bitwise operation
Date:   Thu, 11 Aug 2022 11:41:44 -0400
Message-Id: <20220811154237.1531313-50-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811154237.1531313-1-sashal@kernel.org>
References: <20220811154237.1531313-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shijith Thotton <sthotton@marvell.com>

[ Upstream commit b14056914357beee6a84f6ff1b9195f4659fab9d ]

Made size of operands same in bitwise operations.

The patch fixes the klocwork issue, operands in a bitwise operation have
different size at line 375 and 483.

Signed-off-by: Shijith Thotton <sthotton@marvell.com>
Link: https://lore.kernel.org/r/f4fba33fe4f89b420b4da11d51255e7cc6ea1dbf.1656586269.git.sthotton@marvell.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
index a9da85e418a4..38bbae5d9ae0 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
@@ -17,7 +17,7 @@
 #define	PCI_DEVID_OTX2_CPT10K_PF 0xA0F2
 
 /* Length of initial context fetch in 128 byte words */
-#define CPT_CTX_ILEN    2
+#define CPT_CTX_ILEN    2ULL
 
 #define cpt_get_eng_sts(e_min, e_max, rsp, etype)                   \
 ({                                                                  \
@@ -480,7 +480,7 @@ static int cpt_inline_ipsec_cfg_inbound(struct rvu *rvu, int blkaddr, u8 cptlf,
 	 */
 	if (!is_rvu_otx2(rvu)) {
 		val = (ilog2(NIX_CHAN_CPT_X2P_MASK + 1) << 16);
-		val |= rvu->hw->cpt_chan_base;
+		val |= (u64)rvu->hw->cpt_chan_base;
 
 		rvu_write64(rvu, blkaddr, CPT_AF_X2PX_LINK_CFG(0), val);
 		rvu_write64(rvu, blkaddr, CPT_AF_X2PX_LINK_CFG(1), val);
-- 
2.35.1

