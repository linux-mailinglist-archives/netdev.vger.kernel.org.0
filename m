Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BDF6590048
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 17:40:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236343AbiHKPjP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 11:39:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235800AbiHKPim (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 11:38:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DA02A031C;
        Thu, 11 Aug 2022 08:34:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D0093B82144;
        Thu, 11 Aug 2022 15:34:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD398C433D6;
        Thu, 11 Aug 2022 15:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660232056;
        bh=HpKYO8yLmNOnjoqfb463aByInJcdMtKBZ4sTMxhP3BM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y4zKvBWCBOFucMSyACos46ZE3KFHrUAsFWCD7ZNy1R/06nfjUC3R1FeFipHrFLxm/
         1AyU0g4A9XVg7BS1cGKQal6jfLzfn3j57wPbbamoZms789hfsUXQCJ3T/rtpqGyLmP
         mlWWhmSKIapF2Hep8tK21iEz8l75nG5ked5Gs/EoD3SOy2MD+ffqx8+Rtc1SacQpF6
         WKv03tqDD8RlBvVGKhkwo3+aQWQ0VOq/AAYxcVsirGsy/U9DedfdzRVelxwXf8OAul
         2VAuPZBf0IGMFBERmO1QASTgKHXzZdpX01GRdlfWVqL+9uPE6DdDHgEgyhrfHlaWHz
         UHxTvcl7axnLQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shijith Thotton <sthotton@marvell.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, sgoutham@marvell.com,
        lcherian@marvell.com, gakula@marvell.com, jerinj@marvell.com,
        hkelam@marvell.com, sbhatta@marvell.com, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 056/105] octeontx2-af: fix operand size in bitwise operation
Date:   Thu, 11 Aug 2022 11:27:40 -0400
Message-Id: <20220811152851.1520029-56-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220811152851.1520029-1-sashal@kernel.org>
References: <20220811152851.1520029-1-sashal@kernel.org>
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

