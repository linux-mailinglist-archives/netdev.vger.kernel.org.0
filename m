Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E6012C4E98
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 07:13:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387927AbgKZGLr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 01:11:47 -0500
Received: from mga01.intel.com ([192.55.52.88]:59749 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387921AbgKZGLr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Nov 2020 01:11:47 -0500
IronPort-SDR: zZxke9gh5hAe9N2PXThhDYNbCWBmjMvkbEheF3Ay9dGNQhAubpI7a3o1lraKZMK0HizEVzC7YE
 BEAIb9ZB88Rg==
X-IronPort-AV: E=McAfee;i="6000,8403,9816"; a="190393962"
X-IronPort-AV: E=Sophos;i="5.78,371,1599548400"; 
   d="scan'208";a="190393962"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2020 22:11:46 -0800
IronPort-SDR: 893mHxJcA455TipXEsGTdeKtbsvIEv85A/a3VnVVRKzSrT9NQ2hf9L9qYUn9V5JtIkB6MPEpLl
 tgjjdMHD6MnA==
X-IronPort-AV: E=Sophos;i="5.78,371,1599548400"; 
   d="scan'208";a="547588513"
Received: from chenyu-office.sh.intel.com ([10.239.158.173])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2020 22:11:43 -0800
From:   Chen Yu <yu.c.chen@intel.com>
To:     "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        "Kai-Heng Feng" <kai.heng.feng@canonical.com>
Cc:     linux-pm@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Sasha Neftin <sasha.neftin@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Chen Yu <yu.c.chen@intel.com>
Subject: [PATCH 0/2][v2] Leverage runtime suspend to speed up the s2ram on e1000e
Date:   Thu, 26 Nov 2020 14:14:15 +0800
Message-Id: <cover.1606370334.git.yu.c.chen@intel.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The NIC is put in runtime suspend status when there is no cable connected.
As a result, it is safe to keep non-wakeup NIC in runtime suspended during
s2ram because the system does not rely on the NIC plug event nor WoL to wake
up the system. After doing this, the s2ram could speed up the suspend/resume
process a lot.

Chen Yu (2):
  e1000e: Assign DPM_FLAG_SMART_SUSPEND and DPM_FLAG_MAY_SKIP_RESUME to
    speed up s2ram
  e1000e: Remove the runtime suspend restriction on CNP+

 drivers/base/power/main.c                  |  2 ++
 drivers/net/ethernet/intel/e1000e/netdev.c | 21 +++++++++++++++++++--
 2 files changed, 21 insertions(+), 2 deletions(-)

-- 
2.17.1

