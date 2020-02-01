Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E49C614FA1C
	for <lists+netdev@lfdr.de>; Sat,  1 Feb 2020 20:09:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726881AbgBATJE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Feb 2020 14:09:04 -0500
Received: from foss.arm.com ([217.140.110.172]:43398 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726270AbgBATJD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 1 Feb 2020 14:09:03 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2D4E9FEC;
        Sat,  1 Feb 2020 11:09:03 -0800 (PST)
Received: from [192.168.122.164] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D87783F68E;
        Sat,  1 Feb 2020 11:09:02 -0800 (PST)
Subject: Re: [PATCH 4/6] net: bcmgenet: Initial bcmgenet ACPI support
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, opendmb@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, bcm-kernel-feedback-list@broadcom.com,
        linux-kernel@vger.kernel.org, wahrenst@gmx.net,
        hkallweit1@gmail.com
References: <20200201074625.8698-1-jeremy.linton@arm.com>
 <20200201074625.8698-5-jeremy.linton@arm.com> <20200201153315.GJ9639@lunn.ch>
From:   Jeremy Linton <jeremy.linton@arm.com>
Message-ID: <0536fbdc-f118-3165-9e63-913c1d0def9d@arm.com>
Date:   Sat, 1 Feb 2020 13:09:02 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200201153315.GJ9639@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 2/1/20 9:33 AM, Andrew Lunn wrote:
>> @@ -3595,7 +3597,7 @@ static int bcmgenet_probe(struct platform_device *pdev)
>>   	/* If this is an internal GPHY, power it on now, before UniMAC is
>>   	 * brought out of reset as absolutely no UniMAC activity is allowed
>>   	 */
>> -	if (dn && !of_property_read_string(dn, "phy-mode", &phy_mode_str) &&
>> +	if (!device_property_read_string(&pdev->dev, "phy-mode", &phy_mode_str) &&
>>   	    !strcasecmp(phy_mode_str, "internal"))
>>   		bcmgenet_power_up(priv, GENET_POWER_PASSIVE);
> 
> The code you are modifying appears to be old and out of date. For a
> long time there has been a helper, of_get_phy_mode(). You should look
> at fwnode_get_phy_mode().

Yes, thanks, I did that in the other phy path but not here.
