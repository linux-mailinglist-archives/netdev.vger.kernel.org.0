Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C089340A18
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 17:24:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232149AbhCRQXe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 12:23:34 -0400
Received: from www62.your-server.de ([213.133.104.62]:49652 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232172AbhCRQXS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 12:23:18 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1lMvQT-000Cni-EI; Thu, 18 Mar 2021 17:23:09 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1lMvQT-0006Yq-4f; Thu, 18 Mar 2021 17:23:09 +0100
Subject: Re: [PATCH] selftests/bpf: fix warning comparing pointer to 0
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>, shuah@kernel.org
Cc:     ast@kernel.org, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, linux-kselftest@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1616032552-39866-1-git-send-email-jiapeng.chong@linux.alibaba.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <4983305a-3119-bb4b-bb51-520ed5bd28ac@iogearbox.net>
Date:   Thu, 18 Mar 2021 17:23:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1616032552-39866-1-git-send-email-jiapeng.chong@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26112/Thu Mar 18 12:08:11 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/18/21 2:55 AM, Jiapeng Chong wrote:
> Fix the following coccicheck warning:
> 
> ./tools/testing/selftests/bpf/progs/fentry_test.c:76:15-16: WARNING
> comparing pointer to 0.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> ---
>   tools/testing/selftests/bpf/progs/fentry_test.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/bpf/progs/fentry_test.c b/tools/testing/selftests/bpf/progs/fentry_test.c
> index 5f645fd..d4247d6 100644
> --- a/tools/testing/selftests/bpf/progs/fentry_test.c
> +++ b/tools/testing/selftests/bpf/progs/fentry_test.c
> @@ -64,7 +64,7 @@ struct bpf_fentry_test_t {
>   SEC("fentry/bpf_fentry_test7")
>   int BPF_PROG(test7, struct bpf_fentry_test_t *arg)
>   {
> -	if (arg == 0)
> +	if (!arg)
>   		test7_result = 1;
>   	return 0;
>   }
> @@ -73,7 +73,7 @@ int BPF_PROG(test7, struct bpf_fentry_test_t *arg)
>   SEC("fentry/bpf_fentry_test8")
>   int BPF_PROG(test8, struct bpf_fentry_test_t *arg)
>   {
> -	if (arg->a == 0)
> +	if (!arg->a)
>   		test8_result = 1;
>   	return 0;
>   }
> 

This doesn't apply. Please rebase against bpf-next tree, and also make sure to
squash any other such patches into a single one.
