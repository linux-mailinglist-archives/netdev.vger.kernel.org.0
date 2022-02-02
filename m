Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93D114A6927
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 01:19:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243307AbiBBATg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 19:19:36 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:38408 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243271AbiBBATg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Feb 2022 19:19:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=gbhyykXq+yrCw3urwyy1uFIaDVk62Sl+dc10qpEAFgE=; b=F38ezAMbErJ/Lof+z7COgXVWV5
        iSyvLSNsrJIySJelXZ5l313FHXAWQyZZi9gbv8SvyixqXcljss1YtDMa1UMDODLY1Y2257MvaeYA6
        BHOT7vmtM674KClzU2oFPkDYD6+T41COlIWh2feL8LMC5ov/8IbpdTUNyPUy1qIAZ+bU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nF3N0-003t1x-0u; Wed, 02 Feb 2022 01:19:34 +0100
Date:   Wed, 2 Feb 2022 01:19:34 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alex Elder <elder@linaro.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "bjorn.andersson@linaro.org" <bjorn.andersson@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: IPA monitor (Final RFC)
Message-ID: <YfnOFpUcOgAGeqln@lunn.ch>
References: <384e168b-8266-cb9b-196b-347a513c0d36@linaro.org>
 <e666e0cb-5b65-1fe9-61ae-a3a3cea54ea0@linaro.org>
 <9da2f1f6-fc7c-e131-400d-97ac3b8cdadc@linaro.org>
 <YeLk3STfx2DO4+FO@lunn.ch>
 <c9db7b36-3855-1ac1-41b6-f7e9b91e2074@linaro.org>
 <20220118103017.158ede27@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <f02ad768-2c8e-c8ed-e5f6-6ee79bf97c06@linaro.org>
 <36491c9e-c9fb-6740-9e51-58c23737318f@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <36491c9e-c9fb-6740-9e51-58c23737318f@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alex

This looks good in general.


>     - If any monitor packet received from hardware is bad, it--along
> 
>       with everything beyond it in its page--will be discarded.
> 
>         - The received data must be big enough to hold a status
> 
>           header.
> 
>         - The received data must contain the packet data, meaning
> 
>           packet length in the status header lies within range.
 
So bad in just the sense that capturing the packet and passing it to
the application processor somehow went wrong.

What about packets with bad CRC? Since the application processor is
not involved, i assume something in the APA architecture is validating
L2 and L3 CRCs. Do they get dropped, or can they be seen in the
monitor stream? Does the header contain any indication of CRC errors,
since if the packet has been truncated, it won't be possible to
validate them. And you said L2 headers are not present anyway.

Do you look at various libpcap-ng implementations? Since this is
debugfs you are not defining a stable ABI, you can change it any time
you want and break userspace. But maybe there could be small changes
in the API which make it easier to feed to wireshark via libpcap.

	Andrew
