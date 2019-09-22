Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD7AFBA389
	for <lists+netdev@lfdr.de>; Sun, 22 Sep 2019 19:53:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388493AbfIVRxA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Sep 2019 13:53:00 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:40016 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388054AbfIVRxA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Sep 2019 13:53:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=B021u770oJfMYzL//tDuGzq6YtA3WUYoUSchjaFSERE=; b=Pyzmbjf/x6R18+bUwvzb/FbTB
        N3TVUfkbq37OUXTbGaM8QuxtNMSAyzrXBMyIaeYW1EOLCN1XxR2NJqGMhkEyy06FUqOpbqKklwMa3
        iQO/c1qIY5JYB/ncN5dml1R9euy8SoHeD/ltq0oKMwcVGYMK7AIk4evTsvXw2w/3c88IKkxHMxr8p
        yWLiMbvkq+6ET3yJApJrONPSvwdo2gu7R070rIjMQGuyc4VvxKo7HDdYdhf7bCdSVDke66HqVyvhg
        j45A2ju1Mm6s1pFxrPhS1EImBdkd0JNx+Yo+q96hBziljHmyewxhy4gWw7nzw7BLz4MNpi7h7ecLU
        wskWRoPLw==;
Received: from shell.armlinux.org.uk ([192.168.0.251]:55462)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1iC62W-0008Bu-Rl
        for netdev@vger.kernel.org; Sun, 22 Sep 2019 18:52:53 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1iC62Q-0007vW-64; Sun, 22 Sep 2019 18:52:46 +0100
Date:   Sun, 22 Sep 2019 18:52:46 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        tinywrkb <tinywrkb@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH 0/4] Attempt to fix regression with AR8035 speed downgrade
Message-ID: <20190922175246.GR25745@shell.armlinux.org.uk>
References: <20190922105932.GP25745@shell.armlinux.org.uk>
 <20190922165335.GE27014@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190922165335.GE27014@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 22, 2019 at 06:53:35PM +0200, Andrew Lunn wrote:
> On Sun, Sep 22, 2019 at 11:59:32AM +0100, Russell King - ARM Linux admin wrote:
> > Hi,
> > 
> > tinywrkb, please can you test this series to ensure that it fixes
> > your problem - the previous version has turned out to be a non-starter
> > as it introduces more problems, thanks!
> > 
> > The following series attempts to address an issue spotted by tinywrkb
> > with the AR8035 on the Cubox-i2 in a situation where the PHY downgrades
> > the negotiated link.
> 
> Hi Russell
> 
> This all looks sensible.
> 
> One things we need to be careful of, is this is for net and so stable.

Since the regression was introduced in 5.1, it should be backported
to stable trees.

> But only some of the patches have fixes-tags. I don't know if we
> should add fixes tags to all the patches, just to give back porters a
> hint that they are all needed? It won't compile without the patches,
> so at least it fails safe.

I only put Fixes: tags on patches that are actually fixing something.
Quoting submitting-patches.rst:

  A Fixes: tag indicates that the patch fixes an issue in a previous
  commit.

Since the preceding two patches are just preparing for the fix, and
not actually fixing an issue in themselves, it seems wrong to add a
Fixes: tag for them.  However, mentioning it in the commit message
for the patch that does fix the issue is probably worth it.  Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
