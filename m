Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 732EA520780
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 00:22:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231509AbiEIWZw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 18:25:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230002AbiEIWZu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 18:25:50 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA2A914E2E8
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 15:21:54 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id cq17-20020a17090af99100b001dc0386cd8fso560401pjb.5
        for <netdev@vger.kernel.org>; Mon, 09 May 2022 15:21:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mIhgu/Js/Vshq+INmmTrdmTNQfYGbaiDW2/TL2qENZ8=;
        b=gp6btGGX1cYHems/vnWDpY+23mQpjqz9b/oCLI98PckM8I4eVF8X2RjmDWhh+kAzNS
         eD6eMMuR+05mct65vPzRNvSnTtcAlL17gY5lVrQEM2IOclMfo6xRfoytR3JXq9oJNoba
         SbV+pDhozEhyvXBlLErO0BQcxi9MDe06HjpdgWC3a0KRgaEbTlNrayXaZscCKqJ4nfM2
         /904/pNtl6Zrrw2sD2y2jobDjn0g5PPz16/4+DwLQWa01TJufxcWu/MOYJZcZ4jypdWE
         PGXM/3dAGmLv3oI4c0W3jX4033BlNFU3xUMSiMZzq2A0IVBtjSwVei8t23YP0L+YG6tA
         EIqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mIhgu/Js/Vshq+INmmTrdmTNQfYGbaiDW2/TL2qENZ8=;
        b=0uHIdXQS9VJTY+tFDPIoKbEiF/tkniJI1rOmhqEIK9MWsmZcdwYdcsutPQ1/DkEMGq
         TC2PcskV152GLfI/xjVC85CbeA89BNAvco5iVlvdVbXWG8wuQU4IYewkzp01sTJlCXH1
         FYLKIlmWhKSCHPvVJpBhyCDl/MnJ2fb/0ZlNR3GMmxmbAHibS3Lm2+1C5mlmt9Cunz7Z
         qU+wSLpKv/Nd7TSYHzh4W67TsZOLMCTQ0SNO476PMuEBOWna02ya+TzfplzFj4Y7ZlbI
         ojvKR5n8V8vuM0+B5Kg/dBE66svVC+BMLtqs4XQbz7CFQ/opTf2kFu3kQ+iiaLMq84IO
         vYGQ==
X-Gm-Message-State: AOAM533U5q1ssZfELB+a3/oK6PF6yZz/dpsbY/5RFMwQ2U/Rl0h1ZPx+
        81E34DV3tl9dsTdc2CN0LTzeYwEP8v0=
X-Google-Smtp-Source: ABdhPJzb4t1L9uZtdyzMiADEy8jHXKr1FdDyLVZJWDH2EpYbOQvhabwHvlzZSxB/rQjJazqjay4uRA==
X-Received: by 2002:a17:90a:c388:b0:1d9:6336:2d7a with SMTP id h8-20020a17090ac38800b001d963362d7amr19929096pjt.244.1652134914326;
        Mon, 09 May 2022 15:21:54 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:5d30:4e79:203f:a909])
        by smtp.gmail.com with ESMTPSA id v11-20020a170902f0cb00b0015e8d4eb1efsm395823pla.57.2022.05.09.15.21.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 May 2022 15:21:53 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Coco Li <lixiaoyan@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v5 net-next 00/13] tcp: BIG TCP implementation
Date:   Mon,  9 May 2022 15:21:36 -0700
Message-Id: <20220509222149.1763877-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.0.512.ge40c2bad7a-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

This series implements BIG TCP as presented in netdev 0x15:

https://netdevconf.info/0x15/session.html?BIG-TCP

Jonathan Corbet made a nice summary: https://lwn.net/Articles/884104/

Standard TSO/GRO packet limit is 64KB

With BIG TCP, we allow bigger TSO/GRO packet sizes for IPv6 traffic.

Note that this feature is by default not enabled, because it might
break some eBPF programs assuming TCP header immediately follows IPv6 header.

While tcpdump recognizes the HBH/Jumbo header, standard pcap filters
are unable to skip over IPv6 extension headers.

Reducing number of packets traversing networking stack usually improves
performance, as shown on this experiment using a 100Gbit NIC, and 4K MTU.

