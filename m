Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44E1B21FE8
	for <lists+netdev@lfdr.de>; Fri, 17 May 2019 23:51:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727994AbfEQVvw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 May 2019 17:51:52 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:40036 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727239AbfEQVvw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 May 2019 17:51:52 -0400
Received: by mail-pf1-f193.google.com with SMTP id u17so4295551pfn.7;
        Fri, 17 May 2019 14:51:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vKTywSie20PHVC+gh3ALmwP1wNcXOGPfZhP6bhLQuLg=;
        b=AFWZIX9SpWdoJ+jkt6VyXA7FgBbBpVlj5cEIBtlFAUKj4eQEsCPhK/l6iqZWZN2M9a
         +xZraq+SMdPEYEZtZT1BRQrLOxd4SIivN6kecQcDIctFbfBOmFkhObmx7cMzYOykiehp
         1d/hQ4jqkYrU8p4jfWIdYaDoIQw4z7re1kVnNM5gpjlVpOE2fWfK8JUt7VV/d0h492FK
         jpdG1C1NK7Mh/lxCNhT5RmBKvFrbWxvJg4GoHoxVbcpoSSlKyuING0CJb47OaNV5ssTB
         A46gQcpPfXYS/ju61utxO6r1nKNy704lf2A2+xkO33uH6oUi492lRUl/2yu07njc+4WX
         z2Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vKTywSie20PHVC+gh3ALmwP1wNcXOGPfZhP6bhLQuLg=;
        b=dDzVRUR92KuLwfhGJUIIKAXbFMhL6WB+pC92+raW92FeoAR6njLxY2ZGHytXX3OtpI
         NpiBX/i+cCucdeCRw2qDKz5AfnE5ycUcksVCuZ9WDEDyY7ZoCokmEVkpU4ppsqqU42Ti
         GcNa4pQY2Nqx8q8RXEpUy6HlG7h3m+9qxvzeJ7C0Oq9/9MVldmzuUdbm3FtJmvZzq2oq
         dhMlg6JIXFNzIW5Yy/KPk314yU/yov6CeKG7ISwv0vpItr+oPXrCPgg1S2xhPJ/c4nsD
         5MrbksGRcAbWGZ0AV9uozMQd9E4nlBGUxKdPRZiQIPj5xBfYYZuh9nc6nOnP5KWDQGmb
         Jd1g==
X-Gm-Message-State: APjAAAVyKo+YsX74Z1u5E+fqhkz33X+vTDouV/GEdZ11v0wOQaquOtio
        MIYqmP/5hr5oie2kbN+wNNU=
X-Google-Smtp-Source: APXvYqxtr3rvkPAN7bisoVJOG3FCjvRT171MsV4nnVbCh1CvWumqd1A8T2Avg+su4rkzlYPcY0cIng==
X-Received: by 2002:a62:7608:: with SMTP id r8mr62372435pfc.190.1558129911485;
        Fri, 17 May 2019 14:51:51 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-70.hsd1.ca.comcast.net. [73.241.150.70])
        by smtp.gmail.com with ESMTPSA id i7sm5132014pfo.19.2019.05.17.14.51.49
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 17 May 2019 14:51:50 -0700 (PDT)
Subject: Re: [PATCH bpf] bpf: Check sk_fullsock() before returning from
 bpf_sk_lookup()
To:     Martin KaFai Lau <kafai@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, kernel-team@fb.com,
        Joe Stringer <joe@isovalent.com>
References: <20190517212117.2792415-1-kafai@fb.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <6dc01cb7-cdd4-8a71-b602-0052b7aadfb7@gmail.com>
Date:   Fri, 17 May 2019 14:51:48 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190517212117.2792415-1-kafai@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/17/19 2:21 PM, Martin KaFai Lau wrote:
> The BPF_FUNC_sk_lookup_xxx helpers return RET_PTR_TO_SOCKET_OR_NULL.
> Meaning a fullsock ptr and its fullsock's fields in bpf_sock can be
> accessed, e.g. type, protocol, mark and priority.
> Some new helper, like bpf_sk_storage_get(), also expects
> ARG_PTR_TO_SOCKET is a fullsock.
> 
> bpf_sk_lookup() currently calls sk_to_full_sk() before returning.
> However, the ptr returned from sk_to_full_sk() is not guaranteed
> to be a fullsock.  For example, it cannot get a fullsock if sk
> is in TCP_TIME_WAIT.
> 
> This patch checks for sk_fullsock() before returning. If it is not
> a fullsock, sock_gen_put() is called if needed and then returns NULL.
> 
> Fixes: 6acc9b432e67 ("bpf: Add helper to retrieve socket in BPF")
> Cc: Joe Stringer <joe@isovalent.com>
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> ---
>  net/core/filter.c | 16 ++++++++++++++--
>  1 file changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 55bfc941d17a..85def5a20aaf 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -5337,8 +5337,14 @@ __bpf_sk_lookup(struct sk_buff *skb, struct bpf_sock_tuple *tuple, u32 len,
>  	struct sock *sk = __bpf_skc_lookup(skb, tuple, len, caller_net,
>  					   ifindex, proto, netns_id, flags);
>  
> -	if (sk)
> +	if (sk) {
>  		sk = sk_to_full_sk(sk);
> +		if (!sk_fullsock(sk)) {
> +			if (!sock_flag(sk, SOCK_RCU_FREE))
> +				sock_gen_put(sk);

This looks a bit convoluted/weird.

What about telling/asking __bpf_skc_lookup() to not return a non fullsock instead ?

> +			return NULL;
> +		}
> +	}
>  
>  	return sk;
>  }
> @@ -5369,8 +5375,14 @@ bpf_sk_lookup(struct sk_buff *skb, struct bpf_sock_tuple *tuple, u32 len,
>  	struct sock *sk = bpf_skc_lookup(skb, tuple, len, proto, netns_id,
>  					 flags);
>  
> -	if (sk)
> +	if (sk) {
>  		sk = sk_to_full_sk(sk);
> +		if (!sk_fullsock(sk)) {
> +			if (!sock_flag(sk, SOCK_RCU_FREE))
> +				sock_gen_put(sk);
> +			return NULL;
> +		}
> +	}
>  
>  	return sk;
>  }
> 
