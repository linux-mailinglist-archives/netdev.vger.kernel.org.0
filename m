Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9224D698F1C
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 09:56:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229706AbjBPI4D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 03:56:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbjBPI4C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 03:56:02 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA81E3B3E6;
        Thu, 16 Feb 2023 00:56:00 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id r9-20020a17090a2e8900b00233ba727724so5457627pjd.1;
        Thu, 16 Feb 2023 00:56:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Ypi8jQ7F2+zD7Ox/61oWOym5Eew8ohAKNg0g1aHiunk=;
        b=jmBYNAyIxzvxr2+s7uIfnBlKzM3Kz3T57j6LAwRlPGFbMiFfzctEwMpN1BQCoUOnm+
         v1RjH3c6GDudgpMRQk4veiluPqAqUWoUHZ4o9C4LJ7W+ci7McT1Y99WTz+HblLzpD+ap
         NKhdGAJm2sN180PxiPiL2NO1/taUFef9APoAHMuGc27IXe447eg4mGD0y2gZpiKEIWK6
         9yczPNTpDww8j/ATNnKS0oMRpBwsOsRs5IuXyN0H+3lZi8/3X5bCOQzeZWd9jVaCiPV/
         xLUGRttLE+vjU+eDQNBJP3P4COnzBkMz8W2GMJyzh6nhCfYixAR/cWMHHwvnY+fkWB5w
         jwhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ypi8jQ7F2+zD7Ox/61oWOym5Eew8ohAKNg0g1aHiunk=;
        b=YgdWHdasb+dqgAx8jN4x1HzE+UmdzywbRNHDLgHE8GURrXB4PCoak/S03DKaU01DDK
         w32HlrXdtYlpzg41GcBTD33GQxGD+/km//cL9+xcpz86anlN/HASrlJM6AMWLmHcpKj7
         qliJ3TFJ6zb2fCjh1sSKGM0bB9cga+bx++4P+Azi6DVtjozJLM8wXZ2cMWbMblzoWQ26
         Hnsdperz0rakil88doGVy1Q/4dIMvSbFkn2RbDxa14V6EJr5O5ncd9lfxLU/ce8urVSy
         G+HaFPW+KtfSdEZ0WHp6riwCRUtSTwjoI1CDDlQOlJ/fVVxTznV0Jw8C6F7cuWGV0VCL
         irzw==
X-Gm-Message-State: AO0yUKUQLcZIqdcD9vvRMaNg3rBd/btkBGrsAFNRyvKeXtTxpl6ykW8J
        HtNmF08LghGySkAGst+EFaY=
X-Google-Smtp-Source: AK7set8JIRuzrIc0YG6+epfKd8EkZjZOU6eprUOONq+l5Y7ucy02vOt6JBegFr3roBLKx2DXJListA==
X-Received: by 2002:a17:902:e84a:b0:19a:a267:f16c with SMTP id t10-20020a170902e84a00b0019aa267f16cmr7371554plg.31.1676537760249;
        Thu, 16 Feb 2023 00:56:00 -0800 (PST)
Received: from localhost.localdomain (arc.lsta.media.kyoto-u.ac.jp. [130.54.10.65])
        by smtp.gmail.com with ESMTPSA id 13-20020a170902ee4d00b0019a88c1cf63sm754427plo.180.2023.02.16.00.55.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Feb 2023 00:55:59 -0800 (PST)
From:   Taichi Nishimura <awkrail01@gmail.com>
To:     andrii@kernel.org, mykolal@fb.com, ast@kernel.org,
        daniel@iogearbox.net, martin.lau@linux.dev, song@kernel.org,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org,
        sdf@google.com, haoluo@google.com, jolsa@kernel.org,
        shuah@kernel.org, davem@davemloft.net, kuba@kernel.org,
        hawk@kernel.org, nathan@kernel.org, ndesaulniers@google.com,
        trix@redhat.com, awkrail01@gmail.com, iii@linux.ibm.com,
        ytcoode@gmail.com, deso@posteo.net, memxor@gmail.com,
        joannelkoong@gmail.com, rdunlap@infradead.org
