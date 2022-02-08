Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF3764AE33B
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 23:21:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385869AbiBHWVU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 17:21:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387051AbiBHVv1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 16:51:27 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6227C0612B8
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 13:51:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644357086; x=1675893086;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=yEkQ2jSeBHN1eiLJj30F65eo0gKj1VeF365/AgBhvBg=;
  b=f+4JHSNl5Fkd7wWilSrtJNltQEJReCrky5N4narHlF29Et79IxVUXY5o
   KIeQH8KnAU2wd9vwyYT+by464h+pqJ6/3azwjIz/qfdlGoC+VAbBpJo59
   Dski2FNGkC3sbLbunXBlW8Ec45ue/Dl1pUhf0a29si+3/5jlQNsa07C6o
   TYnCWzjLmeMVjBvRq+MqmyJfOqLouZp7ql2XFURdME+gGN64JKcNQqzYA
   vo4d6VFYpGSkzgzPPVI59qKurvV7gx1sY3e8vbl1/3Yw1QF5ZAjNrINQx
   G6uJ6jidzVD0l64c4Rzmj65OieBH26UBiBXWSofJ79U+jdRHfSjmVd/mZ
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10252"; a="249008202"
X-IronPort-AV: E=Sophos;i="5.88,353,1635231600"; 
   d="scan'208";a="249008202"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2022 13:51:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,353,1635231600"; 
   d="scan'208";a="622047945"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by FMSMGA003.fm.intel.com with ESMTP; 08 Feb 2022 13:51:25 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com
Subject: [PATCH net-next 0/5][pull request] 40GbE Intel Wired LAN Driver Updates 2022-02-08
Date:   Tue,  8 Feb 2022 13:51:12 -0800
Message-Id: <20220208215117.1733822-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Joe Damato says:

This patch set makes several updates to the i40e driver stats collection
and reporting code to help users of i40e get a better sense of how the
driver is performing and interacting with the rest of the kernel.

These patches include some new stats (like waived and busy) which were
inspired by other drivers that track stats using the same nomenclature.

The new stats and an existing stat, rx_reuse, are now accessible with
ethtool to make harvesting this data more convenient for users.

The following are changes since commit c3e676b98326a419f30dd5d956c68fc33323f4fd:
  Merge branch 'inet-separate-dscp-from-ecn-bits-using-new-dscp_t-type'
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 40GbE

Joe Damato (5):
  i40e: Remove rx page reuse double count
  i40e: Aggregate and export RX page reuse stat
  i40e: Add a stat tracking new RX page allocations
  i40e: Add a stat for tracking pages waived
  i40e: Add a stat for tracking busy rx pages

 drivers/net/ethernet/intel/i40e/i40e.h        |  4 +++
 .../net/ethernet/intel/i40e/i40e_ethtool.c    |  4 +++
 drivers/net/ethernet/intel/i40e/i40e_main.c   | 14 ++++++++++-
 drivers/net/ethernet/intel/i40e/i40e_txrx.c   | 25 +++++++++++++------
 drivers/net/ethernet/intel/i40e/i40e_txrx.h   |  3 +++
 5 files changed, 42 insertions(+), 8 deletions(-)

-- 
2.31.1

