Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 865E9678E27
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 03:20:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbjAXCUJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 21:20:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbjAXCUI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 21:20:08 -0500
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60833135
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 18:20:07 -0800 (PST)
Received: by mail-qt1-x836.google.com with SMTP id s4so12038517qtx.6
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 18:20:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Xei6TN9o8l/BrtAO5hO1a2WX2zXGOxL/rQ4I+1VtC58=;
        b=mR/vj2ECA26F+g+OuaocICuH3YOuyy3MmuKmeZ6eEVepoYbHXmiy3xscMjwLhp2DJW
         0cO5cnl5yW/MAvz9U0bnKyt264LebOW9sYgwjhVJi1imgBOcxWGf4tXgbYAkD/v+g1e6
         B9S3XkPu8xMmuz3ee5WGa8xDtdcUaLzOvH/STqCz/zM6e+vfjcSlPqxJ+Y6f4eOsPfFv
         F5EIa2vvVsZ1NfCGDU3Siuui9DctF1ODR2AUn4XKYCvju1NIEDZ42qDLZhOrwZU+BuHH
         YcGO5ElHR9D/NONuaYCwJm/VgazjpEGtMM+IYJs4WF4LeFVMAg0VdG21HD27iNOrpvNa
         cIZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Xei6TN9o8l/BrtAO5hO1a2WX2zXGOxL/rQ4I+1VtC58=;
        b=JaaP0aUB5lUO9sa5s6L0HyK46GDUj6pFeGp1kyzVIhwerJLj1QuY/Kj0SjjEzV+m/7
         +ra4MoxENK4jf533wxo5ml165mveg9d2kCOw+T+yrPJLTWWDH+QRmIhJL0SPEBZYesuE
         BYPkAs6LiKxHui43PnuESMV6BwzbRru8pUgaYd6IiLVBfRVLgrrObAOTjDnm1PtkIFcN
         JLvwZbpd+pfUjaR2blFDmXQe2u3t8juT2KIaXsEVYOhcUn3Om+jlUSICT4PAG0iBx3tU
         xAkC6D8uMPWKXIZRGz6gMuPkvGsKlHkNdO4THU3NC72pNCP62rxz1OTVireJ0JQoMvZv
         LKRQ==
X-Gm-Message-State: AFqh2kqEnd4Bhs+MOgghir3aEY0svzwtwqByqbBZzThaktJSlxwvJ6kg
        gbcWvjvIh8M7s0WgZlHa2BzsIdPkxJwICg==
X-Google-Smtp-Source: AMrXdXuVwg3R1LHSrnV9ofhQZl2BjxP0NiZsyPdG2qvssVgU3EWvEddi/Q10St59h6m0YtZyFb8JTg==
X-Received: by 2002:a05:622a:4f8c:b0:3b6:2d63:c852 with SMTP id ej12-20020a05622a4f8c00b003b62d63c852mr32642534qtb.47.1674526806322;
        Mon, 23 Jan 2023 18:20:06 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id f1-20020ac840c1000000b003a981f7315bsm410558qtm.44.2023.01.23.18.20.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 18:20:05 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Pravin B Shelar <pshelar@ovn.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Aaron Conole <aconole@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Mahesh Bandewar <maheshb@google.com>,
        Paul Moore <paul@paul-moore.com>,
        Guillaume Nault <gnault@redhat.com>
Subject: [PATCHv2 net-next 00/10] net: support ipv4 big tcp
Date:   Mon, 23 Jan 2023 21:19:54 -0500
Message-Id: <cover.1674526718.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is similar to the BIG TCP patchset added by Eric for IPv6:

  https://lwn.net/Articles/895398/

Different from IPv6, IPv4 tot_len is 16-bit long only, and IPv4 header
doesn't have exthdrs(options) for the BIG TCP packets' length. To make
it simple, as David and Paolo suggested, we set IPv4 tot_len to 0 to
indicate this might be a BIG TCP packet and use skb->len as the real
IPv4 total length.

This will work safely, as all BIG TCP packets are GSO/GRO packets and
processed on the same host as they were created; There is no padding
in GSO/GRO packets, and skb->len - network_offset is exactly the IPv4
packet total length; Also, before implementing the feature, all those
places that may get iph tot_len from BIG TCP packets are taken care
with some new APIs:

