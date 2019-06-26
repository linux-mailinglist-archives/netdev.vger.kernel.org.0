Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8267656CA6
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 16:48:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728454AbfFZOsJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 10:48:09 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:51122 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728398AbfFZOr5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 10:47:57 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id x5QElSHR080337;
        Wed, 26 Jun 2019 09:47:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1561560448;
        bh=euKafHZbspwxm0WbBPizKb3mUMGv/MWPwIANUP7B8M8=;
        h=Subject:To:References:From:Date:In-Reply-To;
        b=h/IXXlmmt4ncU4+QQRtcmK4UwK9El/hxz7x4t8V/h8ghkG0KJ30UZL6Q+qb/Fc3Z3
         99h4bwh+AHOjJj2hTZDDdoFzzuj548JusSiIacn7H6KNrdgPah3mV4orod+HhF52YF
         Yz42z9yZzJLh3P13XA3zwJpZD4x3O+ye1pXGqNiQ=
Received: from DFLE115.ent.ti.com (dfle115.ent.ti.com [10.64.6.36])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id x5QElSp7067781
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 26 Jun 2019 09:47:28 -0500
Received: from DFLE114.ent.ti.com (10.64.6.35) by DFLE115.ent.ti.com
 (10.64.6.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Wed, 26
 Jun 2019 09:47:27 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE114.ent.ti.com
 (10.64.6.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5 via
 Frontend Transport; Wed, 26 Jun 2019 09:47:27 -0500
Received: from [10.250.96.121] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id x5QElOE7019579;
        Wed, 26 Jun 2019 09:47:24 -0500
Subject: Re: [RFC PATCH v4 net-next 06/11] net: ethernet: ti: introduce cpsw
 switchdev based driver part 1 - dual-emac
To:     <netdev@vger.kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@resnulli.us>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sekhar Nori <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Rob Herring <robh+dt@kernel.org>, <devicetree@vger.kernel.org>
References: <20190621181314.20778-1-grygorii.strashko@ti.com>
 <20190621181314.20778-7-grygorii.strashko@ti.com>
 <20190626095839.GE6485@khorivan>
From:   grygorii <grygorii.strashko@ti.com>
Message-ID: <d6f1f1fb-21c3-ca5f-2585-8d1c3a4f571d@ti.com>
Date:   Wed, 26 Jun 2019 17:47:20 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190626095839.GE6485@khorivan>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 26/06/2019 12:58, Ivan Khoronzhuk wrote:
> Hi Grygorii
> 
> Too much code, but I've tried pass thru.
> Probably expectation the devlink to be reviewed, but several
> common replies that should be reflected in non RFC v.
> 
> On Fri, Jun 21, 2019 at 09:13:09PM +0300, Grygorii Strashko wrote:
>> From: Ilias Apalodimas <ilias.apalodimas@linaro.org>
>>
>> Part 1:
>> Introduce basic CPSW dual_mac driver (cpsw_new.c) which is operating in
>> dual-emac mode by default, thus working as 2 individual network interfaces.
>> Main differences from legacy CPSW driver are:
>>
>> - optimized promiscuous mode: The P0_UNI_FLOOD (both ports) is enabled in
>> addition to ALLMULTI (current port) instead of ALE_BYPASS. So, Ports in
>> promiscuous mode will keep possibility of mcast and vlan filtering, which
>> is provides significant benefits when ports are joined to the same bridge,
>> but without enabling "switch" mode, or to different bridges.
>> - learning disabled on ports as it make not too much sense for
>>   segregated ports - no forwarding in HW.
>> - enabled basic support for devlink.
>>
>>     devlink dev show
>>         platform/48484000.ethernet_switch
>>
>>     devlink dev param show
>>      platform/48484000.ethernet_switch:
>>     name ale_bypass type driver-specific
>>      values:
>>         cmode runtime value false
>>
>> - "ale_bypass" devlink driver parameter allows to enable
>> ALE_CONTROL(4).BYPASS mode for debug purposes.
>> - updated DT bindings.
>>
>> Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
>> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
>

[...]

>> +
>> +    /* setup host port priority mapping */
>> +    writel_relaxed(CPDMA_TX_PRIORITY_MAP,
>> +               &cpsw->host_port_regs->cpdma_tx_pri_map);
>> +    writel_relaxed(0, &cpsw->host_port_regs->cpdma_rx_chan_map);
> 
> ----
>> +
>> +    /* disable priority elevation */
>> +    writel_relaxed(0, &cpsw->regs->ptype);
>> +
>> +    /* enable statistics collection only on all ports */
>> +    writel_relaxed(0x7, &cpsw->regs->stat_port_en);
>> +
>> +    /* Enable internal fifo flow control */
>> +    writel(0x7, &cpsw->regs->flow_control);
> ---
> 
> Would be nice to do the same in old driver.
> I mean moving it from ndo_open
> Also were thoughts about this.

I have no plans to perform any kind of optimization in old driver any more.

Agree with other comments.

[...]

Thank you.

-- 
Best regards,
grygorii
