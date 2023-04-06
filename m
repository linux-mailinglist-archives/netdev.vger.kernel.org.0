Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A10B36D97E3
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 15:20:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237882AbjDFNTt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 09:19:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238096AbjDFNTe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 09:19:34 -0400
Received: from mail-ej1-x664.google.com (mail-ej1-x664.google.com [IPv6:2a00:1450:4864:20::664])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D23C59F9
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 06:19:31 -0700 (PDT)
Received: by mail-ej1-x664.google.com with SMTP id g18so1326261ejj.5
        for <netdev@vger.kernel.org>; Thu, 06 Apr 2023 06:19:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dectris.com; s=google; t=1680787169;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OurEHAluO0z0/iX0xySpGmAc9WM9TpIWEufWnTv6GLE=;
        b=RtUe4waOH1uRH6GzLLr3ULwobeBTRIvPi9jWYefgAOEk2cjWDQO7BeHHRy0w5lhx0a
         2pl+RhTSFHdg5AaiAnN5o1gVK7I375ofrRGojqrx3NcU2kUeHf63vJ3GZ2HDbIhR97BX
         cPW6nkUcReuAiG/c3lSTnPxbNaqoQqUv/tTVQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680787169;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OurEHAluO0z0/iX0xySpGmAc9WM9TpIWEufWnTv6GLE=;
        b=UuU3Zi/g94U6qjdqs5ws5p6Z87HBgw62pH60gXqB5eN8+RE2Tc+PbGP/TQmHDWXHNf
         mFJNo9fLO/7Cx2KcdZzNopjis/+yvdgr4kTGoiNH/azvA9wBlrXuiPt9wKinKZ4h1flF
         KSHlDyQ87VAeEgN3JVjoIcmGHqwtFYAU3PCfCRRG6JZrqjl7lNzqDHzKhqzyM7rF14Sh
         NhuZrD8FMlsjXXz8HlQtkRM4pm89yXgHw/f3OJgjBXjplAidA4iqyuOAE3bPcvAD7rHE
         +jkvtpFzD29l65FHZmdn/jtB6VP889Hs02h0QbkbMGC86VTbo/lPTeKHk6rb97W32Qew
         jZhQ==
X-Gm-Message-State: AAQBX9cWQeaBQ1u8Evqpa7Iox+3nbGV+3MNeYuC4HAft8Pli3QERY8Ix
        PBvD3mmGG15EJksS/uchcVKdApNz/CXficeeHGIcDq+0dco9
X-Google-Smtp-Source: AKy350Y3BpqFjLhFsA8Ofyp/tsoaubMqvqG4LLFCCOMAjnpds5X8ALPDuorggWeREk8wrlueBVxKM0qjgzwX
X-Received: by 2002:a17:906:46c8:b0:932:c1e2:998b with SMTP id k8-20020a17090646c800b00932c1e2998bmr7247124ejs.15.1680787169403;
        Thu, 06 Apr 2023 06:19:29 -0700 (PDT)
Received: from fedora.dectris.local (dect-ch-bad-pfw.cyberlink.ch. [62.12.151.50])
        by smtp-relay.gmail.com with ESMTPS id 7-20020a170906014700b00947de8fa946sm137999ejh.201.2023.04.06.06.19.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Apr 2023 06:19:29 -0700 (PDT)
X-Relaying-Domain: dectris.com
From:   Kal Conley <kal.conley@dectris.com>
To:     Magnus Karlsson <magnus.karlsson@intel.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
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
Subject: [PATCH bpf-next v4 3/3] selftests: xsk: Add tests for 8K and 9K frame sizes
Date:   Thu,  6 Apr 2023 15:18:06 +0200
Message-Id: <20230406131806.51332-4-kal.conley@dectris.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230406131806.51332-1-kal.conley@dectris.com>
References: <20230406131806.51332-1-kal.conley@dectris.com>
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

Add tests:
- RUN_TO_COMPLETION_8K_FRAME_SIZE: frame_size=8192 (aligned)
- UNALIGNED_9K_FRAME_SIZE: frame_size=9000 (unaligned)

