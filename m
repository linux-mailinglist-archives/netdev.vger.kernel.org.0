Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCEFF52DDE6
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 21:43:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243423AbiESTno (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 15:43:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240779AbiESTnn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 15:43:43 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 769145A2D4;
        Thu, 19 May 2022 12:43:39 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 24JFG7gf013202;
        Thu, 19 May 2022 12:43:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=Bi6MbZ/fwh8kTuD0vWFbDJdahDqE5GQ/BMC+HnTYdeg=;
 b=kPB9IUNuaUvw2Nm+m6++XbrkctVQs5KBAiasd855rALmcFL8L9IH54T6D8aVPjcXe3yR
 77mGReZnZZ8fmsBgI/HEC5rvhJHTYwooBM3VR6xvIWxuI1dRqZuybkaZTJutTiMkHYsf
 p1gLeQTwhNtQ4l961mKlqNB6eiR6THGV8z0= 
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2043.outbound.protection.outlook.com [104.47.74.43])
        by m0001303.ppops.net (PPS) with ESMTPS id 3g4myhxefa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 May 2022 12:43:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OxMupC87hWtLZ7VRSuq+lRWXjfWjuLO1e6xkiPJrqKI4afMTEwBBGFAprks9HrPv+gKi/vTBdsKZvNWZ8ahU2v/S/8HDwbFx8GYTLXXzPMUuiBwP5dpiT7mPax9En9FUdnKXMCYNY2Hs9wUx9nmZ+8lRXfHCNXcp7tPXoKKsvNZOXlC1Nal8b3joefujw0UnZYnNOMzAMX1dACjAe+gQik5ForUShR1udTWKL7PdH6LErTEJs6CFIj+JbKHZtyVpUFtfCYK0H1eFiBQNzkVhZP/2ts/MGL/PWFWrvWo5s631TPPiU5npUk7YWT/+IYN8yVo0dUOJ+vlziIAbHta40w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Bi6MbZ/fwh8kTuD0vWFbDJdahDqE5GQ/BMC+HnTYdeg=;
 b=TZnuXOtN/hzr/cUnapq1CjNMhEDPVi0WravplpWay5DNnBYDkbB83YHb/z+821lF9Nqve5or1WzBd3Hh9DS3QH4jGqZQxeAnnSoPAcnd+vFg0sFdyfpU9LNF2R8ewCoFvW6lSOvv1RR/yIYAz56jsTcnkKKgGcK7jIO3Uez6mu6PV1QheOOsFhazHuf4EbmDGV0N74ovbjz7xHv49hEgTShaU5wnxzM59CV6gVv6qh2WchBV2sa0YorlMuaCFHeUdF2RI6H49+2bQdxdKCwn1er6h4T1IXddMHRIL03AzZr1gLUP7qW41/2LCuzIMBDmWFDTm3bwX3E7hbYUBe6oLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by BYAPR15MB2197.namprd15.prod.outlook.com (2603:10b6:a02:8e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.14; Thu, 19 May
 2022 19:43:20 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::5811:4996:bbfd:3c53]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::5811:4996:bbfd:3c53%7]) with mapi id 15.20.5273.015; Thu, 19 May 2022
 19:43:20 +0000
Message-ID: <0468355f-1d95-d5df-4560-f9220c7a0d05@fb.com>
Date:   Thu, 19 May 2022 12:43:18 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [PATCH bpf v4 3/3] libbpf, selftests/bpf: pass array of u64
 values in kprobe_multi.addrs
Content-Language: en-US
To:     Eugene Syromiatnikov <esyr@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org
References: <cover.1652982525.git.esyr@redhat.com>
 <0f500d9a17dcc1270c581f0b722be8f9d7ce781d.1652982525.git.esyr@redhat.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <0f500d9a17dcc1270c581f0b722be8f9d7ce781d.1652982525.git.esyr@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR03CA0026.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::31) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9391951e-c526-479e-7d56-08da39cfd415
