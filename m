Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 658AC1E703A
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 01:21:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437486AbgE1XVL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 19:21:11 -0400
Received: from mx2.suse.de ([195.135.220.15]:48980 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437469AbgE1XVK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 19:21:10 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 7E257AFDC;
        Thu, 28 May 2020 23:21:07 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 9E392E32D2; Fri, 29 May 2020 01:21:07 +0200 (CEST)
Message-Id: <cover.1590707335.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH ethtool 00/21] netlink interface update for 5.7 release
To:     John Linville <linville@tuxdriver.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Oleksij Rempel <o.rempel@pengutronix.de>
Date:   Fri, 29 May 2020 01:21:07 +0200 (CEST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds supports for netlink interface features supported in
kernel 5.7:

  - get/set netdev features (-k / -K)
  - get/set device private flags (--show-priv-flags / --set-priv-flags)
  - get/set ring sizes (-g / -G)
  - get/set channel counts (-l / -L)
  - get/set coalescing parameters (-c / -C)
  - get/set pause parameters (-a / -A)
  - get/set EEE settings (--show-eee / --set-eee)
  - get timestamping information (-T)
 
First three patches fix bugs found in existing code.

Michal Kubecek (21):
  netlink: fix build warnings
  netlink: fix nest type grouping in parser
  netlink: fix msgbuff_append() helper
  update UAPI header copies
  netlink: add more ethtool netlink message format descriptions
  selftest: omit test-features if netlink is enabled
  netlink: add netlink handler for gfeatures (-k)
  netlink: add netlink handler for sfeatures (-K)
  netlink: add netlink handler for gprivflags (--show-priv-flags)
  netlink: add netlink handler for sprivflags (--set-priv-flags)
  netlink: add netlink handler for gring (-g)
  netlink: add netlink handler for sring (-G)
  netlink: add netlink handler for gchannels (-l)
  netlink: add netlink handler for schannels (-L)
  netlink: add netlink handler for gcoalesce (-c)
  netlink: add netlink handler for scoalesce (-C)
  netlink: add netlink handler for gpause (-a)
  netlink: add netlink handler for spause (-A)
  netlink: add netlink handler for geee (--show-eee)
  netlink: add netlink handler for seee (--set-eee)
  netlink: add netlink handler for tsinfo (-T)

 Makefile.am                  |  11 +-
 common.c                     |  30 ++
 common.h                     |  19 ++
 ethtool.c                    |  79 ++----
 netlink/bitset.c             |  31 +++
 netlink/bitset.h             |   2 +
 netlink/channels.c           | 141 ++++++++++
 netlink/coalesce.c           | 269 ++++++++++++++++++
 netlink/desc-ethtool.c       | 129 ++++++++-
 netlink/eee.c                | 189 +++++++++++++
 netlink/extapi.h             |  30 ++
 netlink/features.c           | 526 +++++++++++++++++++++++++++++++++++
 netlink/monitor.c            |  56 ++++
 netlink/msgbuff.c            |   1 +
 netlink/netlink.h            |  46 +++
 netlink/parser.c             |  10 +-
 netlink/pause.c              | 222 +++++++++++++++
 netlink/privflags.c          | 158 +++++++++++
 netlink/rings.c              | 141 ++++++++++
 netlink/settings.c           |  17 +-
 netlink/tsinfo.c             | 124 +++++++++
 uapi/linux/ethtool.h         |   9 +-
 uapi/linux/ethtool_netlink.h | 175 ++++++++++++
 uapi/linux/if_link.h         |   6 +-
 uapi/linux/net_tstamp.h      |   6 +
 25 files changed, 2347 insertions(+), 80 deletions(-)
 create mode 100644 netlink/channels.c
 create mode 100644 netlink/coalesce.c
 create mode 100644 netlink/eee.c
 create mode 100644 netlink/features.c
 create mode 100644 netlink/pause.c
 create mode 100644 netlink/privflags.c
 create mode 100644 netlink/rings.c
 create mode 100644 netlink/tsinfo.c

-- 
2.26.2

