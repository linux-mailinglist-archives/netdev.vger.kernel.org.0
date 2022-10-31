Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC425613D14
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 19:06:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229993AbiJaSGs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 14:06:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229876AbiJaSGf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 14:06:35 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E92C13F7A
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 11:05:27 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id i21so18599141edj.10
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 11:05:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=2isgzEVOzATuuJwSzGWZ3YEuAbxmDyfoHMxDF7BrO2c=;
        b=eCOL/adO2DyRXMvvuWIQob5OAM/haJJgTvm8xt+rpjNpzrFWC0RaZlOa4v1FiQ1OVJ
         wAiDEXyEu7XFiNDzqXueML8MYU+VdxTqHEU0QM6aNN0oUJbxHaQCrpSWVBVlBhl3RaMG
         7O+8sO5x6QM0hGn6HhpSFmD1NG+mU2LWZbo+s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2isgzEVOzATuuJwSzGWZ3YEuAbxmDyfoHMxDF7BrO2c=;
        b=YbwTk95WSIjjFgnoOYIW9LI//j1lRvDHP7SHLt6u/+0zYnchYr2rTsZu81Tll8B16T
         nT9SfAcvLw7im+rG3Mi5hGAyacNpe8cLJXHNZZ25EQks9jv2jbd1J2IHLOIGRYbbALeL
         hrENsErOY/1/CWJhGezo2hPSzAoKSVkSCmSHgTs6r2FQCMKwMrkyBw8VSAUNS91JFwhc
         Dler1L7wzjYbs2YQA2A0D0BNIf4UgI4IFt2PrXJPugCmM3+NHGRwtXdbrAfxYMhySYkC
         ydZZmv71OP1V6nty7ORUHfbsiBAd618jhaUUZQzcqf/2a8GpPcpPlc8ACCoEF2cCZ2z/
         UHWw==
X-Gm-Message-State: ACrzQf2rbOuiTEIto89vExFgXqJ0h8va7U39/RhT93L9enfJ5Q/3P+c4
        ZSoTrTrEovJI19UO/s8l9kCuXg==
X-Google-Smtp-Source: AMsMyM4Jn+BJzuSqJm0qwadMaYU0P8FmfCoIK5s5kz7nKT2kaxhvB8SjIfQPZNjTbqUQgP4IIF6Ulg==
X-Received: by 2002:a05:6402:524e:b0:461:fa05:aff8 with SMTP id t14-20020a056402524e00b00461fa05aff8mr15072173edd.283.1667239525375;
        Mon, 31 Oct 2022 11:05:25 -0700 (PDT)
Received: from cloudflare.com (79.191.56.44.ipv4.supernova.orange.pl. [79.191.56.44])
        by smtp.gmail.com with ESMTPSA id b18-20020a1709063cb200b007ad9adabcd4sm3219125ejh.213.2022.10.31.11.05.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Oct 2022 11:05:24 -0700 (PDT)
References: <1667000674-13237-1-git-send-email-wangyufen@huawei.com>
User-agent: mu4e 1.6.10; emacs 27.2
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Wang Yufen <wangyufen@huawei.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        john.fastabend@gmail.com
Subject: Re: [PATCH net v2] bpf, sockmap: fix the sk->sk_forward_alloc
 warning of sk_stream_kill_queues()
Date:   Mon, 31 Oct 2022 18:56:49 +0100
In-reply-to: <1667000674-13237-1-git-send-email-wangyufen@huawei.com>
Message-ID: <87fsf3q36k.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 29, 2022 at 07:44 AM +08, Wang Yufen wrote:
> When running `test_sockmap` selftests, got the following warning:
>
> WARNING: CPU: 2 PID: 197 at net/core/stream.c:205 sk_stream_kill_queues+0xd3/0xf0
> Call Trace:
>   <TASK>
>   inet_csk_destroy_sock+0x55/0x110
>   tcp_rcv_state_process+0xd28/0x1380
>   ? tcp_v4_do_rcv+0x77/0x2c0
>   tcp_v4_do_rcv+0x77/0x2c0
>   __release_sock+0x106/0x130
>   __tcp_close+0x1a7/0x4e0
>   tcp_close+0x20/0x70
>   inet_release+0x3c/0x80
>   __sock_release+0x3a/0xb0
>   sock_close+0x14/0x20
>   __fput+0xa3/0x260
>   task_work_run+0x59/0xb0
>   exit_to_user_mode_prepare+0x1b3/0x1c0
>   syscall_exit_to_user_mode+0x19/0x50
>   do_syscall_64+0x48/0x90
>   entry_SYSCALL_64_after_hwframe+0x44/0xae
>
> The root case is: In commit 84472b436e76 ("bpf, sockmap: Fix more
> uncharged while msg has more_data") , I used msg->sg.size replace
> tosend rudely, which break the
>    if (msg->apply_bytes && msg->apply_bytes < send)
> scene.
>
> Fixes: 84472b436e76 ("bpf, sockmap: Fix more uncharged while msg has more_data")
> Reported-by: Jakub Sitnicki <jakub@cloudflare.com>
> Signed-off-by: Wang Yufen <wangyufen@huawei.com>
> Acked-by: John Fastabend <john.fastabend@gmail.com>
> ---
> v1 -> v2: typo fixup
>  net/ipv4/tcp_bpf.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
>
> diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
> index a1626af..774d481 100644
> --- a/net/ipv4/tcp_bpf.c
> +++ b/net/ipv4/tcp_bpf.c
> @@ -278,7 +278,7 @@ static int tcp_bpf_send_verdict(struct sock *sk, struct sk_psock *psock,
>  {
>  	bool cork = false, enospc = sk_msg_full(msg);
>  	struct sock *sk_redir;
> -	u32 tosend, delta = 0;
> +	u32 tosend, orgsize, sent, delta = 0;
>  	u32 eval = __SK_NONE;
>  	int ret;
>  
> @@ -333,10 +333,12 @@ static int tcp_bpf_send_verdict(struct sock *sk, struct sk_psock *psock,
>  			cork = true;
>  			psock->cork = NULL;
>  		}
> -		sk_msg_return(sk, msg, msg->sg.size);
> +		sk_msg_return(sk, msg, tosend);
>  		release_sock(sk);
>  
> +		orgsize = msg->sg.size;
>  		ret = tcp_bpf_sendmsg_redir(sk_redir, msg, tosend, flags);
> +		sent = orgsize - msg->sg.size;

If I'm reading the code right, it's the same as:

                sent = tosend - msg->sg.size;

If so, no need for orgsize.

>  
>  		if (eval == __SK_REDIRECT)
>  			sock_put(sk_redir);
> @@ -375,7 +377,7 @@ static int tcp_bpf_send_verdict(struct sock *sk, struct sk_psock *psock,
>  		    msg->sg.data[msg->sg.start].page_link &&
>  		    msg->sg.data[msg->sg.start].length) {
>  			if (eval == __SK_REDIRECT)
> -				sk_mem_charge(sk, msg->sg.size);
> +				sk_mem_charge(sk, tosend - sent);
>  			goto more_data;
>  		}
>  	}

