Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE0765A920
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 07:23:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726775AbfF2FXc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jun 2019 01:23:32 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:46286 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726702AbfF2FXc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jun 2019 01:23:32 -0400
Received: by mail-wr1-f67.google.com with SMTP id n4so8213385wrw.13
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 22:23:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=ThTAGEqWouuiyKXnKOfOmPwCDBqTIkK+k/TmGWaAWKU=;
        b=yPq0jqLo3c2/P7BEPr/ivRwC3o2p206dks8uL1sw75o/4wpwOp//C9NzXKvaM1WVXP
         CXstBiPgRlpWqK/jdJRrSK3k9jagSp/cxNJhwWwQeOgT63W/SY5qusyK6k+bepeL2Mp6
         NKmNlHvpNEa1aZ7bDwU20kNVhpuPQy8XKRL9TbFredO2RMCcfj451usZNCRSgZgoqhBh
         BY6fTrYJgGiwk5WO3uMpcRvWIcXbxoDGXxQxU7qh28UAVoH4USAVDokl7goteQsyjhd/
         TR2aSSjGnpYIWZasxDtNVHDG53ZnLNRjiJcoeDGpql94f+nNLGrvJE/deglk5j41UgoQ
         i/Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ThTAGEqWouuiyKXnKOfOmPwCDBqTIkK+k/TmGWaAWKU=;
        b=aY4pTdDa/FlpUoCE+TDHY7aSDfI2MX4MppbxXTScLC7ftFJ7g0B7h8ZH/8qAX3IxCq
         kufTCwPSgtarG7H65tFWPWVicHQ2HO9tvhR3WiFJREOST3N7KstoXzVYvojynibI+peg
         4ZTMm307hnS38h5km8nU7BZdBi8IMzBWRlG5ZANT55GEyiyEqYABeX1zsaJ/0UqBCW0x
         W6UUe5QNUpJt/c5vgquWjAwQbM4Oxw7hTd45y0gZaGvlpxS1TfQAFRIIeaLSMWpIQYzW
         ERF/Y+oXl/fbfJUu8dwmgrwJ+rkKN47LvZ+P7604bUDaZMCN9nVaXIKqJLcUv3aATztv
         thTA==
X-Gm-Message-State: APjAAAUZLz51VBXzZpwAg7JtjW9aFxVY4a4xlfUXG1/LibO5BmFhtuE/
        X0B6xJml9T3UC7U+8MmwGSUaaHDJVrs=
X-Google-Smtp-Source: APXvYqxShn4fRpMlyO82Sf7WsAngbcfuOL6RpWyy1jMPte/s0RYn6twAMAI2byZldL25IgY9OL3bvg==
X-Received: by 2002:a5d:540e:: with SMTP id g14mr11104908wrv.346.1561785810023;
        Fri, 28 Jun 2019 22:23:30 -0700 (PDT)
Received: from apalos.lan (athedsl-4461147.home.otenet.gr. [94.71.2.75])
        by smtp.gmail.com with ESMTPSA id g131sm2768887wmf.37.2019.06.28.22.23.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 28 Jun 2019 22:23:29 -0700 (PDT)
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     netdev@vger.kernel.org, jaswinder.singh@linaro.org
Cc:     ard.biesheuvel@linaro.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com, brouer@redhat.com, daniel@iogearbox.net,
        ast@kernel.org, makita.toshiaki@lab.ntt.co.jp,
        jakub.kicinski@netronome.com, john.fastabend@gmail.com,
        davem@davemloft.net, maciejromanfijalkowski@gmail.com,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Subject: [PATCH 0/3, net-next, v2] net: netsec: Add XDP Support
Date:   Sat, 29 Jun 2019 08:23:22 +0300
Message-Id: <1561785805-21647-1-git-send-email-ilias.apalodimas@linaro.org>
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

Changes since v1:
- Use page_pool_free correctly if xdp_rxq_info_reg() failed

Ilias Apalodimas (3):
  net: netsec: Use page_pool API
  net: page_pool: add helper function for retrieving dma direction
  net: netsec: add XDP support

 drivers/net/ethernet/socionext/Kconfig  |   1 +
 drivers/net/ethernet/socionext/netsec.c | 473 ++++++++++++++++++++----
 include/net/page_pool.h                 |   9 +
 3 files changed, 416 insertions(+), 67 deletions(-)

-- 
2.20.1

