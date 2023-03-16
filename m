Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C52146BC813
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 09:01:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230312AbjCPIBv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 04:01:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229902AbjCPIBs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 04:01:48 -0400
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A90EC3B853;
        Thu, 16 Mar 2023 01:01:42 -0700 (PDT)
Received: from maxwell.fritz.box ([109.42.114.157]) by
 mrelayeu.kundenserver.de (mreue011 [213.165.67.97]) with ESMTPSA (Nemesis) id
 1MqbI0-1qGED61Gd6-00meWG; Thu, 16 Mar 2023 09:00:52 +0100
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
Subject: [PATCH net V2 2/2] net: stmmac: Premature loop termination check was ignored on ZC rx
Date:   Thu, 16 Mar 2023 08:59:40 +0100
Message-Id: <20230316075940.695583-3-jh@henneberg-systemdesign.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230316075940.695583-1-jh@henneberg-systemdesign.com>
References: <20230316075940.695583-1-jh@henneberg-systemdesign.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:mqMzrAtMQmUMQjWx51L0PSHKPyASH1/pEP3wcHN2eEBqi8Q745U
 dgnh3N/rVmxXjU3Kov4wy1nZQCU97qDoSFMciWFBjRg6VkCPfWd9pgSNmsV6lDUKn1COfnv
 93Gv3vqS/qwd2NcZCVHnCNle88/BG2ojDCQib3nNuyS9BIhUL5EPkZOpkjCRLwkakQi1R/C
 9k7cARiszzI+CJuxOmcmw==
UI-OutboundReport: notjunk:1;M01:P0:ybRtu81gIRA=;V2R8iM2fSpQWWWvzF7mFI0zI+yK
 AaF3EvGmlLkuwcS8HVBO50+PQR7jc+Xn/fOmg6zduiAj1hMOlDBgTdVk7JZXioy27aV7trG5l
 o9c49RXatLazS5v2+oE15DQivVxklcmFov3N/MX+MTDkUFrgPR8Il5AlgIr5Cyt7+1uby3q3T
 jcS0Orzz+zUdTeSpcDirdU9NfB+97riiiGi5cchHjrommOkve3Q+16rMRIz+2w9EAf2keFkqY
 BoswUNwmbhcxkH+ZCRqt02sbO+2PBCJbNd09ZcxLOwlLSCwGS1Il06Cd25pHbF2NQEtBFzo4h
 NvKG9nQTKexV09UeutHA8iCq4Pi86JqjMdcsfxTTJ6lNMAyBfiFClMGsbowYqCTweJFt0Wve4
 DMIxU0lO6d3hji1C2ZKllwFm/d9TQBjDNeSW4Jd94oPut/74Wni2F79tOLLTKODmNXLIFiito
 W+0nWGgRzYCnW5FofIvHWMpC0t6KjR9LJb/Uun9WJWTL8OL4JrYlHEc7x9EniFXA7fgx0Ibwe
 pGwzy78aFPbLLLiD/HyEcDTBQ94RBQqCw2Y1KH5hJcdQ/92tHbci/FryOdDileRTjzYLjjakt
 fbWQUJ2vwfJnEEN283jS3pcv7Ws42AcraqJAENQBGo8I3ZZpn/TELx4A8mhp0LhAif2yJd3Ii
 RlnFTPzEHNh1F886moIdXs3QF0lm0UDaGtvYx7dmgo+0hPqwN7GENHXIfmm/+TE=
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

