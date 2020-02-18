Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87DD3162D3B
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 18:43:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726751AbgBRRn0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 12:43:26 -0500
Received: from fllv0016.ext.ti.com ([198.47.19.142]:57422 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726707AbgBRRn0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 12:43:26 -0500
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 01IHhGVJ023283;
        Tue, 18 Feb 2020 11:43:16 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1582047796;
        bh=O4+gW1g1SRXHovfi3SfzE51aWRM2NSIHiqZ75JZRyRY=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=kMONkZtubMwK1yj81o7zAslQaD9mRvsGiRMt/29eyBWw8fg9YF5kV9O7tkwR0zz9X
         1+l7ZBejjatAC1h0jQKy5UAsbuRdsRpbozQeZHT3ASLEl7wBe5hrIEXq9WxB5rNcv9
         uICIkfEEoViupJdCKb/Z9uP9u/nNpmHl5srDtfIs=
Received: from DFLE115.ent.ti.com (dfle115.ent.ti.com [10.64.6.36])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 01IHhGCf093868
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 18 Feb 2020 11:43:16 -0600
Received: from DFLE114.ent.ti.com (10.64.6.35) by DFLE115.ent.ti.com
 (10.64.6.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Tue, 18
 Feb 2020 11:43:16 -0600
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE114.ent.ti.com
 (10.64.6.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Tue, 18 Feb 2020 11:43:16 -0600
Received: from [10.250.65.13] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 01IHhGPL061422;
        Tue, 18 Feb 2020 11:43:16 -0600
Subject: Re: [PATCH net-next v2] net: phy: dp83867: Add speed optimization
 feature
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
CC:     Grygorii Strashko <grygorii.strashko@ti.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, <andrew@lunn.ch>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <0ebcd40d-b9cc-1a76-bb18-91d8350aa1cd@gmail.com>
 <170d6518-ea82-08d3-0348-228c72425e64@ti.com>
 <7569617d-f69f-9190-1223-77d3be637753@gmail.com>
 <c7a7bd71-3a1c-1cf3-5faa-204b10ea8b78@ti.com>
 <44499cb2-ec72-75a1-195b-fbadd8463e1c@ti.com>
 <6f800f83-0008-c138-c33a-c00a95862463@ti.com>
 <20200218162522.GH25745@shell.armlinux.org.uk>
 <1346e6b0-1d20-593f-d994-37de87ede891@ti.com>
 <20200218164928.GJ25745@shell.armlinux.org.uk>
 <cba40adb-38b9-2e66-c083-3ca7b570b927@ti.com>
 <20200218173353.GM25745@shell.armlinux.org.uk>
From:   Dan Murphy <dmurphy@ti.com>
Message-ID: <f5c42936-98a6-8221-a244-ed61840c9c81@ti.com>
Date:   Tue, 18 Feb 2020 11:38:33 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200218173353.GM25745@shell.armlinux.org.uk>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Russell

On 2/18/20 11:33 AM, Russell King - ARM Linux admin wrote:
> On Tue, Feb 18, 2020 at 11:12:37AM -0600, Dan Murphy wrote:
>> Well now the read_status is becoming a lot more complex.  It would be better
>> to remove the ack_interrupt call back and just have read_status call the
>> interrupt function regardless of interrupts or not.  Because all the
>> interrupt function would be doing is clearing all the interrupts in the ISR
>> register on a link up/down event.  And as you pointed out we can check and
>> set a flag that indicates if a downshift has happened on link up status and
>> clear it on link down. We would need to set the downshift interrupt mask to
>> always report that bit.  As opposed to not setting any interrupts if
>> interrupts are not enabled.  If the user wants to track WoL interrupt or any
>> other feature interrupt we would have to add that flag to the read_status as
>> well seems like it could get a bit out of control.
> To be honest, I don't like phylib's interrupt implementation; it
> imposes a fixed way of dealing with interrupts on phylib drivers,
> and it sounds like its ideas don't match what modern PHYs want.
>
> For example, the Marvell 88x3310 can produce interrupts for GPIOs
> that are on-board, or temperature alarms, or other stuff... but
> phylib's idea is that a PHY interrupt is for signalling that the
> link changed somehow, and imposes a did_interrupt(), handle
> interrupt, clear_interrupt() structure whether or not it's
> suitable for the PHY.  If you don't provide the functions phylib
> wants, then phydev->irq gets killed.  Plus, phylib claims the
> interrupt for you at certain points depending on whether the
> PHY is bound to a network interface or not.
>
> So, my suggestion to move ack_interrupt to did_interrupt will
> result in phylib forcing phydev->irq to PHY_POLL, killing any
> support for interrupts what so ever...

Does it really make sense to do all of this for a downshift message in 
the kernel log?

>> Again this is a lot of error prone complex changes and tracking just to
>> populate a message in the kernel log.  There is no guarantee that the LP did
>> not force the downshift or advertise that it supports 1Gbps.  So what
>> condition is really being reported here?  There seems like there are so many
>> different scenarios why the PHY could not negotiate to its advertised 1Gbps.
> Note that when a PHY wants to downshift, it does that by changing its
> advertisement that is sent to the other PHY.
>
> So, if both ends support 1G, 100M and 10M, and the remote end decides
> to downshift to 100M, the remote end basically stops advertising 1G
> and restarts negotiation afresh with the new advertisement.
>
> In that case, if you look at ethtool's output, it will indicate that
> the link partner is not advertising 1G, and the link is operating at
> 100M.
>
> If 100M doesn't work (and there are cases where connections become
> quite flakey) then 100M may also be omitted as well, negotiation
> restarted, causing a downshift to 10M.
>
> That's basically how downshift works - a PHY will attempt to
> establish link a number of times before deciding to restart
> negotiation with some of the advertisement omitted, and the
> reduced negotiation advertisement appears in the remote PHY's
> link partner registers.
This is the way I understand it too.
> As I mentioned, the PHY on either end of the link can be the one
> which decides to downshift, and the partner PHY has no idea that
> a downshift has happened.
>
Exactly so we can only report that if the PHY on our end caused the 
downshift.  If this PHY does not cause the downshift then the message 
will not be presented even though a downshift occurred. So what is the 
value in presenting this message?

