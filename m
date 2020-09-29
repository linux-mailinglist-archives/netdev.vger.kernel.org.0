Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C87D127BB19
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 04:44:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727248AbgI2CoX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 22:44:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726064AbgI2CoW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 22:44:22 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E9F1C061755
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 19:44:21 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id b17so1861833pji.1
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 19:44:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZPKYIfxt2LVhhCos7+8U/B9RRLEMtA2XFwO17M2prWY=;
        b=B/bCtfPTuniqKfA32e7shNwbv0C5E94z1+JzxGtn59SE74B60UzY9x+8T4HWKwoN7F
         YeYlECgsNRGA61GcgXGL6reIXWK2vBVXUCiQ47mbjmE0IRq5vUSNOzxgcnnV8HKO/9qi
         PGF69kvqe4zfM3aiLTr37pJ+i4gavx6nYlOa/NWhMFDA2rJY2KLRTEPuMmhf1+1bJYS3
         2U2+StMF119TStwB6QaJ67FCRgLWhVMGvsjDv/qFyMR9OmUueDRhLwCjlJRD5Gws4JaD
         ax9gMIGYT6aW6ygvacHlX2dYpbthf8iC7Q7wgQIZEY7Addu/jmJS13PPFkT4kHYa2Q8w
         OzmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZPKYIfxt2LVhhCos7+8U/B9RRLEMtA2XFwO17M2prWY=;
        b=bj3zPNSRYzVyf8EV/1144As1f3O4ZtMjFysBLRDa8jzO0KLDicTCIUVYldsguHfow8
         EyR0f7o7e47cEE834wiXaG5L6s3uwy72IKSXWYX+QhcmMAHMFR47ScFDQns0S8ZZb7gZ
         hYUCjDP2uFdSwJ5LvSy1hhvHo7jQqL43XpeA7RFLjwN4qhDjdvqXxsmJrlUB3PFyYrBj
         L+PKdiQRnc2yM4LpcRf1QxT0+qBUxqLnI5dlv89SyStuAXCwUEwGrQldp2CeEv/pjUhv
         b1IppEHUhX38bfJ2D1RXPdkA4dDjeKKBjUWAzQ54rH9d7GmcNjp2dbemFJGg1KleyS9k
         gRZg==
X-Gm-Message-State: AOAM532G2R4QrjcikqjM/RLJZhWggHtIqwapmzdB2UUMfokVgXsbuL/b
        oCbWpAMFmbCwNv7LA7lstEU=
X-Google-Smtp-Source: ABdhPJyCBogyRhwvgVLB+xt/s1C8tt7NiwphRuHRnBe3PokPWulQKjbHK38ah0+sesXyOQxFcl57XQ==
X-Received: by 2002:a17:90a:1992:: with SMTP id 18mr1893784pji.143.1601347460775;
        Mon, 28 Sep 2020 19:44:20 -0700 (PDT)
Received: from Davids-MacBook-Pro.local (c-24-23-181-79.hsd1.ca.comcast.net. [24.23.181.79])
        by smtp.googlemail.com with ESMTPSA id ca6sm2490176pjb.53.2020.09.28.19.44.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Sep 2020 19:44:20 -0700 (PDT)
Subject: Re: [PATCH RFC net-next] virtio_net: Relax queue requirement for
 using XDP
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>
References: <20200226005744.1623-1-dsahern@kernel.org>
 <23fe48b6-71d1-55a3-e0e8-ca4b3fac1f7f@redhat.com>
 <9a5391fb-1d80-43d1-5e88-902738cc2528@gmail.com> <87wo89zroe.fsf@toke.dk>
 <20200226032204-mutt-send-email-mst@kernel.org> <87r1yhzqz8.fsf@toke.dk>
 <0dc879c5-12ce-0df2-24b0-97d105547150@digitalocean.com>
 <87wo88wcwi.fsf@toke.dk>
 <CAJ8uoz2++_D_XFwUjFri0HmNaNWKtiPNrJr=Fvc8grj-8hRzfg@mail.gmail.com>
 <b6609e0a-eb2f-78bd-b565-c56dce9e2e48@gmail.com>
 <CAJ8uoz2bj0YWH5K6OW8m+BC06QZTSYW=xbApuEDK5pRCx+RLAA@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <e6a31c99-c492-b643-3fdc-4227b89707df@gmail.com>
Date:   Mon, 28 Sep 2020 19:44:18 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <CAJ8uoz2bj0YWH5K6OW8m+BC06QZTSYW=xbApuEDK5pRCx+RLAA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/28/20 7:25 AM, Magnus Karlsson wrote:
> On Mon, Sep 28, 2020 at 5:13 AM David Ahern <dsahern@gmail.com> wrote:
>>
>> On 2/27/20 2:41 AM, Magnus Karlsson wrote:
>>> I will unfortunately be after Netdevconf due to other commitments. The
>>> plan is to send out the RFC to the co-authors of the Plumbers
>>> presentation first, just to check the sanity of it. And after that
>>> send it to the mailing list. Note that I have taken two shortcuts in
>>> the RFC to be able to make quicker progress. The first on is the
>>> driver implementation of the dynamic queue allocation and
>>> de-allocation. It just does this within a statically pre-allocated set
>>> of queues. The second is that the user space interface is just a
>>> setsockopt instead of a rtnetlink interface. Again, just to save some
>>> time in this initial phase. The information communicated in the
>>> interface is the same though. In the current code, the queue manager
>>> can handle the queues of the networking stack, the XDP_TX queues and
>>> queues allocated by user space and used for AF_XDP. Other uses from
>>> user space is not covered due to my setsockopt shortcut. Hopefully
>>> though, this should be enough for an initial assessment.
>>
>> Any updates on the RFC? I do not recall seeing a patch set on the
>> mailing list, but maybe I missed it.
> 
> No, you have unfortunately not missed anything. It has been lying on
> the shelf collecting dust for most of this time. The reason was that
> the driver changes needed to support dynamic queue allocation just
> became too complex as it would require major surgery to at least all
> Intel drivers, and probably a large number of other ones as well. Do
> not think any vendor would support such a high effort solution and I
> could not (at that time at least) find a way around it. So, gaining
> visibility into what queues have been allocated (by all entities in
> the kernel that uses queue) seems to be rather straightforward, but
> the dynamic allocation part seems to be anything but.

retrofitting a new idea is usually a high level of effort.

> 
> I also wonder how useful this queue manager proposal would be in light
> of Mellanox's subfunction proposal. If people just start to create
> many small netdevs (albeit at high cost which people may argue
> against) consisting of just an rx/tx queue pair, then the queue
> manager dynamic allocation proposal would not be as useful. We could
> just use one of these netdevs to bind to in the AF_XDP case and always
> just specify queue 0. But one can argue that queue management is
> needed even for the subfunction approach, but then it would be at a
> much lower level than what I proposed. What is your take on this?
> Still worth pursuing in some form or another? If yes, then we really
> need to come up with an easy way of supporting this in current
> drivers. It is not going to fly otherwise, IMHO.
> 

I need to find some time to take a deep dive on the subfunction idea. I
like the intent, but need to understand the details.

Thanks for the update.
