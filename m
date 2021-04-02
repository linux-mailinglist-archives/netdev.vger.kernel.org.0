Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCC0535292A
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 11:57:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234029AbhDBJ5B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Apr 2021 05:57:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbhDBJ5A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Apr 2021 05:57:00 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F39DDC0613E6
        for <netdev@vger.kernel.org>; Fri,  2 Apr 2021 02:56:58 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id w8so2477155pjf.4
        for <netdev@vger.kernel.org>; Fri, 02 Apr 2021 02:56:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XW87w4qSyfmGOHCyYDNi3sfZsu5hL8j9oGxPnvJpokw=;
        b=S/AgGnZFfiTUd6ccJlBnO3KlWW9Nm8ZfgH0qF73W0rb9tBMl+id4N/rva/tReLIOsu
         gIfUac4ybqHJc7TFIx/u4UIuhu3tqeds82Pe/6eat24X+iQAXw3HnmqStJ7zR7l3A2N3
         WW3+gSpMgV9yA8/ZTDNaazzirQC7FyLw/MfeacAfh7wDXsvFQzL55RrX+GTGo/7eZV/N
         3CIBGuX8PBjK4OHAcA3Y/zc+c0sAf1ceGYdcgP/ASfGvSL3JZMv7swWdzprHK/5/uE7K
         wFtqNb8cqMusdOnHamiicyQrcIaRZWP/DGcu2KxylVbB+VbqDHSv5M/9mkWf2f5rqRhx
         kYHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XW87w4qSyfmGOHCyYDNi3sfZsu5hL8j9oGxPnvJpokw=;
        b=gT9qO4cMMrPrzE0XCBuZC47yTBgiTFpErsfZkUTKqNqLefnfxsqnRb67Cj29OrFQpp
         MgoULOrrZn+1v2DBnWwKzpATx3SfTrHq0Jz+2qpkuTL8jUAS+uY0hGto738jf5F/o+0O
         Ay9KlzriM0NNT20A4cutjYz92+45WO6bWsUOmNumrYXJWY7pu1ErA4qzkdisaJzzE1z6
         p4td2W5k+0q5mdS6edAZKgIAKS1wr4ywN9ERVUQJZ8w7lvujYxYbsFCrSarPOezAw+fo
         y+Kqhe52lc8Wy9LP5JIpj3Q9C92LQc3VTnYh89ubFysKfIRQuZczY8q5ACfchN4RQJL2
         ybWA==
X-Gm-Message-State: AOAM530O4vUk/PplreMR4wPRP1vyletOc2o13E+kKRYbKeEeS0xBRBj0
        yVqcigxNXm8cd3hHTR9xd9A=
X-Google-Smtp-Source: ABdhPJz9qHG+w4fVqmUoIUvVTR06SWLFjQYPGjQpQZCivdnAOMGAp96YiFtJKuirUa2OM7bhZuw49w==
X-Received: by 2002:a17:902:9f85:b029:e6:f010:a57e with SMTP id g5-20020a1709029f85b02900e6f010a57emr11752621plq.61.1617357418292;
        Fri, 02 Apr 2021 02:56:58 -0700 (PDT)
Received: from yoga-910.localhost (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id d13sm8009505pgb.6.2021.04.02.02.56.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Apr 2021 02:56:57 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ruxandra.radulescu@nxp.com, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v2 0/3] dpaa2-eth: add rx copybreak support
Date:   Fri,  2 Apr 2021 12:55:29 +0300
Message-Id: <20210402095532.925929-1-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

DMA unmapping, allocating a new buffer and DMA mapping it back on the
refill path is really not that efficient. Proper buffer recycling (page
pool, flipping the page and using the other half) cannot be done for
DPAA2 since it's not a ring based controller but it rather deals with
multiple queues which all get their buffers from the same buffer pool on
Rx.

To circumvent these limitations, add support for Rx copybreak in
dpaa2-eth.

Below you can find a summary of the tests that were run to end up
with the default rx copybreak value of 512.
A bit about the setup - a LS2088A SoC, 8 x Cortex A72 @ 1.8GHz, IPfwd
zero loss test @ 20Gbit/s throughput.  I tested multiple frame sizes to
get an idea where is the break even point.

Here are 2 sets of results, (1) is the baseline and (2) is just
allocating a new skb for all frames sizes received (as if the copybreak
was even to the MTU). All numbers are in Mpps.

         64   128    256   512  640   768   896

(1)     3.23  3.23  3.24  3.21  3.1  2.76  2.71
(2)     3.95  3.88  3.79  3.62  3.3  3.02  2.65

It seems that even for 512 bytes frame sizes it's comfortably better when
allocating a new skb. After that, we see diminishing rewards or even worse.

Changes in v2:
 - properly marked dpaa2_eth_copybreak as static

Ioana Ciornei (3):
  dpaa2-eth: rename dpaa2_eth_xdp_release_buf into dpaa2_eth_recycle_buf
  dpaa2-eth: add rx copybreak support
  dpaa2-eth: export the rx copybreak value as an ethtool tunable

 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  | 66 ++++++++++++++-----
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.h  | 10 ++-
 .../ethernet/freescale/dpaa2/dpaa2-ethtool.c  | 40 +++++++++++
 3 files changed, 98 insertions(+), 18 deletions(-)

-- 
2.30.0

