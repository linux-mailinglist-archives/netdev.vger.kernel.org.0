Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FC273507CF
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 22:09:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236434AbhCaUJT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 16:09:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236386AbhCaUJO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 16:09:14 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F83CC061574;
        Wed, 31 Mar 2021 13:09:14 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id l18so23753790edc.9;
        Wed, 31 Mar 2021 13:09:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qpF99nbMLGQ4bgjpmq9TVZKneD9kjHG1BvrLqH3YgvE=;
        b=Inwsg8dCnVgW7ivUTNLhgXdOiNA2xx4WB8MlQvf+NHUjVXShkfH8l8s6/php+JVMBe
         QsHN8vskNVnDl60/Stp2jWDUzwS3SziKaiLO/rKU/m2jfzswCFO4OERwymxrdDawWhht
         WBoo/aOjNzykxXBfbEuWEr4i2kWCk9jWdGTIYSCNakazuosxVAR/vEqfUP7ftCu/gzC2
         cM4DYugh2R/zos8dARdJuRoDl5aajdehEuJbvu9BRhTmwNC1S97R0bNsm6kZ2SxKbf97
         iFRaehlq83TdaixObwcCY6Jv5jMYXkSMFJpsCZr639EdBkpotz7iknybSGzV7w9RMDdt
         4cgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qpF99nbMLGQ4bgjpmq9TVZKneD9kjHG1BvrLqH3YgvE=;
        b=j4zq2TH4mksjHCWnJzdSqqUbrEvvHchRBOGQWNyzsQvy4qvpFQ1LMj2fd+LQPItGwA
         pckakHfh4bvz3oFYZTFQx8m6jTN3VqCyBg9svxfioopwfKqezmK/6Jy/lkGdbXaHHZpg
         l3PWvGDEb9ZbkaQsxrxZLzhyyv61SCbdeLXEzHUC2rcB9BPdvGRu9Mt689KrLD4bBhLt
         /tB9+FVIWETZNmVwnHBdjaGvM6PMmjJLVrGEVULxVKdFNeOA0ulTcEqQq7ZQltRObpAv
         hCXPGV+u/eFSwhFw3u4Y8jNj9hyVNF40+Ge7/H6BMKX8Flh/4bzgxhu1JPmEHS0OLI17
         8yKA==
X-Gm-Message-State: AOAM532oy08WKRPhFAX0qmOACwAZifGN3f8CkjbPe0IpqGfih3wNQa5F
        HZOT1pKffMCOYDcbx9BIVs6fatlBrGw=
X-Google-Smtp-Source: ABdhPJz9FpCx8tcDvwOdforl9xwRQZUhkVr93khZM3ASQuZ8U1SnHf1OG/XzdzMD1KBKOoXWmmI99A==
X-Received: by 2002:a05:6402:51d4:: with SMTP id r20mr5924888edd.112.1617221352785;
        Wed, 31 Mar 2021 13:09:12 -0700 (PDT)
Received: from localhost.localdomain (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id r19sm1691305ejr.55.2021.03.31.13.09.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Mar 2021 13:09:12 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     Alexander Duyck <alexander.duyck@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Alex Marginean <alexandru.marginean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 0/9] XDP for NXP ENETC
Date:   Wed, 31 Mar 2021 23:08:48 +0300
Message-Id: <20210331200857.3274425-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This series adds support to the enetc driver for the basic XDP primitives.
The ENETC is a network controller found inside the NXP LS1028A SoC,
which is a dual-core Cortex A72 device for industrial networking,
with the CPUs clocked at up to 1.3 GHz. On this platform, there are 4
ENETC ports and a 6-port embedded DSA switch, in a topology that looks
like this:

  +-------------------------------------------------------------------------+
  |                    +--------+ 1 Gbps (typically disabled)               |
  | ENETC PCI          |  ENETC |--------------------------+                |
  | Root Complex       | port 3 |-----------------------+  |                |
  | Integrated         +--------+                       |  |                |
  | Endpoint                                            |  |                |
  |                    +--------+ 2.5 Gbps              |  |                |
  |                    |  ENETC |--------------+        |  |                |
  |                    | port 2 |-----------+  |        |  |                |
  |                    +--------+           |  |        |  |                |
  |                                         |  |        |  |                |
  |                        +------------------------------------------------+
  |                        |             |  Felix |  |  Felix |             |
  |                        | Switch      | port 4 |  | port 5 |             |
  |                        |             +--------+  +--------+             |
  |                        |                                                |
  | +--------+  +--------+ | +--------+  +--------+  +--------+  +--------+ |
  | |  ENETC |  |  ENETC | | |  Felix |  |  Felix |  |  Felix |  |  Felix | |
  | | port 0 |  | port 1 | | | port 0 |  | port 1 |  | port 2 |  | port 3 | |
  +-------------------------------------------------------------------------+
         |          |             |           |            |          |
         v          v             v           v            v          v
       Up to      Up to                      Up to 4x 2.5Gbps
      2.5Gbps     1Gbps

