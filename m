Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F4A8380CD2
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 17:24:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233746AbhENPZU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 11:25:20 -0400
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:34401 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231590AbhENPZT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 11:25:19 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailnew.nyi.internal (Postfix) with ESMTP id 36D1C58116B;
        Fri, 14 May 2021 11:23:55 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Fri, 14 May 2021 11:23:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=animalcreek.com;
         h=date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=yv38+k95PhYFZEV25jgoJeWF+VJ
        CV6ohBX/tbnUga10=; b=D+0j36r329938MFly65x++2zfGz1IQF9FNzMTWiH87E
        qVMHVpFPraKxouMhfhGjn2mj0zVBB0b4TqPCUIhosEh175sD6lDD6AJim5rE70fu
        xQLBCppnO9Vpaz9qlhoXdcFpPCE/tXezth1CDBAiTCvLePjlsYm4hzRsszpAUPzn
        p0tg3fRDAdbmr1meHB4Pe6+c3Ctqs+Gg/MBouoG6V78BUvyLOCBrDrNYZFTssD9K
        Qf85m7M0g7GkDEOR6vxFSihE6cTfrR8tC7NiOl6VJlmnbxyQmXZ4jx8VsZRmLbbI
        C62glRVJIonXNs0fTeMOWKjKf7Sqy8fAT/VXKrm0uOg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=yv38+k
        95PhYFZEV25jgoJeWF+VJCV6ohBX/tbnUga10=; b=UdtvsxgXZ4lFIBl5K/6m9o
        tDn+/i5jGGfNjTV0OdUwA7Je1IswP0fQzOV4mEZld36nOgOCm2DuQ20SOp64bSjR
        XfyG15kqpIl/v/V/q+/sqwkNOV9k9SBQ9GCoRBw2jFlelVn6KGeE5OpObzqOrINf
        dscRWkQIhXYfD9Zc6U/PNxFJot2pEXkSGUvjc9orE39o2d1diVbaLTt0D8pBelsk
        NiQJTaLylCI4K1HM5wlua3l9C68oG34Q7GuuFU1vQx9wDb42J8+uGTpv+F4T1Gas
        gpFEZnhMyzWMz85OwNvPZmZ06eGk+aU0de5dswBRi1qXRlMuLYLOJiEiKuxz3SNw
        ==
X-ME-Sender: <xms:CJaeYIyjhwrrCS2aoaJQ5MTtGlq8RxEpzIB2Jnh7zH0VrLpKPCG9YA>
    <xme:CJaeYMSGts3gMifU6wt81PQi0kLg3moiz1qvK7Hwjz9iSwr3qPwpEyBQkkrUAVVNT
    wy2Roi_PvCIjLJs3A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehjedgvdeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjohesthdtredttddtvdenucfhrhhomhepofgrrhhk
    ucfirhgvvghruceomhhgrhgvvghrsegrnhhimhgrlhgtrhgvvghkrdgtohhmqeenucggtf
    frrghtthgvrhhnpedujeelgeejleegleevkeekvdevudfhteeuiedtleehtdduleelvdei
    fffhvdehtdenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeejtddrudejvd
    drfedvrddvudeknecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhf
    rhhomhepmhhgrhgvvghrsegrnhhimhgrlhgtrhgvvghkrdgtohhm
X-ME-Proxy: <xmx:CJaeYKXR27-qZhOXN64kHxQLdKCGi_WYhilI_SiMqsXqSyacnrJliA>
    <xmx:CJaeYGjt8c1GsnHGru4_06o5CnifHahDLc9omOXr3tSOTZdNol0sWg>
    <xmx:CJaeYKBJcVMFoFIHC8oTZLHVdUqnpxuyVQuGu85X8HCV2b-VXWf34g>
    <xmx:C5aeYG1t5oSY0PGig15x7jWyhmPNpHA8-y3Zf2SNOwKCXZvJPiaZ2A>
Received: from blue.animalcreek.com (ip70-172-32-218.ph.ph.cox.net [70.172.32.218])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Fri, 14 May 2021 11:23:52 -0400 (EDT)
Received: by blue.animalcreek.com (Postfix, from userid 1000)
        id E4032136008E; Fri, 14 May 2021 08:23:50 -0700 (MST)
