Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 410434D54E8
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 23:55:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344486AbiCJW40 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 17:56:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232738AbiCJW4Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 17:56:25 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7752518461D;
        Thu, 10 Mar 2022 14:55:22 -0800 (PST)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22AIOWud013415;
        Thu, 10 Mar 2022 14:54:55 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=P545YBNZ0IiZMYTYC4O5lZV4D7HKNXo5UuoqtZDEYAA=;
 b=HrBbUIJCEZQdTc4o9OOqyhe/lp70XHoyI7vuPOyLv7avboYvkgjtLgvFUUUr4lzrS3oy
 qWR/maOHG8OHDH3aiUyLiZztJlniiU1Nljt6FxjQL3/GjpVRcDXUVwY59tTEKEOHhOiP
 S/kagtxX3Eavw93mzavTWY7sAYrNB8lL9Bg= 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2173.outbound.protection.outlook.com [104.47.59.173])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3eqpk7223q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Mar 2022 14:54:54 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ixyRmZGjnLFti8iQACvijc4iqD+sIqHADuO/Pw8g9mkJ27X137WdiabybcDTUM+9OmYmdcaAwWrVY4DPlCZX9OZuSJPgaXCIjPqSvTddwGx3BXZ2CLWawD0RsE5pEO8LVJEMk/+0JW8IYEtOqBgMtmZ2QZpAt5eyQ/bSiX6+kBCBXmmMNn5z57JhRmEW88fv05rFirvAf5AHVpyNeeG0QLDoYaa2NB/JTdqqyrMF1wpA4AV5dlMNXPpFVya7yd2jH4z0duxfDySmC6ngpWpfMbfArsUyHhrE1WY0PIM5mPnVx+qCNG6zl1cOsMxyx6rK9oisS41JcKbHLQy9vOJIfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P545YBNZ0IiZMYTYC4O5lZV4D7HKNXo5UuoqtZDEYAA=;
 b=FRyuNbA6acG9spT3xp8cbcIyIcF3Tq+7ADopUt5jNGIlkRrTHp9r5JkqbRGn5QGIHPTnwdv20atMNnkBcCWPY1hDX6rCBH+Vi8h12n6ljCobZ48xbYYRG4Z2MsMUGCBtlv3hcblLHq62jhnumHXM/ImPnZ4qjiJKzFGGt3i04pjrow+8EToQU7d9BXkKxH9kcuBvi5qy0PwH5tzI5u8xZ/J6AyEmxR0uEshIkrh4QBPuO0c1ZEU8H6+I2QqJpb+9BeS5DXMlmHCu/aFpVFQClBHHN63IxTGH11M/6GvvzdufQSyuDSi5V/7kg/Dd08oyWfGcgyOqYvYQho9YyX1AmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4739.namprd15.prod.outlook.com (2603:10b6:806:19e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Thu, 10 Mar
 2022 22:54:52 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::c5c7:1f39:edaf:9d48]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::c5c7:1f39:edaf:9d48%4]) with mapi id 15.20.5061.022; Thu, 10 Mar 2022
 22:54:52 +0000
Message-ID: <d2af0d13-68cf-ad8c-5b16-af76201452c4@fb.com>
Date:   Thu, 10 Mar 2022 14:54:48 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.2
Subject: Re: [PATCH 1/2] bpf: Adjust BPF stack helper functions to accommodate
 skip > 0
Content-Language: en-US
To:     Namhyung Kim <namhyung@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Eugene Loh <eugene.loh@oracle.com>, Hao Luo <haoluo@google.com>
References: <20220310082202.1229345-1-namhyung@kernel.org>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <20220310082202.1229345-1-namhyung@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-ClientProxiedBy: MWHPR13CA0021.namprd13.prod.outlook.com
 (2603:10b6:300:16::31) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 830bfbe0-75fa-44fe-9dac-08da02e8fd05
