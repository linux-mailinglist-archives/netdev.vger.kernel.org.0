Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90FD06B95BC
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 14:14:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232386AbjCNNN7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 09:13:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232242AbjCNNNg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 09:13:36 -0400
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.17.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BD0C9FBFC;
        Tue, 14 Mar 2023 06:10:21 -0700 (PDT)
Received: from maxwell.localdomain ([109.43.51.107]) by
 mrelayeu.kundenserver.de (mreue109 [213.165.67.113]) with ESMTPSA (Nemesis)
 id 1MkYkC-1qO0UO1e0M-00m3Lr; Tue, 14 Mar 2023 13:39:46 +0100
From:   Jochen Henneberg <jh@henneberg-systemdesign.com>
To:     netdev@vger.kernel.org
Cc:     Jochen Henneberg <jh@henneberg-systemdesign.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net 2/2] net: stmmac: Premature loop termination check was ignored
Date:   Tue, 14 Mar 2023 13:37:59 +0100
Message-Id: <20230314123759.132521-3-jh@henneberg-systemdesign.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230314123759.132521-1-jh@henneberg-systemdesign.com>
References: <20230314123759.132521-1-jh@henneberg-systemdesign.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:l1W1LjxOLRyxarFh4d7uXBRK1UHreknpzqZxegOM2jODzpg/YnC
 9we6QMFFMqqrvH21mCENI6V0GewVL31+FUjESlQG/GgCnknsFYczuD3QVxAowBFgssxKeKC
 BvP40Y6ELDXd3GZ27r2KYfUuPWtMiyJOvLPWLgjjxUnr2hsS6L6ExUn8v0AUlKJ591P77sJ
 29IArAxiVdxnm/YEFKiCg==
UI-OutboundReport: notjunk:1;M01:P0:ALkaqJksCBY=;UNJi6nd3DKRNOsPUSg2Y1GXX0u6
 1coJnSy7MjETLQHEvuK9ywdKPTbvXS66imF0ekDSU5EWzMqeulqgrLB7mVcSdAXH5iYgsMIxM
 LotuqDwvC0xR06FG8kheFe40Zg7KGAwompEBMQfb7tAOHvewSp/6MumxfpQU5k6Hn7xAf+Lm6
 cCPRdJZX38lp+1mw2FNL/y3wXyyULHHdJwJJDI2ewx2vv3b9QzkB+mrYcBMbcMiWP8FSZcS7l
 C43xi7YEW9a1q3JYvx5wmBJtN9Pvf32cjqrXYovFuLvz7fRvSzhz7+zkcKjbPx3TMY2RctZxh
 M44RfssRkJmRKf4X0FxBdQ8rtWUSVXQifNg3fzrnfmXARmRt67VBFfiadjbQ+oRjhWZ9i8zwC
 z7VcNZ/Tjr1+2ehHceriKEEZRRAtOr0dYlYDu5LTLdFOXLXiPOzFc3yaSh04AD3Qbqx/j6WX9
 WH8Jv9MGERxKdSZuxljZTJ3ZqCsEVJPI92I2XenxmHQNCwHMLSZiAJxgoYPDQx4CoqxxhJUeI
 Z6eG482F4kG7BPdMqogBkBrYkm5YGFXaGskjNzDLT0AYlmzEILvb3aGkxi5otf/OWeO2dq7O6
 N0qdv1/b+FByC37Uj2ETGS1wT26B2kewQFkQ7ghUKsDG3P0EzkUVFk7mRAbjPFmi9snDFLUh/
 4zwbgq/IMNikStvlmyfKAiO2hPlkMfl3iVGDrJslbw==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The premature loop termination check makes sense only in case of the
jump to read_again where the count may have been updated. But
read_again did not include the check.

Fixes: bba2556efad6 ("net: stmmac: Enable RX via AF_XDP zero-copy")
Signed-off-by: Jochen Henneberg <jh@henneberg-systemdesign.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index ea51c7c93101..4886668a54c5 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -5031,10 +5031,10 @@ static int stmmac_rx_zc(struct stmmac_priv *priv, int limit, u32 queue)
 			len = 0;
 		}
 
+read_again:
 		if (count >= limit)
 			break;
 
-read_again:
 		buf1_len = 0;
 		entry = next_entry;
 		buf = &rx_q->buf_pool[entry];
-- 
2.39.2

