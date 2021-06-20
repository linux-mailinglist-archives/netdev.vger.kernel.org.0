Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77A7B3AE124
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 01:33:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230160AbhFTXgD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Jun 2021 19:36:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230118AbhFTXgB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Jun 2021 19:36:01 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 804E1C061574;
        Sun, 20 Jun 2021 16:33:47 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id x19so7554605pln.2;
        Sun, 20 Jun 2021 16:33:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ho8mpG9beAl+0ggB96aMls1JfFIVbnP4cgBTDr5kAic=;
        b=guYP/Tk3zSbYsOIQ9PrYGzJ7gfHR+mCAl01iZpc2Q3jFVULZFZBMYMhwtBinwuBQNy
         vZii9E8BjlHgA0iVel4ZqhGkkrj+TwgHQEoky03EPtpgloB/gVHFBl8vy7sMUqxtFCQU
         9cqXrYfqVxVBX/THHb/ckbHSa308lnO2Zb87yI2LgIGpq1DyZZii9OpvSst9eaujriZG
         XjAi+GNIk0hJSTCP4HN0UQrDWgvY8AWyEYZT4Jwj10vqxFL4Et3SH32rsPkNh15o+ZXB
         jvyattL2fpSV3ARbWIQrDWBgzzy4EJnBVA+pm+hMm0/ZfSI0EWvCOHAXXzH9dM7lmUhz
         hrXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ho8mpG9beAl+0ggB96aMls1JfFIVbnP4cgBTDr5kAic=;
        b=lScvOC1dOkMTTOIB4axl1yF/85qK2qYgFUqKnHlxT3YLYjaTPUPT06lLIX2fiuZXDh
         a2Y/l6jOc4THDW71ytW5r26C29UYvjTmw64rpSUUpIybz1Jhv6HawON2ZEoacuDbRt7e
         Ap3wX6wqb2OkznIubagsgBOAYAulkS1xpmW8D3haqkXgAbvjJrAaNTI5yWzr9HJ24Cq2
         Qt78z8/9Xr65cosnGR406xRdadwDYPxiP9Wov6Tu86MWsoMJT8wZxz5scQyouV0ZHhI1
         Voic/m2U3cyQb6uP3I6SdRUu0667kluYNImkZpUZ5I4/y/veDbNlf2EOwjGzRs0JptAU
         51mQ==
X-Gm-Message-State: AOAM5326w0MyWU0JImstF0CMNMxNGTL8J/V53bL5vUCkKO175wQRzeEg
        fLGI55FGQC8La08HsPhnx1FNIo2K/1c=
X-Google-Smtp-Source: ABdhPJxgvgUuK+Pk2t5qQdxmzDjs9a+339K+95TM/2HNeWj8VTgVKaQ4FuQES/mx0zLU4zEtdqmCrQ==
X-Received: by 2002:a17:90a:8b0d:: with SMTP id y13mr34262611pjn.14.1624232026947;
        Sun, 20 Jun 2021 16:33:46 -0700 (PDT)
Received: from localhost ([2409:4063:4d19:cf2b:5167:bcec:f927:8a69])
        by smtp.gmail.com with ESMTPSA id o1sm13359033pjf.56.2021.06.20.16.33.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Jun 2021 16:33:46 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>, bpf@vger.kernel.org
Subject: [PATCH net-next 4/4] bpf: update XDP selftests to not fail with generic XDP
Date:   Mon, 21 Jun 2021 05:02:00 +0530
Message-Id: <20210620233200.855534-5-memxor@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210620233200.855534-1-memxor@gmail.com>
References: <20210620233200.855534-1-memxor@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Generic XDP devmaps and cpumaps now allow setting value_size to 8 bytes
(so that prog_fd can be specified) and XDP progs using them succeed in
SKB mode now. Adjust the checks.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 tools/testing/selftests/bpf/prog_tests/xdp_cpumap_attach.c | 4 ++--
 tools/testing/selftests/bpf/prog_tests/xdp_devmap_attach.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_cpumap_attach.c b/tools/testing/selftests/bpf/prog_tests/xdp_cpumap_attach.c
index 0176573fe4e7..42e46d2ae349 100644
--- a/tools/testing/selftests/bpf/prog_tests/xdp_cpumap_attach.c
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_cpumap_attach.c
@@ -29,8 +29,8 @@ void test_xdp_with_cpumap_helpers(void)
 	 */
 	prog_fd = bpf_program__fd(skel->progs.xdp_redir_prog);
 	err = bpf_set_link_xdp_fd(IFINDEX_LO, prog_fd, XDP_FLAGS_SKB_MODE);
-	CHECK(err == 0, "Generic attach of program with 8-byte CPUMAP",
-	      "should have failed\n");
+	CHECK(err, "Generic attach of program with 8-byte CPUMAP",
+	      "shouldn't have failed\n");
 
 	prog_fd = bpf_program__fd(skel->progs.xdp_dummy_cm);
 	map_fd = bpf_map__fd(skel->maps.cpu_map);
diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_devmap_attach.c b/tools/testing/selftests/bpf/prog_tests/xdp_devmap_attach.c
index 88ef3ec8ac4c..861db508ace2 100644
--- a/tools/testing/selftests/bpf/prog_tests/xdp_devmap_attach.c
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_devmap_attach.c
@@ -31,8 +31,8 @@ void test_xdp_with_devmap_helpers(void)
 	 */
 	dm_fd = bpf_program__fd(skel->progs.xdp_redir_prog);
 	err = bpf_set_link_xdp_fd(IFINDEX_LO, dm_fd, XDP_FLAGS_SKB_MODE);
-	CHECK(err == 0, "Generic attach of program with 8-byte devmap",
-	      "should have failed\n");
+	CHECK(err, "Generic attach of program with 8-byte devmap",
+	      "shouldn't have failed\n");
 
 	dm_fd = bpf_program__fd(skel->progs.xdp_dummy_dm);
 	map_fd = bpf_map__fd(skel->maps.dm_ports);
-- 
2.31.1

