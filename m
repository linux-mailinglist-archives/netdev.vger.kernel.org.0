Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7012B349C44
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 23:30:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231270AbhCYWaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 18:30:21 -0400
Received: from mga03.intel.com ([134.134.136.65]:49800 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230486AbhCYW3w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 18:29:52 -0400
IronPort-SDR: SBromIeWa6wib+UvYVzuSDEZZsOPAZ8vwQxDUhGP+DW3zCsDuD50ssP/ifFcaAlYQUO+TgXqO2
 uxkpVcZnkRvg==
X-IronPort-AV: E=McAfee;i="6000,8403,9934"; a="191063401"
X-IronPort-AV: E=Sophos;i="5.81,278,1610438400"; 
   d="scan'208";a="191063401"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2021 15:29:51 -0700
IronPort-SDR: hJO2gIRmMO8vXBlJP5xVjY8fkuGpBI9o1fbN6TFMHXCnlNEYyl8ShvFj8OHxjXP67M/yDv5wqT
 KwpeLHttvemQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,278,1610438400"; 
   d="scan'208";a="375246720"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga003.jf.intel.com with ESMTP; 25 Mar 2021 15:29:51 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Norbert Ciosek <norbertx.ciosek@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        geert@linux-m68k.org, sridhar.samudrala@intel.com,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net 1/4] virtchnl: Fix layout of RSS structures
Date:   Thu, 25 Mar 2021 15:31:16 -0700
Message-Id: <20210325223119.3991796-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210325223119.3991796-1-anthony.l.nguyen@intel.com>
References: <20210325223119.3991796-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Norbert Ciosek <norbertx.ciosek@intel.com>

Remove padding from RSS structures. Previous layout
could lead to unwanted compiler optimizations
in loops when iterating over key and lut arrays.

Fixes: 65ece6de0114 ("virtchnl: Add missing explicit padding to structures")
Signed-off-by: Norbert Ciosek <norbertx.ciosek@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 include/linux/avf/virtchnl.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/linux/avf/virtchnl.h b/include/linux/avf/virtchnl.h
index 40bad71865ea..532bcbfc4716 100644
--- a/include/linux/avf/virtchnl.h
+++ b/include/linux/avf/virtchnl.h
@@ -476,7 +476,6 @@ struct virtchnl_rss_key {
 	u16 vsi_id;
 	u16 key_len;
 	u8 key[1];         /* RSS hash key, packed bytes */
-	u8 pad[1];
 };
 
 VIRTCHNL_CHECK_STRUCT_LEN(6, virtchnl_rss_key);
@@ -485,7 +484,6 @@ struct virtchnl_rss_lut {
 	u16 vsi_id;
 	u16 lut_entries;
 	u8 lut[1];        /* RSS lookup table */
-	u8 pad[1];
 };
 
 VIRTCHNL_CHECK_STRUCT_LEN(6, virtchnl_rss_lut);
-- 
2.26.2

