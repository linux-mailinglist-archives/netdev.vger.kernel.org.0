Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E184D696816
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 16:29:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233576AbjBNP3I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 10:29:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233224AbjBNP3G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 10:29:06 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B98212B62E;
        Tue, 14 Feb 2023 07:29:04 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id fu4-20020a17090ad18400b002341fadc370so4042519pjb.1;
        Tue, 14 Feb 2023 07:29:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=AH28F6EvRrmywiD1UFCgKML+D/hgdDiHP7RyvKCIv6o=;
        b=mszEtkZ23wN6ChBaQur90G5eacTgdRxgFreNZhq0JaehQZ+ilGRkH1uI2YMEt7+him
         +qhVEc0BK2K4tB/0ZujTX7LAzH0pbU8X8MKXVKHQKtkW2oZOIJLeI7JIv6XgMWXEMmAJ
         QSEaB9tcyn+YNNmbaPsbbM46pF/MwybZ+at3TzGptcA8Y2BGKAwGuBpfS6fhIaohaVL4
         Lf8H9lFo56nxZ8fpo97UOCyo2NRNu+zBGjs+7CxKpxie5Rvsf22Cr738XX/CzijHGULT
         +h/yDH+aLehjCDbOWJGCGuGc3UY22J62fsV2LEslhx+c8Y9UaMkdTaREVOIWL4svbnkb
         TyTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AH28F6EvRrmywiD1UFCgKML+D/hgdDiHP7RyvKCIv6o=;
        b=wPdzMMixG02pRoao95GRkClwmSRsLGz99vDTbowF6DLPbZ26kWoWkYnII8HN0RF3wK
         SxNC/oZQWK7O154DIvPZpPlgAirv6zOpV1b2cEANtPFLJH0ElRf4rbPu9HbTYwPpyF1q
         pcMPIutXg4f4ZFmbW1CEV9J8hOJ8zo6vjaavGbFci4nVmZQCPo4kcs+AEhowHlTwWD1b
         CqXtaoBY2tnC2VvgWoKFcSWdmKShCSRZ/e4H2eYrDlGOU19PcboSOUG24dsungIWoryp
         RRqH0UJCeIws9A80BQkcyu3awffS/BB+eYV4PGoFoGCHNw/LPAjGlTYH+A9vuEfa48cq
         1rFw==
X-Gm-Message-State: AO0yUKWDYkwcqSJXJ+p7CHNgHrePrx5Su14+fn/R/RlI69qQtIz3VnTW
        Xv9DulqluAoB+8bb9pvm9hc=
X-Google-Smtp-Source: AK7set/kfQcJ2vREWV4TZJILYW2ejomRx0Hkjx+WoxFlFaYZ76ocWF4naZkikrA93Luit6sEUzz6sw==
X-Received: by 2002:a17:90b:1b0a:b0:234:190d:e655 with SMTP id nu10-20020a17090b1b0a00b00234190de655mr3025624pjb.44.1676388544071;
        Tue, 14 Feb 2023 07:29:04 -0800 (PST)
Received: from awkrail.localdomain.jp (p182177-ipngn200503kyoto.kyoto.ocn.ne.jp. [58.90.106.177])
        by smtp.gmail.com with ESMTPSA id u4-20020a17090ae00400b00233ebab3770sm4248042pjy.23.2023.02.14.07.28.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Feb 2023 07:29:03 -0800 (PST)
From:   Taichi Nishimura <awkrail01@gmail.com>
To:     shuah@kernel.org, andrii@kernel.org, mykolal@fb.com,
        ast@kernel.org, daniel@iogearbox.net, martin.lau@linux.dev,
        song@kernel.org, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, sdf@google.com, haoluo@google.com,
        jolsa@kernel.org, davem@davemloft.net, kuba@kernel.org,
        hawk@kernel.org, nathan@kernel.org, ndesaulniers@google.com,
        trix@redhat.com, awkrail01@gmail.com, ytcoode@gmail.com,
        deso@posteo.net, joannelkoong@gmail.com
Cc:     linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, llvm@lists.linux.dev
Subject: [PATCH] fixed typos on selftests/bpf
Date:   Wed, 15 Feb 2023 00:28:50 +0900
Message-Id: <20230214152850.389392-1-awkrail01@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I run spell checker and found typos in selftest/bpf/ files.
Fixed all of the detected typos.

This patch is an extra credit for kselftest task
in the Linux kernel bug fixing spring unpaid 2023.

Best regards,
Taichi Nishimura

