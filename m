Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5382C62FFD9
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 23:13:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231388AbiKRWNl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 17:13:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229835AbiKRWNj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 17:13:39 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 499C426540
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 14:13:37 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id x2so9036344edd.2
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 14:13:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=2oP0325pZ2wP3wVienSvCp2ZkuIlt6dYvBZYwfUQg5k=;
        b=bArh9Da5Pe4ytWtWRSoZ5bsIvFrCldM2f9PZeWdr11KzJRfiBjS6KRuOSjC/nW0z2z
         ZbRNRFYDb6lU1JsC/9l0gFBDYYQoWpivaHrQWUVhkCWYH0aQY0WE77gqwQQELVQqjeid
         Zs39RmsHJPSFfarMAjMJazAh8wzD/7VXiW2to=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2oP0325pZ2wP3wVienSvCp2ZkuIlt6dYvBZYwfUQg5k=;
        b=kq42S/VirG4G2HJKMll4QM0CXyY3r5wusJEc/EkB2t3ygiU1C/hkByNGp/xLzSAHn9
         OOqO0bS8B02AqNsDFnn9rm+/+uGqm3ZmC8r570zO4pyWlEV7Vq2BhrsVtgHs/6bsz6tB
         swZ/bg8Mdkm4yw5SYUOcK/Wmeg3JlkNORp0oQJjKyjhuV+vgwwLsMp2WoeApJ0sC871x
         70rxFCVegxH+25LRBrvWONWkquq29ZkhZvNexfcr2QpLAI4BGzhe0S8ntAx6wmRgKtRQ
         qOs4z8++Ve3u2vZ/67aQyWWIb5X6ue1ONmVKcjSAJewuUJNmdadz401HnFsYxZMK9juX
         KJiQ==
X-Gm-Message-State: ANoB5pl2k3U84Q4kIFYTj2nRm5hzoDhEp3BHdl5LLY96l0ekdCY8RK4g
        7P6d/pc18HqpkiEZGezQ//xDTA==
X-Google-Smtp-Source: AA0mqf6AuTtL8STdhju+mnQ7U/8LiiIkJ7x537AGVP9uHFuqs1dhLY0/ebCtL6ptskl5z+mKKMiSvw==
X-Received: by 2002:a05:6402:150:b0:468:fdc3:6b44 with SMTP id s16-20020a056402015000b00468fdc36b44mr5690695edu.388.1668809615857;
        Fri, 18 Nov 2022 14:13:35 -0800 (PST)
Received: from cloudflare.com (79.184.204.15.ipv4.supernova.orange.pl. [79.184.204.15])
        by smtp.gmail.com with ESMTPSA id mb16-20020a170906eb1000b007ae1e528390sm2149486ejb.163.2022.11.18.14.13.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Nov 2022 14:13:35 -0800 (PST)
References: <0000000000004e78ec05eda79749@google.com>
 <00000000000011ec5105edb50386@google.com>
 <c64284f4-2c2a-ecb9-a08e-9e49d49c720b@I-love.SAKURA.ne.jp>
 <CANn89iJq0v5=M7OTPE8WGZ4bNiYzO-KW3E8SRHOzf_q9nHPZEw@mail.gmail.com>
 <a2199ab7c03e71af3ac791e119e52c94e9f023f56c8b0d8014dd70aceee2784e@mu>
User-agent: mu4e 1.6.10; emacs 27.2
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Eric Dumazet <edumazet@google.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Tom Parkin <tparkin@katalix.com>,
        syzbot <syzbot+703d9e154b3b58277261@syzkaller.appspotmail.com>,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        Haowei Yan <g1042620637@gmail.com>
Subject: Re: [PATCH 6.1-rc6] l2tp: call udp_tunnel_encap_enable() and
 sock_release() without sk_callback_lock
Date:   Fri, 18 Nov 2022 23:10:38 +0100
In-reply-to: <a2199ab7c03e71af3ac791e119e52c94e9f023f56c8b0d8014dd70aceee2784e@mu>
Message-ID: <87v8nboqr5.fsf@cloudflare.com>
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

On Fri, Nov 18, 2022 at 06:50 PM +01, Jakub Sitnicki wrote:

[...]

> But, I also have an alternative idea - instead of pulling the function
> call that might sleep out of the critical section, I think we could make
> the critical section much shorter by rearranging the tunnel
> initialization code slightly. That is, a change like below.

[...]

> --8<--
>
> diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
> index 754fdda8a5f5..07454c0418e3 100644
> --- a/net/l2tp/l2tp_core.c
> +++ b/net/l2tp/l2tp_core.c
> @@ -1474,11 +1474,15 @@ int l2tp_tunnel_register(struct l2tp_tunnel *tunnel, struct net *net,
>  	}
>  
>  	sk = sock->sk;
> -	write_lock(&sk->sk_callback_lock);
> +	write_lock_bh(&sk->sk_callback_lock);
>  
>  	ret = l2tp_validate_socket(sk, net, tunnel->encap);
>  	if (ret < 0)
>  		goto err_sock;
> +	if (tunnel->encap != L2TP_ENCAPTYPE_UDP)
> +		rcu_assign_sk_user_data(sk, tunnel);

sk_user_data needs to be reset back to NULL if we bail out when the
tunnel already exists. Will add that and turn it into a patch tomorrow.

> +
> +	write_unlock_bh(&sk->sk_callback_lock);
>  
>  	tunnel->l2tp_net = net;
>  	pn = l2tp_pernet(net);
> @@ -1507,8 +1511,6 @@ int l2tp_tunnel_register(struct l2tp_tunnel *tunnel, struct net *net,
>  		};
>  
>  		setup_udp_tunnel_sock(net, sock, &udp_cfg);
> -	} else {
> -		rcu_assign_sk_user_data(sk, tunnel);
>  	}
>  
>  	tunnel->old_sk_destruct = sk->sk_destruct;
> @@ -1522,7 +1524,6 @@ int l2tp_tunnel_register(struct l2tp_tunnel *tunnel, struct net *net,
>  	if (tunnel->fd >= 0)
>  		sockfd_put(sock);
>  
> -	write_unlock(&sk->sk_callback_lock);
>  	return 0;
>  
>  err_sock:
> @@ -1530,8 +1531,6 @@ int l2tp_tunnel_register(struct l2tp_tunnel *tunnel, struct net *net,
>  		sock_release(sock);
>  	else
>  		sockfd_put(sock);
> -
> -	write_unlock(&sk->sk_callback_lock);
>  err:
>  	return ret;
>  }

