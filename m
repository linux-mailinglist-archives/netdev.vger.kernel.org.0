Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7576B4D396B
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 20:03:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237143AbiCITEC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 14:04:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233594AbiCITEB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 14:04:01 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F16E3369E4
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 11:02:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646852577; x=1678388577;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=aKsGy+geiFdWrmZOkUi6SC+jH118B6yqDKy9FtoYqF8=;
  b=gsjrfImGAr6NUVfjbGXXdpkbvUs8XqPzPXR6HBHaubmA+99qCtd0gcaF
   1lqeGV8KgqNAbEfPikvQSHKK/QUjQzTRNVV0MxO1pYeo5pQO4YG+APS41
   eF8UtBlpjOrtXagIAjVPdSfEZXjF3D7aQ6v//UySI1G9D33u/huwAnTp2
   uFcYi1lwPkwDVaU9jr6jLry73V7KVMb0KOr4W1RkNG9UaM0T5+EDTUXAN
   lJf083mrETJdieVp7NJz+d66uPdZ9Jg04I+ECQ15sE/xPtNtmEJS0DSDj
   4zzbzQv0WpjyM5C640anFDLuuEJg954me2/PRsgbjAg6C/E2WhZBw98QH
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10281"; a="341494148"
X-IronPort-AV: E=Sophos;i="5.90,168,1643702400"; 
   d="scan'208";a="341494148"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2022 11:02:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,168,1643702400"; 
   d="scan'208";a="781188744"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga006.fm.intel.com with ESMTP; 09 Mar 2022 11:02:57 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org
Subject: [PATCH net-next 0/5][pull request] 100GbE Intel Wired LAN Driver Updates 2022-03-09
Date:   Wed,  9 Mar 2022 11:03:10 -0800
Message-Id: <20220309190315.1380414-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to ice driver only.

Martyna implements switchdev filtering on inner EtherType field for
tunnels.

Marcin adds reporting of slowpath statistics for port representors.

Jonathan Toppins changes a non-fatal link error message from warning to
debug.

Maciej removes unnecessary checks in ice_clean_tx_irq().

Amritha adds support for ADQ to match outer destination MAC for tunnels.

The following are changes since commit 7f415828f987fca9651694c7589560e55ffdf9a6:
  MAINTAINERS: rectify entry for REALTEK RTL83xx SMI DSA ROUTER CHIPS
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 100GbE

Amritha Nambiar (1):
  ice: Add support for outer dest MAC for ADQ tunnels

Jonathan Toppins (1):
  ice: change "can't set link" message to dbg level

Maciej Fijalkowski (1):
  ice: avoid XDP checks in ice_clean_tx_irq()

Marcin Szycik (1):
  ice: Add slow path offload stats on port representor in switchdev

Martyna Szapar-Mudlaw (1):
  ice: Add support for inner etype in switchdev

 drivers/net/ethernet/intel/ice/ice.h          |   3 +
 drivers/net/ethernet/intel/ice/ice_lib.c      |   6 +-
 drivers/net/ethernet/intel/ice/ice_main.c     |   6 +-
 .../ethernet/intel/ice/ice_protocol_type.h    |   2 +
 drivers/net/ethernet/intel/ice/ice_repr.c     |  55 ++++
 drivers/net/ethernet/intel/ice/ice_switch.c   | 272 +++++++++++++++++-
 drivers/net/ethernet/intel/ice/ice_tc_lib.c   |  47 ++-
 drivers/net/ethernet/intel/ice/ice_txrx.c     |   7 +-
 8 files changed, 370 insertions(+), 28 deletions(-)

-- 
2.31.1

