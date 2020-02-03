Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E438150FE6
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 19:46:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729759AbgBCSqj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 13:46:39 -0500
Received: from foss.arm.com ([217.140.110.172]:58486 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728185AbgBCSqi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Feb 2020 13:46:38 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EFAD7101E;
        Mon,  3 Feb 2020 10:46:37 -0800 (PST)
Received: from [192.168.122.164] (unknown [10.118.28.21])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CEBDB3F52E;
        Mon,  3 Feb 2020 10:46:37 -0800 (PST)
Subject: Re: [PATCH 2/6] net: bcmgenet: refactor phy mode configuration
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, opendmb@gmail.com, davem@davemloft.net,
        bcm-kernel-feedback-list@broadcom.com,
        linux-kernel@vger.kernel.org, wahrenst@gmx.net,
        hkallweit1@gmail.com
References: <20200201074625.8698-1-jeremy.linton@arm.com>
 <20200201074625.8698-3-jeremy.linton@arm.com>
 <b2d45990-af71-60c3-a210-b23dabb9ba32@gmail.com>
 <20200203011732.GB30319@lunn.ch>
 <1146c2fa-0f43-39d2-e6e0-3d255bfd5be3@gmail.com>
From:   Jeremy Linton <jeremy.linton@arm.com>
Message-ID: <0d743b51-fd77-db8c-1910-c725c4b2e7b9@arm.com>
Date:   Mon, 3 Feb 2020 12:46:31 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <1146c2fa-0f43-39d2-e6e0-3d255bfd5be3@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 2/2/20 9:24 PM, Florian Fainelli wrote:
> 
> 
> On 2/2/2020 5:17 PM, Andrew Lunn wrote:
>> On Sat, Feb 01, 2020 at 08:24:14AM -0800, Florian Fainelli wrote:
>>>
>>>
>>> On 1/31/2020 11:46 PM, Jeremy Linton wrote:
>>>> The DT phy mode is similar to what we want for ACPI
>>>> lets factor it out of the of path, and change the
>>>> of_ call to device_. Further if the phy-mode property
>>>> cannot be found instead of failing the driver load lets
>>>> just default it to RGMII.
>>>
>>> Humm no please do not provide a fallback, if we cannot find a valid
>>> 'phy-mode' property we error out. This controller can be used with a
>>> variety of configurations (internal EPHY/GPHY, MoCA, external
>>> MII/Reverse MII/RGMII) and from a support perspective it is much easier
>>> for us if the driver errors out if one of those essential properties are
>>> omitted.
>>
>> Hi Florian
>>
>> Does any of the silicon variants have two or more MACs sharing one
>> MDIO bus? I'm thinking about the next patch in the series.
> 
> Have not come across a customer doing that, but the hardware
> definitively permits it, and so does the top-level chip pinmuxing.
> 

Does the genet driver?

I might be missing something in the driver, but it looks like the whole 
thing is 1:1:1:1 with platform dev:mdio:phy:netdev at the moment. Given 
the way bcmgenet_mii_register is throwing a bcmgenet MII bus for every 
device _probe().


