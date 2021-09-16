Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA8EE40EB3C
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 22:02:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236230AbhIPUDc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 16:03:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234838AbhIPUD0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Sep 2021 16:03:26 -0400
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ECA5C061574
        for <netdev@vger.kernel.org>; Thu, 16 Sep 2021 13:02:05 -0700 (PDT)
Received: by mail-qk1-x72e.google.com with SMTP id t190so10216031qke.7
        for <netdev@vger.kernel.org>; Thu, 16 Sep 2021 13:02:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sipanda-io.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7ravO3YcOTvwY5nDGdxnQkjVQVgdZVli8+dRtTEX5yM=;
        b=sgChNdlEZt9iHV2tznlqy5uqLs7NkQPzDUy3LSGItrb8QuxdglypHdVPxu9z9jZpkS
         N2WdGTi2plRjOwlJ9LpTNHrgWkcS4/lQOeK85Ow8FDSVztN1hQj9PvAoRLH+xsPoCXf6
         XMQivNbrJGR04wOSd6cPrTLiO497uzZz43vFJysq+LVefxZG/Niyzatt74mvfzgThJm3
         Id17UMWVPVEfneg5AoT5DKtuTRS3ggusX9XZGJaq6DO0oUQp0CXrIq1FmrAJIvA9EkCv
         0Idx4WECV7s3/X9Frf53kh70myErY67Pr5bPaKvZNe+LMKVncapOe75nUFp2qYfinGZR
         ju+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7ravO3YcOTvwY5nDGdxnQkjVQVgdZVli8+dRtTEX5yM=;
        b=s4/lCL7xddpbxduWKZUJgnWk/65oaLHffsKbXKz2xeVZughpizuKBCURM8+I7jOshu
         ODsCrorHb/K8jCEpRf64g9bwdbwRqmDvYhLhEDcIqaltkA3RU3mBdniwv47mT3lkiKSf
         HT+u7p7lDRfz27e/8TEwZ8/oa2lg54n5k/0kW+M+hPfT5/25RchGGySSv9M5LGSzetyE
         xD6/K0lFn/V08nKpxa8m1OSd/GEV0woONzs7fkxDP2CUdk9nMdWehw/NjrhBATK+ky4t
         w6OK/PXOd4d6oZa4HcgYlMOtNtH1RcCYZjHOxVeUXue2cEV6tYWafW4fAP5SI9eudsym
         aitg==
X-Gm-Message-State: AOAM533I4tpBBd0/XscNe5xLWJ+M8KvfKgVDdDAuu8rQbKhVbb991AYp
        GLf/iO9AiQpu1XbkW14EspAixA==
X-Google-Smtp-Source: ABdhPJwgvb33/gioHnGbzA4AIGs5EE1N0KmUJEwfDatntrCtSLFa+mIZWA8+AHV495qa+9MPqU9hPQ==
X-Received: by 2002:a37:9481:: with SMTP id w123mr6917173qkd.75.1631822524509;
        Thu, 16 Sep 2021 13:02:04 -0700 (PDT)
Received: from localhost.localdomain (200.146.127.228.dynamic.adsl.gvt.net.br. [200.146.127.228])
        by smtp.googlemail.com with ESMTPSA id a24sm1307043qtp.90.2021.09.16.13.01.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Sep 2021 13:02:03 -0700 (PDT)
From:   Felipe Magno de Almeida <felipe@sipanda.io>
X-Google-Original-From: Felipe Magno de Almeida <felipe@expertise.dev>
To:     jhs@mojatatu.com, jiri@resnulli.us, xiyou.wangcong@gmail.com
Cc:     netdev@vger.kernel.org, boris.sukholitko@broadcom.com,
        vadym.kochan@plvision.eu, ilya.lifshits@broadcom.com,
        vladbu@nvidia.com, idosch@idosch.org, paulb@nvidia.com,
        dcaratti@redhat.com, marcelo.leitner@gmail.com,
        amritha.nambiar@intel.com, sridhar.samudrala@intel.com,
        tom@sipanda.io, pctammela@mojatatu.com, eric.dumazet@gmail.com,
        Felipe Magno de Almeida <felipe@sipanda.io>
