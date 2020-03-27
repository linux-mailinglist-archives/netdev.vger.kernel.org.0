Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C0C21960C8
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 23:00:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727702AbgC0WAq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 18:00:46 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:45332 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727611AbgC0WAq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 18:00:46 -0400
Received: by mail-qk1-f196.google.com with SMTP id c145so12496970qke.12
        for <netdev@vger.kernel.org>; Fri, 27 Mar 2020 15:00:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=j7h240r2OsaPjjJitTHasAWadC7KON3eXk87Ah62Mcc=;
        b=BmQb4Pmr5SvOXEaze0RFa4209I9PbCkl+JHrZEXudeHEd0fkxjfsYmPJRf+TL5H+Vo
         9OeveMF/iLG1hdUj44t+UdvLNtTTm3bkspMUhYrKDxh5b3WS1Vn4DHHOfd15T9v7vEoZ
         WYaQwzLkd9vQxXuGeg+jIfk7+jxOAEyME6n0lmsL9cYJ/r2QvRqLbVsEm169R/orccJj
         oPwsFiwG8AcPvYH/8+5xGfMkPZhQOUVRaIhgZqZhedS3Z8TBZhMHxYln9XLDsQdYAjX5
         0H9xsHmL7eOFipy895oE17O9MoTI504+zxuNvBEZWBow3v6h1dY1/vK61/fyGHyz1bLL
         mgyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=j7h240r2OsaPjjJitTHasAWadC7KON3eXk87Ah62Mcc=;
        b=TXmN9IQcZ6umKqu+ktTfIeisKBQroEQ/x0z46pTOwsgeTYVjVDxCkEdyis6tZJaj7q
         G0NcN7EiBxtIhrL7YtJmwdTupXUZJ6NZ2DiJgS1nZDNMkeH8aF2RKhRuTNT6JCKIpHbS
         2qKf07XnzR+9+P7szGEdJVZhjgcTuqjlm8oWD47SLwPh+o4cBQc7+p1Q8GKbe2xnO8+p
         H1TsHtTmDs6rd3QtrdfNIgPGp7ZpenDv3ERBUDFTVVvr/shYg4Qwj/IrWS6Y+VD+qzXA
         LavGbSEIW70M4ykqcob6PD8tHmrIeu6derRGjVpKmiZL9x6GIJCEZVo2j8SRTNzMYQ3y
         BM7Q==
X-Gm-Message-State: ANhLgQ1peoI/Js/aK0bQxH3WD3xsMeQCwtndSm5LF3UrjyXMcduhK+kQ
        jXiigfTPCImCYi5QTTRBYVg=
X-Google-Smtp-Source: ADFU+vssBO+st0S8ttM2QA9wxLBcRSB1coTNi2hoYOtEO7fEM1inBv3uDnxvQGCONqE/4eah7UvMoQ==
X-Received: by 2002:a37:9d4a:: with SMTP id g71mr1502209qke.54.1585346443638;
        Fri, 27 Mar 2020 15:00:43 -0700 (PDT)
Received: from localhost.localdomain ([45.72.142.47])
        by smtp.gmail.com with ESMTPSA id v20sm5073659qth.10.2020.03.27.15.00.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Mar 2020 15:00:42 -0700 (PDT)
From:   Alexander Aring <alex.aring@gmail.com>
To:     davem@davemloft.net
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        dav.lebrun@gmail.com, mcr@sandelman.ca, stefan@datenfreihafen.org,
        kai.beckmann@hs-rm.de, martin.gergeleit@hs-rm.de,
        robert.kaiser@hs-rm.de, netdev@vger.kernel.org,
        Alexander Aring <alex.aring@gmail.com>
Subject: [PATCHv3 net-next 0/5] net: ipv6: add rpl source routing
Date:   Fri, 27 Mar 2020 18:00:17 -0400
Message-Id: <20200327220022.15220-1-alex.aring@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi netdev,

This patch series will add handling for RPL source routing handling
and insertion (implement as lwtunnel)! I did an example prototype
implementation in rpld for using this implementation in non-storing mode:

