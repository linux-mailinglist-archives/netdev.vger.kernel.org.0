Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D4533F8855
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 15:09:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240767AbhHZNKF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 09:10:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232909AbhHZNKE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 09:10:04 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 261E8C061757
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 06:09:17 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id b7so4605211edu.3
        for <netdev@vger.kernel.org>; Thu, 26 Aug 2021 06:09:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+bsOsU1pMOOxOS/m4ixkUB3PS/2vs/6qwTOo6DOjBFg=;
        b=dPUscgbSQyYQ8zmHXWLhoZZnjBvrk7oaBAPT5luzobOSpHwqmmq2GzuB3KMCokv5Ns
         RUXSMJNW3QfNCYWwdhDVxvyxxb4Eim6LVBN9QE0V3GO/NzSbRvXBCUBtq/TZF1d6uNbL
         fbZ8AVceoSyQIK6uEoJFkIPxtkJTFoAIdOo11L2G5Uc3cA+RgS3tfLvN2nhwfjxv5irM
         5kgOHCszA+kA7i035RHO+WPU32zSkZKVXdBW/XeeiUfYV8fVSklGl+KOm2ELkzyKPqF+
         MxOFf8iiWjX1V+qzp8AX/zylUgs1wz+EKhI8zODldA3Xmpmt/3M+AGA8fjo/lKuOTV5t
         vk8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+bsOsU1pMOOxOS/m4ixkUB3PS/2vs/6qwTOo6DOjBFg=;
        b=oo6riNUkKNvORW24/+vbKU6XjtBOUrac/s3rDD37jZWx5FHfIsD8hTjWOzblGWIwHw
         heXi1QRZonloU1oALYCmRiZa+xNY7HJmzqI+ec4gI6UbPyGclUK6NH5wsTUIjRKSB2i5
         GaKrUWbohvdjpJcGlmiWZdQRvia2t4OSuTHfq0hA+oS3GQ3Zs5eY9gHWDBNRLqP57X4W
         xm98kGXZyZ9/oIipXXhyHV487ypX/Z0XVXtUaLuTzr4jH5ZvPdMUH8v6xC1VfzuJMtnH
         kIKcki1ZBodjQJj3oDOKxk8K+GRX5osL6q9voQ+kx8tyqAseJgYGqWofzBpO2g9vYhGn
         1zgA==
X-Gm-Message-State: AOAM530Sf7LpC5QDnEn7eJ7DlzPF8Pxknd4B4FNcy+jRsYX0ZtnCsje5
        ZBR+drfSUbZZcd9Z/uMOkNQyj82S0HygNakt
X-Google-Smtp-Source: ABdhPJx8c6LuVoKzZ1iOZZFVGsF1W+1R94P36PO7xzCmBhuNoZksha8rNDBLZQg39EghqecVkTTsgA==
X-Received: by 2002:a05:6402:40c9:: with SMTP id z9mr4200282edb.159.1629983355406;
        Thu, 26 Aug 2021 06:09:15 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id bl16sm1378303ejb.37.2021.08.26.06.09.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Aug 2021 06:09:15 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, Joachim Wiberg <troglobit@gmail.com>,
        dsahern@gmail.com, Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH iproute2-next 00/17] bridge: vlan: add global multicast options
Date:   Thu, 26 Aug 2021 16:05:16 +0300
Message-Id: <20210826130533.149111-1-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Hi all,
This set adds support for vlan multicast options. The feature is
globally controlled by a new bridge option called mcast_vlan_snooping
which is added by patch 01. Then patches 2 and 3 add support for dumping
global vlan options and filtering on vlan id. Patch 04 adds support for
setting global vlan options and then patches 05-16 add all the new
global vlan options, finally patch 17 adds support for dumping vlan
multicast router ports. These options are identical in meaning, names and
functionality as the bridge-wide ones.

All the new vlan global commands are under the global keyword:
 $ bridge vlan global show [ vid VID dev DEVICE ]
 $ bridge vlan global set vid VID dev DEVICE ...

I've added command examples in each commit message. The patch-set is a
bit bigger but the global options follow the same pattern so I don't see
a point in breaking them. All man page descriptions have been taken from
the same current bridge-wide mcast options. The only additional iproute2
change which is left to do is the per-vlan mcast router control which
I'll send separately. Note to properly use this set you'll need the
updated kernel headers where mcast router was moved from a global option
to per-vlan/per-device one (changed uapi enum which was in net-next).

Example:
 # enable vlan mcast snooping globally
 $ ip link set dev bridge type bridge mcast_vlan_snooping 1
 # enable mcast querier on vlan 100
 $ bridge vlan global set dev bridge vid 100 mcast_querier 1
 # show vlan 100's global options
 $ bridge -s vlan global show vid 100
port              vlan-id
bridge            100
                    mcast_snooping 1 mcast_querier 1 mcast_igmp_version 2 mcast_mld_version 1 mcast_last_member_count 2 mcast_last_member_interval 100 mcast_startup_query_count 2 mcast_startup_query_interval 3125 mcast_membership_interval 26000 mcast_querier_interval 25500 mcast_query_interval 12500 mcast_query_response_interval 1000

A following kernel patch-set will add selftests which use these commands.

Thanks,
 Nik

Nikolay Aleksandrov (17):
  ip: bridge: add support for mcast_vlan_snooping
  bridge: vlan: add support to show global vlan options
  bridge: vlan: add support for vlan filtering when dumping options
  bridge: vlan: add support to set global vlan options
  bridge: vlan: add global mcast_snooping option
  bridge: vlan: add global mcast_igmp_version option
  bridge: vlan: add global mcast_mld_version option
  bridge: vlan: add global mcast_last_member_count option
  bridge: vlan: add global mcast_startup_query_count option
  bridge: vlan: add global mcast_last_member_interval option
  bridge: vlan: add global mcast_membership_interval option
  bridge: vlan: add global mcast_querier_interval option
  bridge: vlan: add global mcast_query_interval option
  bridge: vlan: add global mcast_query_response_interval option
  bridge: vlan: add global mcast_startup_query_interval option
  bridge: vlan: add global mcast_querier option
  bridge: vlan: add support for dumping router ports

 bridge/br_common.h    |   4 +-
 bridge/mdb.c          |   6 +-
 bridge/monitor.c      |   2 +-
 bridge/vlan.c         | 546 +++++++++++++++++++++++++++++++++++++-----
 ip/iplink_bridge.c    |  29 +++
 man/man8/bridge.8     | 130 ++++++++++
 man/man8/ip-link.8.in |   8 +
 7 files changed, 659 insertions(+), 66 deletions(-)

-- 
2.31.1

