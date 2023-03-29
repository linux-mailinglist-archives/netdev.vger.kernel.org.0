Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F3746CEC64
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 17:08:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230198AbjC2PIL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 11:08:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbjC2PIK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 11:08:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F5331BD7;
        Wed, 29 Mar 2023 08:08:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B1A00B81B8D;
        Wed, 29 Mar 2023 15:08:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2ED3C433EF;
        Wed, 29 Mar 2023 15:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680102483;
        bh=sqyJuVOPn12HXs42svFyLzzMir/9VKtRH5dGYB/kq/A=;
        h=From:Date:Subject:To:Cc:From;
        b=ecM66mq11hK3JVb5LbtYd2UcdYMEaT6WOpUIGju10bPLRuZXUoC5+7LFGLHf61/Rm
         NBDC6y1FYpYt7WDsCrzCRpaBwelMHT0bgO4DnKq+eN7UoNsjAwHYbpwxnx47BqZ/Su
         cpLJJyVI4h2wWNG14Ev1nNF8qXOyjjKG0MEbJsHOnSplHXSJsl7IuMls/Ygurb6gMC
         SMjgQkDSI1rgxI4sF49G0e2XL+r09bzGzL4CnDNt7mFrtKUApvSQsR4VbJJWa8JKw2
         vdOrxQ6R6Q09fZfv/0al2y21rmlN9bEai1TLGwsuNCOBt27DTyI2mPIyOiJvg1/J/l
         /GGSXAtiXQnVQ==
From:   Nathan Chancellor <nathan@kernel.org>
Date:   Wed, 29 Mar 2023 08:08:01 -0700
Subject: [PATCH net-next] net: ethernet: ti: Fix format specifier in
 netcp_create_interface()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230329-net-ethernet-ti-wformat-v1-1-83d0f799b553@kernel.org>
X-B4-Tracking: v=1; b=H4sIAFBUJGQC/x2NSwrDMAxErxK0rsC1Sfq5SulCcZVaizhFFmkg5
 O61u5vH8GZ2KKzCBe7dDsqrFFlyhfOpg5govxnlVRm888EFf8PMhmyJtQUT/E6LzmRIkeg6hN4
 N/QWqPVJhHJVyTM2fqRhrKz7Kk2z/ywe0kcybwfM4fuMEsgGMAAAA
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     nathan@kernel.org, ndesaulniers@google.com, trix@redhat.com,
        razor@blackwall.org, kerneljasonxing@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, patches@lists.linux.dev
X-Mailer: b4 0.12.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2668; i=nathan@kernel.org;
 h=from:subject:message-id; bh=sqyJuVOPn12HXs42svFyLzzMir/9VKtRH5dGYB/kq/A=;
 b=owGbwMvMwCEmm602sfCA1DTG02pJDCkqIUEb55980mla2v5HXet9VBKL975fT6fvv5d29ZNYk
 soyzz3tHaUsDGIcDLJiiizVj1WPGxrOOct449QkmDmsTCBDGLg4BWAiG6sYGS6/PJbdt6nv6u9a
 7XvB99JdxeYFtS/efudjJqOriOW/8z4M/6yqXKrWPQg7JhvKk1aZ/0Tu38+q1JgVL/Q8nRQUbJe
 85gUA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After commit 3948b05950fd ("net: introduce a config option to tweak
MAX_SKB_FRAGS"), clang warns:

  drivers/net/ethernet/ti/netcp_core.c:2085:4: warning: format specifies type 'long' but the argument has type 'int' [-Wformat]
                          MAX_SKB_FRAGS);
                          ^~~~~~~~~~~~~
  include/linux/dev_printk.h:144:65: note: expanded from macro 'dev_err'
          dev_printk_index_wrap(_dev_err, KERN_ERR, dev, dev_fmt(fmt), ##__VA_ARGS__)
                                                                 ~~~     ^~~~~~~~~~~
  include/linux/dev_printk.h:110:23: note: expanded from macro 'dev_printk_index_wrap'
                  _p_func(dev, fmt, ##__VA_ARGS__);                       \
                               ~~~    ^~~~~~~~~~~
  include/linux/skbuff.h:352:23: note: expanded from macro 'MAX_SKB_FRAGS'
  #define MAX_SKB_FRAGS CONFIG_MAX_SKB_FRAGS
                        ^~~~~~~~~~~~~~~~~~~~
  ./include/generated/autoconf.h:11789:30: note: expanded from macro 'CONFIG_MAX_SKB_FRAGS'
  #define CONFIG_MAX_SKB_FRAGS 17
                               ^~
  1 warning generated.

Follow the pattern of the rest of the tree by changing the specifier to
'%u' and casting MAX_SKB_FRAGS explicitly to 'unsigned int', which
eliminates the warning.

Fixes: 3948b05950fd ("net: introduce a config option to tweak MAX_SKB_FRAGS")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
I am a little confused as to why the solution for this warning is
casting to 'unsigned int' rather than just updating all the specifiers
to be '%d', as I do not see how MAX_SKB_FRAGS can be any type other than
just 'int' but I figured I would be consistent with the other fixes I
have seen around this issue.
---
 drivers/net/ethernet/ti/netcp_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/ti/netcp_core.c b/drivers/net/ethernet/ti/netcp_core.c
index 1bb596a9d8a2..d829113c16ee 100644
--- a/drivers/net/ethernet/ti/netcp_core.c
+++ b/drivers/net/ethernet/ti/netcp_core.c
@@ -2081,8 +2081,8 @@ static int netcp_create_interface(struct netcp_device *netcp_device,
 	netcp->tx_pool_region_id = temp[1];
 
 	if (netcp->tx_pool_size < MAX_SKB_FRAGS) {
-		dev_err(dev, "tx-pool size too small, must be at least %ld\n",
-			MAX_SKB_FRAGS);
+		dev_err(dev, "tx-pool size too small, must be at least %u\n",
+			(unsigned int)MAX_SKB_FRAGS);
 		ret = -ENODEV;
 		goto quit;
 	}

---
base-commit: 3b064f541be822dc095991c6dda20a75eb51db5e
change-id: 20230329-net-ethernet-ti-wformat-acaa86350657

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