https://github.com/linux-wpan/rpld/tree/nonstoring_mode

I will also present a talk at netdev about it:

https://netdevconf.info/0x14/session.html?talk-extend-segment-routing-for-RPL

In receive handling I add handling for IPIP encapsulation as RFC6554
describes it as possible. For reasons I didn't implemented it yet for
generating such packets because I am not really sure how/when this
should happen. So far I understand there exists a draft yet which
describes the cases (inclusive a Hop-by-Hop option which we also not
support yet).

https://tools.ietf.org/html/draft-ietf-roll-useofrplinfo-35

This is just the beginning to start implementation everything for yet,
step by step. It works for my use cases yet to have it running on a
6LOWPAN _only_ network.

I have some patches for iproute2 as well.

A sidenote: I check on local addresses if they are part of segment
routes, this is just to avoid stupid settings. A use can add addresses
afterwards what I cannot control anymore but then it's users fault to
make such thing. The receive handling checks for this as well which is
required by RFC6554, so the next hops or when it comes back should drop
it anyway.

To make this possible I added functionality to pass the net structure to
the build_state of lwtunnel (I hope I caught all lwtunnels).

Another sidenote: I set the headroom value to 0 as I figured out it will
break on interfaces with IPv6 min mtu if set to non zero for tunnels on
L3.

- Alex

changes since v3:
 - use parse_nested which isn't deprecated - Thanks David Ahern
 - change to return -1 instead errno in exthdr handling to unify
   error code
 - change function name from ipv6_rpl_srh_decompress_size to
   ipv6_rpl_srh_size

changes since v2:
 - add additional segdata length in lwtunnel build_state
 - fix build_state patch by not catching one inline noop function
   if LWTUNNEL is disabled

Alexander Aring (5):
  include: uapi: linux: add rpl sr header definition
  addrconf: add functionality to check on rpl requirements
  net: ipv6: add support for rpl sr exthdr
  net: add net available in build_state
  net: ipv6: add rpl sr tunnel

 include/linux/ipv6.h              |   1 +
 include/net/addrconf.h            |   3 +
 include/net/ip_fib.h              |   5 +-
 include/net/lwtunnel.h            |   6 +-
 include/net/rpl.h                 |  46 ++++
 include/uapi/linux/ipv6.h         |   2 +
 include/uapi/linux/lwtunnel.h     |   1 +
 include/uapi/linux/rpl.h          |  48 ++++
 include/uapi/linux/rpl_iptunnel.h |  21 ++
 net/core/lwt_bpf.c                |   2 +-
 net/core/lwtunnel.c               |   6 +-
 net/ipv4/fib_lookup.h             |   2 +-
 net/ipv4/fib_semantics.c          |  22 +-
 net/ipv4/fib_trie.c               |   2 +-
 net/ipv4/ip_tunnel_core.c         |   4 +-
 net/ipv6/Kconfig                  |  10 +
 net/ipv6/Makefile                 |   3 +-
 net/ipv6/addrconf.c               |  63 +++++
 net/ipv6/af_inet6.c               |   7 +
 net/ipv6/exthdrs.c                | 201 +++++++++++++++-
 net/ipv6/ila/ila_lwt.c            |   2 +-
 net/ipv6/route.c                  |   2 +-
 net/ipv6/rpl.c                    | 123 ++++++++++
 net/ipv6/rpl_iptunnel.c           | 380 ++++++++++++++++++++++++++++++
 net/ipv6/seg6_iptunnel.c          |   2 +-
 net/ipv6/seg6_local.c             |   5 +-
 net/mpls/mpls_iptunnel.c          |   2 +-
 27 files changed, 940 insertions(+), 31 deletions(-)
 create mode 100644 include/net/rpl.h
 create mode 100644 include/uapi/linux/rpl.h
 create mode 100644 include/uapi/linux/rpl_iptunnel.h
 create mode 100644 net/ipv6/rpl.c
 create mode 100644 net/ipv6/rpl_iptunnel.c

-- 
2.20.1

