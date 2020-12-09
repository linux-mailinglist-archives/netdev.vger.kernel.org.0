Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3241D2D383F
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 02:23:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726119AbgLIBXG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 20:23:06 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:45458 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725768AbgLIBXF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Dec 2020 20:23:05 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kmoBO-00Ax9n-B8; Wed, 09 Dec 2020 02:22:18 +0100
Date:   Wed, 9 Dec 2020 02:22:18 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Sven Van Asbroeck <thesven73@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        David S Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net v1 2/2] lan743x: boost performance: limit PCIe
 bandwidth requirement
Message-ID: <20201209012218.GN2475764@lunn.ch>
References: <20201206034408.31492-1-TheSven73@gmail.com>
 <20201206034408.31492-2-TheSven73@gmail.com>
 <20201208114314.743ee6ec@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <CAGngYiVSHRGC+eOCeF3Kyj_wOVqxJHvoc9fXRk-w+sVRjeSpcw@mail.gmail.com>
 <20201208225125.GA2602479@lunn.ch>
 <CAGngYiVp2u-A07rrkbeJCbqPW9efjkJUNC+NBxrtCM2JtXGpVA@mail.gmail.com>
 <3aed88da-8e82-3bd0-6822-d30f1bd5ec9e@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3aed88da-8e82-3bd0-6822-d30f1bd5ec9e@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> dma_sync_single_for_{cpu,device} is what you would need in order to make
> a partial cache line invalidation. You would still need to unmap the
> same address+length pair that was used for the initial mapping otherwise
> the DMA-API debugging will rightfully complain.

But often you don't unmap it, you call dma_sync_single_for_device and
put it back into the ring.

    Andrew
