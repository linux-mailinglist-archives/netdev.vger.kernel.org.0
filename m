Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59E2B194C07
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 00:14:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727639AbgCZXOc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 19:14:32 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:26306 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727347AbgCZXOc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 19:14:32 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 02QN9IBc032498;
        Thu, 26 Mar 2020 16:14:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=113rVbSKXoplpZeuH67Z9X993mY92nW81x0ySNRQcGc=;
 b=FemSma3V/d+vepTYQw55xdRf6I4++iya20tnZVgUxdmJk9QznWopJ6Dpzs1GITwNxJkI
 oMcmZBi2tEL8kDz6Ialg9kzf4kmw5GMxm2i2EPRniKlvjpMxp5lwBWf/3rhxlnmsnY3b
 ttsmkb2bUh3dDNdxwF0lcBb11hqkEIhrx0g= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 2yweknxj3y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 26 Mar 2020 16:14:17 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Thu, 26 Mar 2020 16:14:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LDph1IYAI+hXWNh2nK8uFulR2ogo62jF+Fw2cyCmv4rS49MoeMiNr/CKXK//AZ4KT7GaC85o36tjx1BH6l6zwVBP/qQUVvcS3Mb1zng3uB2ulsNwFsp14/83tkWduixEqnnhKjafWW3lE4UKV5DhicF9RGs+WAwCtq/nfZKeFMsUiQg7SRDZw6F2F3iBfwqXFNsLH+KF524AXyMagfI2DjVr7fVbdKtoNQAu7DdSoTe4l9KTlREFui2uzxQPClv6eW20yVPKOuK2MxcoKfmkjMFKhq0NIFynmRtT/4nJ2+2TIkaQrZayaR2xLX3WyrOPSDBCDVr5vWHweudqJbHhHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=113rVbSKXoplpZeuH67Z9X993mY92nW81x0ySNRQcGc=;
 b=ZTCIUCvUDs33BEOep+UIdu7QQOtTxuaxO0ncUD0ESBx61Yh5Oa5mnajNRjhVndXm2z0DKn66HuNHZHlVsFrx2No62kAFMheHaPWXrbJxZSw75BE6u++1wTzZ7HI+zavlfls9VhQcuAvxwLuRpY+orw9RtIgmBc3RcYrr98+gClfvvzg6axk/1CDGhdSB1tVS0/1n6OhCFJxCsBNk3H88iTYtBv/SlstGPEJ1RaQ6wVy9DDxDGbdu8Vsm7P8A951hoqsocFK9pul0XH2szARs+AblXxdsVMii7vafPqbnCyoLwitHJTDBsKEIfXPtXynhINGNsmJZ9aQourIxp6nVow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=113rVbSKXoplpZeuH67Z9X993mY92nW81x0ySNRQcGc=;
 b=C34WnwXOPqkuGFhIDc6yr1qcGsTVRhdkgq3dT71X1bvlzWfkYmxZr42YYJyBY8MAlFA4cdKXfJum42kpU0RyA5LCHdcONeDSibbhijqHFtYEEeYsFgCL2wfALTqpieQtTxtvfwkFMoJnHS8FMKsxplzMIoTUIkr5UdnsTGV/OCY=
