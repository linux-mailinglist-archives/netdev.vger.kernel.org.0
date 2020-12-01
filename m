Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22CF02C948E
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 02:20:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388686AbgLABTd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 20:19:33 -0500
Received: from mga17.intel.com ([192.55.52.151]:30970 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729103AbgLABTd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Nov 2020 20:19:33 -0500
IronPort-SDR: 8AtsTZcyYNEjZdsGices1gIEJBEV+pwm/3PwHVwG12TFm3gYs2VtdVzNU7eRziC08Qpg+fdMXx
 5slXKFiPTqsg==
X-IronPort-AV: E=McAfee;i="6000,8403,9821"; a="152573314"
X-IronPort-AV: E=Sophos;i="5.78,382,1599548400"; 
   d="scan'208";a="152573314"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2020 17:18:53 -0800
IronPort-SDR: zqrZDTpcBY429/48iEvx829mVfItS5dLAJ+RZ+qfqbrJX8xmkv7rTiKJIz8IxntzwfwT4ijMCp
 nens/ksfw/og==
X-IronPort-AV: E=Sophos;i="5.78,382,1599548400"; 
   d="scan'208";a="549340012"
Received: from chenyu-office.sh.intel.com ([10.239.158.173])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2020 17:18:49 -0800
From:   Chen Yu <yu.c.chen@intel.com>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>,
        "Neftin, Sasha" <sasha.neftin@intel.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Brandt, Todd E" <todd.e.brandt@intel.com>,
        Chen Yu <yu.c.chen@intel.com>
Subject: [PATCH 0/2][v3] Put the NIC in runtime suspended during s2ram
Date:   Tue,  1 Dec 2020 09:21:14 +0800
Message-Id: <cover.1606757180.git.yu.c.chen@intel.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The NIC is put in runtime suspend status when there is no cable connected.
As a result, it is safe to keep non-wakeup NIC in runtime suspended during
s2ram because the system does not rely on the NIC plug event nor WoL to wake
up the system. Besides that, unlike the s2idle, s2ram does not need to
manipulate S0ix settings during suspend.

Chen Yu (2):
  e1000e: Leverage direct_complete to speed up s2ram
  e1000e: Remove the runtime suspend restriction on CNP+

 drivers/net/ethernet/intel/e1000e/netdev.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

-- 
2.17.1

