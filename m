Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8335B259DFD
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 20:20:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730110AbgIASUI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 14:20:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726102AbgIASUA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 14:20:00 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D95FC061244
        for <netdev@vger.kernel.org>; Tue,  1 Sep 2020 11:19:58 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id p13so2117380ils.3
        for <netdev@vger.kernel.org>; Tue, 01 Sep 2020 11:19:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FksliviqcgiCVuiQczvZuWvMXHOlk+TZkIWC/eBA2Zc=;
        b=cKuGQYAqG3iVcBc0uQfO7QLoSjD8B+PcR7SD+U1wJfR7kH1TB0x7b7fmHc/bl8eeTA
         DwF+CV/qMbfR+cLoaUJOGc3Fiji1EcvuRLYLW3cMjeHJDGhYP0jvO8P2EFtDhJ7427aD
         EX7YV6Gs5hqkx09MgimFdyAARO5RDTEoPkE7NeXslY7DNOSKrJuYPLeUsSzRVu8yFth9
         j5A+nOHwL6kKWMAiibdjyHjdk+Q/eGboJ6NOioZmk89OAsFArORL1cxRw6ANMWjFbx2a
         4aJ1WuafOgweYq3pLhZK1yVQaGQ29gt7qOvJnjvGfspP05Wq7xJmQ0jYeSd2mcQNAoqz
         OMJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FksliviqcgiCVuiQczvZuWvMXHOlk+TZkIWC/eBA2Zc=;
        b=YgVjGSlkU/Gs+Zl1uCGxx9IUwj1EXW987vAWm2xmjY4RsHbfd7rR/rSkfsill19Ifb
         h5+sisPP2l02FOTH71xn9aX5eYBdnm+m02KJuw3ZqfaLXplqB1rKXQmMEuiyOA7ugJ3E
         i0/er0J6gtdVfwowgsPiJir/cl1z+9AoXa78KVVSpYTfXHIs8pNF8sKD9qXTBip+A1Ob
         HhJublG5u7Cj93m+FlvBmW/LIElZLu3htvXGnYkdM/esNZze7M3xHjEn3m8BkAIBw6u3
         ClLG6MDiGJ4MWg0ZV00L260JQzHYd5KGJXTVDbtSEoyn6jblbqqzh1uo3Z+R9GXYMLBl
         xZUw==
X-Gm-Message-State: AOAM532eUAnuia8wsUw5cPNWcM8161Xf8sEmwmLaoKjrcUtp82fUNWi9
        +6zvqx2ikOkphxSfNTRQe593lo4Rs214jjBwwcY/NQ==
X-Google-Smtp-Source: ABdhPJyT5/iuwzLhxZzfa6deDV335SZZOFHOVwlaH+Ha5xXHf3vqmKqHwpHKo6SmAW6qV5sLfeWPfoZ02kIGyvEgvbA=
X-Received: by 2002:a92:894b:: with SMTP id n72mr256659ild.155.1598984397474;
 Tue, 01 Sep 2020 11:19:57 -0700 (PDT)
MIME-Version: 1.0
References: <20200818231356.1811759-1-weiwan@google.com>
In-Reply-To: <20200818231356.1811759-1-weiwan@google.com>
From:   Wei Wang <weiwan@google.com>
Date:   Tue, 1 Sep 2020 11:19:45 -0700
Message-ID: <CAEA6p_C-H9QxGOMiYFWdGS-=tZ0U2=1=kxTT0BYhmCbDxJW9CQ@mail.gmail.com>
Subject: Re: [PATCH net-next] ip: expose inet sockopts through inet_diag
To:     David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        Mahesh Bandewar <maheshb@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 18, 2020 at 4:14 PM Wei Wang <weiwan@google.com> wrote:
>
> Expose all exisiting inet sockopt bits through inet_diag for debug purpose.
> Corresponding changes in iproute2 ss will be submitted to output all
> these values.
>
> Signed-off-by: Wei Wang <weiwan@google.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Mahesh Bandewar <maheshb@google.com>
> ---

Hi David,

This patch was sent ~2 weeks ago (after net-next opened) and I have
not heard any feedback on this.
In patchwork:
https://patchwork.ozlabs.org/project/netdev/patch/20200818231356.1811759-1-weiwan@google.com/
The status shows "Changes Requested", which I am not sure why.
Could you please advise?

Thanks so much.
Wei