Subject: [PATCH RFC net-next 0/2] net:sched: Introduce tc flower2 classifier based on PANDA parser in kernel
Date:   Thu, 16 Sep 2021 17:00:39 -0300
Message-Id: <20210916200041.810-1-felipe@expertise.dev>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Felipe Magno de Almeida <felipe@sipanda.io>

The venerable Linux flow dissector has proven to be quite useful over
the years as a way to quickly and flexibly analyze packets to extract
header metadata information for a variety of purposes.

Some history:

The grandfather of the modern day flow dissector was introduced by Tom
Herbert in 2010 to extract IP addresses and port numbers for plain TCP
and UDP packets. Eric Dumazet centralized the code in 2011 and flow
dissector was born as the first skb_flow_dissect(). In 2017, Jiri
Pirko added support to make the header metadata extraction
programmable and added support for tc flower classifier which uses
flow dissector as its parser. In 2018, Peter Penkov added a bpf hook
to allow customization of the flow dissector parsing. Over the years
various protocols have been added to the flow dissector and it has
grown to be a rather complex thousand line function.

While flow dissector has proven quite useful, it does have some
shortcomings that are becoming increasingly noticeable as we continue
to expand the functionality of the stack:

- It has been prone to bugs, especially in the required bookkeeping,
as new protocols are added
- Not being able to parse UDP payloads or multi-leveled encapsulations.
- Customizing parsing behavior is impossible and requires multiple
workarounds on client code to avoid pitfalls in special cases handled
by flow dissector and to avoid unnecessary overhead
- For consumers that depend on the mapping in user space as well
    eg tc flower requires even more changes to sync with kernel updates.
- Due to its rigid nature, there's non-trivial loss of information
when you have multiple layers of encap (eg multiple repeated ethernet
headers, or ip headers etc). See this discussion for example [2].
- It is not flexible enough to map well to the semantics of hardware
offloading of parsers i.e the software twin in the kernel and specific
hardware semantics may have different capabilities.

The PANDA parser, introduced in [1], addresses most of these problems
and introduces a developer friendly highly maintainable approach to
adding extensions to the parser. This RFC patch takes a known consumer
of flow dissector - tc flower - and  shows how it could make use of
the PANDA Parser by mostly cutnpaste of the flower code. The new
classifier is called "flower2". The control semantics of flower are
maintained but the flow dissector parser is replaced with a PANDA
Parser. The iproute2 patch is sent separately - but you'll notice
other than replacing the user space tc commands with "flower2"  the
syntax is exactly the same. To illustrate the flexibility of PANDA we
show a simple use case of the issues described in [2] when flower
consumes PANDA. The PANDA Parser is part of the PANDA programming
model for network datapaths, this is described in
https://github.com/panda-net/panda.


[1]: https://netdevconf.info/0x15/session.html?Replacing-Flow-Dissector-with-PANDA-Parser
[2]: https://patchwork.kernel.org/project/netdevbpf/patch/20210830080849.18695-1-boris.sukholitko@broadcom.com/

