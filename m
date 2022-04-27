Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3C1C511F7F
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 20:38:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240786AbiD0QAx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 12:00:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240677AbiD0QAp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 12:00:45 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CF9A9F3A4;
        Wed, 27 Apr 2022 08:57:24 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23RFrbXg029869;
        Wed, 27 Apr 2022 08:55:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=QYvrSCjb1Vr+WKxdhZqUZBVKx8JQlovphdJwlZCo5pI=;
 b=VHM1XCvws4Bzy49nbMGDqVjaLJSqeaVYWZfi1zk3UsAR69XRZLsf0vamfEiw9Yk+Dmow
 FNz90fIgwBOGlOX8sPqj/JVG2vgpu+54VwRmII0DsMywjRqQttiW13aEUWsRz0cmLNiD
 fNTpg2Uu6/RmiwCqrkGTcnw9M1iOwWdqBkQ= 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2103.outbound.protection.outlook.com [104.47.55.103])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fprt957wc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Apr 2022 08:55:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V/xC6Q+d3BYHMm8PI5X3tjUDOSjG2qU7wA6ba+bmE0tnVSIELK4F8fRpU9xmad4IkwdlgZScBqGyJjWbBk29ivKez/jaIKsxUwP/u+rZTtirrPYrHHG9zSqIRgi3X8z9sUCUePfnTdT4fpqTyaiC7jVSkJE6d90MJ09hdSuYDU6AjkAtWYxRQNX0JZRC9mCCTXuQ1zPFfwtE7rlj/QZSzsdqAb1l3W8y//z4PjVqJFxexf26iOFtOXXNT4hHY0RMPpRzXDAHLFsjyQOXHUwaX63+V9ls0zgbFSJbcjlkAlzv3HeKox6Hju/MGU9WmWJUdqdRwMJiPhfTkqv1u/CKwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QYvrSCjb1Vr+WKxdhZqUZBVKx8JQlovphdJwlZCo5pI=;
 b=YsOtY04gaplwBh9cHxm8SiEStcx14kc70ujpKAtor4b1UB7j/YBZDqDqKY//3C1WkxqKakMjrnHmU9Scp2WIz52OAvvMNOAZBZR+vO6CK+Ae4OgOXomFSpkQW7flsD0HzDkpaF+DuZHK/3s3VljtS2zXN3z8bUC4krMoENkqKY+Zo5aoPVcPEAX4oGs6Dh3SYVtmSCLTAMbndy6Xfx7EHPp4W+Ys5pkKKqo60bAQJ069++GJ0g98jdRaF4hUMS48JL/R0XVQKLJpTmgTzUHsAztYvmkHyNcxBRFIn/RROWU1p5ZXamOFfy+lCQU3JDRM2ZIKG7qL1DHUixdI/S++Ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by DM5PR15MB1851.namprd15.prod.outlook.com (2603:10b6:4:58::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.21; Wed, 27 Apr
 2022 15:54:58 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::5811:4996:bbfd:3c53]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::5811:4996:bbfd:3c53%7]) with mapi id 15.20.5206.013; Wed, 27 Apr 2022
 15:54:57 +0000
Message-ID: <05d21d85-7b59-a8f9-73dc-89189986db11@fb.com>
Date:   Wed, 27 Apr 2022 08:54:53 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.0
Subject: Re: [PATCH bpf-next 08/11] samples: bpf: fix shifting unsigned long
 by 32 positions
Content-Language: en-US
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexander Lobakin <alobakin@pm.me>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Dmitrii Dolgov <9erthalion6@gmail.com>,
        Quentin Monnet <quentin@isovalent.com>,
        Tiezhu Yang <yangtiezhu@loongson.cn>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Chenbo Feng <fengc@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Daniel Wagner <daniel.wagner@bmw-carit.de>,
        Thomas Graf <tgraf@suug.ch>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        "linux-perf-use." <linux-perf-users@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        llvm@lists.linux.dev
