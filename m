Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EEA71710DC
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 07:16:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727336AbgB0GQv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 01:16:51 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:39948 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725906AbgB0GQv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 01:16:51 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01R6EqZr017838;
        Wed, 26 Feb 2020 22:16:36 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=ohhE+qQWhVE+VvJqKhzvMOmAcHm95pbsOiWXZ6PMlVI=;
 b=E/hfFhSEYq290I6CsaHR2XgdKyYAcv3JM19qDfoQFQ2obYcvdopBDq+bYv2mRDPOMzfq
 K/ci6VHSxQTHaHCpGMveFs2Q0tE92LjZplbE1AloWGbKPxlF5Hkkw2xdLdjTv/+A1QD+
 L5iizI5E9OSRH7ODUxEcnHMNWI5jUMxHWPw= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2ydcs7far3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 26 Feb 2020 22:16:36 -0800
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Wed, 26 Feb 2020 22:16:35 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fXzt3iQG1qEIUbRAnNuVQFuRtybNsvHLCDHbVYvlWdezBmjVzYd2DWlvjInVip1d+1OeR2TJbHGb8mTkvGeGG0MmliwINOADCHK+Lbcd0mfX9obO/ZSiCnNOLjO05W46PTleeIZjFx6dQxLg66jS0bXmuSYNRbrlWhq2onNE4ZS0E1jWfs2Ue5G57PZknSmM8qJevfCKD70S1Auy4ib8EJjDvC7txsQR8i7OzXvWvxyASHmeIGawgQTi4IqNuQJkFe4C1ia8kd2CKniVI5kmGIon79oIr9R5tjpiF+mxnV13VZd+f6eW3EZp97WGFNaZr/pUXLd/dxTQ8sZ7llaXkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ohhE+qQWhVE+VvJqKhzvMOmAcHm95pbsOiWXZ6PMlVI=;
 b=fEYdrFTWJhTMlisKB6DJi2HGY9WHjLzs4mbHHf6v7bgXxNAuV0qopXbNB2JegaeDWVHSH3+QVvEyf36xKpRM4MG0b7EhbyAj6TsC2YBa8o3niEvfLnEZw/iw2aGLtYtWXDZWXzs2I9T6P1s6qhQmYqlbhIvhxiHr+Iv3JWPapa2LLCWCTNGFus77AzPZ2oVjkmkM2VWYs/bO00orN3LhK+sJHrLgymigL+uGub7HiOMPTkCDGMlWBU+C/F+HY5RoRCxviNaW/i8npMl0waDh4MNbh3BiVuuuHeIO/24x3t1Y1rZSdX7d2uc+J6OLmpGhbBp/s2KRZ6hujjn9xEP0eQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ohhE+qQWhVE+VvJqKhzvMOmAcHm95pbsOiWXZ6PMlVI=;
 b=gQWOIvZivxB+gBZJAbZJLdSFWDTtzS+mvlUc/SE2Hu2RJ3i2Fe0sKPa5Zbs352HDRK2MjOdQ/2Pwk18u5kbeRvh0Ikkl4tSBsZBmxmCEZF8bQHzMBbCZy2m0wBRRNBEGqWnscjkvtIIP2uIu/s3EFRZIRpmzdk7dzkM2RoRjFh4=
