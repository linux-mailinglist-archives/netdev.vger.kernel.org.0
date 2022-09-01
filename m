Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 661D25A95F3
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 13:48:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233088AbiIALsv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 07:48:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232963AbiIALsa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 07:48:30 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02A4B13A7E2;
        Thu,  1 Sep 2022 04:48:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662032908; x=1693568908;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ubvauW2ELUkcoVyWSv7QDK+bwZ40uhVhTYb2hOpWjrI=;
  b=G0WpYkJVCcIBnGsDei3n6d1vl5P0/3hHQdIHQjRF92z6gFMDvHiMg942
   CbSzQkykROZb+5eNBEybyRnHgCw1hvOnnJC4HggnTvxFilic/gI3YPetd
   +i9narzw/V/77oRpV0tRyHfkTX7oo7xlLBaKzOo6u5EI7YcTtgbAWKqO8
   3dUly1K3taj1uMwifFb7LtJDqszC96a0JcfGx2/kb4h2tSr0SXisYTDHh
   38as9n4maUIwdARI2jh3QvuSkpdF1WEZs7sqLi2D4sW1kfYXAxU6hyh7s
   bO5MfnGKxlmKlEQveYYquP00MdJB3QvEFvUvZSkitOgodnxljJnRaMl52
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10456"; a="357410370"
X-IronPort-AV: E=Sophos;i="5.93,280,1654585200"; 
   d="scan'208";a="357410370"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2022 04:48:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,280,1654585200"; 
   d="scan'208";a="673814359"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by fmsmga008.fm.intel.com with ESMTP; 01 Sep 2022 04:48:23 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org
Cc:     netdev@vger.kernel.org, magnus.karlsson@intel.com,
        bjorn@kernel.org, john.fastabend@gmail.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH v6 bpf-next 3/6] selftests: xsk: increase chars for interface name to 16
Date:   Thu,  1 Sep 2022 13:48:10 +0200
Message-Id: <20220901114813.16275-4-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220901114813.16275-1-maciej.fijalkowski@intel.com>
References: <20220901114813.16275-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

So that "enp240s0f0" or such name can be used against xskxceiver.
While at it, also extend character count for netns name.

Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 tools/testing/selftests/bpf/xskxceiver.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/xskxceiver.h b/tools/testing/selftests/bpf/xskxceiver.h
index 8d1c31f127e7..04b298c72f67 100644
--- a/tools/testing/selftests/bpf/xskxceiver.h
+++ b/tools/testing/selftests/bpf/xskxceiver.h
@@ -29,8 +29,8 @@
 #define TEST_FAILURE -1
 #define TEST_CONTINUE 1
 #define MAX_INTERFACES 2
-#define MAX_INTERFACE_NAME_CHARS 7
-#define MAX_INTERFACES_NAMESPACE_CHARS 10
+#define MAX_INTERFACE_NAME_CHARS 16
+#define MAX_INTERFACES_NAMESPACE_CHARS 16
 #define MAX_SOCKETS 2
 #define MAX_TEST_NAME_SIZE 32
 #define MAX_TEARDOWN_ITER 10
-- 
2.34.1

