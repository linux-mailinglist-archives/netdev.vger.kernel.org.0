Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41D8A6218F5
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 17:00:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234635AbiKHQAc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 11:00:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234606AbiKHQAa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 11:00:30 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACEDB59FD9;
        Tue,  8 Nov 2022 08:00:28 -0800 (PST)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A8FMVMP014891;
        Tue, 8 Nov 2022 07:59:56 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=Zo4Jn6tXWagAc63PHKC8DLxoOXT9tJ/plmgA1ZT12jA=;
 b=dNaor7lwEPIOj0NBNMZMa26lJbuPMlMo+bqMzeoVw3Rw4x+F6Ghw6xxT3v9+rFvb1dIu
 pJla1mtf0OFT9s9tNcdvlXBl6nMoDqTKjZb3vCt+41yBQqUXBisfTj0smtt6hjDT7xUh
 Bcu8PDBc8CfQgyFG7lGcK43Usfh2sWb0bSMIE2pQF32r2+cWD+6YJac09r4iCxOUh8e7
 kXIJE95E31bWNeGEL1AUohtNive7g72asmg/xPfbuuDJPofcyLlWwWYSr7Kvzw1U75d1
 pZH9Yj3FT9XGLygeB7j4ne7vLxqjRfTAYYDuU08MyXwrkSbtcpnmF8u6/bYt7ExBTa1r 6g== 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2107.outbound.protection.outlook.com [104.47.70.107])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3kqd0eda23-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Nov 2022 07:59:56 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fUKiUiCo3TyCDiz9NsmxXSL+fISQuRt/GEjdvNKAXOO6rRazM4ta38PSAENt0c0b4qM43onJG/K5uGUqwwZwuk0l3YCyc7ZDT1ZWUuN9nfKPecRMrRIYSWm9+ijsgc8nIuuiJIFLJWRbTKVq79VUTdOusgOEpBoUYgu6H3l25gBTI8TXXtTgk8YRUJeA1GFXaDmNmrx8j5dJzKVToX1tTHpmCQ6f8gTkmBbtlAA/RoKLE9AFVhhF6XljT5OlnAGGqq7vXOFAgeqCIXLnD/AI3qwipOsjiJs630I3CPwEdPqQhoQEleBeDnGjcYjczG4OWKYO0FUepqlhHbbpWYcpyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zo4Jn6tXWagAc63PHKC8DLxoOXT9tJ/plmgA1ZT12jA=;
 b=h46BRuQshqRxSsN0fP+Hf4k/mTOgOYuuMi/+tmyWE3737J8lps/yNBbzzIPQzWis8VdfdDZou86dhZ1qTe76iG77vdXrXmX7ehl7/7DLmxk3KqFH5oQAiRryFXr60YixACWVz+a0STV1SYYtiHQsgQwf7tuc5cJz9Na1L2+e2KsymFapyOaPHpGySKMD5W3QOG6KlG9/kf2pl6K1KoNlwq5qMmOi9eWaLDdPeABHufOXVcWOqMa+CNhtt4pXsZxAoqnVJOGlr8Dl4fHzghK2DfK5J+kpw85zyJe7PvxRzf92vNinO20/SMF4M2EBnExdvP9mZf9WrC6JeMaBEo3zVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by BYAPR15MB2677.namprd15.prod.outlook.com (2603:10b6:a03:153::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.26; Tue, 8 Nov
 2022 15:59:46 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::1f2:1491:9990:c8e3]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::1f2:1491:9990:c8e3%4]) with mapi id 15.20.5791.027; Tue, 8 Nov 2022
 15:59:46 +0000
Message-ID: <c8bd9f3b-52fa-08bd-e5df-e87b68ffdbba@meta.com>
Date:   Tue, 8 Nov 2022 07:59:43 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.4.1
Subject: Re: [PATCH bpf] selftests/bpf: Fix xdp_synproxy compilation failure
 in 32-bit arch
Content-Language: en-US
To:     Yang Jihong <yangjihong1@huawei.com>, ast@kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, kuba@kernel.org,
        hawk@kernel.org, john.fastabend@gmail.com, andrii@kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        kpsingh@kernel.org, sdf@google.com, haoluo@google.com,
        jolsa@kernel.org, mykolal@fb.com, shuah@kernel.org,
        tariqt@nvidia.com, maximmi@nvidia.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20221108131242.17362-1-yangjihong1@huawei.com>
