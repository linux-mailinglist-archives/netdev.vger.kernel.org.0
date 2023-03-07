Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E4246AF851
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 23:12:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229820AbjCGWML (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 17:12:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbjCGWMI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 17:12:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 612ADAF0DB;
        Tue,  7 Mar 2023 14:11:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6AEFDB81A40;
        Tue,  7 Mar 2023 22:10:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF8C9C4339B;
        Tue,  7 Mar 2023 22:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678227058;
        bh=oiHmhj71omPSPmGSzsOmodxrW5pGW9mHePmvgJmZ7As=;
        h=From:To:Cc:Subject:Date:From;
        b=ESNEmcOu9D0O8HKYGDlakAKeZDDgOSOGsroXbtL937IlcIRpYxzlH8ilV/ZCnKsdn
         Hf5qnPcqX0H8jcW1cpSYmBG1AAU4A09SznWdjythesCyDxz5dezmqE8MwECNq8pRk8
         voi0Q64t760M5bys2I0aVzDA7bkB5J/tbWFfEDFeHhOhxSqFyCSEQJ9T1z5LW0cBUz
         kBfdD/+L+0cQAlKcNFAbYyCBjNQNSqziXaNvN0r4C2WXFPLfb1X2EbksDtATnQ9/g4
         nh3eW4Po6sa1c5T2VhGcTo7speBu6Yxsx2IW7wKwZZeFeUG2aRENovXc0mwg96teVV
         HkoO80t+CWEmw==
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Jiawen Wu <jiawenwu@trustnetic.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH] net: restore alpha order to Ethernet devices in config
Date:   Tue,  7 Mar 2023 16:10:51 -0600
Message-Id: <20230307221051.890135-1-helgaas@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bjorn Helgaas <bhelgaas@google.com>

The filename "wangxun" sorts between "intel" and "xscale", but
xscale/Kconfig contains "Intel XScale" prompts, so Wangxun ends up in the
wrong place in the config front-ends.

Move wangxun/Kconfig so the Wangxun devices appear in order in the user
interface.

Fixes: 3ce7547e5b71 ("net: txgbe: Add build support for txgbe")
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/net/ethernet/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/Kconfig b/drivers/net/ethernet/Kconfig
index 323ec56e8a74..bb51ac8ad1b8 100644
--- a/drivers/net/ethernet/Kconfig
+++ b/drivers/net/ethernet/Kconfig
@@ -84,7 +84,6 @@ source "drivers/net/ethernet/huawei/Kconfig"
 source "drivers/net/ethernet/i825xx/Kconfig"
 source "drivers/net/ethernet/ibm/Kconfig"
 source "drivers/net/ethernet/intel/Kconfig"
-source "drivers/net/ethernet/wangxun/Kconfig"
 source "drivers/net/ethernet/xscale/Kconfig"
 
 config JME
@@ -179,6 +178,7 @@ source "drivers/net/ethernet/toshiba/Kconfig"
 source "drivers/net/ethernet/tundra/Kconfig"
 source "drivers/net/ethernet/vertexcom/Kconfig"
 source "drivers/net/ethernet/via/Kconfig"
+source "drivers/net/ethernet/wangxun/Kconfig"
 source "drivers/net/ethernet/wiznet/Kconfig"
 source "drivers/net/ethernet/xilinx/Kconfig"
 source "drivers/net/ethernet/xircom/Kconfig"
-- 
2.25.1

