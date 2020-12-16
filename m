Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16C5C2DBDCE
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 10:42:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725940AbgLPJl5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 04:41:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:51938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725889AbgLPJl5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Dec 2020 04:41:57 -0500
Date:   Wed, 16 Dec 2020 10:42:17 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1608111676;
        bh=wwOdbgunRq2eKqn6jEC3Bs80LYViiIT+qaz21Cqol+s=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=U8xz+2kdTBlKXeI7J5SDrWW1/jaWVXq5kmxd/L7Hil33cr+Dn6ZWIs9+dXhF63c9j
         jXxlCaGd+cMoN5x6Gi6iY49Bsopmneyw7GqLTpn9Or28wGhUx1PVzIWzrs4d1icDR1
         +Y9MD0ribWJJi2xNTn8xF88+79NAblfBZ8MLeHs0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Hemant Kumar <hemantk@codeaurora.org>,
        open list <linux-kernel@vger.kernel.org>,
        Jeffrey Hugo <jhugo@codeaurora.org>,
        Bhaumik Bhatt <bbhatt@codeaurora.org>,
        Network Development <netdev@vger.kernel.org>
Subject: Re: [PATCH v18 0/3] userspace MHI client interface driver
Message-ID: <X9nWeXZz7lh4JdCb@kroah.com>
References: <1607715903-16442-1-git-send-email-hemantk@codeaurora.org>
 <CAMZdPi8=9OsoCH_eV_JZohmFbuXcLv2kWNPLFzQUAKUCUHYs5A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMZdPi8=9OsoCH_eV_JZohmFbuXcLv2kWNPLFzQUAKUCUHYs5A@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 16, 2020 at 10:17:30AM +0100, Loic Poulain wrote:
> Hi Folks,
> 
> On Fri, 11 Dec 2020 at 20:45, Hemant Kumar <hemantk@codeaurora.org> wrote:
> >
> > This patch series adds support for UCI driver. UCI driver enables userspace
> > clients to communicate to external MHI devices like modem. UCI driver probe
> > creates standard character device file nodes for userspace clients to
> > perform open, read, write, poll and release file operations. These file
> > operations call MHI core layer APIs to perform data transfer using MHI bus
> > to communicate with MHI device.
> >
> > This interface allows exposing modem control channel(s) such as QMI, MBIM,
> > or AT commands to userspace which can be used to configure the modem using
> > tools such as libqmi, ModemManager, minicom (for AT), etc over MHI. This is
> > required as there are no kernel APIs to access modem control path for device
> > configuration. Data path transporting the network payload (IP), however, is
> > routed to the Linux network via the mhi-net driver. Currently driver supports
> > QMI channel. libqmi is userspace MHI client which communicates to a QMI
> > service using QMI channel. Please refer to
> > https://www.freedesktop.org/wiki/Software/libqmi/ for additional information
> > on libqmi.
> >
> > Patch is tested using arm64 and x86 based platform.
> 
> Are there any blockers or unadressed comments remaining on this
> series? As far as I understand, the original blocker was the net/WiFi
> mention in the commit message, that caused a legitimate concern from
> network maintainer. It has been clarified now that this driver is not
> for exposing any channel that could be otherwise handled properly by
> an existing Linux subsystem/interface. It will be especially used as a
> pipe for modem QMI channel (or AT commands) in the same way as the USB
> CDC-WDM driver is doing (keeping userspace compatibility). Other MHI
> channels, such as network data, QRTR, etc are not exposed and
> correctly bound to the corresponding Linux subsystems.
> 
> The correlated worry was that it could be a userspace channel facility
> for 'everything qualcomm', but we could say the same for other
> existing busses with userspace shunt (/dev/bus/usb, /dev/i2c,
> /dev/spidev, PCI UIO, UART...). Moreover, it is mitigated by the fact
> that not all MHI channels are exposed by default, but only the allowed
> ones (QMI in the initial version). For sure, special care must be
> given to any further channel addition.

It's the middle of the merge window, we can't do anything with new
patches at all until 5.11-rc1 is out, so please be patient.

thanks,

greg k-h
