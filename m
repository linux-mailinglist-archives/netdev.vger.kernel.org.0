Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 730D74C4490
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 13:23:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240623AbiBYMYB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 07:24:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240565AbiBYMYA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 07:24:00 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6680220E7AE;
        Fri, 25 Feb 2022 04:23:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645791808; x=1677327808;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=Z1efsc2KCTHtU+A7Wzi/Z7zmTbOEnrNDjfHawFO4RlU=;
  b=Zvr/ku0uZXedJ8wGVEU1hlNtyHLml2vAHIlP49T79snmQgJtbPsRVusO
   xp04YSvKzvkwkPCjJbk/DnAWQBgZuDXGHxwpBRHRFwDwxSRCimVacboRX
   cPv38qllidSEDmLwJMXzr1eTFy/Mk4XKly1X2fJgiRsiTC0aD7IjhcBst
   NYO4gMq5egXYTEzEzO88SdAZorAoSxa8np/CpOP/JjvOPM9KFLnqn3bP8
   jEsv/mcHHxgVQC7fDMAhDhoq9JA8qql7h8fJUlMd9dDS1dq/ltTdFplWM
   zAlHsvGkTvWvMeXoDpt5EVjRGTAFRpxz+MRtBYoc0SVR9kxaMMlkGeFS0
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10268"; a="233110448"
X-IronPort-AV: E=Sophos;i="5.90,136,1643702400"; 
   d="scan'208";a="233110448"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2022 04:23:28 -0800
X-IronPort-AV: E=Sophos;i="5.90,136,1643702400"; 
   d="scan'208";a="549242555"
Received: from grossi-mobl.ger.corp.intel.com ([10.252.47.60])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2022 04:23:21 -0800
Date:   Fri, 25 Feb 2022 14:23:20 +0200 (EET)
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
Subject: Re: [PATCH net-next v5 06/13] net: wwan: t7xx: Add AT and MBIM WWAN
 ports
In-Reply-To: <20220223223326.28021-7-ricardo.martinez@linux.intel.com>
Message-ID: <266faa72-b9c-b8bd-97d8-fba1aff16f58@linux.intel.com>
References: <20220223223326.28021-1-ricardo.martinez@linux.intel.com> <20220223223326.28021-7-ricardo.martinez@linux.intel.com>
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

On Wed, 23 Feb 2022, Ricardo Martinez wrote:

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

> +static int t7xx_port_ctrl_tx(struct wwan_port *port, struct sk_buff *skb)
> +{
...
> +	if (!len || !port_private->rx_length_th || !port_private->chan_enable)

It raises eyebrows to see rx_xx being used on something called "tx".
Is it trying to tests port not inited?


-- 
 i.

