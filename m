Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53F4A2C2932
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 15:17:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388729AbgKXOPq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 09:15:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388725AbgKXOPq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 09:15:46 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9F2EC0613D6
        for <netdev@vger.kernel.org>; Tue, 24 Nov 2020 06:15:45 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=[IPv6:::1])
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <a.fatoum@pengutronix.de>)
        id 1khZ6a-0007Kt-S4; Tue, 24 Nov 2020 15:15:40 +0100
Subject: Re: [PATCH] net: stmmac: add flexible PPS to dwmac 4.10a
To:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Antonio Borneo <antonio.borneo@st.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        has <has@pengutronix.de>
References: <20191007154306.95827-1-antonio.borneo@st.com>
 <20191007154306.95827-5-antonio.borneo@st.com>
 <20191009152618.33b45c2d@cakuba.netronome.com>
From:   Ahmad Fatoum <a.fatoum@pengutronix.de>
Message-ID: <42960ede-9355-1277-9a6f-4eac3c22365c@pengutronix.de>
Date:   Tue, 24 Nov 2020 15:15:37 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20191009152618.33b45c2d@cakuba.netronome.com>
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

Hello Jakub,

On 10.10.19 00:26, Jakub Kicinski wrote:
> On Mon, 7 Oct 2019 17:43:06 +0200, Antonio Borneo wrote:
>> All the registers and the functionalities used in the callback
>> dwmac5_flex_pps_config() are common between dwmac 4.10a [1] and
>> 5.00a [2].
>>
>> Reuse the same callback for dwmac 4.10a too.
>>
>> Tested on STM32MP15x, based on dwmac 4.10a.
>>
>> [1] DWC Ethernet QoS Databook 4.10a October 2014
>> [2] DWC Ethernet QoS Databook 5.00a September 2017
>>
>> Signed-off-by: Antonio Borneo <antonio.borneo@st.com>
> 
> Applied to net-next.

This patch seems to have been fuzzily applied at the wrong location.
The diff describes extension of dwmac 4.10a and so does the @@ line:

  @@ -864,6 +864,7 @@ const struct stmmac_ops dwmac410_ops = {

The patch was applied mainline as 757926247836 ("net: stmmac: add
flexible PPS to dwmac 4.10a"), but it extends dwmac4_ops instead:

  @@ -938,6 +938,7 @@ const struct stmmac_ops dwmac4_ops = {

I don't know if dwmac4 actually supports FlexPPS, so I think it's
better to be on the safe side and revert 757926247836 and add the
change for the correct variant.

Cheers,
Ahmad


-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
