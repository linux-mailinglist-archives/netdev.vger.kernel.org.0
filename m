Return-Path: <netdev+bounces-9345-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 949E3728923
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 22:05:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 47E972817A5
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 20:05:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FFA12D264;
	Thu,  8 Jun 2023 20:05:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FA2617740
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 20:05:48 +0000 (UTC)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DA2F270B
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 13:05:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686254747; x=1717790747;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=EjIOxdGM6OYpqyB/WzSbxPau0l0YEkeOYcC98seklK0=;
  b=HPtrIVPTq4wXMso/fe0vQIr+roxfh6CL9DZGpswbmomLCj7LyazN0i6X
   Xu3CVKAscLaR/P4DdrfHT3AZ01tzstfzZtP5j+F2oTdClee2EDpEdNtca
   u1OHwMMJGSaM+fCF8PP2Llv2Fd/1OqISN6pHeHS47n1L5kO1JNANPdeFF
   K21EvE0HS5UtzgVonMcsDdmvZR1STXNRt/6u8UvkJTnaSHBgQhC1tMjuu
   yvetuoGqwBaB2yFQRVBHl4MJEE+1Cgd6DccW2URmvBFnjcZ70ypqrFZW+
   KJnHFJLsqt7vae1fbMgyOtoimoYTjsKi57BRKDFVaFebul93R1fpj433w
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10735"; a="385770826"
X-IronPort-AV: E=Sophos;i="6.00,227,1681196400"; 
   d="scan'208";a="385770826"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2023 13:05:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10735"; a="687486291"
X-IronPort-AV: E=Sophos;i="6.00,227,1681196400"; 
   d="scan'208";a="687486291"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga006.jf.intel.com with ESMTP; 08 Jun 2023 13:05:24 -0700
From: Tony Nguyen <anthony.l.nguyen@intel.com>
To: davem@davemloft.net,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	netdev@vger.kernel.org
Cc: Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH net 0/2][pull request] Intel Wired LAN Driver Updates 2023-06-08 (ice)
Date: Thu,  8 Jun 2023 13:00:49 -0700
Message-Id: <20230608200051.451752-1-anthony.l.nguyen@intel.com>
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
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

This series contains updates to ice driver only.

Simon Horman stops null pointer dereference for GNSS error path.

Kamil fixes memory leak when downing interface when XDP is enabled.

The following are changes since commit 6c0ec7ab5aaff3706657dd4946798aed483b9471:
  Merge branch 'bnxt_en-bug-fixes'
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 100GbE

Kamil Maziarz (1):
  ice: Fix XDP memory leak when NIC is brought up and down

Simon Horman (1):
  ice: Don't dereference NULL in ice_gnss_read error path

 drivers/net/ethernet/intel/ice/ice_gnss.c | 8 +-------
 drivers/net/ethernet/intel/ice/ice_main.c | 4 ++++
 2 files changed, 5 insertions(+), 7 deletions(-)

-- 
2.38.1


