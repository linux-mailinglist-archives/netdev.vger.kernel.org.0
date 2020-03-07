Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 169AA17CDD4
	for <lists+netdev@lfdr.de>; Sat,  7 Mar 2020 12:40:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726102AbgCGLk0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Mar 2020 06:40:26 -0500
Received: from mail-wr1-f49.google.com ([209.85.221.49]:41860 "EHLO
        mail-wr1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726043AbgCGLk0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Mar 2020 06:40:26 -0500
Received: by mail-wr1-f49.google.com with SMTP id v4so5365374wrs.8
        for <netdev@vger.kernel.org>; Sat, 07 Mar 2020 03:40:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dd0L2we/1/kHfw5nKL1a01Zv4R7GevH5IPYmNN4s4L0=;
        b=QXgaKYHOFHS8uwDX9Hsk2t/4wGyUtuI2KR+Y7j7ByjBLoh2AFL78b+w096XJokNMWC
         +OTqAaOeHOBY2OvOYhyYRP+e6gbpHyd4xmpkdFHqUTHx/dCoTdkGvWOb0leiKS9vI898
         08na8JyU9K3M9tVmsxK4EsNQ9UNWu7IhTrouguqMH1QQOQc8arxdOB5DYv8/IAdGshOz
         ToGrdBDq9m5sGbmFDy3F3YhakgiaLl4Mhwvi0WWh5TuP8MWFKkTvItjFTrjs9YqDtyeI
         duo0QOnCke/F98FLeC3LvRogjNwGI8Wtk/Lc/HtuBmaYdXAAS5MsQ57x8sp8nOqa9abv
         Lvrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dd0L2we/1/kHfw5nKL1a01Zv4R7GevH5IPYmNN4s4L0=;
        b=YebBEHY9JdMvX8/EMSIk3dfiFXWLCQYC8dxDcxa9d7HOjEQkc8mUMHjQsY636WxOcP
         uH/TikqZdI/bQ9Dzd00rnSBKmUoW4lHVSsROuS3NpSh/MN0PhM9hrYy07wBqrkkcH86W
         ou/0OvQSXWXyDm7IcGNmma2AG82OuHGK/OMFxQMMZHZhFsCJ75Wp9pziE1jgl1Tk/Qxq
         N/0wjpESQp/9TTxcHnGnFjKN2UVxFhIW1+ea1EtVJtvu/f+HquYsb9om+FcdDQE00by2
         grQlIboFegdQZbVZ0MrmKFzWw1G3AvjDC5UL7FLmifvasbcvkCfRrPLcPK6g7OuXuO6v
         /LBQ==
X-Gm-Message-State: ANhLgQ2DnREbsN8VWZifzGJGDwqFnbdsXqNwFijcdvoTIbeYKzEnCgUQ
        la+Gh/hEXqf12fHq+boASRF1pCP4M0o=
X-Google-Smtp-Source: ADFU+vtmSUh4RlUxwLv6IYKTqVMo/RdC9YaOorngXgvB+kMZqmLSNzGOmIeHqkNOIWGTZfWQ4PikBw==
X-Received: by 2002:a5d:4406:: with SMTP id z6mr4148983wrq.68.1583581223161;
        Sat, 07 Mar 2020 03:40:23 -0800 (PST)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id h18sm900519wmm.6.2020.03.07.03.40.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Mar 2020 03:40:22 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, saeedm@mellanox.com,
        leon@kernel.org, michael.chan@broadcom.com, vishal@chelsio.com,
        jeffrey.t.kirsher@intel.com, idosch@mellanox.com,
        aelior@marvell.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, pablo@netfilter.org,
        ecree@solarflare.com, mlxsw@mellanox.com
Subject: [patch net-next v4 00/10] net: allow user specify TC action HW stats type
Date:   Sat,  7 Mar 2020 12:40:10 +0100
Message-Id: <20200307114020.8664-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
immediate - queried during dump time
delayed - polled from HW periodically or sent by HW in async manner
disabled - no stats needed

Note that if "hw_stats" option is not passed, user does not care about
the type, just expects any type of stats.

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
         index 1 ref 1 bind 1 installed 7 sec used 2 sec
        Action statistics:
        Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
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

Jiri Pirko (10):
  flow_offload: Introduce offload of HW stats type
  ocelot_flower: use flow_offload_has_one_action() helper
  flow_offload: check for basic action hw stats type
  mlxsw: spectrum_flower: Do not allow mixing HW stats types for actions
  mlxsw: restrict supported HW stats type to "any"
  flow_offload: introduce "immediate" HW stats type and allow it in
    mlxsw
  flow_offload: introduce "delayed" HW stats type and allow it in mlx5
  mlxsw: spectrum_acl: Ask device for rule stats only if counter was
    created
  flow_offload: introduce "disabled" HW stats type and allow it in mlxsw
  sched: act: allow user to specify type of HW stats for a filter

 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c  |  9 ++-
 .../ethernet/chelsio/cxgb4/cxgb4_tc_flower.c  |  8 ++-
 .../ethernet/chelsio/cxgb4/cxgb4_tc_flower.h  |  3 +-
 .../chelsio/cxgb4/cxgb4_tc_matchall.c         |  3 +-
 .../net/ethernet/marvell/mvpp2/mvpp2_cls.c    |  6 ++
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 11 +++
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  3 +-
 .../ethernet/mellanox/mlxsw/spectrum_acl.c    | 26 ++++---
 .../ethernet/mellanox/mlxsw/spectrum_flower.c | 17 +++--
 drivers/net/ethernet/mscc/ocelot_flower.c     |  6 +-
 .../ethernet/netronome/nfp/flower/action.c    |  4 ++
 .../net/ethernet/qlogic/qede/qede_filter.c    | 10 ++-
 .../net/ethernet/stmicro/stmmac/stmmac_tc.c   |  9 ++-
 include/net/act_api.h                         |  4 ++
 include/net/flow_offload.h                    | 68 +++++++++++++++++++
 include/uapi/linux/pkt_cls.h                  | 22 ++++++
 net/dsa/slave.c                               |  4 ++
 net/sched/act_api.c                           | 36 ++++++++++
 net/sched/cls_api.c                           |  7 ++
 19 files changed, 230 insertions(+), 26 deletions(-)

-- 
2.21.1

