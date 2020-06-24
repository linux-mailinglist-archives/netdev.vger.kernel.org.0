Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 466BA206973
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 03:24:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388245AbgFXBYq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 21:24:46 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:8684 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387842AbgFXBYp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 21:24:45 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 05O1Kefg018705;
        Tue, 23 Jun 2020 18:24:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=0xMXARyYEgxnqUfMU5lydoc6D2mQOviwZ21W6Q9jyF0=;
 b=oUeR1D1iZaRKFVIg+nHZDjyAwPQqMYlBGwqc4BW4FKyJnRxqrhOy+MOPr5z7oYPkB1nr
 JQW3wqMr4tG5/+HIjdgVHKxCWc36GYUARNtKPqgEQSuWVS+vnRKfjaJ2W0teBgSOZ1h8
 n8iZNQBTekRmWg96lNn5XBoea6KnOrYPtkU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 31uuqg0adj-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 23 Jun 2020 18:24:31 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 23 Jun 2020 18:24:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hY8g/OGSPd9m48bwUTi4HuLnOm1a3Vc03+JYTftq+RN/4391k6UHq6AE7xptW+qSulnQ+UwBoq3jscVqFrqwU/Wb4v/oXTaZG/kFBHX3K0vAoZ1BVH9ZEvzrk7EFhUoRIUN71q5E8/ydFjRAyQkGDT67/XwkmOO5BsHPXLtMmMBIE836FJof7WgbTPRmyg2tpHpOdtcY8dR1IsEfv6UbQo7NG3sKIelAj124EY5whcDMHJPim1ua3ISrGY4c+gYMKWPRzCerD4KCJd4L9l6TPAT6DxArF2tpvugtsZ58RSdxzRQJm+XwP63BV9GEIROqt6BkudHI0HCfyqN2EGotTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0xMXARyYEgxnqUfMU5lydoc6D2mQOviwZ21W6Q9jyF0=;
 b=YJfGwqshGIGJVHc1nuSInZLXdMMg5ByJCKRXcM9WUWzLGNSb8K0HTBF+RaG7tG/dcdhtK+iBW9SM4fXccUh4m/evWjeZHKYrGpCBi3bEzfHTXVXwc2CrzzY1H/G9fEUbe47zXye2GesZg6/A48+MAbcYVKr1gml+mOFuXNcATbkmQ1Gcxe2d0J3SQ859nhV8mryDZqkSh2wOiY/dO4/eZ1ercZMbf9Hvo3mQpSH2r+MPApsT1z0T7hXEuc4EW+3qUb/j1YLZMRXK5+1PsjVjmTK3hMKLW0ANQmv9kQov81ExTpg045UBreZiuaujPatJ0Z5zJijojmA212rPIPaLAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0xMXARyYEgxnqUfMU5lydoc6D2mQOviwZ21W6Q9jyF0=;
 b=JlnU8C8pwHJbkeyyWRcjyF0/o0/gD469uXgd+yMyB6SLdwVmNa6Ms3ZS+sDFT5GtYt/5yPF6V+zculphoeOwoCMna8I8N+E1285Dl7/fTbxYQc8YSpmiZN2fgLkmcSjbQuI9obMFdQc79mq5b/YaguK6l2h4UFFHC9rbi/aMdjY=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2264.namprd15.prod.outlook.com (2603:10b6:a02:8a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Wed, 24 Jun
 2020 01:23:58 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301%7]) with mapi id 15.20.3109.027; Wed, 24 Jun 2020
 01:23:57 +0000
Subject: Re: [PATCH bpf] libbpf: fix CO-RE relocs against .text section
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>
References: <20200619230423.691274-1-andriin@fb.com>
 <ff1e49a8-57bb-a323-f477-018f9a6f0597@fb.com>
 <CAADnVQ+_HD3sfXPoT9bQ3ZdyBW1ibUGrt1KrFo4_7pgppTK-Wg@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <f8470b35-dac3-fc11-50a5-06760754a944@fb.com>
