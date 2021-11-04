Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E777544576D
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 17:44:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231676AbhKDQrJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 12:47:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231684AbhKDQrH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Nov 2021 12:47:07 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41826C06120A;
        Thu,  4 Nov 2021 09:44:29 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id b13so8209111plg.2;
        Thu, 04 Nov 2021 09:44:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6KJURW1u7e7p8ktWh7btj0F0HKwNRv2B8zhFqoFWrBM=;
        b=NTcpIlonhwiDYnrpEIjfUJfoGuhtNj1Euba8n9FTt/EPwDEO5Cctwij3oZtChG2r/n
         I7Yo01xWHo4JgotFSUncL3yh9CQ0c+ozLlLXi3xy8l46n7SfhluzVmDfYFnu45jZ0VeX
         pFxZ91uHQzJWswy6KNx0txxPbOBGdq8ORZAIU8y33WxiNr2zhoDnpCa92999mOxAJ/6L
         DqE4m2SN8UrqBxbkVgkYI46PMY2kcx9lQ+LXDUPjqe0hBdvuckfI9y8RQF6+gvTHCqdn
         emZKxs4MLOuA4bfY0L/3hDd4G3gmFnPZ2cqdxQKnAbcxcfdV46Cu6bhr+wNlj5iWqMve
         mmCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6KJURW1u7e7p8ktWh7btj0F0HKwNRv2B8zhFqoFWrBM=;
        b=o7JC/653bPPF+mkJ4WIohOQGn9NJ2RgH5ORMqNOGhZ031OdGspYjLpElQxEM6fpV95
         N8Itgay/aEYnYdnhMU0BYK7Xp7wRX/CWO5Uc3gY12WowyrOYdyvbcyXGQvDpuwy4ZVat
         /SNtnqJAZZcPuBiGBQztIfzXCmNuTLWtVPtZrpSk87nvQLjQpXkbD3wxznthU+6oUgC4
         p/hwNpNU6NzkkD0p8UK011ssiuFN8V0jEK6M399cr+JODqJiywUONdMy57Gp2+Ca8lnS
         57hlzRs1502RwktAseFaVBSOocnD/L6ZwDXMqC8y484Tl24Xjotme2zjEUDV8Upy82H5
         Wiiw==
X-Gm-Message-State: AOAM531ZDlzuVWYL9t/vEYLNXPRqkdGpmZKUHSFouEVpdIf2GDDp9G+4
        MsLFBSXLhMa9RM8L1Ml1K3A=
X-Google-Smtp-Source: ABdhPJzmAVX0WbDV63R23BnPUT5sXiUy/+ecfcss/9hPyJC8D2qwiZqQYyw3XbCO8dhXWGAgiM3YPQ==
X-Received: by 2002:a17:90b:4a05:: with SMTP id kk5mr8055736pjb.142.1636044268829;
        Thu, 04 Nov 2021 09:44:28 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id p14sm4402974pjb.9.2021.11.04.09.44.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Nov 2021 09:44:28 -0700 (PDT)
Subject: Re: [PATCH] ipv6: remove useless assignment to newinet in
 tcp_v6_syn_recv_sock()
To:     Nghia Le <nghialm78@gmail.com>, edumazet@google.com,
        davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, kernel-janitors@vger.kernel.org,
        lukas.bulwahn@gmail.com
References: <20211104143740.32446-1-nghialm78@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <bed89145-c9a5-ba76-2446-dee8cd35c7da@gmail.com>
Date:   Thu, 4 Nov 2021 09:44:26 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211104143740.32446-1-nghialm78@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/4/21 7:37 AM, Nghia Le wrote:
> The newinet value is initialized with inet_sk() in a block code to
> handle sockets for the ETH_P_IP protocol. Along this code path,
> newinet is never read. Thus, assignment to newinet is needless and
> can be removed.
> 
> Signed-off-by: Nghia Le <nghialm78@gmail.com>
> ---
>  net/ipv6/tcp_ipv6.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
> index 2cc9b0e53ad1..551fce49841d 100644
> --- a/net/ipv6/tcp_ipv6.c
> +++ b/net/ipv6/tcp_ipv6.c
> @@ -1263,7 +1263,6 @@ static struct sock *tcp_v6_syn_recv_sock(const struct sock *sk, struct sk_buff *
>  
>  		inet_sk(newsk)->pinet6 = tcp_inet6_sk(newsk);
>  
> -		newinet = inet_sk(newsk);
>  		newnp = tcp_inet6_sk(newsk);
>  		newtp = tcp_sk(newsk);
>  
> 

Reviewed-by: Eric Dumazet <edumazet@google.com>
