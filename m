Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D8CC52F968
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 08:56:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240309AbiEUG4j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 May 2022 02:56:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240245AbiEUG4h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 May 2022 02:56:37 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C2F4A0D30;
        Fri, 20 May 2022 23:56:36 -0700 (PDT)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24L3YDHk014827;
        Fri, 20 May 2022 23:56:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=ucB3WZ74cNAIH4kto/o0gh/KKlzZTcIAEOqeWMpMbOM=;
 b=OgCyv2L71bWrGN9TaBlDzNYHJ+musK0y4nujiYWovWN69E6XnWXNpihE0TCqOIHDY9JQ
 CXpH6FbR9NOtvzj1ZDtzp5I2+/fU8lBft6MWChfRyQsSEa55QA0QycSf6JfWlv1ku6E8
 VBnhQiYdsyeIHyzoNsazjgoqvo2lPrCvKXU= 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3g59tc0ggs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 May 2022 23:56:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LlqPXwJhAmOfUgv+YZKDYIYYpadkL/WbOqFuxj99/P+44PKYAzSbxVFIZTbDhRmx7QJxDVUHk5Ot3rZj+BKxOiOF49VaPNNCyi/J9iaCOMI0FrTIRKhwUrlqq70c8JpHHS8AufLJ6AQMs3ibPF5eCsakjFL8XS5bMoOv3CnHNTioOLwn9+qISDIylEf3iASqIzjnEmH27bPENxhuHEd328AHxmGiWPFYEtBrIedh35O14fcjd1WksSUeI208RPNw5U7pMW4u0NRb/0leYlZUx7CFZh9Ih9QCB8wr8DB4Jn/SYyosHEs+OQbHUocZHHQ4NjmFu8EwcqWMnmBf2Jtf2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ucB3WZ74cNAIH4kto/o0gh/KKlzZTcIAEOqeWMpMbOM=;
 b=QkCxJ/78MXU1ktoXsQMh/1RHYxUg7NPJ8vT6uQpo909FTda0kJyrp0WkJYpZWANhvGcfkan34tyST1cfTyApfTVnq5f2ubHuA04NTaWL9xnxT34jj2bqaGm+qd7iOzdJ3hGtdgsHRkfmBjLODSqzBwxj4Xl+yirruVpxXZEdvzlSSNsbuztnNgsB7nxrBbFcOimqxDXlNzPQfu7mvK0qtgKW9nyqc8x0UUoAKX2i6JRck2U6OqPV482NCSFBM1oZqC+ufluxb1XAijgKEZhz4cYhijKc7Sv6qSPlIJo2ihRey0KL0yAOz5SNEnkuBE1YucBw50ezPQZHAslKlbowVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by MW2PR1501MB1995.namprd15.prod.outlook.com (2603:10b6:302:d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.19; Sat, 21 May
 2022 06:56:17 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::f172:8f37:fe43:19a3]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::f172:8f37:fe43:19a3%6]) with mapi id 15.20.5273.019; Sat, 21 May 2022
 06:56:16 +0000
Date:   Fri, 20 May 2022 23:56:14 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org
Subject: Re: [PATCH bpf-next v7 04/11] bpf: minimize number of allocated lsm
 slots per program
Message-ID: <20220521065614.w7jqj4xg2skfg73u@kafai-mbp>
References: <20220518225531.558008-1-sdf@google.com>
 <20220518225531.558008-5-sdf@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220518225531.558008-5-sdf@google.com>
X-ClientProxiedBy: SJ0PR13CA0039.namprd13.prod.outlook.com
 (2603:10b6:a03:2c2::14) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0c28454a-318e-4df8-750e-08da3af7006c
