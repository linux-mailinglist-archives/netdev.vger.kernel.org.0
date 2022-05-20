Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BB6652EEDF
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 17:15:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350701AbiETPP2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 11:15:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350684AbiETPPU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 11:15:20 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9528617706D;
        Fri, 20 May 2022 08:15:19 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24KC1rum017408;
        Fri, 20 May 2022 08:14:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=dKI6dQu6wjTQjbRSozjt86cO6m+HuXIEEDaxEzrfdXE=;
 b=cEVdlanj8BCrlSJjXp/hdlknzURoKuEYi5hR/wOvfV//37i57MyLWD6iwdIXRh2xiOS7
 d5fLd2EYENREr21SDkQMsIP6cX/+el7uklp4nqPe1f1L3P0yrUNTJkKZeKEy96Z1oD8c
 lgEbo1blFr+2IMn3PKUqv+kYwGFsrrlYHnM= 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2175.outbound.protection.outlook.com [104.47.59.175])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3g5pj50c3a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 May 2022 08:14:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ABVPeFcTrVaHIHhat0uhsHaLo3ebCRApJoQiEA6HbXCookLkiMt5di7mm5Z1hwF/+Su34mC7uqiSeTJHBVabT5t45jIwIadTjH43qPhPFwS9Y4G75STNrzWAzBLed0oUQvw0X05esP6A1twASE0q5MXjaL+FkqJlW/5JuIXtfHI+iD9L8F1gH6Jo+mMBNobUIy5bTkJ+O+PuJUOv2SeIqoaBGcCc12hfF69+23nfmLbs6/4hICYPv7XzYeHg+gzFYeS53YqclUdBSNb9+Ckil0TJgN+cyV1kNZ1TzFd9jzPCuNRg9defOa2Yo+Lmqiy3teQTx/Dcm6XQ/+IgBeKa2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dKI6dQu6wjTQjbRSozjt86cO6m+HuXIEEDaxEzrfdXE=;
 b=C90u9PlCVCyqTunEsbGgFs8BO+iA0SbiEMwSeFUpqHWPriZfOiOryeF7A/6MPwzrd1q9she0dNnvSTtDuVTKX+aLGU0CpQdyniYFtDt+wqsPCxJ14mvAqBRDkekfMG1jlWFomgvRqtQDuL1WyCyoX4ze5Cqu+4XYKo1chN/wQWJHzV1ZbVwtKKHH0a3u59b3NxZtJ16cp8sLvPWkTnudQTs5KUNFBUAsnxXGufV0mcxcCn67gmdWJ52PtKxY9UxbsWC7RYtpO9AAldUxPxeQ4ThJ8UrNSuJg84cvXt3XWoqbzcwaGd4ycTEYrqPSl4l8hDGiT20rF8pIL0YIzgOQjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4532.namprd15.prod.outlook.com (2603:10b6:806:19b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.17; Fri, 20 May
 2022 15:14:53 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::5811:4996:bbfd:3c53]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::5811:4996:bbfd:3c53%7]) with mapi id 15.20.5273.017; Fri, 20 May 2022
 15:14:53 +0000
Message-ID: <fa3b35a6-5c3c-42a1-23f0-a8143b4eaa57@fb.com>
Date:   Fri, 20 May 2022 08:14:50 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [PATCH bpf-next v1 2/5] cgroup: bpf: add cgroup_rstat_updated()
 and cgroup_rstat_flush() kfuncs
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
        Shuah Khan <shuah@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Michal Hocko <mhocko@kernel.org>
Cc:     Stanislav Fomichev <sdf@google.com>,
        David Rientjes <rientjes@google.com>,
        Greg Thelen <gthelen@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, cgroups@vger.kernel.org
References: <20220520012133.1217211-1-yosryahmed@google.com>
 <20220520012133.1217211-3-yosryahmed@google.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <20220520012133.1217211-3-yosryahmed@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY3PR10CA0021.namprd10.prod.outlook.com
 (2603:10b6:a03:255::26) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6c46fa3f-7c8d-40dd-5aad-08da3a737e07