Signed-off-by: Kal Conley <kal.conley@dectris.com>
---
 tools/testing/selftests/bpf/xskxceiver.c | 25 ++++++++++++++++++++++++
 tools/testing/selftests/bpf/xskxceiver.h |  2 ++
 2 files changed, 27 insertions(+)

diff --git a/tools/testing/selftests/bpf/xskxceiver.c b/tools/testing/selftests/bpf/xskxceiver.c
index 7eccf57a0ccc..86797de7fc50 100644
--- a/tools/testing/selftests/bpf/xskxceiver.c
+++ b/tools/testing/selftests/bpf/xskxceiver.c
@@ -1841,6 +1841,17 @@ static void run_pkt_test(struct test_spec *test, enum test_mode mode, enum test_
 		pkt_stream_replace(test, DEFAULT_PKT_CNT, PKT_SIZE);
 		testapp_validate_traffic(test);
 		break;
+	case TEST_TYPE_RUN_TO_COMPLETION_8K_FRAME:
+		if (!hugepages_present(test->ifobj_tx)) {
+			ksft_test_result_skip("No 2M huge pages present.\n");
+			return;
+		}
+		test_spec_set_name(test, "RUN_TO_COMPLETION_8K_FRAME_SIZE");
+		test->ifobj_tx->umem->frame_size = 8192;
+		test->ifobj_rx->umem->frame_size = 8192;
+		pkt_stream_replace(test, DEFAULT_PKT_CNT, PKT_SIZE);
+		testapp_validate_traffic(test);
+		break;
 	case TEST_TYPE_RX_POLL:
 		test->ifobj_rx->use_poll = true;
 		test_spec_set_name(test, "POLL_RX");
@@ -1904,6 +1915,20 @@ static void run_pkt_test(struct test_spec *test, enum test_mode mode, enum test_
 		if (!testapp_unaligned(test))
 			return;
 		break;
+	case TEST_TYPE_UNALIGNED_9K_FRAME:
+		if (!hugepages_present(test->ifobj_tx)) {
+			ksft_test_result_skip("No 2M huge pages present.\n");
+			return;
+		}
+		test_spec_set_name(test, "UNALIGNED_9K_FRAME_SIZE");
+		test->ifobj_tx->umem->frame_size = 9000;
+		test->ifobj_rx->umem->frame_size = 9000;
+		test->ifobj_tx->umem->unaligned_mode = true;
+		test->ifobj_rx->umem->unaligned_mode = true;
+		pkt_stream_replace(test, DEFAULT_PKT_CNT, PKT_SIZE);
+		test->ifobj_rx->pkt_stream->use_addr_for_fill = true;
+		testapp_validate_traffic(test);
+		break;
 	case TEST_TYPE_HEADROOM:
 		testapp_headroom(test);
 		break;
diff --git a/tools/testing/selftests/bpf/xskxceiver.h b/tools/testing/selftests/bpf/xskxceiver.h
index 919327807a4e..7f52f737f5e9 100644
--- a/tools/testing/selftests/bpf/xskxceiver.h
+++ b/tools/testing/selftests/bpf/xskxceiver.h
@@ -69,12 +69,14 @@ enum test_mode {
 enum test_type {
 	TEST_TYPE_RUN_TO_COMPLETION,
 	TEST_TYPE_RUN_TO_COMPLETION_2K_FRAME,
+	TEST_TYPE_RUN_TO_COMPLETION_8K_FRAME,
 	TEST_TYPE_RUN_TO_COMPLETION_SINGLE_PKT,
 	TEST_TYPE_RX_POLL,
 	TEST_TYPE_TX_POLL,
 	TEST_TYPE_POLL_RXQ_TMOUT,
 	TEST_TYPE_POLL_TXQ_TMOUT,
 	TEST_TYPE_UNALIGNED,
+	TEST_TYPE_UNALIGNED_9K_FRAME,
 	TEST_TYPE_ALIGNED_INV_DESC,
 	TEST_TYPE_ALIGNED_INV_DESC_2K_FRAME,
 	TEST_TYPE_UNALIGNED_INV_DESC,
-- 
2.39.2

