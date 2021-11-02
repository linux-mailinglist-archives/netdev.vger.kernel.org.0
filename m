Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6898644247C
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 01:06:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231501AbhKBAIm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 20:08:42 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:61120 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229497AbhKBAIl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 20:08:41 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A1GofLl017091;
        Mon, 1 Nov 2021 17:05:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=bY9D0zdAuDHiKAqo5vcyO05PYzk287U5Yw0AizRMkWE=;
 b=TvM+13lFAW3x5GowFoaefiNOC9T4NVHni1WXXjezToJ8sLHJH9x3jrpdgH/ky7tgjfRa
 y8Y5XjotuQWm4p2xuB7B5FMiT6QgLF4ecO7R/2SQDtIHWyDRsspzc0CxxOT6CBez1Oc4
 JI4k3h2QX1iRs4Hy1VdE3A66YBSIy28G7l4= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3c2da3dhhq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 01 Nov 2021 17:05:48 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Mon, 1 Nov 2021 17:05:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J0vhzGW9s+eubAP7zYFEave243Cf7k3EvWSfTpyKodS53mejLwPCxpfXKysam2U7+4FRTixf2gd9FrIzGqhdNRZXxeTpmcMZ4vzPa/I6DgN5YLcADTsbT4gYEdCW985JQ/URbSyYo5ylYSCY50hytsJpHJtaDUceT/S1Q3uNsa147WUGlBuPY2WZKMbAp/phezTdjNizlvUAz7s5lx3aWHQtlPgu+4h0eU8hOtgzmlA9PG6lRYP/j9KrPIn7s5NTzYnU+4oeShGLIM0SXsMvCLChthUuRMzDrxAYidXl8O97NaU4zQyQRO8MWmFQTkZmN6OmnPYtKDYFtXnIOMX27w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bY9D0zdAuDHiKAqo5vcyO05PYzk287U5Yw0AizRMkWE=;
 b=lbA39bJiWRBkLwB3q8w4gDqBfkg2bi3QiIbMEO25ba3utlZtpL0yw+E87DhHExIaiotW8NeyIAGscifyHT1ER0M+Z3oLXKkFGVXnbEwuu0QHO+cupoSvOCvdT7YrkdMMps7/cxjNtVoBqEV0esZ7e8tkoGcsS3xMGI1SUkVQWER1sxKgaE4H+PprvqLZ5iEjoYP86CwMoKOboATBxuBWLB/UNAL6wHzq3fDcZeA9Y69TKjQ4o2mflx4HnzUUiKcs0aZU8fJBWNdsOAVGz2/dATCHsdI3L+TAvmuzz2XMMSBMV8IpX5gwREKCLDzf9qV8owjrXBxS+GN+OQtz/UmJ5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fb.com;
