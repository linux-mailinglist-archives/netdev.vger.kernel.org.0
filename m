Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF0BE4EFBE1
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 22:55:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351535AbiDAU4s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 16:56:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347469AbiDAU4r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 16:56:47 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 104301B989C
        for <netdev@vger.kernel.org>; Fri,  1 Apr 2022 13:54:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648846497; x=1680382497;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=qzjXkoACViHnF8scwGkhB1nP70xFyvBEAhG0v6JUzsY=;
  b=Y86kxCEtQjGQElTL+/TpwyTlK0c4Rf5TALdoRBZMWAOhdkvxognqLTdD
   rME5bZe7PhJiel3395fOwmQxJ6k0lI47xtUFtUb3jtnhI6BZJCVO2YiLW
   u5TEyutbw0lImYgtNyzvhjUaBFBoAQafJ/cRHJ16TJIY/r1Fz/Xq03n6Q
   E6R+rhOHTAt+J8URadti+5uZHHXRaawwYq/RdPUrrdhktVwq7JB5sj+HP
   PpBfFc/3d70w+D0EQ/XreRDpiAdqSdCL+5SHrrDyqjtbNCdEsJItNt6r1
   jrUhwAE0GQymWv5lLm7t9smx5zXIJlAS1Tb7dNyZPGRvL0idHGe4V6T5B
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10304"; a="260408778"
X-IronPort-AV: E=Sophos;i="5.90,228,1643702400"; 
   d="scan'208";a="260408778"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2022 13:54:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,228,1643702400"; 
   d="scan'208";a="844523378"
Received: from alicemic-1.jf.intel.com ([10.166.17.62])
  by fmsmga005.fm.intel.com with ESMTP; 01 Apr 2022 13:54:57 -0700
From:   Alice Michael <alice.michael@intel.com>
To:     alice.michael@intel.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org
Subject: [net PATCH 0/2] ice bug fixes
Date:   Fri,  1 Apr 2022 05:14:51 -0700
Message-Id: <20220401121453.48415-1-alice.michael@intel.com>
X-Mailer: git-send-email 2.21.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DATE_IN_PAST_06_12,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tony Nguyen <anthony.l.nguyen@intel.com>

There were a couple of bugs that have been found and
fixed by Anatolii in the ice driver.  First he fixed
a bug on ring creation by setting the default value
for the teid.  Anatolli also fixed a bug with deleting
queues in ice_vc_dis_qs_msg based on their enablement.

Anatolii Gerasymenko:
  ice: Set txq_teid to ICE_INVAL_TEID on ring creation
  ice: Do not skip not enabled queues in ice_vc_dis_qs_msg

 drivers/net/ethernet/intel/ice/ice_lib.c      | 1 +
 drivers/net/ethernet/intel/ice/ice_virtchnl.c | 4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

-- 
2.31.1

