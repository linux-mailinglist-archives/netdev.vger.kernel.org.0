Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 805E62B5E03
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 12:10:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728220AbgKQLJ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 06:09:27 -0500
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:10704 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727267AbgKQLJ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 06:09:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1605611367; x=1637147367;
  h=references:from:to:cc:subject:in-reply-to:date:
   message-id:mime-version;
  bh=EH841G87dGNBNV2s4l1T/JKSnRrnO9+AX7+FxZUsGfA=;
  b=VXM2Z//ssFcynFDUCh3LsuMsH+Reo3RT6Ye23+xPyupb6/yzhVvRCGug
   U1qYqsFm+5lYfUojcurHLqWdRW4v/Cd5dMbdDu0nZusU3h5ZtsL9RmwWb
   zSl9QJsKXC8HwNLvUrpqqYmKfbPavbnaLmfFK4EcwU6O918DWwFVbTjeC
   zhwGsrIWRSuGymmIiihxUaboYU2wqsKwPMcZhuPpcV45IJqgmyBN3NBI0
   sYrjCMDNiasi26QQTDNXm43sigwOZwk+TsG5NapD60ATjtpP6QBQFaOJu
   k69cmlmVBIc3PWBA6M0a/Qk7MGqyatXsgwHGcZwPtJhXZetRBPjYsNmvW
   Q==;
IronPort-SDR: SLbY2ruvV7EnKhrDAyNn8E7FJ9mQE5Rnwqs0yPBy8qD8PibdwCBTM7lkmeWy1iF5tPDyWERv+Y
 ATnEllerhduQNfY2EteykTO2wTuzh0i2up5jrMF/UCocCqDDNbjsohFnaoGkgK9LpoYvrlNqGY
 ngiI6Re/cQaUjIBXWx4Owc9C4M9QY2tn2WddJdzTFW1v+I5XhzZOffmiV4kP19XaOzrTkRN+Nu
 9M17SJuzgZg3f8oK0b99hRaaCk9h5jUifcqDSNfGoU+FpAy4Jdb8/9TOz+meTjZnpexFDod5Bd
 itY=
X-IronPort-AV: E=Sophos;i="5.77,485,1596524400"; 
   d="scan'208";a="98732930"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Nov 2020 04:09:27 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 17 Nov 2020 04:09:26 -0700
Received: from soft-dev2.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3
 via Frontend Transport; Tue, 17 Nov 2020 04:09:24 -0700
References: <20201110100642.2153-1-bjarni.jonasson@microchip.com> <20201110102552.GZ1551@shell.armlinux.org.uk> <87blg5qou5.fsf@microchip.com> <20201110151248.GA1551@shell.armlinux.org.uk> <87a6voqntq.fsf@microchip.com> <20201115121921.GI1551@shell.armlinux.org.uk>
User-agent: mu4e 0.9.18; emacs 25.2.2
From:   Bjarni Jonasson <bjarni.jonasson@microchip.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
CC:     Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        UNGLinuxDriver <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH] phy: phylink: Fix CuSFP issue in phylink
In-Reply-To: <20201115121921.GI1551@shell.armlinux.org.uk>
Date:   Tue, 17 Nov 2020 12:09:22 +0100
Message-ID: <877dqkqly5.fsf@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Russell King - ARM Linux admin writes:

> On Wed, Nov 11, 2020 at 09:52:18AM +0100, Bjarni Jonasson wrote:
>>
>> Russell King - ARM Linux admin writes:
>>
>> > On Tue, Nov 10, 2020 at 03:16:34PM +0100, Bjarni Jonasson wrote:
>> >>
>> >> Russell King - ARM Linux admin writes:
>> >>
>> >> > On Tue, Nov 10, 2020 at 11:06:42AM +0100, Bjarni Jonasson wrote:
>> >> >> There is an issue with the current phylink driver and CuSFPs which
>> >> >> results in a callback to the phylink validate function without any
>> >> >> advertisement capabilities.  The workaround (in this changeset)
>> >> >> is to assign capabilities if a 1000baseT SFP is identified.
>> >> >
>> >> > How does this happen?  Which PHY is being used?
>> >>
>> >> This occurs just by plugging in the CuSFP.
>> >> None of the CuSFPs we have tested are working.
>> >> This is a dump from 3 different CuSFPs, phy regs 0-3:
>> >> FS SFP: 01:40:79:49
>> >> HP SFP: 01:40:01:49
>> >> Marvel SFP: 01:40:01:49
>> >> This was working before the delayed mac config was implemented (in dec
>> >> 2019).
>> >
>> > You're dumping PHY registers 0 and 1 there, not 0 through 3, which
>> > the values confirm. I don't recognise the format either. PHY registers
>> > are always 16-bit.
>> Sorry about that. Here is it again:
>> Marvell SFP : 0x0140 0x0149 0x0141 0x0cc1
>> FS SFP      : 0x1140 0x7949 0x0141 0x0cc2
>> Cisco SFP   : 0x0140 0x0149 0x0141 0x0cc1
>> I.e. its seems to be a Marvell phy (0x0141) in all cases.
>> And this occurs when phylink_start() is called.
>
> So they're all 88E1111 devices, which is the most common PHY for
> CuSFPs.
>
> Do you have the Marvell PHY driver either built-in or available as a
> module? I suspect the problem is you don't. You will need the Marvell
> PHY driver to correctly drive the PHY, you can't rely on the fallback
> driver for SFPs.
Correct.  I was using the generic driver and that does clearly not
work.  After including the Marvell driver the callback to the validate
function happens as expected.  Thanks for the support.
--
Bjarni Jonasson Microchip
