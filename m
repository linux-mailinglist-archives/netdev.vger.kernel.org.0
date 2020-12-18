Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 983492DDD8A
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 04:57:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732740AbgLRDzz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 22:55:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732730AbgLRDzy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Dec 2020 22:55:54 -0500
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45F93C0617A7;
        Thu, 17 Dec 2020 19:55:14 -0800 (PST)
Received: by mail-ot1-x32f.google.com with SMTP id i6so789735otr.2;
        Thu, 17 Dec 2020 19:55:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CqJkxa+ayZLdcjAQlsDQgHeYjWHJ3bto7XxZ3HXQUoU=;
        b=p3nRCDznPod/zXVCuATao6ZgfLEVhmdqDrgqRZ2oxrMM8HHPIlA2nACB8hSCdIOFTp
         Le5DzFpwB3p877d1Xgy/KSjGI1GoAqNHBFpkck6HkZt2uz14qxcVxQ7uB6CFLHiB6DF/
         7FaRCZ9Lh2Z3geHvLvrJ2TDpG05ZUjuBhszOLSbNNJlxLJpsy5opjXQFP62kxbyi7cbk
         Hk1aSA4zBUR+TDmMvXtRk0mll3U/WE8LCx5YczXB5hKl4Ko12FmEXSpZeZn9DcwcSrFK
         J3iFcBQR43pWglqg8l5Aom30uZV3JUFPQj84NI3ZSsTFHMp6oDwT24LmijEs7DUrcAzn
         MMzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CqJkxa+ayZLdcjAQlsDQgHeYjWHJ3bto7XxZ3HXQUoU=;
        b=QTQg/w/SHoD3JEbumON4q3+4bD/Q4bEi7urwzrLQeC72j+2VnBaGSoI3oNxBdwlhVk
         PENMBpNDYnlflu55u9pyfvXeQz0feuea9PJZV5zA0V3LqmcyqZs2QxN+yIq0kPI8ZeKJ
         MU1eR8U6COeGr5gKJHT/Tnt8MRvik7HooQ04X0cv8m/70pivl8rCCrd7XgUqYzPe+2MB
         bsjuM07f+dE6y2kL8sp6tT8aj4/mp90xCR7b9WoxA9wWHtbzJCU+VucRZA4Zt7eF3OTN
         XH+tNMm6CGH1MV+mCL+5rt7hRqJggrnsPUMlJpK4gdeENOsHu5TevSwC60My9r2hLvUK
         DpHA==
X-Gm-Message-State: AOAM530XTo0OW2qaarf1qxDv/i8D/yEfO9FUZ2dRYtunDw8ts9EEf/9F
        /f2XYRaO8o3HHF2/ID9RRyM=
X-Google-Smtp-Source: ABdhPJyYH4731PCXESewJtrcSk0WLs2awpOX8rJE0eFMXEKmpwZ+u19rNYp/TyTHOjC9aORAS8IJdQ==
X-Received: by 2002:a9d:650a:: with SMTP id i10mr1561701otl.341.1608263713597;
        Thu, 17 Dec 2020 19:55:13 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.51])
        by smtp.googlemail.com with ESMTPSA id u3sm1674772otk.31.2020.12.17.19.55.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Dec 2020 19:55:12 -0800 (PST)
Subject: Re: [net-next v4 00/15] Add mlx5 subfunction support
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leonro@nvidia.com>,
        Netdev <netdev@vger.kernel.org>, linux-rdma@vger.kernel.org,
        David Ahern <dsahern@kernel.org>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Kiran Patil <kiran.patil@intel.com>,
        Greg KH <gregkh@linuxfoundation.org>
References: <ecad34f5c813591713bb59d9c5854148c3d7f291.camel@kernel.org>
 <CAKgT0UfTOqS9PBeQFexyxm7ytQzdj0j8VMG71qv4+Vn6koJ5xQ@mail.gmail.com>
 <20201216001946.GF552508@nvidia.com>
 <CAKgT0UeLBzqh=7gTLtqpOaw7HTSjG+AjXB7EkYBtwA6EJBccbg@mail.gmail.com>
 <20201216030351.GH552508@nvidia.com>
 <CAKgT0UcwP67ihaTWLY1XsVKEgysa3HnjDn_q=Sgvqnt=Uc7YQg@mail.gmail.com>
 <20201216133309.GI552508@nvidia.com>
 <CAKgT0UcRfB8a61rSWW-NPdbGh3VcX_=LCZ5J+-YjqYNtm+RhVg@mail.gmail.com>
 <20201216175112.GJ552508@nvidia.com>
 <CAKgT0Uerqg5F5=jrn5Lu33+9Y6pS3=NLnOfvQ0dEZug6Ev5S6A@mail.gmail.com>
 <20201216203537.GM552508@nvidia.com>
 <CAKgT0UfuSA9PdtR6ftcq0_JO48Yp4N2ggEMiX9zrXkK6tN4Pmw@mail.gmail.com>
 <c737048e-5e65-4b16-ffba-5493da556151@gmail.com>
 <CAKgT0UdxVytp4+zYh+gOYDOc4+ZNNx3mW+F9f=UTiKxyWuMVbQ@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <fa864ac9-8a7e-ce42-b93b-1a2762386caf@gmail.com>
Date:   Thu, 17 Dec 2020 20:55:10 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <CAKgT0UdxVytp4+zYh+gOYDOc4+ZNNx3mW+F9f=UTiKxyWuMVbQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/17/20 8:11 PM, Alexander Duyck wrote:
> On Thu, Dec 17, 2020 at 5:30 PM David Ahern <dsahern@gmail.com> wrote:
>>
>> On 12/16/20 3:53 PM, Alexander Duyck wrote:
>>> The problem in my case was based on a past experience where east-west
>>> traffic became a problem and it was easily shown that bypassing the
>>> NIC for traffic was significantly faster.
>>
>> If a deployment expects a lot of east-west traffic *within a host* why
>> is it using hardware based isolation like a VF. That is a side effect of
>> a design choice that is remedied by other options.
> 
> I am mostly talking about this from past experience as I had seen a
> few instances when I was at Intel when it became an issue. Sales and
> marketing people aren't exactly happy when you tell them "don't sell
> that" in response to them trying to sell a feature into an area where

that's a problem engineers can never solve...

> it doesn't belong. Generally they want a solution. The macvlan offload
> addressed these issues as the replication and local switching can be
> handled in software.

well, I guess almost never. :-)

> 
> The problem is PCIe DMA wasn't designed to function as a network
> switch fabric and when we start talking about a 400Gb NIC trying to
> handle over 256 subfunctions it will quickly reduce the
> receive/transmit throughput to gigabit or less speeds when
> encountering hardware multicast/broadcast replication. With 256
> subfunctions a simple 60B ARP could consume more than 19KB of PCIe
> bandwidth due to the packet having to be duplicated so many times. In
> my mind it should be simpler to simply clone a single skb 256 times,
> forward that to the switchdev ports, and have them perform a bypass
> (if available) to deliver it to the subfunctions. That's why I was
> thinking it might be a good time to look at addressing it.
> 

east-west traffic within a host is more than likely the same tenant in
which case a proper VPC is a better solution than the s/w stack trying
to detect and guess that a bypass is needed. Guesses cost cycles in the
fast path which is a net loss - and even more so as speeds increase.

