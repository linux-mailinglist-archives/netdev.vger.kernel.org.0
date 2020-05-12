Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58ED11CFAAD
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 18:29:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726558AbgELQ3a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 12:29:30 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:28056 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725851AbgELQ3a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 12:29:30 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04CGScNi013216;
        Tue, 12 May 2020 09:29:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=BJt3+OyRLRRv3nFxSC9BFQxee39ACuZiymzlA5iPtz4=;
 b=aUqgY+2Yx98Iph0cfno4Uj9UL3njj0yWxlx5xqYC2402sgjFc/Frw3ePGbEy6pcMHPN9
 qPHTylZPNeNfEnHMiqWOJXthDByfrmYmMk+AIqqRSAgK/XZHL46H7rYnB3G7Ru2SbHrA
 4ibmFBeLW6ehGrtvl/b/dZjVymhrb+dz5IM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30xcgsdea3-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 12 May 2020 09:29:16 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 12 May 2020 09:29:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=euT/gkZQQVBNWLHD9Ror1MOtKi5SWJCTiJ03nUd+ajnxsF5val8xexksusRadt6A6cYw5r+haQOiByzECfosu7Urdb0uh72pfmShpy51x+y3z3pyCqUrBYTIgNINaL4PNKvMkGwEEj2eoL/NV7MAzZ7e4YsdQfg+VtjOvWu4+vSG1aC7XEwHIrmqWLQ+SWDuPv2JDsHHnowabNHL7KrGyATAN1vH3P7ZZYnLIK+wEzPVBGQup2K4Fid6Bxdo4N3Ll2Kn5vcqMnLLl108CcjoC+qMBIxtcdcsd+zP1ToVlQhk00cdzVdblUnxr1dcft9PKXI8NPyNZnJhWFEvYf79sA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BJt3+OyRLRRv3nFxSC9BFQxee39ACuZiymzlA5iPtz4=;
 b=gbe2cIMhjgwQAcHIspArc8vAx0bz0wGQS07aG1RAzLx1Cdn4BMAU5Ej2+AWSylyL7VMwq6lb1GJoqbqhiKliCWoueIaxEx+ZinlAmZyaZxyjdIIo8yLwxgUrrWnfymxozpKT9uTmz+vYvetQaRnNlHDpqYRhUilEHQ3Bukyig3R48gNuUcC833Pe0MVB3Ruxd5QZ+pRpqyLNhc6PhS2PKXVKkoPQlqOosQ1nmrQwpQt6qA10eYOLdCZ5QYzbJXqR3a2jBRv5PbiKorb2jZ78ADK+wLEDDwuXhN8A8uNQaHA9iZRxhqIZFHVNhEnFPRNfJzqsuNKd/A3BlWmKr/oA7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BJt3+OyRLRRv3nFxSC9BFQxee39ACuZiymzlA5iPtz4=;
 b=c6SfY+6u5n1CWZ+EqWXLdoApH/6g8C3FyzT6ir7YNMnfosruYJr1RjjUMN92xxzngFK6OV6p0cgL7kCJN7I/1hgG3TLh3rAYfAHGDWCLyvcsiGrVT0YFfjbqkk1rHSjozEyGYeLIv7OwResvLeRqKjiVbgg2wt5iHfgwYewP1kE=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2245.namprd15.prod.outlook.com (2603:10b6:a02:89::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.34; Tue, 12 May
 2020 16:29:08 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301%7]) with mapi id 15.20.2979.033; Tue, 12 May 2020
 16:29:08 +0000
Subject: Re: [PATCH bpf-next v4 02/21] bpf: allow loading of a bpf_iter
 program
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
References: <20200509175859.2474608-1-yhs@fb.com>
 <20200509175900.2474947-1-yhs@fb.com>
 <20200510004139.tjlll6wqq7zevb73@ast-mbp>
 <c128a30f-af40-99c9-706e-4afe268ed38f@fb.com>
 <20200512162524.4yq4i3or4wtwl43x@ast-mbp>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <754bce5b-bb4f-69f0-f938-2de3fd4d56ef@fb.com>
