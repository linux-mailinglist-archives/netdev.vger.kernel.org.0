Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 378CC346490
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 17:11:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233158AbhCWQLS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 12:11:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233147AbhCWQKv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 12:10:51 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4097C061763
        for <netdev@vger.kernel.org>; Tue, 23 Mar 2021 09:10:50 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id dm8so24122015edb.2
        for <netdev@vger.kernel.org>; Tue, 23 Mar 2021 09:10:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OtJczClZvyyzUz2W99ySZlZwsk7iPU0WG7wWmkyfXgQ=;
        b=uOQcAENri96Ujd0j2x9QyFmGHd81FS40zuZgNTVQ83ux6jRqlUcR/hbhuTMU2RGnkJ
         wuj5mMAlMWKZ3Miww2PYmeQuIolvMTxzicIvnrHKqFhNEJiDVBwk/JjoUzaowecIEu03
         6Ucu0AUjymXbCYqkRgFH/iC/irP+Wu+OXemJKKZS7xEXLdkHbXKIF5Y1fpWwKjhXfJWH
         Qtf/uUH2guRKmyQ3PljjT1z2RbbWX/rbz+LYwtGOXkWt2IiMSbHBRhrrx9czPjxpboca
         HusYM6pwdyh/qt2fclT95Gf0KQNtgc3jV9hpvdc3MLwd1YIDG3lE9JXMjlzNmV2YKK6C
         /YWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OtJczClZvyyzUz2W99ySZlZwsk7iPU0WG7wWmkyfXgQ=;
        b=GYY12EPvRPN2GgQcS0ZxnuUBQoLVQ/f1YPjTexus0z8XR929Zydqc+oot1IGsQazEf
         ntCWjsSYiyfZMC4MFhOQRmiH4oLHzilfypxz7TfywzynmFVBg68ivVx2224k0sKRnHqE
         jlfhjye/iZWmozDvbFfyUmffvBHoUR8C2lo5u7cSit3FJBzjoGzqlprT+EDaxSDa62HL
         iOpOy+4TD1E08kWKenR4xx84NBCmVK0u0mnapsWC62kqOTx6AKmBJUcGebQucdOMzHZB
         Clkv2zsVfNG2Sji1NfE5SXlfm6q+ozS3H0iuCO7QOSPW1xl8s1+t9U0wPQNo6tN8htb6
         2sNg==
X-Gm-Message-State: AOAM533YXvSGK0HcXwnb0Ab80xY0Rbz1oxcfoeQw5vbZPr2tdf5iBdv8
        NwVWbQnaZn2zxMMUAaqyEiQ+iw==
X-Google-Smtp-Source: ABdhPJzLRBsXt4/fR4e8wtncvkQEYxZNtsCOJ4qkU5rpaiRJTYKy8HdDP04Fo+UcjfeOgrf4nsJ44A==
X-Received: by 2002:a05:6402:160e:: with SMTP id f14mr5360148edv.45.1616515849553;
        Tue, 23 Mar 2021 09:10:49 -0700 (PDT)
Received: from enceladus (ppp-94-64-113-158.home.otenet.gr. [94.64.113.158])
        by smtp.gmail.com with ESMTPSA id k9sm13271942edn.68.2021.03.23.09.10.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Mar 2021 09:10:49 -0700 (PDT)
Date:   Tue, 23 Mar 2021 18:10:46 +0200
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     Alexander Lobakin <alobakin@pm.me>,
        Matteo Croce <mcroce@linux.microsoft.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        David Ahern <dsahern@gmail.com>,
        Saeed Mahameed <saeed@kernel.org>, Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH net-next 0/6] page_pool: recycle buffers
Message-ID: <YFoTBm0mJ4GyuHb6@enceladus>
References: <20210322170301.26017-1-mcroce@linux.microsoft.com>
 <20210323154112.131110-1-alobakin@pm.me>
 <YFoNoohTULmcpeCr@enceladus>
 <20210323170447.78d65d05@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210323170447.78d65d05@carbon>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 23, 2021 at 05:04:47PM +0100, Jesper Dangaard Brouer wrote:
> On Tue, 23 Mar 2021 17:47:46 +0200
> Ilias Apalodimas <ilias.apalodimas@linaro.org> wrote:
> 
> > On Tue, Mar 23, 2021 at 03:41:23PM +0000, Alexander Lobakin wrote:
> > > From: Matteo Croce <mcroce@linux.microsoft.com>
> > > Date: Mon, 22 Mar 2021 18:02:55 +0100
> > >   
> > > > From: Matteo Croce <mcroce@microsoft.com>
> > > >
> > > > This series enables recycling of the buffers allocated with the page_pool API.
> > > > The first two patches are just prerequisite to save space in a struct and
> > > > avoid recycling pages allocated with other API.
> > > > Patch 2 was based on a previous idea from Jonathan Lemon.
> > > >
> > > > The third one is the real recycling, 4 fixes the compilation of __skb_frag_unref
> > > > users, and 5,6 enable the recycling on two drivers.
> > > >
> > > > In the last two patches I reported the improvement I have with the series.
> > > >
> > > > The recycling as is can't be used with drivers like mlx5 which do page split,
> > > > but this is documented in a comment.
> > > > In the future, a refcount can be used so to support mlx5 with no changes.
> > > >
> > > > Ilias Apalodimas (2):
> > > >   page_pool: DMA handling and allow to recycles frames via SKB
> > > >   net: change users of __skb_frag_unref() and add an extra argument
> > > >
> > > > Jesper Dangaard Brouer (1):
> > > >   xdp: reduce size of struct xdp_mem_info
> > > >
> > > > Matteo Croce (3):
> > > >   mm: add a signature in struct page
> > > >   mvpp2: recycle buffers
> > > >   mvneta: recycle buffers
> > > >
> > > >  .../chelsio/inline_crypto/ch_ktls/chcr_ktls.c |  2 +-
> > > >  drivers/net/ethernet/marvell/mvneta.c         |  4 +-
> > > >  .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 17 +++----
> > > >  drivers/net/ethernet/marvell/sky2.c           |  2 +-
> > > >  drivers/net/ethernet/mellanox/mlx4/en_rx.c    |  2 +-
> > > >  include/linux/mm_types.h                      |  1 +
> > > >  include/linux/skbuff.h                        | 33 +++++++++++--
> > > >  include/net/page_pool.h                       | 15 ++++++
> > > >  include/net/xdp.h                             |  5 +-
> > > >  net/core/page_pool.c                          | 47 +++++++++++++++++++
> > > >  net/core/skbuff.c                             | 20 +++++++-
> > > >  net/core/xdp.c                                | 14 ++++--
> > > >  net/tls/tls_device.c                          |  2 +-
> > > >  13 files changed, 138 insertions(+), 26 deletions(-)  
> > > 
> > > Just for the reference, I've performed some tests on 1G SoC NIC with
> > > this patchset on, here's direct link: [0]
> > >   
> > 
> > Thanks for the testing!
> > Any chance you can get a perf measurement on this?
> 
> I guess you mean perf-report (--stdio) output, right?
> 

Yea, 
As hinted below, I am just trying to figure out if on Alexander's platform the
cost of syncing, is bigger that free-allocate. I remember one armv7 were that
was the case. 

> > Is DMA syncing taking a substantial amount of your cpu usage?
> 
> (+1 this is an important question)
>  
> > > 
> > > [0] https://lore.kernel.org/netdev/20210323153550.130385-1-alobakin@pm.me
> > > 
> 
> -- 
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
> 
