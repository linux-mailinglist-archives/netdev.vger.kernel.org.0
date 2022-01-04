Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41BFB484286
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 14:31:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233624AbiADNbC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 08:31:02 -0500
Received: from mga01.intel.com ([192.55.52.88]:34504 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230287AbiADNbC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jan 2022 08:31:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641303062; x=1672839062;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YSDR7VqnIEeScX1Ku+T5goZVV0p2a1T6EU3r17XKwSo=;
  b=TX7/rIMyfc9IuuvW8hKdNJ+lZYFku4YMrAwYdZNQIwEVxFYe9PmM5EkG
   vbr3THLzyjpi1tCZ/BTJGcXBEnhSaYyMoazf9EPe2VM84fsVddSmqoukZ
   k/n8+2mwBpPFaDow2RBugYm05aDbQs4hnNEbfly9391aryy5z704J6/1a
   if5R2Oq+hROBTt0iz+SYNVTtL428W8HLvS5sNv4HmlN03gOZwc3AZuEKy
   A7r7dxFg1kR4S7LfJS/XnBEM3/OcUKpGI4PqZp2vnaG4r48ZyzzJlmcZo
   csgjYmMRmdgP9YLkeKpGjECCG3vc/W6tTKsGBMEUmgBAeGcC7drmOevXD
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10216"; a="266490495"
X-IronPort-AV: E=Sophos;i="5.88,261,1635231600"; 
   d="scan'208";a="266490495"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2022 05:31:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,261,1635231600"; 
   d="scan'208";a="526049715"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga008.jf.intel.com with ESMTP; 04 Jan 2022 05:30:58 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 204DUvm7014924;
        Tue, 4 Jan 2022 13:30:57 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Intel-wired-lan] [PATCH] intel: Simplify DMA setting
Date:   Tue,  4 Jan 2022 14:29:36 +0100
Message-Id: <20220104132936.252202-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <c7a34d0096eb4ba98dd9ce5b64ba079126cab708.1641255235.git.christophe.jaillet@wanadoo.fr>
References: <c7a34d0096eb4ba98dd9ce5b64ba079126cab708.1641255235.git.christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Date: Tue, 4 Jan 2022 01:15:20 +0100

> As stated in [1], dma_set_mask() with a 64-bit mask will never fail if
> dev->dma_mask is non-NULL.
> So, if it fails, the 32 bits case will also fail for the same reason.
> 
> Simplify code and remove some dead code accordingly.
> 
> [1]: https://lkml.org/lkml/2021/6/7/398
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>  drivers/net/ethernet/intel/e1000e/netdev.c    | 22 ++++++-------------
>  drivers/net/ethernet/intel/i40e/i40e_main.c   |  9 +++-----
>  drivers/net/ethernet/intel/iavf/iavf_main.c   |  9 +++-----
>  drivers/net/ethernet/intel/ice/ice_main.c     |  2 --
>  drivers/net/ethernet/intel/ixgb/ixgb_main.c   | 19 +++++-----------
>  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 20 ++++++-----------
>  .../net/ethernet/intel/ixgbevf/ixgbevf_main.c | 20 +++++------------
>  7 files changed, 31 insertions(+), 70 deletions(-)

I like it, thanks!

Reviewed-by: Alexander Lobakin <alexandr.lobakin@intel.com>

Tony might ask to split it into per-driver patches tho, will see.

--- 8< ---

Al
