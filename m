Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D654B4F9F88
	for <lists+netdev@lfdr.de>; Sat,  9 Apr 2022 00:18:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235270AbiDHWUy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 18:20:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231282AbiDHWUw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 18:20:52 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8699EBAFD;
        Fri,  8 Apr 2022 15:18:46 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id x16so9543853pfa.10;
        Fri, 08 Apr 2022 15:18:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=IxpsMpZ3C9rS1Rmh+iEYTARaz89fma8euHj3cZKcdEo=;
        b=jBZVxb+4em7+l8gCZd9YFbA8lZkw2QKQpUC/Hiw16f536DnrbHtYt3BSg9E75BsnmQ
         UvH+V/Mn4TkOiCoXloAvhAkYBo7muCtaby7CEt976ffu6s+GbtGtposlkDegrp3BPSeu
         d3QMph6xB3HWu6Al663JTLqiPrAAfWH5Ql9auea7dIU00PdQkpnXlq7LpCEOfYKVyvzi
         9TswkYMSEP8krHTt1adBdptE6A0Nrw0hH/hcNA2j3GWCeCRqxEj9w2pzhXzM3DhOYoKB
         P21MeX8MI07LsJB0uSYmrQxt5z4JkULtlKmhRz262bwGGb66i5TmEc3xfKfTwQfh7L8f
         cGEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=IxpsMpZ3C9rS1Rmh+iEYTARaz89fma8euHj3cZKcdEo=;
        b=x9tq/6XRLAodjclF9u2FoQOUO3mm+/uAckVYDk1DF/H/R4I6TnfVGiwhRtqouaSZf+
         u28Na+t/IGGqO7Hsx3mMr9lcUPzfZQXq4/M2/qyD6u5GZu77982QO4tx/fyMai6SQIBz
         3gup9NJ63DXVk83SYssCy9t0S72p14IzjHz6qQBs1HdzqipHlf6E94NBvIgADFDv/Zcm
         t4QXXHxg4xBSFEmFjq0S+RPAtN4gKN+9sCEscpgcEEzZCOfzuckglgbU2uMhZG8UWBhk
         8hajxT8XDtpBDCvh2P3A09MeWmF07V22gwRpw3bY7G09At/7yPMSlM9Dxv5m5kUYNlEi
         FL4Q==
X-Gm-Message-State: AOAM531s2QIENs9xFKpafAaQyJU8TAChUGcacVOBleBHpDwMVdbBpwF6
        aTP55aGM7UOih4YNUSY/m6w=
X-Google-Smtp-Source: ABdhPJwDswQ+YfAJ8JstMCAUjZGGGmOvBVl9QjD5DB5UTpf9OVO3GmmFKnD90oNpU+aq1YnwoxZseQ==
X-Received: by 2002:a05:6a00:ccf:b0:4fa:abfe:e0f6 with SMTP id b15-20020a056a000ccf00b004faabfee0f6mr21823689pfv.67.1649456326356;
        Fri, 08 Apr 2022 15:18:46 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id q3-20020a63ae03000000b003820cc3a451sm23070435pgf.45.2022.04.08.15.18.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Apr 2022 15:18:46 -0700 (PDT)
Message-ID: <85da2373-d8ec-0049-bd3d-6b8f4b044edc@gmail.com>
Date:   Fri, 8 Apr 2022 15:18:43 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH net] ipv6: fix panic when forwarding a pkt with no in6 dev
Content-Language: en-US
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Eric Dumazet <edumazet@google.com>,
        kongweibin <kongweibin2@huawei.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Vasily Averin <vvs@virtuozzo.com>,
        Martin KaFai Lau <kafai@fb.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, rose.chen@huawei.com,
        liaichun@huawei.com, stable@vger.kernel.org
References: <59150cd5-9950-2479-a992-94dcdaa5e63c@6wind.com>
 <20220408140342.19311-1-nicolas.dichtel@6wind.com>
From:   Eric Dumazet <edumazet@gmail.com>
In-Reply-To: <20220408140342.19311-1-nicolas.dichtel@6wind.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 4/8/22 07:03, Nicolas Dichtel wrote:
> kongweibin reported a kernel panic in ip6_forward() when input interface
> has no in6 dev associated.
>
> The following tc commands were used to reproduce this panic:
> tc qdisc del dev vxlan100 root
> tc qdisc add dev vxlan100 root netem corrupt 5%

Not sure I understand how these qdisc changes can trigger a NULL idev ?

Do we have another bug, like skb->cb[] content being mangled ?


>
> CC: stable@vger.kernel.org
> Fixes: ccd27f05ae7b ("ipv6: fix 'disable_policy' for fwd packets")
> Reported-by: kongweibin <kongweibin2@huawei.com>
> Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
> ---
>
> kongweibin, could you test this patch with your setup?
>
> Thanks,
> Nicolas
>
>   net/ipv6/ip6_output.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
> index e23f058166af..fa63ef2bd99c 100644
> --- a/net/ipv6/ip6_output.c
> +++ b/net/ipv6/ip6_output.c
> @@ -485,7 +485,7 @@ int ip6_forward(struct sk_buff *skb)
>   		goto drop;
>   
>   	if (!net->ipv6.devconf_all->disable_policy &&
> -	    !idev->cnf.disable_policy &&
> +	    (!idev || !idev->cnf.disable_policy) &&
>   	    !xfrm6_policy_check(NULL, XFRM_POLICY_FWD, skb)) {
>   		__IP6_INC_STATS(net, idev, IPSTATS_MIB_INDISCARDS);
>   		goto drop;
