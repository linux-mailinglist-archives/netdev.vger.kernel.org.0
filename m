Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6528339CA54
	for <lists+netdev@lfdr.de>; Sat,  5 Jun 2021 19:56:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbhFER5t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Jun 2021 13:57:49 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:46140 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229964AbhFER5s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Jun 2021 13:57:48 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 155HtaNo029541;
        Sat, 5 Jun 2021 10:55:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=lpXnB1mdaG6Kps54uMygNTIYT+mQ5e/DowpE6oFhjeQ=;
 b=UjhsI8fDVaCpwHcZGDsuV89S9SQsJ/FbwHQY4m7cPo7XaDn1hereJEJyv5rHsvCL4WDn
 kW12HWd3A3I5sVMxjjDdwGkV8Pve0ORriWiFEUeYTc+7J7r+hlbw1XT+xFtEm4S6ALYt
 XpkCoFbb9DRdeihYgzqst0zhe9gRs2O7aIo= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3906ym1g59-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sat, 05 Jun 2021 10:55:38 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Sat, 5 Jun 2021 10:55:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jeMILDwF8BTadNmrcDYsl/5IDibQhuu9ih/Sw462BnQs2iChvsTlTWY4mwi0LHHRoObovXqV2Fjx7paXZ3KNaWv9LsDR5ZCpLTEIJ23NmxShHYGTUWiXq9iTbKWAakH8aZ41ISQToKXGeegQuiA/fN37fXOOHSuGvh0t0tc0Qy6coTFLuwlCwIQn/i/g0DVNRPxKkrsYcgpWTqyDRDpZ017XnVcrdWIxHbgdfsAXn/i0cMSWmNkxWBUKpWzs+Qg+unzmpvxIxEGl2rNwzFF8e8TZTLkHt0XJoubr3yZ/Kd0Y3qbKkiFmJgLwZHc/qyWQylddf2uiQnUwyT9kt1MkDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/yESyUHqextMhjf13phnhUwzuU3SOWj8kyeX3a3SAhk=;
 b=oRIHp3YjhFFvsArWEVQeHkM13TGjOoD7Mpw+ga6CjDoJI2rUVm00L8Kn8lLvg+IFETQrh4aLmvHigp5F3rn+Qh33+vMDSGeCqhErY+91vMuDy/Wk/j0UVmlq1wxincstPjjfUKeVisky50lopSql9vALTHuhIio7tH49fjbqHPKVFbhrvcJDTb/z/t2c4ypOoO8R1r3iMyasqpoQfD7ZXlI1Rx0QLQY4D0yZoQpFu53eG6l4jvB603tVU1BGy5INBSJz8EPh7K3rjvItA/0jS20adpG2qhAEmA5mL/JhU/hJ3lgRzssnuGQb4D0wQzxCoUq8lzMZwLkp5IFIIHWxzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SN6PR15MB2336.namprd15.prod.outlook.com (2603:10b6:805:26::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.22; Sat, 5 Jun
 2021 17:55:28 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d886:b658:e2eb:a906]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d886:b658:e2eb:a906%5]) with mapi id 15.20.4195.026; Sat, 5 Jun 2021
 17:55:28 +0000
Subject: Re: [PATCH v4] bpf: core: fix shift-out-of-bounds in ___bpf_prog_run
To:     Kurt Manucredo <fuzzybritches0@gmail.com>,
        <syzbot+bed360704c521841c85d@syzkaller.appspotmail.com>
CC:     <andrii@kernel.org>, <ast@kernel.org>, <bpf@vger.kernel.org>,
        <daniel@iogearbox.net>, <davem@davemloft.net>, <hawk@kernel.org>,
        <john.fastabend@gmail.com>, <kafai@fb.com>, <kpsingh@kernel.org>,
        <kuba@kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <songliubraving@fb.com>,
        <syzkaller-bugs@googlegroups.com>, <nathan@kernel.org>,
        <ndesaulniers@google.com>, <clang-built-linux@googlegroups.com>,
        <linux-kernel-mentees@lists.linuxfoundation.org>,
        <skhan@linuxfoundation.org>, <gregkh@linuxfoundation.org>
References: <000000000000c2987605be907e41@google.com>
 <20210602212726.7-1-fuzzybritches0@gmail.com> <YLhd8BL3HGItbXmx@kroah.com>
 <87609-531187-curtm@phaethon>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <6a392b66-6f26-4532-d25f-6b09770ce366@fb.com>
