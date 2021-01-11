Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE8272F0CE8
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 07:28:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727438AbhAKG22 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 01:28:28 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:8106 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726672AbhAKG21 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 01:28:27 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10B699Jr023873;
        Sun, 10 Jan 2021 22:27:19 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=DsxH3z5zB3jJbjq6ytZyPRrsYMykggcUdM1pLS47AU4=;
 b=IFXe0oWTGG9aXFCBm4kFjy4ocxxvNpt2tIlqfjuPC7Nm5qdc76eQlFJZvBJmlQN5bPdX
 GLy9F5ap3w9DQ3N86dV3D4Pljfo0eI24RKoV/2qnStw43oGGQzaNhMQ9SNCbK2Xn6CvG
 taRf/Idgu7dx39OZi0QKiaHDoDrEF1PObsw= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 35yw87384g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sun, 10 Jan 2021 22:27:19 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Sun, 10 Jan 2021 22:27:18 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BcXo+LlIP6biU/M8+yq08CFtoNGuLLWKJdfq9cApfIBuFAIWmcZqa2Mm+J/QS1LvusrpjCYz4Ud3w0BtEuaZXgRXJFphyoaTmC2pC/ie9902bVQQU2QR9jkYTlBhhFLpsn737f3USbQijg6H6KhR1dllsv6nZpiwQw69zHZ9R7ZdGgWfXW7gimFVfkrsA1lVIETU/bdMv2+RXNEngBglAPsn6Y392E6Kl5QvxeKviDXRJ1BkNEroeGEIMx8d2PDseyNGHAELpZ85zeBL2QWcW82fK1A9B0y7qriTsH1TGtie40RdO2BpaLy3CPwW7qtFfsA4UTCevJ3wyd+OTQFvGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DsxH3z5zB3jJbjq6ytZyPRrsYMykggcUdM1pLS47AU4=;
 b=NCRR5LLxCCtFGt7ypYHf+Tj6LdtoO556tIgdFvse3+PYkCrHMo6D0VCHkH3T/xiwog23yZ715t2a+8X8ssIb9mYNOBKHy0qWyPCXFDdiPRAWMzzqx4JL7OpXLsYT0PC9ehH+dtQU3dkyt5xBFA3Wim6nok5OPXQeCl6cV/wYsxFjhBke/PhGHtEo/vXNeSH1PG1DXhb5XGmx+Lb/bTV6IusTC0mIqtMkttsLQgU8d+/LHHRPVl3j1kH3hSw4aN4PHlT1HsXc05u2qiWDgmF/zEcZYHwFNem5VZMu01OHXUfFdjt7jgjtgbE7Jiev04lssqGyohJzWKZVYbBfLgvy3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DsxH3z5zB3jJbjq6ytZyPRrsYMykggcUdM1pLS47AU4=;
 b=g+/B3odSOMJcMjmZlHTm9TI0pE5ktLS2jRBnHeZanFC87ZDrSYv0+o1K7w5AREXC8h8JELIWJXJ8PHTmHaViYr98IyjfECxXchwGq0gvLgGf94V1O71s0qtAPHM9/3xmVGYzPayPwrhomfZpmJDkkb2+qQ4Yb4IHmK0iyNPnIkU=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB3205.namprd15.prod.outlook.com (2603:10b6:a03:104::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Mon, 11 Jan
 2021 06:27:16 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03%7]) with mapi id 15.20.3742.012; Mon, 11 Jan 2021
 06:27:16 +0000
Subject: Re: [PATCH bpf-next 1/4] bpf: enable task local storage for tracing
 programs
To:     Song Liu <songliubraving@fb.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <mingo@redhat.com>, <peterz@infradead.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <andrii@kernel.org>,
        <john.fastabend@gmail.com>, <kpsingh@chromium.org>,
        <kernel-team@fb.com>, <haoluo@google.com>,
        kernel test robot <lkp@intel.com>
