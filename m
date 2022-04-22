Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08AEB50B0CF
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 08:47:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444506AbiDVGuM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 02:50:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1443537AbiDVGuL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 02:50:11 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B00E50B0A;
        Thu, 21 Apr 2022 23:47:18 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id l7so14506082ejn.2;
        Thu, 21 Apr 2022 23:47:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Del5eeZrAfBdXZm8xl3NxZ/3UlBvdFq7az+6z0GKnVU=;
        b=jM+d8KowqciDEeu33ElBGSBJNSnizyE8hJWhbBmSi/BqCMwnX3JgG+CI1vFJFQTaeC
         t6we977iSDFEsJjJMI5XHEB5ZEpX5SSampoAlsSbxtpJFsAa+EhrQFFlAtSfq8ragbl4
         KJ+RMVbPHe77YUXU7Pdm3KJ9ksy+S8WtTCJyIsYShfwkndZCNZFT/wxTQy9J4cMVdnkE
         tXiewFh7L4P47/5EXORthwCi4T9VwvUBhedNrugtAYMRFre14EVIWaWgeo/mPIWNO6GU
         gvPNLiHkWm/eCz+2pXt1Xlaj9sjX3MYO+7MaHzx8sp+TtjKWOg/NC9yBV/IVvd43VZRH
         QSow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Del5eeZrAfBdXZm8xl3NxZ/3UlBvdFq7az+6z0GKnVU=;
        b=FdkPK3SYPOgEMEb2yH8N/bBl/TJwHNgh1By6c1Hj6UETq1HOmUnlxk3E4TLS06nLjT
         sdiX9JKkE+e4sO34Li6bdzN1Efd1cIlXAB8B4C0i5eBUBkYkaw0ITpYknlO1ifAEue98
         j0wFTlckDA6fZgiWe/Jca46Kv06SjJ0vW0bGSQWCaw8LiavBuSHEiAcOI2vXq7sarQ89
         YwF4gLGxjuluivZYwAYT43a7mSQXcaQLewfx/LnUcfCatPVTtVBSHynM5QgATCG+/umi
         x9JG+j3ONMQkaRq93eEcWrMOevHrAAdCeojww4SP9wcBUQ7Vtuc26wTsLAJV8JDaH4ho
         Ii6Q==
X-Gm-Message-State: AOAM532gOmZxvzBqqc7MEVu/1uwINv6Fqj4/JCH0seLnNcgjl/KN4OnV
        gSXuQL7LOI4Z04217+7vLhw=
X-Google-Smtp-Source: ABdhPJzA96YE+3ajfqFS9wHG63l8IqNyEfGeZ90wN/ktWjwt4XFML5UfYqq7Ef7M1DDPXxF35DlD9w==
X-Received: by 2002:a17:907:6d0d:b0:6f3:61e1:e33b with SMTP id sa13-20020a1709076d0d00b006f361e1e33bmr286510ejc.320.1650610036578;
        Thu, 21 Apr 2022 23:47:16 -0700 (PDT)
Received: from krava ([193.85.244.190])
        by smtp.gmail.com with ESMTPSA id x8-20020a170906134800b006e86ff7db33sm435829ejb.68.2022.04.21.23.47.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Apr 2022 23:47:16 -0700 (PDT)
Date:   Fri, 22 Apr 2022 08:47:13 +0200
From:   Jiri Olsa <olsajiri@gmail.com>
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: Re: [PATCHv2 bpf-next 1/4] kallsyms: Add kallsyms_lookup_names
 function
Message-ID: <YmJPcU9dahEatb0f@krava>
References: <20220418124834.829064-1-jolsa@kernel.org>
 <20220418124834.829064-2-jolsa@kernel.org>
 <20220418233546.dfe0a1be12193c26b05cdd93@kernel.org>
 <Yl5yHVOJpCYr+T3r@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yl5yHVOJpCYr+T3r@krava>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 19, 2022 at 10:26:05AM +0200, Jiri Olsa wrote:

SNIP

