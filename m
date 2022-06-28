Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 270D455DF82
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:30:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243435AbiF1EKG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 00:10:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232793AbiF1EKC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 00:10:02 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 550492A725;
        Mon, 27 Jun 2022 21:10:01 -0700 (PDT)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25RJ1UnT007415;
        Mon, 27 Jun 2022 21:09:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=y8R8QjI/IO7WcZLSPuHH65aIJX1yMCW8tgsdBONth+c=;
 b=IpsLLvZti/0u3OvwRL3yWoUf4x3f6HhcGK9931KvR6a433frDx6ZTX5z2nAoEhy4Jx6C
 35d6ffywKp9pa29E1ShBq1A5XIsC8tGPwjMzrGFVUR3ErVbBXxSQZ7zCKaB55IoEw3HZ
 7BED0qVWlwq2W7VUKJaSHXRgeofZpWykrbM= 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2102.outbound.protection.outlook.com [104.47.70.102])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3gyg0ac1hb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Jun 2022 21:09:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DSSW2WPv1H25qYhZDDHAJIZBrsAEnw+AAUR79b0yJrKGQmrp+NFmnv5UfiSQFlpod0PXT7ognHfy3ngAs0FfsrEjppkt4VYm3Cv1a3A3Azxcj2T9KeSGfT9XMpuPdCj7kGxMUQClVjJBTMOAGopXbXxmEllYDkHKzg72UeEhxqEOR37loPbNNVGaImO+K439SdYm8u+n31GUlkutbqBWXsy9uJSCUZFUsvHvHATvmnnnq4gMOuer6ujCsSI6KjYu/+E/Ny1+WKtfbGCZqlUeelSHus5+2pG7SPM+Hewl6Svtrm7sNky+j75g3Y6LaNjP1mY+JhWwUZtSMzHDspM+7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y8R8QjI/IO7WcZLSPuHH65aIJX1yMCW8tgsdBONth+c=;
 b=mf7j8SYjdfh3baSu57sSnKM7gOg41Y2bK+fntI/I3/n4vgy8w5SR3N+CDOWV/Gu9E00N7/VtKl5Refh7mG5cgK2uZn/mDDLXEmjYd+95Vd3FgRO+wA6p3QBar93fIpcC2DW/Twz4SJUUMPa04Ju3SE+iAxD4n1ci05WYAogP/QdIwBQPMC5uhFOzA0JgyX4SRIbnO87NwTYEwIiX05Q0CpDi53EojOxTyTdKjryS//ReodBAnBbgOP/TrGONC02VSlFXJ9CRBzLzmuMapKZF6DLKxlrOUeML9bwsstIVHOtzqBcWOLAJGlNC2QEPktn6j2rzu+7DUAv23WE6ctOYvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by BN7PR15MB2195.namprd15.prod.outlook.com (2603:10b6:406:88::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Tue, 28 Jun
 2022 04:09:39 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::9568:e5d9:b8ab:bb23]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::9568:e5d9:b8ab:bb23%6]) with mapi id 15.20.5373.018; Tue, 28 Jun 2022
 04:09:38 +0000
Message-ID: <f6c0274d-73c4-e05b-6405-4062230c4a14@fb.com>
Date:   Mon, 27 Jun 2022 21:09:35 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.10.0
Subject: Re: [PATCH bpf-next v2 4/8] bpf: Introduce cgroup iter
Content-Language: en-US
To:     Yosry Ahmed <yosryahmed@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>,
        Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Shuah Khan <shuah@kernel.org>, Michal Hocko <mhocko@kernel.org>
Cc:     Roman Gushchin <roman.gushchin@linux.dev>,
        David Rientjes <rientjes@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Greg Thelen <gthelen@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, cgroups@vger.kernel.org
References: <20220610194435.2268290-1-yosryahmed@google.com>
 <20220610194435.2268290-5-yosryahmed@google.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <20220610194435.2268290-5-yosryahmed@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR11CA0067.namprd11.prod.outlook.com
 (2603:10b6:a03:80::44) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b83a34ce-7e48-4245-92c1-08da58bc04e5
