Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACD026B8B9B
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 08:02:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbjCNHCi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 03:02:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjCNHCh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 03:02:37 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D53E496F0B;
        Tue, 14 Mar 2023 00:02:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678777356; x=1710313356;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ubItdxoh/248YMHvdWaraBjhtcicig7y7gOG+S5DDsA=;
  b=Mblg/L5oHWYU/PZYxW+ZEGSVPG+PtyMV7SnOrpYSu+40+ueCJDXzg4nR
   Lub4X+Gpu8qKe2KN5gKd8eR7pZb7EJDcpE3aJMH1jtNCN9fly74R7kM4D
   /CHr7RsM4MOnFuRI+kenUxbp8nZ/vuQztDVEulehZRd/6YqcQfHuPo5WS
   WXzy6mjPaAVTyW5414M46WsK4lY0+vxbPizfCbZ2e3Rqll+TFJNePk8Ko
   mcTTBJZzNdLlb1D/B7YH/eiliueDgQTm9xWcgb45R8WfrJN3HfDt6T9rm
   VcuSXl1mqK0SFzheHsEsCEHs/dekQYqf3FvkCWQYxrlE8VI/MoJFawF5E
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="334828400"
X-IronPort-AV: E=Sophos;i="5.98,259,1673942400"; 
   d="scan'208";a="334828400"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2023 00:02:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="656226732"
X-IronPort-AV: E=Sophos;i="5.98,259,1673942400"; 
   d="scan'208";a="656226732"
Received: from mike-ilbpg1.png.intel.com ([10.88.227.76])
  by orsmga006.jf.intel.com with ESMTP; 14 Mar 2023 00:02:29 -0700
From:   Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     Looi Hong Aun <hong.aun.looi@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Lai Peter Jun Ann <peter.jun.ann.lai@intel.com>
Subject: [PATCH net v2 0/2] Fix PHY handle no longer parsing
Date:   Tue, 14 Mar 2023 15:02:06 +0800
Message-Id: <20230314070208.3703963-1-michael.wei.hong.sit@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After the fixed link support was introduced, it is observed that PHY
no longer attach to the MAC properly.

This patch series fixes the issue and maintains fixed-link capability.

Michael Sit Wei Hong (2):
  net: stmmac: fix PHY handle parsing
  net: stmmac: move fixed-link support fixup code

 .../net/ethernet/stmicro/stmmac/dwmac-intel.c | 11 ---------
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 24 +++++++++++++++++--
 2 files changed, 22 insertions(+), 13 deletions(-)

v2: Initialize fwnode before using the variable
-- 
2.34.1

