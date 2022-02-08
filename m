Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A64434AD051
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 05:24:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237889AbiBHEYT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 23:24:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233749AbiBHEYS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 23:24:18 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 119DDC0401E9
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 20:24:18 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id y9so7424787pjf.1
        for <netdev@vger.kernel.org>; Mon, 07 Feb 2022 20:24:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=m7KZnN5KCBSzxyUqmUHVPhbE1Z6VkH8fDIVffjTYjXk=;
        b=KZz2RB6oQck4Km2l+GKWXAD2YHwtDwZBMeiQQ1FZvTqbvA9Mjd1MSQc490UyePQThh
         UHR1kQylviXbjldGfWLD+lKw/0YBDmZuDyOMleGR0QtdOamsLYp+WxClcQDfWCjjeXok
         ED0On6aau3pJJyYmLTfYdP+V4y/SsFvXjttvTm1DNQJhUdUHROIlFw99ebKV0STRJv6V
         OevlYOrrhbBVjRaWxDstk8uvApSQuL7InFYkruAhfDCzsrow2Z8W1wLUmC8HyvqfMlzR
         OLLaCzd+QvJL/f83bSOqz/ZINLzdLRTUJXSo6B4RuFUMxJkIcdKmN9QiLYesbZgVFjNa
         GPZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=m7KZnN5KCBSzxyUqmUHVPhbE1Z6VkH8fDIVffjTYjXk=;
        b=C/i63Lj3pk2p4o720gnQaiHwBtW9rtJaFpCYqz45aBcnboHwms46GEfpTL5vz3cSo+
         AggcGTJnl83fQZQ/t4Vkv+RZ3K+cQOhV5Az73J9zMXrz4zODdgS6hIu5qNCn5/57jcgo
         ljMtn/dW0he1Gd57qU87RkK2XBgW9RNfNjg6VilgMOwPF47AfPQ10tcXN9iXI4Dub59X
         5jNu7NY8kaHIhLAjYddtvqfkHxIvnceB7+A3YSLr+X5i5zIlrblfpKlQI77geDloX9T9
         ++zXGLCyoE9sh2NTMKhGau+ejroRRvCoBGtGi/9BvizrBq+sPeGGObxDqe/TKKAjWLPn
         OKwA==
X-Gm-Message-State: AOAM532kmst/M14W1ApmOnCvQxZZiQ3Usf3UYhOMWSG8lfRYEDefi4dY
        ycgsLcN6hqNt5tHMGReHO47MLsJUaj0=
X-Google-Smtp-Source: ABdhPJx1DHzqTpiN46atntC1vpSE9LU5QiApBIyJi1CL3vt5x5FcazEVBQe1/iRddQ2sAoePKdCmNQ==
X-Received: by 2002:a17:90b:1b46:: with SMTP id nv6mr2348346pjb.143.1644294257533;
        Mon, 07 Feb 2022 20:24:17 -0800 (PST)
Received: from [10.0.2.64] ([209.37.97.194])
        by smtp.googlemail.com with ESMTPSA id v2sm880483pjt.55.2022.02.07.20.24.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Feb 2022 20:24:17 -0800 (PST)
Message-ID: <dec5c7e1-4e80-3d62-233a-d7d29e405566@gmail.com>
Date:   Mon, 7 Feb 2022 20:24:16 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Subject: Re: [PATCH net-next 07/11] ip6mr: introduce ip6mr_net_exit_batch()
Content-Language: en-US
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>
References: <20220207171756.1304544-1-eric.dumazet@gmail.com>
 <20220207171756.1304544-8-eric.dumazet@gmail.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220207171756.1304544-8-eric.dumazet@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/7/22 9:17 AM, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> cleanup_net() is competing with other rtnl users.
> 
> Avoiding to acquire rtnl for each netns before calling
> ip6mr_rules_exit() gives chance for cleanup_net()
> to progress much faster, holding rtnl a bit longer.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> ---
>  net/ipv6/ip6mr.c | 20 +++++++++++++++-----
>  1 file changed, 15 insertions(+), 5 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>

