Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0903F57BD90
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 20:17:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229963AbiGTSQ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 14:16:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229871AbiGTSQ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 14:16:56 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BCEB4E60B;
        Wed, 20 Jul 2022 11:16:55 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26KGcpOu024998;
        Wed, 20 Jul 2022 18:16:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=3B2kszBedckSK9t4wJNJKLTYG5uxGwwporKDMUqrgcU=;
 b=k5vzBlOUboEqVOM1nbnmkujTc5YOlaBmyA+v+XpH+cIoh0TcEjLJbvTlR4yDGXg56tDJ
 kwHYuDmzkLWxoNGK2aqLZXniChVT8yxkhHAZFqGnCvgs8OAsqj8NvOS1kx3a1e2w9JWx
 j2VpB95DkxadV79QY8SSGY0ne1x5Kkjk+haQ/7P9IZ8ZWDB5aKGeT5ug1F8VF1NeUStJ
 e0FvrqbbFEGZgpLCaWt45TTKqI5DwUOclaLy7LBSnoNaStHASbxQXvs8FCMMbizE1rHF
 MMBMaxyVNSuYDNYLLz+QKru3D/Pp3W+u3u2S6KL/Oc8HXiNmuynMxao2kApm6sG+AKTd ug== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hbnvtjevx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Jul 2022 18:16:47 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 26KGJvAC007750;
        Wed, 20 Jul 2022 18:16:46 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2172.outbound.protection.outlook.com [104.47.55.172])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3hc1k4h1ks-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Jul 2022 18:16:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LXMGmzdmcbaPmeqYnvJeGQfxxSK5ZBxTBVmgEmToSx4xq/+zDcnnbWD815oFlx2Ve+wMYs813uPQoSLsCKLdNAYSL0qOU+Rj6BB0WhmPo/ZnR/kgFI316EEsyiD/NOOg0EnCY2mdoeWvBZpnUOWjIvwcaCi5jt95s79UVnx/f2TUnDBjIULIyu0hGi3pQ6gxRnoCo4ZDmYCxcr8/mweEdhweRIxca15LYB+8KF2g1MJ9j7HjS3L3gorZx+A5syBmHf2cioiWpIs3c6XHheqUnMYvAMsYp1WzU64COQFKcwOiV20dJimgZOVjC3QNh/NxRja2/eWBfQ00fZvp7rZ2Ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3B2kszBedckSK9t4wJNJKLTYG5uxGwwporKDMUqrgcU=;
 b=J07658cOg2ZMWh7q2WjdBOi6iEpIZuyl/sAXSjLDU0q4Tc+0IsI+6uj+MyWCEPd6x6yu1pJLWDfoaeeSREwtdQ94DOHBoTLyDWr84eZMVlIlWlRocT9sEndH2ZnZtxlfUvd4rz4iS8iL2GtMjqO/kfTRe0Uj+8LozrXvODrFWBFmtZ13LKiz5qxKZFV+lKVYpoo6ReMD7lg6dS5RVTYGRW4aiEFgfvJY5ZroKkzjOzMPU3iGF8pFAzd+X0eTKVbd74Fcs4dZWtxk6akdNsiWAs/zZamGs7WTWmEM9tY7ytFBizcxBH9DzOt5VhDBKa6vS2fnW62z3n+Ff3/rHZ/mbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3B2kszBedckSK9t4wJNJKLTYG5uxGwwporKDMUqrgcU=;
 b=AEl8m/uMNMqxow9ls/Ev3dex08sc4LFI8IEtQ1fgyxKH1CpoKodtdI52HZ3u4LFZd3TkZNSCAiQNXJurLVWunu5a8n92/rc2DPorJu+kfe+4tlhZGqPjci36Z88u6J7MF1n++hYtY6jzv25sawy/SI4/xFdvk4EIl52EqtZaWPg=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by MN2PR10MB3631.namprd10.prod.outlook.com (2603:10b6:208:113::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.14; Wed, 20 Jul
 2022 18:16:44 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b842:a301:806d:231e]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b842:a301:806d:231e%8]) with mapi id 15.20.5438.025; Wed, 20 Jul 2022
 18:16:44 +0000
