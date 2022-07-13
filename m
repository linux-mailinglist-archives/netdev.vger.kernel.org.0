Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B199A572BC2
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 05:10:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229964AbiGMDKk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 23:10:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230249AbiGMDKf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 23:10:35 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15D74D7A65;
        Tue, 12 Jul 2022 20:10:26 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id e132so9304220pgc.5;
        Tue, 12 Jul 2022 20:10:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TaF/Lj+NmXPxuI2k7BxAPwwPaE376VR5hymiA2YLIJU=;
        b=kTU80BTai1sfi9d9e4NKDgaZ2ivI4N82ugddNyR6E+2P4IHaogb9zaRDHpcWhrf0oB
         3FjZdAHZVAitue7xlqRHo/XqTbFXBuHsboBt0vQlCWKo4ycbB+kZm52QvqzgWLm+Owic
         aWRhkUClheIed/CEwyyyW4ywq6RsBLqhNDgvpcpmqXm2wuKCIX9v/cFqznDGo4JswjB7
         CMR+6l0RxytBhjLJl0aRVoYQjFlEqScYpPPqC/ewd3g9FlK9aBclYv6P8Kbs4s6F+idU
         cRaa2G6GXTof7UV0D3ueI5cu9eK649tJnQmSAQPgzkBG/xQhvfyjH7S6nTvLBBYFrjR9
         ufbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TaF/Lj+NmXPxuI2k7BxAPwwPaE376VR5hymiA2YLIJU=;
        b=nLeCVBpuCSJ7lk8Ijg/liE32SWQOCpPzFcxGDT1QpAfwqmnJ1W42avMYCRr5Oo335Q
         AkUOvBq0aBOR6SPlb+ymvDoHjYLDwZOHxbN3WVgs4Av8ftqpuBr40Or5ZsrBScdwvDH/
         MSp7Me4TA7OIXgvCmAX9w4GrQihzj6oQcOdDvi4mhcJOhbbRQoAce0ev7PtwVKnHZcQm
         jGI2ko2uGHYOXNulrXqokNKmvdfLr2l194eLVJTYvvw1Y/BeH9o34ajB5HoRxm8RSF/d
         R7qRsiK1rL82kcT+o9rEtjRfLKFbypn5LSICfQ82FAf+drVGdJlL0vpJwN1zynW3uuWH
         3wSA==
X-Gm-Message-State: AJIora/6IpEWPuLK2zHykuktybbS5R7uythMxXrBsNd2kWn3FUJkFluR
        /TBiy5egSoVXPIea5GTxRU0=
X-Google-Smtp-Source: AGRyM1sXJbFSbjgYrExu7if6in9LpmUGA+XK4zknnmAAZK21SmCOQPX/pXLoX/FABIHJtbtShs2F4Q==
X-Received: by 2002:aa7:8896:0:b0:52a:c018:9d7d with SMTP id z22-20020aa78896000000b0052ac0189d7dmr1285482pfe.82.1657681825464;
        Tue, 12 Jul 2022 20:10:25 -0700 (PDT)
Received: from localhost.localdomain (pcd568068.netvigator.com. [218.102.100.68])
        by smtp.gmail.com with ESMTPSA id b6-20020a62cf06000000b00528d3d7194dsm7594291pfg.4.2022.07.12.20.10.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 20:10:25 -0700 (PDT)
From:   Hawkins Jiawei <yin31149@gmail.com>
To:     guwen@linux.alibaba.com
Cc:     18801353760@163.com, andrii@kernel.org, ast@kernel.org,
        borisp@nvidia.com, bpf@vger.kernel.org, daniel@iogearbox.net,
        davem@davemloft.net, dsahern@kernel.org, edumazet@google.com,
        john.fastabend@gmail.com, kafai@fb.com, kgraul@linux.ibm.com,
        kpsingh@kernel.org, kuba@kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, paskripkin@gmail.com, skhan@linuxfoundation.org,
        songliubraving@fb.com,
        syzbot+5f26f85569bd179c18ce@syzkaller.appspotmail.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com, yin31149@gmail.com,
        yoshfuji@linux-ipv6.org, chuck.lever@oracle.com
Subject: Re: [PATCH] smc: fix refcount bug in sk_psock_get (2)
Date:   Wed, 13 Jul 2022 11:10:05 +0800
Message-Id: <20220713031005.58220-1-yin31149@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <0408b739-3506-608a-4284-1086443a154d@linux.alibaba.com>
References: <0408b739-3506-608a-4284-1086443a154d@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 11 Jul 2022 at 15:21, Wen Gu <guwen@linux.alibaba.com> wrote:
>Although syzbot found this issue in SMC, seems that it is a generic
>issue about sk_user_data usage? Fixing it from SK_USER_DATA_PTRMASK
>as you plan should be a right way.

Thanks for your advice. In fact, I found a more
general patch, but it seems that it has not 
been merged until now.

In this bug, the problem is that smc and psock, both use
sk_user_data field to save their private data. So they 
will treat field in their own way.