Patch 1 adds some APIs for iph tot_len setting and getting, which are
used in all these places where IPv4 BIG TCP packets may reach in Patch
2-8, and Patch 9 implements this feature and Patch 10 adds a selftest
for it.

Note that the similar change as in Patch 2-6 are also needed for IPv6
BIG TCP packets, and will be addressed in another patchset.

The similar performance test is done for IPv4 BIG TCP with 25Gbit NIC
and 1.5K MTU:

No BIG TCP:
for i in {1..10}; do netperf -t TCP_RR -H 192.168.100.1 -- -r80000,80000 -O MIN_LATENCY,P90_LATENCY,P99_LATENCY,THROUGHPUT|tail -1; done
168          322          337          3776.49
143          236          277          4654.67
128          258          288          4772.83
171          229          278          4645.77
175          228          243          4678.93
149          239          279          4599.86
164          234          268          4606.94
155          276          289          4235.82
180          255          268          4418.95
168          241          249          4417.82

Enable BIG TCP:
ip link set dev ens1f0np0 gro_max_size 128000 gso_max_size 128000
for i in {1..10}; do netperf -t TCP_RR -H 192.168.100.1 -- -r80000,80000 -O MIN_LATENCY,P90_LATENCY,P99_LATENCY,THROUGHPUT|tail -1; done
161          241          252          4821.73
174          205          217          5098.28
167          208          220          5001.43
164          228          249          4883.98
150          233          249          4914.90
180          233          244          4819.66
154          208          219          5004.92
157          209          247          4999.78
160          218          246          4842.31
174          206          217          5080.99

Thanks for the feedback from Eric and David Ahern.

v1->v2:
  - add GSO_TCP for tp_status in packet sockets to tell the af_packet
    users that this is a TCP GSO packet in Patch 8.
  - remove the fixes and the selftest for IPv6 BIG TCP, will do it in
    another patchset.
  - also check skb_is_gso() when checking if it's a GSO TCP packet in
    Patch 1.

Xin Long (10):
  net: add a couple of helpers for iph tot_len
  bridge: use skb_ip_totlen in br netfilter
  openvswitch: use skb_ip_totlen in conntrack
  net: sched: use skb_ip_totlen and iph_totlen
  netfilter: use skb_ip_totlen and iph_totlen
  cipso_ipv4: use iph_set_totlen in skbuff_setattr
  ipvlan: use skb_ip_totlen in ipvlan_get_L3_hdr
  packet: add TP_STATUS_GSO_TCP for tp_status
  net: add support for ipv4 big tcp
  selftests: add a selftest for ipv4 big tcp

 drivers/net/ipvlan/ipvlan_core.c           |   2 +-
 include/linux/ip.h                         |  21 ++++
 include/net/netfilter/nf_tables_ipv4.h     |   4 +-
 include/net/route.h                        |   3 -
 include/uapi/linux/if_packet.h             |   1 +
 net/bridge/br_netfilter_hooks.c            |   2 +-
 net/bridge/netfilter/nf_conntrack_bridge.c |   4 +-
 net/core/gro.c                             |   6 +-
 net/core/sock.c                            |  11 +-
 net/ipv4/af_inet.c                         |   7 +-
 net/ipv4/cipso_ipv4.c                      |   2 +-
 net/ipv4/ip_input.c                        |   2 +-
 net/ipv4/ip_output.c                       |   2 +-
 net/netfilter/ipvs/ip_vs_xmit.c            |   2 +-
 net/netfilter/nf_log_syslog.c              |   2 +-
 net/netfilter/xt_length.c                  |   2 +-
 net/openvswitch/conntrack.c                |   2 +-
 net/packet/af_packet.c                     |   4 +
 net/sched/act_ct.c                         |   2 +-
 net/sched/sch_cake.c                       |   2 +-
 tools/testing/selftests/net/Makefile       |   1 +
 tools/testing/selftests/net/big_tcp.sh     | 140 +++++++++++++++++++++
 22 files changed, 191 insertions(+), 33 deletions(-)
 create mode 100644 tools/testing/selftests/net/big_tcp.sh

-- 
2.31.1

