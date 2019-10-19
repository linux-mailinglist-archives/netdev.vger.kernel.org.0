Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0FC9E955D
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 04:48:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727170AbfJ3Dsd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 23:48:33 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:38935 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727088AbfJ3Dsd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 23:48:33 -0400
Received: by mail-pf1-f196.google.com with SMTP id v4so569047pff.6
        for <netdev@vger.kernel.org>; Tue, 29 Oct 2019 20:48:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=/T/XRYB9s2GEx13IWoOw2ufRUj+YVCEQF7wfiy8lqP8=;
        b=LgJenqYxoGBbfV10FoDEXIqaAu6fQUrIWc1Z+pLMVnl8hc+F0i9dqvI+n1iCLAXCd6
         K0/Nk4SQ72uNoUH2xea+8AfybK0VkQXIXIRkistjTeYamDGWgQzxCZPqjWz7ow4741Ja
         k97L/OxrFc/8qI6bOcLpnlwLOeL5e3hJaRxTiKAtp8uixN8I7KXMN04RnHqf4JHmYmiK
         cwLCHl7DEIe7NaYYRm5nBLLHnsIxikMs+1NmnTb/U+QMONJsyoC0LhuUv9An4n1qkaKe
         AbUPCYlY507Xw8tQkGdsFC1R2SJATph6bkwOuLOEdRfS2efJ5WCHIckB5zoQUp7f3Phi
         20Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=/T/XRYB9s2GEx13IWoOw2ufRUj+YVCEQF7wfiy8lqP8=;
        b=PEDATthALq0jgrYmwXAHkkjw9f7SWHAodGDR+kSbnrH3BRqU0Ghf0iB0y8JZaD4j4h
         l8QFJ62TCeFlLvxlzEBZsCf5QSTgjk8MjpP7sRnOHDtjHRHTaGEHASX/f8XVkrk06RAk
         ba2ocUecS1G5oHGf+eSFD+KSQR3JiF6EFHA4gAxnJ/FNevxmfK37qqCgHNG4m2Ypfgzi
         AkA4tpeE/pbJcf2wx6QGf1Mi9sGBgBiglDLmAnKQgvEyLSvdwjOu/hU3bTqsiU1/8BEK
         5cQ1irwh0bHvzhNNsvA4PlqBaUOT5UZbNicGwr5bIDT+KWA+bFf3WnK0lKm57NhN0t5W
         D/0A==
X-Gm-Message-State: APjAAAWC+EC9taEyHBLoQ1V4pySD/4WYmrkUboVDjRmAyZ2XcRQwXh96
        D2E8Jk8DvSyOtcY0A4Li6IU=
X-Google-Smtp-Source: APXvYqzDyZs/WsqI65MK2nPDn94EZqRoef37F86267PdyFRsQ0iLX8WgPdSrV7NsiH4Iu189oCzMig==
X-Received: by 2002:a17:90a:fa81:: with SMTP id cu1mr11398595pjb.114.1572407312563;
        Tue, 29 Oct 2019 20:48:32 -0700 (PDT)
Received: from local.opencloud.tech.localdomain ([203.100.54.194])
        by smtp.gmail.com with ESMTPSA id l22sm632390pgj.4.2019.10.29.20.48.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 29 Oct 2019 20:48:31 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     gvrose8192@gmail.com, pshelar@ovn.org
Cc:     netdev@vger.kernel.org, dev@openvswitch.org,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH net-next v5 00/10] optimize openvswitch flow looking up
Date:   Sat, 19 Oct 2019 16:08:34 +0800
Message-Id: <1571472524-73832-1-git-send-email-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

This series patch optimize openvswitch for performance or simplify
codes.

Patch 1, 2, 4: Port Pravin B Shelar patches to
linux upstream with little changes.

Patch 5, 6, 7: Optimize the flow looking up and
simplify the flow hash.

Patch 8, 9: are bugfix.

The performance test is on Intel Xeon E5-2630 v4.
The test topology is show as below:

+-----------------------------------+
|   +---------------------------+   |
|   | eth0   ovs-switch    eth1 |   | Host0
|   +---------------------------+   |
+-----------------------------------+
      ^                       |
      |                       |
      |                       |
      |                       |
      |                       v
+-----+----+             +----+-----+
| netperf  | Host1       | netserver| Host2
+----------+             +----------+

We use netperf send the 64B packets, and insert 255+ flow-mask:
$ ovs-dpctl add-flow ovs-switch "in_port(1),eth(dst=00:01:00:00:00:00/ff:ff:ff:ff:ff:01),eth_type(0x0800),ipv4(frag=no)" 2
...
$ ovs-dpctl add-flow ovs-switch "in_port(1),eth(dst=00:ff:00:00:00:00/ff:ff:ff:ff:ff:ff),eth_type(0x0800),ipv4(frag=no)" 2
$
$ netperf -t UDP_STREAM -H 2.2.2.200 -l 40 -- -m 18

* Without series patch, throughput 8.28Mbps
* With series patch, throughput 46.05Mbps

v5:
rewrite patch 8, release flow-mask when freeing flow

v4:
access ma->count with READ_ONCE/WRITE_ONCE API. More information,
see patch 5 comments. 

v3:
update ma point when realloc mask_array in patch 5

v2:
simplify codes. e.g. use kfree_rcu instead of call_rcu

Tonghao Zhang (10):
  net: openvswitch: add flow-mask cache for performance
  net: openvswitch: convert mask list in mask array
  net: openvswitch: shrink the mask array if necessary
  net: openvswitch: optimize flow mask cache hash collision
  net: openvswitch: optimize flow-mask looking up
  net: openvswitch: simplify the flow_hash
  net: openvswitch: add likely in flow_lookup
  net: openvswitch: fix possible memleak on destroy flow-table
  net: openvswitch: don't unlock mutex when changing the user_features
    fails
  net: openvswitch: simplify the ovs_dp_cmd_new

 net/openvswitch/datapath.c   |  65 +++++---
 net/openvswitch/flow.h       |   1 -
 net/openvswitch/flow_table.c | 381 ++++++++++++++++++++++++++++++++++---------
 net/openvswitch/flow_table.h |  19 ++-
 4 files changed, 360 insertions(+), 106 deletions(-)

-- 
1.8.3.1

