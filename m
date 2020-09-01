Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 796C5258896
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 08:55:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726521AbgIAGze (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 02:55:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726006AbgIAGzd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 02:55:33 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 480B2C0612AC
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 23:55:33 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id b79so39083wmb.4
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 23:55:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=EcyOcNMeJU/82mEIEPpMUaOJoG8hDM3M2omWrK0fdkc=;
        b=ldcQ43e9NoR45E6kG3MmSTqN8tFcNxZZXj9oeKf+AtkHl7ZQ2qkWtvgQx7CDRVyR3N
         tZl7gbfPQy8/VirXTxIlVbhGLBAnEH3+zVTMWzFDtIcWEsFGRp4C+w7yHy/2+MlEAgJf
         lZGzc/XzuVETYCy9Sd2PUSezkYmrQE0t1CTfy8TarSiB4vqs7h35P4/yJJ6svZ7/zJr0
         QGD74+Ul6sLLclXdkR3fswptIjJwovRETDhwx07U7xf7F+Ufup6oWCEqeTucyZDogPrb
         me72BaQjcOOqSEiKveUiylsfe8Kij0UTYrmOoY32G/f1+8vS33FkMkxmHUjTgWhJgvx5
         GWUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EcyOcNMeJU/82mEIEPpMUaOJoG8hDM3M2omWrK0fdkc=;
        b=I55Z4OQEeEBQy0sw/wwKnuToPW1FnCnm3J58r1Ima5SP/DHJpwjdlDtyA91F8f8Xuv
         ES9lWe3QkBSpSMPjSrq7cNKyCTYYrpT1hpEHCBKqP5Lh5ojwBF3apDSojUH9e4iWKjyF
         Mr/k3odE4BHM2lOOWe6FS1wBmSGNzup5g5lO8LgZwq0mezVErM2/p7yw0nuy2NeMolAk
         EhwX67Ux+r2BbSFjT+8emW2SOGDAKvDri2PjxqQ/iTwUMQCMmrN4tOGOTkCkk0EHU/Jq
         PkfwQxRj8uNqe8bQOZheEjlX8e7wTvZGFSG4TfFjOBo3fULPZ+YnJHkLg40eV6gIJ9Hh
         /1Mw==
X-Gm-Message-State: AOAM532JEVq9/DkOpB+vHfvN6wM3x25kKdNa8drdSVEx7QitkRXbUy33
        WYgtYaHQ6vFXmLJupZrIA8o=
X-Google-Smtp-Source: ABdhPJy5fXMGf8XwKZOvmDpyiBs4F15vmUH4jgfOINDE1k9Q+VOjYE8e0DF1jYxwN4owycT/3LYVkQ==
X-Received: by 2002:a1c:f70a:: with SMTP id v10mr282528wmh.39.1598943331890;
        Mon, 31 Aug 2020 23:55:31 -0700 (PDT)
Received: from [192.168.8.147] ([37.166.79.47])
        by smtp.gmail.com with ESMTPSA id r15sm426365wmn.24.2020.08.31.23.55.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Aug 2020 23:55:31 -0700 (PDT)
Subject: Re: [PATCH net-next] net: diag: add workaround for inode truncation
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, kernel-team@fb.com, zeil@yandex-team.ru,
        khlebnikov@yandex-team.ru, pabeni@redhat.com,
        Dave Marchevsky <davemarchevsky@fb.com>
References: <20200831235956.2143127-1-kuba@kernel.org>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <26351e38-ccbc-c0ce-f12e-96f85913a6dc@gmail.com>
Date:   Tue, 1 Sep 2020 08:55:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200831235956.2143127-1-kuba@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/31/20 4:59 PM, Jakub Kicinski wrote:
> Dave reports that struct inet_diag_msg::idiag_inode is 32 bit,
> while inode's type is unsigned long. This leads to truncation.
> 
> Since there is nothing we can do about the size of existing
> fields - add a new attribute to carry 64 bit inode numbers.
> 
> Reported-by: Dave Marchevsky <davemarchevsky@fb.com>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  include/linux/inet_diag.h      | 1 +
>  include/uapi/linux/inet_diag.h | 1 +
>  net/ipv4/inet_diag.c           | 7 ++++++-
>  3 files changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/inet_diag.h b/include/linux/inet_diag.h
> index 0ef2d800fda7..5ea0f965c173 100644
> --- a/include/linux/inet_diag.h
> +++ b/include/linux/inet_diag.h
> @@ -75,6 +75,7 @@ static inline size_t inet_diag_msg_attrs_size(void)
>  #ifdef CONFIG_SOCK_CGROUP_DATA
>  		+ nla_total_size_64bit(sizeof(u64))  /* INET_DIAG_CGROUP_ID */
>  #endif
> +		+ nla_total_size_64bit(sizeof(u64))  /* INET_DIAG_INODE */
>  		;
>  }
>  int inet_diag_msg_attrs_fill(struct sock *sk, struct sk_buff *skb,
> diff --git a/include/uapi/linux/inet_diag.h b/include/uapi/linux/inet_diag.h
> index 5ba122c1949a..0819a473ee9c 100644
> --- a/include/uapi/linux/inet_diag.h
> +++ b/include/uapi/linux/inet_diag.h
> @@ -160,6 +160,7 @@ enum {
>  	INET_DIAG_ULP_INFO,
>  	INET_DIAG_SK_BPF_STORAGES,
>  	INET_DIAG_CGROUP_ID,
> +	INET_DIAG_INODE,
>  	__INET_DIAG_MAX,
>  };
>  
> diff --git a/net/ipv4/inet_diag.c b/net/ipv4/inet_diag.c
> index 4a98dd736270..6a52947591fc 100644
> --- a/net/ipv4/inet_diag.c
> +++ b/net/ipv4/inet_diag.c
> @@ -125,6 +125,7 @@ int inet_diag_msg_attrs_fill(struct sock *sk, struct sk_buff *skb,
>  			     bool net_admin)
>  {
>  	const struct inet_sock *inet = inet_sk(sk);
> +	unsigned long ino;
>  
>  	if (nla_put_u8(skb, INET_DIAG_SHUTDOWN, sk->sk_shutdown))
>  		goto errout;
> @@ -177,8 +178,12 @@ int inet_diag_msg_attrs_fill(struct sock *sk, struct sk_buff *skb,
>  		goto errout;
>  #endif
>  
> +	ino = sock_i_ino(sk);
> +	if (nla_put_u64_64bit(skb, INET_DIAG_INODE, ino, INET_DIAG_PAD))
> +		goto errout;
> +
>  	r->idiag_uid = from_kuid_munged(user_ns, sock_i_uid(sk));
> -	r->idiag_inode = sock_i_ino(sk);
> +	r->idiag_inode = ino;
>  
>  	return 0;
>  errout:
> 


Last time I checked socket inode numbers were 32bit ?

Is there a plan changing this ?
