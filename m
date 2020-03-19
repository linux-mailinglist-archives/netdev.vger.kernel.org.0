Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43B8818A98D
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 01:05:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727240AbgCSAFy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 20:05:54 -0400
Received: from mga07.intel.com ([134.134.136.100]:26922 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726596AbgCSAFy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Mar 2020 20:05:54 -0400
IronPort-SDR: FVzNTzO8AMw6tjWe8G5xRT8BBTucgy+WeDq/ZtI2l3OKVIcjoZUVOQOTQHfNWEkSMQbR8Sgkn3
 Rw7fT1A6by+g==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2020 17:05:53 -0700
IronPort-SDR: DbORs5Kqq9Q8cahuXpxZa81WGSGNIavEMuPtrhBmtZQraWPa7/o2nN9bS7BZXC7J8+s4bZJbrz
 MX3DGqHqwaQA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,569,1574150400"; 
   d="scan'208";a="418144914"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.254.100.124]) ([10.254.100.124])
  by orsmga005.jf.intel.com with ESMTP; 18 Mar 2020 17:05:52 -0700
Subject: Re: [PATCH net-next 01/11] devlink: add macro for "drv.spec"
To:     Jakub Kicinski <kuba@kernel.org>,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>, Jiri Pirko <jiri@mellanox.com>,
        Michael Chan <michael.chan@broadcom.com>
References: <1584458082-29207-1-git-send-email-vasundhara-v.volam@broadcom.com>
 <1584458082-29207-2-git-send-email-vasundhara-v.volam@broadcom.com>
 <20200317104046.1702b601@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAACQVJqSMsMNChPssuw850HVYXYJAYx=HcwYXGrG3FsMgVQf1g@mail.gmail.com>
 <20200318130441.42ac70b5@kicinski-fedora-PC1C0HJN>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <cc554929-9dbb-998e-aa83-0e5ccb6c3867@intel.com>
Date:   Wed, 18 Mar 2020 17:05:52 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200318130441.42ac70b5@kicinski-fedora-PC1C0HJN>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/18/2020 1:04 PM, Jakub Kicinski wrote:
> On Wed, 18 Mar 2020 09:51:29 +0530 Vasundhara Volam wrote:
>> On Tue, Mar 17, 2020 at 11:10 PM Jakub Kicinski <kuba@kernel.org> wrote:
>>> On Tue, 17 Mar 2020 20:44:38 +0530 Vasundhara Volam wrote:  
>>>> Add definition and documentation for the new generic info "drv.spec".
>>>> "drv.spec" specifies the version of the software interfaces between
>>>> driver and firmware.
>>>>
>>>> Cc: Jiri Pirko <jiri@mellanox.com>
>>>> Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
>>>> Signed-off-by: Michael Chan <michael.chan@broadcom.com>
>>>> ---
>>>>  Documentation/networking/devlink/devlink-info.rst | 6 ++++++
>>>>  include/net/devlink.h                             | 3 +++
>>>>  2 files changed, 9 insertions(+)
>>>>
>>>> diff --git a/Documentation/networking/devlink/devlink-info.rst b/Documentation/networking/devlink/devlink-info.rst
>>>> index 70981dd..0765a48 100644
>>>> --- a/Documentation/networking/devlink/devlink-info.rst
>>>> +++ b/Documentation/networking/devlink/devlink-info.rst
>>>> @@ -59,6 +59,12 @@ board.manufacture
>>>>
>>>>  An identifier of the company or the facility which produced the part.
>>>>
>>>> +drv.spec
>>>> +--------
>>>> +
>>>> +Firmware interface specification version of the software interfaces between  
>>>
>>> Why did you call this "drv" if the first sentence of the description
>>> says it's a property of the firmware?  
>>
>> Since it is a version of interface between driver and firmware. Both
>> driver and firmware
>> can support different versions. I intend to display the version
>> implemented in the driver.
> 
> We're just getting rid of driver versions, with significant effort,
> so starting to extend devlink info with driver stuff seems risky.
> How is driver information part of device info in the first place?
> 
> As you said good driver and firmware will be modular and backward
> compatible, so what's the meaning of the API version?
> 
> This field is meaningless.
> 

I think I agree with Jakub here. I assume, if it's anything like what
the ice driver does, the firmware has an API field used to communicate
to the driver what it can support. This can be used by the driver to
decide if it can load.

For example, if the major API number increases, the ice driver then
assumes that it must be a very old driver which will not work at all
with that firmware. (This is mostly kept as a safety hatch in case no
other alternative can be determined).

The driver can then use this API number as a way to decide if certain
features can be enabled or not.

I suppose printing the driver's "expected" API number makes sense, but I
think the stronger approach is to make the driver able to interoperate
with any previous API version. Newer minor API numbers only mean that
new features exist which the driver might not be aware of. (for example,
if you're running an old driver).

The only reason to care would be in the case where a major breaking
increase occurred. This really shouldn't be necessary, especially if the
API between firmware and driver is designed well, but could be useful as
a last ditch exit in case of some major breaking change that must be done.

Even then, your driver *should* be able to tell and then behave
differently based on this and do the old v1 or v<whatever> that it knows
the firmware CAN support.

In practice, I'm not sure how well this is actually done, as there is
always some maintenance burden for carrying multiple variations of
support, and in the case of a really poorly designed API.. it can be
quite a nightmare.

Thanks,
Jake
