Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 800933CA87D
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 21:00:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235410AbhGOTBT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 15:01:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:35730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242505AbhGOS7o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Jul 2021 14:59:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8707F613D0;
        Thu, 15 Jul 2021 18:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626375410;
        bh=h8VhkJGv7XBlYbGJhIbYQWwxLGpNUt9qSt9i6JbEzSA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=FbZLfbNCxaDykYsqZQEwXtA10VhNEzqCz3CH0vTk3EzdlTlUjwcC6hKBXttGHUd0C
         iqNZrkhCK1tO8JtwqYFp5PRkd9h2RVaHQ1Ei9x69q7HEm7tx49MRJV5QDhfEUHvSzM
         ejM2uL8Mt0+zvFoarESpfMUM7d3isPs8hSFUi+R1W0rR+1WnzDYTbyfbif48ZHw3iW
         QqtICE2h98rG7/Mhw2goBD5Ll1Xlp6DTPMchAlel9IflNb9/ml6jo/2rSULp2VJMHk
         DESwQFImwuypPe/2wM3CGVDGu7YuiNdAV3/C8vq9dB1jfSo51mZVIPmiVGz4jMHCbm
         ZxM6FrMIW1biw==
Date:   Thu, 15 Jul 2021 13:56:49 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     "Billie Alsup (balsup)" <balsup@cisco.com>
Cc:     Paul Menzel <pmenzel@molgen.mpg.de>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Guohan Lu <lguohan@gmail.com>,
        "Madhava Reddy Siddareddygari (msiddare)" <msiddare@cisco.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Sergey Miroshnichenko <s.miroshnichenko@yadro.com>
Subject: Re: [RFC][PATCH] PCI: Reserve address space for powered-off devices
 behind PCIe bridges
Message-ID: <20210715185649.GA1984276@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <545AA576-42A5-47A7-A08A-062582B1569A@cisco.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 15, 2021 at 06:12:25PM +0000, Billie Alsup (balsup) wrote:
> It took me a while to figure out that the "New Outlook" option
> doesn't actually allow sending plain text, so I have to switch to
> "Old Outlook" mode.

Since you've gone to that much trouble already, also note
http://vger.kernel.org/majordomo-info.html and
https://people.kernel.org/tglx/notes-about-netiquette 

BTW, the attribution in the email you quoted below got corrupted in
such a way that it appears that I wrote the whole thing, instead of 
what actually happened, which is that I wrote a half dozen lines of
response to your email.  Linux uses old skool email conventions ;)

> It is not clear as to what parameters Linux would use to consider a
> window broken.

By "broken," I just mean things that are prohibited by the PCI spec,
like "region doesn't fit in a window of an upstream device" or
"non-prefetchable region placed in a prefetchable window."

> But if the kernel preserves some bridge window
> assignment, then it seems feasible for our BIOS to run this same
> algorithm (reading PLX persistent scratch registers to determine
> window sizes).  I will raise this possibility with our own kernel
> team to discuss with the bios team.  We can also look more closely
> at the resource_alignment options to see if that might suffice.
> Thanks for the information!

> From: Bjorn Helgaas <helgaas@kernel.org>
> Date: Thursday, July 15, 2021 at 10:14 AM
> To: "Billie Alsup (balsup)" <balsup@cisco.com>
> Cc: Paul Menzel <pmenzel@molgen.mpg.de>, Bjorn Helgaas <bhelgaas@google.com>, Guohan Lu <lguohan@gmail.com>, "Madhava Reddy Siddareddygari (msiddare)" <msiddare@cisco.com>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, Sergey Miroshnichenko <s.miroshnichenko@yadro.com>
> Subject: Re: [RFC][PATCH] PCI: Reserve address space for powered-off devices behind PCIe bridges
> 
> On Thu, Jul 15, 2021 at 04:52:26PM +0000, Billie Alsup (balsup) wrote:
> We are aware of how Cisco device specific this code is, and hadn't
> intended to upstream it.  This code was originally written for an
> older kernel version (4.8.28-WR9.0.0.26_cgl).  I am not the original
> author; I just ported it into various SONiC linux kernels.  We use
> ACPI with SONiC (although not on our non-SONiC products), so I
> thought I might be able to define such windows within the ACPI tree
> and have some generic code to read such configuration information
> from the ACPI tables,. However, initial attempts failed so I went
> with the existing approach.  I believe we did look at the hpmmiosize
> parameter, but iirc it applied to each bridge, rather than being a
> pool of address space to dynamically parcel out as necessary.
> 
> Right.  I mentioned "pci=resource_alignment=" because it claims to be
> able to specify window sizes for specific bridges.  But I haven't
> exercised that myself.
> 
> There are multiple bridges involved in the hardware (there are 8
> hot-plug fabric cards, each with multiple PCI devices).  Devices on
> the card are in multiple power zones, so all devices are not
> immediately visible to the pci scanning code.  The top level bridge
> reserves close to 5G.  The 2nd level (towards the fabric cards)
> reserve 4.5G.  The 3rd level has 9 bridges each reserving 512M.  The
> 4th level reserves 384M (with a 512M alignment restriction iirc).
> The 5th level reserves 384M (again with an alignment restriction).
> That defines the bridge hierarchy visible at boot.  Things behind
> that 5th level are hot-plugged where there are two more bridge
> levels and 5 devices (1 requiring 2x64M blocks and 4 requiring
> 1x64M).
> 
> I'm not sure if the Cisco kernel team has revisited the hpmmiosize
> and resource_alignment parameters since this initial implementation.
> Reading the description of Sergey's patches, he seems to be
> approaching the same problem from a different direction.   It is
> unclear if such an approach is practical for our environment.   It
> would require updates to all of our SONiC drivers to support
> stopping/remapping/restarting, and it is unclear if that is
> acceptable.  It is certainly less preferable to pre-reserving the
> required space.  For our embedded product, we know exactly what
> devices will be plugged in, and allowing that to be pre-programmed
> into the PLX eeprom gives us the flexibility we need.  
> 
> If you know up front what devices are possible and how much space they
> need, possibly your firmware could assign the bridge windows you need.
> Linux generally does not change window assignments unless they are
> broken.
> 
> Bjorn
> 
> 
