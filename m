Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B78CE6D4B03
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 16:51:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234260AbjDCOvx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 10:51:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234200AbjDCOvk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 10:51:40 -0400
Received: from mail-ed1-x564.google.com (mail-ed1-x564.google.com [IPv6:2a00:1450:4864:20::564])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E69B829BCE
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 07:51:15 -0700 (PDT)
Received: by mail-ed1-x564.google.com with SMTP id i5so118616919eda.0
        for <netdev@vger.kernel.org>; Mon, 03 Apr 2023 07:51:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dectris.com; s=google; t=1680533474;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FndVMXQ48NmaMTKqtO1ulaQVEXkhQgQUYelFrcn8/tk=;
        b=qglQ8cr6GDwbQnP87vDIAIW7KSO00TpW6GYJo+4ghDGZhjdiGbJLz3KBnYiSAR6L+4
         x1Gf8eQbGWLJ5euVAz2FBLRsfr8TGqf9cKUVxLezYNrZ2bwABa7r9IsoMdEEcpLB1ASW
         1exzz3mbakoC/6gnM2PcefyAkIPV7Ppb+xjAs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680533474;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FndVMXQ48NmaMTKqtO1ulaQVEXkhQgQUYelFrcn8/tk=;
        b=HFKK9op7fonLGdDNe+QIW9quA7EYAqCM1XgZokAb/okEDQYQpLutzMTflpWd9eEDBR
         /15+ahKpGBALVj0Xn2DGycB2SVZ3B1INwExRYuw3i6aSAxeWb3QIdngXqJEMb2JvDXgY
         SyGYYg8WG5Y4VHHxk27Evi3P0O7bsaNJc9q+6XRNE2tC7ar5eXxsaGvoydh3mbqley23
         lPOKKhPZAFe63I0NuMOl/5Y06t9IQoKcuUBUoq+TMdaI8IUBv8A64/nKAEVLkrMcSDCu
         fK9wbhiYhsav9fy6Zhy6RCmWcR1yX+0VMHkGOSYb0BZrsEc7j2sBLx/md8IA1UE0+C4K
         edqA==
X-Gm-Message-State: AAQBX9fPLCzBMD1+SRSNNYm4ofAvwz92TwPoIB+Ovcc7z5ZaWHoagETq
        Whv8fQm7gks/ReczTwtiJrglysyddDPDIWJqchJqBB2lzI8u
X-Google-Smtp-Source: AKy350ZitkLAPasR8KtGLgT6u/r/fs8gtm7qe7gcIVCyRMcSsIioX/ErwuX6hUat0Zt6NbRmoN2iaXxmF6cH
X-Received: by 2002:a17:906:980b:b0:932:4eea:17ce with SMTP id lm11-20020a170906980b00b009324eea17cemr35651679ejb.39.1680533474348;
        Mon, 03 Apr 2023 07:51:14 -0700 (PDT)
Received: from fedora.dectris.local (dect-ch-bad-pfw.cyberlink.ch. [62.12.151.50])
        by smtp-relay.gmail.com with ESMTPS id i25-20020a17090685d900b00944010e0472sm3146122ejy.236.2023.04.03.07.51.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 07:51:14 -0700 (PDT)
X-Relaying-Domain: dectris.com
From:   Kal Conley <kal.conley@dectris.com>
To:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Mykola Lysenko <mykolal@fb.com>, Shuah Khan <shuah@kernel.org>
Cc:     Kal Conley <kal.conley@dectris.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next 1/2] selftests: xsk: Use correct UMEM size in testapp_invalid_desc
Date:   Mon,  3 Apr 2023 16:50:46 +0200
Message-Id: <20230403145047.33065-2-kal.conley@dectris.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230403145047.33065-1-kal.conley@dectris.com>
References: <20230403145047.33065-1-kal.conley@dectris.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Avoid UMEM_SIZE macro in testapp_invalid_desc which is incorrect when
the frame size is not XSK_UMEM__DEFAULT_FRAME_SIZE. Also remove the
macro since it's no longer being used.

Fixes: 909f0e28207c ("selftests: xsk: Add tests for 2K frame size")
Signed-off-by: Kal Conley <kal.conley@dectris.com>
---
 tools/testing/selftests/bpf/xskxceiver.c | 9 +++++----
 tools/testing/selftests/bpf/xskxceiver.h | 1 -
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/bpf/xskxceiver.c b/tools/testing/selftests/bpf/xskxceiver.c
index b65e0645b0cd..3956f5db84f3 100644
--- a/tools/testing/selftests/bpf/xskxceiver.c
+++ b/tools/testing/selftests/bpf/xskxceiver.c
@@ -1652,6 +1652,7 @@ static void testapp_single_pkt(struct test_spec *test)
 
 static void testapp_invalid_desc(struct test_spec *test)
 {
+	u64 umem_size = test->ifobj_tx->umem->num_frames * test->ifobj_tx->umem->frame_size;
 	struct pkt pkts[] = {
 		/* Zero packet address allowed */
 		{0, PKT_SIZE, 0, true},
@@ -1662,9 +1663,9 @@ static void testapp_invalid_desc(struct test_spec *test)
 		/* Packet too large */
 		{0x2000, XSK_UMEM__INVALID_FRAME_SIZE, 0, false},
 		/* After umem ends */
-		{UMEM_SIZE, PKT_SIZE, 0, false},
+		{umem_size, PKT_SIZE, 0, false},
 		/* Straddle the end of umem */
-		{UMEM_SIZE - PKT_SIZE / 2, PKT_SIZE, 0, false},
+		{umem_size - PKT_SIZE / 2, PKT_SIZE, 0, false},
 		/* Straddle a page boundrary */
 		{0x3000 - PKT_SIZE / 2, PKT_SIZE, 0, false},
 		/* Straddle a 2K boundrary */
@@ -1682,8 +1683,8 @@ static void testapp_invalid_desc(struct test_spec *test)
 	}
 
 	if (test->ifobj_tx->shared_umem) {
-		pkts[4].addr += UMEM_SIZE;
-		pkts[5].addr += UMEM_SIZE;
+		pkts[4].addr += umem_size;
+		pkts[5].addr += umem_size;
 	}
 
 	pkt_stream_generate_custom(test, pkts, ARRAY_SIZE(pkts));
diff --git a/tools/testing/selftests/bpf/xskxceiver.h b/tools/testing/selftests/bpf/xskxceiver.h
index bdb4efedf3a9..cc24ab72f3ff 100644
--- a/tools/testing/selftests/bpf/xskxceiver.h
+++ b/tools/testing/selftests/bpf/xskxceiver.h
@@ -53,7 +53,6 @@
 #define THREAD_TMOUT 3
 #define DEFAULT_PKT_CNT (4 * 1024)
 #define DEFAULT_UMEM_BUFFERS (DEFAULT_PKT_CNT / 4)
-#define UMEM_SIZE (DEFAULT_UMEM_BUFFERS * XSK_UMEM__DEFAULT_FRAME_SIZE)
 #define RX_FULL_RXQSIZE 32
 #define UMEM_HEADROOM_TEST_SIZE 128
 #define XSK_UMEM__INVALID_FRAME_SIZE (XSK_UMEM__DEFAULT_FRAME_SIZE + 1)
-- 
2.39.2

