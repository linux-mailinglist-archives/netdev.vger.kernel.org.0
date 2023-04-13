Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 149C26E137C
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 19:29:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbjDMR3r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 13:29:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230111AbjDMR3n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 13:29:43 -0400
Received: from h2.cmg1.smtp.forpsi.com (h2.cmg1.smtp.forpsi.com [81.2.195.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D9CA8A7D
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 10:29:39 -0700 (PDT)
Received: from lenoch ([91.218.190.200])
        by cmgsmtp with ESMTPSA
        id n0lLpFzPDPm6Cn0lMpKzFr; Thu, 13 Apr 2023 19:29:38 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=triops.cz; s=f2019;
        t=1681406978; bh=RvFk72lJVn31Atg+4liHgBd22kUzN+EjOgK2JTXgzGA=;
        h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
        b=GqEmnUvy8WXcxfjxDWQbk6WnXc53xcCJAcLf2a4QYvUeJthJDwDEecMA/SbGL5gw2
         xGFhPy6kB7zeb9HrIRIymgU1DFlN8s/dItKbPAT/+f4m1gnglzxtbomtbxxU2OFR3d
         hk3FySLl4/pA98Q8Zt4U4ajJY+e9dGV02AOTA9aMT0CKnL0W0ZoosuqaZDdiJ81eeJ
         E8AlW4NphLNDxGQS46VY+aMsU0Ri7qSQXEoTvO1FD3aDMDQw9OD4lpya1SRzabwzpw
         IxPNY+MPcPl2AgaYHATonZ3mRdfnCEDap04Q5fotE1ZKuKpp04KgXWc4CS+WJtpq3O
         zFVAQ6f41TxSg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=triops.cz; s=f2019;
        t=1681406978; bh=RvFk72lJVn31Atg+4liHgBd22kUzN+EjOgK2JTXgzGA=;
        h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
        b=GqEmnUvy8WXcxfjxDWQbk6WnXc53xcCJAcLf2a4QYvUeJthJDwDEecMA/SbGL5gw2
         xGFhPy6kB7zeb9HrIRIymgU1DFlN8s/dItKbPAT/+f4m1gnglzxtbomtbxxU2OFR3d
         hk3FySLl4/pA98Q8Zt4U4ajJY+e9dGV02AOTA9aMT0CKnL0W0ZoosuqaZDdiJ81eeJ
         E8AlW4NphLNDxGQS46VY+aMsU0Ri7qSQXEoTvO1FD3aDMDQw9OD4lpya1SRzabwzpw
         IxPNY+MPcPl2AgaYHATonZ3mRdfnCEDap04Q5fotE1ZKuKpp04KgXWc4CS+WJtpq3O
         zFVAQ6f41TxSg==
Date:   Thu, 13 Apr 2023 19:29:35 +0200
From:   Ladislav Michl <oss-lists@triops.cz>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     linux-staging@lists.linux.dev, netdev@vger.kernel.org,
        linux-mips@vger.kernel.org,
        Chris Packham <chris.packham@alliedtelesis.co.nz>
Subject: Re: [PATCH 0/3] staging: octeon: Convert to use phylink
Message-ID: <ZDg7/wUN5HzmJ5Zt@lenoch>
References: <ZDgNexVTEfyGo77d@lenoch>
 <b70d9361-c689-4837-bc9d-8e800cda380c@lunn.ch>
 <ZDgvSoT/vdJeI0FS@lenoch>
 <6774ce75-196c-4b55-b159-bd39ee72542e@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6774ce75-196c-4b55-b159-bd39ee72542e@lunn.ch>
X-CMAE-Envelope: MS4wfGJkw1qp0jIXdwLqNJ9mWkMzFKjqgXZi5ZBzKK7bAVzSFJoWM416UPOSBrbFuCpQ6L1Uzj+9wCdZY/k8Q7IwNM546bkdUxzMskcDsXxh0p5/AZMZEh/U
 UivNL13Kh4mEepjijvWKi/hfkavwjf/zJ7+dLhR0QV/Lw5KjGj+N/8IytNycEeSQnMTcW7/P6V3xiiZfE0q1vIpa1GA/2cQzzGbX5m5TwQF+bPN6EUloGVbo
 tjW3V93T4GffrjiJMixfx6SOw4RrIkQ2blraW1RsXKsgw28bgMUNSqfvX54ttQ2ebuQnCgiht18In2zm9qs4nQ==
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 13, 2023 at 07:12:29PM +0200, Andrew Lunn wrote:
> > > > However testing revealed some glitches:
> > > > 1. driver previously returned -EPROBE_DEFER when no phy was attached.
> > > > Phylink stack does not seem to do so, which end up with:
> > > > 
> > > > Marvell PHY driver as a module:
> > > > octeon_ethernet 11800a0000000.pip eth0: configuring for inband/1000base-x link mode
> > > > octeon_ethernet 11800a0000000.pip eth1: PHY [8001180000001800:00] driver [Generic PHY] (irq=POLL)
> > > > octeon_ethernet 11800a0000000.pip eth1: configuring for phy/sgmii link mode
> > > > octeon_ethernet 11800a0000000.pip eth2: PHY [8001180000001800:01] driver [Generic PHY] (irq=POLL)
> > > > octeon_ethernet 11800a0000000.pip eth2: configuring for phy/sgmii link mode
> > > > octeon_ethernet 11800a0000000.pip eth0: switched to inband/sgmii link mode
> > > > octeon_ethernet 11800a0000000.pip eth0: PHY [i2c:sfp:16] driver [Marvell 88E1111] (irq=POLL)
> > > > octeon_ethernet 11800a0000000.pip eth3: PHY [8001180000001800:02] driver [Marvell 88E1340S] (irq=25)
> > > > octeon_ethernet 11800a0000000.pip eth3: configuring for phy/sgmii link mode
> > > > octeon_ethernet 11800a0000000.pip eth4: PHY [8001180000001800:03] driver [Marvell 88E1340S] (irq=25)
> > > > octeon_ethernet 11800a0000000.pip eth4: configuring for phy/sgmii link mode
> > > > octeon_ethernet 11800a0000000.pip eth1: Link is Up - 100Mbps/Full - flow control off
> > > > 
> > > > Marvell PHY driver built-in:
> > > > octeon_ethernet 11800a0000000.pip eth0: configuring for inband/1000base-x link mode
> > > > octeon_ethernet 11800a0000000.pip eth1: PHY [8001180000001800:00] driver [Marvell 88E1340S] (irq=25)
> > > > octeon_ethernet 11800a0000000.pip eth1: configuring for phy/sgmii link mode
> > > > Error: Driver 'Marvell 88E1101' is already registered, aborting...
> > > > libphy: Marvell 88E1101: Error -16 in registering driver
> > > > Error: Driver 'Marvell 88E1101' is already registered, aborting...
> > > > libphy: Marvell 88E1101: Error -16 in registering driver
> > > 
> > > This is very odd. But it could be a side effect of the
> > > compatible. Please try with it removed.
> > 
> > That does not make any difference.
> 
> Then i have no idea. I would suggest you add a WARN_ON() in
> phy_driver_register() so we get a backtrace. That might give a clue
> why it is getting registered multiple times.

And it indeed did. There was kernel/drivers/net/phy/marvell.ko
left in /lib/modules. Clearly my mistake, sorry for the noise and
thank you for help.

So now only that -EPROBE_DEFER handling in module case is waiting for
debugging.

	ladis
