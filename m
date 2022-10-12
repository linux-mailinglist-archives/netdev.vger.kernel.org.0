Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53B065FCEE9
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 01:26:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbiJLX0P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 19:26:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbiJLX0O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 19:26:14 -0400
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F417E7CAB6;
        Wed, 12 Oct 2022 16:26:12 -0700 (PDT)
Message-ID: <33d17f23-03cb-9bff-2e50-06ab0f597640@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1665617171;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5yl+IrN5JIQ6K70LZJo+pynH1PkVtppZ1pBc7ZksFtE=;
        b=w6ezJSmwVtpssAQF1n7F/pKNNksCrEHY0OQ1FrnzUF3KMPxsi+r+vsiRLMmTeEUGndN1PN
        Da/O4jzRf8uvdRiqAihiKSFJJoGy5G1hBNSatTQWmTnq8lb4+AA3jiGdX49xo7k7zAioOm
        KJE8ao5VMLWa80iMGQBoEQ2dz4UwuPY=
Date:   Wed, 12 Oct 2022 16:26:05 -0700
MIME-Version: 1.0
Subject: Re: [PATCH bpf-next v4 6/6] selftest/bpf: Fix error usage of
 ASSERT_OK in xdp_adjust_tail.c
Content-Language: en-US
To:     Xu Kuohai <xukuohai@huaweicloud.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Mykola Lysenko <mykolal@fb.com>, Shuah Khan <shuah@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alan Maguire <alan.maguire@oracle.com>,
        Delyan Kratunov <delyank@fb.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        netdev@vger.kernel.org
References: <20221011120108.782373-1-xukuohai@huaweicloud.com>
 <20221011120108.782373-7-xukuohai@huaweicloud.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <20221011120108.782373-7-xukuohai@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/11/22 5:01 AM, Xu Kuohai wrote:
> From: Xu Kuohai <xukuohai@huawei.com>
> 
> xdp_adjust_tail.c calls ASSERT_OK() to check the return value of
> bpf_prog_test_load(), but the condition is not correct. Fix it.
> 
> Fixes: 791cad025051 ("bpf: selftests: Get rid of CHECK macro in xdp_adjust_tail.c")
> Signed-off-by: Xu Kuohai <xukuohai@huawei.com>
> ---
>   tools/testing/selftests/bpf/prog_tests/xdp_adjust_tail.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_adjust_tail.c b/tools/testing/selftests/bpf/prog_tests/xdp_adjust_tail.c
> index 009ee37607df..39973ea1ce43 100644
> --- a/tools/testing/selftests/bpf/prog_tests/xdp_adjust_tail.c
> +++ b/tools/testing/selftests/bpf/prog_tests/xdp_adjust_tail.c
> @@ -18,7 +18,7 @@ static void test_xdp_adjust_tail_shrink(void)
>   	);
>   
>   	err = bpf_prog_test_load(file, BPF_PROG_TYPE_XDP, &obj, &prog_fd);
> -	if (ASSERT_OK(err, "test_xdp_adjust_tail_shrink"))
> +	if (!ASSERT_OK(err, "test_xdp_adjust_tail_shrink"))
>   		return;
>   
>   	err = bpf_prog_test_run_opts(prog_fd, &topts);
> @@ -53,7 +53,7 @@ static void test_xdp_adjust_tail_grow(void)
>   	);
>   
>   	err = bpf_prog_test_load(file, BPF_PROG_TYPE_XDP, &obj, &prog_fd);
> -	if (ASSERT_OK(err, "test_xdp_adjust_tail_grow"))
> +	if (!ASSERT_OK(err, "test_xdp_adjust_tail_grow"))

Ouch... ic.  It is why this test has been passing.


>   		return;
>   
>   	err = bpf_prog_test_run_opts(prog_fd, &topts);
> @@ -90,7 +90,7 @@ static void test_xdp_adjust_tail_grow2(void)
>   	);
>   
>   	err = bpf_prog_test_load(file, BPF_PROG_TYPE_XDP, &obj, &prog_fd);
> -	if (ASSERT_OK(err, "test_xdp_adjust_tail_grow"))
> +	if (!ASSERT_OK(err, "test_xdp_adjust_tail_grow"))
>   		return;
>   
>   	/* Test case-64 */

