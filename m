Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 215C860F839
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 14:57:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235283AbiJ0M5S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 08:57:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235156AbiJ0M5J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 08:57:09 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93259169CC5
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 05:57:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666875428; x=1698411428;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version:content-id;
  bh=gSXk+x+L6jiJT5Hvl/8cqO6MR0GWHs3OWrzSJWoiivY=;
  b=RxDclxwxYxiww4N7zb7YWU7d0qBFgwuq6lGtFy4NTc3ZS9heL6L+RgpH
   Jg9Q8BwiUfzJjopQiJz+gxX7lrKIUsHRSCmkfrf4pe/sGbQREw3vZEnxy
   3/z+jusiL2KR93Jj3JWgb206MAFo/tVtgs+SaezCWM+EOrXrlQyYr29iO
   LyKpcDDBDdEi7cC/L/bRvwBGHGN5hDsYtxf9B1nJfqHb9q4LmU3/2EiMY
   mOBTV5IRk/Ba/O81c58oxmw3W6JBWIlYY1cku1bvvs90gqHNvuF/qHyPR
   UTpQNjlTMVoXSgFyFCrWM5p0KsmLN5sFlWK7TRylQxx31Rit5XR3UD/QF
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10512"; a="287928775"
X-IronPort-AV: E=Sophos;i="5.95,217,1661842800"; 
   d="scan'208";a="287928775"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2022 05:57:08 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10512"; a="877573714"
X-IronPort-AV: E=Sophos;i="5.95,217,1661842800"; 
   d="scan'208";a="877573714"
Received: from kohnenth-mobl.ger.corp.intel.com ([10.251.216.78])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2022 05:57:04 -0700
Date:   Thu, 27 Oct 2022 15:57:02 +0300 (EEST)
From:   =?ISO-8859-15?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
To:     Sreehari Kancharla <sreehari.kancharla@linux.intel.com>
cc:     Netdev <netdev@vger.kernel.org>, kuba@kernel.org,
        davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        m.chetan.kumar@intel.com, chandrashekar.devegowda@intel.com,
        linuxwwan@intel.com, chiranjeevi.rapolu@linux.intel.com,
        haijun.liu@mediatek.com, ricardo.martinez@linux.intel.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        dinesh.sharma@intel.com, moises.veleta@intel.com,
        sreehari.kancharla@intel.com
Subject: Re: [PATCH net-next v2 2/2] net: wwan: t7xx: Add NAPI support
In-Reply-To: <20221027122510.24982-2-sreehari.kancharla@linux.intel.com>
Message-ID: <a61fb7b1-5f55-9141-3826-495947eb93de@linux.intel.com>
References: <20221027122510.24982-1-sreehari.kancharla@linux.intel.com> <20221027122510.24982-2-sreehari.kancharla@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; BOUNDARY="8323329-198711065-1666875376=:2917"
Content-ID: <b8d548f0-a46c-96c3-2348-2378d964b1ff@linux.intel.com>
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-198711065-1666875376=:2917
Content-Type: text/plain; CHARSET=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Content-ID: <ada4798-9d25-35cd-744e-a7db641e31c@linux.intel.com>

On Thu, 27 Oct 2022, Sreehari Kancharla wrote:

> From: Haijun Liu <haijun.liu@mediatek.com>
> 
> Replace the work queue based RX flow with a NAPI implementation
> Remove rx_thread and dpmaif_rxq_work.
> Enable GRO on RX path.
> Introduce dummy network device. its responsibility is
>     - Binds one NAPI object for each DL HW queue and acts as
>       the agent of all those network devices.
>     - Use NAPI object to poll DL packets.
>     - Helps to dispatch each packet to the network interface.
> 
> Signed-off-by: Haijun Liu <haijun.liu@mediatek.com>
> Co-developed-by: Sreehari Kancharla <sreehari.kancharla@linux.intel.com>
> Signed-off-by: Sreehari Kancharla <sreehari.kancharla@linux.intel.com>
> Signed-off-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
> Acked-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
> Acked-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
> --

> +	if (once_more) {
> +		napi_gro_flush(napi, false);
> +		work_done = budget;
> +		t7xx_dpmaif_clr_ip_busy_sts(&rxq->dpmaif_ctrl->hw_info);
> +	} else if (work_done < budget) {
> +		napi_complete_done(napi, work_done);
> +		t7xx_dpmaif_clr_ip_busy_sts(&rxq->dpmaif_ctrl->hw_info);
> +		t7xx_dpmaif_dlq_unmask_rx_done(&rxq->dpmaif_ctrl->hw_info, rxq->index);
> +	} else {
> +		t7xx_dpmaif_clr_ip_busy_sts(&rxq->dpmaif_ctrl->hw_info);
> +	}
> +
> +	t7xx_pci_enable_sleep(rxq->dpmaif_ctrl->t7xx_dev);
> +	pm_runtime_mark_last_busy(rxq->dpmaif_ctrl->dev);
> +	pm_runtime_put_noidle(rxq->dpmaif_ctrl->dev);
>  	atomic_set(&rxq->rx_processing, 0);
> +	return work_done;

A nitpick: I'd put newline prior to return, it's a bit crowded there 
already.

The patch looks ok to me:

Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>


-- 
 i.
--8323329-198711065-1666875376=:2917--
