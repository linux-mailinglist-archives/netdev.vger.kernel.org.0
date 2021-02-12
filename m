Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 704DE31A2FC
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 17:43:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231184AbhBLQmJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 11:42:09 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44819 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229989AbhBLQkp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 11:40:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613147949;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=U4WyzaFVGJo5ke7IZuHExhC34PtdB0ost6FmcFZqD6o=;
        b=Skv5Kyv6Id+hQVC7nzJwjrIqxXff4YZUghT0heTnTYZZ7wSHZ1d3et6n1i6hm28MeiJy3E
        4wA0fkXHtj210XFxGdD96ogUwEEQV/KvrCt8KuFGEt0oO251pxSxWy5EhJ9LrYEITd2OTH
        5naHAltvCEx50519HL3JC1MQ0XpPpCE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-20-c3Hmb8OLMNuFqTJzA6W-PQ-1; Fri, 12 Feb 2021 11:39:04 -0500
X-MC-Unique: c3Hmb8OLMNuFqTJzA6W-PQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 74D39AFA81;
        Fri, 12 Feb 2021 16:39:02 +0000 (UTC)
Received: from krava (unknown [10.40.193.141])
        by smtp.corp.redhat.com (Postfix) with SMTP id 2D2D819D6C;
        Fri, 12 Feb 2021 16:38:59 +0000 (UTC)
Date:   Fri, 12 Feb 2021 17:38:58 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Nathan Chancellor <nathan@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Veronika Kabatova <vkabatov@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>
Subject: Re: FAILED unresolved symbol vfs_truncate on arm64 with LLVM
Message-ID: <YCavItKm0mKxcVQD@krava>
References: <YCKB1TF5wz93EIBK@krava>
 <YCKlrLkTQXc4Cyx7@krava>
 <CAEf4BzaL=qsSyDc8OxeN4pr7+Lvv+de4f+hM5a56LY8EABAk3w@mail.gmail.com>
 <YCMEucGZVPPQuxWw@krava>
 <CAEf4BzacQrkSMnmeO3sunOs7sfhX1ZoD_Hnk4-cFUK-TpLNqUA@mail.gmail.com>
 <YCPfEzp3ogCBTBaS@krava>
 <CAEf4BzbzquqsA5=_UqDukScuoGLfDhZiiXs_sgYBuNUvTBuV6w@mail.gmail.com>
 <YCQ+d0CVgIclDwng@krava>
 <YCVIWzq0quDQm6bn@krava>
 <CAEf4Bzbt2-Mn4+y0c+sSZWUSrP705c_e3SxedjV_xYGPQL79=w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4Bzbt2-Mn4+y0c+sSZWUSrP705c_e3SxedjV_xYGPQL79=w@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 11, 2021 at 11:59:02AM -0800, Andrii Nakryiko wrote:

SNIP

> 
> So in my previous example I assumed we have address ranges for ftrace
> section, which is exactly the opposite from what we have. So this
> binary search should be a bit different. start <= addr seems wrong
> here as well.
> 
> The invariant here should be that addr[r] is the smallest address that
> is >= than function start addr, right? Except the corner case where
> there is no such r, but for that we have a final check in the return
> below. If you wanted to use index l, you'd need to change the
> invariant to find the largest addr, such that it is < end, but that
> seems a bit convoluted.
> 
> So, with that, I think it should be like this:
> 
> size_t l = 0, r = count - 1, m;
> 
> /* make sure we don't use invalid r */
> if (count == 0) return false;
> 
> while (l < r) {
>     /* note no +1 in this case, it's so that at the end, when you
>      * have, say, l = 0, and r = 1, you try l first, not r.
>      * Otherwise you might end in in the infinite loop when r never == l.
>      */
>     m = l + (r - l) / 2;
>     addr = addrs[m];
> 
>     if (addr >= start)
>         /* we satisfy invariant, so tighten r */
>         r = m;
>     else
>         /* m is not good enough as l, maybe m + 1 will be */
>         l = m + 1;
> }
> 
> return start <= addrs[r] && addrs[r] < end;
> 
> 
> So, basically, r is maintained as a valid index always, while we
> constantly try to tighten the l.
> 
> Does this make sense?

another take ;-)

jirka


