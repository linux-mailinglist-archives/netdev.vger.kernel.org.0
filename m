Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D37D49B089
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 10:44:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1574948AbiAYJh3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 04:37:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355481AbiAYJfE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 04:35:04 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81CCDC06177E;
        Tue, 25 Jan 2022 01:35:04 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id j16so8131227plx.4;
        Tue, 25 Jan 2022 01:35:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+yQlaQTidkaW+1qPreQX8/B3xGfNTHM3RX9ZKojZFPc=;
        b=bY9qsQoUFZxjwUM6Vk6zgKNRBb+piR3OFtIWuvC9NPD9ajKtxf1SLCGA/c31p2LlT3
         B8oc71m0V8V0LhHYBSTQ2omkNLEOwhQAwc260IDt9qRb+GVCQW2PmDiBuOZ7YucAQ5wf
         rnB8OUWI1w1aVJy/9jnGIv16/vTsd+yAq4G7PuhPkVv8Jw6cRH2JtoM6xpTY7aUJnHeE
         4vj+6KlCIPUk6Ww378dd3w/bRN7v+AlvPC/p/MIg9VobThs76BXr/gw4Z10dzh/L5AVM
         wKSrsGVvPVtyjCCILZVxAOwutingeaFM1BkljWKVZOtwKZ69FJ8Z20gOmjqE8x57FFKx
         Y6Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+yQlaQTidkaW+1qPreQX8/B3xGfNTHM3RX9ZKojZFPc=;
        b=GST5Qvxe454v3VnfaQp5ANgRUxsJ+1Z9I6AIrOX8R00p48itS//y9Ql3m1ZZVUS7u0
         pnydpKDEuODMjGjwiDvR/OL7q0sSJr4gFycYSbPH8CrgGhrjmH9cOhi/SGorDVu60831
         oH+3Hxb90r3MDnPYrdh0Md6BR8t9OC3Wrl88MA7AWA3Nx4GYnOnY+cm/ZHVx83vDiz5a
         4KDfAfqF3kkunsDLt9XWdTHUoIlEcD0evg2r462DtXH3SAIU22ISCjODVss5yivgCJ2f
         1FrJUFw5O3rwu0gKmUq9ckquJ1sevikY6shfEAukxunC75XD7E+9IB48mdwqEEAu7zH9
         TrDg==
X-Gm-Message-State: AOAM5337JG/uCC6mEV6DqF0HqVFj8hOhhu5/USrDKk+X9/HwNH+9vmN5
        uvAfly3GzEM0YJhyB03yKsmPN6fXcBm6tg==
X-Google-Smtp-Source: ABdhPJxK0drWhoEulv/ADBxE6BbuYPFG5/iWFKBFKt5lWcBjenRxTBeXLCBWglgjeav57ha1MyzvEg==
X-Received: by 2002:a17:902:c947:b0:14a:ff21:afe3 with SMTP id i7-20020a170902c94700b0014aff21afe3mr17932350pla.49.1643103304004;
        Tue, 25 Jan 2022 01:35:04 -0800 (PST)
Received: from ip-172-31-19-208.ap-northeast-1.compute.internal (ec2-18-181-137-102.ap-northeast-1.compute.amazonaws.com. [18.181.137.102])
        by smtp.gmail.com with ESMTPSA id x25sm17773688pfu.205.2022.01.25.01.35.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 01:35:03 -0800 (PST)
Date:   Tue, 25 Jan 2022 09:34:58 +0000
From:   Hyeonggon Yoo <42.hyeyoo@gmail.com>
To:     Shay Agroskin <shayagr@amazon.com>
Cc:     Julian Wiedmann <jwiedmann.dev@gmail.com>, netdev@vger.kernel.org,
        Arthur Kiyanovski <akiyano@amazon.com>,
        David Arinzon <darinzon@amazon.com>,
        Noam Dagan <ndagan@amazon.com>,
        Saeed Bishara <saeedb@amazon.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sameeh Jubran <sameehj@amazon.com>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: ena: Do not waste napi skb cache
