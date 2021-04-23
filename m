Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02518369A69
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 20:51:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232238AbhDWSv7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 14:51:59 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:19536 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229549AbhDWSv6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 14:51:58 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13NIPAlX023019;
        Fri, 23 Apr 2021 11:51:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=hYds0mhHV+hMNWSH9ivlo/QalU663e93OfH7PKBQ6Bk=;
 b=dQ9PPFnXQkUJl/+BeKc4GWEA/KOrq79i2eQTByJRyzMGozlNzTd+748UMAytLgwLakdp
 uh/EsQwHVkemfn2MG3DI25GW8jSLsWpf3/dJKjML6JsRVyOwNsurqWeKm93owuVWOxPE
 G4ioKhs3sY2LlwKh854j8tB6JWUfDb1mQFw= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 383b4q8ayw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 23 Apr 2021 11:51:10 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 23 Apr 2021 11:51:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YOTFvfnQdhN1qYEYcsSSV5TyUYit8oWHGCf/xiBN3StiJ0mA8L4ftI/zMCJb2b5m8niS1FF72+F3fDLlG4smwj6kP6oiUR7I83v+ElP6NBOtF1Gn2pg+QoNCPsOwUZX2jA0PJxSc1XRXxcSe0GIZRojWiOhaOlT4GMqmvw4ZQ3njsmPCtvmvUc2Arc4F/Ks5gb7Q2urHzTin34Xajk1x1lHr8Q0KkQVJpBlB/K0Fk/6VSiMp0Qr002c091jZ0OPXqdTHfREkfGP2ihaz0TWki1sm5C0Imm/OdwkescrGVWF/sL69QDsMJBfhq7bJOcq36Mglt9zs3dObJC56Z99/iQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hYds0mhHV+hMNWSH9ivlo/QalU663e93OfH7PKBQ6Bk=;
 b=jAyoa250hNOxyenW6Q5dGmLXektXfFK5xii6zYSWTWppNWNhrNGyvDcr734H9otQfThBSf4ICss5Iu272z6kvWkCNjCpMQF+IRnVN0+yQlVGUIXveOZdAbCnL08PWq9RBLAQNiB52ohlDp221viamyXacVMcnhuKjPjcMNhONtyG4LJzNBXW0/SBcrfCDu2D5pa3wGmPsIW0RxKfDwdh5EWNela0PvC4YQKHdl4lqxLv5Fmb1gXi2SFiS9FMf5NLWf/Z0RQQs8ZFPe53aSSoPPCacoP1mz1JmnV3hM6EumSIqy0fuUqX8jLekWuzh2ui3Af7r4TBI4i3wV5fu/OvCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA0PR15MB4016.namprd15.prod.outlook.com (2603:10b6:806:84::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21; Fri, 23 Apr
 2021 18:51:08 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912%3]) with mapi id 15.20.4065.025; Fri, 23 Apr 2021
 18:51:08 +0000
Subject: Re: [PATCH v3 bpf-next 18/18] selftests/bpf: document latest Clang
 fix expectations for linking tests
To:     Andrii Nakryiko <andrii@kernel.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>
CC:     <kernel-team@fb.com>
References: <20210423181348.1801389-1-andrii@kernel.org>
 <20210423181348.1801389-19-andrii@kernel.org>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <66062c52-2738-f001-c04b-30f1fee22000@fb.com>