>  include/linux/inet_diag.h      |  2 ++
>  include/uapi/linux/inet_diag.h | 18 ++++++++++++++++++
>  net/ipv4/inet_diag.c           | 17 +++++++++++++++++
>  3 files changed, 37 insertions(+)
>
> diff --git a/include/linux/inet_diag.h b/include/linux/inet_diag.h
> index 0ef2d800fda7..84abb30a3fbb 100644
> --- a/include/linux/inet_diag.h
> +++ b/include/linux/inet_diag.h
> @@ -75,6 +75,8 @@ static inline size_t inet_diag_msg_attrs_size(void)
>  #ifdef CONFIG_SOCK_CGROUP_DATA
>                 + nla_total_size_64bit(sizeof(u64))  /* INET_DIAG_CGROUP_ID */
>  #endif
> +               + nla_total_size(sizeof(struct inet_diag_sockopt))
> +                                                    /* INET_DIAG_SOCKOPT */
>                 ;
>  }
>  int inet_diag_msg_attrs_fill(struct sock *sk, struct sk_buff *skb,
> diff --git a/include/uapi/linux/inet_diag.h b/include/uapi/linux/inet_diag.h
> index 5ba122c1949a..20ee93f0f876 100644
> --- a/include/uapi/linux/inet_diag.h
> +++ b/include/uapi/linux/inet_diag.h
> @@ -160,6 +160,7 @@ enum {
>         INET_DIAG_ULP_INFO,
>         INET_DIAG_SK_BPF_STORAGES,
>         INET_DIAG_CGROUP_ID,
> +       INET_DIAG_SOCKOPT,
>         __INET_DIAG_MAX,
>  };
>
> @@ -183,6 +184,23 @@ struct inet_diag_meminfo {
>         __u32   idiag_tmem;
>  };
>
> +/* INET_DIAG_SOCKOPT */
> +
> +struct inet_diag_sockopt {
> +       __u8    recverr:1,
> +               is_icsk:1,
> +               freebind:1,
> +               hdrincl:1,
> +               mc_loop:1,
> +               transparent:1,
> +               mc_all:1,
> +               nodefrag:1;
> +       __u8    bind_address_no_port:1,
> +               recverr_rfc4884:1,
> +               defer_connect:1,
> +               unused:5;
> +};
> +
>  /* INET_DIAG_VEGASINFO */
>
>  struct tcpvegas_info {
> diff --git a/net/ipv4/inet_diag.c b/net/ipv4/inet_diag.c
> index 4a98dd736270..93816d47e55a 100644
> --- a/net/ipv4/inet_diag.c
> +++ b/net/ipv4/inet_diag.c
> @@ -125,6 +125,7 @@ int inet_diag_msg_attrs_fill(struct sock *sk, struct sk_buff *skb,
>                              bool net_admin)
>  {
>         const struct inet_sock *inet = inet_sk(sk);
> +       struct inet_diag_sockopt inet_sockopt;
>
>         if (nla_put_u8(skb, INET_DIAG_SHUTDOWN, sk->sk_shutdown))
>                 goto errout;
> @@ -180,6 +181,22 @@ int inet_diag_msg_attrs_fill(struct sock *sk, struct sk_buff *skb,
>         r->idiag_uid = from_kuid_munged(user_ns, sock_i_uid(sk));
>         r->idiag_inode = sock_i_ino(sk);
>
> +       memset(&inet_sockopt, 0, sizeof(inet_sockopt));
> +       inet_sockopt.recverr    = inet->recverr;
> +       inet_sockopt.is_icsk    = inet->is_icsk;
> +       inet_sockopt.freebind   = inet->freebind;
> +       inet_sockopt.hdrincl    = inet->hdrincl;
> +       inet_sockopt.mc_loop    = inet->mc_loop;
> +       inet_sockopt.transparent = inet->transparent;
> +       inet_sockopt.mc_all     = inet->mc_all;
> +       inet_sockopt.nodefrag   = inet->nodefrag;
> +       inet_sockopt.bind_address_no_port = inet->bind_address_no_port;
> +       inet_sockopt.recverr_rfc4884 = inet->recverr_rfc4884;
> +       inet_sockopt.defer_connect = inet->defer_connect;
> +       if (nla_put(skb, INET_DIAG_SOCKOPT, sizeof(inet_sockopt),
> +                   &inet_sockopt))
> +               goto errout;
> +
>         return 0;
>  errout:
>         return 1;
> --
> 2.28.0.297.g1956fa8f8d-goog
>
