Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58BDD3DA7D9
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 17:50:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237909AbhG2PuZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 11:50:25 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:3768 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229602AbhG2PuW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 11:50:22 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 16TFnJ25009941;
        Thu, 29 Jul 2021 08:50:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=F2p2E4rcmRbAuCcWUe6UA98WELVMiUCEiChxeUk7cQI=;
 b=EUt0KeRauGwKKqSuHSBwf7dfMsSBct3DKAsyeEfBFZM6kbzY9tn3E6ABLf4MUfdGm5LU
 LzKSatFgBIP2CmMqsuY28doBz1GCVTlZ7ESlRvpzPBr9qDjkuJmTZqOkdIW1Tw6DlilC
 45LoG+r/XU42td7LDUPFcsgU8005CTk3wGE= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 3a37bf8h6v-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 29 Jul 2021 08:50:06 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 29 Jul 2021 08:50:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YS00gdAX4xH/CTurKmRDBumZh35GgRiNnskkdmNZXizViELt+qr396Enm45fNwgKbqrZQ8R19f5PZngzeN9HJVaWtlCzelsSTO+KYi2IKAulKtLHQPs08BSHM8nj36uaQYJr9StdwzvTRlhApTDjysiHeqA1R0dRHyJckGiIQt4E5kGi2OnFJjlUUVF4C0mwSyK9af7dzBpgHD/d9eijCMuOS/tpYKDl6Qa0ivUyPU6ykZjfAulgIBw3s3LP/DUqcV3ktXS2EMX4c66P8yHv0Q1+XjzNbH8YfJnlQKXDlqkAhzDiCy371WqLCpveXVs/dlZ1Q50dsLIc/WMjWkr8zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F2p2E4rcmRbAuCcWUe6UA98WELVMiUCEiChxeUk7cQI=;
 b=Au/GM8MT2QhINnaDcTE/rfNRMnkMpy7of7cTfkBCoQIMnCvcdXv4Q403JMrBhy5hZrSl9CoQUxvH0mANY2HSVwdF1ak3P2diFyTtpELX86oLvIwmUhD0s6a8bNLPsiBduTE3GCoO9cGWI7FMAvj+QYd83TlYzLri5K/rkcRDp1opi1eoJKi7KyjqahzrFm4FNPeK1sn6PA6g3nFIYTYVQwbPmmZou56ZE9yDLNApidW0s7zTlF2ZkT+s5DLNSSMDZ46WlgJEB6QqrD3Ha+PdzJgfhrPjVxcjbBFqAFzAZI0QALY7z1fj9umvGxhvpT247h3FrjLv3hXkoNh/SZ5xDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4919.namprd15.prod.outlook.com (2603:10b6:806:1d2::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.20; Thu, 29 Jul
 2021 15:50:04 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::c143:fac2:85b4:14cb]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::c143:fac2:85b4:14cb%7]) with mapi id 15.20.4373.021; Thu, 29 Jul 2021
 15:50:04 +0000
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
 <6c362bc2-e4cf-321b-89fb-4e20276c0d73@fb.com>
 <CAM1=_QRN+aioWWNfeS5Tddo2u6UG86bVj66BJoYyzaUDSkDZ1w@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <0feebbb6-7ba7-fe6e-1854-dd1cebfaf1f2@fb.com>
