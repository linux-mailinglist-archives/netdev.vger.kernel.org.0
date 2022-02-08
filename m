Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5F1F4ADEBF
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 17:58:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237696AbiBHQ6C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 11:58:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230391AbiBHQ6B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 11:58:01 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BBA2C061576;
        Tue,  8 Feb 2022 08:58:01 -0800 (PST)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 218E6xLE013404;
        Tue, 8 Feb 2022 08:57:36 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=vqxVCzvXIfkDaB7CkNie+7f432/g25ReSXtmKdHaZK8=;
 b=kodlOQmBerdXTusB+d1RS5d3SogoF8IrtIGxXbsf32EwF2BhdHE+so4NHucGRmax4XVl
 B/2m1YM4wLrX5iCehYDMB99qEfOlWI4ZX6xc8YKKmK+33OEoUNnfiBUiZl4tUPHTm2MH
 wYEPNgZojecFpZUKP0SvDBEcLCGJ+MKP8kM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3e3puw2esm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 08 Feb 2022 08:57:36 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 8 Feb 2022 08:57:35 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NF6F6PwWiegLURFDGeMX7h2UG/nPDtVZIKk1uMEKi1GWypwCCGe2vYVZ8Vo73JIg81PfydHIQTcGZ2s5oL57IaSX0JSQe7HnwmUPtFQRHcX7HkgDDnHrTmiOjWh8iLSGWCsH3jCBLNnR8YlZ2p8NfGLhk5mOE0obmrzmJzI5bMx2cpZyNJg44ioj97WdARyPDu0Ehe4dgxopwtDL07bSdyqudnpy/EOKivDgcxIwL1u3cc5MxeqtufD9qioO6qPDhNXk3Q5X5vsweE7azFnDmGcZSWD5AjAlWIvhmiskM9KUBngoPrdUT7yiIRoXXBSy3tpo3+xc4kkWiPintELnaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vqxVCzvXIfkDaB7CkNie+7f432/g25ReSXtmKdHaZK8=;
 b=Xy0qNWTqAw78K9IGBElI9RUEcEX475y2jjEKOB1/bj9HUCBS/500ldDAEhg66an2Z4p2YbzDDdKWC78e4+Al16YbLOJ+xkMn+5aqu3Ey944ZfT1k1ytC0krNULUZIdA+axEt3VThHr2XYl8O+y1/rlEGU+JrFen849ZzW+PPJ2HPS5Z3EeCaI0eoOp+R8sPMch4Ufx7k3PRlb1L7cfSQ1onn4vF4SSUX4afeHuQzf5ncdtVi5BWsiv/eZzPq2PDuBKGyEdQPMZU4xjG3qEpy+oPYzAJZwwAw2ExThvTLuOkbaMgQ/fOHutHYwK9GDMMfE4sdNsCCL7xaYKNUAsqfow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from DM5PR1501MB2055.namprd15.prod.outlook.com (2603:10b6:4:a1::13)
 by CY4PR15MB1304.namprd15.prod.outlook.com (2603:10b6:903:113::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.19; Tue, 8 Feb
 2022 16:57:33 +0000
Received: from DM5PR1501MB2055.namprd15.prod.outlook.com
 ([fe80::c5d8:3f44:f36d:1d4b]) by DM5PR1501MB2055.namprd15.prod.outlook.com
 ([fe80::c5d8:3f44:f36d:1d4b%6]) with mapi id 15.20.4951.018; Tue, 8 Feb 2022
 16:57:33 +0000
Message-ID: <a11e8024-5a83-3016-f741-110ee74ee927@fb.com>
Date:   Tue, 8 Feb 2022 08:57:30 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Subject: Re: [PATCH bpf-next v2] bpf: reject kfunc calls that overflow
 insn->imm
Content-Language: en-US
To:     Hou Tao <houtao1@huawei.com>, Alexei Starovoitov <ast@kernel.org>
CC:     Martin KaFai Lau <kafai@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
References: <20220208123348.40360-1-houtao1@huawei.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <20220208123348.40360-1-houtao1@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
X-ClientProxiedBy: MWHPR14CA0013.namprd14.prod.outlook.com
 (2603:10b6:300:ae::23) To DM5PR1501MB2055.namprd15.prod.outlook.com
 (2603:10b6:4:a1::13)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 859b5222-3a89-4d18-c7a1-08d9eb2419c7
X-MS-TrafficTypeDiagnostic: CY4PR15MB1304:EE_
X-Microsoft-Antispam-PRVS: <CY4PR15MB130431B49F611842225FED32D32D9@CY4PR15MB1304.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nBm95oUKLa+TkED0h1nLh+fXMOUZbBMsfuQHHMt9H72mxkjtcwskBCgI1Yyusq8YB9Dv6BbDZObJWSan9U5jH1e/yTuwDvFiaNuTYLSydZZn5R4VrrMHkn+kixgIZak9QXXjJvIWO/E2DQ8OCIKk1vjILMEBT3fm2e+PX4Stgq6varWDRjtJfaQ9AugY4/oVynfdJhIkb0OUTSH3x/r+pzTPds2o5S0zmL3KK2Gy5m77f8mBt4tWLmGOp9bn2YDLEzYmcpHa1ESlnlliS+iTbo8iKNTVfaIgo1C28mWDBZzLJG/PjfwztUJmQvJDJ/fhXtbecjnM7CXQee/NyQXprXRvez4xPPwzQmX/ebgzTljk3F9hoVqIv2UvhKsZnuJ60QsDyNKkZOExyDA1ENdKSu2Hgc0bMz88+pBXeax2yVlsfYnYG9FB17O45o1dMRzdlmZz+jBySkX1e3JoYwzqD6qWtKZbbRNP5NwPiWcD/7QasJe/uVLJDysZuRuBMnkR4r7wqLngfFELpA2YOJAqnF4XXyfx8d6tcYjMx7JV/jGG4YJp2msvLjBu5yfxgJoFwJj4sx3ViAza7E1P7w110ErCs/T2OvQKtpHDm0c4ocP4HgyT9pdryrgdijGtkYwmvnT9hua15GfVMVQSPcwkIs1NHYiNhEiTzJaOY0qgbFU+i0UxnjX4M7M0YQvry691vPuUiD/KxBKDvmMDdnyCZQsPPAs9epbUObyvllZaaSL1WIofIATRynpUnyUKjAZ6IoxUQTghrOZ8Pl3xrKVHQXetLaYvleUEySfuy5pVRvrUZgsFAFpq8yLo3BlnkMvEVMYWuMTCy2wFU0EbghtJnQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1501MB2055.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(83380400001)(2906002)(36756003)(186003)(2616005)(38100700002)(54906003)(966005)(110136005)(6512007)(6506007)(86362001)(31686004)(8676002)(8936002)(66556008)(66946007)(6486002)(53546011)(52116002)(4326008)(31696002)(508600001)(316002)(66476007)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RERKeFowVnV1T2tOQ211WHgxdGdXTHZ1c2tHUk1kM1VkbHZzMEtMSzFodFNk?=
 =?utf-8?B?S2V6aGhlTzVpNFdzbmFpMGcxSlk0djd4VmNsQTBSZFhVMStaLzdZOHZSZ1BD?=
 =?utf-8?B?VTNmTHNOL3pUTVBvdCtwelBaMUtLay9oTmcyTEFFUFE0WElGWnpTU3NqVGdl?=
 =?utf-8?B?dDlaL29wYzhFMFRrWnA2cDBEa1FSUHNkWXpTVnBNSmZGRC9uQTBSYitXMEx5?=
 =?utf-8?B?Z1VxVGRkMkltSTRvSUI2aWFja2tBM21EVXp4MCtSWkZlSzUrdktwRVZzTWdT?=
 =?utf-8?B?ZDdKcUV2clJiUU5qNnExUXN5Q3RLbkFtTXN1cG82U3hIeUREbUUybzk4Q3E4?=
 =?utf-8?B?SFdBc01wQ1BnenhzajhrVjVybzZsM0lpMWNnS2VzZ2UzczEzL1dQRWthMzlC?=
 =?utf-8?B?VXFBYjVOOG03WlFNenFkY3VwRnNvMEdEUlh6bkpZSWh0VC9ndktNdVVJYnU5?=
 =?utf-8?B?WTRTN0VicWwweTVXV0Uyb3V6NDRDWWtSMWxQRGJOdk4xTndwMUsvQXhMT2VN?=
 =?utf-8?B?YkxqeVF3eFNLUVVjdGVMNFVWOXhuUFRwTXppSmJFeXdYNmVWelpnZjBJaHp4?=
 =?utf-8?B?T1BOTUYrWkIzcjZXQ0hESTh0bElXZHpST0JrdGl3VlF0RDZwSmloNHdlcVB2?=
 =?utf-8?B?Wkc2T3RPS1cxWFlmY0ZhQ21nU0lHL2hMMzJpcEJWVzhqbllYSm9ibnFkWEtB?=
 =?utf-8?B?aGlZZ2NkaXFLVEFqSjBWaHhvdzgrRHBJZmxjclhBR2hvMWtrMXk2eUJ1SkFI?=
 =?utf-8?B?cEVmOTZVaFNYMjBZVnlXOHhIY0d4c2lBS21EUWlweXI5M0I1eUtBeUtjWllj?=
 =?utf-8?B?dWdFWEJKVjk4Q0wySjRjZGlBZ2JzQWVZYlpqL09xbnJScUYzMFlidTdkQzh0?=
 =?utf-8?B?eUJWcG5SMjhnRlZPVURIWERIRU82TTVQdUxHT0ZXbERjS28xZms1YTFSRWVu?=
 =?utf-8?B?RFFGUVk5WTBYb3RXd1ZOekFqS2h5NDdUSVV3L3dwMUtYcjlUTUJNTDNrS3VM?=
 =?utf-8?B?TEhnSEY0RDhZUk0weUtveFI4ZUhQdHRQVUNOb1BiSnV1SDRhNWdwdi9BUzR6?=
 =?utf-8?B?UjZrUTNQcUQ4WUl4QmZ3R1RzdjRCZitXanFKbWFWU0ZzTysrV21ybjBRYWRW?=
 =?utf-8?B?R2VocmFlYmY4a2J5MDZsdWkyOGtuZ0VsYWM0eDVsZFlibGNOR2ZiUHZLOG5M?=
 =?utf-8?B?UUg1aFZ3RjlMMVc2Qjg3R2NURDhkSlpFaVJLTXdQcEZDTEJTK2ZVaXlJSHNq?=
 =?utf-8?B?Z1VZTzd3K1VzNW41KzZiSUN6Qk9La0xvS0RjZUdpU01wanBaZGM3QldHZmNB?=
 =?utf-8?B?WlgrMG9jY1NRQVpiL2llK0dyNnZTdy9FdDJPWS9SVjFvbmQ0S1RXeTU4NG9q?=
 =?utf-8?B?Ty9CKzZ6RUthWFJmQXYyRFQyT2RlcjU1SUR4SEpsM05VV0trRmpTM0FEYitv?=
 =?utf-8?B?bWRtWkM4UVhWemRSWkNsMFR4a2FOaGQvcExWQVF0cEFsVVEzL2tneFF3OUpS?=
 =?utf-8?B?ek9RR0pxNHg5Wk1XMWtFWnRVeTM1K1YwdGNZenFwVXppT3hGZUpEOWU4cURx?=
 =?utf-8?B?b3ArY2ZrNjFPUEc3VGZ1RDh0QnZLL0lWaEM4S3pyWTdSend6ZXJoUHlZNWox?=
 =?utf-8?B?cXZIRDFwcVk0ZmRKZW9hekpoMllaTmwwcGlvRlFVaHBSUWxRQWNSY1RrNFJp?=
 =?utf-8?B?MzNKd3JjVnE1QVlaMGhORnNrYjBNUUkxbkJpamMvMUd4ckxlTDIwQTZJSVlu?=
 =?utf-8?B?L09kTERVeXVwcDZZelRqOVRWZ1F6bDZuc0tSQ1NoUnc4L01Wa3pPc2FZVjky?=
 =?utf-8?B?QTcyRG96YTZoOUh1M3VlZlREbkFQYXlQRmhCMTk2cnNCb05wUWZBWUZOYldv?=
 =?utf-8?B?NUl2clBUaVM1clVLZ1A3RjV5a0x1OUxBbTBCZDg1MFhoVFpiY3VOQ2lXeGcx?=
 =?utf-8?B?bGdKNU5ZUU9ZN1RIMEJHTi94dHZTTVEwYWNwdEpIejBRVlFoQXBTdlhXOUIr?=
 =?utf-8?B?Z2g4L3VpZnV4OU9BMGZ3TEdEdmhQZnErV2xpUnIyUEZ3S2NrNTV2UlFCdnYr?=
 =?utf-8?B?elF2UHpscjEwOS9rbXI3Ty9WY1cvTWkyY1FvZC9mQjFHcytyV25vZ1pOYVVI?=
 =?utf-8?B?S3lGb2hMOVNPZS9PU05Pczl5L0Z5S01BMi9RRUlNQ3hVYkoyazN2TWdQVEkw?=
 =?utf-8?B?MVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 859b5222-3a89-4d18-c7a1-08d9eb2419c7
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1501MB2055.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2022 16:57:33.4446
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: geTkINb/RLYi1oB+0yJiVfVFl8YD2+sIZL4KUmYSp0nWId7FmSRRa24TxgUBADVj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR15MB1304
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: d2DX36M_y2pxFSTE5L_T35GBrtm-WH2L
X-Proofpoint-ORIG-GUID: d2DX36M_y2pxFSTE5L_T35GBrtm-WH2L
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-08_05,2022-02-07_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 malwarescore=0
 mlxlogscore=999 phishscore=0 mlxscore=0 suspectscore=0 lowpriorityscore=0
 bulkscore=0 spamscore=0 priorityscore=1501 impostorscore=0 adultscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202080102
X-FB-Internal: deliver
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/8/22 4:33 AM, Hou Tao wrote:
> Now kfunc call uses s32 to represent the offset between the address
> of kfunc and __bpf_call_base, but it doesn't check whether or not
> s32 will be overflowed, so add an extra checking to reject these
> invalid kfunc calls.
> 
> Signed-off-by: Hou Tao <houtao1@huawei.com>
> ---
> v2:
>   * instead of checking the overflow in selftests, just reject
>     these kfunc calls directly in verifier
> 
> v1: https://lore.kernel.org/bpf/20220206043107.18549-1-houtao1@huawei.com
> ---
>   kernel/bpf/verifier.c | 13 +++++++++++++
>   1 file changed, 13 insertions(+)
> 
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index a39eedecc93a..fd836e64b701 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -1832,6 +1832,13 @@ static struct btf *find_kfunc_desc_btf(struct bpf_verifier_env *env,
>   	return btf_vmlinux ?: ERR_PTR(-ENOENT);
>   }
>   
> +static inline bool is_kfunc_call_imm_overflowed(unsigned long addr)
> +{
> +	unsigned long offset = BPF_CALL_IMM(addr);
> +
> +	return (unsigned long)(s32)offset != offset;
> +}
> +
>   static int add_kfunc_call(struct bpf_verifier_env *env, u32 func_id, s16 offset)
>   {
>   	const struct btf_type *func, *func_proto;
> @@ -1925,6 +1932,12 @@ static int add_kfunc_call(struct bpf_verifier_env *env, u32 func_id, s16 offset)
>   		return -EINVAL;
>   	}
>   
> +	if (is_kfunc_call_imm_overflowed(addr)) {
> +		verbose(env, "address of kernel function %s is out of range\n",
> +			func_name);
> +		return -EINVAL;
> +	}
> +
>   	desc = &tab->descs[tab->nr_descs++];
>   	desc->func_id = func_id;
>   	desc->imm = BPF_CALL_IMM(addr);

Thanks, I would like to call BPF_CALL_IMM only once and keep checking 
overflow and setting desc->imm close to each other. How about the 
following not-compile-tested code

	unsigned long call_imm;

	...
	call_imm = BPF_CALL_IMM(addr);
	/* some comment here */
	if ((unsigned long)(s32)call_imm != call_imm) {
		verbose(env, ...);
		return -EINVAL;
	} else {
		desc->imm = call_imm;
	}
