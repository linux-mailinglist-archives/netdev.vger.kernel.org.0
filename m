Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB87836C8BF
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 17:35:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238727AbhD0Pgc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 11:36:32 -0400
Received: from mx0.infotecs.ru ([91.244.183.115]:56210 "EHLO mx0.infotecs.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236254AbhD0Pgb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Apr 2021 11:36:31 -0400
Received: from mx0.infotecs-nt (localhost [127.0.0.1])
        by mx0.infotecs.ru (Postfix) with ESMTP id 67595108A04B;
        Tue, 27 Apr 2021 18:35:43 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx0.infotecs.ru 67595108A04B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=infotecs.ru; s=mx;
        t=1619537743; bh=KxbNYGfPwQJcQ49DgL87484lXfDTpag3H+aJRE9b52A=;
        h=Date:From:To:CC:Subject:From;
        b=i8CVO9rhOWeVh49XeEzit6nvpzMcwRong51cFMxFHl6ieEKJnVh4YpJIhpxmAIob0
         nx3DnpvxwEqzgiHPsRAh3LFwQbuB3txPz4t7LC4qdVbeKheniNNL1iC3WOhQvq+SKB
         OB61Bzcs3E8wer6D85LNFa59UDI/nkAYnO7DP0Oo=
Received: from msk-exch-02.infotecs-nt (autodiscover.iitrust.ru [10.0.7.192])
        by mx0.infotecs-nt (Postfix) with ESMTP id 647D4316F917;
        Tue, 27 Apr 2021 18:35:43 +0300 (MSK)
Date:   Tue, 27 Apr 2021 18:33:54 +0300
From:   Pavel Balaev <balaevpa@infotecs.ru>
To:     <netdev@vger.kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH v5 net-next 0/3] net: multipath routing: configurable seed
Message-ID: <YIgu4hLNSa69/oFZ@rnd>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
X-Originating-IP: [11.0.8.107]
X-EXCLAIMER-MD-CONFIG: 208ac3cd-1ed4-4982-a353-bdefac89ac0a
X-KLMS-Rule-ID: 1
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Lua-Profiles: 163354 [Apr 27 2021]
X-KLMS-AntiSpam-Version: 5.9.20.0
X-KLMS-AntiSpam-Envelope-From: BalaevPA@infotecs.ru
X-KLMS-AntiSpam-Rate: 0
X-KLMS-AntiSpam-Status: not_detected
X-KLMS-AntiSpam-Method: none
X-KLMS-AntiSpam-Auth: dkim=none
X-KLMS-AntiSpam-Info: LuaCore: 443 443 d64ad0ad6f66abd85f8fb55fe5d831fdcc4c44a0, {Tracking_uf_ne_domains}, {Tracking_from_domain_doesnt_match_to}
X-MS-Exchange-Organization-SCL: -1
X-KLMS-AntiSpam-Interceptor-Info: scan successful
X-KLMS-AntiPhishing: Clean, bases: 2021/04/27 12:22:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/04/27 11:47:00 #16580367
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is the fifth version of the mpath seed series.

This patch series adds ability for a user to assign seed value
to multipath route hashes.

changes v4:
- patch was splited to patch series
- remove CONFIG_IP_ROUTE_MULTIPATH define from flow_multipath_hash_from_keys(),
  it used in both IPv4/IPv6 protos.

The mainlining discussion history of this branch:
v4: https://lore.kernel.org/netdev/21a2fb1925b215cc48ab8e2f783a7de7@void.so

Balaev Pavel (3):
      net/ipv4: multipath routing: configurable seed
      net/ipv6: multipath routing: configurable seed
      selftests/net/forwarding: configurable seed tests

 Documentation/networking/ip-sysctl.rst             |  14 +
 include/net/flow_dissector.h                       |   2 +
 include/net/netns/ipv4.h                           |   2 +
 include/net/netns/ipv6.h                           |   3 +
 net/core/flow_dissector.c                          |   7 +
 net/ipv4/route.c                                   |  10 +-
 net/ipv4/sysctl_net_ipv4.c                         |  97 ++++++
 net/ipv6/route.c                                   |  10 +-
 net/ipv6/sysctl_net_ipv6.c                         |  96 ++++++
 tools/testing/selftests/net/forwarding/Makefile    |   1 +
 tools/testing/selftests/net/forwarding/lib.sh      |  28 ++
 .../net/forwarding/router_mpath_seed.sh (new +x)   | 347 +++++++++++++++++++++
 12 files changed, 615 insertions(+), 2 deletions(-)
