Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0202C55EFCC
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 22:47:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231210AbiF1Uqy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 16:46:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231356AbiF1Uqb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 16:46:31 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D7552DA91
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 13:46:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656449189; x=1687985189;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ew7Z2BNZeWZHpgkm499S7xo2K2vD2Y+E0N5quiquNfQ=;
  b=YVqju+n9ChAe7GZgxNY1BdjMz6DOgP16AToWc8thm6QOi2aRweyYqNId
   2LJvykq3oZYnXn2S2CHJPoSlDf1j/S3KaZLxDyV2y9tj8H2OonCtRCeNM
   OQMZTeHI2WcbsnwnHkqCNZrlwvtolbwCfDp48Xzy2yBOVKEYDOKvWGopW
   oGTKy2QRdBN+XgEinW4SY+GurcQqjfQo9IMNEvt8ewu/SWOpRiyDhXz6u
   MXAtUrHQVGfD6Tq9q8Zs4Qgx7Yu73LQDdOvkqWrEnUKIPVxtNDs9JHxd2
   bW95ceEOWLtSBHDg6WpRKqgEWSttAvK8kb89v7xe6DD/djA5bnij7x8+s
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10392"; a="368157556"
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="368157556"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2022 13:46:28 -0700
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="658273097"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2022 13:46:24 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1o6I6H-000x8B-GH;
        Tue, 28 Jun 2022 23:46:21 +0300
Date:   Tue, 28 Jun 2022 23:46:21 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Moises Veleta <moises.veleta@linux.intel.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        johannes@sipsolutions.net, ryazanov.s.a@gmail.com,
        loic.poulain@linaro.org, m.chetan.kumar@intel.com,
        chandrashekar.devegowda@intel.com, linuxwwan@intel.com,
        chiranjeevi.rapolu@linux.intel.com, haijun.liu@mediatek.com,
        ricardo.martinez@linux.intel.com, dinesh.sharma@intel.com,
        ilpo.jarvinen@linux.intel.com, moises.veleta@intel.com,
        Madhusmita Sahu <madhusmita.sahu@intel.com>
Subject: Re: [PATCH net-next v2 1/1] net: wwan: t7xx: Add AP CLDMA and GNSS
 port
Message-ID: <YrtonRQTeLZeYm8T@smile.fi.intel.com>
References: <20220628165024.25718-1-moises.veleta@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220628165024.25718-1-moises.veleta@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 28, 2022 at 09:50:24AM -0700, Moises Veleta wrote:
> From: Haijun Liu <haijun.liu@mediatek.com>
> 
> The t7xx device contains two Cross Layer DMA (CLDMA) interfaces to
> communicate with AP and Modem processors respectively. So far only
> MD-CLDMA was being used, this patch enables AP-CLDMA and the GNSS
> port which requires such channel.
> 
> GNSS AT control port allows Modem Manager to control GPS for:
> - Start/Stop GNSS sessions,
> - Configuration commands to support Assisted GNSS positioning
> - Crash & reboot (notifications when resetting device (AP) & host)
> - Settings to Enable/Disable GNSS solution
> - Geofencing
> 
> Rename small Application Processor (sAP) to AP.
> 
> Signed-off-by: Haijun Liu <haijun.liu@mediatek.com>
> Co-developed-by: Madhusmita Sahu <madhusmita.sahu@intel.com>
> Signed-off-by: Madhusmita Sahu <madhusmita.sahu@intel.com>
> Signed-off-by: Moises Veleta <moises.veleta@linux.intel.com>

Missed cutter '---' line here. Effectively invalidates your tag block and may
not be applied (as no SoB present _as a tag_).

> Change log in v2:
> - Add to commit message renaming sAP to AP
> - Add to commit message GNSS AT port info
> - Lowercase X in constant prefix
> - Add GNSS AT comment in static port file
> ---
>  drivers/net/wwan/t7xx/t7xx_hif_cldma.c     | 17 +++--
>  drivers/net/wwan/t7xx/t7xx_hif_cldma.h     |  2 +-
>  drivers/net/wwan/t7xx/t7xx_mhccif.h        |  1 +
>  drivers/net/wwan/t7xx/t7xx_modem_ops.c     | 85 ++++++++++++++++++----
>  drivers/net/wwan/t7xx/t7xx_modem_ops.h     |  3 +
>  drivers/net/wwan/t7xx/t7xx_port.h          | 10 ++-
>  drivers/net/wwan/t7xx/t7xx_port_ctrl_msg.c |  8 +-
>  drivers/net/wwan/t7xx/t7xx_port_proxy.c    | 24 ++++++
>  drivers/net/wwan/t7xx/t7xx_reg.h           |  2 +-
>  drivers/net/wwan/t7xx/t7xx_state_monitor.c | 13 +++-
>  drivers/net/wwan/t7xx/t7xx_state_monitor.h |  2 +

-- 
With Best Regards,
Andy Shevchenko


