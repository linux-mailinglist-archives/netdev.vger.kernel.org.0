Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47489285306
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 22:24:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727127AbgJFUYm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 16:24:42 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:47221 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725962AbgJFUYl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 16:24:41 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 4C5TTg0rfQz1sFh8;
        Tue,  6 Oct 2020 22:24:38 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 4C5TTf09dkz1qs0b;
        Tue,  6 Oct 2020 22:24:38 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id 6uiGA06vKZ4Z; Tue,  6 Oct 2020 22:24:36 +0200 (CEST)
X-Auth-Info: 9erhqb+3Z1Fo9R5IYhOj9VKQ6gfK1E0/LG3P3DPkjPE=
Received: from [IPv6:::1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Tue,  6 Oct 2020 22:24:35 +0200 (CEST)
Subject: Re: PHY reset question
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     David Jander <david@protonic.nl>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>, mkl@pengutronix.de
References: <20201006080424.GA6988@pengutronix.de>
 <2cc5ea02-707e-dbb5-c081-4c5202bd5815@gmail.com>
From:   Marek Vasut <marex@denx.de>
Message-ID: <42d4c4b2-d3ea-9130-ef7f-3d1955116fdc@denx.de>
Date:   Tue, 6 Oct 2020 22:24:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <2cc5ea02-707e-dbb5-c081-4c5202bd5815@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/6/20 9:36 PM, Florian Fainelli wrote:
[...]
>> - Use compatible ("compatible = "ethernet-phy-id0022.1560") in the
>> devicetree,
>>    so that reading the PHYID is not needed
>>    - easy to solve.
>>    Disadvantage:
>>    - losing PHY auto-detection capability
>>    - need a new devicetree if different PHY is used (for example in
>> different
>>      board revision)
> 
> Or you can punt that to the boot loader to be able to tell the
> difference and populate different compatible, or even manage the PHY
> reset to be able to read the actual PHY OUI. To me that is still the
> best solution around.

Wasn't there some requirement for Linux to be bootloader-independent ?
Some systems cannot replace their bootloaders, e.g. if the bootloader is
in ROM, so this might not be a solution.

>> - modify PHY framework to deassert reset before identifying the PHY.
>>    Disadvantages?

If this happens on MX6 with FEC, can you please try these two patches?

https://patchwork.ozlabs.org/project/netdev/patch/20201006135253.97395-1-marex@denx.de/

https://patchwork.ozlabs.org/project/netdev/patch/20201006202029.254212-1-marex@denx.de/

Thanks!
