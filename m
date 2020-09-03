Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52FC925BF0E
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 12:28:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726891AbgICK1k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 06:27:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726025AbgICK1b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 06:27:31 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D265C061244;
        Thu,  3 Sep 2020 03:27:31 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id k15so1948747pfc.12;
        Thu, 03 Sep 2020 03:27:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eQe5hZks1L43GLCT5QNuM+GVxeNbTN+rmb5ukaKJwBk=;
        b=Bvcx3aGtW9+20zhQ7vpIdottSWdHwyzUpuegX1y3bEFLgDwEzwl/8f2etof6Qy1WGH
         mDNxjxG+7ZOlBY/362WLeYlaGvRxl6hTTFLN9sBWmqzLiKlpmo4wYrdZTes0BHVPn8v5
         CITJT1t9vT/yczOziCGPnw9l+7IIky75pA4LGSzczJKFNHvmyRTwbBN2xFO3RzetTqJn
         gusOClv5EzEQzKZcvuDdsbX7pjws6eB714V4ZHU8LsW97PTHRw7MWNa+mA2VvVGcDss/
         uiUWMDlP/4kbv+rRtTARrUMI4FGCI4ndbxcabjmAk8UjXTCHRkZ2//kWiWW1ds3iqPUf
         3w/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eQe5hZks1L43GLCT5QNuM+GVxeNbTN+rmb5ukaKJwBk=;
        b=NFi8xSQCRvvyhsbN64TkX4eSpadr1qCzEXLuBX7qseuFL12ca8gYhNPHQA0uwvuDmb
         OqCKCE9HK4SBi79hyABx0U5oHBpYevgP+EZ+QT7UoUemcGQRTZ8fvF5On2CxHx6BKpRT
         bj9Z4fwCq8De0klDohxEIYJhvtzRvhkgeLdN6YqkZxUCv9zGoCIA6JQSzelYGEeZ3ZAQ
         yCOkOKO1t5Ci3V+hWGjL0KCwWN0mh6njfOcKPyX8JUD8GpqgkxeV8VMV9IdG6R36q5yn
         IrBa0fI4ddroMoht5BCTmsu4rC2jLYDT9yL1Xmx77qNrQ0muyLTmlmadOIJ44MK98dBc
         9QYQ==
X-Gm-Message-State: AOAM532nsKoNeDVSp2RikS8dgI/OVAxAfnc8lhKINg9Rgq67H8/f8Af0
        rGllaBv4goPH4bAYUiTX5WhXF7p0bqng9NF1
X-Google-Smtp-Source: ABdhPJzO14ksK5A4KWC4G63HW8+U3MP02mCBTJWkOE3tnk3O5fN+xmpsr15LxxKkVhOirePH+5PuDw==
X-Received: by 2002:a17:902:ea86:: with SMTP id x6mr3218107plb.131.1599128848141;
        Thu, 03 Sep 2020 03:27:28 -0700 (PDT)
Received: from dhcp-12-153.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x3sm2131929pgg.54.2020.09.03.03.27.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2020 03:27:27 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv10 bpf-next 0/5] xdp: add a new helper for dev map multicast support
Date:   Thu,  3 Sep 2020 18:26:56 +0800
Message-Id: <20200903102701.3913258-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200826132002.2808380-1-liuhangbin@gmail.com>
References: <20200826132002.2808380-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is for xdp multicast support. which has been discussed before[0],
The goal is to be able to implement an OVS-like data plane in XDP, i.e.,
a software switch that can forward XDP frames to multiple ports.

To achieve this, an application needs to specify a group of interfaces
to forward a packet to. It is also common to want to exclude one or more
physical interfaces from the forwarding operation - e.g., to forward a
packet to all interfaces in the multicast group except the interface it
arrived on. While this could be done simply by adding more groups, this
quickly leads to a combinatorial explosion in the number of groups an
application has to maintain.

To avoid the combinatorial explosion, we propose to include the ability
to specify an "exclude group" as part of the forwarding operation. This
needs to be a group (instead of just a single port index), because there
may have multi interfaces you want to exclude.

Thus, the logical forwarding operation becomes a "set difference"
operation, i.e. "forward to all ports in group A that are not also in
group B". This series implements such an operation using device maps to
represent the groups. This means that the XDP program specifies two
device maps, one containing the list of netdevs to redirect to, and the
other containing the exclude list.

To achieve this, I re-implement a new helper bpf_redirect_map_multi()
to accept two maps, the forwarding map and exclude map. If user
don't want to use exclude map and just want simply stop redirecting back
to ingress device, they can use flag BPF_F_EXCLUDE_INGRESS.

The 1st patch add a new bpf arg to allow NULL map pointer.
The 2nd patch add the new bpf_redirect_map_multi() helper.
The 3rd and 4th patches are for usage sample and testing purpose, there
is no effort has been made on performance optimisation.
The 5th patch added some verifier test for new bpf arg ARG_CONST_MAP_PTR_OR_NULL

I did same tests with pktgen(pkt size 64) to compire with xdp_redirect_map().
Here is the test result(the veth peer has a dummy xdp program with XDP_DROP
directly):

