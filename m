Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C4B4362517
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 18:07:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239414AbhDPQDT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 12:03:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:35560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236319AbhDPQDS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Apr 2021 12:03:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6F722611C2;
        Fri, 16 Apr 2021 16:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618588973;
        bh=d0zVsPdUX6JTtl14RzHxNdZ8YLgh4eHCpHLH3rMdWnQ=;
        h=From:To:Cc:Subject:Date:From;
        b=Y3khdbKEHr6f9FzAGiFxk9dQk1HWK1uI3a5E205qqPwpzLiM65gFCEXjeTVpo38a8
         icpMnPcRxS8zSPrAioQmCcYNE8KnMDisIJ/CEQbucT6sxly2zBVnm2IaSEYE2qBrEH
         E9AoJVZbadQUIGn4BKcL4iYEcSbub4DC5ZcuWRMpP8lJsk/brqXJPnMF2J6iZuHxk1
         04a4uLdszhMrU7HGV3j6Bl7PvJA7nHlM7l7+geUIb9e6ZVSEa+QdvE2O4DOkNzElbs
         01JjoSx70gxgAIiIbBgM5xYyv5KUZG7C1vs6nH26tySl1Utyoz7j/ZOX6PKuiqICwB
         tyr0b2dffKpxQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     netdev@vger.kernel.org, idosch@nvidia.com
Cc:     mkubecek@suse.cz, Jakub Kicinski <kuba@kernel.org>
Subject: [RFC ethtool 0/6] ethtool: add FEC & std stats support
Date:   Fri, 16 Apr 2021 09:02:46 -0700
Message-Id: <20210416160252.2830567-1-kuba@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sending these as RFC for testing of the kernel side.

I need to look through them again to double check for bugs,
also the header update (patch 1) refers to a hash from my
local tree.

Jakub Kicinski (6):
  update UAPI header copies
  json: simplify array print API
  netlink: add FEC support
  netlink: fec: support displaying statistics
  ethtool: add nlchk for redirecting to netlink
  netlink: add support for standard stats

 Makefile.am                  |   3 +-
 ethtool.8.in                 |  11 ++
 ethtool.c                    |  12 +-
 json_print.c                 |  20 +-
 json_print.h                 |   4 +-
 netlink/desc-ethtool.c       |  51 +++++
 netlink/extapi.h             |  13 +-
 netlink/fec.c                | 356 +++++++++++++++++++++++++++++++++++
 netlink/monitor.c            |   4 +
 netlink/netlink.c            |   9 +-
 netlink/netlink.h            |   1 +
 netlink/stats.c              | 242 ++++++++++++++++++++++++
 uapi/linux/ethtool.h         | 111 +++++++----
 uapi/linux/ethtool_netlink.h | 188 ++++++++++++++++++
 uapi/linux/if_link.h         |   9 +-
 uapi/linux/netlink.h         |   2 +-
 uapi/linux/rtnetlink.h       |  33 +++-
 17 files changed, 1009 insertions(+), 60 deletions(-)
 create mode 100644 netlink/fec.c
 create mode 100644 netlink/stats.c

-- 
2.30.2

