Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99FD048EE8D
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 17:41:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243522AbiANQlR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 11:41:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243529AbiANQlM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 11:41:12 -0500
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F47BC061574;
        Fri, 14 Jan 2022 08:41:12 -0800 (PST)
Received: by mail-pj1-x1043.google.com with SMTP id i8-20020a17090a138800b001b3936fb375so22615124pja.1;
        Fri, 14 Jan 2022 08:41:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dcb+0ImpXn2QBxgA9dEdyoEqHG0SXOELXRtYsq6KA8s=;
        b=lcvvBGBBh+0lGS8cPQSOhevJpTZX6oSFbcggaonwN5j3VqLEDE3101yY4d4ou41Cgz
         n4BsNJ2IHyiy/Klw68aujybHYOn92AQowz3VObmttU6ItMZn9Uw2ov2VfneNCKOCmDV6
         chPiezL2PXIkk8ufLMQLhtyvBYMGlOeJdOvpBMSShqRk8nQN5nboqdCGxabuK8aZu5Rp
         HW92Hwhejlrt9j+sk+tobIfiBhSVShr9zZvAENm6+ls+p7ZQuUiDtXg33QKyoSIZjAoq
         IUN4hDt6KVpXz64PdedLCal3McUlNyHrFUoFWrpN9K12wyaO8PwaI4CEX8KNHH2HHS6n
         bOMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dcb+0ImpXn2QBxgA9dEdyoEqHG0SXOELXRtYsq6KA8s=;
        b=Zk/vC2ezPXYjYUnxKLnFp9VJyQ4kv42TrCBXsaFJ7862ec/+XXLi2WLxHJx1XdhZ7N
         nTwHREIiruDpSY1K0Yv00ZP5PsT1cXYfydS43pBkIjCkSVGDVtXo4PistE8efehFDkRo
         KQr4nB4BVj7WjyEs4iCqlxW5o1sSIPVSIX6WvJuCwR6Oied+VyVcxggu8eQiyiUKKlmM
         RUe1u46rlr/WgMhBBNb70OBUKV9TOLUz8HH7GOTPAiTwJJYmuc6gxdFjIuJpMXhoHpX+
         fGEIC7yRCiLQyGLdLzHCiv6V6AKJGFd5aVDFlzU8PbG1ag0v1ROP0PWkIMUEUobJR6S5
         LxFg==
X-Gm-Message-State: AOAM5336vLF8fhup2qfLUfwf3LNrBg1MXdjRzjgMRQJ6cXcl3ZCxuPSy
        Qei3buC2/2sLIKNhw6Ua81N6plk7UHolow==
X-Google-Smtp-Source: ABdhPJy/DxPJGgGOktryTSQ2l5P5n6HHRivImuBRTnrgIFQiMwk1r50uetwrs8AOvGRruhGkzdsgoQ==
X-Received: by 2002:a17:903:245:b0:149:d2a3:ddbf with SMTP id j5-20020a170903024500b00149d2a3ddbfmr9984818plh.3.1642178471182;
        Fri, 14 Jan 2022 08:41:11 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:3d4e:6265:800c:dc84])
        by smtp.gmail.com with ESMTPSA id d1sm4896311pgd.66.2022.01.14.08.41.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jan 2022 08:41:10 -0800 (PST)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: [PATCH bpf-next v8 10/10] selftests/bpf: Add test for race in btf_try_get_module