X-MS-TrafficTypeDiagnostic: BN7PR15MB2195:EE_
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ofBVQDdzujoE2cDtYYTMOC9tEgv2XXr7k9z8/DfQukimarcEoHsbkePfdiaensbKQ5bVhZyZWq+OfFl9eAtCyzNX2rSJw5LkxcjGZZ1sLvG/ZQyDCJmByqoXyp3If+hIOH7LoX3/dxqmU/20vow9/QaeqiZceUWz5atg8FQywnYp8A7K4yBz4z2LgYiVlejOi+iOAJUB15HsWWimNDZ1KGl2mksB/Fi34ZPErSZpELx6VdnMaQKiNSKMTBOpype5ce+jqAWaZTMqejSQCX73OjzMLz3TVJdp9891BAt4f0/jeDzLhePiGLNhI9LaAK51GrAFQlxdYrnljix1L+ZHQ/HgDGv/VmTVhn/o3gJEJeVAboSla98haUCW5GH0AJjvH3zLpvXiQe++PnXlqtMmv322+zrPOWXRAs/vA7cyHW77/Dv/Do/vYWgG3AFq2GxtTJ1uRajWaWADn1KrH1bkCzx0JCWEYk8J27Cu5c/Bn5Ds1F7iZLGQ+fEOk/QL8SUWe1fIpuCtoTHB5AR91qMsYgJkuUgH/CIKJ432EAPsodzXi9tF9q1dxeBnNpUcMhcXelXJ2/HrhA/rd2vTuuv7f9QcO2LZK37ASq+xyLqV6SjqEFBjJQRA7SD0stnPN/JI0sWiC4OUB8LSHHsdfGXDg50Fy3O6rOxDrICNbZP9fmDLk2mOdN73a+d3cCAi6YCk6aGJaSYE9pbEaZf9Tr/u/qCkSEQKq9dNERtSsDyiHooLKGyuSA+f+xxbH/XVy+FtlnFKJ5o9WA2Zopf3RVPHKwMedE7MXSZr29x/CLPsHJncLj0nng0rDfS7H+epxEJ9ZU8XfO5cnEDcU6YR04oNJQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(396003)(366004)(136003)(346002)(376002)(66556008)(6486002)(66476007)(41300700001)(478600001)(31686004)(36756003)(8936002)(2616005)(66946007)(86362001)(4326008)(8676002)(6506007)(83380400001)(54906003)(53546011)(7416002)(921005)(110136005)(31696002)(6512007)(5660300002)(316002)(2906002)(30864003)(6666004)(186003)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Zmx2b3FmK256K2V0K21jOGhLd0VXR3BLTWs5ZWt5TGVUdWdlQzUzc1FuOTRm?=
 =?utf-8?B?OWpLbldyZm5vVDROV0V3dWtaMGFENE5yS1hmZjQ4MTB4SEdBVllZVTdvRFdO?=
 =?utf-8?B?YWtuYUJhOU5SN3VxMTF1TkJjcHhQbGh0RlZpSzFPOXQrWUFiRnN6T2dqa2VR?=
 =?utf-8?B?MW9YdFlJUFM3TzlWbWMvZmJhWXozWlBtVFJRL3VpQWIxWkNEMVpNME8yTDhh?=
 =?utf-8?B?RXJkSzRoVDl1c3hoa3pOcjA2Yk9kVlRzMU1ROHN1ektXRUpsTklZZUNWVkcz?=
 =?utf-8?B?NjhUdXlvMDNIRFBOUnRXL0ZRUHNEYzZLbkJUcGFJbmdqRnVDRlYwVGxTSEFQ?=
 =?utf-8?B?UXdkSW5CN3d6R3ZjTmRrWEYvNmhxOW5GSEppMmduTnNMMTg1elhVSUt2ckd4?=
 =?utf-8?B?S1RFVXlBTk5BSGFUeHdsbGlNUkJQaVpObUo4OTZRRm5GMzJCY1hRQ0hkM0ZR?=
 =?utf-8?B?cDROck4xR1h4THAvVFg4MXg1S3VWV0tWRXZMNENkeHl6a2tSMW44cGx4Q05u?=
 =?utf-8?B?S0tUZWdxbDhxVzEyb2ZnZnRoWXR0RzVkb3g5Mk5EZzBGMTY2a3IxcmR5c2Jw?=
 =?utf-8?B?TkZ4YkdENnl5UjBQbGRkSFFUNnR0MmRpTEJndllFczIvMUJGU0ViSE1LZkp3?=
 =?utf-8?B?N0dDanI2NUhzL1N5QjZFRUhnYkxFMURXaXpqOEV2M2hzbUR0WU12R3NJeE1O?=
 =?utf-8?B?V0lqTDdDT1oxM0FJTzhUKytFQnJkL3kwQXhpbGxOS1o4VjFYWUZXSlNOV2w4?=
 =?utf-8?B?OURBUCtDdTRpenBpajVNWmFseWNlT1hSeHpqVkdzNmN6WThVSWdwemE2Q0dB?=
 =?utf-8?B?YzNRc3RQa0ppQUdBdXM5cjVqUHhSODFRTFhXRmsvV0JXcFFPMUJJTkVUeE96?=
 =?utf-8?B?YnlsVDg4VS9iTVVqMzdhUDNMRXl0TGdqS2huQ3l2cS9VbzM0dk9FcjErTWlT?=
 =?utf-8?B?RjhKVllXOWFVOVhMcS8wVlBRb09hVDR0bDJqYjRzMTdXbFI4N1hmR1Y5L01N?=
 =?utf-8?B?L25PV0VmNXNZdE1oNkZtVGNPWC9VcGJCVWp6LzlXRzIrd0hZVkFmUFprZTFM?=
 =?utf-8?B?L3dFVjZDeGxGZFUvSUZyeDI2OVY4UFRTRkw2WGdsc1M2NG5IME5tUytzUWVz?=
 =?utf-8?B?Vk5LSWJ3TFBUNUQrWXU2VGdsRFJIS056U2twU0VyTXpCMzNiZitkY2g0emNQ?=
 =?utf-8?B?WU9aOHZlYVQ4R09IMEk1SENIdWNUdTI0WEZwbVJjRTgxK2o3VHFKNVdWNjhp?=
 =?utf-8?B?SHFBOXQwZ2RucEl3SWdQbWJEcHJ0bVBUeHZGY1pVUTJtZEpZenIvVDRxMWtH?=
 =?utf-8?B?bGlHNFRLZmV5bGs0NVhJT0lGaStFbU1TdUZqOFhUcFB1aVpqWHBweXJCaDNr?=
 =?utf-8?B?Z21UNnMrcGZiVFJRc21abjBrbnlSNkcybnQ3MU5yWGZXZDg1QlR2dld1bWY1?=
 =?utf-8?B?RDNmYXFqZUZEdVRxd0ZOdjBHMnUyc3dKbEhNeUdwNFM5bGZ5a0Rxbi9TTEhn?=
 =?utf-8?B?eXNVNWtqMko2SkVpZXo0VTlyU0F3bkhWWkJ0MTNzeHovMGhpK2ZPQVY1dmtD?=
 =?utf-8?B?NUxxU3kvWmo2aVFZZ2dNUlQrcGd3N1ZDVUtzUS9Va3o5VCs0ajl4VlVXUjZ4?=
 =?utf-8?B?NnN2STVzekdIbE9rSHVBWXJWc214dGE2OGJDc1MxMWdTYVA3a3pEWndKdEFX?=
 =?utf-8?B?a2dXZXBvdGVTaUtBa3J1dnlLVG1Tc0NzRUZVZitsM0xkekVmSjE2UHZtcDJR?=
 =?utf-8?B?am9nMkh1RVUzSEU3dDZ4eENxYlN1eHpHdWJKbWluNG1Kc2FXbVZWc1NlclhH?=
 =?utf-8?B?b09DZ1o0U2h6a1F0YlNFU0MzODVqdld6NkprQnpGai8xNnM1QytNSFpJeU10?=
 =?utf-8?B?RTVBcG5OMlFrRnpTNGZjOEJ2MkNVWDNETkMxU2swdjdpWU95ZTNlcjFyVEpo?=
 =?utf-8?B?L2pqWndDT2gxeXZ1OSs1cUttdlhHZk9qTENmNTVqNnA1UzJDaHVyZjRxcGx0?=
 =?utf-8?B?bzJ3Vm9ucUpFcWJ5c3VLaWV1NWJrSlBxa1o3ZTlZTllFZVgxUGhXNXJiWXFj?=
 =?utf-8?B?VmsvVW8zSnoxbmlTRTcxc0N1alhRVWtzYTZvRFFTZ2YwMDdkblJiWXZCS2xB?=
 =?utf-8?Q?HcNkkP19DCB/VJQTy3DeyXS1L?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b83a34ce-7e48-4245-92c1-08da58bc04e5
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 04:09:38.6846
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JMU+7gIJdLdXPPRKpT35Z4ZEq45ntnU6eS3LsMAW8vJ29i9acMxP8CKq+yFeu2P+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR15MB2195
X-Proofpoint-GUID: hF1CAs-bRh-Zi7_jx-G9NRW-Ug_v3t8M
X-Proofpoint-ORIG-GUID: hF1CAs-bRh-Zi7_jx-G9NRW-Ug_v3t8M
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-27_09,2022-06-24_01,2022-06-22_01
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/10/22 12:44 PM, Yosry Ahmed wrote:
> From: Hao Luo <haoluo@google.com>
> 
> Cgroup_iter is a type of bpf_iter. It walks over cgroups in two modes:
> 
>   - walking a cgroup's descendants.
>   - walking a cgroup's ancestors.

