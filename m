Return-Path: <netdev+bounces-1587-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A9266FE654
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 23:31:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9C2211C20DE7
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 21:31:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 669A31D2D4;
	Wed, 10 May 2023 21:31:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57D1F21CF5
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 21:31:37 +0000 (UTC)
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09ABC2716
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 14:31:36 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id d2e1a72fcca58-643846c006fso8271313b3a.0
        for <netdev@vger.kernel.org>; Wed, 10 May 2023 14:31:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683754295; x=1686346295;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dilDKvLCh912/JBRw2vO/HiVmrKv/M0bEgV3+XRucAc=;
        b=5paPeWa1KE85/hTV+xiWJPPMEd2oAAUUgfJ8zT8Ax2ITNV7UNcwRQJtuw6ZrRMDoyj
         F3iVlnrLqDcJNKS4fM1yFtMVmQ5kW/MPX7G6AXTtCC7MQNgYQ6j6WkpQgfYqHYQHemNJ
         VZeMtOHkDzP5HTheFAj9Oy64HoASBYkyUwn2/ohObRZ4Ynv33NIP/m3H6vW38Zk1OvpB
         JSxazUSaM9FVz1aaLpcEHDIp/y1kg8VV22E7Madn26eFby5Y/jbmzBdFAKGsfoC4LI2G
         T4Lt7VbWRsSeNqphY/EcT2DTmRNSQDCdlS2cOC93RFKl0WsEiVdj2OWBJUsI9HKa4W0m
         h0+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683754295; x=1686346295;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dilDKvLCh912/JBRw2vO/HiVmrKv/M0bEgV3+XRucAc=;
        b=aP3i38qxKWAv8HQ9+RlFoYUiKYW8sn48ItlzZZ9CZBri6W5E3vVeVv1qICVR4wVlMs
         dxwSLvp4zqpICEWgf5x2FUSqq/2WUexEABY8EkCw/erdzQSFJXa9l17uTItqxco9Zbrs
         bA99BI0OnTS1kgHnbiElZMfjRXla0wFk3v/ZSOaA9YbwvOhQyfPpkuo7oVcvBw2ldl7F
         YfWObMjCAp2Ub7jDAupglxFfFZh1prrtNRQ15KdcWdHhkB2Z2JvOICz1aYjHOnEwxNMY
         3yA31F/d6D8UY0Ya08NbR6PgsH6auWBbJnO91tPzlBf4UvNBbRGOh4OFW6DLXL3hHWed
         /uNA==
X-Gm-Message-State: AC+VfDwuZ5d1TKpqNLTaeOHQo6dLL/9gzuhADzN4DxP5R8C4wuZ5khVV
	kVYMNEn7cMd/dIbWtBu1GfB7oDRpZL5XksiRX9ly3w==
X-Google-Smtp-Source: ACHHUZ74oA92M2oyte9ZwQqFQMLwi4FAmCL45SgTYqyIDZnMMcH93WNEj5//wMcp0Tf/bB3sl4rmpo4z3TUompF7XqU=
X-Received: by 2002:a17:902:ba84:b0:1ab:1c09:2df8 with SMTP id
 k4-20020a170902ba8400b001ab1c092df8mr19326387pls.50.1683754295424; Wed, 10
 May 2023 14:31:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230510152216.1392682-1-aleksandr.mikhalitsyn@canonical.com>
In-Reply-To: <20230510152216.1392682-1-aleksandr.mikhalitsyn@canonical.com>
From: Stanislav Fomichev <sdf@google.com>
Date: Wed, 10 May 2023 14:31:24 -0700
Message-ID: <CAKH8qBuAoobsVP2Q5KN06fZ2NM3_aMwT7Y2OoKwS4Cf=cv3ZGg@mail.gmail.com>
Subject: Re: [PATCH net-next] net: core: add SOL_SOCKET filter for bpf
 getsockopt hook
To: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Cc: davem@davemloft.net, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Christian Brauner <brauner@kernel.org>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Kuniyuki Iwashima <kuniyu@amazon.com>, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, 
	bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 10, 2023 at 8:23=E2=80=AFAM Alexander Mikhalitsyn
