Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BE543A6964
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 16:54:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233187AbhFNO4b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 10:56:31 -0400
Received: from mx0b-002c1b01.pphosted.com ([148.163.155.12]:17918 "EHLO
        mx0b-002c1b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233171AbhFNO42 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 10:56:28 -0400
Received: from pps.filterd (m0127843.ppops.net [127.0.0.1])
        by mx0b-002c1b01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15EEn2Do004915;
        Mon, 14 Jun 2021 07:54:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint20171006;
 bh=vCbKBpr3Z5DYFiNYxZ/R+QwG9tdeZOrprj1dQM8zuB4=;
 b=NnnbEGGHtvfJwalBjYwuAC4M1v4Tzn/tgNiCIwtOtof7pTkUe5X3ajMib7ch/EDLN59M
 zM39Te/JIpKyrOZzied4umOdF4JArkDRl8EPIbXEgEO2XkIk4zo01E2+yG01clXVwez7
 eYmrNB1CXBzWnoaXJ5llXFs9dTgxWSrhFcZOoOxJbMwG0JeGxWdlXl/E20D8Y3q6vYLB
 ma8s+eBmq3djhFJlCqtttutvBorwtk/C2XmBfw9jcaLH3fFnE5FVJdyLIB3BTJWEcXDq
 pOTdc43bu+NRyO5VivDRMnAYuBQkpUcVWfKFqP9WdCvRE25mAZdlM5GPBN/jl4wCpDM0 Zg== 
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2047.outbound.protection.outlook.com [104.47.51.47])
        by mx0b-002c1b01.pphosted.com with ESMTP id 3960u411fy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Jun 2021 07:54:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Za0sY5/1NtfVJvhgXUzNlgTfiei8idcE4M+qeoV+4bEgY6icDL2yY7sbYQWnPpMTab0tKeB2Dg6i+IHiqYQMfVIJguInuoDFnXUa82jjcsVXd8Pk7nUJCdeAfwasiwBirzie57vp5FuZVb31aryE4L0j87by0hT8Klj7/pKlqwNzP/0xx760R7RPzLsqS+rmqCRmtFDq2WwHcYt7lQt+laNTM0waANgFkMMHE3rS/eygzwTLan2Qoloi2hoXB+dR2nTDCgYaa6Q6pZpj4bqxyU/+OBvPJ0RQh1PCOYmGPNgBNpjQvszauym+wJZR+2j8srvN9UAJxi94aQ6GyIuH4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vCbKBpr3Z5DYFiNYxZ/R+QwG9tdeZOrprj1dQM8zuB4=;
 b=Ys+rTf9QXTtAJ5OYvLNZa5a7QbsMR5UmX8f6rhIcus/kWykghfbomqO1stdinBRVo+oSCIe6u910zhU4+NyQk/Ir6jX7Ioz2wCYAfBl3IFrMSAy5iREMSLq1ywjfmxbVEtqKQ2A5Iq+PfnPfetlkZF6nKdflAgLGFkxwc+RLfAW++5iiM+1BcU1UawCeO+SVMx80srDk6fgUNT2ubejIKYsILYRgZJmHdVFn5QEpJ779Qlu/6CVUTAXWtbSF+lxKoMFdpb2EpB1+djmsawqGbcASbGDZL2vtz449eC6Zhi3Mtdhwb5toA1kcY0ZspkcJ8t3DmHLMWwvoXfux7re6Ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nutanix.com;
