Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C211322365
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 02:14:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230270AbhBWBNU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 20:13:20 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:54944 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231489AbhBWBNG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 20:13:06 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11N19CTl172732;
        Tue, 23 Feb 2021 01:12:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=GkRh8iv09tX2YyX0Bisf8UWO6+RG6ZbBSXklIykkIls=;
 b=wulqWBy9FTPvANiu2S99Xaw9euBWe+WHbF0MdHvO5KWHklDxnBDfMc8pbn8PRF6yyH+v
 eMfUCYsUMCDQN/P4PmZKX7YOC0a/LGid0AtDxc8a5gtBUEG8CH7Uy5r88Oi3TR1fkQL3
 5qfu54pYHkN/1U5qlAcD3L9cBVDXPHOO7TDGcyFx/dndwDJGs7temGM665B7EaSHTicy
 WWr330OFOwl99Rk6XDULOvM/kOX8ZFKYloP3dCLNyB9SMX5E4C6puPrmBjOVqv4kTmTG
 EXP//SDEy6jRYVeBybBPDzlNJuoB5aKqyBtMVcMAd2PCTvDTGXIAoyyzXPycJ3LYXa2z BQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 36tsuqwmer-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Feb 2021 01:12:18 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11N16RLb130384;
        Tue, 23 Feb 2021 01:12:18 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2105.outbound.protection.outlook.com [104.47.55.105])
        by userp3030.oracle.com with ESMTP id 36ucbwtc3r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Feb 2021 01:12:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M68gHJFkqj7qlXKfdY3/qoXCLocUT10MOE/HKy6rU85wWmqsrt3Kx7LGp0Hxatj5y3qWZQ1q4PzH2zncZeUpczFlt9wk8BnmdwGIzfX8ys4/0lfyDRXQ1z2SsCxe/bJECqXShchY80Tjkigf/EKW4Mcsnodize4hpNnKddbdZnwXQvK6Sx1T8ZGx6VKC3WloKJr38MnygRh/DBBA14EcL7gDQSm4OFuyZSYfnepNw4XO36Io9jjlHVS8oODrQwNOiIgHZDtYUJeZge1yd63bfZ1TedEuU/SPXoWnBpMFIvWagFlIZtdQ5ZdfuRQ2nrnaeggKTYzo40FpD1WzMLZQzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GkRh8iv09tX2YyX0Bisf8UWO6+RG6ZbBSXklIykkIls=;
 b=g6PBqLbuADn7NrgWstZUNlw/Ypy9KHMN6d0jgY+t8YarzbQGUFH5FNrgN1AOUbscJgrVsfkDCBpmiC776Wzs+a8nZYRExXR2Rd2Eda9buTYgC3f90unv3HVu8z8+SWAax0gtUj8ZKWSoBPJpVmlu0s4lk/km3khhc4tjdDEmDpVAsSQ0bfxHPtSEJzqbdcPpY3p1K2gpU/TH79dBDjLe22tPiZYEzd2u8AUrRpXogdX5khbeLstPU80iSwIG33GWRA2CrK4nU4OUvAqkdN789cNBUoQXzcRZbYNmN6EhYnhs/OD1O26hk+wRdSj5mH5e3D1sNEst7eVoClFFJCvq/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GkRh8iv09tX2YyX0Bisf8UWO6+RG6ZbBSXklIykkIls=;
 b=I4BFLq2KxmO1xJxPBcIFWyIwzjGouLw2ClvtVnUShG8Wx7W92afBEVKMFIfGIl+7s+D4u70V+NC4qiGkxhmgMCtXJpgYMUIq1fBI2utY1TRI9VNzVe8+sda14ieN5yXLgKRae2l3ZB7tlkXIqkjHmyHldFQbk3wqcaBJti3s3r4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3287.namprd10.prod.outlook.com (2603:10b6:a03:15c::11)
 by SJ0PR10MB4511.namprd10.prod.outlook.com (2603:10b6:a03:2de::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.41; Tue, 23 Feb
 2021 01:12:16 +0000
Received: from BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::45b5:49d:d171:5359]) by BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::45b5:49d:d171:5359%5]) with mapi id 15.20.3868.031; Tue, 23 Feb 2021
 01:12:16 +0000
Subject: Re: [PATCH] vdpa/mlx5: set_features should allow reset to zero
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Cc:     elic@nvidia.com, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
References: <1613735698-3328-1-git-send-email-si-wei.liu@oracle.com>
 <605e7d2d-4f27-9688-17a8-d57191752ee7@redhat.com>
 <20210222023040-mutt-send-email-mst@kernel.org>
