Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A74382626B9
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 07:19:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725974AbgIIFTu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 01:19:50 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:12390 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725772AbgIIFTp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 01:19:45 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0895IbU4015553;
        Tue, 8 Sep 2020 22:19:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=w3cp035Oil/+9V1xPArCE/jnPAa46F7BxZBzPpTuzQg=;
 b=Pg2aAv4jJomYxxtNrddG3VjbtNLXZ/ajDqKIDUi5uGoz5/7UIdW84ZY98hOq9B4pzGn3
 VL2P7BSQAfqgtiVXJGJuXfUNNo7uCnDsKNVJCPNAztHct84AZQIG74dsmUfk8ZSC3OlE
 qEntYvkOr5scpqImYGcGqdUzdLlXmn9G3M4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 33ctxn5ecc-10
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 08 Sep 2020 22:19:30 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 8 Sep 2020 22:19:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HM+13X0g8SOkBEfV2cD2FWw+jLv6XjRiPQ25OxM9MBRMeULqKX0e2E17J4zcfVI5TPriTFW/RXumVUrRcaaEB1bjJWHI+F+RmHHjU0xffkSWMkBB212omXkJNWLObLLBPVoQihK0JiMCZERSQ8TdrdCMhj5Dfk+jOBAiIpwiePlMPxewsFD8QuRBdy8EDe/2Sr6twB+f3ymLE0PD9DOAJpdpiOvhnuJIf7qiwUgBc+DP5aiWXLgxuMlPQm7VwZSzGRmYKKAs/t8BYz5tkap7uh+hnOSINQUnr/3LXFFn0qs0ya9YzyU9nOfVuT/CbdXO3oI1we8+g297gvw5uKgnUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w3cp035Oil/+9V1xPArCE/jnPAa46F7BxZBzPpTuzQg=;
 b=JxWuJFAgD7aQCDECJOR1HMcZovu69y4OZ/wSOvIblN75vDzWSEj2LY0AZXi2ZHZh/F8V/8k1Nph5enOIVVn/3K6aofBWbn0bR3ne7hL7yUQ1nFxjXVSnibpCn9g9KvNGbXbJ9bWup+ZQ50LeuuYKaYP3/pLRyPEz/91F/R55Ei88CTVHLiotCf2+C4P9bXJnsUMk0Ju2K4BUmnduUJBOTl4P7ckN5jGwuU50qwcgc/pu/8Fk36RT8dqqlT1TOxkEKP5WxUK9rGr5PtuOVCr2/9fjm6SGvZuV2atTsJhpnlSTjm8ZSqwqHvb1SJjIVbvCucSq7l1KIn7yHicKrgfb3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w3cp035Oil/+9V1xPArCE/jnPAa46F7BxZBzPpTuzQg=;
 b=cfZvhYITGrm0NQbQdBqTLXlfwNxUEu4r+XsLrNzJh22TcdJGeorMbQs2GvnazGEbOCSQ2fcG8bR+idXp87qFlzWaNsIPv7EuMzoIvFvbud8hqT9WQS+oYv9B7gURbJf7MwcKzUF6vLNASEuksqSvAXBBRLknGq1MeiCInU72hZw=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB3464.namprd15.prod.outlook.com (2603:10b6:a03:10a::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.15; Wed, 9 Sep
 2020 05:19:24 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80%7]) with mapi id 15.20.3348.019; Wed, 9 Sep 2020
 05:19:24 +0000
Subject: Re: [PATCH bpf-next] selftests/bpf: fix test_sysctl_loop{1,2} failure
 due to clang change
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
References: <20200909031227.963161-1-yhs@fb.com>
 <CAADnVQKgZyAMgChwtnHPY2VTgNQN_s+dn2rwFqySiMq_c+C5iw@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <32cd16a4-35a8-d2aa-1c0c-dae02bf2b434@fb.com>
