Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51CA73BF864
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 12:27:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231500AbhGHK3r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 06:29:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:55194 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231332AbhGHK3r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Jul 2021 06:29:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625740025;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7b+gK1u8OddsQzlfM4KOfl+yHtsKYVBG7gIrhWLwCzw=;
        b=i1MEWrLl1s9z+tWIivP3WJjGcYIkR08sPr1Y0HimRS+9FTcwXZp35xjTMtspfLR3ID6AyB
        BrjA5oWLPB83gtOCticG5KpAGc8MYWUMEU9/XlExDIfGZAlp/EHtEt1w+BkxvMEGoDsukT
        2dyGcPAyONUNVVo9biAFL3cA23bb/ZU=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-234-RyFNd6aMMsOKzpTw4J5uNQ-1; Thu, 08 Jul 2021 06:27:04 -0400
X-MC-Unique: RyFNd6aMMsOKzpTw4J5uNQ-1
Received: by mail-ej1-f70.google.com with SMTP id 16-20020a1709063010b029037417ca2d43so1622652ejz.5
        for <netdev@vger.kernel.org>; Thu, 08 Jul 2021 03:27:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:cc:subject:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7b+gK1u8OddsQzlfM4KOfl+yHtsKYVBG7gIrhWLwCzw=;
        b=sShIOYFtmW8mmIc5Dnxja6JnscbQbeZBjC77X830YL57mD0whJucA+W0P3HrTviL9r
         b4vz51C4j2b9azo6J9kO9lSCbeuNbWmWA/b6ks3u1T0g4+zYS7EcBstT1HTis14FxqRX
         EVKvmp6wrTkQGCHBznSrVncXJESfbJd5Hk7lPE+5zA7rky7PRiHX81i7HOkbmwGQHEhQ
         9cwaq/Ei6dT8MhVQaB2B/LLe0v6DACjKF9zQ1pIOq0FFs9aysbzlI2UcR0PZZ8+o2fqG
         ZzZT6WmJv4Vb8R4TRDdvQNag3ENQW0FZsI7d8cfJHm/DvDXQ7RbDIEsvoMZMFK+MwGUP
         la4w==
X-Gm-Message-State: AOAM533F2DSynaS9+qrjYj4McBSixLRIBiwafige09gSdA16LcpRaO9X
        iIX6IuEJBQWBcCzinRWpqm2zsZ5WlE7mfYhEBy5Ps32LPgk+mDAX5O5fEMvgKjXkw372ErDJH5B
        3AZf9bO/Hl3kYB8Dy
X-Received: by 2002:a05:6402:2044:: with SMTP id bc4mr8615870edb.307.1625740021144;
        Thu, 08 Jul 2021 03:27:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyRiACTdB39EMuyE4YQ39O4HkA5JS4syjBD27Gq8yV6rFYvY3wch0cui/0tyPYI96H9MDU5gA==
X-Received: by 2002:a05:6402:2044:: with SMTP id bc4mr8615849edb.307.1625740020951;
        Thu, 08 Jul 2021 03:27:00 -0700 (PDT)
Received: from [192.168.42.238] (3-14-107-185.static.kviknet.dk. [185.107.14.3])
        by smtp.gmail.com with ESMTPSA id a25sm40186edr.21.2021.07.08.03.26.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Jul 2021 03:27:00 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     brouer@redhat.com, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        netdev@vger.kernel.org, Abaci <abaci@linux.alibaba.com>,
        Dust Li <dust.li@linux.alibaba.com>,
        David Ahern <dsahern@kernel.org>
Subject: Re: [PATCH bpf] bpf: fix for BUG: kernel NULL pointer dereference,
 address: 0000000000000000
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>, bpf@vger.kernel.org
References: <20210708080409.73525-1-xuanzhuo@linux.alibaba.com>
Message-ID: <c314bdcc-06fc-c869-5ad8-a74173a1e6f1@redhat.com>
Date:   Thu, 8 Jul 2021 12:26:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210708080409.73525-1-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Thanks for catching this.

Cc: Ahern, are you okay with disabling this for the 
bpf_prog_test_run_xdp() infra?

I don't think the selftests/bpf (e.g. prog_tests/xdp_devmap_attach.c) 
use the bpf_prog_test_run, right?

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

