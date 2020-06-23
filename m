Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2458A2055E2
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 17:29:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732940AbgFWP3k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 11:29:40 -0400
Received: from www62.your-server.de ([213.133.104.62]:58380 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732920AbgFWP3j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 11:29:39 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jnkri-00019m-2I; Tue, 23 Jun 2020 17:29:38 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jnkrh-0002CW-Pu; Tue, 23 Jun 2020 17:29:37 +0200
Subject: Re: [PATCH bpf-next 2/3] bpf: allow %pB in bpf_seq_printf()
To:     Song Liu <songliubraving@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     ast@kernel.org, kernel-team@fb.com, john.fastabend@gmail.com,
        kpsingh@chromium.org
References: <20200623070802.2310018-1-songliubraving@fb.com>
 <20200623070802.2310018-3-songliubraving@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <677dc8f7-d4e9-7717-5def-935340a23cd2@iogearbox.net>
Date:   Tue, 23 Jun 2020 17:29:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200623070802.2310018-3-songliubraving@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25852/Tue Jun 23 15:09:58 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/23/20 9:08 AM, Song Liu wrote:
> This makes it easy to dump stack trace with bpf_seq_printf().
> 
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>   kernel/trace/bpf_trace.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index 2c13bcb5c2bce..ced3176801ae8 100644
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -636,7 +636,8 @@ BPF_CALL_5(bpf_seq_printf, struct seq_file *, m, char *, fmt, u32, fmt_size,
>   		if (fmt[i] == 'p') {
>   			if (fmt[i + 1] == 0 ||
>   			    fmt[i + 1] == 'K' ||
> -			    fmt[i + 1] == 'x') {
> +			    fmt[i + 1] == 'x' ||
> +			    fmt[i + 1] == 'B') {
>   				/* just kernel pointers */
>   				params[fmt_cnt] = args[fmt_cnt];
>   				fmt_cnt++;
> 

Why only bpf_seq_printf(), what about bpf_trace_printk()?
