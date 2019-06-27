Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFBD45841B
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 16:03:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726832AbfF0ODW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 10:03:22 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:37024 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726370AbfF0ODV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jun 2019 10:03:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=redkA+CovLKkIpwZ1wU0Xkvse8YZ5XsqEc9J4PcUp3E=; b=y262YvjpBRgPISvI0ncYokuWF0
        MZPHbH3jdRfr2batVnS6iSJovhZEb0LlkR0nSoqXJOlPhUwpbnEJvigs7kTl6fLDfs5P41654+Vbe
        V2i5kllV703tjX1boaoAGm3ahO81ovLZcysz3RbZ2qw64mbQ9L9ud3/i5VcodPICzKuY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hgUzc-0000AY-Tq; Thu, 27 Jun 2019 16:03:16 +0200
Date:   Thu, 27 Jun 2019 16:03:16 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jose Abreu <Jose.Abreu@synopsys.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>
Subject: Re: [PATCH net-next 10/10] net: stmmac: Try to get C45 PHY if
 everything else fails
Message-ID: <20190627140316.GF31189@lunn.ch>
References: <cover.1561556555.git.joabreu@synopsys.com>
 <c7d1dbac1940853c22db8215ed60181b2abe3050.1561556556.git.joabreu@synopsys.com>
 <20190626200128.GH27733@lunn.ch>
 <BN8PR12MB3266A8396ACA97484A5E0CE7D3FD0@BN8PR12MB3266.namprd12.prod.outlook.com>
 <20190627132340.GC31189@lunn.ch>
 <BN8PR12MB32666DADBD1DD315026E9A2BD3FD0@BN8PR12MB3266.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN8PR12MB32666DADBD1DD315026E9A2BD3FD0@BN8PR12MB3266.namprd12.prod.outlook.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 27, 2019 at 01:33:59PM +0000, Jose Abreu wrote:
> From: Andrew Lunn <andrew@lunn.ch>
> 
> > There have been some drivers gaining patches for ACPI. That is
> > probably the better long term solution, ask ACPI where is the PHY and
> > what MDIO protocol to use to talk to it.
> 
> Hmmm, I'm not sure this is going to work that way ...
> 
> My setup is a PCI EP which is hot-pluggable and as far as I know ACPI 
> has only static content (????)

I've wanted to improve the PHY probe code for a while. I was thinking
we should add a flag to the MDIO bus driver structure indicating it
can do C45. When that flag is present, we should also scan the bus for
C45 devices, and register them as well.

With that in place, i think your problem goes away. Architecturally, i
think it is wrong that a MAC driver is registering PHY devices. The
MDIO core should do this.

      Andrew
