Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECEAB37FBE9
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 18:59:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbhEMRAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 13:00:21 -0400
Received: from mail-ed1-f48.google.com ([209.85.208.48]:40538 "EHLO
        mail-ed1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbhEMRAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 13:00:19 -0400
Received: by mail-ed1-f48.google.com with SMTP id c22so31733471edn.7;
        Thu, 13 May 2021 09:59:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SuYo0v4Sspk+YrS82KRsmWvE9J4qLdnDJDZ/tX57c60=;
        b=ecnwKAVIbbraP0IO97BXrIeROzHiFIyfFjQpuUIND3uocS8OJV8aqGsokPZIXX1nnb
         dDFbPQp5qVSEQy1bVdPyw3TxBTxfXslSbD+d5UG+16K5+saySpteEoICCbkzOFo2b0Xf
         H4AxlDpOKsKm+mVhpA1bYBfFHc7OKzVsNkyp7uoM7y3RYbJUcahrPBuJj/TmkRFkjU4J
         KUuaCliQxE7MCIQF4eKDDj09CGnlO2mdSeKMp6FApAWWSoSePjCT7H7s5TcxppykMrzj
         UvLFGhBQsQTm0WxFEN4Psj171MEpAq7M76Ws8vU7Auu4e8PMwWCFAfd+f1piiw6Ufr3S
         8eGQ==
X-Gm-Message-State: AOAM5302FfRGmOAbTPtjL8laKmeaNT7tV2UYiFDKT+kJq7M09u4tPhuI
        7v1ea64+lZPqYnrz04iMrGbqBiR6PeuKNcCL
X-Google-Smtp-Source: ABdhPJxDK3pB3PY/rvI4wpNPRfdEYs654cpLUafAO8s3rWQ+yENAmMzQGxTHm01qJ30+vbCBmmirnQ==
X-Received: by 2002:a05:6402:284:: with SMTP id l4mr52310910edv.299.1620925146948;
        Thu, 13 May 2021 09:59:06 -0700 (PDT)
Received: from msft-t490s.teknoraver.net (net-5-94-253-60.cust.vodafonedsl.it. [5.94.253.60])
        by smtp.gmail.com with ESMTPSA id w11sm2959431ede.54.2021.05.13.09.59.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 May 2021 09:59:06 -0700 (PDT)
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
Subject: [PATCH net-next v5 0/5] page_pool: recycle buffers
Date:   Thu, 13 May 2021 18:58:41 +0200
Message-Id: <20210513165846.23722-1-mcroce@linux.microsoft.com>
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
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 17 +++++-----
 drivers/net/ethernet/marvell/sky2.c           |  2 +-
 drivers/net/ethernet/mellanox/mlx4/en_rx.c    |  2 +-
 include/linux/mm.h                            | 12 ++++---
 include/linux/mm_types.h                      | 12 +++++++
 include/linux/skbuff.h                        | 34 ++++++++++++++++---
 include/net/page_pool.h                       | 11 ++++++
 net/core/page_pool.c                          | 27 +++++++++++++++
 net/core/skbuff.c                             | 25 +++++++++++---
 net/tls/tls_device.c                          |  2 +-
 11 files changed, 126 insertions(+), 29 deletions(-)

-- 
2.31.1