<aleksandr.mikhalitsyn@canonical.com> wrote:
>
> We have per struct proto ->bpf_bypass_getsockopt callback
> to filter out bpf socket cgroup getsockopt hook from being called.
>
> It seems worthwhile to add analogical helper for SOL_SOCKET
> level socket options. First user will be SO_PEERPIDFD.
>
> This patch was born as a result of discussion around a new SCM_PIDFD inte=
rface:
> https://lore.kernel.org/all/20230413133355.350571-3-aleksandr.mikhalitsyn=
@canonical.com/
>
> Cc: Alexei Starovoitov <ast@kernel.org>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Christian Brauner <brauner@kernel.org>
> Cc: Stanislav Fomichev <sdf@google.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: Kuniyuki Iwashima <kuniyu@amazon.com>
> Cc: linux-kernel@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Cc: bpf@vger.kernel.org
> Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com=
>
> ---
>  include/linux/bpf-cgroup.h | 8 +++++---
>  include/net/sock.h         | 1 +
>  net/core/sock.c            | 5 +++++
>  3 files changed, 11 insertions(+), 3 deletions(-)
>
> diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
> index 57e9e109257e..97d8a49b35bf 100644
> --- a/include/linux/bpf-cgroup.h
> +++ b/include/linux/bpf-cgroup.h
> @@ -387,10 +387,12 @@ static inline bool cgroup_bpf_sock_enabled(struct s=
ock *sk,
>         int __ret =3D retval;                                            =
        \
>         if (cgroup_bpf_enabled(CGROUP_GETSOCKOPT) &&                     =
      \
>             cgroup_bpf_sock_enabled(sock, CGROUP_GETSOCKOPT))            =
      \
> -               if (!(sock)->sk_prot->bpf_bypass_getsockopt ||           =
      \
> -                   !INDIRECT_CALL_INET_1((sock)->sk_prot->bpf_bypass_get=
sockopt, \
> +               if (((level !=3D SOL_SOCKET) ||                          =
        \
> +                    !sock_bpf_bypass_getsockopt(level, optname)) &&     =
      \
> +                   (!(sock)->sk_prot->bpf_bypass_getsockopt ||          =
      \

Any reason we are not putting this into bpf_bypass_getsockopt for
af_unix struct proto? SO_PEERPIDFD seems relevant only for af_unix?

> +                    !INDIRECT_CALL_INET_1((sock)->sk_prot->bpf_bypass_ge=
tsockopt, \
>                                         tcp_bpf_bypass_getsockopt,       =
      \
> -                                       level, optname))                 =
      \
> +                                       level, optname)))                =
      \
>                         __ret =3D __cgroup_bpf_run_filter_getsockopt(    =
        \
>                                 sock, level, optname, optval, optlen,    =
      \
>                                 max_optlen, retval);                     =
      \
> diff --git a/include/net/sock.h b/include/net/sock.h
> index 8b7ed7167243..530d6d22f42d 100644
> --- a/include/net/sock.h
> +++ b/include/net/sock.h
> @@ -1847,6 +1847,7 @@ int sk_getsockopt(struct sock *sk, int level, int o=
ptname,
>                   sockptr_t optval, sockptr_t optlen);
>  int sock_getsockopt(struct socket *sock, int level, int op,
>                     char __user *optval, int __user *optlen);
> +bool sock_bpf_bypass_getsockopt(int level, int optname);
>  int sock_gettstamp(struct socket *sock, void __user *userstamp,
>                    bool timeval, bool time32);
>  struct sk_buff *sock_alloc_send_pskb(struct sock *sk, unsigned long head=
er_len,
> diff --git a/net/core/sock.c b/net/core/sock.c
> index 5440e67bcfe3..194a423eb6e5 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -1963,6 +1963,11 @@ int sock_getsockopt(struct socket *sock, int level=
, int optname,
>                              USER_SOCKPTR(optlen));
>  }
>
> +bool sock_bpf_bypass_getsockopt(int level, int optname)
> +{
> +       return false;
> +}
> +
>  /*
>   * Initialize an sk_lock.
>   *
> --
> 2.34.1
>