References: <20210108231950.3844417-1-songliubraving@fb.com>
 <20210108231950.3844417-2-songliubraving@fb.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <733ebec6-e4b0-0913-0483-c79338d03798@fb.com>
Date:   Sun, 10 Jan 2021 22:27:14 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.0
In-Reply-To: <20210108231950.3844417-2-songliubraving@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:6067]
X-ClientProxiedBy: BY3PR10CA0025.namprd10.prod.outlook.com
 (2603:10b6:a03:255::30) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c1::1158] (2620:10d:c090:400::5:6067) by BY3PR10CA0025.namprd10.prod.outlook.com (2603:10b6:a03:255::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Mon, 11 Jan 2021 06:27:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 03abdc96-955b-4565-a2df-08d8b5f9f0d4
X-MS-TrafficTypeDiagnostic: BYAPR15MB3205:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB3205202B7061EB44F2DECE05D3AB0@BYAPR15MB3205.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P2af5iBUWk9h0Kzd52KYIWKDJCVgZgeqOyVvegrHiHGX2jieFCRwAFy47U90uojrGkM6fL/kUZ/R+cc+LdJWI5xKMEeT9aQhfFlVksNhamH/ujf1jNxodz4/dOa/JP97HrRPVVn9IiZbYuXDL8msvQ4ElQ2c284S/eRUPISnAOFUwRDYIKPzEwwNtzcbg0fuHCTGggOU1fWPTdArvbLkBwJr9pI7FBftUFU2eRde5fYV0xLv5VkzvXVukZ96wACCa0r7GsLM6TQsg6wUJZ2gDr4YO60LWoWp7paoOm9EMpOCA2+ZGrzfCGZvdgyH92CeoYLnCsy7U8+dbg7yY4MlLJjS/iUluBebNOVKCddNs876q6z3lgWYs+Z0Kxo+KYhPwHTYbaYWbZgTy/ORhgk2bIT69AoUcI5r3WTio3KnpbQy3lVMQdR97DDFVjPDAj0YXVU1bi2DTyvkV/+rBh/+o7gzF9y74lXklmxvLd082rY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(366004)(396003)(136003)(376002)(66476007)(31686004)(478600001)(66556008)(316002)(52116002)(186003)(86362001)(53546011)(66946007)(5660300002)(2616005)(8936002)(7416002)(83380400001)(4326008)(36756003)(2906002)(6486002)(31696002)(8676002)(16526019)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?dWVZOVZrOExOcWRTeHZwV1VyZFBoUFI3cDBDOCtyS3hhSFFTL1NHdWRDdVBZ?=
 =?utf-8?B?ZkFnOStvaHd0U2ZsWTZSbC9HVXppYVFKTXIybE1QbjBYL1NsYmN5NnVSVVNz?=
 =?utf-8?B?M0paeUppQzE3OWZKeW9Cd0ZjQUxHaHNUWUo0bFl4SENBUlpkVllLR3ZLd2RX?=
 =?utf-8?B?NmNFK0pGMC9Jd0dBc0hjeHRDaHIxSDNIYmdVTTEyZ3R4VkFJQlFnYlVxNXhT?=
 =?utf-8?B?aklBVWlQbEFTOWZYSXhiYVM5eENDTTJIb3JVNUk1NEtycElCV2N3aHh6dVdC?=
 =?utf-8?B?ZGpIdUUvOFNTU3N0akpNL3pyVmZJc2ZOWk9jOTFEd2M4ZjJxSDgyejk1eFRj?=
 =?utf-8?B?b3dMcW5wQkF0aW1oZDlCWUNVV0tRTG1ienhCQVNlVzZmVE4xc0lkMGlYak5U?=
 =?utf-8?B?UFBPSWZzSW12d2NTanVaMVhZRFhsVE0xRFpKZit2eU5iUllrS2FJak52UVFM?=
 =?utf-8?B?ZWczZ2dsMVB0K1VCeWt1b1R1cEtiZGpuNFgwZDU1YnMxUGErR25HaHFUTEtt?=
 =?utf-8?B?S1dtODdwNTVXRGdHVlBVbTJsaFRHU1FLSFhSaFkwTHFuZzdtWWQyeDhOa1lB?=
 =?utf-8?B?cXNjRnNhMDF6SHU0blljYXBnT2lPZXRtdnFRR0k3OXIyWFVSdDdsTmhJcWVv?=
 =?utf-8?B?SCtHVFQxQldYR2RMNUNxaUs1WGNBUndNS0dWdHBFN2l0bENRZll5a3JLRjZi?=
 =?utf-8?B?RUJuWklUd2JEUUQ5cy9GMHhjNmNRMlNRWCtVU3l2V0FCdGNNb0R2NklFUDJP?=
 =?utf-8?B?VHdBYVVlaXdBZFAyRzlzUjVKbCtEYytrZXl1eXRVc2dWbzhQbEhGaUdFTGY5?=
 =?utf-8?B?T0RDUTlzUEE3ekgwakRWNnY3d0h6MDVUK0UxOWFYRVlkZkE2R0hNdk1aTStU?=
 =?utf-8?B?Zi9VOWNzRjRqeTk0TU1jaW92OURSbTNwZy8xeHA4SFJ3R21xSWNNRnF2YTdJ?=
 =?utf-8?B?Tis3RHZONUlGY3paWk9uQ1haRWdZYnRCMFR0bEs2TkFxMlI3YUR5UVNkY2Qz?=
 =?utf-8?B?L2VIZVRIZWtLKzJoM1plMnBycDVwMzlLOVRTakNiVTZQbTJxb2RJc25pNm9N?=
 =?utf-8?B?cDBVY0h3bzdNMGxOdWdmcFFKalhvMWxFR2xsUkY0NE4yZTBKUTJpNldYaGFo?=
 =?utf-8?B?QitEL2FuRUs2RVNzbkJKOElDcnE2K1QzemIrVlRsbDRlYk5lR3owdmdwSmZS?=
 =?utf-8?B?b3B6aFRzenBLOEVjUG5SandUaTJ2c25yb2hYWEhjVDdkVHRyV200bFVnSzBP?=
 =?utf-8?B?cWhZSzB3bHl1U3ZiNHFOV29yUzJ6WjZobTBYT3R1eEtJSWhTTFJpNTd3djM1?=
 =?utf-8?B?ZmZRd2xsV01jTHNmZVNIbFJMY0NSR09XMm5HMm81dGhDWnJCZEVXNnVucTBv?=
 =?utf-8?B?SEZIYUd5SlFqTHc9PQ==?=
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2021 06:27:16.4017
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: 03abdc96-955b-4565-a2df-08d8b5f9f0d4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uoN8wUgELT/syovOnt5k/8skCyhBdV50697VteV8Jx0QiRRzCBatZMTOn48X1TfB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3205
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-09_13:2021-01-07,2021-01-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 lowpriorityscore=0 adultscore=0 priorityscore=1501 suspectscore=0
 mlxscore=0 spamscore=0 mlxlogscore=999 bulkscore=0 clxscore=1011
 impostorscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2101110037
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/8/21 3:19 PM, Song Liu wrote:
> To access per-task data, BPF program typically creates a hash table with
> pid as the key. This is not ideal because:
>   1. The use need to estimate requires size of the hash table, with may be
>      inaccurate;
>   2. Big hash tables are slow;
>   3. To clean up the data properly during task terminations, the user need
>      to write code.
> 
> Task local storage overcomes these issues and becomes a better option for
> these per-task data. Task local storage is only available to BPF_LSM. Now
> enable it for tracing programs.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>   include/linux/bpf.h            |  7 +++++++
>   include/linux/bpf_lsm.h        | 22 ----------------------
>   include/linux/bpf_types.h      |  2 +-
>   include/linux/sched.h          |  5 +++++
>   kernel/bpf/Makefile            |  3 +--
>   kernel/bpf/bpf_local_storage.c | 28 +++++++++++++++++-----------
>   kernel/bpf/bpf_lsm.c           |  4 ----
>   kernel/bpf/bpf_task_storage.c  | 26 ++++++--------------------
>   kernel/fork.c                  |  5 +++++
>   kernel/trace/bpf_trace.c       |  4 ++++
>   10 files changed, 46 insertions(+), 60 deletions(-)
> 
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 07cb5d15e7439..cf16548f28f7b 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -1480,6 +1480,7 @@ struct bpf_prog *bpf_prog_by_id(u32 id);
>   struct bpf_link *bpf_link_by_id(u32 id);
>   
>   const struct bpf_func_proto *bpf_base_func_proto(enum bpf_func_id func_id);
> +void bpf_task_storage_free(struct task_struct *task);
>   #else /* !CONFIG_BPF_SYSCALL */
>   static inline struct bpf_prog *bpf_prog_get(u32 ufd)
>   {
> @@ -1665,6 +1666,10 @@ bpf_base_func_proto(enum bpf_func_id func_id)
>   {
>   	return NULL;
>   }
> +
> +static inline void bpf_task_storage_free(struct task_struct *task)
> +{
> +}
>   #endif /* CONFIG_BPF_SYSCALL */
>   
>   static inline struct bpf_prog *bpf_prog_get_type(u32 ufd,
> @@ -1860,6 +1865,8 @@ extern const struct bpf_func_proto bpf_per_cpu_ptr_proto;
>   extern const struct bpf_func_proto bpf_this_cpu_ptr_proto;
>   extern const struct bpf_func_proto bpf_ktime_get_coarse_ns_proto;
>   extern const struct bpf_func_proto bpf_sock_from_file_proto;
> +extern const struct bpf_func_proto bpf_task_storage_get_proto;
> +extern const struct bpf_func_proto bpf_task_storage_delete_proto;
>   
>   const struct bpf_func_proto *bpf_tracing_func_proto(
>   	enum bpf_func_id func_id, const struct bpf_prog *prog);
> diff --git a/include/linux/bpf_lsm.h b/include/linux/bpf_lsm.h
> index 0d1c33ace3987..479c101546ad1 100644
> --- a/include/linux/bpf_lsm.h
> +++ b/include/linux/bpf_lsm.h
> @@ -38,21 +38,9 @@ static inline struct bpf_storage_blob *bpf_inode(
>   	return inode->i_security + bpf_lsm_blob_sizes.lbs_inode;
>   }
>   
> -static inline struct bpf_storage_blob *bpf_task(
> -	const struct task_struct *task)
> -{
> -	if (unlikely(!task->security))
> -		return NULL;
> -
> -	return task->security + bpf_lsm_blob_sizes.lbs_task;
> -}
> -
>   extern const struct bpf_func_proto bpf_inode_storage_get_proto;
>   extern const struct bpf_func_proto bpf_inode_storage_delete_proto;
> -extern const struct bpf_func_proto bpf_task_storage_get_proto;
> -extern const struct bpf_func_proto bpf_task_storage_delete_proto;
>   void bpf_inode_storage_free(struct inode *inode);
> -void bpf_task_storage_free(struct task_struct *task);
>   
>   #else /* !CONFIG_BPF_LSM */
>   
> @@ -73,20 +61,10 @@ static inline struct bpf_storage_blob *bpf_inode(
>   	return NULL;
>   }
>   
> -static inline struct bpf_storage_blob *bpf_task(
> -	const struct task_struct *task)
> -{
> -	return NULL;
> -}
> -
>   static inline void bpf_inode_storage_free(struct inode *inode)
>   {
>   }
>   
> -static inline void bpf_task_storage_free(struct task_struct *task)
> -{
> -}
> -
>   #endif /* CONFIG_BPF_LSM */
>   
>   #endif /* _LINUX_BPF_LSM_H */
> diff --git a/include/linux/bpf_types.h b/include/linux/bpf_types.h
> index 99f7fd657d87a..b9edee336d804 100644
> --- a/include/linux/bpf_types.h
> +++ b/include/linux/bpf_types.h
> @@ -109,8 +109,8 @@ BPF_MAP_TYPE(BPF_MAP_TYPE_SOCKHASH, sock_hash_ops)
>   #endif
>   #ifdef CONFIG_BPF_LSM
>   BPF_MAP_TYPE(BPF_MAP_TYPE_INODE_STORAGE, inode_storage_map_ops)
> -BPF_MAP_TYPE(BPF_MAP_TYPE_TASK_STORAGE, task_storage_map_ops)
>   #endif
> +BPF_MAP_TYPE(BPF_MAP_TYPE_TASK_STORAGE, task_storage_map_ops)
>   BPF_MAP_TYPE(BPF_MAP_TYPE_CPUMAP, cpu_map_ops)
>   #if defined(CONFIG_XDP_SOCKETS)
>   BPF_MAP_TYPE(BPF_MAP_TYPE_XSKMAP, xsk_map_ops)
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 51d535b69bd6f..4a173defa2010 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -42,6 +42,7 @@ struct audit_context;
>   struct backing_dev_info;
>   struct bio_list;
>   struct blk_plug;
> +struct bpf_local_storage;
>   struct capture_control;
>   struct cfs_rq;
>   struct fs_struct;
> @@ -1348,6 +1349,10 @@ struct task_struct {
>   	/* Used by LSM modules for access restriction: */
>   	void				*security;
>   #endif
> +#ifdef CONFIG_BPF_SYSCALL
> +	/* Used by BPF task local storage */
> +	struct bpf_local_storage	*bpf_storage;
> +#endif

I remembered there is a discussion where KP initially wanted to put 
bpf_local_storage in task_struct, but later on changed to
use in lsm as his use case mostly for lsm. Did anybody
remember the details of the discussion? Just want to be
sure what is the concern people has with putting bpf_local_storage
in task_struct and whether the use case presented by
Song will justify it.

>   
>   #ifdef CONFIG_GCC_PLUGIN_STACKLEAK
>   	unsigned long			lowest_stack;
> diff --git a/kernel/bpf/Makefile b/kernel/bpf/Makefile
> index d1249340fd6ba..ca995fdfa45e7 100644
> --- a/kernel/bpf/Makefile
> +++ b/kernel/bpf/Makefile
> @@ -8,9 +8,8 @@ CFLAGS_core.o += $(call cc-disable-warning, override-init) $(cflags-nogcse-yy)
>   
>   obj-$(CONFIG_BPF_SYSCALL) += syscall.o verifier.o inode.o helpers.o tnum.o bpf_iter.o map_iter.o task_iter.o prog_iter.o
>   obj-$(CONFIG_BPF_SYSCALL) += hashtab.o arraymap.o percpu_freelist.o bpf_lru_list.o lpm_trie.o map_in_map.o
> -obj-$(CONFIG_BPF_SYSCALL) += local_storage.o queue_stack_maps.o ringbuf.o
> +obj-$(CONFIG_BPF_SYSCALL) += local_storage.o queue_stack_maps.o ringbuf.o bpf_task_storage.o
>   obj-${CONFIG_BPF_LSM}	  += bpf_inode_storage.o
> -obj-${CONFIG_BPF_LSM}	  += bpf_task_storage.o
>   obj-$(CONFIG_BPF_SYSCALL) += disasm.o
>   obj-$(CONFIG_BPF_JIT) += trampoline.o
>   obj-$(CONFIG_BPF_SYSCALL) += btf.o
[...]
