Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D80AB528FF9
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 22:43:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240682AbiEPUJc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 16:09:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347095AbiEPUFn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 16:05:43 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91B2F40A30;
        Mon, 16 May 2022 13:04:19 -0700 (PDT)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 24GIWvWD016866;
        Mon, 16 May 2022 13:04:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=2A71t2MXvnveKAb7LbVIYi65BtsYRcr0+EopDNrk2sE=;
 b=XVoTqoiFX+lG1gpMduDhjUrLScx3Yp+97XedMbYa41tylCD9C7I95WVNFqlJR5NJA5iF
 3G3u3L1o4j7nZ76aTkzhgAd5wXhArwiEGjjqi76S4Uz032QS983FMro5oTbd/gbFn5Qp
 NNthml0a/3utVjFlhOkAaobWgAXWfvE6za4= 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
        by m0089730.ppops.net (PPS) with ESMTPS id 3g27x9cf64-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 13:04:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gGNyb9ncBrJAXzqN1kEulhRSqEQNwQ724MjFk1DXcC5iX+a/do74kH5jofdWXAWcFnAtDMNWeVZKU+4gZXlaRvTNlULWQ0vf46V3Xpz8DtQHxIjskKYEuSkS2sdI/j0fxL8SPwBERrFN/qXWmWJypfKj5ua1j16/vlN2e56PfPEiawz3gV32FG3e9I7NNk5Cq7BMRFJ1R6fnXEJEnvmWrPvu/hVAvmgMbzF0BmIyFYismc36X1KUZSweTe8Q+C6Du0LOyRNdNIHL+F6bGeyR9PhUQB750OGz4dutsplsdx7aAC5StVpFhEH+s11ezk2nI226OIrCSwAk4ipakqJ52g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2A71t2MXvnveKAb7LbVIYi65BtsYRcr0+EopDNrk2sE=;
 b=gp/uUheaFtnwNof8x9OBbzKnjUTjE2Baf2R7YNF0DxzM+RPal4ddWw4pHjIeM1SDWbQWyJ7sxGLUHas3a9L9awtxWZKXG+9GWttrts8ZUIxGS4yiBXRABC7C0JCgl1ZUpkLDR1vqcdPhqgT7YKQgZ0wvqcnohW7CmN9yJE2BLkTiKIqnpxw2T8OGLAgDmDIzf9las9ac7hVz+H1Ff2tGTih0yaQf87Wu/lj3KdsT/Cnk80oUAwiDWG7TGlJLNV8Ais1dwPSvYhHJBTsljfFu1TEbr3wNw0qOEo4GqqwkZpLJrSvfm77ChbgydHxAoWx8FW5KFV2YwDP/lvWJAIlL9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by MW3PR15MB3995.namprd15.prod.outlook.com (2603:10b6:303:40::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18; Mon, 16 May
 2022 20:03:51 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::5811:4996:bbfd:3c53]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::5811:4996:bbfd:3c53%7]) with mapi id 15.20.5250.018; Mon, 16 May 2022
 20:03:51 +0000
Message-ID: <808092d9-e29d-05b6-1e18-994bdfc61fab@fb.com>
Date:   Mon, 16 May 2022 13:03:48 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [PATCH bpf-next v3] bpftool: Use sysfs vmlinux when dumping BTF
 by ID
Content-Language: en-US
To:     Larysa Zaremba <larysa.zaremba@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>
References: <20220513121743.12411-1-larysa.zaremba@intel.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <20220513121743.12411-1-larysa.zaremba@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-ClientProxiedBy: BYAPR07CA0056.namprd07.prod.outlook.com
 (2603:10b6:a03:60::33) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 991e653f-e8dc-41c3-c59b-08da37773218
