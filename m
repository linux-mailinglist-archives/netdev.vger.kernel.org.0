Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0C506BC4BB
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 04:30:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229966AbjCPDai (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 23:30:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229707AbjCPDaE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 23:30:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA3BD12BEA;
        Wed, 15 Mar 2023 20:28:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4D61561EFC;
        Thu, 16 Mar 2023 03:28:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15F79C433EF;
        Thu, 16 Mar 2023 03:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678937322;
        bh=oPPbw/PBxWk4Q1egWNZu46IiHqVVJx0VcMlY4jCe0r0=;
        h=From:Date:Subject:To:Cc:From;
        b=dK5puxNuRC2Gzse9fmdtPqVr8NzvsDuYp6512mAIgwsKgwKmeOxp7CJB2R9+9Ou9G
         uDEds2QwFKgzfWUV+9kK5cPn2wVl2uFcB1kjc3V4Q2/qI5JSqh/kNSN8clftqpKSMu
         eTnrKC33xE+p45afNDUgrWvi57bhk02jzPq3DIsCps2AIN3yzT7MQjbQvCb1b2i48O
         BSKXIRGO8L3iiE2L82s4bMKiN0VGGMC89mp0vN6vefzjHwE5zspvVSe0vCVAaqMLoX
         n2zeCs3phymkgJR/NQtTT1Q3TPjCdPOar7oEiAnd5YuKZJB8m1XhbcVF2JFhPmLOIO
         QVvcqHXfGOAww==
From:   Nathan Chancellor <nathan@kernel.org>
Date:   Wed, 15 Mar 2023 20:28:29 -0700
Subject: [PATCH next] wifi: iwlwifi: Avoid disabling GCC specific flag with
 clang
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230315-iwlwifi-fix-pragma-v1-1-ad23f92c4739@kernel.org>
X-B4-Tracking: v=1; b=H4sIANyMEmQC/x3N0QqDMAyF4VeRXC/Q2jmKrzJ2kbqoAe0kkSmI7
 766y5/DxznAWIUN2uoA5a+YfHIJf6ugGykPjPIuDbWrgwu+QdmmTXrBXnZclIaZMKX7I7jGR44
 RCkxkjEkpd+NFZ7KV9RoW5cL+b0/IvK/wOs8f9BH5yoMAAAA=
To:     johannes.berg@intel.com, gregory.greenman@intel.com
Cc:     kvalo@kernel.org, nathan@kernel.org, ndesaulniers@google.com,
        trix@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, patches@lists.linux.dev
X-Mailer: b4 0.12.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1454; i=nathan@kernel.org;
 h=from:subject:message-id; bh=oPPbw/PBxWk4Q1egWNZu46IiHqVVJx0VcMlY4jCe0r0=;
 b=owGbwMvMwCEmm602sfCA1DTG02pJDClCPS9PBIRVTCzMT7V6Mm3FHN+FF6zv37l7/IPU+Z4uA
 etNSxhSO0pZGMQ4GGTFFFmqH6seNzScc5bxxqlJMHNYmUCGMHBxCsBE5r5iZDg5LzOr07ladcb9
 mv9Lr/qGtUinP1rvWV/ktijzIaenaQIjw36LA09lr220P9kmfLDULGrDya/MM9ia7k55fSzX+1a
 4LgsA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clang errors:

  drivers/net/wireless/intel/iwlwifi/iwl-devtrace.c:15:32: error: unknown warning group '-Wsuggest-attribute=format', ignored [-Werror,-Wunknown-warning-option]
  #pragma GCC diagnostic ignored "-Wsuggest-attribute=format"
                                 ^
  1 error generated.

The warning being disabled by this pragma is GCC specific. Guard its use
with CONFIG_CC_IS_GCC so that it is not used with clang to clear up the
error.

Fixes: 4eca8cbf7ba8 ("wifi: iwlwifi: suppress printf warnings in tracing")
Link: https://github.com/ClangBuiltLinux/linux/issues/1818
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/iwl-devtrace.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-devtrace.c b/drivers/net/wireless/intel/iwlwifi/iwl-devtrace.c
index c190ec5effa1..e46639b097f4 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-devtrace.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-devtrace.c
@@ -12,7 +12,9 @@
 #include "iwl-trans.h"
 
 #define CREATE_TRACE_POINTS
+#ifdef CONFIG_CC_IS_GCC
 #pragma GCC diagnostic ignored "-Wsuggest-attribute=format"
+#endif
 #include "iwl-devtrace.h"
 
 EXPORT_TRACEPOINT_SYMBOL(iwlwifi_dev_ucode_event);

---
base-commit: 4eca8cbf7ba83c3291b5841905ce64584036b1ff
change-id: 20230315-iwlwifi-fix-pragma-bb4630518e88

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

