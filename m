Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2CCF6B94E6
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 13:52:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232483AbjCNMwM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 08:52:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232305AbjCNMvw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 08:51:52 -0400
Received: from mout.kundenserver.de (mout.kundenserver.de [217.72.192.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE220A8825;
        Tue, 14 Mar 2023 05:47:44 -0700 (PDT)
Received: from maxwell.localdomain ([109.43.51.107]) by
 mrelayeu.kundenserver.de (mreue109 [213.165.67.113]) with ESMTPSA (Nemesis)
 id 1MHG4c-1pgRfb1IOW-00DIcr; Tue, 14 Mar 2023 13:39:43 +0100
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
Subject: [PATCH net 1/2] net: stmmac: Premature loop termination check was ignored
Date:   Tue, 14 Mar 2023 13:37:58 +0100
Message-Id: <20230314123759.132521-2-jh@henneberg-systemdesign.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230314123759.132521-1-jh@henneberg-systemdesign.com>
References: <20230314123759.132521-1-jh@henneberg-systemdesign.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:9odOXzVTEt6nET6RlhuEMzaEAU5NfNUV6HWs/su++s+L/5aTzSd
 2U+FGb12WmVeADxMSgj4AoUS69olA6Y9Kqi+kaAIlGBdcnOr8aIQTWSm35+rNDTBjRDVDho
 eNHW/U3NzgInsz4ivdVqmoAVGimlcvOV08kcXmzmia9EAJJvXkgpnldAn3iCMiK2y9zzQ9o
 B/b58yd8mdmj1Sk9DPXaQ==
UI-OutboundReport: notjunk:1;M01:P0:oRwcTSNJXoU=;FKXs2RQX9KFX1o/21aklpyM+DSY
 vFoLaNm7FBiRYQhDL+Ue4MxrTZhEYlyCgic2du8ShlsYZNPRhbaA2LDPszAVZvhAaoP23q+BQ
 mNs1aqrp0llsI4StFQ6fFWCXRd3Euzpa+YriZbFuFLtn/AYZyigi7xIKlPmEyhG57GI3AiUrw
 6qEDxnOBsTZ7gkXhGR1N5BrGLSdsL9KamQcXucBBagRpLRhygIy2Xk7fDri1eZOGgjv5TpHpH
 0Sxq0A5b1J2NnLjt3GenW2WDBztf+Ku1lSW7EuGAE6VyITrVJxcRLA3YQ0llQaS8hDK/VEHCi
 T4oC+ZwxsSzSDHbrjvzygd9xQUnCL2H3zAOxbGVBBMsD03k2t18N8h95OA/X+qg9P1rLe4wVL
 OThDc+e0NQEHp3ibxRUSgIk4XhLPxDpxhzTFtFM3+mxrHLDqbiloVQP4DLH4Gx9xPBBYLz+o6
 jg8iQPwlF0HKnhNhksDYnRrsVyS2jRt7Z4nHOVS7q7lZX6c17N0URZbj03cLDSwzDvAQYoSWD
 DYVuN2Lc3OpXQHaZhTuzGntQV844ug2Qoj6O5L0qiTnZrURTgnEvyKe/OFRXU+pZUczYO2IHo
 CMpyVKIbAqbMQcIxWjun1K4Xkz7lIgdlQZIj2GxPJAMJEFaHo5mxyOyfEC3KyhYhAo8/ZXj0l
 GPIIOGF59p92gIxvzT8uyqXc3XKqyL0KXn9ApO1uZoY8umbYFYoeZ8Sv33SPlCN6JHTYxRJIu
 0qsYl5DKVOq
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

Fixes: ec222003bd94 ("net: stmmac: Prepare to add Split Header support")
Signed-off-by: Jochen Henneberg <jh@henneberg-systemdesign.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index e4902a7bb61e..ea51c7c93101 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -5221,10 +5221,10 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 			len = 0;
 		}
 
+read_again:
 		if (count >= limit)
 			break;
 
-read_again:
 		buf1_len = 0;
 		buf2_len = 0;
 		entry = next_entry;
-- 
2.39.2

