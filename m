Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3980E40D4D0
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 10:44:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235245AbhIPIpg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 04:45:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235009AbhIPIpf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Sep 2021 04:45:35 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55E4EC061574
        for <netdev@vger.kernel.org>; Thu, 16 Sep 2021 01:44:15 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id d21so8140894wra.12
        for <netdev@vger.kernel.org>; Thu, 16 Sep 2021 01:44:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dKZLjg+J3/Gc1joUzlvOxfMobi0Vi8uNZjcFxom/GJU=;
        b=lh15FStn8eOQ77x1NyuFQa7UcDUBQQzgb6EpxF4xE1L682S7BIWrSEAoyXKaKn9Qzf
         E0iYFkaNzCjrsmQhXA2rfPfoGi45CU71m9BMoMZqCBMhrtEyMG86v5AhNoy5K4m5tXvi
         FPscH1WmoeAQ2tHwTSh6SXx9RqfhLxhaAZcgGU182hsQkFk3y6Uhkw9PaBqWgYieKjRj
         VTuf3rnxPLu+r2P29ivIKMCxTo9ZgaEzxA2Sn0wfhwWPQLq9BI63+Snc17XSIrAgLfXU
         8V0UYsuJHX/TOK0oa6afp5EoaR9JI+qGjSgPGvSc+Iri6V41QE0qQ/IpRueuxcnF2zaH
         tw5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dKZLjg+J3/Gc1joUzlvOxfMobi0Vi8uNZjcFxom/GJU=;
        b=i4zxKS6hdfn0886xNEc3LPi68f9aMv8YW5WFVrp8wgFEJRU/IEeWsT3gXuKutzRGqc
         N5pms7z0DieNh4qugwrGjDxZvLAGqGoLuFjR7+IksbvxXirw2LQPMXh4DLVmZWXVUL6f
         NTSW9cHYg2KmXd7jGVos3BBhS3qzB+q0uN2JeuyMrZyQEhTz8CW/gmmbH68/SrQeLMgp
         kwKQHgPACo1/qaZTXT10udQF1Yfsrj2l0USjdG1iMXRDVkPRFqBlmq+WNigLhVv57XJW
         T+B1HzMpz2RR6SfXbtX0NXUmw4607CI2Ico04kvxYislxqYFzH1EaBEYZoeGor4f4BB3
         A0lw==
X-Gm-Message-State: AOAM531Np9zO9ouJwZVmbqGKdwU/GjXKAAYPYPbCVaqddItw3woQxqli
        hMKqwJvx56u3mQ2FPNZeno7XLfPdylyIEi5j
X-Google-Smtp-Source: ABdhPJyvqWQfElTfhNpGl52X9brC3xHRAkGJFbqoogHuMrPEuM7oNNSts55e7QFcLSCuD+1HDh7ZrQ==
X-Received: by 2002:a5d:54cf:: with SMTP id x15mr4840571wrv.27.1631781853845;
        Thu, 16 Sep 2021 01:44:13 -0700 (PDT)
Received: from apalos.home (ppp-94-66-220-137.home.otenet.gr. [94.66.220.137])
        by smtp.gmail.com with ESMTPSA id j20sm2647897wrb.5.2021.09.16.01.44.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Sep 2021 01:44:13 -0700 (PDT)
Date:   Thu, 16 Sep 2021 11:44:10 +0300
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     Jesper Dangaard Brouer <jbrouer@redhat.com>, brouer@redhat.com,
        Alexander Duyck <alexander.duyck@gmail.com>,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxarm@openeuler.org,
        hawk@kernel.org, jonathan.lemon@gmail.com, alobakin@pm.me,
        willemb@google.com, cong.wang@bytedance.com, pabeni@redhat.com,
        haokexin@gmail.com, nogikh@google.com, elver@google.com,
        memxor@gmail.com, edumazet@google.com, dsahern@gmail.com
Subject: Re: [Linuxarm] Re: [PATCH net-next v2 3/3] skbuff: keep track of pp
 page when __skb_frag_ref() is called
