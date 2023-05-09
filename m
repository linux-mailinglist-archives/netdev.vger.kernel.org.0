Return-Path: <netdev+bounces-1230-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 53F5B6FCC72
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 19:13:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 55C7B1C20C24
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 17:13:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB061F9FE;
	Tue,  9 May 2023 17:13:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0C4C17FE0
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 17:13:05 +0000 (UTC)
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A1C8EE
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 10:13:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683652384; x=1715188384;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=c14LjdQ+D2s8e3GUPC9scst6Jm2nryG/kXXG8KszsI4=;
  b=B24HfheZGNawbBuMzZQWsiT/PjjPSPAjMzkWueNkF+vP/MWR1+gJgbgu
   +MKUzpzBqUD7fyV0EAUsoOIs5FJlI3mx+mcKfqSx/PhS7mT3f6dpljYiF
   pLPK3RtjSZuuCQYxri+9KVbslEn6wRPihcszmWO1zDu/9hdYqOBn/pAuE
   3gWDSUVje8psXzZcGD3xMhJYRdONwHgTnNlN/pq/Yo+jxAYE5TAOdjt88
   8/YslahLi3aZlt2x7opmgPg+zTkz5ixMbzzyVjAD2P4iISWNmhDfmDbMT
   8o0yc4Q6AcBw4nZp801Q0vwOQ7EFJyktNuJt5MxWlPi0FBxD07T+er1Ea
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="339227617"
X-IronPort-AV: E=Sophos;i="5.99,262,1677571200"; 
   d="scan'208";a="339227617"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2023 10:13:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="729601139"
X-IronPort-AV: E=Sophos;i="5.99,262,1677571200"; 
   d="scan'208";a="729601139"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga008.jf.intel.com with ESMTP; 09 May 2023 10:13:03 -0700
From: Tony Nguyen <anthony.l.nguyen@intel.com>
To: davem@davemloft.net,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	netdev@vger.kernel.org
Cc: Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH net 0/3][pull request] Intel Wired LAN Driver Updates 2023-05-09 (igc, igb)
Date: Tue,  9 May 2023 10:09:32 -0700
Message-Id: <20230509170935.2237051-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

This series contains updates to igc and igb drivers.

Husaini clears Tx rings when interface is brought down for igc.

Vinicius disables PTM and PCI busmaster when removing igc driver.

Alex adds error check and path for NVM read error on igb.

The following are changes since commit 162bd18eb55adf464a0fa2b4144b8d61c75ff7c2:
  linux/dim: Do nothing if no time delta between samples
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 1GbE

Aleksandr Loktionov (1):
  igb: fix nvm.ops.read() error handling

Muhammad Husaini Zulkifli (1):
  igc: Clean the TX buffer and TX descriptor ring

Vinicius Costa Gomes (1):
  igc: Fix possible system crash when loading module

 drivers/net/ethernet/intel/igb/igb_ethtool.c |  4 +++-
 drivers/net/ethernet/intel/igc/igc_main.c    | 10 ++++++++++
 2 files changed, 13 insertions(+), 1 deletion(-)

-- 
2.38.1


