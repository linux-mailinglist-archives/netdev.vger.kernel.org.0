Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DA2A400C3D
	for <lists+netdev@lfdr.de>; Sat,  4 Sep 2021 19:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237178AbhIDRPo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Sep 2021 13:15:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229899AbhIDRPn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Sep 2021 13:15:43 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 093AEC061575;
        Sat,  4 Sep 2021 10:14:42 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id d18so323300pll.11;
        Sat, 04 Sep 2021 10:14:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=iFc6/hsrcBHXb0L6ENJYv7woB6l1av4WfvfyQSymWlM=;
        b=jky7Ry8ivE9o6QWdwB1WK/aihvoL83REe8Mk2P0puUGzsm8hUL0GX8nQCtnhKl3u16
         QaY6+KS74yJ5BpIxxOFZybvIaMpJtPIFDyf59rByCTz8JCIh5jCKbseIN5uT1bqIriJa
         aLDVHWRfRaXJIxR6FkX2g9eYcKgFDiH12Bss7ZVuU3C/u+75EAsOyiL9kGvPgz/U6F6n
         8oayQTKtSbTCOlk/icx1rNa1n7FBungGfbxhPnALw0ul39GW2nZ6WIuBXKBQbj9C8cJh
         Divr4v4Ugq2vqdocke99xb9cAli9E8Sl4l8SayTtNINQSQBc/QwUahm1kM9YOVqDWARS
         0dEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iFc6/hsrcBHXb0L6ENJYv7woB6l1av4WfvfyQSymWlM=;
        b=KWiGI483X2JB9WDx7BP2cCLoRNlub1EgCBj9lZE/TN/BLjA4kBJKxNV3ooPOF/oE4W
         RJVvByyiBRjmovJtrEOaf0wtOYi5kLLqZqdM54U4R2Ijcqo1mgxQTg9sf7Q+iaSA7gRy
         lJsJPNCeI/15H3SDeuviGqrficio+0Gu5eaw3sS/NgQRWrxzWBtFdSZXD11FaNOu8XZa
         fyszzDgekbenhBMGuNAS4K/EA/SFOIg6x3vP7M9Vzws0T6+tAOmjtuyYeM2rDQ+8/sKZ
         lM1gSQDSORF5mmVePqH41zWGQMKWIdhHBx9lCD+POD+FYvCt3WHSo1BHxR15TGWlS3Tg
         A1fA==
X-Gm-Message-State: AOAM5310gkmzdwmf595dPBULKPgeoE/qJVSK3l5kyXSOttH6sbFcSen/
        SYGdTnn1EJo8qSQIQHE18q3Or36nRCg=
X-Google-Smtp-Source: ABdhPJymygyiq7j9tW7D09/DkHoxzOpZaa8Yvxh+VHwoC8YXHLHhvnWy8b+lIvtja23Ly+wY/1kEZg==
X-Received: by 2002:a17:90a:194a:: with SMTP id 10mr5152123pjh.176.1630775681377;
        Sat, 04 Sep 2021 10:14:41 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id i11sm2882977pfd.37.2021.09.04.10.14.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 04 Sep 2021 10:14:40 -0700 (PDT)
Subject: Re: WARNING in sk_stream_kill_queues
To:     Vasily Averin <vvs@virtuozzo.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Hao Sun <sunhao.th@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
References: <CACkBjsYG3O_irFOZqjq5dJVDwW8pSUR_p6oO4BUaabWcx-hQCQ@mail.gmail.com>
 <c84b07f8-ab0e-9e0c-c5d7-7d44e4d6f3e5@gmail.com>
 <9a35a6f2-9373-6561-341c-8933b537122e@virtuozzo.com>
 <71e8b315-3f3a-85ae-fede-914269a15272@virtuozzo.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <606daddf-6ca5-6789-b571-6178100432be@gmail.com>
Date:   Sat, 4 Sep 2021 10:14:39 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <71e8b315-3f3a-85ae-fede-914269a15272@virtuozzo.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/4/21 7:48 AM, Vasily Averin wrote:

> Eric,
> this problem is not related to my patches.
> I've reproduced the problem locally on orignal kernel with original config,
> then I've applied last version of my patch -- but it did not help, issue was reproduced again,
> then I've reverted all my patches, see lest below -- and reproduced the problem once again
> 
> Thank you,
> 	Vasily Averin
> 
> b8a0bb68ac30 (HEAD -> net-next-5.15) Revert "ipv6: allocate enough headroom in ip6_finish_output2()"
> 1bc2de674a1b Revert "ipv6: ip6_finish_output2: set sk into newly allocated nskb"
> 780e2f7d9b93 Revert "skbuff: introduce skb_expand_head()"
> 782eaeed9de7 Revert "ipv6: use skb_expand_head in ip6_finish_output2"
> 639e9842fc1f Revert "ipv6: use skb_expand_head in ip6_xmit"
> 3b16ee164bcd Revert "ipv4: use skb_expand_head in ip_finish_output2"
> ab48caf0e632 Revert "vrf: use skb_expand_head in vrf_finish_output"
> 4da67a72ceef Revert "ax25: use skb_expand_head"
> 9b113a8a62f0 Revert "bpf: use skb_expand_head in bpf_out_neigh_v4/6"
> fc4ab503ce8f Revert "vrf: fix NULL dereference in vrf_finish_output()"
>

OK, thanks for checking.

The repro on my host does not trigger the issue, I can not really investigate/bisect.