Felipe Magno de Almeida (2):
  net: Add PANDA network packet parser
  net/sched: Add flower2 packet classifier based on flower and PANDA
    parser

 include/net/panda/compiler_helpers.h          |   79 +
 include/net/panda/flag_fields.h               |  369 ++
 include/net/panda/parser.h                    |  394 ++
 include/net/panda/parser_metadata.h           |  873 +++++
 include/net/panda/parser_types.h              |  255 ++
 include/net/panda/proto_nodes.h               |   48 +
 .../net/panda/proto_nodes/proto_arp_rarp.h    |   88 +
 include/net/panda/proto_nodes/proto_batman.h  |  106 +
 include/net/panda/proto_nodes/proto_ether.h   |   58 +
 include/net/panda/proto_nodes/proto_fcoe.h    |   49 +
 include/net/panda/proto_nodes/proto_gre.h     |  290 ++
 include/net/panda/proto_nodes/proto_icmp.h    |   74 +
 include/net/panda/proto_nodes/proto_igmp.h    |   49 +
 include/net/panda/proto_nodes/proto_ip.h      |   77 +
 include/net/panda/proto_nodes/proto_ipv4.h    |  150 +
 include/net/panda/proto_nodes/proto_ipv4ip.h  |   59 +
 include/net/panda/proto_nodes/proto_ipv6.h    |  133 +
 include/net/panda/proto_nodes/proto_ipv6_eh.h |  108 +
 include/net/panda/proto_nodes/proto_ipv6ip.h  |   59 +
 include/net/panda/proto_nodes/proto_mpls.h    |   49 +
 include/net/panda/proto_nodes/proto_ports.h   |   59 +
 include/net/panda/proto_nodes/proto_ppp.h     |   79 +
 include/net/panda/proto_nodes/proto_pppoe.h   |   98 +
 include/net/panda/proto_nodes/proto_tcp.h     |  177 +
 include/net/panda/proto_nodes/proto_tipc.h    |   56 +
 include/net/panda/proto_nodes/proto_vlan.h    |   66 +
 include/net/panda/proto_nodes_def.h           |   40 +
 include/net/panda/tlvs.h                      |  289 ++
 net/Kconfig                                   |    9 +
 net/Makefile                                  |    1 +
 net/panda/Makefile                            |    8 +
 net/panda/panda_parser.c                      |  605 +++
 net/sched/Kconfig                             |   11 +
 net/sched/Makefile                            |    2 +
 net/sched/cls_flower2_main.c                  | 3289 +++++++++++++++++
 net/sched/cls_flower2_panda_noopt.c           |  305 ++
 net/sched/cls_flower2_panda_opt.c             | 1536 ++++++++
 37 files changed, 9997 insertions(+)
 create mode 100644 include/net/panda/compiler_helpers.h
 create mode 100644 include/net/panda/flag_fields.h
 create mode 100644 include/net/panda/parser.h
 create mode 100644 include/net/panda/parser_metadata.h
 create mode 100644 include/net/panda/parser_types.h
 create mode 100644 include/net/panda/proto_nodes.h
 create mode 100644 include/net/panda/proto_nodes/proto_arp_rarp.h
 create mode 100644 include/net/panda/proto_nodes/proto_batman.h
 create mode 100644 include/net/panda/proto_nodes/proto_ether.h
 create mode 100644 include/net/panda/proto_nodes/proto_fcoe.h
 create mode 100644 include/net/panda/proto_nodes/proto_gre.h
 create mode 100644 include/net/panda/proto_nodes/proto_icmp.h
 create mode 100644 include/net/panda/proto_nodes/proto_igmp.h
 create mode 100644 include/net/panda/proto_nodes/proto_ip.h
 create mode 100644 include/net/panda/proto_nodes/proto_ipv4.h
 create mode 100644 include/net/panda/proto_nodes/proto_ipv4ip.h
 create mode 100644 include/net/panda/proto_nodes/proto_ipv6.h
 create mode 100644 include/net/panda/proto_nodes/proto_ipv6_eh.h
 create mode 100644 include/net/panda/proto_nodes/proto_ipv6ip.h
 create mode 100644 include/net/panda/proto_nodes/proto_mpls.h
 create mode 100644 include/net/panda/proto_nodes/proto_ports.h
 create mode 100644 include/net/panda/proto_nodes/proto_ppp.h
 create mode 100644 include/net/panda/proto_nodes/proto_pppoe.h
 create mode 100644 include/net/panda/proto_nodes/proto_tcp.h
 create mode 100644 include/net/panda/proto_nodes/proto_tipc.h
 create mode 100644 include/net/panda/proto_nodes/proto_vlan.h
 create mode 100644 include/net/panda/proto_nodes_def.h
 create mode 100644 include/net/panda/tlvs.h
 create mode 100644 net/panda/Makefile
 create mode 100644 net/panda/panda_parser.c
 create mode 100644 net/sched/cls_flower2_main.c
 create mode 100644 net/sched/cls_flower2_panda_noopt.c
 create mode 100644 net/sched/cls_flower2_panda_opt.c

-- 
2.33.0

