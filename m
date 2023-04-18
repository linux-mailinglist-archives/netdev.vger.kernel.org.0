Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADBA86E5F58
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 13:08:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229479AbjDRLIM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 07:08:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229962AbjDRLIK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 07:08:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED9BE7ABA
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 04:07:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1553D6301B
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 11:07:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8CB9C433EF;
        Tue, 18 Apr 2023 11:07:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681816064;
        bh=3sMgbHnYFmyo7o83otuBC8dc0GltIp1+zccjMGc95TQ=;
        h=From:Date:Subject:To:Cc:From;
        b=BYabJNlsgK6TddYgNWyKF8BZQcv9Uz7Oc3ij7SyvJJIf8DEMFVP/48d1Lg+ag1Lk2
         ny5UzarcmIHNPbH7srtzwI1uN2EU22fx8Rhdep+1O9WkZSkWMv0UrJqJFUwEfSq12p
         n3KANzk41FZb9zrUe1oCwu8RqSkJywujWhN0fXOKoBF7Kfy+wq2Hr/5ziGXbATAFvb
         6YFLf4NyW7c/a11XOdNzHSPIa7ikLVTsePC9AYHX/1BeEXNjJ56FQn5Ksgld0Bkac2
         gs/NThnM8TrVylSofi9CP8o6Yvb8hWmkywtMi7+Iqz0hOXnlRBvLXntHrOfatvq/gU
         XVijnh2ARv3Yw==
From:   Simon Horman <horms@kernel.org>
Date:   Tue, 18 Apr 2023 13:07:33 +0200
Subject: [PATCH net-next] net: stmmac: dwmac-meson8b: Avoid cast to
 incompatible function type
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230418-dwmac-meson8b-clk-cb-cast-v1-1-e892b670cbbb@kernel.org>
X-B4-Tracking: v=1; b=H4sIAPR5PmQC/x2N2wrCMBBEf6XsswtNY2n1V8SHXLY2mG4lG7VQ+
 u8uPg1n4MzsIFQSCVybHQp9kqSVFcypgTA7fhCmqAxd29n2bEaM38UFXEhWHj2G/MSg4aTiZH0
 fbXcZTD+A+t4JoS+Ow6wL/M5Zy1ehKW3/wxswVWTaKtyP4weJcx0qigAAAA==
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Kevin Hilman <khilman@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com, llvm@lists.linux.dev
X-Mailer: b4 0.12.2
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rather than casting clk_disable_unprepare to an incompatible function
type provide a trivial wrapper with the correct signature for the
use-case.

Reported by clang-16 with W=1:

 drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c:276:6: error: cast from 'void (*)(struct clk *)' to 'void (*)(void *)' converts to incompatible function type [-Werror,-Wcast-function-type-strict]
                                        (void(*)(void *))clk_disable_unprepare,
                                        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
No functional change intended.
Compile tested only.

Signed-off-by: Simon Horman <horms@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
index e8b507f88fbc..f6754e3643f3 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
@@ -263,6 +263,11 @@ static int meson_axg_set_phy_mode(struct meson8b_dwmac *dwmac)
 	return 0;
 }
 
+static void meson8b_clk_disable_unprepare(void *data)
+{
+	clk_disable_unprepare(data);
+}
+
 static int meson8b_devm_clk_prepare_enable(struct meson8b_dwmac *dwmac,
 					   struct clk *clk)
 {
@@ -273,8 +278,7 @@ static int meson8b_devm_clk_prepare_enable(struct meson8b_dwmac *dwmac,
 		return ret;
 
 	return devm_add_action_or_reset(dwmac->dev,
-					(void(*)(void *))clk_disable_unprepare,
-					clk);
+					meson8b_clk_disable_unprepare, clk);
 }
 
 static int meson8b_init_rgmii_delays(struct meson8b_dwmac *dwmac)

