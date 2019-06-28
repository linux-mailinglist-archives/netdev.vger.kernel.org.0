Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2B7D5988B
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 12:39:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726801AbfF1Kjm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 06:39:42 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:50436 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726524AbfF1Kjk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 06:39:40 -0400
Received: by mail-wm1-f66.google.com with SMTP id c66so8619566wmf.0
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 03:39:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=fBOK3HjvGoSZm1sZ6qHEOApekzu52PJQmMnzGuJ7j8M=;
        b=rHKsdHiFkwwxxkcBGeD226Rn1Ktcx7LPLVGD9Kg6u0BkUzPm0bMObcEwS4YCa0Zq7X
         Mwt7kEdM6ip/AZKZIh9FHTle90NhdKP1KTP5hEHe3AcmpQTP2PoX5WwK8r3GpFxXA0PA
         +jAULtBaGw9O5lISBpiIMHvKsGSF8boLA3EXO6HDjAUUYenDqQZEWZKi4F2cEtwovTe9
         gR0n2BTGXsMsQ+aiXFt6DHRh0YOA2NZO4n3OZZ50bMFwRZ8v2nXRN7vmI1+CmaIokkwP
         8ZnEXiC5QBxB5s+DR7h0zaB8Fmz6ydONzTLvffziZlYScc5ryC0CEO0HejBS7AxBnZgA
         meHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=fBOK3HjvGoSZm1sZ6qHEOApekzu52PJQmMnzGuJ7j8M=;
        b=NDQFx9ME2lGXiN2Qn+4O06OqdBr33Y3j/IPPdOjjz+9qgSRpCECg8XhtHk+0tPiz+g
         ArruSdNvRx3iFUIhc63aTfBXboOayspHAcVOoRSeH4dcHBzHCQeQt8KX+pwZ1LJ/N3BG
         ARDOaLpeHRJar7TyNvdctFQ0qq3kP0vsLZHPsAi+DiTIBw3XBExA775wpKxPlKuZ4ypq
         QLiukXy8NpWiEVRkMpKIxgvSjAlrBKNdMIgkeTLLYjFG9koLXRGmVH8GVh/gDpT5RCwY
         5SYF6JJ82nfbFPXMVE1ZzH6EigCFgXo6WswWYJn8r6/dodmcalK9iuC6l3fCym+21rEr
         93Sg==
X-Gm-Message-State: APjAAAW9TBuvLywjQ/tqsmMSmWb6s7JG6+194CN5hbcEXlJ4Meb158fE
        RxUSMbixoTUbXB4VF1d5GpFUQs69LDg=
X-Google-Smtp-Source: APXvYqwwvkdg1746s9ivLxCV03ypm18s1ny80iXcKkrhLLgmhvpgImxDhfR3DKU13z9exejz4ftrQw==
X-Received: by 2002:a1c:be0a:: with SMTP id o10mr6765027wmf.91.1561718377836;
        Fri, 28 Jun 2019 03:39:37 -0700 (PDT)
Received: from apalos.lan (athedsl-4461147.home.otenet.gr. [94.71.2.75])
        by smtp.gmail.com with ESMTPSA id r5sm3397742wrg.10.2019.06.28.03.39.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 28 Jun 2019 03:39:37 -0700 (PDT)
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     netdev@vger.kernel.org, jaswinder.singh@linaro.org
Cc:     ard.biesheuvel@linaro.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com, brouer@redhat.com, daniel@iogearbox.net,
        ast@kernel.org, makita.toshiaki@lab.ntt.co.jp,
        jakub.kicinski@netronome.com, john.fastabend@gmail.com,
        davem@davemloft.net, maciejromanfijalkowski@gmail.com,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Subject: [PATCH 0/3, net-next] net: netsec: Add XDP Support
Date:   Fri, 28 Jun 2019 13:39:12 +0300
Message-Id: <1561718355-13919-1-git-send-email-ilias.apalodimas@linaro.org>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a respin of https://www.spinics.net/lists/netdev/msg526066.html
Since page_pool API fixes are merged into net-next we can now safely use 
it's DMA mapping capabilities. 

First patch changes the buffer allocation from napi/netdev_alloc_frag()
to page_pool API. Although this will lead to slightly reduced performance 
(on raw packet drops only) we can use the API for XDP buffer recycling. 
Another side effect is a slight increase in memory usage, due to using a 
single page per packet.

The second patch adds XDP support on the driver. 
There's a bunch of interesting options that come up due to the single 
Tx queue.
Locking is needed(to avoid messing up the Tx queues since ndo_xdp_xmit 
and the normal stack can co-exist). We also need to track down the 
'buffer type' for TX and properly free or recycle the packet depending 
on it's nature.


Changes since RFC:
- Bug fixes from Jesper and Maciej
- Added page pool API to retrieve the DMA direction

Ilias Apalodimas (3):
  net: netsec: Use page_pool API
  net: page_pool: add helper function for retrieving dma direction
  net: netsec: add XDP support

 drivers/net/ethernet/socionext/Kconfig  |   1 +
 drivers/net/ethernet/socionext/netsec.c | 469 ++++++++++++++++++++----
 include/net/page_pool.h                 |   9 +
 3 files changed, 412 insertions(+), 67 deletions(-)

-- 
2.20.1

