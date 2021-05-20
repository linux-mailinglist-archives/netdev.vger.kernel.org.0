Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C902389E12
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 08:40:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230342AbhETGlz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 02:41:55 -0400
Received: from mga02.intel.com ([134.134.136.20]:54907 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229536AbhETGly (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 May 2021 02:41:54 -0400
IronPort-SDR: hihf4vCfzZUAdHKrvLvbSw0UGyxQCHIYqHLPF/SDr3ar8B+/hRuU/c77a656PhZdPO6ao3Z/FA
 0RQmW4xQys9g==
X-IronPort-AV: E=McAfee;i="6200,9189,9989"; a="188285803"
X-IronPort-AV: E=Sophos;i="5.82,313,1613462400"; 
   d="scan'208";a="188285803"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2021 23:40:32 -0700
IronPort-SDR: Cl7kmvq3cLXqXSr/YwuY72/k/1LVchi5dhUveKlckqZa5wJZmHgml7H3qlsDpJStaFyA2i4UBB
 enbHRd5gwvCw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,313,1613462400"; 
   d="scan'208";a="440182349"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by fmsmga008.fm.intel.com with ESMTP; 19 May 2021 23:40:30 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        anthony.l.nguyen@intel.com, kuba@kernel.org, bjorn@kernel.org,
        magnus.karlsson@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH intel-net 0/2] ice XDP fixes
Date:   Thu, 20 May 2021 08:28:05 +0200
Message-Id: <20210520062806.61684-1-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

here are two small fixes around XDP support in ice driver.

Jamal reported that ice driver does not support XDP on his side. This
got me really puzzling and I had no clue what was going on. Turned that
this is the case when device is in 'safe mode', so let's add a dedicated
ndo_bpf for safe mode ops and make it clear to user what needs to be
fixed. I've described that in the commit message of patch 1 more thoroughly.

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

