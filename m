Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B703B162C6C
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 18:17:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726821AbgBRRRb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 12:17:31 -0500
Received: from fllv0016.ext.ti.com ([198.47.19.142]:52738 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726521AbgBRRRa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 12:17:30 -0500
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 01IHHKY5014972;
        Tue, 18 Feb 2020 11:17:20 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1582046240;
        bh=+TJ5/KK2cxl2V9h577y11dsncne9pQ6lzeQkl9kF/2U=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=EYJNrGWlxkzUzl2W9wb0KDQ3bLbjRkF0cTjuO8rcSWkr3DP6OfUQqWWhuXqJ0PEUT
         CSO4ub0oGecXzQtRblk+tjzpM4dvnv/GOF/1hCCYiHmhgj83KHwTZIVFIiFlaWZMa4
         cILf3FHn96HI+wC845eWOGT9hqJfk/d7KuAzEUQU=
Received: from DFLE115.ent.ti.com (dfle115.ent.ti.com [10.64.6.36])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 01IHHK7p052689;
        Tue, 18 Feb 2020 11:17:20 -0600
Received: from DFLE110.ent.ti.com (10.64.6.31) by DFLE115.ent.ti.com
 (10.64.6.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Tue, 18
 Feb 2020 11:17:20 -0600
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE110.ent.ti.com
 (10.64.6.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Tue, 18 Feb 2020 11:17:20 -0600
Received: from [10.250.65.13] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 01IHHJOf027448;
        Tue, 18 Feb 2020 11:17:20 -0600
Subject: Re: [PATCH net-next v2] net: phy: dp83867: Add speed optimization
 feature
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
CC:     Grygorii Strashko <grygorii.strashko@ti.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, <andrew@lunn.ch>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20200204181319.27381-1-dmurphy@ti.com>
 <0ebcd40d-b9cc-1a76-bb18-91d8350aa1cd@gmail.com>
 <170d6518-ea82-08d3-0348-228c72425e64@ti.com>
 <7569617d-f69f-9190-1223-77d3be637753@gmail.com>
 <c7a7bd71-3a1c-1cf3-5faa-204b10ea8b78@ti.com>
 <44499cb2-ec72-75a1-195b-fbadd8463e1c@ti.com>
 <6f800f83-0008-c138-c33a-c00a95862463@ti.com>
 <20200218162522.GH25745@shell.armlinux.org.uk>
 <1346e6b0-1d20-593f-d994-37de87ede891@ti.com>
 <20200218164928.GJ25745@shell.armlinux.org.uk>
From:   Dan Murphy <dmurphy@ti.com>
Message-ID: <cba40adb-38b9-2e66-c083-3ca7b570b927@ti.com>
Date:   Tue, 18 Feb 2020 11:12:37 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200218164928.GJ25745@shell.armlinux.org.uk>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Russell

On 2/18/20 10:49 AM, Russell King - ARM Linux admin wrote:
> On Tue, Feb 18, 2020 at 10:36:47AM -0600, Dan Murphy wrote:
>> Russell
>>
>> On 2/18/20 10:25 AM, Russell King - ARM Linux admin wrote:
>>> On Fri, Feb 14, 2020 at 12:31:52PM -0600, Dan Murphy wrote:
>>>> Grygorii
>>>>
>>>> On 2/14/20 12:32 PM, Grygorii Strashko wrote:
>>>>> I think it's good idea to have this message as just wrong cable might be
>>>>> used.
>>>>>
>>>>> But this notifier make no sense in it current form - it will produce
>>>>> noise in case of forced 100m/10M.
>>>>>
>>>>> FYI. PHY sequence to update link:
>>>>> phy_state_machine()
>>>>> |-phy_check_link_status()
>>>>>     |-phy_link_down/up()
>>>>>       |- .phy_link_change()->phy_link_change()
>>>>>       |-adjust_link() ----> netdev callback
>>>>> |-phydev->drv->link_change_notify(phydev);
>>>>>
>>>>> So, log output has to be done or in .read_status() or
>>>>> some info has to be saved in .read_status() and then re-used in
>>>>> .link_change_notify().
>>>>>
>>>> OK I will try to find a way to give some sort of message.
>>> How do you know the speed that the PHY downshifted to?
>> The DP83867 has a register PHYSTS where BIT 15:14 indicate the speed that
>> the PHY negotiated.
>>
>> In the same register BIT 13 indicates the duplex mode.
>>
>>> If the speed and duplex are available in some PHY specific status
>>> register, then one way you can detect downshift is to decode the
>>> negotiated speed/duplex from the advertisements (specifically the LPA
>>> read from the registers and the advertisement that we should be
>>> advertising - some PHYs modify their registers when downshifting) and
>>> check whether it matches the negotiated parameters in the PHY
>>> specific status register.
>>>
>>> Alternatively, if the PHY modifies the advertisement register on
>>> downshift, comparing the advertisement register with what it should
>>> be will tell you if downshift has occurred.
>> The ISR register BIT 5 indicates if a downshift occurred or not. So we can
>> indicate that the PHY downshifted but there is no cause in the registers bit
>> field.  My concern for this bit though is the register is clear on read so
>> all other interrupts are lost if we only read to check downshift.  And the
>> link_change_notifier is called before the interrupt ACK call back.  We could
>> call the interrupt function and get the downshift status but again it will
>> clear the interrupt register and any other statuses may be lost.
> What's wrong with having an ack_interrupt() method that reads the
> PHY ISR register, and records in a driver private flag that bit 5
> has been set?  The read_status() method can clear the flag if link
> goes down, or check the flag if link is up and report that a
> downshift event occurred.
>
> If IRQs are not in use, then read_status() would have to read the
> ISR itself.
>
> It may be better to move ack_interrupt() to did_interrupt(), which
> will ensure that it gets executed before the PHY state machine is
> triggered by phy_interrupt().
>
Well now the read_status is becoming a lot more complex.  It would be 
better to remove the ack_interrupt call back and just have read_status 
call the interrupt function regardless of interrupts or not.  Because 
all the interrupt function would be doing is clearing all the interrupts 
in the ISR register on a link up/down event.  And as you pointed out we 
can check and set a flag that indicates if a downshift has happened on 
link up status and clear it on link down. We would need to set the 
downshift interrupt mask to always report that bit.  As opposed to not 
setting any interrupts if interrupts are not enabled.  If the user wants 
to track WoL interrupt or any other feature interrupt we would have to 
add that flag to the read_status as well seems like it could get a bit 
out of control.

Again this is a lot of error prone complex changes and tracking just to 
populate a message in the kernel log.  There is no guarantee that the LP 
did not force the downshift or advertise that it supports 1Gbps.  So 
what condition is really being reported here?  There seems like there 
are so many different scenarios why the PHY could not negotiate to its 
advertised 1Gbps.


Dan


