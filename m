Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A005D39C02E
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 21:08:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230271AbhFDTKQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 15:10:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229823AbhFDTKL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Jun 2021 15:10:11 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 618FEC061766;
        Fri,  4 Jun 2021 12:08:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=qQJztOodfoxDWJWTnTGER2fqF43sT9h5HGGsfs/kKc0=; b=RUDpKiS57Vx8hvZdyqvbgHmfb7
        36Dn56mc7iMBpkAmAAlZRvrv1Zz+hlG8nKJFbgKZVi40T+Ti5TMzurbwhI6sHrcoqECTEJp9CF6Q8
        AtJgqlJT577/KqB9ihV8a4o4ez+QVZZ7CgM9WhGQMK+jym2tUweH+SywM7HeXQ1ma75t5yjUx3UPL
        bkCjtspA1tAAICy9NhLYGco8xJJE66llfOZGS7i+lRYc8pxz/AjiwkSAwxq8m3ofSmomd1MfZHgkA
        nArM1fkk0p03my+iWdXcy2/iT0Ng3PkPEmQeBr+GCcqf160zngXHXCXy/Ezn/iRKE/sWM8vpFp9z4
        jlATDaNQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lpFAl-00DVBg-Kk; Fri, 04 Jun 2021 19:08:03 +0000
Date:   Fri, 4 Jun 2021 20:07:59 +0100
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
Subject: Re: [PATCH net-next v7 1/5] mm: add a signature in struct page
Message-ID: <YLp6D7mEh85vL+pY@casper.infradead.org>
References: <20210604183349.30040-1-mcroce@linux.microsoft.com>
 <20210604183349.30040-2-mcroce@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210604183349.30040-2-mcroce@linux.microsoft.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 04, 2021 at 08:33:45PM +0200, Matteo Croce wrote:
> @@ -130,7 +137,10 @@ struct page {
>  			};
>  		};
>  		struct {	/* Tail pages of compound page */
> -			unsigned long compound_head;	/* Bit zero is set */
> +			/* Bit zero is set
> +			 * Bit one if pfmemalloc page
> +			 */
> +			unsigned long compound_head;

I would drop this hunk.  Bit 1 is not used for this purpose in tail
pages; it's used for that purpose in head and base pages.

I suppose we could do something like ...

 static inline void set_page_pfmemalloc(struct page *page)
 {
-	page->index = -1UL;
+	page->lru.next = (void *)2;
 }

if it's causing confusion.

