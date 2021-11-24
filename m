Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFBEE45CAF1
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 18:25:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242752AbhKXR2h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 12:28:37 -0500
Received: from mga07.intel.com ([134.134.136.100]:35647 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234770AbhKXR2g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 12:28:36 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10178"; a="298734815"
X-IronPort-AV: E=Sophos;i="5.87,260,1631602800"; 
   d="scan'208";a="298734815"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2021 09:18:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,260,1631602800"; 
   d="scan'208";a="597738870"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga002.fm.intel.com with ESMTP; 24 Nov 2021 09:18:09 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com
Subject: [PATCH net-next 00/12][pull request] 40GbE Intel Wired LAN Driver Updates 2021-11-24
Date:   Wed, 24 Nov 2021 09:16:40 -0800
Message-Id: <20211124171652.831184-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to iavf driver only.

Mitch adds restoration of MSI state during reset and reduces the log
level on a couple messages.

Patryk adds an info message when MTU is changed.

Grzegorz adds messaging when transitioning in and out of multicast
promiscuous mode.

Jake returns correct error codes for iavf_parse_cls_flower().

Jedrzej adds messaging for when the driver is removed and refactors
struct usage to take less memory. He also adjusts ethtool statistics to
only display information on active queues.

Tony allows for user to specify the RSS hash.

Karen resolves some static analysis warnings, corrects format specifiers,
and rewords a message to come across as informational.

The following are changes since commit d156250018ab5adbcfcc9ea90455d5fba5df6769:
  Merge branch 'hns3-next'
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

Mitch Williams (2):
  iavf: restore MSI state on reset
  iavf: don't be so alarming

Patryk Małek (1):
  iavf: Add change MTU message

Tony Nguyen (1):
  iavf: Enable setting RSS hash key

 drivers/net/ethernet/intel/iavf/iavf.h        | 10 ++--
 .../net/ethernet/intel/iavf/iavf_ethtool.c    | 48 +++++++++++--------
 drivers/net/ethernet/intel/iavf/iavf_main.c   | 32 +++++++------
 drivers/net/ethernet/intel/iavf/iavf_txrx.c   |  2 +-
 .../net/ethernet/intel/iavf/iavf_virtchnl.c   | 28 +++++++----
 5 files changed, 73 insertions(+), 47 deletions(-)

-- 
2.31.1

