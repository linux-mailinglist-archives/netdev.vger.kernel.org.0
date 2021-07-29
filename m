Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 335DD3DA7CA
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 17:47:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237669AbhG2PrT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 11:47:19 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:57474 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229602AbhG2PrS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 11:47:18 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 16TFdNrw023596;
        Thu, 29 Jul 2021 08:47:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=BqWqV9JGf5QnG0UHVYNVKZ+pE196OFiSeiv5Ftug2D0=;
 b=mw65oNPbGocK6Y6Y8OUrw1Gh91m8oaA09eRfDxhFoA4azSbOafmVwHwHSW2XnFG3j8Ik
 6uhSShP7fvlLFHoenkELD21F/RD5xpmLnLnmuZEYGI9nJgCST1sRYALA0EYftIqPX9gE
 /zqEURSXLnvggeiLmtYJU9nhbWcjfzSwla4= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 3a37bf8gdu-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 29 Jul 2021 08:47:02 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 29 Jul 2021 08:47:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f2BOYWG6cKcgQHzrMayEdedQXsWAJFzOUOG2KigppH5BVY54bNFEfR5GPMFnBMkd4h0ci09+UeoJieN5o2Px64ky9Rgvp9kehBFmQ/N3MSoBLpm5QMuLhQiE5BqhRCRId7YiMkfHsuBFYg+Lvtj7Z2GOstX7TOOljjD/YXcMxfIg7XRa1J0iWHPlwgpem2C49lTELR6Up/JYTtBKJNqcLeWLflEi7Mv/MCj/l4JDbbN62SQzuMFeSR9KyLsJzj8s1ELrfCo7AvT7ph3Q6rMVDxWbcXkw5baRlWK18faajzIb0T+vIf0JbtmSXXOrpS+nv2EeRx1QBlk3AoSpAtDrhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BqWqV9JGf5QnG0UHVYNVKZ+pE196OFiSeiv5Ftug2D0=;
 b=RXaDcXZxoNd1X+6g+4HS/QMG9ySfYPWva6ETjPI9nzW1EN8Kag6VDHN6tLsvxBrLdJASFpF0JxAD3VOLfjcpOboM+XSqzFwnhRiMC163Pkisz0rgg7yarR3bgNhoY4j6NLX/k/Zj8XnTP4iKeTA4o00PTctkEklazh8OF6rBni53XLkDsRAHuyhS3L59uRIGFp88zu4hjMcFUwFxT8s4mJ76+lTzYSmD/eEYt/KLrRntJXCpr2TpKqNgTu36cgqLy+3nReLIJESwRAyM3baCEl8RiyvJmG0t/4cS0v6NbSHtnoKX/RxIZy8sxaYJkU+uy6N4pn8vqWOjLlHhJpjWHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4707.namprd15.prod.outlook.com (2603:10b6:806:19e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.19; Thu, 29 Jul
 2021 15:46:59 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::c143:fac2:85b4:14cb]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::c143:fac2:85b4:14cb%7]) with mapi id 15.20.4373.021; Thu, 29 Jul 2021
 15:46:59 +0000
Subject: Re: [PATCH 10/14] bpf/tests: Add branch conversion JIT test
To:     Johan Almbladh <johan.almbladh@anyfinetworks.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Tony Ambardar <Tony.Ambardar@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
References: <20210728170502.351010-1-johan.almbladh@anyfinetworks.com>
 <20210728170502.351010-11-johan.almbladh@anyfinetworks.com>
 <693d7244-6b92-8690-4b04-e0a066ca4f6f@fb.com>
 <CAM1=_QRqcVYy+ZAKkqoUZghXqLPuD8E4he47ADCRCegM2oGf_g@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <9d3cab26-b4d8-cb97-77d6-327b9bb04f6d@fb.com>