X-MS-TrafficTypeDiagnostic: SA1PR15MB4739:EE_
X-Microsoft-Antispam-PRVS: <SA1PR15MB4739301DC32F9429BE1BAF73D30B9@SA1PR15MB4739.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aJpa4EGmBpwI4jKqPpX0bXY7UeOV6QvYvvx5GkrzOQ9SxshtHYb3s4cxYP6pefT/qJr0+qCtNnxUO0zhjEd5kfIwDnXwSP+gv/qaArWhDAw6tcjyvQbwf1rOqobUfq9gX52yo2Wya2b8HOKw4Qe+S7uJU9+T4OsqA5CPO8IzhaeHnB4z4NRWQ0ozQCtbbbEqECcQvA9eRoyUIkIrYYlq3XnjeV8YAkzCt11aedw3Veq1GhKf/HQ+6RNTydFey7vPhVRc/COTPST5QUzSA5tbik+XwnZkExsSiReaWl4Q+CWxJL/zbSDysbE0w1lZMMMPBEsTrJfJtc5eOIS6fcRtGlLM40ilTdCS+v92o+mJzcMEZWpXUSpFhCkKT8UKQyAY74BBLBp4+HnRV7g+DlkDijWXA8RtVRQycXmkHrySYZEAb8ASv2Qt+f3SSoRFRXHx7bmB9Z2hJs/Wj9zSHHzWWJjLq1qZYabuNNNfjfoK0v5EyK0AsgyO0vkcKykNN87NwKw8mtjG2CPGpr5f0WLJ+eONCz1sfT6MoC29ZjMP4dpaAurrT2q2CMmAsjj1QWomkcB/Ew+HrbSHtnEtqypggoRNxWvx4ibQxllxU6oYaTgJCF2e2X3eXAUFynINcu5y9ia5X3mXOVTyai8E8VQDybFFTVYza9+PXvwLbQDdIx45k1ojeqQwIbZjhbLd9/MR/3Y8CelJ1ces8OJmfHPsooPGxeMHytZn0VsvNz2QJj7WDL15IQYBMD/nQlHzy5K4g6INin9Vunz234emfLGc/wIQy+Mfca66TfDi6lOYOWLADsyzfNFh1mQqF7vivVJCLw8BazX/uwg6LZ7oopeZew==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(53546011)(6506007)(966005)(36756003)(38100700002)(31686004)(2616005)(83380400001)(2906002)(5660300002)(7416002)(316002)(54906003)(66556008)(66946007)(8936002)(6512007)(52116002)(8676002)(31696002)(508600001)(186003)(6486002)(86362001)(6666004)(4326008)(110136005)(66476007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cDkzdUdmNStTcm1QY1pYSjNGenZ1b09rVVEvcnh1eHdldWlQR0U3K1lwQ3BY?=
 =?utf-8?B?ZE1BaTdMOCtxem9sYk4zcWpaR3dEbW1NU2FlSFRmQWNIZFlFcWlBZkNnNmNt?=
 =?utf-8?B?ZXR4MXM1aHhLRTZzVFBOVERRV0dvMGwybjVsRitQY1RzNDNsZEdHdmM0bVlU?=
 =?utf-8?B?MTlpMG1GTlIrdGx5UC96Rlh0SFAzeVdWb3ZRZlFFOWNEaE1lR1F1ZWlvYVB0?=
 =?utf-8?B?RUtydFlJcTRlMGNnODRaMXhMVi83VGQ0Z2JYMGlLSWhjemFUMm5aWDRQbHdy?=
 =?utf-8?B?Y3kydWpvRSszZHJCS2JRL3dHaWF4d1pHY2I0MjdtY1JSZnd2SGlzWm1HcE9w?=
 =?utf-8?B?MDlYR25GbUhuOGE4U1lTRDZXSklIaVJ3YmQyZ0lwUTBDMUtDK2JHbDF4WHZZ?=
 =?utf-8?B?ZjVwZEw5VWE5WTJWeHBEcEZRTjNJamYvek1BZjRHTU1QWGM2RmhSTEhhRTFX?=
 =?utf-8?B?K3Qvc3U3MVRhOVBaVXErZDczSFpPUHZ3MjltVExUTWhMbHkrV0pKY0dPVkxL?=
 =?utf-8?B?NkhIMStxditJakdVTUVpaWVlc3I0N3JnNW5EbmtOalg0ZkZ5OVNZSWQ2alRo?=
 =?utf-8?B?TUhKbzVjcEFwMzZhOE1tNlhxTW9BeUI2SFZiR0xFUjk4VTdrcE1rQXV0d1ly?=
 =?utf-8?B?L1FkOWpBcVd3cDV2dy9YZVorWXNkUTNrYnFpUGp5UFdUUzhBOVNZTUVKSVk5?=
 =?utf-8?B?NkVUWDFUN2VvOHRkb1UxRmdaUEpmU1BhUlJ2bnY2ZjRrOGdDVFAzY096eTl5?=
 =?utf-8?B?dEFkSktIeno0VTV6OVJPeFlwS3QxVXh4WiszOXJDK2lIbitNUEJnVjlSQ2hS?=
 =?utf-8?B?Q1EwVkZsaDliSGJRRTFsYk05M1hWVmVEbDVaL0NoQTlmQU1IcHo4TTVsVXRL?=
 =?utf-8?B?eXlqZU1VTGVUWUtFSzVpRzdydGZjclpZdFdvbTFJaElqQ1BidEcrS2tyT3Jn?=
 =?utf-8?B?V3VDZ2wvSkdMbDYwQTNBTFZ0ajEzMnVMMnpkSkMxWE9EUzFZbWsxNWtWZmV5?=
 =?utf-8?B?R2dKU3E0QVZQZTBRY3NrMDlaYjNUMTQrQ2dUaUhKTlBBZU9hY2ROQi9naG4v?=
 =?utf-8?B?dDc0Z0xxbUZNdmw0amp2QzVOYWZRVjhnYmNqa2Nub0Uyd3E5bi9Xa0RTWHBm?=
 =?utf-8?B?dkVLSEtsOUF5aGg4VVpZM0gralRBZHRkaTBMWEFiblRQY01LMWExTWE2N0Zm?=
 =?utf-8?B?Vkw3c2xZZVE4YUlsM0pvcWlERS9iTUlJUmZscUtsejVkUmk0TW9KYkJzVGpN?=
 =?utf-8?B?NGR5UUlUUFZIaGVQSlRKanBkbFhxcVVVSzFGaSsySlR2eHVLMHcwZFBiUVU3?=
 =?utf-8?B?UThEZkRYbnNPdWExNzM4UmxzdjFZN09XN3BwRGVuYUQzenUvVjUxYTkxUmti?=
 =?utf-8?B?Q2dXMEVvd1dzZDNqQy9ELzBydEFpTE1Db2JncGxVdUVxLzQ0Qkw4SkdiTnNZ?=
 =?utf-8?B?R3R0ZVc0bVMyVnptTm9HemowTkROdjl0d1hVWDE3YWpnazlyS284U3VLVnI3?=
 =?utf-8?B?NFlDeC9vNnpKcTFrSEtjMlkydGRBWWp4L0k4NjRkWVBtWnk1aHZyZGVFRnFt?=
 =?utf-8?B?N2w4SzNyZmVGK3VVNzVBMlhRUXRuT25lTzJ1dUVQRGVLcGdQL2tBbkxreWlw?=
 =?utf-8?B?WEtKSzkxVUVPZ0EvQjRla0N1UWN5bGpBQjFZdmltRDhEb3ovZWd6bUgwWVpF?=
 =?utf-8?B?azgvc0xKUG40RUJFZzlkSHNvN0Z0VkFaZWxJS3U4d014akZYKzErWVlsVjJ3?=
 =?utf-8?B?QUxVNVM0VkNWb3FZU25HTWNzeGxBcWE5Rit6WE1WUVBhUC9td0J5b1V0dElN?=
 =?utf-8?B?UmtYVGd0QjV0SlpnL3NXenp4eWFqYmJlaEgyeHRQcE83V1Azdk1pa3RObGRx?=
 =?utf-8?B?aktNK2FjQ1c4aCtVWjROL0RjWHhDREI5WW9EK01TaU5vZ2x6Ly9ZSTVLb0tZ?=
 =?utf-8?B?WkpScXZpQ1FaUEdiZ0EyT0paYUVOblRKenZQVHFER3IwQmJ3MDlnWFY1SkNv?=
 =?utf-8?B?MFZqYmZOM1ZqelhadUE1d3ZPKy9lTzlvNmNmR0h3YVA3TUd4YVEwZ1lrSjJE?=
 =?utf-8?B?azNJT3gyWHJVMGIrVjVjQnk3Uy9QeTJHMzBOWG9Xd3FBLzhIQzJvbURlK3dE?=
 =?utf-8?B?Y216Q0hodXRYMloyWHFHa2tyaFVLTXdsczl6YjNmcnlNaHFjUFBsdjNiVGln?=
 =?utf-8?B?V3c9PQ==?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 830bfbe0-75fa-44fe-9dac-08da02e8fd05
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2022 22:54:52.8268
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J3/N9AcKeTbd2nOhMa5rtqgA9E4xKE1lHXC+dDf5YHapFrxH7hQJgi8sILrrGSHg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4739
X-Proofpoint-GUID: CuJDOBX9s3O1AwA6VMgomitSzLBF6Gow
X-Proofpoint-ORIG-GUID: CuJDOBX9s3O1AwA6VMgomitSzLBF6Gow
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-10_09,2022-03-09_01,2022-02-23_01
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/10/22 12:22 AM, Namhyung Kim wrote:
> Let's say that the caller has storage for num_elem stack frames.  Then,
> the BPF stack helper functions walk the stack for only num_elem frames.
> This means that if skip > 0, one keeps only 'num_elem - skip' frames.
> 
> This is because it sets init_nr in the perf_callchain_entry to the end
> of the buffer to save num_elem entries only.  I believe it was because
> the perf callchain code unwound the stack frames until it reached the
> global max size (sysctl_perf_event_max_stack).
> 
> However it now has perf_callchain_entry_ctx.max_stack to limit the
> iteration locally.  This simplifies the code to handle init_nr in the
> BPF callstack entries and removes the confusion with the perf_event's
> __PERF_SAMPLE_CALLCHAIN_EARLY which sets init_nr to 0.
> 
> Also change the comment on bpf_get_stack() in the header file to be
> more explicit what the return value means.
> 
> Based-on-patch-by: Eugene Loh <eugene.loh@oracle.com>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>

The change looks good to me. This patch actually fixed a bug
discussed below:

 
https://lore.kernel.org/bpf/30a7b5d5-6726-1cc2-eaee-8da2828a9a9c@oracle.com/

A reference to the above link in the commit message
will be useful for people to understand better with an
example.

Also, the following fixes tag should be added:

Fixes: c195651e565a ("bpf: add bpf_get_stack helper")

Since the bug needs skip > 0 which is seldomly used,
and the current returned stack is still correct although
with less entries, I guess that is why less people
complains.

Anyway, ack the patch:
Acked-by: Yonghong Song <yhs@fb.com>


> ---
>   include/uapi/linux/bpf.h |  4 +--
>   kernel/bpf/stackmap.c    | 56 +++++++++++++++++-----------------------
>   2 files changed, 26 insertions(+), 34 deletions(-)
> 
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index b0383d371b9a..77f4a022c60c 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -2975,8 +2975,8 @@ union bpf_attr {
>    *
>    * 			# sysctl kernel.perf_event_max_stack=<new value>
>    * 	Return
> - * 		A non-negative value equal to or less than *size* on success,
> - * 		or a negative error in case of failure.
> + * 		The non-negative copied *buf* length equal to or less than
> + * 		*size* on success, or a negative error in case of failure.
>    *
>    * long bpf_skb_load_bytes_relative(const void *skb, u32 offset, void *to, u32 len, u32 start_header)
[...]
