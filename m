Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78DD22D7916
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 16:21:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437805AbgLKPVN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 10:21:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390872AbgLKPUe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 10:20:34 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF115C0613CF
        for <netdev@vger.kernel.org>; Fri, 11 Dec 2020 07:19:53 -0800 (PST)
Received: from erdnuss.hi.pengutronix.de ([2001:67c:670:100:2e4d:54ff:fe9d:849c])
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mci@pengutronix.de>)
        id 1knkD1-0003gD-1L; Fri, 11 Dec 2020 16:19:51 +0100
Subject: Re: [PATCH] net: ethernet: fec: Clear stale flag in IEVENT register
 before MII transfers
To:     =?UTF-8?Q?Uwe_Kleine-K=c3=b6nig?= <u.kleine-koenig@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, Fugang Duan <fugang.duan@nxp.com>,
        "David S. Miller" <davem@davemloft.net>, kernel@pengutronix.de
References: <20201209102959.2131-1-u.kleine-koenig@pengutronix.de>
 <20201209144413.GJ2611606@lunn.ch>
 <20201209165148.6kbntgmjopymomx5@pengutronix.de>
From:   Marian Cichy <mci@pengutronix.de>
Message-ID: <dbf9184d-adb2-6377-414b-0593ecb89149@pengutronix.de>
Date:   Fri, 11 Dec 2020 16:19:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201209165148.6kbntgmjopymomx5@pengutronix.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-SA-Exim-Connect-IP: 2001:67c:670:100:2e4d:54ff:fe9d:849c
X-SA-Exim-Mail-From: mci@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/9/20 5:51 PM, Uwe Kleine-König wrote:
> Hi Andrew,
>
> On Wed, Dec 09, 2020 at 03:44:13PM +0100, Andrew Lunn wrote:
>> On Wed, Dec 09, 2020 at 11:29:59AM +0100, Uwe Kleine-König wrote:
>> Do you have
>>
>> ommit 1e6114f51f9d4090390fcec2f5d67d8cc8dc4bfc
>> Author: Greg Ungerer <gerg@linux-m68k.org>
>> Date:   Wed Oct 28 15:22:32 2020 +1000
>>
>>      net: fec: fix MDIO probing for some FEC hardware blocks
>>      
>>      Some (apparently older) versions of the FEC hardware block do not like
>>      the MMFR register being cleared to avoid generation of MII events at
>>      initialization time. The action of clearing this register results in no
>>      future MII events being generated at all on the problem block. This means
>>      the probing of the MDIO bus will find no PHYs.
>>      
>>      Create a quirk that can be checked at the FECs MII init time so that
>>      the right thing is done. The quirk is set as appropriate for the FEC
>>      hardware blocks that are known to need this.
>>
>> in your tree?
> Unless I did something wrong I also saw the failure with v5.10-rc$latest
> earlier today.
>
> ... some time later ...
>
> Argh, I checked my git reflog and the newest release I tested was
> 5.9-rc8.
>
> I wonder if my patch is a simpler and more straight forward fix for the
> problem however, but that might also be because I don't understand the
> comment touched by 1e6114f51f9d4090390fcec2f5d67d8cc8dc4bfc without
> checking the reference manual (which I didn't).
>
> @Marian: As it's you who has to work on this i.MX25 machine, can you
> maybe test if using a kernel > 5.10-rc3 (or cherry-picking
> 1e6114f51f9d4090390fcec2f5d67d8cc8dc4bfc) fixes the problem for you?

Tested it on 5.10-rc7 and the problem is fixed without your previous patch.

Best regards,
Marian

>
> Best regards
> Uwe
>

