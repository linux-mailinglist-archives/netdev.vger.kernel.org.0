Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40E0038CABC
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 18:15:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234376AbhEUQRB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 12:17:01 -0400
Received: from mail-ed1-f53.google.com ([209.85.208.53]:36782 "EHLO
        mail-ed1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231995AbhEUQRA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 May 2021 12:17:00 -0400
Received: by mail-ed1-f53.google.com with SMTP id df21so23938395edb.3;
        Fri, 21 May 2021 09:15:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kXlRaBMJoWOhAWHALOYN55NWGuEBwklQq4V7CKcJSkA=;
        b=SfWJar+FICff2TRIXpGloL9uOmNcsBMdLJTJ3/E9eDGPn8p6za2a3HQZIEnKG7iuR5
         xzvT/EIeaNYSRVKFh48ZfXpUie9M3bnPPcN5zXboUk2HMGlwf15VJHOnL3d4FrX6ic7j
         OwfAcs8NTlBb8dqbL6ZKb5JEtwSKgQEDfZeZcKkZAKOHCGVduG4mfxLJlOGroZOuirvg
         NuYIjgY21+sI2JZJNCUuV1Yc9qiLpnEG9BqPBtIPiyPckkoDFklA9N7XYDS+C0jpybRi
         acCrjYLkRX8ScL2MGu/2Z48TETF9N4O4HUvvjnlnxWIFMKDEQhX5nEy09iRnApu6TpYT
         FR/g==
X-Gm-Message-State: AOAM531klu8qbyfDyn7C7FyRtmJHXgETabRdxtQOIqG4fbwQEJdm0DgS
        jctZ2+os88a26ueMKiegRtRKZyKv2WPsJj9m
X-Google-Smtp-Source: ABdhPJwj4cSc9QZl/beB2hgQ9AcqcPq/X5efuEiyVneN+LuPycp9x16/jNvla0FZjjMcKfQZWZYRSw==
X-Received: by 2002:aa7:cd6b:: with SMTP id ca11mr12064239edb.115.1621613735185;
        Fri, 21 May 2021 09:15:35 -0700 (PDT)
Received: from msft-t490s.teknoraver.net (net-5-94-253-60.cust.vodafonedsl.it. [5.94.253.60])
        by smtp.gmail.com with ESMTPSA id f7sm3871644ejz.95.2021.05.21.09.15.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 May 2021 09:15:34 -0700 (PDT)
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
        Sven Auhagen <sven.auhagen@voleatech.de>
Subject: [PATCH net-next v6 0/5] page_pool: recycle buffers
Date:   Fri, 21 May 2021 18:15:22 +0200
Message-Id: <20210521161527.34607-1-mcroce@linux.microsoft.com>
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

Note that this series depends on the change "mm: fix struct page layout
on 32-bit systems"[2] which is not yet in master.

v5 -> v6
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
[2] https://lore.kernel.org/linux-mm/20210510153211.1504886-1-willy@infradead.org/

Ilias Apalodimas (1):
  page_pool: Allow drivers to hint on SKB recycling

Matteo Croce (4):
  mm: add a signature in struct page
  skbuff: add a parameter to __skb_frag_unref
  mvpp2: recycle buffers
  mvneta: recycle buffers

 drivers/net/ethernet/marvell/mvneta.c         | 11 +++---
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   |  2 +-
 drivers/net/ethernet/marvell/sky2.c           |  2 +-
 drivers/net/ethernet/mellanox/mlx4/en_rx.c    |  2 +-
 include/linux/mm.h                            | 12 ++++---
 include/linux/mm_types.h                      | 12 ++++++-
 include/linux/poison.h                        |  3 ++
 include/linux/skbuff.h                        | 34 ++++++++++++++++---
 include/net/page_pool.h                       |  9 +++++
 net/core/page_pool.c                          | 29 ++++++++++++++++
 net/core/skbuff.c                             | 24 ++++++++++---
 net/tls/tls_device.c                          |  2 +-
 12 files changed, 119 insertions(+), 23 deletions(-)

-- 
2.31.1

