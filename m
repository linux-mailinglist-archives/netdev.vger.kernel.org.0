Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1C52341251
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 02:52:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230194AbhCSBw0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 21:52:26 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:48588 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229680AbhCSBwP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 21:52:15 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 12J1lTS3017549;
        Thu, 18 Mar 2021 18:51:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=azalNHHLzA9NbPZi2oxNrvsD1w2GKCYmimG+19caZ/U=;
 b=HUlsbVpagZDbOsOyvsGXoqznl18FPPX2xKck9u6abKMWzstyjIOz8UWKt4eUjdZvM0i9
 BoH3Oc1xYaQkHPXpBox3HaIus7LQmoUXCW6iR6XRmWo9t+/5SUNFN5FmzVxYkQjLVZZl
 t7gBlqfywVHQFQB+9hDTfSEAhh1MXkv4eZs= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 37bs26r4n8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 18 Mar 2021 18:51:59 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 18 Mar 2021 18:51:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hpj9Sw+sOipvt++xF7E9TkU5P5sbaki7QWtPfqsa4NMIKrxRW1Y34a9iCeYOge9n+8mYzoswJaNwH3z2u8SDHlqOF7x3MTBjeCrD0n/HiPjax8qsFYMpYzQa46icQZ43pQvadmMQOeT/xQW2fRu0Y822SETEpqgS0Rn8ENjd++PMr2YZlCyW1Siq23+XzqMOLZL9pbSeZZw5i3Ge+RCWzZUIQCSPP6JF4HAeWMVSILU41p6+xk1JnyOFkmBsP5TMpC7zOFGQ7IHPY8jFp1LmZ3LwQ2CmBZNSbUJyMJY3+4t39NVwxxOiNW8T+JALowYId0Hin03I7FF55YYsUlpVlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=azalNHHLzA9NbPZi2oxNrvsD1w2GKCYmimG+19caZ/U=;
 b=Atb6NMIq8WrujKTsx8EHCvsm9CRn5u50b3/BbIrQU2xPylrV6Dp5d2qVfxYd3O3YsRCsZUUdVV+Vs6p00rL6TLj4cdvWiA6dChsIdi+Gc8ZvE5620TR6+6AFeV6sMSkT3yxzZShBMV82wOMlP0HRmfYLfDipOuqqSf3DxMJZB2yaTH+wAjn2cXzyiY9I5fB0IZLASdaZ0HZDayQLQPJBbyGG/NKg8KdiOLGsS3EB41SAJ524QL84S2Qu/pFli/CQrJwpfzJyL9pFt2yJQp/xJwYvo/YLUKemt+WY4uC6FB/vPrO/SJviuhXcWZBvW+uex2P6Y9LYBkBpQlQOtAPozg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BN8PR15MB3282.namprd15.prod.outlook.com (2603:10b6:408:a8::32)
 by BN8PR15MB2978.namprd15.prod.outlook.com (2603:10b6:408:83::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Fri, 19 Mar
 2021 01:51:53 +0000
Received: from BN8PR15MB3282.namprd15.prod.outlook.com
 ([fe80::315e:e061:c785:e40]) by BN8PR15MB3282.namprd15.prod.outlook.com
 ([fe80::315e:e061:c785:e40%3]) with mapi id 15.20.3933.032; Fri, 19 Mar 2021
 01:51:53 +0000
Subject: Re: [PATCH bpf-next 04/15] bpf: Support bpf program calling kernel
 function
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>
CC:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
References: <20210316011336.4173585-1-kafai@fb.com>
 <20210316011401.4176793-1-kafai@fb.com>
 <CAEf4Bzb-AmXvV+v-ByGH7iUUG7iLdFxWeY1CJGB7xKHxuABWUg@mail.gmail.com>
From:   Alexei Starovoitov <ast@fb.com>
Message-ID: <70f08dbd-94d2-79ed-d764-0849d45f662b@fb.com>
Date:   Thu, 18 Mar 2021 18:51:49 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
In-Reply-To: <CAEf4Bzb-AmXvV+v-ByGH7iUUG7iLdFxWeY1CJGB7xKHxuABWUg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:e846]
X-ClientProxiedBy: BYAPR06CA0005.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::18) To BN8PR15MB3282.namprd15.prod.outlook.com
 (2603:10b6:408:a8::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:2103::3b8] (2620:10d:c090:400::5:e846) by BYAPR06CA0005.namprd06.prod.outlook.com (2603:10b6:a03:d4::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend Transport; Fri, 19 Mar 2021 01:51:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: beac4461-e035-4e41-1b75-08d8ea7991a7
X-MS-TrafficTypeDiagnostic: BN8PR15MB2978:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN8PR15MB297811EEF9A6346D91D9007CD7689@BN8PR15MB2978.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fv7NbRMaSKg2uUmoVxuAhdHZ9tb2e4nRe2RBJSWv0OoXDsV4udzOkN1RGWNbGW5aC9vImmNSGOx7Y7zZSugKZWwLKa3XuC7Y9rOPfmLw10P8LoYdNa6vcniy4oUc/nr5XB8lYxEbZx9ncdAJkjDJJREVhmnaz/z+dIUUgqQX7X2N/1dAO8pA6M/PS0GWbPCgaWFaUHgDvAWmsOWeNQqWukp0DsuXJhW8vw2C9z+WPSYej0CLP4eulGnHMO2KSnMVZoxMOsXHamYX9GLD9rvcMYo005/qa2DsbwKNN1Ipf1vq7nRPPBog/2iRd8z/lEKTiUEiNY4vmTrqeQFY8UUgeG8sLtXThgJ22iGi2dqDyhy1laMhp4ngymRoiwwvfZ6bl4WCc1m4p7JwM0TD0w9tZc93iu5hCnJzYCdEtpWOPe7k0CZCegLgBwZa6rtD5QeDcpXfbvufzGFO6+iamuK071Jbajj1Tb22MRZsOh3S1dJWwRKqxkdv2ChC+K6EVYEXxlBCCy01k4g7qMkNL8xcoXXhWUOw1BqBGj5P/efCSUEmCKG+EkCCwRvdq5vYtOhitvEfKXRFAyW9fS1UDeAxe+Gi+qcLxBL9P4wRTjWl7VyemK6GIcrAERZCzSdzwMRNcOJ7m3/XkXMojGbd0rHjTBjIgJglW/LbB001O2KwkgOyEpsZVIR8PMb/yoLuE8X/xdqf+8KWnP/63TorcwlH4pudEIUNBtWehotkDWlca88=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR15MB3282.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(39860400002)(396003)(136003)(376002)(366004)(6636002)(8676002)(4744005)(2616005)(66946007)(4326008)(52116002)(31696002)(86362001)(66476007)(5660300002)(66556008)(53546011)(2906002)(38100700001)(186003)(31686004)(36756003)(16526019)(8936002)(6486002)(316002)(478600001)(110136005)(54906003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?ZjhiODU1MFh2SEdCTHk2NmFQVm1nVVZaUHVCOWR6WHZFWU43UGptWU1YUldv?=
 =?utf-8?B?bXNSZ3RtakhWWldseDE2cWJrSGxQcERRMGN0ZXZlbkwrdjI3WU5zeHZYN2Ry?=
 =?utf-8?B?RjM2c2Fya0xyMWkyTEFGSDErNEJYZW14MTJXNmt1T2VHaXpLNUlncFpFQ09w?=
 =?utf-8?B?L1hYWnpnWVlHazMrQmNBZG9EKzZDSktkWXZ6QS9seEh6MDRCT2RVTlpxN2Ru?=
 =?utf-8?B?K1BxTkFOQlEyeEc5ZHk2Yis2U3h6akFNbUFMRFNwdk84UW5pMXNLNWVlV0ZW?=
 =?utf-8?B?dWdycm1CdDQxTXh1cUNhaUY2aURUc2ZuOFFoVTdwSXBGSUorcCtVT0xHUW9U?=
 =?utf-8?B?dHBwL2Mvdit4QmRYRHdlMmthRnFmbW0wVmg3ODcrY3R3aThpRVB5a1BuUHVS?=
 =?utf-8?B?eG9WVk5XSXB5Und4d0V2NHFpZzYzemdNbGh2Ymk1R3d3YkNrTnY2MW84VDB5?=
 =?utf-8?B?QlRIUmQ4QTVOcTFHLzRUeDhlTzBlS1I5S2dwcE0xYzMwNkpPZU40SnhWekx0?=
 =?utf-8?B?SjFRSWR3bndMQis0c2xteHc4QnVGTzdxZ1RBRkcxdUt0ZjU0b2NDcjZFTndp?=
 =?utf-8?B?WnR4TjRLNzk0a3lLZ21QRUgzMXRKdDFqMlJXRU1FaDNQQndocjE4VkRZSElF?=
 =?utf-8?B?WjZYRjJjcFlnRzdRcmJXRlFBeXBDell3VEh6TWFWZ3RWL09MdHZ3cndadXJa?=
 =?utf-8?B?M05IQVdqWktuK3RmRko2ODhFL0ZSWmMvYXVmQ0pDVHlyYzdJeVl5cnhHNzRG?=
 =?utf-8?B?OVJsSDd6ejdIYVA5ZmZyeTNjRzExMjU4bnoyTVRHNitLNkpreUM3dytlTkta?=
 =?utf-8?B?c2xBSXB1Mk9tSHBQMTVpUEtFSjFBWGlTdXFaS0dFcnFtMzl3MHNDbDB1N2gx?=
 =?utf-8?B?TS9DZU9hSlFpdFZtU2VkcHVLUWxNM0hVOHdoVWtPUW9TbGROTHVSaDBkVkhn?=
 =?utf-8?B?SkJpaXZzeXRZYWF6bzhKMlE3U2lVbnBqcUgzRG9lZDBEWDhJcC9DQ2NDa0JZ?=
 =?utf-8?B?QmJqK0xsb1RGNFZEUFNtSzN2U2tOOXF5OHlHSjd0cHhpUXJmaU5UNW8vUU55?=
 =?utf-8?B?eDdKNDZLbHdGemI2bkdzcEZNREZOWVc2VU0wQi9ZWE0rNHpMa0FEQ2RoSEVQ?=
 =?utf-8?B?aTFvVWk2WVpJS2FuVmhxQ0dvL2Jaa3N2dUlqRVJTVWU3SkFPTys1eXZzUWF4?=
 =?utf-8?B?dEVveXdJNmJBN0hmU0g5STZqaFdSaE1qUk5KelFrekZNelhWOU9MZ202Vkk0?=
 =?utf-8?B?aHZpUitWSGtwYTR5aFNoRDkvdlRRMmFDTDRVRXdYcDZuODg1ZUROaWtqQkFo?=
 =?utf-8?B?VXA1ZkxveFZTSWI2eTJUMjQxd3hYM2dSQjdRVXhLQ3Fndk9VcjZyYm5JeVc4?=
 =?utf-8?B?VTJ3QTA0N0xRQjVUTldpejRDMW95MENpaW5jRnlKNzFUanpqK3R0bjZyOXp0?=
 =?utf-8?B?TXhlakhuN1Ayek1GczQ5WVFRNHN1bkV2MGZ4V1RZcUlKQ1dabGhnSDdUWEcv?=
 =?utf-8?B?eW9JVTExdGRnSGZPN1pydXNRbURyRCtXNmZYY3J0MVpqWnN5ZzlSUktCSlVr?=
 =?utf-8?B?U1NVZm54QjhXVGFWOTdxQmUwNzRiYjMxSFUxekJGQVl6K2RxL2wyVkczalp5?=
 =?utf-8?B?Mk43U2x5Y0FkV01ueDQ4eUQxZnVabG84WU5IVFRvZHRTa1BRYU9FV0dRL1Yw?=
 =?utf-8?B?RGtPbWNpdmhIVUtBUzFRaUtqNTZyR0RLVThxcXJQWjdMMnF4UW9oSVdsOHNV?=
 =?utf-8?B?MUcwS0hVbEdMUk1oSGJDVGxBdXNNR3dROEZFVkZ5bzBmT2kxaHI3ZlFlUlhm?=
 =?utf-8?B?UVAwdXhsMm1lOURQZTBRZz09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: beac4461-e035-4e41-1b75-08d8ea7991a7
X-MS-Exchange-CrossTenant-AuthSource: BN8PR15MB3282.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2021 01:51:53.1963
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZLywrNgF8bZlUXrqtfVeSgaObBguZMH8YmMQUQdJKGWfTipG2QxYv2dvCL+GV218
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR15MB2978
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-18_19:2021-03-17,2021-03-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 bulkscore=0 lowpriorityscore=0 mlxscore=0 phishscore=0 suspectscore=0
 spamscore=0 priorityscore=1501 mlxlogscore=999 impostorscore=0
 clxscore=1015 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103190010
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/18/21 6:03 PM, Andrii Nakryiko wrote:
>> +       desc->imm = BPF_CAST_CALL(addr) - __bpf_call_base;
> Is this difference guaranteed to always fit within s32?
> 

we have this restriction in many places: JIT, dispatcher, trampoline,
and bpf interpreter.
Modules and kernel .text are in the same 4G for the same reason: 
performance.
