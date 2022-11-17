Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B990A62E85D
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 23:25:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234246AbiKQWZh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 17:25:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235002AbiKQWZW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 17:25:22 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CA1B786EC
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 14:24:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668723899; x=1700259899;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=CbvdUjT8B7qJpg4Aq6R59iglZZvchjVS6FgyHnAlwp4=;
  b=WsBR+xSw5LM4w2BBmOqznQ7C8zIsA3hM//BxzJ4RcRMdqLPahhLSh7D9
   GrW2Vl9WpTg2wPT7765J6qbhBvQr8GmWHFsiJgJ0+w5CI6tFXwV3HDG3O
   bD7W1Gx+FUimjPXBRTDT+XjwObaL3IeZf/YWB/KyUJOuErwFcty6XeC1k
   XLHzGqk4e5uM/XMVrrlDOf9o+nyFw9nk6O5pIYCVu95hGuGJUPS4gI1gw
   JvG1ybGByRyGo4OFm8iOe7kXWx0rP2saix3Q2BtLyFj27S0YDDxY+Tp78
   Mv1KQu97MiCULf5xirXnSrsg3H2saNOf0BCCxN6tGQYDn3zladjuv28k8
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10534"; a="339826321"
X-IronPort-AV: E=Sophos;i="5.96,172,1665471600"; 
   d="scan'208";a="339826321"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2022 14:24:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10534"; a="885055456"
X-IronPort-AV: E=Sophos;i="5.96,172,1665471600"; 
   d="scan'208";a="885055456"
Received: from avenkata-desk0.sc.intel.com ([172.25.112.42])
  by fmsmga006.fm.intel.com with ESMTP; 17 Nov 2022 14:24:58 -0800
From:   Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
To:     netdev@vger.kernel.org
Cc:     Ira Weiny <ira.weiny@intel.com>,
        "Fabio M . De Francesco" <fmdefrancesco@gmail.com>,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Subject: [PATCH net-next 0/5] Remove uses of kmap_atomic()
Date:   Thu, 17 Nov 2022 14:25:52 -0800
Message-Id: <20221117222557.2196195-1-anirudh.venkataramanan@intel.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

kmap_atomic() is being deprecated. This little series replaces the last
few uses of kmap_atomic() in ethernet drivers with either page_address()
or kmap_local_page().

Anirudh Venkataramanan (5):
  ch_ktls: Use kmap_local_page() instead of kmap_atomic()
  sfc: Use kmap_local_page() instead of kmap_atomic()
  cassini: Remove unnecessary use of kmap_atomic()
  cassini: Use kmap_local_page() instead of kmap_atomic()
  sunvnet: Use kmap_local_page() instead of kmap_atomic()

 .../chelsio/inline_crypto/ch_ktls/chcr_ktls.c | 10 ++---
 drivers/net/ethernet/sfc/tx.c                 |  4 +-
 drivers/net/ethernet/sun/cassini.c            | 40 ++++++-------------
 drivers/net/ethernet/sun/sunvnet_common.c     |  4 +-
 4 files changed, 22 insertions(+), 36 deletions(-)


base-commit: b4b221bd79a1c698d9653e3ae2c3cb61cdc9aee7
-- 
2.37.2

