Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 923672701C5
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 18:14:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726543AbgIRQOT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 12:14:19 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:15006 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726496AbgIRQOL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 12:14:11 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f64dc790000>; Fri, 18 Sep 2020 09:12:41 -0700
Received: from [10.21.180.237] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 18 Sep
 2020 16:14:02 +0000
Subject: Re: [PATCH net-next RFC v4 04/15] devlink: Add reload actions stats
 to dev get
To:     Jiri Pirko <jiri@resnulli.us>
CC:     Ido Schimmel <idosch@idosch.org>,
        Moshe Shemesh <moshe@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <1600063682-17313-1-git-send-email-moshe@mellanox.com>
 <1600063682-17313-5-git-send-email-moshe@mellanox.com>
 <20200914134500.GH2236@nanopsycho.orion> <20200915064519.GA5390@shredder>
 <20200915074402.GM2236@nanopsycho.orion>
 <0d6cb0da-761b-b122-f5b1-b82320cfd5c4@nvidia.com>
 <20200915133406.GQ2236@nanopsycho.orion>
 <bcd28773-0027-11f5-1fd9-0a793f0a3c3a@nvidia.com>
From:   Moshe Shemesh <moshe@nvidia.com>
Message-ID: <bd55e716-7659-c3c4-ded5-c0abbb3d37f3@nvidia.com>
Date:   Fri, 18 Sep 2020 19:13:59 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <bcd28773-0027-11f5-1fd9-0a793f0a3c3a@nvidia.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1600445561; bh=tutrYqskSHP/WZEd6QH96Eyhuoy+btr3igmkP9lHDXU=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Transfer-Encoding:
         Content-Language:X-Originating-IP:X-ClientProxiedBy;
        b=LuCLWpIvpgAuaeZFTJEk7zliCcZVGCRurmG/lvskz9AcdAv68F/QkrTLjvff3ZKvc
         s1KVIrg66pQythBhucdVOmY7ctcthkvoTybkWgHBfe70wqbPOXT/QUlVNYUCww0bwS
         D6Gv1iadF8goI6hlHCd+9mjsvARg6JGsRWeRdLjNZxSGIk0Jw+yRzRGDhdnRXZD0lf
         u+bvWNpjBjCWumbVb1ofI+nqM3O7NDnllgFU5WeNUOndLAWwoqep1Mcr/ju1ntb7QC
         B8F9iHFN2ZldUaLbBFhPPVixU+yL/daEAZZIAw2foWJdpHfqV14PfDtn/pHTG5YSjd
         8dZNKj9+FnzbQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 9/15/2020 11:33 PM, Moshe Shemesh wrote:
> External email: Use caution opening links or attachments
>
>
> On 9/15/2020 4:34 PM, Jiri Pirko wrote:
>> Tue, Sep 15, 2020 at 02:31:38PM CEST, moshe@nvidia.com wrote:
>>> On 9/15/2020 10:44 AM, Jiri Pirko wrote:
>>>> Tue, Sep 15, 2020 at 08:45:19AM CEST, idosch@idosch.org wrote:
>>>>> On Mon, Sep 14, 2020 at 03:45:00PM +0200, Jiri Pirko wrote:
>>>>>> Mon, Sep 14, 2020 at 08:07:51AM CEST, moshe@mellanox.com wrote:
>>>>>>> Expose devlink reload actions stats to the user through devlink dev
>>>>>>> get command.
>>>>>>>
>>>>>>> Examples:
>>>>>>> $ devlink dev show
>>>>>>> pci/0000:82:00.0:
>>>>>>> =C2=A0=C2=A0 reload_action_stats:
>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0 driver_reinit 2
>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0 fw_activate 1
>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0 driver_reinit_no_reset 0
>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0 fw_activate_no_reset 0
>>>>>>> pci/0000:82:00.1:
>>>>>>> =C2=A0=C2=A0 reload_action_stats:
>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0 driver_reinit 1
>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0 fw_activate 1
>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0 driver_reinit_no_reset 0
>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0 fw_activate_no_reset 0
>>>>>> I would rather have something like:
>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0 stats:
>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 reload_action:
>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 driver_reinit 1
>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 fw_activate 1
>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 driver_reinit_no_re=
set 0
>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 fw_activate_no_rese=
t 0
>>>>>>
>>>>>> Then we can easily extend and add other stats in the tree.
>>>
>>> Sure, I will add it.
>> Could you please checkout the metrics patchset and figure out how to
>> merge that with your usecase?
>>
>
> I will check, I will discuss with Ido how it will fit.
>

I have discussed it with Ido, it doesn't fit to merge with metrics:

1. These counters are maintained by devlink unlike metrics which are=20
read by the driver from HW.

2. The metrics counters push string name, while here I use enum.

However, I did add another level as you suggested here for option to=20
future stats that may fit.

>>>>>> Also, I wonder if these stats could be somehow merged with Ido's=20
>>>>>> metrics
>>>>>> work:
>>>>>> https://github.com/idosch/linux/commits/submit/devlink_metric_rfc_v1
>>>>>>
>>>>>> Ido, would it make sense?
>>>>> I guess. My original idea for devlink-metric was to expose
>>>>> design-specific metrics to user space where the entity registering=20
>>>>> the
>>>>> metrics is the device driver. In this case the entity would be=20
>>>>> devlink
>>>>> itself and it would be auto-registered for each device.
>>>> Yeah, the usecase is different, but it is still stats, right.
>>>>
>>>>
>>>>>>> $ devlink dev show -jp
>>>>>>> {
>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0 "dev": {
>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "pci/0000:82:00.0"=
: {
>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 "reload_action_stats": [ {
>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "driver_reinit": 2
>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 },{
>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "fw_activate": 1
>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 },{
>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "driver_reinit_no_re=
set": 0
>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 },{
>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "fw_activate_no_rese=
t": 0
>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 } ]
>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 },
>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "pci/0000:82:00.1"=
: {
>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 "reload_action_stats": [ {
>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "driver_reinit": 1
>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 },{
>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "fw_activate": 1
>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 },{
>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "driver_reinit_no_re=
set": 0
>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 },{
>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "fw_activate_no_rese=
t": 0
>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 } ]
>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>>>>>> =C2=A0=C2=A0=C2=A0=C2=A0 }
>>>>>>> }
>>>>>>>
>>>>>> [..]
