Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCB9B14D504
	for <lists+netdev@lfdr.de>; Thu, 30 Jan 2020 02:36:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727198AbgA3BgO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jan 2020 20:36:14 -0500
Received: from mga12.intel.com ([192.55.52.136]:49906 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726618AbgA3BgN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Jan 2020 20:36:13 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Jan 2020 17:36:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,380,1574150400"; 
   d="scan'208";a="262008471"
Received: from vcostago-desk1.jf.intel.com ([10.54.70.26])
  by fmsmga002.fm.intel.com with ESMTP; 29 Jan 2020 17:36:13 -0800
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, davem@davemloft.net,
        vladimir.oltean@nxp.com, po.liu@nxp.com
Subject: [PATCH net v3 0/2] taprio: Some fixes
Date:   Wed, 29 Jan 2020 17:37:19 -0800
Message-Id: <20200130013721.33812-1-vinicius.gomes@intel.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Changes from v2:
  - Squashed commits 2/3 and 3/3 into a single one (I think a single
    commit is going to be easier to review);
  - Removed an "improvement" that was causing changes in user visible
    behavior;

Changes from v1:
  - Fixed ignoring the 'flags' argument when adding a new
    instance (Vladimir Oltean);
  - Changed the order of commits;

Updated cover letter:

Some fixes for taprio:

Patch 1/2: Reported by Po Liu, is more of a improvement of usability for
drivers implementing offloading features, now they can rely on the
value of dev->num_tc, instead of going through some hops to get this
value.

Patch 2/2: Use 'q->flags' as the source of truth for the offloading
flags. Tries to solidify the current behavior, while avoiding going
into invalid states, one of which was causing a "rcu stall" (more
information in the commit message).

@Vladimir: If possible, I would appreciate your Ack on patch 2/2. I
have been looking at this code for so long that I might have missed
something obvious (and my growing dislike for the word 'flags' may be
affecting my judgement :-).


Vinicius Costa Gomes (2):
  taprio: Fix enabling offload with wrong number of traffic classes
  taprio: Fix still allowing changing the flags during runtime

 net/sched/sch_taprio.c | 87 ++++++++++++++++++++++++++----------------
 1 file changed, 54 insertions(+), 33 deletions(-)

-- 
2.25.0

