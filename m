Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49F6F72BAA
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 11:45:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726347AbfGXJph (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 05:45:37 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41676 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725826AbfGXJph (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 05:45:37 -0400
Received: by mail-wr1-f65.google.com with SMTP id c2so43003489wrm.8;
        Wed, 24 Jul 2019 02:45:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=EuUOzftZKTGgZK3sBI8OojHgaAFEiCuf7+EbcR0NONI=;
        b=trfPnKfDTn1SPOrLLlOEcuQayL04NvEE+mJLTsW/n7grI1JVM4WMUFllaYZaAewgx7
         BGjtsWOqHE/ati2iNYKpUmeUyW5VTm6XxkiPjgK9QEKzdw0rOtweF6Rn3fdMeORmLfMW
         eLMKBw8fl62VbZCExb78RRjEeNrutFs+M6l/OQUuzVCKEkDqe0jVBKNTwnWTWDU//Shi
         4fldUsRPD8H3Ckw1lRBhGCbsDcAPhJJ7ItE+Tg6KdXMxqTo84qkhJ3Dq+90QnEFH6UBL
         /d85YwKHwRsUi/LpIrE0NedBj/YdvIrHkuJ11xJGGBU6FWgYRNbWJGJsHfKZ5P/ngGpJ
         aqLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EuUOzftZKTGgZK3sBI8OojHgaAFEiCuf7+EbcR0NONI=;
        b=rU4+MPoBzyEyUKXTW2BzKyUQc/NTzS+Swur1BKjTqatiguLlgKLyxZs5VzGHOrjRtL
         k/GRAqEC+oudtFwL/YR+G0Djy7tTCpAkz8UBfb7YtY0XERTc2URAEi4YgB6uQyvZAdJm
         ifzhc8cOXcvpj2FqImS3HLFCMdRxyNVUVmDR3BD9dzj1fTvgOn6rnzKhJpWzgOcHGbfw
         p6KVsOF/92Nm21uWfqHOTRxPZAKZObg57wSFn0i55AfWtw6K58lVN/Sa2hgy/BUSe3ht
         bI3CYSTTThxNewYoVjeoMZ7gRWAxq8Lfmqyx7S8Y4fAEi3A0F9tXWoz+A7x1CKSesP7E
         fvVA==
X-Gm-Message-State: APjAAAWIvPkxGvda1+Rnm72clWuHrqcbLa99xaFZW/8UMW2NJWcJ2UJY
        zMH5kHfFDVwMD6JgthNYHwg5cJr3
X-Google-Smtp-Source: APXvYqz9AhCKkDRDlsb7ewH/dWayiEsgjJPX0yWYn31XevkvNHAt0wCMaHKSgcYliPlQI4JFOJiTZA==
X-Received: by 2002:a5d:438e:: with SMTP id i14mr83519426wrq.122.1563961533977;
        Wed, 24 Jul 2019 02:45:33 -0700 (PDT)
Received: from [192.168.8.147] (200.150.22.93.rev.sfr.net. [93.22.150.200])
        by smtp.gmail.com with ESMTPSA id u13sm54302946wrq.62.2019.07.24.02.45.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Jul 2019 02:45:33 -0700 (PDT)
Subject: Re: [PATCH 4.4 stable net] net: tcp: Fix use-after-free in
 tcp_write_xmit
To:     Mao Wenan <maowenan@huawei.com>, davem@davemloft.net,
        gregkh@linuxfoundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20190724091715.137033-1-maowenan@huawei.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <2e09f4d1-8a47-27e9-60f9-63d3b19a98ec@gmail.com>
Date:   Wed, 24 Jul 2019 11:45:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190724091715.137033-1-maowenan@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/24/19 11:17 AM, Mao Wenan wrote:
> There is one report about tcp_write_xmit use-after-free with version 4.4.136:
> 
> BUG: KASAN: use-after-free in tcp_skb_pcount include/net/tcp.h:796 [inline]
> BUG: KASAN: use-after-free in tcp_init_tso_segs net/ipv4/tcp_output.c:1619 [inline]
> BUG: KASAN: use-after-free in tcp_write_xmit+0x3fc2/0x4cb0 net/ipv4/tcp_output.c:2056
> Read of size 2 at addr ffff8801d6fc87b0 by task syz-executor408/4195
> 
> CPU: 0 PID: 4195 Comm: syz-executor408 Not tainted 4.4.136-gfb7e319 #59
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>  0000000000000000 7d8f38ecc03be946 ffff8801d73b7710 ffffffff81e0edad
>  ffffea00075bf200 ffff8801d6fc87b0 0000000000000000 ffff8801d6fc87b0
>  dffffc0000000000 ffff8801d73b7748 ffffffff815159b6 ffff8801d6fc87b0
> Call Trace:
>  [<ffffffff81e0edad>] __dump_stack lib/dump_stack.c:15 [inline]
>  [<ffffffff81e0edad>] dump_stack+0xc1/0x124 lib/dump_stack.c:51
>  [<ffffffff815159b6>] print_address_description+0x6c/0x216 mm/kasan/report.c:252
>  [<ffffffff81515cd5>] kasan_report_error mm/kasan/report.c:351 [inline]
>  [<ffffffff81515cd5>] kasan_report.cold.7+0x175/0x2f7 mm/kasan/report.c:408
>  [<ffffffff814f9784>] __asan_report_load2_noabort+0x14/0x20 mm/kasan/report.c:427
>  [<ffffffff83286582>] tcp_skb_pcount include/net/tcp.h:796 [inline]
>  [<ffffffff83286582>] tcp_init_tso_segs net/ipv4/tcp_output.c:1619 [inline]
>  [<ffffffff83286582>] tcp_write_xmit+0x3fc2/0x4cb0 net/ipv4/tcp_output.c:2056
>  [<ffffffff83287a40>] __tcp_push_pending_frames+0xa0/0x290 net/ipv4/tcp_output.c:2307
>  [<ffffffff8328e966>] tcp_send_fin+0x176/0xab0 net/ipv4/tcp_output.c:2883
>  [<ffffffff8324c0d0>] tcp_close+0xca0/0xf70 net/ipv4/tcp.c:2112
>  [<ffffffff832f8d0f>] inet_release+0xff/0x1d0 net/ipv4/af_inet.c:435
>  [<ffffffff82f1a156>] sock_release+0x96/0x1c0 net/socket.c:586
>  [<ffffffff82f1a296>] sock_close+0x16/0x20 net/socket.c:1037
>  [<ffffffff81522da5>] __fput+0x235/0x6f0 fs/file_table.c:208
>  [<ffffffff815232e5>] ____fput+0x15/0x20 fs/file_table.c:244
>  [<ffffffff8118bd7f>] task_work_run+0x10f/0x190 kernel/task_work.c:115
>  [<ffffffff81135285>] exit_task_work include/linux/task_work.h:21 [inline]
>  [<ffffffff81135285>] do_exit+0x9e5/0x26b0 kernel/exit.c:759
>  [<ffffffff8113b1d1>] do_group_exit+0x111/0x330 kernel/exit.c:889
>  [<ffffffff8115e5cc>] get_signal+0x4ec/0x14b0 kernel/signal.c:2321
>  [<ffffffff8100e02b>] do_signal+0x8b/0x1d30 arch/x86/kernel/signal.c:712
>  [<ffffffff8100360a>] exit_to_usermode_loop+0x11a/0x160 arch/x86/entry/common.c:248
>  [<ffffffff81006535>] prepare_exit_to_usermode arch/x86/entry/common.c:283 [inline]
>  [<ffffffff81006535>] syscall_return_slowpath+0x1b5/0x1f0 arch/x86/entry/common.c:348
>  [<ffffffff838c29b5>] int_ret_from_sys_call+0x25/0xa3
> 
> Allocated by task 4194:
>  [<ffffffff810341d6>] save_stack_trace+0x26/0x50 arch/x86/kernel/stacktrace.c:63
>  [<ffffffff814f8873>] save_stack+0x43/0xd0 mm/kasan/kasan.c:512
>  [<ffffffff814f8b57>] set_track mm/kasan/kasan.c:524 [inline]
>  [<ffffffff814f8b57>] kasan_kmalloc+0xc7/0xe0 mm/kasan/kasan.c:616
>  [<ffffffff814f9122>] kasan_slab_alloc+0x12/0x20 mm/kasan/kasan.c:554
>  [<ffffffff814f4c1e>] slab_post_alloc_hook mm/slub.c:1349 [inline]
>  [<ffffffff814f4c1e>] slab_alloc_node mm/slub.c:2615 [inline]
>  [<ffffffff814f4c1e>] slab_alloc mm/slub.c:2623 [inline]
>  [<ffffffff814f4c1e>] kmem_cache_alloc+0xbe/0x2a0 mm/slub.c:2628
>  [<ffffffff82f380a6>] kmem_cache_alloc_node include/linux/slab.h:350 [inline]
>  [<ffffffff82f380a6>] __alloc_skb+0xe6/0x600 net/core/skbuff.c:218
>  [<ffffffff832466c3>] alloc_skb_fclone include/linux/skbuff.h:856 [inline]
>  [<ffffffff832466c3>] sk_stream_alloc_skb+0xa3/0x5d0 net/ipv4/tcp.c:833
>  [<ffffffff83249164>] tcp_sendmsg+0xd34/0x2b00 net/ipv4/tcp.c:1178
>  [<ffffffff83300ef3>] inet_sendmsg+0x203/0x4d0 net/ipv4/af_inet.c:755
>  [<ffffffff82f1e1fc>] sock_sendmsg_nosec net/socket.c:625 [inline]
>  [<ffffffff82f1e1fc>] sock_sendmsg+0xcc/0x110 net/socket.c:635
>  [<ffffffff82f1eedc>] SYSC_sendto+0x21c/0x370 net/socket.c:1665
>  [<ffffffff82f21560>] SyS_sendto+0x40/0x50 net/socket.c:1633
>  [<ffffffff838c2825>] entry_SYSCALL_64_fastpath+0x22/0x9e
> 
> Freed by task 4194:
>  [<ffffffff810341d6>] save_stack_trace+0x26/0x50 arch/x86/kernel/stacktrace.c:63
>  [<ffffffff814f8873>] save_stack+0x43/0xd0 mm/kasan/kasan.c:512
>  [<ffffffff814f91a2>] set_track mm/kasan/kasan.c:524 [inline]
>  [<ffffffff814f91a2>] kasan_slab_free+0x72/0xc0 mm/kasan/kasan.c:589
>  [<ffffffff814f632e>] slab_free_hook mm/slub.c:1383 [inline]
>  [<ffffffff814f632e>] slab_free_freelist_hook mm/slub.c:1405 [inline]
>  [<ffffffff814f632e>] slab_free mm/slub.c:2859 [inline]
>  [<ffffffff814f632e>] kmem_cache_free+0xbe/0x340 mm/slub.c:2881
>  [<ffffffff82f3527f>] kfree_skbmem+0xcf/0x100 net/core/skbuff.c:635
>  [<ffffffff82f372fd>] __kfree_skb+0x1d/0x20 net/core/skbuff.c:676
>  [<ffffffff83288834>] sk_wmem_free_skb include/net/sock.h:1447 [inline]
>  [<ffffffff83288834>] tcp_write_queue_purge include/net/tcp.h:1460 [inline]
>  [<ffffffff83288834>] tcp_connect_init net/ipv4/tcp_output.c:3122 [inline]
>  [<ffffffff83288834>] tcp_connect+0xb24/0x30c0 net/ipv4/tcp_output.c:3261
>  [<ffffffff8329b991>] tcp_v4_connect+0xf31/0x1890 net/ipv4/tcp_ipv4.c:246
>  [<ffffffff832f9ca9>] __inet_stream_connect+0x2a9/0xc30 net/ipv4/af_inet.c:615
>  [<ffffffff832fa685>] inet_stream_connect+0x55/0xa0 net/ipv4/af_inet.c:676
>  [<ffffffff82f1eb78>] SYSC_connect+0x1b8/0x300 net/socket.c:1557
>  [<ffffffff82f214b4>] SyS_connect+0x24/0x30 net/socket.c:1538
>  [<ffffffff838c2825>] entry_SYSCALL_64_fastpath+0x22/0x9e
> 
> Syzkaller reproducer():
> r0 = socket$packet(0x11, 0x3, 0x300)
> r1 = socket$inet_tcp(0x2, 0x1, 0x0)
> bind$inet(r1, &(0x7f0000000300)={0x2, 0x4e21, @multicast1}, 0x10)
> connect$inet(r1, &(0x7f0000000140)={0x2, 0x1000004e21, @loopback}, 0x10)
> recvmmsg(r1, &(0x7f0000001e40)=[{{0x0, 0x0, &(0x7f0000000100)=[{&(0x7f00000005c0)=""/88, 0x58}], 0x1}}], 0x1, 0x40000000, 0x0)
> sendto$inet(r1, &(0x7f0000000000)="e2f7ad5b661c761edf", 0x9, 0x8080, 0x0, 0x0)
> r2 = fcntl$dupfd(r1, 0x0, r0)
> connect$unix(r2, &(0x7f00000001c0)=@file={0x0, './file0\x00'}, 0x6e)
> 
> C repro link: https://syzkaller.appspot.com/text?tag=ReproC&x=14db474f800000
> 
> This is because when tcp_connect_init call tcp_write_queue_purge, it will
> kfree all the skb in the write_queue, but the sk->sk_send_head forget to set NULL,
> then tcp_write_xmit try to send skb, which has freed in tcp_write_queue_purge, UAF happens.
> 
> Signed-off-by: Mao Wenan <maowenan@huawei.com>
> ---
>  include/net/tcp.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/include/net/tcp.h b/include/net/tcp.h
> index bf8a0dae977a..8f8aace28cf8 100644
> --- a/include/net/tcp.h
> +++ b/include/net/tcp.h
> @@ -1457,6 +1457,7 @@ static inline void tcp_write_queue_purge(struct sock *sk)
>  
>  	while ((skb = __skb_dequeue(&sk->sk_write_queue)) != NULL)
>  		sk_wmem_free_skb(sk, skb);
> +	sk->sk_send_head = NULL;
>  	sk_mem_reclaim(sk);
>  	tcp_clear_all_retrans_hints(tcp_sk(sk));
>  	inet_csk(sk)->icsk_backoff = 0;
> 

This is strange, because tcp_init_send_head() is called from tcp_disconnect()
which is the syzkaller way to trigger this kind of bugs.


I suspect there is another root cause.


