Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86CA8273BE0
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 09:30:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729961AbgIVHap (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 03:30:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729634AbgIVHap (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 03:30:45 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3B8AC061755
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 00:30:44 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id x14so15820196wrl.12
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 00:30:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=R19e/SDIADEubNTx0GB7JVrebS4r/Vv0+kckFPzNBdM=;
        b=XZf/UORQfsNsdhHrQ9JxV5JeS8sHGl6RKx1lCKdeA5DdRJghGDMBJ4WTtlix5RxQz6
         6DdYma2rTK1/+v7ArRsQvrQBIYPegqZVMW8kRqjoW+xcI4A0u0mqJdKEvFtOiRWr7UGm
         ZSmqdD6IU4QanGmK5SpgEbFvjnUDp9q2bXLlwwn+CNZeT8uH4GwfiOjgcKfLr+rRgjzJ
         eEexh8w51DkLs9hCzZV1AcF3IhBHcIADOiuLlpMi25LAIxSr+oPatq6gicGV4vsR8F3b
         3tSzV/Vhej+p4hBT9jX5Qx5O7A/QSJcZDLFjoED60hGaSuaip0+wQHN+XtJSjcVDm3kj
         Lhug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=R19e/SDIADEubNTx0GB7JVrebS4r/Vv0+kckFPzNBdM=;
        b=JRWB6Z1RGW4ypq0FPFEQ/SbpHtk7L6mfUKJDJQBGodUWxQAP5i5xBerm2PrVOABt16
         468eIXyMxgLxcDNBkrBhi/RcavauS8xm9SibIC43JBMsR5IEhXjYSv8f61FUL3pi41XC
         ispHxJxNvKrm3G87rHB/3GVvZ7ZX6G8BPbtgeBT2xQerQx7Ry93HKa7dc01sABGv6iPJ
         vyjxl4MEev7xqpuYgpkZQ9OgBwjoXTgfiSVWTloGfLIj4+NGE3FMVmwTRi8WIvRuUgN6
         p/eMZ/IeWHSBs8NFvr6GyLnToqKV0X8fHaKW11MPdtb9uSlMcbdHS/nHS1ocTaHgLRG/
         yRTw==
X-Gm-Message-State: AOAM530FweQBuYW2htP0rJX/nuQojmEaZ1zWrufgH666tUjO5cxmjqko
        HVJFCrjVMiHLa2zjEuwH9dTAfYTKtH2qN4YtFi5sgg==
X-Google-Smtp-Source: ABdhPJyIE2KTIHDWHiNs3tsn5H708o50h8roFen93FtevElwixHhFsLn5DkDd4eKdztctlS92+C+wQ==
X-Received: by 2002:a5d:510d:: with SMTP id s13mr3765431wrt.177.1600759842901;
        Tue, 22 Sep 2020 00:30:42 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id s26sm3258287wmh.44.2020.09.22.00.30.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2020 00:30:42 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, davem@davemloft.net,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next v2 00/16] net: bridge: mcast: IGMPv3/MLDv2 fast-path (part 2)
Date:   Tue, 22 Sep 2020 10:30:11 +0300
Message-Id: <20200922073027.1196992-1-razor@blackwall.org>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Hi,
This is the second part of the IGMPv3/MLDv2 support which adds support
for the fast-path. In order to be able to handle source entries we add
mdb support for S,G entries (i.e. we add source address support to
br_ip), that requires to extend the current mdb netlink API, fortunately
we just add another attribute which will contain nested future mdb
attributes, then we use it to add support for S,G user- add, del and
dump. The lookup sequence is simple: when IGMPv3/MLDv2 are enabled do
the S,G lookup first and if it fails fallback to *,G. The more complex
part is when we begin handling source lists and auto-installing S,G entries
and *,G filter mode transitions. We have the following cases:
 1) *,G INCLUDE -> EXCLUDE transition: we need to install the port in
    all of *,G's installed S,G entries for proper replication (except
    the ones explicitly blocked), this is also necessary when adding a
    new *,G EXCLUDE port group

 2) *,G EXCLUDE -> INCLUDE transition: we need to remove the port from
    all of *,G's installed S,G entries, this is also necessary when
    removing a *,G port group

 3) New S,G port entry: we need to install all current *,G EXCLUDE ports

 4) Remove S,G port entry: if all other port groups were auto-installed we
    can safely remove them and delete the whole S,G entry