Version         | Test                                   | Native | Generic
5.9 rc1         | xdp_redirect_map       i40e->i40e      |  10.4M |  1.9M
5.9 rc1         | xdp_redirect_map       i40e->veth      |  14.2M |  2.2M
5.9 rc1 + patch | xdp_redirect_map       i40e->i40e      |  10.3M |  1.9M
5.9 rc1 + patch | xdp_redirect_map       i40e->veth      |  14.2M |  2.2M
5.9 rc1 + patch | xdp_redirect_map_multi i40e->i40e      |   8.0M |  1.5M
5.9 rc1 + patch | xdp_redirect_map_multi i40e->veth      |  11.2M |  1.6M
5.9 rc1 + patch | xdp_redirect_map_multi i40e->i40e+veth |   3.5M |  1.1M

The bpf_redirect_map_multi() is slower than bpf_redirect_map() as we loop
the map and do clone skb/xdpf. The generic path is slower than native
path as we send skbs by pktgen. So the result looks reasonable. There is
some performance improvement for veth port compared with 5.8 rc1.

Last but not least, thanks a lot to Toke, Jesper, Jiri and Eelco for
suggestions and help on implementation.

[0] https://xdp-project.net/#Handling-multicast

v10:
Rebase the code to latest bpf-next.
Update helper bpf_xdp_redirect_map_multi()
- No need to check map pointer as we will do the check in verifier.

v9:
Update helper bpf_xdp_redirect_map_multi()
- Use ARG_CONST_MAP_PTR_OR_NULL for helper arg2

v8:
a) Update function dev_in_exclude_map():
   - remove duplicate ex_map map_type check in
   - lookup the element in dev map by obj dev index directly instead
     of looping all the map

v7:
a) Fix helper flag check
b) Limit the *ex_map* to use DEVMAP_HASH only and update function
   dev_in_exclude_map() to get better performance.

v6: converted helper return types from int to long

v5:
a) Check devmap_get_next_key() return value.
b) Pass through flags to __bpf_tx_xdp_map() instead of bool value.
c) In function dev_map_enqueue_multi(), consume xdpf for the last
   obj instead of the first on.
d) Update helper description and code comments to explain that we
   use NULL target value to distinguish multicast and unicast
   forwarding.
e) Update memory model, memory id and frame_sz in xdpf_clone().
f) Split the tests from sample and add a bpf kernel selftest patch.

v4: Fix bpf_xdp_redirect_map_multi_proto arg2_type typo

v3: Based on Toke's suggestion, do the following update
a) Update bpf_redirect_map_multi() description in bpf.h.
b) Fix exclude_ifindex checking order in dev_in_exclude_map().
c) Fix one more xdpf clone in dev_map_enqueue_multi().
d) Go find next one in dev_map_enqueue_multi() if the interface is not
   able to forward instead of abort the whole loop.
e) Remove READ_ONCE/WRITE_ONCE for ex_map.

v2: Add new syscall bpf_xdp_redirect_map_multi() which could accept
include/exclude maps directly.

Hangbin Liu (5):
  bpf: add a new bpf argument type ARG_CONST_MAP_PTR_OR_NULL
  xdp: add a new helper for dev map multicast support
  sample/bpf: add xdp_redirect_map_multicast test
  selftests/bpf: add xdp_redirect_multi test
  selftests/bpf: Add verifier tests for bpf arg
    ARG_CONST_MAP_PTR_OR_NULL

 include/linux/bpf.h                           |  21 +++
 include/linux/filter.h                        |   1 +
 include/net/xdp.h                             |   1 +
 include/uapi/linux/bpf.h                      |  27 +++
 kernel/bpf/devmap.c                           | 124 +++++++++++++
 kernel/bpf/verifier.c                         |  20 +-
 net/core/filter.c                             | 111 ++++++++++-
 net/core/xdp.c                                |  29 +++
 samples/bpf/Makefile                          |   3 +
 samples/bpf/xdp_redirect_map_multi_kern.c     |  43 +++++
 samples/bpf/xdp_redirect_map_multi_user.c     | 166 +++++++++++++++++
 tools/include/uapi/linux/bpf.h                |  27 +++
 tools/testing/selftests/bpf/Makefile          |   4 +-
 .../bpf/progs/xdp_redirect_multi_kern.c       |  77 ++++++++
 tools/testing/selftests/bpf/test_verifier.c   |  22 ++-
 .../selftests/bpf/test_xdp_redirect_multi.sh  | 164 +++++++++++++++++
 .../testing/selftests/bpf/verifier/map_ptr.c  |  70 +++++++
 .../selftests/bpf/xdp_redirect_multi.c        | 173 ++++++++++++++++++
 18 files changed, 1071 insertions(+), 12 deletions(-)
 create mode 100644 samples/bpf/xdp_redirect_map_multi_kern.c
 create mode 100644 samples/bpf/xdp_redirect_map_multi_user.c
 create mode 100644 tools/testing/selftests/bpf/progs/xdp_redirect_multi_kern.c
 create mode 100755 tools/testing/selftests/bpf/test_xdp_redirect_multi.sh
 create mode 100644 tools/testing/selftests/bpf/xdp_redirect_multi.c

-- 
2.25.4

