Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A8C4696D54
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 19:52:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232996AbjBNSwZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 13:52:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229808AbjBNSwY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 13:52:24 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F0796A65;
        Tue, 14 Feb 2023 10:52:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676400744; x=1707936744;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=TwKXloFTMv0mpCZYsinPeWhooTMYzzGCQwRknxpBWOA=;
  b=Ww3fzjQ7tYT/6mX9kOi8lG6PuxcmbRMet7/Cbxa9gmZn1woSaReZEnNc
   cuVcaQtqcroI7tOWopkOxc6ovlpCcia8oqCqiMe4jBBSg994HXSvfAU+9
   Am4InHkV4ro8geOvzJd44LF/LO1BD/7eJWF1AspP5Wjz87S/ACEmuG494
   5gy1yja82cnnJwmCXFU2O7g/UmjbXoAyYxvSWl4afphAV8uk3u1HLS7g5
   Rwt0OGm6XlQJ7d0CoGIJ1Vri3/yAUuKqcTfqSb9hcr9OO3k4U68DoSHc/
   q7U/sFcxOHIzm/XdxeqzQcLuCF/CRuDYFNMhgkxukpobcoQOr5r5ePbZV
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="329866032"
X-IronPort-AV: E=Sophos;i="5.97,297,1669104000"; 
   d="scan'208";a="329866032"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2023 10:52:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="619159892"
X-IronPort-AV: E=Sophos;i="5.97,297,1669104000"; 
   d="scan'208";a="619159892"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga003.jf.intel.com with ESMTP; 14 Feb 2023 10:52:23 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, bpf@vger.kernel.org, bjorn@kernel.org
Subject: [PATCH net 0/3][pull request] Intel Wired LAN Driver Updates 2023-02-14 (ixgbe, i40e)
Date:   Tue, 14 Feb 2023 10:51:43 -0800
Message-Id: <20230214185146.1305819-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to ixgbe and i40e drivers.

Jason Xing corrects comparison of frame sizes for setting MTU with XDP on
ixgbe and adjusts frame size to account for a second VLAN header on ixgbe
and i40e.

The following are changes since commit 05d7623a892a9da62da0e714428e38f09e4a64d8:
  net: stmmac: Restrict warning on disabling DMA store and fwd mode
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue 10GbE

Jason Xing (3):
  ixgbe: allow to increase MTU to 3K with XDP enabled
  i40e: add double of VLAN header when computing the max MTU
  ixgbe: add double of VLAN header when computing the max MTU

 drivers/net/ethernet/intel/i40e/i40e_main.c   |  2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe.h      |  2 ++
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 28 +++++++++++--------
 3 files changed, 20 insertions(+), 12 deletions(-)

-- 
2.38.1

