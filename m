Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1821A37A7A1
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 15:31:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231558AbhEKNct (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 09:32:49 -0400
Received: from mail-ed1-f43.google.com ([209.85.208.43]:36530 "EHLO
        mail-ed1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231305AbhEKNcq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 May 2021 09:32:46 -0400
Received: by mail-ed1-f43.google.com with SMTP id u13so22893147edd.3;
        Tue, 11 May 2021 06:31:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oIa86m56V7D9OxvaRCpHAzJ1pFfZnNHw5kUPaITumU0=;
        b=C+S3ihU08qAh15hEvssLpVKhYNfESpgjVG1huNuXKUjmOR2CrF+lxBF6lxn0hxLxWs
         EE0DURJJiSBjF6O1AIoryrV4ZXJ+1zdqVu+/p8HtI7TpFUPCzeQhZqe9BZW5sjQjPGlF
         n6QaS8V3K5sUXMExOdEUky4z/Zlcwp6duTLFfJMxcdFURLye1TFDNrgywC1D2zbcGmM0
         icwJoCt4Bqv5pYE75l40DNqE4ZvwrPKei8jAiVdJFB+QHr6d4ZTClW48KY9MD9+QbAfI
         865glb6LkUoyw463DJOHvDVjc78ZRktQ/nPcNkkhUDreOUeVS1NypL8Gq8je51nNDzo2
         BlLg==
X-Gm-Message-State: AOAM531EkmMC2DcZMiGMA6ZOyf9F8Knhf6Kltme0Hq7TTF03PDe0msWf
        yIPJ9YY1ajYa4BGabvmURXlUkFZhE05+Oy1v
X-Google-Smtp-Source: ABdhPJxdcawn9TncpLMKVjYBQqwkA4w+GCL74vYFB+ERi6r8YHQrSwr9ybTvxZ/U/SAq58/0humi3g==
X-Received: by 2002:a05:6402:2712:: with SMTP id y18mr37816019edd.41.1620739897451;
        Tue, 11 May 2021 06:31:37 -0700 (PDT)
Received: from msft-t490s.teknoraver.net (net-5-94-253-60.cust.vodafonedsl.it. [5.94.253.60])
        by smtp.gmail.com with ESMTPSA id b12sm14577136eds.23.2021.05.11.06.31.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 May 2021 06:31:36 -0700 (PDT)
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
Subject: [PATCH net-next v4 0/4] page_pool: recycle buffers
Date:   Tue, 11 May 2021 15:31:14 +0200
Message-Id: <20210511133118.15012-1-mcroce@linux.microsoft.com>
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

[1] https://lore.kernel.org/netdev/154413868810.21735.572808840657728172.stgit@firesoul/
[2] https://lore.kernel.org/linux-mm/20210510153211.1504886-1-willy@infradead.org/

Ilias Apalodimas (1):
  page_pool: Allow drivers to hint on SKB recycling

Matteo Croce (3):
  mm: add a signature in struct page
  mvpp2: recycle buffers
  mvneta: recycle buffers

 drivers/net/ethernet/marvell/mvneta.c         | 11 +++---
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 17 +++++-----
 drivers/net/ethernet/marvell/sky2.c           |  2 +-
 drivers/net/ethernet/mellanox/mlx4/en_rx.c    |  2 +-
 include/linux/mm_types.h                      |  1 +
 include/linux/skbuff.h                        | 34 ++++++++++++++++---
 include/net/page_pool.h                       | 11 ++++++
 net/core/page_pool.c                          | 27 +++++++++++++++
 net/core/skbuff.c                             | 20 +++++++++--
 net/tls/tls_device.c                          |  2 +-
 10 files changed, 105 insertions(+), 22 deletions(-)

-- 
2.31.1