Date:   Thu, 29 Jul 2021 08:46:56 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
In-Reply-To: <CAM1=_QRqcVYy+ZAKkqoUZghXqLPuD8E4he47ADCRCegM2oGf_g@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR03CA0031.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::44) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21d6::11d1] (2620:10d:c090:400::5:81b5) by BYAPR03CA0031.namprd03.prod.outlook.com (2603:10b6:a02:a8::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend Transport; Thu, 29 Jul 2021 15:46:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 291cb28c-bd7c-441e-30a3-08d952a819cb
X-MS-TrafficTypeDiagnostic: SA1PR15MB4707:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA1PR15MB4707641769D5EA61B2BDA671D3EB9@SA1PR15MB4707.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:174;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5GlbWmunam9LCq2OZS/aDFL3TAzUTUa6i2X80xbhWreNrv0q/0XapUZTDoOmABAjD2zjUHhPD9qvFFw4lqLgGmqa5VSg+pmSP73SETVRRa8XFETIZEIedyuyZFpT7I89n5RUR2SP6jAzmhLgXFJw858hWIKiTtxl929DfZg37ag9u3b/gweJOX43qQ8CbDDzpWnatDW5qCn9ugSxOHmP+nrUtKJp6b02/fvL7piQM39c6DYjSIzhWh9wXghrgvKWrhLCo5/4OPZaeWj6rIiCMTJ4yhOk3+GIpWYoRZ+ys7I6UOM86De84lmzryXOyE0fm+zbJKcp4z0xdvaifsmtwMT5pkmyW1xbJkWaQvGZR7savEgIWRqmeqigLHwfa1ILt1K+CcE+3UKFyI3yJKMO7lnP+OSfk4/1TWacOyLXPGuRhkjdoFmpGphXe/rfMBxhBDQmus6MQzZJw3VCPvcCO7pDyrywLaOLKQeo/edAS0AxLBvy0iJOV+rlPDvaDOSgL97tv7IcwhVmtMDMjpMH57YMfEy6MbbXJC0QqX14vPiuWdFsKsp4f1QPJ5DCqatjq4oU4FDghjZ5wxnYgeFGbpE/eqLz8ztQSTYfgr7qOIuxpB0f0vgHi71MeLT0oGf7X93fvCMHYzRQ1KAm+86h54mu5tcWpkH4Nap9g7HpCvn0dyzdTptrNkdgQ8eOg5M7IMPu3yRNhkNDsly+CcYaVQgdf5NEMXtzi/2KaANKno4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(52116002)(2906002)(2616005)(8936002)(36756003)(6916009)(31696002)(508600001)(31686004)(5660300002)(6486002)(66556008)(54906003)(66476007)(66946007)(53546011)(316002)(8676002)(4744005)(4326008)(186003)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dXUxVVRPWEYzTU5lcUhwU0dIZ2hXNjQrcFZhOUN4bG0yR05rMmJ3U2F4eWt3?=
 =?utf-8?B?VjVnK2NwakxlT1pBMExTMTNza1FjaVFhOFYxVFo4MGdHQVg5MVU2YldsN0ph?=
 =?utf-8?B?S01DY2k0MENadk43MUFyQnNWTnZuRWd2Mm9rdDRpdjU0K09JcFdmY2xrZjVm?=
 =?utf-8?B?YUhRcEd0TjJicW9IMjNyMFJYcWpiUUxDajlyMmZGVzUrNWlNOGorNE40dnNq?=
 =?utf-8?B?TFZQTklsNFdGd2tXSjRaaFRyMkhJaEZTWHVxclFHei9rRUs1MEkwRlp1OTlr?=
 =?utf-8?B?QVorSDB5WnpTOGNiR1l4QzJPa2E3cE1IN0U4RmRGNkIrRklDa1dwa2Y5UG9Y?=
 =?utf-8?B?M0VxVERoS3ZnS05adU90THBEMGhScllnWWxIUTQrajREU00wZWpmZ0owY0ZE?=
 =?utf-8?B?MWx3UXEzSzJWTGEzQVUyZ3M3WE1KcERMUTdMZUxBajE2aHA2RG11T1ZTcGto?=
 =?utf-8?B?QjIwa2VtYlNacFpoMWdCeW44UXdJRXhDbkZ6ZTkzNEVVbDFpRGhtanc1NnJB?=
 =?utf-8?B?bHo3U0plTEx1WUVUSklMY2dRNWlEVTE4Zng0aWQ5YUV0ZEhXUnNQK21tWncr?=
 =?utf-8?B?SVdZMUtmVW5sc3pKM3JWNzQyNlZLenpYL1ZoaXdBTndOMm9rcmlMNm1PSkJW?=
 =?utf-8?B?TVlhelUyaHpJd05wRGJTYVBISC9FOExPN0ZEakxRSzFrZzZ0TGJYLy9xNEVT?=
 =?utf-8?B?dEJIck9tUTVFSlFsTmpxSmVBVlBBNDJxWTlvMzNiWWI5N2hVdTFBSGlVMk9x?=
 =?utf-8?B?TnZZbmI2RjJoaHpidk5OZ0xmZnd4TjZkUUQzN2E1dHA3cVhlSmVTRjU4VEdW?=
 =?utf-8?B?SnVVdWc1TkZkcDFkY3pCREFVWHBtWjRYcENSVWsrWlk3QlVSMW5reFJ5VHJY?=
 =?utf-8?B?Ni81eTN2Wm5FaVZqeFlRdGVDMVY3VUkyT2kxcFdSTk1KWDk0UTd0RTlUYU5G?=
 =?utf-8?B?T01zRHVMSkpCTlM0M3pTdW9HOVpWL0NDd0ZzZFJuMGVIbndyK2cvMmpqNlJK?=
 =?utf-8?B?QzdyU0pOMzZpR2tvYXd2V1p4NTlZQ0ZxNTJXVHNjbCtGUHVBMjdkb2xqZTlP?=
 =?utf-8?B?L1d0VWx3RDBKWWM5cmwwS0UrTnltVWlNdVZva2ZZcnRPdFJWK2JYMDh0bUJy?=
 =?utf-8?B?T3BGOE02ZWFGQVlveEFsTERpZGNFZFJ3bU4zSDg3U0x4MEJJa21FcENLZWVZ?=
 =?utf-8?B?TXRnYVF0UGRCdDVWcklWNk1aV01WbFZYNWQ0a01yQTRuRDNDTDlhdXV1Z3N5?=
 =?utf-8?B?U2ZtK2tRdThzUW9aL0wrUFVwRVc2WC9jY250NWN5VTZ4V1YrK0xXVXcwZE9k?=
 =?utf-8?B?OVBYQS9tczBGaEMrZ0toVmtCNSsyaW8zdjcwUWZaY2M5VnMrbmR3cTRYR3pj?=
 =?utf-8?B?OFVWY25pa3lNSlkzWjJTdlM4WUNVQkVuc0w4WmZrU2dlNTVFOHdNMHRZcm1j?=
 =?utf-8?B?K0xGbXhVMlc3ZkZoTFVYYXNGQTN4Wk1DQUZPRVMvaytSZ2FFZ1ZJSkgvKzBw?=
 =?utf-8?B?SXJMTVIraW1hb2FObkpjalkzUXpOT0d5cmt2dkVpaTI2cFlMcTdWSVhOUWNO?=
 =?utf-8?B?M0tPUkV3QVpoWloya3RpNVEvL3d3anRtaFpKTkNwWDZBRjFyQ2lVY083QmZu?=
 =?utf-8?B?dDJ3aDJ2U2tpQktTWm03TjV6NkFXTGY2QVk1c3JYMUFQcGYyMmM4ajFQQkxM?=
 =?utf-8?B?ZUJ2c2hYaWdHem9yaExyY2V6eFMxVEYvdHZJNVUzd3lKbUdkSzVYKzNudVJF?=
 =?utf-8?B?RnN1Ym5QbEVjTXJIRW5JSUFlaTgyc1haVU55Z0RPUEJzaVF5V3VUQncrUCt5?=
 =?utf-8?Q?U6Led8djKy+gqeD5KPxNy8PappP51tr97l5n0=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 291cb28c-bd7c-441e-30a3-08d952a819cb
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2021 15:46:59.1555
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QkDocNlkTEIAad/w/7AXkO4A/27BR1Ir0rKbWDDdqixtmrS+T8oz6w18oOAl3UrR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4707
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: zwP8odJDNAVEiDSA5yVw57Xt1N24aUnm
X-Proofpoint-GUID: zwP8odJDNAVEiDSA5yVw57Xt1N24aUnm
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-29_10:2021-07-29,2021-07-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 impostorscore=0 priorityscore=1501 mlxscore=0 mlxlogscore=959 phishscore=0
 clxscore=1015 adultscore=0 suspectscore=0 malwarescore=0 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107290098
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/29/21 5:45 AM, Johan Almbladh wrote:
> On Thu, Jul 29, 2021 at 1:59 AM Yonghong Song <yhs@fb.com> wrote:
>>> +static int bpf_fill_long_jmp(struct bpf_test *self)
>>> +{
>>> +     unsigned int len = BPF_MAXINSNS;
>>> +     struct bpf_insn *insn;
>>> +     int i;
>>> +
>>> +     insn = kmalloc_array(len, sizeof(*insn), GFP_KERNEL);
>>> +     if (!insn)
>>> +             return -ENOMEM;
>>
>> When insn will be freed?
> 
> It is freed by the existing test runner code. If the fill_helper
> member is set, the function destroy_bpf_tests frees the insn pointer
> in that test case. This is the same as with other tests that use the
> fill_helper facility.

Sounds good. Thanks for explanation.
