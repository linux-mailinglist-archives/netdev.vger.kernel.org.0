Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5EF4254FF7
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 22:24:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726322AbgH0UYD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 16:24:03 -0400
Received: from hosting.gsystem.sk ([212.5.213.30]:42652 "EHLO
        hosting.gsystem.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726120AbgH0UYD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 16:24:03 -0400
Received: from [192.168.0.2] (188-167-68-178.dynamic.chello.sk [188.167.68.178])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hosting.gsystem.sk (Postfix) with ESMTPSA id 0983B7A02B7;
        Thu, 27 Aug 2020 22:23:59 +0200 (CEST)
From:   Ondrej Zary <linux@zary.sk>
To:     Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [PATCH 12/30] net: wireless: cisco: airo: Fix a myriad of coding style issues
Date:   Thu, 27 Aug 2020 22:23:57 +0200
User-Agent: KMail/1.9.10
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Lee Jones <lee.jones@linaro.org>, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        Benjamin Reed <breed@users.sourceforge.net>,
        Javier Achirica <achirica@users.sourceforge.net>,
        Jean Tourrilhes <jt@hpl.hp.com>,
        "Fabrice Bellet" <fabrice@bellet.info>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
References: <20200814113933.1903438-1-lee.jones@linaro.org> <202008172335.02988.linux@zary.sk> <87v9h4le9z.fsf@codeaurora.org>
In-Reply-To: <87v9h4le9z.fsf@codeaurora.org>
X-KMail-QuotePrefix: > 
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <202008272223.57461.linux@zary.sk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thursday 27 August 2020 09:49:12 Kalle Valo wrote:
> Ondrej Zary <linux@zary.sk> writes:
> 
> > On Monday 17 August 2020 20:27:06 Jesse Brandeburg wrote:
> >> On Mon, 17 Aug 2020 16:27:01 +0300
> >> Kalle Valo <kvalo@codeaurora.org> wrote:
> >> 
> >> > I was surprised to see that someone was using this driver in 2015, so
> >> > I'm not sure anymore what to do. Of course we could still just remove
> >> > it and later revert if someone steps up and claims the driver is still
> >> > usable. Hmm. Does anyone any users of this driver?
> >> 
> >> What about moving the driver over into staging, which is generally the
> >> way I understood to move a driver slowly out of the kernel?
> >
> > Please don't remove random drivers.
> 
> We don't want to waste time on obsolete drivers and instead prefer to
> use our time on more productive tasks. For us wireless maintainers it's
> really hard to know if old drivers are still in use or if they are just
> broken.
> 
> > I still have the Aironet PCMCIA card and can test the driver.
> 
> Great. Do you know if the airo driver still works with recent kernels?

Yes, it does.

$ uname -a
Linux test 5.7.0-0.bpo.2-686 #1 SMP Debian 5.7.10-1~bpo10+1 (2020-07-30) i686 GNU/Linux

# dmesg | grep airo
[   22.002273] airo(): Probing for PCI adapters
[   22.002422] airo(): Finished probing for PCI adapters
[   23.796853] airo(): cmd:111 status:7f11 rsp0:2 rsp1:0 rsp2:0
[   23.796879] airo(): Doing fast bap_reads
[   24.021208] airo(eth1): Firmware version 5.60.22
[   24.021238] airo(eth1): WPA supported.
[   24.021251] airo(eth1): MAC enabled xx:xx:xx:xx:xx:xx
[   24.062695] airo_cs 0.0 eth35: renamed from eth1
[   50.308100] airo(eth35): Bad MAC enable reason=eaac, rid=e, offset=0
[   50.332761] airo(eth35): Bad MAC enable reason=eaac, rid=e, offset=0

# wpa_supplicant -Dwext -ieth35 -c/etc/wpa_supplicant/wpa_supplicant.conf &
Successfully initialized wpa_supplicant
rfkill: Cannot get wiphy information
ioctl[SIOCSIWENCODEEXT]: Invalid argument
ioctl[SIOCSIWENCODEEXT]: Invalid argument
eth35: Trying to associate with xx:xx:xx:xx:xx:xx (SSID='MSI' freq=2462 MHz)
Failed to add supported operating classes IE
ioctl[SIOCSIWGENIE]: Operation not supported
eth35: Association request to the driver failed
eth35: Associated with xx:xx:xx:xx:xx:xx
eth35: CTRL-EVENT-CONNECTED - Connection to xx:xx:xx:xx:xx:xx completed [id=0 id_str=]

# dhclient -d eth35
Internet Systems Consortium DHCP Client 4.4.1
Copyright 2004-2018 Internet Systems Consortium.
All rights reserved.
For info, please visit https://www.isc.org/software/dhcp/

Listening on LPF/eth35/yy:yy:yy:yy:yy:yy
Sending on   LPF/eth35/yy:yy:yy:yy:yy:yy
Sending on   Socket/fallback
DHCPDISCOVER on eth35 to 255.255.255.255 port 67 interval 6
DHCPOFFER of 192.168.1.192 from 192.168.1.254
DHCPREQUEST for 192.168.1.192 on eth35 to 255.255.255.255 port 67
DHCPACK of 192.168.1.192 from 192.168.1.254
bound to 192.168.1.192 -- renewal in 40 seconds.

-- 
Ondrej Zary
