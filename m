Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67ACB6B70CD
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 09:05:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbjCMIFs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 04:05:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229801AbjCMIFV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 04:05:21 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D985258C24;
        Mon, 13 Mar 2023 01:02:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678694542; x=1710230542;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=CbmVrutLLkAOwM9+nT109OGKvK1HNt/MtMNebpcvudY=;
  b=V2vPMRbw0hzTGtJaRB1QtvFcxylLNQe1HRq5Ph8+n2BZc8OYZYzJ2m1m
   JuVjDUyWFFmiBHeJNmTZ3PskCsgIULX5xqIWZ6VdfRP+F6G8zI9U7nslO
   l8uIytd5xGpUiVwfZebP70gKULRXJ8rDYgDieUmvTmrRMvMhfOuPWdrSB
   GhH0P+9oKeFWhlcgUd1up0rs4xVtHRKpfbqUczpLRuJvi77DFGIuJR9N2
   akYgFP2J4D8b3+P+hp+PEd2rhFYMskD6KeAPMuDfrsmIEtVY7ZGYP+ZNh
   zgG2tlZa5Q1H9kp7oY2zOLV1O4ueMlDahTF1LTJyd/N551gMRgMeSaM8N
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10647"; a="337107362"
X-IronPort-AV: E=Sophos;i="5.98,256,1673942400"; 
   d="scan'208";a="337107362"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2023 01:02:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10647"; a="747517964"
X-IronPort-AV: E=Sophos;i="5.98,256,1673942400"; 
   d="scan'208";a="747517964"
Received: from mike-ilbpg1.png.intel.com ([10.88.227.76])
  by fmsmga004.fm.intel.com with ESMTP; 13 Mar 2023 01:02:04 -0700
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
Subject: [PATCH net 0/2]  Fix PHY handle no longer parsing
Date:   Mon, 13 Mar 2023 16:01:33 +0800
Message-Id: <20230313080135.2952774-1-michael.wei.hong.sit@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
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
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 23 +++++++++++++++++--
 2 files changed, 21 insertions(+), 13 deletions(-)

-- 
2.34.1

