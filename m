Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B1F43CA113
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 17:03:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231192AbhGOPFx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 11:05:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbhGOPFw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Jul 2021 11:05:52 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94A4AC06175F
        for <netdev@vger.kernel.org>; Thu, 15 Jul 2021 08:02:58 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id h8so8598937eds.4
        for <netdev@vger.kernel.org>; Thu, 15 Jul 2021 08:02:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Yluq3beMV5fv9/Nk87EzEa1ZxTYd3mzcMJaKDO7x4Vg=;
        b=tmIomh/MEK5Au1dRya+387VrIb++sWNgScG7/F2JXr+zc9TZILAd+oJqCU7TlojXFw
         y/IlFFftKD5HYw2kc2WQMAm7hl1zAc6lhGw3jclsj1gJPxa3x0rOFr/RoueciggSV2W+
         vN7agWZDf6nMMO6BNLUmUx25LXWlNugY/uPU5PXQNM6ER2VRbVKxDXvyOpB117l5PTw9
         w2hN2cgwohw9pEV3k7kzV5gLEMLrzTbKmvb3y2CFWYiPDELw/c80UluYZhH3YgKtsyKU
         YSjeDhngy+rvMbT87ErftTQp3/b9gRTcpLyckw01D/NxOxXwCJ/VgCxHZvfmb8O0qvCW
         1EPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Yluq3beMV5fv9/Nk87EzEa1ZxTYd3mzcMJaKDO7x4Vg=;
        b=GfePGz/8ZhNCnZ61LY3O8kgP+LjlEFw7Eqg34A6rFCRif2ci72boRNs5IIF9oT5/6z
         bBZbE33UZLlAfxJ19y8AjQx7U8iZ7PRMp7bqLr+TZDFVigwgYGCpy8AfQ2fw4Obkho0r
         Ij19w3u3BsWuIFNQgi/KZfxVpHHsWFFmpyploWEj2Y9e7mh3TYTP2nL37BQTxLX55Ldq
         g8/ocuo/V1dTtCuo77ll9+/9n1DjdEeyvYdlVzmE0MkPmydiQbjW3eumREtqOB02EmLf
         1A3FuvskzpWqVkQeoh/knjC3quXzH4dfywD5jhPfnXdVoMMhzUGm1HxizPFHRhcCN9sk
         sEdw==
X-Gm-Message-State: AOAM5312K1OWRf2d81c2rpAm+wjKIz6pzyGAFkYUchEtgAOVPNgUlj2h
        41F/BwT0YJeagZcAd/LEw7W/Uw==
X-Google-Smtp-Source: ABdhPJxPZoQhKVPrlfkBexsehYqwhichiPmzBkfipmfJwsofsg05PAyw7/fAr4FoIvAgJdvqn2HXUQ==
X-Received: by 2002:a05:6402:4cb:: with SMTP id n11mr7624597edw.292.1626361377200;
        Thu, 15 Jul 2021 08:02:57 -0700 (PDT)
Received: from Iliass-MBP (ppp-94-66-243-35.home.otenet.gr. [94.66.243.35])
        by smtp.gmail.com with ESMTPSA id m26sm462685edf.4.2021.07.15.08.02.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jul 2021 08:02:56 -0700 (PDT)
Date:   Thu, 15 Jul 2021 18:02:53 +0300
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Yunsheng Lin <linyunsheng@huawei.com>,
        Netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Lobakin <alobakin@pm.me>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Guillaume Nault <gnault@redhat.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Matteo Croce <mcroce@microsoft.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1 v2] skbuff: Fix a potential race while recycling
 page_pool packets
Message-ID: <YPBOHcx/sCEz/+wn@Iliass-MBP>
References: <20210709062943.101532-1-ilias.apalodimas@linaro.org>
 <bf326953-495f-db01-e554-42f4421d237a@huawei.com>
 <CAKgT0UemhFPHo9krmQfm=yNTSjwpBwVkoFtLEEQ-qLVh=-BeHg@mail.gmail.com>
 <YPBKFXWdDytvPmoN@Iliass-MBP>
 <CAKgT0UfOr7U-8T+Hr9NVPL7EMYaTzbx7w1-hUthjD9bXUFsqMw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKgT0UfOr7U-8T+Hr9NVPL7EMYaTzbx7w1-hUthjD9bXUFsqMw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 15, 2021 at 07:57:57AM -0700, Alexander Duyck wrote:
> On Thu, Jul 15, 2021 at 7:45 AM Ilias Apalodimas
> <ilias.apalodimas@linaro.org> wrote:
> >
> > > > >           atomic_sub_return(skb->nohdr ? (1 << SKB_DATAREF_SHIFT) + 1 : 1,
> >
> > [...]
> >
> > > > >                             &shinfo->dataref))
> > > > > -             return;
> > > > > +             goto exit;
> > > >
> > > > Is it possible this patch may break the head frag page for the original skb,
> > > > supposing it's head frag page is from the page pool and below change clears
> > > > the pp_recycle for original skb, causing a page leaking for the page pool?
> > >
> > > I don't see how. The assumption here is that when atomic_sub_return
> > > gets down to 0 we will still have an skb with skb->pp_recycle set and
> > > it will flow down and encounter skb_free_head below. All we are doing
> > > is skipping those steps and clearing skb->pp_recycle for all but the
> > > last buffer and the last one to free it will trigger the recycling.
> >
> > I think the assumption here is that
> > 1. We clone an skb
> > 2. The original skb goes into pskb_expand_head()
> > 3. skb_release_data() will be called for the original skb
> >
> > But with the dataref bumped, we'll skip the recycling for it but we'll also
> > skip recycling or unmapping the current head (which is a page_pool mapped
> > buffer)
> 
> Right, but in that case it is the clone that is left holding the
> original head and the skb->pp_recycle flag is set on the clone as it
> was copied from the original when we cloned it. 

Ah yes, that's what I missed

> What we have
> essentially done is transferred the responsibility for freeing it from
> the original to the clone.
> 
> If you think about it the result is the same as if step 2 was to go
> into kfree_skb. We would still be calling skb_release_data and the
> dataref would be decremented without the original freeing the page. We
> have to wait until all the clones are freed and dataref reaches 0
> before the head can be recycled.

Yep sounds correct

Thanks
/Ilias
