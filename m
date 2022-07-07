Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9397569F87
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 12:21:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234829AbiGGKU4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 06:20:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234881AbiGGKUw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 06:20:52 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B5417657
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 03:20:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657189249; x=1688725249;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=BJz5x00XvVwPqcqZX6fSPsHie3Nu/3IdrjAJQfPjjMQ=;
  b=d0sY9F48GlA0ikPh33IE4c/xTEmBKqTyRnnmma0N1BtpCyjTxNt1QOcT
   uxwwIlfBLs3CVe1AW7lMnLh94EKu5sG41XqL43pXFb3KBQ3VGZv17k8NH
   gEeFNEhzo+gib5YUgJu+Rlh0ZypbRYeNExaWVMGEVLti9R4/gQZTvnZWw
   DBxBZ7rdZqC1kgYcP9QwN6ckv3JEqlkI31GDUp8sdWEbw40uDX6uOUiHM
   ISfJc/HTVQmDiUuqAFu8DAvc9Evm/FA1ZNfRf++JQkY3xS0raUjZO40or
   TNhYKEymiZNLwg52Y1mi2wmQ02kYCZ3JoyEr8mr4CIruPTmHreF4bEyYV
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10400"; a="347972238"
X-IronPort-AV: E=Sophos;i="5.92,252,1650956400"; 
   d="scan'208";a="347972238"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2022 03:20:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,252,1650956400"; 
   d="scan'208";a="696458190"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by fmsmga002.fm.intel.com with ESMTP; 07 Jul 2022 03:20:46 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        kuba@kernel.org, davem@davemloft.net, magnus.karlsson@intel.com,
        anatolii.gerasymenko@intel.com, alexandr.lobakin@intel.com,
        john.fastabend@gmail.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH intel-net 0/2] ice: bring up ethtool selftests
Date:   Thu,  7 Jul 2022 12:20:41 +0200
Message-Id: <20220707102044.48775-1-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently `ethtool -t $IFACE` fails for loopback testing.
These two small patches bring it back to life.

These were pulled out from
https://lore.kernel.org/bpf/20220616180609.905015-1-maciej.fijalkowski@intel.com/

and now I route them via net tree as fixes.

Thanks!
Maciej

Maciej Fijalkowski (2):
  ice: check (DD | EOF) bits on Rx descriptor rather than (EOP | RS)
  ice: do not setup vlan for loopback VSI

 drivers/net/ethernet/intel/ice/ice_ethtool.c | 3 ++-
 drivers/net/ethernet/intel/ice/ice_main.c    | 8 +++++---
 2 files changed, 7 insertions(+), 4 deletions(-)

-- 
2.27.0

