Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5673652776
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 20:59:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234102AbiLTT5W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 14:57:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234174AbiLTT44 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 14:56:56 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CE2A1D65A
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 11:56:39 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id me18-20020a17090b17d200b00219f8dc7cb3so11174958pjb.4
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 11:56:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=aMRXZoGC/4/oRvcdMHxsgbhovGkPts5hEi/VbfAQMVs=;
        b=G5+vnLcyKcVHmR9s4iGC9k+ieSlhy7rj3NOo73kHYa0XVJyO7OYiBrvwYMgcb+r0J+
         S1D3duc3AqsaTJ2W+HWoSvtFhQnzxBxPIiDDc+RA7r8oclc+/t57KGPe7LPI7HY33gfQ
         ds+vxmFeuKCRxsTjPkK4eBqaQCb8maEkHx2iIs1/EczViD01CmdAs9CIK7oHoIcnejen
         xgU1cCVsOwKVzr7F4iUsRfquzdsJykU6Js0le3TG6t4Mv4FD0O4tN8M/h6YN2Hn5It7Q
         nid+uNHAZdkR+kcSfhFJ8Q/8J3J3g8p7QaRc5g04j8+h9FXMlIEJfAcP+Iel+WDVlM5x
         S8sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aMRXZoGC/4/oRvcdMHxsgbhovGkPts5hEi/VbfAQMVs=;
        b=3ZhrLQvGRMN9i1z/YmHIEGT2nA3zUEnSLstsOKSXzrxvx1aYzpwj23urLZIWQM0Gbl
         abFw2RHbrLs44hes0uwLx0Pv2lY5VeANIbyzNkJayeTmpXQ2OrFFYNeErlhAril3gOXv
         85Raoqc7AvuFStvojMotyCk9nq4Ijgxe5ktYtwiWu83pDsGMEOnSDM+jTTaWS7xQQjin
         3fP6T/45X554VLUxqXWL+GujuZ4wmLaXwQlgg7KhBkarafNYqdavYVB+U9ClPStzCrKa
         C78azSnjhAMFL8t9KnzImCwhbZiKz+BD2wTf1pot4aqU2nZ9PbaibxNCKpmBScdB3PWs
         gXsA==
X-Gm-Message-State: AFqh2kqK49qd1X1330TAjuCidPaik9USA6ozG2YTUlR9HpyRwht7bm/5
        81zvSY6O58kebZT+s4o3Bt6kpHo=
X-Google-Smtp-Source: AMrXdXvJX18vNT1w8RBxoVbOqfxBqQt/oI/j99+7B9IqW5UMMlEEs1PiejBiQUBeztuir0zsDY/Dvmk=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a17:90a:e17:b0:219:b79d:c308 with SMTP id
 v23-20020a17090a0e1700b00219b79dc308mr3147330pje.69.1671566198800; Tue, 20
 Dec 2022 11:56:38 -0800 (PST)
Date:   Tue, 20 Dec 2022 11:56:37 -0800
In-Reply-To: <000000000000ab724705ee87e321@google.com>
Mime-Version: 1.0
References: <000000000000ab724705ee87e321@google.com>
Message-ID: <Y6ITdVe2DPTioPvc@google.com>
Subject: Re: [syzbot] KASAN: slab-out-of-bounds Write in copy_array
From:   sdf@google.com
To:     syzbot <syzbot+b1e1f7feb407b56d0355@syzkaller.appspotmail.com>
Cc:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, haoluo@google.com,
        hawk@kernel.org, john.fastabend@gmail.com, jolsa@kernel.org,
        kpsingh@kernel.org, kuba@kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, martin.lau@linux.dev, nathan@kernel.org,
        ndesaulniers@google.com, netdev@vger.kernel.org, song@kernel.org,
        syzkaller-bugs@googlegroups.com, trix@redhat.com, yhs@fb.com
