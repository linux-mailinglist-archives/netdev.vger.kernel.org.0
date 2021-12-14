Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85898474ADE
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 19:27:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237060AbhLNS1d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 13:27:33 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:54856 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236984AbhLNS1Y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Dec 2021 13:27:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Wv6kQffD57VO+I+7ojUQcXILo7zZOtCg1fn5qtWUkGs=; b=SJHGpOZIZFJ6G1cEscuV3RZnhh
        D1qWNPI+YjHmpYRhhT3/YxfPIt+VhXpojSW60UFtkJJv1mmIMwH4ur7zypcYpsSdroQdeEGVSYAi3
        m+D8/F1U9mloN1ZhdCLbPnOTYfSDxeA/dsaxSf9lM+4cPw5Uen9CiLlPN0WirQRC/AJU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mxCWH-00GYJW-1E; Tue, 14 Dec 2021 19:27:21 +0100
Date:   Tue, 14 Dec 2021 19:27:20 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alex Elder <elder@linaro.org>
Cc:     Network Development <netdev@vger.kernel.org>,
        "bjorn.andersson@linaro.org" <bjorn.andersson@linaro.org>
Subject: Re: Port mirroring (RFC)
Message-ID: <YbjiCNRffWYEcWDt@lunn.ch>
References: <384e168b-8266-cb9b-196b-347a513c0d36@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <384e168b-8266-cb9b-196b-347a513c0d36@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 14, 2021 at 08:47:12AM -0600, Alex Elder wrote:
> I am implementing what amounts to port mirroring functionality
> for the IPA driver.
> 
> The IPA hardware isn't exactly a network switch (it's sort of
> more than that), but it has the ability to supply replicas of
> packets transferred within it to a special (read only) interface.

I think you need to explain "within it" in a bit more detail. Where
are these packets coming from/going to?

> My plan is to implement this using a new "ipa_mirror" network
> device, so it could be used with a raw socket to capture the
> arriving packets.  There currently exists one other netdev,
> which represents access through a modem to a WWAN network.
> 
> I would like some advice on how to proceed with this.  I want
> the result to match "best practice" upstream, and would like
> this to be as well integrated possible with existing network
> tools.
> 
> A few details about the stream of packets that arrive on
> this hardware interface:
> - Packet data is truncated if it's larger than a certain size
> - Each packet is preceded by a fixed-size header describing it
> - Packets (and their headers) are aggregated into a buffer; i.e.
>   a single receive might carry a dozen (truncated) packets

So this sounds something more like what you would attach pcap/tcpdump
to.  I'm not sure port mirroring is the correct model here. Maybe take
a look at wifi adaptors and their monitor mode? See if that fits
better?
 
	Andrew
