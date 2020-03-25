Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8A3B193338
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 23:00:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727401AbgCYWAz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 18:00:55 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:13364 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727351AbgCYWAy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 18:00:54 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02PM0Z8t026053;
        Wed, 25 Mar 2020 15:00:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=j9lP7biWVcpDHd/m17NQAskZyLPn0KFzfWClGmaJ9lY=;
 b=mmeAqU1s9lq8wj83iWch/lrjlHh9XqJ0PkJRJMCYVqIMLM375NFynKZjvn8OOwhkbiiS
 y4nFm7EPk2OUtSkC/CO2lWiama9wtufmGBCmWsDUMLBPCzCmbGhR52cgyJM2vEfNSZ2Q
 Qx5lQBuu3wHFHdOdQZwhNsbZ9Zgli0DJpNo= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2ywgem6auy-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 25 Mar 2020 15:00:38 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 25 Mar 2020 15:00:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QXmOJFRHEPsJ/a2DFjXuWPWuZrZDjxzTuwR4cPXnAnGiVq9k9vDWTvWM9hn68vjugpqKhHYZkAb9jHguigrSnugMNgXAGLwUjpw/05qcERLypTbjAA7nL5fnzmn3+OkUZaHLxNFzliBne6gfUXRdfcYqLyE3+AVErmEx04H+rpfH7HXY945U5RwbZX3kYL6EGb+BNjuwArf3inAOptfScugsdJeTENV6bz85TzTbCCCfjlQYUfou4CRIN+XdtNvb6Et8SqlS6Vosz06Ly9FFwsuST2+mVxEDm8Sks0mA2RQg1AHUkUnco0KzWZsGzN3a2KAxFjSVj8cEQF1Wqy1Ccg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j9lP7biWVcpDHd/m17NQAskZyLPn0KFzfWClGmaJ9lY=;
 b=PRvM7MIwshFjiRDRzGOu1o7CKQIpq2FIagOucRFo0yUWS6YusapYYTyp1A5+pfWowKI+p4SyX2lO0ZMS03iE2gObCAu+3wns5gaajwLecke9qE8lCSqScAMWl+4799O6JQJ8uscu8xY9tIDyoacGdnRMHP5Y2cjd6FsfyO8Ia0iE+6gXegLiAgJCnKNYILpxXv+XZWJCIUsYmgCKknzHZOvoBiReqVvValIH2InKkkLYOaZl1oSso1Fq0Hu7GAHsaXm04LfDGqqlS7KE3MlzeoykRCsEioGAUeyth+A1NaQPaJlQkBsZwWQ/bAiDr7TAlMjswEVwjedkI75rbnb+yQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j9lP7biWVcpDHd/m17NQAskZyLPn0KFzfWClGmaJ9lY=;
 b=d01WXsRzU3m0fNKePDnEJWQDvCXzcu/izICsRXPlPWUV4ViHofnIgUMIbynYa8YLPtLARk/7xkgA2JGv5JKCzGHSfuD2s6LqbUD+8zkISE25QIeHjmMR2FfOuqNdlNCe23Eyy5WC7zpowQ4w9cW/jACHjAbX31TkWZMGM4ABDxg=
