Return-Path: <netdev+bounces-1728-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A06BE6FEFD6
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 12:24:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 65A062813B2
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 10:24:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC7911C77F;
	Thu, 11 May 2023 10:24:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0F941C740
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 10:24:30 +0000 (UTC)
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24318E5A
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 03:24:29 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id 5b1f17b1804b1-3f2548256d0so174785e9.1
        for <netdev@vger.kernel.org>; Thu, 11 May 2023 03:24:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683800667; x=1686392667;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aNjnVbaKHXho3f1USVEuLsa+32pVxMdZA72M4VSGzCk=;
        b=Yc0ZTge6RIlPhhBEU+LTtPdItI2Mvaf0p66HKdlXdySLS+8YNVID7LXzP2VNhxerB9
         IGWKA2VsGnzS1Cd4rScACbDzwNCkh5tu1p1ywsC66/IzUuFtobcupgKQ0nzPAbbaq1GK
         t7EwQILTF0Zbwy1OisknPnGd22UnDNVDg36770eBBN/clnmGP5d2VY8O4eRJUDLV4JoQ
         6CO5W+5yWsW7iDzloFzh35+6Oeg+m4HB9MUpAK5qzBMDC3gog5Hskm8orMtyBgx6emXz
         MPSpb8xDYPXibxur9dZDdBgF83do1q/f+yAveB6+I2GUPA41c/L+TTmKVzsfHgfj+gdW
         g8RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683800667; x=1686392667;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aNjnVbaKHXho3f1USVEuLsa+32pVxMdZA72M4VSGzCk=;
        b=PuAkY/3h8Wg+8pUboGbECtVhlz6GZVJhZkW/T4QTq5lMS0dDqzOjzeCWgFtIwF4Qgj
         7iZ8ehAt2L2bw1PKCs5PUBxnJbkBpPCkw7hwMQm75IxBpW/+P2KW0XkQ27YwZwPEg0fe
         KSVi9tD6KFkQPBu2wMDGCpEgk3cIqhGDI9p89VcmXvxk94Da7QjbSU/sbdMikaJ6+EEe
         QK44ARzQfLOXvhKgU9e7xme8T/B26UQ8f+mFV3BR1wNyutsT2nd05lRqJpIH3Q0bMCGN
         7aZN0w/KFtsuhHQIFltibp/ks+ar4+0hxjgcALlf9yYdAMqVCNWDTh+GihJRRHF8eXfz
         L+bQ==
X-Gm-Message-State: AC+VfDwAQkZR2WaKIRkNirOflh7nl+Zh5yF8KAfNrVLIOa344aejnf82
	j7HaeCpuHs9+uT2gIJOp3E9M8CWnUUtCefLTY295uBVRqKVVV4hBOj7j9w==
X-Google-Smtp-Source: ACHHUZ4vqZjI6mDIaHyM/+HX+3pzzwDlM7wZnN8ZFhb9YVGrS188TizdkkeIn5RfWaPe7KXyKdKGEYHFY8mQ46/clVI=
X-Received: by 2002:a05:600c:3491:b0:3f4:2594:118a with SMTP id
 a17-20020a05600c349100b003f42594118amr166576wmq.2.1683800667389; Thu, 11 May
 2023 03:24:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230511093456.672221-1-atenart@kernel.org>
In-Reply-To: <20230511093456.672221-1-atenart@kernel.org>
From: Eric Dumazet <edumazet@google.com>
Date: Thu, 11 May 2023 12:24:15 +0200
Message-ID: <CANn89iJ8Jvi2wk5fOGvkreqcUVN_qs=MJ3mYxtqUGC=jnCgLnw@mail.gmail.com>
Subject: Re: [PATCH net-next 0/4] net: tcp: make txhash use consistent for IPv4
To: Antoine Tenart <atenart@kernel.org>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com, 
	netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 11, 2023 at 11:35=E2=80=AFAM Antoine Tenart <atenart@kernel.org=
> wrote:
>
> Hello,
>
> Series is divided in two parts. First two commits make the txhash (used
> for the skb hash in TCP) to be consistent for all IPv4/TCP packets (IPv6
> doesn't have the same issue). Last two commits improve doc/comment
> hash-related parts.
>
> One example is when using OvS with dp_hash, which uses skb->hash, to
> select a path. We'd like packets from the same flow to be consistent, as
> well as the hash being stable over time when using net.core.txrehash=3D0.
> Same applies for kernel ECMP which also can use skb->hash.
>

SGTM, thanks.

Reviewed-by: Eric Dumazet <edumazet@google.com>

FYI while reviewing your patches, I found that I have to send this fix:

I suggest we hold your patch series a bit before this reaches net-next tree=
,
to avoid merge conflicts.

Bug was added in commit f6c0f5d209fa ("tcp: honor SO_PRIORITY in
TIME_WAIT state")


diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 39bda2b1066e1d607a59fb79c6305d0ca30cb28d..06d2573685ca993a3a0a89807f0=
9d7b5c153cc72
100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -829,6 +829,9 @@ static void tcp_v4_send_reset(const struct sock
*sk, struct sk_buff *skb)
                                   inet_twsk(sk)->tw_priority : sk->sk_prio=
rity;
                transmit_time =3D tcp_transmit_time(sk);
                xfrm_sk_clone_policy(ctl_sk, sk);
+       } else {
+               ctl_sk->sk_mark =3D 0;
+               ctl_sk->sk_priority =3D 0;
        }
        ip_send_unicast_reply(ctl_sk,
                              skb, &TCP_SKB_CB(skb)->header.h4.opt,
@@ -836,7 +839,6 @@ static void tcp_v4_send_reset(const struct sock
*sk, struct sk_buff *skb)
                              &arg, arg.iov[0].iov_len,
                              transmit_time);

-       ctl_sk->sk_mark =3D 0;
        xfrm_sk_free_policy(ctl_sk);
        sock_net_set(ctl_sk, &init_net);
        __TCP_INC_STATS(net, TCP_MIB_OUTSEGS);
@@ -935,7 +937,6 @@ static void tcp_v4_send_ack(const struct sock *sk,
                              &arg, arg.iov[0].iov_len,
                              transmit_time);

-       ctl_sk->sk_mark =3D 0;
        sock_net_set(ctl_sk, &init_net);
        __TCP_INC_STATS(net, TCP_MIB_OUTSEGS);
        local_bh_enable();