Signed-off-by: Taichi Nishimura <awkrail01@gmail.com>
---
 tools/testing/selftests/bpf/prog_tests/migrate_reuseport.c    | 2 +-
 tools/testing/selftests/bpf/prog_tests/trampoline_count.c     | 2 +-
 tools/testing/selftests/bpf/progs/btf_dump_test_case_syntax.c | 2 +-
 tools/testing/selftests/bpf/progs/dynptr_fail.c               | 2 +-
 tools/testing/selftests/bpf/progs/strobemeta.h                | 2 +-
 tools/testing/selftests/bpf/progs/test_cls_redirect.c         | 4 ++--
 tools/testing/selftests/bpf/progs/test_subprogs.c             | 2 +-
 tools/testing/selftests/bpf/progs/test_xdp_vlan.c             | 2 +-
 tools/testing/selftests/bpf/test_cpp.cpp                      | 2 +-
 tools/testing/selftests/bpf/veristat.c                        | 4 ++--
 10 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/migrate_reuseport.c b/tools/testing/selftests/bpf/prog_tests/migrate_reuseport.c
index eb2feaac81fe..653b0a20fab9 100644
--- a/tools/testing/selftests/bpf/prog_tests/migrate_reuseport.c
+++ b/tools/testing/selftests/bpf/prog_tests/migrate_reuseport.c
@@ -488,7 +488,7 @@ static void run_test(struct migrate_reuseport_test_case *test_case,
 			goto close_servers;
 	}
 
-	/* Tie requests to the first four listners */
+	/* Tie requests to the first four listeners */
 	err = start_clients(test_case);
 	if (!ASSERT_OK(err, "start_clients"))
 		goto close_clients;
diff --git a/tools/testing/selftests/bpf/prog_tests/trampoline_count.c b/tools/testing/selftests/bpf/prog_tests/trampoline_count.c
index 564b75bc087f..353451a0c88c 100644
--- a/tools/testing/selftests/bpf/prog_tests/trampoline_count.c
+++ b/tools/testing/selftests/bpf/prog_tests/trampoline_count.c
@@ -74,7 +74,7 @@ void serial_test_trampoline_count(void)
 	if (!ASSERT_EQ(link, NULL, "ptr_is_null"))
 		goto cleanup;
 
-	/* and finaly execute the probe */
+	/* and finally execute the probe */
 	prog_fd = bpf_program__fd(prog);
 	if (!ASSERT_GE(prog_fd, 0, "bpf_program__fd"))
 		goto cleanup;
diff --git a/tools/testing/selftests/bpf/progs/btf_dump_test_case_syntax.c b/tools/testing/selftests/bpf/progs/btf_dump_test_case_syntax.c
index 4ee4748133fe..daa8753bb171 100644
--- a/tools/testing/selftests/bpf/progs/btf_dump_test_case_syntax.c
+++ b/tools/testing/selftests/bpf/progs/btf_dump_test_case_syntax.c
@@ -51,7 +51,7 @@ typedef void (*printf_fn_t)(const char *, ...);
  *	typedef int (*fn_t)(int);
  *	typedef char * const * (*fn_ptr2_t)(s_t, fn_t);
  *
