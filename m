Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E417437F734
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 13:53:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232997AbhEMLyo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 07:54:44 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.54]:24214 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232944AbhEMLyK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 07:54:10 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1620906600; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=b5bCvZCsuOOJMeQdyb4FxneqWQMi6C8EVl4SJu4b6Y1eqTo8laH9VyUR4+nAv70Um1
    PplVodNLNRXMRxVVw/f3o/9AzL/LcjwfbIioW5O4GvuMOUg35i45oaFnNqL3PYVY+zCg
    8dyNBAB3JqKoA0bztBBX0S4F/rZymVz/xekVi2G7W8YmSy7HhcvrQ+m6acfRmig3AAVF
    2LsWU3BtIHW4eEfPdIkCi3TjeFsAIIMGUg9WHwGEHJ+erzC/9tFQRnfSsKolbSVbbJ6P
    hzp6zmTg9dSzQv3fB/nevxma8rTkEcwNeG1kfgDuUPLH14FsOFDeO7eCmffWVeL+wnAj
    Y64Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1620906600;
    s=strato-dkim-0002; d=strato.com;
    h=In-Reply-To:References:Message-ID:Subject:Cc:To:From:Date:Cc:Date:
    From:Subject:Sender;
    bh=rUWO1DR6AocpmONMz+jRvLtxJKtSG8G4+v4E4zkkNks=;
    b=QdRSimrFnrIec8/4s6J942dxgg+RFGE/43kzr3eddWW1VRBv96ntaAdUca+N/p2TzZ
    DOybvIP4E+EbyoDHZjoz1V53ToZcDyeD9IKgZ3u5X1PypDO61xiJhsbKjjzwx2ch4laJ
    j2SIbh4JPVMu4Adkt9C+qPWclE50V0+vnpdav3gL3ZDk9lXjLNGpSfQh2c5fDkJnWNdu
    ObQuo0rCTcmWXzPYsat4M6aPJHfpODRkXH7nYGsODsPEDO3yynTkBqIXLp4XBLW7D6iz
    PcwMxIQ9jFzlr9JLs+OFuUQ7MDwFxvkJB8pI9t0JjD+UJXYD4+bcwVOS4qU9x008MvG2
    bnWg==
ARC-Authentication-Results: i=1; strato.com;
    dkim=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1620906600;
    s=strato-dkim-0002; d=gerhold.net;
    h=In-Reply-To:References:Message-ID:Subject:Cc:To:From:Date:Cc:Date:
    From:Subject:Sender;
    bh=rUWO1DR6AocpmONMz+jRvLtxJKtSG8G4+v4E4zkkNks=;
    b=gVm1bxFzSiyjjdZj9HB5Sf3bsDZiqE6m4R7dTle7Sv2zXZ8o3MD3r85aL/I7IMyglU
    DnXXYGyL3p5g4cNDCn5K5Uf363Tx7QX+/bneX5aDAh7+SojINohHOZa6k7pYPkm9rKUK
    Xushe4NdvlG6m2QfbB3jQUScaqj85uxnp49BsZudvCeOXXNzsgajBd5/oSoM6bFPVgh5
    Q7nvtFrbSIUdTxmzWLhA1GlFlHKN1Rqww9RP2f3bqPUbbAJ7i9pagQ04L0Qr4Gw0ArXq
    56n3lhw0hEDSEHLNw/rVMuaPd3w8mDjImdAX/uqMkM1dy+wq6Vx/Jcp7etHcHE8CdLnJ
    JSng==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P3gBZUipdd93FF5ZZvYFPugejmSTVR2nRPhVOQ/OcYgojyw4j34+u26zEodhPgRDZ8j6IczCBg=="
X-RZG-CLASS-ID: mo00
Received: from gerhold.net
    by smtp.strato.de (RZmta 47.25.7 DYNA|AUTH)
    with ESMTPSA id j06c13x4DBnxAIk
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Thu, 13 May 2021 13:49:59 +0200 (CEST)
Date:   Thu, 13 May 2021 13:49:53 +0200
From:   Stephan Gerhold <stephan@gerhold.net>
To:     Mark Greer <mgreer@animalcreek.com>
Cc:     Frieder Schrempf <frieder.schrempf@kontron.de>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-nfc@lists.01.org,
        Alex Blasche <alexander.blasche@qt.io>,
        phone-devel@vger.kernel.org
Subject: Re: Testing wanted for Linux NFC subsystem
Message-ID: <YJ0SYWJjq3ZmXMy3@gerhold.net>
References: <20210512144319.30852-1-krzysztof.kozlowski@canonical.com>
 <14e78a9a-ed1a-9d7d-b854-db6d811f4622@kontron.de>
 <20210512170135.GB222094@animalcreek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210512170135.GB222094@animalcreek.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

On Wed, May 12, 2021 at 10:01:35AM -0700, Mark Greer wrote:
> On Wed, May 12, 2021 at 05:32:35PM +0200, Frieder Schrempf wrote:
> > On 12.05.21 16:43, Krzysztof Kozlowski wrote:
> > > The NFC subsystem is orphaned.  I am happy to spend some cycles to
> > > review the patches, send pull requests and in general keep the NFC
> > > subsystem running.
> > 
> > That's great, thanks!
> > 
> > Maybe you also want to have a look at the userspace side and talk to Mark Greer (on cc). He recently said, that he is supposed to be taking over maintenance for the neard daemon (see this thread: [1]) which currently looks like it's close to being dead (no release for several years, etc.).
> > 
> > I don't know much about the NFC stack and if/how people use it, but without reliable and maintained userspace tooling, the whole thing seems of little use in the long run. Qt has already dropped their neard support for Qt 6 [2], which basically means the mainline NFC stack won't be supported anymore in one of the most common application frameworks for IoT/embedded.
> > 
> > [1] https://lists.01.org/hyperkitty/list/linux-nfc@lists.01.org/thread/OHD5IQHYPFUPUFYWDMNSVCBNO24M45VK/
> > [2] https://bugreports.qt.io/browse/QTBUG-81824
> 
> Re: QT - I've already talked to Alex Blasche from QT (CC'd).  With some
> work we can get Linux NFC/neard back into their good graces.  I/we need
> to find time to put in the work, though.
> 
> An example of the issues they have seen is:
> 
> 	https://bugreports.qt.io/browse/QTBUG-43802
> 
> Another issue I have--and I suspect you, Krzysztof, have as well--is
> lack of hardware.  If anyone reading this wants to volunteer to be a
> tester, please speak up.
> 

Glad to see that Linux NFC might be somewhat less dead now :)

I have a couple of "recycled" smartphones running mainline Linux
and some of them do have NFC chips. I have two with NXP PN547
(supported by nxp,nxp-nci-i2c), one with Samsung S3FWRN5
(samsung,s3fwrn5-i2c) and even one with Broadcom BCM2079x I think
(this one does not have a driver for the Linux NFC subsystem sadly).

+Cc phone-devel@vger.kernel.org, in case other people there are
interested in NFC :)

The NXP/Samsung ones seems to work just fine. However, since there are
barely any userspace tools making use of Linux NFC all my testing so far
was limited to polling for devices with "nfctool" and being happy enough
when it realizes that I hold some NFC tag close to the device. :S

I would be happy to do some more testing if someone has something useful
that can be tested. However, I guess ideally we would have someone who
actually uses Linux NFC actively for some real application. :)

The QT integration might be useful for people running postmarketOS [1]
on these smartphones, but so far I haven't really seen any useful NFC
Qt applications either. :/

Thanks!
Stephan

[1]: https://postmarketos.org
