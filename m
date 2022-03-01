Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0AE04C8236
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 05:21:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231621AbiCAEVl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 23:21:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232344AbiCAEVc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 23:21:32 -0500
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A21C745792;
        Mon, 28 Feb 2022 20:20:24 -0800 (PST)
Received: by mail-io1-xd32.google.com with SMTP id f14so17232760ioz.1;
        Mon, 28 Feb 2022 20:20:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=07HnEEgToDdygcTpNtrJiWX779yx2dMR9E7riCBukew=;
        b=R3z1+khq1h/yHvt78Jhz2mIgkQgXCUXD0CJMhbsD/G0sUi2cMQhIJhPIvdj3uRstaw
         8rgHkwyaboFeKezwSDr7fJYMdt1MyX4KF1xb0Fk2t+ba+lHCTN0J7bMcDGvAnP4z9vFQ
         /BausehbVzRUNA6TrHqOmaGuvD3n4a21PFKXC1wZdHw1vd9UuzlyzpvjoN9PofMoA9nD
         ftNJdA1xqRICIuzKuMRDM2yz4vBRU0/Rz/mlHwD/Q1LkMBnv9FmXqFzc0o7Su7J6x6DG
         MFvCiaNKoyH+ccLsPPmuqIM1ogwk5W3k3pBmb71AZPbIXR82H2ogvIFPqB1UF4Syl5rj
         uhYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=07HnEEgToDdygcTpNtrJiWX779yx2dMR9E7riCBukew=;
        b=7keLbWf4qArIiqiCASh+Kz0Hm9JYIjktjfeh8JneP0tO70wootINxZThRTdLPLzw05
         9QzCIK7a1kMS1WjAJ1/VCScWtVDpBsjVeXZLY7JGQvU7Ti8dOu3AJGegXagoan3Pq+6w
         fkz8A9bV7XOd8S0LWJdF3XYIwlTWDyJ9Eb9HHtvzc+jCkP6h9FwEXyB6Sf26pLHe6hE0
         m9ch+kWL80JsuQM+Kd0ywDpulKW+3JbwZn+vDco+ycieQwnrdlRpbytRLCUI4SehFbmT
         RjbFKeMnEnzCVZPxs6WhRWutqRHD+kgpXjFO8ltJ1tXIOjw7CFnD77usLi+oQBq05vAh
         egnA==
X-Gm-Message-State: AOAM532LjD6QHpa9HdA+K+xHZX0Mxo9kObWIS6xumyWgkT4ywQ+sG+3+
        LL4pMMJ07+PXk5l/xYjdXS4=
X-Google-Smtp-Source: ABdhPJwt39slxO8NSSQsPIrm0AEdPeYiIJW4UM+t3ojCoHA4vl1paC6S6rbh/5YBeWkfpotI8ACq7w==
X-Received: by 2002:a05:6638:1252:b0:313:ee0d:4564 with SMTP id o18-20020a056638125200b00313ee0d4564mr19823180jas.43.1646108424063;
        Mon, 28 Feb 2022 20:20:24 -0800 (PST)
Received: from localhost ([99.197.200.79])
        by smtp.gmail.com with ESMTPSA id g4-20020a92cda4000000b002c24724f23csm7153153ild.13.2022.02.28.20.20.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Feb 2022 20:20:23 -0800 (PST)
Date:   Mon, 28 Feb 2022 20:20:11 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Wang Yufen <wangyufen@huawei.com>, john.fastabend@gmail.com,
        daniel@iogearbox.net, jakub@cloudflare.com, lmb@cloudflare.com,
        davem@davemloft.net, bpf@vger.kernel.org
Cc:     edumazet@google.com, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, ast@kernel.org, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, Wang Yufen <wangyufen@huawei.com>
Message-ID: <621d9efbec66f_8c479208eb@john.notmuch>
In-Reply-To: <20220225014929.942444-4-wangyufen@huawei.com>
References: <20220225014929.942444-1-wangyufen@huawei.com>
 <20220225014929.942444-4-wangyufen@huawei.com>
Subject: RE: [PATCH bpf-next 3/4] bpf, sockmap: Fix more uncharged while msg
 has more_data
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
> In tcp_bpf_send_verdict(), if msg has more data after
> tcp_bpf_sendmsg_redir():
> 
> tcp_bpf_send_verdict()
>  tosend = msg->sg.size  //msg->sg.size = 22220
>  case __SK_REDIRECT:
>   sk_msg_return()  //uncharged msg->sg.size(22220) sk->sk_forward_alloc
>   tcp_bpf_sendmsg_redir() //after tcp_bpf_sendmsg_redir, msg->sg.size=11000
>  goto more_data;
>  tosend = msg->sg.size  //msg->sg.size = 11000
>  case __SK_REDIRECT:
>   sk_msg_return()  //uncharged msg->sg.size(11000) to sk->sk_forward_alloc
> 
> The msg->sg.size(11000) has been uncharged twice, to fix we can charge the
> remaining msg->sg.size before goto more data.
> 
> This issue can cause the following info:
> WARNING: CPU: 0 PID: 9860 at net/core/stream.c:208 sk_stream_kill_queues+0xd4/0x1a0
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
>  ? vfs_write+0x237/0x290
>  exit_to_user_mode_prepare+0xa9/0x200
>  syscall_exit_to_user_mode+0x12/0x30
>  do_syscall_64+0x46/0x80
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
>  </TASK>
> 
> WARNING: CPU: 0 PID: 2136 at net/ipv4/af_inet.c:155 inet_sock_destruct+0x13c/0x260
> Call Trace:
>  <TASK>
>  __sk_destruct+0x24/0x1f0
>  sk_psock_destroy+0x19b/0x1c0
>  process_one_work+0x1b3/0x3c0
>  worker_thread+0x30/0x350
>  ? process_one_work+0x3c0/0x3c0
>  kthread+0xe6/0x110
>  ? kthread_complete_and_exit+0x20/0x20
>  ret_from_fork+0x22/0x30
>  </TASK>
> 
> Fixes: 604326b41a6f ("bpf, sockmap: convert to generic sk_msg interface")
> Signed-off-by: Wang Yufen <wangyufen@huawei.com>
> ---

LGTM also fixes another charge error when going through the error path with
apply set where it looks like we would have left some bytes charged to the
socket.

Acked-by: John Fastabend <john.fastabend@gmail.com>
