Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60652316412
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 11:42:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230420AbhBJKle (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 05:41:34 -0500
Received: from ssl.serverraum.org ([176.9.125.105]:42263 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230417AbhBJKjI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 05:39:08 -0500
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 59A0323E64;
        Wed, 10 Feb 2021 11:38:18 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1612953498;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wh0vTlN5xwzrmuM0AHqMMV/jTENHTG631Hbx7eavitU=;
        b=Ja1dQUdofMfZzdNohvdRWJcjdbK5gNJ5QfdLojNaWUP0Bz1x2+Ses6OB922d6G4OpHyOSb
        ZZYrqzxVZym7uacqfIbLjHTwCxFdhbCXIhg72XIHqcAL+90f04vhiMCq5OtEhEIZHds/Ji
        KaBnAH2nS+r4dY9T95BYOosF487Oyb0=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 10 Feb 2021 11:38:18 +0100
From:   Michael Walle <michael@walle.cc>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next 7/9] net: phy: icplus: select page before writing
 control register
In-Reply-To: <20210210103059.GR1463@shell.armlinux.org.uk>
References: <20210209164051.18156-1-michael@walle.cc>
 <20210209164051.18156-8-michael@walle.cc>
 <d5672062-c619-02a4-3bbe-dad44371331d@gmail.com>
 <20210210103059.GR1463@shell.armlinux.org.uk>
User-Agent: Roundcube Webmail/1.4.10
Message-ID: <d35f726f82c6c743519f3d8a36037dfa@walle.cc>
X-Sender: michael@walle.cc
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2021-02-10 11:30, schrieb Russell King - ARM Linux admin:
> On Wed, Feb 10, 2021 at 08:03:07AM +0100, Heiner Kallweit wrote:
>> On 09.02.2021 17:40, Michael Walle wrote:
>> > +out:
>> > +	return phy_restore_page(phydev, oldpage, err);
>> 
>> If a random page was set before entering config_init, do we actually 
>> want
>> to restore it? Or wouldn't it be better to set the default page as 
>> part
>> of initialization?
> 
> I think you've missed asking one key question: does the paging on this
> PHY affect the standardised registers at 0..15 inclusive, or does it
> only affect registers 16..31?

For this PHY it affects only registers >=16. But that doesn't invaldiate
the point that for other PHYs this might affect all regsisters. Eg. ones
where you could select between fiber and copper pages, right?

> If it doesn't affect the standardised registers, then the genphy_*
> functions don't care which page is selected.

-- 
-michael
