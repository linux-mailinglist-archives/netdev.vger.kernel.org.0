Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5FE252688B
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 19:35:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383095AbiEMRfI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 13:35:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344148AbiEMRfD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 13:35:03 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEBCD101E8;
        Fri, 13 May 2022 10:35:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652463302; x=1683999302;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=OvrdMRFv5ZpZRNGmaPVVhvFlhhKbFzQ/U/+kvsTJ00c=;
  b=h8BEy/b4BxvPBqo5eTCmLFJYqxtewL3H1ZlGdimgBY5WdWJv7v9m36FG
   UhQpj20uJoAJ7YzCQf6z+8+tqNjiG5qj2sXZu3Cc+omn1IQLgncDNTIxp
   +k7FcPIMzXYWndqXcsO6ROujekS1Ko6xgzS5DLM09ezyfSqfBAS5O3zMc
   8ebUZNY00uk5AY5FvKFKv8v5Hsr5xDrmY8z8iEFJzupbuJTG1Bqbza1kq
   RpclJX29AVoN7rq2nxGQ5xwHNf0L3Yq82tMAp7fncFdy4f2P/NkCkEy6F
   HmUPZLOaM7EO6Mt7gZyqG0sdJJZVXCoYTgsdCGrgWvGJJdpqTKoYYTgTT
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10346"; a="250895681"
X-IronPort-AV: E=Sophos;i="5.91,223,1647327600"; 
   d="scan'208";a="250895681"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2022 10:34:14 -0700
X-IronPort-AV: E=Sophos;i="5.91,223,1647327600"; 
   d="scan'208";a="624950921"
Received: from abarkat-mobl.amr.corp.intel.com (HELO rmarti10-nuc3.hsd1.or.comcast.net) ([10.212.160.143])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2022 10:34:13 -0700
From:   Ricardo Martinez <ricardo.martinez@linux.intel.com>
To:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        m.chetan.kumar@intel.com, chandrashekar.devegowda@intel.com,
        linuxwwan@intel.com, chiranjeevi.rapolu@linux.intel.com,
        haijun.liu@mediatek.com, andriy.shevchenko@linux.intel.com,
        dinesh.sharma@intel.com, ilpo.jarvinen@linux.intel.com,
        moises.veleta@intel.com, sreehari.kancharla@intel.com,
        Ricardo Martinez <ricardo.martinez@linux.intel.com>
Subject: [PATCH net-next 0/2] net: skb: Remove skb_data_area_size()
Date:   Fri, 13 May 2022 10:33:58 -0700
Message-Id: <20220513173400.3848271-1-ricardo.martinez@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series removes the skb_data_area_size() helper,
replacing it in t7xx driver with the size used during skb allocation.

https://lore.kernel.org/netdev/CAHNKnsTmH-rGgWi3jtyC=ktM1DW2W1VJkYoTMJV2Z_Bt498bsg@mail.gmail.com/

Ricardo Martinez (2):
  net: wwan: t7xx: Avoid calls to skb_data_area_size()
  net: skb: Remove skb_data_area_size()

 drivers/net/wwan/t7xx/t7xx_hif_cldma.c     | 7 +++----
 drivers/net/wwan/t7xx/t7xx_hif_dpmaif_rx.c | 6 ++----
 include/linux/skbuff.h                     | 5 -----
 3 files changed, 5 insertions(+), 13 deletions(-)

-- 
2.25.1

