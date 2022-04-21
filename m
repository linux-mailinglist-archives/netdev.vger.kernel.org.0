Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3C45509EE3
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 13:47:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236564AbiDULuE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 07:50:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiDULuE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 07:50:04 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F411825598;
        Thu, 21 Apr 2022 04:47:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650541635; x=1682077635;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=dfeSNdUoGE0S29vNXQz6ZwN1m2C60hdGtcLr8c9QTp4=;
  b=KbG8DIVQIccRrAqdaWmgWpYzRjutmLcS4s1hYtqoFJL5bRjwJyYbZzju
   EFmFTKPKB0sJlOJXy1/sif/GJ4TBDd0sgDFTADbXpRuQ7ZJpsO66jo9Qr
   nnPLp6CDxSILRN2knw7knLZBsNG4z98FNIOaUAKMZNj0v1NzP6NNv0wGt
   ZO06r6LK/U0eoY6elD38kn9WZZKWa7tLpSZ3Mbu7sDWxArDHK+UZycPtL
   X5e9hzK0DdA6/EQ17VOCZ5ojLsMYzKUbW9rSoaEKDxPlcrwZoAZMoPm+c
   TUmAmSYd/5BIqaFn/b5jBnYzl62BSYxCTOHlzak7uecRuc9UcZskUnuT2
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10323"; a="289438633"
X-IronPort-AV: E=Sophos;i="5.90,278,1643702400"; 
   d="scan'208";a="289438633"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2022 04:47:14 -0700
X-IronPort-AV: E=Sophos;i="5.90,278,1643702400"; 
   d="scan'208";a="530257376"
Received: from bpeddu-mobl.amr.corp.intel.com ([10.251.216.95])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2022 04:47:08 -0700
Date:   Thu, 21 Apr 2022 14:47:06 +0300 (EEST)
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
Subject: Re: [PATCH net-next v6 12/13] net: wwan: t7xx: Device deep sleep
 lock/unlock
In-Reply-To: <20220407223629.21487-13-ricardo.martinez@linux.intel.com>
Message-ID: <81e2104b-69ce-fd26-4b90-55869363ddce@linux.intel.com>
References: <20220407223629.21487-1-ricardo.martinez@linux.intel.com> <20220407223629.21487-13-ricardo.martinez@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323329-387946438-1650541633=:1673"
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-387946438-1650541633=:1673
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT

On Thu, 7 Apr 2022, Ricardo Martinez wrote:

> From: Haijun Liu <haijun.liu@mediatek.com>
> 
> Introduce the mechanism to lock/unlock the device 'deep sleep' mode.
> When the PCIe link state is L1.2 or L2, the host side still can keep
> the device is in D0 state from the host side point of view. At the same
> time, if the device's 'deep sleep' mode is unlocked, the device will
> go to 'deep sleep' while it is still in D0 state on the host side.
> 
> Signed-off-by: Haijun Liu <haijun.liu@mediatek.com>
> Signed-off-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
> Co-developed-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
> Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
> ---

> +void t7xx_pci_enable_sleep(struct t7xx_pci_dev *t7xx_dev)
> +{
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&t7xx_dev->md_pm_lock, flags);
> +	t7xx_dev->sleep_disable_count--;
> +	if (atomic_read(&t7xx_dev->md_pm_state) < MTK_PM_RESUMED) {

goto unlock;

> +		spin_unlock_irqrestore(&t7xx_dev->md_pm_lock, flags);
> +		return;
> +	}
> +
> +	if (t7xx_dev->sleep_disable_count == 0)
> +		t7xx_dev_set_sleep_capability(t7xx_dev, true);

unlock:

> +	spin_unlock_irqrestore(&t7xx_dev->md_pm_lock, flags);
> +}
> +
>  static int t7xx_send_pm_request(struct t7xx_pci_dev *t7xx_dev, u32 request)
>  {
>  	unsigned long wait_ret;

Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>


-- 
 i.

--8323329-387946438-1650541633=:1673--
