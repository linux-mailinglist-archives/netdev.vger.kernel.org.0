Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24B5B52DE27
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 22:15:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244650AbiESUPT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 16:15:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230395AbiESUPS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 16:15:18 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 601AFED8FF;
        Thu, 19 May 2022 13:15:17 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id n124-20020a1c2782000000b003972dfca96cso1502624wmn.4;
        Thu, 19 May 2022 13:15:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=R5StGlz1vviurEeHp86Yc0NK8H+s2C5ct2HWFfXOqqI=;
        b=j2AsJkqpREZDVr3/wq7aBhPed9FdU4CLnUyO+TKagVnoCi9D3Cvo+38/9odRp9/ss4
         egPEhRr5tmcCVrEmHJqZMpqS3eRmtevuI5JvI72sPbyiQecTSUfCdqlwLf9GQLbK2nlF
         qJM8JSjqzGruJ3K3JGZ4eG0f/WKwi/1/lzrL7zCudAyJoCrW1eQfKF/MWxM+AN9VFVOJ
         3Qjzu5URJ9U+l4+W7XwCn0c0Z9pmQwslF3H2s8pcOy2zPHltAoVr5IKjHHtdzhA6fzr7
         SATwahrsB7oyyBnpbjRJ4Onq6CRmceX7AUQjQDPAj7lF1eoZ2VDbP+k8ANpAmRb1Af+/
         WROQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=R5StGlz1vviurEeHp86Yc0NK8H+s2C5ct2HWFfXOqqI=;
        b=7iyLJ5lI6ou6jqKQJ4iKbRGnDfFee43mwsLKrM0R8V5n59J36hhCnU9IpUMNK006CC
         +0yPEePNjiV1v9FrEZ5vlryDjUQCdMNFUsj5p6oFFHwbYNoH/gLwlahKFB5LZS4dfN/5
         mCgHZR1oCNrCvF0td1JOuCccoPJmGbb4OPXyBwanU2Y/oby3o0veUhkRycb2K5yyey+7
         QREhEp3c92IAQ3dpMtSGNtHNhPHgKs6YguPG2mMweKMA8qBkzD/lhIS2y+ky45ZWpTPg
         HwVl2kQ8aYTAL1LBQddUIsB1NaUoyXEL4ofiZtHyEnrB72gQomPF0dllIz7B2LrVzCrD
         9Ikw==
X-Gm-Message-State: AOAM531X56ojjmpxbXYQTuiE8/U2Kc2krbAf7iXzBHDB8bEwEFCbSihQ
        Yo5/RNLqkIkya6RtRC1Be+8=
X-Google-Smtp-Source: ABdhPJxLMUXGCou2vx2P8DLUXT8bJ4Al4x/Zussdwmm1ENGEOmVNyzpdtA5dDAtGvqBShdpCvcbZsw==
X-Received: by 2002:a1c:acc6:0:b0:38e:b184:7721 with SMTP id v189-20020a1cacc6000000b0038eb1847721mr5350152wme.94.1652991315822;
        Thu, 19 May 2022 13:15:15 -0700 (PDT)
Received: from krava ([95.82.133.179])
        by smtp.gmail.com with ESMTPSA id d27-20020adfa41b000000b0020d012692dbsm559144wra.18.2022.05.19.13.15.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 May 2022 13:15:15 -0700 (PDT)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Thu, 19 May 2022 22:15:12 +0200
To:     Yonghong Song <yhs@fb.com>
Cc:     Eugene Syromiatnikov <esyr@redhat.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH bpf v4 3/3] libbpf, selftests/bpf: pass array of u64
 values in kprobe_multi.addrs
Message-ID: <YoalUCsTMFsADkPX@krava>
References: <cover.1652982525.git.esyr@redhat.com>
 <0f500d9a17dcc1270c581f0b722be8f9d7ce781d.1652982525.git.esyr@redhat.com>
 <0468355f-1d95-d5df-4560-f9220c7a0d05@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0468355f-1d95-d5df-4560-f9220c7a0d05@fb.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 19, 2022 at 12:43:18PM -0700, Yonghong Song wrote:
