Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85126576BE2
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 06:42:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231148AbiGPEmq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jul 2022 00:42:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbiGPEml (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jul 2022 00:42:41 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D98CA3057A;
        Fri, 15 Jul 2022 21:42:40 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26FKnGJL007823;
        Fri, 15 Jul 2022 21:42:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=UqoulM3GoNAkqQFdJGKsna5s9DYdbMP2qSNmDo2eZvA=;
 b=RiuACJpiM/B7dwhL8raGNQQEOFiDePaIPr8gvnyDTS6V5WC85ipAh8iXGx2k1dfqA6ZU
 H709MU3gG8A7w5k881nU8jyDspDb56Ss/xgBbG4dqF4i2mFpg/wCR/I8JecT7P4p/Db9
 jBVpABd0OtMkT3C+B/K3Ttxynf4zC/dIIvs= 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3haktcbrma-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 Jul 2022 21:42:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FY5dw0KRxb839dS+Co6E3F1U/ACDiRQTs2+ASOLD44RGRypakY4sKBQctCT0o7VsrWckyMxX9G36t9cYazLCjaIpUiB6Yvz+e8jJa75IsgixcnlcDV6ghhI6S4Fw22rfybV0cbY+WS/EXk58gLvFBPf6QItFDrRYwsYkEgHT+7BEwMmVsdxLydD8mXg3nKuNGKasIlnqBoKiOmGY8kDhX63LHIG599GdWB3FVOnFzYvjbPRFgUNJ7NRX/P8D4fAKXpPYvH/5W34Y6B4JD4wMLvc9f9WvyBCJ2q9u+Tr04HgPb9b9Ag2X0Jjne3QTXmi1gsPpCbre5u2wHNkk1C0hGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UqoulM3GoNAkqQFdJGKsna5s9DYdbMP2qSNmDo2eZvA=;
 b=R/QC2eZlPi2CSGe0xYgRzpLTleBaA/SVgU2rup3Z9evIOFM7Pu001esOpx1AJd+n3QmoG8jbk3/nJ47Hz3xBqNW/NYhaABz+FAmMqcqSPYOTKFIonsZga5U/SMAkHcQN3mCGLyTBs1qXY246Waup3p3YGj4v9/8Z8fJLmysyc2YR2vTwYoEp8MMZwuk0CysYzYJlfnN2P+vu6JFGko208bhYvgBXopYLw7XpQOdEpIfO3AMImziSiacL5KdCRzj3Zo1BjzGijvQZSUC40A99CT7RjCoMkPSA2IxN/xLTFn/twVzffPeMd102yKcS+s1ays7h5791ROEjYxporAvPpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from DM5PR1501MB2055.namprd15.prod.outlook.com (2603:10b6:4:a1::13)
 by MW4PR15MB4620.namprd15.prod.outlook.com (2603:10b6:303:10d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.19; Sat, 16 Jul
 2022 04:42:03 +0000
Received: from DM5PR1501MB2055.namprd15.prod.outlook.com
 ([fe80::acda:cdec:5c2f:af77]) by DM5PR1501MB2055.namprd15.prod.outlook.com
 ([fe80::acda:cdec:5c2f:af77%7]) with mapi id 15.20.5438.014; Sat, 16 Jul 2022
 04:42:01 +0000
Message-ID: <de4f4721-fdfc-bfdf-2680-864a7464e56f@fb.com>
Date:   Fri, 15 Jul 2022 21:41:45 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH bpf-next v6 08/23] libbpf: add map_get_fd_by_id and
 map_delete_elem in light skeleton
Content-Language: en-US
To:     Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Jiri Kosina <jikos@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Joe Stringer <joe@cilium.io>, Jonathan Corbet <corbet@lwn.net>
Cc:     Tero Kristo <tero.kristo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org
References: <20220712145850.599666-1-benjamin.tissoires@redhat.com>
 <20220712145850.599666-9-benjamin.tissoires@redhat.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <20220712145850.599666-9-benjamin.tissoires@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR07CA0086.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::27) To DM5PR1501MB2055.namprd15.prod.outlook.com
 (2603:10b6:4:a1::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 979c4868-209f-4c79-33b7-08da66e57eee
X-MS-TrafficTypeDiagnostic: MW4PR15MB4620:EE_
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k6o/rKbNR6nwwffrBzfxhr+UGSscrsMYCce5CL3gfUhnZ5r/Tlo93PMxHYSD33uAfJQCjV1ueMBcd7UnmKwz/y6UYeJHeL8o84i3k4bhdoYyOGKaqdC+Dzo8Ws82n6sk+xibq/W634mkAF/4gM5OTzwm0Vh8JJiM+ioXqJ+4560lzPnhxvLstDHQoFPa79vNS8+wKoCHD8srPTpCpwyUW4F82DqjyqusKm9o5QIVRPzW1F0tIdjI5ZaEGF9mekFuQjcysnF+7oZY0M+GkwDbQHKtwql5ExP/BKotoDo4oHR677Cm+o1OHcSK+oXxtlSAyaQDO3y1SohwdkXEYSRV4PWCjn5S4YkeVz7g2g9vWQZAtelHoXvjjVywCz/+A4O6mQamqZJv0nXch0ytR5/n4hDJER4GV+iAwS/6AgVHj6VYdZjgaWmI6bpz8usnk20DM10Db8Tvw7CVTtIu0/gNBUMneD2oP1B4e8yVxZOtE8P7EsV5QOGUK8a7IFsHm5vZJvEKdqryUD5FugGiKUYB+gbjYsApVPy4v0RzeAwHls/0xeDtt+DJwEnfcGsnJjOu3luzpssUGpvdRkOedJBWYn/bssWq8QbunXqPnKJzZu4Hv44Bkpxn6OmaSGT5jmk5JM3fLe1Gq2Bno3H2wpnneDwxefzJuSZxIOwhQgq6LIO7gQYq4ADoSQ/pVTIpnv8+AyBjIcw71O3bEosqYlGevraJivTlxAPKALqMDUswr9IZEOJXf8i4Kid2xe2avzMMxh6Br7e/VC7JQ3GJs1yVd4WJf8uNaXmfO3mFeOYqSb+FXZnMUd993Emhxgvh8IH+DkO4P1o/DkPSipzNXLXVs+5tW61qcLriSn5MAqMbwv033LvdsFW1hSjG/W0BP9zQ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1501MB2055.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(39860400002)(346002)(376002)(366004)(396003)(6486002)(478600001)(31696002)(38100700002)(921005)(6666004)(6506007)(41300700001)(31686004)(186003)(2616005)(6512007)(36756003)(110136005)(316002)(53546011)(2906002)(4326008)(5660300002)(8936002)(7416002)(66556008)(66476007)(8676002)(66946007)(558084003)(86362001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VE9PWDFZT0k2TVA5OGVOOHpaMmprUTgxR0x5aDRDQTkyY1V2SnllMklMbXI2?=
 =?utf-8?B?eTFjanI4NTY2RDhpSTdScWxjZlBxcThETVVMdmVQekl1cHdoQVkvanhJQzJM?=
 =?utf-8?B?U1RNWDJwZEgxRkRqZ1NoaXV5TTB5U1d1ODFWTmZuY0dvQ2JobE0xMVZ5eDRX?=
 =?utf-8?B?Ykw4bEFPT2p3TVBxUWl4NjRLZGJQZHVSTWRoS2svaGFHVldUNHU5cDZoaFZm?=
 =?utf-8?B?REJlMVRHbFdwbk1pdFd6WVRwbHZQWnpOa0grVXlqNGN6NzZTVHVEL0dIZFVp?=
 =?utf-8?B?dXg3RytiN1lWd0pRei91WURUUUtSZGdxZ01VbDEyRkFwK045bi9VOTNrUlRM?=
 =?utf-8?B?bi9hRmhoY05HTUZHWko3UW1nc2c1Y1lKcUpxOXBVdHRrWGpheVpBSzc1dGVK?=
 =?utf-8?B?U1FiTVY1Sm5iUjRLMnN4VENJcmRnbXQ5S1BZUEUyY3ZBOHk5djhhejZwRzVp?=
 =?utf-8?B?aEU2UTFib1NTYlF3V2N1UDE3RjZOTGlIQlNlVEExdVQ3NGdzWDJXeUhFNzFE?=
 =?utf-8?B?NUlFVE9rK1c2TTFFNG1Ua1hHdVdzTVVqV0dJNG1peUJ3UHZaekEvUGx6MEw3?=
 =?utf-8?B?SE5jdWNwbkZEL2diOEZ4eVFhS2JJMzkyZmtVZ1ltZU5TeTJjZVg3TjZHZFhP?=
 =?utf-8?B?Tm5FczJGMHhDTkhvZ2JaYWhDUHk1RGxrcDVndjNJejJtVUVlbnlUY1JLbDFE?=
 =?utf-8?B?L2REeURmbkJrNHUvQ1VPZEplWldXNEljc0pFN016SGgrOXkvWnB3cmwzT29N?=
 =?utf-8?B?eklydS9UaGR1NFVjZUpUSnRCcTNISjVmdlpSdzhXZjJLN3lIUWdkR21JR0FO?=
 =?utf-8?B?cUxGaDZrYlMrUzFXdVA0bWQ4QjZhSDlKT0tLaWVTc3VkUzFNWE1EYVBVVTJ6?=
 =?utf-8?B?MTRHZVRsZUdhdUVQUTgzRVpvc0hVc3Z1WERaYmdiN0NTM0ppWDI4bmxGNFdR?=
 =?utf-8?B?UGI2NGRmU29UZURUdXg3b29HeGxUZit0eitobTcrSzAwWmgvZmZxcis4NHNi?=
 =?utf-8?B?bUJ4NHkrdjNXQVloWjNPWDVYY1NEN2lXbVhoN3lmd3hVMWc0UkttSUZaeTVk?=
 =?utf-8?B?Q0Q2T2VUOXJQeXh4UGJNOXhpVHVnWHQ2cjJ5cXZxQjM2S2QybjE1a1pUTEpj?=
 =?utf-8?B?U2t6OEdKQTVRdDZTSHhUbU9lODZRanFoMnhuVlluNlIxdjlQNkRSL1FzTkRN?=
 =?utf-8?B?VmtuTWUyYkd5Unc2dE1HZ2lzUUVMQUYzd3pkWkpPOEpiY1UvdzVuT3lhZldm?=
 =?utf-8?B?N2ZiUkJ6bDFQYTViblJhV2JSN3dORmxScGZlRHF6bjl6Y1FSTmViOGMvZXRo?=
 =?utf-8?B?cWhrbk5Bc3p2S0ZKeFpiSWZET00rVm9yK1lVd3pGL2I3RVVvT3VlaTEwdTdx?=
 =?utf-8?B?RE9JQjFEVGJFOTVXWjluUGhDVTMzZjlaeWVyYmkzeHJjSGxpT1MwYlZYZDRs?=
 =?utf-8?B?ZTlLUGQ0T2FJTHF2YVk4V0h4ckdrN3o3MEduYXpnSytncmMzR0lCQktkZ1lk?=
 =?utf-8?B?cTZudU1BWG1SSDBpS29XbjFnaEsyNlFLbEFiMCtRWFcyYTAzZWtTdUVpVGo1?=
 =?utf-8?B?RzI0eWlsL1hwaWZwR1c4Mm5GSURvS01xT3dCcGdnSXJPZ2VjeGJ5cm9FdEdM?=
 =?utf-8?B?Y0xUdkozNklWeS9ybWVjb1VFcmZIT3ZrZ3NZQnJ6Z0MwNFgrbXF1WW9ibUxB?=
 =?utf-8?B?YThYMUphRVpkVTNPbEdha1NGSGo3OE9tMVVkTmpZY2w3cTdYbmc5Ui9LNk05?=
 =?utf-8?B?emhTbGhLeWdMbVVYOEQ3UU9kSjVJVWlNZWUvRWgrYkxhM2xzc01NVjBYeVRC?=
 =?utf-8?B?Y21hVGpCWk9Dd2Y0K2lKTDdxc2FsNDdRdWg0b012U253WW1iSjd4Tk1rM2NK?=
 =?utf-8?B?UVh6VXptcVJ0MXYxM3R4RVhUQ3BGcXZIOGRQejUyYUxiUEh3TTBDWU5pN1Z4?=
 =?utf-8?B?NHpIWlZGbmRybkNLd0hVQStTbzZ2Ynp0RnZGTzJkR2hpaXh3Ujh4M0FuQjdi?=
 =?utf-8?B?eFFoMVhLOTBJR2RhWjNYWGo1Y1ZIWTFHRDVxMHUxYWRhdnJ4QjJTRHNMSlkv?=
 =?utf-8?B?NGhFeXJEbUNabE93d2xmbzE1VE84NzlSTzNHeEZGckxKMkRFdUQ1azNNaXVN?=
 =?utf-8?B?a2NDR1pwWGNjR1Zyc1lqL0U1WnBybVUycVBCS2pDYmNYNVkzNHo1TkhUUng1?=
 =?utf-8?B?RkE9PQ==?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 979c4868-209f-4c79-33b7-08da66e57eee
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1501MB2055.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2022 04:42:01.4109
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CjhHFjoX/c2ZY7FyZkffhuLIQps9iHUCfYlfNd7GpL3q6CIp9CluwxU7qsDqRBqr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR15MB4620
X-Proofpoint-GUID: aXCN5Soa21CpcnuGSuBzQWQEQMX-rS31
X-Proofpoint-ORIG-GUID: aXCN5Soa21CpcnuGSuBzQWQEQMX-rS31
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-16_03,2022-07-15_01,2022-06-22_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/12/22 7:58 AM, Benjamin Tissoires wrote:
> This allows to have a better control over maps from the kernel when
> preloading eBPF programs.
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

Acked-by: Yonghong Song <yhs@fb.com>