Message-ID: <028506a9-d5f8-04e9-7427-5a39e0772987@oracle.com>
Date:   Wed, 20 Jul 2022 19:16:35 +0100
Subject: Re: [PATCH V2 vfio 05/11] vfio: Add an IOVA bitmap support
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, jgg@nvidia.com,
        saeedm@nvidia.com, kvm@vger.kernel.org, netdev@vger.kernel.org,
        kuba@kernel.org, kevin.tian@intel.com, leonro@nvidia.com,
        maorg@nvidia.com, cohuck@redhat.com
References: <20220714081251.240584-1-yishaih@nvidia.com>
 <20220714081251.240584-6-yishaih@nvidia.com>
 <20220719130114.2eecbba1.alex.williamson@redhat.com>
 <11865968-4a13-11b0-abfb-267f9adf3a95@oracle.com>
 <20220720104725.19aadc5d.alex.williamson@redhat.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20220720104725.19aadc5d.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR04CA0144.eurprd04.prod.outlook.com
 (2603:10a6:208:55::49) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 057b401d-606d-40b2-0258-08da6a7c0079
X-MS-TrafficTypeDiagnostic: MN2PR10MB3631:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9cW1Aw+daD0o5IlaU/eWB7z7eRs/IXLGF1O5FhuZm8T9KT5chIuXZXCUzj6dmJoqJdCercndePWWBGt5gh1UI8N1hdUk3QB/WeymZ89wxBL8guOD7ANfoHdqvhtII90QylylcBnzShhQ9mmmjWdFCJnlCXZtAvo07wCKoxe6ZN6JdMLrhNoDgDTNWGwIlZjo3RunCBE1ZZJYMyTnPCDLDeivqV//LHsdJxIWVXlMzkzf1gHR80EvHuKm/lMiWX0gYFy2awNzv9L2m+dPRbAzwMA8rX8Hb9f/PVo7qQqYSvG820vMi42Vl/bHNVxLw/R3Kja6jvQdYy+U4qJUj4wXjiwTtcw+8JmSRRg5ycEDCHbR3jPfi73NVmhZGnSG5M2trDacEFQaa/7iiLyE64bC5k+tIQRTDzqv0NKKu7uaxTFRQcKmNWUkqa+XOK4Xup39n/M1fhhvAhGhKj2iycnxVPIGoJSaxj6iCR+sZkNrrrCivyQWYCEtcC8iktPKAgiKJworWIYiYxwD+YMDdue4Lr+3OjC49gsFVGDIkZZK9giF4GxCEhQa8F3e0A61Ak7Sqjp3S4RVDIDSE2v8npfZrQP1BMgWvN77/lgoxiDDIgBWCc2h36IC6li9My/p2C7TKZ1a44arMVRmM1cRtewsF5PAhknoZoiMBZdwBj5vlDyU3y413wY9zRNxODHGydh2/LJnM2Itm2+OBD4+CiI2JLi92k76/5yO5flKRhcnLinyry2zrrf6edVxsBnL+AqHrcHVz9ZHQ8dSPIZwpcZFaRVPJV887JGI/mZjbleBm5s=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(136003)(376002)(366004)(346002)(39860400002)(83380400001)(38100700002)(2616005)(186003)(41300700001)(5660300002)(36756003)(7416002)(8936002)(2906002)(6506007)(26005)(53546011)(478600001)(66556008)(4326008)(66946007)(66476007)(8676002)(6666004)(6916009)(86362001)(6486002)(316002)(31686004)(31696002)(6512007)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dXZjMzVWN3NnVHZqc3pNYmQ0cXNGRXAwSUdZV2xOdmVlV3ZXanV4QU9GVHBM?=
 =?utf-8?B?Tk9TQkFPcEhtS2VrdVVXRW9sT0FvTWUwRG5MeHpiOE9VOHhlb1ZEZk9mTEFl?=
 =?utf-8?B?N3FVMGpWSU03TDVFR28weVhhYkpaYkFuYkZrV2p6VUU0b1Npdy9ydVVZQTk5?=
 =?utf-8?B?dFN6d0xTeTNUbld3ejZqM0VhSVpaRkt0cmxIUklvL051TmdBaUZTQy84ZGIz?=
 =?utf-8?B?bUs4S3VxckRrb0t6MzlHMEp0Qm5GNnQ3bDFlaG1wZjlGdUN2dmQ2QUFXUWU3?=
 =?utf-8?B?L1F4anZnZDdYZy9QUy9YV3puMVhITXJGWnI4VlduTEhqQkpOQ01BUjVwaGdO?=
 =?utf-8?B?dG9oamdlSnNGcGtiMWJIcU90bFYzYWNaMXVrNjBmMUpUTHF5OXhGTlFrb0Zk?=
 =?utf-8?B?dE1ZZGZ3UWFyM1FqTGFpM0Z1RnN2Y2VXdVNma1ZRajI5YnU2NTJRRFJkdElZ?=
 =?utf-8?B?QTRwUEdNNXdFMXpkQ2F4VDEwUlRLQ3BSNm5SRnJ3ckpCSFBmWEd4RG9KQk80?=
 =?utf-8?B?akprNEpSTTNtRGpGZmtPUnJaMy8wTmN5VEs1d2I0QnNlSmNrcVJNb1djb2dB?=
 =?utf-8?B?aitZaTd0YjVzZjQ5SHNwVFU3NEpIYlluZ05JbytkNDRoWElUWDNzSjNRaHhm?=
 =?utf-8?B?cHNndmNXYlVta0ZZZHV1VVM0UUhhTG5vR3NxL0J0QlVjcER1L3IxYm5wOTRY?=
 =?utf-8?B?WS9kdHQ1NjJBeGJOTnZ4akVmZWJWUmkwZHk3YTdIeVFtNGxqSHViMVljUjZR?=
 =?utf-8?B?MlRzekYwa0czZWVOejIzUTNHWi8rdVVqbFMrbHFoRy8yWElRNTE1a0c1UFBI?=
 =?utf-8?B?bXY0anpvQUFHWWZ6TzdxZFNCTE9xQmErZjBiK2JJYys0UjhNMzJsRnRIbDEr?=
 =?utf-8?B?Tk1ZU0FLOWlEeVdlMTBwVGdPNWxWUldQcWhOSDE2Tlh1S3NRZjFjLy9LRFZt?=
 =?utf-8?B?T25FSS9ycVFMaUVJNWNxbkEvYjRVeWo5Z1cxZ2s1cjlLV0owRXF5TWVGZDll?=
 =?utf-8?B?Y0FhMllPeFl5R2VmdnVvcGtzWkROWTFXTW9VY1dDOHd0WGlodmpXcEpMSWQz?=
 =?utf-8?B?Mk02cFVsMTZOdDNvMHhrZHBLNnQ4bTJ4cnZOcnI2NFZSR1FFeEpWQmRRY1l2?=
 =?utf-8?B?Nng0bG9rbWdQTzJuWnFPWDVNNmxNdHFseFgyMGVCYmRzMzRZa002eWtMSWtk?=
 =?utf-8?B?ZWI4d0JaWE9oeHNFNGNabnJUNG1vaDZ0MEsvK1hRRldTZy9lZnBPM2xKVDAw?=
 =?utf-8?B?U2NrSFVZd09JWDFoK3hOZEZQSlF4YXdaSUxFSmcvWnovc0xMUHJuc0ZwNDRW?=
 =?utf-8?B?K1lWeUk0dWhOdVFleFlTdmFINEprOUZuRzNPNS9URDJ3K0NER2locjJnWFhE?=
 =?utf-8?B?a3hTTTlBVFpLQVVuMlh4SDk4YkkraW5LZGdUdzhqSGhFVUdSOVByRllMeFhN?=
 =?utf-8?B?WXFiWjhSWmw2U3JLNklzSmxmVmJreFpqbmUyOERWZHZFcXVGYy9xa1ExMDVy?=
 =?utf-8?B?bEF6MmF2ekJIVEVPSWpibXF2a3BFeUhGeUY3eXN1RDhDOEk1ajV5c1BFQ0h1?=
 =?utf-8?B?SzlTZGVZenZmTU9tVTJSU0tob21TS0xpeDJFVnN6ekluL1NKZUxsMGtXYnRv?=
 =?utf-8?B?RzZWMlBjY3ZTZkJSSkVOOXAyZmxrT1VTaGQvWTVjWUZrVVhJaE1uVUVIOTVq?=
 =?utf-8?B?R3JjU1o5TmtIZjl6M1VIeUlieXg2YVlyRlBYbFIwZVBrS2ZsZzRzWGJJWU5B?=
 =?utf-8?B?UTA5b1QreFJWenZmbGRUbVpSK0tSM0ZtWHZ2a2M3RU5Wei90VldibUE2eGQr?=
 =?utf-8?B?STR0TlpVd0tOTU1SeUZrVkRYNGJ2WlVXdGc5bXdRaUw0ZUdjdWtSaUxqcXhk?=
 =?utf-8?B?cFdhSW9sbjI3VzRKZFFQbE1qOWdTV3VEenZDWTRZcXdXN1FNRWtkK2FmUlRa?=
 =?utf-8?B?bnltRTZuZXJwdFdhQ0ZqOW0ydGxuQStuL0V3bFFvbThnVXdUZitYbm1tR05x?=
 =?utf-8?B?VmJoalJwOEVqb1VrU0Y0czAva3JTcDlpMnpvQ1dQODRJUWI3cXA4Uk5kWVVE?=
 =?utf-8?B?aUFRblRKamZNRXVjNUIxUTc3OUdqV01DVnpGcm5NYUNPY0tKNWlmV2k4WENo?=
 =?utf-8?B?dFRjaHJHYkxCWiswbFZDb3BONXZ2eEpHVThYeWVIMVpJOGV4dXNhV2lMU05Q?=
 =?utf-8?B?M3c9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 057b401d-606d-40b2-0258-08da6a7c0079
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2022 18:16:44.4640
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DLCMfnWvOXAHyVU+xhq8BcTirYCiKBnppY1nEbHMykZz8TOrJ+OY73sJkqFoMJ6NYZKLUHYkP30GIKHGheSf9mbo8dQdAuLdY3uEyv0E5Mg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3631
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-20_12,2022-07-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207200075
X-Proofpoint-GUID: 2z-QvWWzLIwgtVSCvxPQ15pmmdcsOit5
X-Proofpoint-ORIG-GUID: 2z-QvWWzLIwgtVSCvxPQ15pmmdcsOit5
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/20/22 17:47, Alex Williamson wrote:
> On Wed, 20 Jul 2022 02:57:24 +0100
> Joao Martins <joao.m.martins@oracle.com> wrote:
>> On 7/19/22 20:01, Alex Williamson wrote:
>>> On Thu, 14 Jul 2022 11:12:45 +0300
>>> Yishai Hadas <yishaih@nvidia.com> wrote:
>>>> From: Joao Martins <joao.m.martins@oracle.com>

