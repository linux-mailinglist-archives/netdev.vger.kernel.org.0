Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF32D552DB5
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 10:58:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347828AbiFUI4s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 04:56:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347849AbiFUI4l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 04:56:41 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 57E8D240BB;
        Tue, 21 Jun 2022 01:56:30 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 3/5] selftests: netfilter: correct PKTGEN_SCRIPT_PATHS in nft_concat_range.sh
Date:   Tue, 21 Jun 2022 10:56:16 +0200
Message-Id: <20220621085618.3975-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220621085618.3975-1-pablo@netfilter.org>
References: <20220621085618.3975-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jie2x Zhou <jie2x.zhou@intel.com>

Before change:
make -C netfilter
 TEST: performance
   net,port                                                      [SKIP]
   perf not supported
   port,net                                                      [SKIP]
   perf not supported
   net6,port                                                     [SKIP]
   perf not supported
   port,proto                                                    [SKIP]
   perf not supported
   net6,port,mac                                                 [SKIP]
   perf not supported
   net6,port,mac,proto                                           [SKIP]
   perf not supported
   net,mac                                                       [SKIP]
   perf not supported

After change:
   net,mac                                                       [ OK ]
     baseline (drop from netdev hook):               2061098pps
     baseline hash (non-ranged entries):             1606741pps
     baseline rbtree (match on first field only):    1191607pps
     set with  1000 full, ranged entries:            1639119pps
ok 8 selftests: netfilter: nft_concat_range.sh

Fixes: 611973c1e06f ("selftests: netfilter: Introduce tests for sets with range concatenation")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Jie2x Zhou <jie2x.zhou@intel.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tools/testing/selftests/netfilter/nft_concat_range.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/netfilter/nft_concat_range.sh b/tools/testing/selftests/netfilter/nft_concat_range.sh
index b35010cc7f6a..a6991877e50c 100755
--- a/tools/testing/selftests/netfilter/nft_concat_range.sh
+++ b/tools/testing/selftests/netfilter/nft_concat_range.sh
@@ -31,7 +31,7 @@ BUGS="flush_remove_add reload"
 
 # List of possible paths to pktgen script from kernel tree for performance tests
 PKTGEN_SCRIPT_PATHS="
-	../../../samples/pktgen/pktgen_bench_xmit_mode_netif_receive.sh
+	../../../../samples/pktgen/pktgen_bench_xmit_mode_netif_receive.sh
 	pktgen/pktgen_bench_xmit_mode_netif_receive.sh"
 
 # Definition of set types:
-- 
2.30.2

