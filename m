Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B226A463CF4
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 18:38:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244931AbhK3Rll (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 12:41:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244899AbhK3Rlk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 12:41:40 -0500
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79C98C061574;
        Tue, 30 Nov 2021 09:38:18 -0800 (PST)
Received: by mail-oi1-x22c.google.com with SMTP id bf8so42739604oib.6;
        Tue, 30 Nov 2021 09:38:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=9yGsC6D7YcOedaCUxwHy8rpPCvqA2k0rkOUjWSThB+4=;
        b=M+M3zT55J2QxB8HMlADYhY7i1nGcnxOCpuvuHTowOML7H3UYCOQgrJcI2X+ccSVsZY
         ygGzn7P/NwfLBZiKv0xN3bAu/yT1O4cWaGAiz1Z+n7Zz1fBJnUFgK4ktEUqA/uKiMuOw
         HeBXDWEDa/7qgzCw+qANz9vtthuz5AqydpHmf8zg2n91jFYKnMJzQRacCC028hwCoYOi
         KZqO8dGkgGXeny/HL4nM9D2TvJLdaMTmjh9GYvc8OkchCVe5C7y5mL1/eXBrGqlV/2O1
         /8hy+bINrdZr5g1BrVYz3RktocUD4jLwHPDv8a7X0n+AGGR5JYKRlH2dW/WyvBP7bRJR
         Hukg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=9yGsC6D7YcOedaCUxwHy8rpPCvqA2k0rkOUjWSThB+4=;
        b=hVThqRfV0YF7M3vD/7A1M5tLTo/G+9F1FU+9659n+gw35aHTmsgOqhtKZ7qKYAiPHG
         fx936L42MYvBZu9VZ4liy8e22sIdRW+FlYFQoTr5kr0UZkDlp0yVgcmqmFHcI81gh6LU
         axqANQ+ErPbr9UxSql0vj/rp51JjtZMyZo9ZrP8m3p0ebnlUWJjf6PrjeZKY/7B9sTiQ
         4ayBQ70U58ZXOrfWgBZ/Cu03vP3M8VcUCnwOx1egI5L5+irqaS7RTkG5TlWnsnTu+IAB
         NEv5dtCAFdVF6ZB0k3gjb+PRFnvXU06wBlXiY3JWDWjFM+m2AZLPlmXDUQdbBIBCxrob
         YGiQ==
X-Gm-Message-State: AOAM533z3synEPyDEUn+csltLh+icNuMyMFsWu2S/rzq5U7X0cP7U/eF
        mjepGNqj0gKbc1Ogw0mI1E0=
X-Google-Smtp-Source: ABdhPJyGUDiBcRXjb78HKBVv0Vo8IF+yfoYemWY83wRl492HqCJi/MbSLqMh4aR1q9XhY4QuhyzZ4g==
X-Received: by 2002:a05:6808:1784:: with SMTP id bg4mr354985oib.70.1638293897903;
        Tue, 30 Nov 2021 09:38:17 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id bf17sm4100632oib.27.2021.11.30.09.38.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Nov 2021 09:38:17 -0800 (PST)
Message-ID: <18655462-c72e-1d26-5b59-d03eb993d832@gmail.com>
Date:   Tue, 30 Nov 2021 10:38:14 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.1
Subject: Re: [PATCH v2 net-next 00/26] net: introduce and use generic XDP
 stats
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Shay Agroskin <shayagr@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        David Arinzon <darinzon@amazon.com>,
        Noam Dagan <ndagan@amazon.com>,
        Saeed Bishara <saeedb@amazon.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Russell King <linux@armlinux.org.uk>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Yajun Deng <yajun.deng@linux.dev>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Andrei Vagin <avagin@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Cong Wang <cong.wang@bytedance.com>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, bpf@vger.kernel.org,
        virtualization@lists.linux-foundation.org
References: <20211123163955.154512-1-alexandr.lobakin@intel.com>
 <20211130155612.594688-1-alexandr.lobakin@intel.com>
 <20211130081207.228f42ba@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20211130163454.595897-1-alexandr.lobakin@intel.com>
 <20211130090449.58a8327d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20211130090449.58a8327d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/30/21 10:04 AM, Jakub Kicinski wrote:
> On Tue, 30 Nov 2021 17:34:54 +0100 Alexander Lobakin wrote:
>>> Another thought on this patch: with individual attributes you could save
>>> some overhead by not sending 0 counters to userspace. e.g., define a
>>> helper that does:  
>>
>> I know about ETHTOOL_STAT_NOT_SET, but RTNL xstats doesn't use this,
>> does it?
> 
> Not sure if you're asking me or Dave but no, to my knowledge RTNL does
> not use such semantics today. But the reason is mostly because there
> weren't many driver stats added there. Knowing if an error counter is
> not supported or supporter and 0 is important for monitoring. Even if
> XDP stats don't have a counter which may not be supported today it's
> not a good precedent to make IMO.
> 

Today, stats are sent as a struct so skipping stats whose value is 0 is
not an option. When using individual attributes for the counters this
becomes an option. Given there is no value in sending '0' why do it?

Is your pushback that there should be a uapi to opt-in to this behavior?
