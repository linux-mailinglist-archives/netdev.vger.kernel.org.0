Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE4B35F52DC
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 12:48:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbiJEKsq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Oct 2022 06:48:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229682AbiJEKsn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Oct 2022 06:48:43 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DBAB46849
        for <netdev@vger.kernel.org>; Wed,  5 Oct 2022 03:48:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664966920; x=1696502920;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=iEh35rXYhX0wsc4WDNFbElR6jIxJ7FlTV3kI9tIJt5c=;
  b=UO7A3+/LrYpzAaAAMnk43o9TBvwviJDv1U37Eg15tr14HFCGCs93wBqa
   H1h98wOOQo/dHyBrw9cdUnVz3m31yi5EOjHsd5FJ27mMkUjv7UdG4FlsK
   p376C0AEe1T0AU13tZyprrjuMpCvw5W4CcicQ29Nc9cWQ1lwCa77nY8hz
   wAWsj5jXZLL1c5IqOGMVL1N+LXsZCq85ANP6F6/IxgebsChqiJofeXwHI
   ZB2NMC3sWn+g93d6KhdANOk2LuiRePQPvpAZJQA0+9AzoNBWDsjwgfX43
   8cdOtsUShAEPOv/BtAfTBSTfmW5Iu3KozSLUPWGWcZaqGT7zC+o9lmK9D
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10490"; a="329543913"
X-IronPort-AV: E=Sophos;i="5.95,159,1661842800"; 
   d="scan'208";a="329543913"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2022 03:48:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10490"; a="728611883"
X-IronPort-AV: E=Sophos;i="5.95,159,1661842800"; 
   d="scan'208";a="728611883"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga002.fm.intel.com with ESMTP; 05 Oct 2022 03:48:38 -0700
Received: from switcheroo.igk.intel.com (switcheroo.igk.intel.com [172.22.229.137])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 295AmbV2028819;
        Wed, 5 Oct 2022 11:48:37 +0100
From:   Wojciech Drewek <wojciech.drewek@intel.com>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org, gnault@redhat.com
Subject: [PATCH iproute2-next v2 0/3] L2TPv3 support in tc-flower
Date:   Wed,  5 Oct 2022 12:44:29 +0200
Message-Id: <20221005104432.369341-1-wojciech.drewek@intel.com>
X-Mailer: git-send-email 2.31.1
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

This patchset implements support for matching
on L2TPv3 session id using tc-flower.
First two patches are uapi updates.

Kernel changes (merged):
https://lore.kernel.org/netdev/166365901622.22752.10799448124008445080.git-patchwork-notify@kernel.org/

v2: workaround for IPPROTO_L2TP definition in f_flower.c

Wojciech Drewek (3):
  uapi: move IPPROTO_L2TP to in.h
  uapi: Add TCA_FLOWER_KEY_L2TPV3_SID
  f_flower: Introduce L2TPv3 support

 include/uapi/linux/in.h      |  2 ++
 include/uapi/linux/l2tp.h    |  2 --
 include/uapi/linux/pkt_cls.h |  2 ++
 man/man8/tc-flower.8         | 11 ++++++--
 tc/f_flower.c                | 49 +++++++++++++++++++++++++++++++++++-
 5 files changed, 61 insertions(+), 5 deletions(-)

-- 
2.31.1

