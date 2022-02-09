Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E07BE4AF5A2
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 16:43:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236137AbiBIPnc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 10:43:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231892AbiBIPnb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 10:43:31 -0500
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC259C0613C9;
        Wed,  9 Feb 2022 07:43:34 -0800 (PST)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 2198pfp9028176;
        Wed, 9 Feb 2022 07:43:06 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=vXxbbj1kq5/JAY3/f8yw4TwCqod6NWUf66KGi5E8yo8=;
 b=fVPZqdrG1dFAJKgfvA2it0HbsSfDrTFkku/soSKxvi1fyBXtY+SwgLboqr9IX090G2f7
 RH3nN7Tded0Qur35lmnmpud2YdRMHBs7hsxO3gIazj7henJL2V4rV6Lmt/5/OWfxXUHU
 1rGhO5PqIO1qrE4mzZVkWPefWtYtNQh6lR0= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3e3y3s60x9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 09 Feb 2022 07:43:05 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 9 Feb 2022 07:43:04 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ge0Qz8h+qbNeHWBWw+Ma0F/ZjSpBQtaFpkZpKSz36AlJlOCT5XNu1DlpCqC5tLNU1o1tuiqSmrdqI6WJq6fJVpXqg8hlQQMn5wYWRtmZyns1DR4WTx432dhijC2eyLlh6c66AxPQp1XTX2XuTAeKcyZyTR65rt5W4nDFGQZny/OzQdRZGmiZvPc0yx6WNbb6YB+rizAVh0grovMEzt25ipD/xtfCtAMoZadKq6+49sS+219mv7gYBAXN6hL02u4ubwwB9/hXbukBS1ZLeD4e6QmFm+BU+mAuXqyO8AE9QeGA6VYAWrY205GfNR9bQNjDUMF3JO4WsWXkNfArtnvF1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vXxbbj1kq5/JAY3/f8yw4TwCqod6NWUf66KGi5E8yo8=;
 b=U02oF7XSSuR/m8HnQQUz18FdZ/vab9Qg835Um/lRH0p+P3A3BdDjfU1RhLz9I1/FJBJuG+MI1tGE+yR2o9GyUj7yrVbaVpP9TWLGZM2NR4l0BrG2NDX1+4vF9J4limWwUigQ2TADBkSr6qNOXJ1kpCidZOm2jUD22+r1/bwfIsW5iuXySo3hq/MsgwaYf2Tk1txzX/Z0L+DnvJjxU7BKLJJlb7W2Kw22xuZ5EKJhV1o2pzHYBG4bevkHHbi2a32W8rHUGy+8cFit0rW4WbySHwEPZ1YuB5I4Jez2V6j5+vyqzOiJ2Yv4y5BR32EPUjnwB459Pc7Z4WFVGZyROVo1Vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4482.namprd15.prod.outlook.com (2603:10b6:806:195::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Wed, 9 Feb
 2022 15:43:03 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f54e:cd09:acc2:1092]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f54e:cd09:acc2:1092%4]) with mapi id 15.20.4975.011; Wed, 9 Feb 2022
 15:43:03 +0000
Message-ID: <54064f1c-5ff0-e6c1-dae5-19bec4b7641b@fb.com>
Date:   Wed, 9 Feb 2022 07:42:58 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Subject: Re: [PATCH bpf-next v3] bpf: reject kfunc calls that overflow
 insn->imm
Content-Language: en-US
To:     Hou Tao <houtao1@huawei.com>, Alexei Starovoitov <ast@kernel.org>
CC:     Martin KaFai Lau <kafai@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
References: <20220209091153.54116-1-houtao1@huawei.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <20220209091153.54116-1-houtao1@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
X-ClientProxiedBy: MW4PR03CA0287.namprd03.prod.outlook.com
 (2603:10b6:303:b5::22) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0748e384-fdda-47cc-8b44-08d9ebe2db8e
