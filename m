Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A167349C40
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 23:30:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231236AbhCYWaR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 18:30:17 -0400
Received: from mga03.intel.com ([134.134.136.65]:49800 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230285AbhCYW3w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 18:29:52 -0400
IronPort-SDR: YF7XJmbofHbvT47GoybUjpeAyt2RohejFcXzlrQSSGEtz62dxBx7FZKfp/eE9qT/yi07zfRFF4
 ErvRe+J6r2Wg==
X-IronPort-AV: E=McAfee;i="6000,8403,9934"; a="191063400"
X-IronPort-AV: E=Sophos;i="5.81,278,1610438400"; 
   d="scan'208";a="191063400"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2021 15:29:51 -0700
IronPort-SDR: Dj272vASU5oaYPgd9CXSuopQbkB0/+Guy+NYVGokrLw1BSkzwq5bkXgkWCBzqXJfWQOPRcTzKO
 giGuIAhxfuTQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,278,1610438400"; 
   d="scan'208";a="375246716"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga003.jf.intel.com with ESMTP; 25 Mar 2021 15:29:51 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com
Subject: [PATCH net 0/4][pull request] Intel Wired LAN Driver Updates 2021-03-25
Date:   Thu, 25 Mar 2021 15:31:15 -0700
Message-Id: <20210325223119.3991796-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to virtchnl header file and i40e driver.

Norbert removes added padding from virtchnl RSS structures as this
causes issues when iterating over the arrays.

Mateusz adds Asym_Pause as supported to allow these settings to be set
as the hardware supports it.

Eryk fixes an issue where encountering a VF reset alongside releasing
VFs could cause a call trace.

Arkadiusz moves TC setup before resource setup as previously it was
possible to enter with a null q_vector causing a kernel oops.

The following are changes since commit e43accba9b071dcd106b5e7643b1b106a158cbb1:
  psample: Fix user API breakage
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 40GbE

Arkadiusz Kubalewski (1):
  i40e: Fix oops at i40e_rebuild()

Eryk Rybak (1):
  i40e: Fix kernel oops when i40e driver removes VF's

Mateusz Palczewski (1):
  i40e: Added Asym_Pause to supported link modes

Norbert Ciosek (1):
  virtchnl: Fix layout of RSS structures

 drivers/net/ethernet/intel/i40e/i40e.h             |  1 +
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c     |  1 +
 drivers/net/ethernet/intel/i40e/i40e_main.c        | 11 +++++------
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |  9 +++++++++
 include/linux/avf/virtchnl.h                       |  2 --
 5 files changed, 16 insertions(+), 8 deletions(-)

-- 
2.26.2