Date:   Tue, 8 Sep 2020 22:19:23 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
In-Reply-To: <CAADnVQKgZyAMgChwtnHPY2VTgNQN_s+dn2rwFqySiMq_c+C5iw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR03CA0018.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::28) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c1::10a4] (2620:10d:c090:400::5:ca4d) by BY5PR03CA0018.namprd03.prod.outlook.com (2603:10b6:a03:1e0::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Wed, 9 Sep 2020 05:19:24 +0000
X-Originating-IP: [2620:10d:c090:400::5:ca4d]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3dc4c445-38be-4d71-fe11-08d8547fea7d
X-MS-TrafficTypeDiagnostic: BYAPR15MB3464:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB34646D208E9962F2B6B68161D3260@BYAPR15MB3464.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:2582;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GPAPxnFVdW5vAo6uHEWxHnnlCcBu+IhWEl7K+qRH1xSefogdoFIyZc5ek7eVa2sYKQCbfLH3yIPOB4MsHE20fj/ViwH0CdE7Tk3QVz1b3CDH+ynivNYJ8Qzu8xO8eXcpI7CtTW9j53njf6kLvZWSbOMlINH/Yfjt23o6x75uFwZcg/tTr+xGiaayuPmzEWQy1SCFpg9WSJ8JlQLt+JjrVQ7ZZ6N/d2ttqa6DcDRPYmfeMD0oOkJBsn+CEu/KsMNKsgitzjRcNAO4a6n5incABiSg0qY2Ze0DYFAshqyDTmz7KW7ZbgYIUbRBNf30f1C/o2+HdVFEgM5YIE6lc+fMz4Uue6CIifb+83vpwKCv0yo9S3OzodtDx+ZJYc+TrYqElqsmytx0u65jsne7ewKJDViB2PtpBH3AuykjIw9o22jHLt8ApCuj2GEedsJDVHCDnNbS3CWleSFx8YnIZi3eTQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(396003)(39860400002)(366004)(376002)(66946007)(66556008)(66476007)(53546011)(6486002)(36756003)(8936002)(83380400001)(316002)(2616005)(8676002)(31686004)(31696002)(52116002)(16526019)(86362001)(4326008)(186003)(478600001)(2906002)(6916009)(54906003)(5660300002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: F75K5dkirxd5Q+ycFibVi+8luu1xk9Xc9kenAXsmM74SjBIDXbUbQLPxTpyhn7fjqWh7e3J2qyCwE+toFjo6G71qm6061Zz91aEx2rGrkWrb9OeX4Vh7pE9fsvz7R99lXqhyGG+RmWEdUj01Kqew8yFJYNLMSObOVnDmbzqD2iOeKve1RKQe67GPQ3GjU33D9BMILMVvE46UaDVIKZ0b9Uh475DpPJMuBfaViZnTvc0PldV9ZMzOjOYf9H0pZPheADYqHP2n7yfBLLAaVjfz5/CG3QCyvyQyvo2RkRrbF/xP8beUpnqMMXBt7nPn2oqn7dqZpS0EQlQb2gzTPZ9V/zKbL5mjz+F0YBancmlNQIFa0rvKTtGXNetxLibHLhQa1DDkhwMB8BBaONLfVYYnHmzLUQxMusXuwiPS8W+/fto7feM/SdLzvR3nBEs4PRa/OTVntYE7X4nAnakuRccl8brIOyKIhPsjq03BsmqVMSYNNUoG3AhreLRZdhHIDqgQIdXhBIb2DAtflEoa8uUpjZWOBsgL/SUIXx8RgdrjwX89f5ZSv1qeA9ZWeS/nSTsvUMlXEpJ5rOZnvtqJnvuXn7q5AZ3YA22dzH6KyGdLrD7si8/MEhGmqJo40IzaGwGbucI9FBhVV05wYGBskdoh3oxOVkmvrRNfoG++T+WVZto=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3dc4c445-38be-4d71-fe11-08d8547fea7d
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2020 05:19:24.6749
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: efrCkK34k+5OlHTYFX+E3TxsVf0ChhIMmBRxD4QmFl6uaQoKj3ZSyQL21B1T9FBK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3464
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-09_03:2020-09-08,2020-09-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 impostorscore=0 lowpriorityscore=0 malwarescore=0 phishscore=0
 clxscore=1015 mlxscore=0 spamscore=0 suspectscore=0 bulkscore=0
 priorityscore=1501 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2009090048
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/8/20 9:04 PM, Alexei Starovoitov wrote:
> On Tue, Sep 8, 2020 at 8:12 PM Yonghong Song <yhs@fb.com> wrote:
>> diff --git a/tools/testing/selftests/bpf/progs/test_sysctl_loop2.c b/tools/testing/selftests/bpf/progs/test_sysctl_loop2.c
>> index b2e6f9b0894d..3c292c087395 100644
>> --- a/tools/testing/selftests/bpf/progs/test_sysctl_loop2.c
>> +++ b/tools/testing/selftests/bpf/progs/test_sysctl_loop2.c
>> @@ -18,9 +18,9 @@
>>   #define MAX_ULONG_STR_LEN 7
>>   #define MAX_VALUE_STR_LEN (TCP_MEM_LOOPS * MAX_ULONG_STR_LEN)
>>
>> +const char tcp_mem_name[] = "net/ipv4/tcp_mem/very_very_very_very_long_pointless_string_to_stress_byte_loop";
>>   static __attribute__((noinline)) int is_tcp_mem(struct bpf_sysctl *ctx)
>>   {
>> -       volatile char tcp_mem_name[] = "net/ipv4/tcp_mem/very_very_very_very_long_pointless_string_to_stress_byte_loop";
> 
> It fixes the issue with new llvm, but breaks slightly older llvm:

Let me take a look.

>   ./test_progs -n 7/21
> libbpf: load bpf program failed: Permission denied
> libbpf: -- BEGIN DUMP LOG ---
> libbpf:
> invalid stack off=0 size=1
> verification time 6975 usec
> stack depth 160+64
> processed 889 insns (limit 1000000) max_states_per_insn 4 total_states
> 14 peak_states 14 mark_read 10
> 
> libbpf: -- END LOG --
> libbpf: failed to load program 'sysctl_tcp_mem'
> libbpf: failed to load object 'test_sysctl_loop2.o'
> test_bpf_verif_scale:FAIL:114
> #7/21 test_sysctl_loop2.o:FAIL
> 
> clang --version
> clang version 12.0.0 (https://github.com/llvm/llvm-project.git
> 6f3511a01a5227358a334803c264cfce4175ca5d)
> 
