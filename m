Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A03E93A5F2B
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 11:32:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232732AbhFNJed (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 05:34:33 -0400
Received: from mx0b-002c1b01.pphosted.com ([148.163.155.12]:54444 "EHLO
        mx0b-002c1b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232630AbhFNJeb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 05:34:31 -0400
Received: from pps.filterd (m0127842.ppops.net [127.0.0.1])
        by mx0b-002c1b01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15E9P2tP025184;
        Mon, 14 Jun 2021 02:32:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint20171006;
 bh=Fv6GXCaxOeGsnSHBU5tXC/61x5fr5pUOpe7xtayhdcU=;
 b=bzltjwhA9w77HpH6CafR0de4NxtzhLw6xHHEcxRKqULdrpkB0Dn85lX6fiCr1hVmHgKd
 ttml5OWGdFRqxdwR2A4koCa4/nOIzT91kN8wJgobVUVMLQrqpE+DNq7r5CbvxcX97O6s
 WZzkm/p0B90i+XwdYNcA/DAZdD8IHiviCBHMjD4mYO+B2ui85ti+KG8IMZFmtvdM6nws
 yHVSAq2/S21qIpqETQXjILg0wNGB3D4XHSTIGHLh28fFxK2k5GMRMTIBrO6x9r3io2lV
 +dl+2tjey1LQvVlQOWndKyy+iivHRx+EOSlu6MvdDkhMUzEMD92h8zL2X20+ksAHoEKy qQ== 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2103.outbound.protection.outlook.com [104.47.70.103])
        by mx0b-002c1b01.pphosted.com with ESMTP id 395p44s95p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Jun 2021 02:32:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CwZzOmPcYQq3/U84Kh3SFLr6EExzXxZq+rPj6oJVp1RNpkLPmCbC4VhG/OxAzS8Ng6StF5WENzNlbRUvcsY0WFkpRukYqsHCxbxDRCQ2/vM1BSr9h/6f36Xq7z+hIPBDxm4MiuJaV13a4/Eg7zLRveoXLpIM/2Vc058jEyCirh2l/Z8xktAKchw//HvpUXP4nDvs/LK3FLIPz7rsgEIqXkmZyMj7dU2fxw8Elr8ne//OisvswJReO+NkzlRs7WHBj5F0G5J8DMGEzCGQhPIG0GWL+Zid66U9gy/WwDqzkt4z3JlUObl6Kf8EQHzMfuwWCoMm3c4nEfYLEd/Cl+EfuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fv6GXCaxOeGsnSHBU5tXC/61x5fr5pUOpe7xtayhdcU=;
 b=l1tpV9PYL7EvzddzFaS9Zrs42y5jtklbf+Yen8hZD/CYSGPOsAhzUgEN/YPsd/DrMKVcM23bAKpjx56/ARoevjrEnqkF/x2uEgseYP9i48jjHH1RlWSq9YVB2+Z/AwcWdT04jF4C0/Pz7QCrNebedcy/6mm9GGhhfTDPedOigyPvR6El7A7nrFnbOxSi+PhgHcONlBRPwT0Xtfy/y1enyHXsd5fKme7/sahRYIN5L4SpgE+RaykKC8oAGd3+XK5Lomc4xncgQ3F0pxtbA+NE7hV8Xruh7grGH//Y9nk911jM2cnmq/ox7ZiAwRIKlwPLpDQciz8D8rr31RMt9MbP5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nutanix.com;
Received: from CH0PR02MB7964.namprd02.prod.outlook.com (2603:10b6:610:105::16)
 by CH2PR02MB6998.namprd02.prod.outlook.com (2603:10b6:610:88::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.22; Mon, 14 Jun
 2021 09:32:18 +0000
Received: from CH0PR02MB7964.namprd02.prod.outlook.com
 ([fe80::f833:4420:8225:5d12]) by CH0PR02MB7964.namprd02.prod.outlook.com
 ([fe80::f833:4420:8225:5d12%7]) with mapi id 15.20.4219.025; Mon, 14 Jun 2021
 09:32:18 +0000
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
From:   Jonathan Davies <jonathan.davies@nutanix.com>
Message-ID: <469dd530-ebd2-37a4-9c6a-9de86e7a38dc@nutanix.com>
Date:   Mon, 14 Jun 2021 10:32:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <YMRbt+or+QTlqqP9@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [92.13.244.69]
X-ClientProxiedBy: AM3PR05CA0086.eurprd05.prod.outlook.com
 (2603:10a6:207:1::12) To CH0PR02MB7964.namprd02.prod.outlook.com
 (2603:10b6:610:105::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.249] (92.13.244.69) by AM3PR05CA0086.eurprd05.prod.outlook.com (2603:10a6:207:1::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.22 via Frontend Transport; Mon, 14 Jun 2021 09:32:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 38a0c23e-79ea-4497-894a-08d92f174d73
X-MS-TrafficTypeDiagnostic: CH2PR02MB6998:
X-Microsoft-Antispam-PRVS: <CH2PR02MB6998D8B015DFA90DC58A0989CB319@CH2PR02MB6998.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: f0mbwj3Dir31GKjW1oe12CWKVAShUYr7BFdZCMBaZfMdU0FKC8Uv1vggs797rpqM3a0qNmJqgCuehLSL3WSvIfHjjF4bZeaLLL5KcK4Ph6en9dOdPMDjSAB27s9ueZ/hpytqf//tiBqfLWMQ1mI+St3ImGjK/EamQbpAuP9YUz2sy9BmNpyy8qZUMkMvmO1iguT1YxD7a2OgxvKRtKIdpFilZAA7cRfNpBKRzL/7u/2vX9Y6t8kajUtKi7AHhhtP97XHmNf5jBLpVcpx+bCYtPQQbLF0epJESnXNgoOoYtXuxSWDQlBRCZpJRpSsraq39sGCFIP0o5WxepjCZnp5gnCyV9ilMaQn/txpn4JE97+kq54BjPaIzWVnQAO/GIHo4niVMd3crnCxZp1gYj3VBICYOXLT9vr4kG6gaca0br4RmV6TX/OE1Go5rIbHhOpxFNWUvAJj96+c7npDzbqFhAHXGgUXUaUTqN6u51JAbuFs4xru62i36cu4UNc+KNwhGC08M35e9Nos9pIGloR7H76k6Pyiw+B0Wre056B9zadePH3i0dLj4joZd2FJCuB78GU5CYtZjrX3Z1DLrzEOy6uh1cG+EXJPcg1eINlPCwn2gBMuBUJSXjxhlwU0vN2vDBHJ0qCy3ew4zZ54wYwJDUKxTshhUzrmI+S8+/TcAwFwelAchUuMNHnlZ5AIQuEuCHJAZAipPL5gihQ0wYjpm0zn93VAl2wrmj6c2soz1vE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR02MB7964.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(39860400002)(346002)(376002)(136003)(8936002)(8676002)(53546011)(2906002)(52116002)(66556008)(44832011)(31696002)(66476007)(6486002)(6666004)(66946007)(4326008)(26005)(54906003)(6916009)(31686004)(5660300002)(16526019)(478600001)(316002)(16576012)(186003)(83380400001)(2616005)(36756003)(956004)(38100700002)(38350700002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bnVMVUE4VG9OQzc5NVpSSlZPQnpGZHRkSHpJcHJ4YlpCMUh5a3g5N0t3VWxu?=
 =?utf-8?B?bGtYNkxwcW4wbUJocFN6ejFNWUZYVGdBQnpwanJCODNmMWVsTXB0M0pMTEVC?=
 =?utf-8?B?ak12S3owblQvOWVCY09QNUNhNTViajM4L1FORkk1MHdtS2kvdEFZNG16dkt6?=
 =?utf-8?B?VVo5VytyY24rZnZpb0FCOGo3YjlKYUZHTTFCZS9hVEVaTTFyZVVmbEZBbU9v?=
 =?utf-8?B?YkorYlZId3FKcURFZEl2aU16MkpOUVpmUWVHWVRMaUVYa29sK0ZITjBCdjJO?=
 =?utf-8?B?M20zM1h1TFRwU1Zad1ZBUEdMZFhDMFpmQ0hvekRkVmZlMitCd09zTXgvU28x?=
 =?utf-8?B?QWQ1bDUvRUNOOGw3VS9HYkpXWDBJVDZrNHVNVkUzdlJJdU9UTlUxSWNsKy8r?=
 =?utf-8?B?TXMreEFMM2xzODNmZ2JSRDRadVArSjRUTzdnSTJ1OWh2enVXMHNHTEVrS08v?=
 =?utf-8?B?N3ZiNFJRYmhyWEN2U04rcUdhU081bGpWRnhNeFZZdk5JaHlCb3dUT29XckRw?=
 =?utf-8?B?ckVvdVIwaUVUNVU2OGllZlE2T3h1N0xUMnNKOWlRY3NSdU8vbHBpWEdDbXd4?=
 =?utf-8?B?TVk3NGNCUGdrZ2VGb2ZHaVBwSnc4VW9KQXBpZnRFcGdRVmNCcG1hK3Y3Q2Fl?=
 =?utf-8?B?VktwMmtvNHRtRnVTTUxxRHFyNXoxTHNrSXdIN3pOQi9FUTlxcit3M1A4NmQz?=
 =?utf-8?B?Z0JVS2cranVqNnBaWDlMM3J2enV6YWpvVEtLeElVcVNpWlc5S0s3L2FhMC9v?=
 =?utf-8?B?SHJWTDhkMzM2eTdFb21UV0h4MDhadUVBVERpVEdCVUdqcVlLU3RBdFNNUHdp?=
 =?utf-8?B?T21VKzkxQ2FXZWdodzNlZjhsMFJjTjQ4aTNEQm5hb0RXNmdnRTA3TFlwMTFz?=
 =?utf-8?B?eGRWbmNlRHJxbVI3d2ZGYUhBQ3hhclh3bG1xOXBjdm82eHVBLzRMUGFRdHJU?=
 =?utf-8?B?cWlzQnNsamo5bEVWaUNUT2Z6bkN4U2NRWHBXdWVOQXM3bzVNY21TNGVaOUM3?=
 =?utf-8?B?Tk1aTGhXaXRXUmR1UHk3M24zcE1YdjVGS2ZwT3RjQ2F1bHNXYnhKMlovcm1J?=
 =?utf-8?B?MDJTL1M0V28vMlFkNXJvVWlsOE1JU0FWQWQrZ1o5UGtHeUtQck1jL0xiQUEx?=
 =?utf-8?B?aFZwc3YxeXYwdHdEK2hMb1orMUN4eTRmd1JTN1ZxTUlrekVXS2VkRjhmb0Q2?=
 =?utf-8?B?LzRHRTJBeTQyV0RxNzNzbDZ3eG5tM0dNZGtFaTBXLzFmbkR0UG1RSTBURDNv?=
 =?utf-8?B?Qkt5S1cvTktvT2M1VVZRVG5OLzlRR0JpRlJjMDM0N05lQTRoejIrYmZWeGtD?=
 =?utf-8?B?SWViNGROVG5qc1BiVTQ0bHJZSnl4djdpSXJITWVhSlpReVNxOTRHVjBLV1ll?=
 =?utf-8?B?bEpncVRiWkN5NU40ZUxneHQ0cDRmN09zWll6YUxYZEluR1RMd3VqNjBTcUQ4?=
 =?utf-8?B?MXZYeW1SUjV1STJ4N0ErVXl2clpyeTFTZ3I2Q2hPb1NoZTdFekFsU3h1UmVS?=
 =?utf-8?B?NGIxNnBtMUVuSTBBR0dCVlR6NTFnR3h5emdlcTVUZTAzV3hRTGVwbDRJUFAv?=
 =?utf-8?B?SFRnY2NVUnl1b2xFMVM4ODdDZVVobFl5T01VaW5XRmFUQ1d4YTRYeit0QVND?=
 =?utf-8?B?WHVTYXBXTnVaUTcxell3bFpwZEhNdEJGc2NmWlI1cmk4VVN2RFVuSHRhSUZn?=
 =?utf-8?B?OTVuTEdEcEJTcFRvb3REK3cwQUV4QTVkWUdEVFFXVHdpeENkSTltRFlPM3I4?=
 =?utf-8?Q?nq6QMBjrC/5TFlwN/4WuvDlGS8yBVWzV/6Rypi1?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38a0c23e-79ea-4497-894a-08d92f174d73
X-MS-Exchange-CrossTenant-AuthSource: CH0PR02MB7964.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2021 09:32:18.0841
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P27goWvI+cW2bNfqerCqkxSb72VCdyo7hvFYwf+Z4oevlbHhmrEJ/dKbzGCxL+8zwxbz73QAxtzjMhMc1QnDQxZKijMSCbhMvaCt5ThlFVg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR02MB6998
X-Proofpoint-ORIG-GUID: hgRpvmp3trxcYpq5Qi_tHhStjwVquH0h
X-Proofpoint-GUID: hgRpvmp3trxcYpq5Qi_tHhStjwVquH0h
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-14_04:2021-06-11,2021-06-14 signatures=0
X-Proofpoint-Spam-Reason: safe
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/06/2021 08:01, Greg KH wrote:
> On Fri, Jun 11, 2021 at 03:23:39PM +0000, Jonathan Davies wrote:
>> When the predictable device naming scheme for NICs is not in use, it is
>> common for there to be udev rules to rename interfaces to names with
>> prefix "eth".
>>
>> Since the timing at which USB NICs are discovered is unpredictable, it
>> can be interfere with udev's attempt to rename another interface to
>> "eth0" if a freshly discovered USB interface is initially given the name
>> "eth0".
>>
>> Hence it is useful to be able to override the default name. A new usbnet
>> module parameter allows this to be configured.
>>
>> Signed-off-by: Jonathan Davies <jonathan.davies@nutanix.com>
>> Suggested-by: Prashanth Sreenivasa <prashanth.sreenivasa@nutanix.com>
>> ---
>>   drivers/net/usb/usbnet.c | 13 ++++++++++---
>>   1 file changed, 10 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
>> index ecf6284..55f6230 100644
>> --- a/drivers/net/usb/usbnet.c
>> +++ b/drivers/net/usb/usbnet.c
>> @@ -72,6 +72,13 @@ static int msg_level = -1;
>>   module_param (msg_level, int, 0);
>>   MODULE_PARM_DESC (msg_level, "Override default message level");
>>   
>> +#define DEFAULT_ETH_DEV_NAME "eth%d"
>> +
>> +static char *eth_device_name = DEFAULT_ETH_DEV_NAME;
>> +module_param(eth_device_name, charp, 0644);
>> +MODULE_PARM_DESC(eth_device_name, "Device name pattern for Ethernet devices"
>> +				  " (default: \"" DEFAULT_ETH_DEV_NAME "\")");
> 
> This is not the 1990's, please do not add new module parameters as they
> are on a global driver level, and not on a device level.

The initial name is set at probe-time, so the device doesn't exist yet. 
So I felt like it was a choice between either changing the hard-coded 
"eth%d" string or providing a driver-level module parameter. Is there a 
better alternative?

> Also changing the way usb network devices are named is up to userspace,
> the kernel should not be involved in this.  What is wrong with just
> renaming it in userspace as you want to today?

Yes, renaming devices is the responsibility of userspace. Normally udev 
will rename a device shortly after it is probed. But there's a window 
during which it has the name the kernel initially assigns. If there's 
other renaming activity happening during that window there's a chance of 
collisions.

Userspace solutions include:
  1. udev backing off and retrying in the event of a collision; or
  2. avoiding ever renaming a device to a name in the "eth%d" namespace.

Solution 1 is ugly and slow. It's much neater to avoid the collisions in 
the first place where possible.

Solution 2 arises naturally from use of the predictable device naming 
scheme. But when userspace is not using that, solution 2 may not apply.

Yes, the problem is a result of userspace decisions, but that doesn't 
mean the kernel can't help make things easier.

Thanks,
Jonathan