---
diff --git a/btf_encoder.c b/btf_encoder.c
index b124ec20a689..20a93ed60e52 100644
--- a/btf_encoder.c
+++ b/btf_encoder.c
@@ -36,6 +36,7 @@ struct funcs_layout {
 struct elf_function {
 	const char	*name;
 	unsigned long	 addr;
+	unsigned long	 size;
 	unsigned long	 sh_addr;
 	bool		 generated;
 };
@@ -44,7 +45,7 @@ static struct elf_function *functions;
 static int functions_alloc;
 static int functions_cnt;
 
-static int functions_cmp(const void *_a, const void *_b)
+static int functions_cmp_name(const void *_a, const void *_b)
 {
 	const struct elf_function *a = _a;
 	const struct elf_function *b = _b;
@@ -52,6 +53,16 @@ static int functions_cmp(const void *_a, const void *_b)
 	return strcmp(a->name, b->name);
 }
 
+static int functions_cmp_addr(const void *_a, const void *_b)
+{
+	const struct elf_function *a = _a;
+	const struct elf_function *b = _b;
+
+	if (a->addr == b->addr)
+		return 0;
+	return a->addr < b->addr ? -1 : 1;
+}
+
 static void delete_functions(void)
 {
 	free(functions);
@@ -98,6 +109,7 @@ static int collect_function(struct btf_elf *btfe, GElf_Sym *sym,
 
 	functions[functions_cnt].name = name;
 	functions[functions_cnt].addr = elf_sym__value(sym);
+	functions[functions_cnt].size = elf_sym__size(sym);
 	functions[functions_cnt].sh_addr = sh.sh_addr;
 	functions[functions_cnt].generated = false;
 	functions_cnt++;
@@ -236,6 +248,48 @@ get_kmod_addrs(struct btf_elf *btfe, __u64 **paddrs, __u64 *pcount)
 	return 0;
 }
 
+static int is_ftrace_func(struct elf_function *func, __u64 *addrs,
+			  __u64 count, bool kmod)
+{
+	/*
+	 * For vmlinux image both addrs[x] and functions[x]::addr
+	 * values are final address and are comparable.
+	 *
+	 * For kernel module addrs[x] is final address, but
+	 * functions[x]::addr is relative address within section
+	 * and needs to be relocated by adding sh_addr.
+	 */
+	__u64 start = kmod ? func->addr + func->sh_addr : func->addr;
+	__u64 addr, end = func->addr + func->size;
+
+	/*
+	 * The invariant here is addr[r] that is the smallest address
+	 * that is >= than function start addr. Except the corner case
+	 * where there is no such r, but for that we have a final check
+	 * in the return.
+	 */
+	size_t l = 0, r = count - 1, m;
+
+	/* make sure we don't use invalid r */
+	if (count == 0)
+		return false;
+
+	while (l < r) {
+		m = l + (r - l) / 2;
+		addr = addrs[m];
+
+		if (addr >= start) {
+			/* we satisfy invariant, so tighten r */
+			r = m;
+		} else {
+			/* m is not good enough as l, maybe m + 1 will be */
+			l = m + 1;
+		}
+	}
+
+	return start <= addrs[r] && addrs[r] < end;
+}
+
 static int setup_functions(struct btf_elf *btfe, struct funcs_layout *fl)
 {
 	__u64 *addrs, count, i;
@@ -267,7 +321,7 @@ static int setup_functions(struct btf_elf *btfe, struct funcs_layout *fl)
 	}
 
 	qsort(addrs, count, sizeof(addrs[0]), addrs_cmp);
-	qsort(functions, functions_cnt, sizeof(functions[0]), functions_cmp);
+	qsort(functions, functions_cnt, sizeof(functions[0]), functions_cmp_addr);
 
 	/*
 	 * Let's got through all collected functions and filter
@@ -275,18 +329,9 @@ static int setup_functions(struct btf_elf *btfe, struct funcs_layout *fl)
 	 */
 	for (i = 0; i < functions_cnt; i++) {
 		struct elf_function *func = &functions[i];
-		/*
-		 * For vmlinux image both addrs[x] and functions[x]::addr
-		 * values are final address and are comparable.
-		 *
-		 * For kernel module addrs[x] is final address, but
-		 * functions[x]::addr is relative address within section
-		 * and needs to be relocated by adding sh_addr.
-		 */
-		__u64 addr = kmod ? func->addr + func->sh_addr : func->addr;
 
 		/* Make sure function is within ftrace addresses. */
-		if (bsearch(&addr, addrs, count, sizeof(addrs[0]), addrs_cmp)) {
+		if (is_ftrace_func(func, addrs, count, kmod)) {
 			/*
 			 * We iterate over sorted array, so we can easily skip
 			 * not valid item and move following valid field into
@@ -303,6 +348,8 @@ static int setup_functions(struct btf_elf *btfe, struct funcs_layout *fl)
 
 	if (btf_elf__verbose)
 		printf("Found %d functions!\n", functions_cnt);
+
+	qsort(functions, functions_cnt, sizeof(functions[0]), functions_cmp_name);
 	return 0;
 }
 
@@ -312,7 +359,7 @@ static struct elf_function *find_function(const struct btf_elf *btfe,
 	struct elf_function key = { .name = name };
 
 	return bsearch(&key, functions, functions_cnt, sizeof(functions[0]),
-		       functions_cmp);
+		       functions_cmp_name);
 }
 
 static bool btf_name_char_ok(char c, bool first)

