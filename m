Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A2D249D663
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 00:53:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229829AbiAZXxe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 18:53:34 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:56552 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229771AbiAZXxd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jan 2022 18:53:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=QR17iCDr/Cz9CtLK/heYO9ZBbquQ+JtefAe67qGIIlM=; b=CvEJl6yR5Dx3unUMT5vBzpqLc6
        YHrLLHQDaYO4fo5hefvpWhfaA9SkxZFmb7Potq/YVp8qxkQ+3J9SlVhI03kOg0njZyEAhMJ/s/wZH
        zVQjB94SAgkxwiJfS51hbnDcYjpOVLeV1OmSYwzyN019I9iiE+GR2ZNXNK8m8rQfJOFU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nCs6T-002sRn-5O; Thu, 27 Jan 2022 00:53:29 +0100
Date:   Thu, 27 Jan 2022 00:53:29 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] net: dsa: mv88e6xxx: Improve indirect
 addressing performance
Message-ID: <YfHe+WAOQDu3hkG1@lunn.ch>
References: <20220126231239.1443128-1-tobias@waldekranz.com>
 <20220126231239.1443128-3-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220126231239.1443128-3-tobias@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 27, 2022 at 12:12:39AM +0100, Tobias Waldekranz wrote:
> Before this change, both the read and write callback would start out
> by asserting that the chip's busy flag was cleared. However, both
> callbacks also made sure to wait for the clearing of the busy bit
> before returning - making the initial check superfluous. The only
> time that would ever have an effect was if the busy bit was initially
> set for some reason.
> 
> With that in mind, make sure to perform an initial check of the busy
> bit, after which both read and write can rely the previous operation
> to have waited for the bit to clear.
> 
> This cuts the number of operations on the underlying MDIO bus by 25%
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
