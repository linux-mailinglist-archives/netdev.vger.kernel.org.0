Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEE2D188D38
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 19:33:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726682AbgCQSdO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 14:33:14 -0400
Received: from mga01.intel.com ([192.55.52.88]:8785 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726498AbgCQSdO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Mar 2020 14:33:14 -0400
IronPort-SDR: LqReU1GgIpQCYbIVSjYRkIOsvhzwl18AKMp1zplaPRLGyjL8yd3mXRYmi4wfuiGo3EZ6PJfIyK
 V/Nx4+uUqd5g==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2020 11:33:13 -0700
IronPort-SDR: wmWpX+UmcI4jn/AoZwpavXC/9jX6i9sHCn9USTeL3rMSoQG8mYoA/dTO251fW1mQDq3j3LXxih
 rBc3/wu5Jygg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,565,1574150400"; 
   d="scan'208";a="445585761"
Received: from sleader-mobl.ger.corp.intel.com (HELO [10.251.162.41]) ([10.251.162.41])
  by fmsmga006.fm.intel.com with ESMTP; 17 Mar 2020 11:33:10 -0700
Subject: Re: [PATCH net-next 01/11] devlink: add macro for "drv.spec"
To:     Jakub Kicinski <kuba@kernel.org>,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        Jiri Pirko <jiri@mellanox.com>,
        Michael Chan <michael.chan@broadcom.com>
References: <1584458082-29207-1-git-send-email-vasundhara-v.volam@broadcom.com>
 <1584458082-29207-2-git-send-email-vasundhara-v.volam@broadcom.com>
 <20200317104046.1702b601@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <db9eb36d-ac18-7903-d170-e0a6aeb9dd04@intel.com>
Date:   Tue, 17 Mar 2020 11:33:08 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200317104046.1702b601@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/17/2020 10:40 AM, Jakub Kicinski wrote:
> On Tue, 17 Mar 2020 20:44:38 +0530 Vasundhara Volam wrote:
>> Add definition and documentation for the new generic info "drv.spec".
>> "drv.spec" specifies the version of the software interfaces between
>> driver and firmware.
>>
>> Cc: Jiri Pirko <jiri@mellanox.com>
>> Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
>> Signed-off-by: Michael Chan <michael.chan@broadcom.com>
>> ---
>>  Documentation/networking/devlink/devlink-info.rst | 6 ++++++
>>  include/net/devlink.h                             | 3 +++
>>  2 files changed, 9 insertions(+)
>>
>> diff --git a/Documentation/networking/devlink/devlink-info.rst b/Documentation/networking/devlink/devlink-info.rst
>> index 70981dd..0765a48 100644
>> --- a/Documentation/networking/devlink/devlink-info.rst
>> +++ b/Documentation/networking/devlink/devlink-info.rst
>> @@ -59,6 +59,12 @@ board.manufacture
>>  
>>  An identifier of the company or the facility which produced the part.
>>  
>> +drv.spec
>> +--------
>> +
>> +Firmware interface specification version of the software interfaces between
> 
> Why did you call this "drv" if the first sentence of the description
> says it's a property of the firmware?
> 
> Upcoming Intel patches call this "fw.mgmt.api". Please use that name,
> it makes far more sense.
> 

Yep, I think this is equivalent to "fw.mgmt.api" as well.

If we want to make this a standard name, I'm fine with that, and we can
update the ice driver to use the macro.

Thanks,
Jake

>> +driver and firmware. This tag displays spec version implemented by driver.
>> +
>>  fw
>>  --
>>  
>> diff --git a/include/net/devlink.h b/include/net/devlink.h
>> index c9ca86b..9c4d889 100644
>> --- a/include/net/devlink.h
>> +++ b/include/net/devlink.h
>> @@ -476,6 +476,9 @@ enum devlink_param_generic_id {
>>  /* Revision of asic design */
>>  #define DEVLINK_INFO_VERSION_GENERIC_ASIC_REV	"asic.rev"
>>  
>> +/* FW interface specification version implemented by driver */
>> +#define DEVLINK_INFO_VERSION_GENERIC_DRV_SPEC	"drv.spec"
>> +
>>  /* Overall FW version */
>>  #define DEVLINK_INFO_VERSION_GENERIC_FW		"fw"
>>  /* Control processor FW version */
> 