From:   Yonghong Song <yhs@meta.com>
In-Reply-To: <20221108131242.17362-1-yangjihong1@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR05CA0081.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::22) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR1501MB2064:EE_|BYAPR15MB2677:EE_
X-MS-Office365-Filtering-Correlation-Id: a651170e-1f31-499c-b808-08dac1a2421b
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oO/ibTo1inX2bi0yXlmZoSZEWZjoVmDgNTVxQqLsDPBKIi3coEJHKQOUg2bfkaUHcpxQQT5AJGtjOs2WK9eaEBysprdH7t8jp8tgTDvYoAIEEIQxh8Yl/PFp/yya7mIveJutD2oe0qe8AHbFt8i39W95vHG+jHg/5VrRZbu2uqmbB76pStehmptMzGOBDrPXacueAy+cgI6CRfJ5cZPKksyiKufR0VaQN7mkLnjx0EIPMgsj4v5vA6wT2QdxwZm9XEsPhs3mYKkdRZOa4wX9SDkHfg+YiEM7w+f1A90MMZyCfxUEhWfe/f/K6G6LZn6zVb9RiarG1bCTnaC9sbeQ+2kMjG2u9WLHWm43WuvBxGB/D+EVcyRZP+ewwahraCrf6QE7gLvoVwjbSGordKp6Kl1n/ZD//yOo4bMXZpOf4XZ3rrg3g32QKjzn08fp2heJ9Z9GtHZ6GQHciV0hFd3TVlfls+tdk8UP/HDfonw7CTUfiEXPCF2lObMoPxeiCuXL+3sC7nEGVCOCj4UO+FQ+Pb/mMb5fhnyBc+8DYHuTnl1nm8KLHOkr544qdb68JY0VgIhfPExsUL/m6a6k6kyptKjXwfw3wKBDH6CjZTVH43ifRXnlZVM/QHxf7IVNXcpjKDbWoUw9oQMGs9B4rDda/ICqB7cgshVMzUb7Q0l99xhQjesn9zp1FYQUjt4hXIC6o11v4yQLicqW9HLkasB7DJo/1tXRCF1ggegjrQK4bX8ZwliSsxVB2JxlJYi6CFK/0VKY2hdmbwADZsirqBA3udcn5IdraaWSY7GYGB8V5KrswdmhQ86BBgOUOvGrBfWG
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(136003)(366004)(396003)(346002)(376002)(451199015)(8936002)(31686004)(38100700002)(7416002)(5660300002)(41300700001)(2906002)(86362001)(31696002)(66556008)(66946007)(316002)(36756003)(478600001)(921005)(6666004)(6512007)(6486002)(6506007)(53546011)(186003)(66476007)(83380400001)(2616005)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NnB0aC9EYmZEejU2TzNYRlhMSXQyTExwYW90OEFSeWRYRFhqejAwelpOWmlj?=
 =?utf-8?B?M0MwSTZacGFNMWZncndBSUNPb2tCdUVnWVZ5ZkZDVWFXZkN6U1ViYnBIZVpL?=
 =?utf-8?B?dUhHOWwxWkFvdWZlTm9PdjlLV1ptWTR5b1c1TlVObXpKZmVCdTZublhtYVBX?=
 =?utf-8?B?NDZnTFpieTBycWplVXRjVWpKc05GQmJhdk1tZUk2a0MzK3psSHp1SE1XbjFP?=
 =?utf-8?B?VW9KTVp4QXIwSFRNazFzelBhd3AzeHZsTDFQekRDWFI3dm5ZeXg5NWhTbnVx?=
 =?utf-8?B?RUowM3Rzai8yUHFPRkNUc1duOXpoWC9tam1PeDNQWk5JUFBPelRHYnJEOG9I?=
 =?utf-8?B?eG9WdE45Ni9hVmNRQmMyQWE5ckpjQTNVd0RGMCtWcEFNUHN3R2RtUGZYV2VF?=
 =?utf-8?B?cDI2YVJSU3MzeDlFRzFwS1BTTHlrcWMyQ01TUXFGb2IwZGRJaUZHNXlzcXBS?=
 =?utf-8?B?UkRyUFBTbHJKdkhYWXVUSTlzUjZNOEw5ZEkwbXJlcHlCS3UzSjg4aVN0NENs?=
 =?utf-8?B?V0xmZU1lVGN6V1c3T3ZZTE4yOUg2MDBFbGkwRmM1SGVsQUZyOGVpRXNON3dT?=
 =?utf-8?B?ZWpIZ25ZbWFBM1FjU0NFNjZOaHVPckVjbTNxc2t2UUtYa0puOW1MRlplV3Ny?=
 =?utf-8?B?OVNhMEpaeXFPR2l1YVdwVUhPQ2lNUHpVZEFsNkYzcU16RXJUbk5GbWJwNlYz?=
 =?utf-8?B?MVhYK0JXQ3dhTlkxL1lhcTBFOW1pQmxiL2RWZjRqT0xMVTlwR0xkZGJwM1dx?=
 =?utf-8?B?TDhjR0VhaUNUNHEreXA1dGlTNVhmYmg5ZnJmMXhOalZkOFRyRWF3bStJSURS?=
 =?utf-8?B?RmlJTHhaVGtEV2JjZjdYNFJwRHZqdFhaK2hISnlXY3pwTWx0V2FlRkhYV2g5?=
 =?utf-8?B?c0pDZDFQczhaNkZRYk9rQnVKVHh1M09PajdLZTdSaDdsbGZ5ME02Y2FaMkVZ?=
 =?utf-8?B?M1YrRklXQ1RVTzlhU1VsSStJaXk3MnRzbHBPaGgycTlLajNkYWtnZU9hUjdL?=
 =?utf-8?B?QWxQWEFLVEQ4QkJ0OE5vQWtkUWF3R2gxVUZLQTU0clpwZVZRaGVvUUxFdmli?=
 =?utf-8?B?YjlDYVJKQzRpR1V4TGU3NVRBSUxGNHp3MWVkaHBQTVpBM0VIQmw0NjhwR3ps?=
 =?utf-8?B?ekF5VWl0ZEJtbzh2dHF0RGQ3V0pHOUpyUEVxcFBTaWViODJSeWhIcGt0WUZj?=
 =?utf-8?B?eUU3UmdJZmJ6Tkx5NzlBalRCMWh4cklVMWQveWJxYlVrQmNqaisxdlE0MCsw?=
 =?utf-8?B?cnpWR040MjM3SHViUVhiMzlLVllrRjBDS3lMaVBDRGJHUDcwVGxLU0xhNjBl?=
 =?utf-8?B?M3NNWTNmcmNqb28yMkNEWi95cXkvLzF3RFd3eW9nYXNjaTV5STlxTzgyYXlq?=
 =?utf-8?B?NUQ0WkF1dGdiaWNZWk1SR2lRbXFpOENoSnVjNEFxT1BrVXRGSVNVSWNiNEdJ?=
 =?utf-8?B?Z2QvNnpyNXJsaHg3aFFDS1BsWEkwYlplY2Z0WEpGSXFPN0s4RVkrNjhtVkpw?=
 =?utf-8?B?N3IrY3ZBajdhWW14ckFWeFRmZ0VBSmVBUmxOUUI3K1ZoSUgzOHNkR0tyckJk?=
 =?utf-8?B?Y3hGWkQzZHk2dVlxUTFDNjdFRzM1U0hqdzREVEtDNURWNGhFNmh3dTZIOWU5?=
 =?utf-8?B?ZXowSm0zYkNpdklLTXl4dlVZQlB2K1pNaGphRjNOVG9PcGxLWU4xck50ZkJI?=
 =?utf-8?B?Z1M2TXZwWnV5T0xQejFxUWNyRkQzQTRMNEZhMzIyV2ZkV08xSHorRjVsakcz?=
 =?utf-8?B?cDE5bG9wS3Y0SHI5UDhZS0V0elUrbjBkS09GZmVuY3ZtOUdwTEdaNTFHc1RR?=
 =?utf-8?B?RSs0MW1ZL3Z4Q1RBOUxJNEVRaWh6WGpvQzh5aGhDcVR0N2orQmgwVkIvdVVC?=
 =?utf-8?B?MlRSSWlodWU1TnRZZ2FrMDdKemxoay9UTUp3dTBSVjFuZGFsVWtkYklRSHFG?=
 =?utf-8?B?YVV1YTRoR28vdTZmOHh1dTBEZ2VWUnBmbDFEc3g2LzlteU9XSGdSaFpFeTZ3?=
 =?utf-8?B?Q0l2blE5cktxbFRiNWtUSFBIcnoyR1ZiYXEyQ3EwWFlaMnFvck5LR1VpeEFq?=
 =?utf-8?B?Z3NJWjZ1VlFSZjdzVUR2MDlURFhucklWb0V2MFdmcFNSemMrUlVnOE54WFlj?=
 =?utf-8?B?VlFOUnR1TnFLTUR0M3pOcFpxbHFqV0x2WHAxS3FiVUV1SWZmcy9LS3hzZytv?=
 =?utf-8?B?b0E9PQ==?=
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a651170e-1f31-499c-b808-08dac1a2421b
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2022 15:59:46.5571
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aDgMFzaPw7USjcFrBTb+a/0DfRPmbPargWiwvHKtTlXCjZYfPS8/DDY1q/iLSw6r
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2677
X-Proofpoint-ORIG-GUID: vmfn6AP2w5PjxdfAF_D23M7jA-mhnhzv
X-Proofpoint-GUID: vmfn6AP2w5PjxdfAF_D23M7jA-mhnhzv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-07_11,2022-11-08_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/8/22 5:12 AM, Yang Jihong wrote:
> xdp_synproxy fails to be compiled in the 32-bit arch, log is as follows:
> 
>    xdp_synproxy.c: In function 'parse_options':
>    xdp_synproxy.c:175:36: error: left shift count >= width of type [-Werror=shift-count-overflow]
>      175 |                 *tcpipopts = (mss6 << 32) | (ttl << 24) | (wscale << 16) | mss4;
>          |                                    ^~
>    xdp_synproxy.c: In function 'syncookie_open_bpf_maps':
>    xdp_synproxy.c:289:28: error: cast from pointer to integer of different size [-Werror=pointer-to-int-cast]
>      289 |                 .map_ids = (__u64)map_ids,
>          |                            ^
> 
> Fix it.
> 
> Fixes: fb5cd0ce70d4 ("selftests/bpf: Add selftests for raw syncookie helpers")
> Signed-off-by: Yang Jihong <yangjihong1@huawei.com>
> ---
>   tools/testing/selftests/bpf/xdp_synproxy.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/bpf/xdp_synproxy.c b/tools/testing/selftests/bpf/xdp_synproxy.c
> index ff35320d2be9..45fef01a87a8 100644
> --- a/tools/testing/selftests/bpf/xdp_synproxy.c
> +++ b/tools/testing/selftests/bpf/xdp_synproxy.c
> @@ -172,7 +172,7 @@ static void parse_options(int argc, char *argv[], unsigned int *ifindex, __u32 *
>   	if (tcpipopts_mask == 0xf) {
>   		if (mss4 == 0 || mss6 == 0 || wscale == 0 || ttl == 0)
>   			usage(argv[0]);
> -		*tcpipopts = (mss6 << 32) | (ttl << 24) | (wscale << 16) | mss4;
> +		*tcpipopts = ((unsigned long long)mss6 << 32) | (ttl << 24) | (wscale << 16) | mss4;

This looks weird. Maybe we should define mss6 as unsigned long long to 
avoid this casting at all?

>   	} else if (tcpipopts_mask != 0) {
>   		usage(argv[0]);
>   	}
> @@ -286,7 +286,7 @@ static int syncookie_open_bpf_maps(__u32 prog_id, int *values_map_fd, int *ports
>   
>   	prog_info = (struct bpf_prog_info) {
>   		.nr_map_ids = 8,
> -		.map_ids = (__u64)map_ids,
> +		.map_ids = (__u64)(unsigned long)map_ids,
>   	};
>   	info_len = sizeof(prog_info);
>   
