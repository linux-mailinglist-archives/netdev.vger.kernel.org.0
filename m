Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E82730E2AD
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 19:41:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232507AbhBCSlM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 13:41:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:35844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229979AbhBCSlK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Feb 2021 13:41:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8FD9D64F65;
        Wed,  3 Feb 2021 18:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612377630;
        bh=ne/VpkVjff6Ma10qaIVVWwYCBVEGioYMCeW+6BzKYTo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tz9oqbThN853bYgekpJXUbpY7OjxGMixhA5LVVvqA0kvOa3LvdRQaeJYSGHmzhGpG
         mq7DhJ5yztK6omAKh3TQZNCEmJn+MLJym8cJh1nVObVoDEPEHlLbAmQbs2ojGWLALl
         vOp+1MfDWSgrpVuS6981DjAT4ed26Usx8jRMKP8bEasX9B5rK+bXl6jq13WVWyT5SI
         m9qrLIPa2eSd3Ii/CrhdSQmOeIlhW84dY9E4zfNN0WjXe9BacxlhYVpksuZzLAd3Ng
         28iFSq5g0/1kGmUoooZUx+5Jrf9Y10ehFEims8qWYMcE6qFv36k85jYJyXTskxsA2D
         bTBYrI2wFjiXw==
Date:   Wed, 3 Feb 2021 10:40:28 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        David Miller <davem@davemloft.net>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Jeffrey Hugo <jhugo@codeaurora.org>,
        Bhaumik Bhatt <bbhatt@codeaurora.org>,
        Network Development <netdev@vger.kernel.org>
Subject: Re: [RESEND PATCH v18 0/3] userspace MHI client interface driver
Message-ID: <20210203104028.62d41962@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAMZdPi8o44RPTGcLSvP0nptmdUEmJWFO4HkCB_kjJvfPDgchhQ@mail.gmail.com>
References: <1609958656-15064-1-git-send-email-hemantk@codeaurora.org>
        <20210113152625.GB30246@work>
        <YBGDng3VhE1Yw6zt@kroah.com>
        <20210201105549.GB108653@thinkpad>
        <YBfi573Bdfxy0GBt@kroah.com>
        <20210201121322.GC108653@thinkpad>
        <20210202042208.GB840@work>
        <20210202201008.274209f9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <835B2E08-7B84-4A02-B82F-445467D69083@linaro.org>
        <20210203100508.1082f73e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAMZdPi8o44RPTGcLSvP0nptmdUEmJWFO4HkCB_kjJvfPDgchhQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 3 Feb 2021 19:28:28 +0100 Loic Poulain wrote:
> On Wed, 3 Feb 2021 at 19:05, Jakub Kicinski <kuba@kernel.org> wrote:
> > On Wed, 03 Feb 2021 09:45:06 +0530 Manivannan Sadhasivam wrote:  
> > > The current patchset only supports QMI channel so I'd request you to
> > > review the chardev node created for it. The QMI chardev node created
> > > will be unique for the MHI bus and the number of nodes depends on the
> > > MHI controllers in the system (typically 1 but not limited).  
> >
> > If you want to add a MHI QMI driver, please write a QMI-only driver.
> > This generic "userspace client interface" driver is a no go. Nobody will
> > have the time and attention to police what you throw in there later.  
> 
> Think it should be seen as filtered userspace access to MHI bus
> (filtered because not all channels are exposed), again it's not
> specific to MHI, any bus in Linux offers that (i2c, spi, usb, serial,
> etc...). It will not be specific to QMI, since we will also need it
> for MBIM (modem control path), AT commands, and GPS (NMEA frames), all
> these protocols are usually handled by userspace tools and not linked
> to any internal Linux framework, so it would be better not having a
> dedicated chardev for each of them.

The more people argue for this backdoor interface the more distrustful
of it we'll become. Keep going at your own peril.