'Standard' performance with current (74KB) limits.
for i in {1..10}; do ./netperf -t TCP_RR -H iroa23  -- -r80000,80000 -O MIN_LATENCY,P90_LATENCY,P99_LATENCY,THROUGHPUT|tail -1; done
77           138          183          8542.19    
79           143          178          8215.28    
70           117          164          9543.39    
80           144          176          8183.71    
78           126          155          9108.47    
80           146          184          8115.19    
71           113          165          9510.96    
74           113          164          9518.74    
79           137          178          8575.04    
73           111          171          9561.73    

Now enable BIG TCP on both hosts.

ip link set dev eth0 gro_max_size 185000 gso_max_size 185000
for i in {1..10}; do ./netperf -t TCP_RR -H iroa23  -- -r80000,80000 -O MIN_LATENCY,P90_LATENCY,P99_LATENCY,THROUGHPUT|tail -1; done
57           83           117          13871.38   
64           118          155          11432.94   
65           116          148          11507.62   
60           105          136          12645.15   
60           103          135          12760.34   
60           102          134          12832.64   
62           109          132          10877.68   
58           82           115          14052.93   
57           83           124          14212.58   
57           82           119          14196.01   

We see an increase of transactions per second, and lower latencies as well.

v5: Replaced two patches (that were adding new attributes) with patches
    from Alexander Duyck. Idea is to reuse existing gso_max_size/gro_max_size

v4: Rebased on top of Jakub series (Merge branch 'tso-gso-limit-split')
    max_tso_size is now family independent.

v3: Fixed a typo in RFC number (Alexander)
    Added Reviewed-by: tags from Tariq on mlx4/mlx5 parts.

v2: Removed the MAX_SKB_FRAGS change, this belongs to a different series.
    Addressed feedback, for Alexander and nvidia folks.




Alexander Duyck (2):
  net: allow gso_max_size to exceed 65536
  net: allow gro_max_size to exceed 65536

Coco Li (2):
  ipv6: Add hop-by-hop header to jumbograms in ip6_output
  mlx5: support BIG TCP packets

Eric Dumazet (9):
  net: add IFLA_TSO_{MAX_SIZE|SEGS} attributes
  net: limit GSO_MAX_SIZE to 524280 bytes
  tcp_cubic: make hystart_ack_delay() aware of BIG TCP
  ipv6: add struct hop_jumbo_hdr definition
  ipv6/gso: remove temporary HBH/jumbo header
  ipv6/gro: insert temporary HBH/jumbo header
  net: loopback: enable BIG TCP packets
  veth: enable BIG TCP packets
  mlx4: support BIG TCP packets

 drivers/net/ethernet/amd/xgbe/xgbe.h          |  3 +-
 .../net/ethernet/mellanox/mlx4/en_netdev.c    |  3 +
 drivers/net/ethernet/mellanox/mlx4/en_tx.c    | 47 +++++++++--
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  1 +
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en_tx.c   | 84 +++++++++++++++----
 drivers/net/ethernet/sfc/ef100_nic.c          |  3 +-
 drivers/net/ethernet/sfc/falcon/tx.c          |  3 +-
 drivers/net/ethernet/sfc/tx_common.c          |  3 +-
 drivers/net/ethernet/synopsys/dwc-xlgmac.h    |  3 +-
 drivers/net/hyperv/rndis_filter.c             |  2 +-
 drivers/net/loopback.c                        |  2 +
 drivers/net/veth.c                            |  1 +
 drivers/scsi/fcoe/fcoe.c                      |  2 +-
 include/linux/ipv6.h                          |  1 +
 include/linux/netdevice.h                     | 16 +++-
 include/net/ipv6.h                            | 44 ++++++++++
 include/uapi/linux/if_link.h                  |  2 +
 net/bpf/test_run.c                            |  2 +-
 net/core/dev.c                                |  7 +-
 net/core/gro.c                                |  8 ++
 net/core/rtnetlink.c                          | 16 ++--
 net/core/sock.c                               |  4 +
 net/ipv4/tcp_bbr.c                            |  2 +-
 net/ipv4/tcp_cubic.c                          |  4 +-
 net/ipv4/tcp_output.c                         |  2 +-
 net/ipv6/ip6_offload.c                        | 56 ++++++++++++-
 net/ipv6/ip6_output.c                         | 22 ++++-
 net/sctp/output.c                             |  3 +-
 tools/include/uapi/linux/if_link.h            |  2 +
 30 files changed, 291 insertions(+), 59 deletions(-)

-- 
2.36.0.512.ge40c2bad7a-goog

