Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11E38348225
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 20:49:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237979AbhCXTsd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 15:48:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237892AbhCXTr6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 15:47:58 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60344C061763
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 12:47:58 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id k128so11152210wmk.4
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 12:47:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1FeJH/VMdgiDXmAKXlvTZmQCQ/yHGjuMnpWAa3BNzXw=;
        b=n46dMb3763qgQJVL19NkGz7dHLBvvM8VzjoC4bG7c8TEcu/cQKZnSvj9TRh4SoXlWs
         h0APtrxTjWIIy1Au7ikEz1xvoZnJQZbqz8TBqKQWjYGE9KEVZh6FXjiy7h+cwiqBXca1
         ohMDnwWSnE2rPN147tjJm+Lp/5TIsOGgtX9n+Uj/20iknbRnMJ8RclYjzUNV+XllI+0y
         BGrd994H7898iZHz1WTkYGbSj3siUxsej5+zeHCDrd2XKXz1j9zcfg31kAqGrsUQHU/B
         /R2MMR8XDveJ9r45KVRgTTOT9haNZGP/4YLrHWxQdD0HmE6825zenu2TFf/QyJsSr3Di
         lR/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1FeJH/VMdgiDXmAKXlvTZmQCQ/yHGjuMnpWAa3BNzXw=;
        b=SxAVmBB2KyGeGSl19W8MJorJBCGxeBy2W7pqDGmuauMnwkfdfFFVaIv164wMun9EDH
         1X1vGl0Y+gKHjLu5NZPbsai7c0jPJonp/nvfyV/HnrXXcIe73hL7TtbuAq/bNuZOLwu1
         ux10ZEXXXNy+2rMjeaSVx2faAjmWDnPSV/IEmIIU5yAiAThbH/JJA0TGeqNSYxT9c71m
         +SHT2KKqT83dqNPz8aqYxVzlbsPQl024o714KtswtfcUT9G23DajDE2meAwcCnOhpcyj
         KoF+jwJTUXTBWgGibsOzdaJlhCGLLJ8kvKRCP3rjYMKTe4709Mu+cH98ADmb18YOIQPC
         mIAA==
X-Gm-Message-State: AOAM531auzVG2qkjqjDHX/PlB9Pvf4KIHnYno+PIw8Kk7x2xkMuKedGI
        kzY8SSdJqSg7Rkcapa9L754=
X-Google-Smtp-Source: ABdhPJzdnS7VIAS6oKQ/5nEfEGpI+juBqJ22AggzeRvxhqF3ioIcoI223iw+K3VEKkyfjt4zRf2MlA==
X-Received: by 2002:a1c:e244:: with SMTP id z65mr4482345wmg.130.1616615277176;
        Wed, 24 Mar 2021 12:47:57 -0700 (PDT)
Received: from [192.168.1.101] ([37.167.241.69])
        by smtp.gmail.com with ESMTPSA id v189sm3833322wme.39.2021.03.24.12.47.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Mar 2021 12:47:56 -0700 (PDT)
Subject: Re: [PATCH net-next V5 6/6] icmp: add response to RFC 8335 PROBE
 messages
To:     Andreas Roeseler <andreas.a.roeseler@gmail.com>,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org
References: <cover.1616608328.git.andreas.a.roeseler@gmail.com>
 <77658f2ff9f9de796ae2386f60b2a372882befa6.1616608328.git.andreas.a.roeseler@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <ce5b1c2f-1b88-d4c8-2afd-867db9092606@gmail.com>
Date:   Wed, 24 Mar 2021 20:47:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <77658f2ff9f9de796ae2386f60b2a372882befa6.1616608328.git.andreas.a.roeseler@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/24/21 7:18 PM, Andreas Roeseler wrote:
> Modify the icmp_rcv function to check PROBE messages and call icmp_echo
> if a PROBE request is detected.
> 


...

> @@ -1340,6 +1440,7 @@ static int __net_init icmp_sk_init(struct net *net)
>  
>  	/* Control parameters for ECHO replies. */
>  	net->ipv4.sysctl_icmp_echo_ignore_all = 0;
> +	net->ipv4.sysctl_icmp_echo_enable_probe = 0;
>  	net->ipv4.sysctl_icmp_echo_ignore_broadcasts = 1;
>  
>  	/* Control parameter - ignore bogus broadcast responses? */
> 

Where is sysctl_icmp_echo_enable_probe defined ?

Please include a cover letter, also add proper documentation for any new sysctl
in Documentation/networking/ip-sysctl.rst

