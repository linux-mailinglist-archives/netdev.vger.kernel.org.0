Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8199749CBBD
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 15:02:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241874AbiAZOCz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 09:02:55 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:55526 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234931AbiAZOCy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jan 2022 09:02:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=9IeG5KzbMlvWnu66VCUZdgobTcmnNfYSNkQ/p5kg02M=; b=lMRcY7SmT3141LGWwtXJxF95zu
        PARIw6Np2hDA3LxhLRVXDpBHtX6TVq3PQjarXHGU/AbpH3BryR11CeDs9aOg9BPu307gnUd5N7W7a
        pyjq/gkkTmL3fT6bS/ytEyQwrsj8xnt9E/ylhR0VUPOwCXEURRoRnDWpp+JAUSzGeOxk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nCiso-002ofv-U5; Wed, 26 Jan 2022 15:02:46 +0100
Date:   Wed, 26 Jan 2022 15:02:46 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Marcin Wojtas <mw@semihalf.com>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Markus Koch <markus@notsyncing.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 4/5] net/fsl: xgmac_mdio: Support setting the
 MDC frequency
Message-ID: <YfFUhn+T2SYCaTHc@lunn.ch>
References: <20220126101432.822818-1-tobias@waldekranz.com>
 <20220126101432.822818-5-tobias@waldekranz.com>
 <YfFHmkFXtlVus9IW@lunn.ch>
 <87r18ubp57.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r18ubp57.fsf@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> >> +	if (device_property_read_u32(dev, "clock-frequency", &priv->mdc_freq))
> >> +		return;
> >> +
> >> +	priv->enet_clk = devm_clk_get(dev, NULL);
> >> +	if (IS_ERR(priv->enet_clk)) {
> >> +		dev_err(dev, "Input clock unknown, not changing MDC frequency");
> >
> > Is the clock optional or mandatory?
> 
> As the code is now, it is mandatory. I could add some default frequency,
> but I fear that could do more harm than good?

As i said in the reply to the DT patch, it is mandatory if the
"clock-frequency" parameter is present.

> Ok, no worries about regressions for deployed stuff already out there?

It would only cause a regression if a DT blob happened to have a
'clock-frequency' parameter and not clock, which it should not.

        Andrew
