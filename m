Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFDBF108182
	for <lists+netdev@lfdr.de>; Sun, 24 Nov 2019 04:02:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726757AbfKXDCQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 22:02:16 -0500
Received: from mail-pf1-f173.google.com ([209.85.210.173]:42410 "EHLO
        mail-pf1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726676AbfKXDCQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 22:02:16 -0500
Received: by mail-pf1-f173.google.com with SMTP id s5so5549263pfh.9
        for <netdev@vger.kernel.org>; Sat, 23 Nov 2019 19:02:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=cs410pk2WGGskzmW00wQGEQsVx1UHdJx4TCUeQnvyi8=;
        b=FypTV9hr1yrpcpZXQxme+38rUMvHaHHI2CgVqm/AnBtCIY2CsCFTkpWxBrTrYDPGKO
         gYcySGIXSJ0mpfN0y3AxnnrcfIlukFZnocwoTdSmlFk3n52pC9C8In8jFCyu3vjtBSpD
         ej2KXS46Iu1qn+oOqBGWP+/OfQXUver9IEIyWdU0GVrIpDIMXNDfGOQaJMtH4004iOBq
         nkYy+c1mnAUtPL86Tx6pKZRrnG6hAfU6Lm0lnBYmkWdTsAghZr/xl8RhqpHUrJQAXQO0
         Qs816VBxDblr8xtZM5aU8C4NkCS6wGNfnVFen/HYc5ksJkYEs9PfDxVUrPt1WiJCvhFF
         AX5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=cs410pk2WGGskzmW00wQGEQsVx1UHdJx4TCUeQnvyi8=;
        b=TPXtNzUHx2wtZN1NP6MGOcOPP8DiHO2p90xLMAr5ms7GOdWnGkvAGweYs1z5nO7iF3
         0CyT5gzb5ofzfDx7QfEY0mG/TVOaGcZhDKmnobkmaDa/g0QRn+fP5OZ8yKUZ/PfCVuh3
         V2wKUWVNjbjaLkC50dE9K+MXpQcHTZCHbPLMp7SJsP3t+dIZNMSNtLSMroD34KczATx7
         4hufN1KrL3P3EfRs3j5QZvdqlyAG8NB7Zgu8610WIVOcGQrmlKPabjuwG60B9Bsmt8+T
         mTKr+OdyzRqscKi+UR0wEzomLte4WoO4yOrkUa6fjeMsEXJwyweEckHglOuGX5htHSgA
         7nag==
X-Gm-Message-State: APjAAAUCMUOBB0GVbgJVHcp5rW0eaU7P/wnH6x3Orb/tmWOZPhFWMKwl
        +rn3BlRBvsXaYD9Puup/kIZO6Q==
X-Google-Smtp-Source: APXvYqxVCh1R4UCxh2jpfBCuVx7MilWEZVy8nP29FUiR2f0oa4d5b+AhH8fW8ZiNhYOVxpWk8q06Xg==
X-Received: by 2002:a62:501:: with SMTP id 1mr27669598pff.69.1574564535099;
        Sat, 23 Nov 2019 19:02:15 -0800 (PST)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id z10sm3287704pgc.5.2019.11.23.19.02.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Nov 2019 19:02:14 -0800 (PST)
Date:   Sat, 23 Nov 2019 19:02:09 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Po Liu <po.liu@nxp.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Roy Zang <roy.zang@nxp.com>, Mingkai Hu <mingkai.hu@nxp.com>,
        Jerry Huang <jerry.huang@nxp.com>, Leo Li <leoyang.li@nxp.com>
Subject: Re: [net-next] enetc: add support Credit Based Shaper(CBS) for
 hardware offload
Message-ID: <20191123190209.5ad772fc@cakuba.netronome.com>
In-Reply-To: <20191122070321.20915-1-Po.Liu@nxp.com>
References: <20191122070321.20915-1-Po.Liu@nxp.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 22 Nov 2019 07:17:18 +0000, Po Liu wrote:
> +	if (tc == prio_top) {
> +		max_interference_size = port_frame_max_size * 8;
> +	} else {
> +		u32 m0, ma, r0, ra;
> +
> +		m0 = port_frame_max_size * 8;
> +		ma = enetc_port_rd(&si->hw, ENETC_PTCMSDUR(prio_top)) * 8;
> +		ra = enetc_get_cbs_bw(&si->hw, prio_top) *
> +			port_transmit_rate * 10000ULL;
> +		r0 = port_transmit_rate * 1000000ULL;
> +		max_interference_size = m0 + ma + (u64)ra * m0 / (r0 - ra);
> +	}
> +
> +	/* hiCredit bits calculate by:
> +	 *
> +	 * maxSizedFrame * (idleSlope/portTxRate)
> +	 */
> +	hi_credit_bit = max_interference_size * bw / 100;
> +
> +	/* hiCredit bits to hiCredit register need to calculated as:
> +	 *
> +	 * (enetClockFrequency / portTransmitRate) * 100
> +	 */
> +	hi_credit_reg = (ENETC_CLK * 100ULL) * hi_credit_bit
> +			/ (port_transmit_rate * 1000000ULL);

Hi! The patch looks good to me, but I'm concerned about those 64bit
divisions here. Don't these need to be div_u64() & co.? Otherwise
we may see one of the:

ERROR: "__udivdi3" [drivers/net/ethernet/freescale/enetc/fsl-enetc.ko] undefined!

messages from the build bot..

I could be wrong, I haven't actually tested..
