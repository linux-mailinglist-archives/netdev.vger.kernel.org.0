Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B54155DDC2
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:28:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243836AbiF1IQF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 04:16:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244273AbiF1IPj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 04:15:39 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E18982DD4D;
        Tue, 28 Jun 2022 01:14:58 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id u12-20020a05600c210c00b003a02b16d2b8so7068186wml.2;
        Tue, 28 Jun 2022 01:14:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fTVgseVNgqo9Ivwwv2PAZ0MNjl+Ewk+f4XoldCtkS7k=;
        b=I59z5R3IxjeTR4zj7ruq4/SbCv3uBEBD094l7mpGuxilr5kfRI3ZACUGAU5IZN8y8B
         BfSV9A1mR3Rx5E/OTpm6NGAmO+Nk7hxmkTvnSHgjOyclMxvRwvq/4zlX73em4tIUpwmu
         i8KrZ6TDibLG0X2kg26gWHv0PjSdnu5zGtVkC0JOcWoovkBanhw7JLE4u8aWL4fzWEsP
         zNTJ/otGInEahf12+Ps09mAd6b7q9dgp2M5JwsQy5JfShadJLHvYn2h96BTlszgo4V8q
         BBksVJh+vBC8ywMYSQu/m1eJEDoGb6nZL5I+a2/vDs0GI6K7sWyEBhsazHJxwiSvPXGi
         qaog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fTVgseVNgqo9Ivwwv2PAZ0MNjl+Ewk+f4XoldCtkS7k=;
        b=MgD7aWjONreRkeIsgTMVFrTgSEQyyaTliX7DpN8sTCwif80m2GB5o17DvmBj07ZihJ
         VDWBkhigQSqJUVIvStYToZvSyE2C/HPYswFo29e35a22iEockqd0Qpf6F7KCuJbcWdTh
         eDdb++5OY0xFYbuUSjhtGVylJDH4GrGkudHVXRcVqt4j7qC6wKKOazb4O9Qxh0NHGSYG
         rh72Ormcg+558f0AaWycJco/ykVzq77mi0C/Tkyjzk8cHyije3hojDJk/J4Ypn2jxAy9
         goX3SjuU5B0zsX1M/xinFaH7Qvn6BHwuPXQEWm+U2pewyoPkPUwZZ3tk5cNApZhwycBT
         2HAg==
X-Gm-Message-State: AJIora8KaGn4C9Nbzjb6VByNX/fvLRa9aKGm8IQNZsQbkrdkpsLyHQS7
        chsIgZdwinuu1NgiwpCvR38=
X-Google-Smtp-Source: AGRyM1sxKRto5wR1HRE44ljDWBWjSWtrME0XEg5f/50qfwPpyMU+wPNHXH8P61OMWA0uTWCBMm5x9g==
X-Received: by 2002:a05:600c:3508:b0:39c:8240:5538 with SMTP id h8-20020a05600c350800b0039c82405538mr25878322wmq.165.1656404096701;
        Tue, 28 Jun 2022 01:14:56 -0700 (PDT)
Received: from krava (net-109-116-206-47.cust.vodafonedsl.it. [109.116.206.47])
        by smtp.gmail.com with ESMTPSA id j10-20020a5d448a000000b0021b8c99860asm12958055wrq.115.2022.06.28.01.14.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 01:14:56 -0700 (PDT)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Tue, 28 Jun 2022 10:14:52 +0200
To:     Ian Rogers <irogers@google.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Quentin Monnet <quentin@isovalent.com>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf bpf: 8 byte align bpil data
Message-ID: <Yrq4fFtgcpwa2JUu@krava>
References: <20220614014714.1407239-1-irogers@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220614014714.1407239-1-irogers@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 13, 2022 at 06:47:14PM -0700, Ian Rogers wrote:
> bpil data is accessed assuming 64-bit alignment resulting in undefined
> behavior as the data is just byte aligned. With an -fsanitize=undefined
> build the following errors are observed:
> 
> $ sudo perf record -a sleep 1
> util/bpf-event.c:310:22: runtime error: load of misaligned address 0x55f61084520f for type '__u64', which requires 8 byte alignment
> 0x55f61084520f: note: pointer points here
>  a8 fe ff ff 3c  51 d3 c0 ff ff ff ff 04  84 d3 c0 ff ff ff ff d8  aa d3 c0 ff ff ff ff a4  c0 d3 c0
>              ^
> util/bpf-event.c:311:20: runtime error: load of misaligned address 0x55f61084522f for type '__u32', which requires 4 byte alignment
> 0x55f61084522f: note: pointer points here
>  ff ff ff ff c7  17 00 00 f1 02 00 00 1f  04 00 00 58 04 00 00 00  00 00 00 0f 00 00 00 63  02 00 00
>              ^
> util/bpf-event.c:198:33: runtime error: member access within misaligned address 0x55f61084523f for type 'const struct bpf_func_info', which requires 4 byte alignment
> 0x55f61084523f: note: pointer points here
>  58 04 00 00 00  00 00 00 0f 00 00 00 63  02 00 00 3b 00 00 00 ab  02 00 00 44 00 00 00 14  03 00 00
> 
> Correct this by rouding up the data sizes and aligning the pointers.
> 
> Signed-off-by: Ian Rogers <irogers@google.com>
> ---
>  tools/perf/util/bpf-utils.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/perf/util/bpf-utils.c b/tools/perf/util/bpf-utils.c
> index e271e05e51bc..80b1d2b3729b 100644
> --- a/tools/perf/util/bpf-utils.c
> +++ b/tools/perf/util/bpf-utils.c
> @@ -149,11 +149,10 @@ get_bpf_prog_info_linear(int fd, __u64 arrays)
>  		count = bpf_prog_info_read_offset_u32(&info, desc->count_offset);
>  		size  = bpf_prog_info_read_offset_u32(&info, desc->size_offset);
>  
> -		data_len += count * size;
> +		data_len += roundup(count * size, sizeof(__u64));
>  	}
>  
>  	/* step 3: allocate continuous memory */
> -	data_len = roundup(data_len, sizeof(__u64));
>  	info_linear = malloc(sizeof(struct perf_bpil) + data_len);
>  	if (!info_linear)
>  		return ERR_PTR(-ENOMEM);
> @@ -180,7 +179,7 @@ get_bpf_prog_info_linear(int fd, __u64 arrays)
>  		bpf_prog_info_set_offset_u64(&info_linear->info,
>  					     desc->array_offset,
>  					     ptr_to_u64(ptr));
> -		ptr += count * size;
> +		ptr += roundup(count * size, sizeof(__u64));

this one depends on info_linear->data being alligned(8), right?

should we make sure it's allways the case like in the patch
below, or it's superfluous?

thanks,
jirka


---
diff --git a/tools/perf/util/bpf-utils.h b/tools/perf/util/bpf-utils.h
index 86a5055cdfad..1aba76c44116 100644
--- a/tools/perf/util/bpf-utils.h
+++ b/tools/perf/util/bpf-utils.h
@@ -60,7 +60,7 @@ struct perf_bpil {
 	/* which arrays are included in data */
 	__u64			arrays;
 	struct bpf_prog_info	info;
-	__u8			data[];
+	__u8			data[] __attribute__((aligned(8)));
 };
 
 struct perf_bpil *
