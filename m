Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B60B49D485
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 22:29:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232514AbiAZV3E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 16:29:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232524AbiAZV3B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 16:29:01 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29669C061749;
        Wed, 26 Jan 2022 13:29:01 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id s5so1438172ejx.2;
        Wed, 26 Jan 2022 13:29:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=BMc1fVwckCRvw/Dv/tBaShtNrcGUAklyobw2nHDvO1c=;
        b=MsVGuWWcvHFMYVGkvCKoWrVQUUqS/sftypg2xHuw4tAh/9GAZkcw0g9UGyx7c+skzd
         mbYm3JtBOWoohyvkr0LwnVj3TwL65K4Q11h1KAbR9cHb4AOwXKvO9WwSn5h+6jrTq+Xp
         3rFgZ3zwFXEfkOzuCyvF9+/5rZfRPDs9a2cUJ7po0WBNqbeQJhc6mJzSz0cg2AOu1/px
         z98xiUGzjxBykAIHzkfBi9zFzJs14Jq0wUFtA/RX7n4IExyGjdXD/f6iHryO3Cn5Heb3
         hopKtJXpQyRzQZnbUan8qKcova43qkWDy0UBFVczoeOenRG5vtLAHNdoQeG0Wcq6Bmrd
         e+xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=BMc1fVwckCRvw/Dv/tBaShtNrcGUAklyobw2nHDvO1c=;
        b=gz0b5lJs/l2Q/TdqKbQ0kxFjoj6RCly7iPILTB6hdYll4JCy23DFO+00svzZn7ciEF
         3N1cklV/oBWEedMOXc71gxz3sgANJvtJ5e5DkgM7p1OW5Z02rgqYCyr+myrb2wYqu+mn
         qWBm4wpigR3DZ7lylBj0XUxAwNDmF+2PW0uKFpnaMqU17MgELuqcDWuEs9W6i+CaZCC5
         V9ZPdPsEOCD37z7dLgV2PqHEezkxYM0g8tdJe+FFg4k62ISUDAq3Fbqbq5JIm67Ovv3D
         6o3/3LRmXYY1vURBqI/giWY6HxcWtkxL5AmcDlfoYGb9PrwSu9vCNpdufvPf/owKQCTz
         XcZw==
X-Gm-Message-State: AOAM532e0FGQ31FzPszy9ubjeixbdQVMVZOftJKNjia8CiRMZkxY4FVF
        jPnLa92Xu5w+8Yvqq5E/LmM=
X-Google-Smtp-Source: ABdhPJzdEjQQ+/H3DwGTHrLsu06c4n+nkpYjsBjq20ffSS0UfipHwGGIo6GftST34IpxfACJvjR+1A==
X-Received: by 2002:a17:906:31cc:: with SMTP id f12mr495303ejf.115.1643232539521;
        Wed, 26 Jan 2022 13:28:59 -0800 (PST)
Received: from [192.168.8.198] ([85.255.234.222])
        by smtp.gmail.com with ESMTPSA id fy40sm7718078ejc.36.2022.01.26.13.28.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Jan 2022 13:28:59 -0800 (PST)
Message-ID: <fbc8acbe-4c12-9c68-0418-51e97457d30b@gmail.com>
Date:   Wed, 26 Jan 2022 21:28:46 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH for-next v4] cgroup/bpf: fast path skb BPF filtering
Content-Language: en-US
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>, linux-kernel@vger.kernel.org,
        Stanislav Fomichev <sdf@google.com>
References: <94e36de3cc2b579e45f95c189a6f5378bf1480ac.1643156174.git.asml.silence@gmail.com>
 <20220126203055.3xre2m276g2q2tkx@kafai-mbp.dhcp.thefacebook.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20220126203055.3xre2m276g2q2tkx@kafai-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/26/22 20:30, Martin KaFai Lau wrote:
> On Wed, Jan 26, 2022 at 12:22:13AM +0000, Pavel Begunkov wrote:
>>   #define BPF_CGROUP_RUN_PROG_INET_INGRESS(sk, skb)			      \
>>   ({									      \
>>   	int __ret = 0;							      \
>> -	if (cgroup_bpf_enabled(CGROUP_INET_INGRESS))		      \
>> +	if (cgroup_bpf_enabled(CGROUP_INET_INGRESS) && sk &&		      \
>  From reading sk_filter_trim_cap() where this will be called, sk cannot be NULL.
> If yes, the new sk test is not needed.

Well, there is no sane way to verify how it's used considering

EXPORT_SYMBOL(__cgroup_bpf_run_filter_skb);

but can remove the check if nobody cares


> Others lgtm.
> 
>> +	    cgroup_bpf_sock_enabled(sk, CGROUP_INET_INGRESS)) 	      \
>>   		__ret = __cgroup_bpf_run_filter_skb(sk, skb,		      \
>>   						    CGROUP_INET_INGRESS); \
>>   									      \

-- 
Pavel Begunkov