X-MS-TrafficTypeDiagnostic: SA1PR15MB4482:EE_
X-Microsoft-Antispam-PRVS: <SA1PR15MB448286B1C50531E3589A02D9D32E9@SA1PR15MB4482.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:1775;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H1ttIoD9hcDDbkXMQIMSBvS0Y2uGGZUGb/fgKNvcXxQ3wNG+GtrFMF2MlN11cBSbxjnKx9JhGu7CFhuxwaF8VCxA/JG4MjSYyNSZ7pRvh2jJxx3+Lj3pAvWvGLNYTGQ1dfEAUFjCxv4aHy+99fcCt/F/PPI2FqKcYXOsQzLCyIRdvLfk+u0YUSTnGK7x0TDFq8v0pM111dFLugH+MbBk/Jh6MGA9uPdqdK82sib6cxqRDM3sCJdNd4XNBiYq7FlFqc7NoqDN2K0k2NWJyl7VfKnawytT0vTL2RcIrkKmkpgX4Yl2S2zEO3yiwc/rHMvmpszEpYw9nkduULvrc+WwVDhNc0RzAjis6J4RW9fudX5U36lV7C9ucyRnjJbxOIsLcoTOR9nmdCQjJxM/eqXWqpr8FQrIzDvO/3AkqscGsfANeFnIPfqOxTsJHP9ub5eCcEuS6Q8OXT5vtqXM/FP4iIzotJjb8z4v6q9XNsOoexJgaQrT8xNxw6oQW3y0nlkKxRPAjzCX3JL252G4xoO1g9D0cbiaOFVOHjwypT+4877u+f2GQOOAQv6H1+yqdSlKey07Cz/cjCpPeXiDD/MZxHgOIKPRqCbnRYMpBqO1vB7gPruGpe4LmANebdL1kD34gjljaJQdmwsop/8nUin1tpD5crMKZxebB+hGRMivtvcBkANlTZerm91gtmOVQNaUo3RRaHgWqXQfjT6FfbBJfdN8juryQTRdR7N3pOeWdL59ypJHXXNpcf0wwjG3F9lj+GnBU52LjzmLdUXg7OB+fHlpmowGlpJGDPXOvuxTL/AieYzazct76KLikY/4GpVJJT7k2Ni/RDf8ujOCSdLmURfjt8Rz4JBLeXtDGZYeo6y19I3bBNQNE51DKp5Umxln
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(186003)(966005)(36756003)(2906002)(6486002)(508600001)(38100700002)(31686004)(2616005)(316002)(52116002)(53546011)(110136005)(6512007)(6666004)(54906003)(86362001)(8936002)(5660300002)(6506007)(83380400001)(31696002)(66476007)(8676002)(66556008)(4326008)(66946007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c3RHUnM4VmQ4MmRTSlpDMlZIYm5XNEtsUi91T1kxNkxCUWxtY2VKSW1aejVR?=
 =?utf-8?B?OFBpT0tjK3J2SFZ2OXpEVDVGL0d0ZmZNSFlZTTBXS2F6K2xsaE5zY2VTWXEx?=
 =?utf-8?B?Tk9WY0NTaXUzSUVHM04wcEt3UVJFRmw4MzJZK05GTmVlandNZy81VXkrcFRU?=
 =?utf-8?B?NkE2VkMyVlVuN3oxWkZxUk1PaEErbUhRZ3RCajFxSWR3cE1yT3MyVjVpOXpX?=
 =?utf-8?B?clhWM2pzbW1uY2VPc0hidlJBbS9zTU03MmlrUnZzZEZCVDdtUTZxVENZNzJo?=
 =?utf-8?B?cDJKKzY5a2VwejVVQmVtS2hNcmR1bWxadW5GOTFFb0xWMSsyWVlMWDhOVGl5?=
 =?utf-8?B?NFBuWnhKYkZTZkpCMk43akJ3UFJvMm1hSzVHa2FCVzZqZ2txSFg4MUFnNFI5?=
 =?utf-8?B?Um1TR1MzNzV1bTdDVlFpcFV1M09ubjZxbURaRHZ2K0NRRWhnZU55TGRqQXhC?=
 =?utf-8?B?MGR4L0FmTFl0aHQwTDNMWUlZMUVyZUd0OVUxQ2NJWEpkUTJGU0FuOVY2SWFz?=
 =?utf-8?B?bG9DZ21KRWZ0NUtaUDZKQSt6bnlUVU1XVnRhVGJLdU5mUkhaNWg0dTM4d1hu?=
 =?utf-8?B?cldyT1pvSHFhVHJZY0J3MWs5SElnOFl0TThJZFEreFo5Tm1JbzdYYTM0c2w5?=
 =?utf-8?B?YVc5M3ZWWU9CSnJUTUU4alNsUHdsbXRubDBJL044VXdKVXhTY0VPZmJEVndX?=
 =?utf-8?B?QUd3SmtRdkpiQU9pMWlyeEt0UHFRU1pCV1J0Y3hmVk5WelE4cjB3YmxRNVVp?=
 =?utf-8?B?ZzJkbjRRWVRQNUVMRkwwWUl1cXdnZWlvWERndVdWWk9JTTZVdWpQeGh3WVgz?=
 =?utf-8?B?b3MzaGY3TzYxUnovMGlYTGo3djQ4bXRTM2trbkIyUEhIbnl5bStBa2xRckw1?=
 =?utf-8?B?NzFtVWVTcEhjbHlkeXh2ajlKVVZCUVFIeS8zc1ZEN09PU2Z6UzJBYXUwWkRN?=
 =?utf-8?B?TGhYTktjWDRaLy9uOXVwTzF5Zks0R1I5Y293bnFYRDFDbWxMblR3ZThNUkVK?=
 =?utf-8?B?S2RSTFRrRGNNUTJIOVp5YnNHZ29UdnBqRDIwQ3d0ZVNiN0QrU0hGMmROTGN0?=
 =?utf-8?B?VUlrV2F1QTcwV1QxVWJXcDh0em9kR0Iyc3FoYjZ2QWxxeW1HNkQraW1tdm9z?=
 =?utf-8?B?dWdYaGxoTXdldHRyQi9XT21NQkkvaHVvL0NYbk5jSWd2bmVEbUt6TkRtMEpV?=
 =?utf-8?B?ZzdISXpMN3dGeUlDdmJpQVpjM24vcmp0OWNZSHM4UU9aZTFJNnF1b0YxWncz?=
 =?utf-8?B?VzZ4YVZFZElBMSsrb1pZcnJGUEVNSHZ1YW1VaDZaT1lxU0psV1RPL3ZYNTlH?=
 =?utf-8?B?RHdZZmhNZHdoYmtTVExid3JTSEhCYUdlTmxmSXlxWVBCMmk0NUJWYWtXNnRP?=
 =?utf-8?B?alFlVDM1WkM1NFlocW9UZU9SN3BOcG93MkFpekFuQ24yLzdWdTFkQ0JRU0FH?=
 =?utf-8?B?WExmbzU4WFFXY3RpVGF0NUF6dnFoTE9vRHV1MzhMajR1b1p0UjBlUUdaU0hH?=
 =?utf-8?B?UUY5ZGNmT1NrTEFFWWlNRnh5TTVVS21VT3JhS2FCcGwyZXRuT3grNEZaNTFl?=
 =?utf-8?B?VnVtODZsbDNjNy9naFJkOCtjdHE3ZmdRQ0ZRZ2FRYnpZeG1tbjZpeXVLTk5S?=
 =?utf-8?B?dVRtcmdHL25tbldJaHRTWlZJTjFSYm9mZWNxcmRtaDBOWU85T3plK3lpK2FP?=
 =?utf-8?B?Vm0rZ1pzSi9NdnVkUXFIbSs5YXNTZkxoZWZOOW8xQlB6YitjMEtEQ1k1cjZB?=
 =?utf-8?B?WUN3ODM0NWdOQURKbWpUM012R0ErMDMxdmN6ZmNqTDgxK2dSUlhyS2owOTNE?=
 =?utf-8?B?dzJZdnBmclk1V0VZRFdmUjdwanY0Zk4xU1Z2aDNhS3pDNUhJVUlGeTlNUzhI?=
 =?utf-8?B?aXBuMGltUDlUTzZPdEgxQy9QdFVjYXJkM3VCMkkxaUxPc0VUVHhJbEVnUWk5?=
 =?utf-8?B?Tk92T0E2SWdMdEJQQ0xWS1FUc2lhZjVlaDd0QXRWVVR5ZGpHZEw0MjhmYzJ5?=
 =?utf-8?B?V0huTVNTWE5SRG9laUVqL3RUdERUVVlZcG5NcWFPVU9IWFNmSXN5SmRjVkZm?=
 =?utf-8?B?MWM1U3dDQVVtT1Y2ejdQZHZMcjZvdmZNNm5Jek1BdTJqV2daNFhrQUZhUWtx?=
 =?utf-8?B?NVZXRE5EbytuemlSa1lYUlo3WHBOVkIxeWNFQjg1VVlza0Q1WmZnZHYvNHhP?=
 =?utf-8?B?Y0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0748e384-fdda-47cc-8b44-08d9ebe2db8e
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2022 15:43:02.9730
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1UcKIMzJOp4P5HMNXiw2TXE43akhxRDirEndC4pAqqMAVKgyCCmJ4bIrGOZDm0EV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4482
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: wllE6h0-ZNxjy_YlO0PjgQuOSOSXoR2J
X-Proofpoint-ORIG-GUID: wllE6h0-ZNxjy_YlO0PjgQuOSOSXoR2J
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-09_08,2022-02-09_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 priorityscore=1501
 mlxlogscore=999 mlxscore=0 phishscore=0 impostorscore=0 lowpriorityscore=0
 suspectscore=0 malwarescore=0 clxscore=1015 bulkscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202090088
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



On 2/9/22 1:11 AM, Hou Tao wrote:
> Now kfunc call uses s32 to represent the offset between the address
> of kfunc and __bpf_call_base, but it doesn't check whether or not
> s32 will be overflowed, so add an extra checking to reject these
> invalid kfunc calls.
> 
> Signed-off-by: Hou Tao <houtao1@huawei.com>

The patch itself looks good. But the commit message
itself doesn't specify whether this is a theoretical case or
could really happen in practice. I look at the patch history,
and find the become commit message in v1 of the patch ([1]):

 > Since commit b2eed9b58811 ("arm64/kernel: kaslr: reduce module
 > randomization range to 2 GB"), for arm64 whether KASLR is enabled
 > or not, the module is placed within 2GB of the kernel region, so
 > s32 in bpf_kfunc_desc is sufficient to represente the offset of
 > module function relative to __bpf_call_base. The only thing needed
 > is to override bpf_jit_supports_kfunc_call().

So it does look like the overflow is possible.

So I suggest you add more description on *when* the overflow
may happen in this patch.

And you can also retain your previous selftest patch to test
this verifier change.

   [1] 
https://lore.kernel.org/bpf/20220119144942.305568-1-houtao1@huawei.com/

> ---
> v3:
>   * call BPF_CALL_IMM() once (suggested by Yonghong)
> 
> v2: https://lore.kernel.org/bpf/20220208123348.40360-1-houtao1@huawei.com
>   * instead of checking the overflow in selftests, just reject
>     these kfunc calls directly in verifier
> 
> v1: https://lore.kernel.org/bpf/20220206043107.18549-1-houtao1@huawei.com
> ---
>   kernel/bpf/verifier.c | 11 ++++++++++-
>   1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 1ae41d0cf96c..eb72e6139e2b 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -1842,6 +1842,7 @@ static int add_kfunc_call(struct bpf_verifier_env *env, u32 func_id, s16 offset)
>   	struct bpf_kfunc_desc *desc;
>   	const char *func_name;
>   	struct btf *desc_btf;
> +	unsigned long call_imm;
>   	unsigned long addr;
>   	int err;
>   
> @@ -1926,9 +1927,17 @@ static int add_kfunc_call(struct bpf_verifier_env *env, u32 func_id, s16 offset)
>   		return -EINVAL;
>   	}
>   
> +	call_imm = BPF_CALL_IMM(addr);
> +	/* Check whether or not the relative offset overflows desc->imm */
> +	if ((unsigned long)(s32)call_imm != call_imm) {
> +		verbose(env, "address of kernel function %s is out of range\n",
> +			func_name);
> +		return -EINVAL;
> +	}
> +
>   	desc = &tab->descs[tab->nr_descs++];
>   	desc->func_id = func_id;
> -	desc->imm = BPF_CALL_IMM(addr);
> +	desc->imm = call_imm;
>   	desc->offset = offset;
>   	err = btf_distill_func_proto(&env->log, desc_btf,
>   				     func_proto, func_name,