From:   Si-Wei Liu <si-wei.liu@oracle.com>
Organization: Oracle Corporation
Message-ID: <22fe5923-635b-59f0-7643-2fd5876937c2@oracle.com>
Date:   Mon, 22 Feb 2021 17:12:12 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
In-Reply-To: <20210222023040-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [24.6.170.153]
X-ClientProxiedBy: SN4PR0501CA0144.namprd05.prod.outlook.com
 (2603:10b6:803:2c::22) To BYAPR10MB3287.namprd10.prod.outlook.com
 (2603:10b6:a03:15c::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.19] (24.6.170.153) by SN4PR0501CA0144.namprd05.prod.outlook.com (2603:10b6:803:2c::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.10 via Frontend Transport; Tue, 23 Feb 2021 01:12:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e913a42e-10e9-495b-4159-08d8d7980f08
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4511:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4511314D056DF4916105855BB1809@SJ0PR10MB4511.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: x+22IUYNuuk8BlIfUs6chcJlSaAhvL4TDnUh6d74JkUwic7Ipj0yFvAg0Uphqy2OqOCn3GzmTXi0W+O0y1vpQPiUueD6SGHO2JngcH+0AxBz9EGDUzP413+OH/oKbw9O+K3d4+Pagk7/YCgxIk/QZ/7ItNoVhFzDeMttUAycXZo1aIPH9LLarMede1Wo59QcxT0aJtm2HC13fm81uTYBTvaNHWkkdZdRfl6lATauuPvyHseuEaRDVvGDtOkA6aevkTPiFi9ah/Q1eeUidrpBtQTnhQLlu73HMlpx9TdCWHNhuxhcZStXi+qfVUtgAPcpD6xjD8Ag+g/lf4/oEBDi+AOBkBOsBGfKitRhpxKHqW3Oaii9XecvwDgR/m1PRZPV0vIG/p82JpjitfSLcJiCcUeeI0NarfSzpp4+u+XPPXUcq8NxDkXPPTBd741VWZqYWn4lykYeY5Y9hJu4gRCVesWi5zlSpAoUOZdyTRMaT4EfJnDeCj+5E6sZSnSUyxfKNjn8ShRDSvN2ddTwh40HathyLnwjaT6GQrJ9CjAVWbBhVhh+rnndZrZQxb8m/447IZugzrfQsIQTZKZXf6GbCtuDRhE4KkeEeIE9TWttZV4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3287.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(39860400002)(136003)(376002)(396003)(366004)(4326008)(83380400001)(36916002)(316002)(6486002)(478600001)(8676002)(2616005)(5660300002)(6666004)(31686004)(956004)(36756003)(16576012)(66476007)(8936002)(110136005)(26005)(2906002)(31696002)(16526019)(86362001)(186003)(66946007)(66556008)(53546011)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Y2VhTWIvM3NkR056NVlYcStLTWVoL3FkS3VwVW1GVTMvOUxGZEthL2ZrY290?=
 =?utf-8?B?WU16bUQyS3VFODBWalB4QWc1S2JzMGs2K3l6T0YyaHFlTCtpQ3BkU09qRFZY?=
 =?utf-8?B?MktUT2lvaDYvV2xzQXJ0a3dzdkJ5ZVJtVjJwR0pleEFPWU5EQWRCdURSRjdp?=
 =?utf-8?B?UDZpUTZWSGVnMkJTbUNpSGFWckt6VVJ3ZGt6UGpyOWRicGNWbnUybUJ6c0Ux?=
 =?utf-8?B?dFJqZWgyVXVra0Mxcy9MSW5GQ3VPRXpWYXJaaEtZaFVZVHFzWEVvN0oxcGFP?=
 =?utf-8?B?a3JUSjh3TzFadk90bnZCTGN5RmRmbG10WjZJc1gzMnVtTUx5Nkw1NTFIUndh?=
 =?utf-8?B?bncrTEdRWnlxS2FPMEY4TUxneW9PeHZrZmo5NDZ0ZGxiUGxNVFBpOUVZRk9T?=
 =?utf-8?B?WmZrMlF6WFZCa09SV2hmdHpvSzQ2dmlVdDRHNk01S2ZkbW1OZ3QycjZYVXRQ?=
 =?utf-8?B?R0FsdGhFZEJqS0ZGdG9tK1JCeEwzdkVVdWF4N0ZyYzdESmFBWE5BZjF1TWRw?=
 =?utf-8?B?eGVielpPYVZaMHVjT1NOalh0Z01xTm0zRjNpWUp4eGRkR2wxT3c3bmdPMHhF?=
 =?utf-8?B?K1J6cjJTQUFGNlhscEZYSnNzckJTa1d6T25kSmhmVXAvdW9EV1NKSFNraWpk?=
 =?utf-8?B?UnB1WGJpV2FNMGtsdWtLNWFUa0Z6b043VFhndE5vK3lWd21JZitIQWJtU0tl?=
 =?utf-8?B?cXdzLzNnRStWOHlyTkhyRW5tdWk0L1ppd3NRU2J5Qkl6K3Zwa1ZHNWdEeDNB?=
 =?utf-8?B?MFM1bzJWQUJuL0dKdk4wQnZacG5TZ2cvRGoxWkJWYTRGSitlU3JFcjgwYU5L?=
 =?utf-8?B?RUo0RXJUb3FHYmNOMXVIbU1CVFpuVURtL0ZIZ1FqeUtwSm5wYWViUVZHdlRQ?=
 =?utf-8?B?WFBOM1REZU1hcTh4ZURlT01KNVpWbWpMUExWbHl0RVhrdGtCcVIyODlnVFhp?=
 =?utf-8?B?S1JKR3JvTHBsN2lka3V5b2IvaTd6Wkt4U2lZdm5qb3R6ZEFhdk8yVUQvckt5?=
 =?utf-8?B?dUVVWTAxR3llWFRFNGZtNTlOanhDYnZzUkN1MDVqMGlYNkFKb2dFbUl4Q1pI?=
 =?utf-8?B?SkQ1VVdxdFBkQW1xbTJuNHUzYjd0TGpsVXdXeVpQQ1I1S3JraGxWYS9HcjN4?=
 =?utf-8?B?ZUpxL1RiYktwTzZhSTlKY2t3RURRcFI5VEpnOEpqcGkwVVRNcUFBUEdZdTB5?=
 =?utf-8?B?b2MxaDcxTFVzVmt5UHZnWWZBbEtSTWRLOE9uMCtZNWk0MStPSi9Wb3V4aDE2?=
 =?utf-8?B?TlJYYzRGVnBsU3U2cnJuUUpXRXlRcWNnMm9QMWV2NThQMTc1bDdINUJxVlhF?=
 =?utf-8?B?N0ZKenlGZmw2YVRMeVUyeVhKZDF5TXo0TlNGMm03Z25JSUJETjlZTFpUdzJX?=
 =?utf-8?B?WXBXazlIbmw2QXZsckdXMHhmTWRJT1drQXBuWkVudlg0aG1yN015OTRZUWVL?=
 =?utf-8?B?aFVWWS9JV1lpYnVSZGZKUEdJcG9RVUNXMERjZ3BxSmxLd216dzk5UHVKWmo0?=
 =?utf-8?B?bHFlTGNPRHh1T3JXdVdkenNmVmlyb2pLWVdHRWlleWNrVC9FdHdLb1VpbjJV?=
 =?utf-8?B?eFRleExub0trSDJkY1lrY3J0VGpkZm03bFJ2Y2dtLzh3V2hVVks0aGJHZkcv?=
 =?utf-8?B?UG1PbVdmNFJFYzViYXA0VGZ4NjlQYWdGbEhBeW93N0h3V1VrU3IyNCtCN2xV?=
 =?utf-8?B?cDJ5MUY2M01ONkRoWkwyWTVWbUEreGpXNWRlZ3p3TjQzd1ZBdzJHYXhLWFB6?=
 =?utf-8?Q?zVdZNQ/MV4gNmgKPuV8px3OX3R9DRS19L/MaoPi?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e913a42e-10e9-495b-4159-08d8d7980f08
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3287.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2021 01:12:16.4152
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h9nChHu7oNCAwlPe92MRymibkPUOhuk+/0VABU8oB502ybBrAxElC6ZSucuizOLGMY4Sinsciq6/txYVgDu2UQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4511
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9903 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 spamscore=0 suspectscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102230006
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9903 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 mlxscore=0 malwarescore=0
 clxscore=1015 phishscore=0 mlxlogscore=999 lowpriorityscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102230006
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/21/2021 11:34 PM, Michael S. Tsirkin wrote:
> On Mon, Feb 22, 2021 at 12:14:17PM +0800, Jason Wang wrote:
>> On 2021/2/19 7:54 下午, Si-Wei Liu wrote:
>>> Commit 452639a64ad8 ("vdpa: make sure set_features is invoked
>>> for legacy") made an exception for legacy guests to reset
>>> features to 0, when config space is accessed before features
>>> are set. We should relieve the verify_min_features() check
>>> and allow features reset to 0 for this case.
>>>
>>> It's worth noting that not just legacy guests could access
>>> config space before features are set. For instance, when
>>> feature VIRTIO_NET_F_MTU is advertised some modern driver
>>> will try to access and validate the MTU present in the config
>>> space before virtio features are set.
>>
>> This looks like a spec violation:
>>
>> "
>>
>> The following driver-read-only field, mtu only exists if VIRTIO_NET_F_MTU is
>> set.
>> This field specifies the maximum MTU for the driver to use.
>> "
>>
>> Do we really want to workaround this?
>>
>> Thanks
> And also:
>
> The driver MUST follow this sequence to initialize a device:
> 1. Reset the device.
> 2. Set the ACKNOWLEDGE status bit: the guest OS has noticed the device.
> 3. Set the DRIVER status bit: the guest OS knows how to drive the device.
> 4. Read device feature bits, and write the subset of feature bits understood by the OS and driver to the
> device. During this step the driver MAY read (but MUST NOT write) the device-specific configuration
> fields to check that it can support the device before accepting it.
> 5. Set the FEATURES_OK status bit. The driver MUST NOT accept new feature bits after this step.
> 6. Re-read device status to ensure the FEATURES_OK bit is still set: otherwise, the device does not
> support our subset of features and the device is unusable.
> 7. Perform device-specific setup, including discovery of virtqueues for the device, optional per-bus setup,
> reading and possibly writing the device’s virtio configuration space, and population of virtqueues.
> 8. Set the DRIVER_OK status bit. At this point the device is “live”.
>
>
> so accessing config space before FEATURES_OK is a spec violation, right?
It is, but it's not relevant to what this commit tries to address. I 
thought the legacy guest still needs to be supported.

Having said, a separate patch has to be posted to fix the guest driver 
issue where this discrepancy is introduced to virtnet_validate() (since 
commit fe36cbe067). But it's not technically related to this patch.

-Siwei

>
>
>>> Rejecting reset to 0
>>> prematurely causes correct MTU and link status unable to load
>>> for the very first config space access, rendering issues like
>>> guest showing inaccurate MTU value, or failure to reject
>>> out-of-range MTU.
>>>
>>> Fixes: 1a86b377aa21 ("vdpa/mlx5: Add VDPA driver for supported mlx5 devices")
>>> Signed-off-by: Si-Wei Liu <si-wei.liu@oracle.com>
>>> ---
>>>    drivers/vdpa/mlx5/net/mlx5_vnet.c | 15 +--------------
>>>    1 file changed, 1 insertion(+), 14 deletions(-)
>>>
>>> diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
>>> index 7c1f789..540dd67 100644
>>> --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
>>> +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
>>> @@ -1490,14 +1490,6 @@ static u64 mlx5_vdpa_get_features(struct vdpa_device *vdev)
>>>    	return mvdev->mlx_features;
>>>    }
>>> -static int verify_min_features(struct mlx5_vdpa_dev *mvdev, u64 features)
>>> -{
>>> -	if (!(features & BIT_ULL(VIRTIO_F_ACCESS_PLATFORM)))
>>> -		return -EOPNOTSUPP;
>>> -
>>> -	return 0;
>>> -}
>>> -
>>>    static int setup_virtqueues(struct mlx5_vdpa_net *ndev)
>>>    {
>>>    	int err;
>>> @@ -1558,18 +1550,13 @@ static int mlx5_vdpa_set_features(struct vdpa_device *vdev, u64 features)
>>>    {
>>>    	struct mlx5_vdpa_dev *mvdev = to_mvdev(vdev);
>>>    	struct mlx5_vdpa_net *ndev = to_mlx5_vdpa_ndev(mvdev);
>>> -	int err;
>>>    	print_features(mvdev, features, true);
>>> -	err = verify_min_features(mvdev, features);
>>> -	if (err)
>>> -		return err;
>>> -
>>>    	ndev->mvdev.actual_features = features & ndev->mvdev.mlx_features;
>>>    	ndev->config.mtu = cpu_to_mlx5vdpa16(mvdev, ndev->mtu);
>>>    	ndev->config.status |= cpu_to_mlx5vdpa16(mvdev, VIRTIO_NET_S_LINK_UP);
>>> -	return err;
>>> +	return 0;
>>>    }
>>>    static void mlx5_vdpa_set_config_cb(struct vdpa_device *vdev, struct vdpa_callback *cb)

