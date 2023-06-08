Return-Path: <netdev+bounces-9380-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B076728A12
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 23:16:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3826F2817F1
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 21:16:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A073C34CDC;
	Thu,  8 Jun 2023 21:13:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87C7A2D279;
	Thu,  8 Jun 2023 21:13:41 +0000 (UTC)
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F6E12D74;
	Thu,  8 Jun 2023 14:13:39 -0700 (PDT)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 358GmS3G016818;
	Thu, 8 Jun 2023 14:12:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=4wr8b+paBWEP/y+xRSVouRil5605j63PYXpW58nMnXo=;
 b=h3xa74gDN3zwnJKeqqzUAnCkULX5QoMGtpDilB8uRxuJw4Pyeni7H8qKE4iJPaWN0yHN
 o/7APJaw3C5898r+OHcx93E/gWSfmc1DKW8+kV7B4ay9aqwceZVLW+q0isCzEw+9sHNz
 XasUy97RiAwjBE026QHSwM9WargRqZLFvHSOLhVbhZWB8uNKu/PYT7c2inb/e2aTZa/y
 KAA4TPQhs7BJXIt8od6yqcwFHrBiujZo+BFKSnxhmwsH4+VIuEb7WEp+TqL9KHQbqMoK
 bKOOrOWDecGvIshMRWwIyKnUtoaq27vmX8z+tfdSzwvKnsv/nKHZoVsJ5BuIlEQ/AByk NA== 
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2177.outbound.protection.outlook.com [104.47.56.177])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3r2qbsn1jd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 08 Jun 2023 14:12:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AK0EyPaWwEr1kKSazmABeMRU7JCAjTnjQXQur2BCj+g6HEQNXb7Afg/O1pegmafVD61z3U4qPDca0YKSLwritZeEhfvpI/ORYP/hA7WLicizgbUnwvrkefq+TdJ68BNxWJEBVHGDq4M9vt4jlt1LDP5HElWHfxmeh0cPWTLEFjYZa2ZRJAjO1BS1m90/l0Os8cJlt8ts+BxeUInrHT7AzEfxFYxZFUWfX56nmCgluPrLnpH/mjth2cL2fxgc8PNNTwYD0BP51k4XXExneUhy1/s6oW3lBKdscdBf/niqL9lUZv276wlY5/f/wBQHGwoQjwdLchGDxFAqvufCDg6jlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4wr8b+paBWEP/y+xRSVouRil5605j63PYXpW58nMnXo=;
 b=icWxDL0O+2YunEGziMRtGIDiXAzT0gG/kUNZteu1qW0hIGBpVN2Jn07qJ8HwkS86ZFp+lE9NOflWQciTZ2HPvPgA56GM/tFkJjFewrmZ7iMp3WcXlt4xX++4r/BJLiaViG1BbK4Uo13RkYzrhr8NISH98L2Zz3Br8pDGYkR3ueiPxd+uvplrH+Oc6X/0yABUngtsN83RShoKVwSl5s7/iRMAZG13n5hvS2y86a7CDyMo2G8rHce/O2zxTYa9As0L3d4CFkH6GR6yVnFFNqbJJZTzA3oMVJ5tkSJtDNW6K8CYNv7Dt1x0xgzBp9MdnMaIJfF+24r96v7vp19idXn3ZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by DM4PR15MB5565.namprd15.prod.outlook.com (2603:10b6:8:10e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Thu, 8 Jun
 2023 21:12:52 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::bf7d:a453:b8d9:cf0]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::bf7d:a453:b8d9:cf0%6]) with mapi id 15.20.6455.030; Thu, 8 Jun 2023
 21:12:52 +0000
Message-ID: <2fb8c454-1ae7-27cd-a9fa-0d8dda18a900@meta.com>
Date: Thu, 8 Jun 2023 14:12:49 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.2
Subject: Re: [PATCH bpf-next v3 1/3] bpf, x86: allow function arguments up to
 12 for TRACING
Content-Language: en-US
To: Menglong Dong <menglong8.dong@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: davem@davemloft.net, dsahern@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, martin.lau@linux.dev,
        song@kernel.org, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, sdf@google.com, x86@kernel.org,
        imagedong@tencent.com, benbjiang@tencent.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
