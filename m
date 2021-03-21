Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BC523433D4
	for <lists+netdev@lfdr.de>; Sun, 21 Mar 2021 18:45:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230047AbhCURov (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Mar 2021 13:44:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229913AbhCURoW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Mar 2021 13:44:22 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B58CEC061574;
        Sun, 21 Mar 2021 10:44:21 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id u9so17578295ejj.7;
        Sun, 21 Mar 2021 10:44:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fYGF5sGH9yTwb4yGNT0DDgLLyY4Lq+vokKLWKOMuKD0=;
        b=OuAZCA0g4oL2WK4UKmTvZisRiNRkPLvX8hxmS4l+BjTM72PJx42FlqPY0U7Iq025x9
         gqHuPcfSL44u7JzvPRrV/O4C+JsfqjDIimdodJQHE1JkXA5fCyRP2fzooqtE3fD8tMQ1
         Y8Rex67TMX5vGpTGN8jZScjar3wwXtI2ohAejFjFB8HBZSRVZXpQsgTAftogWvKfzMGG
         rN0IyAb/LXNoJl97kMbKPckmi4XC/zUnArQG+Ru6lm7J82gqxjATuP6aceAx0mQyKIRv
         V+5TGpfd49eqkROTDH3kYLyntiqTdC2hlUx9Hpuvf0k00r6R1ipFrqZ3Z/GPWIr2TRnc
         mbIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fYGF5sGH9yTwb4yGNT0DDgLLyY4Lq+vokKLWKOMuKD0=;
        b=ktxsmQnnd89NgJe+UhUW/IeMq+DO2n8/vCpIdSa6MGb4bf/aqiIYuVy9hmQn66C/OK
         Cb4cQJNJHEOKocA8M+iLn9TQlbBpXqLQH1DjSnyfkxGm/uOB9hqte3Od5E2Nlp+bKGkc
         NH/Z2vXb+a6KTSwEeSOLO4azcs6I7L1fQ22n8d814tuGP5lxvtfuwb5PBKIG2YiEKZuR
         ox3QRO3zV/vhVJIto5UhMCtHU0rTplYidxv4acbVostCUjoWwXiGpAuIm63UEsWPlrjI
         pTbAn/41TB8WDEFmbM5+/5QPw19dyfD2TQivQYf9QOqJHoExilGM7VmQubIHr+Qv6CQP
         lFHA==
X-Gm-Message-State: AOAM533Ev3tEKQlruMA3j+TrKZ0kfYsIs461fAxegvwASvy/Nbl8PVcp
        p3yuuXbUmW4S6nk7ht9iqVs=
X-Google-Smtp-Source: ABdhPJzf8l3KvrgKYg3s9d9HN1erE7HxUWwWIF0x5iI7EC9BHeOD1ifvZesGWjFE4Jt8srWTdCsjHw==
X-Received: by 2002:a17:906:3395:: with SMTP id v21mr15538126eja.322.1616348660368;
        Sun, 21 Mar 2021 10:44:20 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id q16sm8959645edv.61.2021.03.21.10.44.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Mar 2021 10:44:20 -0700 (PDT)
Date:   Sun, 21 Mar 2021 19:44:19 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Pavel Machek <pavel@denx.de>
Cc:     kernel list <linux-kernel@vger.kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: enetc: fix bitfields, we are clearing wrong bits
Message-ID: <20210321174419.jiwfu2nsfyhlhllc@skbuf>
References: <20210321162500.GA26497@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210321162500.GA26497@amd>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 21, 2021 at 05:25:00PM +0100, Pavel Machek wrote:
> Bitfield manipulation in enetc_mac_config() looks wrong. Fix
> it. Untested.
> 
> Signed-off-by: Pavel Machek (CIP) <pavel@denx.de>
> 
> diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
> index 224fc37a6757..b85079493933 100644
> --- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
> +++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
> @@ -505,7 +505,7 @@ static void enetc_mac_config(struct enetc_hw *hw, phy_interface_t phy_mode)
>  	if (phy_interface_mode_is_rgmii(phy_mode)) {
>  		val = enetc_port_rd(hw, ENETC_PM0_IF_MODE);
>  		val &= ~ENETC_PM0_IFM_EN_AUTO;
> -		val &= ENETC_PM0_IFM_IFMODE_MASK;
> +		val &= ~ENETC_PM0_IFM_IFMODE_MASK;
>  		val |= ENETC_PM0_IFM_IFMODE_GMII | ENETC_PM0_IFM_RG;
>  		enetc_port_wr(hw, ENETC_PM0_IF_MODE, val);
>  	}
> 
> -- 
> DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
> HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

Fixes: c76a97218dcb ("net: enetc: force the RGMII speed and duplex instead of operating in inband mode")
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Note that for normal operation, the bug was inconsequential, due to the
fact that we write the IF_MODE register in two stages, first in
.phylink_mac_config (which incorrectly cleared out a bunch of stuff),
then we update the speed and duplex to the correct values in
.phylink_mac_link_up. Maybe loopback mode was broken.

Thanks!