Received: from MW3PR15MB3883.namprd15.prod.outlook.com (2603:10b6:303:51::22)
 by MW3PR15MB4057.namprd15.prod.outlook.com (2603:10b6:303:47::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.20; Wed, 25 Mar
 2020 22:00:26 +0000
Received: from MW3PR15MB3883.namprd15.prod.outlook.com
 ([fe80::a49b:8546:912f:dd98]) by MW3PR15MB3883.namprd15.prod.outlook.com
 ([fe80::a49b:8546:912f:dd98%5]) with mapi id 15.20.2835.023; Wed, 25 Mar 2020
 22:00:26 +0000
Subject: Re: [PATCHv2 bpf-next 5/5] selftests: bpf: add test for sk_assign
To:     Joe Stringer <joe@wand.net.nz>
CC:     bpf <bpf@vger.kernel.org>, Lorenz Bauer <lmb@cloudflare.com>,
        netdev <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>
References: <20200325055745.10710-1-joe@wand.net.nz>
 <20200325055745.10710-6-joe@wand.net.nz>
 <82e8d147-b334-3d29-0312-7b087ac908f3@fb.com>
 <CAOftzPiJHOW7BnCmc1MDm-TOwqYYK6V2VHhsiYVd6qZu4jH_+Q@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <6d92317a-5274-5718-c78e-fb7b309cdee7@fb.com>
Date:   Wed, 25 Mar 2020 15:00:14 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.6.0
In-Reply-To: <CAOftzPiJHOW7BnCmc1MDm-TOwqYYK6V2VHhsiYVd6qZu4jH_+Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR1401CA0017.namprd14.prod.outlook.com
 (2603:10b6:301:4b::27) To MW3PR15MB3883.namprd15.prod.outlook.com
 (2603:10b6:303:51::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from MacBook-Pro-52.local (2620:10d:c090:400::5:8424) by MWHPR1401CA0017.namprd14.prod.outlook.com (2603:10b6:301:4b::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.19 via Frontend Transport; Wed, 25 Mar 2020 22:00:25 +0000
X-Originating-IP: [2620:10d:c090:400::5:8424]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1f5d02e1-0c03-40bf-5049-08d7d107eccd
X-MS-TrafficTypeDiagnostic: MW3PR15MB4057:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MW3PR15MB4057DA61876CD6408DA6B873D3CE0@MW3PR15MB4057.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:2150;
X-Forefront-PRVS: 0353563E2B
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(396003)(136003)(376002)(366004)(346002)(39860400002)(6666004)(36756003)(86362001)(2906002)(5660300002)(478600001)(31686004)(2616005)(31696002)(52116002)(186003)(16526019)(81156014)(6506007)(316002)(81166006)(6916009)(8936002)(8676002)(66946007)(6512007)(66476007)(66556008)(6486002)(53546011)(54906003)(4326008);DIR:OUT;SFP:1102;SCL:1;SRVR:MW3PR15MB4057;H:MW3PR15MB3883.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k3bM0C95ev3jTjB8Bn1tKKokznBYoVcmuEiqoYiCHzyJWiomZWnZ0SLKWfqfsHEAOYfaXpUVOAS2TeB7LJ3jx5ZXUaxp3S1CJw4aNyPXnJ17OFmEoItk4nDqEv3m1zWbQPsHM9gCQnpvbeevEF8UtKG7V4JltQG/wEagmhcA4vsXULDVsnhuwo2EnX+ul2/0TKT3dn6wLeMKMKmqf8uDorqAafH1JZ1eLKRxShk5bP24uZB598Fbv4DbrYW7DoAq/Hz3J66okEH7jo3cPW2ZpLZ4MRsUaAVcaCAJOL8gsPPzKUWuk74arcHkocmLGTHp7ZFAW50thYk1jV3w+o1kqOY/wZ+EDtLGtNAioSEwh3m3T/xT6lpH3IM5TMneZJ3aS4Wy2B2gT8A5LOb1OrBXjXtVhGyJLzcK6iCH4Eopw4OTTAdH++7Vz6KEa+V+Wrfr
X-MS-Exchange-AntiSpam-MessageData: u9JqsMVZueve4VflRgySCSKM6MMUJJVMkBC3DZywGoOVqXkbenA7TePcM8sLerDY1F4721soe+q7+FTJZtdGUYf9HWluxXAUc122P84qMFVTlDsc75FdPYGnb+Jt8APwlfpL3GKccMyYdOdyGiM20FfepQ838q7r5+7YzI8f75Q7oPXC7dNx+3tWkA/toaKZ
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f5d02e1-0c03-40bf-5049-08d7d107eccd
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2020 22:00:26.5851
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bMpDBqJomfvmvezHw7OOYYeT57wOS+wFZizlvOkAPn7L3hnqXNSIz37gQcgi0osd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB4057
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-25_13:2020-03-24,2020-03-25 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 bulkscore=0 lowpriorityscore=0 suspectscore=0 phishscore=0
 priorityscore=1501 mlxscore=0 adultscore=0 spamscore=0 mlxlogscore=999
 malwarescore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2003250168
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/25/20 2:20 PM, Joe Stringer wrote:
> On Wed, Mar 25, 2020 at 11:18 AM Yonghong Song <yhs@fb.com> wrote:
>>
>>
>>
>> On 3/24/20 10:57 PM, Joe Stringer wrote:
>>> From: Lorenz Bauer <lmb@cloudflare.com>
>>>
>>> Attach a tc direct-action classifier to lo in a fresh network
>>> namespace, and rewrite all connection attempts to localhost:4321
>>> to localhost:1234 (for port tests) and connections to unreachable
>>> IPv4/IPv6 IPs to the local socket (for address tests).
>>>
>>> Keep in mind that both client to server and server to client traffic
>>> passes the classifier.
>>>
>>> Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
>>> Co-authored-by: Joe Stringer <joe@wand.net.nz>
>>> Signed-off-by: Joe Stringer <joe@wand.net.nz>
>>> ---
>>> v2: Rebase onto test_progs infrastructure
>>> v1: Initial commit
>>> ---
>>>    tools/testing/selftests/bpf/Makefile          |   2 +-
>>>    .../selftests/bpf/prog_tests/sk_assign.c      | 244 ++++++++++++++++++
>>>    .../selftests/bpf/progs/test_sk_assign.c      | 127 +++++++++
>>>    3 files changed, 372 insertions(+), 1 deletion(-)
>>>    create mode 100644 tools/testing/selftests/bpf/prog_tests/sk_assign.c
>>>    create mode 100644 tools/testing/selftests/bpf/progs/test_sk_assign.c
>>>
>>> diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
>>> index 7729892e0b04..4f7f83d059ca 100644
>>> --- a/tools/testing/selftests/bpf/Makefile
>>> +++ b/tools/testing/selftests/bpf/Makefile
>>> @@ -76,7 +76,7 @@ TEST_PROGS_EXTENDED := with_addr.sh \
>>>    # Compile but not part of 'make run_tests'
>>>    TEST_GEN_PROGS_EXTENDED = test_sock_addr test_skb_cgroup_id_user \
>>>        flow_dissector_load test_flow_dissector test_tcp_check_syncookie_user \
>>> -     test_lirc_mode2_user xdping test_cpp runqslower
>>> +     test_lirc_mode2_user xdping test_cpp runqslower test_sk_assign
>>
>> No test_sk_assign any more as the test is integrated into test_progs, right?
> 
> I'll fix it up.
> 
>>> +static __u32 duration;
>>> +
>>> +static bool configure_stack(int self_net)
>>
>> self_net parameter is not used.
> 
> Hrm, why didn't the compiler tell me this..? Will fix.
> 
>>> +{
>>> +     /* Move to a new networking namespace */
>>> +     if (CHECK_FAIL(unshare(CLONE_NEWNET)))
>>> +             return false;
>>
>> You can use CHECK to encode better error messages. Thhis is what
>> most test_progs tests are using.
> 
> I was going back and forth on this when I was writing this bit.
> CHECK_FAIL() already prints the line that fails, so when debugging
> it's pretty clear what call went wrong if you dig into the code.
> Combine with perror() and you actually get a readable string of the
> error, whereas the common form for CHECK() seems to be just printing
> the error code which the developer then has to do symbol lookup to
> interpret..
> 
>      if (CHECK(efd < 0, "open", "err %d errno %d\n", efd, errno))
> 
> Example output with CHECK_FAIL / perror approach:
> 
>      # ./test_progs -t assign
>      ...
>      Timed out while connecting to server
>      connect_to_server:FAIL:90
>      Cannot connect to server: Interrupted system call
>      #46/1 ipv4 port redir:FAIL
>      #46 sk_assign:FAIL
>      Summary: 0/0 PASSED, 0 SKIPPED, 2 FAILED

I won't insist since CHECK_FAIL should roughly provide enough
information for failure. CHECK might be more useful if you want
to provide more context, esp. if the same routine is called
in multiple places and you can have a marker to differentiate
which call site caused the problem.

But again, just a suggestion. CHECK_FAIL is okay to me.

> 
> Diff to make this happen is just connect to a port that the BPF
> program doesn't redirect:
> 
> $ git diff
> diff --git a/tools/testing/selftests/bpf/prog_tests/sk_assign.c
> b/tools/testing/selftests/bpf/prog_tests/sk_assign.c
> index 1f0afcc20c48..ba661145518a 100644
> --- a/tools/testing/selftests/bpf/prog_tests/sk_assign.c
> +++ b/tools/testing/selftests/bpf/prog_tests/sk_assign.c
> @@ -192,7 +191,7 @@ static int do_sk_assign(void)
>                  goto out;
> 
>          /* Connect to unbound ports */
> -       addr4.sin_port = htons(TEST_DPORT);
> +       addr4.sin_port = htons(666);
>          addr6.sin6_port = htons(TEST_DPORT);
> 
>          test__start_subtest("ipv4 port redir");
> 
> (I had to drop the kill() call as well, but that's part of the next
> revision of this series..)
> 
>>> +static int connect_to_server(const struct sockaddr *addr, socklen_t len)
>>> +{
>>> +     int fd = -1;
>>> +
>>> +     fd = socket(addr->sa_family, SOCK_STREAM, 0);
>>> +     if (CHECK_FAIL(fd == -1))
>>> +             goto out;
>>> +     if (CHECK_FAIL(sigaction(SIGALRM, &timeout_action, NULL)))
>>> +             goto out;
>>
>> should this goto close_out?
> 
> Will fix.
> 
>>> +void test_sk_assign(void)
>>> +{
>>> +     int self_net;
>>> +
>>> +     self_net = open(NS_SELF, O_RDONLY);
>>> +     if (CHECK_FAIL(self_net < 0)) {
>>> +             perror("Unable to open "NS_SELF);
>>> +             return;
>>> +     }
>>> +
>>> +     if (!configure_stack(self_net)) {
>>> +             perror("configure_stack");
>>> +             goto cleanup;
>>> +     }
>>> +
>>> +     do_sk_assign();
>>> +
>>> +cleanup:
>>> +     close(self_net);
>>
>> Did we exit the newly unshared net namespace and restored the previous
>> namespace?
> 
> Ah I've mainly just been running this test so it didn't affect me but
> I realise now I dropped the hunks that were intended to do this
> cleanup. Will fix.
> 
>>> +     /* We can't do a single skc_lookup_tcp here, because then the compiler
>>> +      * will likely spill tuple_len to the stack. This makes it lose all
>>> +      * bounds information in the verifier, which then rejects the call as
>>> +      * unsafe.
>>> +      */
>>
>> This is a known issue. For scalars, only constant is restored properly
>> in verifier at this moment. I did some hacking before to enable any
>> scalars. The fear is this will make pruning performs worse. More
>> study is needed here.
> 
> Thanks for the background. Do you want me to refer to any specific
> release version or date or commit for this comment or it's fine to
> leave as-is?

Maybe add a "workaround:" marker in the comments so later we can search
and find these examples if we have compiler/verifier improvements.

-bash-4.4$ egrep -ri workaround
test_get_stack_rawtp.c: * This is an acceptable workaround since there 
is one entry here.
test_seg6_loop.c:       // workaround: define induction variable "i" as 
"long" instead
test_sysctl_loop1.c:    /* a workaround to prevent compiler from generating
-bash-4.4$
