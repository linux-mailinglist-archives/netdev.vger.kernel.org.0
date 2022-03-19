Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AC9E4DE865
	for <lists+netdev@lfdr.de>; Sat, 19 Mar 2022 15:31:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243120AbiCSOdJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Mar 2022 10:33:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231131AbiCSOdI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Mar 2022 10:33:08 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBEE743384;
        Sat, 19 Mar 2022 07:31:45 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id h1so13261344edj.1;
        Sat, 19 Mar 2022 07:31:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=y4CzFVqtuLij5VKXYGjzDEEpcQrN2OuW4IgMTkoJKOM=;
        b=m9v2MVf24TU/J9/OIsiIk68A1+P7YeXTmXlOdE78V0zm1SiOGuNUmzPZZytqIoW33N
         RFHCG7UuFEs+jikOiIo9n8tlPfnOR7H4ENNT4i57cOZ8jZyvyLe92PNmHKFp16vEllpI
         iSeeTmJumnApw3hD+ThjKqtDRlZlbH6nfAZ8CHf5LcCCtYygONKu129RHUSjMK0vd6Dp
         p7BWWpFzleobSDjKLubEJwMcJQuYzZHfO5O28ztIndA3U5Ul4gwkGTMm2haxB9QfaPe1
         zZL3s9kvlcr8g/f/lnPwtfKvvxc6A+Uy/R2jbdKp8Zw/FgXAiCBsYkPjfHb5hnmRCoEZ
         7XcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=y4CzFVqtuLij5VKXYGjzDEEpcQrN2OuW4IgMTkoJKOM=;
        b=PklR2iySDrDxqmNvQ70JiYgF1gWMw2CZpMY9VF/rHnn1Ib0bAqMBF3s1782vJcuF0n
         Ekza3XJLZwcTTrJe96AT1G+VDhcYFxId5rMdT1OItJcr0nwd7YJ6SZZu2Bi8meP+4AJT
         BLdAOb8dyrPL4rtzScjIqy+rnSt+enTIx9GJoKqy+Mn6ZGSidRjfhlpTSjKYktEABIGI
         Cd7GhakZK1yaDucQwBEzuyhpwrGpi4ksaO7aIBAvwvIL969lskJHmKPcQuG5JD0F+Yqb
         V95M39QS6MfEoMVDLHoFW7VgGVPK8q1PHSuydxPoQ5Ad9cG0Wus07IT5vELrg1CTty/M
         Kvzg==
X-Gm-Message-State: AOAM532fqCZuKI+duW2aFPFk1CJ5+0nxL57FF6sCyV9xNDxCCekgIz9z
        tJV77KCQOw4rRRWY6E7Prg3tb10ufHnUyg==
X-Google-Smtp-Source: ABdhPJzDmFsfcgcfyfq6oVroPMLuTEVoOpzb3SoT/pM2p7HUrpS0GEHLWOrEa4wmHXHs0pARXKS10g==
X-Received: by 2002:a05:6402:51d2:b0:415:c171:346c with SMTP id r18-20020a05640251d200b00415c171346cmr14477367edd.19.1647700304269;
        Sat, 19 Mar 2022 07:31:44 -0700 (PDT)
Received: from krava ([83.240.61.119])
        by smtp.gmail.com with ESMTPSA id w12-20020a17090649cc00b006d0bee77b9asm4846644ejv.72.2022.03.19.07.31.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Mar 2022 07:31:43 -0700 (PDT)
Date:   Sat, 19 Mar 2022 15:31:41 +0100
From:   Jiri Olsa <olsajiri@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCHv3 bpf-next 00/13] bpf: Add kprobe multi link
Message-ID: <YjXpTZUI10RVCGPD@krava>
References: <20220316122419.933957-1-jolsa@kernel.org>
 <CAEf4BzbpjN6ca7D9KOTiFPOoBYkciYvTz0UJNp5c-_3ptm=Mrg@mail.gmail.com>
 <YjXMSg+BSSOv0xd1@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YjXMSg+BSSOv0xd1@krava>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 19, 2022 at 01:27:56PM +0100, Jiri Olsa wrote:
> On Fri, Mar 18, 2022 at 10:50:46PM -0700, Andrii Nakryiko wrote:
> > On Wed, Mar 16, 2022 at 5:24 AM Jiri Olsa <jolsa@kernel.org> wrote:
> > >
> > > hi,
> > > this patchset adds new link type BPF_TRACE_KPROBE_MULTI that attaches
> > > kprobe program through fprobe API [1] instroduced by Masami.
> > >
> > > The fprobe API allows to attach probe on multiple functions at once very
> > > fast, because it works on top of ftrace. On the other hand this limits
> > > the probe point to the function entry or return.
> > >
> > >
> > > With bpftrace support I see following attach speed:
> > >
> > >   # perf stat --null -r 5 ./src/bpftrace -e 'kprobe:x* { } i:ms:1 { exit(); } '
> > >   Attaching 2 probes...
> > >   Attaching 3342 functions
> > >   ...
> > >
> > >   1.4960 +- 0.0285 seconds time elapsed  ( +-  1.91% )
> > >
> > > v3 changes:
> > >   - based on latest fprobe post from Masami [2]
> > >   - add acks
> > >   - add extra comment to kprobe_multi_link_handler wrt entry ip setup [Masami]
> > >   - keep swap_words_64 static and swap values directly in
> > >     bpf_kprobe_multi_cookie_swap [Andrii]
> > >   - rearrange locking/migrate setup in kprobe_multi_link_prog_run [Andrii]
> > >   - move uapi fields [Andrii]
> > >   - add bpf_program__attach_kprobe_multi_opts function [Andrii]
> > >   - many small test changes [Andrii]
> > >   - added tests for bpf_program__attach_kprobe_multi_opts
> > >   - make kallsyms_lookup_name check for empty string [Andrii]
> > >
> > > v2 changes:
> > >   - based on latest fprobe changes [1]
> > >   - renaming the uapi interface to kprobe multi
> > >   - adding support for sort_r to pass user pointer for swap functions
> > >     and using that in cookie support to keep just single functions array
> > >   - moving new link to kernel/trace/bpf_trace.c file
> > >   - using single fprobe callback function for entry and exit
> > >   - using kvzalloc, libbpf_ensure_mem functions
> > >   - adding new k[ret]probe.multi sections instead of using current kprobe
> > >   - used glob_match from test_progs.c, added '?' matching
> > >   - move bpf_get_func_ip verifier inline change to seprate change
> > >   - couple of other minor fixes
> > >
> > >
> > > Also available at:
> > >   https://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git
> > >   bpf/kprobe_multi
> > >
> > > thanks,
> > > jirka
> > >
> > >
> > > [1] https://lore.kernel.org/bpf/164458044634.586276.3261555265565111183.stgit@devnote2/
> > > [2] https://lore.kernel.org/bpf/164735281449.1084943.12438881786173547153.stgit@devnote2/
> > > ---
> > > Jiri Olsa (13):
> > >       lib/sort: Add priv pointer to swap function
> > >       kallsyms: Skip the name search for empty string
> > >       bpf: Add multi kprobe link
> > >       bpf: Add bpf_get_func_ip kprobe helper for multi kprobe link
> > >       bpf: Add support to inline bpf_get_func_ip helper on x86
> > >       bpf: Add cookie support to programs attached with kprobe multi link
> > >       libbpf: Add libbpf_kallsyms_parse function
> > >       libbpf: Add bpf_link_create support for multi kprobes
> > >       libbpf: Add bpf_program__attach_kprobe_multi_opts function
> > >       selftests/bpf: Add kprobe_multi attach test
> > >       selftests/bpf: Add kprobe_multi bpf_cookie test
> > >       selftests/bpf: Add attach test for bpf_program__attach_kprobe_multi_opts
> > >       selftests/bpf: Add cookie test for bpf_program__attach_kprobe_multi_opts
> > >
> > 
> > Ok, so I've integrated multi-attach kprobes into retsnoop. It was
> > pretty straightforward. Here are some numbers for the speed of
> > attaching and, even more importantly, detaching for a set of almost
> > 400 functions. It's a bit less functions for fentry-based mode due to
> > more limited BTF information for static functions. Note that retsnoop
> > attaches two BPF programs for each kernel function, so it's actually
> > two multi-attach kprobes, each attaching to 397 functions. For
> > single-attach kprobe, we perform 397 * 2 = 794 attachments.
> > 
> > I've been invoking retsnoop with the following specified set of
> > functions: -e '*sys_bpf*' -a ':kernel/bpf/syscall.c' -a
> > ':kernel/bpf/verifier.c' -a ':kernel/bpf/btf.c' -a
> > ':kernel/bpf/core.c'. So basically bpf syscall entry functions and all
> > the discoverable functions from syscall.c, verifier.c, core.c and
> > btf.c from kernel/bpf subdirectory.
> > 
> > Results:
> > 
> > fentry attach/detach (263 kfuncs): 2133 ms / 31671  ms (33 seconds)
> > kprobe attach/detach (397 kfuncs): 3121 ms / 13195 ms (16 seconds)
> > multi-kprobe attach/detach (397 kfuncs): 9 ms / 248 ms (0.25 seconds)
> > 
> > So as you can see, the speed up is tremendous! API is also very
> > convenient, I didn't have to modify retsnoop internals much to
> > accommodate multi-attach API. Great job!
> 
> nice! thanks for doing that so quickly
> 
> > 
> > Now for the bad news. :(
> > 
> > Stack traces from multi-attach kretprobe are broken, which makes all
> > this way less useful.
> > 
> > Below, see stack traces captured with multi- and single- kretprobes
> > for two different use cases. Single kprobe stack traces make much more
> > sense. Ignore that last function doesn't have actual address
> > associated with it (i.e. for __sys_bpf and bpf_tracing_prog_attach,
> > respectively). That's just how retsnoop is doing things, I think. We
> > actually were capturing stack traces from inside __sys_bpf (first
> > case) and bpf_tracing_prog_attach (second case).
> > 
> > MULTI KPROBE:
> > ffffffff81185a80 __sys_bpf+0x0
> > (kernel/bpf/syscall.c:4622:1)
> > 
> > SINGLE KPROBE:
> > ffffffff81e0007c entry_SYSCALL_64_after_hwframe+0x44
> > (arch/x86/entry/entry_64.S:113:0)
> > ffffffff81cd2b15 do_syscall_64+0x35
> > (arch/x86/entry/common.c:80:7)
> >                  . do_syscall_x64
> > (arch/x86/entry/common.c:50:12)
> > ffffffff811881aa __x64_sys_bpf+0x1a
> > (kernel/bpf/syscall.c:4765:1)
> >                  __sys_bpf
> > 
> > 
> > MULTI KPROBE:
> > ffffffff811851b0 bpf_tracing_prog_attach+0x0
> > (kernel/bpf/syscall.c:2708:1)
> > 
> > SINGLE KPROBE:
> > ffffffff81e0007c entry_SYSCALL_64_after_hwframe+0x44
> > (arch/x86/entry/entry_64.S:113:0)
> > ffffffff81cd2b15 do_syscall_64+0x35
> > (arch/x86/entry/common.c:80:7)
> >                  . do_syscall_x64
> > (arch/x86/entry/common.c:50:12)
> > ffffffff811881aa __x64_sys_bpf+0x1a
> > (kernel/bpf/syscall.c:4765:1)
> > ffffffff81185e79 __sys_bpf+0x3f9
> > (kernel/bpf/syscall.c:4705:9)
> > ffffffff8118583a bpf_raw_tracepoint_open+0x19a
> > (kernel/bpf/syscall.c:3069:6)
> >                  bpf_tracing_prog_attach
> > 
> > You can see that in multi-attach kprobe we only get one entry, which
> > is the very last function in the stack trace. We have no parent
> > function captured whatsoever. Jiri, Masami, any ideas what's wrong and
> > how to fix this? Let's try to figure this out and fix it before the
> > feature makes it into the kernel release. Thanks in advance!
> 
> oops, I should have tried kstack with the bpftrace's kretprobe, I see the same:
> 
> 	# ./src/bpftrace -e 'kretprobe:x* { @[kstack] = count(); }'
> 	Attaching 1 probe...
> 	Attaching 3340probes
> 	^C
> 
> 	@[
> 	    xfs_trans_apply_dquot_deltas+0
> 	]: 22
> 	@[
> 	    xlog_cil_commit+0
> 	]: 22
> 	@[
> 	    xlog_grant_push_threshold+0
> 	]: 22
> 	@[
> 	    xfs_trans_add_item+0
> 	]: 22
> 	@[
> 	    xfs_log_reserve+0
> 	]: 22
> 	@[
> 	    xlog_space_left+0
> 	]: 22
> 	@[
> 	    xfs_buf_offset+0
> 	]: 22
> 	@[
> 	    xfs_trans_free_dqinfo+0
> 	]: 22
> 	@[
> 	    xlog_ticket_alloc+0
> 	    xfs_log_reserve+5
> 	]: 22
> 	@[
> 	    xfs_cil_prepare_item+0
> 
> 
> I think it's because we set original ip for return probe to have
> bpf_get_func_ip working properly, but it breaks backtrace of course 
> 
> I'm not sure we could bring along the original regs for return probe,
> but I have an idea how to workaround the bpf_get_func_ip issue and
> keep the registers intact for other helpers

change below is using bpf_run_ctx to store link and entry ip on stack,
where helpers can find it.. it fixed the retprobe backtrace for me

I had to revert the get_func_ip inline.. it's squashed in the change
below for quick testing.. I'll send revert in separate patch with the
formal change

could you please test?

thanks,
jirka


---
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 0287176bfe9a..cf92f9c01556 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -13678,7 +13678,7 @@ static int do_misc_fixups(struct bpf_verifier_env *env)
 			continue;
 		}
 
-		/* Implement tracing bpf_get_func_ip inline. */
+		/* Implement bpf_get_func_ip inline. */
 		if (prog_type == BPF_PROG_TYPE_TRACING &&
 		    insn->imm == BPF_FUNC_get_func_ip) {
 			/* Load IP address from ctx - 16 */
@@ -13693,25 +13693,6 @@ static int do_misc_fixups(struct bpf_verifier_env *env)
 			continue;
 		}
 
-#ifdef CONFIG_X86
-		/* Implement kprobe_multi bpf_get_func_ip inline. */
-		if (prog_type == BPF_PROG_TYPE_KPROBE &&
-		    eatype == BPF_TRACE_KPROBE_MULTI &&
-		    insn->imm == BPF_FUNC_get_func_ip) {
-			/* Load IP address from ctx (struct pt_regs) ip */
-			insn_buf[0] = BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_1,
-						  offsetof(struct pt_regs, ip));
-
-			new_prog = bpf_patch_insn_data(env, i + delta, insn_buf, 1);
-			if (!new_prog)
-				return -ENOMEM;
-
-			env->prog = prog = new_prog;
-			insn      = new_prog->insnsi + i + delta;
-			continue;
-		}
-#endif
-
 patch_call_imm:
 		fn = env->ops->get_func_proto(insn->imm, env->prog);
 		/* all functions that have prototype and verifier allowed
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 9a7b6be655e4..aefe33c08296 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -80,7 +80,8 @@ u64 bpf_get_stack(u64 r1, u64 r2, u64 r3, u64 r4, u64 r5);
 static int bpf_btf_printf_prepare(struct btf_ptr *ptr, u32 btf_ptr_size,
 				  u64 flags, const struct btf **btf,
 				  s32 *btf_id);
-static u64 bpf_kprobe_multi_cookie(struct bpf_run_ctx *ctx, u64 ip);
+static u64 bpf_kprobe_multi_cookie(struct bpf_run_ctx *ctx);
+static u64 bpf_kprobe_multi_entry_ip(struct bpf_run_ctx *ctx);
 
 /**
  * trace_call_bpf - invoke BPF program
@@ -1042,8 +1043,7 @@ static const struct bpf_func_proto bpf_get_func_ip_proto_kprobe = {
 
 BPF_CALL_1(bpf_get_func_ip_kprobe_multi, struct pt_regs *, regs)
 {
-	/* This helper call is inlined by verifier on x86. */
-	return instruction_pointer(regs);
+	return bpf_kprobe_multi_entry_ip(current->bpf_ctx);
 }
 
 static const struct bpf_func_proto bpf_get_func_ip_proto_kprobe_multi = {
@@ -1055,7 +1055,7 @@ static const struct bpf_func_proto bpf_get_func_ip_proto_kprobe_multi = {
 
 BPF_CALL_1(bpf_get_attach_cookie_kprobe_multi, struct pt_regs *, regs)
 {
-	return bpf_kprobe_multi_cookie(current->bpf_ctx, instruction_pointer(regs));
+	return bpf_kprobe_multi_cookie(current->bpf_ctx);
 }
 
 static const struct bpf_func_proto bpf_get_attach_cookie_proto_kmulti = {
@@ -2220,15 +2220,16 @@ struct bpf_kprobe_multi_link {
 	struct bpf_link link;
 	struct fprobe fp;
 	unsigned long *addrs;
-	/*
-	 * The run_ctx here is used to get struct bpf_kprobe_multi_link in
-	 * get_attach_cookie helper, so it can't be used to store data.
-	 */
-	struct bpf_run_ctx run_ctx;
 	u64 *cookies;
 	u32 cnt;
 };
 
+struct bpf_kprobe_multi_run_ctx {
+	struct bpf_run_ctx run_ctx;
+	struct bpf_kprobe_multi_link *link;
+	unsigned long entry_ip;
+};
+
 static void bpf_kprobe_multi_link_release(struct bpf_link *link)
 {
 	struct bpf_kprobe_multi_link *kmulti_link;
@@ -2282,18 +2283,21 @@ static int bpf_kprobe_multi_cookie_cmp(const void *a, const void *b, const void
 	return __bpf_kprobe_multi_cookie_cmp(a, b);
 }
 
-static u64 bpf_kprobe_multi_cookie(struct bpf_run_ctx *ctx, u64 ip)
+static u64 bpf_kprobe_multi_cookie(struct bpf_run_ctx *ctx)
 {
+	struct bpf_kprobe_multi_run_ctx *run_ctx;
 	struct bpf_kprobe_multi_link *link;
+	u64 *cookie, entry_ip;
 	unsigned long *addr;
-	u64 *cookie;
 
 	if (WARN_ON_ONCE(!ctx))
 		return 0;
-	link = container_of(ctx, struct bpf_kprobe_multi_link, run_ctx);
+	run_ctx = container_of(current->bpf_ctx, struct bpf_kprobe_multi_run_ctx, run_ctx);
+	link = run_ctx->link;
+	entry_ip = run_ctx->entry_ip;
 	if (!link->cookies)
 		return 0;
-	addr = bsearch(&ip, link->addrs, link->cnt, sizeof(ip),
+	addr = bsearch(&entry_ip, link->addrs, link->cnt, sizeof(entry_ip),
 		       __bpf_kprobe_multi_cookie_cmp);
 	if (!addr)
 		return 0;
@@ -2301,10 +2305,22 @@ static u64 bpf_kprobe_multi_cookie(struct bpf_run_ctx *ctx, u64 ip)
 	return *cookie;
 }
 
+static u64 bpf_kprobe_multi_entry_ip(struct bpf_run_ctx *ctx)
+{
+	struct bpf_kprobe_multi_run_ctx *run_ctx;
+
+	run_ctx = container_of(current->bpf_ctx, struct bpf_kprobe_multi_run_ctx, run_ctx);
+	return run_ctx->entry_ip;
+}
+
 static int
 kprobe_multi_link_prog_run(struct bpf_kprobe_multi_link *link,
-			   struct pt_regs *regs)
+			   unsigned long entry_ip, struct pt_regs *regs)
 {
+	struct bpf_kprobe_multi_run_ctx run_ctx = {
+		.link = link,
+		.entry_ip = entry_ip,
+	};
 	struct bpf_run_ctx *old_run_ctx;
 	int err;
 
@@ -2315,7 +2331,7 @@ kprobe_multi_link_prog_run(struct bpf_kprobe_multi_link *link,
 
 	migrate_disable();
 	rcu_read_lock();
-	old_run_ctx = bpf_set_run_ctx(&link->run_ctx);
+	old_run_ctx = bpf_set_run_ctx(&run_ctx.run_ctx);
 	err = bpf_prog_run(link->link.prog, regs);
 	bpf_reset_run_ctx(old_run_ctx);
 	rcu_read_unlock();
@@ -2330,24 +2346,10 @@ static void
 kprobe_multi_link_handler(struct fprobe *fp, unsigned long entry_ip,
 			  struct pt_regs *regs)
 {
-	unsigned long saved_ip = instruction_pointer(regs);
 	struct bpf_kprobe_multi_link *link;
 
-	/*
-	 * Because fprobe's regs->ip is set to the next instruction of
-	 * dynamic-ftrace instruction, correct entry ip must be set, so
-	 * that the bpf program can access entry address via regs as same
-	 * as kprobes.
-	 *
-	 * Both kprobe and kretprobe see the entry ip of traced function
-	 * as instruction pointer.
-	 */
-	instruction_pointer_set(regs, entry_ip);
-
 	link = container_of(fp, struct bpf_kprobe_multi_link, fp);
-	kprobe_multi_link_prog_run(link, regs);
-
-	instruction_pointer_set(regs, saved_ip);
+	kprobe_multi_link_prog_run(link, entry_ip, regs);
 }
 
 static int
@@ -2514,7 +2516,11 @@ int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
 {
 	return -EOPNOTSUPP;
 }
-static u64 bpf_kprobe_multi_cookie(struct bpf_run_ctx *ctx, u64 ip)
+static u64 bpf_kprobe_multi_cookie(struct bpf_run_ctx *ctx)
+{
+	return 0;
+}
+static u64 bpf_kprobe_multi_entry_ip(struct bpf_run_ctx *ctx)
 {
 	return 0;
 }
