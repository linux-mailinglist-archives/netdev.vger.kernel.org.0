Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05BC5173E65
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 18:25:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726682AbgB1RZL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 12:25:11 -0500
Received: from mail-wm1-f53.google.com ([209.85.128.53]:51821 "EHLO
        mail-wm1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725769AbgB1RZK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 12:25:10 -0500
Received: by mail-wm1-f53.google.com with SMTP id t23so4033672wmi.1
        for <netdev@vger.kernel.org>; Fri, 28 Feb 2020 09:25:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=knCQ/NKgp/LKhnLoGMEe1Nth2ZkvJY04GVkgA5zOjeg=;
        b=AhNqb7RJC/2ZM/Ziq7a1fNCy11ZVP4EoqROXKj6BH3NqWnW0NjGcwkscFWvLXZO+hX
         rhCVPQxv9BzRvNl2Y4rQfN9OuwAlC8ve970VOBQb8OjR0zo/642oj2HbL5bE1wfzqT/U
         M5Hyw3xN5oc9oFCEx776pzED4ukl7zYXm1C/JEY5I05hT6UR8+8YHlECFNosH4QIE3xX
         wmdrEP3AiEwBJf9f9yOKhslqYlibWrrJijxsNAYFPtTNG3Ks/cbw9ESO+ojXeyKU+bsY
         MqLwV2+ZTCIXLJ+b0TUnP2tkih/1CaaaMEOp7bTg9vS23t7AgQZ+lqydj8KVyAU1TVzL
         P4nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=knCQ/NKgp/LKhnLoGMEe1Nth2ZkvJY04GVkgA5zOjeg=;
        b=r46zOddX+Zh/vcl7OQue+w7SPVXWz4fT6r/4VHBI/OO65UCeKprKQcEngP2I1eUYSc
         0VNvLC7ha23Y6IH5qhqKM1YOaRCQqbUt3Ic6QyeKg9fd4LaE2yaBu9MA/MtyvRsS3q13
         G1rOpPsr0AbGHktlQPSAaoOI4CzzHOCUEcp+DV/IpLCS7zHd42EMFJx4XgfGXyVdBcwF
         uKEUWernWJEp1QxJf5tn5hd7NbB5teaQzDKT/vlABgk4puScdK6+zD24UmmEVIfhU9so
         MmkdYBj5b2BM/hKJ7VPZ6Dpkj7jwsBNuL4R1yoAsrVf5rgTGGUGqtFTnD8NUOqgeuC7y
         gqYA==
X-Gm-Message-State: APjAAAUuiWNUmSaXdMel76DsJZo2i44R5Nl67deMQVF5yNDNyGAjabqY
        PbPjUe0sIm3Zi6juiHKFbBNlps5oHN8=
X-Google-Smtp-Source: APXvYqwJZ7mG8l000IPEfqS/nP/aqUODPZEs2fmNnkJUCZrEmRtwlNzX0+BXDAVXapRtNU5/Bis38g==
X-Received: by 2002:a05:600c:2c4d:: with SMTP id r13mr5492030wmg.112.1582910706526;
        Fri, 28 Feb 2020 09:25:06 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id s1sm13396152wro.66.2020.02.28.09.25.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2020 09:25:06 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, saeedm@mellanox.com,
        leon@kernel.org, michael.chan@broadcom.com, vishal@chelsio.com,
        jeffrey.t.kirsher@intel.com, idosch@mellanox.com,
        aelior@marvell.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, pablo@netfilter.org,
        ecree@solarflare.com, mlxsw@mellanox.com
Subject: [patch net-next v2 00/12] net: allow user specify TC action HW stats type
Date:   Fri, 28 Feb 2020 18:24:53 +0100
Message-Id: <20200228172505.14386-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Currently, when user adds a TC action and the action gets offloaded,
the user expects the HW stats to be counted and included in stats dump.
However, since drivers may implement different types of counting, there
is no way to specify which one the user is interested in.

For example for mlx5, only delayed counters are available as the driver
periodically polls for updated stats.

In case of mlxsw, the counters are queried on dump time. However, the
HW resources for this type of counters is quite limited (couple of
thousands). This limits the amount of supported offloaded filters
significantly. Without counter assigned, the HW is capable to carry
millions of those.

On top of that, mlxsw HW is able to support delayed counters as well in
greater numbers. That is going to be added in a follow-up patch.

This patchset allows user to specify one of the following types of HW
stats for added action:
any - current default, user does not care about the type, just expects
      any type of stats.
immediate - queried during dump time
delayed - polled from HW periodically or sent by HW in async manner
disabled - no stats needed

Examples:
$ tc filter add dev enp0s16np28 ingress proto ip handle 1 pref 1 flower skip_sw dst_ip 192.168.1.1 action drop hw_stats disabled
$ tc -s filter show dev enp0s16np28 ingress 
filter protocol ip pref 1 flower chain 0 
filter protocol ip pref 1 flower chain 0 handle 0x1 
  eth_type ipv4
  dst_ip 192.168.1.1
  skip_sw
  in_hw in_hw_count 2
        action order 1: gact action drop
         random type none pass val 0
         index 1 ref 1 bind 1 installed 13 sec used 4 sec
        Action statistics:
        Sent 1164 bytes 588185936 pkt (dropped 588185936, overlimits 0 requeues 0) 
        Sent software 0 bytes 0 pkt
        Sent hardware 1164 bytes 588185936 pkt
        backlog 0b 0p requeues 0
        hw_stats disabled
	
$ tc filter add dev enp0s16np28 ingress proto ip handle 1 pref 1 flower skip_sw dst_ip 192.168.1.1 action drop hw_stats immediate
$ tc -s filter show dev enp0s16np28 ingress
filter protocol ip pref 1 flower chain 0 
filter protocol ip pref 1 flower chain 0 handle 0x1 
  eth_type ipv4
  dst_ip 192.168.1.1
  skip_sw
  in_hw in_hw_count 2
        action order 1: gact action drop
         random type none pass val 0
         index 1 ref 1 bind 1 installed 11 sec used 4 sec
        Action statistics:
        Sent 102 bytes 1 pkt (dropped 1, overlimits 0 requeues 0) 
        Sent software 0 bytes 0 pkt
        Sent hardware 102 bytes 1 pkt
        backlog 0b 0p requeues 0
        hw_stats immediate

Jiri Pirko (12):
  flow_offload: Introduce offload of HW stats type
  ocelot_flower: use flow_offload_has_one_action() helper
  flow_offload: check for basic action hw stats type
  mlx5: en_tc: Do not allow mixing HW stats types for actions
  mlxsw: spectrum_flower: Do not allow mixing HW stats types for actions
  mlx5: restrict supported HW stats type to "any"
  mlxsw: restrict supported HW stats type to "any"
  flow_offload: introduce "immediate" HW stats type and allow it in
    mlxsw
  flow_offload: introduce "delayed" HW stats type and allow it in mlx5
  mlxsw: spectrum_acl: Ask device for rule stats only if counter was
    created
  flow_offload: introduce "disabled" HW stats type and allow it in mlxsw
  sched: act: allow user to specify type of HW stats for a filter

 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c  |  9 +++-
 .../ethernet/chelsio/cxgb4/cxgb4_tc_flower.c  |  8 +++-
 .../ethernet/chelsio/cxgb4/cxgb4_tc_flower.h  |  3 +-
 .../chelsio/cxgb4/cxgb4_tc_matchall.c         |  3 +-
 .../net/ethernet/marvell/mvpp2/mvpp2_cls.c    |  6 +++
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 23 ++++++++++
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  3 +-
 .../ethernet/mellanox/mlxsw/spectrum_acl.c    | 25 ++++++----
 .../ethernet/mellanox/mlxsw/spectrum_flower.c | 21 +++++++--
 drivers/net/ethernet/mscc/ocelot_flower.c     |  6 ++-
 .../ethernet/netronome/nfp/flower/action.c    |  4 ++
 .../net/ethernet/qlogic/qede/qede_filter.c    | 10 ++--
 .../net/ethernet/stmicro/stmmac/stmmac_tc.c   |  9 +++-
 include/net/act_api.h                         |  1 +
 include/net/flow_offload.h                    | 46 +++++++++++++++++++
 include/uapi/linux/pkt_cls.h                  | 26 +++++++++++
 net/dsa/slave.c                               |  4 ++
 net/sched/act_api.c                           | 21 +++++++++
 net/sched/cls_api.c                           | 26 +++++++++++
 19 files changed, 229 insertions(+), 25 deletions(-)

-- 
2.21.1

