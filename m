Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76C095374F3
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 09:23:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232663AbiE3G2Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 02:28:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232388AbiE3G2Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 02:28:24 -0400
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C027B25EAF;
        Sun, 29 May 2022 23:28:18 -0700 (PDT)
X-UUID: beb414e58d2c4899bcc7c4da52594413-20220530
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.5,REQID:a195ec36-b888-41bb-b4a1-9208f132fbd3,OB:0,LO
        B:0,IP:0,URL:5,TC:0,Content:0,EDM:0,RT:0,SF:100,FILE:0,RULE:Release_Ham,AC
        TION:release,TS:105
X-CID-INFO: VERSION:1.1.5,REQID:a195ec36-b888-41bb-b4a1-9208f132fbd3,OB:0,LOB:
        0,IP:0,URL:5,TC:0,Content:0,EDM:0,RT:0,SF:100,FILE:0,RULE:Spam_GS981B3D,AC
        TION:quarantine,TS:105
X-CID-META: VersionHash:2a19b09,CLOUDID:f2cff847-4fb1-496b-8f1d-39e733fed1ea,C
        OID:4c6178cddb7c,Recheck:0,SF:28|16|19|48,TC:nil,Content:0,EDM:-3,IP:nil,U
        RL:1,File:nil,QS:0,BEC:nil
X-UUID: beb414e58d2c4899bcc7c4da52594413-20220530
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw02.mediatek.com
        (envelope-from <lina.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 1226521694; Mon, 30 May 2022 14:28:10 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.186) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.792.3;
 Mon, 30 May 2022 14:28:09 +0800
Received: from mbjsdccf07.mediatek.inc (10.15.20.246) by
 mtkmbs11n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.792.3 via Frontend Transport; Mon, 30 May 2022 14:28:08 +0800
From:   Lina Wang <lina.wang@mediatek.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "Maciej enczykowski" <maze@google.com>, <netdev@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <lkp@intel.com>,
        <rong.a.chen@intel.com>, kernel test robot <oliver.sang@intel.com>,
        Lina Wang <lina.wang@mediatek.com>
Subject: [PATCH] selftests net: fix bpf build error
Date:   Mon, 30 May 2022 14:21:26 +0800
Message-ID: <20220530062126.27808-1-lina.wang@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,RDNS_NONE,
        SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,T_SPF_TEMPERROR,UNPARSEABLE_RELAY
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bpf_helpers.h has been moved to tools/lib/bpf since 5.10, so add more
incliding path.

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

