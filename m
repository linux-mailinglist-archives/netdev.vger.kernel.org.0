Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D977437B9A6
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 11:50:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230230AbhELJvk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 05:51:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230240AbhELJvi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 May 2021 05:51:38 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62482C061574
        for <netdev@vger.kernel.org>; Wed, 12 May 2021 02:50:30 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id a25so2179406edr.12
        for <netdev@vger.kernel.org>; Wed, 12 May 2021 02:50:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1GGUsVMHLE+IZgAeaNUaXpWdQucmX1IJ1U87o5AWB8s=;
        b=dsXi6+0LX4t+9I7MTbwVdtOk7zzsArKhSuULaxCvj2iBGrnDe01i5L5qyCHksIqOuR
         F3x3O2sul75deZpTuwJvVwAzK/1QfZs86ltV4Owx4R91a2hQf5ySMECYMDxMyJOcnYCK
         E4Bz5qj6B2d8U4FkikUs12sVmL7ry4l8jNa7ZxLgs32nJW90DgsjE1yd7zVFFVuOU3uD
         cLNdUfVI1ZeWsVG5lngJwX8wDr4oJ6CzitK4be65XHK9dMrAwFE/IyPoFlsFbD9hcqEG
         k6TMbIA0GDSRitCYZ5rfQGxfqvGzfFE4n1DFMRP9o09pVMJiKWKQRFwIJKImH36cwFAA
         h4Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1GGUsVMHLE+IZgAeaNUaXpWdQucmX1IJ1U87o5AWB8s=;
        b=aFWhgdlOYIbsJ0UO5QGNfQHPiGhyP45JG2Z+Ro6iszsevTMHbOYPG1i1jtvuMpRN1K
         kt7XZGUUtwDjwF2l8sdIuo+gB0aIbu/4ICamNzkaq09HOsEen9UKH2+OumctmJ9yalIt
         w2MtFCFDOwZZvSNiMWjsM0jGrLZhphgvNkBZLrdT3GOHxPrAbLT3V7Eb9OJ1FU0ek7ub
         IwVCd1e6JVGCFj9ZuumPBax5S7g1FoJELoNdWFWpOigABQC5qspGdcrL8s3glrthpwnb
         pWtiieB1HQihRhIxDetqjebGF2lr5ET4ZKf30fK0Q2/x3hB75tVzhbZY3c9f3Y6MW70K
         ZOEA==
X-Gm-Message-State: AOAM530wzVK2keB+diJuHH+ZMKYrfQefFPVVNuy37DKooy3upNDdwh1K
        c8w5+lcxxh0h8yjHcSoimmz+RA==
X-Google-Smtp-Source: ABdhPJzmDSQCoBfSxpSFssN4vIeMUeoO4am9Wp3h0Kx3M7Nxh9kHKvhHuJYFuHxshsy6Fd+kEGp0lw==
X-Received: by 2002:aa7:cd83:: with SMTP id x3mr41440462edv.373.1620813029119;
        Wed, 12 May 2021 02:50:29 -0700 (PDT)
Received: from apalos.home ([94.69.77.156])
        by smtp.gmail.com with ESMTPSA id lr15sm13734709ejb.107.2021.05.12.02.50.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 May 2021 02:50:28 -0700 (PDT)
Date:   Wed, 12 May 2021 12:50:22 +0300
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Matteo Croce <mcroce@linux.microsoft.com>, netdev@vger.kernel.org,
        linux-mm@kvack.org, Ayush Sawal <ayush.sawal@chelsio.com>,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Rohit Maheshwari <rohitm@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Russell King <linux@armlinux.org.uk>,
        Mirko Lindner <mlindner@marvell.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Boris Pismenny <borisp@nvidia.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>, Yu Zhao <yuzhao@google.com>,
        Will Deacon <will@kernel.org>,
        Michel Lespinasse <walken@google.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Roman Gushchin <guro@fb.com>, Hugh Dickins <hughd@google.com>,
        Peter Xu <peterx@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Cong Wang <cong.wang@bytedance.com>, wenxu <wenxu@ucloud.cn>,
        Kevin Hao <haokexin@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Marco Elver <elver@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Yunsheng Lin <linyunsheng@huawei.com>,
        Guillaume Nault <gnault@redhat.com>,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        bpf@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
        Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>, Paolo Abeni <pabeni@redhat.com>,
        Sven Auhagen <sven.auhagen@voleatech.de>
Subject: Re: [PATCH net-next v4 2/4] page_pool: Allow drivers to hint on SKB
 recycling
Message-ID: <YJuk3o6CezbVrT+P@apalos.home>
References: <20210511133118.15012-1-mcroce@linux.microsoft.com>
 <20210511133118.15012-3-mcroce@linux.microsoft.com>
 <fa93976a-3460-0f7f-7af4-e78bfe55900a@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fa93976a-3460-0f7f-7af4-e78bfe55900a@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[...]
> > Since we added an extra argument on __skb_frag_unref() to handle
> > recycling, update the current users of the function with that.
> 
> This part could be done with a preliminary patch, only adding this
> extra boolean, this would keep the 'complex' patch smaller.

Sure 

[...]
> >  #include <linux/uaccess.h>
> >  #include <trace/events/skb.h>
> > @@ -645,6 +648,11 @@ static void skb_free_head(struct sk_buff *skb)
> >  {
> >  	unsigned char *head = skb->head;
> >  
> > +#if IS_BUILTIN(CONFIG_PAGE_POOL)
> 
> Why IS_BUILTIN() ? 

No reason, we'll replace it with an ifdef

> 
> PAGE_POOL is either y or n
> 
> IS_ENABLED() would look better, since we use IS_BUILTIN() for the cases where a module might be used.
> 
> Or simply #ifdef CONFIG_PAGE_POOL
> 
> > +	if (skb->pp_recycle && page_pool_return_skb_page(head))
> 
> This probably should be attempted only in the (skb->head_frag) case ?

I think the extra check makes sense.

> 
> Also this patch misses pskb_expand_head()

I am not sure I am following. Misses what? pskb_expand_head() will either
call skb_release_data() or skb_free_head(), which would either recycle or
unmap the buffer for us (depending on the page refcnt)

[...]

Thanks
/Ilias