Currently we compute these operations from the available ports, their
source lists and their filter mode. In the future we can extend the port
group structure and reduce the running time of these ops. Also one
current limitation is that host-joined S,G entries are not supported.
I.e. one cannot add "dev bridge port bridge" mdb S,G entries. The host
join is currently considered an EXCLUDE {} join, so it's reflected in
all of *,G's installed S,G entries. If an S,G,port entry is added as
temporary then the kernel can take it over if a source shows up from a
report, permanent entries are skipped. In order to properly handle
blocked sources we add a new port group blocked flag to avoid forwarding
to that port group in the S,G. Finally when forwarding we use the port
group filter mode (if it's INCLUDE and the port group is from a *,G then
don't replicate to it, respectively if it's EXCLUDE then forward) and the
blocked flag (obviously if it's set - skip that port unless it's a
router port) to decide if the port should be skipped. Another limitation
is that we can't do some of the above transitions without small traffic
drop while installing/removing entries. That will be taken care of when
we add atomic swap of port replication lists later.

Patch break down:
 patches 1-3: prepare the mdb code for better extack support which is
              used in future patches to return a more meaningful error
 patches 4-6: add the source address field to struct br_ip, and do minor
              cleanups around it
 patches 7-8: extend the mdb netlink API so we can send new mdb
              attributes and uses the new API for S,G entry add/del/dump
              support
 patch     9: takes care of S,G entries when doing a lookup (first S,G
              then *,G lookup)
 patch    10: adds a new port group field and attribute for origin protocol
              we use the already available RTPROT_ definitions,
              currently user-space entries are added as RTPROT_STATIC and
              kernel entries are added as RTPROT_KERNEL, we may allow
              user-space to set custom values later (e.g. for FRR, clag)
 patch    11: adds an internal S,G,port rhashtable to speed up filter
              mode transitions
 patch    12: initial automatic install of S,G entries based on port
              groups' source lists
 patch    13: handles port group modes on transitions or when new
              port group entries are added
 patch    14: self-explanatory - adds support for blocked port group
              entries needed to stop forwarding to particular S,G,port
              entries
 patch    15: handles host-join/leave state changes, treats host-joins
              as EXCLUDE {} groups (reflected in all *,G's S,G entries)
 patch    16: finally adds the fast-path filter mode and block flag
              support

Here're the sets that will come next (in order):
 - iproute2 support for IGMPv3/MLDv2
 - selftests for all mode transitions and group flags
 - explicit host tracking for proper fast-leave support
 - atomic port replication lists (these are also needed for broadcast
   forwarding optimizations)
 - mode transition optimization and removal of open-coded sorted lists

Not implemented yet:
 - Host IGMPv3/MLDv2 filter support (currently we handle only join/leave
   as before)
 - Proper other querier source timer and value updates
 - IGMPv3/v2 MLDv2/v1 compat (I have a few rough patches for this one)

v2: fix build with CONFIG_BATMAN_ADV_MCAST in patch 6

Thanks,
 Nik


Nikolay Aleksandrov (16):
  net: bridge: mdb: use extack in br_mdb_parse()
  net: bridge: mdb: move all port and bridge checks to br_mdb_add
  net: bridge: mdb: use extack in br_mdb_add() and br_mdb_add_group()
  net: bridge: add src field to br_ip
  net: bridge: mcast: use br_ip's src for src groups and querier address
  net: bridge: mcast: rename br_ip's u member to dst
  net: bridge: mdb: add support to extend add/del commands
  net: bridge: mdb: add support for add/del/dump of entries with source
  net: bridge: mcast: when igmpv3/mldv2 are enabled lookup (S,G) first,
    then (*,G)
  net: bridge: mcast: add rt_protocol field to the port group struct
  net: bridge: mcast: add sg_port rhashtable
  net: bridge: mcast: install S,G entries automatically based on reports
  net: bridge: mcast: handle port group filter modes
  net: bridge: mcast: add support for blocked port groups
  net: bridge: mcast: handle host state
  net: bridge: mcast: when forwarding handle filter mode and blocked
    flag

 include/linux/if_bridge.h      |   8 +-
 include/uapi/linux/if_bridge.h |  17 +
 net/batman-adv/multicast.c     |  14 +-
 net/bridge/br_forward.c        |  17 +-
 net/bridge/br_mdb.c            | 371 +++++++++++++-----
 net/bridge/br_multicast.c      | 678 +++++++++++++++++++++++++++------
 net/bridge/br_private.h        |  49 ++-
 7 files changed, 916 insertions(+), 238 deletions(-)

-- 
2.25.4

