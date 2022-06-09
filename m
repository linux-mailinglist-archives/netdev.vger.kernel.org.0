Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEDAF545031
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 17:08:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344121AbiFIPIl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 11:08:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343967AbiFIPIh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 11:08:37 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F3D33AB1D8;
        Thu,  9 Jun 2022 08:08:36 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id f12so18982339ilj.1;
        Thu, 09 Jun 2022 08:08:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=RuRAsoq3kuC2fdfy0p3uN9pJb+y+NfwDk7/S/TecTMU=;
        b=PqErSSsTDO/K7H06mxzgyq3EqMjIORjKQKyE2pbepnVMmafrgl3CiJ5X/3+PXH0b2x
         zYTFD1mSei9m2jigv/WB1JwXjvI5CDw6rSlpccX1RWtuvWjW6os5zrfDbTlSlIrYMTeZ
         yIwnNmTuXM3RbLZvAWmPCSiWNZzU4YvLBstTFue4LLMsYksmOtBp09fZU1m3m4vGKVta
         aDrKrCqv0ormdRcp94XUe/s4RDrWVchfSF3GdbI2I474+2OdwHdfwWnjopIbPeORryAj
         ATPiAyM29GAdZkVjWg5At9Oq6eTOKZFbCfhF5LRO7NjUk22FE1riyKYyAnpoTXC6o+uK
         sJpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=RuRAsoq3kuC2fdfy0p3uN9pJb+y+NfwDk7/S/TecTMU=;
        b=7vWWQtl8i773V3gp/pzH+qR1Sm+ba72d5zAZdo/Daopc1y/MozN7stJWgkg3XmGvXT
         A2erfHlX7Zy0kV9kXP5gnC8j159w7QnY3akRgyH6c8A300OceMXgHZK7dFsZOzBdPHQL
         5spx8fg12yCMmr7/aa3WkcaoUOQEj2X9MqUhENe110vSqPTua8EC7pVEQ73cefi1eiSU
         16RGh07RPXNdLRCmRhpP1Lmer5fg7ORKLpbaHqOaaChRmVrkCFvO/bPNQ0XLdkGnXHNj
         EMg5jMe9gJI02YcHIFKXmMkQyzYld2vpNubejZ+5IN4YoAB3MwaLCnkVq9qUrIuz0WKZ
         Yraw==
X-Gm-Message-State: AOAM531skC33lK0JAG4T8cjtvtUBura+51pFm/MBwDk7OUN72t8qHcWo
        8umPQ5KESaIJGhWb71OtjAQ=
X-Google-Smtp-Source: ABdhPJwvuq5omzgm4ljNMtSKF7jLsO/HzGvkPNeItVjSPtaP4AlYNIsj0e+ylcXKzUf4luoG7SV4Vw==
X-Received: by 2002:a05:6e02:1a8e:b0:2d3:bd16:40ee with SMTP id k14-20020a056e021a8e00b002d3bd1640eemr23091084ilv.20.1654787315336;
        Thu, 09 Jun 2022 08:08:35 -0700 (PDT)
Received: from localhost ([172.243.153.43])
        by smtp.gmail.com with ESMTPSA id x8-20020a92d648000000b002d517c65c51sm6926875ilp.88.2022.06.09.08.08.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jun 2022 08:08:34 -0700 (PDT)
Date:   Thu, 09 Jun 2022 08:08:26 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        Eric Dumazet <edumazet@google.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>
Message-ID: <62a20ceaba3d4_b28ac2082c@john.notmuch>
In-Reply-To: <20220602012105.58853-2-xiyou.wangcong@gmail.com>
References: <20220602012105.58853-1-xiyou.wangcong@gmail.com>
 <20220602012105.58853-2-xiyou.wangcong@gmail.com>
Subject: RE: [Patch bpf-next v3 1/4] tcp: introduce tcp_read_skb()
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
>  include/net/tcp.h |  2 ++
>  net/ipv4/tcp.c    | 47 +++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 49 insertions(+)
> 
> diff --git a/include/net/tcp.h b/include/net/tcp.h
> index 1e99f5c61f84..878544d0f8f9 100644
> --- a/include/net/tcp.h
> +++ b/include/net/tcp.h
> @@ -669,6 +669,8 @@ void tcp_get_info(struct sock *, struct tcp_info *);
>  /* Read 'sendfile()'-style from a TCP socket */
>  int tcp_read_sock(struct sock *sk, read_descriptor_t *desc,
>  		  sk_read_actor_t recv_actor);
> +int tcp_read_skb(struct sock *sk, read_descriptor_t *desc,
> +		 sk_read_actor_t recv_actor);
>  
>  void tcp_initialize_rcv_mss(struct sock *sk);
>  
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index 9984d23a7f3e..a18e9ababf54 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -1709,6 +1709,53 @@ int tcp_read_sock(struct sock *sk, read_descriptor_t *desc,
>  }
>  EXPORT_SYMBOL(tcp_read_sock);
>  
> +int tcp_read_skb(struct sock *sk, read_descriptor_t *desc,
> +		 sk_read_actor_t recv_actor)
> +{
> +	struct tcp_sock *tp = tcp_sk(sk);
> +	u32 seq = tp->copied_seq;
> +	struct sk_buff *skb;
> +	int copied = 0;
> +	u32 offset;
> +
> +	if (sk->sk_state == TCP_LISTEN)
> +		return -ENOTCONN;
> +
> +	while ((skb = tcp_recv_skb(sk, seq, &offset)) != NULL) {
> +		int used;
> +
> +		__skb_unlink(skb, &sk->sk_receive_queue);
> +		used = recv_actor(desc, skb, 0, skb->len);
> +		if (used <= 0) {
> +			if (!copied)
> +				copied = used;
> +			break;
> +		}
> +		seq += used;
> +		copied += used;
> +
> +		if (TCP_SKB_CB(skb)->tcp_flags & TCPHDR_FIN) {
> +			kfree_skb(skb);

Hi Cong, can you elaborate here from v2 comment.

"Hm, it is tricky here, we use the skb refcount after this patchset, so
it could be a real drop from another kfree_skb() in net/core/skmsg.c
which initiates the drop."

The tcp_read_sock() hook is using tcp_eat_recv_skb(). Are we going
to kick tracing infra even on good cases with kfree_skb()? In
sk_psock_verdict_recv() we do an skb_clone() there.

.John
