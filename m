Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C95ED3E0595
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 18:13:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234054AbhHDQNV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 12:13:21 -0400
Received: from mga12.intel.com ([192.55.52.136]:7118 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232580AbhHDQNS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Aug 2021 12:13:18 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10066"; a="193547271"
X-IronPort-AV: E=Sophos;i="5.84,294,1620716400"; 
   d="scan'208";a="193547271"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2021 09:11:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,294,1620716400"; 
   d="scan'208";a="569083133"
Received: from ccgwwan-adlp1.iind.intel.com ([10.224.174.35])
  by orsmga004.jf.intel.com with ESMTP; 04 Aug 2021 09:11:00 -0700
From:   M Chetan Kumar <m.chetan.kumar@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        krishna.c.sudi@intel.com, linuxwwan@intel.com
Subject: [PATCH 0/4] net: wwan: iosm: fixes
Date:   Wed,  4 Aug 2021 21:39:48 +0530
Message-Id: <20210804160952.70254-1-m.chetan.kumar@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series contains IOSM Driver fixes. Below is the patch
series breakdown.

PATCH1:
* Correct the td buffer type casting & format specifier to fix lkp buildbot
warning.

PATCH2:
* Endianness type correction for nr_of_bytes. This field is exchanged
as part of host-device protocol communication.

PATCH3:
* Correct ul/dl data protocol mask bit to know which protocol capability
does device implement.

PATCH4:
* Calling unregister_netdevice() inside wwan del link is trying to
acquire the held lock in ndo_stop_cb(). Instead, queue net dev to
be unregistered later.

--
M Chetan Kumar (4):
  net: wwan: iosm: fix lkp buildbot warning
  net: wwan: iosm: endianness type correction
  net: wwan: iosm: correct data protocol mask bit
  net: wwan: iosm: fix recursive lock acquire in unregister

 drivers/net/wwan/iosm/iosm_ipc_mmio.h         | 4 ++--
 drivers/net/wwan/iosm/iosm_ipc_mux_codec.c    | 4 ++--
 drivers/net/wwan/iosm/iosm_ipc_mux_codec.h    | 2 +-
 drivers/net/wwan/iosm/iosm_ipc_protocol_ops.c | 4 ++--
 drivers/net/wwan/iosm/iosm_ipc_wwan.c         | 2 +-
 5 files changed, 8 insertions(+), 8 deletions(-)

-- 
2.25.1

