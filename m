Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2216B376483
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 13:32:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234181AbhEGLdD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 07:33:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbhEGLdC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 May 2021 07:33:02 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC974C061574;
        Fri,  7 May 2021 04:32:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=mqQ6WGNGTBB2lnr8xs2cVbAkboIvHY3B9yP2k6r/7BQ=; b=f6ykX4K7reSNXFrRdITQ40GQnb
        cod4J1zm4FoD1YjnZgbiW1MGn9zNJyEnP87o4aADEtb0shEux2NYiyyt0+zQzLE1lLbqJ18/LBkiW
        lUxshDjNsfU++qZ1zIKr9TmVfFoDihiaKqncnRzoJo8C1zF7uAZQTPeoGSHE+42EB3BGa3YClEZ/j
        Ff9QQIfW0UTMyLzFzNRegam3xS0JNZb5BRNHK4PRN5/HvIA5KVfBwaCmbcrNg++fq9zMZrWcdAZ17
        4gR0Kdz8PsnqLD972vomwgfAb5BBfPDMkKTucoVliyrPGMHte7pYXq46ovkfElYSvfH70c8By09Wd
        1PJpV0tg==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1leyhL-0037xM-KZ; Fri, 07 May 2021 11:31:16 +0000
Date:   Fri, 7 May 2021 12:31:11 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Yunsheng Lin <linyunsheng@huawei.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Matteo Croce <mcroce@linux.microsoft.com>,
        netdev@vger.kernel.org, linux-mm@kvack.org,
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
        Guillaume Nault <gnault@redhat.com>,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        bpf@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
        Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>, Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next v3 0/5] page_pool: recycle buffers
Message-ID: <YJUk/40MoIxwa1hr@infradead.org>
References: <e873c16e-8f49-6e70-1f56-21a69e2e37ce@huawei.com>
 <YIsAIzecktXXBlxn@apalos.home>
 <9bf7c5b3-c3cf-e669-051f-247aa8df5c5a@huawei.com>
 <YIwvI5/ygBvZG5sy@apalos.home>
 <33b02220-cc50-f6b2-c436-f4ec041d6bc4@huawei.com>
 <YJPn5t2mdZKC//dp@apalos.home>
 <75a332fa-74e4-7b7b-553e-3a1a6cb85dff@huawei.com>
 <YJTm4uhvqCy2lJH8@apalos.home>
 <bdd97ac5-f932-beec-109e-ace9cd62f661@huawei.com>
 <20210507121953.59e22aa8@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210507121953.59e22aa8@carbon>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 07, 2021 at 12:19:53PM +0200, Jesper Dangaard Brouer wrote:
> Nvidia[2] being involved which I think was unfair).  The general idea
> behind NetGPU makes sense to me,

Sorry, but that is utter bullshit.  It was rejected because it did
nothing but injecting hooks for an out of tree module while ignoring the
existing kernel infrastructure for much of what it tries to archive.
