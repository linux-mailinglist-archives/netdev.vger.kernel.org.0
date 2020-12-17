Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9183F2DD994
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 20:59:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729613AbgLQT67 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 14:58:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726548AbgLQT66 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Dec 2020 14:58:58 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72600C0617A7
        for <netdev@vger.kernel.org>; Thu, 17 Dec 2020 11:58:18 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=[IPv6:::1])
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <a.fatoum@pengutronix.de>)
        id 1kpzPi-0000XD-0w; Thu, 17 Dec 2020 20:58:14 +0100
Subject: Re: [PATCH 1/2] net: stmmac: retain PTP-clock at hwtstamp_set
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Holger Assmann <h.assmann@pengutronix.de>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Rayagond Kokatanur <rayagond@vayavyalabs.com>,
        kernel@pengutronix.de, Michael Olbrich <m.olbrich@pengutronix.de>,
        Jose Abreu <Jose.Abreu@synopsys.com>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Richard Cochran <richardcochran@gmail.com>,
        =?UTF-8?Q?Uwe_Kleine-K=c3=b6nig?= <u.kleine-koenig@pengutronix.de>
References: <20201216113239.2980816-1-h.assmann@pengutronix.de>
 <20201216171334.1e36fbff@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <ae5371c0-ea53-6885-a25b-b44e9fe0b615@pengutronix.de>
 <20201217095943.6b17db4f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Ahmad Fatoum <a.fatoum@pengutronix.de>
Message-ID: <ceb51db5-5b7e-752a-8d0b-8bcea6aa2a5c@pengutronix.de>
Date:   Thu, 17 Dec 2020 20:58:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201217095943.6b17db4f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: a.fatoum@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17.12.20 18:59, Jakub Kicinski wrote:
> On Thu, 17 Dec 2020 09:25:48 +0100 Ahmad Fatoum wrote:
>> On 17.12.20 02:13, Jakub Kicinski wrote:
>>>> +			netdev_warn(priv->dev, "HW Timestamping init failed: %pe\n",
>>>> +					ERR_PTR(ret));  
>>>
>>> why convert to ERR_PTR and use %pe and not just %d?  
>>
>> To get a symbolic error name if support is compiled in (note the `e' after %p).
> 
> Cool, GTK. Kind of weird we there is no equivalent int decorator, tho.
> Do you happen to know why?
New format-specifiers should be using %p<extension>, which is already established,
said the reviewers:

https://lore.kernel.org/lkml/20200120085508.25522-1-u.kleine-koenig@pengutronix.de/

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
