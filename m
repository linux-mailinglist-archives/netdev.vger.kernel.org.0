Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 146663B21D7
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 22:37:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbhFWUjj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 16:39:39 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:52450 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229660AbhFWUji (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Jun 2021 16:39:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=1XtEzc6VnSjwLXbMFdcKxrNUxmRgQuaNqMZ4b5TzFxo=; b=ONgnW4sIZKv4soPmAFcM4MNh6S
        eBjrrNk0sM4dgCFBqgTez62PZAPefRuFqBJkswL0oQWBk81pdg+HOh8K4ry4inZlNo/YIwK3nICg0
        gzTPcfsAmx4ExJT1NjxRcguwbqTSNSpxI2XNEckRW1kCaLLnH+Sjh0PN6/tqRGL+fVmM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lw9cc-00AtE6-9o; Wed, 23 Jun 2021 22:37:18 +0200
Date:   Wed, 23 Jun 2021 22:37:18 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, linux@armlinux.org.uk,
        jaz@semihalf.com, gjb@semihalf.com, upstream@semihalf.com,
        Samer.El-Haj-Mahmoud@arm.com, jon@solid-run.com, tn@semihalf.com,
        rjw@rjwysocki.net, lenb@kernel.org
Subject: Re: [net-next: PATCH v3 5/6] net: mvpp2: enable using phylink with
 ACPI
Message-ID: <YNObfrJN0Qk5RO+x@lunn.ch>
References: <20210621173028.3541424-1-mw@semihalf.com>
 <20210621173028.3541424-6-mw@semihalf.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210621173028.3541424-6-mw@semihalf.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static bool mvpp2_use_acpi_compat_mode(struct fwnode_handle *port_fwnode)
> +{
> +	if (!is_acpi_node(port_fwnode))
> +		return false;
> +
> +	return (!fwnode_property_present(port_fwnode, "phy-handle") &&
> +		!fwnode_property_present(port_fwnode, "managed") &&
> +		!fwnode_get_named_child_node(port_fwnode, "fixed-link"));

I'm not too sure about this last one. You only use fixed-link when
connecting to an Ethernet switch. I doubt anybody will try ACPI and a
switch. It has been agreed, ACPI is for simple hardware, and you need
to use DT for advanced hardware configurations.

What is your use case for fixed-link?

     Andrew
