Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C01A4BB404
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 09:19:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232191AbiBRITi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 03:19:38 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230221AbiBRITg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 03:19:36 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5F67241D95
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 00:19:19 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id u18so14094970edt.6
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 00:19:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=zA4D4bqg/JKCi4itLWnRLwBvLNacvx3YHy1WPJpY3zg=;
        b=Rl6EN1Ijfjz+xc1Zvt561uXHF/fO7Bu4MCUm8Lvzc8g47TcpOYEvhux0RNG+pr3Cfy
         NOoId3k/iJlO8sIp9TCIVusWA4tcA/kJ/Aj0p99Oyx7o1VYgWH7v5NuhWZrQ7yLtoRY5
         9xo71KxSc+PR+XtqYexwKCDJFiHjqGxqxnRI3oIMrf6SZr/x2vKPlxGqanfRhwqbBypA
         wbZDfn2uV7R3KWWRtq5BSgt9sZuDaiJ7AVdjASQeIAvyt5iz4l6dXy+1qPrHeJGhyXdl
         oC+uXhgAp/WTWVPmgHX7N0GDzkFfwvAISGUe/gDXyMZXpp5D4NQgXRhMnl0bH4NlhyEj
         lHiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=zA4D4bqg/JKCi4itLWnRLwBvLNacvx3YHy1WPJpY3zg=;
        b=cGOY/1KizyhU+8D6a0fFP1uFblrKTnsz4RoTS9h0VrfyJWH0Soen4xEoCj7sdUoNM8
         eBCV/gLFBthhyDUVMZUvSTScscOcPLnFGz2fzN8sG9vaw3g9jqYKaTemNTXdf4eSRG2+
         O4osCVuo/O/u2Y/7cVdqmR4ZhKh/E7zp/3uUDVMnSKxBRNdPRy2YFdgjOFeY1+wCXzjO
         1mTikFo4IGyQtxHSyDdSquMc5u/pF5v4Z4bLmszHsO6UGvG+rZqhwJqh4eP0/XpM8HwG
         ch0hQ9A9Uq3S5fAFeb2vFaG16hUJwVbTg/Eh8k+Y+mLaK18/PTu+/Zi/3gON9mt4sqe+
         gkPQ==
X-Gm-Message-State: AOAM532hWyhdSL206hg3U/0Mn/zPrXgqehLQZfmCWkQxqUKwR9P+kQG1
        JKw+mx9EDQZRy5NMk2G+A5Pj2A==
X-Google-Smtp-Source: ABdhPJx6GrW+UtMJJAA7qxElzyt2kcgtKjiCmJmo9P2Cn7MiQuM2XGJXMV4Cr4V4zxC/chlkQ/jeyQ==
X-Received: by 2002:a50:dac2:0:b0:410:d3ab:2cb8 with SMTP id s2-20020a50dac2000000b00410d3ab2cb8mr6975554edj.15.1645172358279;
        Fri, 18 Feb 2022 00:19:18 -0800 (PST)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id o11sm4174533edq.101.2022.02.18.00.19.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Feb 2022 00:19:17 -0800 (PST)
Message-ID: <fddf59da-ce42-00a8-56ed-18672fa80f8c@blackwall.org>
Date:   Fri, 18 Feb 2022 10:19:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net-next] bridge: switch br_net_exit to batch mode
Content-Language: en-US
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Roopa Prabhu <roopa@nvidia.com>
References: <20220218070150.2628980-1-eric.dumazet@gmail.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20220218070150.2628980-1-eric.dumazet@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18/02/2022 09:01, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> cleanup_net() is competing with other rtnl users.
> 
> Instead of calling br_net_exit() for each netns,
> call br_net_exit_batch() once.
> 
> This gives cleanup_net() ability to group more devices
> and call unregister_netdevice_many() only once for all bridge devices.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Roopa Prabhu <roopa@nvidia.com>
> Cc: Nikolay Aleksandrov <razor@blackwall.org>
> ---
>  net/bridge/br.c | 15 +++++++++------
>  1 file changed, 9 insertions(+), 6 deletions(-)
> 

Thanks,
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>