Content-Type: multipart/mixed; charset="UTF-8"; boundary="dL3nf9A7ziUAVJ+f"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--dL3nf9A7ziUAVJ+f
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 11/28, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    c35bd4e42885 Add linux-next specific files for 20221124
> git tree:       linux-next
> console+strace: https://syzkaller.appspot.com/x/log.txt?x=13369dc5880000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=11e19c740a0b2926
> dashboard link: https://syzkaller.appspot.com/bug?extid=b1e1f7feb407b56d0355
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1345a205880000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=124c644b880000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/968fee464d14/disk-c35bd4e4.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/4f46fe801b5b/vmlinux-c35bd4e4.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/c2cdf8fb264e/bzImage-c35bd4e4.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+b1e1f7feb407b56d0355@syzkaller.appspotmail.com
> 
> ==================================================================
> BUG: KASAN: slab-out-of-bounds in copy_array+0x96/0x100 kernel/bpf/verifier.c:1032
> Write of size 232 at addr ffff88801ed62600 by task syz-executor990/5290
> 
> CPU: 0 PID: 5290 Comm: syz-executor990 Not tainted 6.1.0-rc6-next-20221124-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
> Call Trace:
>  <TASK>
>  __dump_stack lib/dump_stack.c:88 [inline]
>  dump_stack_lvl+0xd1/0x138 lib/dump_stack.c:106
>  print_address_description mm/kasan/report.c:253 [inline]
>  print_report+0x15e/0x45d mm/kasan/report.c:364
>  kasan_report+0xbf/0x1f0 mm/kasan/report.c:464
>  check_region_inline mm/kasan/generic.c:183 [inline]
>  kasan_check_range+0x141/0x190 mm/kasan/generic.c:189
>  memcpy+0x3d/0x60 mm/kasan/shadow.c:66
>  copy_array+0x96/0x100 kernel/bpf/verifier.c:1032
>  copy_verifier_state+0xa9/0xbe0 kernel/bpf/verifier.c:1210
>  pop_stack+0x8c/0x2f0 kernel/bpf/verifier.c:1273
>  do_check kernel/bpf/verifier.c:13733 [inline]
>  do_check_common+0x372b/0xc5e0 kernel/bpf/verifier.c:15991
>  do_check_main kernel/bpf/verifier.c:16054 [inline]
>  bpf_check+0x7371/0xad00 kernel/bpf/verifier.c:16624
>  bpf_prog_load+0x1543/0x2230 kernel/bpf/syscall.c:2619
>  __sys_bpf+0x1436/0x4ff0 kernel/bpf/syscall.c:4979
>  __do_sys_bpf kernel/bpf/syscall.c:5083 [inline]
>  __se_sys_bpf kernel/bpf/syscall.c:5081 [inline]
>  __x64_sys_bpf+0x79/0xc0 kernel/bpf/syscall.c:5081
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> RIP: 0033:0x7fc18e7bbc29
> Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffd8f27a968 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
> RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fc18e7bbc29
> RDX: 0000000000000048 RSI: 0000000020000200 RDI: 0000000000000005
> RBP: 00007fc18e77fdd0 R08: 0000000000000000 R09: 0000000000000000
> R10: 00000000ffffffff R11: 0000000000000246 R12: 00007fc18e77fe60
> R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
>  </TASK>
> 
> Allocated by task 5290:
>  kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
>  kasan_set_track+0x25/0x30 mm/kasan/common.c:52
>  ____kasan_kmalloc mm/kasan/common.c:376 [inline]
>  ____kasan_kmalloc mm/kasan/common.c:335 [inline]
>  __kasan_krealloc+0x145/0x180 mm/kasan/common.c:444
>  kasan_krealloc include/linux/kasan.h:232 [inline]
>  __do_krealloc mm/slab_common.c:1348 [inline]
>  krealloc+0xa8/0x100 mm/slab_common.c:1385
>  push_jmp_history+0x89/0x260 kernel/bpf/verifier.c:2528
>  is_state_visited kernel/bpf/verifier.c:13269 [inline]
>  do_check kernel/bpf/verifier.c:13466 [inline]
>  do_check_common+0x4b47/0xc5e0 kernel/bpf/verifier.c:15991
>  do_check_main kernel/bpf/verifier.c:16054 [inline]
>  bpf_check+0x7371/0xad00 kernel/bpf/verifier.c:16624
>  bpf_prog_load+0x1543/0x2230 kernel/bpf/syscall.c:2619
>  __sys_bpf+0x1436/0x4ff0 kernel/bpf/syscall.c:4979
>  __do_sys_bpf kernel/bpf/syscall.c:5083 [inline]
>  __se_sys_bpf kernel/bpf/syscall.c:5081 [inline]
>  __x64_sys_bpf+0x79/0xc0 kernel/bpf/syscall.c:5081
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> 
> The buggy address belongs to the object at ffff88801ed62600
>  which belongs to the cache kmalloc-256 of size 256
> The buggy address is located 0 bytes inside of
>  256-byte region [ffff88801ed62600, ffff88801ed62700)
> 
> The buggy address belongs to the physical page:
> page:ffffea00007b5880 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x1ed62
> head:ffffea00007b5880 order:1 compound_mapcount:0 subpages_mapcount:0 compound_pincount:0
> flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
> raw: 00fff00000010200 ffff888012441b40 ffffea0000809f80 dead000000000002
> raw: 0000000000000000 0000000080100010 00000001ffffffff 0000000000000000
> page dumped because: kasan: bad access detected
> page_owner tracks the page as allocated
> page last allocated via order 1, migratetype Unmovable, gfp_mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 56, tgid 56 (kworker/u4:4), ts 7761288109, free_ts 0
>  prep_new_page mm/page_alloc.c:2541 [inline]
>  get_page_from_freelist+0x119c/0x2cd0 mm/page_alloc.c:4293
>  __alloc_pages+0x1cb/0x5b0 mm/page_alloc.c:5551
>  alloc_pages+0x1aa/0x270 mm/mempolicy.c:2285
>  alloc_slab_page mm/slub.c:1833 [inline]
>  allocate_slab+0x25e/0x350 mm/slub.c:1980
>  new_slab mm/slub.c:2033 [inline]
>  ___slab_alloc+0xa91/0x1400 mm/slub.c:3211
>  __slab_alloc.constprop.0+0x56/0xa0 mm/slub.c:3310
>  slab_alloc_node mm/slub.c:3395 [inline]
>  __kmem_cache_alloc_node+0x1a9/0x430 mm/slub.c:3472
>  kmalloc_trace+0x26/0x60 mm/slab_common.c:1049
>  kmalloc include/linux/slab.h:571 [inline]
>  scsi_probe_and_add_lun+0x3ae/0x34d0 drivers/scsi/scsi_scan.c:1186
>  __scsi_scan_target+0x21f/0xda0 drivers/scsi/scsi_scan.c:1664
>  scsi_scan_channel drivers/scsi/scsi_scan.c:1752 [inline]
>  scsi_scan_channel+0x148/0x1e0 drivers/scsi/scsi_scan.c:1728
>  scsi_scan_host_selected+0x2e3/0x3b0 drivers/scsi/scsi_scan.c:1781
>  do_scsi_scan_host+0x1e8/0x260 drivers/scsi/scsi_scan.c:1920
>  do_scan_async+0x42/0x500 drivers/scsi/scsi_scan.c:1930
>  async_run_entry_fn+0x9c/0x530 kernel/async.c:127
>  process_one_work+0x9bf/0x1710 kernel/workqueue.c:2289
> page_owner free stack trace missing
> 
> Memory state around the buggy address:
>  ffff88801ed62500: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>  ffff88801ed62580: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> >ffff88801ed62600: 00 00 00 00 fc fc fc fc fc fc fc fc fc fc fc fc
>                                ^
>  ffff88801ed62680: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>  ffff88801ed62700: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> ==================================================================
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> syzbot can test patches for this issue, for details see:
> https://goo.gl/tpsmEJ#testing-patches

