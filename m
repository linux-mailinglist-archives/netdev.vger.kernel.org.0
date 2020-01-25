Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8593D149263
	for <lists+netdev@lfdr.de>; Sat, 25 Jan 2020 01:52:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387563AbgAYAwU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 19:52:20 -0500
Received: from mga07.intel.com ([134.134.136.100]:29976 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387405AbgAYAwT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jan 2020 19:52:19 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Jan 2020 16:52:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,359,1574150400"; 
   d="scan'208";a="294841477"
Received: from vcostago-desk1.jf.intel.com ([10.54.70.26])
  by fmsmga001.fm.intel.com with ESMTP; 24 Jan 2020 16:52:18 -0800
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, davem@davemloft.net,
        vladimir.oltean@nxp.com, po.liu@nxp.com
Subject: [PATCH net v1 0/3] taprio: Some fixes
Date:   Fri, 24 Jan 2020 16:53:17 -0800
Message-Id: <20200125005320.3353761-1-vinicius.gomes@intel.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Some fixes for taprio, mostly (2/3 and 3/3) related to the 'flags'
argument:

Patch 1/3: Reported by Po Liu, is more of a improvement of usability for
drivers implementing offloading features, now they can rely on the
value of dev->num_tc, instead of going through some hops to get this
value.

Patch 2/3: Changing the "flags" parameter during "runtime" was never
supposed to work, but if the user didn't set it at the beginning, we
were still allowing it.

Patch 3/3: Improves the code, so a similar situation fixed by 2/3 is
harder to happen again, and has the intended side effect that users do
not need to specify the "flags" argument when changing schedules when
some kind of offloading is enabled.


Cheers,
--
Vinicius

Vinicius Costa Gomes (3):
  taprio: Fix enabling offload with wrong number of traffic classes
  taprio: Fix still allowing changing the flags during runtime
  taprio: Allow users not to specify "flags" when changing schedules

 net/sched/sch_taprio.c | 45 +++++++++++++++++++++---------------------
 1 file changed, 22 insertions(+), 23 deletions(-)

-- 
2.25.0