[snip]

>>>> diff --git a/include/linux/iova_bitmap.h b/include/linux/iova_bitmap.h
>>>> new file mode 100644
>>>> index 000000000000..c474c351634a
>>>> --- /dev/null
>>>> +++ b/include/linux/iova_bitmap.h
>>>> @@ -0,0 +1,46 @@
>>>> +/* SPDX-License-Identifier: GPL-2.0 */
>>>> +/*
>>>> + * Copyright (c) 2022, Oracle and/or its affiliates.
>>>> + * Copyright (c) 2021-2022, NVIDIA CORPORATION & AFFILIATES. All rights reserved
>>>> + */
>>>> +
>>>> +#ifndef _IOVA_BITMAP_H_
>>>> +#define _IOVA_BITMAP_H_
>>>> +
>>>> +#include <linux/highmem.h>
>>>> +#include <linux/mm.h>
>>>> +#include <linux/uio.h>
>>>> +
>>>> +struct iova_bitmap {
>>>> +	unsigned long iova;
>>>> +	unsigned long pgshift;
>>>> +	unsigned long start_offset;
>>>> +	unsigned long npages;
>>>> +	struct page **pages;
>>>> +};
>>>> +
>>>> +struct iova_bitmap_iter {
>>>> +	struct iova_bitmap dirty;
>>>> +	u64 __user *data;
>>>> +	size_t offset;
>>>> +	size_t count;
>>>> +	unsigned long iova;
>>>> +	unsigned long length;
>>>> +};
>>>> +
>>>> +int iova_bitmap_iter_init(struct iova_bitmap_iter *iter, unsigned long iova,
>>>> +			  unsigned long length, u64 __user *data);
>>>> +void iova_bitmap_iter_free(struct iova_bitmap_iter *iter);
>>>> +bool iova_bitmap_iter_done(struct iova_bitmap_iter *iter);
>>>> +unsigned long iova_bitmap_length(struct iova_bitmap_iter *iter);
>>>> +unsigned long iova_bitmap_iova(struct iova_bitmap_iter *iter);
>>>> +void iova_bitmap_iter_advance(struct iova_bitmap_iter *iter);
>>>> +int iova_bitmap_iter_get(struct iova_bitmap_iter *iter);
>>>> +void iova_bitmap_iter_put(struct iova_bitmap_iter *iter);
>>>> +void iova_bitmap_init(struct iova_bitmap *bitmap,
>>>> +		      unsigned long base, unsigned long pgshift);
>>>> +unsigned int iova_bitmap_set(struct iova_bitmap *dirty,
>>>> +			     unsigned long iova,
>>>> +			     unsigned long length);
>>>> +
>>>> +#endif  
>>>
>>> No relevant comments, no theory of operation.  I found this really
>>> difficult to review and the page handling is still not clear to me.
>>> I'm not willing to take on maintainership of this code under
>>> drivers/vfio/ as is.   
>>
>> Sorry for the lack of comments/docs and lack of clearity in some of the
>> functions. I'll document all functions/fields and add a comment bloc at
>> the top explaining the theory on how it should be used/works, alongside
>> the improvements you suggested above.
>>
>> Meanwhile what is less clear for you on the page handling? We are essentially
>> calculating the number of pages based of @offset and @count and then preping
>> the iova_bitmap (@dirty) with the base IOVA and page offset. iova_bitmap_set()
>> then computes where is the should start setting bits, and then it kmap() each page
>> and sets the said bits. So far I am not caching kmap() kaddr,
>> so the majority of iova_bitmap_set() complexity comes from iterating over number
>> of bits to kmap and accounting to the offset that user bitmap address had.
> 
> It could have saved a lot of struggling through this code if it were
> presented as a windowing scheme to iterate over a user bitmap.
> 
> As I understand it more though, does the API really fit the expected use
> cases?  As presented here and used in the following patch, we map every
> section of the user bitmap, present that section to the device driver
> and ask them to mark dirty bits and atomically clear their internal
> tracker for that sub-range.  This seems really inefficient.
> 
So with either IOMMU and VFIO vendor driver the hardware may marshal their dirty
bits in entirely separate manners. On IOMMUs it is unbounded and PTEs format
vary, so there's no way but to walk all domain pagetables since the beginning of the
(mapped) IOVA range and check that every PTE is dirty or not and this is going to be
rather expensive, the next cost would be between 1) to copy bitmaps back and forth or
2) pin . 2)  it's cheaper if it is over 2M chunks (i.e. fewer atomics there) unless
we take the slow-path. On VFIO there's no intermediate storage for the driver,
and even we were going to preregister anything vendor we would have to copy MBs
of bitmaps to user memory (worst case e.g 32MiB per Tb). Although there's some
unefficiency on unnecessary pinning of potential non-dirty IOVA ranges if the user
doesn't mark anything dirty.