X-MS-TrafficTypeDiagnostic: BYAPR15MB2197:EE_
X-Microsoft-Antispam-PRVS: <BYAPR15MB21978D5A9060BA198835247DD3D09@BYAPR15MB2197.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: evz96ElPFBFloRP8DAEO5sVfGkiljSLYu4fGXPX8jgcHT9QbTyO4xMH7LLCA7mtxc7O9CZ2IK+n2TbaZBo0hehbhgx1BRt/Ue+g4NBB6HROyaTXBeF3/j4Gowqir03j26eyuS2RA9wd3STCn/DhWLy0MMHMgnjPUSNE7BSXTywV1miasLGUC8U6BFNNndjmT2AD0zsyk1TEa75dxgsDgOC8HAne4s2WBWWe7lmYp4IQnwZcJyo0w5oftMtgP1I/0ODXix7G3YW7s3be97NGEJeAVeQ6d7GvUFXIkje4B93ynky2xuitH1WCwyZG5PLHX83UHxwlQaIPDbU6YzvFFpWOVp0EKY9vwI2AEVsb0MUe2x+dWuaAr2BtVVXON4r17YkyHan7XdgYKuvSt4xj8LpPbUcPKZbahvyXIIMJPt0F2V0tzSO6MnEIb/tEdordD3kh8bC6DEfPQ5HtMSahlJRteujmUu7Vv0Z19ZjyhT3X7e534j21XUdgbEZSc7Mc4UfbT/klBPKVe8NjBmWWBeRjEe7to3KuKggmsAA0S658hw40/iMUjQ48M+PWxl/ooHtj4Kg9ybyeRyM2G3A6fILVSu+RbVwN5vtTXtHZQQKqBVSolt4rt2UnfwkobBGeiuTMn/vi8tf/R1X+i5VhtOwxIgaNwEho6ibJ/8TeijpiMGq3njjOoh2Cl0Het3y+7lELDf99OGQ4HRQMfdj9+xaDR70GiC5paTla8waG9gffNwB8kcxhq+8yixgcvsEJK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6486002)(110136005)(83380400001)(508600001)(8936002)(54906003)(316002)(186003)(38100700002)(2616005)(53546011)(66476007)(8676002)(66556008)(7416002)(31696002)(66946007)(2906002)(6506007)(5660300002)(52116002)(86362001)(4326008)(6512007)(36756003)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UHl4QzZTdVFuTmx2V3M0bnl4bVBhVmFqNmJFMDFZQnBsMnV0VjRzUzBHOE5r?=
 =?utf-8?B?YlBWWEliWWdPMGxkaHhQOHdWYlloalFQUjc3Lzc5VjVLMHRHcUNvQmhpVitL?=
 =?utf-8?B?QmRqZVNmTFVia241Y2lnVE5yY2YrMTBNY1R4ZEtHUkZmM0ROcFdQcWs4K0gx?=
 =?utf-8?B?TGViK28vOG45T0JvdUhvRTdlc1RQdjhCNnF1bXZ3MjFpSCtiUkVvdnM3L3RN?=
 =?utf-8?B?MURXZTlIVi8wYkJFb1U0K0hmWjJ2cGNPeFZEd2dXODdiYjBLSGZ3dW5jQXp3?=
 =?utf-8?B?eHkrU1pIeVpMZldVYkdpb3E4OXp2UXpOdmhZQnRMV0ZneC95dFNvQUk0QnFt?=
 =?utf-8?B?TGMxWGxNRExGcDJmK3NQaWZwRm5BUTlDcnFKYThDa2RsYnZzVlRGT3RFc0k2?=
 =?utf-8?B?V3BLaG1yNVJ2eU1wck5sZm5sNkhuUDhJbGNCYXZaVXQxR2d1bmZUSk01WTFZ?=
 =?utf-8?B?R0xMdm1CQk9RTW9DT2NmSGRDd1FYY0s5ZG9TQ3h2bU1MZzRNQ05ua052cURZ?=
 =?utf-8?B?djJWSHVuZDFpQXZ4R2Ewb05UUVIvRFkyZkRrUnUwS0I2Z0FGbWMySlQ3bWp4?=
 =?utf-8?B?MHNzTDh5S2E5R3lLckUza2J0OXdhMVRpVTMxODFCUUhyR1dDWjVQNUN4cFlO?=
 =?utf-8?B?NGNacjB2bHpDc09VWWlRdC9RTFB2cWtTNUpNalgzYzJUZG4vaTNuZjFrbHZT?=
 =?utf-8?B?RHRkRHdxMi9naW8xajQxWkZCUEdoWXJtUHArWlBPRzY4cWJNcVg3cHp2ZG1Y?=
 =?utf-8?B?T0ExTDJaeTh4ZTdyUWtIVTAydk13bWtGOUZsMEdtaWVRSDZ4VGhNcDN1VW90?=
 =?utf-8?B?Sk10enRnUENmVzZVc3pzdzgxQXdKeWFzMElYU2VrM05OdE9yWGFFSDBvVExi?=
 =?utf-8?B?STh2NUxwcmptQjcwTEpRVUYvTXpEa29DRjVuY29FOHNjTXNQM0J1Zk1tWEF5?=
 =?utf-8?B?QkxkcERBMXJNVzhkaURENFVEc3Y4Y0x5eUNWZ0FHRlNhT2V6TXJ3WDMrRW5r?=
 =?utf-8?B?ckFSTjBiRmpaTFJJcVl1WUVZbFVnR1dOek8xQ213S0thVEdRVGlBcVhUbWd1?=
 =?utf-8?B?dmczSWhkTGdnRDNWWURBMkI1RURlekNqUndEMzVUNVNFSy9WcTBJeDJ1a0Ni?=
 =?utf-8?B?TlVCREEvWERMR29ySzk4N1FNbVBrOGFGTUttVTl4WWNRRVVaWS8rYWZTd3Fa?=
 =?utf-8?B?TDFPNWFmZGJIYmJ4TjBRakY4SytKWGxmMGx2RDIrNVpyRmRvQTI5eTVHVWZH?=
 =?utf-8?B?VGNlcmUreGU0M09wS0hGRmFndWFkeHF6amxGOUlwQTFiWXhjTTR3QUVGS3dE?=
 =?utf-8?B?Nkl0a2pIV1JGYkVxT0JRNXVGK0FGdGVKR05NS1N4ZWZQVm5Mb0s0TXU3aEpI?=
 =?utf-8?B?ZmRNSXZ1RHJibTlLSDlrSk9sdFNoL3RoMUpFcnR5c09DTXQzYmIvN1ZKNkRv?=
 =?utf-8?B?RTlmTFhmVU9uZmFZQVRlL3ZZQnRGZ242cUM0c3I0N3ZpNk9YRmgrQWtGMlR5?=
 =?utf-8?B?WEl1SXdGbUxvY0VtdGh0ajdCOFFmRUc0K2Z5cTJXc2FmemxRQ0JqNnV4WXFG?=
 =?utf-8?B?SjgrOGVpb1pybUxvWWd1YUZHT29kY2Yvc1VNdkZldERSY1hZSUtxcVhaUlBr?=
 =?utf-8?B?eUNROGl2ZElzOE84T25kcjVPYmZYNC81N3htZzlpemFrd0d0b04yZ2ZpTUI0?=
 =?utf-8?B?ZXBmTmt6dTFXbHBzQ2xOS1BINnZLK2plSXhtSHEvRzRBYmtuaWFlZi9MWWJw?=
 =?utf-8?B?T0FOYzFqeVlzTzdlbTloQlZtYm9ZTTlyaFB1TWg3dWwwem9CT1pwT2JYaGZR?=
 =?utf-8?B?UmhNZElsbmZGVFp4VjkzSWhreEhFbkhqUk5ZRTJ6OG50Ylo2WWczSmxBblBO?=
 =?utf-8?B?MHE2eDArSU1QWVJXMGhReEpLNkQvV1J1UmRmNkk0Y05IenF0SXRiNDU2R3Ra?=
 =?utf-8?B?bWEwam1vN1BKZ2JQMktJajRuU3lXb3RXS1pSRVpvbXBodlFHWGs5a0tIWTJx?=
 =?utf-8?B?b203cnhuTUsrUDd4UnM0bHM1d05mRnd0VWQrV0EvMGFmSFQ0d2E3a09KeWxv?=
 =?utf-8?B?V00zVVBzS0dCSXhiVkFjTm1aRHhlQ0JCRmIwT1haR3Z5RXRjVXpod1dwczAz?=
 =?utf-8?B?M2oreFVCbnBaRlR5eHVZSHM1cVBjdU8xc3l1UVYvSUhsbnN1K3VLd1JrM3hv?=
 =?utf-8?B?WDAwc3RBRk81b09ObGJCM095U0F5UFFUa1E3VHcyaFlrVTZEamFKNmQzNWlm?=
 =?utf-8?B?ZFp4NmdRSE5qbzgxVmZLUW9mVWpLUkFoTE5pUzQwbWk3NW0zWjZpaVNPbXNj?=
 =?utf-8?B?WklMS3ArZU41SEtMVHRhWHJ4TGdSR21UMXRBM1RwUWNGWUw4bWtpQ2c0eUJX?=
 =?utf-8?Q?oHDutlBJcXdQZ0aw=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9391951e-c526-479e-7d56-08da39cfd415
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2022 19:43:20.7100
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l0pqb5AuEy7/xPXW8YO2r3kB0n14kTGTC+ZITn6c3TSZ8wb0L05xQnFPXmxjYxAo
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2197
X-Proofpoint-ORIG-GUID: cGMtXOmTlGyBiiwfQxkjK2mvpffdWWbn
X-Proofpoint-GUID: cGMtXOmTlGyBiiwfQxkjK2mvpffdWWbn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-19_06,2022-05-19_03,2022-02-23_01
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/19/22 11:14 AM, Eugene Syromiatnikov wrote:
> With the interface as defined, it is impossible to pass 64-bit kernel
> addresses from a 32-bit userspace process in BPF_LINK_TYPE_KPROBE_MULTI,
> which severly limits the useability of the interface, change the API
> to accept an array of u64 values instead of (kernel? user?) longs.
> This patch implements the user space part of the change (without
> the relevant kernel changes, since, as of now, an attempt to add
> kprobe_multi link will fail with -EOPNOTSUPP), to avoid changing
> the interface after a release.
> 
> Fixes: 5117c26e877352bc ("libbpf: Add bpf_link_create support for multi kprobes")
> Fixes: ddc6b04989eb0993 ("libbpf: Add bpf_program__attach_kprobe_multi_opts function")
> Fixes: f7a11eeccb111854 ("selftests/bpf: Add kprobe_multi attach test")
> Fixes: 9271a0c7ae7a9147 ("selftests/bpf: Add attach test for bpf_program__attach_kprobe_multi_opts")
> Fixes: 2c6401c966ae1fbe ("selftests/bpf: Add kprobe_multi bpf_cookie test")
> Signed-off-by: Eugene Syromiatnikov <esyr@redhat.com>
> ---
>   tools/lib/bpf/bpf.h                                        | 2 +-
>   tools/lib/bpf/libbpf.c                                     | 8 ++++----
>   tools/lib/bpf/libbpf.h                                     | 2 +-
>   tools/testing/selftests/bpf/prog_tests/bpf_cookie.c        | 2 +-
>   tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c | 8 ++++----
>   5 files changed, 11 insertions(+), 11 deletions(-)
> 
> diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
> index f4b4afb..f677602 100644
> --- a/tools/lib/bpf/bpf.h
> +++ b/tools/lib/bpf/bpf.h
> @@ -417,7 +417,7 @@ struct bpf_link_create_opts {
>   			__u32 flags;
>   			__u32 cnt;
>   			const char **syms;
> -			const unsigned long *addrs;
> +			const __u64 *addrs;

Patch 2 and 3 will prevent supporting 64-bit kernel, 32-bit userspace 
for kprobe_multi. So effectively, kprobe_multi only supports
64-bit kernel and 64-bit user space.
This is definitely an option, but it would be great
if other people can chime in as well for whether this choice
is best or not.

>   			const __u64 *cookies;
>   		} kprobe_multi;
>   	};
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 809fe20..03a14a6 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -10279,7 +10279,7 @@ static bool glob_match(const char *str, const char *pat)
>   
>   struct kprobe_multi_resolve {
>   	const char *pattern;
> -	unsigned long *addrs;
> +	__u64 *addrs;
>   	size_t cap;
>   	size_t cnt;
>   };
> @@ -10294,12 +10294,12 @@ resolve_kprobe_multi_cb(unsigned long long sym_addr, char sym_type,
>   	if (!glob_match(sym_name, res->pattern))
>   		return 0;
>   
> -	err = libbpf_ensure_mem((void **) &res->addrs, &res->cap, sizeof(unsigned long),
> +	err = libbpf_ensure_mem((void **) &res->addrs, &res->cap, sizeof(__u64),
>   				res->cnt + 1);
>   	if (err)
>   		return err;
>   
> -	res->addrs[res->cnt++] = (unsigned long) sym_addr;
> +	res->addrs[res->cnt++] = sym_addr;
>   	return 0;
>   }
>   
> @@ -10314,7 +10314,7 @@ bpf_program__attach_kprobe_multi_opts(const struct bpf_program *prog,
>   	};
>   	struct bpf_link *link = NULL;
>   	char errmsg[STRERR_BUFSIZE];
> -	const unsigned long *addrs;
> +	const __u64 *addrs;
>   	int err, link_fd, prog_fd;
>   	const __u64 *cookies;
>   	const char **syms;
> diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> index 05dde85..ec1cb61 100644
> --- a/tools/lib/bpf/libbpf.h
> +++ b/tools/lib/bpf/libbpf.h
> @@ -431,7 +431,7 @@ struct bpf_kprobe_multi_opts {
>   	/* array of function symbols to attach */
>   	const char **syms;
>   	/* array of function addresses to attach */
> -	const unsigned long *addrs;
> +	const __u64 *addrs;
>   	/* array of user-provided values fetchable through bpf_get_attach_cookie */
>   	const __u64 *cookies;
>   	/* number of elements in syms/addrs/cookies arrays */
> diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_cookie.c b/tools/testing/selftests/bpf/prog_tests/bpf_cookie.c
> index 923a613..5aa482a 100644
> --- a/tools/testing/selftests/bpf/prog_tests/bpf_cookie.c
> +++ b/tools/testing/selftests/bpf/prog_tests/bpf_cookie.c
> @@ -137,7 +137,7 @@ static void kprobe_multi_link_api_subtest(void)
>   	cookies[6] = 7;
>   	cookies[7] = 8;
>   
> -	opts.kprobe_multi.addrs = (const unsigned long *) &addrs;
> +	opts.kprobe_multi.addrs = (const __u64 *) &addrs;
>   	opts.kprobe_multi.cnt = ARRAY_SIZE(addrs);
>   	opts.kprobe_multi.cookies = (const __u64 *) &cookies;
>   	prog_fd = bpf_program__fd(skel->progs.test_kprobe);
> diff --git a/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c b/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c
> index b9876b5..fbf4cf2 100644
> --- a/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c
> +++ b/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c
> @@ -105,7 +105,7 @@ static void test_link_api_addrs(void)
>   	GET_ADDR("bpf_fentry_test7", addrs[6]);
>   	GET_ADDR("bpf_fentry_test8", addrs[7]);
>   
> -	opts.kprobe_multi.addrs = (const unsigned long*) addrs;
> +	opts.kprobe_multi.addrs = (const __u64 *) addrs;
>   	opts.kprobe_multi.cnt = ARRAY_SIZE(addrs);
>   	test_link_api(&opts);
>   }
> @@ -183,7 +183,7 @@ static void test_attach_api_addrs(void)
>   	GET_ADDR("bpf_fentry_test7", addrs[6]);
>   	GET_ADDR("bpf_fentry_test8", addrs[7]);
>   
> -	opts.addrs = (const unsigned long *) addrs;
> +	opts.addrs = (const __u64 *) addrs;
>   	opts.cnt = ARRAY_SIZE(addrs);
>   	test_attach_api(NULL, &opts);
>   }
> @@ -241,7 +241,7 @@ static void test_attach_api_fails(void)
>   		goto cleanup;
>   
>   	/* fail_2 - both addrs and syms set */
> -	opts.addrs = (const unsigned long *) addrs;
> +	opts.addrs = (const __u64 *) addrs;
>   	opts.syms = syms;
>   	opts.cnt = ARRAY_SIZE(syms);
>   	opts.cookies = NULL;
> @@ -255,7 +255,7 @@ static void test_attach_api_fails(void)
>   		goto cleanup;
>   
>   	/* fail_3 - pattern and addrs set */
> -	opts.addrs = (const unsigned long *) addrs;
> +	opts.addrs = (const __u64 *) addrs;
>   	opts.syms = NULL;
>   	opts.cnt = ARRAY_SIZE(syms);
>   	opts.cookies = NULL;
