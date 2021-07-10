Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32E653C2BEB
	for <lists+netdev@lfdr.de>; Sat, 10 Jul 2021 02:08:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231438AbhGJAKo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 20:10:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:39568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230409AbhGJAKo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Jul 2021 20:10:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A28EC610FB;
        Sat, 10 Jul 2021 00:07:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625875679;
        bh=AJKBC8B4izA+7NYU6wL8JyNLV++Lg0eJux7bSCAJ60A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JQqyuCNnX4bIU9UPdB7bjabLhXBoT7c3vAVDINxFy0tShVhYRsbHa3PHHrZbrHnPv
         mfdFn92yGlopjKxNyg1BttJ2XUNFKNIZJ5Y+hIsXa5asblZKepnKrAzRMPqO6dUUcU
         /V6XEaH+aU8Xvnq4oQhUNGrO/hSLby+qaBMg1W5Xv49aHmtMnDoXG3vvYb/NJ5xk9h
         aFS+MDgEw+xXW52OWBC+FAquZ5bQUKebTHauTu9GFomGoF8cXfYvkJZcq/gXzQME/U
         GRkjs419qpy4SMGPY02n1xLFNjUsDk1lJ0RMNKf4MAVuB3vOvp641oioikiPV38Z0X
         v0GiX4fOmhmPQ==
Received: by pali.im (Postfix)
        id 18DB377D; Sat, 10 Jul 2021 02:07:57 +0200 (CEST)
Date:   Sat, 10 Jul 2021 02:07:56 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Maximilian Luz <luzmaximilian@gmail.com>
Cc:     Jonas =?utf-8?Q?Dre=C3=9Fler?= <verdre@v0yd.nl>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tsuchiya Yuto <kitakar@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH v2 2/2] mwifiex: pcie: add reset_d3cold quirk for Surface
 gen4+ devices
Message-ID: <20210710000756.4j3tte63t5u6bbt4@pali>
References: <20210709173013.vkavxrtz767vrmej@pali>
 <89a60b06-b22d-2ea8-d164-b74e4c92c914@gmail.com>
 <20210709184443.fxcbc77te6ptypar@pali>
 <251bd696-9029-ec5a-8b0c-da78a0c8b2eb@gmail.com>
 <20210709194401.7lto67x6oij23uc5@pali>
 <4e35bfc1-c38d-7198-dedf-a1f2ec28c788@gmail.com>
 <20210709212505.mmqxdplmxbemqzlo@pali>
 <bfbb3b4d-07f7-1b97-54f0-21eba4766798@gmail.com>
 <20210709225433.axpzdsfbyvieahvr@pali>
 <89c9d1b8-c204-d028-9f2c-80d580dabb8b@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <89c9d1b8-c204-d028-9f2c-80d580dabb8b@gmail.com>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Saturday 10 July 2021 02:00:08 Maximilian Luz wrote:
> On 7/10/21 12:54 AM, Pali Rohár wrote:
> 
> [...]
> 
> > > Also not sure if this is just my bias, but it feels like the Surface
> > > line always had more problems with that driver (and firmware) than
> > > others.
> > 
> > Ehm, really? I see reports also from non-Surface users about bad quality
> > of these 88W[89]xxx cards and repeating firmware issues. I have bad
> > personal experience with 88W8997 SDIO firmware and lot of times I get
> > advice about ex-Marvell/NXP wifi cards "do not touch and run away
> > quickly".
> 
> Yeah, then I'm probably biased since I'm mostly dealing with Surface
> stuff.
> 
> > I think that more people if they get mPCIe/M.2 wifi card in laptop which
> > does not work, they just replace it with some working one. And not
> > spending infinite time in trying to fix it... So this may explain why
> > there are more Surface users with these issues...
> 
> That might be an explanation. If it wouldn't need a heat-gun to open it
> up, I'd probably have done that at some point in the past (there were
> times when WiFi at my Uni was pretty much unusable with this device...
> and I'm still not sure what fixed that or even if it's fixed completely).
> 
> > > I'm honestly a bit surprised that MS stuck with them for this
> > > long (they decided to go with Intel for 7th gen devices). AFAICT they
> > > initially chose Marvell due to connected standby support, so maybe that
> > > causes issue for us and others simply aren't using that feature? Just
> > > guessing though.
> > 
> > In my opinion that "Connected Standby" is just MS marketing term.
> 
> I can only really repeat what I've been told: Apparently when they
> started designing those devices, the only option with "Connected
> standby" (or probably rather that feature set that MS wanted) was,
> unfortunately for us, Marvell.
> 
> > 88W[89]xxx chips using full-mac firmware and drivers [*]. Full-mac lot
> > of times causing more issues than soft-mac solution. Moreover this
> > Marvell firmware implements also other "application" layers in firmware
> > which OS drivers can use, e.g. there is fully working "wpa-supplicant"
> > replacement and also AP part. Maybe windows drivers are using it and it
> > cause less problems? Duno. mwifiex uses only "low level" commands and
> > WPA state machine is implemented in userspace wpa-supplicant daemon.
> > 
> > [*] - Small note: There are also soft-mac firmwares and drivers but
> > apparently Marvell has never finished linux driver and firmware was not
> > released to public...
> > 
> > And there is also Laird Connectivity which offers their own proprietary
> > linux kernel drivers with their own firmware for these 88W[89]xxx chips.
> > Last time I checked it they released some parts of driver on github.
> > Maybe somebody could contact Laird or check if their driver can be
> > replaced by mwifiex? Or just replacing ex-Marvell/NXP firmware by their?
> > But I'm not sure if they have something for 88W8897.
> 
> Interesting, I was not aware of this. IIRC we've been experimenting with
> the mwlwifi driver (which that lrdmwl driver seems to be based on?), but
> couldn't get that to work with the firmware we have.

mwlwifi is that soft-mac driver and uses completely different firmware.
For sure it would not work with current full-mac firmware.

> IIRC it also didn't
> work with the Windows firmware (which seems to be significantly
> different from the one we have for Linux and seems to use or be modeled
> after some special Windows WiFi driver interface).

So... Microsoft has different firmware for this chip? And it is working
with mwifiex driver?
