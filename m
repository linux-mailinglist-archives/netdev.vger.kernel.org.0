Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5944853E67A
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 19:07:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233042AbiFFJa6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 05:30:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233039AbiFFJao (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 05:30:44 -0400
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6BD6CFE04;
        Mon,  6 Jun 2022 02:30:36 -0700 (PDT)
X-UUID: 9da0ca4ab9714784bc805696926d2f86-20220606
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.5,REQID:8a3a7e6c-ef0d-4a18-bce8-80824a24180b,OB:0,LO
        B:0,IP:0,URL:5,TC:0,Content:0,EDM:0,RT:0,SF:100,FILE:0,RULE:Release_Ham,AC
        TION:release,TS:105
X-CID-INFO: VERSION:1.1.5,REQID:8a3a7e6c-ef0d-4a18-bce8-80824a24180b,OB:0,LOB:
        0,IP:0,URL:5,TC:0,Content:0,EDM:0,RT:0,SF:100,FILE:0,RULE:Spam_GS981B3D,AC
        TION:quarantine,TS:105
X-CID-META: VersionHash:2a19b09,CLOUDID:a2a64f7e-c8dc-403a-96e8-6237210dceee,C
        OID:0e4a7272b3e5,Recheck:0,SF:28|17|19|48,TC:nil,Content:0,EDM:-3,IP:nil,U
        RL:1,File:nil,QS:0,BEC:nil
X-UUID: 9da0ca4ab9714784bc805696926d2f86-20220606
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw01.mediatek.com
        (envelope-from <lina.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1911604969; Mon, 06 Jun 2022 14:52:09 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.186) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.792.3;
 Mon, 6 Jun 2022 14:52:08 +0800
Received: from mbjsdccf07.mediatek.inc (10.15.20.246) by
 mtkmbs11n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.792.3 via Frontend Transport; Mon, 6 Jun 2022 14:52:04 +0800
From:   Lina Wang <lina.wang@mediatek.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Maciej enczykowski <maze@google.com>, <netdev@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        Lina Wang <lina.wang@mediatek.com>
Subject: [PATCH v3] selftests net: fix bpf build error
Date:   Mon, 6 Jun 2022 14:45:17 +0800
Message-ID: <20220606064517.8175-1-lina.wang@mediatek.com>
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
Acked-by: Song Liu <songliubraving@fb.com>
---
 tools/testing/selftests/net/bpf/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/bpf/Makefile b/tools/testing/selftests/net/bpf/Makefile
index f91bf14bbee7..8a69c91fcca0 100644
--- a/tools/testing/selftests/net/bpf/Makefile
+++ b/tools/testing/selftests/net/bpf/Makefile
@@ -2,6 +2,7 @@
 
 CLANG ?= clang
 CCINCLUDE += -I../../bpf
+CCINCLUDE += -I../../../lib
 CCINCLUDE += -I../../../../../usr/include/
 
 TEST_CUSTOM_PROGS = $(OUTPUT)/bpf/nat6to4.o
@@ -10,5 +11,4 @@ all: $(TEST_CUSTOM_PROGS)
 $(OUTPUT)/%.o: %.c
 	$(CLANG) -O2 -target bpf -c $< $(CCINCLUDE) -o $@
 
-clean:
-	rm -f $(TEST_CUSTOM_PROGS)
+EXTRA_CLEAN := $(TEST_CUSTOM_PROGS)
-- 
2.18.0