The ENETC ports 2 and 3 can act as DSA masters for the embedded switch.
Because 4 out of the 6 externally-facing ports of the SoC are switch
ports, the most interesting use case for XDP on this device is in fact
XDP_TX on the 2.5Gbps DSA master.

Nonetheless, the results presented below are for IPv4 forwarding between
ENETC port 0 (eno0) and port 1 (eno1) both configured for 1Gbps.
There are two streams of IPv4/UDP datagrams with a frame length of 64
octets delivered at 100% port load to eno0 and to eno1. eno0 has a flow
steering rule to process the traffic on RX ring 0 (CPU 0), and eno1 has
a flow steering rule towards RX ring 1 (CPU 1).

For the IPFWD test, standard IP routing was enabled in the netns.
For the XDP_DROP test, the samples/bpf/xdp1 program was attached to both
eno0 and to eno1.
For the XDP_TX test, the samples/bpf/xdp2 program was attached to both
eno0 and to eno1.
For the XDP_REDIRECT test, the samples/bpf/xdp_redirect program was
attached once to the input of eno0/output of eno1, and twice to the
input of eno1/output of eno0.

Finally, the preliminary results are as follows:

        | IPFWD | XDP_TX | XDP_REDIRECT | XDP_DROP
--------+-------+--------+-------------------------
fps     | 761   | 2535   | 1735         | 2783
Gbps    | 0.51  | 1.71   | 1.17         | n/a

There is a strange phenomenon in my testing sistem where it appears that
one CPU is processing more than the other. I have not investigated this
too much. Also, the code might not be very well optimized (for example
dma_sync_for_device is called with the full ENETC_RXB_DMA_SIZE_XDP).

Design wise, the ENETC is a PCI device with BD rings, so it uses the
MEM_TYPE_PAGE_SHARED memory model, as can typically be seen in Intel
devices. The strategy was to build upon the existing model that the
driver uses, and not change it too much. So you will see things like a
separate NAPI poll function for XDP.

I have only tested with PAGE_SIZE=4096, and since we split pages in
half, it means that MTU-sized frames are scatter/gather (the XDP
headroom + skb_shared_info only leaves us 1476 bytes of data per
buffer). This is sub-optimal, but I would rather keep it this way and
help speed up Lorenzo's series for S/G support through testing, rather
than change the enetc driver to use some other memory model like page_pool.
My code is already structured for S/G, and that works fine for XDP_DROP
and XDP_TX, just not for XDP_REDIRECT, even between two enetc ports.
So the S/G XDP_REDIRECT is stubbed out (the frames are dropped), but
obviously I would like to remove that limitation soon.

Please note that I am rather new to this kind of stuff, I am more of a
control path person, so I would appreciate feedback.

Enough talking, on to the patches.

Vladimir Oltean (9):
  net: enetc: consume the error RX buffer descriptors in a dedicated
    function
  net: enetc: move skb creation into enetc_build_skb
  net: enetc: add a dedicated is_eof bit in the TX software BD
  net: enetc: clean the TX software BD on the TX confirmation path
  net: enetc: move up enetc_reuse_page and enetc_page_reusable
  net: enetc: add support for XDP_DROP and XDP_PASS
  net: enetc: add support for XDP_TX
  net: enetc: increase RX ring default size
  net: enetc: add support for XDP_REDIRECT

 drivers/net/ethernet/freescale/enetc/enetc.c  | 826 +++++++++++++++---
 drivers/net/ethernet/freescale/enetc/enetc.h  |  53 +-
 .../ethernet/freescale/enetc/enetc_ethtool.c  |  19 +-
 .../net/ethernet/freescale/enetc/enetc_pf.c   |   2 +
 4 files changed, 796 insertions(+), 104 deletions(-)

-- 
2.25.1

