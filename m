Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F72E473A84
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 03:00:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240299AbhLNCAE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 21:00:04 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:53548 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231303AbhLNCAD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 21:00:03 -0500
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BE1sI7D022081;
        Tue, 14 Dec 2021 01:59:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=+TmTfjlpf0SjCYjtZib430MwZmGaZWyssOSnIw3LGG0=;
 b=vo3SnCIs0ZRHq5xDB7TrKByGWmtNcwwgQDEgDwSSDDFpAp3d1yALuMl33hkgwab0v+sT
 RmrWK08aOSKMUvA1saM2UWs+cvuSUi4nLYGIKAT4NuDVuczaCPR10ZnFWAQ0ajwnzmeI
 bgIP3+x2yS+Unhf1Un26EkvluHk0o2lkfosEpaeZFz9yrHWoZwRLI84ST++ysbfnGDzL
 wfUCGlE9M7pj9IuETTWSPb+rukkLWRRK3pIhQqGpFZM7Mz+TDtNNktSl+fSNvvtzXtqG
 TPH7+SqY0/gM/ACgOxzEA3Vlhj9AfOMGbcRlr8M1aCaRzLA7MQ3pYcDkEPYls46kbzY2 tQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cx2nfahpx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 01:59:55 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BE1t4ck149910;
        Tue, 14 Dec 2021 01:59:54 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2049.outbound.protection.outlook.com [104.47.74.49])
        by userp3020.oracle.com with ESMTP id 3cvnep3j05-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Dec 2021 01:59:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=liU18UPbxUxEFanvgtcUHIaAOrsqIOAdnPZPZCjGaN9pf13HCmKp5sBviR1fWIwr0BTDBQHV1x1lhwg1WTn4kApo1lAfcOaYMptAbSeQspfVHhAVjlmAl/LT4C5qlTBpsYdEG/+U+j08pACKQdKltrnuxvL2h71R+ppsS6A4lv4HlN7hMBER8nLeO3vlCkZVfjEXLX1Wb/+yCZCpYzlpE1nvX0CiZFSOHotd/pq4mwmgmoRzSaXSoQ+7s7AkzUzVohSa5LnI0C7g0szhXDQY//JXiUsfsVYnhpZtN+DDLq0IQRKlHJdOgGlIigGRyusK4qbzIKACPEHkl1Wl4XfR0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+TmTfjlpf0SjCYjtZib430MwZmGaZWyssOSnIw3LGG0=;
 b=krbgmF/XoUrgApqH6vHwAo+or5NWG6FtkFeySOheN3+g+Ym6CcVc1rscJXxZIpO634SMXU5rVS8q7YluWKAgB562v6S5cZNIaFldf/gfLMD5zYXYaY+WshgehZ501gQcOd44rC8qhRzR/sZGZA2e/vPbF6WOk11bG0mnTUDwNELbzTxeHb15OW7/3f5g7Hf4Y/8SFDbsues2pJJ+LQnTkOLYBQdtugAjIUtmdNL0W1AMB1nzzNclwVtqw6wAOEZIy746nabbz9s3ALPXtyHtFIxDzbRONA9A/9ndX++/xn6pUFyGZngCyEGRzidydj5XG0prrR77CkxVLFKFtjirFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+TmTfjlpf0SjCYjtZib430MwZmGaZWyssOSnIw3LGG0=;
 b=sdXCzLERihYwcubckfuGiJYIBJinhFomPsqSiE/waBlNeYY3SUYL1UPu0VOCa7FPG1NTXL2uM1aZqFpUhBh8Tso8wX/ToXhcxLM2Ofo9lUaeTVkhmuMJSYCQ9X2bUN8+27COYShqMYduWtP05DRDPrryO+FOmtRTQHEqhNpXYBg=
Received: from BYAPR10MB3287.namprd10.prod.outlook.com (2603:10b6:a03:15c::11)
 by SJ0PR10MB5598.namprd10.prod.outlook.com (2603:10b6:a03:3d9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.12; Tue, 14 Dec
 2021 01:59:52 +0000
Received: from BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::7c7e:4a5e:24e0:309d]) by BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::7c7e:4a5e:24e0:309d%3]) with mapi id 15.20.4778.017; Tue, 14 Dec 2021
 01:59:52 +0000
