Return-Path: <netdev+bounces-5384-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F2D99710FF4
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 17:50:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 37445281562
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 15:50:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA6DB19BD6;
	Thu, 25 May 2023 15:50:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEB731952A
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 15:50:39 +0000 (UTC)
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 481ACB6
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 08:50:38 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id 41be03b00d2f7-53482b44007so1252151a12.2
        for <netdev@vger.kernel.org>; Thu, 25 May 2023 08:50:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20221208.gappssmtp.com; s=20221208; t=1685029837; x=1687621837;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=q7bxfSZavN2X+jL/HxqIqmFFMeUEqV0iKZ0/vLhcOBY=;
        b=V8ZE+2AvDOzrexuZv5Ygef/E91YmYW886SGwlZrJnjWFH1Gyw6GTjX/G3ihxsGu7VW
         Rr3KHiBrvPb9X+pLLBB6s+3rKueqLd++UxEs3nguILjQ0BujFExcOi/aBpVoFSZVHcC0
         djmqqjGf95hvZDWnfthAb170X30gjxDrBLAelm3Vg2ojN4RwMkskB31pq0RcdYTJtEni
         J6JQmK50afUiobuDJ4LHNLZYBizJTzq08wn+Y/At57RLYFXJyptQx7uaru34GGUQNIVx
         VILgz9fkjfeSpD6uEIPTbbXqakb4Pz8a1qpOQTkzu+xgrPqs3c/g6moS7JJt8lFZvedz
         Plug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685029837; x=1687621837;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=q7bxfSZavN2X+jL/HxqIqmFFMeUEqV0iKZ0/vLhcOBY=;
        b=Y351PjC8OhbppKm/CFqkFqFkx7Z/2saVEkBjrMdBKEmZGC7/O6buvBFAnmhJ8S7jpE
         vxK81HbSF0MqoINEo/9ixdTiJW9LP64DS3W0wZTgn6oQ6UxE2dOb49pKtwrwCjSvalC6
         B3PojcX3S3uvnP9oYv3IP/qi3UTuo1ik/djwykH88XzvTi4kMFLw56L6GUpaU1gUJ2uZ
         T1QhWKg1cD7CycPM34PBwkH+QhV6dJjClFnzPAO8DWY3W02whrb9LFOaQCKpRv4Ft0kY
         JT37OXo06tiALtW/YFQBO9qfKalUSdInTDbilN/fNgRx1yzwDxGy9zKHd0XVZcZGN985
         5ISw==
X-Gm-Message-State: AC+VfDyIfvU7FPYQpDcq8tcInrRNwHSF85+u0x5FkSwVoozlutmzpvQi
	QLQ216zXxrGSy7WbZq92BQsz3FmuNCEDwZUrPnyliA==
X-Google-Smtp-Source: ACHHUZ46A50L2ZP39EGOX0fDEd9kmjdBihkbietxB5ZiZS2tpwKq3NLfpC+KTm8PJKTSCqp84uKdwQ==
X-Received: by 2002:a17:902:e887:b0:1ae:5916:9f12 with SMTP id w7-20020a170902e88700b001ae59169f12mr2677542plg.13.1685029837506;
        Thu, 25 May 2023 08:50:37 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id t1-20020a170902e84100b001a9a8983a15sm1586547plg.231.2023.05.25.08.50.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 May 2023 08:50:37 -0700 (PDT)
From: Stephen Hemminger <stephen@networkplumber.org>
To: netdev@vger.kernel.org
Cc: Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2 v2 0/2] vxlan: option printing
Date: Thu, 25 May 2023 08:50:33 -0700
Message-Id: <20230525155035.7471-1-stephen@networkplumber.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

This patchset makes printing of vxlan details more consistent.

Before:
$ ip -d link show dev vxlan0
4: vxlan0: <BROADCAST,MULTICAST> mtu 1450 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/ether e6:a4:54:b2:34:85 brd ff:ff:ff:ff:ff:ff promiscuity 0  allmulti 0 minmtu 68 maxmtu 65535 
    vxlan id 42 group 239.1.1.1 dev enp2s0 srcport 0 0 dstport 4789 ttl auto ageing 300 udpcsum noudp6zerocsumtx noudp6zerocsumrx addrgenmode eui64 numtxqueues 1 numrxqueues 1 gso_max_size 64000 gso_max_segs 64 tso_max_size 64000 tso_max_segs 64 gro_max_size 65536 

After:
$ ip -d link show dev vxlan0
4: vxlan0: <BROADCAST,MULTICAST> mtu 1450 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/ether e6:a4:54:b2:34:85 brd ff:ff:ff:ff:ff:ff promiscuity 0  allmulti 0 minmtu 68 maxmtu 65535 
    vxlan id 42 group 239.1.1.1 dev enp2s0 srcport 0 0 dstport 4789 ttl auto ageing 300 addrgenmode eui64 numtxqueues 1 numrxqueues 1 gso_max_size 64000 gso_max_segs 64 tso_max_size 64000 tso_max_segs 64 gro_max_size 65536

And JSON output is more complete
$ ip -j -p -d link show dev vxlan0
[ {
        "ifindex": 4,
        "ifname": "vxlan0",
        "flags": [ "BROADCAST","MULTICAST" ],
        "mtu": 1450,
        "qdisc": "noop",
        "operstate": "DOWN",
        "linkmode": "DEFAULT",
        "group": "default",
        "txqlen": 1000,
        "link_type": "ether",
        "address": "e6:a4:54:b2:34:85",
        "broadcast": "ff:ff:ff:ff:ff:ff",
        "promiscuity": 0,
        "allmulti": 0,
        "min_mtu": 68,
        "max_mtu": 65535,
        "linkinfo": {
            "info_kind": "vxlan",
            "info_data": {
                "external": false,
                "id": 42,
                "group": "239.1.1.1",
                "link": "enp2s0",
                "port_range": {
                    "low": 0,
                    "high": 0
                },
                "port": 4789,
                "learning": true,
                "proxy": false,
                "rsc": false,
                "l2miss": false,
                "l3miss": false,
                "ttl": 0,
                "df": "unset",
                "ageing": 300,
                "udp_csum": true,
                "udp_zero_csum6_tx": false,
                "udp_zero_csum6_rx": false,
                "remcsum_tx": false,
                "remcsum_rx": false
            }
        },
        "inet6_addr_gen_mode": "eui64",
        "num_tx_queues": 1,
        "num_rx_queues": 1,
        "gso_max_size": 64000,
        "gso_max_segs": 64,
        "tso_max_size": 64000,
        "tso_max_segs": 64,
        "gro_max_size": 65536
    } ]



Stephen Hemminger (2):
  vxlan: use print_nll for gbp and gpe
  vxlan: make option printing more consistent

 include/json_print.h |  9 +++++
 ip/iplink_vxlan.c    | 84 ++++++++++++++++----------------------------
 lib/json_print.c     | 19 ++++++++++
 3 files changed, 58 insertions(+), 54 deletions(-)

-- 
2.39.2


