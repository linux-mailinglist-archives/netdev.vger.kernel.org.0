Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A87FD52ED16
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 15:28:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346855AbiETN23 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 09:28:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233392AbiETN22 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 09:28:28 -0400
Received: from mail.sf-mail.de (mail.sf-mail.de [IPv6:2a01:4f8:1c17:6fae:616d:6c69:616d:6c69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D352BB8BD2
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 06:28:25 -0700 (PDT)
Received: (qmail 15196 invoked from network); 20 May 2022 13:28:23 -0000
Received: from p200300cf07141a0076d435fffeb7be92.dip0.t-ipconnect.de ([2003:cf:714:1a00:76d4:35ff:feb7:be92]:49916 HELO eto.sf-tec.de) (auth=eike@sf-mail.de)
        by mail.sf-mail.de (Qsmtpd 0.38dev) with (TLS_AES_256_GCM_SHA384 encrypted) ESMTPSA
        for <kuba@kernel.org>; Fri, 20 May 2022 15:28:23 +0200
From:   Rolf Eike Beer <eike-kernel@sf-tec.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org,
        netdev@vger.kernel.org, Yang Yingliang <yangyingliang@huawei.com>,
        davem@davemloft.net, edumazet@google.com
Subject: [PATCH] net: tulip: fix build with CONFIG_GSC
Date:   Fri, 20 May 2022 15:28:21 +0200
Message-ID: <4719560.GXAFRqVoOG@eto.sf-tec.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes: 3daebfbeb455 ("net: tulip: convert to devres")
Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Rolf Eike Beer <eike-kernel@sf-tec.de>
---
 drivers/net/ethernet/dec/tulip/eeprom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/dec/tulip/eeprom.c b/drivers/net/ethernet/dec/tulip/eeprom.c
index 67a67cb78dbb..d5657ff15e3c 100644
--- a/drivers/net/ethernet/dec/tulip/eeprom.c
+++ b/drivers/net/ethernet/dec/tulip/eeprom.c
@@ -117,7 +117,7 @@ static void tulip_build_fake_mediatable(struct tulip_private *tp)
 			  0x00, 0x06  /* ttm bit map */
 			};
 
-		tp->mtable = devm_kmalloc(&tp->pdev->pdev, sizeof(struct mediatable) +
+		tp->mtable = devm_kmalloc(&tp->pdev->dev, sizeof(struct mediatable) +
 					  sizeof(struct medialeaf), GFP_KERNEL);
 
 		if (tp->mtable == NULL)
-- 
2.35.3