Date:   Tue, 23 Jun 2020 18:23:55 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
In-Reply-To: <CAADnVQ+_HD3sfXPoT9bQ3ZdyBW1ibUGrt1KrFo4_7pgppTK-Wg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR13CA0030.namprd13.prod.outlook.com
 (2603:10b6:a03:180::43) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21cf::1926] (2620:10d:c090:400::5:d956) by BY5PR13CA0030.namprd13.prod.outlook.com (2603:10b6:a03:180::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.12 via Frontend Transport; Wed, 24 Jun 2020 01:23:57 +0000
X-Originating-IP: [2620:10d:c090:400::5:d956]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f83dd0c7-5410-4213-2333-08d817dd446f
X-MS-TrafficTypeDiagnostic: BYAPR15MB2264:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB22640D8078037E6207481BB7D3950@BYAPR15MB2264.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0444EB1997
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NJOsqwLmh16xaE/IodOU4MT3xSXpcOHIktkOBC0rs0nsDINCYo1EUxtjvJUf43oytjBEKltlk9mjA9ZU8zL5UGWY5cmQ7B6XxGAqCTVPDMzJzKZOUi3Itdt+/6OWIqr3bEtZEbB3qAJKAnimpm14w/THmn0lNaG4wLhPFM2NypRJ1rr/AuepzTW0oLhBj3kfUyDl22dM84+YP1JvwirL0o/bBxcCck9kYVZ2DxFM0Oyh1Y8dvrkAdlfKesjwjkY3tmwHywK8z5d12d1Svc3Zwxupl/b81Cm//P5Tmkkm7oxcfsuzyr70HkmXIGp75eQP+mCs7fM7vruhNmDu/9Rfbz6IXp4Jmw95dUNUP0Wx9APL/1iMtbgNxJXwBlFFT8YnNiWW5pkuchZFHXvPAAE/ft+fhFTKd+0DToSPqyQHA8g=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(376002)(366004)(346002)(39860400002)(136003)(396003)(31686004)(6486002)(16526019)(186003)(53546011)(478600001)(52116002)(8676002)(2906002)(4326008)(54906003)(36756003)(8936002)(316002)(6916009)(66476007)(2616005)(31696002)(66946007)(66556008)(5660300002)(83380400001)(86362001)(142923001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: uLnepjq9XNuerwLIjFSLVLeT6PBQx247+hy9GdUm8ruLiMWxBK7nhy2R3vh5G81KzktaxcTlaRSX1MhgP4hySVBZBRuzrS8oAqfdgNxp+xLWuClWkyl2jHlyxMYCGPuypWFK9EuGLqnzJ7oBkc06iTPbyZrxtNcSemCsJXC/kuxRliwaUgtdgAWx2BPaYHdS244QuLRkJVl+H96R03ZY/GER46Nmk9uasyvsaiXvwD/ijR+QVNSp0vVqeO9CAzBTtw4zO+xAUyndK2bFP2fWn3pJ8Ae6oqXErH79DqMG9NT3sgOGLH8NFCwxJ6OzVal5vRUAC+0oW0+RseZwOpfEkkmE49gJgc8JKq74y5/BQ6oPBBxCM0LERT0oKyjPOuhHT8psdGvzwSSkZygoALz2T3Q4ib+qBD1ieyM6wh55CxvCl/65A3QB9b4lYw5IsBn9vDi1N8RtSo4WIScf9ny3bHN0j0lxliSqwGWYHxGW6Gt3Z5w1iS6pZQrVULuj+KRbjZfn+hE+CCqc7SZrj9gaYw==
X-MS-Exchange-CrossTenant-Network-Message-Id: f83dd0c7-5410-4213-2333-08d817dd446f
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2020 01:23:57.8539
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: unf9QWm8qOsx0mdpTpm5HbPCnBHLe8rKmhF1UCln1al6RvqTtMM/Lvz+lFAJR67V
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2264
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-23_17:2020-06-23,2020-06-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0 mlxscore=0
 malwarescore=0 suspectscore=0 impostorscore=0 spamscore=0 adultscore=0
 clxscore=1015 lowpriorityscore=0 cotscore=-2147483648 mlxlogscore=999
 priorityscore=1501 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006240007
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/23/20 5:40 PM, Alexei Starovoitov wrote:
> On Sat, Jun 20, 2020 at 12:06 AM Yonghong Song <yhs@fb.com> wrote:
>>
>>
>>
>> On 6/19/20 4:04 PM, Andrii Nakryiko wrote:
>>> bpf_object__find_program_by_title(), used by CO-RE relocation code, doesn't
>>> return .text "BPF program", if it is a function storage for sub-programs.
>>> Because of that, any CO-RE relocation in helper non-inlined functions will
>>> fail. Fix this by searching for .text-corresponding BPF program manually.
>>>
>>> Adjust one of bpf_iter selftest to exhibit this pattern.
>>>
>>> Reported-by: Yonghong Song <yhs@fb.com>
>>> Fixes: ddc7c3042614 ("libbpf: implement BPF CO-RE offset relocation algorithm")
>>> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
>>
>> Acked-by: Yonghong Song <yhs@fb.com>
>>
>> But the fix here only fixed the issue for interpreter mode.
>> For jit only mode, we still have issues. The following patch can fix
>> the jit mode issue,
>>
>> =============
>>
>>   From 4d66814513ec45b86a30a1231b8a000d4bfc6f1a Mon Sep 17 00:00:00 2001
>> From: Yonghong Song <yhs@fb.com>
>> Date: Fri, 19 Jun 2020 23:26:13 -0700
>> Subject: [PATCH bpf] bpf: set the number of exception entries properly for
>>    subprograms
>>
>> Currently, if a bpf program has more than one subprograms, each
>> program will be jitted separately. For tracing problem, the
>> prog->aux->num_exentries is not setup properly. For example,
>> with bpf_iter_netlink.c modified to force one function not inlined,
>> and with proper libbpf fix, with CONFIG_BPF_JIT_ALWAYS_ON,
>> we will have error like below:
>>     $ ./test_progs -n 3/3
>>     ...
>>     libbpf: failed to load program 'iter/netlink'
>>     libbpf: failed to load object 'bpf_iter_netlink'
>>     libbpf: failed to load BPF skeleton 'bpf_iter_netlink': -4007
>>     test_netlink:FAIL:bpf_iter_netlink__open_and_load skeleton
>> open_and_load failed
>>     #3/3 netlink:FAIL
>> The dmesg shows the following errors:
>>     ex gen bug
>> which is triggered by the following code in arch/x86/net/bpf_jit_comp.c:
>>     if (excnt >= bpf_prog->aux->num_exentries) {
>>       pr_err("ex gen bug\n");
>>       return -EFAULT;
>>     }
>>
>> If the program has more than one subprograms, num_exentries is actually
>> 0 since it is not setup.
>>
>> This patch fixed the issue by setuping proper num_exentries for
>> each subprogram before calling jit function.
>>
>> Signed-off-by: Yonghong Song <yhs@fb.com>
> 
> Thanks for fixing. Applied both to bpf tree.
> Yonghong, next time please submit the patch properly.
> It was very awkward to copy-paste it manually from the thread.
> I've edited the commit log a bit.

Thanks. I posted original commit as I am not sure how to proceed as
this and Andrii's patch belongs to the same patch set to fix 
bpf_iter_netlink problem. I guess next time I will go ahead with
patch submit with proper description in the patch, which
sounds better for review and to get notice from other people.