Received: from MW3PR15MB3883.namprd15.prod.outlook.com (2603:10b6:303:51::22)
 by MW3PR15MB3772.namprd15.prod.outlook.com (2603:10b6:303:4c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.20; Thu, 26 Mar
 2020 23:14:14 +0000
Received: from MW3PR15MB3883.namprd15.prod.outlook.com
 ([fe80::a49b:8546:912f:dd98]) by MW3PR15MB3883.namprd15.prod.outlook.com
 ([fe80::a49b:8546:912f:dd98%5]) with mapi id 15.20.2835.025; Thu, 26 Mar 2020
 23:14:14 +0000
Subject: Re: call for bpf progs. Re: [PATCHv2 bpf-next 5/5] selftests: bpf:
 add test for sk_assign
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>
CC:     Joe Stringer <joe@wand.net.nz>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Martin Lau <kafai@fb.com>
References: <20200325055745.10710-1-joe@wand.net.nz>
 <20200325055745.10710-6-joe@wand.net.nz>
 <82e8d147-b334-3d29-0312-7b087ac908f3@fb.com>
 <CACAyw99Eeu+=yD8UKazRJcknZi3D5zMJ4n=FVsxXi63DwhdxYA@mail.gmail.com>
 <20200326210719.den5isqxntnoqhmv@ast-mbp>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <ac11345e-3036-4f88-96ab-9cff84b5d9ea@fb.com>
Date:   Thu, 26 Mar 2020 16:14:10 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.6.0
In-Reply-To: <20200326210719.den5isqxntnoqhmv@ast-mbp>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW2PR16CA0053.namprd16.prod.outlook.com
 (2603:10b6:907:1::30) To MW3PR15MB3883.namprd15.prod.outlook.com
 (2603:10b6:303:51::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from macbook-pro-52.local.dhcp.thefacebook.com (2620:10d:c090:400::5:ab1) by MW2PR16CA0053.namprd16.prod.outlook.com (2603:10b6:907:1::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.19 via Frontend Transport; Thu, 26 Mar 2020 23:14:12 +0000
X-Originating-IP: [2620:10d:c090:400::5:ab1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a19c2a09-24a8-4838-7f85-08d7d1db6617
X-MS-TrafficTypeDiagnostic: MW3PR15MB3772:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MW3PR15MB37729213111D2C5B6D503540D3CF0@MW3PR15MB3772.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0354B4BED2
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(396003)(376002)(39860400002)(366004)(136003)(346002)(53546011)(31686004)(6506007)(52116002)(6486002)(66476007)(66946007)(186003)(16526019)(2616005)(5660300002)(110136005)(2906002)(36756003)(4326008)(31696002)(6512007)(54906003)(966005)(316002)(81166006)(478600001)(81156014)(8936002)(66556008)(86362001)(8676002);DIR:OUT;SFP:1102;SCL:1;SRVR:MW3PR15MB3772;H:MW3PR15MB3883.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MQLQ8LEWYBHPTGEON/Lsl2d7nKEVrfMuDEoP5UGAfxyv6aXlV824hxUtdKYeEHTgiMu/3+XSvBKeeRyfqzodqLfjjCn9cCGm6H+Clw9bCfNFJQmsWmsdXg+g2P6PubpntHwfLT4vB9OHZ7mKn6Xd1qqWX0Bzh6r4PO9w93mtUSIfoK4LtIbLD/FaC+VbMUbTUfhf2VVjusLR/bcA+0+LmuIU/XuTTSXYTBhTckE73WerqsKde2exEIsIP+v2P0ISUtIAKqWgoNzK3LUdCCm8gRSyD/1X+QHXrNo8T5EABB3eL6HuQ6oR12KD9P+V0YZp+Ke0NoI1dTG97u9aMJDosOZFZCfgfiUm10ZzqZBeSlxVbOH42cV31ignrt2d5+0duDopnOkerxW9vKJio4CH3dd7e8Wr9RxrtcqixigleT0YAfrbg2qAswKbjC8u5nwVUu2YUea5pFAD6ldfYG/RBcQ6xTSCUk/ml9qTNLvB9bNpq+exEP359VF+S+DtJgDDvPwu0aUvAazDywiIxbkceg==
X-MS-Exchange-AntiSpam-MessageData: /UrYUZrj0MDfobUmk3743IripLYGL2hheU3/AY2Z0yrOOuvLFrjngjE9oLpi+ghkK6nVFNu+4q/0OSF8sdfjebudGiuqORmYQZ1GsV2zMDJT2izy4XSHvf5Bhg45K1k71kfd/NRS2046vYYIK/pNOYTahxlkR/nHM55rGdufLfjPQVHHnIq9fsdrrwr2uZ/Y
X-MS-Exchange-CrossTenant-Network-Message-Id: a19c2a09-24a8-4838-7f85-08d7d1db6617
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2020 23:14:13.8736
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XxoTOMRKqPjTqjlUz3Mqjwt0xf4xsgjJG6HqaDV4UCrC1vuWthIYMf9vYvueK8Tc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3772
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-26_14:2020-03-26,2020-03-26 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 lowpriorityscore=0 mlxlogscore=999 spamscore=0 phishscore=0 suspectscore=0
 clxscore=1015 adultscore=0 mlxscore=0 impostorscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003260168
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/26/20 2:07 PM, Alexei Starovoitov wrote:
> On Thu, Mar 26, 2020 at 10:13:31AM +0000, Lorenz Bauer wrote:
>>>> +
>>>> +     if (ipv4) {
>>>> +             if (tuple->ipv4.dport != bpf_htons(4321))
>>>> +                     return TC_ACT_OK;
>>>> +
>>>> +             ln.ipv4.daddr = bpf_htonl(0x7f000001);
>>>> +             ln.ipv4.dport = bpf_htons(1234);
>>>> +
>>>> +             sk = bpf_skc_lookup_tcp(skb, &ln, sizeof(ln.ipv4),
>>>> +                                     BPF_F_CURRENT_NETNS, 0);
>>>> +     } else {
>>>> +             if (tuple->ipv6.dport != bpf_htons(4321))
>>>> +                     return TC_ACT_OK;
>>>> +
>>>> +             /* Upper parts of daddr are already zero. */
>>>> +             ln.ipv6.daddr[3] = bpf_htonl(0x1);
>>>> +             ln.ipv6.dport = bpf_htons(1234);
>>>> +
>>>> +             sk = bpf_skc_lookup_tcp(skb, &ln, sizeof(ln.ipv6),
>>>> +                                     BPF_F_CURRENT_NETNS, 0);
>>>> +     }
>>>> +
>>>> +     /* We can't do a single skc_lookup_tcp here, because then the compiler
>>>> +      * will likely spill tuple_len to the stack. This makes it lose all
>>>> +      * bounds information in the verifier, which then rejects the call as
>>>> +      * unsafe.
>>>> +      */
>>>
>>> This is a known issue. For scalars, only constant is restored properly
>>> in verifier at this moment. I did some hacking before to enable any
>>> scalars. The fear is this will make pruning performs worse. More
>>> study is needed here.
>>
>> Of topic, but: this is actually one of the most challenging issues for
>> us when writing
>> BPF. It forces us to have very deep call graphs to hopefully avoid clang
>> spilling the constants. Please let me know if I can help in any way.
> 
> Thanks for bringing this up.
> Yonghong, please correct me if I'm wrong.

Yes. The summary below is correct. For reference, the below bcc issue
documents some of my investigation:
   https://github.com/iovisor/bcc/issues/2463

> I think you've experimented with tracking spilled constants. The first issue
> came with spilling of 4 byte constant. The verifier tracks 8 byte slots and
> lots of places assume that slot granularity. It's not clear yet how to refactor
> the verifier. Ideas, help are greatly appreciated.

I cannot remember exactly what I did then. Probably remember the spilled 
size too. Since the hack is never peer reviewed, maybe my approach has bugs.

> The second concern was pruning, but iirc the experiments were inconclusive.
> selftests/bpf only has old fb progs. Hence, I think, the step zero is for
> everyone to contribute their bpf programs written in C. If we have both
> cilium and cloudflare progs as selftests it will help a lot to guide such long
> lasting verifier decisions.

Yes, this is inconclusive and I did not do any active investigation here
since just enhancing the non-const spill won't resolve the above issue.
But totally agree that if we had an implementation, we should measure
its impact on verifier speed.
