Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 725882EC344
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 19:35:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726499AbhAFSfj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 13:35:39 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:53572 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725890AbhAFSfj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Jan 2021 13:35:39 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kxDe3-00GUyF-JA; Wed, 06 Jan 2021 19:34:55 +0100
Date:   Wed, 6 Jan 2021 19:34:55 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     Sven Auhagen <sven.auhagen@voleatech.de>, netdev@vger.kernel.org,
        davem@davemloft.net, Jakub Kicinski <kuba@kernel.org>,
        Matteo Croce <mcroce@microsoft.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Subject: Re: [PATCH net-next] net: mvpp2: increase MTU limit when XDP enabled
Message-ID: <X/YCz6g+2la+g+kI@lunn.ch>
References: <20210105171921.8022-1-kabel@kernel.org>
 <20210105172437.5bd2wypkfw775a4v@svensmacbookair.sven.lan>
 <20210105184308.1d2b7253@kernel.org>
 <X/TKNlir5Cyimjn3@lunn.ch>
 <20210106125608.5f6fab6f@kernel.org>
 <20210106133205.617dddd8@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210106133205.617dddd8@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 06, 2021 at 01:32:05PM +0100, Marek Behún wrote:
> On Wed, 6 Jan 2021 12:56:08 +0100
> Marek Behún <kabel@kernel.org> wrote:
> 
> > I also to write a simple NAT masquerading program. I think XDP can
> > increase NAT throughput to 2.5gbps as well.
> 
> BTW currently if XDP modifies the packet, it has to modify the
> checksums accordingly. There is a helper for that even, bpf_csum_diff.
> 
> But many drivers can offload csum computation, mvneta and mvpp2 for
> example.

Hi Marek

It does require that the MAC is DSA aware. The Freescale FEC for
example cannot do such csum, because the DSA header confuses it, and
it cannot find the IP header, etc. So if you do look at a generic way
to implement this, you need the MAC driver to indicate it has the
needed support.

       Andrew
