Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF2904FE944
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 22:06:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229967AbiDLUH5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 16:07:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234273AbiDLUHg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 16:07:36 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A92E890B6
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 13:00:10 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id k25so23501886iok.8
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 13:00:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=K1Zo9cjvRMs9FoxF4qjQP8fVi3O18U4rWvWLCmbt+as=;
        b=S0dnCMGGrf7NMW2nzEHe+Fvn9yQETJXQaEdR6MBuHA+GLJ5mGOBjk9B/arhjEW4VxK
         5xHMCqlRem8CONOaUo3Lkm1BeQtZbDtQGjhaYGha50i7LRjbqGXcbSLbtC5laiYOndai
         WjRxd8NZP7GxV3z/gjtjpvrZqYhpNVbw4Ni8RdsOn/9ZVtYyxuca+AbUffrprSPplsdD
         gFs6G+obZ+6yhcsgNXKWq8ZIRw8JjX+wtiDxwrquxYVMrFAKSlrHaxjLv1oZICk2lXa5
         sKbUfo96etOszD0AbVukH8GqmAN3W4agB9Bry+uctZ+VZ5oV5LF+VzBcfwS2s2+bxlqj
         jM9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=K1Zo9cjvRMs9FoxF4qjQP8fVi3O18U4rWvWLCmbt+as=;
        b=TJHqG3z/7+m+CyvRBPFebUbru0ZjVu2MaLnzgpQ41OeVJET9PVy25MN+scU/weywBC
         Z4j3gMcwkqd+lRpUxhJIKK87fs1yfd9YRFxG3JgdUel5MfIq01qTIZwX/dB9yMOBHDqv
         s0UxUcsHKNlF12aFgIzH1L1iBxeZVHz3uIl9vGu8YH5493NB5MRNRfuRR9DA+kF0tTRI
         bUYE+zTNs2A+MsnkURhxeToHP4IFYSDdn8ERx3AHuKe+GSZ1cowbGbZfyvPg1eeSs4rq
         yjPkHSJsMGCeOJT3TAM6jMLUPvh7qf7LutIru1Z6k2sukgNybO9dg6pQIEbzh6UM75Le
         EyXA==
X-Gm-Message-State: AOAM530hEUCK/S57hGG2MkBUv+Ap0ea5kbh2BGVL56v8S0gIPWon0e+1
        NG3i9rGerErWU4IhtPF06+Q=
X-Google-Smtp-Source: ABdhPJxuBgFvOSySGdC/yroOW36U3ANoVy8QdsMnTdXiLPqmHUieqV1Q82drLnY8Z4hrGxoWksd6Sw==
X-Received: by 2002:a5e:a717:0:b0:649:6328:792b with SMTP id b23-20020a5ea717000000b006496328792bmr16230407iod.54.1649793609565;
        Tue, 12 Apr 2022 13:00:09 -0700 (PDT)
Received: from localhost ([172.243.153.43])
        by smtp.gmail.com with ESMTPSA id m9-20020a0566022ac900b0064cf3d9f35fsm18168628iov.35.2022.04.12.13.00.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 13:00:09 -0700 (PDT)
Date:   Tue, 12 Apr 2022 13:00:02 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org
Cc:     Cong Wang <cong.wang@bytedance.com>,
        Eric Dumazet <edumazet@google.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>
Message-ID: <6255da425c4ad_57e1208f9@john.notmuch>
In-Reply-To: <20220410161042.183540-2-xiyou.wangcong@gmail.com>
References: <20220410161042.183540-1-xiyou.wangcong@gmail.com>
 <20220410161042.183540-2-xiyou.wangcong@gmail.com>
Subject: RE: [Patch bpf-next v1 1/4] tcp: introduce tcp_read_skb()
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

Cong Wang wrote:
> From: Cong Wang <cong.wang@bytedance.com>
> 
> This patch inroduces tcp_read_skb() based on tcp_read_sock(),
> a preparation for the next patch which actually introduces
> a new sock ops.
> 
> TCP is special here, because it has tcp_read_sock() which is
> mainly used by splice(). tcp_read_sock() supports partial read
> and arbitrary offset, neither of them is needed for sockmap.
> 
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Jakub Sitnicki <jakub@cloudflare.com>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> ---

Thanks for doing this Cong comment/question inline.

[...]

> +int tcp_read_skb(struct sock *sk, read_descriptor_t *desc,
> +		 sk_read_actor_t recv_actor)
> +{
> +	struct sk_buff *skb;
> +	struct tcp_sock *tp = tcp_sk(sk);
> +	u32 seq = tp->copied_seq;
> +	u32 offset;
> +	int copied = 0;
> +
> +	if (sk->sk_state == TCP_LISTEN)
> +		return -ENOTCONN;
> +	while ((skb = tcp_recv_skb(sk, seq, &offset, true)) != NULL) {

I'm trying to see why we might have an offset here if we always
consume the entire skb. There is a comment in tcp_recv_skb around
GRO packets, but not clear how this applies here if it does at all
to me yet. Will read a bit more I guess.

If the offset can be >0 than we also need to fix the recv_actor to
account for the extra offset in the skb. As is the bpf prog might
see duplicate data. This is a problem on the stream parser now.

Then another fallout is if offset is zero than we could just do
a skb_dequeue here and skip the tcp_recv_skb bool flag addition
and upate.

I'll continue reading after a few other things I need to get
sorted this afternoon, but maybe you have the answer on hand.

> +		if (offset < skb->len) {
> +			int used;
> +			size_t len;
> +
> +			len = skb->len - offset;
> +			used = recv_actor(desc, skb, offset, len);
> +			if (used <= 0) {
> +				if (!copied)
> +					copied = used;
> +				break;
> +			}
> +			if (WARN_ON_ONCE(used > len))
> +				used = len;
> +			seq += used;
> +			copied += used;
> +			offset += used;
> +
> +			if (offset != skb->len)
> +				continue;
> +		}
> +		if (TCP_SKB_CB(skb)->tcp_flags & TCPHDR_FIN) {
> +			kfree_skb(skb);
> +			++seq;
> +			break;
> +		}
> +		kfree_skb(skb);
> +		if (!desc->count)
> +			break;
> +		WRITE_ONCE(tp->copied_seq, seq);
> +	}
> +	WRITE_ONCE(tp->copied_seq, seq);
> +
> +	tcp_rcv_space_adjust(sk);
> +
> +	/* Clean up data we have read: This will do ACK frames. */
> +	if (copied > 0)
> +		tcp_cleanup_rbuf(sk, copied);
> +
> +	return copied;
> +}
> +EXPORT_SYMBOL(tcp_read_skb);
> +
