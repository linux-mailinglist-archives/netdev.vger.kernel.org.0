Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4F3D3CE839
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 19:27:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353265AbhGSQjV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 12:39:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355596AbhGSQg0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 12:36:26 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BEA0C04F95B
        for <netdev@vger.kernel.org>; Mon, 19 Jul 2021 09:49:43 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id v1so24953546edt.6
        for <netdev@vger.kernel.org>; Mon, 19 Jul 2021 10:09:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hCwCFJ1+trCTxtyY5c2JV6920R4rE/IWrnFMqMl4GWo=;
        b=YzzyiOCo0H8SkPJ2eAjW8nucLWYg0LWlYhln2BRJaBlR3kkC+zsL0nAGG7Wn476dIE
         mVJgrjVfMaWt4d2l5AeTRkwjHle82IwiASWbNrvFUr0QIARBsYiRFP5K+49RDslxd8Rs
         PI+6a/8d8ZpAFsBWJuSVCvuSg/3gT2SH9ap6Dy55Ku2Wa6dqJYXj5+Q8XEUs8N+UlmWB
         PZ+KZVrApWnk/8HcMHqyakEOLM1jj/OKJBmag5ZsV24HTUSUQ6vjPNb3QLXjRgL1yPrn
         MkMF/nABewbQYF/Je4+8/illMSOMde8WhrMv08ZrrefMuz7/oa0GNPRklNgxOmQ19P8u
         ZN9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hCwCFJ1+trCTxtyY5c2JV6920R4rE/IWrnFMqMl4GWo=;
        b=A0cjDtdQSJzVhD2o01W29WlVPIbYeFF7PK3LxCmTBpgSP4VbN1qeTKpBvkeg//ubfw
         KBxEgauaI6mJkSSgvKInLh/gCxb8LHvjnbbm99vDn817X6v9JJR+5NC/XsBhTi34sW2x
         ji/baXMt9dNvWexYud8GmXgV0e6+3wfxrC3j+R33CPXTo+qTi8T5U+4PFHZK+b7UOHog
         4lcO0RMqwnS+bPwT0K/q3dA20TxC1nSb3VV4ngLmAfRAAXX6NzPcdH5QjlhGXLToWeAc
         7VFxWumEOPMfrnxSxQxFOhAp/MhJAaDJ86eVSh86Ms4jjq4yA8/DXyCjivHpKgMldAWV
         rikg==
X-Gm-Message-State: AOAM532LvJkXH1YTSvR8h3HH+RDoitZYpXh5Wx2pqSOjY1lus1wHdizG
        w2gzj34NOO74UWdXv02Xn93dfMWvyYJevndSn3w=
X-Google-Smtp-Source: ABdhPJwL8S8WCknZyYA9MYa2c3vjo3kR5Nk9as8CB5JC8cM/eyKmK9+uoO3mDj/PRxX06cNRsIRFlw==
X-Received: by 2002:a50:9d8d:: with SMTP id w13mr35970596ede.94.1626714596270;
        Mon, 19 Jul 2021 10:09:56 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id nc29sm6073896ejc.10.2021.07.19.10.09.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jul 2021 10:09:55 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 00/15] net: bridge: multicast: add vlan support
Date:   Mon, 19 Jul 2021 20:06:22 +0300
Message-Id: <20210719170637.435541-1-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Hi all,
This patchset adds initial per-vlan multicast support, most of the code
deals with moving to multicast context pointers from bridge/port pointers.
That allows us to switch them with the per-vlan contexts when a multicast
packet is being processed and vlan multicast snooping has been enabled.
That is controlled by a global bridge option added in patch 06 which is
off by default (BR_BOOLOPT_MCAST_VLAN_SNOOPING). It is important to note
that this option can change only under RTNL and doesn't require
multicast_lock, so we need to be careful when retrieving mcast contexts
in parallel. For packet processing they are switched only once in
br_multicast_rcv() and then used until the packet has been processed.
For the most part we need these contexts only to read config values and
check if they are disabled. The global mcast state which is maintained
consists of querier and router timers, the rest are config options.
The port mcast state which is maintained consists of query timer and
link to router port list if it's ever marked as a router port. Port
multicast contexts _must_ be used only with their respective global
contexts, that is a bridge port's mcast context must be used only with
bridge's global mcast context and a vlan/port's mcast context must be
used only with that vlan's global mcast context due to the router port
lists. This way a bridge port can be marked as a router in multiple
vlans, but might not be a router in some other vlan. Also this allows us
to have per-vlan querier elections, per-vlan queries and basically the
whole multicast state becomes per-vlan when the option is enabled.
One of the hardest parts is synchronization with vlan's memory
management, that is done through a new vlan flag: BR_VLFLAG_MCAST_ENABLED
which is changed only under multicast_lock. When a vlan is being
destroyed first that flag is removed under the lock, then the multicast
context is torn down which includes waiting for any outstanding context
timers. Since all of the vlan processing depends on BR_VLFLAG_MCAST_ENABLED
it must be checked first if the contexts are vlan and the multicast_lock
has been acquired. That is done by all IGMP/MLD packet processing
functions and timers. When processing a packet we have RCU so the vlan
memory won't be freed, but if the flag is missing we must not process it.
The timers are synchronized in the same way with the addition of waiting
for them to finish in case they are running after removing the flag
under multicast_lock (i.e. they were waiting for the lock). Multicast vlan
snooping requires vlan filtering to be enabled, if it's disabled then
snooping gets automatically disabled, too. BR_VLFLAG_GLOBAL_MCAST_ENABLED
controls if a vlan has BR_VLFLAG_MCAST_ENABLED set which is used in all
vlan disabled checks. We need both flags because one is controlled by
user-space globally (BR_VLFLAG_GLOBAL_MCAST_ENABLED) and the other is
for a particular bridge/vlan or port/vlan entry (BR_VLFLAG_MCAST_ENABLED).
Since the latter is also used for synchronization between the multicast
and vlan code, and also controlled by BR_VLFLAG_GLOBAL_MCAST_ENABLED we
rely on it when checking if a vlan context is disabled. The multicast
fast-path has 3 new bit tests on the cache-hot bridge flags field, I
didn't observe any measurable difference. I haven't forced either
context options to be always disabled when the other type is enabled
because the state consists of timers which either expire (router) or
don't affect the normal operation. Some options, like the mcast querier
one, won't be allowed to change for the disabled context type, that will
come with a future patch-set which adds per-vlan querier control.