The implementation has another choice, BPF_ITER_CGROUP_PARENT_UP.
We should add it here as well.

> 
> When attaching cgroup_iter, one can set a cgroup to the iter_link
> created from attaching. This cgroup is passed as a file descriptor and
> serves as the starting point of the walk. If no cgroup is specified,
> the starting point will be the root cgroup.
> 
> For walking descendants, one can specify the order: either pre-order or
> post-order. For walking ancestors, the walk starts at the specified
> cgroup and ends at the root.
> 
> One can also terminate the walk early by returning 1 from the iter
> program.
> 
> Note that because walking cgroup hierarchy holds cgroup_mutex, the iter
> program is called with cgroup_mutex held.

Overall looks good to me with a few nits below.

Acked-by: Yonghong Song <yhs@fb.com>

> 
> Signed-off-by: Hao Luo <haoluo@google.com>
> Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
> ---
>   include/linux/bpf.h            |   8 ++
>   include/uapi/linux/bpf.h       |  21 +++
>   kernel/bpf/Makefile            |   2 +-
>   kernel/bpf/cgroup_iter.c       | 235 +++++++++++++++++++++++++++++++++
>   tools/include/uapi/linux/bpf.h |  21 +++
>   5 files changed, 286 insertions(+), 1 deletion(-)
>   create mode 100644 kernel/bpf/cgroup_iter.c
> 
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 8e6092d0ea956..48d8e836b9748 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -44,6 +44,7 @@ struct kobject;
>   struct mem_cgroup;
>   struct module;
>   struct bpf_func_state;
> +struct cgroup;
>   
>   extern struct idr btf_idr;
>   extern spinlock_t btf_idr_lock;
> @@ -1590,7 +1591,14 @@ int bpf_obj_get_user(const char __user *pathname, int flags);
>   	int __init bpf_iter_ ## target(args) { return 0; }
>   
>   struct bpf_iter_aux_info {
> +	/* for map_elem iter */
>   	struct bpf_map *map;
> +
> +	/* for cgroup iter */
> +	struct {
> +		struct cgroup *start; /* starting cgroup */
> +		int order;
> +	} cgroup;
>   };
>   
>   typedef int (*bpf_iter_attach_target_t)(struct bpf_prog *prog,
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index f4009dbdf62da..4fd05cde19116 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -87,10 +87,27 @@ struct bpf_cgroup_storage_key {
>   	__u32	attach_type;		/* program attach type (enum bpf_attach_type) */
>   };
>   
> +enum bpf_iter_cgroup_traversal_order {
> +	BPF_ITER_CGROUP_PRE = 0,	/* pre-order traversal */
> +	BPF_ITER_CGROUP_POST,		/* post-order traversal */
> +	BPF_ITER_CGROUP_PARENT_UP,	/* traversal of ancestors up to the root */
> +};
> +
>   union bpf_iter_link_info {
>   	struct {
>   		__u32	map_fd;
>   	} map;
> +
> +	/* cgroup_iter walks either the live descendants of a cgroup subtree, or the ancestors
> +	 * of a given cgroup.
> +	 */
> +	struct {
> +		/* Cgroup file descriptor. This is root of the subtree if for walking the
> +		 * descendants; this is the starting cgroup if for walking the ancestors.
> +		 */
> +		__u32	cgroup_fd;
> +		__u32	traversal_order;
> +	} cgroup;
>   };
>   
>   /* BPF syscall commands, see bpf(2) man-page for more details. */
> @@ -6050,6 +6067,10 @@ struct bpf_link_info {
>   				struct {
>   					__u32 map_id;
>   				} map;
> +				struct {
> +					__u32 traversal_order;
> +					__aligned_u64 cgroup_id;
> +				} cgroup;
>   			};
>   		} iter;
>   		struct  {
> diff --git a/kernel/bpf/Makefile b/kernel/bpf/Makefile
> index 057ba8e01e70f..9741b9314fb46 100644
> --- a/kernel/bpf/Makefile
> +++ b/kernel/bpf/Makefile
> @@ -8,7 +8,7 @@ CFLAGS_core.o += $(call cc-disable-warning, override-init) $(cflags-nogcse-yy)
>   
>   obj-$(CONFIG_BPF_SYSCALL) += syscall.o verifier.o inode.o helpers.o tnum.o bpf_iter.o map_iter.o task_iter.o prog_iter.o link_iter.o
>   obj-$(CONFIG_BPF_SYSCALL) += hashtab.o arraymap.o percpu_freelist.o bpf_lru_list.o lpm_trie.o map_in_map.o bloom_filter.o
> -obj-$(CONFIG_BPF_SYSCALL) += local_storage.o queue_stack_maps.o ringbuf.o
> +obj-$(CONFIG_BPF_SYSCALL) += local_storage.o queue_stack_maps.o ringbuf.o cgroup_iter.o
>   obj-$(CONFIG_BPF_SYSCALL) += bpf_local_storage.o bpf_task_storage.o
>   obj-${CONFIG_BPF_LSM}	  += bpf_inode_storage.o
>   obj-$(CONFIG_BPF_SYSCALL) += disasm.o
> diff --git a/kernel/bpf/cgroup_iter.c b/kernel/bpf/cgroup_iter.c
> new file mode 100644
> index 0000000000000..88deb655efa71
> --- /dev/null
> +++ b/kernel/bpf/cgroup_iter.c
> @@ -0,0 +1,235 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/* Copyright (c) 2022 Google */
> +#include <linux/bpf.h>
> +#include <linux/btf_ids.h>
> +#include <linux/cgroup.h>
> +#include <linux/kernel.h>
> +#include <linux/seq_file.h>
> +
> +#include "../cgroup/cgroup-internal.h"  /* cgroup_mutex and cgroup_is_dead */
> +
> +/* cgroup_iter provides two modes of traversal to the cgroup hierarchy.
> + *
> + *  1. Walk the descendants of a cgroup.
> + *  2. Walk the ancestors of a cgroup.

three modes here?

> + *
> + * For walking descendants, cgroup_iter can walk in either pre-order or
> + * post-order. For walking ancestors, the iter walks up from a cgroup to
> + * the root.
> + *
> + * The iter program can terminate the walk early by returning 1. Walk
> + * continues if prog returns 0.
> + *
> + * The prog can check (seq->num == 0) to determine whether this is
> + * the first element. The prog may also be passed a NULL cgroup,
> + * which means the walk has completed and the prog has a chance to
> + * do post-processing, such as outputing an epilogue.
> + *
> + * Note: the iter_prog is called with cgroup_mutex held.
> + */
> +
> +struct bpf_iter__cgroup {
> +	__bpf_md_ptr(struct bpf_iter_meta *, meta);
> +	__bpf_md_ptr(struct cgroup *, cgroup);
> +};
> +
> +struct cgroup_iter_priv {
> +	struct cgroup_subsys_state *start_css;
> +	bool terminate;
> +	int order;
> +};
> +
> +static void *cgroup_iter_seq_start(struct seq_file *seq, loff_t *pos)
> +{
> +	struct cgroup_iter_priv *p = seq->private;
> +
> +	mutex_lock(&cgroup_mutex);
> +
> +	/* support only one session */
> +	if (*pos > 0)
> +		return NULL;
> +
> +	++*pos;
> +	p->terminate = false;
> +	if (p->order == BPF_ITER_CGROUP_PRE)
> +		return css_next_descendant_pre(NULL, p->start_css);
> +	else if (p->order == BPF_ITER_CGROUP_POST)
> +		return css_next_descendant_post(NULL, p->start_css);
> +	else /* BPF_ITER_CGROUP_PARENT_UP */
> +		return p->start_css;
> +}
> +
> +static int __cgroup_iter_seq_show(struct seq_file *seq,
> +				  struct cgroup_subsys_state *css, int in_stop);
> +
> +static void cgroup_iter_seq_stop(struct seq_file *seq, void *v)
> +{
> +	/* pass NULL to the prog for post-processing */
> +	if (!v)
> +		__cgroup_iter_seq_show(seq, NULL, true);
> +	mutex_unlock(&cgroup_mutex);
> +}
> +
> +static void *cgroup_iter_seq_next(struct seq_file *seq, void *v, loff_t *pos)
> +{
> +	struct cgroup_subsys_state *curr = (struct cgroup_subsys_state *)v;
> +	struct cgroup_iter_priv *p = seq->private;
> +
> +	++*pos;
> +	if (p->terminate)
> +		return NULL;
> +
> +	if (p->order == BPF_ITER_CGROUP_PRE)
> +		return css_next_descendant_pre(curr, p->start_css);
> +	else if (p->order == BPF_ITER_CGROUP_POST)
> +		return css_next_descendant_post(curr, p->start_css);
> +	else
> +		return curr->parent;
> +}
> +
> +static int __cgroup_iter_seq_show(struct seq_file *seq,
> +				  struct cgroup_subsys_state *css, int in_stop)
> +{
> +	struct cgroup_iter_priv *p = seq->private;
> +	struct bpf_iter__cgroup ctx;
> +	struct bpf_iter_meta meta;
> +	struct bpf_prog *prog;
> +	int ret = 0;
> +
> +	/* cgroup is dead, skip this element */
> +	if (css && cgroup_is_dead(css->cgroup))
> +		return 0;
> +
> +	ctx.meta = &meta;
> +	ctx.cgroup = css ? css->cgroup : NULL;
> +	meta.seq = seq;
> +	prog = bpf_iter_get_info(&meta, in_stop);
> +	if (prog)
> +		ret = bpf_iter_run_prog(prog, &ctx);
> +
> +	/* if prog returns > 0, terminate after this element. */
> +	if (ret != 0)
> +		p->terminate = true;
> +
> +	return 0;
> +}
> +
> +static int cgroup_iter_seq_show(struct seq_file *seq, void *v)
> +{
> +	return __cgroup_iter_seq_show(seq, (struct cgroup_subsys_state *)v,
> +				      false);
> +}
> +
> +static const struct seq_operations cgroup_iter_seq_ops = {
> +	.start  = cgroup_iter_seq_start,
> +	.next   = cgroup_iter_seq_next,
> +	.stop   = cgroup_iter_seq_stop,
> +	.show   = cgroup_iter_seq_show,
> +};
> +
> +BTF_ID_LIST_SINGLE(bpf_cgroup_btf_id, struct, cgroup)
> +
> +static int cgroup_iter_seq_init(void *priv, struct bpf_iter_aux_info *aux)
> +{
> +	struct cgroup_iter_priv *p = (struct cgroup_iter_priv *)priv;
> +	struct cgroup *cgrp = aux->cgroup.start;
> +
> +	p->start_css = &cgrp->self;
> +	p->terminate = false;
> +	p->order = aux->cgroup.order;
> +	return 0;
> +}
> +
> +static const struct bpf_iter_seq_info cgroup_iter_seq_info = {
> +	.seq_ops                = &cgroup_iter_seq_ops,
> +	.init_seq_private       = cgroup_iter_seq_init,
> +	.seq_priv_size          = sizeof(struct cgroup_iter_priv),
> +};
> +
> +static int bpf_iter_attach_cgroup(struct bpf_prog *prog,
> +				  union bpf_iter_link_info *linfo,
> +				  struct bpf_iter_aux_info *aux)
> +{
> +	int fd = linfo->cgroup.cgroup_fd;
> +	struct cgroup *cgrp;
> +
> +	if (fd)
> +		cgrp = cgroup_get_from_fd(fd);
> +	else /* walk the entire hierarchy by default. */
> +		cgrp = cgroup_get_from_path("/");
> +
> +	if (IS_ERR(cgrp))
> +		return PTR_ERR(cgrp);
> +
> +	aux->cgroup.start = cgrp;
> +	aux->cgroup.order = linfo->cgroup.traversal_order;

The legality of traversal_order should be checked.

> +	return 0;
> +}
> +
> +static void bpf_iter_detach_cgroup(struct bpf_iter_aux_info *aux)
> +{
> +	cgroup_put(aux->cgroup.start);
> +}
> +
> +static void bpf_iter_cgroup_show_fdinfo(const struct bpf_iter_aux_info *aux,
> +					struct seq_file *seq)
> +{
> +	char *buf;
> +
> +	buf = kzalloc(PATH_MAX, GFP_KERNEL);
> +	if (!buf) {
> +		seq_puts(seq, "cgroup_path:\n");

This is a really unlikely case. maybe "cgroup_path:<unknown>"?

> +		goto show_order;
> +	}
> +
> +	/* If cgroup_path_ns() fails, buf will be an empty string, cgroup_path
> +	 * will print nothing.
> +	 *
> +	 * Path is in the calling process's cgroup namespace.
> +	 */
> +	cgroup_path_ns(aux->cgroup.start, buf, PATH_MAX,
> +		       current->nsproxy->cgroup_ns);
> +	seq_printf(seq, "cgroup_path:\t%s\n", buf);
> +	kfree(buf);
> +
> +show_order:
> +	if (aux->cgroup.order == BPF_ITER_CGROUP_PRE)
> +		seq_puts(seq, "traversal_order: pre\n");
> +	else if (aux->cgroup.order == BPF_ITER_CGROUP_POST)
> +		seq_puts(seq, "traversal_order: post\n");
> +	else /* BPF_ITER_CGROUP_PARENT_UP */
> +		seq_puts(seq, "traversal_order: parent_up\n");
> +}
> +
[...]