Received: from CH0PR02MB7964.namprd02.prod.outlook.com (2603:10b6:610:105::16)
 by CH0PR02MB7900.namprd02.prod.outlook.com (2603:10b6:610:101::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.22; Mon, 14 Jun
 2021 14:54:17 +0000
Received: from CH0PR02MB7964.namprd02.prod.outlook.com
 ([fe80::f833:4420:8225:5d12]) by CH0PR02MB7964.namprd02.prod.outlook.com
 ([fe80::f833:4420:8225:5d12%7]) with mapi id 15.20.4219.025; Mon, 14 Jun 2021
 14:54:17 +0000
Subject: Re: [PATCH] net: usbnet: allow overriding of default USB interface
 naming
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrew@lunn.ch
References: <20210611152339.182710-1-jonathan.davies@nutanix.com>
 <YMRbt+or+QTlqqP9@kroah.com>
 <469dd530-ebd2-37a4-9c6a-9de86e7a38dc@nutanix.com>
 <YMckz2Yu8L3IQNX9@kroah.com>
 <a620bc87-5ee7-6132-6aa0-6b99e1052960@nutanix.com>
 <YMde1fN+qIBfCWpD@kroah.com>
From:   Jonathan Davies <jonathan.davies@nutanix.com>
Message-ID: <80b6e3ab-6b8f-abaa-9d20-859c89789add@nutanix.com>
Date:   Mon, 14 Jun 2021 15:53:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <YMde1fN+qIBfCWpD@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [92.13.244.69]
X-ClientProxiedBy: AM3PR05CA0096.eurprd05.prod.outlook.com
 (2603:10a6:207:1::22) To CH0PR02MB7964.namprd02.prod.outlook.com
 (2603:10b6:610:105::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.249] (92.13.244.69) by AM3PR05CA0096.eurprd05.prod.outlook.com (2603:10a6:207:1::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21 via Frontend Transport; Mon, 14 Jun 2021 14:54:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 199d67ac-6db8-44a2-dc81-08d92f4448bb
X-MS-TrafficTypeDiagnostic: CH0PR02MB7900:
X-Microsoft-Antispam-PRVS: <CH0PR02MB7900759664B57F5658183E39CB319@CH0PR02MB7900.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ReFLEz8y3UT/PPvdyhUa09W4naZCeZst8zn5D/R2Wt/dtb5ja8IQCT+qqDubwA87seB9qNVK3MjKlXPwYISo/yrD24wcnvKtn1Eg3I1U5ittxydLW+qZJlU5zO0rn+I4wbAc3OLyAdSGZWANsyKPEL1+g3vZ5rUARXIX+my0W2MgWYyPbwZEf1MnZ6h0YJoxcJpzuAc5UJeia4Ljh906Ig5d7XkR6KY1p5NfuXtVmQ5QIWvv1/2igVumQj1bJ4qaVdso1y3gY9V00fuJ4asIRJ4EegQhajr5YALRBNPpnIy/kqmLvKslAe5a66Q3juhDynShgsrB21e5ZOjA48Bl7sKGaddoviOYg2JkCHIlABEQAYLA6uFXZHDFwJJ0YksuBn64VZLH5Q+ykV8RbXQSWRNHPa1TLISm5Xc6ma4e53DMNyY1RpftpfuVsjKCZ3u/IQVAwcFvGqI86jGbTtJjwcMwH+/pAnqogUP5fPGNXGFpTLWwgw/pxHB5mKZZSkkdsiFhLc7BLTKl9X2KXCnPRDMy7EnUEvAmOSKNRXo5Fwirv6qWKR1s74nJmCn2RsKC2tr1hR3DgG//UYlYloGQICfx4nb93lELDGFZJH46yNlalMa8GRlM6OGqnT2r3arn/2QZD1j5UMsouaWL8AGY97LZ1iN7Nv+d3Es1YRs/M3IkJ+BRNytBPHVsLewmgX1VmFG3rSHgB/D5UWcix5BSxK7hJ7ASOiXspbD94ToYJUzgwsPN4D/1cFqZPhWo1dhPjCS9+as4g7r63sJJWmdZHNz0EJwabswcXMhjolMA63W+udKIz0Jec6Qudq3Zrm7ey3OxXV3Xdya3v9HVsG1Bv12SS8qZ8NbCsEV9JQY+M0Jg2G089bvDBVaphEesJyaw
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR02MB7964.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39860400002)(366004)(396003)(346002)(136003)(4326008)(53546011)(2906002)(16526019)(6486002)(478600001)(31686004)(186003)(8936002)(8676002)(6666004)(26005)(66946007)(16576012)(66556008)(6916009)(38100700002)(38350700002)(36756003)(956004)(52116002)(44832011)(31696002)(5660300002)(83380400001)(966005)(66476007)(2616005)(54906003)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Zm9yaDY0bFp5NHpDUUNxdzFDNHdiTmZ2aTU5Y3NvYmdnZVZJQlFYUGN4VUEv?=
 =?utf-8?B?L2I3c01uaTg3VkJCMm1rem8xTGhwRkR1NUVnU3UwWlhIeGEzMktjcE4wOEl4?=
 =?utf-8?B?dlFWTWRocGZqQlVGNnZZY0pIWUxlMTFjcmpWdXdTWFlCLzNmbi9lanRsKzVO?=
 =?utf-8?B?VmJPWUoydXZMSzdnNytiSUhTMWhpQWFQUTVPNk9NL3JCam50MzBlZ1FvWkJK?=
 =?utf-8?B?RlJQN1haV1NWTCtKblIvRWJTOTJXZ2lUeGwxSmV1OU5tMzhTMmdGWFlrcWxH?=
 =?utf-8?B?bUVZR3orcTRsdmczalRkN2Z5U2R0V2xxazB6ZW0zQkpDZTZvQVpWUm9PUjZE?=
 =?utf-8?B?eWhRN05QMmdtTXpyN0dnOEFnVllDK1BSZDcxUzZzVGhKOWtmRGt3QzZKTHhy?=
 =?utf-8?B?NlZzckJmWWhzNW1tY2VhUm1NSHZBUHVWSngvakNldlRKRUM3MlVzRGRialZ5?=
 =?utf-8?B?R1h4aDBxZzBGV3dCenRPUktzc0ZzMHgzL1FSdjEzKzhFWVpQRjAwTThHVmpM?=
 =?utf-8?B?M01SaTJ1MmpwbWt4MWVDeTRZQkZLSUxLUy9MWFJhR2VuUSttKzN2cTJkVVYw?=
 =?utf-8?B?NmlRQ3hnYlQzTWE3ejFhOWVRdDNPTXYyZ0MvcUMwMXpJQkJtY2FRKyttdm03?=
 =?utf-8?B?N3hnUWNoQmlNRmREL1pETnhwcElJdWVkZVk0MjVqMGFhQlJIZE9NZGxSL0w1?=
 =?utf-8?B?U2psTWl4d3NPb3ZJUVQ5VkdncXVEWnJRRGwwcG85dE5JZ1EwV21HN0t2U2Jr?=
 =?utf-8?B?T1RDMndNNDNlam92V292YWVRMTkzUHNGVVY5Q1IwUFJmQVUwQTBtanlWSVR0?=
 =?utf-8?B?ajNUa0llNUovVzIweGdrdTdkMEpSczZ0b25mT0VVUmVzWG8vUmthWXdRMGJu?=
 =?utf-8?B?U0dSdXBobUk1bDVCY0FqUHdtczJoeU8zY1F1RGcxeVYrbXVYZjhxaTBFS0lD?=
 =?utf-8?B?ZTI0UWRUMVUzWmFMUmdaK0hpRWE3Qm90VWYzYUIzSXQ1S2JZY2twRkRaZ0M5?=
 =?utf-8?B?Z2FDZ09qbXdCZVFRR0VhNEpGeW5PN1pLOTFrT1ZITmx4VkpnYWZFWGFpbytQ?=
 =?utf-8?B?NkExYm5MZEMyUkgxRmJyODVPQkJoTGR4V2JLNURXTlJteEtPUUlyNWloeUJv?=
 =?utf-8?B?bzA0alduOUlnamd0azYvOXkxdlBYeEc3eDlFYTZjZWJpYy9YM3FRbERpOUFq?=
 =?utf-8?B?NVlxZ2Y1YlZQaWRyeTZZVkUyeGdkVlNTNnJ5Nk11M25kM2ZGUU96UG1PZ0JQ?=
 =?utf-8?B?UlloTFNjOGpRWjFvZHkwTVJaalB0TnNBWXRIUkdjaU1VV0tKTXhnWGp6M012?=
 =?utf-8?B?OWU2Q3g0MjVOMDFNenRKRVpqTnJvSFMzS0pVWUxTSkFuTC9WS2xiQmtBeGtt?=
 =?utf-8?B?TDZsMExZTGFwUlBwSWhnMWtkc0p6cldVK0R5N2dOK3dtRjhYTXBFVEx3a2NH?=
 =?utf-8?B?Rkw5WDV4OHFKTXNMNTVnUmlSSnFBRS96Zk9NS0c4djd4aXhnWU5RM3gxWWFO?=
 =?utf-8?B?ZzlPZkdMcXhVNjRtUmlxVGNMNmlIUFpkemI5ZlpLcFJQNksrWnBMc2xRTDVx?=
 =?utf-8?B?bW1maE55UnJoMjdnbzhvYXpZRXI1Rnhta0hFSWtMd2NoME1UY0pHQnhjYnBD?=
 =?utf-8?B?M0R5TFI4TnVVcVRoWWM0aDlTV2FydDJqRWd2VHh2ZklsZVVMN3FRbE9oS09X?=
 =?utf-8?B?UlJSMjlFVGU4MFhaM0c5TUFzODQxYUcyRUVGT2dKTXdXa0UvcW1qY0xHYVJv?=
 =?utf-8?Q?ID7dK6yHlAAJ1oppINCVwFGOkxcpEbYsUV0ICNt?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 199d67ac-6db8-44a2-dc81-08d92f4448bb
X-MS-Exchange-CrossTenant-AuthSource: CH0PR02MB7964.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2021 14:54:17.5054
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: asIb/2Z7V86Ks1ayVH5R7ItONcTQTT7pDmTPtQ9ovzlaIuWbvGAfZLet+5fQu9EQZJ7RfcR63klKXGBRMTgoc7Snd7M9voqwnxpJ8opofEc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR02MB7900
X-Proofpoint-ORIG-GUID: 52pY1CDJqrcw_ecdOiFLBJyp1QsGgGOM
X-Proofpoint-GUID: 52pY1CDJqrcw_ecdOiFLBJyp1QsGgGOM
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-14_09:2021-06-14,2021-06-14 signatures=0
X-Proofpoint-Spam-Reason: safe
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/06/2021 14:51, Greg KH wrote:
> On Mon, Jun 14, 2021 at 11:58:57AM +0100, Jonathan Davies wrote:
>> On 14/06/2021 10:43, Greg KH wrote:
>>> On Mon, Jun 14, 2021 at 10:32:05AM +0100, Jonathan Davies wrote:
>>>> On 12/06/2021 08:01, Greg KH wrote:
>>>>> On Fri, Jun 11, 2021 at 03:23:39PM +0000, Jonathan Davies wrote:
>>>>>> When the predictable device naming scheme for NICs is not in use, it is
>>>>>> common for there to be udev rules to rename interfaces to names with
>>>>>> prefix "eth".
>>>>>>
>>>>>> Since the timing at which USB NICs are discovered is unpredictable, it
>>>>>> can be interfere with udev's attempt to rename another interface to
>>>>>> "eth0" if a freshly discovered USB interface is initially given the name
>>>>>> "eth0".
>>>>>>
>>>>>> Hence it is useful to be able to override the default name. A new usbnet
>>>>>> module parameter allows this to be configured.
>>>>>>
>>>>>> Signed-off-by: Jonathan Davies <jonathan.davies@nutanix.com>
>>>>>> Suggested-by: Prashanth Sreenivasa <prashanth.sreenivasa@nutanix.com>
>>>>>> ---
>>>>>>     drivers/net/usb/usbnet.c | 13 ++++++++++---
>>>>>>     1 file changed, 10 insertions(+), 3 deletions(-)
>>>>>>
>>>>>> diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
>>>>>> index ecf6284..55f6230 100644
>>>>>> --- a/drivers/net/usb/usbnet.c
>>>>>> +++ b/drivers/net/usb/usbnet.c
>>>>>> @@ -72,6 +72,13 @@ static int msg_level = -1;
>>>>>>     module_param (msg_level, int, 0);
>>>>>>     MODULE_PARM_DESC (msg_level, "Override default message level");
>>>>>> +#define DEFAULT_ETH_DEV_NAME "eth%d"
>>>>>> +
>>>>>> +static char *eth_device_name = DEFAULT_ETH_DEV_NAME;
>>>>>> +module_param(eth_device_name, charp, 0644);
>>>>>> +MODULE_PARM_DESC(eth_device_name, "Device name pattern for Ethernet devices"
>>>>>> +				  " (default: \"" DEFAULT_ETH_DEV_NAME "\")");
>>>>>
>>>>> This is not the 1990's, please do not add new module parameters as they
>>>>> are on a global driver level, and not on a device level.
>>>>
>>>> The initial name is set at probe-time, so the device doesn't exist yet. So I
>>>> felt like it was a choice between either changing the hard-coded "eth%d"
>>>> string or providing a driver-level module parameter. Is there a better
>>>> alternative?
>>>
>>> This has always been this way, why is this suddenly an issue?  What
>>> changed to cause the way we can name these devices after they have been
>>> found like we have been for the past decade+?
>>
>> The thing that changed for me was that system-udevd does *not* have the
>> backoff and retry logic that traditional versions of udev had.
>>
>> Compare implementations of rename_netif in
>> https://git.kernel.org/pub/scm/linux/hotplug/udev.git/tree/src/udev-event.c 
>> (traditional udev, which handles collisions) and
>> https://github.com/systemd/systemd/blob/main/src/udev/udev-event.c 
>> (systemd-udevd, which does not handle collisions).
> 
> Then submit a change to add the logic back.  This looks like a userspace
> tool breaking existing setups, so please take it up with the developers
> of that tool.  The kernel has not changed or "broken" anything here.

(I didn't mean to imply that the kernel was to blame, merely that a 
kernel change could help make things tidier.)

>> I think this logic was removed under the assumption that users of
>> systemd-udevd would also use the predictable device naming scheme, meaning
>> renames are guaranteed to not collide with devices being probed.
> 
> Why are you not using the predictable device naming scheme?  If you have
> multiple network devices in the system, it seems like that is a good
> idea to follow as the developers added that for a reason.

Sadly in my case this isn't possible for reasons beyond my control. I'd 
like to move things in that direction but in the meantime thought this 
workaround could have been helpful for others who find themselves in the 
same position as me.

Thanks for all the input.

Jonathan
