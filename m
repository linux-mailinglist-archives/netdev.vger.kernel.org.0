Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C630215C3F
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 18:52:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729585AbgGFQwU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 12:52:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:40130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729494AbgGFQwU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Jul 2020 12:52:20 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 22F4A206E9;
        Mon,  6 Jul 2020 16:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594054339;
        bh=xdaRqZT1+9b9Hwv4ZCb6X1XEW+VVf2e1R5XMLeCYHiw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=xOjcD1SejuWSE4eNJvXzUeCNnbtqHOGD4kUIoU0M1BUZOTxBjxwAFne8AaG44kl5g
         z0hBHoiLqKo/C3OuXbW6B7meN857YSHalmfIGklYmCxqEdvTzZ+p/2xvyVUSelY7mV
         0gM6So1bajV5AfyK7ik06/QL0+Tc8o6RSWBPiMtI=
Date:   Mon, 6 Jul 2020 09:52:17 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Aya Levin <ayal@mellanox.com>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "helgaas@kernel.org" <helgaas@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        "alexander.h.duyck@linux.intel.com\"" 
        <alexander.h.duyck@linux.intel.com>
Subject: Re: [net-next 10/10] net/mlx5e: Add support for PCI relaxed
 ordering
Message-ID: <20200706095217.55c34281@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <7b79eead-ceab-5d95-fd91-cabeeef82d6a@mellanox.com>
References: <20200623195229.26411-1-saeedm@mellanox.com>
        <20200623195229.26411-11-saeedm@mellanox.com>
        <20200623143118.51373eb7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <dda5c2b729bbaf025592aa84e2bdb84d0cda7570.camel@mellanox.com>
        <082c6bfe-5146-c213-9220-65177717c342@mellanox.com>
        <20200624102258.4410008d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <19a722952a2b91cc3b26076b8fd74afdfbfaa7a4.camel@mellanox.com>
        <20200624133018.5a4d238b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <7b79eead-ceab-5d95-fd91-cabeeef82d6a@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 6 Jul 2020 16:00:59 +0300 Aya Levin wrote:
> Assuming the discussions with Bjorn will conclude in a well-trusted API 
> that ensures relaxed ordering in enabled, I'd still like a method to 
> turn off relaxed ordering for performance debugging sake.
> Bjorn highlighted the fact that the PCIe sub system can only offer a 
> query method. Even if theoretically a set API will be provided, this 
> will not fit a netdev debugging - I wonder if CPU vendors even support 
> relaxed ordering set/unset...
> On the driver's side relaxed ordering is an attribute of the mkey and 
> should be available for configuration (similar to number of CPU vs. 
> number of channels).
> Based on the above, and binding the driver's default relaxed ordering to 
> the return value from pcie_relaxed_ordering_enabled(), may I continue 
> with previous direction of a private-flag to control the client side (my 
> driver) ?

That's fine with me, chicken bit seems reasonable as long as the
default is dictated by the PCI subsystem. I have no particularly 
strong feeling on the API used for the chicken bit, but others may.
