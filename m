Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E707867F954
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 16:58:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234389AbjA1P64 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 10:58:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233841AbjA1P6x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 10:58:53 -0500
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52C5A2B083
        for <netdev@vger.kernel.org>; Sat, 28 Jan 2023 07:58:42 -0800 (PST)
Received: by mail-qt1-x834.google.com with SMTP id m26so6554535qtp.9
        for <netdev@vger.kernel.org>; Sat, 28 Jan 2023 07:58:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ErAXPT9hufdeE1C07BpAgXljI6JPcNPJU83T2aHDJeM=;
        b=M55C7/lBjSLgEPGbsuqwWd9hCIrwtmwOSosBlpEwrpKF0Z8OeJpgeb6JV/SysNFjqS
         uSMZYxAoaFIeyUiJvYLeY4pb+QzlRa202cu2HR7nyI6gl0ut6/l6nPcWnwbOglTaTmKZ
         ZqoXJWL2lGiKYHmodAyehl5X+2hxNQgEbwGbBfuZaW7cVXfuMx26hW9LMURVLUh3/qgA
         dmBKeY0SDGeYnjOI84zwr5SHY88mob9R/Xflhp071HDsdes/3JpJAMEfX8WT1NUAO4AW
         +qgdlhPlMRNqOJ1mE3EiXB6BWOCkv0ir/AbGJNFK2E8WakwpKC9fl8q9K37LyH6bSDYF
         ly3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ErAXPT9hufdeE1C07BpAgXljI6JPcNPJU83T2aHDJeM=;
        b=Cjx5/REmTaC6dxWyxpwuvBQpprsm793ItbRK3R0MISs8MZeLiZBN+nay5BVk6YuWQn
         71TWytOJqLHEGh/QkegbJz7NtXgffcDSARZX+aXs9qwtewhS4F92iILCxCJ+MGww+q7z
         /G/rxItqQjbtt6TFCb1Sz5YHmf8ZwYzyFTnwB5u1HlAjlVRug+Erowutp6P6NS8Q0Wim
         WfyD5iANkJIe3oOq0P/gE2MJLvMg0I935K2zb1dzs1HtQgv6vwbw6s/TxHcfl9JuGZct
         UCbc3ISDcZT40SZNQ4vbTLEzPsmUWKnlMGbJO5NyV05dXk75LqB7coFcVqYlWlNtjNqz
         UPhQ==
X-Gm-Message-State: AO0yUKUE0I+gGjPykWU4hzkpZjw0dyPPycZAe0jydMVRWLVDWpQYK4wv
        j1sluh4QTF++/WVehem5N5bxovC21/VzVQ==
X-Google-Smtp-Source: AK7set+Q+6VqbNirICaNhEvJO3EeP8ZhWkPvepT8y5OzeqKTuZnvHrbf1Qcbu7zN1vhae/I1BbX3BQ==
X-Received: by 2002:ac8:5e0d:0:b0:3b6:4731:1d0b with SMTP id h13-20020ac85e0d000000b003b647311d0bmr4972434qtx.16.1674921521054;
        Sat, 28 Jan 2023 07:58:41 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id i7-20020a05620a0a0700b006fbbdc6c68fsm4955174qka.68.2023.01.28.07.58.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Jan 2023 07:58:40 -0800 (PST)
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
Subject: [PATCHv4 net-next 00/10] net: support ipv4 big tcp
Date:   Sat, 28 Jan 2023 10:58:29 -0500
Message-Id: <cover.1674921359.git.lucien.xin@gmail.com>
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
2-7, Patch 8 adds a GSO_TCP tp_status for af_packet users, and Patch 9
add new netlink attributes to make IPv4 BIG TCP independent from IPv6
BIG TCP on configuration, and Patch 10 implements this feature.

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
ip link set dev ens1f0np0 gro_ipv4_max_size 128000 gso_ipv4_max_size 128000
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
  - remove the fixes and the selftest for IPv6 BIG TCP, will do it in
    another patchset.
  - add GSO_TCP for tp_status in packet sockets to tell the af_packet
    users that this is a TCP GSO packet in Patch 8.
  - also check skb_is_gso() when checking if it's a GSO TCP packet in
    Patch 1.
v2->v3:
  - add gso/gro_ipv4_max_size per device and netlink attributes for them
    in Patch 9, so that we can selectively enable BIG TCP for IPv6, and
    not for IPv4, as Eric required.
  - remove the selftest, as it requires userspace iproute2 change after
    making IPv4 BIG TCP independent from IPv6 BIG TCP on configuration.
v3->v4:
  - put gso/gro_ipv4_max_size close to other related fields, so that we
    do not need an extra cache line miss, as Eric suggested.
  - also check ipv6_addr_v4mapped() when reading gso(_ipv4)_max_size in
    sk_setup_caps(), as Eric noticed.

Xin Long (10):
  net: add a couple of helpers for iph tot_len
  bridge: use skb_ip_totlen in br netfilter
  openvswitch: use skb_ip_totlen in conntrack
  net: sched: use skb_ip_totlen and iph_totlen
  netfilter: use skb_ip_totlen and iph_totlen
  cipso_ipv4: use iph_set_totlen in skbuff_setattr
  ipvlan: use skb_ip_totlen in ipvlan_get_L3_hdr
  packet: add TP_STATUS_GSO_TCP for tp_status
  net: add gso_ipv4_max_size and gro_ipv4_max_size per device
  net: add support for ipv4 big tcp

 drivers/net/ipvlan/ipvlan_core.c           |  2 +-
 include/linux/ip.h                         | 21 ++++++++++++++
 include/linux/netdevice.h                  |  6 ++++
 include/net/netfilter/nf_tables_ipv4.h     |  4 +--
 include/net/route.h                        |  3 --
 include/uapi/linux/if_link.h               |  3 ++
 include/uapi/linux/if_packet.h             |  1 +
 net/bridge/br_netfilter_hooks.c            |  2 +-
 net/bridge/netfilter/nf_conntrack_bridge.c |  4 +--
 net/core/dev.c                             |  4 +++
 net/core/dev.h                             | 18 ++++++++++++
 net/core/gro.c                             | 12 ++++----
 net/core/rtnetlink.c                       | 33 ++++++++++++++++++++++
 net/core/sock.c                            | 26 +++++++++--------
 net/ipv4/af_inet.c                         |  7 +++--
 net/ipv4/cipso_ipv4.c                      |  2 +-
 net/ipv4/ip_input.c                        |  2 +-
 net/ipv4/ip_output.c                       |  2 +-
 net/netfilter/ipvs/ip_vs_xmit.c            |  2 +-
 net/netfilter/nf_log_syslog.c              |  2 +-
 net/netfilter/xt_length.c                  |  2 +-
 net/openvswitch/conntrack.c                |  2 +-
 net/packet/af_packet.c                     |  4 +++
 net/sched/act_ct.c                         |  2 +-
 net/sched/sch_cake.c                       |  2 +-
 25 files changed, 130 insertions(+), 38 deletions(-)

-- 
2.31.1

