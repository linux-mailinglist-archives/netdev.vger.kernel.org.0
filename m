Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08DAD265100
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 22:39:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726996AbgIJUjM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 16:39:12 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:56378 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726962AbgIJUiy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Sep 2020 16:38:54 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kGTLE-00E8So-Ti; Thu, 10 Sep 2020 22:38:48 +0200
Date:   Thu, 10 Sep 2020 22:38:48 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oded Gabbay <oded.gabbay@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, SW_Drivers <SW_Drivers@habana.ai>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 00/15] Adding GAUDI NIC code to habanalabs driver
Message-ID: <20200910203848.GJ3354160@lunn.ch>
References: <20200910161126.30948-1-oded.gabbay@gmail.com>
 <20200910130112.1f6bd9e9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAFCwf13SbXqjyu6JHKSTf-EqUxcBZUe4iAfggLhKXOi6DhXYcg@mail.gmail.com>
 <20200910202513.GH3354160@lunn.ch>
 <CAFCwf11P7pEJ+Av9oiwdQFor5Kh9JeKvVTBXnMzWusKCRz7mHw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFCwf11P7pEJ+Av9oiwdQFor5Kh9JeKvVTBXnMzWusKCRz7mHw@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 10, 2020 at 11:30:33PM +0300, Oded Gabbay wrote:
> On Thu, Sep 10, 2020 at 11:25 PM Andrew Lunn <andrew@lunn.ch> wrote:
> >
> > > Can you please elaborate on how to do this with a single driver that
> > > is already in misc ?
> > > As I mentioned in the cover letter, we are not developing a
> > > stand-alone NIC. We have a deep-learning accelerator with a NIC
> > > interface.
> >
> > This sounds like an MFD.
> >
> >      Andrew
> 
> Yes and no. There is only one functionality - training of deep
> learning (Accelerating compute operations) :)
> The rdma is just our method of scaling-out - our method of
> intra-connection between GAUDI devices (similar to NVlink or AMD
> crossfire).
> So the H/W exposes a single physical function at the PCI level. And
> thus Linux can call a single driver for it during the PCI probe.

Yes, it probes the MFD driver. The MFD driver then creates platform
drivers for the sub functions. i.e. it would create an Ethernet
platform driver. That then gets probed in the usual way. The child
device can get access to the parent device, if it needs to share
things, e.g. a device on a bus. This is typically I2C or SPI, but
there is no reason it cannot be a PCI device.

Go look in drivers/mfd.

      Andrew