Date:   Tue, 12 May 2020 09:29:05 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
In-Reply-To: <20200512162524.4yq4i3or4wtwl43x@ast-mbp>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR21CA0030.namprd21.prod.outlook.com
 (2603:10b6:a03:114::40) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from macbook-pro-52.local.dhcp.thefacebook.com (2620:10d:c090:400::5:d0f0) by BYAPR21CA0030.namprd21.prod.outlook.com (2603:10b6:a03:114::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.2 via Frontend Transport; Tue, 12 May 2020 16:29:07 +0000
X-Originating-IP: [2620:10d:c090:400::5:d0f0]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e689f652-1866-4380-78b4-08d7f6919809
X-MS-TrafficTypeDiagnostic: BYAPR15MB2245:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2245480D523A376490E77BC1D3BE0@BYAPR15MB2245.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:1303;
X-Forefront-PRVS: 0401647B7F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v7p63II7Q3TXxTNQMOSAN9WTeqk1Wqyzku+yKoCRdwXVoCkt3txNgniM1SqUzhnB6U0CrEKYMIWJcjd7ut1vs/dFBFvdlDH0d4FhZSnHHIR+iV2KAJphZFzw9rHqLPdHDeH0dHk0olLtV9imWybCFHpxtwdEogvXSUyaDDupe+barHrCnYgbag1nblbHLt6b0UaaaGkG3tbqwTb7GmZ7EDXeSK1w/qqfLNlnvZe1G+uEU650bqysE4+8wvYjyQaF27MXo3ZarMdJzufx+pG4O7EoAVIbGFDWwM8izy9fGBWphOTt72tf6VHKJHj/ohM+9tSV2xRxzRPMzhXEZtpUJviJOYrR5c973fnVUPNeh4QZ+uJg4vwPlpYiUmBmmMKuBzvTxKO1MmIgSKjLOl9UgRPlKxe9yBdVArquj2rj5OJ/NMfDc1a4FhYUtybI2/STfGcZurPXDCgq5zVRc8jlwZRxIfRo6JMoKk1J7kC9Cn3f8+OCkS6wVFMA7lNBUCVC3GzwcTv/8FLjmG56BtEj3U21a34AwZKY8e+F9qW+o/Sz4lw2193zKx7MBJN7aDyK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(376002)(346002)(366004)(39860400002)(396003)(136003)(33430700001)(31696002)(66556008)(8676002)(52116002)(66946007)(66476007)(16526019)(86362001)(6916009)(4326008)(36756003)(186003)(6486002)(53546011)(316002)(478600001)(6506007)(33440700001)(2616005)(2906002)(31686004)(54906003)(8936002)(6512007)(5660300002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: Mcpag65w+Otkcp5WONxxoC4Mb0yPHgXtX8Wi8JOKJAVIUKPy4ld/X4VK1NnUpSUwtdiHmHpW7rKRKtgzlNZYX4tSqOj5yh9HmUHWD6ni8JrKP033A/x1UKTbFJnk03G3csMKPqwzYX0BV02POy41NJVc3+DR8va5nHTxuWm0vdP9J4Dz3otsQO+QnxGFgIZ3jzBopajjz7nV8+pyZwJYku2BusRofUr+AR2+BUfmpAgFpnnBc386D+R92VSgZSHcTOXOYOyYzs3JQ+LQkMfIHxdv/+hBAuAV2C9MkWwSgiD6HE60sl0ZQM9mHrqMnVaH556nj8AYWoRnpZae3RJqmJAx7TI/CJ9MS1R4EWY/oBVfx5hAwgxIBj6n8PtjPTpZtGXqdiH2zMqc0V9PLAvKOuFSYBB58r96RO1n4zJPWps+buFnDF7+Vwp96CpmAobM7Dd5Oh9HE9KcgH4xduJeZLIkJ8c+QtTyKUyJwIoErpTkz+rv1IjKp7eIxmiLx0LBXrh1LSTwonUYqeVUA9ooTQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: e689f652-1866-4380-78b4-08d7f6919809
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2020 16:29:07.9761
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k8fHz+dniPI8sXI5RZ8kwwP+5S5RBun3zILRYiBlEmQjOaM/K5Y/0bDunYuIYel8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2245
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-12_05:2020-05-11,2020-05-12 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 spamscore=0 impostorscore=0 suspectscore=0 adultscore=0 phishscore=0
 bulkscore=0 clxscore=1015 malwarescore=0 mlxlogscore=999
 priorityscore=1501 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2005120126
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/12/20 9:25 AM, Alexei Starovoitov wrote:
> On Tue, May 12, 2020 at 08:41:19AM -0700, Yonghong Song wrote:
>>
>>
>> On 5/9/20 5:41 PM, Alexei Starovoitov wrote:
>>> On Sat, May 09, 2020 at 10:59:00AM -0700, Yonghong Song wrote:
>>>> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
>>>> index 70ad009577f8..d725ff7d11db 100644
>>>> --- a/kernel/bpf/verifier.c
>>>> +++ b/kernel/bpf/verifier.c
>>>> @@ -7101,6 +7101,10 @@ static int check_return_code(struct bpf_verifier_env *env)
>>>>    			return 0;
>>>>    		range = tnum_const(0);
>>>>    		break;
>>>> +	case BPF_PROG_TYPE_TRACING:
>>>> +		if (env->prog->expected_attach_type != BPF_TRACE_ITER)
>>>> +			return 0;
>>>> +		break;
>>>
>>> Not related to this set, but I just noticed that I managed to forget to
>>> add this check for fentry/fexit/freplace.
>>> While it's not too late let's enforce return 0 for them ?
>>> Could you follow up with a patch for bpf tree?
>>
>> Just want to double check. In selftests, we have
>>
>> SEC("fentry/__set_task_comm")
>> int BPF_PROG(prog4, struct task_struct *tsk, const char *buf, bool exec)
>> {
>>          return !tsk;
>> }
>>
>> SEC("fexit/__set_task_comm")
>> int BPF_PROG(prog5, struct task_struct *tsk, const char *buf, bool exec)
>> {
>>          return !tsk;
>> }
>>
>> fentry/fexit may returrn 1. What is the intention here? Does this mean
>> we should allow [0, 1] instead of [0, 0]?
> 
> Argh. I missed that bit when commit ac065870d9282 tweaked the return
> value. For fentry/exit the return value is ignored by trampoline.
> imo it's misleading to users and should be rejected by the verifier.
> so [0,0] for fentry/fexit

Sounds good. Will craft patch to enforce fentry/fexit with [0,0] then.
Thanks!

> 
>> For freplace, we have
>>
>> __u64 test_get_skb_len = 0;
>> SEC("freplace/get_skb_len")
>> int new_get_skb_len(struct __sk_buff *skb)
>> {
>>          int len = skb->len;
>>
>>          if (len != 74)
>>                  return 0;
>>          test_get_skb_len = 1;
>>          return 74; /* original get_skb_len() returns skb->len */
>> }
>>
>> That means freplace may return arbitrary values depending on what
>> to replace?
> 
> yes. freplace and fmod_ret can return anything.
> 
