Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A645B477369
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 14:44:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237690AbhLPNop (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 08:44:45 -0500
Received: from mga11.intel.com ([192.55.52.93]:12305 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237562AbhLPNoo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Dec 2021 08:44:44 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10199"; a="237032305"
X-IronPort-AV: E=Sophos;i="5.88,211,1635231600"; 
   d="scan'208";a="237032305"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2021 05:44:44 -0800
X-IronPort-AV: E=Sophos;i="5.88,211,1635231600"; 
   d="scan'208";a="519255307"
Received: from jetten-mobl.ger.corp.intel.com ([10.252.36.24])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2021 05:44:36 -0800
Date:   Thu, 16 Dec 2021 15:44:34 +0200 (EET)
From:   =?ISO-8859-15?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
To:     Ricardo Martinez <ricardo.martinez@linux.intel.com>
cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        m.chetan.kumar@intel.com, chandrashekar.devegowda@intel.com,
        linuxwwan@intel.com, chiranjeevi.rapolu@linux.intel.com,
        haijun.liu@mediatek.com, amir.hanania@intel.com,
        andriy.shevchenko@linux.intel.com, dinesh.sharma@intel.com,
        eliot.lee@intel.com, mika.westerberg@linux.intel.com,
        moises.veleta@intel.com, pierre-louis.bossart@intel.com,
        muralidharan.sethuraman@intel.com, Soumya.Prakash.Mishra@intel.com,
        sreehari.kancharla@intel.com, suresh.nagaraj@intel.com
Subject: Re: [PATCH net-next v3 04/12] net: wwan: t7xx: Add control port
In-Reply-To: <20211207024711.2765-5-ricardo.martinez@linux.intel.com>
Message-ID: <377f68a1-c642-d5da-51e7-624eac4eb911@linux.intel.com>
References: <20211207024711.2765-1-ricardo.martinez@linux.intel.com> <20211207024711.2765-5-ricardo.martinez@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 6 Dec 2021, Ricardo Martinez wrote:

> From: Haijun Liu <haijun.liu@mediatek.com>
> 
> Control Port implements driver control messages such as modem-host
> handshaking, controls port enumeration, and handles exception messages.
> 
> The handshaking process between the driver and the modem happens during
> the init sequence. The process involves the exchange of a list of
> supported runtime features to make sure that modem and host are ready
> to provide proper feature lists including port enumeration. Further
> features can be enabled and controlled in this handshaking process.
> 
> Signed-off-by: Haijun Liu <haijun.liu@mediatek.com>
> Signed-off-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
> Co-developed-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
> Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>



> +	ccci_h->packet_header = 0;
> +	ccci_h->packet_len = cpu_to_le32(packet_size);
> +	ccci_h->status &= cpu_to_le32(~HDR_FLD_CHN);
> +	ccci_h->status |= cpu_to_le32(FIELD_PREP(HDR_FLD_CHN, port_static->tx_ch));
> +	ccci_h->status &= cpu_to_le32(~HDR_FLD_SEQ);
> +	ccci_h->ex_msg = 0;

...

> +		ccci_h->packet_header = cpu_to_le32(CCCI_HEADER_NO_DATA);
> +		ccci_h->packet_len = cpu_to_le32(sizeof(*ctrl_msg_h) + CCCI_H_LEN);
> +		ccci_h->status &= cpu_to_le32(~HDR_FLD_CHN);
> +		ccci_h->status |= cpu_to_le32(FIELD_PREP(HDR_FLD_CHN, ch));
> +		ccci_h->ex_msg = 0;

...

> +		ccci_h->packet_header = cpu_to_le32(CCCI_HEADER_NO_DATA);
> +		ccci_h->packet_len = cpu_to_le32(msg);
> +		ccci_h->status &= cpu_to_le32(~HDR_FLD_CHN);
> +		ccci_h->status |= cpu_to_le32(FIELD_PREP(HDR_FLD_CHN, ch));
> +		ccci_h->ex_msg = cpu_to_le32(ex_msg);

A helper to handle the common part of ccci_h init would be useful.


-- 
 i.

