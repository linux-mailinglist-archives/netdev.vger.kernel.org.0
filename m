Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1B936D8B51
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 01:59:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233929AbjDEX7s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 19:59:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234086AbjDEX7o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 19:59:44 -0400
Received: from mail-ed1-x562.google.com (mail-ed1-x562.google.com [IPv6:2a00:1450:4864:20::562])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94C13769B
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 16:59:40 -0700 (PDT)
Received: by mail-ed1-x562.google.com with SMTP id ew6so145151654edb.7
        for <netdev@vger.kernel.org>; Wed, 05 Apr 2023 16:59:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dectris.com; s=google; t=1680739179;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aiktHjl/mMcq2QHaTiXh/kaZ7IlrVAnqoR/RxQRC2zg=;
        b=M4qbOdZXV1C/wDoAtkeyblRD3pP/gVWJ2ejk/HkiM7w0jCcQ+v29RtLw8uUviwLJl1
         auBRb4iOIKy8itmdG/qdpbrAKRxz64u2qESoitiubJYsYHgTftPuHS1ASwXk3vl7M4az
         3IStF2usOaKTZJlThJ/IelRoZTkMFI4q2YFm8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680739179;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aiktHjl/mMcq2QHaTiXh/kaZ7IlrVAnqoR/RxQRC2zg=;
        b=QOEjSBcQxCGovumsCjgBoN1vrbhoL7nNrzdwOdGNiEcocZ4ts3NPfNGVHaXK/0vYBr
         pHOF/d8slDIPdV5XeCVW935hIBOCpH/mn6dUg/Ic4WPpdGdl6PyDFwIAJJQs6exBndjn
         Ci0urzEtsm/paK8Hoo5zyUfgrnZc1REt2mObj7bK7WT3sFCo6N+1aZTklwqbKh5ZY4Ay
         JPYEfbuMMg0werTYl8zJkZWR4prJ11SSblmVeV2kIspXZO6So3gzcu4vPd+3vWq060FU
         o4/H9FH71NKhbqjrI7cDtBW+W+0M+/eyGA30/HNC2cT/2DStFyt4RO/p9NDcjkmMjgKH
         kJww==
X-Gm-Message-State: AAQBX9ePxAgQAPGCCKvWh0XvcoB2kALPDlLWuQrWfaxfXZG5kk8+ddQY
        oN8glUrPRCD4LhklPtLzelKuboK2hfjRDq+sfmhcALdaNAIb
X-Google-Smtp-Source: AKy350ZO1gDgW7Ny5Ov0vBQrRbAUQYqALMitKDhaeYZHL3oGuCKea7cv8SV217niml8vcg3/D1sq64+4Br0U
X-Received: by 2002:a17:906:edcb:b0:930:f953:9614 with SMTP id sb11-20020a170906edcb00b00930f9539614mr5666535ejb.1.1680739178981;
        Wed, 05 Apr 2023 16:59:38 -0700 (PDT)
Received: from fedora.dectris.local (dect-ch-bad-pfw.cyberlink.ch. [62.12.151.50])
        by smtp-relay.gmail.com with ESMTPS id hd33-20020a17090796a100b00949174b747bsm8548ejc.96.2023.04.05.16.59.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 16:59:38 -0700 (PDT)
X-Relaying-Domain: dectris.com
From:   Kal Conley <kal.conley@dectris.com>
To:     Magnus Karlsson <magnus.karlsson@intel.com>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Mykola Lysenko <mykolal@fb.com>, Shuah Khan <shuah@kernel.org>
Cc:     Kal Conley <kal.conley@dectris.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next v2 2/2] selftests: xsk: Add test UNALIGNED_INV_DESC_4K1_FRAME_SIZE
Date:   Thu,  6 Apr 2023 01:59:19 +0200
Message-Id: <20230405235920.7305-3-kal.conley@dectris.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230405235920.7305-1-kal.conley@dectris.com>
References: <20230405235920.7305-1-kal.conley@dectris.com>
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

Add unaligned descriptor test for frame size of 4001. Using an odd frame
size ensures that the end of the UMEM is not near a page boundary. This
allows testing descriptors that staddle the end of the UMEM but not a
page.

This test used to fail without the previous commit ("xsk: Add check for
unaligned descriptors that overrun UMEM").

Signed-off-by: Kal Conley <kal.conley@dectris.com>
---
 tools/testing/selftests/bpf/xskxceiver.c | 24 ++++++++++++++++++++++++
 tools/testing/selftests/bpf/xskxceiver.h |  1 +
 2 files changed, 25 insertions(+)

diff --git a/tools/testing/selftests/bpf/xskxceiver.c b/tools/testing/selftests/bpf/xskxceiver.c
index 1a4bdd5aa78c..5a9691e942de 100644
--- a/tools/testing/selftests/bpf/xskxceiver.c
+++ b/tools/testing/selftests/bpf/xskxceiver.c
@@ -69,6 +69,7 @@
  */
 
 #define _GNU_SOURCE
+#include <assert.h>
 #include <fcntl.h>
 #include <errno.h>
 #include <getopt.h>
@@ -1876,6 +1877,29 @@ static void run_pkt_test(struct test_spec *test, enum test_mode mode, enum test_
 		test->ifobj_rx->umem->unaligned_mode = true;
 		testapp_invalid_desc(test);
 		break;
+	case TEST_TYPE_UNALIGNED_INV_DESC_4K1_FRAME: {
+		u64 page_size, umem_size;
+
+		if (!hugepages_present(test->ifobj_tx)) {
+			ksft_test_result_skip("No 2M huge pages present.\n");
+			return;
+		}
+		test_spec_set_name(test, "UNALIGNED_INV_DESC_4K1_FRAME_SIZE");
+		/* Odd frame size so the UMEM doesn't end near a page boundary. */
+		test->ifobj_tx->umem->frame_size = 4001;
+		test->ifobj_rx->umem->frame_size = 4001;
+		test->ifobj_tx->umem->unaligned_mode = true;
+		test->ifobj_rx->umem->unaligned_mode = true;
+		/* This test exists to test descriptors that staddle the end of
+		 * the UMEM but not a page.
+		 */
+		page_size = sysconf(_SC_PAGESIZE);
+		umem_size = test->ifobj_tx->umem->num_frames * test->ifobj_tx->umem->frame_size;
+		assert(umem_size % page_size > PKT_SIZE);
+		assert(umem_size % page_size < page_size - PKT_SIZE);
+		testapp_invalid_desc(test);
+		break;
+	}
 	case TEST_TYPE_UNALIGNED:
 		if (!testapp_unaligned(test))
 			return;
diff --git a/tools/testing/selftests/bpf/xskxceiver.h b/tools/testing/selftests/bpf/xskxceiver.h
index cc24ab72f3ff..919327807a4e 100644
--- a/tools/testing/selftests/bpf/xskxceiver.h
+++ b/tools/testing/selftests/bpf/xskxceiver.h
@@ -78,6 +78,7 @@ enum test_type {
 	TEST_TYPE_ALIGNED_INV_DESC,
 	TEST_TYPE_ALIGNED_INV_DESC_2K_FRAME,
 	TEST_TYPE_UNALIGNED_INV_DESC,
+	TEST_TYPE_UNALIGNED_INV_DESC_4K1_FRAME,
 	TEST_TYPE_HEADROOM,
 	TEST_TYPE_TEARDOWN,
 	TEST_TYPE_BIDI,
-- 
2.39.2

