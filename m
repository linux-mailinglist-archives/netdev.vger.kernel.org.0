Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 310A36DE1D9
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 19:07:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229666AbjDKRHL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 13:07:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbjDKRHK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 13:07:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DD88E4B
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 10:07:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E928C62269
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 17:07:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2BC8C433D2;
        Tue, 11 Apr 2023 17:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681232827;
        bh=N1XRiP63joZ93INNsXvdZicbfgAa2ybJjUkSpcZii5A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=A83bKRm4ziTO23pfIjtML8ptz9AztzvG+kEi7ttWv3RGKPski/pCyDII2yxkfUrU9
         iDwLZECfVVMcK0lTOOqVtdgjiZqIEHTvr46S/TEAi9L1fcDtpNXn1de1JGlNVIBsZj
         b5TQr4F0smHF59JcD8sVdu2o0xF0xE2lpZvKGdje/K2YK4ziT8l3h89IxYmu1pJg3v
         KrckHIGKCIiq7aOjrUVRusEd8861vJUmYn4/9dTTuUrifY9NP3e1ZTMXij03ySAHv/
         g8XZ+IAdZMUzOekk1WIpD+r+JwLvFPiaWH5li8OtkHhPJLCpbo+IsNWKtwSCtoCbzo
         mOjCBoUyyQnRA==
Date:   Tue, 11 Apr 2023 19:07:02 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH RFC net-next 0/6] net: mvneta: reduce size of TSO header
 allocation
Message-ID: <20230411190702.3bdbc83d@dellmb>
In-Reply-To: <ZDWB1zRNlxpTN1IK@shell.armlinux.org.uk>
References: <ZCsbJ4nG+So/n9qY@shell.armlinux.org.uk>
        <ZDWB1zRNlxpTN1IK@shell.armlinux.org.uk>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.37; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 11 Apr 2023 16:50:47 +0100
"Russell King (Oracle)" <linux@armlinux.org.uk> wrote:

> Hi,
> 
> I think the Turris folk are waiting for me to get this into the kernel
> and backported to stable before they merge it into their tree and we
> therefore end up with it being tested.
> 
> We are now at -rc7, and this series is in danger of missing the
> upcoming merge window.
> 
> So, I think it's time that I posted a wake-up call here to say that no,
> that's not going to happen until such time that we know whether these
> patches solve the problem that they identified. I'm not bunging patches
> into the kernel for problems people have without those people testing
> the proposed changes.
> 
> I think if the Turris folk want to engage with mainline for assistance
> in resolving issues, they need to do their part and find a way to
> provide kernels to test out proposed fixes for their problems.

Hello Russell,

sorry about this, our kernel team was halved a few months ago and things
are a little hectic here. Tomorrow I will try to apply these patches
and build a testing release of TurrisOS for users who have this issue.
Hopefully they will report positively to it.

Marek


> On Mon, Apr 03, 2023 at 07:29:59PM +0100, Russell King (Oracle) wrote:
> > Hi,
> > 
> > With reference to
> > https://forum.turris.cz/t/random-kernel-exceptions-on-hbl-tos-7-0/18865/
> > 
> > It appears that mvneta attempts an order-6 allocation for the TSO
> > header memory. While this succeeds early on in the system's life time,
> > trying order-6 allocations later can result in failure due to memory
> > fragmentation.
> > 
> > Firstly, the reason it's so large is that we take the number of
> > transmit descriptors, and allocate a TSO header buffer for each, and
> > each TSO header is 256 bytes. The driver uses a simple mechanism to
> > determine the address - it uses the transmit descriptor index as an
> > index into the TSO header memory.
> > 
> > 	(The first obvious question is: do there need to be this
> > 	many? Won't each TSO header always have at least one bit
> > 	of data to go with it? In other words, wouldn't the maximum
> > 	number of TSO headers that a ring could accept be the number
> > 	of ring entries divided by 2?)
> > 
> > There is no real need for this memory to be an order-6 allocation,
> > since nothing in hardware requires this buffer to be contiguous.
> > 
> > Therefore, this series splits this order-6 allocation up into 32
> > order-1 allocations (8k pages on 4k page platforms), each giving
> > 32 TSO headers per page.
> > 
> > In order to do this, these patches:
> > 
> > 1) fix a horrible transmit path error-cleanup bug - the existing
> >    code unmaps from the first descriptor that was allocated at
> >    interface bringup, not the first descriptor that the packet
> >    is using, resulting in the wrong descriptors being unmapped.
> > 
> > 2) since xdp support was added, we now have buf->type which indicates
> >    what this transmit buffer contains. Use this to mark TSO header
> >    buffers.
> > 
> > 3) get rid of IS_TSO_HEADER(), instead using buf->type to determine
> >    whether this transmit buffer needs to be DMA-unmapped.
> > 
> > 4) move tso_build_hdr() into mvneta_tso_put_hdr() to keep all the
> >    TSO header building code together.
> > 
> > 5) split the TSO header allocation into chunks of order-1 pages.
> > 
> >  drivers/net/ethernet/marvell/mvneta.c | 166 +++++++++++++++++++++++-----------
> >  1 file changed, 115 insertions(+), 51 deletions(-)
> > 
> > -- 
> > RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> > FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!
> >   
> 

