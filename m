Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E53F63A5A37
	for <lists+netdev@lfdr.de>; Sun, 13 Jun 2021 21:47:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231891AbhFMTtn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Jun 2021 15:49:43 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33834 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231788AbhFMTtn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 13 Jun 2021 15:49:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=lL7tVfmXSD23raXqXaZKAQwqFBlWd0U2PzBpKElohIM=; b=K5IYKFtokDKBag55xHZHbQwSxv
        IUyTegEqE7Jh1eEL4ENnLDR4wECt7iorXFBlAPGMTENq3oE7Jcm044F9VRh3EsZoheV5aAdVcwkv+
        bAq/VIXmHG3YoLgEc16a6sJUNUzJ/Z+hB+7hHe7bBfkbLiOC0gPaDg3jqdI6/HITt6A4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lsW55-009C08-Qk; Sun, 13 Jun 2021 21:47:39 +0200
Date:   Sun, 13 Jun 2021 21:47:39 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, linux@armlinux.org.uk,
        jaz@semihalf.com, gjb@semihalf.com, upstream@semihalf.com,
        Samer.El-Haj-Mahmoud@arm.com, jon@solid-run.com
Subject: Re: [net-next: PATCH 2/3] net: mvpp2: enable using phylink with ACPI
Message-ID: <YMZg27EkTuebBXwo@lunn.ch>
References: <20210613183520.2247415-1-mw@semihalf.com>
 <20210613183520.2247415-3-mw@semihalf.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210613183520.2247415-3-mw@semihalf.com>
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

fixed-link and managed are not documented in
Documentation/firmware-guide/acpi/dsd/phy.rst.

Also, should you be looking for phy-mode?

      Andrew
