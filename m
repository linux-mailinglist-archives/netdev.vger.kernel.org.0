Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D298164F43
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 20:53:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726799AbgBSTxM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 14:53:12 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:45280 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726651AbgBSTxM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 14:53:12 -0500
Received: by mail-pg1-f194.google.com with SMTP id b9so609508pgk.12
        for <netdev@vger.kernel.org>; Wed, 19 Feb 2020 11:53:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8/Ys+gfNzOc1gS/xW+HhTtx5JivFD5N5QkMkpiMQA3s=;
        b=YyeJO/PHTyGXhRoDa2kZVHfE1sKfnoKHzs2rUvPLTiCCCvPCV/F9YJ6UJgai8B1TPL
         NoEI4VF+VZgr1YxucvQSz8mGItCWhjOLj/oTBqTAo1jQGKNiVE3qz3w6qNGGUsGfvv35
         Ul/GefXJsYhIfE5f7T/+gLbaliFDfp9TLhsRQAqeIbvwUkkxra1Bv7QvPZL0xJhwMH+w
         /txTaH8maEizq6lgn8drUepvzZwIqPvzjmljD9mQ3LMJAGc7GnmYGSaHwYRmfSR8Ospn
         i0pKRg1F8NE32Ql5ksennOlvQAuHM/+aOYaH0QfwzkFtu50UOTLplMGYman7D5LedOS4
         GZZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8/Ys+gfNzOc1gS/xW+HhTtx5JivFD5N5QkMkpiMQA3s=;
        b=Cxt+eqrCG1LrvfgxxNvzU/AsN2+Kpp6mV2ASpyEKOV0+BbpRcumaP4c9MmzCa4Hjm8
         svFXF5fscKonttuP5xyD6yETTANDueUiCuvYpbMst6s3x6faQLsbxMd+JVcP7eNqKU6G
         cNgYSjFCEA4UO/9bPKmlzDeapIeiiP0q8XYg6aEDPr091jmu+XhSoDAM7uCt41nLKfyK
         XC9xon0TDY6HiB1fA625lWJWQf18/lXpO7DuD2qPoyI9/YjBRTNMQL5AwLlkY0AZkukg
         EEBluC2nCvTea7AnBtPPnceylryvMBFPdX/OAFuQL8XnS9ZpFjw+SiAl/SNtFtO1s/gh
         3aHA==
X-Gm-Message-State: APjAAAWLRKhJNfe0xsMUM4FTC/MXe55vWPfpZBYAXVg66OxPx6wDgh28
        SwU/8gRqPTll3iWNE1hwn/o=
X-Google-Smtp-Source: APXvYqxJ/QqiMVO6FbtKzvlafJ2cYfM8AQFnGb7Ib07vFOGfea9NVIYFcBm/EwxOpZr3S7IaHf/t1g==
X-Received: by 2002:a65:4486:: with SMTP id l6mr26980997pgq.1.1582141991858;
        Wed, 19 Feb 2020 11:53:11 -0800 (PST)
Received: from [172.20.2.64] (rrcs-24-43-226-3.west.biz.rr.com. [24.43.226.3])
        by smtp.gmail.com with ESMTPSA id b18sm436587pfb.116.2020.02.19.11.53.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Feb 2020 11:53:11 -0800 (PST)
Subject: Re: [PATCH net] udp: rehash on disconnect
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, plroskin@gmail.com, edumazet@google.com,
        Willem de Bruijn <willemb@google.com>
References: <20200219191632.253526-1-willemdebruijn.kernel@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <8298ddb4-336f-d1ee-d535-21770a3a1bb6@gmail.com>
Date:   Wed, 19 Feb 2020 11:53:09 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200219191632.253526-1-willemdebruijn.kernel@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/19/20 11:16 AM, Willem de Bruijn wrote:
> From: Willem de Bruijn <willemb@google.com>
> 
> As of the below commit, udp sockets bound to a specific address can
> coexist with one bound to the any addr for the same port.
> 
> The commit also phased out the use of socket hashing based only on
> port (hslot), in favor of always hashing on {addr, port} (hslot2).
> 
> The change broke the following behavior with disconnect (AF_UNSPEC):
> 
>     server binds to 0.0.0.0:1337
>     server connects to 127.0.0.1:80
>     server disconnects
>     client connects to 127.0.0.1:1337
>     client sends "hello"
>     server reads "hello"	// times out, packet did not find sk
> 
> On connect the server acquires a specific source addr suitable for
> routing to its destination. On disconnect it reverts to the any addr.
> 
> The connect call triggers a rehash to a different hslot2. On
> disconnect, add the same to return to the original hslot2.
> 
> Skip this step if the socket is going to be unhashed completely.
> 
> Fixes: 4cdeeee9252a ("net: udp: prefer listeners bound to an address")
> Reported-by: Pavel Roskin <plroskin@gmail.com>
> Signed-off-by: Willem de Bruijn <willemb@google.com>
> ---
>  net/ipv4/udp.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
> index db76b96092991..08a41f1e1cd22 100644
> --- a/net/ipv4/udp.c
> +++ b/net/ipv4/udp.c
> @@ -1857,8 +1857,12 @@ int __udp_disconnect(struct sock *sk, int flags)
>  	inet->inet_dport = 0;
>  	sock_rps_reset_rxhash(sk);
>  	sk->sk_bound_dev_if = 0;
> -	if (!(sk->sk_userlocks & SOCK_BINDADDR_LOCK))
> +	if (!(sk->sk_userlocks & SOCK_BINDADDR_LOCK)) {
>  		inet_reset_saddr(sk);
> +		if (sk->sk_prot->rehash &&
> +		    (sk->sk_userlocks & SOCK_BINDPORT_LOCK))
> +			sk->sk_prot->rehash(sk);
> +	}
>  
>  	if (!(sk->sk_userlocks & SOCK_BINDPORT_LOCK)) {
>  		sk->sk_prot->unhash(sk);
> 

Reviewed-by: Eric Dumazet <edumazet@google.com>