#syz test: git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git c35bd4e42885

--dL3nf9A7ziUAVJ+f
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="syz.patch"

commit 589aa8077dcf413b06c78c6d8095496c98720c25
Author:     Stanislav Fomichev <sdf@google.com>
AuthorDate: Tue Dec 20 11:51:17 2022 -0800
Commit:     Stanislav Fomichev <sdf@google.com>
CommitDate: Tue Dec 20 11:51:17 2022 -0800

    Revert "mm: Make ksize() a reporting-only function"
    
    This reverts commit 38931d8989b5760b0bd17c9ec99e81986258e4cb.

diff --git a/mm/kasan/kasan_test.c b/mm/kasan/kasan_test.c
index 73684642c42d..0d59098f0876 100644
--- a/mm/kasan/kasan_test.c
+++ b/mm/kasan/kasan_test.c
@@ -783,30 +783,23 @@ static void kasan_global_oob_left(struct kunit *test)
 	KUNIT_EXPECT_KASAN_FAIL(test, *(volatile char *)p);
 }
 
-/* Check that ksize() does NOT unpoison whole object. */
+/* Check that ksize() makes the whole object accessible. */
 static void ksize_unpoisons_memory(struct kunit *test)
 {
 	char *ptr;
-	size_t size = 128 - KASAN_GRANULE_SIZE - 5;
-	size_t real_size;
+	size_t size = 123, real_size;
 
 	ptr = kmalloc(size, GFP_KERNEL);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
-
 	real_size = ksize(ptr);
-	KUNIT_EXPECT_GT(test, real_size, size);
 
 	OPTIMIZER_HIDE_VAR(ptr);
 
-	/* These accesses shouldn't trigger a KASAN report. */
-	ptr[0] = 'x';
-	ptr[size - 1] = 'x';
+	/* This access shouldn't trigger a KASAN report. */
+	ptr[size] = 'x';
 
-	/* These must trigger a KASAN report. */
-	if (IS_ENABLED(CONFIG_KASAN_GENERIC))
-		KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr)[size]);
-	KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr)[size + 5]);
-	KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr)[real_size - 1]);
+	/* This one must. */
+	KUNIT_EXPECT_KASAN_FAIL(test, ((volatile char *)ptr)[real_size]);
 
 	kfree(ptr);
 }
