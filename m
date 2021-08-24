Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F0713F6170
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 17:20:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238272AbhHXPUo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 11:20:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:38148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230341AbhHXPUn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Aug 2021 11:20:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A90A61265;
        Tue, 24 Aug 2021 15:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629818399;
        bh=mQu485WoXeSt4oqBdnAqN8wigPmCfnwDsOWt+e9BPd4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=H8B13mZgVXuBAgxSfJjvkiPMFp2qtvKtoDIUWOoAHgh/teX4Vc2qBjEj5iFTtF14b
         4ggzZ3xt4RtjcMy5N1qV4rEZEOk4OAL7sdaHAQuOPWvWFZ5At4EAr5hi87kWRtQDMK
         XzQwK75SczSjJADilTeSlsrRp85ORuLz/Rdd0TbFVEBblnEbBhULoCOo6OyUmid/tZ
         n68lisAHaChbtHtK7RW2ceJ2WXtiLdd0lzDkQwGOISziCfiKEhefqRe+4EYz5ez9XL
         yYw1w+Bmlg+jJlZ/gUgt0LEiJvZ3MrStHxt8cQ/My7IAOoHRgeCby6uIdrtY8Ik1wo
         0rxErN5pGx6RA==
Date:   Tue, 24 Aug 2021 08:19:58 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "John Efstathiades" <john.efstathiades@pebblebay.com>
Cc:     <linux-usb@vger.kernel.org>, <UNGLinuxDriver@microchip.com>,
        <woojung.huh@microchip.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 05/10] lan78xx: Disable USB3 link power state
 transitions
Message-ID: <20210824081958.407b4009@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <02d701d798f5$04a23df0$0de6b9d0$@pebblebay.com>
References: <20210823135229.36581-1-john.efstathiades@pebblebay.com>
        <20210823135229.36581-6-john.efstathiades@pebblebay.com>
        <20210823154022.490688a6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <001b01d798c6$5b4d7b30$11e87190$@pebblebay.com>
        <20210824065303.17f23421@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <02d701d798f5$04a23df0$0de6b9d0$@pebblebay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 24 Aug 2021 15:33:13 +0100 John Efstathiades wrote:
> > Do you expect the device-initiated transitions to always be causing
> > trouble or are there scenarios where they are useful?  
> 
> It's a particular problem on Android devices.
> 
> > Having to recompile the driver is a middle ground rarely chosen
> > upstream. If the code has very low chance of being useful - let's
> > remove it (git will hold it forever if needed); if there are reasonable
> > chances someone will find it useful it should be configurable from user
> > space, or preferably automatically enabled based on some device match
> > list.  
> 
> I like the sound of the device match list but I don't know what you mean.
> Is there a driver or other reference you could point me at that provides
> additional info?

Depends on what the discriminator is. If problems happen with 
a particular ASIC revisions driver needs to read the revision
out and make a match. If it's product by product you can use
struct usb_device_id :: driver_info to attach metadata per 
device ID. If it's related to the platform things like DMI
matching are sometimes used. I have very limited experience 
with Android / embedded ARM so not sure what would work there.
