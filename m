Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 484834423B0
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 00:03:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232263AbhKAXGa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 19:06:30 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:6130 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229618AbhKAXG3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 19:06:29 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A1GoYgQ005430;
        Mon, 1 Nov 2021 16:03:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=4zbqsh4gTx50xVB+XvBErkVTY9Wj/T7BuCeyc+7SuIM=;
 b=MH6VDJNjfR5P24zH4EUm+3UFJ5UMKzv8NBiumzlHHoE2axcfsnahYOJo+Ejv1PPqy2U8
 a1Ldy7hBU6gQ516sh4Ikei4qM/zexnmMqoilpRfgKMb+1qbugT/v4OZr+BYkeBnAm0nT
 41sgNld8sMjZkhwlnB9LLNdj995ejiXfaYU= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3c2dp1n6p1-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 01 Nov 2021 16:03:42 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Mon, 1 Nov 2021 16:03:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W4MdESHrShOxb/bC9bYdaaRjET2p2Vu36hgrsyUTCTrPdou8f2vZy1QukWXevG2yeXudheqbE8htpAI/DCvKMrDXCdZM6TcUyqMCgLZHWgp8bVChsUrXhUfIqH2ZEg99Z6TM/4OMCrntexsLss1ULbk92D2+rz/eUjKqLwEgywEoh8zMz5CZ61LsQjnbwtAhEuU24RpjYsucqpYiPQNDSISMz9alU0SxWfE6ACBWy86Ou0YmwAAinI+awJb5kgP172hte3tcklAmO74E70y2GRlFkPJ/D7OSpBgGAB0FGBJLPox0JlkqPuR8TRNuspN3Knhc43kS1+UFjQFzCgvLLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4zbqsh4gTx50xVB+XvBErkVTY9Wj/T7BuCeyc+7SuIM=;
 b=ddLgQYajPiEQgGnW7Hf4XuQPS35uioOtPkkJcSA2sp1iT2tRWINifQXtbireBdl08uXYxwZcoNUkSe6e+1t7zFA5o3ohP3mQ1K0KhNwD81V+FGFfNDkqiws8UXag80xas6pFHaQJng0HryfSoMSNnYN7/cUiawRVez9sJBpF9NUAe1cv2zIHAmuWasrrY9ZpYrPzHJk0r4wDg7R5Bveq3mZ0jsLhjuHNKwcDI76ja3aPns3jNaVKRMKPlz36uJwNTIjScjD6cupIT4bPdJvFkij0m8QpUOjOCEPRe6oDjB8SuocywWmYQ0MdlYORcve98ssaAsG5E6biZK6Up5rLHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.17; Mon, 1 Nov
 2021 23:03:40 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::51ef:4b41:5aea:3f75]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::51ef:4b41:5aea:3f75%6]) with mapi id 15.20.4649.019; Mon, 1 Nov 2021
 23:03:40 +0000
Message-ID: <87ea129f-a861-5684-8071-cd3390375d3d@fb.com>
Date:   Mon, 1 Nov 2021 16:03:36 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.1
Subject: Re: [PATCH v2 bpf-next 2/3] bpf: Fix propagation of signed bounds
 from 64-bit min/max into 32-bit.
Content-Language: en-US
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <andrii@kernel.org>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <kernel-team@fb.com>
References: <20211101222153.78759-1-alexei.starovoitov@gmail.com>
 <20211101222153.78759-2-alexei.starovoitov@gmail.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <20211101222153.78759-2-alexei.starovoitov@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CO1PR15CA0104.namprd15.prod.outlook.com
 (2603:10b6:101:21::24) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