X-MS-TrafficTypeDiagnostic: MW3PR15MB3995:EE_
X-Microsoft-Antispam-PRVS: <MW3PR15MB3995A57061F48DA97DB6D0D8D3CF9@MW3PR15MB3995.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wnxhrsokJt/+MqGeW2GPJaG8TwLx4yIjB8Iq6g/nsKP3OYJ8AK+gWj/LuStY12zvz1oUmxxUcrSD+Z8B3AFpb94/8ibZTHuAFhwQQoN+/ZO9UySFl6b472iu0g43/OuqmCvy7lU6PbjW75jHhKecGKJEe4bsVLzo4Jff172eZAB6OfgZzf09akq0s2PRMIMh+6TwAly7YqIZojGF65NM7TducVqr4a7Y0De9iv5bkUrlbs/DFUdaqrQ3PnKX9aBonbvkJ2FN60qrg21ZgMc5/VkzeqvQDls3wM5UhqSRFjXiGq+wWYUiJKelPOkajna4NWFGgD3zii1mihHDES0xLTCQkNyQkP0S5WmrSaubomu+0ST94RT9DSAk6Mz4HPMBSXL/OE0wJw1cl1dqNiXeTspKa543KUHqHn904gE8A7LJHaih5f4uMveBfjycPFypgBcXnITICyDIlB1RUENg0w/2LXWKlikAJMlHm+WGM5YFPz4DMCOVagwW56v0JTWpWLUdLXv/U1xM7HJThhNpIgtAMVm9E7S+yQIDHot7599VbvaNV3E1t31Mn7umwo+tIoPcl42zU9KskZVjX0gn9hCLpNzFgBSO4Ov4G4oXJqW2QXEi7HDoZ+v6wHjgOkk8tFAK4y3WwW8gMLZVTK+MzQTPeICa6fK58SW5gyR7aYuQA47IYzqVL8zknB9fWEVVA2zKQ538x+8cXedtu7xepfx8xfL/8xuJ5mvqH7Fdl9WNOS75TN921H7lrUzwUKIixSaJO9zXKpbnw0R81XJV0RbzL50AP4eqjaWpUmeeWnWDvdSMIjRQJKGz5SUup0ijM6iGSDcoCdl8BqrJOnK2ICOffYq5goOuLGds+y0rTak=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(4326008)(31696002)(6666004)(86362001)(83380400001)(66476007)(38100700002)(66556008)(2906002)(508600001)(53546011)(966005)(66946007)(52116002)(5660300002)(36756003)(8676002)(8936002)(54906003)(110136005)(186003)(2616005)(316002)(6506007)(7416002)(6486002)(31686004)(6512007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OGtCWjNwZk5zOHhMeXRnVHk5Zkhzdzh0Z3pXaHhjZVg3VklpRkE0cTRWREZz?=
 =?utf-8?B?cGR6ZXIwc084bU05dVpRNlVUTC90MVBwQ2p4QW0yM1JwcTFEc1ZFaU5IaFlS?=
 =?utf-8?B?Sjh2b29nMGxhYXZFZzBHRkw2N0ZHZkROdGFDV0FvVi9YamZPMzF5aWwwbGNN?=
 =?utf-8?B?clJ1bE9Sb0JnQTN1THlHMkh0aGFoUVBhbHdsUlFNUW1uM1VkQ2hLMTdsWjBq?=
 =?utf-8?B?Q1BiKzhCUGQyZkMyVkNtbTlqTzFGVDZUay9IVHo2SW03dEVTaUs3WmNGSTF2?=
 =?utf-8?B?TDArenpTa3Jpa2QyNnpNc2loZWtPTU9iaTVVcVJpV3NBMktycWlLelNublkr?=
 =?utf-8?B?d0hUWGlMZmgyL25FUG1rNTl1RWRtQnBJRmQrTkx0VC9Fc1FGcDJMY2xuUEtF?=
 =?utf-8?B?UkxVZHNrNkptWmpRT3hLaFVuWjhJTnlZMDQ2VUZ5eVdYWFRmdUN1R01ZYU1M?=
 =?utf-8?B?bE15YXN3SEoxaUtFcVJQOTdBRE9wMHpmVnRGNmdFbFBJMFdNb2JGSTFnVVdH?=
 =?utf-8?B?cmpkdFI0RGZZMmFuaERwbzdtYVRwaFpTNTVnYVUrR1Rac0lMd2hJMjhQY2xm?=
 =?utf-8?B?N3g4a1Jsd0hwWlRjNTlqMFQwTmlrVE1OOGdRRFVIUjZoM1VDSlRUSjQvU3ZQ?=
 =?utf-8?B?ajcrRkd0M1NnVWpicGFzYnMrT1loYkQ4MHpOdElqSExJd3lYZ3RnME81bkZm?=
 =?utf-8?B?blRSbFdBeDFPTVJXTi9OV0lDd215YjJ2OWJYT3hqek15NzM1Z2JNNHNCdXlm?=
 =?utf-8?B?VXpmbktaaTFYWmFvdTZta3FQeGRWdVRGQzFWa0VNcWpUK0wxbXo1NlV3U0pO?=
 =?utf-8?B?bm1qcFlqYkgxM1FKUU4zdDlKNUxBRU50azFBbUpVbUhQcVNPcU9BdVhHYWNJ?=
 =?utf-8?B?cXdpcFRPR2NXZnM5L0daWHE5bXRkS2d2TktTOWFCelNFb0JpT3JzYVZDcmpW?=
 =?utf-8?B?MENKVDlZMnhiNWJ3Vk1Bell1cUw0U0Juc05odkJaNWdaRTJMMlVHclhkVDd0?=
 =?utf-8?B?bWF4SCsvWlhlM09qVWk0OTZDSkdiQ2gra0l3SDBiQTc3OGwzcHpiQlNQR3E3?=
 =?utf-8?B?eStrbit4ejNlQVV0YjRZSjgxb1FqR0NpQ0k4ckVFRWNVZkUxK0tlcmp4QkxF?=
 =?utf-8?B?SFlsTmNUNzdDZkpDWHdLR0N3L2NsRFNweWhudFYrWjR5Wm9FS3R6UUkrUUhu?=
 =?utf-8?B?M2RXcXVlQ29PSnhmRmkyMkYva2QrZ3dsa0tkNWhWNU1hZ1p5SzNPeVBYdHRP?=
 =?utf-8?B?T3JJdjlWLzI2bW56VUNLRGwvQmtvdUw4b0hqWnJlendUekhhMzNoTVVTSUw2?=
 =?utf-8?B?VXc4d2xDcDhNYVZiMytmQ1FtdGNCUW4xVkxEZWhSRytnOHpUV0k3RCtrMGtV?=
 =?utf-8?B?U2xhRjBsNStJaU5DYTJGcW1WTC9PQVdpc3RWUWE0MGVpajVpM3VidnZ2RE1F?=
 =?utf-8?B?Ynd1WXFTZGFwajFQb08yUVBsNVpXcG14cWRxVlpYRTluMHBIU2NlWkZPQ09M?=
 =?utf-8?B?UG5ZS0gvNkRTby9icDlBd0p0enV0VFh6cHVaTW94NlpmWVlhTDRwT2V6U3Zp?=
 =?utf-8?B?Y3J4ekFubkRIWmhqV0h4ak5xRWFsRzFsUzgwZU4wSUlvNG43SFdneXkveE5v?=
 =?utf-8?B?V1dBd0J6Q1U3MTMyQ3p4YkRXVnN6dEJjYVpjTmFtNkUrYnZLbTdnT0o4SHha?=
 =?utf-8?B?MktqY2M2eG5UcUEzL2FuT21YUnBJTGMwR0RLYUU2NURkWDhtalIydFRaU2lH?=
 =?utf-8?B?YzFoNnRidlFnZjUyajRnUzc5bHJBQ1FvRldrSmxMdnJvbmgyRGs1aHVmMFdC?=
 =?utf-8?B?ZmpoYWZaMzdPbHd2UnhHQjdyK2VKWnlPeTh6YlhUV2djektqbDNmU1lXZW02?=
 =?utf-8?B?N0dENkNkc3gxbE1ZM2xkUC9MUjUrV3QrbzA1QUhoM3pPRjZqQWoxeHlOQUxG?=
 =?utf-8?B?eStrd0xjajNSdTJ0UUFpclZBZEZIZXVsK2hPMTNGTUY0YnZjbzRPUFRLTmU5?=
 =?utf-8?B?SVJvZ012QmlUc2VtUy90Mk9LTFl2MkRDUDhNclVIUkdpbDFWNlZqcDhRK00r?=
 =?utf-8?B?WUZtNGlvZVRYSHh0MGQraG1kQUlPcFE2NGxzN2dLOFF4Y2xkSEJFdld5REta?=
 =?utf-8?B?TEJxR2JoZE9MdWZLVWlyYldkdVI0Zk1YWnhSYWIzcHpESVEvalZUL2RBVk1G?=
 =?utf-8?B?YzkvK2ovQi9kUmk1N2IzV3hWZkNVSmQ5YWlTcHQyWU16WG12bzZmb250MFFr?=
 =?utf-8?B?U2EyZ2hqRVNtbk44Uy9Xcmx3Nm1oNzRRT1Q0a0pTOG9pMzVVMVNJWFQvM0tH?=
 =?utf-8?B?U2dxVjBLZTN4elkydWNwVkxGc0NTbUxMc3N6OTRLcHVyVUlGemNoano3Tkhy?=
 =?utf-8?Q?TtK9RWgemVLTtrcI=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 991e653f-e8dc-41c3-c59b-08da37773218
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2022 20:03:50.9029
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2iG5dSHX983+8yat65qRBZQjFKWY2SvHAeB9yOS1GUMqpRj6l6IklGMF3u0X9g5w
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3995
X-Proofpoint-GUID: Nmmix2Epwwf2WsnVc0hY70iZUOn_Ntsx
X-Proofpoint-ORIG-GUID: Nmmix2Epwwf2WsnVc0hY70iZUOn_Ntsx
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-16_15,2022-05-16_02,2022-02-23_01
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/13/22 5:17 AM, Larysa Zaremba wrote:
> Currently, dumping almost all BTFs specified by id requires
> using the -B option to pass the base BTF. For kernel module
> BTFs the vmlinux BTF sysfs path should work.

This is not precise. It should be that
dumping all module BTFs specified by id requires using the -B
option. In current situation, to dump a btf associated with
a bpf program, -B option is not needed.

> 
> This patch simplifies dumping by ID usage by loading
> vmlinux BTF from sysfs as base, if base BTF was not specified
> and the ID corresponds to a kernel module BTF.
> 
> Signed-off-by: Larysa Zaremba <larysa.zaremba@intel.com>
> Reviewed-by: Alexander Lobakin <alexandr.lobakin@intel.com>
> ---
>  From v2[0]:
> - instead of using vmlinux as base only after the first unsuccessful
>    attempt, set base to vmlinux before loading in applicable cases, precisely
>    if no base was provided by user and id belongs to a kernel module BTF.
> 
>  From v1[1]:
> - base BTF is assumed to be vmlinux only for kernel BTFs.
> 
> [0] https://lore.kernel.org/bpf/20220505130507.130670-1-larysa.zaremba@intel.com/
> [1] https://lore.kernel.org/bpf/20220428111442.111805-1-larysa.zaremba@intel.com/
> ---
>   tools/bpf/bpftool/btf.c | 65 +++++++++++++++++++++++++++++++++++------
>   1 file changed, 56 insertions(+), 9 deletions(-)
> 
> diff --git a/tools/bpf/bpftool/btf.c b/tools/bpf/bpftool/btf.c
> index a2c665beda87..0eb105c416fc 100644
> --- a/tools/bpf/bpftool/btf.c
> +++ b/tools/bpf/bpftool/btf.c
> @@ -459,6 +459,54 @@ static int dump_btf_c(const struct btf *btf,
>   	return err;
>   }
>   
> +static const char sysfs_vmlinux[] = "/sys/kernel/btf/vmlinux";
> +
> +static struct btf *get_vmlinux_btf_from_sysfs(void)
> +{
> +	struct btf *base;
> +
> +	base = btf__parse(sysfs_vmlinux, NULL);
> +	if (libbpf_get_error(base)) {
> +		p_err("failed to parse vmlinux BTF at '%s': %ld\n",
> +		      sysfs_vmlinux, libbpf_get_error(base));

nit: libbpf_get_error() is called twice. Can be consolidated into
one call.

> +		base = NULL;
> +	}
> +
> +	return base;
> +}
> +
> +#define BTF_NAME_BUFF_LEN 64
> +
> +static bool btf_is_kernel_module(__u32 btf_id)
> +{
> +	struct bpf_btf_info btf_info = {};
> +	char btf_name[BTF_NAME_BUFF_LEN];
> +	int btf_fd;
> +	__u32 len;
> +	int err;
> +
> +	btf_fd = bpf_btf_get_fd_by_id(btf_id);
> +	if (btf_fd < 0) {
> +		p_err("can't get BTF object by id (%u): %s",
> +		      btf_id, strerror(errno));

I am not sure whether we want p_err here or not.
The function is to test whether btf is a kernel_module.
If anything wrong happens here. The original logic
follows and an error will be printed out any way.

> +		return false;
> +	}
> +
> +	len = sizeof(btf_info);
> +	btf_info.name = ptr_to_u64(btf_name);
> +	btf_info.name_len = sizeof(btf_name);
> +	err = bpf_obj_get_info_by_fd(btf_fd, &btf_info, &len);
> +	close(btf_fd);
> +
> +	if (err) {
> +		p_err("can't get BTF (ID %u) object info: %s",
> +		      btf_id, strerror(errno));

The same as above, probably we don't need p_err here.

> +		return false;
> +	}
> +
> +	return strncmp(btf_name, "vmlinux", sizeof(btf_name)) && btf_info.kernel_btf;

This should work considering current module names but the code itself 
doesn't sound right. The characters after "vmlinux" could be arbitrary.
strncmp(btf_name, "vmlinux", strlen("vmlinux") + 1) is better.

> +}
> +
>   static int do_dump(int argc, char **argv)
>   {
>   	struct btf *btf = NULL, *base = NULL;
> @@ -536,18 +584,11 @@ static int do_dump(int argc, char **argv)
>   		NEXT_ARG();
>   	} else if (is_prefix(src, "file")) {
>   		const char sysfs_prefix[] = "/sys/kernel/btf/";
> -		const char sysfs_vmlinux[] = "/sys/kernel/btf/vmlinux";
>   
>   		if (!base_btf &&
>   		    strncmp(*argv, sysfs_prefix, sizeof(sysfs_prefix) - 1) == 0 &&
> -		    strcmp(*argv, sysfs_vmlinux) != 0) {
> -			base = btf__parse(sysfs_vmlinux, NULL);
> -			if (libbpf_get_error(base)) {
> -				p_err("failed to parse vmlinux BTF at '%s': %ld\n",
> -				      sysfs_vmlinux, libbpf_get_error(base));
> -				base = NULL;
> -			}
> -		}
> +		    strcmp(*argv, sysfs_vmlinux))
> +			base = get_vmlinux_btf_from_sysfs();
>   
>   		btf = btf__parse_split(*argv, base ?: base_btf);
>   		err = libbpf_get_error(btf);
> @@ -591,6 +632,12 @@ static int do_dump(int argc, char **argv)
>   	}
>   
>   	if (!btf) {
> +		if (!base_btf && btf_is_kernel_module(btf_id)) {
> +			p_info("Warning: valid base BTF was not specified with -B option, falling back on standard base BTF (%s)",
> +			       sysfs_vmlinux);

Having 'Warning' for p_info seems not appropriate. Similar to other 
p_info, you can just remove 'Warning: ".

> +			base_btf = get_vmlinux_btf_from_sysfs();
> +		}
> +
>   		btf = btf__load_from_kernel_by_id_split(btf_id, base_btf);
>   		err = libbpf_get_error(btf);
>   		if (err) {
