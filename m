Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76AF5558B71
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 00:58:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229838AbiFWW6e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 18:58:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiFWW6c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 18:58:32 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFADC5D10B;
        Thu, 23 Jun 2022 15:58:31 -0700 (PDT)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25NK3T4Y013939;
        Thu, 23 Jun 2022 15:58:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=htqSXUbsG8icUua7FAizFzf1dGWG0zc81CXEscWBtsM=;
 b=HkQiamgtb1tS6wiys/YrI0C1Umnqlj2WZ5jibd7xDdvKqpSxidElyNc7FNZOM+P9YxK3
 pi6LZK+P+R8PNnM0Wu2vyIhN1kCdZue/jHQ2w55dcOTx9cNo20ZCobGDhy12v+TGi5lB
 J4nPz1PERo2j2qQ9JASsMg43SuBfSmpyXKI= 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3gvp68cfyy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Jun 2022 15:58:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HAQN2UroPcOJnyvD7O/mh1nY9ZFWNsrWzPE7tQO1Rbz8fvKgHizFX5YIetCDkPPBYiwc43pjsgCeR94btt600NnhghCuiCBXas5Phz46WA8jTVMV2nCbpeNNT9JoWzxgP3d/U12Nc3sMDOtLIA6KF8ormm5bLLbJWEvIMFraBcIG+xpiaeYUpTHtk+KS1F20lqW6uXFPqe9M1bPDzKQQeBqGfuYG9vdm4afCbhuxy2RoOAdlDXWqBAj5HZzbqrRPmegf1sqdZkH//tE9tUDI9WV2I6+beRwrDlPn0GyXevsAJoixUwhUe4Pc+L+4X/WLetB+pG0HWvl+Mltd3bfX9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=htqSXUbsG8icUua7FAizFzf1dGWG0zc81CXEscWBtsM=;
 b=GywiXU9UESCMHc5JWWXvYnLkieOETqIRQg4qnJwE8WROxnuvV7t2INJKH3jarJdHaYcB8DvO8zHQ3YT2sYfc7gEB2t46fScu3djE0gF09YBYqrVUqRV8BObOkM/eOHn+El+ea07IG++hsJpWLRbHpXlNJnIW/+uoOlfcioQRbqohVaeSa4ngJiJO+df/ht06VoDzrIp/eoy/eoMoj3Q5WhW9mEotyvBag1sTQz6EXTzPXwmXZ6hYZl5917dAZBNb3HMH3JeLo7LLHEsO9Iyw0C/0AqImREenfS7wkkXbuxYq/bB5AHbqSR+XRCKDqEcD4vMqA+iu18b0vP4yUFnE2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MW4PR15MB4475.namprd15.prod.outlook.com (2603:10b6:303:104::16)
 by BN6PR15MB1876.namprd15.prod.outlook.com (2603:10b6:405:4f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.16; Thu, 23 Jun
 2022 22:58:15 +0000
Received: from MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::3941:25c6:c1cd:5762]) by MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::3941:25c6:c1cd:5762%7]) with mapi id 15.20.5353.022; Thu, 23 Jun 2022
 22:58:15 +0000
Date:   Thu, 23 Jun 2022 15:58:13 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org
Subject: Re: [PATCH bpf-next v10 09/11] libbpf: implement bpf_prog_query_opts
Message-ID: <20220623225813.4vu3hgar7d3jgbja@kafai-mbp>
References: <20220622160346.967594-1-sdf@google.com>
 <20220622160346.967594-10-sdf@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220622160346.967594-10-sdf@google.com>
