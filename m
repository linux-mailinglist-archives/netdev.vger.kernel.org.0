Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68EFC1511A1
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 22:10:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727097AbgBCVKZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 16:10:25 -0500
Received: from foss.arm.com ([217.140.110.172]:59412 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725372AbgBCVKZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Feb 2020 16:10:25 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 47B17101E;
        Mon,  3 Feb 2020 13:10:24 -0800 (PST)
Received: from [192.168.122.164] (unknown [10.118.28.21])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1D9543F68E;
        Mon,  3 Feb 2020 13:10:24 -0800 (PST)
Subject: Re: [PATCH 3/6] net: bcmgenet: enable automatic phy discovery
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, opendmb@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, bcm-kernel-feedback-list@broadcom.com,
        linux-kernel@vger.kernel.org, wahrenst@gmx.net,
        hkallweit1@gmail.com
References: <20200201074625.8698-1-jeremy.linton@arm.com>
 <20200201074625.8698-4-jeremy.linton@arm.com> <20200201152518.GI9639@lunn.ch>
 <ad9bc142-c0a8-74af-09c6-7150ff4b854a@arm.com>
 <20200203011528.GA30319@lunn.ch>
From:   Jeremy Linton <jeremy.linton@arm.com>
Message-ID: <b6505e78-9dbc-9c97-b4f8-1c9eac24b52e@arm.com>
Date:   Mon, 3 Feb 2020 15:10:23 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200203011528.GA30319@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 2/2/20 7:15 PM, Andrew Lunn wrote:
>> I though I should clarify the direct question here about ACPI. ACPI does
>> have the ability to do what you describe, but it a more rigorous way. If you
>> look at the ACPI GenericSerialBus abstraction you will see how ACPI would
>> likely handle this situation. I've been considering making a similar comment
>> in that large fwnode patch set posted the other day.

I should have been a lot more specific here, but I didn't want to write 
a book.

> 
> I know ~0 about ACPI. But it does not seem unreasonable to describe an
> MDIO bus in the same way as an i2c bus, or an spi bus. Each can have
> devices on it, at specific addresses. Each needs common properties
> like interrupts, and each needs bus specific properties like SPI
> polarity. And you need pointers to these devices, so that other
> subsystems can use them.
> 
> So maybe the correct way to describe this is to use ACPI
> GenericSerialBus?

AFAIK, not as the specification stands today.

First its not defined for MDIO (see 6-240 in acpi 6.3) , and secondly 
because its intended to be used from AML (one of the examples IIRC is to 
read battery vendor info). That implies to me, that the ACPI standards 
body's would also have to add some additional methods which configure 
and return state about the phys. AKA some of the linux phy_() functions 
would just redirect to AML equivalents the same way there are AML 
battery functions for returning status/etc.