Date:   Thu, 29 Jul 2021 08:50:01 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
In-Reply-To: <CAM1=_QRN+aioWWNfeS5Tddo2u6UG86bVj66BJoYyzaUDSkDZ1w@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR13CA0014.namprd13.prod.outlook.com
 (2603:10b6:a03:180::27) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21d6::11d1] (2620:10d:c090:400::5:81b5) by BY5PR13CA0014.namprd13.prod.outlook.com (2603:10b6:a03:180::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.6 via Frontend Transport; Thu, 29 Jul 2021 15:50:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 09beaa7d-9b9e-4dea-43c0-08d952a88801
X-MS-TrafficTypeDiagnostic: SA1PR15MB4919:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA1PR15MB49199571738818FA87DDEAE9D3EB9@SA1PR15MB4919.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7g339ZK3koRzebR2KS5CrAN4d5JMDvehWB1r25ooZDZ465LOao8tvekQN0cORf5VaT+dEhe0Huk+EiwChHCUg6T2BG9L9UlzFTP56+xyvQIBaNS7AAaeNc1l7ZNzhgrg5EPExaHvEpeu/RLeCpz6cbMdr4V9dFbEPfnuzziV4YStFcxMTF+nBZRn76rqxWxfEyLlsEFyaaF341qu17tLYrWrP8yHaGTXAmWxGNLwbg5ZgxU+baec6J6nRtxETFqSYejWO21847VZqqzLBmpFSFtCX40RHTWY+m3IXFHuzeUbkGMTRcfCPU0AaBEeV8vpUN2bklwYWgV0kZWmod1SSu1M/lmsA12pXPloAHBggDQDkGpHVgFBnk7KoeEeWoQCN599OgjZVQZBRFxfKgVOkl0MQrr4ovlVnT7cXU/OaHgrnHugXulnbun5tbm28alJZfIGQi/BloYOadX0tXMsW+mXRXWUPbQrnGIrYpcUz3TbZTsablJluu85Q08ZYdT1RqQhTHIX2OxgFUM68JRiL79ARv5j73Ya5wtWJMPtWrFm2Pi5JcALZNb6K8yLCr5FJ8ioOhVLPOYQ7rCrRzFtD81+qQ32ngADq8A7+7pd0NcXtoLkS40RUygRXxgvFfJrPwxtyAo4aGKt6MCcmJ5evX+nmtzUhwejc/SZBel0MFqxbPjQJfWlPTTbKk0FS6IF2QRndglx6b4DXuWuXF0BeTaz4d72jHkNBsAVpIPN8hU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(366004)(346002)(396003)(39860400002)(53546011)(8676002)(2906002)(31686004)(186003)(66476007)(6916009)(2616005)(6486002)(66556008)(36756003)(478600001)(4326008)(86362001)(8936002)(316002)(54906003)(38100700002)(66946007)(52116002)(5660300002)(31696002)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dlpoZzNmSHkxa1NyMENmT0J5YUszNmhDVXdGOC9RcDBpSGZDUkpmVWdvQlZD?=
 =?utf-8?B?NjhONG55UFZkVU5Uc3VVOG5iVStXQmZLUVBPRjlpaWYxeUtQRGxzZHdzWUxj?=
 =?utf-8?B?OE5iemZGUzg3YkZDenVxTnFXRGh4WDF0WE9GTTVxMGFjWFBxRmorNStVcC9W?=
 =?utf-8?B?TEJDL0FxNTN4K2tpNS9LblNGdmNqZFBqVXd5YmVuTHNtSklFaFlPVERrZFZJ?=
 =?utf-8?B?VFJyTlJ0ZVk4M296R0RFbWFJNmkzclJTU08yV0orczgyc0NjRkNHK2N6djhj?=
 =?utf-8?B?TEY1TUdObnRuUmhFbEh5TXJjbE1aWTdpZW14VUdRYy9TUUFQbmYyV1VJQXdE?=
 =?utf-8?B?K1NTRUdzRFlVRm1PT0N0cnQ3QzhXUklteWFaSWFkT0lHSlJyZURMSkhXQ1Vs?=
 =?utf-8?B?TTNweGorVS9hREZPRnNOcFpqQUF1U0p0NVZLV3hWK0IvVDc2d0FYQUxtb0Nv?=
 =?utf-8?B?NC83QUVUZVRIcWlNQWE5L0pEWkxvQzRMZFJwb05taS9EMkFPVFhsazlxRndU?=
 =?utf-8?B?VnZ5ZFRIM2FjUEhHNnlnamZOOVdRWExGQ0dJSEk2OGJRbnA1dU9uZUVRWlVh?=
 =?utf-8?B?QjJQSTJsVkV0Ync2YUVoR0xGQmlYRFk4MG9YRXFBa3FFOVE1RlRCWFlKeWpY?=
 =?utf-8?B?WVVVR2IyMjBNUzd2ZGNKWndmT1NqckNYS1MxYzhYM0wrODRvbE1HV2lZQ1hl?=
 =?utf-8?B?SnROcXZwWmZvZ09xandiT0loeHNQQnFOZ0FTZWxuMjNhVVEySEV1c0R1bWl6?=
 =?utf-8?B?TXlNcVlwc2toNEZlcmdmN01DaksvanB4clZNblRHeDI3ZGRtd1doZ0Q5L3c3?=
 =?utf-8?B?S0RzUTR2dnlkb3VvNmtNVjFnaWltV2Z2dnhWQ1RwNWhTcUdxVlVRZGVqdnB6?=
 =?utf-8?B?WENsMVBzNHdqQldlRGRkVnd0Y3pTZ2RZanI2MDNFRnRkNDkwUVg2VmVWVFlY?=
 =?utf-8?B?MDN1eDh4d09ZMitscjRkcGh6QS9PMklqV3AwcmsvNnRrQWlLcDdoVnZaSUVh?=
 =?utf-8?B?YXJyU2F4dlJseXdHYjVXVXMzUHpHdCs5NFNBQVhrMmliZWEvTjZXZXpTRS9v?=
 =?utf-8?B?UVZWYTRCTUtLdjRpUFpocWtvOWc5VGhrTjRCZEhUWlAyL2FCMmlHOVdLbzZ5?=
 =?utf-8?B?OFNPZkcxbUd5ZW55OFh2Zjh6QnZycU9Kc3BkMTFwMmRhVXdLZm5jdzJCYWR3?=
 =?utf-8?B?ZE1UMzRhU2dHUFdmWUp5U3JJVFo0S2hTQWZuWmNhU3lzdzdLVFhEUW1vZkpC?=
 =?utf-8?B?d21vNEFZc0hUV1ptMmtmOVUwTGJ2MXNxeUJSc2RYR08yangxcSt4UFQxL3Nk?=
 =?utf-8?B?eStVWGxQSVo5Nld5ZXBzM01taWhwczZQb1BGaTV6WlI1d1hPcG5MdTQ3dXpw?=
 =?utf-8?B?czVDbkpTTWtDV1lOMm1JWVFBSHpFVkRYcHgwM2dMS0JTUUtLSU43TTFXTzcx?=
 =?utf-8?B?ZHRmQkZHUkl2MFJrT084YnVMdmRDdmMwZ2hCUE9aWVVzRFl1NU9iRHYvclFF?=
 =?utf-8?B?ZXNzcUhieGxvZUMveVEyVEJyc1BONDkrSGV1OWpib2JtZTQ0RUJGc3V3cDZ3?=
 =?utf-8?B?MGJQOCtMUGlsbEFYWERUd09UcklrU1ZWbWh0aHBWNldZVG5KZnkzTmJOR0p1?=
 =?utf-8?B?cmFndGw1eE4zclBpVEUyZkJDaG5ZaG1WQTNTRzZ3QzBVU3RiNGFhTkR3THM1?=
 =?utf-8?B?S2xxOFBJVXV4S0xWTURQSy9xMWlEemlBZldnSWw2ZXNzcTN1UngvbElvWTZp?=
 =?utf-8?B?c29lR0ltcjJySkFwNWF4N3dYSVc1WWtCSXg0S1kwTXNYNUp3R2NLOHhJZGkx?=
 =?utf-8?Q?NWTfTrg4a+8jvvOMfWySKqAgGuvVsBhrBfYO4=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 09beaa7d-9b9e-4dea-43c0-08d952a88801
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2021 15:50:04.0442
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qUDNiP2NFFbJVJFtsbC4k+hlu6e6MEE9Uf/froBtyUa1i5XaNNlyuZQTrz/DJTsd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4919
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: 7NZnxjSdaCkYLviK2SoXp1LqkQDT-pCs
X-Proofpoint-GUID: 7NZnxjSdaCkYLviK2SoXp1LqkQDT-pCs
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-29_10:2021-07-29,2021-07-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 impostorscore=0 priorityscore=1501 mlxscore=0 mlxlogscore=999 phishscore=0
 clxscore=1015 adultscore=0 suspectscore=0 malwarescore=0 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107290099
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/29/21 6:24 AM, Johan Almbladh wrote:
> On Thu, Jul 29, 2021 at 2:55 AM Yonghong Song <yhs@fb.com> wrote:
>>> +static int bpf_fill_long_jmp(struct bpf_test *self)
>>> +{
>>> +     unsigned int len = BPF_MAXINSNS;
>>
>> BPF_MAXINSNS is 4096 as defined in uapi/linux/bpf_common.h.
>> Will it be able to trigger a PC relative branch + long
>> conditional jump?
> 
> It does, on the MIPS32 JIT. The ALU64 MUL instruction with a large
> immediate was chosen since it expands to a lot of MIPS32 instructions:
> 2 to load the immediate, 1 to zero/sign extend it, and then 9 for the
> 64x64 multiply.

Maybe added a comment in the code to mention that with BPF_MAXINSNS
PC relative branch + long conditional jump can be triggered on MIPS32
JIT. Other architecture may need a different/larger number?

> 
> Other JITs will be different of course. On the other hand, other
> architectures have other limitations that this test may not trigger
> anyway. I added the test because I was implementing a non-trivial
> iterative branch conversion logic in the MIPS32 JIT. One can argue
> that when such complex JIT mechanisms are added, the test suite should
> also be updated to cover that, especially if the mechanism handles
> something that almost never occur in practice.
> 
> Since I was able to trigger the branch conversion with BPF_MAXINSNS
> instructions, and no other test was using more, I left it at that.
> However, should I or someone else work on the MIPS64 JIT, I think
> updating the test suite so that similar special cases there are
> triggered would be a valuable contribution.
> 