X-ClientProxiedBy: SJ0PR13CA0232.namprd13.prod.outlook.com
 (2603:10b6:a03:2c1::27) To MW4PR15MB4475.namprd15.prod.outlook.com
 (2603:10b6:303:104::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4140bc5f-7408-4387-d27d-08da556bdad7
X-MS-TrafficTypeDiagnostic: BN6PR15MB1876:EE_
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2eEsce14KxlZ0857bV7P6cJNvJLxVCZUfqQ3PnNz+ezsGAq23GS4SqVK2XKi33oq9pNTgUhb4zZj9kE7M8bhcv+HizFqZWnzOsmtpdgK8pVGz78j3NuexKAToTgqpT8FHaduNgcK61QdH8R6IRr67a4YCkam2Wut1QjDiyzMZVNYahqVUmrSeKAqX+gfESDE465KcD/AJMsS4p6M8Itrug0gcG7A45CgBUqIUaaAhSJhSg/dlGp60gVcOafbe8LusujUE8Rvm+saW+unJIlrjyDn4xvli5MVopoZ/UTWx1GvbjJqwBHRnZzSyfYSb3DjWzl5AZ7l6+8+O9RhOF8d/rbn4Y+mPh+1kWE3+X8y80AWei+e3rEeTOB0CR5WQF119CuVMixir9Wi40triF/lXvJG3YWR8KN5k+A+rdhx9gv/DwqDPSyFYb39xdTEonyS/XkgqYcbrMTnFy/AdDMVk0uBSk83tf619U3UePoPjH5bkDk9TZN/Hba0M9ILx8Crw1f/YMX4mZOHHWaA/gTXfL71WUUho9npmWpUVOtgujG+16D7IViCzMXUPP7xV54ACUFMvMHtLmchMx12b6X2M2ZJiSuV+Ye5c1l46l7dI8vHxUs8EQbeyDeoC2IKQcUuXN6b9a9aAihs3EvYOodvKk551GO2eGfvlfVP06kp4DgUdW6qG2cEdXid9mUMkWGqDBlYzfJjCjj0fb0T9ShjjFZ69q4O3q88oRUvsr0+4sm8fr1kudlEX+weDylrTAYj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4475.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(376002)(346002)(39860400002)(396003)(136003)(366004)(33716001)(41300700001)(6512007)(52116002)(6506007)(1076003)(4326008)(316002)(186003)(9686003)(83380400001)(6916009)(478600001)(38100700002)(5660300002)(86362001)(8936002)(66946007)(66476007)(2906002)(6486002)(66556008)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zKM9cMNrMCsPUvbJx4/LG5ilwomlgVLVbhGsT5QZyIuf18Ti7zZ43o4AIDQh?=
 =?us-ascii?Q?H3OP4UOg3reZnmEHWXS2uc0TCB9a/0kWft1GJdXPGFm01XIcVjNQuGLP8Yog?=
 =?us-ascii?Q?cUpaoRA7Cqlk1SdIeVxYY0qzKuV7jmMCPItxN4FWYk3YKtXRxpOPnQGW7BS/?=
 =?us-ascii?Q?vQCFSEBA9QQQKeQnZZkrxp2gYQY/7pQ1dPo6KFS90JQf3DWgRiSo+rP19qM/?=
 =?us-ascii?Q?woLEIaClSc6otDB8nNlOBONx/V7MuoX1ZsThwKYIAKt0KqXqDDIZR3FFXdkG?=
 =?us-ascii?Q?KW1HWrRoFQD5WqJEfEGT9g/OYf5ouedsQ54m9P4XYA3yv9pDbdMNJAOk39rl?=
 =?us-ascii?Q?BJX0261/F56A06ikwBNoBUuc2EAAcXOmje+P8lql6XmEGCxXT5s7UYZIkQhM?=
 =?us-ascii?Q?z+nPuapyRkhIDTQfjEel+TMxC5Qa4uRpeWz8/EC+AFCSrbPJ0je/6P6yuPW4?=
 =?us-ascii?Q?1L6bBQYINHZcvZo8o/BGKT3SQeagKeTUuEKVHzWmXhwT2VA2aJNGJNmpIyd9?=
 =?us-ascii?Q?hzzRhzOdaVcDSgmY8rXqBmBStrt9FEOgDUK3Zypj7WN0ciipFvi+RxsDGHmK?=
 =?us-ascii?Q?PzUEwOWj2pS0/sBw0ruIQP2++vvnRdvyTz8neV9u9W0bXheRGGXVlwAsDu7k?=
 =?us-ascii?Q?EsISrJFgAQMw6OG7QZG5zcbKXRkRwRrA05tVHtQVSeDL3Aqz+qTjQHzQrYTm?=
 =?us-ascii?Q?TefdNWyQv0H/YmXfkmMSgxQUaTnNPY93CgTp0Ucapx7q6VTU0OUnBvZaKrp+?=
 =?us-ascii?Q?nP79sokshhCRIbe4wK7DJlueEELRg1ClCCQTSFy6mAJ/62aanGzw16ZX/s8B?=
 =?us-ascii?Q?GOrfdv/YyCxstX6xgbArEXJ4YG/olAJceqTiLXqZsWtagMfvdX4InzC8C6/h?=
 =?us-ascii?Q?GDmS2aA3lcaUYGM+SG9XstnikogvJayvAdZ27+g5FVcHv+LA0GK8S7YRa2DJ?=
 =?us-ascii?Q?ziK4gXugCywZxr+SmGtTUjXtkGo4COEOmJmcdL+SKdSp8gQV+rnrqej1Lffe?=
 =?us-ascii?Q?24wPu77xTq7TSVcgqkhaUicB6xE5OK6YddJbYgaCk/FV9zizVPb+dWEEhCc8?=
 =?us-ascii?Q?OccjncVic3tJB144NJ2fvY2WDXEgQx4ek3kwE5qjiqLLRt4jnFcpyocqXy00?=
 =?us-ascii?Q?xC2JdMCvEzO5/KsDVJsKkrFOr6zdO1Gekty3XnV71FnjiMsaJN3tY1nioSwe?=
 =?us-ascii?Q?5/v8F5bpUrudYss+3SKadw74A0HZGNWBGhRJ0vlsNAPeNXhB8bsKlzxHcn/O?=
 =?us-ascii?Q?UFCx0aIU3t3mhbYmenYjykOslNI1xczin7u+yNcLfgY3VWQKEo0h9usmo6Lu?=
 =?us-ascii?Q?q3O9vF9l22GBpLqJXDY7kVS5H7q8ffeqg5OjB2I1U6KdIoYIe0SEsa0fP7iF?=
 =?us-ascii?Q?Sem7Fcraq5FDLb2w89Ph5BFiZWuv4fJQBIxIKut/xgdRjB6ESX183ODl2lp4?=
 =?us-ascii?Q?6Lv5ElKHrUaY1vBwTgc9TU09IWIdPsvxKQNyQvzn0/T7opZaPf9ojvvEl9N6?=
 =?us-ascii?Q?nIUayx2yZJVQQKQIx5Ai1SKRjcSOArdnguaW8fcnpP00a8F+wHbluysKGUcp?=
 =?us-ascii?Q?TrCmKanl49y377yKlk5/+3ccxBYJ792zqMdxlvNqVngPtT1KMxcWpJs37fBf?=
 =?us-ascii?Q?Rg=3D=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4140bc5f-7408-4387-d27d-08da556bdad7
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4475.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2022 22:58:15.1690
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Wu0bFpg0LniybyY809r2KA5Cj8CWTSCiUxsW/8EqAggFXlw3Uht96X/eqtCEkB06
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR15MB1876
X-Proofpoint-GUID: laDyOp55-fyqodDcwgt6IBGn9zhUQcRD
X-Proofpoint-ORIG-GUID: laDyOp55-fyqodDcwgt6IBGn9zhUQcRD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-23_11,2022-06-23_01,2022-06-22_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 22, 2022 at 09:03:44AM -0700, Stanislav Fomichev wrote:
> Implement bpf_prog_query_opts as a more expendable version of
> bpf_prog_query. Expose new prog_attach_flags and attach_btf_func_id as
> well:
> 
> * prog_attach_flags is a per-program attach_type; relevant only for
>   lsm cgroup program which might have different attach_flags
>   per attach_btf_id
> * attach_btf_func_id is a new field expose for prog_query which
>   specifies real btf function id for lsm cgroup attachments
> 
> Acked-by: Andrii Nakryiko <andrii@kernel.org>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>  tools/include/uapi/linux/bpf.h |  3 +++
>  tools/lib/bpf/bpf.c            | 38 +++++++++++++++++++++++++++-------
>  tools/lib/bpf/bpf.h            | 15 ++++++++++++++
>  tools/lib/bpf/libbpf.map       |  1 +
>  4 files changed, 50 insertions(+), 7 deletions(-)
> 
> diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
> index b7479898c879..ad9e7311c4cf 100644
> --- a/tools/include/uapi/linux/bpf.h
> +++ b/tools/include/uapi/linux/bpf.h
> @@ -1432,6 +1432,7 @@ union bpf_attr {
>  		__u32		attach_flags;
>  		__aligned_u64	prog_ids;
>  		__u32		prog_cnt;
> +		__aligned_u64	prog_attach_flags; /* output: per-program attach_flags */
>  	} query;
>  
>  	struct { /* anonymous struct used by BPF_RAW_TRACEPOINT_OPEN command */
> @@ -6076,6 +6077,8 @@ struct bpf_prog_info {
>  	__u64 run_cnt;
>  	__u64 recursion_misses;
>  	__u32 verified_insns;
> +	__u32 attach_btf_obj_id;
> +	__u32 attach_btf_id;
>  } __attribute__((aligned(8)));
nit. This could be done together in patch 5.

Acked-by: Martin KaFai Lau <kafai@fb.com>
