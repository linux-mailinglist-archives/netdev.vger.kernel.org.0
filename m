Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ADE33653BE
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 10:10:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbhDTILF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 04:11:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbhDTILE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 04:11:04 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72B61C06138A
        for <netdev@vger.kernel.org>; Tue, 20 Apr 2021 01:10:33 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id n2so56878683ejy.7
        for <netdev@vger.kernel.org>; Tue, 20 Apr 2021 01:10:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FG5E8uWGSrCvajWCjQUTriiKHPgt6q+O5wn0TlE95pQ=;
        b=zCCqheyR986/BDJiX2v51ephpReLZP0aCw2199pReb60w50j/aQo+xHHfXXUBXXydW
         1iPjmITiaWa8banzSpUECuDdbVOiI4NKC9wnSLuBbE/YC5846UJY1XwLTipBgGV/fZlh
         aeu7T47FtiIPMNezvjA8OW4GOsvVFAnqOuyar1inVAZrF4tNsRDporJAlldNike4y7TC
         ly3OBtz7A1LspIgPb3Egr4a3gGJ9ZTu+aBMUhkcr20HtAmV66EIp8V9kIURR3gtLEGMV
         /7R5yQCiCUDpNn62ZghQyGjtFrsbOBqiirdidAeJx9UGX/bJtpyuOWB6GZnHLQfoMoL+
         y10Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FG5E8uWGSrCvajWCjQUTriiKHPgt6q+O5wn0TlE95pQ=;
        b=Z/5y07RAXAVYJDZbm7nFgfoeqSQW1WskYM3Lm2tx82nWdFnzHaVN5Dlog/YP7F6Bme
         1gizlDOftygp2sjHZtcbzPo/CgFuHY9WVFXxpHjYS8k90E6Lc90rIQ69ZxP00pF4IXzQ
         U+PoZ2but6CZCDYLzpK3/RiBAKAkSN+G4u1aOvlzDNPOVEerRbJB0c0mGIfeE2YlKMHi
         hKwzLb3oKYiQsD31qkbfrIy9+fUVMmbZg5R+4k8MHMj/q6Wu0YnGgUtUZpD3nebT1AQL
         rcTLyrhG02B810MrXuuFyDoTR3UYOFyNKm2YVU42riS8jgPEASoRTXQOu4g24fswO02Y
         fYMw==
X-Gm-Message-State: AOAM531Tkx/IoJUUVsd7ihzTCtl8uaMrR1eUBQh43PMsFZGlEvXwxVkx
        KJzTzMPSef+PFGK6XsECEvqw+g==
X-Google-Smtp-Source: ABdhPJzlY+PZZYIcEGbGdwXLxztX7H+aBXujACcm1iNj1AFfW9eP/eWpWxhk451ND+trCv13A9EbkQ==
X-Received: by 2002:a17:906:c34d:: with SMTP id ci13mr25303488ejb.430.1618906231985;
        Tue, 20 Apr 2021 01:10:31 -0700 (PDT)
Received: from apalos.home (ppp-94-65-92-88.home.otenet.gr. [94.65.92.88])
        by smtp.gmail.com with ESMTPSA id yr16sm11854378ejb.63.2021.04.20.01.10.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Apr 2021 01:10:31 -0700 (PDT)
Date:   Tue, 20 Apr 2021 11:10:26 +0300
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Shakeel Butt <shakeelb@google.com>,
        Matteo Croce <mcroce@linux.microsoft.com>,
        netdev <netdev@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        Ayush Sawal <ayush.sawal@chelsio.com>,
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
        Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Cong Wang <cong.wang@bytedance.com>, wenxu <wenxu@ucloud.cn>,
        Kevin Hao <haokexin@gmail.com>,
        Aleksandr Nogikh <nogikh@google.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Marco Elver <elver@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Yunsheng Lin <linyunsheng@huawei.com>,
        Guillaume Nault <gnault@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-rdma@vger.kernel.org,
        bpf <bpf@vger.kernel.org>, Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>, Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next v3 2/5] mm: add a signature in struct page
Message-ID: <YH6MchNQPgFjfuQ+@apalos.home>
References: <20210409223801.104657-1-mcroce@linux.microsoft.com>
 <20210409223801.104657-3-mcroce@linux.microsoft.com>
 <20210410154824.GZ2531743@casper.infradead.org>
 <YHHPbQm2pn2ysth0@enceladus>
 <CALvZod7UUxTavexGCzbKaK41LAW7mkfQrnDhFbjo-KvH9P6KsQ@mail.gmail.com>
 <YHHuE7g73mZNrMV4@enceladus>
 <20210414214132.74f721dd@carbon>
 <CALvZod4F8kCQQcK5_3YH=7keqkgY-97g+_OLoDCN7uNJdd61xA@mail.gmail.com>
 <20210419132204.1e07d5b9@carbon>
 <20210419130148.GA2531743@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210419130148.GA2531743@casper.infradead.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Matthew,

[...]
> 
> And the contents of this page already came from that device ... if it
> wanted to write bad data, it could already have done so.
> 
> > > > (3) The page_pool is optimized for refcnt==1 case, and AFAIK TCP-RX
> > > > zerocopy will bump the refcnt, which means the page_pool will not
> > > > recycle the page when it see the elevated refcnt (it will instead
> > > > release its DMA-mapping).  
> > > 
> > > Yes this is right but the userspace might have already consumed and
> > > unmapped the page before the driver considers to recycle the page.
> > 
> > That is a good point.  So, there is a race window where it is possible
> > to gain recycling.
> > 
> > It seems my page_pool co-maintainer Ilias is interested in taking up the
> > challenge to get this working with TCP RX zerocopy.  So, lets see how
> > this is doable.
> 
> You could also check page_ref_count() - page_mapcount() instead of
> just checking page_ref_count().  Assuming mapping/unmapping can't
> race with recycling?
> 

That's not a bad idea.  As I explained on my last reply to Shakeel, I don't
think the current patch will blow up anywhere.  If the page is unmapped prior
to kfree_skb() it will be recycled.  If it's done in a reverse order, we'll
just free the page entirely and will have to re-allocate it.
The only thing I need to test is potential races (assuming those can even
happen?).

Trying to recycle the page outside of kfree_skb() means we'd have to 'steal'
the page, during put_page() (or some function that's outside the networking
scope).  I think this is going to have a measurable performance penalty though
not in networking, but in general.

In any case, that should be orthogonal to the current patchset.  So unless
someone feels strongly about it, I'd prefer keeping the current code and
trying to enable recycling in the skb zc case, when we have enough users of
the API.


Thanks
/Ilias
