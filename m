Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63ACB539FE6
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 10:55:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350943AbiFAIzo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 04:55:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240907AbiFAIzm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 04:55:42 -0400
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 854363EB83;
        Wed,  1 Jun 2022 01:55:34 -0700 (PDT)
X-UUID: 3f01de6d2d9d4dcdab48dd6d9a90e923-20220601
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.5,REQID:07a5508c-f0d0-4141-97ae-30c7e52dea0e,OB:0,LO
        B:0,IP:0,URL:5,TC:0,Content:0,EDM:0,RT:0,SF:53,FILE:0,RULE:Release_Ham,ACT
        ION:release,TS:58
X-CID-INFO: VERSION:1.1.5,REQID:07a5508c-f0d0-4141-97ae-30c7e52dea0e,OB:0,LOB:
        0,IP:0,URL:5,TC:0,Content:0,EDM:0,RT:0,SF:53,FILE:0,RULE:Release_Ham,ACTIO
        N:release,TS:58
X-CID-META: VersionHash:2a19b09,CLOUDID:c2408914-f88c-475e-badf-d9ee54230b8f,C
        OID:5e25530cba60,Recheck:0,SF:28|100|17|19|48|101,TC:nil,Content:0,EDM:-3,
        IP:nil,URL:1,File:nil,QS:0,BEC:nil
X-UUID: 3f01de6d2d9d4dcdab48dd6d9a90e923-20220601
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw02.mediatek.com
        (envelope-from <lina.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 652858334; Wed, 01 Jun 2022 16:55:28 +0800
Received: from mtkmbs07n1.mediatek.inc (172.21.101.16) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.792.3;
 Wed, 1 Jun 2022 16:55:26 +0800
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 mtkmbs07n1.mediatek.inc (172.21.101.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 1 Jun 2022 16:55:26 +0800
Received: from mbjsdccf07.mediatek.inc (10.15.20.246) by
 mtkmbs11n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.792.3 via Frontend Transport; Wed, 1 Jun 2022 16:55:25 +0800
From:   Lina Wang <lina.wang@mediatek.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Maciej enczykowski <maze@google.com>, <netdev@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <lkp@intel.com>,
        <rong.a.chen@intel.com>, kernel test robot <oliver.sang@intel.com>,
        Lina Wang <lina.wang@mediatek.com>
Subject: [PATCH v2] selftests net: fix bpf build error
Date:   Wed, 1 Jun 2022 16:48:40 +0800
Message-ID: <20220601084840.11024-1-lina.wang@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        T_SCC_BODY_TEXT_LINE,T_SPF_TEMPERROR,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bpf_helpers.h has been moved to tools/lib/bpf since 5.10, so add more
including path.

Fixes: edae34a3ed92 ("selftests net: add UDP GRO fraglist + bpf self-tests")
Reported-by: kernel test robot <oliver.sang@intel.com>
Signed-off-by: Lina Wang <lina.wang@mediatek.com>
---
 tools/testing/selftests/net/bpf/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/net/bpf/Makefile b/tools/testing/selftests/net/bpf/Makefile
index f91bf14bbee7..070251986dbe 100644
--- a/tools/testing/selftests/net/bpf/Makefile
+++ b/tools/testing/selftests/net/bpf/Makefile
@@ -2,6 +2,7 @@
 
 CLANG ?= clang
 CCINCLUDE += -I../../bpf
+CCINCLUDE += -I../../../../lib
 CCINCLUDE += -I../../../../../usr/include/
 
 TEST_CUSTOM_PROGS = $(OUTPUT)/bpf/nat6to4.o
-- 
2.18.0