Another important addition is the global vlan options, so far we had
only per bridge/port vlan options but in order to control vlan multicast
snooping globally we need to add a new type of global vlan options.
They can be changed only on the bridge device and are dumped only when a
special flag is set in the dump request. The first global option is vlan
mcast snooping control, it controls the vlan BR_VLFLAG_GLOBAL_MCAST_ENABLED
private flag. It can be set only on master vlan entries. There will be
many more global vlan options in the future both for multicast config
and other per-vlan options (e.g. STP).

There's a lot of room for improvements, I'll do some of the initial
ones but splitting the state to different contexts opens the door
for a lot more. Also any new multicast options become vlan-supported with
very little to no effort by using the same contexts.

Short patch description:
  patches 01-04: initial mcast context add, no functional changes
  patch      05: adds vlan mcast init and control helpers and uses them on
                 vlan create/destroy
  patch      06: adds a global bridge mcast vlan snooping knob (default
                 off)
  patches 07-08: add a helper for users which must derive the contexts
                 based on current bridge and vlan options (e.g. timers)
  patch      09: adds checks for disabled vlan contexts in packet
                 processing and timers
  patch      10: adds support for per-vlan querier and tagged queries
  patch      11: adds router port vlan id in the notifications
  patches 12-14: add global vlan options support (change, dump, notify)
  patch      15: adds per-vlan global mcast snooping control

Future patch-sets which build on this one (in order):
 - vlan state mcast handling
 - user-space mdb contexts (currently only the bridge contexts are used
   there)
 - all bridge multicast config options added per-vlan global and per
   vlan/port
 - iproute2 support for all the new uAPIs
 - selftests

This set has been stress-tested (deleting/adding ports/vlans while changing
vlan mcast snooping while processing IGMP/MLD packets), and also has
passed all bridge self-tests. I'm sending this set as early as possible
since there're a few more related sets that should go in the same
release to get proper and full mcast vlan snooping support.

Thanks,
 Nik

Nikolay Aleksandrov (15):
  net: bridge: multicast: factor out port multicast context
  net: bridge: multicast: factor out bridge multicast context
  net: bridge: multicast: use multicast contexts instead of bridge or
    port
  net: bridge: vlan: add global and per-port multicast context
  net: bridge: multicast: add vlan state initialization and control
  net: bridge: add vlan mcast snooping knob
  net: bridge: multicast: add helper to get port mcast context from port
    group
  net: bridge: multicast: use the port group to port context helper
  net: bridge: multicast: check if should use vlan mcast ctx
  net: bridge: multicast: add vlan querier and query support
  net: bridge: multicast: include router port vlan id in notifications
  net: bridge: vlan: add support for global options
  net: bridge: vlan: add support for dumping global vlan options
  net: bridge: vlan: notify when global options change
  net: bridge: vlan: add mcast snooping control

 include/uapi/linux/if_bridge.h    |   18 +
 net/bridge/br.c                   |    9 +-
 net/bridge/br_device.c            |   14 +-
 net/bridge/br_forward.c           |    7 +-
 net/bridge/br_input.c             |   17 +-
 net/bridge/br_mdb.c               |   64 +-
 net/bridge/br_multicast.c         | 1656 ++++++++++++++++++-----------
 net/bridge/br_multicast_eht.c     |   92 +-
 net/bridge/br_netlink.c           |   41 +-
 net/bridge/br_private.h           |  355 +++++--
 net/bridge/br_private_mcast_eht.h |    3 +-
 net/bridge/br_sysfs_br.c          |   38 +-
 net/bridge/br_sysfs_if.c          |    2 +-
 net/bridge/br_vlan.c              |   85 +-
 net/bridge/br_vlan_options.c      |  216 ++++
 15 files changed, 1791 insertions(+), 826 deletions(-)

-- 
2.31.1

