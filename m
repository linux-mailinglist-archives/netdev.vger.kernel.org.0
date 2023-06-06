Return-Path: <netdev+bounces-8624-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DE4E6724E6B
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 23:03:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 93956280A98
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 21:03:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6842B2721E;
	Tue,  6 Jun 2023 21:02:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E80A3D7F
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 21:02:53 +0000 (UTC)
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D76731720
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 14:02:50 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id 46e09a7af769-6b2041315a5so1774967a34.0
        for <netdev@vger.kernel.org>; Tue, 06 Jun 2023 14:02:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686085370; x=1688677370;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=uq9Pr6DWUVzSXGxbV7e8ZoB8v64gECVHajz2KbgU84M=;
        b=nk0kQfUOYGxbA0ifjF5QUVXaAIW1vfVdix4AA/DsDLhQGISIr3M35kVaT8owahipaR
         3m9J2cqxnwxTh9FUa8hsSrnl3w/TbwfUh+mRJyBGbzLyeAYff7NlkA8KwTK8Klz9xWt6
         bNhZCW188kLCU7KIQK44G91iqHSL9TNfyCXMWbmZjS9csnXbTG25MLQ2mGtqxEozkY86
         xbbBHG2t/JEnYl7K7gyQbij+7mbujoSf98exF9Mckp0YUoHK6OtKX7iBupMuijEt6Q+f
         4IBYc9+Dqzh+n0oDt8ypG/W8nwu2afenNgRK+ACJnQ5yf7q/6NEmbCpz9rsqEA7DUh2a
         W3Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686085370; x=1688677370;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uq9Pr6DWUVzSXGxbV7e8ZoB8v64gECVHajz2KbgU84M=;
        b=ap2VjgNcg5bon5dsxCRtpV2g4A2oTF4kDLtoi7Kkeup1N++18BFPoJERQGlViCtshd
         FgoaKN+r2jm3lAoUd86q/WJCloRJyQoHL8hDcgYefpSbMMfL7sqAainQ7NcYPTNraMZD
         S+O3PYglerEMGRAzbfi5Y4okU5YHNNqMmHJ6G8DocZE4zxibX+07xYxyWpS+PG01YxrG
         7dsiXPajENfCTab6PRgg1R7WFuY97MdSV/d7JEYBs7wAE87f5h+N7h+OZFJFBG5e/a7U
         NiTFmy2bwV70448UbauHwGEbcb+IUaV40UAw4Vz7p2yFOPwbEnvbe4zjkJGyuzFJn+bB
         v9Ew==
X-Gm-Message-State: AC+VfDyYd9Tw1dcd30fnpiirdrTu663mAs/Ctow61aGJactdrfoaZXsM
	80wjkiUx8cOu0Lt+n0xxRyKGKA==
X-Google-Smtp-Source: ACHHUZ7LYh5dG7aPOBJuFRUuEBk0WqeuseveTYM2K8wIaYAbGmx3y0eFWA1FPUJnp32LJJKABJh6Qw==
X-Received: by 2002:a05:6358:c014:b0:129:b9f4:6d43 with SMTP id ez20-20020a056358c01400b00129b9f46d43mr773502rwb.30.1686085369822;
        Tue, 06 Jun 2023 14:02:49 -0700 (PDT)
Received: from google.com ([2620:15c:2d1:203:e8d0:a79a:be71:c670])
        by smtp.gmail.com with ESMTPSA id m4-20020a17090a71c400b0025671de4606sm2918pjs.4.2023.06.06.14.02.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jun 2023 14:02:49 -0700 (PDT)
Date: Tue, 6 Jun 2023 14:02:44 -0700
From: Nick Desaulniers <ndesaulniers@google.com>
To: Alexander Lobakin <alobakin@pm.me>
Cc: Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Song Liu <songliubraving@fb.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, bpf@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	tpgxyz@gmail.com
Subject: Re: [PATCH v2 bpf 03/11] bpftool: use a local bpf_perf_event_value
 to fix accessing its fields
Message-ID: <ZH+e9IYk+DIZzUFL@google.com>
References: <20220421003152.339542-1-alobakin@pm.me>
 <20220421003152.339542-4-alobakin@pm.me>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220421003152.339542-4-alobakin@pm.me>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Apr 21, 2022 at 12:39:04AM +0000, Alexander Lobakin wrote:
> Fix the following error when building bpftool:
> 
>   CLANG   profiler.bpf.o
>   CLANG   pid_iter.bpf.o
> skeleton/profiler.bpf.c:18:21: error: invalid application of 'sizeof' to an incomplete type 'struct bpf_perf_event_value'
>         __uint(value_size, sizeof(struct bpf_perf_event_value));
>                            ^     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> tools/bpf/bpftool/bootstrap/libbpf/include/bpf/bpf_helpers.h:13:39: note: expanded from macro '__uint'
> tools/bpf/bpftool/bootstrap/libbpf/include/bpf/bpf_helper_defs.h:7:8: note: forward declaration of 'struct bpf_perf_event_value'
> struct bpf_perf_event_value;
>        ^
> 
> struct bpf_perf_event_value is being used in the kernel only when
> CONFIG_BPF_EVENTS is enabled, so it misses a BTF entry then.
> Define struct bpf_perf_event_value___local with the
> `preserve_access_index` attribute inside the pid_iter BPF prog to
> allow compiling on any configs. It is a full mirror of a UAPI
> structure, so is compatible both with and w/o CO-RE.
> bpf_perf_event_read_value() requires a pointer of the original type,
> so a cast is needed.
> 

