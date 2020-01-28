Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1561414C3BC
	for <lists+netdev@lfdr.de>; Wed, 29 Jan 2020 00:51:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726444AbgA1XvP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jan 2020 18:51:15 -0500
Received: from mga01.intel.com ([192.55.52.88]:42267 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726293AbgA1XvP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jan 2020 18:51:15 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 Jan 2020 15:51:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,375,1574150400"; 
   d="scan'208";a="277321920"
Received: from vcostago-desk1.jf.intel.com ([10.54.70.26])
  by FMSMGA003.fm.intel.com with ESMTP; 28 Jan 2020 15:51:15 -0800
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, davem@davemloft.net,
        vladimir.oltean@nxp.com, po.liu@nxp.com
Subject: [PATCH net v2 0/3] taprio: Some fixes
Date:   Tue, 28 Jan 2020 15:52:24 -0800
Message-Id: <20200128235227.3942256-1-vinicius.gomes@intel.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Changes from v1:
  - Fixed ignoring the 'flags' argument when adding a new
    instance (Vladimir Oltean);
  - Changed the order of commits;

Updated cover letter:

Some fixes for taprio, mostly (2/3 and 3/3) related to the 'flags'
argument:

Patch 1/3: Reported by Po Liu, is more of a improvement of usability for
drivers implementing offloading features, now they can rely on the
value of dev->num_tc, instead of going through some hops to get this
value.

Patch 2/3: Use 'q->flags' as the source of truth for the offloading
flags.

Patch 3/3: Fixes the issue that changing the flags during runtime was
still allowed (with bad results). The solution was to initialize
'q->flags' with an invalid value.


Cheers,
--
Vinicius

Vinicius Costa Gomes (3):
  taprio: Fix enabling offload with wrong number of traffic classes
  taprio: Allow users not to specify "flags" when changing schedules
  taprio: Fix still allowing changing the flags during runtime

 net/sched/sch_taprio.c | 87 ++++++++++++++++++++++++++----------------
 1 file changed, 54 insertions(+), 33 deletions(-)

-- 
2.25.0

