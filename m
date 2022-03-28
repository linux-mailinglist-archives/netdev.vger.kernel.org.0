Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BEA84E9629
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 14:02:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242267AbiC1MEc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 08:04:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242218AbiC1MEW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 08:04:22 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AAE6DFEA
        for <netdev@vger.kernel.org>; Mon, 28 Mar 2022 05:02:41 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id x34so16603738ede.8
        for <netdev@vger.kernel.org>; Mon, 28 Mar 2022 05:02:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=u9gMefs9D4sXYrqNr7PYUc9+3nwjTh6EgKXpSLB3o0I=;
        b=uQ0mS6YUcbQd5D3VeXPWtaJrr1jPLq8djaTCYYTHmnvijDovdCue70fZltIEmy+awS
         2/nXdb4C3OiPRWiYWecR3+6s45+pHocRm0i33bNpE8ISYskfZ9AgjPBBumgwmPme1Agw
         SaulRP4/+X0l1WyMfbE3pDK7pPl5K4pOn3w8uv580e0zaQgBxSjUKmIuhwfkt1vzq+JG
         4lfA96TXeuiTNmmXRNPFQR1ujp2qHp4yAgwb5D4HUm3mT34e4FXNFtTbo7GQ+d6BzFF6
         YabEUae9zAuhGwsf8F+OSpFshX/83DmIb+V11KzYVy2hIWMOCY5c2IvFznOld8Bra6Gp
         E9LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=u9gMefs9D4sXYrqNr7PYUc9+3nwjTh6EgKXpSLB3o0I=;
        b=qosfq9ZBmh1wFxU4DEEW3QM57tFYfNHBiGNA3lsTd8X1OihBYNXCWEe0F4dLbNjVkU
         kE/Ql3FVgYkkt4AcAOyOqexI5H6ZdSuK3tSQMS32iNu8fhaP4JGNE3qBf/22zAI0auzI
         XUauXlHRClA/tiIGczgZUYyS6dTP/IgFuWaGM32wQ0DE+M8A6WXQwMF9EaBettcch/CK
         vYeeChkdTBV1eiP6d3zu+IX/Z/AjWBAGwQztyCu3XMoWorYjOWnv4x1rrHyTUZo9xbC3
         CNXvTSLXL/Or0Yax9y9VRQ/SxDDmPWGEVOqkx4szhxwVjS+1RQgxtRO1dW7onSbJj/Vq
         iYeg==
X-Gm-Message-State: AOAM531ICB76BxkojoPkDHF9PY3SkXpTuBUF+yG3qzYKROiHp+NBeXsZ
        GAbXm1MTX65bSnjaw8jvMqlI7Q==
X-Google-Smtp-Source: ABdhPJyIq3ZREWefYDa6IXpBpbYtJB6NEmv4R7CFSE2Y/3cI6x4PoXkwUHDLE+MdDlLzNkLCqSqReA==
X-Received: by 2002:aa7:d311:0:b0:419:443b:6222 with SMTP id p17-20020aa7d311000000b00419443b6222mr15689099edq.161.1648468959688;
        Mon, 28 Mar 2022 05:02:39 -0700 (PDT)
Received: from myrica (cpc92880-cmbg19-2-0-cust679.5-4.cable.virginm.net. [82.27.106.168])
        by smtp.gmail.com with ESMTPSA id n20-20020a17090695d400b006e0b0022b29sm3856223ejy.186.2022.03.28.05.02.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Mar 2022 05:02:39 -0700 (PDT)
Date:   Mon, 28 Mar 2022 13:02:14 +0100
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     Alexander Duyck <alexanderduyck@fb.com>
Cc:     Yunsheng Lin <linyunsheng@huawei.com>,
        "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
        "hawk@kernel.org" <hawk@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net] skbuff: disable coalescing for page_pool recycling
