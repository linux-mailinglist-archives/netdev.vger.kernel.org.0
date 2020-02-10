Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D44B4158423
	for <lists+netdev@lfdr.de>; Mon, 10 Feb 2020 21:10:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727363AbgBJUKb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Feb 2020 15:10:31 -0500
Received: from lelv0142.ext.ti.com ([198.47.23.249]:39364 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727056AbgBJUKa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Feb 2020 15:10:30 -0500
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 01AK9s3i089232;
        Mon, 10 Feb 2020 14:09:54 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1581365394;
        bh=AFL81LYESA2xTo1aeZkayWnryvzu4ghmI9VBCmzaZ2c=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=xLPc/jlo1dOpnGbkqgDhWC0DrVbaDFm4aIlu7L+KgY5MiwIqdAfZcoDTns5yQDKwD
         OEYrnfH2L5cJpTMcI3FEO1tAmSlhUK5p9p/E6U2GpRrUAIFGVKZmJM7ohUXxg4iRG6
         T6oWVPcvuJVptLgll6iqs/Ojf6EjJyGP27HmNFiI=
Received: from DLEE106.ent.ti.com (dlee106.ent.ti.com [157.170.170.36])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 01AK9s7Q035091
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 10 Feb 2020 14:09:54 -0600
Received: from DLEE112.ent.ti.com (157.170.170.23) by DLEE106.ent.ti.com
 (157.170.170.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Mon, 10
 Feb 2020 14:09:54 -0600
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE112.ent.ti.com
 (157.170.170.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Mon, 10 Feb 2020 14:09:54 -0600
Received: from [158.218.117.45] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 01AK9qra005248;
        Mon, 10 Feb 2020 14:09:52 -0600
Subject: Re: [v1,net-next, 1/2] ethtool: add setting frame preemption of
 traffic classes
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Po Liu <po.liu@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "hauke.mehrtens@intel.com" <hauke.mehrtens@intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "allison@lohutok.net" <allison@lohutok.net>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "alexandru.ardelean@analog.com" <alexandru.ardelean@analog.com>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "ayal@mellanox.com" <ayal@mellanox.com>,
        "pablo@netfilter.org" <pablo@netfilter.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "simon.horman@netronome.com" <simon.horman@netronome.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Roy Zang <roy.zang@nxp.com>, Mingkai Hu <mingkai.hu@nxp.com>,
        Jerry Huang <jerry.huang@nxp.com>, Leo Li <leoyang.li@nxp.com>
References: <20191127094517.6255-1-Po.Liu@nxp.com>
 <87v9p93a2s.fsf@linux.intel.com>
 <9b13a47e-8ca3-66b0-063c-798a5fa71149@ti.com>
 <CA+h21hqk2pCfrQg5kC6HzmL=eEqJXjuRsu+cVkGsEi8OXGpKJA@mail.gmail.com>
From:   Murali Karicheri <m-karicheri2@ti.com>
Message-ID: <700c20c2-6112-100f-d198-40ee74a167c1@ti.com>
Date:   Mon, 10 Feb 2020 15:17:13 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.7.0
MIME-Version: 1.0
In-Reply-To: <CA+h21hqk2pCfrQg5kC6HzmL=eEqJXjuRsu+cVkGsEi8OXGpKJA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

On 01/23/2020 08:30 AM, Vladimir Oltean wrote:
> Hi Murali,
> 
> On Wed, 22 Jan 2020 at 20:04, Murali Karicheri <m-karicheri2@ti.com> wrote:
>>
>> I have question about the below parameters in The Gate Parameter Table
>> that are not currently supported by tc command. Looks like they need to
>> be shown to user for management.
>>
>>       - ConfigChange - Looks like this needs to be controlled by
>>         user. After sending admin command, user send this trigger to start
>>         copying admin schedule to operation schedule. Is this getting
>>         added to tc command?
> 
> "The ConfigChange parameter signals the start of a
> configuration change for the gate
> when it is set to TRUE. This should only be done
> when the various administrative parameters
> are all set to appropriate values."
> 
> As far as my understanding goes, all tc-taprio commands currently
> behave as though this boolean is implicitly set to TRUE after the
> structures have been set up. I'm not sure there is any value in doing
> otherwise.
> 
That is my understanding as well. However I found this in the 802.1Q
and want to see if someone has insight into this parameter. So perhaps
we can ignore this for now and re-visit when there is a real need for
the same.

>>       - ConfigChangeTime - The time at which the administrative variables
>>         that determine the cycle are to be copied across to the
>>         corresponding operational variables, expressed as a PTP timescale
> 
> This is the base-time of the admin schedule, no?

I think there is cycle time extension possible and in that case,
ConfigChangeTime may be different from Admin  base-time. So this gives
the actual time when the cycle configuration is actually applied.

> 
> "The PTPtime at which the next config change is scheduled to occur.
> The value is a representation of a PTPtime value,
> consisting of a 48-bit integer
> number of seconds and a 32-bit integer number of nanoseconds."
> 
>>       - TickGranularity - the management parameters specified in Gate
>>         Parameter Table allow a management station to discover the
>>         characteristics of an implementation’s cycle timer clock
>>         (TickGranularity) and to set the parameters for the gating cycle
>>         accordingly.
> 
> Not sure who is going to use this and for what purpose, but ok.

Same here. Not sure how this will be used by application.

> 
>>       - ConfigPending - A Boolean variable, set TRUE to indicate that
>>         there is a new cycle configuration awaiting installation.
> 
> I had tried to export something like this (driver calls back into
> sch_taprio.c when hw has applied the config, this would result in
> ConfigPending = FALSE), but ultimately didn't finish the idea, and it
> caused some problems too, due to incorrect RCU usage.
> 

Ok. Hope you plan to send a patch for this in the future.

>>       - ConfigChangeError - Error in configuration (AdminBaseTime <
>>         CurrentTime)
> 
> This can be exported similarly.

Ok.

> 
>>       - SupportedListMax - Maximum supported Admin/Open shed list.
>>
>> Is there a plan to export these from driver through tc show or such
>> command? The reason being, there would be applications developed to
>> manage configuration/schedule of TSN nodes that would requires these
>> information from the node. So would need a support either in tc or
>> some other means to retrieve them from hardware or driver. That is my
>> understanding...
>>
> 
> Not sure what answer you expect to receive for "is there any plan".

To avoid duplicating the work if someone is already working on this.

> You can go ahead and propose something, as long as it is reasonably
> useful to have.
Ok. Will keep in mind.
> 
>> Regards,
>>
>> Murali
>>
>> --
>> Murali Karicheri
>> Texas Instruments
> 
> Thanks,
> -Vladimir
> 

-- 
Murali Karicheri
Texas Instruments
