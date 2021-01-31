Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38733309B3D
	for <lists+netdev@lfdr.de>; Sun, 31 Jan 2021 10:31:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230016AbhAaJat (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jan 2021 04:30:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230013AbhAaJ2Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jan 2021 04:28:16 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AC23C061573
        for <netdev@vger.kernel.org>; Sun, 31 Jan 2021 01:27:35 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id i8so3046012ejc.7
        for <netdev@vger.kernel.org>; Sun, 31 Jan 2021 01:27:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DQuz1pa9GvbRd37vkQ2NVh0PZw3uNiGrjR2cuG/k2HM=;
        b=iSxoOmK/bHvymVhs7lEGzAKWPsXzqb96+fBQfcqEz7TWjaRPk/F9y/jNqZmVOM7azD
         uW9kLQidLFRP8nuTbveE+8KZMrFwHiIIeGTE61I1UCAiK4nu70RoMDE83i9WE8WMpAEp
         gBeiKmW06lxxXm/jmyfoggAgPtmQKPOBh1Pw3+rgmmE71Z3TzJNljhxO2QbPJo5uImCk
         T+UQL8TwdO+B3XivVvGloYo64c5tBzJX43OSe3J9RgJEqFMZ9H+Aw/9uFfmygqC9gwSB
         W9OeVyU2c781b1XM/Ve84o2nR4xUE87cnXqbXk6NRtdo5rWRki7SSSszLTtTtm9QXuJ0
         MLug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DQuz1pa9GvbRd37vkQ2NVh0PZw3uNiGrjR2cuG/k2HM=;
        b=PjGe2Sl1k6UPj0y03GQIeo5/1bvU/SJkMBacaBVebBLViF2stUQfUt/4CR9CveJ094
         3qloQYBmpNeQuMF5tcIZCf+kgsIK/IkOESl9rjRmb5LUehndqXLCasZZLtzIx1Pwr/fW
         7lkAwLvA6yKbF+y+EMeFo4tymJ4xUmlgohuUm1L6/qLlOl/qL96fqtxk70MdJwvPXE/7
         EA5bRDJYuGywi3n1NGIbuooDXY1VwexYJoCjqjpqSVqFZOLWabBerQ1SkTPD79ZI87Ps
         ysMtFrQu2uViXsEbYuiJ+6Mam6xibZev2Zdb6kafDcZhGlGsch3o88vmj2h5UoTfWhpM
         X8TA==
X-Gm-Message-State: AOAM5323EpVRbUvU2k03z5f3v28TEpuXc43rvrqzevCYShHBWlD8Sb5s
        Xhkgfnf4KoGreQRcqvVwtqYj2CrcQ/y1myrA
X-Google-Smtp-Source: ABdhPJxEegalHxQS/egMrax4TUygJ9kqmPPYFJMTrCxpod0Wg/kZYUvmjVWfXpHsq8edhR3KRWHGZg==
X-Received: by 2002:a17:906:a149:: with SMTP id bu9mr12692150ejb.185.1612085253859;
        Sun, 31 Jan 2021 01:27:33 -0800 (PST)
Received: from [132.68.43.126] ([132.68.43.126])
        by smtp.gmail.com with ESMTPSA id r22sm6983019edp.9.2021.01.31.01.27.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 31 Jan 2021 01:27:33 -0800 (PST)
Subject: Re: [PATCH v2 net-next 19/21] net/mlx5e: NVMEoTCP, data-path for DDP
 offload
To:     David Ahern <dsahern@gmail.com>,
        Boris Pismenny <borisp@mellanox.com>, kuba@kernel.org,
        davem@davemloft.net, saeedm@nvidia.com, hch@lst.de,
        sagi@grimberg.me, axboe@fb.com, kbusch@kernel.org,
        viro@zeniv.linux.org.uk, edumazet@google.com, smalin@marvell.com
Cc:     boris.pismenny@gmail.com, linux-nvme@lists.infradead.org,
        netdev@vger.kernel.org, benishay@nvidia.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, Or Gerlitz <ogerlitz@mellanox.com>,
        Yoray Zack <yorayz@mellanox.com>
References: <20210114151033.13020-1-borisp@mellanox.com>
 <20210114151033.13020-20-borisp@mellanox.com>
 <10c28b01-49e5-c512-8670-bf8332b24b1b@gmail.com>
 <15248743-82bf-4283-d8c6-99f2210e42ae@gmail.com>
 <2a0bfce0-6226-7b9a-95b1-15f4f1f321e8@gmail.com>
From:   Boris Pismenny <borispismenny@gmail.com>
Message-ID: <f376794c-568b-9b87-7467-dfe433053a4d@gmail.com>
Date:   Sun, 31 Jan 2021 11:27:31 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <2a0bfce0-6226-7b9a-95b1-15f4f1f321e8@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19/01/2021 6:36, David Ahern wrote:
> On 1/17/21 1:42 AM, Boris Pismenny wrote:
>> This is needed for a few reasons that are explained in detail
>> in the tcp-ddp offload documentation. See patch 21 overview
>> and rx-data-path sections. Our reasons are as follows:
> 
> I read the documentation patch, and it does not explain it and really
> should not since this is very mlx specific based on the changes.
> Different h/w will have different limitations. Given that, it would be
> best to enhance the patch description to explain why these gymnastics
> are needed for the skb.
> 

The text in the documentation that describes this trade-off:
''We remark that a single TCP packet may have numerous PDUs embedded
inside. NICs can choose to offload one or more of these PDUs according
to various trade-offs. Possibly, offloading such small PDUs is of little
value, and it is better to leave it to software. ``

Indeed, different HW may have other additional trade-offs. But, I
suspect that this one will be important for all.

>> 1) Each SKB may contain multiple PDUs. DDP offload doesn't operate on
>> PDU headers, so these are written in the receive ring. Therefore, we
>> need to rebuild the SKB to account for it. Additionally, due to HW
>> limitations, we will only offload the first PDU in the SKB.
> 
> Are you referring to LRO skbs here? I can't imagine going through this
> for 1500 byte packets that have multiple PDUs.
> 
> 

No, that is true for any skb, and non-LRO skbs in particular. Most SKBs
do not contain multiple PDUs, but the ones that do are handled
gracefully in this function.


