Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 558BF13611E
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 20:33:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730464AbgAITdP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 14:33:15 -0500
Received: from mga05.intel.com ([192.55.52.43]:37095 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730127AbgAITdP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jan 2020 14:33:15 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Jan 2020 11:33:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,414,1571727600"; 
   d="scan'208";a="223970931"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.244.172])
  by orsmga003.jf.intel.com with ESMTP; 09 Jan 2020 11:33:14 -0800
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     valex@mellanox.com, jiri@resnulli.us,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [PATCH v2 0/3] devlink region trigger support
Date:   Thu,  9 Jan 2020 11:33:07 -0800
Message-Id: <20200109193311.1352330-1-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.25.0.rc1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series consists of patches to enable devlink to request a snapshot via
a new DEVLINK_CMD_REGION_TRIGGER_SNAPSHOT.

A reviewer might notice that the devlink health API already has such support
for handling a similar case. However, the health API does not make sense in
cases where the data is not related to an error condition.

In this case, using the health API only for the dumping feels incorrect.
Regions make sense when the addressable content is not captured
automatically on error conditions, but only upon request by the devlink API.

The netdevsim driver is modified to support the new trigger_snapshot
callback as an example of how this can be used.

Jacob Keller (3):
  devlink: add callback to trigger region snapshots
  devlink: introduce command to trigger region snapshot
  netdevsim: support triggering snapshot through devlink

 drivers/net/ethernet/mellanox/mlx4/crdump.c |  4 +-
 drivers/net/netdevsim/dev.c                 | 37 ++++++++++++-----
 include/net/devlink.h                       | 12 ++++--
 include/uapi/linux/devlink.h                |  2 +
 net/core/devlink.c                          | 45 +++++++++++++++++++--
 5 files changed, 80 insertions(+), 20 deletions(-)

-- 
2.25.0.rc1