Message-ID: <ba9df703-29af-98a9-c554-f303ff045398@oracle.com>
Date:   Mon, 13 Dec 2021 17:59:45 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: vdpa legacy guest support (was Re: [PATCH] vdpa/mlx5:
 set_features should allow reset to zero)
Content-Language: en-US
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>, elic@nvidia.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
References: <fae0bae7-e4cd-a3aa-57fe-d707df99b634@redhat.com>
 <20210223082536-mutt-send-email-mst@kernel.org>
 <3ff5fd23-1db0-2f95-4cf9-711ef403fb62@oracle.com>
 <20210224000057-mutt-send-email-mst@kernel.org>
 <52836a63-4e00-ff58-50fb-9f450ce968d7@oracle.com>
 <20210228163031-mutt-send-email-mst@kernel.org>
 <2cb51a6d-afa0-7cd1-d6f2-6b153186eaca@redhat.com>
 <20210302043419-mutt-send-email-mst@kernel.org>
 <178f8ea7-cebd-0e81-3dc7-10a058d22c07@redhat.com>
 <c9a0932f-a6d7-a9df-38ba-97e50f70c2b2@oracle.com>
 <20211212042311-mutt-send-email-mst@kernel.org>
From:   Si-Wei Liu <si-wei.liu@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20211212042311-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN4PR0601CA0010.namprd06.prod.outlook.com
 (2603:10b6:803:2f::20) To BYAPR10MB3287.namprd10.prod.outlook.com
 (2603:10b6:a03:15c::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 105102f0-ecfc-4755-c343-08d9bea56af1
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5598:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB55980CD3EAC9AE90E8A1D9D9B1759@SJ0PR10MB5598.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XS5vvsSZDa5TdiL549Ykxt+/sFPsb8FnkQaK+ral1lLaDaZHuWtyhntJoIRouqMKRO4YQfsOCJ0HGLd1DYGXPWSjPddJfUyYxcmM75VLO2zppiUhdjFZ2KkAJ5r9W2m3Q5GeXVfPtAh1k1sXfttuS/ZbHoeKirrfZO65bl7hXIEB6mJyqP5i6ZVR+auCVSKBuOu8NABnNdbIFKwjLHuXpgJ0zhHOeiGj5W2odB037HTH0U1/6vsN+F4wnnpP0encEc/VttmwkOmDdK/rGy7WSlFvw24/0Fc7bWX8B0nLUTNMz/qUEr6AoZDjdPcH7LQwtBccsV+K0Y7ZZi6Z6CaPugxHZjZ8NH1hasrgVVvByOhq1T1+/XcMqoWtrmkbyIvkeGApaXtssYJxmiZbYfvIDdQuN0Z6ucCQBKg9GP7luWNuA00PvHgxZ9Dv61r39zX1E/ckpMK74P4FX0SZIHxH+tap6PxocbJvlm+328H4YTriRAmnZgXQO1i8W8mdbeOQloweSnawTYOIDAxlkKzGo6E2vzSunRp7Ses4DioTDstenDiSV90wicyWH3fn0qFe41ce+4rHS1Eg2uRPq1S9fR2KS423wMAfPKQnEtgmNPzRD3PtB0nbqlprTCJhZmHnXiXlQ7KMMjIRBkGAC9KATUmR7F2asD+tqi2HvK7RhIX4hsHpN1inj5CZBCQreQ+pXmNbFjODHr6Gr2Mt99CZ4cbSLCxcMrvBJMAFw+2WKQ1KL/IAktHt2gzfZjWQKEeKvN5iZim9wXYgmWVbFK+kegMHjYgXAsUMjLfF+sG/twrVLbVo5NQIf/k6KjNgq5rd
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3287.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2616005)(5660300002)(83380400001)(6666004)(31696002)(6916009)(316002)(8936002)(2906002)(4326008)(86362001)(8676002)(66946007)(36756003)(6512007)(38100700002)(966005)(6506007)(53546011)(186003)(66556008)(66476007)(36916002)(26005)(31686004)(508600001)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UGJqQ1JkcFltUW1zTFd0YUdLMmc5RU5PU1FCcTF3S210LzhOVzVLV2ZFNEc1?=
 =?utf-8?B?c09NNjIxVFFOM2FERkVrTHVWNHFrU2hnTzQxYTRKNitSVktCNkt0WWRVdG81?=
 =?utf-8?B?SkJxRlFaL0NkOUxVZDhEbTE2RW9FQ3dxekZ5bndTQ2RIdnkxTlpnakNkNll5?=
 =?utf-8?B?UkN6NTZhdk1MeDRqMG9WM05obllIS1YrdG03MXhwVjVxYVBicHE3QUtTWk1p?=
 =?utf-8?B?OExuem9rUmFvS0p6eXpJK1VHMzZVMG4rLzBldzFHYmlxaDJZdVJHZk5nRXFI?=
 =?utf-8?B?S2t4c0lqUkEyTytuQWlSRFAxZXZ1QnZoay9GSlFlRW1UQ3FjbFhMcXlOLytm?=
 =?utf-8?B?aERVbUhQdGlMT0IyY2Z1NERkckNyeDIzaDNTbmlHYWV2QklCWmVWb0dZSGtP?=
 =?utf-8?B?Yk9kVEtaUlp3K3RDVW5DdGV6QktoTEFwcTBWdWJOUi9RamhZVDNtZmcyTXR1?=
 =?utf-8?B?bzhkcXFMWmFOdkxFVzNxdUJJUU9CY3lJV3loa2lQRUQ0aEl3K1BUT2pvVVlu?=
 =?utf-8?B?bWxXUlpJc3FIajFJTEVhcHpNSW5BWmRaZkRjZkRvY2tEL3VaNHRsUmpPSjJw?=
 =?utf-8?B?N3ZpWEhSRXlmc1l2NDN4aitJYmlaZkkwbGYwZnFJNXI5OXhqaDBVcXpORkUv?=
 =?utf-8?B?WmpIQ0xycGZmSHh6NWFSVDd3SEJDYjV3OTNIMk1Pdmw0V2FZdXM2RDZPdlZt?=
 =?utf-8?B?OUFYSFFRcGI2ZlhDUGRhZUtFUTZBVnp1WmhYOWhxYnhaNTREUCtSZlp6aUNy?=
 =?utf-8?B?V2pMZ25YOHg1UGVxWE0rR2J3OXBaYWJBdjNuRkFnWDdQckZENzEvZDR4MzdM?=
 =?utf-8?B?SVJnZXNtazB1TTdMUE5uMGFuL0pIWGJtVENMc3lHZjVjOVUzOWxicVRLTzAx?=
 =?utf-8?B?Z3doWUtUZWJaRzMvdWNtbnhaa0k0WnVBRE1WUXFGQ0lxTU5MaE9PQ3BDTGdR?=
 =?utf-8?B?ZjdITUlJckM4NGwzWjk0MW5TeVcrQ0xJQjV6VWxIdzNSLzFzamxMbEpVbnoy?=
 =?utf-8?B?MWZDclJHeUxBMWZWOGZ3NFB0SU1vVFlESllEc1dnVkFMczhKTGhTcUVwUDVC?=
 =?utf-8?B?bHROUktTYkZNSitZKzluVzdnZnV0bEQyTkRKczZRdnVUYUdwSHk1aUpaVW5o?=
 =?utf-8?B?TGozNlo2aEt4Y01XbGNiWDMrNitlQWVPNzFiMndPUDNqNnRYelJYM2NzZnQz?=
 =?utf-8?B?Nmk0cXE1ZlBKaFVNdjNDY3ZyaUNNWlJFTytQVEpKTHdhU2dYK2lMMURacjNw?=
 =?utf-8?B?VTBtT1o4OE9RTVU0YUM4THRMMVE3RUNJZmxzY3FyeVM2Rm1YSlBscUZTMEVO?=
 =?utf-8?B?V2tDR0pwTjFjajNRR1hYU3h4Q0d1V0pYNUhzNXRKeS9zVnR5YmxIYU1JdTUr?=
 =?utf-8?B?SVhldWpOb0JpYlk5ZytoTm1Yd21TM1haNFR4ZTlxM3ZsaUFuR2IyRUphR2Zz?=
 =?utf-8?B?bVpOQjduUVV6RlpVdGorQnptRDNNNkFGNy95RGVEMDFHUEpXbTlxREZLa2Zk?=
 =?utf-8?B?NS9KQWRuQXhobHNHNjB3bFY3UHhSMUdRNi9VQS8rMlZaOWVESlpZbVJrUlF3?=
 =?utf-8?B?Mk5sSG1tQ2pWUW9kVitST2wyamQ5ZmVpYkYyTG0zMS9zMytVYkR3M2MxdG52?=
 =?utf-8?B?cWo0eGc3eEU3d1RIWHBRQTVEN056Q0dCMmRNemZySm9vMzdqRFpLVE13L05n?=
 =?utf-8?B?UEVvUktWeVpEVGpoWnhBMDJRR1hOM25KaURONlpUYzVXZHI4eDlwMUhpejg5?=
 =?utf-8?B?amhBYUF2VG1GcWNORkJMVXVpNmVpUE1nR0NSMVZLSkQ2Lzltblphai9aQ2FZ?=
 =?utf-8?B?TVFlb2cvQ09TSHdWRFd4RmlzSGlraVhDR2VUdXJXdzhndUc3SG50NjRxcmFz?=
 =?utf-8?B?cGU4aDVtT2FFclFhSEhwWWRyb3drVEJFT2RuSStTUlNVRWY5S3pnMS9IWHFk?=
 =?utf-8?B?Nm55ZUROWUI1MW5BaDM1ME43dCtGdVNSdjVWdEFERHhuZDRwUWJQdkpNb1Yx?=
 =?utf-8?B?VE1TYTlDRGJEZ1dLMEY0Q3ZaRzYvV3N5MUZGTmFWSXZUMXE0cGlTS0ViQ0NN?=
 =?utf-8?B?R2NVVlBRUUhFcTA5RFpGQlVOdzVmenJCRGVyS2Uwam5sL3VjRWFiRmJYZFdI?=
 =?utf-8?B?NzRQRm1BVVBLZHU3TzZOYmwzNHQ2b2dZZ1FSalEwTTRMZ3c1M1JQYXl6Qmo5?=
 =?utf-8?Q?Z0Sh6INQtfE60CSi2GmDmGU=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 105102f0-ecfc-4755-c343-08d9bea56af1
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3287.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2021 01:59:52.4308
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0bwlAou8UjnJ8nZXv1OdyILRv+1jMPfz6EndnIQBtTdVK+5o7Ult/XZ4XZEZugIGfx7q2s+5aHbvdyUdQZVzOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5598
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10197 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 malwarescore=0 bulkscore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112140007
X-Proofpoint-ORIG-GUID: PumS6uZhRzEVXE36jRR7XQI_tNxL79O4
X-Proofpoint-GUID: PumS6uZhRzEVXE36jRR7XQI_tNxL79O4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/12/2021 1:26 AM, Michael S. Tsirkin wrote:
> On Fri, Dec 10, 2021 at 05:44:15PM -0800, Si-Wei Liu wrote:
>> Sorry for reviving this ancient thread. I was kinda lost for the conclusion
>> it ended up with. I have the following questions,
>>
>> 1. legacy guest support: from the past conversations it doesn't seem the
>> support will be completely dropped from the table, is my understanding
>> correct? Actually we're interested in supporting virtio v0.95 guest for x86,
>> which is backed by the spec at
>> https://urldefense.com/v3/__https://ozlabs.org/*rusty/virtio-spec/virtio-0.9.5.pdf__;fg!!ACWV5N9M2RV99hQ!dTKmzJwwRsFM7BtSuTDu1cNly5n4XCotH0WYmidzGqHSXt40i7ZU43UcNg7GYxZg$ . Though I'm not sure
>> if there's request/need to support wilder legacy virtio versions earlier
>> beyond.
> I personally feel it's less work to add in kernel than try to
> work around it in userspace. Jason feels differently.
> Maybe post the patches and this will prove to Jason it's not
> too terrible?
I suppose if the vdpa vendor does support 0.95 in the datapath and ring 
layout level and is limited to x86 only, there should be easy way out. I 
checked with Eli and other Mellanox/NVDIA folks for hardware/firmware 
level 0.95 support, it seems all the ingredient had been there already 
dated back to the DPDK days. The only major thing limiting is in the 
vDPA software that the current vdpa core has the assumption around 
VIRTIO_F_ACCESS_PLATFORM for a few DMA setup ops, which is virtio 1.0 only.

