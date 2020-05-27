Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2D2C1E4D8D
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 20:57:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728731AbgE0S5o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 14:57:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728688AbgE0S5m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 14:57:42 -0400
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92AD9C08C5C2;
        Wed, 27 May 2020 11:57:41 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id m67so12307588oif.4;
        Wed, 27 May 2020 11:57:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=I09zh1v7z5u8lEFHdYt72pjx0gywlmdpCKdvNPS3YjA=;
        b=Hl+IXHSFurDg/vHoOJem9FDAWswbJsRgzR+fGRdAysJ9zCQOtQuNxJWkcmpRqH7649
         M/Y3j5yHoE5LMgaorq7cDkZC5Z2mNAWvFE13fZRXW/GEBIk9PJ3MOvmc6oGzZk+XS5L+
         /F8TPP/8cPLNdBA4qIQ4e+DZWgqWR9Cr1T9g9zUph6jFs1GCN2xJ5AR/Es0KSBEiHwTU
         hQSg+Eb/8CJX62DK1aNQbc9vVlTHIUU6GyM8BV7c71G4ggYUPfJaT3+bQ+zl+AAWz+mE
         wDuK8owCbABniOeKBJmd+6+RDEWJgA/DBIaDXAvnni/okb0rQo5NfMRA7p0rPeGPGK+Q
         VaQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=I09zh1v7z5u8lEFHdYt72pjx0gywlmdpCKdvNPS3YjA=;
        b=motbcn1OSmmwLGxuv7KDz68uDSSQqN4JwASLK8Ahj7UZFmQMR403Jm3w315t5Qmlyv
         4axzkoTL4AmrC3XPmZDIaIYqP1TiwukfyTHMMaW8K6OGCocCUJueWuovzo9oxulp48vl
         RXxRsK8cUXaHQLDM+9GolAMl57YhCcRfEJ1tUlt2TTz0m7HR3kvMeTKh2GOSMqDLyEQs
         sjc7cF2/9lQabjfQQ5Y7csnzI90UhRUDPFjU26FjswOh5TDk3niCmDELVAzIoAOkWcq2
         78VTUjfDBJh5mkpZwzLsfoXk8QqNWn4mLP6GIECsGw05Hm5PS77jgT89qRjthNmvvOcu
         Mt/Q==
X-Gm-Message-State: AOAM530471s0Ej/VIoV6uuucspj3x57naCIs8NWwsWb2vnLzgEra9dTg
        St1tBMymiNv5LKKtomaE6QnRFInvThQ=
X-Google-Smtp-Source: ABdhPJxvi0EZe24uD0uYZYuQSoDF1clZ5ClhD7yha8spsIME2wl9ZZLZy5AG25fwLfpFhSyAjB7Fkg==
X-Received: by 2002:a05:6808:d8:: with SMTP id t24mr3598966oic.10.1590605860922;
        Wed, 27 May 2020 11:57:40 -0700 (PDT)
Received: from localhost.members.linode.com ([2600:3c00::f03c:92ff:fe3e:1759])
        by smtp.gmail.com with ESMTPSA id i127sm1074596oih.38.2020.05.27.11.57.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2020 11:57:39 -0700 (PDT)
From:   Anton Protopopov <a.s.protopopov@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Shuah Khan <shuah@kernel.org>
Cc:     Anton Protopopov <a.s.protopopov@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH bpf 5/5] selftests/bpf: add tests for write-only stacks/queues
Date:   Wed, 27 May 2020 18:57:00 +0000
Message-Id: <20200527185700.14658-6-a.s.protopopov@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200527185700.14658-5-a.s.protopopov@gmail.com>
References: <20200527185700.14658-1-a.s.protopopov@gmail.com>
 <20200527185700.14658-2-a.s.protopopov@gmail.com>
 <20200527185700.14658-3-a.s.protopopov@gmail.com>
 <20200527185700.14658-4-a.s.protopopov@gmail.com>
 <20200527185700.14658-5-a.s.protopopov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For write-only stacks and queues bpf_map_update_elem should be allowed, but
bpf_map_lookup_elem and bpf_map_lookup_and_delete_elem should fail with EPERM.

Signed-off-by: Anton Protopopov <a.s.protopopov@gmail.com>
---
 tools/testing/selftests/bpf/test_maps.c | 40 ++++++++++++++++++++++++-
 1 file changed, 39 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/test_maps.c b/tools/testing/selftests/bpf/test_maps.c
index 08d63948514a..6a12a0e01e07 100644
--- a/tools/testing/selftests/bpf/test_maps.c
+++ b/tools/testing/selftests/bpf/test_maps.c
@@ -1405,7 +1405,7 @@ static void test_map_rdonly(void)
 	close(fd);
 }
 
-static void test_map_wronly(void)
+static void test_map_wronly_hash(void)
 {
 	int fd, key = 0, value = 0;
 
@@ -1429,6 +1429,44 @@ static void test_map_wronly(void)
 	close(fd);
 }
 
+static void test_map_wronly_stack_or_queue(enum bpf_map_type map_type)
+{
+	int fd, value = 0;
+
+	assert(map_type == BPF_MAP_TYPE_QUEUE ||
+	       map_type == BPF_MAP_TYPE_STACK);
+	fd = bpf_create_map(map_type, 0, sizeof(value), MAP_SIZE,
+			    map_flags | BPF_F_WRONLY);
+	/* Stack/Queue maps do not support BPF_F_NO_PREALLOC */
+	if (map_flags & BPF_F_NO_PREALLOC) {
+		assert(fd < 0 && errno == EINVAL);
+		return;
+	}
+	if (fd < 0) {
+		printf("Failed to create map '%s'!\n", strerror(errno));
+		exit(1);
+	}
+
+	value = 1234;
+	assert(bpf_map_update_elem(fd, NULL, &value, BPF_ANY) == 0);
+
+	/* Peek element should fail */
+	assert(bpf_map_lookup_elem(fd, NULL, &value) == -1 && errno == EPERM);
+
+	/* Pop element should fail */
+	assert(bpf_map_lookup_and_delete_elem(fd, NULL, &value) == -1 &&
+	       errno == EPERM);
+
+	close(fd);
+}
+
+static void test_map_wronly(void)
+{
+	test_map_wronly_hash();
+	test_map_wronly_stack_or_queue(BPF_MAP_TYPE_STACK);
+	test_map_wronly_stack_or_queue(BPF_MAP_TYPE_QUEUE);
+}
+
 static void prepare_reuseport_grp(int type, int map_fd, size_t map_elem_size,
 				  __s64 *fds64, __u64 *sk_cookies,
 				  unsigned int n)
-- 
2.20.1

