Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC4644B0F2E
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 14:50:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242456AbiBJNuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 08:50:23 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238801AbiBJNuX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 08:50:23 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81AB1137;
        Thu, 10 Feb 2022 05:50:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644501024; x=1676037024;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=BF7kESzRDG3KdzYJ4AwPP/B/TOak0p8VAlGfRDqWcBU=;
  b=eedSEYtB0IZhw+fEnO7cybAmTCVoSPXp/fVrVxoYf0MtY/ILPSoWCZZT
   JhpY4zZA8neARFIAaKYMErAdKb06Tsbr6v/W1NTNhmZeo884W1zhnbQPy
   0dKtI1zNw0NfpUhNNAMHsrNKS4mwp06y5naaUtWnemnl3PpvlNl/JCbhn
   L8Grdd9sDTfAJZNmtp/5FVL2ZnczTSuCaXX/o4yXJvyU2jcCB5DM2s0yh
   36G+4yrZOYubBH1mmbTAWAqafhcFhu6315zVYNKpkiGdi88R6/H17fBUI
   GOKqUJLVyDV9CWhbAhEdOzadXATGcNfnsih5xbZbHKVioDbr9/VBM7V0O
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10253"; a="229460019"
X-IronPort-AV: E=Sophos;i="5.88,358,1635231600"; 
   d="scan'208";a="229460019"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 05:50:24 -0800
X-IronPort-AV: E=Sophos;i="5.88,358,1635231600"; 
   d="scan'208";a="541616919"
Received: from asamsono-mobl1.ccr.corp.intel.com ([10.252.41.247])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 05:50:18 -0800
Date:   Thu, 10 Feb 2022 15:50:16 +0200 (EET)
From:   =?ISO-8859-15?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
To:     Ricardo Martinez <ricardo.martinez@linux.intel.com>
cc:     Netdev <netdev@vger.kernel.org>, linux-wireless@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        m.chetan.kumar@intel.com, chandrashekar.devegowda@intel.com,
        linuxwwan@intel.com, chiranjeevi.rapolu@linux.intel.com,
        haijun.liu@mediatek.com, amir.hanania@intel.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        dinesh.sharma@intel.com, eliot.lee@intel.com,
        moises.veleta@intel.com, pierre-louis.bossart@intel.com,
        muralidharan.sethuraman@intel.com, Soumya.Prakash.Mishra@intel.com,
        sreehari.kancharla@intel.com
Subject: Re: [PATCH net-next v4 02/13] net: wwan: t7xx: Add control DMA
 interface
In-Reply-To: <20220114010627.21104-3-ricardo.martinez@linux.intel.com>
Message-ID: <12ac1a9-bcf7-2515-fe69-8aa796cbbff7@linux.intel.com>
References: <20220114010627.21104-1-ricardo.martinez@linux.intel.com> <20220114010627.21104-3-ricardo.martinez@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 13 Jan 2022, Ricardo Martinez wrote:

> From: Haijun Liu <haijun.liu@mediatek.com>
> 
> Cross Layer DMA (CLDMA) Hardware interface (HIF) enables the control
> path of Host-Modem data transfers. CLDMA HIF layer provides a common
> interface to the Port Layer.
> 
> CLDMA manages 8 independent RX/TX physical channels with data flow
> control in HW queues. CLDMA uses ring buffers of General Packet
> Descriptors (GPD) for TX/RX. GPDs can represent multiple or single
> data buffers (DB).
> 
> CLDMA HIF initializes GPD rings, registers ISR handlers for CLDMA
> interrupts, and initializes CLDMA HW registers.
> 
> CLDMA TX flow:
> 1. Port Layer write
> 2. Get DB address
> 3. Configure GPD
> 4. Triggering processing via HW register write
> 
> CLDMA RX flow:
> 1. CLDMA HW sends a RX "done" to host
> 2. Driver starts thread to safely read GPD
> 3. DB is sent to Port layer
> 4. Create a new buffer for GPD ring
> 
> Signed-off-by: Haijun Liu <haijun.liu@mediatek.com>
> Signed-off-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
> Co-developed-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
> Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
> ---

> +	struct cldma_ring *tr_ring;
> +	struct cldma_request *tr_done;
> +	struct cldma_request *rx_refill;
> +	struct cldma_request *tx_xmit;
> +	int budget;			/* Same as ring buffer size by default */
> +	spinlock_t ring_lock;

I couldn't figure out what ring_lock is supposed to protect exactly.
Since there were tr_ring operations done w/o ring_lock (in 
t7xx_cldma_gpd_rx_from_q), I was left to wonder whether it's due to
a locking bug or me not understanding what ring_lock is supposed to 
protect.


-- 
 i.

