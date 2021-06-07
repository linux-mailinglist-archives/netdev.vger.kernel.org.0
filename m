Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAD4B39E70E
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 21:02:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231450AbhFGTEr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 15:04:47 -0400
Received: from mail-wr1-f46.google.com ([209.85.221.46]:42507 "EHLO
        mail-wr1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230382AbhFGTEq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 15:04:46 -0400
Received: by mail-wr1-f46.google.com with SMTP id c5so18771220wrq.9;
        Mon, 07 Jun 2021 12:02:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7elu8SUjvz3NpIAnZdhLmPIZAY5gqwX0oUC25j6zt6o=;
        b=NGEOgcJK2cd1Lwz6YBd/8mW3WZ/AS9Rx62dYiSVwwrHb+IU0BREZ+Rxbz2rN3a1k0I
         1NdYheo/+Bzpha/eVf9w6PQnX4QKXjKK4rqaBYxGgaVGk0Wlm17Hs3aweoCewcHkSXKD
         siwDJ8fWIqenPfUhCqpvfWUgV15la6vDbsuX2I5fVry34ss0xmUg1l9tfQ0oN+ch3WSR
         Y9ZEROFydcNG6TPc/JpmSDJ3f8HmGm8kB3AR3khqlqVp03JO6mE+0pZ8yRVt8AtJ6o7s
         nSfs4zHxR+bbLRXwBiqbF5H4m1SUa1B6skGKjbcZhDo5Q10hMsh1J4av5XsomkkF6+/d
         2c8w==
X-Gm-Message-State: AOAM531WyATIl1PE/Ou1ABmN3sxFb33rlm2vbiPPW0ZyyRLZiiB1ppNF
        VIYVo2iNO9Yosa6If6lj2A/jBhpLsTVv1A==
X-Google-Smtp-Source: ABdhPJykYaizJoHqtJ077ULU/MDp6MpjeL15pGN0B69g3u0PquuiuAGZwQhbeiEBUPna9ixN7rNoYg==
X-Received: by 2002:a5d:698e:: with SMTP id g14mr18615268wru.212.1623092565167;
        Mon, 07 Jun 2021 12:02:45 -0700 (PDT)
Received: from msft-t490s.teknoraver.net (net-37-119-128-179.cust.vodafonedsl.it. [37.119.128.179])
        by smtp.gmail.com with ESMTPSA id g17sm12185968wrp.61.2021.06.07.12.02.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Jun 2021 12:02:44 -0700 (PDT)
From:   Matteo Croce <mcroce@linux.microsoft.com>
To:     netdev@vger.kernel.org, linux-mm@kvack.org
Cc:     Ayush Sawal <ayush.sawal@chelsio.com>,
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
        bpf@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
        Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>, Paolo Abeni <pabeni@redhat.com>,
        Sven Auhagen <sven.auhagen@voleatech.de>,
        Yonghong Song <yhs@fb.com>,
        Michel Lespinasse <walken@google.com>,
        KP Singh <kpsingh@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        David Hildenbrand <david@redhat.com>,
        Song Liu <songliubraving@fb.com>
Subject: [PATCH net-next v8 0/5] page_pool: recycle buffers
Date:   Mon,  7 Jun 2021 21:02:35 +0200
Message-Id: <20210607190240.36900-1-mcroce@linux.microsoft.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matteo Croce <mcroce@microsoft.com>

This is a respin of [1]

This patchset shows the plans for allowing page_pool to handle and
maintain DMA map/unmap of the pages it serves to the driver. For this
to work a return hook in the network core is introduced.

The overall purpose is to simplify drivers, by providing a page
allocation API that does recycling, such that each driver doesn't have
to reinvent its own recycling scheme. Using page_pool in a driver
does not require implementing XDP support, but it makes it trivially
easy to do so. Instead of allocating buffers specifically for SKBs
we now allocate a generic buffer and either wrap it on an SKB
(via build_skb) or create an XDP frame.
The recycling code leverages the XDP recycle APIs.

The Marvell mvpp2 and mvneta drivers are used in this patchset to
demonstrate how to use the API, and tested on a MacchiatoBIN
and EspressoBIN boards respectively.

Please let this going in on a future -rc1 so to allow enough time
to have wider tests.

v7 -> v8:
- use page->lru.next instead of page->index for pfmemalloc
- remove conditional include
- rework page_pool_return_skb_page() so to have less conversions
  between page and addresses, and call compound_head() only once
- move some code from skb_free_head() to a new helper skb_pp_recycle()
- misc fixes

v6 -> v7:
- refresh patches against net-next
- remove a redundant call to virt_to_head_page()
- update mvneta benchmarks

v5 -> v6:
- preserve pfmemalloc bit when setting signature
- fix typo in mvneta
- rebase on next-next with the new cache
- don't clear the skb->pp_recycle in pskb_expand_head()

v4 -> v5:
- move the signature so it doesn't alias with page->mapping
- use an invalid pointer as magic
- incorporate Matthew Wilcox's changes for pfmemalloc pages
- move the __skb_frag_unref() changes to a preliminary patch
- refactor some cpp directives
- only attempt recycling if skb->head_frag
- clear skb->pp_recycle in pskb_expand_head()

v3 -> v4:
- store a pointer to page_pool instead of xdp_mem_info
- drop a patch which reduces xdp_mem_info size
- do the recycling in the page_pool code instead of xdp_return
- remove some unused headers include
- remove some useless forward declaration

v2 -> v3:
- added missing SOBs
- CCed the MM people

v1 -> v2:
- fix a commit message
- avoid setting pp_recycle multiple times on mvneta
- squash two patches to avoid breaking bisect

[1] https://lore.kernel.org/netdev/154413868810.21735.572808840657728172.stgit@firesoul/

Ilias Apalodimas (1):
  page_pool: Allow drivers to hint on SKB recycling

Matteo Croce (4):
  mm: add a signature in struct page
  skbuff: add a parameter to __skb_frag_unref
  mvpp2: recycle buffers
  mvneta: recycle buffers

 drivers/net/ethernet/marvell/mvneta.c         | 11 ++++--
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   |  2 +-
 drivers/net/ethernet/marvell/sky2.c           |  2 +-
 drivers/net/ethernet/mellanox/mlx4/en_rx.c    |  2 +-
 include/linux/mm.h                            | 11 +++---
 include/linux/mm_types.h                      |  7 ++++
 include/linux/poison.h                        |  3 ++
 include/linux/skbuff.h                        | 39 ++++++++++++++++---
 include/net/page_pool.h                       |  9 +++++
 net/core/page_pool.c                          | 28 +++++++++++++
 net/core/skbuff.c                             | 20 ++++++++--
 net/tls/tls_device.c                          |  2 +-
 12 files changed, 114 insertions(+), 22 deletions(-)

-- 
2.31.1

