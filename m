Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9E094D6A99
	for <lists+netdev@lfdr.de>; Sat, 12 Mar 2022 00:26:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229621AbiCKWsU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 17:48:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbiCKWsI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 17:48:08 -0500
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C40D62B8527;
        Fri, 11 Mar 2022 14:22:58 -0800 (PST)
Received: by mail-il1-x12c.google.com with SMTP id d3so6973792ilr.10;
        Fri, 11 Mar 2022 14:22:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=l9ueQ6sbNeiCyD3vc7vLJPQmjp7y1xfh34Qc674GbVw=;
        b=OvQxiqMI843DzSOYaQ7GUM3pX/tPVSRN8MVStlHX948VIL5lFjUOJ7SHuCx3S6ig/0
         wPv2HUgdIogdFtKsL7JfptQ+tg+/1aPa8b+Seg1yBf3r3a9oea579yrk8xNOP9zcoHUy
         Za22kkQE7KEREB1BpnO8j2Ljz8XF5TxvW8r0WrCRNliVfEVP103CmfRMZy38PHHL8OVA
         w5N7Ji7o4Tp6YKChK6Dq4QwfOlKRb8bbVQCYM8TDmr0rpJ9OYgoIpU0i/rJ2WEByvJQw
         gsbf7GOCC7MiA6Y9AVXydQVO4IOzq0u9ZWXc2UJgfcQ6+3Rdz/NNKN0wq5Kw4W1HKXCG
         Tuyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=l9ueQ6sbNeiCyD3vc7vLJPQmjp7y1xfh34Qc674GbVw=;
        b=3FNot7EU0GFdok6znrYvQmyEsIpBrU34GkoR95xSh8FTtsp497UYMno0x70HlB1UaZ
         Oczc9a7X2mw7QykYB/0aJiB6jlZPpdG0d1k9Ct4tQGkZ6XhMh3n79Yw7VvvjGUqRebTy
         wHtNvczvhLPruRiuSV0aQz0o920jzIuLLKgPSfhVeFyY+Rk9smlOW9FI1Kk7UDl9AvmK
         eT0ieRLUNeIMbg2yQ5iclOu5a6LlLP/AShzKXhLO2ZPB4LCAnQOcYmb56uW0fDO1IT5j
         HnFKxGQcR0fZ1z5QiiB7IoaGyn/TkHllcgTnFKeSJ+9cXKCvzJRK+LTa4cNaEuI0UN5h
         X08A==
X-Gm-Message-State: AOAM530rGd3xr6ixOjmTUMfoanicrrMTdoJAInyKTK4J8wipopKbs2WH
        eFIGZNg1Fu+6dN5uwRd3N2QDX+XD9cGNlw==
X-Google-Smtp-Source: ABdhPJw6fYf21s38ve8M4r0XTkkmlQQoLA8MvYHjEueqRTVPBsyeh5v2hgBxFOz3WTNJcWn4YJo41A==
X-Received: by 2002:a05:6602:26d3:b0:63d:aa17:8742 with SMTP id g19-20020a05660226d300b0063daa178742mr9649602ioo.198.1647035728083;
        Fri, 11 Mar 2022 13:55:28 -0800 (PST)
Received: from localhost ([99.197.200.79])
        by smtp.gmail.com with ESMTPSA id a4-20020a5d9544000000b00640a6eb6e1esm4902810ios.53.2022.03.11.13.55.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Mar 2022 13:55:27 -0800 (PST)
Date:   Fri, 11 Mar 2022 13:55:19 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Wang Yufen <wangyufen@huawei.com>, john.fastabend@gmail.com,
        daniel@iogearbox.net, jakub@cloudflare.com, lmb@cloudflare.com,
        davem@davemloft.net, bpf@vger.kernel.org
Cc:     edumazet@google.com, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, ast@kernel.org, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, Wang Yufen <wangyufen@huawei.com>
Message-ID: <622bc54747627_8327a20838@john.notmuch>
In-Reply-To: <20220304081145.2037182-3-wangyufen@huawei.com>
References: <20220304081145.2037182-1-wangyufen@huawei.com>
 <20220304081145.2037182-3-wangyufen@huawei.com>
Subject: RE: [PATCH bpf-next v3 2/4] bpf, sockmap: Fix memleak in
 tcp_bpf_sendmsg while sk msg is full
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
> If tcp_bpf_sendmsg() is running while sk msg is full. When sk_msg_alloc()
> returns -ENOMEM error, tcp_bpf_sendmsg() goes to wait_for_memory. If partial
> memory has been alloced by sk_msg_alloc(), that is, msg_tx->sg.size is
> greater than osize after sk_msg_alloc(), memleak occurs. To fix we use
> sk_msg_trim() to release the allocated memory, then goto wait for memory.
> 
> Other call paths of sk_msg_alloc() have the similar issue, such as
> tls_sw_sendmsg(), so handle sk_msg_trim logic inside sk_msg_alloc(),
> as Cong Wang suggested.
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
> Acked-by: John Fastabend <john.fastabend@gmail.com>
> ---

Still LGTM Thanks! Next time drop the ack though if you rewrite the patch
this much. Appreciate the fixes and helpful commit messages though.
