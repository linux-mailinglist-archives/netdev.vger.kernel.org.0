Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B3D66DDFF2
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 17:50:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbjDKPu4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 11:50:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjDKPuz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 11:50:55 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42A7B2723
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 08:50:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:To:From:Date:Reply-To:Cc:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=N5Gz8wSjMgV7qvAbvj5EnI8Afsz2xt/406+Dj04n9Jg=; b=0bYWw2+TVKqv+/NakQQ/RE6Ywt
        mRkWzYh+EdZELDda/Ib0lZvvTAc0Cb4Ogu381py3aSrslCLEA9R6VAU/YWt6lQ33O45bN3S5w7B66
        NfvmA8g50PSbTXnmzciyzEA/kjC1/R6PlyP/6f1nyRBjP+2+RJERvfjFqbhGV8ZPnXeEW09ranN3b
        aB4ZEbRs9GViD4YvcsmGK6i1kHnYNdlcqxxwokvRtnQtDczKHy0gGgK1Td96RZpciqSK76yjg3wxX
        rT/Py/9o/avVi2uuxH778Lf2cw9cbkXYpdWRWyJyDbcxB1NQv84C2f2TydFMOPKkMcckCzsd5aIOB
        yh/ZL+jg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:51714)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pmGGf-00066N-1B; Tue, 11 Apr 2023 16:50:49 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pmGGd-0004Ee-7L; Tue, 11 Apr 2023 16:50:47 +0100
Date:   Tue, 11 Apr 2023 16:50:47 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH RFC net-next 0/6] net: mvneta: reduce size of TSO header
 allocation
Message-ID: <ZDWB1zRNlxpTN1IK@shell.armlinux.org.uk>
References: <ZCsbJ4nG+So/n9qY@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZCsbJ4nG+So/n9qY@shell.armlinux.org.uk>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I think the Turris folk are waiting for me to get this into the kernel
and backported to stable before they merge it into their tree and we
therefore end up with it being tested.

We are now at -rc7, and this series is in danger of missing the
upcoming merge window.

So, I think it's time that I posted a wake-up call here to say that no,
that's not going to happen until such time that we know whether these
patches solve the problem that they identified. I'm not bunging patches
into the kernel for problems people have without those people testing
the proposed changes.

I think if the Turris folk want to engage with mainline for assistance
in resolving issues, they need to do their part and find a way to
provide kernels to test out proposed fixes for their problems.

On Mon, Apr 03, 2023 at 07:29:59PM +0100, Russell King (Oracle) wrote:
> Hi,
> 
> With reference to
> https://forum.turris.cz/t/random-kernel-exceptions-on-hbl-tos-7-0/18865/
> 
> It appears that mvneta attempts an order-6 allocation for the TSO
> header memory. While this succeeds early on in the system's life time,
> trying order-6 allocations later can result in failure due to memory
> fragmentation.
> 
> Firstly, the reason it's so large is that we take the number of
> transmit descriptors, and allocate a TSO header buffer for each, and
> each TSO header is 256 bytes. The driver uses a simple mechanism to
> determine the address - it uses the transmit descriptor index as an
> index into the TSO header memory.
> 
> 	(The first obvious question is: do there need to be this
> 	many? Won't each TSO header always have at least one bit
> 	of data to go with it? In other words, wouldn't the maximum
> 	number of TSO headers that a ring could accept be the number
> 	of ring entries divided by 2?)
> 
> There is no real need for this memory to be an order-6 allocation,
> since nothing in hardware requires this buffer to be contiguous.
> 
> Therefore, this series splits this order-6 allocation up into 32
> order-1 allocations (8k pages on 4k page platforms), each giving
> 32 TSO headers per page.
> 
> In order to do this, these patches:
> 
> 1) fix a horrible transmit path error-cleanup bug - the existing
>    code unmaps from the first descriptor that was allocated at
>    interface bringup, not the first descriptor that the packet
>    is using, resulting in the wrong descriptors being unmapped.
> 
> 2) since xdp support was added, we now have buf->type which indicates
>    what this transmit buffer contains. Use this to mark TSO header
>    buffers.
> 
> 3) get rid of IS_TSO_HEADER(), instead using buf->type to determine
>    whether this transmit buffer needs to be DMA-unmapped.
> 
> 4) move tso_build_hdr() into mvneta_tso_put_hdr() to keep all the
>    TSO header building code together.
> 
> 5) split the TSO header allocation into chunks of order-1 pages.
> 
>  drivers/net/ethernet/marvell/mvneta.c | 166 +++++++++++++++++++++++-----------
>  1 file changed, 115 insertions(+), 51 deletions(-)
> 
> -- 
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!
