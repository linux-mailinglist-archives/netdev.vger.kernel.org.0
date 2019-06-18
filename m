Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 981574A8DC
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 19:54:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729671AbfFRRyM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 13:54:12 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:43097 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729586AbfFRRyM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 13:54:12 -0400
Received: by mail-lf1-f65.google.com with SMTP id j29so9973470lfk.10
        for <netdev@vger.kernel.org>; Tue, 18 Jun 2019 10:54:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=NouuY42zJKl63ZgtDCXlF0UJACWgTUbc5Huhqpxp5co=;
        b=oDCaNMLEkdZscBjrOIsA2muSEFyDu04wxA5rJHW1SAtvJ/TYLHlkluo2rn6w+6wyp+
         BaRrFjW2caS2+/xCXTCETPEpurpKKdahqZ9IyLcD/bJc4DG3wl25NVpl7hQXpPGAWaX/
         Czq71ChxNkaQKhA16SCfdCvIZzUga6e0/7KHcuGZmyy0ZuVdN9qH316yWBioaH/cR18j
         8zF28VOcw+gny0or0XPiIqQ9VHWF3kDFpfq7MYX33Ig28DDYrXCQ+j7uLER7jN8HbzA6
         k/lF3OSRDB2kCBnxT46OHkvp6GM9HNkSYwfUqBd6WA/N1na4nHs59laJAi3zSC7e8wBJ
         etow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=NouuY42zJKl63ZgtDCXlF0UJACWgTUbc5Huhqpxp5co=;
        b=aY56vuR8yqAR3+FbKUE38HZJDcLmJ0E1QzLztUOcVmREhf4ncUUAcT5E/33/2mcYFw
         rIqAZz7wTC3mpsebK6KxqQhgd3xHa4dWNCbIEdsP60FAM3bDam1rpSh4MgyFBnuEFRk5
         NAX9O26LnWzFU7Bfbkn2DjjXqTYW0qyHbowIBNM/2nqvfiZfu5pheVh4xFQvjHVlpmTY
         QSJMaSyyh9yiDHBcjbgKjtZcdEYFqzOjj1J8CbNsVyoYpSl095IPLMqNMSC+uKaZ1N1e
         51UB80vlnWFmQNcKzmWaqFyxzbKWIKMU8pAmr873+O3OOxum57T0wBRWlVFGuHk/nRCB
         c1+Q==
X-Gm-Message-State: APjAAAVOPW/tUAy3PQmI0P6urYR21TbFWJN7LpY9i8+o8f7CfjaSDOWN
        EeNovC6EgoyrFr13+HjzNS8PNw==
X-Google-Smtp-Source: APXvYqz4LmvkwHFIM1Nkt9bcabYZNY7yd43n3uOYjb9S0H+pZ8moZ5tABt6wwg/nMYLlAsSZgtioZw==
X-Received: by 2002:ac2:4109:: with SMTP id b9mr26647665lfi.31.1560880449513;
        Tue, 18 Jun 2019 10:54:09 -0700 (PDT)
Received: from khorivan (59-201-94-178.pool.ukrtel.net. [178.94.201.59])
        by smtp.gmail.com with ESMTPSA id r84sm2988644lja.54.2019.06.18.10.54.08
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 18 Jun 2019 10:54:08 -0700 (PDT)
Date:   Tue, 18 Jun 2019 20:54:07 +0300
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Tariq Toukan <tariqt@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        "toshiaki.makita1@gmail.com" <toshiaki.makita1@gmail.com>,
        "grygorii.strashko@ti.com" <grygorii.strashko@ti.com>,
        "mcroce@redhat.com" <mcroce@redhat.com>
Subject: Re: [PATCH net-next v1 08/11] xdp: tracking page_pool resources and
 safe removal
Message-ID: <20190618175405.GA3227@khorivan>
References: <156045046024.29115.11802895015973488428.stgit@firesoul>
 <156045052249.29115.2357668905441684019.stgit@firesoul>
 <20190615093339.GB3771@khorivan>
 <a02856c1-46e7-4691-6bb9-e0efb388981f@mellanox.com>
 <20190618125431.GA5307@khorivan>
 <20190618171951.17128ed8@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190618171951.17128ed8@carbon>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 18, 2019 at 05:19:51PM +0200, Jesper Dangaard Brouer wrote:
Hi, Jesper