Hi Alexander,
What's the status of this series? I wasn't able to find a v3 on lore.

We received a report that OpenMandriva is carrying around this patch.
https://github.com/ClangBuiltLinux/linux/issues/1805.

+ Tomasz

Tomasz, do you have more info which particular configs can reproduce
this issue? Is this patch still necessary?

> Fixes: 47c09d6a9f67 ("bpftool: Introduce "prog profile" command")
> Suggested-by: Andrii Nakryiko <andrii@kernel.org>
> Signed-off-by: Alexander Lobakin <alobakin@pm.me>
> ---
>  tools/bpf/bpftool/skeleton/profiler.bpf.c | 27 ++++++++++++++---------
>  1 file changed, 17 insertions(+), 10 deletions(-)
> 
> diff --git a/tools/bpf/bpftool/skeleton/profiler.bpf.c b/tools/bpf/bpftool/skeleton/profiler.bpf.c
> index ce5b65e07ab1..2f80edc682f1 100644
> --- a/tools/bpf/bpftool/skeleton/profiler.bpf.c
> +++ b/tools/bpf/bpftool/skeleton/profiler.bpf.c
> @@ -4,6 +4,12 @@
>  #include <bpf/bpf_helpers.h>
>  #include <bpf/bpf_tracing.h>
> 
> +struct bpf_perf_event_value___local {
> +	__u64 counter;
> +	__u64 enabled;
> +	__u64 running;
> +} __attribute__((preserve_access_index));
> +
>  /* map of perf event fds, num_cpu * num_metric entries */
>  struct {
>  	__uint(type, BPF_MAP_TYPE_PERF_EVENT_ARRAY);
> @@ -15,14 +21,14 @@ struct {
>  struct {
>  	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
>  	__uint(key_size, sizeof(u32));
> -	__uint(value_size, sizeof(struct bpf_perf_event_value));
> +	__uint(value_size, sizeof(struct bpf_perf_event_value___local));
>  } fentry_readings SEC(".maps");
> 
>  /* accumulated readings */
>  struct {
>  	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
>  	__uint(key_size, sizeof(u32));
> -	__uint(value_size, sizeof(struct bpf_perf_event_value));
> +	__uint(value_size, sizeof(struct bpf_perf_event_value___local));
>  } accum_readings SEC(".maps");
> 
>  /* sample counts, one per cpu */
> @@ -39,7 +45,7 @@ const volatile __u32 num_metric = 1;
>  SEC("fentry/XXX")
>  int BPF_PROG(fentry_XXX)
>  {
> -	struct bpf_perf_event_value *ptrs[MAX_NUM_MATRICS];
> +	struct bpf_perf_event_value___local *ptrs[MAX_NUM_MATRICS];
>  	u32 key = bpf_get_smp_processor_id();
>  	u32 i;
> 
> @@ -53,10 +59,10 @@ int BPF_PROG(fentry_XXX)
>  	}
> 
>  	for (i = 0; i < num_metric && i < MAX_NUM_MATRICS; i++) {
> -		struct bpf_perf_event_value reading;
> +		struct bpf_perf_event_value___local reading;
>  		int err;
> 
> -		err = bpf_perf_event_read_value(&events, key, &reading,
> +		err = bpf_perf_event_read_value(&events, key, (void *)&reading,
>  						sizeof(reading));
>  		if (err)
>  			return 0;
> @@ -68,14 +74,14 @@ int BPF_PROG(fentry_XXX)
>  }
> 
>  static inline void
> -fexit_update_maps(u32 id, struct bpf_perf_event_value *after)
> +fexit_update_maps(u32 id, struct bpf_perf_event_value___local *after)
>  {
> -	struct bpf_perf_event_value *before, diff;
> +	struct bpf_perf_event_value___local *before, diff;
> 
>  	before = bpf_map_lookup_elem(&fentry_readings, &id);
>  	/* only account samples with a valid fentry_reading */
>  	if (before && before->counter) {
> -		struct bpf_perf_event_value *accum;
> +		struct bpf_perf_event_value___local *accum;
> 
>  		diff.counter = after->counter - before->counter;
>  		diff.enabled = after->enabled - before->enabled;
> @@ -93,7 +99,7 @@ fexit_update_maps(u32 id, struct bpf_perf_event_value *after)
>  SEC("fexit/XXX")
>  int BPF_PROG(fexit_XXX)
>  {
> -	struct bpf_perf_event_value readings[MAX_NUM_MATRICS];
> +	struct bpf_perf_event_value___local readings[MAX_NUM_MATRICS];
>  	u32 cpu = bpf_get_smp_processor_id();
>  	u32 i, zero = 0;
>  	int err;
> @@ -102,7 +108,8 @@ int BPF_PROG(fexit_XXX)
>  	/* read all events before updating the maps, to reduce error */
>  	for (i = 0; i < num_metric && i < MAX_NUM_MATRICS; i++) {
>  		err = bpf_perf_event_read_value(&events, cpu + i * num_cpu,
> -						readings + i, sizeof(*readings));
> +						(void *)(readings + i),
> +						sizeof(*readings));
>  		if (err)
>  			return 0;
>  	}
> --
> 2.36.0
> 
> 