References: <20220414223704.341028-1-alobakin@pm.me>
 <20220414223704.341028-9-alobakin@pm.me>
 <CAEf4BzZVohaHdCTz_KFVdEus2pndLTZvg=BHfujpgt29qbio3Q@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <CAEf4BzZVohaHdCTz_KFVdEus2pndLTZvg=BHfujpgt29qbio3Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0175.namprd03.prod.outlook.com
 (2603:10b6:a03:338::30) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3a379d6b-d542-44da-5e8a-08da2866476b
X-MS-TrafficTypeDiagnostic: DM5PR15MB1851:EE_
X-Microsoft-Antispam-PRVS: <DM5PR15MB185190D04D4483B966451312D3FA9@DM5PR15MB1851.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DwnBXi7193vfNQ19Cyf8ajI9pIJoTCZbzbMyw7F2iR8+fFQcpdTWpmGGGpPBIIHU/B8LmSY+tcdvWG6gIRziOZnDHzFNmeJYUNSvTof7OQp6rZ73wgTtxwHwOrhqNzivnQlxPWlBLqI2o7UGPx7ww8tIFvTOalNaEBCbF4/+/lR54LahNsfKIOMU1z8vR5owp8OCPBSz73eOV59aPVe8cd/EJ2tUudcSA8JLP2cKdxbAALqbx+TQNkupPCP2tY05zkI0JJduwrWgU/hwEclx8unzNgO5ajeyygbOyVLmDAPW31MOzfNbjXRETlhme0Y8i+4S5FGW9+trelJnFIMkpwFdZgBSLQdkuZn444DRasj/kPPcOBFAZNg16/Tq6L5Qne4uGOz5FKRHh5cvsthkHuVoSSFehmqJMs2gtE5iN/qxImW1tvRf/jrb4EkKvAnvqc/auAfRzxM1OFuvAFZguF+uuQ8/j2Z5dEUbxhu73NYcMORp8hZmsfEeVlT68kIzxx4KB9grBfSQy6QbIUEB13ju584S8ooxfbcQKIuaZtJXdE587q3GbzFIsjswDVAZZBhwZSV8wY5re/B0z9XvJ1lh0nhvYFn8zsY1y9STntQuzVV/oeSov2hUSenF3chZ93GM4HpxLrMlofYxvlLmhGQMsiIRjcglclfNx8844ZI5owpAJsGg2uNfbcu5T5K6kyO+Mz7NV9gZsJgBu7mb/l0JNwptQyex67B4D8pBxhy4xwg8p7ycxrtBZAM/6XDM
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(53546011)(6506007)(316002)(36756003)(6512007)(52116002)(38100700002)(31686004)(66556008)(66476007)(66946007)(8676002)(31696002)(110136005)(83380400001)(6486002)(86362001)(508600001)(54906003)(6666004)(2616005)(4326008)(5660300002)(8936002)(7406005)(2906002)(7416002)(186003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WmpkcnB3VzRFWWEwaDNuWGp5TmtLQVgzTmovbytkM1Z1L3lPYWwvZjVmSS9Q?=
 =?utf-8?B?WDZPRElaNTFnbmVsSXg4c1NVMHpRTWQybElzTWdUOEM1bGM0YW1xczd0QXdW?=
 =?utf-8?B?V2dndnFkK1gzSnlSbkxqbFdqNjNBcHBFZHJKL0ZZdG9vRTdKa3NRZjFTaTJY?=
 =?utf-8?B?M25iRWRWZ3dRd1ZRYUQ3b2JMdk1DbGI5UDZadVBYWkhnVTlEa2FjTVZ0U3BR?=
 =?utf-8?B?R3F2TFlsQXFTUDZlTzE1bFdNb0lwZGFMZm0rM0xodWs5TExHQmlDeGM3SVds?=
 =?utf-8?B?UFZjWkwrc1YzNmRrUXgrRmJ0RTNkWUVYRGs0dmpMSS9xM1dJVmN5N3AvMy95?=
 =?utf-8?B?SnA0d3VKMmxveGhJVWJvUm05dkhkSDlpM05KWlBvTDJBRUwrWGlvZXBjQ2pL?=
 =?utf-8?B?UVluWTBFUVROcmVEZVJhdlErWVNnTUp6eW5qOEZXNG5hKzJCdHFaN3c3Ymhl?=
 =?utf-8?B?eVVmZW9HQjRjcGg2WjU5cGRRQkozNTFNZER6NFJ6TjBRb2pLQmFMd1RKSS8v?=
 =?utf-8?B?UmpOYjdRRnNpMTBVK3Uwc3BRWVVlSmIxUWVXUUJxOEwzUDZ4bSt6MjkzS3Fl?=
 =?utf-8?B?R3VEd0trazNyMlhwSUsyQUt5V2FxR1lvV3dVazNBTGpjOW5FYnBHNkdHNGdD?=
 =?utf-8?B?N2FEdUl4ckcwQ2l1eFFKOHdSMXdla0ZKZ1VBKzlOZjRZYndsUk14dFprK2s1?=
 =?utf-8?B?Z2ZEYlRTSGtaZ3JtSFRKakxINlVhN2NhVllhbTV0dzdSNTdoZ0cyR0JCWHFy?=
 =?utf-8?B?Z0RlVHlIbVJ1YmNaUVd0VEdwTlp2M3BHbWFwR3FkTHdKcjVmbXhMeHFiTFZy?=
 =?utf-8?B?NUlMeW90NUhEalM4YkJZNCt6bmxma2RJK25KejFuVVg4eUlKaTIvdzMzTEhy?=
 =?utf-8?B?WFVUaHVnWjVuYUxwSGJuOUtQVG9UQTRQcG5teUNxOExROWlhWFMyM0tsTTNs?=
 =?utf-8?B?eDhKUEptOVJIZWtwdXFYUWZPd1FhZFp2S0lYbmdPcmRXQmhZeFYzeVJRSHRP?=
 =?utf-8?B?Tmc2dytweFZkUnFKSldjNnFtWm5wL3N5T09WcGVIMmNpQVBqbVVhcUpTMHJS?=
 =?utf-8?B?SUtwMlJZeVdrdk4vRHRFQWViaHBDeUs5UWRWV0ltaVNBbmZNMXdiWjBMU0RJ?=
 =?utf-8?B?RUw5RnVsdkJkY3hZcktiS2hhNXNXWThDRDhsdDNSanErQTRzQmdoajR1eDFN?=
 =?utf-8?B?NW40SkM4WWZYcEZ6am5VU21oTFY0WlJZN25zNVVnUEkzNGdWVVNvQ29hSlZO?=
 =?utf-8?B?emd4T1pyVHg2NGlKMXhnR2I0SC9IUmQ0MDg0MmNvMk1WMUZrbU9BREZINGJG?=
 =?utf-8?B?L05iUDEwT3ErbTcrNHJ1ZFpoS0h5bWxTeDJ3YzM0d1RtSUhGZ2tBUlJ5UmJU?=
 =?utf-8?B?ZGNXTHVVOWNESEJZV1NKVUdXUFk1RnBiNXRaQkkwbVpwOEovRUp6eHJYUlNX?=
 =?utf-8?B?SG10M0IzMXBiUzdyS3hZYmF4NGdGb1FVM3o2MEtGN1FQTmZVUW9vcEl4cUlj?=
 =?utf-8?B?UjVjeTU0c2lsUXJuNGcxTlBuVjdiczZPeEUyWi9IVWp2YnZaNy9WdUhKcSs3?=
 =?utf-8?B?ejUxeHdWT1BQVzJNcnRiRE50SXZrYm9ocyttY0pJRVg5WjVpdS9WSDFKV3ZG?=
 =?utf-8?B?U0dpWVAvYVU2TnBlTGVZM1ZDMTdqb0ZTdnZ5ZC9aSHN6WFgvR2hLSitUN1F5?=
 =?utf-8?B?OXN1YnpTRkdOU01oMlZSZCtqNVZka1g1cDg4R21EU1pDUGdQZUU3OWRhRGRG?=
 =?utf-8?B?SlhaSGY0dmQvY2NacjVlQU5Hdkh1TUo1U0Q0UFhJdUljOHBWMkNWSDl0TVll?=
 =?utf-8?B?NjZkNjJWa3JiNUptek12RTIrZVl4azZXbEVZeVBGcitqWWt2RjdFbDE5WU9Q?=
 =?utf-8?B?Z3Y3RlFmTzNZeEV2dXdKb0hha2dXL0xrTWRHTDdycVNNSWpJeGVKNk81Mkt1?=
 =?utf-8?B?bWkzL2ZLSVNsa3k1L0M5cTZ3RWJhVWR3VVFWU3BQWGJCTmNlUWl3MTZmbkxB?=
 =?utf-8?B?YmF6dUZoTVlUWGVvckJCUlM0aUtrR2RrOHE2d3gvL0x2cTBOSURBWWhOaW81?=
 =?utf-8?B?ZkVRQWlFMnc3VCs0UHBjdVhvaXZMUkUyRTFCSzc1S0cwdUdQRTNLYVBFK04r?=
 =?utf-8?B?VGtZR3ZCNjRKZGtLWEp3OUR5Q2VJZkxpb3hzdEpmUHNscEsya2hsTnBKaWE5?=
 =?utf-8?B?OWNEUjZFanN1VG9naW5OTzRiUUVnSWx3blFZbUYwMFFSSXBYcHNXc0d5MmF4?=
 =?utf-8?B?RkZRYnpxY25OQk1yUytvd3N5UmswbENodUxuVGNkSXQxc0FHK0hyQlB3d2JW?=
 =?utf-8?B?R2JzWGY2dm9uNUlhOHJwd0I0QTErYnRnT1ZDaGRLSVg3MHltS3BzOGVIMDhM?=
 =?utf-8?Q?oRk8ak6b0oIKHM0w=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a379d6b-d542-44da-5e8a-08da2866476b
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2022 15:54:57.8215
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s+MdR2PK1Nci78PfYM6OIHOiRb9zCsb3R+GTmUlEx3mMZHRl5oG9MVarIHIKR/VY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1851
X-Proofpoint-GUID: GV9-L0tchi0YLPySx0A7_35j8Ye5OtNq
X-Proofpoint-ORIG-GUID: GV9-L0tchi0YLPySx0A7_35j8Ye5OtNq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-27_04,2022-04-27_01,2022-02-23_01
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/20/22 10:18 AM, Andrii Nakryiko wrote:
> On Thu, Apr 14, 2022 at 3:46 PM Alexander Lobakin <alobakin@pm.me> wrote:
>>
>> On 32 bit systems, shifting an unsigned long by 32 positions
>> yields the following warning:
>>
>> samples/bpf/tracex2_kern.c:60:23: warning: shift count >= width of type [-Wshift-count-overflow]
>>          unsigned int hi = v >> 32;
>>                              ^  ~~
>>
> 
> long is always 64-bit in BPF, but I suspect this is due to
> samples/bpf/Makefile still using this clang + llc combo, where clang
> is called with native target and llc for -target bpf. Not sure if we
> are ready to ditch that complicated combination. Yonghong, do we still
> need that or can we just use -target bpf in samples/bpf?

Current most bpf programs in samples/bpf do not use vmlinux.h and CO-RE.
They direct use kernel header files. That is why clang C -> IR 
compilation still needs to be native.

We could just use -target bpf for the whole compilation but that needs 
to change the code to use vmlinux.h and CO-RE. There are already a 
couple of sample bpf programs did this.

> 
> 
>> The usual way to avoid this is to shift by 16 two times (see
>> upper_32_bits() macro in the kernel). Use it across the BPF sample
>> code as well.
>>
>> Fixes: d822a1926849 ("samples/bpf: Add counting example for kfree_skb() function calls and the write() syscall")
>> Fixes: 0fb1170ee68a ("bpf: BPF based latency tracing")
>> Fixes: f74599f7c530 ("bpf: Add tests and samples for LWT-BPF")
>> Signed-off-by: Alexander Lobakin <alobakin@pm.me>
>> ---
>>   samples/bpf/lathist_kern.c      | 2 +-
>>   samples/bpf/lwt_len_hist_kern.c | 2 +-
>>   samples/bpf/tracex2_kern.c      | 2 +-
>>   3 files changed, 3 insertions(+), 3 deletions(-)
>>
> 
> [...]
