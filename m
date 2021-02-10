Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A632F316977
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 15:52:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231694AbhBJOwZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 09:52:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229888AbhBJOwS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 09:52:18 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FEEDC06174A;
        Wed, 10 Feb 2021 06:51:36 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id m1so2069215wml.2;
        Wed, 10 Feb 2021 06:51:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zjhXKo3lnsUCaAO03EAAKy7XedvCevX8vo7EKjAoj3Q=;
        b=jJ8LF025NOB5tTRRmh45iSwVNW9BiH2jesDquvAlwBgGfOycUUj9SneIWmt0+ZsKNg
         G4jfNkdmBdVwNrf6KziMjZyDhDfsh0VTabiZ88CqjMSEyWAAB9KcF0LqWF574ojQJWfB
         uEcBjTGL5J1sN7VltBi5masq/ykxXWJ71FekRuG1mMOVHDXcYAaB69OZ0pm/EZyGUojM
         E8ghijNjy9n51CKDhciWDBttcc7mGU9VLnekLrNRsHhHEJw6eo3kNbDjNnFbJryP9S1m
         HqCjtV55tT0SgA+5jTrOqavLEvYCCRxhlE/v9SL/9kkxp+24Qjc3js9+kLYBwSORR2i+
         /jyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zjhXKo3lnsUCaAO03EAAKy7XedvCevX8vo7EKjAoj3Q=;
        b=N0NSqR7UJcDgyWO/9pfk5rjy2qj1WSru0YnBPESxmPdaloVurwSjVrzHn/driXgDQM
         X8PTlMUwGV+XNd5qs0dXNxnTsJb5M30fE0w1ArsgkhiUCZyzeLEKkWGsNvSNAeZDsDnX
         ilsW5+XVTDaY3mNDCphDp2uNFHELY4tVL2cXhPNbbLhOnEWaB+BRJQcbq3KNieNy//VO
         8JjWI6bEwRS/C7W1WLSfxk9xnAtS4qYzAK3/pvxkpZYWoqoGbDSbwTsGVMnr/77IJIis
         sjUfvH2B6MKjv03KQhYOiSCqc7V+f63nn4HtGvWg4cBZ8VZngZoV4983t1EGrM7v8cd9
         R7gA==
X-Gm-Message-State: AOAM531BYnuYLAHIBaTrzjxGkPbQjsCpPNQkflsWWmmPHZW69fhi1GwZ
        2VZSz06yZmbgh2SjqBfr8yxc40ffyFE=
X-Google-Smtp-Source: ABdhPJzD1UwIOcK8QlbA/opY/7S8Oipu5m0gukv+y2QgFJwbqk6JJMIT/ifLddt6Wbwu5S+4rtPxqA==
X-Received: by 2002:a1c:67c3:: with SMTP id b186mr3336454wmc.24.1612968695135;
        Wed, 10 Feb 2021 06:51:35 -0800 (PST)
Received: from [192.168.1.101] ([37.170.168.78])
        by smtp.gmail.com with ESMTPSA id v15sm4054700wra.61.2021.02.10.06.51.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Feb 2021 06:51:34 -0800 (PST)
Subject: Re: [PATCH bpf 1/4] net: add SO_NETNS_COOKIE socket option
To:     Lorenz Bauer <lmb@cloudflare.com>,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Helge Deller <deller@gmx.de>,
        "David S. Miller" <davem@davemloft.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     kernel-team@cloudflare.com, linux-api@vger.kernel.org,
        linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
        sparclinux@vger.kernel.org, linux-arch@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
References: <20210210120425.53438-1-lmb@cloudflare.com>
 <20210210120425.53438-2-lmb@cloudflare.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <a922e31d-efce-35c3-c584-cf1bdcf93c5d@gmail.com>
Date:   Wed, 10 Feb 2021 15:51:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210210120425.53438-2-lmb@cloudflare.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/10/21 1:04 PM, Lorenz Bauer wrote:
> We need to distinguish which network namespace a socket belongs to.
> BPF has the useful bpf_get_netns_cookie helper for this, but accessing
> it from user space isn't possible. Add a read-only socket option that
> returns the netns cookie, similar to SO_COOKIE. If network namespaces
> are disabled, SO_NETNS_COOKIE returns the cookie of init_net.
> 
> The BPF helpers change slightly: instead of returning 0 when network
> namespaces are disabled we return the init_net cookie as for the
> socket option.
> 
> Cc: linux-api@vger.kernel.org
> Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> ---

...

>  
> +static inline u64 __sock_gen_netns_cookie(struct sock *sk)
> +{
> +#ifdef CONFIG_NET_NS
> +	return __net_gen_cookie(sk->sk_net.net);
> +#else
> +	return __net_gen_cookie(&init_net);
> +#endif
> +}
> +
> +static inline u64 sock_gen_netns_cookie(struct sock *sk)
> +{
> +	u64 cookie;
> +
> +	preempt_disable();
> +	cookie = __sock_gen_netns_cookie(sk);
> +	preempt_enable();
> +
> +	return cookie;
> +}
> +
> 

I suggest we make net->net_cookie a mere u64 initialized in setup_net(),
instead of having to preempt_disable() around reading it.

(Here and in your patch 2/4)

Your patches would be much simpler.

Cleanup patch :

https://patchwork.kernel.org/project/netdevbpf/patch/20210210144144.24284-1-eric.dumazet@gmail.com/


