Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 278CA39A719
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 19:10:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231686AbhFCRKT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 13:10:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:41470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231622AbhFCRKG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 13:10:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D663B613F8;
        Thu,  3 Jun 2021 17:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622740100;
        bh=S0arLeFgiygFNv2SwSBpMgnp3DpjxMX41fEk6gYS1c0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P/1pJ0KxqcE9dXvk/tpi6EHKJqBfIyHIwccKIyFUD8aGCCCWjhue+PiWiXkOkfhKy
         D9DUCMrurzbOYrSe5OJ6HnHL7BPX+Ly/Ex7ykLnMRmJxVyABLXOVC9MHnZosjSsgAJ
         wmFlD2KQDFkKY/f2MpGuusZ58YLQunMjiOj9xevGHO3imfiaKF22xqwnv1/wJzIqjY
         Kw/WuUcOvBgx7aRBEBloIImkzegfkDGnzZStWn9RB3yxyCaDAWrjU2TYL3OqqqboYy
         BeErLc8JGf8QVcw2kgIe3ESoZp+9stD4tej858S+Qwf4VKE9WjpDn2gW1dpp+trPZi
         P9jos9AfnEjJA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 37/43] bpf, selftests: Adjust few selftest result_unpriv outcomes
Date:   Thu,  3 Jun 2021 13:07:27 -0400
Message-Id: <20210603170734.3168284-37-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210603170734.3168284-1-sashal@kernel.org>
References: <20210603170734.3168284-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit 1bad6fd52be4ce12d207e2820ceb0f29ab31fc53 ]

Given we don't need to simulate the speculative domain for registers with
immediates anymore since the verifier uses direct imm-based rewrites instead
of having to mask, we can also lift a few cases that were previously rejected.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/verifier/stack_ptr.c       | 2 --
 tools/testing/selftests/bpf/verifier/value_ptr_arith.c | 8 --------
 2 files changed, 10 deletions(-)

diff --git a/tools/testing/selftests/bpf/verifier/stack_ptr.c b/tools/testing/selftests/bpf/verifier/stack_ptr.c
index 07eaa04412ae..8ab94d65f3d5 100644
--- a/tools/testing/selftests/bpf/verifier/stack_ptr.c
+++ b/tools/testing/selftests/bpf/verifier/stack_ptr.c
@@ -295,8 +295,6 @@
 	BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_1, 0),
 	BPF_EXIT_INSN(),
 	},
-	.result_unpriv = REJECT,
-	.errstr_unpriv = "invalid write to stack R1 off=0 size=1",
 	.result = ACCEPT,
 	.retval = 42,
 },
diff --git a/tools/testing/selftests/bpf/verifier/value_ptr_arith.c b/tools/testing/selftests/bpf/verifier/value_ptr_arith.c
index e5913fd3b903..7ae2859d495c 100644
--- a/tools/testing/selftests/bpf/verifier/value_ptr_arith.c
+++ b/tools/testing/selftests/bpf/verifier/value_ptr_arith.c
@@ -300,8 +300,6 @@
 	},
 	.fixup_map_array_48b = { 3 },
 	.result = ACCEPT,
-	.result_unpriv = REJECT,
-	.errstr_unpriv = "R0 pointer arithmetic of map value goes out of range",
 	.retval = 1,
 },
 {
@@ -371,8 +369,6 @@
 	},
 	.fixup_map_array_48b = { 3 },
 	.result = ACCEPT,
-	.result_unpriv = REJECT,
-	.errstr_unpriv = "R0 pointer arithmetic of map value goes out of range",
 	.retval = 1,
 },
 {
@@ -472,8 +468,6 @@
 	},
 	.fixup_map_array_48b = { 3 },
 	.result = ACCEPT,
-	.result_unpriv = REJECT,
-	.errstr_unpriv = "R0 pointer arithmetic of map value goes out of range",
 	.retval = 1,
 },
 {
@@ -766,8 +760,6 @@
 	},
 	.fixup_map_array_48b = { 3 },
 	.result = ACCEPT,
-	.result_unpriv = REJECT,
-	.errstr_unpriv = "R0 pointer arithmetic of map value goes out of range",
 	.retval = 1,
 },
 {
-- 
2.30.2

