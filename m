Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 378F144AF55
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 15:19:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235273AbhKIOWb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 09:22:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235140AbhKIOWa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Nov 2021 09:22:30 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C4C6C061764
        for <netdev@vger.kernel.org>; Tue,  9 Nov 2021 06:19:43 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=[127.0.0.1])
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <a.fatoum@pengutronix.de>)
        id 1mkRyH-0003AW-2g; Tue, 09 Nov 2021 15:19:33 +0100
From:   Ahmad Fatoum <a.fatoum@pengutronix.de>
Subject: Re: [Linux-stm32] [PATCH net] net: stmmac: allow a tc-taprio
 base-time of zero
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>,
        Holger Assmann <h.assmann@pengutronix.de>
Cc:     Yannick Vignon <yannick.vignon@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Pengutronix Kernel Team <kernel@pengutronix.de>
References: <20211108202854.1740995-1-vladimir.oltean@nxp.com>
 <87bl2t3fkq.fsf@kurt> <20211109103504.ahl2djymnevsbhoj@skbuf>
Message-ID: <6bf6db8b-4717-71fe-b6de-9f6e12202dad@pengutronix.de>
Date:   Tue, 9 Nov 2021 15:19:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211109103504.ahl2djymnevsbhoj@skbuf>
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

Hello Vladimir, Kurt,

On 09.11.21 11:35, Vladimir Oltean wrote:
> On Tue, Nov 09, 2021 at 09:20:53AM +0100, Kurt Kanzenbach wrote:
>> Hi Vladimir,
>>
>> On Mon Nov 08 2021, Vladimir Oltean wrote:
>>> Commit fe28c53ed71d ("net: stmmac: fix taprio configuration when
>>> base_time is in the past") allowed some base time values in the past,
>>> but apparently not all, the base-time value of 0 (Jan 1st 1970) is still
>>> explicitly denied by the driver.
>>>
>>> Remove the bogus check.
>>>
>>> Fixes: b60189e0392f ("net: stmmac: Integrate EST with TAPRIO scheduler API")
>>> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
>>
>> I've experienced the same problem and wanted to send a patch for
>> it. Thanks!
>>
>> Reviewed-by: Kurt Kanzenbach <kurt@linutronix.de>
> 
> Cool. So you had that patch queued up? What other stmmac patches do you
> have queued up? :) Do you have a fix for the driver setting the PTP time
> every time when SIOCSHWTSTAMP is called? This breaks the UTC-to-TAI
> offset established by phc2sys and it takes a few seconds to readjust,
> which is very annoying.

Sounds like the same issue in:
https://lore.kernel.org/netdev/20201216113239.2980816-1-h.assmann@pengutronix.de/

Cheers,
Ahmad

> _______________________________________________
> Linux-stm32 mailing list
> Linux-stm32@st-md-mailman.stormreply.com
> https://st-md-mailman.stormreply.com/mailman/listinfo/linux-stm32
> 


-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
