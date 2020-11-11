Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74F792AEC5A
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 09:52:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726198AbgKKIwX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 03:52:23 -0500
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:18627 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725859AbgKKIwW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 03:52:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1605084742; x=1636620742;
  h=references:from:to:cc:subject:message-id:in-reply-to:
   date:mime-version;
  bh=rrIqm04QSC3aas0qYK9KkO9YMBrUS6gc7OMH0lzTqng=;
  b=Krr3HhclB4jrtGNstGotxv0dmm7gnd/CsrASVqO/FYXd2WhqLZBRHun9
   KN4XkRGjEmuDux6kz/oUX5phwpD2Mk8+aBQHv3RGIKcsdriwExChAr5/e
   p6SMSmq7Ej3h/3cP1GI2pZIIBlKemHEm2Qsi7Jkw8FJb05PwiTuL/0xyj
   O1pn4xIu+iJUBklinq0v3OvrnTaaxYQMaLLoAchIaUphQDx5Ke/8AblNk
   6P5quiF8QoMTHpPW71IPEAiDFpbmggvMZ+DE0GlimhAfk8GbfuIdKirwx
   VZ/zUdB8LAgnhrnGG52GA+hAn10YblgHukwsRTlJZvom6P+Qe/DKz1A7J
   g==;
IronPort-SDR: b3W6ktx4LF13xndDR/oV0/XmLcyPlBxSwi8WuZ5JpgmDwYRiB/6hEqDN9H5RXebCwDIc/pxC2g
 tjRu4fE9rkbLAAEkECpt7/+Zg/F3+eTwn5cphTu2UsmJ4dCJpiAi7eqI8aK1LH6fOrlubmunwd
 u4Pxb8tH8LlnuXkhxC60sYwifva+8Q5uGf3RWkx5Or7MJH2sAOMBnvYjj+9s1f+qVY4AuL/KOZ
 omj8aSsI17iaaC4EG+FOlHipLdMn3/lGOXdp3/nfXiF4UBu9EYGDAvkjYRUrbchaRh/tld1xeA
 D2g=
X-IronPort-AV: E=Sophos;i="5.77,469,1596524400"; 
   d="scan'208";a="93262603"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 11 Nov 2020 01:52:21 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 11 Nov 2020 01:52:21 -0700
Received: from soft-dev2.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3
 via Frontend Transport; Wed, 11 Nov 2020 01:52:19 -0700
References: <20201110100642.2153-1-bjarni.jonasson@microchip.com> <20201110102552.GZ1551@shell.armlinux.org.uk> <87blg5qou5.fsf@microchip.com> <20201110151248.GA1551@shell.armlinux.org.uk>
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
Message-ID: <87a6voqntq.fsf@microchip.com>
In-Reply-To: <20201110151248.GA1551@shell.armlinux.org.uk>
Date:   Wed, 11 Nov 2020 09:52:18 +0100
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Russell King - ARM Linux admin writes:

> On Tue, Nov 10, 2020 at 03:16:34PM +0100, Bjarni Jonasson wrote:
>>
>> Russell King - ARM Linux admin writes:
>>
>> > On Tue, Nov 10, 2020 at 11:06:42AM +0100, Bjarni Jonasson wrote:
>> >> There is an issue with the current phylink driver and CuSFPs which
>> >> results in a callback to the phylink validate function without any
>> >> advertisement capabilities.  The workaround (in this changeset)
>> >> is to assign capabilities if a 1000baseT SFP is identified.
>> >
>> > How does this happen?  Which PHY is being used?
>>
>> This occurs just by plugging in the CuSFP.
>> None of the CuSFPs we have tested are working.
>> This is a dump from 3 different CuSFPs, phy regs 0-3:
>> FS SFP: 01:40:79:49
>> HP SFP: 01:40:01:49
>> Marvel SFP: 01:40:01:49
>> This was working before the delayed mac config was implemented (in dec
>> 2019).
>
> You're dumping PHY registers 0 and 1 there, not 0 through 3, which
> the values confirm. I don't recognise the format either. PHY registers
> are always 16-bit.
Sorry about that. Here is it again:
Marvell SFP : 0x0140 0x0149 0x0141 0x0cc1
FS SFP      : 0x1140 0x7949 0x0141 0x0cc2
Cisco SFP   : 0x0140 0x0149 0x0141 0x0cc1
I.e. its seems to be a Marvell phy (0x0141) in all cases.
And this occurs when phylink_start() is called.
--
Bjarni Jonasson, Microchip


