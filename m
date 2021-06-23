Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04C5A3B21B3
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 22:18:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230001AbhFWUUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 16:20:23 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:52374 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229849AbhFWUUX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Jun 2021 16:20:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=eBdvdXLvFySdllVHeHdoDDe9M7upqNkx1Ws1iVGbDDU=; b=U8pdFx4Fbzb0/ZHInFJvIfahrK
        geu/L+BcSz3VU9ORPqZJzyq9/WnAevciAInvWih4u25ftHEflxkI+HYhw7+MUJipICbHD+WWBk2Z3
        x23LA1Q3pjYPt4aVhmk2DtN48PrGxUL77YeHI0IQEuiDlMQYbrt0wgg5++gffM3SmmMM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lw9Jy-00At5z-PY; Wed, 23 Jun 2021 22:18:02 +0200
Date:   Wed, 23 Jun 2021 22:18:02 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, linux@armlinux.org.uk,
        jaz@semihalf.com, gjb@semihalf.com, upstream@semihalf.com,
        Samer.El-Haj-Mahmoud@arm.com, jon@solid-run.com, tn@semihalf.com,
        rjw@rjwysocki.net, lenb@kernel.org
Subject: Re: [net-next: PATCH v3 1/6] Documentation: ACPI: DSD: describe
 additional MAC configuration
Message-ID: <YNOW+mQNEmSRx/6V@lunn.ch>
References: <20210621173028.3541424-1-mw@semihalf.com>
 <20210621173028.3541424-2-mw@semihalf.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210621173028.3541424-2-mw@semihalf.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +MAC node example with a "fixed-link" subnode.
> +---------------------------------------------
> +
> +.. code-block:: none
> +
> +	Scope(\_SB.PP21.ETH1)
> +	{
> +	  Name (_DSD, Package () {
> +	    ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
> +		 Package () {
> +		     Package () {"phy-mode", "sgmii"},
> +		 },
> +	    ToUUID("dbb8e3e6-5886-4ba6-8795-1319f52a966b"),
> +		 Package () {
> +		     Package () {"fixed-link", "LNK0"}
> +		 }
> +	  })

At least in the DT world, it is pretty unusual to see both fixed-link
and phy-mode. You might have one of the four RGMII modes, in order to
set the delays when connecting to a switch. But sgmii and fixed link
seems very unlikely, how is sgmii autoneg going to work?

> +	  Name (LNK0, Package(){ // Data-only subnode of port
> +	    ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
> +		 Package () {
> +		     Package () {"speed", 1000},
> +		     Package () {"full-duplex", 1}
> +		 }
> +	  })
> +	}
> +

  Andrew
