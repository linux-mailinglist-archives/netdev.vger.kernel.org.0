Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32AFA158437
	for <lists+netdev@lfdr.de>; Mon, 10 Feb 2020 21:24:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727516AbgBJUXz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Feb 2020 15:23:55 -0500
Received: from fllv0016.ext.ti.com ([198.47.19.142]:34162 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727437AbgBJUXz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Feb 2020 15:23:55 -0500
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 01AKNIko012856;
        Mon, 10 Feb 2020 14:23:18 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1581366198;
        bh=M1Td7beGKvgKckRxRbYjVwuAHcQVfdb9OrWelO0p1/M=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=tcXcOcurD0Qrn1wq7WRo9pz0XiELk9+01wOeqvdq9G59S2RStj7Hm6y+K0X++4R7x
         MwcahzVNop3u00CdBtmSiSDQ6/wDBQSp2yR0n6QCc++HOtIEELIagEEzbd1aNezo7M
         ZWa8pS3fDjpP7Zq0hzQAWf9hLaLXvh/cFfeWr/b4=
Received: from DLEE100.ent.ti.com (dlee100.ent.ti.com [157.170.170.30])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 01AKNI2f127064
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 10 Feb 2020 14:23:18 -0600
Received: from DLEE112.ent.ti.com (157.170.170.23) by DLEE100.ent.ti.com
 (157.170.170.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Mon, 10
 Feb 2020 14:23:18 -0600
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE112.ent.ti.com
 (157.170.170.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Mon, 10 Feb 2020 14:23:18 -0600
Received: from [158.218.117.45] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 01AKNGFq056049;
        Mon, 10 Feb 2020 14:23:16 -0600
Subject: Re: [v1,net-next, 1/2] ethtool: add setting frame preemption of
 traffic classes
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Vladimir Oltean <olteanv@gmail.com>
CC:     Po Liu <po.liu@nxp.com>,
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
 <87d0bajc3l.fsf@linux.intel.com>
From:   Murali Karicheri <m-karicheri2@ti.com>
Message-ID: <70deb628-d7bc-d2a3-486d-d3e53854c06e@ti.com>
Date:   Mon, 10 Feb 2020 15:30:37 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.7.0
MIME-Version: 1.0
In-Reply-To: <87d0bajc3l.fsf@linux.intel.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,


On 01/23/2020 12:50 PM, Vinicius Costa Gomes wrote:
> Hi,
> 
> Vladimir Oltean <olteanv@gmail.com> writes:
> 
>> Hi Murali,
>>
>> On Wed, 22 Jan 2020 at 20:04, Murali Karicheri <m-karicheri2@ti.com> wrote:
>>>
>>> I have question about the below parameters in The Gate Parameter Table
>>> that are not currently supported by tc command. Looks like they need to
>>> be shown to user for management.
>>>
>>>       - ConfigChange - Looks like this needs to be controlled by
>>>         user. After sending admin command, user send this trigger to start
>>>         copying admin schedule to operation schedule. Is this getting
>>>         added to tc command?
>>
>> "The ConfigChange parameter signals the start of a
>> configuration change for the gate
>> when it is set to TRUE. This should only be done
>> when the various administrative parameters
>> are all set to appropriate values."
>>
>> As far as my understanding goes, all tc-taprio commands currently
>> behave as though this boolean is implicitly set to TRUE after the
>> structures have been set up. I'm not sure there is any value in doing
>> otherwise.
>>
>>>       - ConfigChangeTime - The time at which the administrative variables
>>>         that determine the cycle are to be copied across to the
>>>         corresponding operational variables, expressed as a PTP timescale
>>
>> This is the base-time of the admin schedule, no?
>>
>> "The PTPtime at which the next config change is scheduled to occur.
>> The value is a representation of a PTPtime value,
>> consisting of a 48-bit integer
>> number of seconds and a 32-bit integer number of nanoseconds."
>>
>>>       - TickGranularity - the management parameters specified in Gate
>>>         Parameter Table allow a management station to discover the
>>>         characteristics of an implementation’s cycle timer clock
>>>         (TickGranularity) and to set the parameters for the gating cycle
>>>         accordingly.
>>
>> Not sure who is going to use this and for what purpose, but ok.
>>
>>>       - ConfigPending - A Boolean variable, set TRUE to indicate that
>>>         there is a new cycle configuration awaiting installation.
>>
>> I had tried to export something like this (driver calls back into
>> sch_taprio.c when hw has applied the config, this would result in
>> ConfigPending = FALSE), but ultimately didn't finish the idea, and it
>> caused some problems too, due to incorrect RCU usage.
>>
> 
> If this should be exported, this should be done from taprio, perhaps
> adding a new field to what is exported via the dump() callback, which
> should be quite easy.
>
We are still working to send a patch for taprio offload on our hardware
and it may take a while to get to this. So if someone can help to add
the required kernel/driver interface for this, that will be great!

>>>       - ConfigChangeError - Error in configuration (AdminBaseTime <
>>>         CurrentTime)
>>
>> This can be exported similarly.
> 
> In my view, having this as a "runtime" error is not useful, as we can
> verify this at configuration time.

Looks like this is not an error per 802.1Q standard if I understood it
correctly.

This is what I see.
=======================================================================
 From 802.1Q 2018, 8.6.9.1.1 SetCycleStartTime()

If AdminBaseTime is set to the same time in the past in all bridges and
end stations, OperBaseTime is always in the past, and all cycles start
synchronized. Using AdminBaseTime in the past is appropriate when you
can start schedules prior to starting the application that uses the
schedules. Use of AdminBaseTime in the future is intended to change a
currently running schedule in all bridges and end stations to a new
schedule at a future time. Using AdminBaseTime in the future is
appropriate when schedules must be changed without stopping the
application
========================================================================

> 
>>
>>>       - SupportedListMax - Maximum supported Admin/Open shed list.
>>>
>>> Is there a plan to export these from driver through tc show or such
>>> command? The reason being, there would be applications developed to
>>> manage configuration/schedule of TSN nodes that would requires these
>>> information from the node. So would need a support either in tc or
>>> some other means to retrieve them from hardware or driver. That is my
>>> understanding...
>>>
> 
> Hm, now I understamd what you meant here...
> 
>>
>> Not sure what answer you expect to receive for "is there any plan".
>> You can go ahead and propose something, as long as it is reasonably
>> useful to have.
> 
> ... if this is indeed useful, perhaps one way to do is to add a subcommand
> to TC_SETUP_QDISC_TAPRIO, so we can retrieve the stats/information we want
> from the driver. Similar to what cls_flower does.
> 

What I understand is that there will be some work done to allow auto
configuration of TSN nodes from user space and that would need access to
all or some of the above parameters along with tc command to configure
the same. May be a open source project for this or some custom
application? Any such projects existing??

Regards,

Murali
>>
>>> Regards,
>>>
>>> Murali
>>>
>>> --
>>> Murali Karicheri
>>> Texas Instruments
>>
>> Thanks,
>> -Vladimir
> 
> Cheers,
> --
> Vinicius
> 

-- 
Murali Karicheri
Texas Instruments