Received: from SA1PR15MB4465.namprd15.prod.outlook.com (2603:10b6:806:194::23)
 by SA1PR15MB4806.namprd15.prod.outlook.com (2603:10b6:806:1e1::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.17; Tue, 2 Nov
 2021 00:05:45 +0000
Received: from SA1PR15MB4465.namprd15.prod.outlook.com
 ([fe80::853:8eb0:5412:13b]) by SA1PR15MB4465.namprd15.prod.outlook.com
 ([fe80::853:8eb0:5412:13b%7]) with mapi id 15.20.4649.019; Tue, 2 Nov 2021
 00:05:45 +0000
Message-ID: <98419416-0239-2634-b749-18beeb0dd50b@fb.com>
Date:   Mon, 1 Nov 2021 17:05:40 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.0
Subject: Re: [PATCH bpf-next] bpf: add missing map_delete_elem method to bloom
 filter map
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Yonghong Song <yhs@fb.com>, Eric Dumazet <eric.dumazet@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        syzbot <syzkaller@googlegroups.com>
References: <20211031171353.4092388-1-eric.dumazet@gmail.com>
 <c735d5a9-cf60-13ba-83eb-86cbcd25685e@fb.com>
 <CANn89iLY7etQxhQa06ea2FThr6FyR=CNnQcig65H4NhE3fu0FQ@mail.gmail.com>
 <CAADnVQLLKF_44QabyEZ0xbj+LxSssT9_gd3ydjL036E4+erG9Q@mail.gmail.com>
 <CANn89iLhta9E+cucGOTDNLtqXF=Mrxem=Y6wthh2ODhnALrqoA@mail.gmail.com>
From:   Joanne Koong <joannekoong@fb.com>
In-Reply-To: <CANn89iLhta9E+cucGOTDNLtqXF=Mrxem=Y6wthh2ODhnALrqoA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR12CA0058.namprd12.prod.outlook.com
 (2603:10b6:300:103::20) To SA1PR15MB4465.namprd15.prod.outlook.com
 (2603:10b6:806:194::23)
MIME-Version: 1.0
Received: from [IPV6:2620:10d:c083:1409:25:469d:91d7:d5f8] (2620:10d:c090:500::2:49c4) by MWHPR12CA0058.namprd12.prod.outlook.com (2603:10b6:300:103::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14 via Frontend Transport; Tue, 2 Nov 2021 00:05:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 74ec4f94-8f41-4d5f-0a39-08d99d948446
X-MS-TrafficTypeDiagnostic: SA1PR15MB4806:
X-Microsoft-Antispam-PRVS: <SA1PR15MB4806C3F92DB0C734B22D5992D28B9@SA1PR15MB4806.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AcnBh0yQ3tHhmtZ9/QKIhTfC8h5aDvu9DZo1aKcAnYUAQTPWnvzJkVvCXj/0umtpmT4kyWFRN5mP1WJlbcH3yXZKVAn6Rroenn8CSbIFqLCVOPOudD2JbrAMYHWvyOA7YJScYkLtVKGmUiS9EwaPpaSW3Tu0H1H2a2xWOwhlJDjVccSHyyPt6wI0AliB9mjo00N/0TH78kzhD0oj2zNr5idDDjCwUgm5/ykwqx4d73qYv1msqyCXOhqbYx13HP4YhTzKBMqVOq7KxBrLMxXYnjQtAppDtPtu4iPRQptxfAniK8OZ+mUllAt9AytjP3QG4H4g/WIBsMK9evWfOCQkv2MZG1wovyAtj3E7aMJJBcJmuLFUghQ3pBDHGYoI8CGYIQVCkUkebpuo6sD+uLrj/biE6kWp77fp1u5Hkej0yB/zg0oRjiXO1o0i9Fwd6TbC62UkJuUIdg7adCowdQVe+eSNUAz7+FHQfP/j0lpoRhAGwtZxTJxElwtBH9P0Zlrtdv8RG06UX0nWKOYZ39wtYl49vJl07RHbWRSvYtd4iwKxcL/Mv7ZD21AnjUXjvzONYNkRrv33SY3pNMswNtVRSlFZJlyWlm0cud+4kuaTYBiHP3IUM4cMX1AvkNGze18fufTMnqru3u8tiJSli9EFDM/627/ogy3sFs4RtF/IhBEd5Pzni4haTApxq147Mm/WekMtB9PQcYERwJWGlIe5d4+MANGL+hF21/0o3+2byDk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB4465.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4744005)(5660300002)(86362001)(66476007)(53546011)(66556008)(66946007)(2616005)(508600001)(38100700002)(2906002)(6486002)(7416002)(54906003)(110136005)(36756003)(316002)(8936002)(8676002)(31686004)(186003)(31696002)(4326008)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UTNJQUZXdnp6aW1BYVZwOENQWlNHb25FMExGdnkyV1R5dTRlRnU0WGp6NE5o?=
 =?utf-8?B?UG84d3preTQ1Wi9mL0d1SGJMYlZ4RmFpeXMwaGFQSWlRQnVnWU9yRnR6QmVn?=
 =?utf-8?B?Sy90VlFWQ2t2dytMUUY0eWNZcEFWOXdoRSswVktqSkVGN0paR3psdzVwWHZl?=
 =?utf-8?B?UTUwT2RqS2J4NUFLRDhMT0pWcUhCVll6RUNvZWFGRFkyMlR3cm80ZXlYUVNy?=
 =?utf-8?B?Q2NIYmU1cTRsM3Z5TW9kdDJ3eXB1eXhEQWRYTFROTnJHVFNNTk0vellqTmlv?=
 =?utf-8?B?cnlWVWVyemIxaDJwaWZGZ0xTSnpIb29GSWNHaHQ3LzVJR0dzUThha0F2NkhX?=
 =?utf-8?B?bHJubTV1UXNGM01NSWoyN0xxTUJPbFY4d0N4QXZQVXBwTVduV1NFQThJQ2lm?=
 =?utf-8?B?RDQ4Y3ZaUTlGRHI2Q2FDaTBMcjRLbDA2WCtLNjZYaFZqWkxWblpVWlVWMmxM?=
 =?utf-8?B?SjlhRGdOREczNy9QU05DZkZDMEhMUWNDMFNGUEs4NUI2cG5PS2c0U2dQVWRr?=
 =?utf-8?B?ZFQ3eU1BWTgvMGN3V3hJVm5zSWFHb0QwMDhMM3BNcmxvYjdvMnlhbXlXTHMz?=
 =?utf-8?B?NVhXQjNQSHdkTWFtUXZvaHlhWjJ6dGNMMC9PVmJxcXZIL2hXaHhXTXUzemVn?=
 =?utf-8?B?RU01eFEwUG4xNWt5YXBSc01YcVNjTjFlR3JHV0lqNzdNUHZYMjBVTzBMaVhX?=
 =?utf-8?B?d0hRelFPMzVtK1hEdXBTaXJUMGlPTG4wVDZ3K0VBeW41eUlyL3VkQ0sxYmx1?=
 =?utf-8?B?MjI4b1VqTHBsOFlVWTQrNkVjM212cW1kcnpqUGNCQy9WcGFKRFNPNHhHTmF2?=
 =?utf-8?B?Rk1XNE5EU2xhbTJjUWZwQVhvSUJNNWxhU1Z6VEdtZTBCZVFFK0FDZGlNWGZu?=
 =?utf-8?B?d1BXOXJNeWJBVWYxc3U4aG54U3FPTnlWN0oxZWp5a0tXQmQvSE1qSERkYzVh?=
 =?utf-8?B?Qll6UHBDbkdXRHhSYTVIdWh3dVczdnhMcjRockRnaGU5VnpVaDU1akRmcnE4?=
 =?utf-8?B?TldSZmdpVFo2NFlzc3JkVExKbTEraHp3dlp6NDB5VTJ4L0w3VG5XY2lnUkMy?=
 =?utf-8?B?d3UrQXJ5UE5iL2Y1WlkvYmxiUlhGbWtVdTdHSnUwNW1iRHNZVW54YzZkcVVl?=
 =?utf-8?B?aTdtTU9oS2NDUkUyNWsxbDJRL2czTk1HTHQrM1ZLRWg2U0c2bXhlUUNVMkEv?=
 =?utf-8?B?NWZFMlBiRmhNVFNPTWVzSnhNUXJhNTQzcy9wQjUrZUdrb0RObzJucXorSk80?=
 =?utf-8?B?b0ZQM1c3TUFQeTFOemU4SE0rd21SelU0MVJiU2Fya0ZmNHB2b29KYlJPYmUw?=
 =?utf-8?B?ZUM3NEJ4aWNiclNDZk9ERm9IendwczBBZzl0RmRvZWpSYjVrQ1hib1lFalpq?=
 =?utf-8?B?VFc4akIxaFlpUEc0a1R5NHZ6VWticFBqN1YwRzNzVVJIeDBTMjdza09uZ2Vr?=
 =?utf-8?B?WDRMRFB0WVc1akp5bTU5S3Zuc1c2bWpvSFNTUE9FV3VzQXNGbFQvOGZNUlUv?=
 =?utf-8?B?L0IyYTlFcHBwWWR3RVdiQXhHemcwbU1VYkZmTWFlbGVUWVlFOU9qVUVJbkNP?=
 =?utf-8?B?aHJjMzVwZy9majVWOWJLTnJyR1R3cjMzMFFZbWU1Z2c2d20wWTN5ZlRkSi9z?=
 =?utf-8?B?NUVsUklqQ3k3MXBXdFYzUENIQVp6UDVGSkdwSDdwaFRsRUlOSnFJdVZHRXZN?=
 =?utf-8?B?SktqWUVpajBiMldOUVFiK3RvWlpDaFhvWTBoV2R0UmhrbHpSNHE4WHRUZWFT?=
 =?utf-8?B?REtrTHExSzR5WDdxd0lFVmZONjBtUEF5a3lJRTlaODJjdlB4MmJja24rOWxY?=
 =?utf-8?B?bEx5dVZOL0ladDdTWk0vak9nVkRmbGpMczhRSTJRYTZQLzF0Y2NIOGN6U2Jy?=
 =?utf-8?B?c01qR01Lem8yRVBDWkRHU29MU1R6N0JxcVBCczZWa1RKODd2Z2hyRFpHQTNN?=
 =?utf-8?B?V2dob3VvaEVjN05pTjZZd290Vk12dDROTkRLVTFoQnYyYTJwa3dDdzExZGl0?=
 =?utf-8?B?RFU5L04xRFliT2pZWk9RdnBaaGN3aUVhQXNFbkdlYVk0TjNmei9Pd0hQYWFp?=
 =?utf-8?B?VGx2S2JkdDNYMjNzRTlaY0dIamVrTGdobksyTGRLRTlUVVNrSUV4Vmp2b1h0?=
 =?utf-8?B?V1BTOHdoN0xIRE1kd3NORC9VenhKOVJzbHRhY05kV1U0SWQ2TTFHUndrRUtK?=
 =?utf-8?Q?dCfC3F3zbmu8T5L8dahIEZCXHSqBgz/+EHKs9UHOv+vv?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 74ec4f94-8f41-4d5f-0a39-08d99d948446
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB4465.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2021 00:05:45.1271
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bRoM3xL/U8SG/irwzS2nLfy0u/+BCJ/HWFImZz1O/wwm7AoKkw3oJozNsTLWI2TK2u78vuz+UNRCET3kEPOriQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4806
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: Fe_WH1pXb29hVjFBeCEOXfhVS9TMqV4_
X-Proofpoint-GUID: Fe_WH1pXb29hVjFBeCEOXfhVS9TMqV4_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-01_08,2021-11-01_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 bulkscore=0 phishscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999
 spamscore=0 malwarescore=0 priorityscore=1501 clxscore=1011
 lowpriorityscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2111010128
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for fixing this, Eric and Alexei. And
thanks for reviewing it, Yonghong.

On 11/1/21 4:24 PM, Eric Dumazet wrote:
> On Mon, Nov 1, 2021 at 2:25 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
>
>> I rebased and patched it manually while applying.
>> Thanks!
> Excellent, thank you Alexei.
