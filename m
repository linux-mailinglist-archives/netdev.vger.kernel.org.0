Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 527554B0EE4
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 14:34:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242266AbiBJNeV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 08:34:21 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240708AbiBJNeU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 08:34:20 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F290AC54;
        Thu, 10 Feb 2022 05:34:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644500061; x=1676036061;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=35F95GQH062JU1k0E2ipbpvw2aBZd129hwlob5d/l1s=;
  b=QxgJSm995Nz8dfsQ5i0487xm7n13QJTKqqhxzClK8C5Ij7pRMhGYhgtu
   zcNvBEzIKR+qzfk3+xJEB4A6BF7THgugKpyATGvBKEHouyo1cIFAf0sIq
   2Y3ctux5e4f8Fu8icC3wOyCtov8ArHsaRK/gkZmrXihPbK3gKtnoTUrN+
   ICdBeY+Amyy7diODuxargUhkLI7htKpCQDoPfqA9HmGhCa8E1Q+rAjdX/
   dqXaept2nDMfj8fhTyjdrCBurk+EDClDKBz093o9ev978E2Ry+yN9x0ti
   TEiss/A1wEnuWTt6+KdQbaVcEGZzZYgZhKU363LCAeJqLojT4iAc6Aq5a
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10253"; a="249439222"
X-IronPort-AV: E=Sophos;i="5.88,358,1635231600"; 
   d="scan'208";a="249439222"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 05:34:21 -0800
X-IronPort-AV: E=Sophos;i="5.88,358,1635231600"; 
   d="scan'208";a="541611354"
Received: from asamsono-mobl1.ccr.corp.intel.com ([10.252.41.247])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 05:34:15 -0800
Date:   Thu, 10 Feb 2022 15:34:13 +0200 (EET)
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
Subject: Re: [PATCH net-next v4 04/13] net: wwan: t7xx: Add port proxy
 infrastructure
In-Reply-To: <20220114010627.21104-5-ricardo.martinez@linux.intel.com>
Message-ID: <4474a82c-4118-61cd-e48c-92123bc32e3b@linux.intel.com>
References: <20220114010627.21104-1-ricardo.martinez@linux.intel.com> <20220114010627.21104-5-ricardo.martinez@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
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
> Port-proxy provides a common interface to interact with different types
> of ports. Ports export their configuration via `struct t7xx_port` and
> operate as defined by `struct port_ops`.
> 
> Signed-off-by: Haijun Liu <haijun.liu@mediatek.com>
> Co-developed-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
> Signed-off-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
> Co-developed-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
> Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
> ---

> +	struct mutex		tx_mutex_lock; /* Protects the seq number operation */

This is unused.


-- 
 i.