Date:   Fri, 14 May 2021 08:23:50 -0700
From:   Mark Greer <mgreer@animalcreek.com>
To:     Stephan Gerhold <stephan@gerhold.net>
Cc:     Mark Greer <mgreer@animalcreek.com>,
        Frieder Schrempf <frieder.schrempf@kontron.de>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-nfc@lists.01.org,
        Alex Blasche <alexander.blasche@qt.io>,
        phone-devel@vger.kernel.org
Subject: Re: Testing wanted for Linux NFC subsystem
Message-ID: <20210514152350.GA301895@animalcreek.com>
References: <20210512144319.30852-1-krzysztof.kozlowski@canonical.com>
 <14e78a9a-ed1a-9d7d-b854-db6d811f4622@kontron.de>
 <20210512170135.GB222094@animalcreek.com>
 <YJ0SYWJjq3ZmXMy3@gerhold.net>
 <20210513144855.GA266838@animalcreek.com>
 <YJ1Hr/hov9I42GK1@gerhold.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YJ1Hr/hov9I42GK1@gerhold.net>
Organization: Animal Creek Technologies, Inc.
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 13, 2021 at 05:37:19PM +0200, Stephan Gerhold wrote:
> On Thu, May 13, 2021 at 07:48:55AM -0700, Mark Greer wrote:
> > On Thu, May 13, 2021 at 01:49:53PM +0200, Stephan Gerhold wrote:
> > > I have a couple of "recycled" smartphones running mainline Linux
> > > and some of them do have NFC chips. I have two with NXP PN547
> > > (supported by nxp,nxp-nci-i2c), one with Samsung S3FWRN5
> > > (samsung,s3fwrn5-i2c) and even one with Broadcom BCM2079x I think
> > > (this one does not have a driver for the Linux NFC subsystem sadly).
> > > 
> > > +Cc phone-devel@vger.kernel.org, in case other people there are
> > > interested in NFC :)
> > > 
> > > The NXP/Samsung ones seems to work just fine. However, since there are
> > > barely any userspace tools making use of Linux NFC all my testing so far
> > > was limited to polling for devices with "nfctool" and being happy enough
> > > when it realizes that I hold some NFC tag close to the device. :S
> > 
> > There is a user-level daemon that is the counterpart for the in-kernel
> > NFC subsystem.  It is called neard and is available here:
> > 
> > 	git://git.kernel.org/pub/scm/network/nfc/neard.git
> > 
> > There are a few test script in it that will let you read and write NFC
> > tags, and do some other things.  We can add some more tests to that set
> > as we go.
> > 
> 
> Yeah, I packaged that for Alpine Linux / postmarketOS.
> "nfctool" also comes from "neard" as far as I can tell :)
> 
> I think I also played with the Neard test scripts a bit at some point,
> and managed to read some NFC tag thing inside an old Yubikey NEO
> that I found, but didn't really know what else to do.

Yeah, there isn't a whole lot you can do but beyond reading/writing
tags and peer-to-peer, there are things like Bluetooth and Wifi
handover, Android Application Record support, and at least some
support for Secure Engine.

> > > I would be happy to do some more testing if someone has something useful
> > > that can be tested. However, I guess ideally we would have someone who
> > > actually uses Linux NFC actively for some real application. :)
> > 
> > Ideally, you should have some NFC tags of various types.  Types 2, 3,
> > 4A, 4B, and 5 tags are supported.  Peer-to-peer mode is supported too

I should have mentioned type 1 as well but I don't have the hardware
to test it.

> > so you should be able to transfer data from one of your phones to the
> > other over NFC (and do a BT hand-over, if you're interested).
> > 
> 
> I guess this is where I kind of lack hardware as well at the moment,
> I don't have any programmable NFC tags at the moment (although I guess
> those should be quite cheap). I might play with the peer-to-peer mode
> a bit when I find time.

Please let me/us know how it goes.

> > Note that the specified range for NFC is only 4 cm and poor antenna
> > design, etc. means that the actual range is usually much less (e.g.,
> > they amost have to touch).  Also note that there are timing constraints
> > so you may need to make the scheduling priority of the interrupt thread
> > of your NFC driver real-time.
> > 
> 
> Yeah I noticed, always need to search for a while to find the right spot
> on the phone. :)

Yeah, it can be an Easter egg hunt on many phones.  :)

Mark
--
