Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54F5E3E2FD3
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 21:46:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244003AbhHFTq5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 15:46:57 -0400
Received: from mail-pl1-f171.google.com ([209.85.214.171]:44735 "EHLO
        mail-pl1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229748AbhHFTq4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Aug 2021 15:46:56 -0400
Received: by mail-pl1-f171.google.com with SMTP id q2so8441394plr.11
        for <netdev@vger.kernel.org>; Fri, 06 Aug 2021 12:46:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BX+yhZsge6xsr6SQsZC5CJS2tj6uRVB9UJOJkyIuvx4=;
        b=a1rSNk3rTxud/nj2C+PMagCCoNQ/pXmIZqSNtr8iwueT7KOm1uui+iSAfA7QvwTD86
         PSuBeG2JH/Hneuysh+e2jNw6Mz1qXK6BoqHOSJllZXxnSA+f5enkE7Xy/HTJE3/XWSKh
         atCfxMxBVSxXPddTExufHTKUFCq/hxY5r4ZS2K1of1paOrOwj1FKux08Yw4afLh/xKub
         HgSuTuZ14Gk9KHFWnbH7ys62UGBjHznXc1ynBLToKvDujRV1afqSxPYtcgB4FRF6U1C0
         tFk8zdiuLqvZDKg5Xtj/gsWdv99ubUXNmO9KQII4tjDjdLwmCtdJH6JewH2unxX20UVJ
         +9yA==
X-Gm-Message-State: AOAM533aSM9tt6aEYlZfCGiA1FR2/c6qAYWZ3I8bDaWQIzG1YsB2zVa2
        B62jzqvhNyZq+2P1JI8xrFA=
X-Google-Smtp-Source: ABdhPJws+bOGHVVbKilHYfcIRdp/qccAQ/++ydXiWQCJs6aUz+cYXNXELCRbiJW6OmP3Yf6JtT3NQw==
X-Received: by 2002:a65:62da:: with SMTP id m26mr178554pgv.370.1628279199840;
        Fri, 06 Aug 2021 12:46:39 -0700 (PDT)
Received: from ?IPv6:2601:647:4802:9070:4a77:cdda:c1bf:a6b7? ([2601:647:4802:9070:4a77:cdda:c1bf:a6b7])
        by smtp.gmail.com with ESMTPSA id y23sm12357295pgf.38.2021.08.06.12.46.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Aug 2021 12:46:39 -0700 (PDT)
Subject: Re: [PATCH v5 net-next 00/36] nvme-tcp receive and tarnsmit offloads
To:     Or Gerlitz <gerlitz.or@gmail.com>
Cc:     Christoph Hellwig <hch@lst.de>, Boris Pismenny <borisp@nvidia.com>,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Saeed Mahameed <saeedm@nvidia.com>, axboe@fb.com,
        Keith Busch <kbusch@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Eric Dumazet <edumazet@google.com>,
        Shai Malin <smalin@marvell.com>, boris.pismenny@gmail.com,
        linux-nvme@lists.infradead.org,
        Linux Netdev List <netdev@vger.kernel.org>,
        benishay@nvidia.com, Or Gerlitz <ogerlitz@nvidia.com>,
        Yoray Zack <yorayz@nvidia.com>,
        Boris Pismenny <borisp@mellanox.com>
References: <20210722110325.371-1-borisp@nvidia.com>
 <20210723055626.GA32126@lst.de>
 <02c4e0af-0ae9-f4d9-d2ad-65802bdf036a@grimberg.me>
 <CAJ3xEMjzRqrj-EN7gbqKmD5txAV-gZn828V+6QAf5wfwYsqySQ@mail.gmail.com>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <1d461a0d-cda5-2086-ec17-c5bb3a80846f@grimberg.me>
Date:   Fri, 6 Aug 2021 12:46:37 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CAJ3xEMjzRqrj-EN7gbqKmD5txAV-gZn828V+6QAf5wfwYsqySQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/4/21 6:51 AM, Or Gerlitz wrote:
> On Fri, Jul 23, 2021 at 10:59 PM Sagi Grimberg <sagi@grimberg.me> wrote:
> 
>> [.. ] It is difficult to review.
>> The order should be:
>> 1. ulp_ddp interface
>> 2. nvme-tcp changes
>> 3. mlx5e changes
> 
> .. and this is exactly how the series is organized, for v6 we will drop the
> TX offload part and stick to completing the review on the RX offload part.
> 
>> Also even beyond grouping patches together I have 2 requests:
>> 1. Please consolidate ddp routines under a single ifdef (also minimize
>> the ifdef in call-sites).
> 
> ok, will make an effort to be better in that respect
> 
>> 2. When consolidating functions, try to do this as prep patches
>> documenting in the change log that it is preparing to add ddp. Its
>> difficult digesting both at times.
> 
> to clarify, you would like patch #5 "nvme-tcp: Add DDP offload control path"
> to only add the call sites and if-not-deffed implementation for the added knobs:
> 
> nvme_tcp_offload_socket
> nvme_tcp_unoffload_socket
> nvme_tcp_offload_limits
> nvme_tcp_resync_response
> 
> and a 2nd patch to add the if-yes-deffed implementation?
> 
> This makes sense, however IMHO repeating this prep exercise for
> the data-path patch (#6 "nvme-tcp: Add DDP data-path") doesn't
> seem to provide notable value  b/c you will only see two call sites
> for the two added empty knobs:
> 
> nvme_tcp_setup_ddp
> nvme_tcp_teardown_ddp
> 
> but whatever you prefer, so.. let us know

I was more referring to routines that now grew the ddp path
and changed in the same time like:
nvme_tcp_complete_request
nvme_tcp_consume_skb
etc..
