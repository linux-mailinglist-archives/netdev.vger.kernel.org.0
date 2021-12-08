Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72BD246D774
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 16:54:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236396AbhLHP5c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 10:57:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbhLHP5c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 10:57:32 -0500
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34608C0617A1
        for <netdev@vger.kernel.org>; Wed,  8 Dec 2021 07:54:00 -0800 (PST)
Received: by mail-oi1-x234.google.com with SMTP id t19so4706231oij.1
        for <netdev@vger.kernel.org>; Wed, 08 Dec 2021 07:54:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=4tDzHMwyFwNkytGlATdsqcpRw1WvysTioxOljYkdZmk=;
        b=bjRdHV/k0XGU9gxDfTzUWwp14PauEwc6AJxflD8UG3grB44dgKak70uDK5hjesBzus
         vr6ljJg4JBPqUDxuAezSqQqPNZuENv/zCXaqjeiUYWRZSWC43cG8APBi5XntNxHRoJ5b
         FdNt6VwDubd04pZahfBB9LULeN0VnqLgnEIw+OzdkMyp82PmCPZvPAym9gdfpIDxmsMg
         illOaWRLi7axODpRJ41Htu02eW8XykqJSx7RG7Y1Isbsj/uD3/RunWmdm6lBHQJu4unw
         hzmFi9UxsNJtHKc+OAHGLbroFBoZ4dWjLPYF1N8d+Xc6AylkL/lUW4chZwZhl9dK/s12
         Fqsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=4tDzHMwyFwNkytGlATdsqcpRw1WvysTioxOljYkdZmk=;
        b=tleXEXrVwuD5aB3aeFM9HvN5nNH3HTJtgjLLGCIyQL0esclk11/pObOGQtimR2LeLS
         mG6sUT1EyB0YLecPC+MSope1mnsjOFOUu5Z64LT/OTOcpG4BQf6QojtUtS/B0XX1oFjR
         eey20WMkv2ebSflBXfGEQUjLNAEoPJceVeBtk27Ontrj3wUHjuJckgBjbzFNY/734V5p
         ma9d55yIMHxWRW+/uSLtK80Ns+TuxoipViVk1mE3GSeSYGQdLNJfdbKK2AP9saBmszJD
         BpptoiMdV7K9v4jf3+3XkY0Tlg7nAk6Ne8sW7Hksa5bGWeDAWrdbJTbjNhTExIbN1qyF
         GwLA==
X-Gm-Message-State: AOAM530ennavknxNc4FEkDazogrA6po+ebEn0Zbd9eF8FMf41tNBOUwD
        ueXvEOjH/vErldKmVgk6nRU=
X-Google-Smtp-Source: ABdhPJz68FQD1NAmC5CiC78pge2pYzeJnegzqsy/FWFYL2fenerPfhEV1G6xAa8HlSXkNMNy121dpQ==
X-Received: by 2002:a05:6808:1315:: with SMTP id y21mr301519oiv.103.1638978839589;
        Wed, 08 Dec 2021 07:53:59 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id u136sm655063oie.13.2021.12.08.07.53.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Dec 2021 07:53:59 -0800 (PST)
Message-ID: <ded3d280-efcd-810e-c29c-7296f97cb181@gmail.com>
Date:   Wed, 8 Dec 2021 08:53:57 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.2
Subject: Re: [PATCH net] net, neigh: clear whole pneigh_entry at alloc time
Content-Language: en-US
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Roopa Prabhu <roopa@nvidia.com>
References: <20211206165329.1049835-1-eric.dumazet@gmail.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20211206165329.1049835-1-eric.dumazet@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/6/21 9:53 AM, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Commit 2c611ad97a82 ("net, neigh: Extend neigh->flags to 32 bit
> to allow for extensions") enables a new KMSAM warning [1]
> 
> I think the bug is actually older, because the following intruction
> only occurred if ndm->ndm_flags had NTF_PROXY set.
> 
> 	pn->flags = ndm->ndm_flags;
> 
> Let's clear all pneigh_entry fields at alloc time.
> 

All of the fields - except the new flags field - are initialized after
the alloc. Why do you think the bug is older?

...

> Fixes: 62dd93181aaa ("[IPV6] NDISC: Set per-entry is_router flag in Proxy NA.")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Roopa Prabhu <roopa@nvidia.com>
> ---
>  net/core/neighbour.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/net/core/neighbour.c b/net/core/neighbour.c
> index 72ba027c34cfea6f38a9e78927c35048ebfe7a7f..dda12fbd177ba6ad2798ea2b07733fa3f03441ab 100644
> --- a/net/core/neighbour.c
> +++ b/net/core/neighbour.c
> @@ -763,11 +763,10 @@ struct pneigh_entry * pneigh_lookup(struct neigh_table *tbl,
>  
>  	ASSERT_RTNL();
>  
> -	n = kmalloc(sizeof(*n) + key_len, GFP_KERNEL);
> +	n = kzalloc(sizeof(*n) + key_len, GFP_KERNEL);
>  	if (!n)
>  		goto out;
>  
> -	n->protocol = 0;
>  	write_pnet(&n->net, net);
>  	memcpy(n->key, pkey, key_len);
>  	n->dev = dev;
> 

Reviewed-by: David Ahern <dsahern@kernel.org>
