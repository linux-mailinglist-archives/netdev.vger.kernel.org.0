Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D528C37A89E
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 16:11:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231771AbhEKOM3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 10:12:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231740AbhEKOM2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 May 2021 10:12:28 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0193C061760
        for <netdev@vger.kernel.org>; Tue, 11 May 2021 07:11:20 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id b25so29941856eju.5
        for <netdev@vger.kernel.org>; Tue, 11 May 2021 07:11:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=h+QS57uiDcNTSUqHWnANazOKg81NGt/aGf/q6ieH1nA=;
        b=nBT0KcVBFdLuioxxcGs1zFZbBCuEmIA5PEK7t++BbscRfg1vcTUhh3lSqa+QW55LI7
         s7FBc50qHrBEbDhdSygfrqqf4/IwC9UhdDBTzufvA5dHY/Qkya3JV6QTnB+krBEsdXE0
         9CJ/4ylMQSbN8nUrHFXh+FlybG4pvnlxenZwPdv/79v5kJ5iopwKJJVQxrKwa21Bnqdt
         JTFKwEqHDhitRoFZqq/OnsDXPJD+Cqai3kHhcSJYo2ZgRWMNnd9TqKkb30UnIfDm6+r6
         6ERYqfNvRAll4JfCrnrPGUOBmDdO0bXGvWHPsrF8jpXkVLv81EZ4d63Y1HGf0QPxWI1x
         1/Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=h+QS57uiDcNTSUqHWnANazOKg81NGt/aGf/q6ieH1nA=;
        b=lHsLIEmyjlUBIAVfvB7TAZjxk3eGn5QuhmJAJ/afRzKXgP+G2E363ivLCblfX2rYto
         ZoEPPH6vjuyYU3JQLhY2k7wuG/eKGBBa7B6L5jMUNGZFrV470G+BPk3bqZIi7i1TwysE
         L6CTcFj4XFnLM2rihUmmNZfNg5Z2D+f0lLcFC/Tggq1bAqXXX8H8AD6EtFigaZpUN9dg
         iRrWRMQLpmIsgwNTbS5Yfb6sW/ktL0cKAKu+pG0+CdLA8rf4wPBdSgJ3qFh4rXTRG4ei
         qtcDR86et+l0Zt7u7T8MS1aOjWJjQ6sn4yB7XQUAc9SJvtuSHQWPcjpspVkHMDJxfW5B
         ewFg==
X-Gm-Message-State: AOAM532Jd2eZDLiDwR/9/4ssYlnUjqr7FLGmjqElN9O6Dxvw568RYE4B
        FdZTXcERZgctIrbqzyI6V1iHltbzzG0WOrJo
X-Google-Smtp-Source: ABdhPJyde4XpzdeyCjbJoxHs1iN8giKGPqKQdQE8vE7bc3fW9JukYGeNAo8nJr9s6SFzEog6CVswzA==
X-Received: by 2002:a17:906:594c:: with SMTP id g12mr3983010ejr.267.1620742279612;
        Tue, 11 May 2021 07:11:19 -0700 (PDT)
Received: from apalos.home ([94.69.77.156])
        by smtp.gmail.com with ESMTPSA id v12sm15108949edb.81.2021.05.11.07.11.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 May 2021 07:11:19 -0700 (PDT)
Date:   Tue, 11 May 2021 17:11:13 +0300
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Matthew Wilcox <willy@infradead.org>
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
        bpf@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>, Paolo Abeni <pabeni@redhat.com>,
        Sven Auhagen <sven.auhagen@voleatech.de>
Subject: Re: [PATCH net-next v4 1/4] mm: add a signature in struct page
Message-ID: <YJqQgYSWH2qan1GS@apalos.home>
References: <20210511133118.15012-1-mcroce@linux.microsoft.com>
 <20210511133118.15012-2-mcroce@linux.microsoft.com>
 <YJqKfNh6l3yY2daM@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YJqKfNh6l3yY2daM@casper.infradead.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Matthew,

On Tue, May 11, 2021 at 02:45:32PM +0100, Matthew Wilcox wrote:
> On Tue, May 11, 2021 at 03:31:15PM +0200, Matteo Croce wrote:
> > @@ -101,6 +101,7 @@ struct page {
> >  			 * 32-bit architectures.
> >  			 */
> >  			unsigned long dma_addr[2];
> > +			unsigned long signature;
> >  		};
> >  		struct {	/* slab, slob and slub */
> >  			union {
> 
> No.  Signature now aliases with page->mapping, which is going to go
> badly wrong for drivers which map this page into userspace.
> 
> I had this as:
> 
> +                       unsigned long pp_magic;
> +                       unsigned long xmi;
> +                       unsigned long _pp_mapping_pad;
>                         unsigned long dma_addr[2];
> 
> and pp_magic needs to be set to something with bits 0&1 clear and
> clearly isn't a pointer.  I went with POISON_POINTER_DELTA + 0x40.

Regardless to the changes required, there's another thing we'd like your
opinion on.
There was a change wrt to the previous patchset. We used to store the
struct xdp_mem_info into page->private.  On the new version we store the
page_pool ptr address in page->private (there's an explanation why on the
mail thread, but the tl;dr is that we can get some more speed and keeping
xdp_mem_info is not that crucial). So since we can just store the page_pool
address directly, should we keep using page->private or it's better to
do: 

+                       unsigned long pp_magic;
+                       unsigned long pp_ptr;
+                       unsigned long _pp_mapping_pad;
                        unsigned long dma_addr[2];
and use pp_ptr?

Thanks
/Ilias