Date:   Fri, 23 Apr 2021 11:51:04 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
In-Reply-To: <20210423181348.1801389-19-andrii@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:bc07]
X-ClientProxiedBy: MW2PR2101CA0001.namprd21.prod.outlook.com
 (2603:10b6:302:1::14) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e8::17f2] (2620:10d:c090:400::5:bc07) by MW2PR2101CA0001.namprd21.prod.outlook.com (2603:10b6:302:1::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.7 via Frontend Transport; Fri, 23 Apr 2021 18:51:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 87be7f66-3a87-4dd0-aac6-08d90688c189
X-MS-TrafficTypeDiagnostic: SA0PR15MB4016:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR15MB401699DCDB52DE41EF914D37D3459@SA0PR15MB4016.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:172;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W0oZ3zqMPRv0eP2Ych9MEdf89Zo/PQPrEUBZIi9iX8gGzqoQankOhzm+9UFcJSLj9yVvEZwliEW/lbOmD5A9ZdLKZfR7pb75/3M8HWynlvHn+PB9oKhS0bunKDP25GQCCtq2KL17Aq49l8sDTWoVJmIfOJ8+YhGKLgnwOQykJxD8V7yJY+b+cz6HbR7xNaGCwMKg+dS670JUyvml4o4qdXUBTKUbg+L2R82iAyxjzdjWlIqJPtU9ZM8fh7eGGWzfU1Qj+fPThGKR+0G1+bjzDnXJwKPY1E00hPFjUoeda5uwUj5NzO53idS8CMX8klRFpXFyaf8NQb4XiJJ1WNz1HUFnerO4l+WR099AIafK0uEhA4y+cOeCKfjcmdBQ6Q1b2YdS10iSa3VkOsBkiQGJS2LBme05/+c3u4vhmW6yfuxM9KDAJj4QLvnx0rjNvjD9JxrIAba51ePZrPOOQJPWSAuCl99bI+EKYdb7cWLLX37paYuKUvdSkciGkWKtZwXu1xrId21wuyAc2qX72u2vB9OqNTnkJvN0rkaC8G8qceohAaSrtmeV64NNZPrSTA0W86Z54Jybb9p6pHzMJD3lRNmBNx6M38pfWrC5a2gG2iOCD7FLEzNNKfMZB+5kgFp2DNP8XrxeXj9wDLSJxbK0zoHOXfrInCMna/dhMNZa+qRr1BkWCD4XzFMxf6VuP9gn
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(136003)(366004)(376002)(346002)(52116002)(53546011)(316002)(6486002)(38100700002)(36756003)(4326008)(86362001)(8936002)(558084003)(16526019)(478600001)(186003)(31696002)(5660300002)(2616005)(2906002)(66556008)(66476007)(66946007)(8676002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?L2xxOVBQR0lUNE5ueStxdXVrTExwUEpickNmbW9uM0lRMG11TEpGUkFmTjBN?=
 =?utf-8?B?M1Y5MENJNVRmY09TbDhZSXdXTHoyaDRLNW5CeXg4RDc4NEhpSTNObHNEQlhk?=
 =?utf-8?B?SDZSTUowUVFRaXVsbzAwcGRJVmZGcFoyRWRKQnJNbTFqN3ZXUmpNNldXdjJp?=
 =?utf-8?B?bmNXenVNTU15RW1CTW0vamJ5eXJaNUxQRHFRbzJJVUI0WEpOZ29TRlJtbFRq?=
 =?utf-8?B?TS9mN0dRNUtaQXBZUFJLaldPYXlBaVJZdXc2ZzBJTUxOV3JibW5OWWFGeWQ1?=
 =?utf-8?B?dXFLV0xUOXFqY05FQnIzYUxkOThBUTY4Z2V0cW9BcnBLM3REY0RtSStRN2Rm?=
 =?utf-8?B?b0lLanBhcGsweFZWNmZOampjdnpLOWtXUXMwWGY5QTA2R1BiQXNNVnp1UWlC?=
 =?utf-8?B?RjVHRkhzU2MzVFBKdmJPcGFxZEIzRWNXOU9SOWRFKzNxTFVDT3Z2MHFmalBz?=
 =?utf-8?B?SmNrM1dLZ0lkekU2WEVaQnk3WW94UXJoTFNtN1AzOTB1enlQdElISDJEbURW?=
 =?utf-8?B?eDVmWERDcDNQV05YRXcrczQ5czUrTnJMS0dESS9CcjAybDZ3L0Y2dGJpckVT?=
 =?utf-8?B?VGx0akk4WkMvRVFHT0tWczhNYTFHS3E5dGVDRDVHa3p2SEdGQmJRZEtwYkk5?=
 =?utf-8?B?WGhXMEtBUHVYWnFiYm5zZlAvOXdKOG41OXp5QTZOaXR3b0l2ZnE3N3JqYjc2?=
 =?utf-8?B?TDN5bkdYWmN6ZHIxZXRWR245dnJrWDhpazJORVlBMHVYdEFnVUpUS1kvZkRw?=
 =?utf-8?B?eXIyZGJYTFpaSXRoQ29OOFhma3N5TGg5S2Y1RTZ5ZWxNV0krZ1VDMU1RM2hT?=
 =?utf-8?B?YnoxSDJTUmpBV1RrKzJLMUJMQkNCR3IrNGZPVHp4SlZEelNHOGVjZnkxTVN4?=
 =?utf-8?B?VytGOG9JQ3lKOVNFTHNUOTVQc3lncFFDdU5ZT3FDNWhzeklDdGh1eUd2MVBM?=
 =?utf-8?B?NXpwcGd2RWc5ZW9NNFc1a05yczZVT1VVTVZzWURxdU9relpNRHA4d3l4K0tV?=
 =?utf-8?B?WFVFczMvMUYrWUJBQlovMmthUnlRSFVFUzlwMEtUTnVHU0pRcmhpT2pzM0Fo?=
 =?utf-8?B?M2l6eGVDcU5FM09qUnpLaHhXU1RxUElmQjRXWnVWaVJmS1JDd0NxbjJJeHpI?=
 =?utf-8?B?RU1jZ0ZSeUh0ZVFWS25LbHZRbGVXa3BOUWV4YjB3OEJHTkNUK25FMFNBeitI?=
 =?utf-8?B?TFlQbW1CUy9MNnI0L0N2d21zMnJEUis3NFZxdFFaWElmSWlBemFDYmZJZG5F?=
 =?utf-8?B?M1JDZTNjMlhmamRMbTJlVkFlVlY1dWFQNW8xUEFLdGhIVGQ2bnhlM3FtdVNv?=
 =?utf-8?B?SVkxRWxyQUVIQzhuOEU1V1pkQjNaa1AwU0Rld0RmbExrZHBUTWd3K242R2ZP?=
 =?utf-8?B?d2FhVU9QUHk1MkZYZmNiNmhiTjgwRytad1NId0VEbUhXY1M0Z3B4R1FLdHlP?=
 =?utf-8?B?NHpGckNSN3RxNU5wN1o2WVROS0VlUmhDQjRhSjNZWXhnRHZOMy9yQ2ZFVGxO?=
 =?utf-8?B?Z0FwY3B5bDJBWFBrVzJ5MzRTZ1F2SEs5N0pzZFZtUy94OHA1THIwKy9Qd0ZH?=
 =?utf-8?B?VDhKRFozYWNtbUtwcTlQbWx6SjZVTmxGNGQ4QzlvcG9MWHJHZ2FjKzZxb2dY?=
 =?utf-8?B?ODlFWGt6TFVjZjFHakdURG5CQmZOWTNmNFlORWZsWG9RVXRQU3Axem5OYnJS?=
 =?utf-8?B?Y21jUmdHakRuYUZFbGZZY0lwMzhFUjZQYXNyeGJ5OFN0YjRiOUxYV0lXNVFS?=
 =?utf-8?B?RG01dGt3NlhsQ3d6VmVhd3R4Z084dzRIa296MHVKWjZidXFOemZYSUtKbm1R?=
 =?utf-8?Q?LNamdSHCQNxAsNPvNYIoVBB6Nzt6EszcKfyRQ=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 87be7f66-3a87-4dd0-aac6-08d90688c189
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2021 18:51:08.2729
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TvURwmqb7BgNXMVo+kmOwYwf1orKyFL0mACHwG+7o3QiyrPrSAtLCiT8fa0b+IFd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR15MB4016
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: qQXmhMQ7gQRKErE0PHjKH4Wt_lwCDOqM
X-Proofpoint-ORIG-GUID: qQXmhMQ7gQRKErE0PHjKH4Wt_lwCDOqM
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-23_07:2021-04-23,2021-04-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 mlxlogscore=886 phishscore=0 impostorscore=0 malwarescore=0
 priorityscore=1501 spamscore=0 mlxscore=0 adultscore=0 suspectscore=0
 bulkscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104060000 definitions=main-2104230121
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/23/21 11:13 AM, Andrii Nakryiko wrote:
> Document which fixes are required to generate correct static linking
> selftests.
> 
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>

Acked-by: Yonghong Song <yhs@fb.com>
