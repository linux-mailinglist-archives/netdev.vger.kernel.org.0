Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A47A21C550
	for <lists+netdev@lfdr.de>; Sat, 11 Jul 2020 18:38:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728651AbgGKQiM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jul 2020 12:38:12 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:58620 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728412AbgGKQiM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Jul 2020 12:38:12 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1juIVq-004dfe-Si; Sat, 11 Jul 2020 18:38:06 +0200
Date:   Sat, 11 Jul 2020 18:38:06 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, min.li.xe@renesas.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] ptp: add debugfs support for IDT family of
 timing devices
Message-ID: <20200711163806.GM1014141@lunn.ch>
References: <1594395685-25199-1-git-send-email-min.li.xe@renesas.com>
 <20200710135844.58d76d44@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200711134601.GD20443@hoboy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200711134601.GD20443@hoboy>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 11, 2020 at 06:46:01AM -0700, Richard Cochran wrote:
> On Fri, Jul 10, 2020 at 01:58:44PM -0700, Jakub Kicinski wrote:
> > On Fri, 10 Jul 2020 11:41:25 -0400 min.li.xe@renesas.com wrote:
> > > From: Min Li <min.li.xe@renesas.com>
> > > 
> > > This patch is to add debugfs support for ptp_clockmatrix and ptp_idt82p33.
> > > It will create a debugfs directory called idtptp{x} and x is the ptp index.
> > > Three inerfaces are present, which are cmd, help and regs. help is read
> > > only and will display a brief help message. regs is read only amd will show
> > > all register values. cmd is write only and will accept certain commands.
> > > Currently, the accepted commands are combomode to set comobo mode and write
> > > to write up to 4 registers.
> > > 
> > > Signed-off-by: Min Li <min.li.xe@renesas.com>
> > 
> > No private configuration interfaces in debugfs, please.
> 
> I suggested to Min to use debugfs for device-specific configuration
> that would be out of place in the generic PTP Hardware Clock
> interface.
> 
> > If what you're exposing is a useful feature it deserves a proper 
> > uAPI interface.
> 
> Can you expand on what you mean by "proper uAPI interface" please?

Hi Richard

Well, one obvious issues is that debugfs it totally optional, and
often not built. You would not want the correct operation of a device
to depend something which is optional. debugfs is also unstable. There
are no ABI rules. So user space cannot rely on the API being the same
from version to version. Again, not something you want for the correct
operation of a device.

Allowing registers to be read, is a typical debug operation. So that
part seems reasonable. A kernel developer/debugger has the skills to
deal with unstable APIs, and rebuilding the kernel to actually have
debugfs in the image.

But configuration does not belong in debugfs. It would be good to
explain what is being configured by these parameters, then we can
maybe make a suggestion about the correct API to use.

      Andrew
