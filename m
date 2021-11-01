Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52B3C441D8C
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 16:45:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232619AbhKAPrc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 11:47:32 -0400
Received: from www62.your-server.de ([213.133.104.62]:41768 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbhKAPrc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 11:47:32 -0400
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1mhZUS-000Eo3-QG; Mon, 01 Nov 2021 16:44:52 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1mhZUS-0002JX-DH; Mon, 01 Nov 2021 16:44:52 +0100
Subject: Re: [PATCH bpf-next v3] bpf: Change value of MAX_TAIL_CALL_CNT from
 32 to 33
To:     Tiezhu Yang <yangtiezhu@loongson.cn>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xuefeng Li <lixuefeng@loongson.cn>,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, illusionist.neo@gmail.com,
        zlim.lnx@gmail.com, naveen.n.rao@linux.ibm.com,
        luke.r.nels@gmail.com, xi.wang@gmail.com, bjorn@kernel.org,
        iii@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        udknight@gmail.com, davem@davemloft.net
References: <1635508430-2918-1-git-send-email-yangtiezhu@loongson.cn>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <f80b4756-8e74-6ee8-c367-30f8d2771bfb@iogearbox.net>
Date:   Mon, 1 Nov 2021 16:44:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1635508430-2918-1-git-send-email-yangtiezhu@loongson.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26340/Mon Nov  1 09:21:46 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/29/21 1:53 PM, Tiezhu Yang wrote:
[...]
> diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> index b6c72af..6d10292 100644
> --- a/kernel/bpf/core.c
> +++ b/kernel/bpf/core.c
> @@ -1565,7 +1565,8 @@ static u64 ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn)
>   
>   		if (unlikely(index >= array->map.max_entries))
>   			goto out;
> -		if (unlikely(tail_call_cnt > MAX_TAIL_CALL_CNT))
> +
> +		if (unlikely(tail_call_cnt == MAX_TAIL_CALL_CNT))
>   			goto out;
>   

Why making it less robust by going with == rather than >= ?