On 08/07/2021 10.04, Xuan Zhuo wrote:
> These two types of xdp prog(BPF_XDP_DEVMAP, BPF_XDP_CPUMAP) will not be
> executed directly in the driver, we should not directly run these two
> XDP progs here. To run these two situations, there must be some special
> preparations, otherwise it may cause kernel exceptions.
> 
> For more reference dev_xdp_attach().
> 
> [   46.982479] BUG: kernel NULL pointer dereference, address: 0000000000000000
> [   46.984295] #PF: supervisor read access in kernel mode
> [   46.985777] #PF: error_code(0x0000) - not-present page
> [   46.987227] PGD 800000010dca4067 P4D 800000010dca4067 PUD 10dca6067 PMD 0
> [   46.989201] Oops: 0000 [#1] SMP PTI
> [   46.990304] CPU: 7 PID: 562 Comm: a.out Not tainted 5.13.0+ #44
> [   46.992001] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.14.0-0-g155821a1990b-prebuilt.qemu.org 04/01/24
> [   46.995113] RIP: 0010:___bpf_prog_run+0x17b/0x1710
> [   46.996586] Code: 49 03 14 cc e8 76 f6 fe ff e9 ad fe ff ff 0f b6 43 01 48 0f bf 4b 02 48 83 c3 08 89 c2 83 e0 0f c0 ea 04 02
> [   47.001562] RSP: 0018:ffffc900005afc58 EFLAGS: 00010246
> [   47.003115] RAX: 0000000000000000 RBX: ffffc9000023f068 RCX: 0000000000000000
> [   47.005163] RDX: 0000000000000000 RSI: 0000000000000079 RDI: ffffc900005afc98
> [   47.007135] RBP: 0000000000000000 R08: ffffc9000023f048 R09: c0000000ffffdfff
> [   47.009171] R10: 0000000000000001 R11: ffffc900005afb40 R12: ffffc900005afc98
> [   47.011172] R13: 0000000000000001 R14: 0000000000000001 R15: ffffffff825258a8
> [   47.013244] FS:  00007f04a5207580(0000) GS:ffff88842fdc0000(0000) knlGS:0000000000000000
> [   47.015705] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   47.017475] CR2: 0000000000000000 CR3: 0000000100182005 CR4: 0000000000770ee0
> [   47.019558] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [   47.021595] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [   47.023574] PKRU: 55555554
> [   47.024571] Call Trace:
> [   47.025424]  __bpf_prog_run32+0x32/0x50
> [   47.026296]  ? printk+0x53/0x6a
> [   47.027066]  ? ktime_get+0x39/0x90
> [   47.027895]  bpf_test_run.cold.28+0x23/0x123
> [   47.028866]  ? printk+0x53/0x6a
> [   47.029630]  bpf_prog_test_run_xdp+0x149/0x1d0
> [   47.030649]  __sys_bpf+0x1305/0x23d0
> [   47.031482]  __x64_sys_bpf+0x17/0x20
> [   47.032316]  do_syscall_64+0x3a/0x80
> [   47.033165]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [   47.034254] RIP: 0033:0x7f04a51364dd
> [   47.035133] Code: 00 c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 48
> [   47.038768] RSP: 002b:00007fff8f9fc518 EFLAGS: 00000213 ORIG_RAX: 0000000000000141
> [   47.040344] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f04a51364dd
> [   47.041749] RDX: 0000000000000048 RSI: 0000000020002a80 RDI: 000000000000000a
> [   47.043171] RBP: 00007fff8f9fc530 R08: 0000000002049300 R09: 0000000020000100
> [   47.044626] R10: 0000000000000004 R11: 0000000000000213 R12: 0000000000401070
> [   47.046088] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
> [   47.047579] Modules linked in:
> [   47.048318] CR2: 0000000000000000
> [   47.049120] ---[ end trace 7ad34443d5be719a ]---
> [   47.050273] RIP: 0010:___bpf_prog_run+0x17b/0x1710
> [   47.051343] Code: 49 03 14 cc e8 76 f6 fe ff e9 ad fe ff ff 0f b6 43 01 48 0f bf 4b 02 48 83 c3 08 89 c2 83 e0 0f c0 ea 04 02
> [   47.054943] RSP: 0018:ffffc900005afc58 EFLAGS: 00010246
> [   47.056068] RAX: 0000000000000000 RBX: ffffc9000023f068 RCX: 0000000000000000
> [   47.057522] RDX: 0000000000000000 RSI: 0000000000000079 RDI: ffffc900005afc98
> [   47.058961] RBP: 0000000000000000 R08: ffffc9000023f048 R09: c0000000ffffdfff
> [   47.060390] R10: 0000000000000001 R11: ffffc900005afb40 R12: ffffc900005afc98
> [   47.061803] R13: 0000000000000001 R14: 0000000000000001 R15: ffffffff825258a8
> [   47.063249] FS:  00007f04a5207580(0000) GS:ffff88842fdc0000(0000) knlGS:0000000000000000
> [   47.065070] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   47.066307] CR2: 0000000000000000 CR3: 0000000100182005 CR4: 0000000000770ee0
> [   47.067747] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [   47.069217] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [   47.070652] PKRU: 55555554
> [   47.071318] Kernel panic - not syncing: Fatal exception
> [   47.072854] Kernel Offset: disabled
> [   47.073683] ---[ end Kernel panic - not syncing: Fatal exception ]---
> 
> Reported-by: Abaci <abaci@linux.alibaba.com>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> Reviewed-by: Dust Li <dust.li@linux.alibaba.com>
> ---
>   net/bpf/test_run.c | 6 ++++++
>   1 file changed, 6 insertions(+)
> 
> diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
> index aa47af349ba8..17227e0b277b 100644
> --- a/net/bpf/test_run.c
> +++ b/net/bpf/test_run.c
> @@ -701,6 +701,12 @@ int bpf_prog_test_run_xdp(struct bpf_prog *prog, const union bpf_attr *kattr,
>   	void *data;
>   	int ret;
>   
> +	if (prog->expected_attach_type == BPF_XDP_DEVMAP)
> +		return -EINVAL;
> +
> +	if (prog->expected_attach_type == BPF_XDP_CPUMAP)
> +		return -EINVAL;
> +
>   	if (kattr->test.ctx_in || kattr->test.ctx_out)
>   		return -EINVAL;
>   

