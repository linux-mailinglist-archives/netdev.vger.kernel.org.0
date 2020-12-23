Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A63E72E22CC
	for <lists+netdev@lfdr.de>; Thu, 24 Dec 2020 00:38:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727832AbgLWXh1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 18:37:27 -0500
Received: from mga03.intel.com ([134.134.136.65]:27330 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727056AbgLWXh0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Dec 2020 18:37:26 -0500
IronPort-SDR: Pnj5CbThPRKBd93gqPTE9zk1yoT3DacXg/rje8gZzSR5VonGQaSG4kH1m6sVwq/5PsR2XoCJj7
 V6CElJGSnLGw==
X-IronPort-AV: E=McAfee;i="6000,8403,9844"; a="176184740"
X-IronPort-AV: E=Sophos;i="5.78,443,1599548400"; 
   d="scan'208";a="176184740"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Dec 2020 15:36:28 -0800
IronPort-SDR: zc+vvYe+cV5gm+iMnd/HX/H+Wc/eWW1tlgvAsfOu1G+Xhl7WGScmjP8svrBc+pL8xZTeR3ab15
 xgd14bbPaB0w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,443,1599548400"; 
   d="scan'208";a="345253122"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga008.fm.intel.com with ESMTP; 23 Dec 2020 15:36:28 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, alexander.duyck@gmail.com,
        sasha.neftin@intel.com, darcari@redhat.com, Yijun.Shen@dell.com,
        Perry.Yuan@dell.com, anthony.wong@canonical.com,
        hdegoede@redhat.com, mario.limonciello@dell.com
Subject: [net 0/4][pull request] Intel Wired LAN Driver Updates 2020-12-23
Date:   Wed, 23 Dec 2020 15:36:21 -0800
Message-Id: <20201223233625.92519-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit e086ba2fccda ("e1000e: disable s0ix entry and exit flows for ME
systems") disabled S0ix flows for systems that have various incarnations of
the i219-LM ethernet controller.  This was done because of some regressions
caused by an earlier commit 632fbd5eb5b0e ("e1000e: fix S0ix flows for
cable connected case") with i219-LM controller.

Per discussion with Intel architecture team this direction should be
changed and allow S0ix flows to be used by default.  This patch series
includes directional changes for their conclusions in
https://lkml.org/lkml/2020/12/13/15.

The following are changes since commit 1f45dc22066797479072978feeada0852502e180:
  ibmvnic: continue fatal error reset after passive init
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 1GbE

Mario Limonciello (4):
  e1000e: Only run S0ix flows if shutdown succeeded
  e1000e: bump up timeout to wait when ME un-configures ULP mode
  Revert "e1000e: disable s0ix entry and exit flows for ME systems"
  e1000e: Export S0ix flags to ethtool

 drivers/net/ethernet/intel/e1000e/e1000.h   |  1 +
 drivers/net/ethernet/intel/e1000e/ethtool.c | 46 ++++++++++++++++
 drivers/net/ethernet/intel/e1000e/ich8lan.c | 17 ++++--
 drivers/net/ethernet/intel/e1000e/netdev.c  | 59 ++++-----------------
 4 files changed, 71 insertions(+), 52 deletions(-)

-- 
2.26.2

