Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19CE628164A
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 17:14:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388296AbgJBPOL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 11:14:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726017AbgJBPOK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 11:14:10 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA68EC0613D0;
        Fri,  2 Oct 2020 08:14:10 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id s14so978132pju.1;
        Fri, 02 Oct 2020 08:14:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cGNKaBMh3uHXuYbt3cZz1U1JxLB1ZMRyGwuoggkhc2M=;
        b=SyC+iDBKdFLQMS0k3F6plRyS3gb3GKpoQmC6y/r2JgCA1B8FJUFG5mJg0qDfwNKz71
         whx5e7JlbvNzn+kH41Pajh2h5liry4u8jBbSIp3KcX939HwHlGKnifYnCTPaWfn7J89+
         LOsHc/6WfjvPwC3eECJCH2gLOfcy7/i+zffVzy6FrylCZnQvXt0HCk2EoZpDjSPZNeVi
         Bt+Ap8Co9q5QIeY1X7cNKqenHQZzsux+mEbzH0j3IocIhYqhPJgHtKHX4utTuqCMv8ts
         HRvqTzQ7QCroEYCJGVVq/MOmqOx6ZzhYxjwHNFujubAofK/DeVO5bUh59W/rZ31od08/
         VqHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cGNKaBMh3uHXuYbt3cZz1U1JxLB1ZMRyGwuoggkhc2M=;
        b=NqLWa/zjyxes8GYVwrjvxRxlaMZAkA+LVuZVDtP+yKllFx+2l/IauhT8zEwFKFmAGO
         ibMG/Fw5BOWvu5jekSzLX6EPhxmgge/T3ts6cOg7bqb8eJpnSAFs8OnpMNqviQuIZi6B
         ieO7v5EW4CajUWCh3UsTyHzY3j6AekbspcnXsAfsK0un8LpouRHR2n7QoKcniLx96vuX
         75xtSyhvbrkXY7+RYh/fJAOBbxav8vhwkzAg2dHMBepXhHoLOo/XYv6qie+Ie92R3ngp
         aNLf+eGKgS0tVeIJxYAZ19Rsjsn6BGsTe/9nD8XivzWzyX1I/Ppa1vmKvutZ0lmfZ2SR
         eSUw==
X-Gm-Message-State: AOAM531CGxe5PB+IAGhwVnvEnjUhGQc14xlsn7V8P27VwVoycUM02V0X
        JO4Js7OlHsYP6vWyPjrFElamoibV1Dm5Jg==
X-Google-Smtp-Source: ABdhPJxRj+oXjCFHLcbUCsWQ3OC/nynuWVNf1/JBivOhLtLXjEPZjhm+ocFv39TW1MFvxBAvTvDZGw==
X-Received: by 2002:a17:90a:e00e:: with SMTP id u14mr3300963pjy.153.1601651650245;
        Fri, 02 Oct 2020 08:14:10 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id 22sm2326807pfw.17.2020.10.02.08.14.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Oct 2020 08:14:09 -0700 (PDT)
Subject: Re: [net-next PATCH v1 3/7] net: phy: Introduce fwnode_get_phy_id()
To:     Grant Likely <grant.likely@arm.com>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc:     linux-kernel@vger.kernel.org, linux.cj@gmail.com,
        netdev@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, nd <nd@arm.com>
References: <20200930160430.7908-1-calvin.johnson@oss.nxp.com>
 <20200930160430.7908-4-calvin.johnson@oss.nxp.com>
 <11e6b553-675f-8f3d-f9d5-316dae381457@arm.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <679fab8f-d33a-9ce8-1982-788d5f90185e@gmail.com>
Date:   Fri, 2 Oct 2020 08:14:07 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <11e6b553-675f-8f3d-f9d5-316dae381457@arm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/2/2020 4:05 AM, Grant Likely wrote:
> 
> 
> On 30/09/2020 17:04, Calvin Johnson wrote:
>> Extract phy_id from compatible string. This will be used by
>> fwnode_mdiobus_register_phy() to create phy device using the
>> phy_id.
>>
>> Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
>> ---
>>
>>   drivers/net/phy/phy_device.c | 32 +++++++++++++++++++++++++++++++-
>>   include/linux/phy.h          |  5 +++++
>>   2 files changed, 36 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
>> index c4aec56d0a95..162abde6223d 100644
>> --- a/drivers/net/phy/phy_device.c
>> +++ b/drivers/net/phy/phy_device.c
>> @@ -9,6 +9,7 @@
>>   #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>> +#include <linux/acpi.h>
>>   #include <linux/bitmap.h>
>>   #include <linux/delay.h>
>>   #include <linux/errno.h>
>> @@ -845,6 +846,27 @@ static int get_phy_c22_id(struct mii_bus *bus, 
>> int addr, u32 *phy_id)
>>       return 0;
>>   }
>> +/* Extract the phy ID from the compatible string of the form
>> + * ethernet-phy-idAAAA.BBBB.
>> + */
>> +int fwnode_get_phy_id(struct fwnode_handle *fwnode, u32 *phy_id)
>> +{
>> +    unsigned int upper, lower;
>> +    const char *cp;
>> +    int ret;
>> +
>> +    ret = fwnode_property_read_string(fwnode, "compatible", &cp);
>> +    if (ret)
>> +        return ret;
>> +
>> +    if (sscanf(cp, "ethernet-phy-id%4x.%4x", &upper, &lower) == 2) {
>> +        *phy_id = ((upper & 0xFFFF) << 16) | (lower & 0xFFFF);
>> +        return 0;
>> +    }
>> +    return -EINVAL;
>> +}
>> +EXPORT_SYMBOL(fwnode_get_phy_id);
> 
> This block, and the changes in patch 4 duplicate functions from 
> drivers/of/of_mdio.c, but it doesn't refactor anything in 
> drivers/of/of_mdio.c to use the new path. Is your intent to bring all of 
> the parsing in these functions of "compatible" into the ACPI code path?
> 
> If so, then the existing code path needs to be refactored to work with 
> fwnode_handle instead of device_node.
> 
> If not, then the DT path in these functions should call out to of_mdio, 
> while the ACPI path only does what is necessary.

Rob has been asking before to have drivers/of/of_mdio.c be merged or at 
least relocated within drivers/net/phy where it would naturally belong. 
As a preliminary step towards ACPI support that would seem reasonable to do.

Then, as Grant suggests you can start re-factoring as much as possible 
with using fwnode_handle.
-- 
Florian
