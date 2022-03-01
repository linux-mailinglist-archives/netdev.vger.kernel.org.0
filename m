Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 642004C8C94
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 14:26:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234929AbiCAN1d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 08:27:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235012AbiCAN12 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 08:27:28 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 556169D4C1;
        Tue,  1 Mar 2022 05:26:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646141205; x=1677677205;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=z2s6MqyiWrQTAqg/P9Yn8V1ROZ3GKC+IbN5wcEyP710=;
  b=liSiQby72p2kdT6dlEl9tf3ZABIKtIzU/OdJ01Ad9b4JmmwmR2FrxtbW
   Ti1+p+x6OkFyp2+BaFzQwP/bikwIQLhBW5geS3P9mVsH6q6EWkjR+Di8q
   d1aDBFc5nmhWi1DWAkttVCk+tlOW53KLQmWujilrevKK9dM3b2QA39DWb
   GC8JZov/Tcev4zoLqSerGxttvv8suhttjctqNq3qjhwQtLFLl3TbLP/oi
   HzTcqxHK7Ltq/AiZ5VyZNJ56MSYwE3eCIQQWVTpoFXNmXjndFXYj8ZuJi
   12zs9ne61/l+94nw+3aU58m2eXxgtqN7pSu110M5sYZuoJQRXsxaSbTyM
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10272"; a="252862561"
X-IronPort-AV: E=Sophos;i="5.90,146,1643702400"; 
   d="scan'208";a="252862561"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2022 05:26:45 -0800
X-IronPort-AV: E=Sophos;i="5.90,146,1643702400"; 
   d="scan'208";a="550709348"
Received: from fsforza-mobl1.ger.corp.intel.com ([10.252.44.248])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2022 05:26:38 -0800
Date:   Tue, 1 Mar 2022 15:26:36 +0200 (EET)
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
        sreehari.kancharla@intel.com, madhusmita.sahu@intel.com
Subject: Re: [PATCH net-next v5 10/13] net: wwan: t7xx: Introduce power
 management
In-Reply-To: <20220223223326.28021-11-ricardo.martinez@linux.intel.com>
Message-ID: <3fe7f932-57b7-14c7-4966-7484df7f8250@linux.intel.com>
References: <20220223223326.28021-1-ricardo.martinez@linux.intel.com> <20220223223326.28021-11-ricardo.martinez@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 23 Feb 2022, Ricardo Martinez wrote:

> From: Haijun Liu <haijun.liu@mediatek.com>
> 
> Implements suspend, resumes, freeze, thaw, poweroff, and restore
> `dev_pm_ops` callbacks.
> 
> >From the host point of view, the t7xx driver is one entity. But, the
> device has several modules that need to be addressed in different ways
> during power management (PM) flows.
> The driver uses the term 'PM entities' to refer to the 2 DPMA and
> 2 CLDMA HW blocks that need to be managed during PM flows.
> When a dev_pm_ops function is called, the PM entities list is iterated
> and the matching function is called for each entry in the list.
> 
> Signed-off-by: Haijun Liu <haijun.liu@mediatek.com>
> Signed-off-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
> Co-developed-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
> Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
> ---

> +static int __t7xx_pci_pm_suspend(struct pci_dev *pdev)
> +{
...
> +	iowrite32(L1_DISABLE_BIT(0), IREG_BASE(t7xx_dev) + DIS_ASPM_LOWPWR_CLR_0);
> +	return 0;

The success path does this same iowrite32 to DIS_ASPM_LOWPWR_CLR_0
as the failure paths. Is that intended?

The function looks much better now!


-- 
 i.