Message-ID: <YUMD2v7ffs1xAjaW@apalos.home>
References: <20210914121114.28559-1-linyunsheng@huawei.com>
 <20210914121114.28559-4-linyunsheng@huawei.com>
 <CAKgT0Ud7NXpHghiPeGzRg=83jYAP1Dx75z3ZE0qV8mT0zNMDhA@mail.gmail.com>
 <9467ec14-af34-bba4-1ece-6f5ea199ec97@huawei.com>
 <YUHtf+lI8ktBdjsQ@apalos.home>
 <0337e2f6-5428-2c75-71a5-6db31c60650a@redhat.com>
 <fef7d148-95d6-4893-8924-1071ed43ff1b@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fef7d148-95d6-4893-8924-1071ed43ff1b@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> >> appear if we try to pull in your patches on using page pool and recycling

[...]

> >> for Tx where TSO and skb_split are used?
> 
> As my understanding, the problem might exists without tx recycling, because a
> skb from wire would be passed down to the tcp stack and retransmited back to
> the wire theoretically. As I am not able to setup a configuration to verify
> and test it and the handling seems tricky, so I am targetting net-next branch
> instead of net branch.
> 
> >>
> >> I'll be honest, when I came up with the recycling idea for page pool, I
> >> never intended to support Tx.  I agree with Alexander here,  If people want
> >> to use it on Tx and think there's value,  we might need to go back to the
> >> drawing board and see what I've missed.  It's still early and there's a
> >> handful of drivers using it,  so it will less painful now.
> 
> Yes, we also need to prototype it to see if there is something missing in the
> drawing board and how much improvement we get from that:)
> 
> > 
> > I agree, page_pool is NOT designed or intended for TX support.
> > E.g. it doesn't make sense to allocate a page_pool instance per socket, as the backing memory structures for page_pool are too much.
> > As the number RX-queues are more limited it was deemed okay that we use page_pool per RX-queue, which sacrifice some memory to gain speed.
> 
> As memtioned before, Tx recycling is based on page_pool instance per socket.
> it shares the page_pool instance with rx.
> 
> Anyway, based on feedback from edumazet and dsahern, I am still trying to
> see if the page pool is meaningful for tx.
> 
> > 
> > 
> >> The pp_recycle_bit was introduced to make the checking faster, instead of
> >> getting stuff into cache and check the page signature.  If that ends up
> >> being counterproductive, we could just replace the entire logic with the
> >> frag count and the page signature, couldn't we?  In that case we should be
> >> very cautious and measure potential regression on the standard path.
> > 
> > +1
> 
> I am not sure "pp_recycle_bit was introduced to make the checking faster" is a
> valid. The size of "struct page" is only about 9 words(36/72 bytes), which is
> mostly to be in the same cache line, and both standard path and recycle path have
> been touching the "struct page", so it seems the overhead for checking signature
> seems minimal.
> 
> I agree that we need to be cautious and measure potential regression on the
> standard path.

well pp_recycle is on the same cache line boundary with the head_frag we
need to decide on recycling. After that we start checking page signatures
etc,  which means the default release path remains mostly unaffected.  

I guess what you are saying here, is that 'struct page' is going to be
accessed eventually by the default network path,  so there won't be any 
noticeable performance hit?  What about the other usecases we have
for pp_recycle right now?  __skb_frag_unref() in skb_shift() or
skb_try_coalesce() (the latter can probably be removed tbh).

> 
> Another way is to use the bit 0 of frag->bv_page ptr to indicate if a frag
> page is from page pool.

Instead of the 'struct page' signature?  And the pp_recycle bit will
continue to exist?  

Right now the 'naive' explanation on the recycling decision is something like:

if (pp_recycle) <--- recycling bit is set
    (check page signature) <--- signature matches page pool
		(check fragment refcnt) <--- If frags are enabled and is the last consumer
			recycle

If we can proove the performance is unaffected when we eliminate the first if,
then obviously we should remove it.  I'll try running that test here and see,
but keep in mind I am only testing on an 1GB interface.  Any chance we can get 
measurements on a beefier hardware using hns3 ?

> 
> > 
> >> But in general,  I'd be happier if we only had a simple logic in our
> >> testing for the pages we have to recycle.  Debugging and understanding this
> >> otherwise will end up being a mess.
> > 
> > 

[...]

Regards
/Ilias