>> in smc_switch_to_fallback(), and set smc->clcsock->sk_user_data
>> to origin smc in smc_fback_replace_callbacks().
>> 
>> Later, sk_psock_get() will treat the smc->clcsock->sk_user_data
>> as sk_psock type, which triggers the refcnt warning.

So in the patch [PATCH RFC 1/5] net: Add distinct sk_psock field,
psock private data will be moved to the sk_psock field, shown as
below
> The sk_psock facility populates the sk_user_data field with the
> address of an extra bit of metadata. User space sockets never
> populate the sk_user_data field, so this has worked out fine.
> 
> However, kernel consumers such as the RPC client and server do
> populate the sk_user_data field. The sk_psock() function cannot tell
> that the content of sk_user_data does not point to psock metadata,
> so it will happily return a pointer to something else, cast to a
> struct sk_psock.
> 
> Thus kernel consumers and psock currently cannot co-exist.
> 
> We could educate sk_psock() to return NULL if sk_user_data does
> not point to a struct sk_psock. However, a more general solution
> that enables full co-existence psock and other uses of sk_user_data
> might be more interesting.
> 
> Move the struct sk_psock address to its own pointer field so that
> the contents of the sk_user_data field is preserved.
> 
> Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
> ---
>  include/linux/skmsg.h |    2 +-
>  include/net/sock.h    |    4 +++-
>  net/core/skmsg.c      |    6 +++---
>  3 files changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
> index c5a2d6f50f25..5ef3a07c5b6c 100644
> --- a/include/linux/skmsg.h
> +++ b/include/linux/skmsg.h
> @@ -277,7 +277,7 @@ static inline void sk_msg_sg_copy_clear(
>			struct sk_msg *msg, u32 start)
>  
>  static inline struct sk_psock *sk_psock(const struct sock *sk)
>  {
> -	return rcu_dereference_sk_user_data(sk);
> +	return rcu_dereference(sk->sk_psock);
>  }
>  
>  static inline void sk_psock_set_state(struct sk_psock *psock,
> diff --git a/include/net/sock.h b/include/net/sock.h
> index c4b91fc19b9c..d2a513169527 100644
> --- a/include/net/sock.h
> +++ b/include/net/sock.h
> @@ -327,7 +327,8 @@ struct sk_filter;
>    *	@sk_tskey: counter to disambiguate concurrent tstamp requests
>    *	@sk_zckey: counter to order MSG_ZEROCOPY notifications
>    *	@sk_socket: Identd and reporting IO signals
> -  *	@sk_user_data: RPC layer private data
> +  *	@sk_user_data: Upper layer private data
> +  *	@sk_psock: socket policy data (bpf)
>    *	@sk_frag: cached page frag
>    *	@sk_peek_off: current peek_offset value
>    *	@sk_send_head: front of stuff to transmit
> @@ -519,6 +520,7 @@ struct sock {
>  
>  	struct socket		*sk_socket;
>  	void			*sk_user_data;
> +	struct sk_psock	__rcu	*sk_psock;
>  #ifdef CONFIG_SECURITY
>  	void			*sk_security;
>  #endif
> diff --git a/net/core/skmsg.c b/net/core/skmsg.c
> index cc381165ea08..2b3d01d92790 100644
> --- a/net/core/skmsg.c
> +++ b/net/core/skmsg.c
> @@ -695,7 +695,7 @@ struct sk_psock *sk_psock_init(struct sock *sk,
>					int node)
>  
>  	write_lock_bh(&sk->sk_callback_lock);
>  
> -	if (sk->sk_user_data) {
> +	if (sk->sk_psock) {
>  		psock = ERR_PTR(-EBUSY);
>  		goto out;
>  	}
> @@ -726,7 +726,7 @@ struct sk_psock *sk_psock_init(struct sock *sk,
>					int node)
>  	sk_psock_set_state(psock, SK_PSOCK_TX_ENABLED);
>  	refcount_set(&psock->refcnt, 1);
>  
> -	rcu_assign_sk_user_data_nocopy(sk, psock);
> +	rcu_assign_pointer(sk->sk_psock, psock);
>  	sock_hold(sk);
>  
>  out:
> @@ -825,7 +825,7 @@ void sk_psock_drop(struct sock *sk,
>					struct sk_psock *psock)
>  {
>  	write_lock_bh(&sk->sk_callback_lock);
>  	sk_psock_restore_proto(sk, psock);
> -	rcu_assign_sk_user_data(sk, NULL);
> +	rcu_assign_pointer(sk->sk_psock, NULL);
>  	if (psock->progs.stream_parser)
>  		sk_psock_stop_strp(sk, psock);
>  	else if (psock->progs.stream_verdict || psock->progs.skb_verdict)

I have tested this patch and the reproducer did not trigger any issue.

In Patchwork website, this patch fails the checks on
netdev/cc_maintainers. If this patch fails for some other reasons,
I will still fix this bug from SK_USER_DATA_PTRMASK,
as a temporary solution.
