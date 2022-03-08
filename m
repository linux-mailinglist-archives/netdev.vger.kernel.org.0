Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5822F4D1CB0
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 17:03:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233290AbiCHQEJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 11:04:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245280AbiCHQEI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 11:04:08 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B2304BB93
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 08:03:10 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id qt6so40254020ejb.11
        for <netdev@vger.kernel.org>; Tue, 08 Mar 2022 08:03:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ZOGsVLXImYpGczi6NE7BO5N3OHzaeF1uhsS78EYxSuM=;
        b=E6b9InFXW+CKXWGY1GAWIXi7fMfuIOpLHx05oOaSGgn50n+XmijPsJfWRkyWm0TUn6
         mBH+cBUVD6kJdxX4PP47r/N4HryE904B+VSOUN5Yz/NhVuuB4pYdDp6vflgD4dBfuhhq
         ShwQ71JH9cEC3PFtJD+indVszQRE4XtVX1mt5naVp43GFtcDR36jDplhZq/pFZZF3zPu
         8HgX1msx8T/KO85w6Ks1nI94N9sIvax77qwflNL3UjoMZPsLaxBmckDqusngA0nPrzyY
         KMNW5L0fs4XAtTpASkXYA1mPa6zYAnaKOKA/WsgvwVV+iDFc3IyOMzbc0TMe8cu7NYgw
         fCYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ZOGsVLXImYpGczi6NE7BO5N3OHzaeF1uhsS78EYxSuM=;
        b=jOyg94e2V6HjDphh/F3rBPL5CP1OozrGGiMghxua2VATpPZ7f0P5FlywIg15NM6RrN
         mtFwn09qt2uax/cZ04vJfP0nK7WX9X6zbcvlLLzKsQ9uX46B8FoL9IYYyybrKwaEOYDu
         0bOXxuo4DjOhEFVWewQilP0WfEEtEzj/XP2ED+wtQkunCiIXlB5qAc7oQqR1eQf3IBpt
         iUDeV5U1jYTW2YEJlNdt8XgeZ5UOF/9abphEgxuoVGKjAH1YnLYi38WB03S7VHckPE1i
         aWtIOKisM6UJduV6v1qPhOLoZ2wFiAdB0qlPigt1y1dT8+/TSFcG+Q5QuQ5Vv4jb/OxM
         ZdHA==
X-Gm-Message-State: AOAM532cQ7h1WnAWtnnVBqEdNxYmbatM8+gC2HOXLytOV+c+xjMunmlL
        +lyWJ4JEvsWeDJ45AmBBH00=
X-Google-Smtp-Source: ABdhPJyxo+o1aQMVOSHYkW/WpTfLGR//09wX2gcrH40QCKxYhlrro5SdQXIZ8z9tRQD2KXbKs79Rjg==
X-Received: by 2002:a17:906:7056:b0:6d6:dd99:f2a4 with SMTP id r22-20020a170906705600b006d6dd99f2a4mr13627214ejj.43.1646755389036;
        Tue, 08 Mar 2022 08:03:09 -0800 (PST)
Received: from [192.168.0.110] ([77.126.183.254])
        by smtp.gmail.com with ESMTPSA id y18-20020aa7ca12000000b0041677910461sm830581eds.53.2022.03.08.08.03.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Mar 2022 08:03:08 -0800 (PST)
Message-ID: <f227a1a2-dfdf-4d56-6a2a-99dc2bd28ba5@gmail.com>
Date:   Tue, 8 Mar 2022 18:03:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH v2 net-next 13/14] mlx4: support BIG TCP packets
Content-Language: en-US
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Coco Li <lixiaoyan@google.com>,
        David Ahern <dsahern@kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Tariq Toukan <tariqt@nvidia.com>
References: <20220303181607.1094358-1-eric.dumazet@gmail.com>
 <20220303181607.1094358-14-eric.dumazet@gmail.com>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <20220303181607.1094358-14-eric.dumazet@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
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



On 3/3/2022 8:16 PM, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> mlx4 supports LSOv2 just fine.
> 
> IPv6 stack inserts a temporary Hop-by-Hop header
> with JUMBO TLV for big packets.
> 
> We need to ignore the HBH header when populating TX descriptor.
> 
> Tested:
> 
> Before: (not enabling bigger TSO/GRO packets)
> 
> ip link set dev eth0 gso_ipv6_max_size 65536 gro_ipv6_max_size 65536
> 
> netperf -H lpaa18 -t TCP_RR -T2,2 -l 10 -Cc -- -r 70000,70000
> MIGRATED TCP REQUEST/RESPONSE TEST from ::0 (::) port 0 AF_INET6 to lpaa18.prod.google.com () port 0 AF_INET6 : first burst 0 : cpu bind
> Local /Remote
> Socket Size   Request Resp.  Elapsed Trans.   CPU    CPU    S.dem   S.dem
> Send   Recv   Size    Size   Time    Rate     local  remote local   remote
> bytes  bytes  bytes   bytes  secs.   per sec  % S    % S    us/Tr   us/Tr
> 
> 262144 540000 70000   70000  10.00   6591.45  0.86   1.34   62.490  97.446
> 262144 540000
> 
> After: (enabling bigger TSO/GRO packets)
> 
> ip link set dev eth0 gso_ipv6_max_size 185000 gro_ipv6_max_size 185000
> 
> netperf -H lpaa18 -t TCP_RR -T2,2 -l 10 -Cc -- -r 70000,70000
> MIGRATED TCP REQUEST/RESPONSE TEST from ::0 (::) port 0 AF_INET6 to lpaa18.prod.google.com () port 0 AF_INET6 : first burst 0 : cpu bind
> Local /Remote
> Socket Size   Request Resp.  Elapsed Trans.   CPU    CPU    S.dem   S.dem
> Send   Recv   Size    Size   Time    Rate     local  remote local   remote
> bytes  bytes  bytes   bytes  secs.   per sec  % S    % S    us/Tr   us/Tr
> 
> 262144 540000 70000   70000  10.00   8383.95  0.95   1.01   54.432  57.584
> 262144 540000
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Tariq Toukan <tariqt@nvidia.com>
> ---
>   .../net/ethernet/mellanox/mlx4/en_netdev.c    |  3 ++
>   drivers/net/ethernet/mellanox/mlx4/en_tx.c    | 47 +++++++++++++++----
>   2 files changed, 41 insertions(+), 9 deletions(-)
> 

Reviewed-by: Tariq Toukan <tariqt@nvidia.com>

Thanks.
