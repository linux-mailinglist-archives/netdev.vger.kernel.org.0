Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78D6A2B86D0
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 22:36:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727019AbgKRVff (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 16:35:35 -0500
Received: from mga11.intel.com ([192.55.52.93]:8606 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726766AbgKRVfe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 16:35:34 -0500
IronPort-SDR: 4usVwzh5PTJAztVQX2EZ1lKn6fegobUQFrerccFT4qDudYi9rbbld+htVhyDDsF3y3tM/awE0l
 URm2lC/bC1dg==
X-IronPort-AV: E=McAfee;i="6000,8403,9809"; a="167680384"
X-IronPort-AV: E=Sophos;i="5.77,488,1596524400"; 
   d="scan'208";a="167680384"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2020 13:35:33 -0800
IronPort-SDR: N7X8KpP5Fb25kRBz6/gO5VM7lB3nVRaC7xNKBecWTSsmsjqdhAdWiZUzn5lhg3YkR9Y1VWgwcC
 h2yef+026nKA==
X-IronPort-AV: E=Sophos;i="5.77,488,1596524400"; 
   d="scan'208";a="534494609"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.212.69.244]) ([10.212.69.244])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2020 13:35:32 -0800
Subject: Re: [PATCH net-next v1] ptp: document struct ptp_clock_request
 members
To:     Ahmad Fatoum <a.fatoum@pengutronix.de>,
        Richard Cochran <richardcochran@gmail.com>
Cc:     kernel@pengutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20201117213826.18235-1-a.fatoum@pengutronix.de>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <26e16e25-c5ac-1474-fcc9-466cea4bcf9a@intel.com>
Date:   Wed, 18 Nov 2020 13:35:29 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <20201117213826.18235-1-a.fatoum@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/17/2020 1:38 PM, Ahmad Fatoum wrote:
> It's arguable most people interested in configuring a PPS signal
> want it as external output, not as kernel input. PTP_CLK_REQ_PPS
> is for input though. Add documentation to nudge readers into
> the correct direction.

Agreed. I think at least one driver has abused the PPS in the past as a
way to request that we enable the PPS hardware, resulting in effectively
using it as a limited form of the EXTTS interface. Hopefully this helps
reduce the confusion here!

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

> 
> Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
> ---
> Prompted by Richard's comment here:
> https://lore.kernel.org/netdev/20180525170247.r4gn323udrucmyv6@localhost/
> ---
>  include/linux/ptp_clock_kernel.h | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/include/linux/ptp_clock_kernel.h b/include/linux/ptp_clock_kernel.h
> index d3e8ba5c7125..0d47fd33b228 100644
> --- a/include/linux/ptp_clock_kernel.h
> +++ b/include/linux/ptp_clock_kernel.h
> @@ -12,6 +12,19 @@
>  #include <linux/pps_kernel.h>
>  #include <linux/ptp_clock.h>
>  
> +/**
> + * struct ptp_clock_request - request PTP clock event
> + *
> + * @type:   The type of the request.
> + *	    EXTTS:  Configure external trigger timestamping
> + *	    PEROUT: Configure periodic output signal (e.g. PPS)
> + *	    PPS:    trigger internal PPS event for input
> + *	            into kernel PPS subsystem
> + * @extts:  describes configuration for external trigger timestamping.
> + *          This is only valid when event == PTP_CLK_REQ_EXTTS.
> + * @perout: describes configuration for periodic output.
> + *	    This is only valid when event == PTP_CLK_REQ_PEROUT.
> + */
>  
>  struct ptp_clock_request {
>  	enum {
> 
