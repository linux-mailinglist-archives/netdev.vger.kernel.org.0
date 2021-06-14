Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F9663A62B3
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 13:01:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232952AbhFNLDh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 07:03:37 -0400
Received: from mx0a-002c1b01.pphosted.com ([148.163.151.68]:36246 "EHLO
        mx0a-002c1b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234320AbhFNLB2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 07:01:28 -0400
Received: from pps.filterd (m0127838.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15EArsSo013305;
        Mon, 14 Jun 2021 03:59:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint20171006;
 bh=BySWnAKgBpZDnsfeIxG4g3bAa5feqw3mxxNkty20E6I=;
 b=ELNa+zBDrOlqFYhdMKv4nLFxf4N8dvUdtSb7IjnmZvdancXrWv5tlgB0gnMXjp40Zaf3
 02eqOkJReGxyCQv1sYKXfYm0viKZl+nwqqIRCdmwYRIqcXKwfNIbGfsw1XpfFx9xiMZp
 1YPPNeN4G6T++9rXiZ+1kHvwPP/gYxnrxcFhkzv8ai/zwXv9PDivvgktZWjyNWjsR79d
 ZaasS7Il9J2Ek/qglb15lw5lRU7nm0M2AlnrME6KtKZwu5fGNKQaQ+t42JgoaY5hWe8j
 jLrDCNoKVyTsd+16BTQWda68H3s8C63fbbqf2hPcCPs5/t9gDmAayvq52wNKIozOZ764 gA== 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2176.outbound.protection.outlook.com [104.47.57.176])
        by mx0a-002c1b01.pphosted.com with ESMTP id 3960dxgm9a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Jun 2021 03:59:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A3AjhGbAckshGvUAdkaLRFgb3RXjHPr5ZHfdfe031ucH9zkUGEf0R+FOLKSgzAIPRS8QVQy4Y0O5A31n1QDDxuq+g8sYAfzSqtQbyL/aJsj2Y8breGi2MDuz8f77/SrrXWwI1pThH1RRlSmCa6vEscEpMXFsgUxWubh6qddjlRDtdyJNuHzQrnFE4QEi5JB3MJKVoy8eI/AWxzQR399Su+qDcfWl1bb2qgS9819gr5Uj/dHlIP7K1Xesk2Qp5SbvLoyzjmGDfKdIy01e7ugyeSFcIuKOUS0hodkZEeY/0874xdA3vnWr5Q2GStR78bT9EyIIfn2ZYtMAhtx2JR9Tyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BySWnAKgBpZDnsfeIxG4g3bAa5feqw3mxxNkty20E6I=;
 b=F8wOLqH2JqSWP8X0y5hQSlu22BoS3oULDvnCI70GtSLIKWcQl0C6Zdzko+CjtzGqKUoyBYcpHGyQE+Xy8aMKKepuBBQIr7ZsaTE9EGzfbQjn5l8obUS9r1U9A1EOs/dNu60xTtGhazonyJMS/wgYgPEqtBhIZU+E2NNhJWY67W98N/kCevFF4xkg1Uz1gatOOIu9KuRY9KyxC9egZhI+9qyaFDz/Rply+n12vLSm3ppVzTGMXjZv/yCpAKxkENRw81Io954b+gSIpqC23dP1LCQo0CaKDectBvfMXs36cEtwNiFs6IOeZhoFoqaCYY3BLSxc1YD5W/I+IVZEQcubJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nutanix.com;
Received: from CH0PR02MB7964.namprd02.prod.outlook.com (2603:10b6:610:105::16)
 by CH2PR02MB7045.namprd02.prod.outlook.com (2603:10b6:610:8b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.22; Mon, 14 Jun
 2021 10:59:11 +0000
Received: from CH0PR02MB7964.namprd02.prod.outlook.com
 ([fe80::f833:4420:8225:5d12]) by CH0PR02MB7964.namprd02.prod.outlook.com
 ([fe80::f833:4420:8225:5d12%7]) with mapi id 15.20.4219.025; Mon, 14 Jun 2021
 10:59:11 +0000
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
From:   Jonathan Davies <jonathan.davies@nutanix.com>
Message-ID: <a620bc87-5ee7-6132-6aa0-6b99e1052960@nutanix.com>
Date:   Mon, 14 Jun 2021 11:58:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <YMckz2Yu8L3IQNX9@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [92.13.244.69]
X-ClientProxiedBy: AM0PR10CA0115.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:e6::32) To CH0PR02MB7964.namprd02.prod.outlook.com
 (2603:10b6:610:105::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.249] (92.13.244.69) by AM0PR10CA0115.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:e6::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21 via Frontend Transport; Mon, 14 Jun 2021 10:59:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 228c1b85-248f-4503-5937-08d92f2370d5
X-MS-TrafficTypeDiagnostic: CH2PR02MB7045:
X-Microsoft-Antispam-PRVS: <CH2PR02MB7045BD01842EB107579ECC3FCB319@CH2PR02MB7045.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JgaGz3sj2QQCHP8kUxTpTD8IfKa/DWTGA5oOpER42h8J1o/Nu2M7IvfyTKtXMgNIRB8L69h3ltt+3Qp1VIvhXLGzBpMcKb1aLv+D0HBomN6GOb8xcyWqklJWMdrOQNKufcWtWjexeYWu+sEo6DVc5tvFqBBJVBAzcPB9vsKSnAPi0uVXmH6+fhi9qenrctNZrP/QKkoe9xqG4+2556v8ivP3TdNL7Svn6bvxqmuhXBxQ9HwXE3++DEh5OWNsNyrWdtWY5IkIoek5RnznjRqlrLTNa9ia+mScKAWRo8lQfJ9AHAY7v5NXp7clsvsqJusO3dOGxnkSzo4f/2x5yva3i3aOCYAAjVYDTezjEAu/1GV6O1PFmRHIBb4foWpTB7nUA9Fof5iZWlOWUeY1EBZN9d86Glzt0ACxQvZ7sEm/49h1Aj8ERGCoBsMTD3pnIeEO7J4/6FoOG379jrVJiAqc55K02N1hdOD0NBGDO1HduEYXo3sZNQBONR7UgWbLAVPQi7sRhJNS7LLSHdlwefEyZt/bP9A5wxA/DjJvw00bADY2F3GJRiKdhCgRqlaIDoII8H6NB4aDvwFUBHmm4xsqfCJdCbC97UgYXKbThz/ZZRdg0ta6hbPfD/z0mYXdY/qi+QGsI9rdj2p4EfYa/+kRy11Y4WQfon0IqQ3SSKtcrl+N7up8N70z6UYpIvIo5VDgsb3H/v44B9BbIXh6CWqQ+7kuT+Dlbmf1loMAmpfhMc7wLD8gf190ZccDvJ60Rvt6dari9IdcYTSke/GIjZTHcgzvfE95h5hD8/fkoR0F3yySPYVgLo/QRKgW+dD21AuO+4hiTWRbZ9YL2pMzHZxFvtABPRFmpO72K5w2xI9+hikW8rlErrmXDjIRi8Thtq91
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR02MB7964.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(346002)(376002)(396003)(366004)(8676002)(53546011)(38100700002)(52116002)(66476007)(66556008)(54906003)(8936002)(38350700002)(6666004)(66946007)(44832011)(31696002)(5660300002)(4326008)(966005)(2906002)(316002)(26005)(6486002)(16576012)(16526019)(2616005)(956004)(6916009)(31686004)(83380400001)(186003)(36756003)(478600001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SUNaM1hvOURQanY1TVBNRkExak9MVC9KK3BWc0NFdXhtbElVR21EMlVrNTJQ?=
 =?utf-8?B?dlUwU2VkVHNwZDRvbktCaFFZYTU3SFcybHVSMDVZeDdrMzBtdVZmektvUkV3?=
 =?utf-8?B?RjhvZ3BUL09MS01JNVBybGFEL3VTMWdFUWxKTmwvTUsxdDFjNUFSK0VTRGdh?=
 =?utf-8?B?NHZmNVF1dlliWVRwV2tQZmFkTVlMYktLV2s3bEpvNXdSZitZdW9MN0tkSHJ0?=
 =?utf-8?B?WFRpZnhyZnFWcEVxMHRmeUZ3ZURGS3BrVVdhdlpNLzhMc2M5S3ZhSkI0VmNJ?=
 =?utf-8?B?UGQ3U3g5c0JLNDd3eUFOQmdOR2ZBSXREaGdkRzBJYXY2Q3RyVHRHYTQvdUtx?=
 =?utf-8?B?TDlRYjRxZWlKb0dwL3Q4cEd5eEdwOEdlUHlZZHhsNksva0JSMzVRREEwTkhx?=
 =?utf-8?B?RE9kWmZGdldpZlVscW1Ic2hWWlZDRU03ZHZ6RWZPQm12UExyUHBJZVZBSFRD?=
 =?utf-8?B?bnBVWS93Z2E0OU5KTDZndzhjanQ1UC9pMFJad3FrWXkxckNGdUY3dHlRWjJJ?=
 =?utf-8?B?akVJQU1Qa0tub3JuaStqUGpGNzlhNWp6UGRyNnBQUEI4bVZHSXZyRXhWQUhP?=
 =?utf-8?B?V1J1SFBZa2JLVVcva2wvT0VhbHVWbmRwWG1pMklqM2MxcGFpaHhVUXJPTFRR?=
 =?utf-8?B?SFIzblBmcTBrWEM5TlJlK2Mzd0RjUHcvei9sVkdlSTlhWlJKc1MzbDRSSTJW?=
 =?utf-8?B?TGRaUi9LUG92aHJrc281V2FpWjZXNEFXTFE5alhYSEF2UVRDWG9ySVU3V01s?=
 =?utf-8?B?OWNESlNoUS8zWHpoenc3Z1djZ1hwOXJnWEF4bWJxWFJkU2FvR25tdWd1WGh4?=
 =?utf-8?B?VmRwNmp4cCtIMGZoT1BDK1l2emYrSEpZTURod1BLNFdHKyt5YzZpNW81YXFF?=
 =?utf-8?B?L0dNWmNGRFNQQlZBclJXa1IyQTVoeFp2T1JVaUVDUnNTVDRScjZNN3pYOEl4?=
 =?utf-8?B?RmhrOEUxeFBaTFVwNkdCVjJKblY0bWdWVWlmNUUyczFaNnBsN1lLNWhIRlpX?=
 =?utf-8?B?MEtqUVRsQ0Z4YTJnOGpuWUd3RGk2NzVJTE40eVBOS2dpenZCZ3gwcE83SnFq?=
 =?utf-8?B?L05FbWRIc28vaUc3d3NpMi9xL3AyT2xUY2U4ajhNaVAva3dLUDlrOVJ5M09G?=
 =?utf-8?B?WURiNHdONTV2ZVhhWHVtU0VOd0NwbVZGcGVhM1FoN2dIWWhXT0crWnBvMXoz?=
 =?utf-8?B?OEJpQjBVWGxIV1NaTUw5bnhHS3R2d0laMG5SUEpYQm91UXU1emVwdzVNemRj?=
 =?utf-8?B?OVFSUUtJU1MwbG11TGZHaHRQekM1L2hFWDNTZXpRQjUreisxQ3BOYnFOUWtF?=
 =?utf-8?B?UDVBUzZzME10THlXNmJDUFlldGRyeG9UREZvaXV0ODNvS1J5aUJqS1BzUHRR?=
 =?utf-8?B?cWg4Z05WcmhjMWs3dDBoOTRPb05yTU5WbmwzU3ZqWStjZExjVUhTbFR5UWtK?=
 =?utf-8?B?Z1dBU2pFSFA3UGg2LzhzMVlmTjBBeHE3M3pSTEowaGVmTkh0Z0Z3VzU4bTAr?=
 =?utf-8?B?U2xQZEgwUGl0L0JaMWQzMGYrNUlWaTl2SGRZb1o2NmF1eXhrMFJpWW1ybzhn?=
 =?utf-8?B?bmpmZ25CZnhESEgyemIyODZtcjludU9wYUp6V1BuNWJxWFRETksrYnYyU3FP?=
 =?utf-8?B?MmhROEZBZHp3MUdiNW1uZFgzdjU4U3I3dTRHMENZT2NBbmFOeUZpOEtjK3Nl?=
 =?utf-8?B?b2phV0V6UTZaM3FmVVJvVHRzUFluVzJzNjNwNFEzVDk4SmMzaStmUGRsNEdm?=
 =?utf-8?Q?ZEH/6WyIQCLIqgjlio4CGAoFyqeza3qfLcGyLxG?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 228c1b85-248f-4503-5937-08d92f2370d5
X-MS-Exchange-CrossTenant-AuthSource: CH0PR02MB7964.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2021 10:59:11.3972
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QDTxycM8z6IFAp+JPm3XwaswzaFEZ3JVkXAl0WiSnXCXHczIUahESTPSoDypSkGMNEVpUl1UWdHAyPuyY5EDm9hugihYIt9aPPlOvxXl9lw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR02MB7045
X-Proofpoint-GUID: 6yNIAbUychW5_Q0MfNUfHGRIp5qfkGFi
X-Proofpoint-ORIG-GUID: 6yNIAbUychW5_Q0MfNUfHGRIp5qfkGFi
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-14_04:2021-06-14,2021-06-14 signatures=0
X-Proofpoint-Spam-Reason: safe
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/06/2021 10:43, Greg KH wrote:
> On Mon, Jun 14, 2021 at 10:32:05AM +0100, Jonathan Davies wrote:
>> On 12/06/2021 08:01, Greg KH wrote:
>>> On Fri, Jun 11, 2021 at 03:23:39PM +0000, Jonathan Davies wrote:
>>>> When the predictable device naming scheme for NICs is not in use, it is
>>>> common for there to be udev rules to rename interfaces to names with
>>>> prefix "eth".
>>>>
>>>> Since the timing at which USB NICs are discovered is unpredictable, it
>>>> can be interfere with udev's attempt to rename another interface to
>>>> "eth0" if a freshly discovered USB interface is initially given the name
>>>> "eth0".
>>>>
>>>> Hence it is useful to be able to override the default name. A new usbnet
>>>> module parameter allows this to be configured.
>>>>
>>>> Signed-off-by: Jonathan Davies <jonathan.davies@nutanix.com>
>>>> Suggested-by: Prashanth Sreenivasa <prashanth.sreenivasa@nutanix.com>
>>>> ---
>>>>    drivers/net/usb/usbnet.c | 13 ++++++++++---
>>>>    1 file changed, 10 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
>>>> index ecf6284..55f6230 100644
>>>> --- a/drivers/net/usb/usbnet.c
>>>> +++ b/drivers/net/usb/usbnet.c
>>>> @@ -72,6 +72,13 @@ static int msg_level = -1;
>>>>    module_param (msg_level, int, 0);
>>>>    MODULE_PARM_DESC (msg_level, "Override default message level");
>>>> +#define DEFAULT_ETH_DEV_NAME "eth%d"
>>>> +
>>>> +static char *eth_device_name = DEFAULT_ETH_DEV_NAME;
>>>> +module_param(eth_device_name, charp, 0644);
>>>> +MODULE_PARM_DESC(eth_device_name, "Device name pattern for Ethernet devices"
>>>> +				  " (default: \"" DEFAULT_ETH_DEV_NAME "\")");
>>>
>>> This is not the 1990's, please do not add new module parameters as they
>>> are on a global driver level, and not on a device level.
>>
>> The initial name is set at probe-time, so the device doesn't exist yet. So I
>> felt like it was a choice between either changing the hard-coded "eth%d"
>> string or providing a driver-level module parameter. Is there a better
>> alternative?
> 
> This has always been this way, why is this suddenly an issue?  What
> changed to cause the way we can name these devices after they have been
> found like we have been for the past decade+?

The thing that changed for me was that system-udevd does *not* have the 
backoff and retry logic that traditional versions of udev had.

Compare implementations of rename_netif in 
https://git.kernel.org/pub/scm/linux/hotplug/udev.git/tree/src/udev-event.c 
(traditional udev, which handles collisions) and 
https://github.com/systemd/systemd/blob/main/src/udev/udev-event.c 
(systemd-udevd, which does not handle collisions).

I think this logic was removed under the assumption that users of 
systemd-udevd would also use the predictable device naming scheme, 
meaning renames are guaranteed to not collide with devices being probed.

>>> Also changing the way usb network devices are named is up to userspace,
>>> the kernel should not be involved in this.  What is wrong with just
>>> renaming it in userspace as you want to today?
>>
>> Yes, renaming devices is the responsibility of userspace. Normally udev will
>> rename a device shortly after it is probed. But there's a window during
>> which it has the name the kernel initially assigns. If there's other
>> renaming activity happening during that window there's a chance of
>> collisions.
>>
>> Userspace solutions include:
>>   1. udev backing off and retrying in the event of a collision; or
>>   2. avoiding ever renaming a device to a name in the "eth%d" namespace.
> 
> Picking a different namespace does not cause a lack of collisions to
> happen, you could have multiple usb network devices being found at the
> same time, right?
> 
> So no matter what, 1) has to happen.

Within a namespace, the "%d" in "eth%d" means __dev_alloc_name finds a 
name that's not taken. I didn't check the locking but assume that can 
only happen serially, in which case two devices probed in parallel would 
not mutually collide.

So I don't think it's necessarily true that 1) has to happen.

>> Solution 1 is ugly and slow. It's much neater to avoid the collisions in the
>> first place where possible.
> 
> This is not being solved by changing the name as you have to do this no
> matter what.
> 
> And the code and logic in userspace is already there to do this, right?
> This is not a new issue, what changed to cause it to show up for you?

As above, the logic's not there if userspace is using systemd-udevd.

>> Solution 2 arises naturally from use of the predictable device naming
>> scheme. But when userspace is not using that, solution 2 may not apply.
> 
> Again you always have to do 1 no matter what, so might as well just do
> it.
> 
>> Yes, the problem is a result of userspace decisions, but that doesn't mean
>> the kernel can't help make things easier.
> 
> Ideally, if you _can_ do something in userspace, you should, especially
> for policy decisions like naming.  That is why udev was created 17 years
> ago :)

I'm arguing that a bit of flexibility in the kernel can avoid an 
undesirable workaround in userspace. But I can respect the principle you 
describe.

Thanks,
Jonathan
