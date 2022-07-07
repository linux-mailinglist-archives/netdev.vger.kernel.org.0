Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E30A569F6D
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 12:18:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235347AbiGGKRB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 06:17:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235364AbiGGKQ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 06:16:58 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A86E25072E
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 03:16:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657189017; x=1688725017;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=JhSwozAgKYlJy+X03EQEM0YoYTa8MOfoBs+82qEK3q4=;
  b=gVG1GYeH/z8ghNRiQdR6Sb8+tvZU9UcilGKzfQdk+qzgil7MEt0YsbT8
   VvEgnKSXJhoV4i1a+aHPffe+wzOYFx5+gEHIquSpVtR8DMTmkLmvpbj+z
   7VNOHDQ5DtmZiiO5qTFTBCpcbdkuzmeUK//kB0JQuu3gMlDgIJ08zR9B1
   +QAMrLlS/dv0finsVtS8jQQVgmNouBIwMTAs1vCFI3CQqDkiKTxHr569V
   fsiYBQhCPENDcftB3IlyfmiVJFSd+IwqrfTIQF4KYaA7LzIzCOQ7avr/w
   wA605WJVHI/nc7Vn6vEIrl557i7WcCz/cG0ZFyTB0/rJKwpNy/JhCDdxy
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10400"; a="285113717"
X-IronPort-AV: E=Sophos;i="5.92,252,1650956400"; 
   d="scan'208";a="285113717"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2022 03:16:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,252,1650956400"; 
   d="scan'208";a="651077054"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by fmsmga008.fm.intel.com with ESMTP; 07 Jul 2022 03:16:54 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        kuba@kernel.org, davem@davemloft.net, magnus.karlsson@intel.com,
        anatolii.gerasymenko@intel.com, alexandr.lobakin@intel.com,
        john.fastabend@gmail.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH intel-next 0/2] ice: add NETIF_F_LOOPBACK support
Date:   Thu,  7 Jul 2022 12:16:49 +0200
Message-Id: <20220707101651.48738-1-maciej.fijalkowski@intel.com>
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

Hi,

these two patches are pulled out of the set
https://lore.kernel.org/bpf/20220616180609.905015-1-maciej.fijalkowski@intel.com/

they are about adding support for loopback toggle and they were written
for AF_XDP ZC testing purposes but they are good on their own and since
I need to rework ice ZC support a bit, let us route them via IWL
instead.

By the time I am done with refactor I believe there is a high chance
that these will land in net-next.

Thanks!
Maciej

Maciej Fijalkowski (2):
  ice: compress branches in ice_set_features()
  ice: allow toggling loopback mode via ndo_set_features callback

 drivers/net/ethernet/intel/ice/ice_main.c | 73 ++++++++++++++++-------
 1 file changed, 51 insertions(+), 22 deletions(-)

-- 
2.27.0

