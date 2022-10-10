Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18CFA5F9B92
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 11:01:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229893AbiJJJBa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 05:01:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231189AbiJJJB3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 05:01:29 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EB981127;
        Mon, 10 Oct 2022 02:01:28 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id bv10so12437486wrb.4;
        Mon, 10 Oct 2022 02:01:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+y7bAJPsrwUBLd8lS99Vl4DRojpEn+2LcBi7aYBpm8I=;
        b=ZNeBW7oC/NBRtw9xcqoobO8Sf2Hpd3hHAQSXcdNrdgDyfNtSZixn5MzoA9CaeAeA1G
         0lex4dOAf61JCebm3hSj3AwBUnfh7IIT4hQmDO0VWq/hS4ekXjr8pLq30R7GHEifUTcb
         R2mjGyqRkppt9s5U8xI4pPgW0WCutKuE5EHGuJvGZTguE+4khI7EI/KlvMzhC6JUPMi+
         MzYS3Zc6j788ok9c+PCuDGLhOETVttIbLCtNr9bDYe45TE/z7/vFb8SVsIJ1CByyIQCN
         +0+ZKhHUrOVk1+yem7sO2SN9JeGcuYM3Vw8tN0BRHfnwep7+ZnYjJUMnvGlN0w97AujX
         xdVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+y7bAJPsrwUBLd8lS99Vl4DRojpEn+2LcBi7aYBpm8I=;
        b=32ahkabU0/5UXRTJhHllQUxlifrkOu+0j4y9JZq1qGnB9xMxyFir6SkL70qm7Xzupy
         Bs+8Q7MGsO5xdtQiF3C+YXNK1st0QhbJM8izswYXNHhfZ7yaMWCb0ysmvfe5o7Kt+uWx
         lK9lqKCTKfbvz8r1ccIbSbOqqM+IA1xbVVFFJVHPIwYRgNmjxZbSsJxvvBDH5OLC+NWP
         7h3IVJraYFuzT/uF5C6A2hCDdW/svAtsXbiQCsvB2lvRyHap/srv23zjiz1XYCuxDUMp
         rZ89Nrf68/o8VYHhAm9b0keqTlbvC5BFNpFnnrEHLS7CvOZMgl6PGxEjVSJ8zMDuGBCH
         3UTA==
X-Gm-Message-State: ACrzQf0GeWBqMFBaGi14pSve8ammK556D28dbS762Rh6TQlmI6vD1ewl
        uSg56kW+qSuFEllzjr3qIRs=
X-Google-Smtp-Source: AMsMyM6l0DoGdglXgDjk2sFu/ZsftUW4ab9ENWWlsIARyWTAJVPu3e6srwvRZ+OuxbUS34qvawzhtw==
X-Received: by 2002:adf:f98e:0:b0:22e:393:8def with SMTP id f14-20020adff98e000000b0022e03938defmr11307683wrr.570.1665392486906;
        Mon, 10 Oct 2022 02:01:26 -0700 (PDT)
Received: from krava ([193.85.244.190])
        by smtp.gmail.com with ESMTPSA id n11-20020a05600c3b8b00b003a540fef440sm17165455wms.1.2022.10.10.02.01.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Oct 2022 02:01:26 -0700 (PDT)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Mon, 10 Oct 2022 11:01:23 +0200
To:     Xu Kuohai <xukuohai@huaweicloud.com>
Cc:     bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Mykola Lysenko <mykolal@fb.com>,
        Shuah Khan <shuah@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Hou Tao <houtao1@huawei.com>,
        Dmitrii Dolgov <9erthalion6@gmail.com>,
        Alan Maguire <alan.maguire@oracle.com>,
        Kui-Feng Lee <kuifeng@fb.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>
Subject: Re: [PATCH bpf-next 4/5] selftest/bpf: Fix memory leak in
 kprobe_multi_test
Message-ID: <Y0PfY9irDM0KEqq7@krava>
References: <20221009131830.395569-1-xukuohai@huaweicloud.com>
 <20221009131830.395569-5-xukuohai@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221009131830.395569-5-xukuohai@huaweicloud.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 09, 2022 at 09:18:29AM -0400, Xu Kuohai wrote:
> From: Xu Kuohai <xukuohai@huawei.com>
> 
> The get_syms() function in kprobe_multi_test.c does not free the string
> memory allocated by sscanf correctly. Fix it.
> 
> Signed-off-by: Xu Kuohai <xukuohai@huawei.com>
> ---
>  .../bpf/prog_tests/kprobe_multi_test.c          | 17 ++++++++---------
>  1 file changed, 8 insertions(+), 9 deletions(-)
> 
> diff --git a/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c b/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c
> index d457a55ff408..07dd2c5b7f98 100644
> --- a/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c
> +++ b/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c
> @@ -360,15 +360,14 @@ static int get_syms(char ***symsp, size_t *cntp)
>  		 * to them. Filter out the current culprits - arch_cpu_idle
>  		 * and rcu_* functions.
>  		 */
> -		if (!strcmp(name, "arch_cpu_idle"))
> -			continue;
> -		if (!strncmp(name, "rcu_", 4))
> -			continue;
> -		if (!strcmp(name, "bpf_dispatcher_xdp_func"))
> -			continue;
> -		if (!strncmp(name, "__ftrace_invalid_address__",
> -			     sizeof("__ftrace_invalid_address__") - 1))
> +		if (!strcmp(name, "arch_cpu_idle") ||
> +			!strncmp(name, "rcu_", 4) ||
> +			!strcmp(name, "bpf_dispatcher_xdp_func") ||
> +			!strncmp(name, "__ftrace_invalid_address__",
> +				 sizeof("__ftrace_invalid_address__") - 1)) {
> +			free(name);
>  			continue;
> +		}
>  		err = hashmap__add(map, name, NULL);
>  		if (err) {
>  			free(name);
> @@ -394,7 +393,7 @@ static int get_syms(char ***symsp, size_t *cntp)
>  	hashmap__free(map);
>  	if (err) {
>  		for (i = 0; i < cnt; i++)
> -			free(syms[cnt]);
> +			free(syms[i]);

mama mia.. nice catch! thanks

Acked-by: Jiri Olsa <jolsa@kernel.org>

jirka

>  		free(syms);
>  	}
>  	return err;
> -- 
> 2.25.1
> 
