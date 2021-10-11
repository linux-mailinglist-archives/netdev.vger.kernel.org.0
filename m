Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2645428D03
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 14:30:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236597AbhJKMcE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 08:32:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236584AbhJKMcE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Oct 2021 08:32:04 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08588C061570
        for <netdev@vger.kernel.org>; Mon, 11 Oct 2021 05:30:04 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id g10so66401494edj.1
        for <netdev@vger.kernel.org>; Mon, 11 Oct 2021 05:30:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8R0yE/cxVHvwquZPbOltOEz0D9tBHQM+oAeyj/5Oe7w=;
        b=FXzOL5LCnisbrGuuwRWxxVgnOol92yY0RKTJyFSRNA1ojvkI4GQAWxO2KF+j+QRKsu
         u98Cb8IdU1MYdndfLNE1l03Rfo6rOjDQIhFBnZx4aWXvlrMf2Uv8gUk2ke5rqKeVxs3S
         YGtwOiVjbdzn4KlA/LfgSIA46/QELQHyML6B4VkL+h8zgu3VSCJio80xD755bgcHYYaz
         kEe6szTyd9eV//ngArOWp3CjAmjZZSC8TWLqdlsUD4nbcWS4g+bRCBit27oO6cU7653k
         GHdivWTSzwu+vG11755m46kgU3w6yjkSTmOb4etRTsbdTNZoZwVaFHueYGPfTOhMQghO
         tv8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8R0yE/cxVHvwquZPbOltOEz0D9tBHQM+oAeyj/5Oe7w=;
        b=B1ueeAQHrILTYHQlmLWi7ZL+R4qvTpHLA26Otj+iE41of2SSkXp0wvPmNa+2ee+2Ms
         IvY1EMbUx4GoDAfU3NF5Jqj0/3maBfGH7hI8ctLj+tqd3C7MBMqJPOlBEenVmnYeSb7R
         WOPMmXSco9GaZBK84HTT01TvMQVc5oLwuZxaaLDgy67wHrezPHplqj4jKuMCHRCRsAQM
         2/a0T8HldfZGO+rn3C5VNkyuSWC/YetH94YGp2gHIheCj8lOEmM1jHrZl/0mh1jcmdm3
         EV8B110uZ+lfZVMaoQwKaivL8E8E4v6V0DrggX7St8eYGSTlvNTwzmbZFieFXzEi1cLt
         F6og==
X-Gm-Message-State: AOAM532HvL9OTNPDap152yQiavoEdkaNALCdYjF8EXyqrzhP1bElOqr0
        MUlo8FQovncZrBBpsFSRvzYmDg==
X-Google-Smtp-Source: ABdhPJxbSB+nDpde8OFxNgOlGrt5t5L/HD+mZszO/+/8GWvGG8Zhv5Z+6xVUSEKeSarJ6WKBDu/DOw==
X-Received: by 2002:a50:bf05:: with SMTP id f5mr40394285edk.156.1633955402530;
        Mon, 11 Oct 2021 05:30:02 -0700 (PDT)
Received: from apalos.home (ppp-94-66-220-73.home.otenet.gr. [94.66.220.73])
        by smtp.gmail.com with ESMTPSA id f26sm4159873edr.8.2021.10.11.05.30.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Oct 2021 05:30:02 -0700 (PDT)
Date:   Mon, 11 Oct 2021 15:29:58 +0300
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     John Hubbard <jhubbard@nvidia.com>,
        Yunsheng Lin <linyunsheng@huawei.com>, davem@davemloft.net,
        kuba@kernel.org, brouer@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxarm@openeuler.org,
        akpm@linux-foundation.org, hawk@kernel.org, peterz@infradead.org,
        yuzhao@google.com, will@kernel.org, willy@infradead.org,
        jgg@ziepe.ca, mcroce@microsoft.com, willemb@google.com,
        cong.wang@bytedance.com, pabeni@redhat.com, haokexin@gmail.com,
        nogikh@google.com, elver@google.com, memxor@gmail.com,
        vvs@virtuozzo.com, linux-mm@kvack.org, edumazet@google.com,
        alexander.duyck@gmail.com, dsahern@gmail.com
Subject: Re: [PATCH net-next -v5 3/4] mm: introduce __get_page() and
 __put_page()
Message-ID: <YWQuRpdJOMyJBBrs@apalos.home>
References: <20211009093724.10539-1-linyunsheng@huawei.com>
 <20211009093724.10539-4-linyunsheng@huawei.com>
 <62106771-7d2a-3897-c318-79578360a88a@nvidia.com>
 <89bcc42a-ad95-e729-0748-bf394bf770be@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <89bcc42a-ad95-e729-0748-bf394bf770be@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 11, 2021 at 02:25:08PM +0200, Jesper Dangaard Brouer wrote:
> 
> 
> On 09/10/2021 21.49, John Hubbard wrote:
> > So in case it's not clear, I'd like to request that you drop this one
> > patch from your series.
> 
> In my opinion as page_pool maintainer, you should also drop patch 4/4 from
> this series.
> 
> I like the first two patches, and they should be resend and can be applied
> without too much further discussion.

+1
That's what I hinted on the previous version. The patches right now go way
beyond the spec of page pool.  We are starting to change core networking
functions and imho we need a lot more people involved in this discussion,
than the ones participating already.

As a general note and the reason I am so hesitant,  is that we are starting
to violate layers here (at least in my opinion).  When the recycling was
added,  my main concern was to keep the network stack unaware (apart from
the skb bit).  Now suddenly we need to teach frag_ref/unref internal page
pool counters and that doesn't feel right.  We first need to prove the race
can actually happen, before starting to change things.

Regards
/Ilias
> 
> --Jesper
> 