- * - `fn_complext_t`: pointer to a function returning struct and accepting
+ * - `fn_complex_t`: pointer to a function returning struct and accepting
  *   union and struct. All structs and enum are anonymous and defined inline.
  *
  * - `signal_t: pointer to a function accepting a pointer to a function as an
diff --git a/tools/testing/selftests/bpf/progs/dynptr_fail.c b/tools/testing/selftests/bpf/progs/dynptr_fail.c
index 78debc1b3820..b979ee9f5a37 100644
--- a/tools/testing/selftests/bpf/progs/dynptr_fail.c
+++ b/tools/testing/selftests/bpf/progs/dynptr_fail.c
@@ -623,7 +623,7 @@ static int release_twice_callback_fn(__u32 index, void *data)
 }
 
 /* Test that releasing a dynptr twice, where one of the releases happens
- * within a calback function, fails
+ * within a callback function, fails
  */
 SEC("?raw_tp")
 __failure __msg("arg 1 is an unacquired reference")
diff --git a/tools/testing/selftests/bpf/progs/strobemeta.h b/tools/testing/selftests/bpf/progs/strobemeta.h
index 753718595c26..e562be6356f3 100644
--- a/tools/testing/selftests/bpf/progs/strobemeta.h
+++ b/tools/testing/selftests/bpf/progs/strobemeta.h
@@ -135,7 +135,7 @@ struct strobe_value_loc {
 	 * tpidr_el0 for aarch64).
 	 * TLS_IMM_EXEC: absolute address of GOT entry containing offset
 	 * from thread pointer;
-	 * TLS_GENERAL_DYN: absolute addres of double GOT entry
+	 * TLS_GENERAL_DYN: absolute address of double GOT entry
 	 * containing tls_index_t struct;
 	 */
 	int64_t offset;
diff --git a/tools/testing/selftests/bpf/progs/test_cls_redirect.c b/tools/testing/selftests/bpf/progs/test_cls_redirect.c
index 2833ad722cb7..a8ba39848bbf 100644
--- a/tools/testing/selftests/bpf/progs/test_cls_redirect.c
+++ b/tools/testing/selftests/bpf/progs/test_cls_redirect.c
@@ -600,7 +600,7 @@ static INLINING ret_t get_next_hop(buf_t *pkt, encap_headers_t *encap,
 		return TC_ACT_SHOT;
 	}
 
-	/* Skip the remainig next hops (may be zero). */
+	/* Skip the remaining next hops (may be zero). */
 	return skip_next_hops(pkt, encap->unigue.hop_count -
 					   encap->unigue.next_hop - 1);
 }
@@ -610,7 +610,7 @@ static INLINING ret_t get_next_hop(buf_t *pkt, encap_headers_t *encap,
  *
  *    fill_tuple(&t, foo, sizeof(struct iphdr), 123, 321)
  *
- * clang will substitue a costant for sizeof, which allows the verifier
+ * clang will substitute a costant for sizeof, which allows the verifier
  * to track it's value. Based on this, it can figure out the constant
  * return value, and calling code works while still being "generic" to
  * IPv4 and IPv6.
diff --git a/tools/testing/selftests/bpf/progs/test_subprogs.c b/tools/testing/selftests/bpf/progs/test_subprogs.c
index f8e9256cf18d..a8d602d7c88a 100644
--- a/tools/testing/selftests/bpf/progs/test_subprogs.c
+++ b/tools/testing/selftests/bpf/progs/test_subprogs.c
@@ -47,7 +47,7 @@ static __noinline int sub5(int v)
 	return sub1(v) - 1; /* compensates sub1()'s + 1 */
 }
 
-/* unfortunately verifier rejects `struct task_struct *t` as an unkown pointer
+/* unfortunately verifier rejects `struct task_struct *t` as an unknown pointer
  * type, so we need to accept pointer as integer and then cast it inside the
  * function
  */
diff --git a/tools/testing/selftests/bpf/progs/test_xdp_vlan.c b/tools/testing/selftests/bpf/progs/test_xdp_vlan.c
index 134768f6b788..c19324f228a3 100644
--- a/tools/testing/selftests/bpf/progs/test_xdp_vlan.c
+++ b/tools/testing/selftests/bpf/progs/test_xdp_vlan.c
@@ -98,7 +98,7 @@ bool parse_eth_frame(struct ethhdr *eth, void *data_end, struct parse_pkt *pkt)
 	return true;
 }
 
-/* Hint, VLANs are choosen to hit network-byte-order issues */
+/* Hint, VLANs are chosen to hit network-byte-order issues */
 #define TESTVLAN 4011 /* 0xFAB */
 // #define TO_VLAN  4000 /* 0xFA0 (hint 0xOA0 = 160) */
 
diff --git a/tools/testing/selftests/bpf/test_cpp.cpp b/tools/testing/selftests/bpf/test_cpp.cpp
index 0bd9990e83fa..f4936834f76f 100644
--- a/tools/testing/selftests/bpf/test_cpp.cpp
+++ b/tools/testing/selftests/bpf/test_cpp.cpp
@@ -91,7 +91,7 @@ static void try_skeleton_template()
 
 	skel.detach();
 
-	/* destructor will destory underlying skeleton */
+	/* destructor will destroy underlying skeleton */
 }
 
 int main(int argc, char *argv[])
diff --git a/tools/testing/selftests/bpf/veristat.c b/tools/testing/selftests/bpf/veristat.c
index f961b49b8ef4..83231456d3c5 100644
--- a/tools/testing/selftests/bpf/veristat.c
+++ b/tools/testing/selftests/bpf/veristat.c
@@ -144,7 +144,7 @@ static struct env {
 	struct verif_stats *prog_stats;
 	int prog_stat_cnt;
 
-	/* baseline_stats is allocated and used only in comparsion mode */
+	/* baseline_stats is allocated and used only in comparison mode */
 	struct verif_stats *baseline_stats;
 	int baseline_stat_cnt;
 
@@ -882,7 +882,7 @@ static int process_obj(const char *filename)
 		 * that BPF object file is incomplete and has to be statically
 		 * linked into a final BPF object file; instead of bailing
 		 * out, report it into stderr, mark it as skipped, and
-		 * proceeed
+		 * proceed
 		 */
 		fprintf(stderr, "Failed to open '%s': %d\n", filename, -errno);
 		env.files_skipped++;
-- 
2.25.1

