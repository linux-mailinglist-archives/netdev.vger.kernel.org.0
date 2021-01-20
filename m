Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B44BF2FD36A
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 16:08:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732475AbhATOzR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 09:55:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389223AbhATOxo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 09:53:44 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DC1CC061793
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 06:53:04 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id rv9so15132273ejb.13
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 06:53:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wPcMQBvMi4L81CqXqUNlL27DFtJJ6AUlR/ZpxbIsss0=;
        b=d9dH+MgL/izcQtHIuCFBChiqwBlYNEApffYHF+cLXlOytooAGXYMxtjmA20xwvdEkB
         lusAqKqxHmUi59bUm2kcQUXp6oTBfC45O61JXeWJ7KAKNF2ErwcpkwBO73DchKAkBRot
         zXIxH15FOSngpnEBaEWzasfNfb+8zt1oEMte8caWGtKtjVjCRXpWgJFjlc09Kas3zYt9
         WfN/Rb8574+kfRuebMYntF2awBevyY+httkbxKrlLaqUiwSdQ3KOBon8tcqGM77A0A8/
         SSldHu6xC/rZBwtmqj1OQu0Te7m+1i4cOqzzu5CXWSSCZb4xysXtVqgREfR8Qi4a7Q0y
         vgrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wPcMQBvMi4L81CqXqUNlL27DFtJJ6AUlR/ZpxbIsss0=;
        b=pAvb42Cb02OrJFSIV39Xry2Xxi6MHiti8aYStYWEvXLwJzMp2WYSH0BDTefr2AwccJ
         AjBbkJyFK9obAW8n9V2d1wmI0A4XWSBCbcb37DFbWhb43XA9ddODIEB+Gv3BVklAMhsB
         PLEJbMbKYXQhdbq2Psm8TSV7cDsaWWxOImP/YAmwcLvXNNCjzrIl6vL080mF6E4cTvbm
         TYXdIuJI2omphIyo8VyTJ5nv68Fzvdfaza4PDXwktwxeTfCTIm/MxCoQ1VsDuS7Nk2dY
         80XLlqzPw2Rx5JileOvJidgXrTgFGzJu+d+hyQhp57f7gsXL1Flg5nv9NFezSFuWJpOU
         Bb0g==
X-Gm-Message-State: AOAM5300Z2DYJZ+GWieY1WArC4Sm0gcZXvRjPi4X0RrzDsYNmNXKGe0y
        skFdU74H5YQJ3e+qzlc+NiucvXe6sEAwBvwTVt4=
X-Google-Smtp-Source: ABdhPJwfnuWxdwtTZSD4VbwPBqdodewMrp9L977O+krdOkQCNs75p1aDh7VM2tT7lT5gsRdVz6IGEw==
X-Received: by 2002:a17:906:4d19:: with SMTP id r25mr6166680eju.148.1611154382405;
        Wed, 20 Jan 2021 06:53:02 -0800 (PST)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id x17sm1239349edq.77.2021.01.20.06.53.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 06:53:01 -0800 (PST)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        kuba@kernel.org, davem@davemloft.net,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 00/14] net: bridge: multicast: add initial EHT support
Date:   Wed, 20 Jan 2021 16:51:49 +0200
Message-Id: <20210120145203.1109140-1-razor@blackwall.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Hi,
This set adds explicit host tracking support for IGMPv3/MLDv2. The
already present per-port fast leave flag is used to enable it since that
is the primary goal of EHT, to track a group and its S,Gs usage per-host
and when left without any interested hosts delete them before the standard
timers. The EHT code is pretty self-contained and not enabled by default.
There is no new uAPI added, all of the functionality is currently hidden
behind the fast leave flag. In the future that will change (more below).
The host tracking uses two new sets per port group: one having an entry for
each host which contains that host's view of the group (source list and
filter mode), and one set which contains an entry for each source having
an internal set which contains an entry for each host that has reported
an interest for that source. RB trees are used for all sets so they're
compact when not used and fast when we need to do lookups.
To illustrate it:
 [ bridge port group ]
  ` [ host set (rb) ]
   ` [ host entry with a list of sources and filter mode ]
  ` [ source set (rb) ]
   ` [ source entry ]
    ` [ source host set (rb) ]
     ` [ source host entry with a timer ]

The number of tracked sources per host is limited to the maximum total
number of S,G entries per port group - PG_SRC_ENT_LIMIT (currently 32).
The number of hosts is unlimited, I think the argument that a local
attacker can exhaust the memory/cause high CPU usage can be applied to
fdb entries as well which are unlimited. In the future if needed we can
add an option to limit these, but I don't think it's necessary for a
start. All of the new sets are protected by the bridge's multicast lock.
I'm pretty sure we'll be changing the cases and improving the
convergence time in the future, but this seems like a good start.

I'll post self-tests as a separate patch-set.

Patch breakdown:
 patch 1 -  4: minor cleanups and preparations for EHT
 patch      5: adds the new structures which will be used in the
               following patches
 patch      6: adds support to create, destroy and lookup host entries
 patch      7: adds support to create, delete and lokup source set entries
 patch      8: adds a host "delete" function which is just a host's
               source list flush since that would automatically delete
               the host
 patch 9 - 10: add support for handling all IGMPv3/MLDv2 report types
               more information can be found in the individual patches
 patch     11: optmizes a specific TO_INCLUDE use-case with host timeouts
 patch     12: handles per-host filter mode changing (include <-> exclude)
 patch     13: pulls out block group deletion since now it can be
               deleted in both filter modes
 patch     14: marks deletions done due to fast leave

Future plans:
 - export host information
 - add an option to reduce queries
 - add an option to limit the number of host entries
 - tune more fast leave cases for quicker convergence

By the way I think this is the first open-source EHT implementation, I
couldn't find any while researching it. :)

Thanks,
 Nik


Nikolay Aleksandrov (14):
  net: bridge: multicast: rename src_size to addr_size
  net: bridge: multicast: pass host src address to IGMPv3/MLDv2
    functions
  net: bridge: multicast: __grp_src_block_incl can modify pg
  net: bridge: multicast: calculate idx position without changing ptr
  net: bridge: multicast: add EHT structures and definitions
  net: bridge: multicast: add EHT host handling functions
  net: bridge: multicast: add EHT source set handling functions
  net: bridge: multicast: add EHT host delete function
  net: bridge: multicast: add EHT allow/block handling
  net: bridge: multicast: add EHT include and exclude handling
  net: bridge: multicast: optimize TO_INCLUDE EHT timeouts
  net: bridge: multicast: add EHT host filter_mode handling
  net: bridge: multicast: handle block pg delete for all cases
  net: bridge: multicast: mark IGMPv3/MLDv2 fast-leave deletes

 net/bridge/Makefile               |   2 +-
 net/bridge/br_multicast.c         | 254 +++++----
 net/bridge/br_multicast_eht.c     | 856 ++++++++++++++++++++++++++++++
 net/bridge/br_private.h           |   6 +
 net/bridge/br_private_mcast_eht.h |  65 +++
 5 files changed, 1093 insertions(+), 90 deletions(-)
 create mode 100644 net/bridge/br_multicast_eht.c
 create mode 100644 net/bridge/br_private_mcast_eht.h

-- 
2.29.2

