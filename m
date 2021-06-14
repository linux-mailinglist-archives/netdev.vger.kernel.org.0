Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 378BA3A5F2E
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 11:32:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232748AbhFNJel (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 05:34:41 -0400
Received: from mx0a-002c1b01.pphosted.com ([148.163.151.68]:3542 "EHLO
        mx0a-002c1b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232721AbhFNJej (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 05:34:39 -0400
Received: from pps.filterd (m0127840.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15E9Oxkd021804;
        Mon, 14 Jun 2021 02:32:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint20171006;
 bh=lDZNaSADPmBFS1l5GHq95ydo8FKkmCOyTPHN6Nf/iAU=;
 b=AtSY43pX1qnvZG40ZdrbLJX3yak6917PukdBk9SuBF72MzGKIf4pyhPhr2Xn3kdQwLfa
 d1HFK7dwTjX4NzOhZ3sPGCPzbUSrRqFZyd4tUGNd1jffLTYf6uObg24HgdK/jH0t5AsI
 TDq2M8PD7k1I1nZkjvh0+g4ke6F+a11CwL/U+anki2ynoDbg4NlaHxuniTqgMe7886HW
 kppNc2RkEyYH/HHOuYkCQQyBDABzfCqt/OwF3GbNuic7DMQrWZPpUaIcfy79g9uf55Pf
 i5W4wf6T8XdSsXAUqAM5bNDIHTsQRouUUHuS8D/Av7Sb1FFO5qAjG9q8Xf2bvXwDA8Ba OQ== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by mx0a-002c1b01.pphosted.com with ESMTP id 39606h0gg1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Jun 2021 02:32:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZLLqNfJYje28/saqeaebJjxJ0k4nu7nN5w3K8+J3kF4HTRJlTkRdH6boeS+x8nVZaq9agT/1Z7M4yohismpclYDZzSULibxfARnKk76J16lShDNswq3dYLy0EXIKY61FWDV2QHfxoV/q7rIFRBiv6LQi41FYRIKiRQxXIQY8RXMu4m0fVBz/cl92AXTRJ4EIsDupO/ahpRp4tLmjBLehRm272KbVYzbrqKHD/ZfHhKhr/1838uchsdG3OMsloLvde5kUZkcYqYYquhlGpVcPON30X7Vef2PmCLlOnzbtHDPJZbWzKxJyuZhbSH/QJA74Zs2Bry/hxFhs+bGb8r19qQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lDZNaSADPmBFS1l5GHq95ydo8FKkmCOyTPHN6Nf/iAU=;
 b=SSsVgVHAEdYhlt778XzlnTckxpBYEaWkjXxiOUEyiFm3RH/9RPpRPam7TmB+V9bTK37x8h0dT0kNtk72DyZBgZsdQntqTTOJXu2/jNGCo1uqZuINW2lgjBbkhN25f3KL4UD/SNNiXPpz7VF5wMFZc+GycRNwIDHMCZ2v1eQex8B1ijix0rr6Du2EnwiRZQGxUQWtdDv12sxx1Wgmut4IU1iNXGbp9hps6btbi3/myK/ObJ5eK5QbB1NXoAFKhEuHvhMHD7YjdPf4QKhEDTHIbJ+DimGCE6n5rvxwJfJODYQBkFScW1qWcrieEaDo4r4SZOm7xrNQZzPDTY+blv50Rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=nutanix.com;
Received: from CH0PR02MB7964.namprd02.prod.outlook.com (2603:10b6:610:105::16)
 by CH2PR02MB6711.namprd02.prod.outlook.com (2603:10b6:610:ae::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.25; Mon, 14 Jun
 2021 09:32:27 +0000
Received: from CH0PR02MB7964.namprd02.prod.outlook.com
 ([fe80::f833:4420:8225:5d12]) by CH0PR02MB7964.namprd02.prod.outlook.com
 ([fe80::f833:4420:8225:5d12%7]) with mapi id 15.20.4219.025; Mon, 14 Jun 2021
 09:32:27 +0000
Subject: Re: [PATCH] net: usbnet: allow overriding of default USB interface
 naming
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210611152339.182710-1-jonathan.davies@nutanix.com>
 <YMOaZB6xf2xOpC0S@lunn.ch>
From:   Jonathan Davies <jonathan.davies@nutanix.com>
Message-ID: <e35ddece-3fd2-4252-6786-af507ba819d2@nutanix.com>
Date:   Mon, 14 Jun 2021 10:32:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <YMOaZB6xf2xOpC0S@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [92.13.244.69]
X-ClientProxiedBy: AM3PR05CA0088.eurprd05.prod.outlook.com
 (2603:10a6:207:1::14) To CH0PR02MB7964.namprd02.prod.outlook.com
 (2603:10b6:610:105::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.249] (92.13.244.69) by AM3PR05CA0088.eurprd05.prod.outlook.com (2603:10a6:207:1::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21 via Frontend Transport; Mon, 14 Jun 2021 09:32:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 99bbb713-5206-4a36-20ff-08d92f17530e
X-MS-TrafficTypeDiagnostic: CH2PR02MB6711:
X-Microsoft-Antispam-PRVS: <CH2PR02MB67115FD69A27D5764761EE8ECB319@CH2PR02MB6711.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2GCK+r6g3FK9wFhPItgvqUAXpuZ8yFWN/R7nuWgKUbyCGmh+5gn54fMB27HBb9FVwsX1wtIvXlBmfZPSRjsVsa+TsIhWQLqmSAhOqamSNzhz/kaX/nuP2+sBecKDJXrQK61/lfPX8kPapMUIBCAaPQO6UROnGZcrJG7vPPeO8NQU97kw35i2zx6XGqx/KfHI0AOQsOR6bDRf209Rz8Df9tN4pDGJMyVwD6brqskvs1P/bmkQ1ezsna3mtnIEQOnXnGQP9yFI/plSvGhtqSbhmYMpNzvXdGQDQ0HL3ttceMaapUQvR/ttDLfW04SeIqT/29RBehqU4lWKvmWWpMXn3O/MZ+JwBUCWGlqHtwQTTYybyF+6zpnk2wmvLBQ3zXeEWkWYgzpKAgq2Toy5GRD413OCBMZGCN818fnrlBrG96UeWSX/NwP+Bd9slHgwLJoVK6dgordjomO2E2sul3SsPaKCSREtJriEst4iSWKPQJSiNcga1srEkkxBG3gW/xHfM7ixU4/SOr4tZikJQnzpSl7MI6n/xS0hRPfc3B8xClotGhCRP06gFxy3wp+Ea/+YShMzFRXJlHIudmbnCc4griaYSDSNMyQVE7Haq86k2uQIZSy0uZIb0WLZF2mWbClCNyz87wC4CvVmFT6oW5rcX/J509GyMgb5bxb4GY1zTbe4gxm5blosj6ceOIAFsj8MmepxGkVtmfHgjVi7CMQHSXEupcraWgvg4EvntBdHa2Q=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR02MB7964.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(39860400002)(376002)(396003)(136003)(366004)(16576012)(6486002)(31686004)(2616005)(8936002)(316002)(2906002)(83380400001)(26005)(5660300002)(44832011)(6666004)(66946007)(4326008)(956004)(478600001)(54906003)(66476007)(16526019)(66556008)(53546011)(52116002)(6916009)(186003)(38100700002)(31696002)(38350700002)(8676002)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L2xsaDljZkM2N3FNayt1anZESlExY0RYdzRER3lER2pXUkJyVE4rSHlueHow?=
 =?utf-8?B?YnhjQk9oRXNWbjFCQjhhUUV0Nm1pTEtpQm1lRkUrN3R5SklNdFRCazRDMlJi?=
 =?utf-8?B?STEwbFh3ZjJ2ZHd2OHdIdVlhS0ZteC9OUFR0K2xEcHlaUXVEcFpWRkNxSFdQ?=
 =?utf-8?B?L05adjlOK3ljeHVHL1hRVittaWFpR2FBNkxzSnlEZXZTSUNRU0FWZTFtb3dw?=
 =?utf-8?B?MU03TmtvY1pHaHNSTnpkTW56eEZXR0pIeE5PMGlnOEFoQ0VqMm9ZSDJuakdB?=
 =?utf-8?B?RlFyTmQ4MmpndWVmV3A2ZlE4SWwxdnE0ZWJwbXNWTUxvNWhscEx6Q2Y3ZlhP?=
 =?utf-8?B?TDlxNGkvOEY0UmZ1cjFBT2xKckRNK05vSStoTTRQanFIMmpLZFcxUC9UVFg3?=
 =?utf-8?B?blREZ3NSNy81eGRDaVQzVkJoWHVUMHJ0Vit5Tzl1clMzMUdTRnNtajZxSG82?=
 =?utf-8?B?bVFmVGNHUmJCUDViYlc5RG5SRGJsUmZhamYzTTQwZmJlYmNKR3M0MzdzS0Vr?=
 =?utf-8?B?dmNVZzhVSkMwUnZCZmR4ZS8vbVRmd3Q5ai84cnBWUExnZWtBVGl6VFRIZGdu?=
 =?utf-8?B?WFMwQUhHNVk1YWdobk9KRXQ4QWVGMWI2anRMVmdrMlFlQy9YOEEvYlhnQ2Ni?=
 =?utf-8?B?U1MrVDFrVFlqdUxhenU4TWFCY09BWXZCeVpObFJKQkdTYWl5MGMwMjF2L21I?=
 =?utf-8?B?Ny9PVXhLQW9qdDY3UjMrM0I4MHErRTlSb3RIY2t6a1BDenZ1NitFV0VicXA1?=
 =?utf-8?B?WVV6eExnQ0xxNENCMHRXMHpRdFlsWmJBM1RxcGpJN0hFUUJRekhqRG5VbHNy?=
 =?utf-8?B?K1BvaTViYkpoaDJQdEM1ZjNDdnptTzd3aVQ3TFJQRE5hWFVVcThISHgrN2x3?=
 =?utf-8?B?Z3piaXJNOTJQOTBJUUJlZWhRYnVQZS9GSjREVmloeGdGL2p6S2MwOHp6OUFW?=
 =?utf-8?B?Qnl4SHR2V2sxNkdidDlvT1o5cEpUcG0rNGZuTW54VlUydk5QUDFSNGVLNFR4?=
 =?utf-8?B?S0I4NHNyZFJYR3crSzNQVEFwZzltZmxTWjBsMm1RbFJMVzdETmdnMnlXbC90?=
 =?utf-8?B?R011blc3Mjc1blhVR0tJUnhNQ0N0Tis4YllsTTF2U2dya2pHekdDdW12bGlz?=
 =?utf-8?B?a2Qvd085emttamxWVmZMKy9uYXlvY20vN3FHeVR6TkxIWVdzdkNHVHZEOUhk?=
 =?utf-8?B?NzcxSzBVcklaLzBFUnBjSHRuNHZmS3FFYSt4bGdzdngzcDg1SE5XU3FoM21C?=
 =?utf-8?B?QUJwS25qTCtzNStJVDVyWmhWMmFrS2o3M0xBb3lOMVY0WFQydkc5SXF2Mmo3?=
 =?utf-8?B?QW1nQzJJYWxRVkpORFNSUXJZdTd1WngvNVd0NEpSSnhjY1NyL0hPcUpGUjdW?=
 =?utf-8?B?emtSc3VjeUgxcE1JOGNiR0xwcWo0TTJnamo3OFNsUWlseVZBRVQ3SjlvcDRD?=
 =?utf-8?B?ZG9HMVBVa0RhVUg0VS83SkNQaUlMVTFjVncyNlJKc1d4TGJZeGIyZmdoRWpB?=
 =?utf-8?B?eDhNQ1RSd01vYXFOSTlqSmM1cXRuWDY4eWVRT0ZCWUVTVnJMYzVnSmF0Vndj?=
 =?utf-8?B?aC9mZ1RZRUU2OVBnOEhoOWQ1Y1d3REh3bXp4M3VJRkhkQUVqdlNEdGthNGt2?=
 =?utf-8?B?UnJzVUVUclhUczEyYURKTGFQSG5RQzdvbHBpbnlYQU9KSDBNVDhMSXRNeVZt?=
 =?utf-8?B?Q3R3WXJrelQwZXdCUjY3Uk0yT0pldFYyV2hYNFM3djMwdEpwb1UrYm1GWkJm?=
 =?utf-8?Q?wF/GlSOxoHy3daDvvlHEFrBcs38qqDD6+ihNh5k?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99bbb713-5206-4a36-20ff-08d92f17530e
X-MS-Exchange-CrossTenant-AuthSource: CH0PR02MB7964.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2021 09:32:27.4660
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: meLBWsk0H9BKETF5zHf2I6WlbbspTwfVzzXl2qOUPHqJMt3HqoaD33fDdvfMcdU7dNG5AcokJzW5h7Pci79s3uXYNfZjVQDxrqBBB/OXYzQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR02MB6711
X-Proofpoint-GUID: jCwU21bFMVpTd9N9wXRNZAr8mHX5LSxR
X-Proofpoint-ORIG-GUID: jCwU21bFMVpTd9N9wXRNZAr8mHX5LSxR
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-14_04:2021-06-11,2021-06-14 signatures=0
X-Proofpoint-Spam-Reason: safe
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/06/2021 18:16, Andrew Lunn wrote:
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
> Module parameter are not liked in the network stack.

Thanks, I wasn't aware. Please help me understand: is that in an effort 
to avoid configurability altogether, or because there's some preferred 
mechanism for performing configuration?

> It actually seems like a udev problem, and you need to solve it
> there. It is also not specific to USB. Any sort of interface can pop
> up at an time, especially with parallel probing of busses.

Yes, this is also applicable to the naming done for all ethernet 
devices. But I've seen the problem multiple times for USB NICs, which is 
why I proposed a fix here first.

> So you need
> udev to detect there has been a race condition and try again with the
> rename.

(See reply to similar question in sibling thread.)

Thanks,
Jonathan