X-MS-TrafficTypeDiagnostic: MW2PR1501MB1995:EE_
X-Microsoft-Antispam-PRVS: <MW2PR1501MB199507FCC0EA035673220061D5D29@MW2PR1501MB1995.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /7+voyBDPwtHcxxNYcUfAvM8+2e71OUeVoMc+3VJH68fZoDvukO+ObD40EWso/DKeT708iC+Dr7ixz4iqFwYswIFyTC02bxsxw3m5vyD3tH/BrrqFkL8yx3sNjshSJ1QzQeicxG9fnua40MHgz0z4phLb40QUHTztzXMgLo3KK3j4iffqMyRosX7D+3EoAF/9xI55Ha96+rV1wkwhOcBb3d1mcciMVatmntKNoQf/bJuYPtH0vo3dgZnsUT2gpTSe13IUUFbeSOOCI0otR4B/Y7YdW9YUMFd5QsLKV1Lp3WQ32LXPn/8ZWxz29vUkEVsBHL4bLoCvIV99IwdjtwbEyS+lN3oxcmnSh/h5Fx8UiYHrx4rdJSSZmBQFdiL4CerYwgcjvXoCtgvOXwN68GQE6EQ+Crnyjrh64eJny5aPfsT66neJb6QesKksYD8H3hooZ92gFKylEYhwWv+PO6Zrajne8ybvDyY6UuMMe/zccbbFLH/lIlykuNCAZHbAqJ7GG985Wwt6JAslx456JbLj8q1fX+LMZnHDiijht0aSW4ZfaehGzPNdUGev2vzGSwB+FIdAa7O82Vt+VE/KailBXEniU6wgMr4OfgUb+ui6LANpSB6vPIPYMd/bgsdK9aiuy+fkNzKQatLIgGK2koTcEqMrJxbBESdSe7syTMcguNSVLC6TBaxlIMWEpmTP/8b
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(6506007)(5660300002)(9686003)(6486002)(316002)(2906002)(8936002)(52116002)(1076003)(186003)(6512007)(8676002)(6916009)(83380400001)(33716001)(66476007)(66946007)(66556008)(38100700002)(508600001)(86362001)(4326008)(21314003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1prbzQBAysem/+XKzMmfwgrG+TwqbyDu3+2geC611OAMsUtlrHhgf1Fw9H1N?=
 =?us-ascii?Q?/4Ylfidce0BKObhZUhO/YZcVlkTDChCaOt2peySKi4PJfeGbo9zhanKXMyt4?=
 =?us-ascii?Q?Z3eCB6eesxZw2FCFcopyzyHKJrJHFi6pQ4thfgVhdhYB3vCW/RUlLmhdah2r?=
 =?us-ascii?Q?Vlti4TDC3QES4baNWV9Wavni3LbGc/Y2E+M48IoHStbYY+vXypVSRkVhjlOH?=
 =?us-ascii?Q?BB4akrH797KuqvVUajD6lGJyuFmPIajRFtOQVP6fDR2MH2YDg90rxC4cjWAF?=
 =?us-ascii?Q?E2X+BivaRnhL5QyUpv3mL2M1wXK4Ouj1LJT/QFXJkbzy9B/HhanVbamq3f8F?=
 =?us-ascii?Q?gh2r+Bboz3844wfM0Aj3R6tWdt5cW668QZatl6QJvrkBPHkTJVHA1wAt4n6p?=
 =?us-ascii?Q?hX1+RdwhyJYLBJT4eUn+g0ypur6FNB0mmIBvc+iR2fMAFoRVrBpcycnPf/IQ?=
 =?us-ascii?Q?GEaLR9lRkuwlUN5xUPSy8iIzQ4NVuQbMt6o03M2LqTtBUd1vNhiyrk6FzZTr?=
 =?us-ascii?Q?N5i3XzxKahYoVL2y8w/r5so/UEcOFgP+NpN5aFgl3mkd6VRWWXZ2D8UiVAYX?=
 =?us-ascii?Q?jssd6ElTwrEtDQWvhOPq5lCJy4eiEebIJq7wvWroLwvu7+apHdNXBWykB6fE?=
 =?us-ascii?Q?bljXyvYO/NeyTchjnOQhCLpoVk7GzogG6PFu5Xx4lDBxVEX3C9+WYLKd0Xd4?=
 =?us-ascii?Q?gCGvg7Pj6djZiNNoxGIlOnolqGOqEAbYhJSOTUFTEiP1R2AWCkAGaNTUFCj3?=
 =?us-ascii?Q?B/gwOnwe1VgFaQRfHe4wR6hmEQhGF8QDeRRoTGUITF1VatY1QiESxlZk/ev2?=
 =?us-ascii?Q?ftKGyFF4CMOZovfLsngvIR+11l0PdRCeX8gYUJw2i+XF+ws6IGREkxlP8e7o?=
 =?us-ascii?Q?gO7zl2EUGVBUXCb7YeVLqjBHVTCmujsBiYigUERZE/4xQa8u388HTkApBv0t?=
 =?us-ascii?Q?fsxuTTHB2rEvJAEAlBJKmLABNTtd5J1mezv/lpk+YPx6T1RR+G8spbLoGWWJ?=
 =?us-ascii?Q?D8zP5asjIQ5O+7jVoxggkKTE7KEIdUY5pgt/ZncBo/X3xy4CHtvIsRW+koJs?=
 =?us-ascii?Q?2T2uYhrxbwQG5eEah9Nty9X5cIsjWlDGs14BeRfEf082pVDT/G6QataJ3+7C?=
 =?us-ascii?Q?TgONcKkwrGTypsXhKXNrgYJckK76jsvyjFRwyNothW4C1G1pSx0KqsYwUsOb?=
 =?us-ascii?Q?9DyEsnrtbQRHjL0eBpE3S8+WC5nnxlRqLPUkwS/amhiS+Ad8CIMFW57nwQli?=
 =?us-ascii?Q?ZrpFzTUiOBBMr5kjnPxGUeAKoLkBknnJY3NTSB6lZEdhCARPSDSSlSdmHHv7?=
 =?us-ascii?Q?3W4Hv6iX2AxPxi/M9BVi/Wm5SoQBTo23hWsOyOJ7BloVn/j2BXoyNd5BWbHm?=
 =?us-ascii?Q?rW3VJbroyB4qOvCkmoPdaxkKl/0n0pv1t7OdnJkJkGOhm6fEo1+pvEfYI8AF?=
 =?us-ascii?Q?qsKlM4HNatj38vBQ7gJInOlowCQMJUFpIC4tQldpteZjsrKuV2TQB/t1PUUB?=
 =?us-ascii?Q?Sg2rjCv1e2boslJtxmuBN6nbphxDe98tX7//V7M777psuJpSk/0+/sb3a13z?=
 =?us-ascii?Q?+n3msf1PevwhhC6IA6tct0+u3uYsm3TbCMDq4a9uBpaBqDmSvHtg76h17PPg?=
 =?us-ascii?Q?j0vjliZJ5rGe2zxw2PexPnRNMoT3ZR/KuwsfWavNbthTOgfp6et94lNZVAF+?=
 =?us-ascii?Q?ccGj2E3en01oqcV4ZlEtQE5u1ljFH74szL3wdCBuvzvxOasCcGuXV/lVY2Wu?=
 =?us-ascii?Q?/YEWuqbXh420pL/XkTlBUAyDy0Jchxo=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c28454a-318e-4df8-750e-08da3af7006c
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2022 06:56:16.6505
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Vqv6MMxg+Zf98bxEiknr3rxQyNxMKIx+t0/sW8ldVNNWOitkhBCDKMcUcTJgKa3A
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR1501MB1995
X-Proofpoint-ORIG-GUID: DKHObFdy7DlDwkXv8EflfYXCLEfgpP2x
X-Proofpoint-GUID: DKHObFdy7DlDwkXv8EflfYXCLEfgpP2x
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-20_08,2022-05-20_02,2022-02-23_01
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 18, 2022 at 03:55:24PM -0700, Stanislav Fomichev wrote:
> Previous patch adds 1:1 mapping between all 211 LSM hooks
> and bpf_cgroup program array. Instead of reserving a slot per
> possible hook, reserve 10 slots per cgroup for lsm programs.
> Those slots are dynamically allocated on demand and reclaimed.
> 
> struct cgroup_bpf {
> 	struct bpf_prog_array *    effective[33];        /*     0   264 */
> 	/* --- cacheline 4 boundary (256 bytes) was 8 bytes ago --- */
> 	struct hlist_head          progs[33];            /*   264   264 */
> 	/* --- cacheline 8 boundary (512 bytes) was 16 bytes ago --- */
> 	u8                         flags[33];            /*   528    33 */
> 
> 	/* XXX 7 bytes hole, try to pack */
> 
> 	struct list_head           storages;             /*   568    16 */
> 	/* --- cacheline 9 boundary (576 bytes) was 8 bytes ago --- */
> 	struct bpf_prog_array *    inactive;             /*   584     8 */
> 	struct percpu_ref          refcnt;               /*   592    16 */
> 	struct work_struct         release_work;         /*   608    72 */
> 
> 	/* size: 680, cachelines: 11, members: 7 */
> 	/* sum members: 673, holes: 1, sum holes: 7 */
> 	/* last cacheline: 40 bytes */
> };
> 
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>  include/linux/bpf-cgroup-defs.h |   3 +-
>  include/linux/bpf_lsm.h         |   6 --
>  kernel/bpf/bpf_lsm.c            |   5 --
>  kernel/bpf/cgroup.c             | 135 +++++++++++++++++++++++++++++---
>  4 files changed, 125 insertions(+), 24 deletions(-)
> 
> diff --git a/include/linux/bpf-cgroup-defs.h b/include/linux/bpf-cgroup-defs.h
> index d5a70a35dace..359d3f16abea 100644
> --- a/include/linux/bpf-cgroup-defs.h
> +++ b/include/linux/bpf-cgroup-defs.h
> @@ -10,7 +10,8 @@
>  
>  struct bpf_prog_array;
>  
> -#define CGROUP_LSM_NUM 211 /* will be addressed in the next patch */
> +/* Maximum number of concurrently attachable per-cgroup LSM hooks. */
> +#define CGROUP_LSM_NUM 10
>  
>  enum cgroup_bpf_attach_type {
>  	CGROUP_BPF_ATTACH_TYPE_INVALID = -1,
> diff --git a/include/linux/bpf_lsm.h b/include/linux/bpf_lsm.h
> index 7f0e59f5f9be..613de44aa429 100644
> --- a/include/linux/bpf_lsm.h
> +++ b/include/linux/bpf_lsm.h
> @@ -43,7 +43,6 @@ extern const struct bpf_func_proto bpf_inode_storage_delete_proto;
>  void bpf_inode_storage_free(struct inode *inode);
>  
>  int bpf_lsm_find_cgroup_shim(const struct bpf_prog *prog, bpf_func_t *bpf_func);
> -int bpf_lsm_hook_idx(u32 btf_id);
>  
>  #else /* !CONFIG_BPF_LSM */
>  
> @@ -74,11 +73,6 @@ static inline int bpf_lsm_find_cgroup_shim(const struct bpf_prog *prog,
>  	return -ENOENT;
>  }
>  
> -static inline int bpf_lsm_hook_idx(u32 btf_id)
> -{
> -	return -EINVAL;
> -}
> -
>  #endif /* CONFIG_BPF_LSM */
>  
>  #endif /* _LINUX_BPF_LSM_H */
> diff --git a/kernel/bpf/bpf_lsm.c b/kernel/bpf/bpf_lsm.c
> index 654c23577ad3..96503c3e7a71 100644
> --- a/kernel/bpf/bpf_lsm.c
> +++ b/kernel/bpf/bpf_lsm.c
> @@ -71,11 +71,6 @@ int bpf_lsm_find_cgroup_shim(const struct bpf_prog *prog,
>  	return 0;
>  }
>  
> -int bpf_lsm_hook_idx(u32 btf_id)
> -{
> -	return btf_id_set_index(&bpf_lsm_hooks, btf_id);
> -}
> -
>  int bpf_lsm_verify_prog(struct bpf_verifier_log *vlog,
>  			const struct bpf_prog *prog)
>  {
> diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
> index 2c356a38f4cf..a959cdd22870 100644
> --- a/kernel/bpf/cgroup.c
> +++ b/kernel/bpf/cgroup.c
> @@ -132,15 +132,110 @@ unsigned int __cgroup_bpf_run_lsm_current(const void *ctx,
>  }
>  
>  #ifdef CONFIG_BPF_LSM
> +struct list_head unused_bpf_lsm_atypes;
> +struct list_head used_bpf_lsm_atypes;
> +
> +struct bpf_lsm_attach_type {
> +	int index;
> +	u32 btf_id;
> +	int usecnt;
> +	struct list_head atypes;
> +	struct rcu_head rcu_head;
> +};
> +
> +static int __init bpf_lsm_attach_type_init(void)
> +{
> +	struct bpf_lsm_attach_type *atype;
> +	int i;
> +
> +	INIT_LIST_HEAD_RCU(&unused_bpf_lsm_atypes);
> +	INIT_LIST_HEAD_RCU(&used_bpf_lsm_atypes);
> +
> +	for (i = 0; i < CGROUP_LSM_NUM; i++) {
> +		atype = kzalloc(sizeof(*atype), GFP_KERNEL);
> +		if (!atype)
> +			continue;
> +
> +		atype->index = i;
> +		list_add_tail_rcu(&atype->atypes, &unused_bpf_lsm_atypes);
> +	}
> +
> +	return 0;
> +}
> +late_initcall(bpf_lsm_attach_type_init);
> +
>  static enum cgroup_bpf_attach_type bpf_lsm_attach_type_get(u32 attach_btf_id)
>  {
> -	return CGROUP_LSM_START + bpf_lsm_hook_idx(attach_btf_id);
> +	struct bpf_lsm_attach_type *atype;
> +
> +	lockdep_assert_held(&cgroup_mutex);
> +
> +	list_for_each_entry_rcu(atype, &used_bpf_lsm_atypes, atypes) {
> +		if (atype->btf_id != attach_btf_id)
> +			continue;
> +
> +		atype->usecnt++;
> +		return CGROUP_LSM_START + atype->index;
> +	}
> +
> +	atype = list_first_or_null_rcu(&unused_bpf_lsm_atypes, struct bpf_lsm_attach_type, atypes);
> +	if (!atype)
> +		return -E2BIG;
> +
> +	list_del_rcu(&atype->atypes);
> +	atype->btf_id = attach_btf_id;
> +	atype->usecnt = 1;
> +	list_add_tail_rcu(&atype->atypes, &used_bpf_lsm_atypes);
> +
> +	return CGROUP_LSM_START + atype->index;
> +}
> +
> +static void bpf_lsm_attach_type_reclaim(struct rcu_head *head)
> +{
> +	struct bpf_lsm_attach_type *atype =
> +		container_of(head, struct bpf_lsm_attach_type, rcu_head);
> +
> +	atype->btf_id = 0;
> +	atype->usecnt = 0;
> +	list_add_tail_rcu(&atype->atypes, &unused_bpf_lsm_atypes);
hmm...... no need to hold the cgroup_mutex when changing
the unused_bpf_lsm_atypes list ?
but it is a rcu callback, so spinlock is needed.

> +}
> +
> +static void bpf_lsm_attach_type_put(u32 attach_btf_id)
> +{
> +	struct bpf_lsm_attach_type *atype;
> +
> +	lockdep_assert_held(&cgroup_mutex);
> +
> +	list_for_each_entry_rcu(atype, &used_bpf_lsm_atypes, atypes) {
> +		if (atype->btf_id != attach_btf_id)
> +			continue;
> +
> +		if (--atype->usecnt <= 0) {
> +			list_del_rcu(&atype->atypes);
> +			WARN_ON_ONCE(atype->usecnt < 0);
> +
> +			/* call_rcu here prevents atype reuse within
> +			 * the same rcu grace period.
> +			 * shim programs use __bpf_prog_enter_lsm_cgroup
> +			 * which starts RCU read section.
It is a bit unclear for me to think through why
there is no need to assign 'shim_prog->aux->cgroup_atype = CGROUP_BPF_ATTACH_TYPE_INVALID'
here before reclaim and the shim_prog->bpf_func does not need to check
shim_prog->aux->cgroup_atype before using it.

It will be very useful to have a few word comments here to explain this.

> +			 */
> +			call_rcu(&atype->rcu_head, bpf_lsm_attach_type_reclaim);
How about doing this bpf_lsm_attach_type_put() in bpf_prog_free_deferred().
And only do it for the shim_prog but not the cgroup-lsm prog.
The shim_prog is the only one needing cgroup_atype.  Then the cgroup_atype
naturally can be reused when the shim_prog is being destroyed.

bpf_prog_free_deferred has already gone through a rcu grace
period (__bpf_prog_put_rcu) and it can block, so cgroup_mutex
can be used.

The need for the rcu_head here should go away also.  The v6 array approach
could be reconsidered.

The cgroup-lsm prog does not necessarily need to hold a usecnt to the cgroup_atype.
Their aux->cgroup_atype can be CGROUP_BPF_ATTACH_TYPE_INVALID.
My understanding is the replace_prog->aux->cgroup_atype during attach
is an optimization, it can always search again.
