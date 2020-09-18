Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 426C4270142
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 17:44:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726126AbgIRPoj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 11:44:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725941AbgIRPoi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 11:44:38 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D37DC0613CE
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 08:44:38 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id n61so5766258ota.10
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 08:44:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LS9Lok3HYzhgMzH/BOayYnb7/4Jux8Yd0XF3Va6kejI=;
        b=tJvBabJHFn7XMk8UVdCNlk0FwGYby5dnlRqj+abSSA/PRo3DI+peGc77vnsymjdwZJ
         mv1etVvtJgV0qOw2YWxeT7CcU8R5iFIlSGV4jcNl1IDwKMuIOXjiC20m7IDRpGrRaM6n
         EBj6QZTJrj6VzIOgU2qi0Y/vbnd6kw+74r8MUKFBpf7FHZBpmwLknjESs2zXdXLIbtMF
         EkXgQgQD7UFNhVtcyBfLiqCwpTpc9URwjQbvS1qecNNQhEkJXUAGEzvg9JDJfqzD1RP1
         WGExsFp5fR01GWtAmI5l7jHxoyvipsUXmT+V8PGatqUEhwXEjFjjErSod10+fzaU5gg2
         ulXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LS9Lok3HYzhgMzH/BOayYnb7/4Jux8Yd0XF3Va6kejI=;
        b=FWJwiHeY0nkOxpWM9ZbV5hSgKzAI+llViYG12M8E72jBEh308wgfzFxBHa3ReCC4Xt
         6wHtzkLWqQ60wdyfpZm10UfG2Ty6/aGSyyYbMUcHL5HgaQK0k85X2ehESb45CI0Wwuw0
         nrkAbG0XAEHTNYs1HByYHXT081tsPoZz2vE9fEqanYufdlhR8OiIa6BtJRKC1YzY/WpG
         n1/kFrmFhpU0m20RC42PKVBJSmvJp5VqJWLEOS8FO3sUovGbo0xoXJgszZ8JZ9/JbIOb
         DHkn/Jt713e5vMRjKXC7r02tY63/NN0F/8Ktg6NiOQW6WmWGsDonmXuwXrCn7HyVn0rx
         8uHw==
X-Gm-Message-State: AOAM530K0BTz4Adzf2vTY/IEAplAeV20oSc1uNE7IoEO6Tsq+j3f9MQ2
        CCnHiz3i26VhzLqYRl+axRVAtRngWrgACA==
X-Google-Smtp-Source: ABdhPJz5+TUNxw83T0OKzyom0d+6nK8oxVydxrCr91fppUGDETdShGEEQ4vfXNaKuvWzbbgJ1SbO5Q==
X-Received: by 2002:a9d:30d7:: with SMTP id r23mr23459978otg.186.1600443877651;
        Fri, 18 Sep 2020 08:44:37 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:bd0c:595:7529:c07b])
        by smtp.googlemail.com with ESMTPSA id p8sm3179934oot.29.2020.09.18.08.44.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Sep 2020 08:44:36 -0700 (PDT)
Subject: Re: [PATCH iproute2-next] ip: promote missed packets to the -s row
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     stephen@networkplumber.org, netdev@vger.kernel.org
References: <20200916194249.505389-1-kuba@kernel.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <0371023e-f46f-5dfd-6268-e11a18deeb06@gmail.com>
Date:   Fri, 18 Sep 2020 09:44:35 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200916194249.505389-1-kuba@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/16/20 1:42 PM, Jakub Kicinski wrote:
> missed_packet_errors are much more commonly reported:
> 
> linux$ git grep -c '[.>]rx_missed_errors ' -- drivers/ | wc -l
> 64
> linux$ git grep -c '[.>]rx_over_errors ' -- drivers/ | wc -l
> 37
> 
> Plus those drivers are generally more modern than those
> using rx_over_errors.
> 
> Since recently merged kernel documentation makes this
> preference official, let's make ip -s output more informative
> and let rx_missed_errors take the place of rx_over_errors.
> 
> Before:
> 
> 2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP mode DEFAULT group default qlen 1000
>     link/ether 00:0a:f7:c1:4d:38 brd ff:ff:ff:ff:ff:ff
>     RX: bytes  packets  errors  dropped overrun mcast
>     6.04T      4.67G    0       0       0       67.7M
>     RX errors: length   crc     frame   fifo    missed
>                0        0       0       0       7
>     TX: bytes  packets  errors  dropped carrier collsns
>     3.13T      2.76G    0       0       0       0
>     TX errors: aborted  fifo   window heartbeat transns
>                0        0       0       0       6
> 
> After:
> 
> 2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP mode DEFAULT group default qlen 1000
>     link/ether 00:0a:f7:c1:4d:38 brd ff:ff:ff:ff:ff:ff
>     RX: bytes  packets  errors  dropped missed  mcast
>     6.04T      4.67G    0       0       7       67.7M
>     RX errors: length   crc     frame   fifo    overrun
>                0        0       0       0       0
>     TX: bytes  packets  errors  dropped carrier collsns
>     3.13T      2.76G    0       0       0       0
>     TX errors: aborted  fifo   window heartbeat transns
>                0        0       0       0       6

changes to ip output are usually not allowed.
