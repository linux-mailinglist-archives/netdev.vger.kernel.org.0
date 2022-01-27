Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 457B349E2DE
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 13:53:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241238AbiA0MxR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 07:53:17 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:57746 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229689AbiA0MxR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jan 2022 07:53:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=bRJN9lWGNOku7mSyFFagRVgjabvasRW58NvyAym0qlM=; b=lCiIFH9qQ54Nb7dqaFl0urEKyh
        0QAiUvVVqxs5+Ap78DLkrJiQ32ISK90GwOsxH4x/oOXQJUAGxPofPGGfb1kSFS28+Ds3ImVhFqNVT
        wp/KixFG+lWOnBvLJ3bI8BD9H6p/LpHIxlLO3NGv2M+0HWHL0an8J6VAEPp8qUzW4vzs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nD4Gw-002zH9-5y; Thu, 27 Jan 2022 13:53:06 +0100
Date:   Thu, 27 Jan 2022 13:53:06 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Hayes Wang <hayeswang@realtek.com>
Cc:     Aaron Ma <aaron.ma@canonical.com>,
        "Limonciello, Mario" <Mario.Limonciello@amd.com>,
        Henning Schild <henning.schild@siemens.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Oliver Neukum <oneukum@suse.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "tiwai@suse.de" <tiwai@suse.de>
Subject: Re: [PATCH 1/3 v3] net: usb: r8152: Check used MAC passthrough
 address
Message-ID: <YfKVslNusCMMCmgp@lunn.ch>
References: <3f258c23-c844-7b48-fffb-2fbf5d6d7475@amd.com>
 <20220111084348.7e897af9@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <2b779fef-459f-79bb-4005-db4fd3fd057f@amd.com>
 <20220111090648.511e95e8@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <5411b3a0-7e36-fa75-5c5c-eb2fda9273b1@amd.com>
 <20220112202125.105d4c58@md1za8fc.ad001.siemens.net>
 <DM4PR12MB516889A458A16D89D4562CA7E2529@DM4PR12MB5168.namprd12.prod.outlook.com>
 <de684c19-7a84-ac7c-0019-31c253d89a5f@canonical.com>
 <edff6219-b1f7-dec5-22ea-0bde9a3e0efb@canonical.com>
 <5b94f064bd5c48589ea856f68ac0e930@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5b94f064bd5c48589ea856f68ac0e930@realtek.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 27, 2022 at 08:06:20AM +0000, Hayes Wang wrote:
> Aaron Ma <aaron.ma@canonical.com>
> > Sent: Thursday, January 27, 2022 10:52 AM
> [...]
> > Hi all,
> > 
> > Realtek 8153BL can be identified by the following code from Realtek Outbox
> > driver:
> > } else if (tp->version == RTL_VER_09 && (ocp_data & BL_MASK)) {
> > 
> > I will suggest Realtek to send out this change for review.
> 
> I don't think the feature of MAC passthrough address is maintained
> by Realtek. Especially, there is no uniform way about it. The
> different companies have to maintain their own ways by themselves.
> 
> Realtek could provide the method of finding out the specific device
> for Lenovo. You could check USB OCP 0xD81F bit 3. For example,
> 
> 	ocp_data = ocp_read_byte(tp, MCU_TYPE_USB, USB_MISC_1);
> 	if (tp->version == RTL_VER_09 && (ocp_data & BIT(3))) {
> 		/* This is the RTL8153B for Lenovo. */
> 	}

Is there a documented meaning for this bit? Realtek have allocated
this bit to Lenovo?

Why is it guaranteed that no other devices manufactured by anybody
else will not have this bit set? That is the real question here. Does
this give false positive where you break the networking for some
random USB dongle.

     Andrew
