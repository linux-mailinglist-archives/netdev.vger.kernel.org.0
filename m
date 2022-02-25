Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 280EB4C431D
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 12:10:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239941AbiBYLLF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 06:11:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238967AbiBYLLD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 06:11:03 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C743197B51;
        Fri, 25 Feb 2022 03:10:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645787432; x=1677323432;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=Tm075Fx16DfjHBtJEGna7CmW+o40n6UD+/Aw9R+hYBk=;
  b=UmtdF7B3JQZRQAEe8BuC+b0vcK41zJBDXqtQv0uhJUMHQDgn2Qc4+26r
   Gad/4TGMr8QJJv0M3vSczPTDaOtAGsQq3JDE8+/5ZglAeaouyA0zXYvQ4
   KhYVkmc9A3jK1FN5pSoYAqtZAiqGQs263feXxrCgswvtOFkdbYBvz95q4
   0/ox/KIH0xeZGEOruRUz5ZQMVFhBe9kBkMnA1h3ju0tmiME6SliPXIAwb
   A4iEyC1h4fPJJSUQxxNCgU3LqCBl6oW+Lv2S8kHbnwyrUS6nzHQK8zrh+
   PqSHFjV+fDtl8FH6FjdzUcfTQ0ymzsk6nQu29eonhWYeHJSAuHJioAZ6r
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10268"; a="252672301"
X-IronPort-AV: E=Sophos;i="5.90,136,1643702400"; 
   d="scan'208";a="252672301"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2022 03:10:32 -0800
X-IronPort-AV: E=Sophos;i="5.90,136,1643702400"; 
   d="scan'208";a="549223077"
Received: from grossi-mobl.ger.corp.intel.com ([10.252.47.60])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2022 03:10:24 -0800
Date:   Fri, 25 Feb 2022 13:10:22 +0200 (EET)
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
Subject: Re: [PATCH net-next v5 03/13] net: wwan: t7xx: Add core components
In-Reply-To: <20220223223326.28021-4-ricardo.martinez@linux.intel.com>
Message-ID: <d5e3d2c-998b-58aa-9e71-43210f33e6f@linux.intel.com>
References: <20220223223326.28021-1-ricardo.martinez@linux.intel.com> <20220223223326.28021-4-ricardo.martinez@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 23 Feb 2022, Ricardo Martinez wrote:

> From: Haijun Liu <haijun.liu@mediatek.com>
> 
> Registers the t7xx device driver with the kernel. Setup all the core
> components: PCIe layer, Modem Host Cross Core Interface (MHCCIF),
> modem control operations, modem state machine, and build
> infrastructure.
> 
> * PCIe layer code implements driver probe and removal.
> * MHCCIF provides interrupt channels to communicate events
>   such as handshake, PM and port enumeration.
> * Modem control implements the entry point for modem init,
>   reset and exit.
> * The modem status monitor is a state machine used by modem control
>   to complete initialization and stop. It is used also to propagate
>   exception events reported by other components.
> 
> Signed-off-by: Haijun Liu <haijun.liu@mediatek.com>
> Signed-off-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
> Co-developed-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
> Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
> 
> >From a WWAN framework perspective:
> Reviewed-by: Loic Poulain <loic.poulain@linaro.org>
> ---

> +	/* IPs enable interrupts when ready */
> +	for (i = 0; i < EXT_INT_NUM; i++)
> +		t7xx_pcie_mac_clear_int(t7xx_dev, i);

In v4, PCIE_MAC_MSIX_MSK_SET() wrote to IMASK_HOST_MSIX_SET_GRP0_0.
In v5, t7xx_pcie_mac_clear_int() writes to IMASK_HOST_MSIX_CLR_GRP0_0.

t7xx_pcie_mac_set_int() would write to IMASK_HOST_MSIX_SET_GRP0_0
matching to what v4 did. So you probably want to call 
t7xx_pcie_mac_set_int() instead of t7xx_pcie_mac_clear_int()?


-- 
 i.

