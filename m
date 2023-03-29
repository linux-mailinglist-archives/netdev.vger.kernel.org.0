Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D2D36CF1D2
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 20:08:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230214AbjC2SIZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 14:08:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230044AbjC2SIK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 14:08:10 -0400
Received: from mail-ed1-x564.google.com (mail-ed1-x564.google.com [IPv6:2a00:1450:4864:20::564])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE8615B8E
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 11:08:08 -0700 (PDT)
Received: by mail-ed1-x564.google.com with SMTP id ew6so66738792edb.7
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 11:08:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dectris.com; s=google; t=1680113288;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0JcOBw4gWK3pGVgIwSHEAH1ux6z4YHbgrrgEhO1iOUY=;
        b=nrB6uQaTQ7q47LdHn7rP+M5OOy965alRAvDM7vKPVyG22wCNrrubzORNHLdgVRQjkN
         Xwlxp5iYfTRGUqwS6+zDl3nUS0XfKzS/4xbA2kompJVv8PYikgPZaXwA31ZNI84uK2ez
         43O0SFRgxRgID6bVMCRHlOLXVjlLbC7C8OC4U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680113288;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0JcOBw4gWK3pGVgIwSHEAH1ux6z4YHbgrrgEhO1iOUY=;
        b=KZUpJv5PEixZQA2I/h2hhVKZ6gfRs091CPzN957UlxogrZEj0AXrcNOJaKRcWro5sG
         C/7DCGRaaYhWjjP6722x/OxCCzDgIo4Ct0e9wu5mbsazuApfaYRbC8v+qEJzZZpNFzpe
         NfdiOQssv2yKOXV6AWNV/+SNmLg63g/1RU4/aVOcFXkkpxfxZ323o94nRdfMtGdEpLnf
         o4ghEVixy1vuwri+beeFwR3meyGJDmPqDy7Itp+4d75QpdEr8Mhs63g2jsIa2ofJrxz7
         qCCjVJTcDZSTPx0zBXORBmNX0H5hORaVj6KzNj8HtG1TdUHF6XxewIXT9PDgSRPJz62f
         lY8w==
X-Gm-Message-State: AAQBX9fcFHg/joyfa44gsyDkKa+WFVz2t7YreRnHZLxjsHW37eLcaOJ6
        ob5hCyKnQb0eR9mCaDaZILSLzm3GXTboxHhRXjrLsV5WwJJb
X-Google-Smtp-Source: AKy350bxFMjlHaRl7efN4M/V4zSVbqY/9Z7mlghC560/VJfU3ARlAGRqXv8WzP8wQUQ3PrbCblEX4oeU7SsC
X-Received: by 2002:a17:907:7d89:b0:931:1567:f84f with SMTP id oz9-20020a1709077d8900b009311567f84fmr3803832ejc.4.1680113288432;
        Wed, 29 Mar 2023 11:08:08 -0700 (PDT)
Received: from fedora.dectris.local (dect-ch-bad-pfw.cyberlink.ch. [62.12.151.50])
        by smtp-relay.gmail.com with ESMTPS id m10-20020a1709066d0a00b00920438f59b3sm12072998ejr.154.2023.03.29.11.08.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Mar 2023 11:08:08 -0700 (PDT)
X-Relaying-Domain: dectris.com
From:   Kal Conley <kal.conley@dectris.com>
To:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Mykola Lysenko <mykolal@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Shuah Khan <shuah@kernel.org>
Cc:     Kal Conley <kal.conley@dectris.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next v2 07/10] selftests: xsk: Add test UNALIGNED_INV_DESC_4K1_FRAME_SIZE
Date:   Wed, 29 Mar 2023 20:04:59 +0200
Message-Id: <20230329180502.1884307-8-kal.conley@dectris.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230329180502.1884307-1-kal.conley@dectris.com>
References: <20230329180502.1884307-1-kal.conley@dectris.com>
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
 tools/testing/selftests/bpf/xskxceiver.c | 25 ++++++++++++++++++++++++
 tools/testing/selftests/bpf/xskxceiver.h |  1 +
 2 files changed, 26 insertions(+)

diff --git a/tools/testing/selftests/bpf/xskxceiver.c b/tools/testing/selftests/bpf/xskxceiver.c
index 1a4bdd5aa78c..9b9efd0e0a4c 100644
--- a/tools/testing/selftests/bpf/xskxceiver.c
+++ b/tools/testing/selftests/bpf/xskxceiver.c
@@ -69,6 +69,7 @@
  */
 
 #define _GNU_SOURCE
+#include <assert.h>
 #include <fcntl.h>
 #include <errno.h>
 #include <getopt.h>
@@ -1876,6 +1877,30 @@ static void run_pkt_test(struct test_spec *test, enum test_mode mode, enum test_
 		test->ifobj_rx->umem->unaligned_mode = true;
 		testapp_invalid_desc(test);
 		break;
+	case TEST_TYPE_UNALIGNED_INV_DESC_4K1_FRAME:
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
+		{
+			u64 umem_size = test->ifobj_tx->umem->num_frames *
+					test->ifobj_tx->umem->frame_size;
+			u64 page_size = sysconf(_SC_PAGESIZE);
+
+			assert(umem_size % page_size > PKT_SIZE);
+			assert(umem_size % page_size < page_size - PKT_SIZE);
+		}
+		testapp_invalid_desc(test);
+		break;
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

