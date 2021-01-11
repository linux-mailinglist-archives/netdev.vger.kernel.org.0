Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75C452F0DB0
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 09:14:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727822AbhAKIOF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 03:14:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726611AbhAKIOE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 03:14:04 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 210FDC061795
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 00:13:24 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=[127.0.0.1])
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <h.assmann@pengutronix.de>)
        id 1kysKG-0002Gq-99; Mon, 11 Jan 2021 09:13:20 +0100
Subject: Re: [PATCH 1/2] net: stmmac: retain PTP-clock at hwtstamp_set
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Rayagond Kokatanur <rayagond@vayavyalabs.com>,
        kernel@pengutronix.de, Michael Olbrich <m.olbrich@pengutronix.de>,
        Ahmad Fatoum <a.fatoum@pengutronix.de>,
        Jose Abreu <Jose.Abreu@synopsys.com>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Richard Cochran <richardcochran@gmail.com>
References: <20201216113239.2980816-1-h.assmann@pengutronix.de>
 <20201216171334.1e36fbff@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Holger Assmann <h.assmann@pengutronix.de>
Message-ID: <efb0fe5e-36af-9b36-98d2-e5f006c749d9@pengutronix.de>
Date:   Mon, 11 Jan 2021 09:13:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201216171334.1e36fbff@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: h.assmann@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 17.12.20 um 02:13 Jakub Kicinski wrote:
> 
> Thanks for the patch, minor nits below.

Thanks for the Feedback! I will work it in for my v2.

>> +
>> +	if (!(priv->dma_cap.time_stamp || priv->dma_cap.atime_stamp))
> 
> !a && !b reads better IMHO

We've chosen this variant because it is already used this way in
stmmac_main (e.g. in stmmac_hwtstamp_set(), stmmac_hwtstamp_get(), or
stmmac_validate()).

>> @@ -5290,8 +5330,7 @@ int stmmac_resume(struct device *dev)
>>   		/* enable the clk previously disabled */
>>   		clk_prepare_enable(priv->plat->stmmac_clk);
>>   		clk_prepare_enable(priv->plat->pclk);
>> -		if (priv->plat->clk_ptp_ref)
>> -			clk_prepare_enable(priv->plat->clk_ptp_ref);
>> +		stmmac_init_hwtstamp(priv);
> 
> This was optional, now you always init?

This was not intended. Will be fixed in v2 to be optional again.

Regards,
Holger