> > > +static int kallsyms_callback(void *data, const char *name,
> > > +			     struct module *mod, unsigned long addr)
> > > +{
> > > +	struct kallsyms_data *args = data;
> > > +
> > > +	if (!bsearch(&name, args->syms, args->cnt, sizeof(*args->syms), symbols_cmp))
> > > +		return 0;
> > > +
> > > +	addr = ftrace_location(addr);
> > > +	if (!addr)
> > > +		return 0;
> > 
> > Ooops, wait. Did you do this last version? I missed this point.
> > This changes the meanings of the kernel function.
> 
> yes, it was there before ;-) and you're right.. so some archs can
> return different address, I did not realize that
> 
> > 
> > > +
> > > +	args->addrs[args->found++] = addr;
> > > +	return args->found == args->cnt ? 1 : 0;
> > > +}
> > > +
> > > +/**
> > > + * kallsyms_lookup_names - Lookup addresses for array of symbols
> > 
> > More correctly "Lookup 'ftraced' addresses for array of sorted symbols", right?
> > 
> > I'm not sure, we can call it as a 'kallsyms' API, since this is using
> > kallsyms but doesn't return symbol address, but ftrace address.
> > I think this name misleads user to expect returning symbol address.
> > 
> > > + *
> > > + * @syms: array of symbols pointers symbols to resolve, must be
> > > + * alphabetically sorted
> > > + * @cnt: number of symbols/addresses in @syms/@addrs arrays
> > > + * @addrs: array for storing resulting addresses
> > > + *
> > > + * This function looks up addresses for array of symbols provided in
> > > + * @syms array (must be alphabetically sorted) and stores them in
> > > + * @addrs array, which needs to be big enough to store at least @cnt
> > > + * addresses.
> > 
> > Hmm, sorry I changed my mind. I rather like to expose kallsyms_on_each_symbol()
> > and provide this API from fprobe or ftrace, because this returns ftrace address
> > and thus this is only used from fprobe.
> 
> ok, so how about:
> 
>   int ftrace_lookup_symbols(const char **sorted_syms, size_t cnt, unsigned long *addrs);

quick question.. is it ok if it stays in kalsyms.c object?

so we don't need to expose kallsyms_on_each_symbol,
and it stays in 'kalsyms' place

jirka



diff --git a/include/linux/kallsyms.h b/include/linux/kallsyms.h
index ce1bd2fbf23e..177e0b13c8c5 100644
--- a/include/linux/kallsyms.h
+++ b/include/linux/kallsyms.h
@@ -72,6 +72,7 @@ int kallsyms_on_each_symbol(int (*fn)(void *, const char *, struct module *,
 #ifdef CONFIG_KALLSYMS
 /* Lookup the address for a symbol. Returns 0 if not found. */
 unsigned long kallsyms_lookup_name(const char *name);
+int ftrace_lookup_symbols(const char **sorted_syms, size_t cnt, unsigned long *addrs);
 
 extern int kallsyms_lookup_size_offset(unsigned long addr,
 				  unsigned long *symbolsize,
@@ -103,6 +104,11 @@ static inline unsigned long kallsyms_lookup_name(const char *name)
 	return 0;
 }
 
+static inline int ftrace_lookup_symbols(const char **sorted_syms, size_t cnt, unsigned long *addrs);
+{
+	return -ERANGE;
+}
+
 static inline int kallsyms_lookup_size_offset(unsigned long addr,
 					      unsigned long *symbolsize,
 					      unsigned long *offset)
diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
index 79f2eb617a62..1e7136a765a9 100644
--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -29,6 +29,7 @@
 #include <linux/compiler.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
+#include <linux/bsearch.h>
 
 /*
  * These will be re-linked against their real values
@@ -228,7 +229,7 @@ unsigned long kallsyms_lookup_name(const char *name)
 	return module_kallsyms_lookup_name(name);
 }
 
-#ifdef CONFIG_LIVEPATCH
+#if defined(CONFIG_LIVEPATCH) || defined(CONFIG_FPROBE)
 /*
  * Iterate over all symbols in vmlinux.  For symbols from modules use
  * module_kallsyms_on_each_symbol instead.
@@ -572,6 +573,73 @@ int sprint_backtrace_build_id(char *buffer, unsigned long address)
 	return __sprint_symbol(buffer, address, -1, 1, 1);
 }
 
+#ifdef CONFIG_FPROBE
+static int symbols_cmp(const void *a, const void *b)
+{
+	const char **str_a = (const char **) a;
+	const char **str_b = (const char **) b;
+
+	return strcmp(*str_a, *str_b);
+}
+
+struct kallsyms_data {
+	unsigned long *addrs;
+	const char **syms;
+	size_t cnt;
+	size_t found;
+};
+
+static int kallsyms_callback(void *data, const char *name,
+			     struct module *mod, unsigned long addr)
+{
+	struct kallsyms_data *args = data;
+
+	if (!bsearch(&name, args->syms, args->cnt, sizeof(*args->syms), symbols_cmp))
+		return 0;
+
+	addr = ftrace_location(addr);
+	if (!addr)
+		return 0;
+
+	args->addrs[args->found++] = addr;
+	return args->found == args->cnt ? 1 : 0;
+}
+
+/**
+ * ftrace_lookup_symbols - Lookup addresses for array of symbols
+ *
+ * @sorted_syms: array of symbols pointers symbols to resolve,
+ * must be alphabetically sorted
+ * @cnt: number of symbols/addresses in @syms/@addrs arrays
+ * @addrs: array for storing resulting addresses
+ *
+ * This function looks up addresses for array of symbols provided in
+ * @syms array (must be alphabetically sorted) and stores them in
+ * @addrs array, which needs to be big enough to store at least @cnt
+ * addresses.
+ *
+ * This function returns 0 if all provided symbols are found,
+ * -ESRCH otherwise.
+ */
+int ftrace_lookup_symbols(const char **sorted_syms, size_t cnt, unsigned long *addrs)
+{
+	struct kallsyms_data args;
+
+	args.addrs = addrs;
+	args.syms = sorted_syms;
+	args.cnt = cnt;
+	args.found = 0;
+	kallsyms_on_each_symbol(kallsyms_callback, &args);
+
+	return args.found == args.cnt ? 0 : -ESRCH;
+}
+#else
+int ftrace_lookup_symbols(const char **sorted_syms, size_t cnt, unsigned long *addrs)
+{
+	return -ERANGE;
+}
+#endif /* CONFIG_FPROBE */
+
 /* To avoid using get_symbol_offset for every symbol, we carry prefix along. */
 struct kallsym_iter {
 	loff_t pos;
