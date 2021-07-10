Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8E943C2C22
	for <lists+netdev@lfdr.de>; Sat, 10 Jul 2021 02:38:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231679AbhGJAlO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 20:41:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:56848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230428AbhGJAlN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Jul 2021 20:41:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0C26A613BF;
        Sat, 10 Jul 2021 00:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625877509;
        bh=QphO8XZjqunxxjGgJByk//J7MuSxi98V+e0NXlqw/yA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=M+8O2OLOEZGXtGoTzRv9f9LfFeXq4W26UkwbgGdHT5trKE10R8vU++Lj4n0yh1wTb
         NGmnijiLfnrQAmWl6LzRCMxHO9pjETcbfRqxx33D6OJj5QyO9gtS7B8Ti0yx1xjyMp
         J0zV08hilomQzno2peGC0NafMhEqvN+bQN2oAmsx5GzTmjkaXzhi7aw6E/5ttNjNP+
         3xIcKZvLRFPcC7eDTBd4YJd8DOS27LMEAKMmT2lUOSsYQJIvGyrVqJ96CrEaMLA4C0
         8cltALToiFtut8rZtnd3hsSjh3g9j4mJME4LAJ3dC39zt8lvQoHY1Mz4z0qHDF6RY6
         gKTXOGNe+ae2g==
Received: by pali.im (Postfix)
        id 7D4E577D; Sat, 10 Jul 2021 02:38:26 +0200 (CEST)
Date:   Sat, 10 Jul 2021 02:38:26 +0200
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
Message-ID: <20210710003826.clnk5sh3cvlamwjr@pali>
References: <20210709184443.fxcbc77te6ptypar@pali>
 <251bd696-9029-ec5a-8b0c-da78a0c8b2eb@gmail.com>
 <20210709194401.7lto67x6oij23uc5@pali>
 <4e35bfc1-c38d-7198-dedf-a1f2ec28c788@gmail.com>
 <20210709212505.mmqxdplmxbemqzlo@pali>
 <bfbb3b4d-07f7-1b97-54f0-21eba4766798@gmail.com>
 <20210709225433.axpzdsfbyvieahvr@pali>
 <89c9d1b8-c204-d028-9f2c-80d580dabb8b@gmail.com>
 <20210710000756.4j3tte63t5u6bbt4@pali>
 <1d45c961-d675-ea80-abe4-8d4bcf3cf8d4@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1d45c961-d675-ea80-abe4-8d4bcf3cf8d4@gmail.com>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Saturday 10 July 2021 02:18:12 Maximilian Luz wrote:
> On 7/10/21 2:07 AM, Pali Rohár wrote:
> 
> [...]
> 
> > > Interesting, I was not aware of this. IIRC we've been experimenting with
> > > the mwlwifi driver (which that lrdmwl driver seems to be based on?), but
> > > couldn't get that to work with the firmware we have.
> > 
> > mwlwifi is that soft-mac driver and uses completely different firmware.
> > For sure it would not work with current full-mac firmware.
> > 
> > > IIRC it also didn't
> > > work with the Windows firmware (which seems to be significantly
> > > different from the one we have for Linux and seems to use or be modeled
> > > after some special Windows WiFi driver interface).
> > 
> > So... Microsoft has different firmware for this chip? And it is working
> > with mwifiex driver?
> 
> I'm not sure how special that firmware really is (i.e. if it is Surface
> specific or just what Marvell uses on Windows), only that it doesn't
> look like the firmware included in the linux-firmware repo. The Windows
> firmware doesn't work with either mwlwifi or mwifiex drivers (IIRC) and
> on Linux we use the official firmware from the linux-firmware repo.

Version available in the linux-firmware repo is also what big companies
(like google) receive for their systems... sometimes just only older
version as Marvell/NXP is slow in updating files in linux-firmware.
Seems that it is also same what receive customers under NDA as more
companies dropped "proprietary" ex-Marvell/NXP driver on internet and it
contained this firmware with some sources of driver which looks like a
fork of mwifiex (or maybe mwifiex is "cleaned fork" of that driver :D)

There is old firmware documentation which describe RPC communication
between OS and firmware:
http://wiki.laptop.org/images/f/f3/Firmware-Spec-v5.1-MV-S103752-00.pdf

It is really old for very old wifi chips and when I checked it, it still
matches what mwifiex is doing with new chips. Just there are new and
more commands. And documentation is OS-neutral.

So if Microsoft has some "incompatible" firmware with this, it could
mean that they got something special which nobody else have? Maybe it
can explain that "connected standby" and maybe also better stability?

Or just windows distribute firmware in different format and needs to
"unpack" or "preprocess" prior downloading it to device?
