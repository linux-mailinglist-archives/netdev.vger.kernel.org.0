Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73DFD37FAE2
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 17:37:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234933AbhEMPiu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 11:38:50 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.53]:16797 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234932AbhEMPis (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 11:38:48 -0400
X-Greylist: delayed 13644 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 May 2021 11:38:44 EDT
ARC-Seal: i=1; a=rsa-sha256; t=1620920245; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=juU15rfsS9PwAkEcGdmkeIe9uzbV9nhUK1ONhA7Dy+RwT+Wfd4l6SHG1lymDZTsBwO
    mVnFQ9Diu1qwkoxE1woFU2mD+5o/imo51W/Nye43yi0axFgGolLUs2CaqlB5E1y9Yv67
    3DpaLnJoYONeK8cRq+ElKZssvclbCW3JJsnPnLAPiIP3LmO4cNmqAucxHIBh+I30Rc1a
    P+71JXbZ229I9vNUsu0QD3jROHnFroYVNwJLooOPxc3bUGc39wk4QvunxI8HWaplaj8/
    B6Y7KY9mHfZ7loBok2vOqSCauYMKUdVcp4n2T1Ymt38Uu3hyRTXWp9luF87B/SxInCyV
    QTVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1620920245;
    s=strato-dkim-0002; d=strato.com;
    h=In-Reply-To:References:Message-ID:Subject:Cc:To:From:Date:Cc:Date:
    From:Subject:Sender;
    bh=p9b5c3IB1K+7is9GeRzTX7tLozoGvL5xMmPv3Z5hQhs=;
    b=qIRC5Y+VBFsR/r+yc66MJ4wZj1aIi7ALTWP/LhRlaXmdZClLxkp62xGvNFK+h7AoWm
    OhjndCOpxkZF1cbqgFe37Gf4jKnFHKKWs++oNByhOcksiWqygtTPzhSe59cFfYRMpV9g
    ytRahTBUlu9hRsC+n9jv7K0AmOuKEsldP1hxhVfxunGV6NBJMSoWF31MmgmIrcLdLNGj
    /7GJiEZ4OnUoG/zJPHLqliJFgVYYmtZGJ1lvMUkbQoKzWg2k8mjDA+3iuxoRAL7nZjXM
    gCzPdxKovLsohs1wcMy3AcT7xfeXotN903JEOgu3IpHfjDhNig0fu8Cc7aTlLchN4bQk
    vbxA==
ARC-Authentication-Results: i=1; strato.com;
    dkim=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1620920245;
    s=strato-dkim-0002; d=gerhold.net;
    h=In-Reply-To:References:Message-ID:Subject:Cc:To:From:Date:Cc:Date:
    From:Subject:Sender;
    bh=p9b5c3IB1K+7is9GeRzTX7tLozoGvL5xMmPv3Z5hQhs=;
    b=GFwjKEH95MZ8/6NQ1xxSmPYkfTah3tiG+7qFrvRnPsBrP4U1T5l5AnDTImA4W02T35
    9696eUZFfiP6FhEa7hWb4O15zHX3glmCAmmgeDKS3E9GON/NbTAAZBqVK4wBs4iptFz5
    POFE3z6RQRf76WBTrziT+5Fy1mqody5GbnC5N/tpkSf68x2nvSRWVgU7h1j7RUCXdn4a
    ipxRrsPp+0lHp24INxH2kpDIdxIGWPQfDIllFSefvhanttauVoji8fmTn/SFj7s5lnCP
    C0hDksAYI4ZRkgyN+QmskQxxCyvyKvXxsVFc/Xbw4wLb9V4LvoHzH4LCJrYyc1+hJCfy
    4b5w==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P3gBZUipdd93FF5ZZvYFPugejmSTVR2nRPhVOQ/OcYgojyw4j34+u26zEodhPgRDZ8j6IczCBg=="
X-RZG-CLASS-ID: mo00
Received: from gerhold.net
    by smtp.strato.de (RZmta 47.25.7 DYNA|AUTH)
    with ESMTPSA id j06c13x4DFbOCNR
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Thu, 13 May 2021 17:37:24 +0200 (CEST)
Date:   Thu, 13 May 2021 17:37:19 +0200
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
Message-ID: <YJ1Hr/hov9I42GK1@gerhold.net>
References: <20210512144319.30852-1-krzysztof.kozlowski@canonical.com>
 <14e78a9a-ed1a-9d7d-b854-db6d811f4622@kontron.de>
 <20210512170135.GB222094@animalcreek.com>
 <YJ0SYWJjq3ZmXMy3@gerhold.net>
 <20210513144855.GA266838@animalcreek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210513144855.GA266838@animalcreek.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 13, 2021 at 07:48:55AM -0700, Mark Greer wrote:
> On Thu, May 13, 2021 at 01:49:53PM +0200, Stephan Gerhold wrote:
> > I have a couple of "recycled" smartphones running mainline Linux
> > and some of them do have NFC chips. I have two with NXP PN547
> > (supported by nxp,nxp-nci-i2c), one with Samsung S3FWRN5
> > (samsung,s3fwrn5-i2c) and even one with Broadcom BCM2079x I think
> > (this one does not have a driver for the Linux NFC subsystem sadly).
> > 
> > +Cc phone-devel@vger.kernel.org, in case other people there are
> > interested in NFC :)
> > 
> > The NXP/Samsung ones seems to work just fine. However, since there are
> > barely any userspace tools making use of Linux NFC all my testing so far
> > was limited to polling for devices with "nfctool" and being happy enough
> > when it realizes that I hold some NFC tag close to the device. :S
> 
> There is a user-level daemon that is the counterpart for the in-kernel
> NFC subsystem.  It is called neard and is available here:
> 
> 	git://git.kernel.org/pub/scm/network/nfc/neard.git
> 
> There are a few test script in it that will let you read and write NFC
> tags, and do some other things.  We can add some more tests to that set
> as we go.
> 

Yeah, I packaged that for Alpine Linux / postmarketOS.
"nfctool" also comes from "neard" as far as I can tell :)

I think I also played with the Neard test scripts a bit at some point,
and managed to read some NFC tag thing inside an old Yubikey NEO
that I found, but didn't really know what else to do.

> > I would be happy to do some more testing if someone has something useful
> > that can be tested. However, I guess ideally we would have someone who
> > actually uses Linux NFC actively for some real application. :)
> 
> Ideally, you should have some NFC tags of various types.  Types 2, 3,
> 4A, 4B, and 5 tags are supported.  Peer-to-peer mode is supported too
> so you should be able to transfer data from one of your phones to the
> other over NFC (and do a BT hand-over, if you're interested).
> 

I guess this is where I kind of lack hardware as well at the moment,
I don't have any programmable NFC tags at the moment (although I guess
those should be quite cheap). I might play with the peer-to-peer mode
a bit when I find time.

> Note that the specified range for NFC is only 4 cm and poor antenna
> design, etc. means that the actual range is usually much less (e.g.,
> they amost have to touch).  Also note that there are timing constraints
> so you may need to make the scheduling priority of the interrupt thread
> of your NFC driver real-time.
> 

Yeah I noticed, always need to search for a while to find the right spot
on the phone. :)

Stephan
