Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC02552AC62
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 22:03:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352878AbiEQUDN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 16:03:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352870AbiEQUDK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 16:03:10 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C460F47AFE;
        Tue, 17 May 2022 13:03:08 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id w4so26099104wrg.12;
        Tue, 17 May 2022 13:03:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XkfCyrxoT2zrN+jBafASwOY2VNfhqpO8cs0A4/vlmzk=;
        b=Z6NRcJCPTKd+uYuaaRGGyE7nPBIZDdYyoDwFkpGfsH37QepNFob3KfmyTQYbeeqSSm
         T/fXK9dmyUJfqPAAZIr6134fHA3s0PxlclH/8XLCh8GARtsJd8GZskD/FiEBUVU4xFJO
         YCodNWpbgUMw/l0n0CmBW9XGjz52F8yeVHwj6oUQNl4GvmATre1s23PkhP23UQV0Gx/A
         m0cmU1ieDZOMQ+WilUJYZiQMGcNgJih7VzaR0Hzk7mQnQEPSYWlupp22hgD1Z1rZtkd8
         ElxGECDRkNkMuYzWvSzxuZeTDTx3RYPwahuGKVZXwq3eRb4kdgVNObe+rVbWS5vcspYA
         JPXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XkfCyrxoT2zrN+jBafASwOY2VNfhqpO8cs0A4/vlmzk=;
        b=C3tKvyp31pm1tKnYXODxDaWu/yEZ2KVi8qvRzq0ICpzGw/7AFNDTkd+lnknUYkuXM3
         jeoSsn9pZ3DfbfcdqLtZKkXQekU7fPTewqmfrfNOm8gO+TpmE2frP35dAJDqEWr4xyPa
         i5D41M3E+OWlZXItafoEIYzgHqDUajrfE8C/xtjtec4kriGLzBlZJLXpNrn1ObKF9awH
         5WzOSgVuu7qDryjfYJwwu8nmeHBPiM8CSEaJDP/fmAaX1vUPyK6yfKIBVNo99XaVqSkK
         urxZ/SwSfpuh9EBwVTEanAqppERYQIBnK2rR3Rbx5sbcDPTsNOkc2dEEW0AMWYWVKqsi
         UkNg==
X-Gm-Message-State: AOAM531IXIGzo6OaNmr3poGvHc0mwqdNLC6q0PopiWOzScd9kiNrMKkO
        K722fMgRiJ95KgB+2+tWhjk=
X-Google-Smtp-Source: ABdhPJwdMzs2tUU7ktkt0AD+WQ+TXU6s2t1Jd+DEvS6PRi5796o+TMfSh7eEyamExptxlHwVx3shNA==
X-Received: by 2002:a05:6000:1f04:b0:20c:a0c3:b710 with SMTP id bv4-20020a0560001f0400b0020ca0c3b710mr20736024wrb.660.1652817787068;
        Tue, 17 May 2022 13:03:07 -0700 (PDT)
Received: from krava ([95.82.133.179])
        by smtp.gmail.com with ESMTPSA id d6-20020adfc086000000b0020c5253d8fcsm15887563wrf.72.2022.05.17.13.03.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 13:03:06 -0700 (PDT)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Tue, 17 May 2022 22:03:04 +0200
To:     Eugene Syromiatnikov <esyr@redhat.com>
Cc:     Jiri Olsa <olsajiri@gmail.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH bpf-next v3 4/4] bpf_trace: pass array of u64 values in
 kprobe_multi.addrs
Message-ID: <YoP/eEMqAn3sVFXf@krava>
References: <cover.1652772731.git.esyr@redhat.com>
 <6ef675aeeea442fa8fc168cd1cb4e4e474f65a3f.1652772731.git.esyr@redhat.com>
 <YoNnAgDsIWef82is@krava>
 <20220517123050.GA25149@asgard.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220517123050.GA25149@asgard.redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 17, 2022 at 02:30:50PM +0200, Eugene Syromiatnikov wrote:
> On Tue, May 17, 2022 at 11:12:34AM +0200, Jiri Olsa wrote:
> > On Tue, May 17, 2022 at 09:36:47AM +0200, Eugene Syromiatnikov wrote:
> > > With the interface as defined, it is impossible to pass 64-bit kernel
> > > addresses from a 32-bit userspace process in BPF_LINK_TYPE_KPROBE_MULTI,
> > > which severly limits the useability of the interface, change the ABI
> > > to accept an array of u64 values instead of (kernel? user?) longs.
> > > Interestingly, the rest of the libbpf infrastructure uses 64-bit values
> > > for kallsyms addresses already, so this patch also eliminates
> > > the sym_addr cast in tools/lib/bpf/libbpf.c:resolve_kprobe_multi_cb().
> > 
> > so the problem is when we have 32bit user sace on 64bit kernel right?
> > 
> > I think we should keep addrs as longs in uapi and have kernel to figure out
> > if it needs to read u32 or u64, like you did for symbols in previous patch
> 
> No, it's not possible here, as addrs are kernel addrs and not user space
> addrs, so user space has to explicitly pass 64-bit addresses on 64-bit
> kernels (or have a notion whether it is running on a 64-bit
> or 32-bit kernel, and form the passed array accordingly, which is against
> the idea of compat layer that tries to abstract it out).

