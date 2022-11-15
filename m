Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 557FA62A138
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 19:21:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbiKOSVU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 13:21:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230102AbiKOSVS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 13:21:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B016B1740D;
        Tue, 15 Nov 2022 10:21:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 478E06198D;
        Tue, 15 Nov 2022 18:21:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47EF4C433D6;
        Tue, 15 Nov 2022 18:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668536476;
        bh=xWjmq7WiC/F2r5gxXmowNQUk5c/Yd6DQ40WejS4CMrI=;
        h=From:To:Cc:Subject:Date:From;
        b=XV/xHytSXTAxKESi5zLwvm3E3IJevMUxrqXp/puCiUKcgXF2lcIadEpzTwc1Zsddj
         cg/kvtK17XcMBsBLC5YBGZRrLQjNQUk4mlxuGjgiUfhiPtWxs3BvsdbYJW5wFWbbzC
         3izeGNv/NU4wRXNAMbPB0U4VdcTewozfarptvttWJvg2B9gUFQp+73bh49nLVlMsuZ
         sw29JRq8vzVQ/awI8H9J6K5e4mlnb5lDNhXad0D98F1rnWxCJ4Jkkz6XeG3vpDZRss
         PhOcZ0JCvORYSKuwSjWdoyHQffv6ZuKKcnDl8Du49XKAnWHw/9dNNsae4jMFEkG8q6
         gcYIVwlkQBUtA==
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>
To:     bpf@vger.kernel.org, Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@rivosinc.com>,
        linux-riscv@lists.infradead.org, netdev@vger.kernel.org,
        Anders Roxell <anders.roxell@linaro.org>,
        Mykola Lysenko <mykolal@fb.com>,
        linux-kselftest@vger.kernel.org
Subject: [PATCH bpf 1/2] selftests/bpf: Explicitly pass RESOLVE_BTFIDS to sub-make
Date:   Tue, 15 Nov 2022 19:20:50 +0100
Message-Id: <20221115182051.582962-1-bjorn@kernel.org>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn@rivosinc.com>

When cross-compiling selftests/bpf, the resolve_btfids binary end up
in a different directory, than the regular resolve_btfids
builds. Populate RESOLVE_BTFIDS for sub-make, so it can find the
binary.

Signed-off-by: Björn Töpel <bjorn@rivosinc.com>
---
 tools/testing/selftests/bpf/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index e6cf21fad69f..8f8ede30e94e 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -200,7 +200,7 @@ $(OUTPUT)/sign-file: ../../../../scripts/sign-file.c
 $(OUTPUT)/bpf_testmod.ko: $(VMLINUX_BTF) $(wildcard bpf_testmod/Makefile bpf_testmod/*.[ch])
 	$(call msg,MOD,,$@)
 	$(Q)$(RM) bpf_testmod/bpf_testmod.ko # force re-compilation
-	$(Q)$(MAKE) $(submake_extras) -C bpf_testmod
+	$(Q)$(MAKE) $(submake_extras) RESOLVE_BTFIDS=$(RESOLVE_BTFIDS) -C bpf_testmod
 	$(Q)cp bpf_testmod/bpf_testmod.ko $@
 
 DEFAULT_BPFTOOL := $(HOST_SCRATCH_DIR)/sbin/bpftool

base-commit: 47df8a2f78bc34ff170d147d05b121f84e252b85
-- 
2.37.2

