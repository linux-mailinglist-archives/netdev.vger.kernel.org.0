Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A148389E28
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 08:47:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230440AbhETGsY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 02:48:24 -0400
Received: from mga17.intel.com ([192.55.52.151]:17784 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229534AbhETGsW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 May 2021 02:48:22 -0400
IronPort-SDR: kdFpieYwNOobLPVjXlWsjJ2x9c02W9NOpi+j3S8leapDKdG9Iqmyh1/X609w37zv5J6rJvMMNx
 pljYEoC5NtLg==
X-IronPort-AV: E=McAfee;i="6200,9189,9989"; a="181437729"
X-IronPort-AV: E=Sophos;i="5.82,313,1613462400"; 
   d="scan'208";a="181437729"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2021 23:47:00 -0700
IronPort-SDR: Vq/jT1J3z7ztUugLsJzOWxxm6AyP6qVflRGJk4L/Dr2auV/vRk5aWGtmD2gnXMkmaJMue8Qd5h
 2Ckag79hchAg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,313,1613462400"; 
   d="scan'208";a="543203120"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by fmsmga001.fm.intel.com with ESMTP; 19 May 2021 23:46:58 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        anthony.l.nguyen@intel.com, kuba@kernel.org, bjorn@kernel.org,
        magnus.karlsson@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH v2 intel-net 0/2] ice XDP fixes
Date:   Thu, 20 May 2021 08:34:58 +0200
Message-Id: <20210520063500.62037-1-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[resending as v2, vim session got broken while editing patch]

Hi,

here are two small fixes around XDP support in ice driver.

Jamal reported that ice driver does not support XDP on his side. This
got me really puzzling and I had no clue what was going on. Turned that
this is the case when device is in 'safe mode', so let's add a dedicated
ndo_bpf for safe mode ops and make it clear to user what needs to be
fixed. I've described that in the commit message of patch 1 more
thoroughly.

Second issue was found during implementing XDP Tx fallback path for
unsufficient queue count case, which I will send on next week once I'm
back from woods. Hopefully.

Thanks!

Maciej Fijalkowski (2):
  ice: add ndo_bpf callback for safe mode netdev ops
  ice: parametrize functions responsible for Tx ring management

 drivers/net/ethernet/intel/ice/ice_lib.c  | 18 ++++++++++--------
 drivers/net/ethernet/intel/ice/ice_main.c | 15 +++++++++++++++
 2 files changed, 25 insertions(+), 8 deletions(-)

-- 
2.20.1

