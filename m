Return-Path: <netdev+bounces-7513-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C9F572083B
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 19:17:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F2AE52819DE
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 17:17:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32D1233308;
	Fri,  2 Jun 2023 17:17:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2465A33303
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 17:17:37 +0000 (UTC)
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E0301A2
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 10:17:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685726256; x=1717262256;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=2UZMCLsOZ0SJOW7OKC4J3m3lbbFB/JjfMgNR2ziKQpE=;
  b=FTxWTjtzSoUso2N3s5nTzaI7f6MR6L06zPoDRkxMmN5v9nnCBofQHy4S
   q0Jx6lkCZNgQF0BsHU7xaoPQ9Jn7X43PxW6vij43vmaCWvsK6/pJ18MF3
   Xk2mAncHwDxXIzlotHgVFZ4ijeFNzAUhpNimjxtyRJlWMl2dD3szcjmY+
   UIr/tZ/zoZs4xmToV4KuFQQ3nzNaYKnXwDfFN3dw0tvC+jUDMs6sKVU7l
   C3ye/VkgzRlOiNcQLfNqn226GJIf0qkP/v+7Gm6KoQ/rGoDXAXjtLzn4a
   gyUSZrAhXQYGiPZdpshe9Hl05T8zYC56uYSYyaEj4HuxNqQYL4jNDmLf1
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10729"; a="340549293"
X-IronPort-AV: E=Sophos;i="6.00,213,1681196400"; 
   d="scan'208";a="340549293"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2023 10:17:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10729"; a="772952348"
X-IronPort-AV: E=Sophos;i="6.00,213,1681196400"; 
   d="scan'208";a="772952348"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by fmsmga008.fm.intel.com with ESMTP; 02 Jun 2023 10:17:20 -0700
From: Tony Nguyen <anthony.l.nguyen@intel.com>
To: davem@davemloft.net,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	netdev@vger.kernel.org
Cc: Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH net-next 0/3][pull request] Intel Wired LAN Driver Updates 2023-06-02 (iavf)
Date: Fri,  2 Jun 2023 10:12:59 -0700
Message-Id: <20230602171302.745492-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

This series contains updates to iavf driver only.

Piotr avoids sending request for MAC address if it is the current MAC
address.

Przemek defers removing, previous, primary MAC address until after
getting result of adding its replacement.

Ahmed removes unnecessary masking when setting up interrupts.

The following are changes since commit 3f06760c00f56c5fe6c7f3361c2cf64becee1174:
  ipv4: Drop tos parameter from flowi4_update_output()
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 40GbE

Ahmed Zaki (1):
  iavf: remove mask from iavf_irq_enable_queues()

Piotr Gardocki (1):
  iavf: add check for current MAC address in set_mac callback

Przemek Kitszel (1):
  iavf: fix err handling for MAC replace

 drivers/net/ethernet/intel/iavf/iavf.h        |  2 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c   | 63 +++++++++----------
 .../net/ethernet/intel/iavf/iavf_register.h   |  2 +-
 3 files changed, 33 insertions(+), 34 deletions(-)

-- 
2.38.1