Received: from DM6PR15MB3001.namprd15.prod.outlook.com (2603:10b6:5:13c::16)
 by DM6PR15MB3547.namprd15.prod.outlook.com (2603:10b6:5:1ff::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.15; Thu, 27 Feb
 2020 06:16:20 +0000
Received: from DM6PR15MB3001.namprd15.prod.outlook.com
 ([fe80::294e:884:76fd:743c]) by DM6PR15MB3001.namprd15.prod.outlook.com
 ([fe80::294e:884:76fd:743c%4]) with mapi id 15.20.2750.021; Thu, 27 Feb 2020
 06:16:20 +0000
Subject: Re: [PATCH bpf-next v2 4/4] bpf: inet_diag: Dump bpf_sk_storages in
 inet_diag_dump()
To:     Martin KaFai Lau <kafai@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>
CC:     <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>, <eric.dumazet@gmail.com>
References: <20200225230402.1974723-1-kafai@fb.com>
 <20200225230427.1976129-1-kafai@fb.com>
 <938a0461-fd8d-b4b9-4fef-95d46409c0d6@iogearbox.net>
 <20200227013448.srxy5kkpve7yheln@kafai-mbp>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <b3c06021-a5a4-191c-e301-a30ad6954191@fb.com>
Date:   Wed, 26 Feb 2020 22:16:16 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
In-Reply-To: <20200227013448.srxy5kkpve7yheln@kafai-mbp>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR04CA0064.namprd04.prod.outlook.com
 (2603:10b6:300:6c::26) To DM6PR15MB3001.namprd15.prod.outlook.com
 (2603:10b6:5:13c::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from MacBook-Pro-52.local (2620:10d:c090:400::5:e3b6) by MWHPR04CA0064.namprd04.prod.outlook.com (2603:10b6:300:6c::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.14 via Frontend Transport; Thu, 27 Feb 2020 06:16:19 +0000
X-Originating-IP: [2620:10d:c090:400::5:e3b6]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2d260d5a-8f04-410d-4cf4-08d7bb4c8fdb
X-MS-TrafficTypeDiagnostic: DM6PR15MB3547:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR15MB35472D307B6A90802A44BDD4D3EB0@DM6PR15MB3547.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:305;
X-Forefront-PRVS: 03264AEA72
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(39860400002)(376002)(396003)(366004)(346002)(136003)(189003)(199004)(8676002)(5660300002)(6486002)(66946007)(81156014)(66556008)(66476007)(81166006)(6512007)(8936002)(6666004)(4326008)(31686004)(16526019)(53546011)(31696002)(186003)(478600001)(86362001)(54906003)(52116002)(316002)(2616005)(36756003)(2906002)(110136005)(6506007);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR15MB3547;H:DM6PR15MB3001.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GcKrwZwhs/HnAVrpz5OKAoyZmhTTMJWh/ADybxV0bn4r8fG5g//CgQL9uWKMjb+H8o6UT19xIviT1cXaKhfMge6C2elRAyHdJQXoWL0DqfyDnJ6bAM+BugcxZIvSGcaGXlnTI8GLAQBfyZfwCr3J6Kd5w6OyUbjaA5SNYEqWbfQH2S/6IaJKBmmZNNNx1bb0TIg5OTgN+GBdiOYB6WBnVFk4cYHyQGTs1YHP6K05qJ5Tq1kBnGDB7r//4XjiL8QLYBHWQiBnmiCjGhp1g5IUIh+v2GpX34sxiqK6eAVzJ5Z4/7sBDIzUpj68NQboE+c9iByJ37gq41u98lxIzK1KcYUs/YoyTc02umtsSH0FmdrP/TKWrT0CxmXwgg7v0w/j5Yc8f0fX9acVGRU7uskC2xIfMHgdR/O/8/RnPbLA/XWowYyM7NYnlfhBBzvmR8NO
X-MS-Exchange-AntiSpam-MessageData: KexDYb08I/9PnBncw61lNCFAmRhqmP9PCj5MYk4KEbFnYrgMPLNgKdJO3HvJcy0dBhueslg2y5EAzHVYE18kr6BzBu8UaIK7xFYgdd3TT46cw1C7mCIfSuSucBLsGs9vcxQgRI6TsvhomeqLvUkYM2iZQ+/z5ERWEC4NtJvE465O/egtxKiToP4WvhXO/l8Q
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d260d5a-8f04-410d-4cf4-08d7bb4c8fdb
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2020 06:16:20.3656
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +5tQ9KpAe+5SBJTesULg6me0JkJYMU50hoRNhR+KV8poYLaXNGY7Pczj7oKST6nY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB3547
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-27_01:2020-02-26,2020-02-27 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 lowpriorityscore=0 priorityscore=1501 clxscore=1011 bulkscore=0
 malwarescore=0 phishscore=0 impostorscore=0 mlxscore=0 mlxlogscore=999
 spamscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002270048
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/26/20 5:34 PM, Martin KaFai Lau wrote:
> On Wed, Feb 26, 2020 at 06:21:33PM +0100, Daniel Borkmann wrote:
>> On 2/26/20 12:04 AM, Martin KaFai Lau wrote:
>>> This patch will dump out the bpf_sk_storages of a sk
>>> if the request has the INET_DIAG_REQ_SK_BPF_STORAGES nlattr.
>>>
>>> An array of SK_DIAG_BPF_STORAGE_REQ_MAP_FD can be specified in
>>> INET_DIAG_REQ_SK_BPF_STORAGES to select which bpf_sk_storage to dump.
>>> If no map_fd is specified, all bpf_sk_storages of a sk will be dumped.
>>>
>>> bpf_sk_storages can be added to the system at runtime.  It is difficult
>>> to find a proper static value for cb->min_dump_alloc.
>>>
>>> This patch learns the nlattr size required to dump the bpf_sk_storages
>>> of a sk.  If it happens to be the very first nlmsg of a dump and it
>>> cannot fit the needed bpf_sk_storages,  it will try to expand the
>>> skb by "pskb_expand_head()".
>>>
>>> Instead of expanding it in inet_sk_diag_fill(), it is expanded at a
>>> sleepable context in __inet_diag_dump() so __GFP_DIRECT_RECLAIM can
>>> be used.  In __inet_diag_dump(), it will retry as long as the
>>> skb is empty and the cb->min_dump_alloc becomes larger than before.
>>> cb->min_dump_alloc is bounded by KMALLOC_MAX_SIZE.  The min_dump_alloc
>>> is also changed from 'u16' to 'u32' to accommodate a sk that may have
>>> a few large bpf_sk_storages.
>>>
>>> The updated cb->min_dump_alloc will also be used to allocate the skb in
>>> the next dump.  This logic already exists in netlink_dump().
>>>
>>> Here is the sample output of a locally modified 'ss' and it could be made
>>> more readable by using BTF later:
>>> [root@arch-fb-vm1 ~]# ss --bpf-map-id 14 --bpf-map-id 13 -t6an 'dst [::1]:8989'
>>> State Recv-Q Send-Q Local Address:Port  Peer Address:PortProcess
>>> ESTAB 0      0              [::1]:51072        [::1]:8989
>>> 	 bpf_map_id:14 value:[ 3feb ]
>>> 	 bpf_map_id:13 value:[ 3f ]
>>> ESTAB 0      0              [::1]:51070        [::1]:8989
>>> 	 bpf_map_id:14 value:[ 3feb ]
>>> 	 bpf_map_id:13 value:[ 3f ]
>>>
>>> [root@arch-fb-vm1 ~]# ~/devshare/github/iproute2/misc/ss --bpf-maps -t6an 'dst [::1]:8989'
>>> State         Recv-Q         Send-Q                   Local Address:Port                    Peer Address:Port         Process
>>> ESTAB         0              0                                [::1]:51072                          [::1]:8989
>>> 	 bpf_map_id:14 value:[ 3feb ]
>>> 	 bpf_map_id:13 value:[ 3f ]
>>> 	 bpf_map_id:12 value:[ 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000... total:65407 ]
>>> ESTAB         0              0                                [::1]:51070                          [::1]:8989
>>> 	 bpf_map_id:14 value:[ 3feb ]
>>> 	 bpf_map_id:13 value:[ 3f ]
>>> 	 bpf_map_id:12 value:[ 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000... total:65407 ]
>>>
>>> Acked-by: Song Liu <songliubraving@fb.com>
>>> Signed-off-by: Martin KaFai Lau <kafai@fb.com>
>>
>> Hmm, the whole approach is not too pleasant to be honest. I can see why you need
>> it since the regular sk_storage lookup only takes sock fd as a key and you don't
>> have it otherwise available from outside, but then dumping up to KMALLOC_MAX_SIZE
>> via netlink skb is not a great experience either. :( Also, are we planning to add
>> the BTF dump there in addition to bpftool? Thus resulting in two different lookup
>> APIs and several tools needed for introspection instead of one? :/ Also, how do we
>> dump task local storage maps in future? Does it need a third lookup interface?
>>
>> In your commit logs I haven't read on other approaches and why they won't work;
>> I was wondering, given sockets are backed by inodes, couldn't we have a variant
>> of iget_locked() (minus the alloc_inode() part from there) where you pass in ino
>> number to eventually get to the socket and then dump the map value associated with
>> it the regular way from bpf() syscall?
> Thanks for the feedback!
> 
> I think (1) dumping all sk(s) in a system is different from
> (2) dumping all sk of a bpf_sk_storage_map or lookup a particular
> sk from a bpf_sk_storage_map.
> 
> This patch is doing (1).  I believe it is useful to make the commonly used
> tools like "ss" (which already shows many useful information of a sk)
> to be able to introspect a kernel struct extended by bpf instead of
> limiting to only the bpftool can show the bpf extended data.
> The plan is to move the bpftool/btf_dumper.c to libbpf.  The libbpf's
> btf_dumper print out format is still TBD and the current target is the drgn
> like format instead of the current semi-json like plain-txt printout.  As
> more kernel struct may be extensible by bpf, having it in libbpf will be
> useful going forward.
> 
> Re: future kernel struct extended by bpf
> For doing (1), I think we can ride on the existing API to iterate them also.
> bpf can extend a kernel struct but should not stop the current
> iteration API from working or seeing them.  That includes the current
> seq_file API.  The mid-term goal is to extend the seq_file by
> attaching a bpf_prog to (e.g. /proc/net/tcp) to do filtering
> and printing.  Yonghong is looking into that.

Right. I am working on a design and prototype to use bpf programs
to dump certain kernel internal data structures. The high level
idea is to create some /sys path to encode "what" to dump, e.g.,
/sys/kernel/bpfdump/tcp6_sockets/ for tcp6_sockets and "add" bpf
program(s) to that path to specify "how" to dump.

I hope to share the design and prototype soon.
