Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 404A157454B
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 08:51:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233081AbiGNGv0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 02:51:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230239AbiGNGvZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 02:51:25 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 770282871F;
        Wed, 13 Jul 2022 23:51:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657781484; x=1689317484;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=IgFWBJhx8O61e3eZsPUNChi+KMCQ8uSmCcKx5rnwkXU=;
  b=P9w5pc4mMclIQrRyLhRDH0Z8wSBVdHGaUN/pCOOmAzzLcTHUHNgDbD3l
   dMzcBW6WMZl75c+6yPLbntx81cMukvX1w6XG4dlDwht+o11e6A7rf0KFw
   lEhpCK0pG0E4QsDzIIdlrh11LyjziqOs9ZRFKymqQOJaS03H6cS14pXsu
   m/p8oW2gDtwSxoQFnFQNWLRTJAu1JgXkIVwXikldOU6/qicpyM7d0vSjI
   Ahe+dvnioI7QhI3loYZZ1YqJwb3HQR3wmjKVpoJpsoYMTl/MoZAWEGBTc
   hivYKxm5BHJ4uOEZW7bdqaLzq8h9py0jE5dnIgEzJDnRPa4rlAzQyfaka
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10407"; a="268463995"
X-IronPort-AV: E=Sophos;i="5.92,269,1650956400"; 
   d="scan'208";a="268463995"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2022 23:51:23 -0700
X-IronPort-AV: E=Sophos;i="5.92,269,1650956400"; 
   d="scan'208";a="922953841"
Received: from unknown (HELO jiezho4x-mobl1.ccr.corp.intel.com) ([10.255.29.31])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2022 23:51:19 -0700
From:   Jie2x Zhou <jie2x.zhou@intel.com>
To:     jie2x.zhou@intel.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, shuah@kernel.org,
        nathan@kernel.org, ndesaulniers@google.com, trix@redhat.com,
        netdev@vger.kernel.org
Cc:     linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, llvm@lists.linux.dev,
        Philip Li <philip.li@intel.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH] tools/testing/selftests/net/bpf/Makefile: fix fatal error: 'bpf/bpf_helpers.h' file not found
Date:   Thu, 14 Jul 2022 14:50:03 +0800
Message-Id: <20220714065003.8388-1-jie2x.zhou@intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In tools/testing/selftests run:
make -C bpf
make -C net
fatal error: 'bpf/bpf_helpers.h' file not found

Add bpf/bpf_helpers.h include path in net/bpf/Makefile.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Jie2x Zhou <jie2x.zhou@intel.com>
---
 tools/testing/selftests/net/bpf/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/net/bpf/Makefile b/tools/testing/selftests/net/bpf/Makefile
index 8ccaf8732eb2..07d56d446358 100644
--- a/tools/testing/selftests/net/bpf/Makefile
+++ b/tools/testing/selftests/net/bpf/Makefile
@@ -1,6 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 
 CLANG ?= clang
+CCINCLUDE += -I../bpf/tools/include
 CCINCLUDE += -I../../bpf
 CCINCLUDE += -I../../../../lib
 CCINCLUDE += -I../../../../../usr/include/
-- 
2.36.1

