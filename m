Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA9F8323182
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 20:38:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232261AbhBWThd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 14:37:33 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:49416 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231853AbhBWThV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 14:37:21 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11NJUW29167720;
        Tue, 23 Feb 2021 19:36:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=65+iVLhJ5nlitb1iXhwgUDRKg8fiqShej4FrSlsUl40=;
 b=VH5+1C8GsRuwnWz7fcJcQvvOH0igHSwgUHss2bYl6djTvGj74zIGnS4eCJVAM9hTpXgz
 /pRxdlvP7Lt16QQjooRsUJLu8BgqmgrTewg3pvQix27HcJXDqDw/K9D4M0ANQk8oDAGG
 nL8QfBMJ6Jq+G4ghirprfk1452xtheBI1pG6Vo39/d9D4uLW9RuZoEObqA2AqF1woHtQ
 U8pO3XPsh6wI9FZAIsNfLjFaSlF3ZBuHPnZ6imFgrGXHJJWwrF1N15vfx+N+07nm0D3i
 Ra373UeTNsR0w+VYE6fTzzl49hgrewND8cO0YtgXdiZR7q6Fru8UYBhObZXaDXG48Xm1 uA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 36ugq3ffkm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Feb 2021 19:36:04 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11NJUTTq023492;
        Tue, 23 Feb 2021 19:36:04 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2109.outbound.protection.outlook.com [104.47.55.109])
        by aserp3030.oracle.com with ESMTP id 36v9m51ktq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Feb 2021 19:36:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m4PcMk/F2nPEPSBTL8YcUMPS7VwITjm+Nrzu0RbyiCI4MQ0lyoPxGEdPdDGBkpc92GoaR3k6zG12I/mhAyCcBvNY9IkmN2pS8e7V7wDQj00XNa9liX66jM9xL7altaBQr/Ct20Y/XTkQsUFtGSVwdJK48F7LdTmdIyzv354yFxXX/Dt3ahJ3pjg/hcGfeUgs8qhjhSYpsF09NXBiiTUwAXbxb5ZelVK0LyGr9/eogmhDCXJNMV/rLZ7DSK4sJM/ZZsd+7vsh4VzQiuzLZ0VBBonVlowYCTsmkm6vM2x6u0qCSm0xGSPPk5fqm1Sk1eCp4hC6eK+P8NpdxwnEIkR00g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=65+iVLhJ5nlitb1iXhwgUDRKg8fiqShej4FrSlsUl40=;
 b=EGiI0nulukGQZu791lzP0VN7hlBjpCC2UORSI/ek2GpW9T3Yoetda8B90Va3hqAmLyin4JIn96y2ph99AXp/FNpOJBhboWTaXxCRCSNiOiVWpGOFFrbspA1rn0lW/hptlQWqkAlCEfkNKDdIYXtAzDXaZ8iVvou2zP24YsCgQCEU3eo2FC3PkItbp+D6tjqi4aole+3c2KrL6p+CFa6GUQgYL2GU7gdBL9in3S/lTMFlYIGUGj93ih43QDqKJlS4wzgmtSYo4ZBkThk2ukms8UzZ9yVlaVF49EgxH5WmxhpYqS4g+Z8lN79WanJeEg9p5qXL5CJdp2rArGAd6CO2KA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=65+iVLhJ5nlitb1iXhwgUDRKg8fiqShej4FrSlsUl40=;
 b=AJPp1t51+mSeaHqVev6H186XJRbErQ7kMzpn40gGn/E4Rt9Gk4w945hkXRGxmQ4MGkYoSN3RN5+G4WZPJFMmy9ctR5IUsQRlFbFSeAKbc5Vm6fwhhO7P7c7Pv8w45YXmmMWe7191F86anjuuu3Byq4aFakoFvN/E0PPmteBiNKc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BN8PR10MB3283.namprd10.prod.outlook.com (2603:10b6:408:d1::28)
 by BN6PR10MB1937.namprd10.prod.outlook.com (2603:10b6:404:102::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19; Tue, 23 Feb
 2021 19:36:01 +0000
Received: from BN8PR10MB3283.namprd10.prod.outlook.com
 ([fe80::3dd4:e8fe:49e6:2fd3]) by BN8PR10MB3283.namprd10.prod.outlook.com
 ([fe80::3dd4:e8fe:49e6:2fd3%7]) with mapi id 15.20.3868.032; Tue, 23 Feb 2021
 19:36:01 +0000
Subject: Re: [PATCH] vdpa/mlx5: set_features should allow reset to zero
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Cc:     elic@nvidia.com, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
References: <1613735698-3328-1-git-send-email-si-wei.liu@oracle.com>
 <605e7d2d-4f27-9688-17a8-d57191752ee7@redhat.com>
 <20210222023040-mutt-send-email-mst@kernel.org>
 <22fe5923-635b-59f0-7643-2fd5876937c2@oracle.com>
 <fae0bae7-e4cd-a3aa-57fe-d707df99b634@redhat.com>
 <20210223082536-mutt-send-email-mst@kernel.org>
From:   Si-Wei Liu <si-wei.liu@oracle.com>
Organization: Oracle Corporation
Message-ID: <3ff5fd23-1db0-2f95-4cf9-711ef403fb62@oracle.com>
Date:   Tue, 23 Feb 2021 11:35:57 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
In-Reply-To: <20210223082536-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [24.6.170.153]
X-ClientProxiedBy: SJ0PR05CA0119.namprd05.prod.outlook.com
 (2603:10b6:a03:334::34) To BN8PR10MB3283.namprd10.prod.outlook.com
 (2603:10b6:408:d1::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.19] (24.6.170.153) by SJ0PR05CA0119.namprd05.prod.outlook.com (2603:10b6:a03:334::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.11 via Frontend Transport; Tue, 23 Feb 2021 19:36:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0642142c-7c7e-49c5-4478-08d8d832407f
X-MS-TrafficTypeDiagnostic: BN6PR10MB1937:
X-Microsoft-Antispam-PRVS: <BN6PR10MB1937C53CAFFE78B587A0780CB1809@BN6PR10MB1937.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2449;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c5TaBG5XmgL2QkQbnJ9kejUk1tgfUzcLayNedNicwCNQr8CJje33rkrFqSWdZIhuuDkjsjmYKZrc/YCHMqY/XN8ADH/yxNoB5EeLZwuKEggJA7xGJ/LX9D/MzS3YH8BSmw3I2zi0UBHSDAGYTsXyJPN41SobhAyCHJ+G6TDK+T+EK83jxVMrsfvcOvGxLHSM4rCfd34lXQnvQ3ZKwB+Rk1dKseHEYqZ3U7qf7u9GirhMZ9H7cq6vYGv34nBNUv4JPSJOCQHoe6J813rIMCdRjp5/tw+PJ9WtSFWdabaSBAcvfC54kEnfYXQhy29ZN4bedzuZHk8DrjpAAdj5soDaT4L7h+J1XfYjfYa8r67d38r9L/XYKCyWlEYF1K1NoPMSOpd7b1e6uoU7zBIUsJi8IlspIJZyQGfvzLVRvXePKIysFHsYNx/JcWTkXih17qEZP3G0f1oRE8XCgR/9d8ta+XifhIrhvik9oSZikQvQDqOrDzXpwZiT6K9jGnmVnpIe+tIrw/u4xdeIOf+VJHaSyJ+LC7QyLVqaJb3tTfoGghtM5Osuyv3mzjy2fRmI1BwzWN8opoXo4qrkUVB+6C7fTU22xG0/d6BkEz/aGt5CV9o=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR10MB3283.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39850400004)(366004)(136003)(376002)(346002)(396003)(6666004)(53546011)(8676002)(66476007)(2906002)(110136005)(31686004)(26005)(86362001)(66946007)(16576012)(16526019)(186003)(66556008)(2616005)(316002)(956004)(4326008)(83380400001)(36756003)(6486002)(478600001)(5660300002)(31696002)(36916002)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?a29SYUZmUGtnMVU3QzNabk9KMFBjVEF2aGRMMHBCazZJMExBbzhoengwcmNW?=
 =?utf-8?B?NHg4Q2xrSFdPUGFLbkp3YVpvQ0NycUJuREtQQ2FVaHpiNE0wZWM4eWIwRWxk?=
 =?utf-8?B?TkhRelZ1TGZnRFNyODVIN1hQS1FxUEpHOTBnWVZMLzAyQ2R0cThIQUowdDJW?=
 =?utf-8?B?RU5JSXpWa0ZwK0dRdU1FZVdxY3ROaDV1c0pmM0REM2t5Si8xM3F0aW9JY1pw?=
 =?utf-8?B?Q3hjczZlVkZCUlk5RkZWbHowUXZpODJwZnhqRk9RMHFXZUFrWTg3OVRiWS9Y?=
 =?utf-8?B?K25nMDVqUDQ5d2pOYm9KOUZCd2plaHdDbXVCZE84TnNiY0FOMGtXVFNFY3k3?=
 =?utf-8?B?dE91OU9pd0gyeXgwalBYeXdGb00vVVFMamlsb2JLSFRhL0hkUFQ5NUN2V0sw?=
 =?utf-8?B?RmJmV0Y1VkR0a0dkSHRWQUFzZ2xhRXp5VEJUZDQ0MC9zK21oRXRvL0tJN2lU?=
 =?utf-8?B?RW1GWFkwT3drdHhCbmxYZFRIWWFObEZHa1pNL3VrcXZLN2lOenNRVWRYMW9o?=
 =?utf-8?B?YzJRQWpacmt0Z2NYSVU0d3hZQTJoVDBiUXkyaiswUm5aTER6OGRYRWpxM1l5?=
 =?utf-8?B?Ty9JWHFIbG40YlhEWkJzRTJvd2ozT0R0czlRZERNam9TKzFzUzhQaGp6Z2xM?=
 =?utf-8?B?MTc4TEI2b2FJY2JwZ1E0eEQxazRvdGp3VWxFbDZOemRKZmJKUzV5VThKSWMx?=
 =?utf-8?B?K2lRWFlMekhXc1JIalMxdUttTnBhQ2JWQzF6am9uR3pYcUM0bllITm54WUdi?=
 =?utf-8?B?QWpnODVJZkQ0Qm10R0JQcVp3elQ1NEdYNmwvZXNoQmsvekdVUitMVW56WDl0?=
 =?utf-8?B?U3RLYTAwck5mMzIzbmttU3hSK0NqVWRSSGJZcjBpNy9waUZSRVc5M0t5NXd5?=
 =?utf-8?B?MnZnUWVNN1gzSTU4akNIUUlmTTBORjQyMXBvckMrM2ExM0dDdnBqbHBrRm5x?=
 =?utf-8?B?eE9VVm95SFJJViszN1lLUVd2ZkxHK0dSSk44TUQzemtNeE1JT0VrQlp3cEd6?=
 =?utf-8?B?bnd2d2tqdWsvQmg0ZXRXd0svc1ZBeU8zN3poaGwxa202Tm5Ta0phRVRLWUpj?=
 =?utf-8?B?L2tmbGNpa0c0eXQ1c1d5SjU2ZjBoVWhpbGlIYTBjd0VGZ1laeTJGanJZUjNN?=
 =?utf-8?B?ZGtVTm91a3BHSlFUN1NYMWd6TzhWb2dkMzdIWnpCeCtacVQyOVFYVndmbEtY?=
 =?utf-8?B?RXkxcDM3SzlsaUk0ZFFsQ09LV1RoY1Q2WCtRb3dkTlB3NGNCbnZrKzFHaEdr?=
 =?utf-8?B?WmdDdEpyUTQ4M0l1SU1xdGFXclBSSExYTkY2MDg5emNnbXZvWDFuaVhaci9F?=
 =?utf-8?B?OTdOc3pCWGZQZmpOWGJZM0FwMmhxVHMybUhWRU93SWMwbXlQU0J1ZEhxYnQy?=
 =?utf-8?B?eXFzY0t1d3JOVkFGYzlwc0p1WVVLSURGTUN2cEFzem9GVS9vQm1pMHdETGQv?=
 =?utf-8?B?a3JrMCtwNXZ1OGZnVXd5MEZvM00wMVp1UkRNMFprM3VyNWViQ2piMGZIUU1T?=
 =?utf-8?B?VGZ5Q1ZuNTAzM3Bmelo0NnNUNnczaHdiZnFrcjN0OHo3aXpDSTcwZ2IzSmF4?=
 =?utf-8?B?MUtVRTR5WGE2dXNSTXNYV1ZFdFA4SU1wQ0NpZkJ0MUFhTjVLV3JiV1JrZXFy?=
 =?utf-8?B?aDVqeTFYcWhtcVFMd2ppZ1c5UEVLTVMvOWhDRTh6Sk5TMjRkN1VrK0Ewdlk4?=
 =?utf-8?B?WVFxeDI2QVNJbi94UUFEMHZtcjRYejAvaVArc2JYOVdlejlFZitEM2FvdFVG?=
 =?utf-8?Q?xXrrlBTNm6qQ1QElMrwTLSlsOqnC7sd5QXtQs+D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0642142c-7c7e-49c5-4478-08d8d832407f
X-MS-Exchange-CrossTenant-AuthSource: BN8PR10MB3283.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2021 19:36:01.7520
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OBRdljOM/3y9JqKEd2qu6N6+nnpG+kfQSzXgMzO7T/R65y7QhRqEidDZjENPaXY/z24Ly9fbB/GGXcwZ8IXaDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR10MB1937
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9904 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 spamscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102230163
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9904 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 malwarescore=0 spamscore=0 mlxscore=0 suspectscore=0 priorityscore=1501
 clxscore=1015 impostorscore=0 lowpriorityscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102230163
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/23/2021 5:26 AM, Michael S. Tsirkin wrote:
> On Tue, Feb 23, 2021 at 10:03:57AM +0800, Jason Wang wrote:
>> On 2021/2/23 9:12 上午, Si-Wei Liu wrote:
>>>
>>> On 2/21/2021 11:34 PM, Michael S. Tsirkin wrote:
>>>> On Mon, Feb 22, 2021 at 12:14:17PM +0800, Jason Wang wrote:
>>>>> On 2021/2/19 7:54 下午, Si-Wei Liu wrote:
>>>>>> Commit 452639a64ad8 ("vdpa: make sure set_features is invoked
>>>>>> for legacy") made an exception for legacy guests to reset
>>>>>> features to 0, when config space is accessed before features
>>>>>> are set. We should relieve the verify_min_features() check
>>>>>> and allow features reset to 0 for this case.
>>>>>>
>>>>>> It's worth noting that not just legacy guests could access
>>>>>> config space before features are set. For instance, when
>>>>>> feature VIRTIO_NET_F_MTU is advertised some modern driver
>>>>>> will try to access and validate the MTU present in the config
>>>>>> space before virtio features are set.
>>>>> This looks like a spec violation:
>>>>>
>>>>> "
>>>>>
>>>>> The following driver-read-only field, mtu only exists if
>>>>> VIRTIO_NET_F_MTU is
>>>>> set.
>>>>> This field specifies the maximum MTU for the driver to use.
>>>>> "
>>>>>
>>>>> Do we really want to workaround this?
>>>>>
>>>>> Thanks
>>>> And also:
>>>>
>>>> The driver MUST follow this sequence to initialize a device:
>>>> 1. Reset the device.
>>>> 2. Set the ACKNOWLEDGE status bit: the guest OS has noticed the device.
>>>> 3. Set the DRIVER status bit: the guest OS knows how to drive the
>>>> device.
>>>> 4. Read device feature bits, and write the subset of feature bits
>>>> understood by the OS and driver to the
>>>> device. During this step the driver MAY read (but MUST NOT write)
>>>> the device-specific configuration
>>>> fields to check that it can support the device before accepting it.
>>>> 5. Set the FEATURES_OK status bit. The driver MUST NOT accept new
>>>> feature bits after this step.
>>>> 6. Re-read device status to ensure the FEATURES_OK bit is still set:
>>>> otherwise, the device does not
>>>> support our subset of features and the device is unusable.
>>>> 7. Perform device-specific setup, including discovery of virtqueues
>>>> for the device, optional per-bus setup,
>>>> reading and possibly writing the device’s virtio configuration
>>>> space, and population of virtqueues.
>>>> 8. Set the DRIVER_OK status bit. At this point the device is “live”.
>>>>
>>>>
>>>> so accessing config space before FEATURES_OK is a spec violation, right?
>>> It is, but it's not relevant to what this commit tries to address. I
>>> thought the legacy guest still needs to be supported.
>>>
>>> Having said, a separate patch has to be posted to fix the guest driver
>>> issue where this discrepancy is introduced to virtnet_validate() (since
>>> commit fe36cbe067). But it's not technically related to this patch.
>>>
>>> -Siwei
>>
>> I think it's a bug to read config space in validate, we should move it to
>> virtnet_probe().
>>
>> Thanks
> I take it back, reading but not writing seems to be explicitly allowed by spec.
> So our way to detect a legacy guest is bogus, need to think what is
> the best way to handle this.
Then maybe revert commit fe36cbe067 and friends, and have QEMU detect 
legacy guest? Supposedly only config space write access needs to be 
guarded before setting FEATURES_OK.

-Siwie

>>>>
>>>>>> Rejecting reset to 0
>>>>>> prematurely causes correct MTU and link status unable to load
>>>>>> for the very first config space access, rendering issues like
>>>>>> guest showing inaccurate MTU value, or failure to reject
>>>>>> out-of-range MTU.
>>>>>>
>>>>>> Fixes: 1a86b377aa21 ("vdpa/mlx5: Add VDPA driver for
>>>>>> supported mlx5 devices")
>>>>>> Signed-off-by: Si-Wei Liu <si-wei.liu@oracle.com>
>>>>>> ---
>>>>>>     drivers/vdpa/mlx5/net/mlx5_vnet.c | 15 +--------------
>>>>>>     1 file changed, 1 insertion(+), 14 deletions(-)
>>>>>>
>>>>>> diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c
>>>>>> b/drivers/vdpa/mlx5/net/mlx5_vnet.c
>>>>>> index 7c1f789..540dd67 100644
>>>>>> --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
>>>>>> +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
>>>>>> @@ -1490,14 +1490,6 @@ static u64
>>>>>> mlx5_vdpa_get_features(struct vdpa_device *vdev)
>>>>>>         return mvdev->mlx_features;
>>>>>>     }
>>>>>> -static int verify_min_features(struct mlx5_vdpa_dev *mvdev,
>>>>>> u64 features)
>>>>>> -{
>>>>>> -    if (!(features & BIT_ULL(VIRTIO_F_ACCESS_PLATFORM)))
>>>>>> -        return -EOPNOTSUPP;
>>>>>> -
>>>>>> -    return 0;
>>>>>> -}
>>>>>> -
>>>>>>     static int setup_virtqueues(struct mlx5_vdpa_net *ndev)
>>>>>>     {
>>>>>>         int err;
>>>>>> @@ -1558,18 +1550,13 @@ static int
>>>>>> mlx5_vdpa_set_features(struct vdpa_device *vdev, u64
>>>>>> features)
>>>>>>     {
>>>>>>         struct mlx5_vdpa_dev *mvdev = to_mvdev(vdev);
>>>>>>         struct mlx5_vdpa_net *ndev = to_mlx5_vdpa_ndev(mvdev);
>>>>>> -    int err;
>>>>>>         print_features(mvdev, features, true);
>>>>>> -    err = verify_min_features(mvdev, features);
>>>>>> -    if (err)
>>>>>> -        return err;
>>>>>> -
>>>>>>         ndev->mvdev.actual_features = features &
>>>>>> ndev->mvdev.mlx_features;
>>>>>>         ndev->config.mtu = cpu_to_mlx5vdpa16(mvdev, ndev->mtu);
>>>>>>         ndev->config.status |= cpu_to_mlx5vdpa16(mvdev,
>>>>>> VIRTIO_NET_S_LINK_UP);
>>>>>> -    return err;
>>>>>> +    return 0;
>>>>>>     }
>>>>>>     static void mlx5_vdpa_set_config_cb(struct vdpa_device
>>>>>> *vdev, struct vdpa_callback *cb)