Date:   Fri, 14 Jan 2022 22:09:53 +0530
Message-Id: <20220114163953.1455836-11-memxor@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220114163953.1455836-1-memxor@gmail.com>
References: <20220114163953.1455836-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=18149; h=from:subject; bh=zshjPp83912NeLg9Mv0IQBqeiGLYQxp30dm+Z8HQ+SY=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBh4acV6+fNtJ2b3929WUwzqvj3s5tVkFvZ3Fx3ASu4 UjHOokCJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYeGnFQAKCRBM4MiGSL8Ryq9aEA CbNlim1Jf/yP/jQGwYzgg5dyoHEcPTqggLJ/CeY9xoKZzteJkijYFmQyjJS/H7Zqhj4oom5bg8TCC8 EKCS+TFHzAOG5wWMz3dpmxZPiTI7VF5YETqim0CyvS0EbnjS5r/s35quR182mkTrDIbmRiF2VGYFFZ Wr/R3yZhelBDi5eNpJ0JgrSZh6MxHQSmLBYjZSfdRvn9xUJc5GneFJBCdOXoHcsy3yBDv/NLK/EW2l N/cbcV+KVEnOn7HNTj2GJJFDZFN6VzFYCixhodrNHAVKHQWRwp3r9g1aVKzIGWXDi8c5HnxEs/46uS Jo/3z0HMucqwGiWxKycdsjCEMkE8nxXq9vVRTrYmhQkos32qM0Qd4zGsKE6miQv5b2p3W2btxmRVE2 3XwbnMsi11+q72bU2W/x31M2EraB0lMmSIWXE5dN3ZhgzGwOc20LIoVv+vLE8RfvrbZcVQNTFD0zHX rFZxhBdx4mQj/IF1y8H5+7GVBwno7D/Xw+FWv8nSNqUzzx7tCNCul24VRsAFMoSGDDsf6fgRh0oMoG cvok8DOrunVcPSvhYxixBmWVy1UuWccaqQG9bxqJqJ7gxkBC/jVRLakJSx8mb0UBoK7PPIK8pDejyf EOJKIeMufszeE3phdaHa5glb8euUFmZsMVODpzSGhCZdzfgABQPAYaJjQOHw==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds a complete test case to ensure we never take references to
modules not in MODULE_STATE_LIVE, which can lead to UAF, and it also
ensures we never access btf->kfunc_set_tab in an inconsistent state.

The test uses userfaultfd to artificially widen the race.

When run on an unpatched kernel, it leads to the following splat:

[root@(none) bpf]# ./test_progs -t bpf_mod_race/ksym
[   55.498171] BUG: unable to handle page fault for address: fffffbfff802548b                                                                      [   55.499206] #PF: supervisor read access in kernel mode
[   55.499855] #PF: error_code(0x0000) - not-present page
[   55.500555] PGD a4fa9067 P4D a4fa9067 PUD a4fa5067 PMD 1b44067 PTE 0
[   55.501499] Oops: 0000 [#1] PREEMPT SMP KASAN NOPTI
[   55.502195] CPU: 0 PID: 83 Comm: kworker/0:2 Tainted: G           OE     5.16.0-rc4+ #151                                                       [   55.503388] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS ArchLinux 1.15.0-1 04/01/2014
[   55.504777] Workqueue: events bpf_prog_free_deferred
[   55.505563] RIP: 0010:kasan_check_range+0x184/0x1d0
[   55.506363] Code: 12 83 e0 07 48 39 d0 7d 8a 41 bb 01 00 00 00 5b 5d 44 89 d8 41 5c c3 48 85 d2 74 ed 48 01 ea eb 09 48 83 c0 01 48 39 d0 74 df
<80> 38 00 74 f2 e9 39 ff ff ff b8 01 00 00 00 c3 48 29 c3 48 89 da
[   55.509140] RSP: 0018:ffff88800560fcf0 EFLAGS: 00010282
[   55.509977] RAX: fffffbfff802548b RBX: fffffbfff802548c RCX: ffffffff9337b6ba
[   55.511096] RDX: fffffbfff802548c RSI: 0000000000000004 RDI: ffffffffc012a458
[   55.512143] RBP: fffffbfff802548b R08: 0000000000000001 R09: ffffffffc012a45b
[   55.513228] R10: fffffbfff802548b R11: 0000000000000001 R12: ffff888001b5f598
[   55.514332] R13: ffff888004f49ac8 R14: 0000000000000000 R15: ffff888092449400
[   55.515418] FS:  0000000000000000(0000) GS:ffff888092400000(0000) knlGS:0000000000000000
[   55.516705] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   55.517560] CR2: fffffbfff802548b CR3: 0000000007c10006 CR4: 0000000000770ef0

