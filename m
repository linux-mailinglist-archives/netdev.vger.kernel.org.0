Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9ABBF4C81E3
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 05:03:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231261AbiCAEDm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 23:03:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230272AbiCAEDk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 23:03:40 -0500
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D8604BFDC;
        Mon, 28 Feb 2022 20:03:00 -0800 (PST)
Received: by mail-io1-xd35.google.com with SMTP id w7so17175009ioj.5;
        Mon, 28 Feb 2022 20:03:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=QbGiC4M7yjcGNMo3K5OFtxH8Uhk9ttEp8MVhuXYPVJw=;
        b=RS5TgXUTmZdxWOKt9lpX1fSbzxAYg63DwcoVNE25UuVL6u8najpILJVkFwCj4B3Z0i
         w45wLPscmhSv8x63H1OW5wim5f7OYOa0U2YbTN3bDVxmXHYYLOrV+nnG2GGSoF5lnic1
         n9Wp8kZlpXR6Wm8cxHKFI1tHJ/iQuCSmmU/KFAkRWZLfjELvSeBUoxvpPadIvGct9/MN
         BxDcSknYMAxNPh4XwhsnbM+wVu7uFRoJjg571mk9kaVzzNlcgTfKo190hikzJQhh/IW+
         ccULwGj/4K+hSpGdfSPwWasWOGkdqf0dGj8mODn6/561y17RpD1xiy/8uBHH/pmt4WGz
         jL8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=QbGiC4M7yjcGNMo3K5OFtxH8Uhk9ttEp8MVhuXYPVJw=;
        b=12Tlabq9btazX+Bm5zqnARBh07ldRusul9a5CS3NB0lO2r8a91u+ZJkaPQD22z4zGH
         PRnl5FTq1OVUevO3vNlucH3erXHuOY1gWxn1Vjrh7TxFAuAVJAPgQ03NmM5TL+vbV/Wp
         6eyW71Ff7wOJ+RqAwa/KOS2WwzDL9uSzEQj7JV8ioPCTfHRpujne+YHbWEwbmBnayrtE
         Vxl8vsr3ljdNWfKkfpOPKsU2WRj0LRpTiRHC2H+l3I5fuF1BUKYgLkp0pEwUOypPcWnH
         iLtZmWmgAczNSSpJJiLns/EdlRhqfq9QXG/kXlVpwtVdad4lKxigjtnmui2DWyFVs17o
         OA/A==
X-Gm-Message-State: AOAM532M+5IQhbIKz3su2sMaf0q+LNHLPoplwBQMDT/OnXI2YsV4hIZQ
        +DcIYVvxmewywMGt/nShUXA=
X-Google-Smtp-Source: ABdhPJywKwvEilzemENObt86ACBcCDnzan6rjFida8BY+GPH51BGw+1D/vzcYN1WScKxIsckJdR0Jw==
X-Received: by 2002:a02:a1c7:0:b0:314:cc99:3c4f with SMTP id o7-20020a02a1c7000000b00314cc993c4fmr19285817jah.53.1646107379809;
        Mon, 28 Feb 2022 20:02:59 -0800 (PST)
Received: from localhost ([99.197.200.79])
        by smtp.gmail.com with ESMTPSA id p13-20020a056e0206cd00b002c23c551420sm7078911ils.36.2022.02.28.20.02.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Feb 2022 20:02:59 -0800 (PST)
Date:   Mon, 28 Feb 2022 20:02:53 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Wang Yufen <wangyufen@huawei.com>, john.fastabend@gmail.com,
        daniel@iogearbox.net, jakub@cloudflare.com, lmb@cloudflare.com,
        davem@davemloft.net, bpf@vger.kernel.org
Cc:     edumazet@google.com, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, ast@kernel.org, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, Wang Yufen <wangyufen@huawei.com>
Message-ID: <621d9aed541f_8c47920864@john.notmuch>
In-Reply-To: <20220225014929.942444-3-wangyufen@huawei.com>
References: <20220225014929.942444-1-wangyufen@huawei.com>
 <20220225014929.942444-3-wangyufen@huawei.com>
Subject: RE: [PATCH bpf-next 2/4] bpf, sockmap: Fix memleak in tcp_bpf_sendmsg
 while sk msg is full
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wang Yufen wrote:
> If tcp_bpf_sendmsg() is running while sk msg is full, sk_msg_alloc()
> returns -ENOSPC, tcp_bpf_sendmsg() goto wait for memory. If partial memory
> has been alloced by sk_msg_alloc(), that is, msg_tx->sg.size is greater
> than osize after sk_msg_alloc(), memleak occurs. To fix we use
> sk_msg_trim() to release the allocated memory, then goto wait for memory.

Small nit, "sk_msg_alloc() returns -ENOSPC" should be something like, "when
sk_msg_alloc() returns -ENOMEM error,..." That error path is from ENOMEM not
the ENOSPC.

But nice find thanks! I think we might have seen this in a couple cases on
our side as well.

> 
> This issue can cause the following info:
> WARNING: CPU: 3 PID: 7950 at net/core/stream.c:208 sk_stream_kill_queues+0xd4/0x1a0
> Call Trace:
>  <TASK>
>  inet_csk_destroy_sock+0x55/0x110
>  __tcp_close+0x279/0x470
>  tcp_close+0x1f/0x60
>  inet_release+0x3f/0x80
>  __sock_release+0x3d/0xb0
>  sock_close+0x11/0x20
>  __fput+0x92/0x250
>  task_work_run+0x6a/0xa0
>  do_exit+0x33b/0xb60
>  do_group_exit+0x2f/0xa0
>  get_signal+0xb6/0x950
>  arch_do_signal_or_restart+0xac/0x2a0
>  exit_to_user_mode_prepare+0xa9/0x200
>  syscall_exit_to_user_mode+0x12/0x30
>  do_syscall_64+0x46/0x80
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
>  </TASK>
> 
> WARNING: CPU: 3 PID: 2094 at net/ipv4/af_inet.c:155 inet_sock_destruct+0x13c/0x260
> Call Trace:
>  <TASK>
>  __sk_destruct+0x24/0x1f0
>  sk_psock_destroy+0x19b/0x1c0
>  process_one_work+0x1b3/0x3c0
>  kthread+0xe6/0x110
>  ret_from_fork+0x22/0x30
>  </TASK>
> 
> Fixes: 604326b41a6f ("bpf, sockmap: convert to generic sk_msg interface")
> Signed-off-by: Wang Yufen <wangyufen@huawei.com>
> ---
>  net/ipv4/tcp_bpf.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
> index 9b9b02052fd3..ac9f491cc139 100644
> --- a/net/ipv4/tcp_bpf.c
> +++ b/net/ipv4/tcp_bpf.c
> @@ -421,8 +421,10 @@ static int tcp_bpf_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
>  		osize = msg_tx->sg.size;
>  		err = sk_msg_alloc(sk, msg_tx, msg_tx->sg.size + copy, msg_tx->sg.end - 1);
>  		if (err) {
> -			if (err != -ENOSPC)
> +			if (err != -ENOSPC) {
> +				sk_msg_trim(sk, msg_tx, osize);
>  				goto wait_for_memory;
> +			}
>  			enospc = true;
>  			copy = msg_tx->sg.size - osize;
>  		}
> -- 
> 2.25.1
> 

Acked-by: John Fastabend <john.fastabend@gmail.com>
