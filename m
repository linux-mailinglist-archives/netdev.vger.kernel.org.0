Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 930E837A802
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 15:45:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231472AbhEKNrA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 09:47:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231426AbhEKNq6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 May 2021 09:46:58 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44459C06174A;
        Tue, 11 May 2021 06:45:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=FVA5wqZqu8qiAE18h5kq9MiEIAMhp9EbfMLzX4fyri0=; b=qXaafalpgCsxtOTMTKsFr32oAl
        Ey4Pn5q26OmCtYaucXBxnIc0nTRX90wkfOgcbYJ5B9wESM8C0n7F3PTXHnwa4/4MY5QSTyVNzOt2w
        w0LE/RGFPT2Iwwi983+WJrOchbqG2Z/ZhzM+nFrlyFr/Yd475x75jCjPe0Kbh06tm93HqeyDPJ7SS
        39BS3YUqzv/AbpzCUfG8+HXbylR9cj/X15Ad3l0g9OfyanhsU7zCJw8gAxfCVgsxRaDJ1igUR85M6
        CriaKnychXfPzkvEMBUYFiJI1YXfFtIFEjJMyv/0jqIWfCze7IKMWonff8JCfJMI48b3ANGJBXgfp
        R6vqWoeA==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lgShY-007K8j-G2; Tue, 11 May 2021 13:45:33 +0000
Date:   Tue, 11 May 2021 14:45:32 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Matteo Croce <mcroce@linux.microsoft.com>
Cc:     netdev@vger.kernel.org, linux-mm@kvack.org,
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
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
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
Message-ID: <YJqKfNh6l3yY2daM@casper.infradead.org>
References: <20210511133118.15012-1-mcroce@linux.microsoft.com>
 <20210511133118.15012-2-mcroce@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210511133118.15012-2-mcroce@linux.microsoft.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 11, 2021 at 03:31:15PM +0200, Matteo Croce wrote:
> @@ -101,6 +101,7 @@ struct page {
>  			 * 32-bit architectures.
>  			 */
>  			unsigned long dma_addr[2];
> +			unsigned long signature;
>  		};
>  		struct {	/* slab, slob and slub */
>  			union {

No.  Signature now aliases with page->mapping, which is going to go
badly wrong for drivers which map this page into userspace.

I had this as:

+                       unsigned long pp_magic;
+                       unsigned long xmi;
+                       unsigned long _pp_mapping_pad;
                        unsigned long dma_addr[2];

and pp_magic needs to be set to something with bits 0&1 clear and
clearly isn't a pointer.  I went with POISON_POINTER_DELTA + 0x40.