>
>On Tue, 18 Jun 2019 15:54:33 +0300 Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org> wrote:
>
>> On Sun, Jun 16, 2019 at 10:56:25AM +0000, Tariq Toukan wrote:
>> >
>> >On 6/15/2019 12:33 PM, Ivan Khoronzhuk wrote:
>> >> On Thu, Jun 13, 2019 at 08:28:42PM +0200, Jesper Dangaard Brouer wrote:
>[...]
>> >>
>> >> What would you recommend to do for the following situation:
>> >>
>> >> Same receive queue is shared between 2 network devices. The receive ring is
>> >> filled by pages from page_pool, but you don't know the actual port (ndev)
>> >> filling this ring, because a device is recognized only after packet is
>> >> received.
>> >>
>> >> The API is so that xdp rxq is bind to network device, each frame has
>> >> reference
>> >> on it, so rxq ndev must be static. That means each netdev has it's own rxq
>> >> instance even no need in it. Thus, after your changes, page must be
>> >> returned to
>> >> the pool it was taken from, or released from old pool and recycled in
>> >> new one
>> >> somehow.
>> >>
>> >> And that is inconvenience at least. It's hard to move pages between
>> >> pools w/o performance penalty. No way to use common pool either,
>> >> as unreg_rxq now drops the pool and 2 rxqa can't reference same
>> >> pool.
>> >
>> >Within the single netdev, separate page_pool instances are anyway
>> >created for different RX rings, working under different NAPI's.
>>
>> The circumstances are so that same RX ring is shared between 2
>> netdevs... and netdev can be known only after descriptor/packet is
>> received. Thus, while filling RX ring, there is no actual device,
>> but when packet is received it has to be recycled to appropriate
>> net device pool. Before this change there were no difference from
>> which pool the page was allocated to fill RX ring, as there were no
>> owner. After this change there is owner - netdev page pool.
>
>It not really a dependency added in this patchset.  A page_pool is
>strictly bound to a single RX-queue, for performance, as this allow us
>a NAPI fast-path return used for early drop (XDP_DROP).
>
>I can see that the API xdp_rxq_info_reg_mem_model() make it possible to
>call it on different xdp_rxq_info structs with the same page_pool
>pointer.  But it was never intended to be used like that, and I
>consider it an API usage violation.  I originally wanted to add the
>allocator pointer to xdp_rxq_info_reg() call, but the API was extended
>in different versions, so I didn't want to break users.  I've actually
>tried hard to catch when drivers use the API wrong, via WARN(), but I
>guess you found a loop hole.
>
>Besides, we already have a dependency from the RX-queue to the netdev
>in the xdp_rxq_info structure.
>E.g. the xdp_rxq_info->dev is sort of
>central, and dereferenced by BPF-code to read xdp_md->ingress_ifindex,
>and also used by cpumap when creating SKBs.
Yes, That's I'm talking about.

>
>
>> For cpsw the dma unmap is common for both netdevs and no difference
>> who is freeing the page, but there is difference which pool it's
>> freed to.
>>
>> So that, while filling RX ring the page is taken from page pool of
>> ndev1, but packet is received for ndev2, it has to be later
>> returned/recycled to page pool of ndev1, but when xdp buffer is
>> handed over to xdp prog the xdp_rxq_info has reference on ndev2 ...
>>
>> And no way to predict the final ndev before packet is received, so no
>> way to choose appropriate page pool as now it becomes page owner.
>>
>> So, while RX ring filling, the page/dma recycling is needed but should
>> be some way to identify page owner only after receiving packet.
>>
>> Roughly speaking, something like:
>>
>> pool->pages_state_hold_cnt++;
>>
>> outside of page allocation API, after packet is received.
>
>Don't EVER manipulate the internal state outside of page allocation
>API.  That kills the purpose of defining any API.
And I don't, that's rough propose that can be covered by newer API and here kind
of material for explanation.

This RX ring is filled by internal descriptors for 2 netdevs, it's common only
internally. But to bind descriptor with a page, the page must be allocated from
pool bind to ndev, In case of cpsw, ndev is identified only after the
descriptor/packet is received. Then, it can be related to some ndev and thus
pool. The example in question only shows what API needs to allow underneath.

For this, the following is needed:

1) Allocate page from page pool, but w/o counter inc, so driver can became the
owner and bind it with a descriptor and put it to RX ring for receiving a
packet by h/w.

2) after a packet is received the counter needs to be inc for a pool the packet
is destined for and let xdp infrastructure do the rest.

That's it.
I don't propose to change the API for those who doesn't require it,
just let to use more detailed variant for those who can't use it in regular way.

And it's not final decision would be nice to hear another constructive
propositions.

>
>> and free of the counter while allocation (w/o owing the page).
>
>You use-case of two netdev's sharing the same RX-queue sounds dubious,
>and very hardware specific.  I'm not sure why we want to bend the APIs
>to support this?
The question is rather why not? The allocator is supposed to be used as one of
the main generic solutions for XDP, if not say more, it should be able to cover
most of the hardware, not only for hi speed solutions, but for other usecases.
I don't propose to change main API, left it as is, just extend it that not only
single ndev hardware can use it... I can add it myself if you don't want to
bother.

> If we had to allow page_pool to be registered twice, via
>xdp_rxq_info_reg_mem_model() then I guess we could extend page_pool
>with a usage/users reference count, and then only really free the
>page_pool when refcnt reach zero.  But it just seems and looks wrong
>(in the code) as the hole trick to get performance is to only have one
>user.
I don't propose this.

>
>-- 
>Best regards,
>  Jesper Dangaard Brouer
>  MSc.CS, Principal Kernel Engineer at Red Hat
>  LinkedIn: http://www.linkedin.com/in/brouer

-- 
Regards,
Ivan Khoronzhuk