Cc:     bpf@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        llvm@lists.linux.dev
Subject: [PATCH bpf-next] Fix typos in selftest/bpf files
Date:   Thu, 16 Feb 2023 17:55:37 +0900
Message-Id: <20230216085537.519062-1-awkrail01@gmail.com>
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

Run spell checker on files in selftest/bpf and fixed typos.

Signed-off-by: Taichi Nishimura <awkrail01@gmail.com>
---
 tools/testing/selftests/bpf/prog_tests/migrate_reuseport.c  | 2 +-
 tools/testing/selftests/bpf/prog_tests/trampoline_count.c   | 2 +-
 .../testing/selftests/bpf/progs/btf_dump_test_case_syntax.c | 2 +-
 tools/testing/selftests/bpf/progs/dynptr_fail.c             | 2 +-
 tools/testing/selftests/bpf/progs/strobemeta.h              | 2 +-
 tools/testing/selftests/bpf/progs/test_cls_redirect.c       | 6 +++---
 tools/testing/selftests/bpf/progs/test_subprogs.c           | 2 +-
 tools/testing/selftests/bpf/progs/test_xdp_vlan.c           | 2 +-
 tools/testing/selftests/bpf/test_cpp.cpp                    | 2 +-
 tools/testing/selftests/bpf/veristat.c                      | 4 ++--
 10 files changed, 13 insertions(+), 13 deletions(-)

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
index 8fd4c0d78089..e91d0d1769f1 100644
--- a/tools/testing/selftests/bpf/prog_tests/trampoline_count.c
+++ b/tools/testing/selftests/bpf/prog_tests/trampoline_count.c
@@ -79,7 +79,7 @@ void serial_test_trampoline_count(void)
 	if (!ASSERT_EQ(link, NULL, "ptr_is_null"))
 		goto cleanup;
 
-	/* and finaly execute the probe */
+	/* and finally execute the probe */
 	prog_fd = bpf_program__fd(prog);
 	if (!ASSERT_GE(prog_fd, 0, "bpf_program__fd"))
 		goto cleanup;
diff --git a/tools/testing/selftests/bpf/progs/btf_dump_test_case_syntax.c b/tools/testing/selftests/bpf/progs/btf_dump_test_case_syntax.c
index 26fffb02ed10..ad21ee8c7e23 100644
--- a/tools/testing/selftests/bpf/progs/btf_dump_test_case_syntax.c
+++ b/tools/testing/selftests/bpf/progs/btf_dump_test_case_syntax.c
@@ -84,7 +84,7 @@ typedef void (*printf_fn_t)(const char *, ...);
  *	typedef int (*fn_t)(int);
  *	typedef char * const * (*fn_ptr2_t)(s_t, fn_t);
  *
- * - `fn_complext_t`: pointer to a function returning struct and accepting
+ * - `fn_complex_t`: pointer to a function returning struct and accepting
  *   union and struct. All structs and enum are anonymous and defined inline.
  *
  * - `signal_t: pointer to a function accepting a pointer to a function as an
diff --git a/tools/testing/selftests/bpf/progs/dynptr_fail.c b/tools/testing/selftests/bpf/progs/dynptr_fail.c
index 5950ad6ec2e6..aa5b69354b91 100644
--- a/tools/testing/selftests/bpf/progs/dynptr_fail.c
+++ b/tools/testing/selftests/bpf/progs/dynptr_fail.c
@@ -630,7 +630,7 @@ static int release_twice_callback_fn(__u32 index, void *data)
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
index 2833ad722cb7..66b304982245 100644
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
@@ -610,8 +610,8 @@ static INLINING ret_t get_next_hop(buf_t *pkt, encap_headers_t *encap,
  *
  *    fill_tuple(&t, foo, sizeof(struct iphdr), 123, 321)
  *
- * clang will substitue a costant for sizeof, which allows the verifier
- * to track it's value. Based on this, it can figure out the constant
+ * clang will substitute a constant for sizeof, which allows the verifier
+ * to track its value. Based on this, it can figure out the constant
  * return value, and calling code works while still being "generic" to
  * IPv4 and IPv6.
  */
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
index cdf3c48d6cbb..4ddcb6dfe500 100644
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