Date:   Sat, 5 Jun 2021 10:55:25 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
In-Reply-To: <87609-531187-curtm@phaethon>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
X-Originating-IP: [2620:10d:c090:400::5:80b3]
X-ClientProxiedBy: SJ0PR13CA0077.namprd13.prod.outlook.com
 (2603:10b6:a03:2c4::22) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c1::1a79] (2620:10d:c090:400::5:80b3) by SJ0PR13CA0077.namprd13.prod.outlook.com (2603:10b6:a03:2c4::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.10 via Frontend Transport; Sat, 5 Jun 2021 17:55:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3c308d3f-51d7-4cc4-1a39-08d9284b1aa3
X-MS-TrafficTypeDiagnostic: SN6PR15MB2336:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR15MB233634E970F8DEE1A933681CD33A9@SN6PR15MB2336.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uLHoAxorF9+anzhzuSowV2GWbtOGKUvMSrU9dr0QQVEzG2PvaHXxI/jov5AyUo+AJMa86etCj/9dbcbFQh8lewOK5blfp4RsNpRf2pMrEOzLk2PHqMGrXl5iEcEpVFFoWAgv3PY9QNGadzyEULYWqd5c6ZNq3Gd4nMVogDJ6XFPcAEAbrJh1hIwlvb9K1/Pei9PE2iugHBLSNc9kH0QYsmqtvlbtk8Hgl0OAq15TI2QUdfAT6qfaqRZYSaCFzuHbJibQMOlZqkAFdphnhmpc6X5ZOxgqyF12sUuFqLKDDeEPlR0+kYToxiaoVsXtyFZ1CJ47LbqN5XtaLp76zM31f6HOahCJXkM9h2dLjbajMnXbs6GSVQOPNSFRan/agr/YHzBNjynFMc8et0OYMRFdJGShLLwYT/Gxu3NL7v1L5iKgOJrt8aZrqCWc0ngWDT9uJ1cyhoufdoR4raMGO053UvWPWuKS9+KWAkle+l9SJBLhJZsR5LyB3HFbzSe79pslprDUH5BYKpzeJ191U4BrJEpaNnMByZu1t1FYtRU/Pg6Qbj2SVM2XUDfvk44e267QDC3zsuDqIzvWwHdYgg1G717hdwFaqFTbUaB0xHeJ+n7nB/Iv4Jw/D4LTffOKIF3RRo7mdRwCd6MqrgJjkp2S7nPYXWCPlnwMEJP2liGDG9DUoTs0KfGy8dp9Uz8pUGriHIxpWQmw+YejJTlXZJ75aAjkc9HKLf5Spo21yhHhITUKqWzcX5vegMEWdSfG4dULhwz0zLvwLbdUZTmBDxF1zDpawbfsSmA2KrJMfHClQhNsAn61Dbw1Jxb2+RQJ/5WBumQu5Kzw02VjTQzdXEIl5iSFxzlpFyfb5803my3NvXs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(366004)(39860400002)(376002)(346002)(966005)(478600001)(38100700002)(36756003)(316002)(8676002)(7416002)(186003)(4326008)(86362001)(53546011)(8936002)(2906002)(2616005)(31696002)(83380400001)(66556008)(66946007)(66476007)(52116002)(5660300002)(16526019)(6486002)(31686004)(101420200003)(99710200001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?c0F3akZRaSszZUhyUkU1MjVzaEVRMXMxNFJvakZZODI3OXhRMlBjQndiRjFt?=
 =?utf-8?B?WmRPWFhJbHRJSzBpTmQrTk9PeTkzZU05NVZCdEg5MnFZN1NjbkdCeXFDZlNX?=
 =?utf-8?B?d2dBRFlLeE5NcWVtN3dpU0hhN0M2cDhBd0w5ZG9DTEkwOW5mNzhJbTZ1QWxV?=
 =?utf-8?B?OGJHTkNLT1k2ekFGNzkxay80Vkk4ZDhqNXlmZXJ3VWl6dlhQMGU3Z0hoRUhB?=
 =?utf-8?B?emhKUTRjRThVay9TV0Z4cUQ3MUZnUStvZkljVStzbFBXSWVEc0VtRTdnaTNQ?=
 =?utf-8?B?QnZxdzdRQ3JQY3Q1UTRDMk5pSUh4N0FoS3NodmdHeXlURDlHRVkrUGRISGZw?=
 =?utf-8?B?Y1pXN0FwTEtFNmcxR2c1d2Y2UnZneUFENUovNi9TMTJCZWJUWUJnQ1F5cDQx?=
 =?utf-8?B?Q3hvZk85bU5nNTRMYkpDN1RHa3FBKzNJYlZtc09VUmZnOXpSUHVqVjJDR09X?=
 =?utf-8?B?WkFTYWlPdHJZODhyTVRuaGljbm9JWS9EbVpEbFN3c0R4RGp4L2EwVGJENm8r?=
 =?utf-8?B?SzQ1WXgrRTlJRkZvY3RuMW5IOXo0U01BL3RCYVh0YVluUFV2bTl5d3Vza1Vu?=
 =?utf-8?B?WVM4RTZmaVB5UXpkSTlPVzFhKy9aZ1ZMdXFLQjB0ZUYwT2poemlMMThIMHUw?=
 =?utf-8?B?T0ZlQWlVQ0t1UzRxRXNVN0dKMUdmS2hrUkxPYWVMQk01OWxQNE1MUXFMS0ZM?=
 =?utf-8?B?aU1WSnNhaTBYMnBqT09Nc1lTY2ZsY28vU2hadUVWZmdEOVdPNkhYT3NSNkQ4?=
 =?utf-8?B?d2lMSXliNmtGVHNUb3Z0Z2NObGlmNXh5V1A0ZW9lK1N0NjlucDU1aVVHR3oy?=
 =?utf-8?B?b3dtQnJMV1Zzc0h6aHByTCtqM3FmQWN5MTMvTTM5bDV6YUVycjB0aC9vdDdN?=
 =?utf-8?B?Vzh1ME1Uc2s0cE9NaVJyMTB4VGV6ckVwaVpjbW9tdEs5ZTFBTEtqWGszT1dw?=
 =?utf-8?B?Rmp6ZHhnUWI3VE5jL0YrU3ROZmo3cStrU0l2a25QMEFlUTllYzhhcDRGcU5n?=
 =?utf-8?B?dDdmMEdVZGZQWDJpcE1OeFZmSk5QYlZlQXlEOWI5V0lNMk95QXVBQ2xZZXN6?=
 =?utf-8?B?eUVVUkdTcmJscVRHZTVQYU8yY2NTaTV0WllDQndkR1U1aWNIdXc2bDdUbDk2?=
 =?utf-8?B?ODBCK2NJVGo2RUpXbUhxUEZZS2l3RVRDYmZsaElvN1JRcHF6RFBNN0ViYklj?=
 =?utf-8?B?V3duTDgwVVZaTEdBeHVzMUptSTkrT2laVHhLZEFrL3VodVA5ZXBEdU94WTlp?=
 =?utf-8?B?MFVDU21idmF4VlBqQktUeVFiTjlIL2pBdXpVbGhHRWFRMHBSS0E2TnRoYTc0?=
 =?utf-8?B?QWs0dXBQK2ZKQ25xOVZNNHN3Y3VHOWFLcmQxamhGR1NHWVpTQlNVVWxqTjY0?=
 =?utf-8?B?eWVCaWoyak9XeHdrbFpjdm9qV3Q0VWhJMlNTbTl0ZmNrQWtUVjVDbnppNXEx?=
 =?utf-8?B?cFVjTnZCalZESTdRZ25LVVcvQXFKNkxGNk5qQmV5aC9HTGkvYXN1YU40bEQ1?=
 =?utf-8?B?cm1hZkNNTWF6VndOOU1vUDFYWGNIeW9XVE5UZzVzY0gyQzJmYjZpUURXSFZy?=
 =?utf-8?B?L0tZY0Fka0M5cXlseWl3eUdoc1VKRTZOZHBSalN4SU1IdTdCR3IzdmIvSDdI?=
 =?utf-8?B?VnNyckxhQ1lka0licm80QmxZNkRPSnU3SHFPeExRWmtQNHBRTWloQ29MNWRO?=
 =?utf-8?B?TEtLY1VhRkRUZitjcStHV1o4MzAvUzFyeHhVbzdYb0pSVjRxb0hxYWYwOGMy?=
 =?utf-8?B?WGJRbjN5bk5RWkRXeVQ4VjFic1JyU3pNZVVwQWMwdi9lZi9qVHJOb2Ezd3Fh?=
 =?utf-8?Q?IFOAii9v5A35ODIiO+C988HKvhD4daVakCzEU=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c308d3f-51d7-4cc4-1a39-08d9284b1aa3
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2021 17:55:28.5839
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y8FjyzWEki3XuoRbLmQqTGZD3AT895mzmST/jHKvMPddvsx0Aq/VJL6H1clHNxYy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR15MB2336
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: ZT7ZsTvVozpnJ51ooHPU1tr5PAuuPRNX
X-Proofpoint-GUID: ZT7ZsTvVozpnJ51ooHPU1tr5PAuuPRNX
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 1 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-05_11:2021-06-04,2021-06-05 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0 spamscore=0
 lowpriorityscore=0 bulkscore=0 clxscore=1011 impostorscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 phishscore=0 priorityscore=1501
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106050131
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/5/21 8:01 AM, Kurt Manucredo wrote:
> Syzbot detects a shift-out-of-bounds in ___bpf_prog_run()
> kernel/bpf/core.c:1414:2.

This is not enough. We need more information on why this happens
so we can judge whether the patch indeed fixed the issue.

> 
> I propose: In adjust_scalar_min_max_vals() move boundary check up to avoid
> missing them and return with error when detected.
> 
> Reported-and-tested-by: syzbot+bed360704c521841c85d@syzkaller.appspotmail.com
> Signed-off-by: Kurt Manucredo <fuzzybritches0@gmail.com>
> ---
> 
> https://syzkaller.appspot.com/bug?id=edb51be4c9a320186328893287bb30d5eed09231
> 
> Changelog:
> ----------
> v4 - Fix shift-out-of-bounds in adjust_scalar_min_max_vals.
>       Fix commit message.
> v3 - Make it clearer what the fix is for.
> v2 - Fix shift-out-of-bounds in ___bpf_prog_run() by adding boundary
>       check in check_alu_op() in verifier.c.
> v1 - Fix shift-out-of-bounds in ___bpf_prog_run() by adding boundary
>       check in ___bpf_prog_run().
> 
> thanks
> 
> kind regards
> 
> Kurt
> 
>   kernel/bpf/verifier.c | 30 +++++++++---------------------
>   1 file changed, 9 insertions(+), 21 deletions(-)
> 
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 94ba5163d4c5..ed0eecf20de5 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -7510,6 +7510,15 @@ static int adjust_scalar_min_max_vals(struct bpf_verifier_env *env,
>   	u32_min_val = src_reg.u32_min_value;
>   	u32_max_val = src_reg.u32_max_value;
>   
> +	if ((opcode == BPF_LSH || opcode == BPF_RSH || opcode == BPF_ARSH) &&
> +			umax_val >= insn_bitness) {
> +		/* Shifts greater than 31 or 63 are undefined.
> +		 * This includes shifts by a negative number.
> +		 */
> +		verbose(env, "invalid shift %lld\n", umax_val);
> +		return -EINVAL;
> +	}

I think your fix is good. I would like to move after
the following code though:

         if (!src_known &&
             opcode != BPF_ADD && opcode != BPF_SUB && opcode != BPF_AND) {
                 __mark_reg_unknown(env, dst_reg);
                 return 0;
         }

> +
>   	if (alu32) {
>   		src_known = tnum_subreg_is_const(src_reg.var_off);
>   		if ((src_known &&
> @@ -7592,39 +7601,18 @@ static int adjust_scalar_min_max_vals(struct bpf_verifier_env *env,
>   		scalar_min_max_xor(dst_reg, &src_reg);
>   		break;
>   	case BPF_LSH:
> -		if (umax_val >= insn_bitness) {
> -			/* Shifts greater than 31 or 63 are undefined.
> -			 * This includes shifts by a negative number.
> -			 */
> -			mark_reg_unknown(env, regs, insn->dst_reg);
> -			break;
> -		}

I think this is what happens. For the above case, we simply
marks the dst reg as unknown and didn't fail verification.
So later on at runtime, the shift optimization will have wrong
shift value (> 31/64). Please correct me if this is not right
analysis. As I mentioned in the early please write detailed
analysis in commit log.

Please also add a test at tools/testing/selftests/bpf/verifier/.


>   		if (alu32)
>   			scalar32_min_max_lsh(dst_reg, &src_reg);
>   		else
>   			scalar_min_max_lsh(dst_reg, &src_reg);
>   		break;
>   	case BPF_RSH:
> -		if (umax_val >= insn_bitness) {
> -			/* Shifts greater than 31 or 63 are undefined.
> -			 * This includes shifts by a negative number.
> -			 */
> -			mark_reg_unknown(env, regs, insn->dst_reg);
> -			break;
> -		}
>   		if (alu32)
>   			scalar32_min_max_rsh(dst_reg, &src_reg);
>   		else
>   			scalar_min_max_rsh(dst_reg, &src_reg);
>   		break;
>   	case BPF_ARSH:
> -		if (umax_val >= insn_bitness) {
> -			/* Shifts greater than 31 or 63 are undefined.
> -			 * This includes shifts by a negative number.
> -			 */
> -			mark_reg_unknown(env, regs, insn->dst_reg);
> -			break;
> -		}
>   		if (alu32)
>   			scalar32_min_max_arsh(dst_reg, &src_reg);
>   		else
> 