>
>> 2. suppose some form of legacy guest support needs to be there, how do we
>> deal with the bogus assumption below in vdpa_get_config() in the short term?
>> It looks one of the intuitive fix is to move the vdpa_set_features call out
>> of vdpa_get_config() to vdpa_set_config().
>>
>>          /*
>>           * Config accesses aren't supposed to trigger before features are
>> set.
>>           * If it does happen we assume a legacy guest.
>>           */
>>          if (!vdev->features_valid)
>>                  vdpa_set_features(vdev, 0);
>>          ops->get_config(vdev, offset, buf, len);
>>
>> I can post a patch to fix 2) if there's consensus already reached.
>>
>> Thanks,
>> -Siwei
> I'm not sure how important it is to change that.
> In any case it only affects transitional devices, right?
> Legacy only should not care ...
Yes I'd like to distinguish legacy driver (suppose it is 0.95) against 
the modern one in a transitional device model rather than being legacy 
only. That way a v0.95 and v1.0 supporting vdpa parent can support both 
types of guests without having to reconfigure. Or are you suggesting 
limit to legacy only at the time of vdpa creation would simplify the 
implementation a lot?

Thanks,
-Siwei

>
>> On 3/2/2021 2:53 AM, Jason Wang wrote:
>>> On 2021/3/2 5:47 下午, Michael S. Tsirkin wrote:
>>>> On Mon, Mar 01, 2021 at 11:56:50AM +0800, Jason Wang wrote:
>>>>> On 2021/3/1 5:34 上午, Michael S. Tsirkin wrote:
>>>>>> On Wed, Feb 24, 2021 at 10:24:41AM -0800, Si-Wei Liu wrote:
>>>>>>>> Detecting it isn't enough though, we will need a new ioctl to notify
>>>>>>>> the kernel that it's a legacy guest. Ugh :(
>>>>>>> Well, although I think adding an ioctl is doable, may I
>>>>>>> know what the use
>>>>>>> case there will be for kernel to leverage such info
>>>>>>> directly? Is there a
>>>>>>> case QEMU can't do with dedicate ioctls later if there's indeed
>>>>>>> differentiation (legacy v.s. modern) needed?
>>>>>> BTW a good API could be
>>>>>>
>>>>>> #define VHOST_SET_ENDIAN _IOW(VHOST_VIRTIO, ?, int)
>>>>>> #define VHOST_GET_ENDIAN _IOW(VHOST_VIRTIO, ?, int)
>>>>>>
>>>>>> we did it per vring but maybe that was a mistake ...
>>>>> Actually, I wonder whether it's good time to just not support
>>>>> legacy driver
>>>>> for vDPA. Consider:
>>>>>
>>>>> 1) It's definition is no-normative
>>>>> 2) A lot of budren of codes
>>>>>
>>>>> So qemu can still present the legacy device since the config
>>>>> space or other
>>>>> stuffs that is presented by vhost-vDPA is not expected to be
>>>>> accessed by
>>>>> guest directly. Qemu can do the endian conversion when necessary
>>>>> in this
>>>>> case?
>>>>>
>>>>> Thanks
>>>>>
>>>> Overall I would be fine with this approach but we need to avoid breaking
>>>> working userspace, qemu releases with vdpa support are out there and
>>>> seem to work for people. Any changes need to take that into account
>>>> and document compatibility concerns.
>>>
>>> Agree, let me check.
>>>
>>>
>>>>    I note that any hardware
>>>> implementation is already broken for legacy except on platforms with
>>>> strong ordering which might be helpful in reducing the scope.
>>>
>>> Yes.
>>>
>>> Thanks
>>>
>>>
>>>>

