Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF84A41DB1D
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 15:32:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350825AbhI3Ndz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 09:33:55 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41044 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350215AbhI3Ndw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 09:33:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=0141hjdvYnZ0004bBaZDxqKz05YDhXafXUnAytuAYqY=; b=GVYNAoA3POXh3HF81JD5vbzbta
        Pjf9ml4mzJYtODOChVuQKypjgDYUHvs2Fv2iGGbUZT3Uk3Gg6yxozcu4SGtXF1d4GrsVtYXhMmWD0
        3vWXmPmN+jbqkXPcqSlImTMPs8cn0hxafJI4mURth+mISBm5hGDLTjhLnWIg1tvbZAGA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mVwAS-008xC8-21; Thu, 30 Sep 2021 15:32:08 +0200
Date:   Thu, 30 Sep 2021 15:32:08 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        BCM Kernel Feedback <bcm-kernel-feedback-list@broadcom.com>,
        Vivek Unune <npcomplete13@gmail.com>
Subject: Re: Lockup in phy_probe() for MDIO device (Broadcom's switch)
Message-ID: <YVW8WM5yxP7sW7Ph@lunn.ch>
References: <YVWOp/2Nj/E1dpe3@shell.armlinux.org.uk>
 <5715f818-a279-d514-dcac-73a94c1d30ef@gmail.com>
 <YVWUKwEXrd39t8iw@shell.armlinux.org.uk>
 <1e4e40ba-23b8-65b4-0b53-1c8393d9a834@gmail.com>
 <YVWjEQzJisT0HgHB@shell.armlinux.org.uk>
 <f51658fb-0844-93fc-46d0-6b3a7ef36123@gmail.com>
 <YVWt2B7c9YKLlmgT@shell.armlinux.org.uk>
 <955416fe-4da4-b1ec-aadb-9b816f02d7f2@gmail.com>
 <YVW2oN3vBoP3tNNn@shell.armlinux.org.uk>
 <YVW59e2iItl5S4Qh@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YVW59e2iItl5S4Qh@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I should also point out that as this b53 driver that is causing the
> problem only exists in OpenWRT, this is really a matter for OpenWRT
> developers rather than mainline which does not suffer this problem.
> I suspect that OpenWRT developers will not be happy with either of
> the two patches I've posted above - I suspect they are trying to
> support both DSA and swconfig approaches with a single DT. That can
> be made to work, but not with a PHYLIB driver being a wrapper around
> the swconfig stuff (precisely because there's no phy_device in this
> scenario.)
> 
> The only reason to patch mainline kernels would be to make them more
> robust, and maybe to also make an explicit statement about what isn't
> supported (having a phy_driver with its of_match_table member set.)

I agree with you here. This is an OpenWRT problem. We would hopefully
catch such a driver at review time and reject it. We could make it
more robust in mainline, but as you said, OpenWRT developers might not
actually like it more robust.

	 Andrew
