Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B96635A8C2
	for <lists+netdev@lfdr.de>; Sat, 10 Apr 2021 00:44:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235061AbhDIWiX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 18:38:23 -0400
Received: from mail-ej1-f52.google.com ([209.85.218.52]:44600 "EHLO
        mail-ej1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234602AbhDIWiW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 18:38:22 -0400
Received: by mail-ej1-f52.google.com with SMTP id e14so10965640ejz.11;
        Fri, 09 Apr 2021 15:38:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RQaj4GV0Jq3ffxY/eFd7Oq4i8/CAPwtBW6FzUex6oGs=;
        b=Yb6NVkMJNita1PGzV5CCuUAwzPKKoTcDsweDvWicPgK5MvjWToqprZ0FjJkHtvSlxO
         hye5PNpTW3Z1Itu3ifvn/jqOIdYRI8Tcz4SCiV2pdZJg/r4Yo5f6hfnzwrJ9LLIXv7r1
         4cpRUx0pUxP0csi0ooBNLTkNg9nTc0ZcSyKam3/H1s1dylvm1SBnctl6CPFnPb/IUWQw
         eugYp4U26rsz4/nNnfyvS109hQhhPJm7Mk2Yx1j+9IavpavYJJyfMNf3nYxuMp8bj8GK
         0RbFjHZq0QbJBH3ZPYdCmkbYGIoBAoppTt5ykg5R8hWMmG+5yB494WjgZebU1IHMzdjM
         jMSw==
X-Gm-Message-State: AOAM533W78O8hPX7mCE4TqF/SZVxlCeO+zWMnJXjENG9XDA511ajlrPy
        w35XLckbukF3c31nQS6ZqluqvukE89yfpw==
X-Google-Smtp-Source: ABdhPJx4JIcTBS5XaTVR5i9muuS54gLr6k4CxbJYfTE18J+nrM5vNX7CvYmgumecUrk1XBF+7DSXBw==
X-Received: by 2002:a17:907:33cb:: with SMTP id zk11mr1145396ejb.231.1618007887368;
        Fri, 09 Apr 2021 15:38:07 -0700 (PDT)
Received: from msft-t490s.teknoraver.net (net-93-66-21-119.cust.vodafonedsl.it. [93.66.21.119])
        by smtp.gmail.com with ESMTPSA id s20sm2108726edu.93.2021.04.09.15.38.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Apr 2021 15:38:06 -0700 (PDT)
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
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        bpf@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
        Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>, Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next v3 0/5] page_pool: recycle buffers
Date:   Sat, 10 Apr 2021 00:37:56 +0200
Message-Id: <20210409223801.104657-1-mcroce@linux.microsoft.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matteo Croce <mcroce@microsoft.com>

This is a respin of [1]

This  patchset shows the plans for allowing page_pool to handle and
maintain DMA map/unmap of the pages it serves to the driver.  For this
to work a return hook in the network core is introduced.

The overall purpose is to simplify drivers, by providing a page
allocation API that does recycling, such that each driver doesn't have
to reinvent its own recycling scheme.  Using page_pool in a driver
does not require implementing XDP support, but it makes it trivially
easy to do so.  Instead of allocating buffers specifically for SKBs
we now allocate a generic buffer and either wrap it on an SKB
(via build_skb) or create an XDP frame.
The recycling code leverages the XDP recycle APIs.

The Marvell mvpp2 and mvneta drivers are used in this patchset to
demonstrate how to use the API, and tested on a MacchiatoBIN
and EspressoBIN boards respectively.

Please let this going in on a future -rc1 so to allow enough time
to have wider tests.

[1] https://lore.kernel.org/netdev/154413868810.21735.572808840657728172.stgit@firesoul/

v2 -> v3:
- added missing SOBs
- CCed the MM people

v1 -> v2:
- fix a commit message
- avoid setting pp_recycle multiple times on mvneta
- squash two patches to avoid breaking bisect

Ilias Apalodimas (1):
  page_pool: Allow drivers to hint on SKB recycling

Jesper Dangaard Brouer (1):
  xdp: reduce size of struct xdp_mem_info

Matteo Croce (3):
  mm: add a signature in struct page
  mvpp2: recycle buffers
  mvneta: recycle buffers

 .../chelsio/inline_crypto/ch_ktls/chcr_ktls.c |  2 +-
 drivers/net/ethernet/marvell/mvneta.c         |  7 ++-
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 17 +++----
 drivers/net/ethernet/marvell/sky2.c           |  2 +-
 drivers/net/ethernet/mellanox/mlx4/en_rx.c    |  2 +-
 include/linux/mm_types.h                      |  1 +
 include/linux/skbuff.h                        | 35 ++++++++++++--
 include/net/page_pool.h                       | 15 ++++++
 include/net/xdp.h                             |  5 +-
 net/core/page_pool.c                          | 47 +++++++++++++++++++
 net/core/skbuff.c                             | 20 +++++++-
 net/core/xdp.c                                | 14 ++++--
 net/tls/tls_device.c                          |  2 +-
 13 files changed, 142 insertions(+), 27 deletions(-)

-- 
2.30.2

