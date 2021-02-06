Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 778A9311BC5
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 07:58:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229565AbhBFG6K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Feb 2021 01:58:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbhBFG6J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Feb 2021 01:58:09 -0500
Received: from mail-oo1-xc2f.google.com (mail-oo1-xc2f.google.com [IPv6:2607:f8b0:4864:20::c2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CA32C06174A
        for <netdev@vger.kernel.org>; Fri,  5 Feb 2021 22:57:29 -0800 (PST)
Received: by mail-oo1-xc2f.google.com with SMTP id x19so2209715ooj.10
        for <netdev@vger.kernel.org>; Fri, 05 Feb 2021 22:57:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8DiMpJT7Um/2h89dIOS5f4b7jbuvRU//md1Pt6mD0vg=;
        b=gH5yS/7h3a7LXhrpwZpZpwh1Zi6rHdaOhJ7cRk5qtft8A7LrOILZ+HNvpNzhmuZTLK
         EmVVdoJynYQey2z/Tere+LxM9OlTxkcI93+gz1GFTLH0fveR8n0B/c/BtQ4V7oWjCbDa
         UZfsGRaEW5q0RPhtx1fQR33JSAYNs9ugi9bYhrTxE46ewJq/4NFcFXj8VTbUX/jv83LG
         mfd8YFcQZ7NpQV4mTIsLjTmx4ilPtxXbEQ/L3e6FO55JUUwlcx0GSll3Q50GAWoksbjb
         e4C96VZnr7DGuJ9ntK38iHe38/kRO0CyPyeLHPr9KSalI2G2uQwq/prrEjynI20avHmE
         BASA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8DiMpJT7Um/2h89dIOS5f4b7jbuvRU//md1Pt6mD0vg=;
        b=WQu3Y8Tm9y1quurIh2nVtmrE73yqIi0SZrdH/H4ty4W6EWPRBOpZpEFaftjRYQlYt2
         ffo8RY6QLChLVVsUfcYSzW6tQqSgw1BOlDzK+2JdHsaqc41LMsTxR1TI88KF89TJEwdx
         i1gHzjEApvG2kGptWpYRf2RKys8hkCMJuqmGAdsdYHpQ2RYnCDMM2SdR/HnhYOkOvwzO
         lIOQISqJeV40anu+HZrUj8ceCeMXtanqjz7aCLidDk7lkgu8ZZbuElp83bC7Ey8fETUC
         yb6kBtQJdJQ7vqajUCzQIZT1u/kHde81IYuOQWiNGt4rYTgmD4qp4+RYhNfRbMrggMu8
         B/tw==
X-Gm-Message-State: AOAM531VrGtMoAb6Z8PPgg76mYC/7xVlnvVZdynqFFnykesSmiFRVGX5
        t0JZYaz2z9I7vCI9a3V/H+A=
X-Google-Smtp-Source: ABdhPJyJB0xhb3w0kXszY44BHfUjfre7VNjsh4CRlh612FFK2X5UdkbuRoi9n7880pynObOrwYnKIA==
X-Received: by 2002:a4a:4c97:: with SMTP id a145mr6090216oob.16.1612594648526;
        Fri, 05 Feb 2021 22:57:28 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id o16sm2295923ote.79.2021.02.05.22.57.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Feb 2021 22:57:27 -0800 (PST)
Subject: Re: [net] tcp: Explicitly mark reserved field in tcp_zerocopy_receive
 args.
To:     Arjun Roy <arjunroy.kdev@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org
Cc:     arjunroy@google.com, edumazet@google.com, soheil@google.com,
        Leon Romanovsky <leon@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
References: <20210205230127.310521-1-arjunroy.kdev@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <5bc63873-67e1-c3bd-116e-7b40a15d7d92@gmail.com>
Date:   Fri, 5 Feb 2021 23:57:25 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210205230127.310521-1-arjunroy.kdev@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/5/21 4:01 PM, Arjun Roy wrote:
> From: Arjun Roy <arjunroy@google.com>
> 
> Explicitly define reserved field and require it to be 0-valued.
> 
> Fixes: 7eeba1706eba ("tcp: Add receive timestamp support for receive zerocopy.")
> Signed-off-by: Arjun Roy <arjunroy@google.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Soheil Hassas Yeganeh <soheil@google.com>
> Suggested-by: David Ahern <dsahern@gmail.com>
> Suggested-by: Leon Romanovsky <leon@kernel.org>
> Suggested-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  include/uapi/linux/tcp.h | 2 +-
>  net/ipv4/tcp.c           | 2 ++
>  2 files changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/include/uapi/linux/tcp.h b/include/uapi/linux/tcp.h
> index 42fc5a640df4..8fc09e8638b3 100644
> --- a/include/uapi/linux/tcp.h
> +++ b/include/uapi/linux/tcp.h
> @@ -357,6 +357,6 @@ struct tcp_zerocopy_receive {
>  	__u64 msg_control; /* ancillary data */
>  	__u64 msg_controllen;
>  	__u32 msg_flags;
> -	/* __u32 hole;  Next we must add >1 u32 otherwise length checks fail. */
> +	__u32 reserved; /* set to 0 for now */
>  };
>  #endif /* _UAPI_LINUX_TCP_H */
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index e1a17c6b473c..97aee57ab9b4 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -4159,6 +4159,8 @@ static int do_tcp_getsockopt(struct sock *sk, int level,
>  		}
>  		if (copy_from_user(&zc, optval, len))
>  			return -EFAULT;
> +		if (zc.reserved)
> +			return -EOPNOTSUPP;

usually invalid values for uapi return -EINVAL