X-MS-TrafficTypeDiagnostic: SA1PR15MB4532:EE_
X-Microsoft-Antispam-PRVS: <SA1PR15MB45329B108E3E7E02A4AA3A44D3D39@SA1PR15MB4532.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k3pZk4MMLpjNkedYlpywNxtSmq0a54hHnHRTn43YTzeY3t2u0Od5UJCTSyi8soOdSF+HZvNCQaHQ7Oa77wynk/mHxd0f8DcvJzEYgfjEdajVrbRznnoniAaZZTb6TIiyYaBvumC/aKt/PhBAC4faPTRc/ROKbXhXCfvoH+lwzhU4+zHfaHQoSOIEUVe4bq9S17YiPttaY/qf1TiqAr2at0zfGGW5ePxgV4UOzWBuXsNr4Uyeaw3QN6nv9fJUaAtjBpp/so+qQO9xHt1gVuWfsOvu5b2senUSmJogrT6110MW+qS0Po+75zzeEm9YNHsUcMuZwnoutbfQaKXpmC124nKqxgzTUSmjIvg0xaAAZy6EvBMRuiJXI3ExCpgThRMiMItOGHbH9HGDxL2IJrvWy+eU4/oYs0NmerAltzfbbTy15tDvot1hyXwc6oitrOig76r/vXCc+ar5hWWE+MvWHKg7MY33d3trK6Vfq3HFFEGcNQY0G69H1Aymge5eg+UuSluO99dB/sWDX/+YGC+C4YdDCzakglIQ4An5KFgBS0hcUBf+w2nHWi0bCVsUsSGdgRPJwKXN6KlyjposLEC+eu4sy16aTmOU+UQU6q4gbUhEcMgeXfMcB/vGElJznpTf9U2NRVnuXM9S5FKZSPuh6v7m/5kYPdvxI0MEu+6GbbufcQl8qJZJj8Twq8Tpvp/0K0f21r67RI8THqVClp7+S2Vp4WKTAcuI7gb76w+JkkRYZYPlCE0kjg3izA+pqn1z
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(110136005)(86362001)(921005)(38100700002)(54906003)(4326008)(316002)(31696002)(66556008)(66946007)(66476007)(8676002)(2616005)(36756003)(8936002)(6506007)(2906002)(5660300002)(7416002)(508600001)(186003)(6512007)(31686004)(83380400001)(53546011)(6486002)(52116002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QytOWFMyZkZRWWVtZW5GNzdlcm1lTk9taWtkNDJBd2I2VUtkUDUzb3poanM4?=
 =?utf-8?B?ek1YcmI2UktEcllkK2VJSHNLbDRucFUwaEVFRkpwRHp1czlzaWtuODVPcmt3?=
 =?utf-8?B?MERDL2c5ZVZvSmtHUHB1NFZNOXAzY3Y3SFdDWXFINlFhL0QwOFhLL1Q3WFRU?=
 =?utf-8?B?U0lpMS83L2dEa1Y3Y3dycWlIcVlmUXRnd1pxZ2NMbmpiaFZUb2ZPRnl4WTFN?=
 =?utf-8?B?a2h4eTB2c09ESGJaNDJEcGVOS040NHNKWlM5VTVCa1J2SXJrMWFkYW1FMU9l?=
 =?utf-8?B?Vi83QWpCN09BYXpOVkg1T1Yvdm1xdG1sNUpObXJ6bkYyT29wdTk0WnJHYnZt?=
 =?utf-8?B?eU1yaHZrZWNYZ3B3a3QrS1FmMnBaT1V6U21UbDlVTDZMRlpkNnMwV2ZmRlRu?=
 =?utf-8?B?RVZDZzF0N2RxaUhZL2dsWUI3RXdTQU5hcmZJZ3NaUUR5ZEp3VS8yMExKQno3?=
 =?utf-8?B?Vy96TUsxamIrMjJjbkFqdVFEUU9LdGtza2wzNzJZRms1aXJGNEd0MUJDMUpw?=
 =?utf-8?B?dllYWHZFZmtqU2t0U2lweWQzOFR6RzE3cUFKMi9TMDFwSnlvNWhyQURGNEY1?=
 =?utf-8?B?emVzQ3VKNU1uRHNJaEZ3UE1XbEdqMFJtOTc3dUgxVTBjQkxnRHV1Y0NWMjQ1?=
 =?utf-8?B?Y3dRaTJoN2VmaDFndlNuTnFoQXIwWGZsRVFrdG0rZUNHL2I5T0p5aTFIdEVD?=
 =?utf-8?B?U0t4ZkNFUnF0NFZtMmttVE1DL0pZZHpiOEdibzJRNldHUWIxUGJXMFFyNk1K?=
 =?utf-8?B?ZUJLaWpwUmlkMWdMVlVnbHJDdlRvWEFUQzdNNzNhMm55bk5wdVQyN1A5NWFP?=
 =?utf-8?B?RjF3ZS9hY25lcDJhMWJBZ05RajNybE1BWnBucllucFFUR1BqOTNyenNZTHh1?=
 =?utf-8?B?Ulc4elVJVjloYTltaUhWOEN4a2EzalJpL0tOY1dVLzlPZU5tYmsyT0RwSUJJ?=
 =?utf-8?B?eVBIQitaV2VndEkxVWdiUVo2QUhOWTB0VEFqR2g1MnFjc3kvY2VZZ0xaVXRm?=
 =?utf-8?B?VExYbGpEaG1MMVVPWXhFbG43cXlaUVFQcXJWRUpwVit3M3VXY2h0bks4MGVw?=
 =?utf-8?B?TTU1cDZDMy8yQ1h6NHNBU0VwcXJuNXRYZEIxRVB0WFZKTjNqYnRNcWNnTHgy?=
 =?utf-8?B?Um4zaER0V25xSkpXbVhMZlhuU1Y3R2ZrTGg0VjdvbDdMQ09sS1pZR1ZHMUhy?=
 =?utf-8?B?Ri9QRGx0cW1JdjNkSkFrbGtqcmx6RjdaT0pRa2c2emZHWkZadWZ2VG5XS1Zv?=
 =?utf-8?B?eXQ3YUxFbER0UWpSK3JZMTdEbXRuQ2VvU0hvMGMwa0hXVHA3LzMwNnFhc3Zw?=
 =?utf-8?B?dTFjbFB0TnE5OG4wWGdtUnVJeXZBYk1ZWFVobzk5SjZWYWpQTmFSU2F6NnY1?=
 =?utf-8?B?OURmSkdmL2VCckt1ckxhR1h3eWlRU1h3eFBNM1NiVFZzMUZNWFdNN3Z0QlM5?=
 =?utf-8?B?REcycWZ2L0x3YjVaQjFoLzNCR3BCbEM5M1ppcy84dW5HSHAwSTEvS3ZrQVM4?=
 =?utf-8?B?VnN1eWJ1bGZhN2hBbURWYU5MUEMwYmlMN2R5eGI3S2QzRTd1RnhhYjNoakc1?=
 =?utf-8?B?VWpidGZZcHgzNWIvMkdyT0kwcVFXSjBWQThEVWNYa0g5dTFlcUlPcnZKNGhN?=
 =?utf-8?B?dVRPN3lVNE1mcjFCRmFocllSajVFTU54TE1JQzhVZFFhWWVlUHdHL0oyU1ky?=
 =?utf-8?B?ZFFSenMyajhPVUM0TTQ5MkNhSjlEeHdDT3Nnc0NGVC9keUVGQk1aejc1VU9v?=
 =?utf-8?B?SldFdGpMY2JSNS9CRjlpQjFYL3o0cDVLZHJSOExoOGJwTnlKUWxya1V0L1Bl?=
 =?utf-8?B?ZDlNSjJha0NreU5MUnZWdjlQQkVTZDl0cVEzTWNIVUhBbmdrSHp1SEltdnNp?=
 =?utf-8?B?MCttK3hudWtLSUJkcjNPU29ZQno1RklLZ1dKb0VTc01Semx6N3lMYVJUUCs3?=
 =?utf-8?B?ei9hTFFvSGw0UkxWSld0S2FlKzJMSUxLUzRDM1NsQ1lzbzJRalRQZW1zWG1j?=
 =?utf-8?B?ZjdpdEN1bFk4KzJSalNGelFyVmdkNHBsUU9GOXFlUnVtc29GUVFKWnF6MTEy?=
 =?utf-8?B?bkNSV3N5eWZ1ZCtWSUU3aStqRDVId0dOajlUTjFDU3VNL3E4Z3BMbFcwTVND?=
 =?utf-8?B?OXNoTGxVM0JFenZoL2FFZy9vakZRNU9vV3BQeE55RzZGcUQ5ZDNINWQ2cHg2?=
 =?utf-8?B?TnJhQU1jY0M2MkxERzNGbXpucTdrTG4zUlVZaWhNRmRRc3BRcThaUm1PYVNl?=
 =?utf-8?B?TmplMWwwL1htaS81VnpuWGhhZCtEQ2IwNTRKaVVzWG95K3Byd3U3OWVZa0Uv?=
 =?utf-8?B?c1V5a3BGczluWjJjbjZTR0t1V1NITkhmZmM1d3BYZEE3elA3d2xQQ083WUh1?=
 =?utf-8?Q?SZv2C8J0s5swNCVg=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c46fa3f-7c8d-40dd-5aad-08da3a737e07
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2022 15:14:53.8282
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SD/P0KWwhuJUNqGg1HGNCLNvxRHdlAZpMi/JL66nAMGssnR1QO6cCtQfQ4SdwTeH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4532
X-Proofpoint-GUID: vcEZZZbk92WtRuoIe4SNG6wb0CrKhhRn
X-Proofpoint-ORIG-GUID: vcEZZZbk92WtRuoIe4SNG6wb0CrKhhRn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-20_04,2022-05-20_02,2022-02-23_01
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



On 5/19/22 6:21 PM, Yosry Ahmed wrote:
> Add cgroup_rstat_updated() and cgroup_rstat_flush() kfuncs to bpf
> tracing programs. bpf programs that make use of rstat can use these
> functions to inform rstat when they update stats for a cgroup, and when
> they need to flush the stats.
> 
> Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
> ---
>   kernel/cgroup/rstat.c | 35 ++++++++++++++++++++++++++++++++++-
>   1 file changed, 34 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/cgroup/rstat.c b/kernel/cgroup/rstat.c
> index e7a88d2600bd..a16a851bc0a1 100644
> --- a/kernel/cgroup/rstat.c
> +++ b/kernel/cgroup/rstat.c
> @@ -3,6 +3,11 @@
>   
>   #include <linux/sched/cputime.h>
>   
> +#include <linux/bpf.h>
> +#include <linux/btf.h>
> +#include <linux/btf_ids.h>
> +
> +
>   static DEFINE_SPINLOCK(cgroup_rstat_lock);
>   static DEFINE_PER_CPU(raw_spinlock_t, cgroup_rstat_cpu_lock);
>   
> @@ -141,7 +146,12 @@ static struct cgroup *cgroup_rstat_cpu_pop_updated(struct cgroup *pos,
>   	return pos;
>   }
>   
> -/* A hook for bpf stat collectors to attach to and flush their stats */
> +/*
> + * A hook for bpf stat collectors to attach to and flush their stats.
> + * Together with providing bpf kfuncs for cgroup_rstat_updated() and
> + * cgroup_rstat_flush(), this enables a complete workflow where bpf progs that
> + * collect cgroup stats can integrate with rstat for efficient flushing.
> + */
>   __weak noinline void bpf_rstat_flush(struct cgroup *cgrp,
>   				     struct cgroup *parent, int cpu)
>   {
> @@ -476,3 +486,26 @@ void cgroup_base_stat_cputime_show(struct seq_file *seq)
>   		   "system_usec %llu\n",
>   		   usage, utime, stime);
>   }
> +
> +/* Add bpf kfuncs for cgroup_rstat_updated() and cgroup_rstat_flush() */
> +BTF_SET_START(bpf_rstat_check_kfunc_ids)
> +BTF_ID(func, cgroup_rstat_updated)
> +BTF_ID(func, cgroup_rstat_flush)
> +BTF_SET_END(bpf_rstat_check_kfunc_ids)
> +
> +BTF_SET_START(bpf_rstat_sleepable_kfunc_ids)
> +BTF_ID(func, cgroup_rstat_flush)
> +BTF_SET_END(bpf_rstat_sleepable_kfunc_ids)
> +
> +static const struct btf_kfunc_id_set bpf_rstat_kfunc_set = {
> +	.owner		= THIS_MODULE,
> +	.check_set	= &bpf_rstat_check_kfunc_ids,
> +	.sleepable_set	= &bpf_rstat_sleepable_kfunc_ids,

There is a compilation error here:

kernel/cgroup/rstat.c:503:3: error: ‘const struct btf_kfunc_id_set’ has 
no member named ‘sleepable_set’; did you mean ‘release_set’?
     503 |  .sleepable_set = &bpf_rstat_sleepable_kfunc_ids,
         |   ^~~~~~~~~~~~~
         |   release_set
   kernel/cgroup/rstat.c:503:19: warning: excess elements in struct 
initializer
     503 |  .sleepable_set = &bpf_rstat_sleepable_kfunc_ids,
         |                   ^
   kernel/cgroup/rstat.c:503:19: note: (near initialization for 
‘bpf_rstat_kfunc_set’)
   make[3]: *** [scripts/Makefile.build:288: kernel/cgroup/rstat.o] Error 1

Please fix.

> +};
> +
> +static int __init bpf_rstat_kfunc_init(void)
> +{
> +	return register_btf_kfunc_id_set(BPF_PROG_TYPE_TRACING,
> +					 &bpf_rstat_kfunc_set);
> +}
> +late_initcall(bpf_rstat_kfunc_init);
