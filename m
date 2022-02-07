Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 567284AB731
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 10:08:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243194AbiBGI4P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 03:56:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245735AbiBGItq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 03:49:46 -0500
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E654C043181;
        Mon,  7 Feb 2022 00:49:45 -0800 (PST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1644223781;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=UBM1gIzU+01nrnh6VMwcHQq+WPbC6EDjF3CE0IODu/M=;
        b=pUXVXhNysJC84kLT0rUQIoz5s6uL5zgEE0ilDsHMsfpJ2plPGtoh5WLKLthtnisror4520
        9Ev3UeFVZ7ctZD8VB6OvlrIKsYybLUT+jkE/LCrdyIVzebbVM0y9PnMNVoEsiZH+oU1MkN
        BEv2WVKdyjs9Ln0Sr9e+Jic8JZhAm0w=
From:   Cai Huoqing <cai.huoqing@linux.dev>
To:     cai.huoqing@linux.dev
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Karol Gugala <kgugala@antmicro.com>,
        Mateusz Holenko <mholenko@antmicro.com>,
        Gabriel Somlo <gsomlo@gmail.com>,
        Joel Stanley <joel@jms.id.au>,
        Cai Huoqing <caihuoqing@baidu.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: ethernet: litex: Add the dependency on HAS_IOMEM
Date:   Mon,  7 Feb 2022 16:49:12 +0800
Message-Id: <20220207084912.9309-1-cai.huoqing@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        TO_EQ_FM_DIRECT_MX,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The helper function devm_platform_ioremap_resource_xxx()
needs HAS_IOMEM enabled, so add the dependency on HAS_IOMEM.

Fixes: 464a57281f29 ("net/mlxbf_gige: Make use of devm_platform_ioremap_resourcexxx()")
Signed-off-by: Cai Huoqing <cai.huoqing@linux.dev>
---
 drivers/net/ethernet/litex/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/litex/Kconfig b/drivers/net/ethernet/litex/Kconfig
index f99adbf26ab4..04345b929d8e 100644
--- a/drivers/net/ethernet/litex/Kconfig
+++ b/drivers/net/ethernet/litex/Kconfig
@@ -17,7 +17,7 @@ if NET_VENDOR_LITEX
 
 config LITEX_LITEETH
 	tristate "LiteX Ethernet support"
-	depends on OF
+	depends on OF && HAS_IOMEM
 	help
 	  If you wish to compile a kernel for hardware with a LiteX LiteEth
 	  device then you should answer Y to this.
-- 
2.25.1

