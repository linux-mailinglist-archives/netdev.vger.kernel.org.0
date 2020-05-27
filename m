Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A86661E4DB9
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 20:58:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728674AbgE0S5l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 14:57:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728620AbgE0S5j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 14:57:39 -0400
Received: from mail-oo1-xc41.google.com (mail-oo1-xc41.google.com [IPv6:2607:f8b0:4864:20::c41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73605C08C5C2;
        Wed, 27 May 2020 11:57:38 -0700 (PDT)
Received: by mail-oo1-xc41.google.com with SMTP id v3so575272oot.1;
        Wed, 27 May 2020 11:57:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=g+Sx+LdvdlNSFwCeU+0IiQJrZn4C+WBNteUBifrI+jE=;
        b=KVvW98BqWNJ24t4WyN/kDF2iHvPjOBw9yXgMoj+8JhHhAlRDlE+LpzKyLqn3Xpvukv
         nqown0T98zAjGQYo/R+soVOVV9GmMOEPZemPOE6E9AskUI2lTowG+89h2Nae54qub440
         nN4oIa7J5phAONxfckHzvZ3M0u8UDlYQE5GLjjgP9oIx0/fYQAjHbPFXdYtLjfyPmfRu
         HqKv+HM3L6omH2j6MAGfV9IatjOE/0OhnlBCcpfQ119Igf7IDlYpuOPjDsezkhjNiLBs
         ObWnVQCjDvdmjGWi4ARxA5ZfIhjymjU5aRf6ZmarnM2zUVaqStWptuYpvxI5gXym6FuP
         31QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=g+Sx+LdvdlNSFwCeU+0IiQJrZn4C+WBNteUBifrI+jE=;
        b=oNmLG6Zy4b2/fKHXa3gRIKsE5wGN6HvlOfEluG1ixr0nW0mhrT3q5xG0k2J7PAa75N
         0csW9QMgsqAMn+348XmVL3E7MF3GNGEedZbRIWLncslLfXNBU9uYumpio3tdGH9v9/za
         FZGaVWtmyzgXe0UzeITaegRB1jWqpvFJUTHm/P+kigZYAjxPXf+vOofLfH+amalIZTyM
         O9UuwuxrK84XwYLdobSnBvmeJbyHaNZ9SfFJmaMFv/FvxQG+Mpr7kLZf1Cnf3ZK7YARM
         F52/ipL12wuDgObeimzp6QFNtoRE75E5V4Sa3XYoQ79Lp8pQWgugkQVGAx7ybgCM7aFk
         2X6w==
X-Gm-Message-State: AOAM530X0nVnTEBDKyOfMug/ovbf6nTzG7XguI1kYFkje99UDDbwqUtg
        UWOJA5yh0f2R8z3314idRgk=
X-Google-Smtp-Source: ABdhPJxzxs3LBefZR3f9QCZMzmpVC0Xh6Fb7A6WGu2tA0bCiDIdtmf9eu5W4zxbg+ADgH2XQJc85eg==
X-Received: by 2002:a4a:6b0b:: with SMTP id g11mr4196074ooc.6.1590605857821;
        Wed, 27 May 2020 11:57:37 -0700 (PDT)
Received: from localhost.members.linode.com ([2600:3c00::f03c:92ff:fe3e:1759])
        by smtp.gmail.com with ESMTPSA id i127sm1074596oih.38.2020.05.27.11.57.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2020 11:57:37 -0700 (PDT)
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
Subject: [PATCH bpf 3/5] selftests/bpf: cleanup comments in test_maps
Date:   Wed, 27 May 2020 18:56:58 +0000
Message-Id: <20200527185700.14658-4-a.s.protopopov@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200527185700.14658-3-a.s.protopopov@gmail.com>
References: <20200527185700.14658-1-a.s.protopopov@gmail.com>
 <20200527185700.14658-2-a.s.protopopov@gmail.com>
 <20200527185700.14658-3-a.s.protopopov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make comments inside the test_map_rdonly and test_map_wronly tests
consistent with logic.

Signed-off-by: Anton Protopopov <a.s.protopopov@gmail.com>
---
 tools/testing/selftests/bpf/test_maps.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_maps.c b/tools/testing/selftests/bpf/test_maps.c
index 46cf2c232964..08d63948514a 100644
--- a/tools/testing/selftests/bpf/test_maps.c
+++ b/tools/testing/selftests/bpf/test_maps.c
@@ -1394,11 +1394,11 @@ static void test_map_rdonly(void)
 
 	key = 1;
 	value = 1234;
-	/* Insert key=1 element. */
+	/* Try to insert key=1 element. */
 	assert(bpf_map_update_elem(fd, &key, &value, BPF_ANY) == -1 &&
 	       errno == EPERM);
 
-	/* Check that key=2 is not found. */
+	/* Check that key=1 is not found. */
 	assert(bpf_map_lookup_elem(fd, &key, &value) == -1 && errno == ENOENT);
 	assert(bpf_map_get_next_key(fd, &key, &value) == -1 && errno == ENOENT);
 
@@ -1422,7 +1422,7 @@ static void test_map_wronly(void)
 	/* Insert key=1 element. */
 	assert(bpf_map_update_elem(fd, &key, &value, BPF_ANY) == 0);
 
-	/* Check that key=2 is not found. */
+	/* Check that reading elements and keys from the map is not allowed. */
 	assert(bpf_map_lookup_elem(fd, &key, &value) == -1 && errno == EPERM);
 	assert(bpf_map_get_next_key(fd, &key, &value) == -1 && errno == EPERM);
 
-- 
2.20.1

