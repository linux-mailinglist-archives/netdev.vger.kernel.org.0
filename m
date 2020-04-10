Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05FAD1A4CB3
	for <lists+netdev@lfdr.de>; Sat, 11 Apr 2020 01:47:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726650AbgDJXry (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 19:47:54 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:17228 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726594AbgDJXrx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Apr 2020 19:47:53 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03ANj0SN002727;
        Fri, 10 Apr 2020 16:47:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=iEKjC+Yy83GRhkmFXMiJKwwgu8zYECdhSc6RE6zpPJA=;
 b=nbxvEMPOwRCXhTLpDE1IHv/wrf3wZXSUmuFfYcsztQbau0DwdnLPtNo1u4Cq5tI0RjLX
 XBDd/jnTqbZ1WYDasNNSSSy/G2vFhsplGeMvNlFiza8CRU59AVzo8drUmCwas2LDsqz1
 AbJWfNLDigWbb/UtQTlkxL3f5827I+B3gVQ= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 30aur3acg8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 10 Apr 2020 16:47:41 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Fri, 10 Apr 2020 16:47:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a2egH7z3x8M3RPXXfTv663wYgDQHvMkqO0HIfbNPKtbgIfL8UchNOIuJJduMfZVeqTi2VRU140vX8H9TtLpOh7RWJsNK2vpWgrAivhe6KA5I+j/U2duJRQDRWvNxIhFBE4CQcmV/UWaKR2GaDgkDajLZt/wqjywtdP+eAqBcseu9QFRfehRPjVL6/FwUqCdBRD05x5G+CvkciqbTU8bBsrMan3SaiatWvH9+SgnWGMcPgPAtTGs8k0B37vkBvbVl5bszW0v2L7VhcJNZxqQLTV5X699nVBmvDybt0FmnJqmQZT4CC3av2JPHkIFrI5H18TybPb5BC6e+MTHbTTSVXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iEKjC+Yy83GRhkmFXMiJKwwgu8zYECdhSc6RE6zpPJA=;
 b=T5tNWsBHttjIkfy42bqPkZkMOH3Nf7HF5xOOGc9rTnS+QrkAfaDoa3CH+cCZQywCN3zJhbHXThbq4BVXVxN3c2ecdhIoFrvYofXIqD4YKXJqAuLWNio6GCuVys4EAsr9WBCNY2an8uLCUGAJ1QC24sGPfslTZipMyHEOiNF5CI2QIGZKMAWsO//qDidAS4VFpCSA7xS1OyaHTvbBiPIekzIunnEMLfMF7Lbaq59SfVKvvPHu/7J6zKtQTY99DVjggEWrB1TO8nfUCn/qATRGdiQ7cZijMNK9BUSt0cSb25/Lgnhi52FH8QdT8b74HyuU597Yk2hAtt7r7uXOhkevGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iEKjC+Yy83GRhkmFXMiJKwwgu8zYECdhSc6RE6zpPJA=;
 b=GLyHA/IKuuARms0DW89tmKnlUnnpP1u9CFnxhUoFZVWn1DTfsID/6tCdBxopoOWmTTeM7D/H//RcMs5JlyzPSZt7xy0U1dLRUaVxh7Zl7dn5EhapQ0M8xacyXtF1eLzJ39YmPaC5S6n3rywKFPFcY9noMvxCEzDh/qokH9MN+3I=
Received: from MW3PR15MB3883.namprd15.prod.outlook.com (2603:10b6:303:51::22)
 by MW3PR15MB3962.namprd15.prod.outlook.com (2603:10b6:303:45::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.19; Fri, 10 Apr
 2020 23:47:39 +0000
Received: from MW3PR15MB3883.namprd15.prod.outlook.com
 ([fe80::a49b:8546:912f:dd98]) by MW3PR15MB3883.namprd15.prod.outlook.com
 ([fe80::a49b:8546:912f:dd98%5]) with mapi id 15.20.2878.018; Fri, 10 Apr 2020
 23:47:39 +0000
Subject: Re: [RFC PATCH bpf-next 05/16] bpf: create file or anonymous dumpers
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
References: <20200408232520.2675265-1-yhs@fb.com>
 <20200408232526.2675664-1-yhs@fb.com>
 <20200410030017.errh35srmbmd7uk5@ast-mbp.dhcp.thefacebook.com>
 <c34e8f08-c727-1006-e389-633f762106ab@fb.com>
 <CAEf4BzYM3fPUGVmRJOArbxgDg-xMpLxyKPxyiH5RQUbKVMPFvA@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <2d941e43-72de-b641-22b8-b9ec970ccf52@fb.com>
Date:   Fri, 10 Apr 2020 16:47:36 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
In-Reply-To: <CAEf4BzYM3fPUGVmRJOArbxgDg-xMpLxyKPxyiH5RQUbKVMPFvA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR15CA0038.namprd15.prod.outlook.com
 (2603:10b6:300:ad::24) To MW3PR15MB3883.namprd15.prod.outlook.com
 (2603:10b6:303:51::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from MacBook-Pro-52.local (2620:10d:c090:400::5:e0e4) by MWHPR15CA0038.namprd15.prod.outlook.com (2603:10b6:300:ad::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.15 via Frontend Transport; Fri, 10 Apr 2020 23:47:38 +0000
X-Originating-IP: [2620:10d:c090:400::5:e0e4]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 54208cfd-b4ef-4d11-c9f0-08d7dda98d70
X-MS-TrafficTypeDiagnostic: MW3PR15MB3962:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MW3PR15MB39629EE4F948DFA0A08BA394D3DE0@MW3PR15MB3962.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 0369E8196C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR15MB3883.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(39860400002)(136003)(346002)(376002)(366004)(396003)(186003)(4326008)(36756003)(6916009)(16526019)(31696002)(52116002)(31686004)(478600001)(53546011)(66946007)(66556008)(66476007)(5660300002)(2906002)(2616005)(86362001)(54906003)(81156014)(6512007)(8936002)(6486002)(316002)(6506007)(8676002);DIR:OUT;SFP:1102;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nCjCACPMsJvA5J95Lmctrv4Z1siN4HutE4NMVi9qHQM32WN9O5SpPzEcns0h2B4HrEPZxZVlpUz0G/M+TZbvO90TK7sjDS7dkt7p8DQwsKI/mhLZCRqthw7IsRB0wzgDBNmRagkJwM3yBqG+1lvXyDgTfVLtdqvlCAX/DzTFBsdNVWGf9EcpH6qr6thh+bKxKcPzqU/0B6eQQ6Osrym1g1Hj8/jao+2jmR2msHGdWPDfQ0AguRdMmo/5npDDjELaq1gjy0F+6nhPEySniqtbUFULHexc0ZdKzvkBYHGX+rK66qHE+YjQCI3MMZ5UtOjybBvQ0PNEBXvV6yCxvXYpSrd3NXXdKERkLsHnfppYBKXk+wLrb1aD2DUisX6pljm7erdu7zOQJUD4+x2Za0MhhEPZhPqWQ9oMxnd5r/1VrAy/UZ1RXH3dpIjgd76Zpt1J
X-MS-Exchange-AntiSpam-MessageData: ln1W2PohEIFuuGdBWBtqiOIz9WXxbHf0odANm7d8G5hc/QE8/VoOq4eC0wj19qbPbK/zt0jS/mAQBwbgwvgKgk4pdMGab5p/kVk8X9Wk7SPja71U7crMBWrRVMXZTMSq1gmGk40piMyFP+CAwgri1Upc5va89aP68M8KJwi4af0Hwb/lkfQS4oG9ncoywdV6
X-MS-Exchange-CrossTenant-Network-Message-Id: 54208cfd-b4ef-4d11-c9f0-08d7dda98d70
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2020 23:47:39.3313
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LOYPc4hUfMyQtTFehbaf1iJgyDthcxDrQIeXLRQipVh7uBb5wmw0R+kYSh72PF7Y
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3962
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-10_10:2020-04-09,2020-04-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 adultscore=0 clxscore=1015 bulkscore=0 mlxlogscore=999 priorityscore=1501
 malwarescore=0 impostorscore=0 phishscore=0 spamscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004100167
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/10/20 3:53 PM, Andrii Nakryiko wrote:
> On Fri, Apr 10, 2020 at 3:43 PM Yonghong Song <yhs@fb.com> wrote:
>>
>>
>>
>> On 4/9/20 8:00 PM, Alexei Starovoitov wrote:
>>> On Wed, Apr 08, 2020 at 04:25:26PM -0700, Yonghong Song wrote:
>>>> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
>>>> index 0f1cbed446c1..b51d56fc77f9 100644
>>>> --- a/include/uapi/linux/bpf.h
>>>> +++ b/include/uapi/linux/bpf.h
>>>> @@ -354,6 +354,7 @@ enum {
>>>>    /* Flags for accessing BPF object from syscall side. */
>>>>       BPF_F_RDONLY            = (1U << 3),
>>>>       BPF_F_WRONLY            = (1U << 4),
>>>> +    BPF_F_DUMP              = (1U << 5),
>>> ...
>>>>    static int bpf_obj_pin(const union bpf_attr *attr)
>>>>    {
>>>> -    if (CHECK_ATTR(BPF_OBJ) || attr->file_flags != 0)
>>>> +    if (CHECK_ATTR(BPF_OBJ) || attr->file_flags & ~BPF_F_DUMP)
>>>>               return -EINVAL;
>>>>
>>>> +    if (attr->file_flags == BPF_F_DUMP)
>>>> +            return bpf_dump_create(attr->bpf_fd,
>>>> +                                   u64_to_user_ptr(attr->dumper_name));
>>>> +
>>>>       return bpf_obj_pin_user(attr->bpf_fd, u64_to_user_ptr(attr->pathname));
>>>>    }
>>>
>>> I think kernel can be a bit smarter here. There is no need for user space
>>> to pass BPF_F_DUMP flag to kernel just to differentiate the pinning.
>>> Can prog attach type be used instead?
>>
>> Think again. I think a flag is still useful.
>> Suppose that we have the following scenario:
>>     - the current directory /sys/fs/bpf/
>>     - user says pin a tracing/dump (target task) prog to "p1"
>>
>> It is not really clear whether user wants to pin to
>>      /sys/fs/bpf/p1
>> or user wants to pin to
>>      /sys/kernel/bpfdump/task/p1
>>
>> unless we say that a tracing/dump program cannot pin
>> to /sys/fs/bpf which seems unnecessary restriction.
>>
>> What do you think?
> 
> Instead of special-casing dumper_name, can we require specifying full
> path, and then check whether it is in BPF FS vs BPFDUMP FS? If the
> latter, additionally check that it is in the right sub-directory
> matching its intended target type.

We could. I just think specifying full path for bpfdump is not necessary 
since it is a single user mount...

> 
> But honestly, just doing everything within BPF FS starts to seem
> cleaner at this point...

bpffs is multi mount, which is not a perfect fit for bpfdump,
considering mounting inside namespace, etc, all dumpers are gone.