Message-ID: <Ye/EQgqCBogZR87T@ip-172-31-19-208.ap-northeast-1.compute.internal>
References: <20220123115623.94843-1-42.hyeyoo@gmail.com>
 <f835cbb3-a028-1daf-c038-516dd47ce47c@gmail.com>
 <5cca8bdd-bed0-f26a-6c96-d18947d3a50b@gmail.com>
 <pj41zlmtjk7t9a.fsf@u570694869fb251.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <pj41zlmtjk7t9a.fsf@u570694869fb251.ant.amazon.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 24, 2022 at 10:50:05PM +0200, Shay Agroskin wrote:
> 
> Julian Wiedmann <jwiedmann.dev@gmail.com> writes:
> 
> > On 24.01.22 10:57, Julian Wiedmann wrote:
> > > On 23.01.22 13:56, Hyeonggon Yoo wrote:
> > > > By profiling, discovered that ena device driver allocates skb by
> > > > build_skb() and frees by napi_skb_cache_put(). Because the
> > > > driver
> > > > does not use napi skb cache in allocation path, napi skb cache
> > > > is
> > > > periodically filled and flushed. This is waste of napi skb
> > > > cache.
> > > > 
> > > > As ena_alloc_skb() is called only in napi, Use napi_build_skb()
> > > > instead of build_skb() to when allocating skb.
> > > > 
> > > > This patch was tested on aws a1.metal instance.
> > > > 
> > > > Signed-off-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
> > > > ---
> > > >  drivers/net/ethernet/amazon/ena/ena_netdev.c | 2 +-
> > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > > 
> > > > diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c
> > > > b/drivers/net/ethernet/amazon/ena/ena_netdev.c
> > > > index c72f0c7ff4aa..2c67fb1703c5 100644
> > > > --- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
> > > > +++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
> > > > @@ -1407,7 +1407,7 @@ static struct sk_buff
> > > > *ena_alloc_skb(struct ena_ring *rx_ring, void *first_frag)
> > > >  		skb = netdev_alloc_skb_ip_align(rx_ring->netdev,
> > > >  						rx_ring->rx_copybreak);
> > > 
> > > To keep things consistent, this should then also be
> > > napi_alloc_skb().
> > >

Right. I missed this. Thank you for pointing this!

> > 
> > And on closer look, this copybreak path also looks buggy. If
> > rx_copybreak
> > gets reduced _while_ receiving a frame, the allocated skb can end up too
> > small to take all the data.
> > 
> > @ ena maintainers: can you please fix this?
> > 
> 

Shay and Julian, Thank you for reviewing this.

> Updating the copybreak value is done through ena_ethtool.c
> (ena_set_tunable()) which updates `adapter->rx_copybreak`.
> The adapter->rx_copybreak value is "propagated back" to the ring local
> attributes (rx_ring->rx_copybreak) only after an interface toggle which
> stops the napi routine first.
> 
> Unless I'm missing something here I don't think the bug you're describing
> exists.
> 
> I agree that the netdev_alloc_skb_ip_align() can become napi_alloc_skb().
> Hyeonggon Yoo, can you please apply this change as well to this patch?
> 

Okay. I'll update and test it again.

BTW, It seems netdev_alloc_skb_ip_align() is used to make some fields
be aligned. It's okay to just ignore this?

Thanks,
Hyeonggon.

> Thanks,
> Shay
> 
> 
> > > >  	else
> > > > -		skb = build_skb(first_frag, ENA_PAGE_SIZE);
> > > > +		skb = napi_build_skb(first_frag, ENA_PAGE_SIZE);
> > > >  	if (unlikely(!skb)) {
> > > >  		ena_increase_stat(&rx_ring->rx_stats.skb_alloc_fail,  1,
> > > 
