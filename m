Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C78212A1C7
	for <lists+netdev@lfdr.de>; Tue, 24 Dec 2019 14:35:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726245AbfLXNet (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Dec 2019 08:34:49 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:28365 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726140AbfLXNet (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Dec 2019 08:34:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1577194486;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=z2q4OL9ihk4Apd9lWWlPYliz8UTcK7dTTZ5u7f9/tL8=;
        b=PU9V7y49DQkriYrbHtszXDtFLOdCfsoeL+Gs+yjQOCBN9utDBPXj5ysRlsa3+Bi8Bears9
        agLVwpd3WOf3E2aGAi/TrkA6yMjXQInjbpGo4dap6aXUqNYjQtxRKEch2q1Cp5Ar/OnYhy
        SUimtKOsPmYSqTxlJTSf0hMJLcZ9kqY=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-95-C5QjoQs1MJCFgrAHQWhMBQ-1; Tue, 24 Dec 2019 08:34:44 -0500
X-MC-Unique: C5QjoQs1MJCFgrAHQWhMBQ-1
Received: by mail-lj1-f200.google.com with SMTP id k25so4642757lji.4
        for <netdev@vger.kernel.org>; Tue, 24 Dec 2019 05:34:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=z2q4OL9ihk4Apd9lWWlPYliz8UTcK7dTTZ5u7f9/tL8=;
        b=LdAiDrBJPs09P1IUa9kYE2Bv5Zrz6k2ncYzKgVMbQOIv9e+nZetWXDkxAu8V6uk40e
         dYsh+w0nCz/roilrBWvyXj0YxA4niH4itZ7Kr0v2veMbejHeXi+haulUyYM5R0Zq29+b
         66+JxrCCvuhTp3/qi6PgRLb5OvbAmjHwTXMmKRBdEom43sXZdsIUvpWHJ37fvLB6p6Dn
         AhUYtcpLuj/D9YwaYakzCQNn9CfAI63wEhUM76YqvH4GCDD5JMlnFGqvY6NDP0Myo0zF
         iVGywIgv3+21jZs2PrzjkvIwH1+CKSzsfcM73lfed2iQurMA3ycIq4Gzr2DxRGEgHi9P
         HqJQ==
X-Gm-Message-State: APjAAAXgUsvlUDaKBhIqLwyKoZemTj/UtVn6Ska5ei34xS7EUEp6EHST
        yA1Jae4NffGFtTo5MEcXQ13PtAOaglY98VHfrvfOTyEMV8H97l8xFXPjCticE3/Lv6zoU4RaLch
        ZtI/OBCjALkQ0Rd081HRS8/B0Jla2YKK3
X-Received: by 2002:a2e:a486:: with SMTP id h6mr13293949lji.235.1577194483336;
        Tue, 24 Dec 2019 05:34:43 -0800 (PST)
X-Google-Smtp-Source: APXvYqzA5nHrwNIXn8vl0vtcv0E5G8M12QmEmWl4uoe5YycqgbHMKvn+tixpF5hsd1XduLn1ToxUO/W02+T/ll8x6EQ=
X-Received: by 2002:a2e:a486:: with SMTP id h6mr13293926lji.235.1577194483020;
 Tue, 24 Dec 2019 05:34:43 -0800 (PST)
MIME-Version: 1.0
References: <20191224010103.56407-1-mcroce@redhat.com> <20191224095229.GA24310@apalos.home>
In-Reply-To: <20191224095229.GA24310@apalos.home>
From:   Matteo Croce <mcroce@redhat.com>
Date:   Tue, 24 Dec 2019 14:34:07 +0100
Message-ID: <CAGnkfhzrSaVe3zJ+0rriqqELha554Gmv-zskrJbiBjhHdUG2uQ@mail.gmail.com>
Subject: Re: [RFC net-next 0/2] mvpp2: page_pool support
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Tomislav Tomasic <tomislav.tomasic@sartura.hr>,
        Marcin Wojtas <mw@semihalf.com>,
        Stefan Chulski <stefanc@marvell.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Nadav Haklai <nadavh@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 24, 2019 at 10:52 AM Ilias Apalodimas
<ilias.apalodimas@linaro.org> wrote:
>
> On Tue, Dec 24, 2019 at 02:01:01AM +0100, Matteo Croce wrote:
> > This patches change the memory allocator of mvpp2 from the frag allocator to
> > the page_pool API. This change is needed to add later XDP support to mvpp2.
> >
> > The reason I send it as RFC is that with this changeset, mvpp2 performs much
> > more slower. This is the tc drop rate measured with a single flow:
> >
> > stock net-next with frag allocator:
> > rx: 900.7 Mbps 1877 Kpps
> >
> > this patchset with page_pool:
> > rx: 423.5 Mbps 882.3 Kpps
> >
> > This is the perf top when receiving traffic:
> >
> >   27.68%  [kernel]            [k] __page_pool_clean_page
>
> This seems extremly high on the list.
>
> >    9.79%  [kernel]            [k] get_page_from_freelist
> >    7.18%  [kernel]            [k] free_unref_page
> >    4.64%  [kernel]            [k] build_skb
> >    4.63%  [kernel]            [k] __netif_receive_skb_core
> >    3.83%  [mvpp2]             [k] mvpp2_poll
> >    3.64%  [kernel]            [k] eth_type_trans
> >    3.61%  [kernel]            [k] kmem_cache_free
> >    3.03%  [kernel]            [k] kmem_cache_alloc
> >    2.76%  [kernel]            [k] dev_gro_receive
> >    2.69%  [mvpp2]             [k] mvpp2_bm_pool_put
> >    2.68%  [kernel]            [k] page_frag_free
> >    1.83%  [kernel]            [k] inet_gro_receive
> >    1.74%  [kernel]            [k] page_pool_alloc_pages
> >    1.70%  [kernel]            [k] __build_skb
> >    1.47%  [kernel]            [k] __alloc_pages_nodemask
> >    1.36%  [mvpp2]             [k] mvpp2_buf_alloc.isra.0
> >    1.29%  [kernel]            [k] tcf_action_exec
> >
> > I tried Ilias patches for page_pool recycling, I get an improvement
> > to ~1100, but I'm still far than the original allocator.
>
> Can you post the recycling perf for comparison?
>

  12.00%  [kernel]                  [k] get_page_from_freelist
   9.25%  [kernel]                  [k] free_unref_page
   6.83%  [kernel]                  [k] eth_type_trans
   5.33%  [kernel]                  [k] __netif_receive_skb_core
   4.96%  [mvpp2]                   [k] mvpp2_poll
   4.64%  [kernel]                  [k] kmem_cache_free
   4.06%  [kernel]                  [k] __xdp_return
   3.60%  [kernel]                  [k] kmem_cache_alloc
   3.31%  [kernel]                  [k] dev_gro_receive
   3.29%  [kernel]                  [k] __page_pool_clean_page
   3.25%  [mvpp2]                   [k] mvpp2_bm_pool_put
   2.73%  [kernel]                  [k] __page_pool_put_page
   2.33%  [kernel]                  [k] __alloc_pages_nodemask
   2.33%  [kernel]                  [k] inet_gro_receive
   2.05%  [kernel]                  [k] __build_skb
   1.95%  [kernel]                  [k] build_skb
   1.89%  [cls_matchall]            [k] mall_classify
   1.83%  [kernel]                  [k] page_pool_alloc_pages
   1.80%  [kernel]                  [k] tcf_action_exec
   1.70%  [mvpp2]                   [k] mvpp2_buf_alloc.isra.0
   1.63%  [kernel]                  [k] free_unref_page_prepare.part.0
   1.45%  [kernel]                  [k] page_pool_return_skb_page
   1.42%  [act_gact]                [k] tcf_gact_act
   1.16%  [kernel]                  [k] netif_receive_skb_list_internal
   1.08%  [kernel]                  [k] kfree_skb
   1.07%  [kernel]                  [k] skb_release_data


> >
> > Any idea on why I get such bad numbers?
>
> Nop but it's indeed strange
>
> >
> > Another reason to send it as RFC is that I'm not fully convinced on how to
> > use the page_pool given the HW limitation of the BM.
>
> I'll have a look right after holidays
>

Thanks

> >
> > The driver currently uses, for every CPU, a page_pool for short packets and
> > another for long ones. The driver also has 4 rx queue per port, so every
> > RXQ #1 will share the short and long page pools of CPU #1.
> >
>
> I am not sure i am following the hardware config here
>

Never mind, it's quite a mess, I needed a lot of time to get it :)

The HW put the packets in different buffer pools depending on the size:
short: 64..128
long: 128..1664
jumbo: 1664..9856

Let's skip the jumbo buffer for now and assume we have 4 CPU, the
driver allocates 4 short and 4 long buffers.
Each port has 4 RX queues, and each one uses a short and a long buffer.
With the page_pool api, we have 8 struct page_pool, 4 for the short
and 4 for the long buffers.


> > This means that for every RX queue I call xdp_rxq_info_reg_mem_model() twice,
> > on two different page_pool, can this be a problem?
> >
> > As usual, ideas are welcome.
> >
> > Matteo Croce (2):
> >   mvpp2: use page_pool allocator
> >   mvpp2: memory accounting
> >
> >  drivers/net/ethernet/marvell/Kconfig          |   1 +
> >  drivers/net/ethernet/marvell/mvpp2/mvpp2.h    |   7 +
> >  .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 142 +++++++++++++++---
> >  3 files changed, 125 insertions(+), 25 deletions(-)
> >
> > --
> > 2.24.1
> >
> Cheers
> /Ilias
>

Bye,
-- 
Matteo Croce
per aspera ad upstream

