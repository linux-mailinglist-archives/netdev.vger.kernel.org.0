Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 663733B0ECA
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 22:31:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbhFVUda (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 16:33:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230114AbhFVUd2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 16:33:28 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC816C061574;
        Tue, 22 Jun 2021 13:31:11 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id f10so8916020plg.0;
        Tue, 22 Jun 2021 13:31:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ho8mpG9beAl+0ggB96aMls1JfFIVbnP4cgBTDr5kAic=;
        b=moz/96mMW6dUOyAGHojY7v7orYfOZIHjrqog+XI4uttLQIgS4Jlwh3LKNtpVWyxVDz
         b0A3Vmluc4NpSzDKqbuSk0SUxBg0LYhlitHBnSlKNDbPoNJ5aAxHVrHzgXAZq/7RhK+m
         s2sN6eOL7N4JNCBIuB6ppMG01Vr2RF+uTwCCNV97LkDnVFUmOds/n/opeTwK3lO/3Ugw
         R7+3UizZx2G0V1JKGcMhxTMmC2eYXJtiS8D7ymknixw0x0gvh/eCyQZJJaNIgk9bNODa
         S9qbvsf9FkcN4uajXFtIAVdBHeLn1YdDX76Na8Vz3nV1QfivWg93IEIlfWevvH/Mx/KC
         IPhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ho8mpG9beAl+0ggB96aMls1JfFIVbnP4cgBTDr5kAic=;
        b=JRMprbOUvNOLDQEZszi3TUz9rOIPrfi3vdsS+C/X6ZLTHBTJO5MpqLI+C3eFQ5AuFg
         1MCUffmLHVa/Ojxx7SdzHG7Z8obKsPnFRUbTfhYzPRLdnuR3NxiR+yxfPd5qL4uuRaqm
         7xzauMiCMVh2Vsphc4XDv4u/jHHOI3zj+cyyW5GjxZpMa6gaNKusuPcSMwgjS2TnIZms
         kPkQxbDg5nvda3OlR5K7ETeHfru2s+L6zi+Sl5uMYbIlwEt5msJeavDKSuCas78XhT2x
         6LhNbvwvcThTHjGGuLIBElBOwOgWCI2UcTW/gCG499KVQ7qdaKAIFWecnCDndzYH9t4u
         AEFw==
X-Gm-Message-State: AOAM532sjfWbRPmKre1Jz9wqBWhU849oT4WMgjAxwZSr6WgIm9qs4rO7
        w+oYoKey8WhxJPcEstmtZ+2H5d+DCzg=
X-Google-Smtp-Source: ABdhPJxXNUDzs2e7ypHVjRfEmRuzDEU+LSLZ8ZT5crga9Wl6qI5WmW+7PcktfsCfM9MRvfer2hvGOQ==
X-Received: by 2002:a17:902:720c:b029:11e:787d:407e with SMTP id ba12-20020a170902720cb029011e787d407emr24689318plb.31.1624393871194;
        Tue, 22 Jun 2021 13:31:11 -0700 (PDT)
Received: from localhost ([2402:3a80:11bb:33b3:7f0c:3646:8bde:417e])
        by smtp.gmail.com with ESMTPSA id o1sm3118465pjf.56.2021.06.22.13.31.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 13:31:10 -0700 (PDT)
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
Subject: [PATCH net-next v3 5/5] bpf: update XDP selftests to not fail with generic XDP
Date:   Wed, 23 Jun 2021 01:58:35 +0530
Message-Id: <20210622202835.1151230-6-memxor@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210622202835.1151230-1-memxor@gmail.com>
References: <20210622202835.1151230-1-memxor@gmail.com>
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

