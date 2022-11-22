Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 145206343A8
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 19:31:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234510AbiKVSbg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 13:31:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234232AbiKVSbc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 13:31:32 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C672E87A59
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 10:31:31 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id s12so21812710edd.5
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 10:31:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=Gaak7skZamRjfvKXr8Vn2aBIqzH3LyXYNlgiuxnc+3o=;
        b=hn1VHTAMFehl5BStBrbsUCeeQnYi4x6stXHAK+/qpub7Pxu1E6pH8eFlUxfGwG1kG5
         zTkINCGG2milV6IdX6FAEZQDAa5AuEy2zSbrvoOjyTmRNuO5XaTvSn3+eKu+emA7TX6W
         Oxlcl7kkBM5lSlhbQ85wpf+uX8iLGnnLxqIYo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Gaak7skZamRjfvKXr8Vn2aBIqzH3LyXYNlgiuxnc+3o=;
        b=e7bGlk4iiU6iHv1DgQ7G/8IYctlTEKOX5UlXeNmvV6texahpo/zTqr6oEB+0wEsQ0+
         ZHTgJBS3K7gcD2S61Jv6IA97By0G6MtGHyGRwNoSWLPOhvAe5118zsL9g/8/UaIfo2nC
         N/QLeenKbcLXtMSJNBh20VnrK96wJpRIwdUnqjwZW6XGWdNVAO3NviBazuZKNJ9cORH5
         mcTNEfaV2Lw+GGAVp+mzU7sz5oEGoZQpceYqzs/ygE4U+fyU4bY0F57oN1xZbEviuRxc
         LtfJJ8s+L83rbgly2lkv0fck6APK7r2w9Fmv7/3alIWAAZQxU2Qj55CyFOOvovzLI+zj
         xZTA==
X-Gm-Message-State: ANoB5pniKbUS6322IhoAcpH6S/49d7g5yjm2VkInSTGix7WFFyliGkoj
        i5hwGhas0tap3gIfcN8wicRwPSGVoeip3w==
X-Google-Smtp-Source: AA0mqf6WMvNpF9VvIMySOhK5qk6DpOglcnpkV5ECVDuWFkciVIUbDDNfZl63DEDq6+Q+3pgF27wO6A==
X-Received: by 2002:a05:6402:444a:b0:459:401:c23e with SMTP id o10-20020a056402444a00b004590401c23emr6989876edb.23.1669141890294;
        Tue, 22 Nov 2022 10:31:30 -0800 (PST)
Received: from cloudflare.com (79.184.204.15.ipv4.supernova.orange.pl. [79.184.204.15])
        by smtp.gmail.com with ESMTPSA id e22-20020a170906315600b00738795e7d9bsm6240934eje.2.2022.11.22.10.31.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Nov 2022 10:31:29 -0800 (PST)
References: <00000000000033a0120588fac894@google.com>
 <693b572a-6436-14e6-442c-c8f2f361ed94@I-love.SAKURA.ne.jp>
 <YydimPlesKO+4QKG@boqun-archlinux>
 <f1567517-5614-2b2a-b42d-4c26433de3b2@I-love.SAKURA.ne.jp>
 <c9695548-3f27-dda1-3124-ec21da106741@I-love.SAKURA.ne.jp>
User-agent: mu4e 1.6.10; emacs 27.2
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Eric Dumazet <edumazet@google.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc:     Boqun Feng <boqun.feng@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Waiman Long <longman@redhat.com>, netdev@vger.kernel.org,
        syzbot <syzbot+94cc2a66fc228b23f360@syzkaller.appspotmail.com>,
        syzkaller-bugs@googlegroups.com
Subject: Re: WARNING: locking bug in inet_autobind
Date:   Tue, 22 Nov 2022 19:02:31 +0100
In-reply-to: <c9695548-3f27-dda1-3124-ec21da106741@I-love.SAKURA.ne.jp>
Message-ID: <87sfialu2n.fsf@cloudflare.com>
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

On Tue, Sep 27, 2022 at 10:00 PM +09, Tetsuo Handa wrote:
> On 2022/09/19 14:02, Tetsuo Handa wrote:
>> But unfortunately reordering
>> 
>>   tunnel->sock = sk;
>>   ...
>>   lockdep_set_class_and_name(&sk->sk_lock.slock,...);
>> 
>> by
>> 
>>   lockdep_set_class_and_name(&sk->sk_lock.slock, &l2tp_socket_class, "l2tp_sock");
>>   smp_store_release(&tunnel->sock, sk);
>> 
>> does not help, for connect() on AF_INET6 socket is not finding this "sk" by
>> accessing tunnel->sock.
>> 
>
> I considered something like below diff, but I came to think that this problem
> cannot be solved unless l2tp_tunnel_register() stops using userspace-supplied
> file descriptor and starts always calling l2tp_tunnel_sock_create(), for
> userspace can continue using userspace-supplied file descriptor as if a normal
> socket even after lockdep_set_class_and_name() told that this is a tunneling
> socket.
>
> Since userspace-supplied file descriptor has to be a datagram socket,
> can we somehow copy the source/destination addresses from
> userspace-supplied socket to kernel-created socket?
>
>
> diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
> index 7499c51b1850..07429bed7c4c 100644
> --- a/net/l2tp/l2tp_core.c
> +++ b/net/l2tp/l2tp_core.c
> @@ -1382,8 +1382,6 @@ static int l2tp_tunnel_sock_create(struct net *net,
>  	return err;
>  }
>  
> -static struct lock_class_key l2tp_socket_class;
> -
>  int l2tp_tunnel_create(int fd, int version, u32 tunnel_id, u32 peer_tunnel_id,
>  		       struct l2tp_tunnel_cfg *cfg, struct l2tp_tunnel **tunnelp)
>  {
> @@ -1509,8 +1507,20 @@ int l2tp_tunnel_register(struct l2tp_tunnel *tunnel, struct net *net,
>  
>  	tunnel->old_sk_destruct = sk->sk_destruct;
>  	sk->sk_destruct = &l2tp_tunnel_destruct;
> -	lockdep_set_class_and_name(&sk->sk_lock.slock, &l2tp_socket_class,
> -				   "l2tp_sock");
> +	if (IS_ENABLED(CONFIG_LOCKDEP)) {
> +		static struct lock_class_key l2tp_socket_class;
> +
> +		/* Changing class/name of an already visible sock might race
> +		 * with first lock_sock() call on that sock. In order to make
> +		 * sure that register_lock_class() has completed before
> +		 * lockdep_set_class_and_name() changes class/name, explicitly
> +		 * lock/release that sock.
> +		 */
> +		lock_sock(sk);
> +		release_sock(sk);
> +		lockdep_set_class_and_name(&sk->sk_lock.slock,
> +					   &l2tp_socket_class, "l2tp_sock");
> +	}
>  	sk->sk_allocation = GFP_ATOMIC;
>  
>  	trace_register_tunnel(tunnel);

What if we revisit Eric's lockdep splat fix in 37159ef2c1ae ("l2tp: fix
a lockdep splat") and:

1. remove the lockdep_set_class_and_name(...) call in l2tp; it looks
   like an odd case within the network stack, and

2. switch to bh_lock_sock_nested in l2tp_xmit_core so that we don't
   break what has been fixed in 37159ef2c1ae.

Eric, WDYT?