Trying to avoid copies as iova_bitmap, the main cost is in the pinning and
making it dependent on dirties (rather than windowing) means we could pin
individual pages of the bitmap more often (with efficiency being a bit more
tied to the VF workload or vIOMMU).

> Are we just counting on the fact that each 2MB window of dirty bitmap
> is 64GB of guest RAM (assuming 4KB pages) and there's likely something
> dirty there?
> 
Yes, and likely there's enough except when we get reports for very big
IOVA ranges when usually there's more than one iteration. 4K of user
memory would represent a section (128M).

> It seems like a more efficient API might be for us to call the device
> driver with an iterator object, which the device driver uses to call
> back into this bitmap helper to set specific iova+length ranges as
> dirty.

I can explore another variant. With some control over how it advances
the bitmap the driver could easily adjust the iova_bitmap as it see fit
without necessarily having to walk the whole bitmap memory while retaining
the same iova_bitmap general facility. The downside(?) would be that end
drivers (iommu driver, or vfio vendor driver) need to work (pin) with user
buffers rather than kernel managed pages.

> The iterator could still cache the kmap'd page (or pages) to
> optimize localized dirties, but we don't necessarily need to kmap and
> present every section of the bitmap to the driver. 
kmap_local_page() is cheap (IOW page_address(page)), unless its highmem (AIUI).

The expensive part for zerocopy approach is having to pin pages prior to have
iova_bitmap_set(). If the device is doing IOs scattered across a relatively
ram sections I am not sure how the caching will be efficient.

> Thanks,
> 
