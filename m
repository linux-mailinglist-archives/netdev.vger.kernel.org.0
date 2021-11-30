Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 742E2463FD8
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 22:21:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343972AbhK3VZI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 16:25:08 -0500
Received: from mga03.intel.com ([134.134.136.65]:13461 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344024AbhK3VYj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Nov 2021 16:24:39 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10184"; a="236263988"
X-IronPort-AV: E=Sophos;i="5.87,277,1631602800"; 
   d="scan'208";a="236263988"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2021 13:21:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,277,1631602800"; 
   d="scan'208";a="744895421"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga006.fm.intel.com with ESMTP; 30 Nov 2021 13:21:15 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com
Subject: [PATCH net-next v2 00/10][pull request] 40GbE Intel Wired LAN Driver Updates 2021-11-30
Date:   Tue, 30 Nov 2021 13:19:54 -0800
Message-Id: <20211130212004.198898-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to iavf driver only.

Patryk adds a debug message when MTU is changed.

Grzegorz adds messaging when transitioning in and out of multicast
promiscuous mode.

Jake returns correct error codes for iavf_parse_cls_flower().

Jedrzej adds messaging for when the driver is removed and refactors
struct usage to take less memory. He also adjusts ethtool statistics to
only display information on active queues.

Tony allows for user to specify the RSS hash.

Karen resolves some static analysis warnings, corrects format specifiers,
and rewords a message to come across as informational.
---
v2:
- Dropped patch 1 (for net) and 5
- Change MTU message from info to debug

The following are changes since commit 196073f9c44be0b4758ead11e51bc2875f98df29:
  net: ixp4xx_hss: drop kfree for memory allocated with devm_kzalloc
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 40GbE

Grzegorz Szczurek (1):
  iavf: Log info when VF is entering and leaving Allmulti mode

Jacob Keller (1):
  iavf: return errno code instead of status code

Jedrzej Jagielski (3):
  iavf: Add trace while removing device
  iavf: Refactor iavf_mac_filter struct memory usage
  iavf: Fix displaying queue statistics shown by ethtool

Karen Sornek (3):
  iavf: Fix static code analysis warning
  iavf: Refactor text of informational message
  iavf: Refactor string format to avoid static analysis warnings

Patryk Małek (1):
  iavf: Add change MTU message

Tony Nguyen (1):
  iavf: Enable setting RSS hash key

 drivers/net/ethernet/intel/iavf/iavf.h        | 10 ++--
 .../net/ethernet/intel/iavf/iavf_ethtool.c    | 48 +++++++++++--------
 drivers/net/ethernet/intel/iavf/iavf_main.c   | 29 ++++++-----
 drivers/net/ethernet/intel/iavf/iavf_txrx.c   |  2 +-
 .../net/ethernet/intel/iavf/iavf_virtchnl.c   | 24 ++++++----
 5 files changed, 69 insertions(+), 44 deletions(-)

-- 
2.31.1

