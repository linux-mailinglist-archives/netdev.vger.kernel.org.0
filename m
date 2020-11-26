Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAD772C58F5
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 17:02:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391581AbgKZQBh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 11:01:37 -0500
Received: from guitar.tcltek.co.il ([192.115.133.116]:42814 "EHLO
        mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391423AbgKZQBh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Nov 2020 11:01:37 -0500
Received: from tarshish (unknown [10.0.8.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.tkos.co.il (Postfix) with ESMTPS id B2DA6440048;
        Thu, 26 Nov 2020 18:01:35 +0200 (IST)
References: <87pn40uo25.fsf@tarshish> <20201126154716.GN2073444@lunn.ch>
User-agent: mu4e 1.4.13; emacs 27.1
From:   Baruch Siach <baruch@tkos.co.il>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: Get MAC supported link modes for SFP port
In-reply-to: <20201126154716.GN2073444@lunn.ch>
Date:   Thu, 26 Nov 2020 18:01:35 +0200
Message-ID: <87mtz4umxs.fsf@tarshish>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Thu, Nov 26 2020, Andrew Lunn wrote:
> On Thu, Nov 26, 2020 at 05:37:22PM +0200, Baruch Siach wrote:
>> I am trying to retrieve all MAC supported link modes
>> (ETHTOOL_LINK_MODE_*) for network interfaces with SFP port. The
>> 'supported' bit mask that ETHTOOL_GLINKSETTINGS provides in
>> link_mode_masks[] changes to match the SFP module that happens to be
>> plugged in. When no SFP module is plugged, the bit mask looks
>> meaningless.
>
> That sounds like it is doing the correct thing.
>
>> I understand that ETHTOOL_LINK_MODE_* bits are meant to describe PHY
>> level capabilities. So I would settle for a MAC level "supported rates"
>> list.
>
> What is your use cases?

I would like to report the port supported data rates to the system
user. I need to tell whether 10Gbps SFP module are supported in that
port in a generic way. The driver has this information. It is necessary
to implement the validate callback in phylink_mac_ops. But I see no way
to read this information from userspace.

> A MAC without some form a PHY, be it copper, fibre, or a faked
> fixed-link, is useless. You need the combination of what the MAC can
> do and what the PHY can do to have any meaning information.

I understand that. I probably need a higher level concept of data rate
supported.

baruch

-- 
                                                     ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.52.368.4656, http://www.tkos.co.il -