References: <20230607125911.145345-1-imagedong@tencent.com>
 <20230607125911.145345-2-imagedong@tencent.com>
 <20230607200905.5tbosnupodvydezq@macbook-pro-8.dhcp.thefacebook.com>
 <CADxym3abYOZ5JVa4FP5R-Vi7HAk=n_0vTmMGveDH8xvFtuaBDw@mail.gmail.com>
From: Yonghong Song <yhs@meta.com>
In-Reply-To: <CADxym3abYOZ5JVa4FP5R-Vi7HAk=n_0vTmMGveDH8xvFtuaBDw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR03CA0295.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::30) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR1501MB2064:EE_|DM4PR15MB5565:EE_
X-MS-Office365-Filtering-Correlation-Id: bf545347-1364-490e-c88f-08db68651f1a
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	lEz6Zf7sfOv8mqiQQq+x1KUJJNVIpOUTU9hQQurv443qR9Cmb5gaOyGzDlPKpoAOx07yYwMGCKptNiiFSzCzRkt81Aw+70Xcd8k5TlMHGw5OiJsD5HVgSXDyiCcWqemJ+QndqYm0NaeVVuMJQoduUS1c8pSqvOxeih6zxOFGYMZ+B8G6ypel5qk3VVGiF9zQRhJZNYtdZR8bpqhuZvbwlFw5UIC+bM2m4w1yZBO+HSFgnYuQi1SuW8dRZv29oCAjlJcwp2ssguGsoLNzKiVVDjrIjcdOc4q8rnjzPZ+Kwh9/BHHrlUnta/Y7Rb51qnNwZwd3bZYuCJbOjfxdDF4MuY/l2idIAmrPE264w28XfdM1SxLfts210g9pRf+3Q2ikI0CXiWB74NY4MIi5a2Zny2YSuDbuDsGVgMstUDW/1/DNDq7Zyk/2T6ejc2+dQG22Mv3Z5dxajj7+OTc+gZhcU66lfZ/k8wqeL1OhPTcccRoJhvI8CFHm59zN1pTGViCIawMUmxGzH0edaYsSxTRArOKb4W+G3cqvRLmLYPchLrBuNgAolpNHGLuFH2tgrE8Ksn7qwl/zDI0QoNio0nqVbtvaYIe1iYOa3+ZQuj0oOBSOvFA5aHS5tbeonnES++zETP3DU86rB1xm8F0vv+HASMIbM32WYduQC0YH4rfGLbc=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(396003)(346002)(39860400002)(136003)(366004)(451199021)(7416002)(31686004)(2906002)(41300700001)(8936002)(5660300002)(8676002)(316002)(66556008)(66946007)(4326008)(110136005)(478600001)(66476007)(6666004)(36756003)(6486002)(186003)(53546011)(31696002)(86362001)(2616005)(6512007)(6506007)(38100700002)(21314003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?ZVovZXVka2NzNUl4UzNMaGhXeCtBMkFZL2h0c2ZSV3N3bEFETHBrcWY4N3hq?=
 =?utf-8?B?NHpyWUJBaHlNWCtLaklXc01SMGhBelhKNGFVbHMzZDhPa0xuWnZ4YmdJR0hR?=
 =?utf-8?B?MlFCTlFZaXFHNEY3TkEwOW5HZzQ3UWdadDF4TitvV2RsMEdoVkw2WVN1aVFr?=
 =?utf-8?B?VW1FK1g0clcwdDlDbzVtMTJpQmpBcWlaeWpwdVlkMGhPWHFGZ3o3UkVBd0Nt?=
 =?utf-8?B?Z3QyUGJJSGpPcmJQRGdVSFVmZWpOaytVa0RzLzZPVWsrQTloeTVBeUhOcUdE?=
 =?utf-8?B?N3R0aW1ibEZFbkVLWU9QL0IvYk1hcmdTYlNtV0d4LzNyVnpaT01tZCt6cjBZ?=
 =?utf-8?B?cklZdGR2MVg5ZkVsemVFVWM2S1Yzc3d6YXBvemxsWURZVXU2YWJQS3RtcjVu?=
 =?utf-8?B?UTgvdHJGQ09NR2VtdEpuTmlDZUxxckovdW9HSnprK0lwM3hxTmErSnZHRFpk?=
 =?utf-8?B?TUlYcy9hczNEcXJQOUZPZnl6anZJeW5Td2ZMdmhkR2lDRWRreHNta2VQQklh?=
 =?utf-8?B?dzNBVUJrcWhjUDVLam9ESzI4c1BPTldGVlVWbmFlRTk4ZmlDWHM4NXNuemtX?=
 =?utf-8?B?S1J4NjZtL0Nta1pXalpyVlVjNjhmQmhndnRnNlg1c2JuSzV0WUJqMzNORjJW?=
 =?utf-8?B?YUhhWUdrYW9teFB5dUR3OU12VGpaNEsrczdNTmZST1NXamFsRDh2NEdiajg3?=
 =?utf-8?B?Yk45OG93WVEvM1ZHUW84R3RmUHVqbnU0NG9EVFExYVJtT3Z1U0JFVTNFeFRh?=
 =?utf-8?B?aFNFTDRXeVpUWUkyMGQ3MkRhVDZ1b1BFaVh4c1JreTgwRHd2NzJla2dUUmlw?=
 =?utf-8?B?QUJaOHF2elUySFd6OWpodUZMUUxFZHg1a29oYW1EcFhXeUVyUWJUaWdFYzlo?=
 =?utf-8?B?a0dCcnlGdXIxOEFsdjA4UVp2UVVneWwzdEhscFEzMTFQaXl6MUJmOVJuL2c0?=
 =?utf-8?B?M1hhT3RHVXFycDdMTTVKcEZPYkkyaG1YOTZUNit2ejl1cktIanhOaXZ1VlJn?=
 =?utf-8?B?U2NtR21mTjN0cTVRSlhtbVJmUUhhUnh3RTZlazNTZDJDTVZqN0RxU2dOS1dt?=
 =?utf-8?B?ckc1OUZQbHl5cFdDelZRMFVSbitDME9sTUxRdEZCcS9xYXRkVG0rRGlHckxn?=
 =?utf-8?B?UWdnWGRmcjlCbFJtS0hsckhnWTR1S29vNGpJM1FPSnUrSFBKY3IxdjloL0FJ?=
 =?utf-8?B?WnhNazVicWN4cjJGRklmUWtDWXQ4enIyODlCM05tczlPc3dlczZiSVg5d1F5?=
 =?utf-8?B?UEYvcjlkTVJSZ2wveDRxM2trUVNQMkhjbUxGZ2RFdll1NXN5V0hqRDgyVHhM?=
 =?utf-8?B?TU9kYnZYOGtJRmN1aGNLNTkwcTlxRERiczN0Y1dBdEErcURKZUdrMVNlZWhs?=
 =?utf-8?B?dzZrOTBHbGpXUjNIOHh4UlhibmUyNGd3MkNtcll5ajl6Mm1YVUJGckVVUTQ1?=
 =?utf-8?B?bmIrUzY1ZHdsYUZFUStSbXZBN0l1R0YxeElKL0F6NEJteCtDSVkwb3pCTnpR?=
 =?utf-8?B?UDF4RkVCLzc3ZDZMbmxDSlpjaEpBMTgxeVR0bCtSODVDZEFHNUdIREJkTXJK?=
 =?utf-8?B?Y2FMbjhjYVdOTnRxSFZwelRZL1hHU0I3VUNJNWFiVU1oN3pHTHU5Y3FvL04x?=
 =?utf-8?B?RFpoWnR0aXhyajFPNzhBellKUlI0NmtPTFVrWlRsMWIvdS9leWVLYnVZUm12?=
 =?utf-8?B?cmQ5THZ4ZkRhK2tMcUNJOUdRNzVSM01hWFJGTnZlalI4Uy8yUFJ5bW4rNDRw?=
 =?utf-8?B?T1hSMTVrN25CRDllNXUxZ2YzL3IzUGlETmJYdkNlUkFDSzM2ZVFiTWFhTGYr?=
 =?utf-8?B?amU4TU8rYzFkcG10NnlsZlNWVzdlL1p4L0hjVjVPM2t3NHpzZjFOU2tHNndY?=
 =?utf-8?B?OFlkSFBTZlNDQmJ6KzAreWl3M29pd0szTExFeUxMbW5pYzNzSXM5Sy9xczA2?=
 =?utf-8?B?ZE9TYzlpekdXYXpzVmRXV3RieUN6WFYyc3hmbDc1YVhKWXVJbTNBYkRNSk1Q?=
 =?utf-8?B?ZlBlQXhXbFFyRUM1UUlROEUyc2c3STUzVjJQY3BkWThPMXBIQXB1Nk4xQldx?=
 =?utf-8?B?dmJqSnpkWjJvNXc2Q1pESHpTT1crZTVFZlh0TkkvUXZQSnFuc01QVjlTcm9R?=
 =?utf-8?B?LzVONGEyZlEwZVh5TjdVRElMMDVjM1VhdUNES09VZnhrU2xIeU1rM3FNdklm?=
 =?utf-8?B?M2c9PQ==?=
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf545347-1364-490e-c88f-08db68651f1a
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2023 21:12:52.7842
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rLFfQIak2TMBwTyaFgi+HnpKzW4Ydf2SwGYKhAfvuxtfxjR+2VzNO7THnu5YFBtl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR15MB5565
X-Proofpoint-ORIG-GUID: Nge8sMlHz9LD4SY7U6nYejA66eDt3qU9
X-Proofpoint-GUID: Nge8sMlHz9LD4SY7U6nYejA66eDt3qU9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-08_16,2023-06-08_01,2023-05-22_02
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 6/7/23 8:17 PM, Menglong Dong wrote:
> On Thu, Jun 8, 2023 at 4:09 AM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
>>
>> On Wed, Jun 07, 2023 at 08:59:09PM +0800, menglong8.dong@gmail.com wrote:
>>> From: Menglong Dong <imagedong@tencent.com>
>>>
>>> For now, the BPF program of type BPF_PROG_TYPE_TRACING can only be used
>>> on the kernel functions whose arguments count less than 6. This is not
>>> friendly at all, as too many functions have arguments count more than 6.
>>>
>>> Therefore, let's enhance it by increasing the function arguments count
>>> allowed in arch_prepare_bpf_trampoline(), for now, only x86_64.
>>>
>>> For the case that we don't need to call origin function, which means
>>> without BPF_TRAMP_F_CALL_ORIG, we need only copy the function arguments
>>> that stored in the frame of the caller to current frame. The arguments
>>> of arg6-argN are stored in "$rbp + 0x18", we need copy them to
>>> "$rbp - regs_off + (6 * 8)".
>>>
>>> For the case with BPF_TRAMP_F_CALL_ORIG, we need prepare the arguments
>>> in stack before call origin function, which means we need alloc extra
>>> "8 * (arg_count - 6)" memory in the top of the stack. Note, there should
>>> not be any data be pushed to the stack before call the origin function.
>>> Then, we have to store rbx with 'mov' instead of 'push'.
>>
>> x86-64 psABI requires stack to be 16-byte aligned when args are passed on the stack.
>> I don't see this logic in the patch.
> 
> Yeah, it seems I missed this logic......:)
> 
> I have not figure out the rule of the alignment, but after
> observing the behavior of the compiler, the stack seems
> should be like this:
> 
> ------ stack frame begin
> rbp
> 
> xxx   -- this part should be aligned in 16-byte
> 
> ------ end of arguments in stack
> xxx
> ------ begin of arguments in stack
> 
> So the code should be:
> 
> +       if (nr_regs > 6 && (flags & BPF_TRAMP_F_CALL_ORIG)) {
> +                stack_size = ALIGN(stack_size, 16);
> +                stack_size += (nr_regs - 6) * 8;
> +       }
> 
> Am I right?

This is the stack_size, you should ensure stack pointer is 16-byte aligned.

> 
> Thanks!
> Menglong Dong

