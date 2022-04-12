Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA1C54FE1B4
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 15:07:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354914AbiDLNJM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 09:09:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356041AbiDLNIW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 09:08:22 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4B1BBC2F;
        Tue, 12 Apr 2022 05:54:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649768056; x=1681304056;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=LdY9sTGizeqlCp/hNlojoai4UZdpGD+7RUCYPvX1e2U=;
  b=VqzfgHznPsX/Vmn4Ld/X4n+YEZQwFnrKd45OtMtaGD4pZhmFfoiVB952
   0+P7H5Nyfvpr2YI+84pttCQTGc6rDusfHQl2biYQ8VnrR3+COVjfDm0hO
   Far2/8pdUZdyyQP91+p9uMaY0fGtBAGIF8rzrSInjXa/oglKHdH4m/Pqt
   ltyvM5nMsHRzY1fOlpZmFDkqv0SaIhDLat6K7tdQ1uF3AICWPvbBiYJ/n
   AIDRWy/16nFTJpwSEsv7LLAbVwmxPhQJHv+5bCU2halCnQWCUXPwSG/Zi
   kMC0TNAB2KZ8rEcs4R9s268DZeZGFqIfhekWoLzkZzRA7DUKeUrq2P3+8
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10314"; a="242307088"
X-IronPort-AV: E=Sophos;i="5.90,253,1643702400"; 
   d="scan'208";a="242307088"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2022 05:54:14 -0700
X-IronPort-AV: E=Sophos;i="5.90,253,1643702400"; 
   d="scan'208";a="572753215"
Received: from rsimofi-mobl1.ger.corp.intel.com ([10.252.45.1])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2022 05:54:08 -0700
Date:   Tue, 12 Apr 2022 15:54:05 +0300 (EEST)
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
Subject: Re: [PATCH net-next v6 06/13] net: wwan: t7xx: Add AT and MBIM WWAN
 ports
In-Reply-To: <20220407223629.21487-7-ricardo.martinez@linux.intel.com>
Message-ID: <7cbb81a8-6bb-599b-3c27-a161622a08d@linux.intel.com>
References: <20220407223629.21487-1-ricardo.martinez@linux.intel.com> <20220407223629.21487-7-ricardo.martinez@linux.intel.com>
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

On Thu, 7 Apr 2022, Ricardo Martinez wrote:

> From: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
> 
> Adds AT and MBIM ports to the port proxy infrastructure.
> The initialization method is responsible for creating the corresponding
> ports using the WWAN framework infrastructure. The implemented WWAN port
> operations are start, stop, and TX.
> 
> Signed-off-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
> Co-developed-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
> Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
> 
> >From a WWAN framework perspective:
> Reviewed-by: Loic Poulain <loic.poulain@linaro.org>
> ---

> +	spin_lock_irqsave(&port->rx_wq.lock, flags);
> +	port->rx_length_th = 0;
> +	spin_unlock_irqrestore(&port->rx_wq.lock, flags);

?

-- 
 i.

