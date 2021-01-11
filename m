Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D4792F1A3E
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 16:56:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387766AbhAKP43 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 10:56:29 -0500
Received: from www62.your-server.de ([213.133.104.62]:36360 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727195AbhAKP42 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 10:56:28 -0500
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1kyzXm-000AEm-OE; Mon, 11 Jan 2021 16:55:46 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kyzXm-0002w9-IG; Mon, 11 Jan 2021 16:55:46 +0100
Subject: Re: [PATCH] Signed-off-by: giladreti <gilad.reti@gmail.com>
To:     giladreti <gilad.reti@gmail.com>, bpf@vger.kernel.org,
        Yonghong Song <yhs@fb.com>
Cc:     Alexei Starovoitov <ast@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210111153123.GA423936@ubuntu>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <17629073-4fab-a922-ecc3-25b019960f44@iogearbox.net>
Date:   Mon, 11 Jan 2021 16:55:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20210111153123.GA423936@ubuntu>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26046/Mon Jan 11 13:34:14 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Gilad,

On 1/11/21 4:31 PM, giladreti wrote:
> Added support for pointer to mem register spilling, to allow the verifier
> to track pointer to valid memory addresses. Such pointers are returned
> for example by a successful call of the bpf_ringbuf_reserve helper.
> 
> This patch was suggested as a solution by Yonghong Song.

The SoB should not be in subject line but as part of the commit message instead
and with proper name, e.g.

Signed-off-by: Gilad Reti <gilad.reti@gmail.com>

For subject line, please use a short summary that fits the patch prefixed with
the subsystem "bpf: [...]", see also [0] as an example. Thanks.

It would be good if you could also add a BPF selftest for this [1].

   [0] https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git/commit/?id=e22d7f05e445165e58feddb4e40cc9c0f94453bc
   [1] https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git/tree/tools/testing/selftests/bpf/
       https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git/tree/tools/testing/selftests/bpf/verifier/spill_fill.c

> ---
>   kernel/bpf/verifier.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 17270b8404f1..36af69fac591 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -2217,6 +2217,8 @@ static bool is_spillable_regtype(enum bpf_reg_type type)
>   	case PTR_TO_RDWR_BUF:
>   	case PTR_TO_RDWR_BUF_OR_NULL:
>   	case PTR_TO_PERCPU_BTF_ID:
> +	case PTR_TO_MEM:
> +	case PTR_TO_MEM_OR_NULL:
>   		return true;
>   	default:
>   		return false;
> 