diff --git a/mm/slab_common.c b/mm/slab_common.c
index 7e96abf1bd7d..33b1886b06eb 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -1333,11 +1333,11 @@ __do_krealloc(const void *p, size_t new_size, gfp_t flags)
 	void *ret;
 	size_t ks;
 
-	/* Check for double-free before calling ksize. */
+	/* Don't use instrumented ksize to allow precise KASAN poisoning. */
 	if (likely(!ZERO_OR_NULL_PTR(p))) {
 		if (!kasan_check_byte(p))
 			return NULL;
-		ks = ksize(p);
+		ks = kfence_ksize(p) ?: __ksize(p);
 	} else
 		ks = 0;
 
@@ -1405,10 +1405,8 @@ void kfree_sensitive(const void *p)
 	void *mem = (void *)p;
 
 	ks = ksize(mem);
-	if (ks) {
-		kasan_unpoison_range(mem, ks);
+	if (ks)
 		memzero_explicit(mem, ks);
-	}
 	kfree(mem);
 }
 EXPORT_SYMBOL(kfree_sensitive);
@@ -1429,11 +1427,13 @@ EXPORT_SYMBOL(kfree_sensitive);
  */
 size_t ksize(const void *objp)
 {
+	size_t size;
+
 	/*
-	 * We need to first check that the pointer to the object is valid.
-	 * The KASAN report printed from ksize() is more useful, then when
-	 * it's printed later when the behaviour could be undefined due to
-	 * a potential use-after-free or double-free.
+	 * We need to first check that the pointer to the object is valid, and
+	 * only then unpoison the memory. The report printed from ksize() is
+	 * more useful, then when it's printed later when the behaviour could
+	 * be undefined due to a potential use-after-free or double-free.
 	 *
 	 * We use kasan_check_byte(), which is supported for the hardware
 	 * tag-based KASAN mode, unlike kasan_check_read/write().
@@ -1447,7 +1447,13 @@ size_t ksize(const void *objp)
 	if (unlikely(ZERO_OR_NULL_PTR(objp)) || !kasan_check_byte(objp))
 		return 0;
 
-	return kfence_ksize(objp) ?: __ksize(objp);
+	size = kfence_ksize(objp) ?: __ksize(objp);
+	/*
+	 * We assume that ksize callers could use whole allocated area,
+	 * so we need to unpoison this area.
+	 */
+	kasan_unpoison_range(objp, size);
+	return size;
 }
 EXPORT_SYMBOL(ksize);
 

--dL3nf9A7ziUAVJ+f--
