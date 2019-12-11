Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92B7811A861
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 10:58:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728441AbfLKJ6Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 04:58:16 -0500
Received: from mx2.suse.de ([195.135.220.15]:58136 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727493AbfLKJ6P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Dec 2019 04:58:15 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B4972AC46;
        Wed, 11 Dec 2019 09:58:13 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 73A45E00B7; Wed, 11 Dec 2019 10:58:09 +0100 (CET)
Message-Id: <cover.1576057593.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net-next v3 0/5] ethtool netlink interface, preliminary part
To:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@resnulli.us>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Date:   Wed, 11 Dec 2019 10:58:09 +0100 (CET)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As Jakub Kicinski suggested in ethtool netlink v7 discussion, this
submission consists only of preliminary patches which raised no objections;
first four patches already have Acked-by or Reviewed-by.

- patch 1 exposes permanent hardware address (as shown by "ethtool -P")
  via rtnetlink
- patch 2 is renames existing netlink helper to a better name
- patch 3 and 4 reorganize existing ethtool code (no functional change)
- patch 5 makes the table of link mode names available as an ethtool string
  set (will be needed for the netlink interface) 

Once we get these out of the way, v8 of the first part of the ethtool
netlink interface will follow.

Changes from v2 to v3: fix SPDX licence identifiers (patch 3 and 5).

Changes from v1 to v2: restore build time check that all link modes have
assigned a name (patch 5).

Michal Kubecek (5):
  rtnetlink: provide permanent hardware address in RTM_NEWLINK
  netlink: rename nl80211_validate_nested() to nla_validate_nested()
  ethtool: move to its own directory
  ethtool: move string arrays into common file
  ethtool: provide link mode names as a string set

 include/net/netlink.h                   |   8 +-
 include/uapi/linux/ethtool.h            |   2 +
 include/uapi/linux/if_link.h            |   1 +
 net/Makefile                            |   2 +-
 net/core/Makefile                       |   2 +-
 net/core/rtnetlink.c                    |   5 +
 net/ethtool/Makefile                    |   3 +
 net/ethtool/common.c                    | 171 ++++++++++++++++++++++++
 net/ethtool/common.h                    |  22 +++
 net/{core/ethtool.c => ethtool/ioctl.c} |  90 ++-----------
 net/wireless/nl80211.c                  |   3 +-
 11 files changed, 219 insertions(+), 90 deletions(-)
 create mode 100644 net/ethtool/Makefile
 create mode 100644 net/ethtool/common.c
 create mode 100644 net/ethtool/common.h
 rename net/{core/ethtool.c => ethtool/ioctl.c} (95%)

-- 
2.24.0