[   55.518672] PKRU: 55555554
[   55.519022] Call Trace:
[   55.519483]  <TASK>
[   55.519884]  module_put.part.0+0x2a/0x180
[   55.520642]  bpf_prog_free_deferred+0x129/0x2e0
[   55.521478]  process_one_work+0x4fa/0x9e0
[   55.522122]  ? pwq_dec_nr_in_flight+0x100/0x100
[   55.522878]  ? rwlock_bug.part.0+0x60/0x60
[   55.523551]  worker_thread+0x2eb/0x700
[   55.524176]  ? __kthread_parkme+0xd8/0xf0
[   55.524853]  ? process_one_work+0x9e0/0x9e0
[   55.525544]  kthread+0x23a/0x270
[   55.526088]  ? set_kthread_struct+0x80/0x80
[   55.526798]  ret_from_fork+0x1f/0x30
[   55.527413]  </TASK>
[   55.527813] Modules linked in: bpf_testmod(OE) crc32_pclmul(E) intel_rapl_msr(E) intel_rapl_common(E) rapl(E) ghash_clmulni_intel(E) crct10dif_pclmul(E) crc32c_intel(E) serio_raw(E) [last unloaded: bpf_testmod]
[   55.530846] CR2: fffffbfff802548b
[   55.531341] ---[ end trace 1af41803c054ad6d ]---
[   55.532136] RIP: 0010:kasan_check_range+0x184/0x1d0
[   55.532918] Code: 12 83 e0 07 48 39 d0 7d 8a 41 bb 01 00 00 00 5b 5d 44 89 d8 41 5c c3 48 85 d2 74 ed 48 01 ea eb 09 48 83 c0 01 48 39 d0 74 df <80> 38 00 74 f2 e9 39 ff ff ff b8 01 00 00 00 c3 48 29 c3 48 89 da
[   55.535887] RSP: 0018:ffff88800560fcf0 EFLAGS: 00010282
[   55.536711] RAX: fffffbfff802548b RBX: fffffbfff802548c RCX: ffffffff9337b6ba
[   55.537821] RDX: fffffbfff802548c RSI: 0000000000000004 RDI: ffffffffc012a458
[   55.538899] RBP: fffffbfff802548b R08: 0000000000000001 R09: ffffffffc012a45b
[   55.539928] R10: fffffbfff802548b R11: 0000000000000001 R12: ffff888001b5f598
[   55.541021] R13: ffff888004f49ac8 R14: 0000000000000000 R15: ffff888092449400
[   55.542108] FS:  0000000000000000(0000) GS:ffff888092400000(0000) knlGS:0000000000000000
[   55.543260]CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   55.544136] CR2: fffffbfff802548b CR3: 0000000007c10006 CR4: 0000000000770ef0
[   55.545317] PKRU: 55555554
[   55.545671] note: kworker/0:2[83] exited with preempt_count 1

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 net/bpf/test_run.c                            |   2 +
 .../selftests/bpf/bpf_testmod/bpf_testmod.c   |   4 +
 tools/testing/selftests/bpf/config            |   1 +
 .../selftests/bpf/prog_tests/bpf_mod_race.c   | 230 ++++++++++++++++++
 .../selftests/bpf/progs/bpf_mod_race.c        | 100 ++++++++
 .../selftests/bpf/progs/kfunc_call_race.c     |  14 ++
 tools/testing/selftests/bpf/progs/ksym_race.c |  13 +
 7 files changed, 364 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/bpf_mod_race.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_mod_race.c
 create mode 100644 tools/testing/selftests/bpf/progs/kfunc_call_race.c
 create mode 100644 tools/testing/selftests/bpf/progs/ksym_race.c

diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index 93ba56507240..3a5bf8ad834d 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -172,6 +172,8 @@ int noinline bpf_fentry_test1(int a)
 {
 	return a + 1;
 }
+EXPORT_SYMBOL_GPL(bpf_fentry_test1);
+ALLOW_ERROR_INJECTION(bpf_fentry_test1, ERRNO);
 
 int noinline bpf_fentry_test2(int a, u64 b)
 {
diff --git a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c
index c0805d0d753f..bdbacf5adcd2 100644
--- a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c
+++ b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c
@@ -118,6 +118,8 @@ static const struct btf_kfunc_id_set bpf_testmod_kfunc_set = {
 	.check_set = &bpf_testmod_check_kfunc_ids,
 };
 
+extern int bpf_fentry_test1(int a);
+
 static int bpf_testmod_init(void)
 {
 	int ret;
@@ -125,6 +127,8 @@ static int bpf_testmod_init(void)
 	ret = register_btf_kfunc_id_set(BPF_PROG_TYPE_SCHED_CLS, &bpf_testmod_kfunc_set);
 	if (ret < 0)
 		return ret;
+	if (bpf_fentry_test1(0) < 0)
+		return -EINVAL;
 	return sysfs_create_bin_file(kernel_kobj, &bin_attr_bpf_testmod_file);
 }
 
diff --git a/tools/testing/selftests/bpf/config b/tools/testing/selftests/bpf/config
index 32d80e77e910..763db63a3890 100644
--- a/tools/testing/selftests/bpf/config
+++ b/tools/testing/selftests/bpf/config
@@ -52,3 +52,4 @@ CONFIG_NETFILTER=y
 CONFIG_NF_DEFRAG_IPV4=y
 CONFIG_NF_DEFRAG_IPV6=y
 CONFIG_NF_CONNTRACK=y
+CONFIG_USERFAULTFD=y
diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_mod_race.c b/tools/testing/selftests/bpf/prog_tests/bpf_mod_race.c
new file mode 100644
index 000000000000..d43f548c572c
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_mod_race.c
@@ -0,0 +1,230 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <unistd.h>
+#include <pthread.h>
+#include <sys/mman.h>
+#include <stdatomic.h>
+#include <test_progs.h>
+#include <sys/syscall.h>
+#include <linux/module.h>
+#include <linux/userfaultfd.h>
+
+#include "ksym_race.skel.h"
+#include "bpf_mod_race.skel.h"
+#include "kfunc_call_race.skel.h"
+
+/* This test crafts a race between btf_try_get_module and do_init_module, and
+ * checks whether btf_try_get_module handles the invocation for a well-formed
+ * but uninitialized module correctly. Unless the module has completed its
+ * initcalls, the verifier should fail the program load and return ENXIO.
+ *
+ * userfaultfd is used to trigger a fault in an fmod_ret program, and make it
+ * sleep, then the BPF program is loaded and the return value from verifier is
+ * inspected. After this, the userfaultfd is closed so that the module loading
+ * thread makes forward progress, and fmod_ret injects an error so that the
+ * module load fails and it is freed.
+ *
+ * If the verifier succeeded in loading the supplied program, it will end up
+ * taking reference to freed module, and trigger a crash when the program fd
+ * is closed later. This is true for both kfuncs and ksyms. In both cases,
+ * the crash is triggered inside bpf_prog_free_deferred, when module reference
+ * is finally released.
+ */
+
+struct test_config {
+	const char *str_open;
+	void *(*bpf_open_and_load)();
+	void (*bpf_destroy)(void *);
+};
+
+enum test_state {
+	_TS_INVALID,
+	TS_MODULE_LOAD,
+	TS_MODULE_LOAD_FAIL,
+};
+
+static _Atomic enum test_state state = _TS_INVALID;
+
+static int sys_finit_module(int fd, const char *param_values, int flags)
+{
+	return syscall(__NR_finit_module, fd, param_values, flags);
+}
+
+static int sys_delete_module(const char *name, unsigned int flags)
+{
+	return syscall(__NR_delete_module, name, flags);
+}
+
+static int load_module(const char *mod)
+{
+	int ret, fd;
+
+	fd = open("bpf_testmod.ko", O_RDONLY);
+	if (fd < 0)
+		return fd;
+
+	ret = sys_finit_module(fd, "", 0);
+	close(fd);
+	if (ret < 0)
+		return ret;
+	return 0;
+}
+
+static void *load_module_thread(void *p)
+{
+
+	if (!ASSERT_NEQ(load_module("bpf_testmod.ko"), 0, "load_module_thread must fail"))
+		atomic_store(&state, TS_MODULE_LOAD);
+	else
+		atomic_store(&state, TS_MODULE_LOAD_FAIL);
+	return p;
+}
+
+static int sys_userfaultfd(int flags)
+{
+	return syscall(__NR_userfaultfd, flags);
+}
+
+static int test_setup_uffd(void *fault_addr)
+{
+	struct uffdio_register uffd_register = {};
+	struct uffdio_api uffd_api = {};
+	int uffd;
+
+	uffd = sys_userfaultfd(O_CLOEXEC);
+	if (uffd < 0)
+		return -errno;
+
+	uffd_api.api = UFFD_API;
+	uffd_api.features = 0;
+	if (ioctl(uffd, UFFDIO_API, &uffd_api)) {
+		close(uffd);
+		return -1;
+	}
+
+	uffd_register.range.start = (unsigned long)fault_addr;
+	uffd_register.range.len = 4096;
+	uffd_register.mode = UFFDIO_REGISTER_MODE_MISSING;
+	if (ioctl(uffd, UFFDIO_REGISTER, &uffd_register)) {
+		close(uffd);
+		return -1;
+	}
+	return uffd;
+}
+
+static void test_bpf_mod_race_config(const struct test_config *config)
+{
+	void *fault_addr, *skel_fail;
+	struct bpf_mod_race *skel;
+	struct uffd_msg uffd_msg;
+	pthread_t load_mod_thrd;
+	_Atomic int *blockingp;
+	int uffd, ret;
+
+	fault_addr = mmap(0, 4096, PROT_READ, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	if (!ASSERT_NEQ(fault_addr, MAP_FAILED, "mmap for uffd registration"))
+		return;
+
+	if (!ASSERT_OK(sys_delete_module("bpf_testmod", 0), "unload bpf_testmod"))
+		goto end_mmap;
+
+	skel = bpf_mod_race__open();
+	if (!ASSERT_OK_PTR(skel, "bpf_mod_kfunc_race__open"))
+		goto end_module;
+
+	skel->rodata->bpf_mod_race_config.tgid = getpid();
+	skel->rodata->bpf_mod_race_config.inject_error = -4242;
+	skel->rodata->bpf_mod_race_config.fault_addr = fault_addr;
+	if (!ASSERT_OK(bpf_mod_race__load(skel), "bpf_mod___load"))
+		goto end_destroy;
+	blockingp = (_Atomic int *)&skel->bss->bpf_blocking;
+
+	if (!ASSERT_OK(bpf_mod_race__attach(skel), "bpf_mod_kfunc_race__attach"))
+		goto end_destroy;
+
+	uffd = test_setup_uffd(fault_addr);
+	if (!ASSERT_GE(uffd, 0, "userfaultfd open + register address"))
+		goto end_destroy;
+
+	if (!ASSERT_OK(pthread_create(&load_mod_thrd, NULL, load_module_thread, NULL),
+		       "load module thread"))
+		goto end_uffd;
+
+	/* Now, we either fail loading module, or block in bpf prog, spin to find out */
+	while (!atomic_load(&state) && !atomic_load(blockingp))
+		;
+	if (!ASSERT_EQ(state, _TS_INVALID, "module load should block"))
+		goto end_join;
+	if (!ASSERT_EQ(*blockingp, 1, "module load blocked")) {
+		pthread_kill(load_mod_thrd, SIGKILL);
+		goto end_uffd;
+	}
+
+	/* We might have set bpf_blocking to 1, but may have not blocked in
+	 * bpf_copy_from_user. Read userfaultfd descriptor to verify that.
+	 */
+	if (!ASSERT_EQ(read(uffd, &uffd_msg, sizeof(uffd_msg)), sizeof(uffd_msg),
+		       "read uffd block event"))
+		goto end_join;
+	if (!ASSERT_EQ(uffd_msg.event, UFFD_EVENT_PAGEFAULT, "read uffd event is pagefault"))
+		goto end_join;
+
+	/* We know that load_mod_thrd is blocked in the fmod_ret program, the
+	 * module state is still MODULE_STATE_COMING because mod->init hasn't
+	 * returned. This is the time we try to load a program calling kfunc and
+	 * check if we get ENXIO from verifier.
+	 */
+	skel_fail = config->bpf_open_and_load();
+	ret = errno;
+	if (!ASSERT_EQ(skel_fail, NULL, config->str_open)) {
+		/* Close uffd to unblock load_mod_thrd */
+		close(uffd);
+		uffd = -1;
+		while (atomic_load(blockingp) != 2)
+			;
+		ASSERT_OK(kern_sync_rcu(), "kern_sync_rcu");
+		config->bpf_destroy(skel_fail);
+		goto end_join;
+
+	}
+	ASSERT_EQ(ret, ENXIO, "verifier returns ENXIO");
+	ASSERT_EQ(skel->data->res_try_get_module, false, "btf_try_get_module == false");
+
+	close(uffd);
+	uffd = -1;
+end_join:
+	pthread_join(load_mod_thrd, NULL);
+	if (uffd < 0)
+		ASSERT_EQ(atomic_load(&state), TS_MODULE_LOAD_FAIL, "load_mod_thrd success");
+end_uffd:
+	if (uffd >= 0)
+		close(uffd);
+end_destroy:
+	bpf_mod_race__destroy(skel);
+	ASSERT_OK(kern_sync_rcu(), "kern_sync_rcu");
+end_module:
+	sys_delete_module("bpf_testmod", 0);
+	ASSERT_OK(load_module("bpf_testmod.ko"), "restore bpf_testmod");
+end_mmap:
+	munmap(fault_addr, 4096);
+	atomic_store(&state, _TS_INVALID);
+}
+
+static const struct test_config ksym_config = {
+	.str_open = "ksym_race__open_and_load",
+	.bpf_open_and_load = (void *)ksym_race__open_and_load,
+	.bpf_destroy = (void *)ksym_race__destroy,
+};
+
+static const struct test_config kfunc_config = {
+	.str_open = "kfunc_call_race__open_and_load",
+	.bpf_open_and_load = (void *)kfunc_call_race__open_and_load,
+	.bpf_destroy = (void *)kfunc_call_race__destroy,
+};
+
+void serial_test_bpf_mod_race(void)
+{
+	if (test__start_subtest("ksym (used_btfs UAF)"))
+		test_bpf_mod_race_config(&ksym_config);
+	if (test__start_subtest("kfunc (kfunc_btf_tab UAF)"))
+		test_bpf_mod_race_config(&kfunc_config);
+}
diff --git a/tools/testing/selftests/bpf/progs/bpf_mod_race.c b/tools/testing/selftests/bpf/progs/bpf_mod_race.c
new file mode 100644
index 000000000000..82a5c6c6ba83
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/bpf_mod_race.c
@@ -0,0 +1,100 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <vmlinux.h>
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+const volatile struct {
+	/* thread to activate trace programs for */
+	pid_t tgid;
+	/* return error from __init function */
+	int inject_error;
+	/* uffd monitored range start address */
+	void *fault_addr;
+} bpf_mod_race_config = { -1 };
+
+int bpf_blocking = 0;
+int res_try_get_module = -1;
+
+static __always_inline bool check_thread_id(void)
+{
+	struct task_struct *task = bpf_get_current_task_btf();
+
+	return task->tgid == bpf_mod_race_config.tgid;
+}
+
+/* The trace of execution is something like this:
+ *
+ * finit_module()
+ *   load_module()
+ *     prepare_coming_module()
+ *       notifier_call(MODULE_STATE_COMING)
+ *         btf_parse_module()
+ *         btf_alloc_id()		// Visible to userspace at this point
+ *         list_add(btf_mod->list, &btf_modules)
+ *     do_init_module()
+ *       freeinit = kmalloc()
+ *       ret = mod->init()
+ *         bpf_prog_widen_race()
+ *           bpf_copy_from_user()
+ *             ...<sleep>...
+ *       if (ret < 0)
+ *         ...
+ *         free_module()
+ * return ret
+ *
+ * At this point, module loading thread is blocked, we now load the program:
+ *
+ * bpf_check
+ *   add_kfunc_call/check_pseudo_btf_id
+ *     btf_try_get_module
+ *       try_get_module_live == false
+ *     return -ENXIO
+ *
+ * Without the fix (try_get_module_live in btf_try_get_module):
+ *
+ * bpf_check
+ *   add_kfunc_call/check_pseudo_btf_id
+ *     btf_try_get_module
+ *       try_get_module == true
+ *     <store module reference in btf_kfunc_tab or used_btf array>
+ *   ...
+ * return fd
+ *
+ * Now, if we inject an error in the blocked program, our module will be freed
+ * (going straight from MODULE_STATE_COMING to MODULE_STATE_GOING).
+ * Later, when bpf program is freed, it will try to module_put already freed
+ * module. This is why try_get_module_live returns false if mod->state is not
+ * MODULE_STATE_LIVE.
+ */
+
+SEC("fmod_ret.s/bpf_fentry_test1")
+int BPF_PROG(widen_race, int a, int ret)
+{
+	char dst;
+
+	if (!check_thread_id())
+		return 0;
+	/* Indicate that we will attempt to block */
+	bpf_blocking = 1;
+	bpf_copy_from_user(&dst, 1, bpf_mod_race_config.fault_addr);
+	return bpf_mod_race_config.inject_error;
+}
+
+SEC("fexit/do_init_module")
+int BPF_PROG(fexit_init_module, struct module *mod, int ret)
+{
+	if (!check_thread_id())
+		return 0;
+	/* Indicate that we finished blocking */
+	bpf_blocking = 2;
+	return 0;
+}
+
+SEC("fexit/btf_try_get_module")
+int BPF_PROG(fexit_module_get, const struct btf *btf, struct module *mod)
+{
+	res_try_get_module = !!mod;
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/progs/kfunc_call_race.c b/tools/testing/selftests/bpf/progs/kfunc_call_race.c
new file mode 100644
index 000000000000..4e8fed75a4e0
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/kfunc_call_race.c
@@ -0,0 +1,14 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <vmlinux.h>
+#include <bpf/bpf_helpers.h>
+
+extern void bpf_testmod_test_mod_kfunc(int i) __ksym;
+
+SEC("tc")
+int kfunc_call_fail(struct __sk_buff *ctx)
+{
+	bpf_testmod_test_mod_kfunc(0);
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/progs/ksym_race.c b/tools/testing/selftests/bpf/progs/ksym_race.c
new file mode 100644
index 000000000000..def97f2fed90
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/ksym_race.c
@@ -0,0 +1,13 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <vmlinux.h>
+#include <bpf/bpf_helpers.h>
+
+extern int bpf_testmod_ksym_percpu __ksym;
+
+SEC("tc")
+int ksym_fail(struct __sk_buff *ctx)
+{
+	return *(int *)bpf_this_cpu_ptr(&bpf_testmod_ksym_percpu);
+}
+
+char _license[] SEC("license") = "GPL";
-- 
2.34.1

