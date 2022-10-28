Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F5B2611D56
	for <lists+netdev@lfdr.de>; Sat, 29 Oct 2022 00:17:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230153AbiJ1WRy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 18:17:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230163AbiJ1WRv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 18:17:51 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B99AD24C967;
        Fri, 28 Oct 2022 15:17:48 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id v17so2976259plo.1;
        Fri, 28 Oct 2022 15:17:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DFO6Rk7Tx4hw0SPw2ANYZShYSilBpAbikYfHtUSUgJ4=;
        b=Hf6lkoQB117lQRZBQhZ8TavpzliAnVKU4z6Egh7Mj2rRvsRkP3HUz7+M4asMUUm9Qg
         tbd4W48ncI5tocOxAV1T+M6pFzkFrwRfsNWOA8JdhdT+vwNUhcpAKo14VT23acJ5oT9n
         w4+N2z39wOqfHnZuptoWHpj84RlSfVHmyvTwIIKkZ7GVFyLKioMLT3RA1bdESVB93amT
         Aaqg0UCGxo/9IPzTkiA+0ePucVFGJ9P8F5kmkpu4svff97dPXyy/dY+nYkQUS1gzftLv
         WhvNxedpbjvW9b2GwCGQtVgdxIyn+dk8D/5tr34cRHkwc9wOcpKlwN1OhFi6JBhPw0eM
         UhnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=DFO6Rk7Tx4hw0SPw2ANYZShYSilBpAbikYfHtUSUgJ4=;
        b=VF7VD+GndvQmq94F83K1anvriAzrFkwxqOkT8fwwz37OoPqjRttweQmIwKpa91jQUp
         YNoWkdox+vJLIIpSyApXEE6BONrDRv9koV/Cv9FDFSDQFebDdYxn/eArJgTZRfdOoLQ4
         GMe9XJBdy9lXQKGxQ07xnz23kinUPlaYBqaLwO0e4nSopsdKj1eaLIFFPX/ROxdH5rbn
         VrrsZyTyH4UfaUVb1xyA0MGsNplslszdkp78mz5oUMfzGfVWH8YEHmD7KXBZyZACxhPQ
         2VAPphuDMQgQIako1oGPTYD71E9vZZQ/gT5afz3yhfuaKE18RSZLHyMIkiqX/cyouj6x
         x0Sw==
X-Gm-Message-State: ACrzQf3yX/e+voSiWboUDqewgibdMprtCRO7ts6eVDJfa2Um0Wce7u1g
        7ajNcLOJJNYG9JVBo1U4r+s=
X-Google-Smtp-Source: AMsMyM7NLVqJGwqqynmjXRDuTkZXRqz6rlO0IH7hXm03TZpnHGovrwAm0ul3aMMH8d7xb7lpT/un6g==
X-Received: by 2002:a17:902:778f:b0:17f:8347:ff83 with SMTP id o15-20020a170902778f00b0017f8347ff83mr1218994pll.146.1666995468109;
        Fri, 28 Oct 2022 15:17:48 -0700 (PDT)
Received: from localhost ([98.97.41.13])
        by smtp.gmail.com with ESMTPSA id m2-20020a170902db0200b001868ba9a867sm3541528plx.303.2022.10.28.15.17.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Oct 2022 15:17:47 -0700 (PDT)
Date:   Fri, 28 Oct 2022 15:17:46 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Wang Yufen <wangyufen@huawei.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     john.fastabend@gmail.com, jakub@cloudflare.com
Message-ID: <635c550a430c6_256e2089c@john.notmuch>
In-Reply-To: <1666941754-10216-1-git-send-email-wangyufen@huawei.com>
References: <1666941754-10216-1-git-send-email-wangyufen@huawei.com>
Subject: RE: [PATCH net] bpf, sockmap: fix the sk->sk_forward_alloc warning of
 sk_stream_kill_queues()
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wang Yufen wrote:
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

Ah nice catch. Feel free to add my ACK on a v2 with small typo fixup.

Acked-by: John Fastabend <john.fastabend@gmail.com>

> 
> Fixes: 84472b436e76 ("bpf, sockmap: Fix more uncharged while msg has more_data")
> Reported-by: Jakub Sitnicki <jakub@cloudflare.com>
> Signed-off-by: Wang Yufen <wangyufen@huawei.com>
> ---
>  net/ipv4/tcp_bpf.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
> index a1626af..38d4735 100644
> --- a/net/ipv4/tcp_bpf.c
> +++ b/net/ipv4/tcp_bpf.c
> @@ -278,7 +278,7 @@ static int tcp_bpf_send_verdict(struct sock *sk, struct sk_psock *psock,
>  {
>  	bool cork = false, enospc = sk_msg_full(msg);
>  	struct sock *sk_redir;
> -	u32 tosend, delta = 0;
> +	u32 tosend, orgsize, sended, delta = 0;
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
> +		sended = orgsize - msg->sg.size;

Small english nitpick. Past tense of send is sent so could we make this,

                sent = orgsize - msg->sg.size;

>  
>  		if (eval == __SK_REDIRECT)
>  			sock_put(sk_redir);
> @@ -374,8 +376,8 @@ static int tcp_bpf_send_verdict(struct sock *sk, struct sk_psock *psock,
>  		if (msg &&
>  		    msg->sg.data[msg->sg.start].page_link &&
>  		    msg->sg.data[msg->sg.start].length) {
> -			if (eval == __SK_REDIRECT)
> -				sk_mem_charge(sk, msg->sg.size);
> +			if (eval == __SK_REDIRECT && tosend > sended)

Other nit, you could probably omit the 'tosend > sended' check here. Because
otherwise tosend == sended and the mem_charge of zer is a nop. But OTOH
its probably ok to keep the check to avoid some extra work.

> +				sk_mem_charge(sk, tosend - sended);
>  			goto more_data;
>  		}
>  	}
> -- 
> 1.8.3.1