> 
> 
> On 5/19/22 11:14 AM, Eugene Syromiatnikov wrote:
> > With the interface as defined, it is impossible to pass 64-bit kernel
> > addresses from a 32-bit userspace process in BPF_LINK_TYPE_KPROBE_MULTI,
> > which severly limits the useability of the interface, change the API
> > to accept an array of u64 values instead of (kernel? user?) longs.
> > This patch implements the user space part of the change (without
> > the relevant kernel changes, since, as of now, an attempt to add
> > kprobe_multi link will fail with -EOPNOTSUPP), to avoid changing
> > the interface after a release.
> > 
> > Fixes: 5117c26e877352bc ("libbpf: Add bpf_link_create support for multi kprobes")
> > Fixes: ddc6b04989eb0993 ("libbpf: Add bpf_program__attach_kprobe_multi_opts function")
> > Fixes: f7a11eeccb111854 ("selftests/bpf: Add kprobe_multi attach test")
> > Fixes: 9271a0c7ae7a9147 ("selftests/bpf: Add attach test for bpf_program__attach_kprobe_multi_opts")
> > Fixes: 2c6401c966ae1fbe ("selftests/bpf: Add kprobe_multi bpf_cookie test")
> > Signed-off-by: Eugene Syromiatnikov <esyr@redhat.com>
> > ---
> >   tools/lib/bpf/bpf.h                                        | 2 +-
> >   tools/lib/bpf/libbpf.c                                     | 8 ++++----
> >   tools/lib/bpf/libbpf.h                                     | 2 +-
> >   tools/testing/selftests/bpf/prog_tests/bpf_cookie.c        | 2 +-
> >   tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c | 8 ++++----
> >   5 files changed, 11 insertions(+), 11 deletions(-)
> > 
> > diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
> > index f4b4afb..f677602 100644
> > --- a/tools/lib/bpf/bpf.h
> > +++ b/tools/lib/bpf/bpf.h
> > @@ -417,7 +417,7 @@ struct bpf_link_create_opts {
> >   			__u32 flags;
> >   			__u32 cnt;
> >   			const char **syms;
> > -			const unsigned long *addrs;
> > +			const __u64 *addrs;
> 
> Patch 2 and 3 will prevent supporting 64-bit kernel, 32-bit userspace for
> kprobe_multi. So effectively, kprobe_multi only supports
> 64-bit kernel and 64-bit user space.
> This is definitely an option, but it would be great
> if other people can chime in as well for whether this choice
> is best or not.

IIUC patch 3 is preparation for kernel change that will enable 32 bit
userspace and 64 bit kernel, and Eugene will send it later

sounds good to me

jirka

> 
> >   			const __u64 *cookies;
> >   		} kprobe_multi;
> >   	};
> > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > index 809fe20..03a14a6 100644
> > --- a/tools/lib/bpf/libbpf.c
> > +++ b/tools/lib/bpf/libbpf.c
> > @@ -10279,7 +10279,7 @@ static bool glob_match(const char *str, const char *pat)
> >   struct kprobe_multi_resolve {
> >   	const char *pattern;
> > -	unsigned long *addrs;
> > +	__u64 *addrs;
> >   	size_t cap;
> >   	size_t cnt;
> >   };
> > @@ -10294,12 +10294,12 @@ resolve_kprobe_multi_cb(unsigned long long sym_addr, char sym_type,
> >   	if (!glob_match(sym_name, res->pattern))
> >   		return 0;
> > -	err = libbpf_ensure_mem((void **) &res->addrs, &res->cap, sizeof(unsigned long),
> > +	err = libbpf_ensure_mem((void **) &res->addrs, &res->cap, sizeof(__u64),
> >   				res->cnt + 1);
> >   	if (err)
> >   		return err;
> > -	res->addrs[res->cnt++] = (unsigned long) sym_addr;
> > +	res->addrs[res->cnt++] = sym_addr;
> >   	return 0;
> >   }
> > @@ -10314,7 +10314,7 @@ bpf_program__attach_kprobe_multi_opts(const struct bpf_program *prog,
> >   	};
> >   	struct bpf_link *link = NULL;
> >   	char errmsg[STRERR_BUFSIZE];
> > -	const unsigned long *addrs;
> > +	const __u64 *addrs;
> >   	int err, link_fd, prog_fd;
> >   	const __u64 *cookies;
> >   	const char **syms;
> > diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> > index 05dde85..ec1cb61 100644
> > --- a/tools/lib/bpf/libbpf.h
> > +++ b/tools/lib/bpf/libbpf.h
> > @@ -431,7 +431,7 @@ struct bpf_kprobe_multi_opts {
> >   	/* array of function symbols to attach */
> >   	const char **syms;
> >   	/* array of function addresses to attach */
> > -	const unsigned long *addrs;
> > +	const __u64 *addrs;
> >   	/* array of user-provided values fetchable through bpf_get_attach_cookie */
> >   	const __u64 *cookies;
> >   	/* number of elements in syms/addrs/cookies arrays */
> > diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_cookie.c b/tools/testing/selftests/bpf/prog_tests/bpf_cookie.c
> > index 923a613..5aa482a 100644
> > --- a/tools/testing/selftests/bpf/prog_tests/bpf_cookie.c
> > +++ b/tools/testing/selftests/bpf/prog_tests/bpf_cookie.c
> > @@ -137,7 +137,7 @@ static void kprobe_multi_link_api_subtest(void)
> >   	cookies[6] = 7;
> >   	cookies[7] = 8;
> > -	opts.kprobe_multi.addrs = (const unsigned long *) &addrs;
> > +	opts.kprobe_multi.addrs = (const __u64 *) &addrs;
> >   	opts.kprobe_multi.cnt = ARRAY_SIZE(addrs);
> >   	opts.kprobe_multi.cookies = (const __u64 *) &cookies;
> >   	prog_fd = bpf_program__fd(skel->progs.test_kprobe);
> > diff --git a/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c b/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c
> > index b9876b5..fbf4cf2 100644
> > --- a/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c
> > +++ b/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c
> > @@ -105,7 +105,7 @@ static void test_link_api_addrs(void)
> >   	GET_ADDR("bpf_fentry_test7", addrs[6]);
> >   	GET_ADDR("bpf_fentry_test8", addrs[7]);
> > -	opts.kprobe_multi.addrs = (const unsigned long*) addrs;
> > +	opts.kprobe_multi.addrs = (const __u64 *) addrs;
> >   	opts.kprobe_multi.cnt = ARRAY_SIZE(addrs);
> >   	test_link_api(&opts);
> >   }
> > @@ -183,7 +183,7 @@ static void test_attach_api_addrs(void)
> >   	GET_ADDR("bpf_fentry_test7", addrs[6]);
> >   	GET_ADDR("bpf_fentry_test8", addrs[7]);
> > -	opts.addrs = (const unsigned long *) addrs;
> > +	opts.addrs = (const __u64 *) addrs;
> >   	opts.cnt = ARRAY_SIZE(addrs);
> >   	test_attach_api(NULL, &opts);
> >   }
> > @@ -241,7 +241,7 @@ static void test_attach_api_fails(void)
> >   		goto cleanup;
> >   	/* fail_2 - both addrs and syms set */
> > -	opts.addrs = (const unsigned long *) addrs;
> > +	opts.addrs = (const __u64 *) addrs;
> >   	opts.syms = syms;
> >   	opts.cnt = ARRAY_SIZE(syms);
> >   	opts.cookies = NULL;
> > @@ -255,7 +255,7 @@ static void test_attach_api_fails(void)
> >   		goto cleanup;
> >   	/* fail_3 - pattern and addrs set */
> > -	opts.addrs = (const unsigned long *) addrs;
> > +	opts.addrs = (const __u64 *) addrs;
> >   	opts.syms = NULL;
> >   	opts.cnt = ARRAY_SIZE(syms);
> >   	opts.cookies = NULL;