Received: from [IPV6:2620:10d:c085:21e8::198e] (2620:10d:c090:400::5:38d3) by CO1PR15CA0104.namprd15.prod.outlook.com (2603:10b6:101:21::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15 via Frontend Transport; Mon, 1 Nov 2021 23:03:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e24e3daa-30a6-4a95-4954-08d99d8bd84d
X-MS-TrafficTypeDiagnostic: SN6PR1501MB2064:
X-Microsoft-Antispam-PRVS: <SN6PR1501MB20644A7245D32A19B4821924D38A9@SN6PR1501MB2064.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:2150;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MLeC+x70ltdKz/pG4u+cKHHSHM2YWRazBKfImt8ThkAbCOmvx3npV1O/pF157QLMeNsmrdaUw+CnR2WwoD/2dIEyU8zCmDyzBbAIi1ngXCo9ubRQKdrULkWexR23N8fKy90pKaWbkzPOL5SIDTDlYAB6RkPvH5XkLe7NRzKu6e3tdbd3DCcW8q9tI2kI3kzS4Ibb6clV0H5DcF+YKsT1xy9ci9FLdiR5s8mbh63rNBQVreSJOQdAFnDmAJzyC7d3UkOivHp0VX2V1ydKWq5GDyN9NW/mOSOoRfMZ8yynuHxm+EUSGd2IW66kTsCBbzpHKNa4PV695Vsi9J7oh5DTEgKTr1kdblB05Gq27o2+yNQtDxOIIzRMePfB57EKgDp9ctG5FR5ooYiFtChDWuWhPRombR82GGOiZrDdzL9IRv5IcNmnO1QJymUHoDuK7ffYNbz6xEtPbw+Q0d9XX6DxJvdmqlCvVzaYI+o0EtU9G02tu57bgqKQX8vCNc6MeXN4pLjwOJw2E3WRzbPpdOxik1asRdjcFG8lfycdSb9Xh96CAabG3hRNG2ORzW/Bu9rQJGWxnpr915lZZvIq5OQSwz4usAy915Z/ZL7yIEy9dYHCc7xkPsRQ/uL6OSwADf65+9JdYx9Tb2HupSM8xNCQYb9eMxNymp/BVMEvMcWVQ0ldHOJUrjD7BSuO9iD+4AnXekbqNHfWFQPNVQRMfMRz7HtP+nIaK+dHf427oZKfg8Ub0WKbVgFFGgRZpA8F0uC0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(5660300002)(86362001)(2906002)(6666004)(66946007)(66556008)(31686004)(4326008)(66476007)(53546011)(31696002)(2616005)(6486002)(38100700002)(8936002)(52116002)(508600001)(186003)(8676002)(83380400001)(4744005)(36756003)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YjlGQ3h4TXBNSjNRZzVJY0NuRmlEejZVemR3aTBMOXUvTnU3ZGxEdXhLWjY0?=
 =?utf-8?B?SWs3VmV2MEJiVHkwUW9kR2JEbXZieGQzdC9TMUFtaWRQdXRtWWN3WlVkdlFm?=
 =?utf-8?B?elBXOThaL3FvemF6eVFvdGlKT1N2K25HLzVJbUpGVlc0blkrSFdqT2pWalNm?=
 =?utf-8?B?Y2dXMXl4cndTNzVQWVBkUTAvQnZjeEp5WTFXanllSDJra2hwMnp6ZTlNbWhH?=
 =?utf-8?B?TmF2Uy9YMU1FTkVGMmpKQ0hxUE1lbVMvVEhaaFo3Vkp6QTVobVNtQUdiU1Fx?=
 =?utf-8?B?OENQcGEvckNjUkRmSDUxMWpGUEd2SmhKMjRIY3J5RE1XajFzdHNvYjYvZWJP?=
 =?utf-8?B?QW5wL3FTOFBVNVBMMDBnK1FGQkt2cmhMZTdiVzdaZXIycmREV2lJay9zNDg4?=
 =?utf-8?B?ako0MlVRUTdkWjJ6VldIQmI0djhseGtIa2xRaHQ5dmdycHZ0ZFJOTzFvb05R?=
 =?utf-8?B?bnRmM1RJd25VMVdhcHZNYkhqSXlZS2Uwd1RQL0NlMCs2OThpNDFvbzJqQnc1?=
 =?utf-8?B?UWc2ODdyeHlOSEdWZVBqY1czU1N4UTBOdDdEK0pnbEltbnhyWUpXNTk1a0pq?=
 =?utf-8?B?V0NwVFJhb21ZM1Nhd3QrT3lqMktBSnVVZktRVXBMNGk2RHJtU2NVZVRFdkJ2?=
 =?utf-8?B?R0Z6cGVyYzFlWWJ0Z1pFQ2k5SDR3M2NLZng0TzBlM0F0elNXV0drQXMyNWZy?=
 =?utf-8?B?M29zOTh3VU9kVXNDSDU5WHVvSGxNZ2pIQkV4R0FGRzJYTkJncGo5SmNERG5K?=
 =?utf-8?B?MzNFYWtUU216MUpzUW1oSXk3cm1reFB4dDRhYktrUll1N1NVUkZ4R052emx3?=
 =?utf-8?B?eW9sZXJNbnVzWFc4UzJKVHcyR0VleG0xQ3FhS2IvYU94VyszTmp5MGw0Nmc5?=
 =?utf-8?B?N2E1Yy9XNjFCVVBLVzdEUE9UZnkybVVJOFIyZ1hJRzc5TmdlcExqYVUzbHE3?=
 =?utf-8?B?bFg0S0NNQnhKWUJwNXdRbjRremhvZ29OOE9ZZFNGelFLSHZlZ3pIM1gxalFp?=
 =?utf-8?B?VThlK0lrUUt6TXZYZ25wMmF3cDJhLzY0eDg4Nm5CMGQreVp5KzZSZG5pS0ZC?=
 =?utf-8?B?dHF0eFphVHlwQmIvS0x2UXpCRHQvOEVTMHh0S2RqVGpGSUpaQnM1ekxGRGxn?=
 =?utf-8?B?L3Noa2dhMzV0ZlZuSUg5OGIrc05OVldTZ2pJMWUvTk80L2hzTVpFcWlJTFBu?=
 =?utf-8?B?UjFGRVVpR0o4ZVJOSUY4RHVuajVWTUtoVDdXbG1PcEFtLzNSODFxeXlrb3Qw?=
 =?utf-8?B?amtVaGVta1ZhbFZxUnFhM3dXeW82bU4wSjJsaHI5bGp1NlhMOVlOeWcvRmNJ?=
 =?utf-8?B?cVpCanlyREcyVmVHODdtU25UV2xiLzhDWSswd0hKTG9JRHcxMkFuY1J1enEv?=
 =?utf-8?B?cVE4Mks3Rlc0TWJ6YWVBQ0pUTDNvY0FBY0Vob0FBZ3E1MkpyS01IeW52Umox?=
 =?utf-8?B?OGxCK3ZUMGpya0lMeEt6UEQyekNEdkRhQ1FNOGpvUHNiODNGeHNlQjRETlBv?=
 =?utf-8?B?R0FnNmdObTJGNnVHZjlJUTNNOFhNeUNsTWxjU3N1N3FYYzdpZVdzRzl3Tk5x?=
 =?utf-8?B?djN0WWNGM09lNDZzUlgyeGtoczYzNEsyYWUxc1VsYTVaTEEvd1dUMTd4dTk2?=
 =?utf-8?B?SmRIcFFmZWsxNUd2TlV2MmtlYm92MVdmMk9JQlNmbVdXZmEwYTlPMVBGR2hi?=
 =?utf-8?B?UjNtUnU1MFUyZS9hVTIwenhpQ1A5ckFBYllWNjJiRWc5cExPci9vd1BFNVhi?=
 =?utf-8?B?TktRTlRSd09TRStHQzNoU0xVTkJtaENNRGVHWTFSbDFCWXRPODljS3RTTTZz?=
 =?utf-8?B?SGlTUFdsTFFnWjhmZkEvWVU2Q25xNmI3OXE3dnVmTHFKTzY1dEJIQkgzUTQy?=
 =?utf-8?B?cGY3cDE5d3VvWXpwODhhYlZ6TjFEVy9BSHF0b3hQWGRNMGFBbHlQRHlBVGto?=
 =?utf-8?B?RkdSUGJjL2x4bHA3dnQxUklSa2Y2ZmYwd1ZnUjVNblhzR01Ycjd5a0MySWhI?=
 =?utf-8?B?bEJmcktBMlhmU1U5ZVM0M1JMdWFCUXhEa3NDWllPTnV4MkFVdVJadzBndTF3?=
 =?utf-8?B?Mnk3UHVHdG9xTnM5QWh2ck9YcHJyM1Fra2pKNmRkK0hFZDJ1RTdHUEFiTmNk?=
 =?utf-8?B?bFlMTjYyNzF3Z1VhejhTRFhzMEpPejFJeUpvbXd6MUxhN0pEc01mUkx6dERY?=
 =?utf-8?B?TEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e24e3daa-30a6-4a95-4954-08d99d8bd84d
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Nov 2021 23:03:40.6653
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DUFwVECJ2WSSx8HfsNCToIygGht7/EfIy0hmGpA01mChFprjMBdUn91t/fIhfj7s
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR1501MB2064
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: o18QFJ9rv6XXTV1qENEr-DhCZ_oFVyy7
X-Proofpoint-GUID: o18QFJ9rv6XXTV1qENEr-DhCZ_oFVyy7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-01_08,2021-11-01_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 lowpriorityscore=0 suspectscore=0 bulkscore=0 priorityscore=1501
 clxscore=1015 phishscore=0 spamscore=0 adultscore=0 mlxscore=0
 malwarescore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2111010121
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/1/21 3:21 PM, Alexei Starovoitov wrote:
> From: Alexei Starovoitov <ast@kernel.org>
> 
> Similar to unsigned bounds propagation fix signed bounds.
> The 'Fixes' tag is a hint. There is no security bug here.
> The verifier was too conservative.
> 
> Fixes: 3f50f132d840 ("bpf: Verifier, do explicit ALU32 bounds tracking")
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>

The change looks good. Should a new test_verifier test be added
to exercise the new change?

> ---
>   kernel/bpf/verifier.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 29671ed49ee8..a4b48bd4e3ca 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -1420,7 +1420,7 @@ static void __reg_combine_32_into_64(struct bpf_reg_state *reg)
>   
>   static bool __reg64_bound_s32(s64 a)
>   {
> -	return a > S32_MIN && a < S32_MAX;
> +	return a >= S32_MIN && a <= S32_MAX;
>   }
>   
>   static bool __reg64_bound_u32(u64 a)
> 
