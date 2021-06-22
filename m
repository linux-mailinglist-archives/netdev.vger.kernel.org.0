Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BED53B0DEF
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 21:57:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232858AbhFVT7o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 15:59:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232823AbhFVT7m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 15:59:42 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F13F3C061574;
        Tue, 22 Jun 2021 12:57:25 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id b3so3349187plg.2;
        Tue, 22 Jun 2021 12:57:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ho8mpG9beAl+0ggB96aMls1JfFIVbnP4cgBTDr5kAic=;
        b=ZaJhdTpZCheyIDvl8SMfyCgl7gpCHTjgh05riTZ4lTYuUs85WJubXFuoFYY6GlmH+x
         t9wRsYMhKTN84r0qcL5ZPgb9gSqjn9+sGmWtKuHXQZJDQO5IojFsQVdQVjNOHFxh/DFb
         3/j2BlUsYH0Ifmu1ABOBrMIZ3OSiT/azqFaYYx1cFEWQ48PaRRwgJihExZFoEecwSjxT
         ru67K3J58rBCXrS5gpJV8MtXEyegxkK5NGQiLxndgo11pf9GdubOYYaq/HNBp0r/RuuY
         +dPL755LOcJYP/RWn2FPJnmP8IUvylFktR55BBJ2uf4M4YmepnA5mF0Sq8WcCBZTXGWC
         feJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ho8mpG9beAl+0ggB96aMls1JfFIVbnP4cgBTDr5kAic=;
        b=rSFy0lS24bLs1nT4/smGakysNFfEVEgVJwPx7lsaL8HD3UXCJB4D/2nIKd8HN8/JM8
         lVfXEE86yHAucrKSNcEeutk6dR6vRnRhS6aSMC2Og/0zc09b5Va+y0VVa5zjMzDrZqPk
         kKje2M2Z+7Bn4rpN1NMpIIh5Fj9kIHxXX+YGU/lIp9g9v5sOcR+o6o7cKb8ED7JZL5ty
         +r3O7UPuHEBkfUbfp/EKNV95UqY3zjdMdRw+BD9THHRIlA6gbgLVJHGEcawr2Mhn4Kk5
         3rCpZOjjrwT1rR8JHVub+jNZuZrqEBhADhQA0RqpU6139KafAmXmw+aMKSSc9YcBjEQQ
         gRRQ==
X-Gm-Message-State: AOAM533TWI0PzRVGf8AP7Emu7hMLwPYeX8C3G/YEiFGsJN+LRrTDNL7e
        kBU5w999Eh1JMSABnRGKMppZkgE+Pfo=
X-Google-Smtp-Source: ABdhPJwhisqMbi48Ece0jNwR2Vxewbk+DgYiPBAXSC3f4exv6GNV4jKd+tWmQSlpt0ncX+T2e0rYwg==
X-Received: by 2002:a17:90a:8b0d:: with SMTP id y13mr5612234pjn.88.1624391845414;
        Tue, 22 Jun 2021 12:57:25 -0700 (PDT)
Received: from localhost ([2402:3a80:11bb:33b3:7f0c:3646:8bde:417e])
        by smtp.gmail.com with ESMTPSA id b18sm160712pft.1.2021.06.22.12.57.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 12:57:25 -0700 (PDT)
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
Subject: [PATCH net-next v2 5/5] bpf: update XDP selftests to not fail with generic XDP
Date:   Wed, 23 Jun 2021 01:25:27 +0530
Message-Id: <20210622195527.1110497-6-memxor@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210622195527.1110497-1-memxor@gmail.com>
References: <20210622195527.1110497-1-memxor@gmail.com>
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

