Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0C5949C0CB
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 02:35:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235892AbiAZBfH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 20:35:07 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:23232 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235885AbiAZBfF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 20:35:05 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20PMO28s026764;
        Tue, 25 Jan 2022 17:34:43 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=tmfljIsqRGt0pDzFJTjMGc+NHB8uPRH925nxSV5T2qk=;
 b=Q8PfEOo0sjRR5FmqF8IfHCv9+RGdjCLViHnL8q1Uvjcbe9kZ1GiNRAfGm8GXZ1qqUc5b
 kDCOwO/2YpKECL6DJlzm2CVPI8RMyloSNfVyh3pNJt5sj1+9AoT9Ey1tCXZslXzSaczp
 64laVnOzzh0bo2kyrb5F2KjhSDAITkMeP34= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3dts3e99ny-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 25 Jan 2022 17:34:43 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 25 Jan 2022 17:34:42 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A4zn5cXmHkyI1m9nU7pG0XZDNheUdqMExb3LAKoY+gco7uYy3qXnVrFHIb3ACVWFFLNk/8g5j4bAG1BMoKBlwn+gmMCURjzSEsnIv3+1srRmABqSO7+7HMJdPbt699RwQG+uy4oOKmgAjavmvEtERjcY5ApmcgLKNwK2Qo4q8QHr/ojGQY1VmLbYTY2r5hMOYUz6afFhxniL4PudRGF0BMUPim+EpF7jYRMHUmPu/P387GkDPclKnftu3BWPre479+Af7D4TV407QLIZ47K9VtTPES2LSeyb/iIT4Vl9bgecKsQo4ScJ4OANArRYIydLcBmUEdW1W5UQpzfeB6ouvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tmfljIsqRGt0pDzFJTjMGc+NHB8uPRH925nxSV5T2qk=;
 b=HuYYHWOpNKwQrEVko754vggXpB8aYnnxxLWs/UVuOHLeUTlTFkDRpF8iYvpxzEw725wfa0+rcgs8lX9w2uYznMxusb2tbAIBwIngRWRUI8dQ8iZvzCgoEiqqQ2c78Lh6sOUzX/fZImaGO8qVG/A9rCWsgaBjqfgIqffXirkhYtL25GGKdB2edxthcnjFgsZoHiUnUgbOP1t/AzvCnRh5wL77RigiOj3Fxcq9OFeXeZH+vMUrx/e3qEtOr0X3W5R65cZpnPz9B8dAU/NAIKFp/hYzn/Nv2rSq1TkGXkxfNHT9THGSv0tWJ/tYm3xT2Uy62hB+NRYK6gdDi/prNQ8wbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from MW4PR15MB4490.namprd15.prod.outlook.com (2603:10b6:303:103::23)
 by BL0PR1501MB2050.namprd15.prod.outlook.com (2603:10b6:207:1d::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15; Wed, 26 Jan
 2022 01:34:41 +0000
Received: from MW4PR15MB4490.namprd15.prod.outlook.com
 ([fe80::25c1:6abc:fcfa:30db]) by MW4PR15MB4490.namprd15.prod.outlook.com
 ([fe80::25c1:6abc:fcfa:30db%3]) with mapi id 15.20.4930.015; Wed, 26 Jan 2022
 01:34:40 +0000
Message-ID: <c0b61cc2-af08-061a-813c-320de81fe5f8@fb.com>
Date:   Tue, 25 Jan 2022 17:34:37 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.0
Subject: Re: [PATCH v6 bpf-next 6/7] bpf: introduce bpf_prog_pack allocator
Content-Language: en-US
To:     Song Liu <song@kernel.org>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Song Liu <songliubraving@fb.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        Peter Zijlstra <peterz@infradead.org>, X86 ML <x86@kernel.org>
References: <20220121194926.1970172-1-song@kernel.org>
 <5E70BF53-E3FB-4F7A-B55D-199C54A8FDCA@fb.com>
 <adec88f9-b3e6-bfe4-c09e-54825a60f45d@linux.ibm.com>
 <2AAC8B8C-96F1-400F-AFA6-D4AF41EC82F4@fb.com>
 <CAADnVQKgdMMeONmjUhbq_3X39t9HNQWteDuyWVfcxmTerTnaMw@mail.gmail.com>
 <CAPhsuW4AXLirZwjH4YfJLYj1VUU2muQx1wTkkUpeBBH9kvw2Ag@mail.gmail.com>
 <CAADnVQL8-Hq=g3u65AOoOcB5y-LcOEA4wwMb1Ep0usWdCCSAcA@mail.gmail.com>
 <CAPhsuW4K+oDsytLvz4n44Fe3Pbjmpu6tnCk63A-UVxCZpz_rjg@mail.gmail.com>
 <CAADnVQJ8-XVYb21bFRgsaoj7hzd89NSbSOBj0suwsYSL89pxsg@mail.gmail.com>
 <CAPhsuW7AzQL5y+4stw_MZCg2sR3e5qe1YS0L1evxhCvfTWF5+Q@mail.gmail.com>
 <CAADnVQLn0UFjMx_5rQhWbSPXK1PUbJR04cxSgrTH-KuUVy8C9g@mail.gmail.com>
 <CAPhsuW4YUT4r+9HSXxUMXjP8KjPq__npmxo6O4K8p0FSaZ6s0A@mail.gmail.com>
 <CAADnVQ+xiQx4SWuEqm+vCjXs-GCo_jsVcF9DB7JyoEP=C_=-QA@mail.gmail.com>
 <CAPhsuW5gVLZeKznY0U2ccYbSzDht5K4fz2-9ScT15WBBJXeUJw@mail.gmail.com>
 <CAPhsuW4Ci9m=XW-ceHV1HBJQqxOmvK9F=yvg6CpwMzALcyTEeA@mail.gmail.com>
From:   Alexei Starovoitov <ast@fb.com>
In-Reply-To: <CAPhsuW4Ci9m=XW-ceHV1HBJQqxOmvK9F=yvg6CpwMzALcyTEeA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0P220CA0024.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:41b::32) To MW4PR15MB4490.namprd15.prod.outlook.com
 (2603:10b6:303:103::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fbb64ef2-1d7c-4bc3-da4a-08d9e06c059a
X-MS-TrafficTypeDiagnostic: BL0PR1501MB2050:EE_
X-Microsoft-Antispam-PRVS: <BL0PR1501MB2050AF6E02477505E15D01C7D7209@BL0PR1501MB2050.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BQNPh50CK7mpvKCAZdxCeqX28/9vNtQ4wTpCDUp8d3tMVS3Ti7AsPCN914J8xx4lw3O2Y8ZzEs90wAvLX89kOgQKAfPCTcChZLGDUoNZLI+SGJqTwLoAzTeS8SGHPnRfOVE3Z5tMqpw0Tqc/LxvO7O1UN11iW09r4Woa6H/2wBzo2zBSxZv23o+xrge/UI0l7/60Ml3wK0FDYuC1FCACcx3zU8vERO8dExfFqmODvZHIkICcKJsK1FPDX/faI/lthW/EqPXeuTZMh0KOdbrInDoeEy6UAdd0sAyZnxrGwyA2p/YZPRm3SIAnMNE+PZjUv9T3Mr0cIn4KA5brcGkjffzR5LSHcDXxfmldNEvoJQ2fijpTlZU3cFvmN4EMflOHcFTsVNuNwWEiLCMlxfWtIiGfGmPsYtheEDqNMRH9MNXL9bE+WRKk/nVM4QgB1/IhOi1RaDP3DUWGedtwraZ2VmwTKWI9nWCOLbpldGvfviR/Y/II6Ymddi/0rdhOzFReYbkgLlWqxy1XyBveVF6ypdqtcstqijzKCjpZ/S6JioLzszRrPUoSMnrmOi0m0+iZnO19Dukd4TxI/juq/DsBkDw/wbUVZ3D/7enfXUdhtDmtfQCQVC6MzvanHdRNVSL+bE1oGeGOOosRpUIrR5qTsaqlANVvM2NyYLbIz8tCvj7vIookJhcwFaMF8+UlnX6Y1GcZK7veflWXtxPUM289xBVytToaUUq8q/cf02DUaT0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4490.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(508600001)(54906003)(2616005)(110136005)(36756003)(316002)(186003)(6486002)(31686004)(66946007)(66556008)(66476007)(4326008)(5660300002)(86362001)(52116002)(53546011)(6666004)(6512007)(6506007)(7416002)(8676002)(8936002)(38100700002)(31696002)(2906002)(45980500001)(43740500002)(20210929001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cTUyN2xTdWNNbEtwVE52VE5FdVRnRWdQMGdEU3k4RGE5eVhHaVJvazZReHQv?=
 =?utf-8?B?NzEyRG00ckNzZ212NU81blI2dnJ5Y3JneEF0M0F6c0RsUjBXejBacjFJVmt5?=
 =?utf-8?B?aWxNOXpZUmJzM21uOUdhOEd2YjJYZzlEL2tkSXRCU0NRVkhZdjRLMzVCQUVQ?=
 =?utf-8?B?eVF6NDZmRzlBb0h4NWhadCtPZDEvdk9tUjVTZFViNXRSNGZjY2FxR0gwSVk4?=
 =?utf-8?B?RVl4YUNCNERVdDJzWnd2eDZ3MlN5dEJIZTIvM1NFU0NITS9hc2JnbEZYc09V?=
 =?utf-8?B?bzMrUzNIamhGL2ZUcy9FdDNvNCsvVWdXL3p3QlFqK0R4MmJjanU3REZwVklZ?=
 =?utf-8?B?NHZSdFBCdzl0OHhUdG9hNWtwUnFkaEJXL1p5L0lpK3N2Ukh0NllVU0k2UDhW?=
 =?utf-8?B?dXdCeXNvN3ZSeFRXMWFQNHBLYmFDMzFQNTRacVJ1Y0hJbDhhOVJBUHN5S0pa?=
 =?utf-8?B?NTdEUmNTZEZIbkQwSkhXSEJTbUt4d1FNdlhxQXNabDlxMXZWaG92MGhvOWJq?=
 =?utf-8?B?ekViMExtbGZhRFVYcDVxeU9yUVkrYjJUOTQvcExMVlNWakhIUUxQSXU0MFJj?=
 =?utf-8?B?SmFtbmUrOTg3Q1NoejJ1S1pMcE0ybWdSZDd4WUFVVGh6akZkczlzNWkzYWxG?=
 =?utf-8?B?UlNsNkRFUXloZVQzTkRwRGF4cXEzdnFLTVFTa016THQ2N0tHTnhsdTJRMHdM?=
 =?utf-8?B?Vi9ibitzWjhDaGtsTHRLYmovNVNFY0llL3I4b1RKc1M0ak5BM2JFRkpUbm83?=
 =?utf-8?B?aFYwbFJpck4vdm9zZmYwdXRZM1BObVFEMnVWc2pmdWJXS0lxQmc1ZSt5RzR3?=
 =?utf-8?B?UCt6TWtEV0RZNnFyK2hMOEcrQndWMmY0TkxOWEh1THJ2bm1lajVMRWp6bWgv?=
 =?utf-8?B?eW1ocjA5dFRFaUdFZHI2Uks2NGsza09FYnE4dlozR2NuM2xGOFFqWjNGSGR3?=
 =?utf-8?B?TkxRQUZ1SHpmQk15b1YwQXhoQThnRm9lYXI4b3pkNmsvT1RnUjZiSXpXY2Nv?=
 =?utf-8?B?MXJkSWxDaDRrRGVmQmx5MHd5SjRsT0tybmx1dThPYk0zZVpUMkFzNzhBNjd0?=
 =?utf-8?B?MXVJTjFZdTM5YTZ3b3d0Sm9ZWnZyQXlVd0lvNHV1NXNISzY1VEx2S0lWTGZ1?=
 =?utf-8?B?bjcvdzVzeGdValFLTVlyV3lNcG9KRVRqUHM4cy9hRmNQRXFMYkkycTZpY1lI?=
 =?utf-8?B?RmovM1dFNXNCdVlobXBEY1RPRnp6Mm9PdkJ0UnN5anZiSDBCQm50dWxsTURV?=
 =?utf-8?B?aS9BWGtOKzdBcms1UHMxcFIwRUNWc2JWUFlGOGdEdEpEL2tLbHVVclEvU01k?=
 =?utf-8?B?R1dFUENjV2FGQ2Y4MytLeldick1QbjNkbkIrQUluV05zTUZyY2NRRkJxR1ZK?=
 =?utf-8?B?MWhqbHpzOU1kTVZ0SWo5OWo4QW5FY2FqUnJVdGlpRFdoZUJSMmpaN3VKb2Fk?=
 =?utf-8?B?ZCtpWGhFV1hFMEVCRUhVMC9TRDZveFJxM3VuZC9BcWlodEZyWGFxRFFHVGtD?=
 =?utf-8?B?UTVGaUhRSzQyb1M4ZTd5ZlFIZ2MvSlJIQnJYUUdDTmdEbG03bmliUFJZeGIv?=
 =?utf-8?B?Z0xxRExSaktRMzVETU5vVThiekVoSG5IelBJTGdmd0VTbTRBbDZDUGsvTDFl?=
 =?utf-8?B?QWZ0RVNLUTlqMXRPRVlmNzl4elp0Q3FnZjZBdWVZZ29Ia0doV1R1UE9TY0xx?=
 =?utf-8?B?ZGcwdEVmTTlqTU5CSW9GdTZKWVpDZU9PbmdESEZYV3VNZmZxbGVhMnFGWlR6?=
 =?utf-8?B?MndOUjlpRHc3MkJuMEM5TVhrWTdZSHlIazVwS1hSd0RCYi9iN3U4TFRQK0RJ?=
 =?utf-8?B?bzdNVnoxaGxUa2laVjVCSmE3TDJTTGUxWEVmWlVwRVM4b0czdHYwR0FuS3VG?=
 =?utf-8?B?SzFFcVYyWFVsNUQ5QmxrSlptajlnNVNSYlpiN0xPQmNKWTZac1NjTkZRSTVy?=
 =?utf-8?B?eG9FZHNubVcvekY2ek5sWDdTNm9WZGhkc3g4R2J3SzR6cy8rQ2l2WTBIeDdZ?=
 =?utf-8?B?bExpWW9CVFBhbS9UbFR2bTFmQ2lZWHhiUlBkazlpdkIzRzdlYkpDOGFJN1U2?=
 =?utf-8?B?NmtJQURhOVdKZjRSNCtuQ0VtMG9KbzI2VVIwWlN6dUsvZGJkYURETUl0OUY5?=
 =?utf-8?Q?H1qLp6dLdTb2407QtmdmemZ0c?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fbb64ef2-1d7c-4bc3-da4a-08d9e06c059a
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4490.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2022 01:34:40.7257
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Adc0tCvzwPHUPntqUzfBYdtAd9EHYVHDxaennOUngOS+CxTBnIl9leXzrxKtag0O
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR1501MB2050
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: 3zn8qBtCcc-saHPG8kQcEYN9qX5Fck6k
X-Proofpoint-GUID: 3zn8qBtCcc-saHPG8kQcEYN9qX5Fck6k
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-25_06,2022-01-25_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 impostorscore=0
 malwarescore=0 clxscore=1011 adultscore=0 mlxlogscore=915 phishscore=0
 suspectscore=0 mlxscore=0 lowpriorityscore=0 priorityscore=1501
 spamscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201260004
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/25/22 5:31 PM, Song Liu wrote:
> On Tue, Jan 25, 2022 at 5:28 PM Song Liu <song@kernel.org> wrote:
>>
>> On Tue, Jan 25, 2022 at 5:20 PM Alexei Starovoitov
>> <alexei.starovoitov@gmail.com> wrote:
>>>
>>> On Tue, Jan 25, 2022 at 4:50 PM Song Liu <song@kernel.org> wrote:
>>>>
>>>> On Tue, Jan 25, 2022 at 4:38 PM Alexei Starovoitov
>>>> <alexei.starovoitov@gmail.com> wrote:
>>>>>
>> [...]
>>>>>>
>>>>>> In bpf_jit_binary_hdr(), we calculate header as image & PAGE_MASK.
>>>>>> If we want s/PAGE_MASK/63 for x86_64, we will have different versions
>>>>>> of bpf_jit_binary_hdr(). It is not on any hot path, so we can use __weak for
>>>>>> it. Other than this, I think the solution works fine.
>>>>>
>>>>> I think it can stay generic.
>>>>>
>>>>> The existing bpf_jit_binary_hdr() will do & PAGE_MASK
>>>>> while bpf_jit_binary_hdr_pack() will do & 63.
>>>>
>>>> The problem with this approach is that we need bpf_prog_ksym_set_addr
>>>> to be smart to pick bpf_jit_binary_hdr() or bpf_jit_binary_hdr_pack().
>>>
>>> We can probably add a true JIT image size to bpf_prog_aux.
>>> bpf_prog_ksym_set_addr() is approximating the end:
>>> prog->aux->ksym.end   = addr + hdr->pages * PAGE_SIZE
>>> which doesn't have to include all the 'int 3' padding after the end.
> 
> Actually, we can use prog->jited_len in bpf_prog_ksym_set_addr(), right?

Lol. Yeah. We should. Looks like somebody remembers their own
code in perf_event_bpf_emit_ksymbols() ;)
