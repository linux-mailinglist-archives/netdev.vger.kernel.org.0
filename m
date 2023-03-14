Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08D066B9D4B
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 18:46:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230318AbjCNRqS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 13:46:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230287AbjCNRqQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 13:46:16 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AB77AF2B2
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 10:46:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678815966; x=1710351966;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Vt/ieJERMhcOe75l4XLs4dJjs0UQayarM6oOGmAJZsQ=;
  b=oK2qVXnXWtY74gRebR3mqeFvIHGH3fGlKLXg81RPyddXEPui03XAZqPz
   Fe7HrVz7W9mkmreLiH6XJlH3gUqvtWzPwr6Pm3B9UPLf/SOZinyTSyxYo
   igsSb6HUgGw4Da/am021NQ0qqrERR4jjS+9vj3J4Un1kxo8SamnzgDKxI
   TMpnTO67phLYrWcGeSCmc/JDnm+S53A3KObOvfBneGN9g+JFCh4pKDv5q
   uq9q6IY7nWO2QKlRvzV2sY3Doe0ccSP1ewWT/d6Q/WVjmr42eknOLdX7K
   cGxUxiSMBRmX3hpc9bfYy0F83KY91k2BDg9sxUKIH7okPp/T5tQ4BBBwZ
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="317148698"
X-IronPort-AV: E=Sophos;i="5.98,260,1673942400"; 
   d="scan'208";a="317148698"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2023 10:46:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="1008516907"
X-IronPort-AV: E=Sophos;i="5.98,260,1673942400"; 
   d="scan'208";a="1008516907"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by fmsmga005.fm.intel.com with ESMTP; 14 Mar 2023 10:46:04 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH net 0/3][pull request] Intel Wired LAN Driver Updates 2023-03-14 (iavf)
Date:   Tue, 14 Mar 2023 10:44:20 -0700
Message-Id: <20230314174423.1048526-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to iavf driver only.

Alex fixes incorrect check against Rx hash feature and corrects payload
value for IPv6 UDP packet.

Ahmed removes bookkeeping of VLAN 0 filter as it always exists and can
cause a false max filter error message.

The following are changes since commit 28e8cabe80f3e6e3c98121576eda898eeb20f1b1:
  net: hsr: Don't log netdev_err message on unknown prp dst node
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 40GbE

Ahmed Zaki (1):
  iavf: do not track VLAN 0 filters

Alexander Lobakin (2):
  iavf: fix inverted Rx hash condition leading to disabled hash
  iavf: fix non-tunneled IPv6 UDP packet type and hashing

 drivers/net/ethernet/intel/iavf/iavf_common.c   | 2 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c     | 4 ++++
 drivers/net/ethernet/intel/iavf/iavf_txrx.c     | 2 +-
 drivers/net/ethernet/intel/iavf/iavf_virtchnl.c | 2 --
 4 files changed, 6 insertions(+), 4 deletions(-)

-- 
2.38.1