Message-ID: <YkGjxox4gsJrWvJT@myrica>
References: <20220324172913.26293-1-jean-philippe@linaro.org>
 <6dca1c23-e72e-7580-31ba-0ef1dfe745ad@huawei.com>
 <SA1PR15MB5137A34F08A624A565150338BD1A9@SA1PR15MB5137.namprd15.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SA1PR15MB5137A34F08A624A565150338BD1A9@SA1PR15MB5137.namprd15.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 25, 2022 at 02:50:46AM +0000, Alexander Duyck wrote:
> > >     The problem is here: both SKB1 and SKB2 point to PAGE2 but SKB1 does
> > >     not actually hold a reference to PAGE2.
> > 
> > it seems the SKB1 *does* hold a reference to PAGE2 by calling
> > __skb_frag_ref(), which increments the page->_refcount instead of
> > incrementing pp_frag_count, as skb_cloned(SKB3) is true and
> > __skb_frag_ref() does not handle page pool
> > case:
> > 
> > INVALID URI REMOVED
> > rc1/source/net/core/skbuff.c*L5308__;Iw!!Bt8RZUm9aw!u944ZiA7uzBuFvccr
> > rtR1xvondLNnkMf5xzM8xbbkosow-v5t-XdZJd6bMsByMx2Kw$
> 
> I'm confused here as well. I don't see a path where you can take ownership of the page without taking a reference.
> 
> Specifically the skb_head_is_locked() won't let you steal the head if the skb is cloned. And then for the frags they have an additional reference taken if the skb is cloned.
> 
> >  Without coalescing, when
> > >     releasing both SKB2 and SKB3, a single reference to PAGE2 would be
> > >     dropped. Now when releasing SKB1 and SKB2, two references to PAGE2
> > >     will be dropped, resulting in underflow.
> > >
> > >  (3c) Drop SKB2:
> > >
> > >       af_packet_rcv(SKB2)
> > >         consume_skb(SKB2)
> > >           skb_release_data(SKB2)                // drops second dataref
> > >             page_pool_return_skb_page(PAGE2)    // drops one pp_frag_count
> > >
> > >                       SKB1 _____ PAGE1
> > >                            \____
> > >                                  PAGE2
> > >                                  /
> > >                 RX_BD3 _________/
> > >
> > > (4) Userspace calls recvmsg()
> > >     Copies SKB1 and releases it. Since SKB3 was coalesced with SKB1, we
> > >     release the SKB3 page as well:
> > >
> > >     tcp_eat_recv_skb(SKB1)
> > >       skb_release_data(SKB1)
> > >         page_pool_return_skb_page(PAGE1)
> > >         page_pool_return_skb_page(PAGE2)        // drops second
> > pp_frag_count
> > >
> > > (5) PAGE2 is freed, but the third RX descriptor was still using it!
> > >     In our case this causes IOMMU faults, but it would silently corrupt
> > >     memory if the IOMMU was disabled.
> 
> I think I see the problem. It is when you get into steps 4 and 5 that you are actually hitting the issue. When you coalesced the page you ended up switching the page from a page pool page to a reference counted page, but it is being stored in a page pool skb. That is the issue. Basically if the skb is a pp_recycle skb we should be incrementing the frag count, not the reference count.
> So essentially the logic should be that if to->pp_recycle is set but from is cloned then you need to return false. The problem isn't that they are both pp_recycle skbs, it is that the from was cloned and we are trying to merge that into a pp_recycle skb by adding to the reference count of the pages.

I agree with this, the problem is switching from a page_pool frag refcount
to a page refcount. I suppose we could change __skb_frag_ref() to increase
the pp_frag_count but that's probably best left as future improvement, I
don't want to break more than I fix here. I'll send a v2 with a check on
(cloned(from) && from->pp_recycle)

Thanks,
Jean

> 
> > > A proper implementation would probably take another reference from the
> > > page_pool at step (3b), but that seems too complicated for a fix. Keep
> > > it simple for now, prevent coalescing for page_pool users.