hum :-\ I'll need to check on compat layer.. there must
be some other code doing this already somewhere, right?

jirka

> 
> > we'll need to fix also bpf_kprobe_multi_cookie_swap because it assumes
> > 64bit user space pointers
> > 
> > would be gret if we could have selftest for this
> > 
> > thanks,
> > jirka
> > 
> > > 
> > > Fixes: 0dcac272540613d4 ("bpf: Add multi kprobe link")
> > > Fixes: 5117c26e877352bc ("libbpf: Add bpf_link_create support for multi kprobes")
> > > Fixes: ddc6b04989eb0993 ("libbpf: Add bpf_program__attach_kprobe_multi_opts function")
> > > Fixes: f7a11eeccb111854 ("selftests/bpf: Add kprobe_multi attach test")
> > > Fixes: 9271a0c7ae7a9147 ("selftests/bpf: Add attach test for bpf_program__attach_kprobe_multi_opts")
> > > Fixes: 2c6401c966ae1fbe ("selftests/bpf: Add kprobe_multi bpf_cookie test")
> > > Signed-off-by: Eugene Syromiatnikov <esyr@redhat.com>
> > > ---
> > >  kernel/trace/bpf_trace.c                           | 25 ++++++++++++++++++----
> > >  tools/lib/bpf/bpf.h                                |  2 +-
> > >  tools/lib/bpf/libbpf.c                             |  8 +++----
> > >  tools/lib/bpf/libbpf.h                             |  2 +-
> > >  .../testing/selftests/bpf/prog_tests/bpf_cookie.c  |  2 +-
> > >  .../selftests/bpf/prog_tests/kprobe_multi_test.c   |  8 +++----
> > >  6 files changed, 32 insertions(+), 15 deletions(-)
> > > 
> > > diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> > > index 9d3028a..30a15b3 100644
> > > --- a/kernel/trace/bpf_trace.c
> > > +++ b/kernel/trace/bpf_trace.c
> > > @@ -2454,7 +2454,7 @@ int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
> > >  	void __user *ucookies;
> > >  	unsigned long *addrs;
> > >  	u32 flags, cnt, size, cookies_size;
> > > -	void __user *uaddrs;
> > > +	u64 __user *uaddrs;
> > >  	u64 *cookies = NULL;
> > >  	void __user *usyms;
> > >  	int err;
> > > @@ -2486,9 +2486,26 @@ int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
> > >  		return -ENOMEM;
> > >  
> > >  	if (uaddrs) {
> > > -		if (copy_from_user(addrs, uaddrs, size)) {
> > > -			err = -EFAULT;
> > > -			goto error;
> > > +		if (sizeof(*addrs) == sizeof(*uaddrs)) {
> > > +			if (copy_from_user(addrs, uaddrs, size)) {
> > > +				err = -EFAULT;
> > > +				goto error;
> > > +			}
> > > +		} else {
> > > +			u32 i;
> > > +			u64 addr;
> > > +
> > > +			for (i = 0; i < cnt; i++) {
> > > +				if (get_user(addr, uaddrs + i)) {
> > > +					err = -EFAULT;
> > > +					goto error;
> > > +				}
> > > +				if (addr > ULONG_MAX) {
> > > +					err = -EINVAL;
> > > +					goto error;
> > > +				}
> > > +				addrs[i] = addr;
> > > +			}
> > >  		}
> > >  	} else {
> > >  		struct user_syms us;
> > > diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
> > > index 2e0d373..da9c6037 100644
> > > --- a/tools/lib/bpf/bpf.h
> > > +++ b/tools/lib/bpf/bpf.h
> > > @@ -418,7 +418,7 @@ struct bpf_link_create_opts {
> > >  			__u32 flags;
> > >  			__u32 cnt;
> > >  			const char **syms;
> > > -			const unsigned long *addrs;
> > > +			const __u64 *addrs;
> > >  			const __u64 *cookies;
> > >  		} kprobe_multi;
> > >  		struct {
> > > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > > index ef7f302..35fa9c5 100644
> > > --- a/tools/lib/bpf/libbpf.c
> > > +++ b/tools/lib/bpf/libbpf.c
> > > @@ -10737,7 +10737,7 @@ static bool glob_match(const char *str, const char *pat)
> > >  
> > >  struct kprobe_multi_resolve {
> > >  	const char *pattern;
> > > -	unsigned long *addrs;
> > > +	__u64 *addrs;
> > >  	size_t cap;
> > >  	size_t cnt;
> > >  };
> > > @@ -10752,12 +10752,12 @@ resolve_kprobe_multi_cb(unsigned long long sym_addr, char sym_type,
> > >  	if (!glob_match(sym_name, res->pattern))
> > >  		return 0;
> > >  
> > > -	err = libbpf_ensure_mem((void **) &res->addrs, &res->cap, sizeof(unsigned long),
> > > +	err = libbpf_ensure_mem((void **) &res->addrs, &res->cap, sizeof(__u64),
> > >  				res->cnt + 1);
> > >  	if (err)
> > >  		return err;
> > >  
> > > -	res->addrs[res->cnt++] = (unsigned long) sym_addr;
> > > +	res->addrs[res->cnt++] = sym_addr;
> > >  	return 0;
> > >  }
> > >  
> > > @@ -10772,7 +10772,7 @@ bpf_program__attach_kprobe_multi_opts(const struct bpf_program *prog,
> > >  	};
> > >  	struct bpf_link *link = NULL;
> > >  	char errmsg[STRERR_BUFSIZE];
> > > -	const unsigned long *addrs;
> > > +	const __u64 *addrs;
> > >  	int err, link_fd, prog_fd;
> > >  	const __u64 *cookies;
> > >  	const char **syms;
> > > diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> > > index 9e9a3fd..76e171d 100644
> > > --- a/tools/lib/bpf/libbpf.h
> > > +++ b/tools/lib/bpf/libbpf.h
> > > @@ -489,7 +489,7 @@ struct bpf_kprobe_multi_opts {
> > >  	/* array of function symbols to attach */
> > >  	const char **syms;
> > >  	/* array of function addresses to attach */
> > > -	const unsigned long *addrs;
> > > +	const __u64 *addrs;
> > >  	/* array of user-provided values fetchable through bpf_get_attach_cookie */
> > >  	const __u64 *cookies;
> > >  	/* number of elements in syms/addrs/cookies arrays */
> > > diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_cookie.c b/tools/testing/selftests/bpf/prog_tests/bpf_cookie.c
> > > index 83ef55e3..e843840 100644
> > > --- a/tools/testing/selftests/bpf/prog_tests/bpf_cookie.c
> > > +++ b/tools/testing/selftests/bpf/prog_tests/bpf_cookie.c
> > > @@ -140,7 +140,7 @@ static void kprobe_multi_link_api_subtest(void)
> > >  	cookies[6] = 7;
> > >  	cookies[7] = 8;
> > >  
> > > -	opts.kprobe_multi.addrs = (const unsigned long *) &addrs;
> > > +	opts.kprobe_multi.addrs = (const __u64 *) &addrs;
> > >  	opts.kprobe_multi.cnt = ARRAY_SIZE(addrs);
> > >  	opts.kprobe_multi.cookies = (const __u64 *) &cookies;
> > >  	prog_fd = bpf_program__fd(skel->progs.test_kprobe);
> > > diff --git a/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c b/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c
> > > index 586dc52..7646112 100644
> > > --- a/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c
> > > +++ b/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c
> > > @@ -108,7 +108,7 @@ static void test_link_api_addrs(void)
> > >  	GET_ADDR("bpf_fentry_test7", addrs[6]);
> > >  	GET_ADDR("bpf_fentry_test8", addrs[7]);
> > >  
> > > -	opts.kprobe_multi.addrs = (const unsigned long*) addrs;
> > > +	opts.kprobe_multi.addrs = (const __u64 *) addrs;
> > >  	opts.kprobe_multi.cnt = ARRAY_SIZE(addrs);
> > >  	test_link_api(&opts);
> > >  }
> > > @@ -186,7 +186,7 @@ static void test_attach_api_addrs(void)
> > >  	GET_ADDR("bpf_fentry_test7", addrs[6]);
> > >  	GET_ADDR("bpf_fentry_test8", addrs[7]);
> > >  
> > > -	opts.addrs = (const unsigned long *) addrs;
> > > +	opts.addrs = (const __u64 *) addrs;
> > >  	opts.cnt = ARRAY_SIZE(addrs);
> > >  	test_attach_api(NULL, &opts);
> > >  }
> > > @@ -244,7 +244,7 @@ static void test_attach_api_fails(void)
> > >  		goto cleanup;
> > >  
> > >  	/* fail_2 - both addrs and syms set */
> > > -	opts.addrs = (const unsigned long *) addrs;
> > > +	opts.addrs = (const __u64 *) addrs;
> > >  	opts.syms = syms;
> > >  	opts.cnt = ARRAY_SIZE(syms);
> > >  	opts.cookies = NULL;
> > > @@ -258,7 +258,7 @@ static void test_attach_api_fails(void)
> > >  		goto cleanup;
> > >  
> > >  	/* fail_3 - pattern and addrs set */
> > > -	opts.addrs = (const unsigned long *) addrs;
> > > +	opts.addrs = (const __u64 *) addrs;
> > >  	opts.syms = NULL;
> > >  	opts.cnt = ARRAY_SIZE(syms);
> > >  	opts.cookies = NULL;
> > > -- 
> > > 2.1.4
> > > 
> > 
> 
