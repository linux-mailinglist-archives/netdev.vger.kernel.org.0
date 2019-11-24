Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0640C108597
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 00:35:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727117AbfKXXfG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Nov 2019 18:35:06 -0500
Received: from mail-pf1-f171.google.com ([209.85.210.171]:32844 "EHLO
        mail-pf1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727004AbfKXXfF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Nov 2019 18:35:05 -0500
Received: by mail-pf1-f171.google.com with SMTP id c184so6338270pfb.0
        for <netdev@vger.kernel.org>; Sun, 24 Nov 2019 15:35:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=IAX5OsvQRFhKUVQf9ZlgdiZ0hiTtv7ussL8NqCM89xg=;
        b=CQBjZJADEWDMnh/O55ZZyyKuHM3lHl/Cs7sj8JVwoM8X3SLQs/jhmNaCCoFxpgFC4g
         opzBTt8OmQvgOLfvkwLJvBfEH0hjyy0FtECa2itRyCOE061wAAncoCKldnlKW6fMD+b2
         2XF3SSMWTYhxj4tWkOhjp5PwS5KGUU2ZCpVG2seV0UTJsPUoZBctrqVYxtV1kKnO92tW
         V1viAVqpSX1oypYw0Q9ZCpgZws35eVJxTyFwle1YxsA9N0oRnpSg+1Nzk1APXKtT/QUw
         B2EueQVIFlEq6ncV0is9dMR3HEJYuutOP3ApyK1VPuKJhLmIa8zGbZ8GkDat4+NbdveS
         Ohew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=IAX5OsvQRFhKUVQf9ZlgdiZ0hiTtv7ussL8NqCM89xg=;
        b=qKMrhrB69Aqbhn0CTtH7rpdidhop4BuLvaPw/bKDZon3iM6ONxq2f2pJW7aFsgMc1U
         6ygMExv7S/RfJBoEfn3iZB+tZTkrl/6LTC0FY/Khcg0Nr+cpbWWdODL0ebjEqErn++Uh
         dZn1+yn+zTcBhUz2w+vJT2khY/jb2dNJmR2YsWB6hVk1Rop4vO/B0Y1EoyXBuV+/e95O
         DX/rHYvoyFK82b765IZNBNdTuUZHqR5ysBnxF8sd25+gXLMEsq7h8tHGaJI9hpzKiW7x
         rlGfe9MVXjjWY5dEsb9LTx4go8dRE1mamka5pLQQyHexm3ab0lDx9eokPWoIUkxFhyNq
         hf1A==
X-Gm-Message-State: APjAAAUUPvVzpuD72YVSk1tI6gb3HTEUMmZDfWOP4HZpb4bHORfTkC3P
        rCIx6ds3ZMZlUJnmDASTWruWRHSj9Nc=
X-Google-Smtp-Source: APXvYqxNAS091SYTF7LWUbmNijXLey/JwiGkEGlAES3q+1uVZ0F13uA6K8LvjVSUWygYD+NFsaX9uw==
X-Received: by 2002:a62:ac06:: with SMTP id v6mr30674323pfe.210.1574638505235;
        Sun, 24 Nov 2019 15:35:05 -0800 (PST)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id z1sm5717299pfk.61.2019.11.24.15.35.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Nov 2019 15:35:05 -0800 (PST)
Date:   Sun, 24 Nov 2019 15:34:58 -0800
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
Message-ID: <20191124153458.14015cb2@cakuba.netronome.com>
In-Reply-To: <20191123190209.5ad772fc@cakuba.netronome.com>
References: <20191122070321.20915-1-Po.Liu@nxp.com>
        <20191123190209.5ad772fc@cakuba.netronome.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 23 Nov 2019 19:02:09 -0800, Jakub Kicinski wrote:
> On Fri, 22 Nov 2019 07:17:18 +0000, Po Liu wrote:
> > +	if (tc == prio_top) {
> > +		max_interference_size = port_frame_max_size * 8;
> > +	} else {
> > +		u32 m0, ma, r0, ra;
> > +
> > +		m0 = port_frame_max_size * 8;
> > +		ma = enetc_port_rd(&si->hw, ENETC_PTCMSDUR(prio_top)) * 8;
> > +		ra = enetc_get_cbs_bw(&si->hw, prio_top) *
> > +			port_transmit_rate * 10000ULL;
> > +		r0 = port_transmit_rate * 1000000ULL;
> > +		max_interference_size = m0 + ma + (u64)ra * m0 / (r0 - ra);
> > +	}
> > +
> > +	/* hiCredit bits calculate by:
> > +	 *
> > +	 * maxSizedFrame * (idleSlope/portTxRate)
> > +	 */
> > +	hi_credit_bit = max_interference_size * bw / 100;
> > +
> > +	/* hiCredit bits to hiCredit register need to calculated as:
> > +	 *
> > +	 * (enetClockFrequency / portTransmitRate) * 100
> > +	 */
> > +	hi_credit_reg = (ENETC_CLK * 100ULL) * hi_credit_bit
> > +			/ (port_transmit_rate * 1000000ULL);  
> 
> Hi! The patch looks good to me, but I'm concerned about those 64bit
> divisions here. Don't these need to be div_u64() & co.? Otherwise
> we may see one of the:
> 
> ERROR: "__udivdi3" [drivers/net/ethernet/freescale/enetc/fsl-enetc.ko] undefined!
> 
> messages from the build bot..
> 
> I could be wrong, I haven't actually tested..

Yup:

drivers/net/ethernet/freescale/enetc/enetc_qos.o: In function `enetc_setup_tc_cbs':
enetc_qos.c:(.text+0x5b4): undefined reference to `__udivdi3'
enetc_qos.c:(.text+0x608): undefined reference to `__udivdi3'
/home/jkicinski/devel/linux/Makefile:1077: recipe for target 'vmlinux' failed
make[1]: *** [vmlinux] Error 1
make[1]: Leaving directory '/home/jkicinski/devel/linux/build_tmp2'
Makefile:179: recipe for target 'sub-make' failed
make: *** [sub-make] Error 2

Please fix and repost.
