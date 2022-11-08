Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92E7B620749
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 04:08:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233330AbiKHDIG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 22:08:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233512AbiKHDH4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 22:07:56 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF5B02FFEC;
        Mon,  7 Nov 2022 19:07:53 -0800 (PST)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4N5tM03VXnzmVdj;
        Tue,  8 Nov 2022 11:07:40 +0800 (CST)
Received: from [10.174.179.191] (10.174.179.191) by
 canpemm500010.china.huawei.com (7.192.105.118) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 8 Nov 2022 11:07:51 +0800
Message-ID: <60f9b887-5b96-2502-e86e-06b08c0bbcd6@huawei.com>
Date:   Tue, 8 Nov 2022 11:07:51 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [PATCH v2 bpf-next 2/3] selftests/bpf: Fix incorrect ASSERT in
 the tcp_hdr_options test
To:     Martin KaFai Lau <martin.lau@linux.dev>, <bpf@vger.kernel.org>
CC:     'Alexei Starovoitov ' <ast@kernel.org>,
        'Andrii Nakryiko ' <andrii@kernel.org>,
        'Daniel Borkmann ' <daniel@iogearbox.net>,
        <netdev@vger.kernel.org>, <kernel-team@meta.com>
References: <20221107230420.4192307-1-martin.lau@linux.dev>
 <20221107230420.4192307-3-martin.lau@linux.dev>
From:   wangyufen <wangyufen@huawei.com>
In-Reply-To: <20221107230420.4192307-3-martin.lau@linux.dev>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.191]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 canpemm500010.china.huawei.com (7.192.105.118)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/11/8 7:04, Martin KaFai Lau 写道:
> From: Martin KaFai Lau <martin.lau@kernel.org>
>
> This patch fixes the incorrect ASSERT test in tcp_hdr_options during
> the CHECK to ASSERT macro cleanup.
>
> Cc: Wang Yufen <wangyufen@huawei.com>
> Fixes: 3082f8cd4ba3 ("selftests/bpf: Convert tcp_hdr_options test to ASSERT_* macros")
> Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
> ---
>   tools/testing/selftests/bpf/prog_tests/tcp_hdr_options.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/tcp_hdr_options.c b/tools/testing/selftests/bpf/prog_tests/tcp_hdr_options.c
> index 617bbce6ef8f..57191773572a 100644
> --- a/tools/testing/selftests/bpf/prog_tests/tcp_hdr_options.c
> +++ b/tools/testing/selftests/bpf/prog_tests/tcp_hdr_options.c
> @@ -485,7 +485,7 @@ static void misc(void)
>   			goto check_linum;
>   
>   		ret = read(sk_fds.passive_fd, recv_msg, sizeof(recv_msg));
> -		if (ASSERT_EQ(ret, sizeof(send_msg), "read(msg)"))
> +		if (!ASSERT_EQ(ret, sizeof(send_msg), "read(msg)"))
>   			goto check_linum;
>   	}
>   
> @@ -539,7 +539,7 @@ void test_tcp_hdr_options(void)
>   		goto skel_destroy;
>   
>   	cg_fd = test__join_cgroup(CG_NAME);
> -	if (ASSERT_GE(cg_fd, 0, "join_cgroup"))
> +	if (!ASSERT_GE(cg_fd, 0, "join_cgroup"))
>   		goto skel_destroy;
>   
>   	for (i = 0; i < ARRAY_SIZE(tests); i++) {

LGTM. Sorry for the breakage.

Acked-by: Wang Yufen <wangyufen@huawei.com>


