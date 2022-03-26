Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FB6C4E8320
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 19:02:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234347AbiCZSEQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Mar 2022 14:04:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232395AbiCZSEQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Mar 2022 14:04:16 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53DBC13CECF
        for <netdev@vger.kernel.org>; Sat, 26 Mar 2022 11:02:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=NouxmkbXyieO1Hux/ld3G695f3UzkTVKQUYwNvnmwE8=; b=TAAZxnsjAOaA0cRvvgeIIlUiQ4
        ml0HEWH+UD7R6dKWsfLumGb20l/fLtlpDcauTSzZomPYi7Rd6NXMBHDGtzAsm4umqH49+fJwwiAPR
        JLpxTdU13YncFq6aWkdZocjTZFhwMnk/PGHN8xTzVDYJJAR8LIHCe7xNI3OhtP3I3qeanC7ldQk8R
        KM8HjMbotEuB3UZUVDHqs7EQ00RLmFuPEhAw6uPWLAy+chjaRLQs4Z9NAmE1qK8pG9YWOzjp0VWCf
        lw7eAglsOQApw6gKBgZCL31R/E35ljUuqZnHdtlUQlEjwOTgXy22/C177oSnfyhtH72C2oocdwEFB
        Ah3EN+gA==;
Received: from [2601:1c0:6280:3f0::aa0b] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nYAkF-004f0I-Dp; Sat, 26 Mar 2022 18:02:36 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     netdev@vger.kernel.org
Cc:     patches@lists.linux.dev, Randy Dunlap <rdunlap@infradead.org>,
        kernel test robot <lkp@intel.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        UNGLinuxDriver@microchip.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Steen Hegelund <steen.hegelund@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>
Subject: [PATCH] net: sparx5: depends on PTP_1588_CLOCK_OPTIONAL
Date:   Sat, 26 Mar 2022 11:02:34 -0700
Message-Id: <20220326180234.20814-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix build errors when PTP_1588_CLOCK=m and SPARX5_SWTICH=y.

arc-linux-ld: drivers/net/ethernet/microchip/sparx5/sparx5_ethtool.o: in function `sparx5_get_ts_info':
sparx5_ethtool.c:(.text+0x146): undefined reference to `ptp_clock_index'
arc-linux-ld: sparx5_ethtool.c:(.text+0x146): undefined reference to `ptp_clock_index'
arc-linux-ld: drivers/net/ethernet/microchip/sparx5/sparx5_ptp.o: in function `sparx5_ptp_init':
sparx5_ptp.c:(.text+0xd56): undefined reference to `ptp_clock_register'
arc-linux-ld: sparx5_ptp.c:(.text+0xd56): undefined reference to `ptp_clock_register'
arc-linux-ld: drivers/net/ethernet/microchip/sparx5/sparx5_ptp.o: in function `sparx5_ptp_deinit':
sparx5_ptp.c:(.text+0xf30): undefined reference to `ptp_clock_unregister'
arc-linux-ld: sparx5_ptp.c:(.text+0xf30): undefined reference to `ptp_clock_unregister'
arc-linux-ld: sparx5_ptp.c:(.text+0xf38): undefined reference to `ptp_clock_unregister'
arc-linux-ld: sparx5_ptp.c:(.text+0xf46): undefined reference to `ptp_clock_unregister'
arc-linux-ld: drivers/net/ethernet/microchip/sparx5/sparx5_ptp.o:sparx5_ptp.c:(.text+0xf46): more undefined references to `ptp_clock_unregister' follow

Fixes: 3cfa11bac9bb ("net: sparx5: add the basic sparx5 driver")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Horatiu Vultur <horatiu.vultur@microchip.com>
Cc: UNGLinuxDriver@microchip.com
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Steen Hegelund <steen.hegelund@microchip.com>
Cc: Bjarni Jonasson <bjarni.jonasson@microchip.com>
Cc: Lars Povlsen <lars.povlsen@microchip.com>
---
 drivers/net/ethernet/microchip/sparx5/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20220325.orig/drivers/net/ethernet/microchip/sparx5/Kconfig
+++ linux-next-20220325/drivers/net/ethernet/microchip/sparx5/Kconfig
@@ -4,6 +4,7 @@ config SPARX5_SWITCH
 	depends on HAS_IOMEM
 	depends on OF
 	depends on ARCH_SPARX5 || COMPILE_TEST
+	depends on PTP_1588_CLOCK_OPTIONAL
 	select PHYLINK
 	select PHY_SPARX5_SERDES
 	select RESET_CONTROLLER
