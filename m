Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 825B7170DEE
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 02:35:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728146AbgB0BfR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 20:35:17 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:50946 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727964AbgB0BfR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 20:35:17 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 01R1YxJs027289;
        Wed, 26 Feb 2020 17:35:00 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=Hnom75qaMy4JgV7P7d95ObMgUz2RAWSv5pqB4QSMZ74=;
 b=rJTMTVnVF8MFazayYlMqb+JliTup68fjU9HxJQzeomnQDZ1r44gsURYYui7bEGtcDdLS
 3tsF6wfNtRdOUxEgVRaaIZghubB4Ekqv7IDHa/mRhkAUqWw2IGVEChs0LR5RlTs+n6Th
 LuqJDVkBNJ6BHOVgVAHzspDnzH/bmPl2rRw= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 2ydckpeffa-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 26 Feb 2020 17:35:00 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Wed, 26 Feb 2020 17:34:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T7Szerg4yiCQHuRvMSoX2b+cnlYMPLWGlxBgYwkfAT5qh2KyZZydbqPVZPC58I/IXT2n96f8vK/D10JDwpwLZCK0D2bfS3dH0yZ2POBF88SgXNiCyJlr/FNVCDTWJYai8CbB9T3vejzcGUYcrUnh8JAHz3MWX5B4onx+KyQx74MhIa8MeUgUGsailthHnNyhHmi0dCEHnafv5gJNakuPd7B+q9XWTE5yxGmsyc/KCy4+5UJv+ldCgg+LjfsCKrRnZARFUSsBrBM+5kWaJ97EVPMfVkNVi/pY5PcO8NxxJXwhsGbMzouLIvSD0kRRx0osQFz334o2b0t4TWiKATxE0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hnom75qaMy4JgV7P7d95ObMgUz2RAWSv5pqB4QSMZ74=;
 b=djC1hU9MtBFXnPIBUBpawxj2bLPTXtC1IkIQr2qKwYUs9GqDWfm5O8Nxkdkj0olmI0zaZdO+8DvtZ8S9P5g0OLB75uEo8r/kui3lxMcjbl2D0D5Q6HiIsrspCnThAlDsfBfubSEu9EGY+w9/egCGVt70H0SE9/2cPFrWH13sNvQU2MGo6CZ+FRum+4ekoKpnkwqr1njoy1If+eiFS7HPt480M1hy2j36Aql/on70As//jq6Vk5HmOnQ9Aq6aPg5fAEMfaIGCMOJn4pyi41HzNl8LZhFXQ1K5EMyZG9JePqEIRzCzbuqp7zJaF1XFQLHJFiPjBz6UctVfbQ62Fd7vhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hnom75qaMy4JgV7P7d95ObMgUz2RAWSv5pqB4QSMZ74=;
 b=CaErsow6EiZAeo6KOMtMWVMr2qMBa1hIt6jywbdC9sX78VewiZtqOKQu99PTwfAFhCW3IpwJnBEX2iTU9oTOcusS+KkEec46FPbo8twwG8vIie4vsKOeLl4GhotUSRNsA9zKGbpiLKBrUqpGxfpJLOi0Q9d1z21Q8W8A95f6uXc=
Received: from BYAPR15MB2278.namprd15.prod.outlook.com (2603:10b6:a02:8e::17)
 by BYAPR15MB3351.namprd15.prod.outlook.com (2603:10b6:a03:10c::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.21; Thu, 27 Feb
 2020 01:34:51 +0000
Received: from BYAPR15MB2278.namprd15.prod.outlook.com
 ([fe80::4d5a:6517:802b:5f47]) by BYAPR15MB2278.namprd15.prod.outlook.com
 ([fe80::4d5a:6517:802b:5f47%4]) with mapi id 15.20.2750.021; Thu, 27 Feb 2020
 01:34:50 +0000
Date:   Wed, 26 Feb 2020 17:34:48 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
CC:     <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>, <eric.dumazet@gmail.com>
Subject: Re: [PATCH bpf-next v2 4/4] bpf: inet_diag: Dump bpf_sk_storages in
 inet_diag_dump()
Message-ID: <20200227013448.srxy5kkpve7yheln@kafai-mbp>
References: <20200225230402.1974723-1-kafai@fb.com>
 <20200225230427.1976129-1-kafai@fb.com>
 <938a0461-fd8d-b4b9-4fef-95d46409c0d6@iogearbox.net>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <938a0461-fd8d-b4b9-4fef-95d46409c0d6@iogearbox.net>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: MWHPR22CA0041.namprd22.prod.outlook.com
 (2603:10b6:300:69::27) To BYAPR15MB2278.namprd15.prod.outlook.com
 (2603:10b6:a02:8e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:500::6:ba05) by MWHPR22CA0041.namprd22.prod.outlook.com (2603:10b6:300:69::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.18 via Frontend Transport; Thu, 27 Feb 2020 01:34:49 +0000
X-Originating-IP: [2620:10d:c090:500::6:ba05]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4e77be9a-ffbe-4ede-e83d-08d7bb253cc9
X-MS-TrafficTypeDiagnostic: BYAPR15MB3351:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB3351E3B124489EA4F4ADB3BFD5EB0@BYAPR15MB3351.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:2803;
X-Forefront-PRVS: 03264AEA72
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(136003)(346002)(376002)(39860400002)(366004)(396003)(189003)(199004)(2906002)(316002)(53546011)(52116002)(6496006)(478600001)(54906003)(55016002)(186003)(9686003)(4326008)(1076003)(33716001)(8936002)(81166006)(8676002)(81156014)(5660300002)(16526019)(66476007)(66946007)(6916009)(86362001)(66556008);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3351;H:BYAPR15MB2278.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zSO/CRR1yrdHk0UyBywjNMT5yZ3FxlI1rILKFT0SLpcWW5wP2YJM9hoiDNXu5zG2cmxamwcUYUqXmIeioIDL1eNSH2SQWisYUplSEoJNsiY2tfd4p57aJ3h8x8sCNA1RRk0v2LIQS+72RBKIzVSY7YRzMreLWf5sff67D4y8vZnIaqQqzqx04RDIzedXn+ioLKehiEZiczypIokLU+M4NjjyyyGOoLPZGC/CJbqHlxDAjlLkJlOYA65xjf75LjY/5goJ/D7iJfz6AhWjobmMyPoV9Z7GF4/Zua2Z19ZgIjiZbl4w0FAHdtMpp7ak/lp5zNAm8B0CE+0PZOJgueY8gX37VtiFAi9nxsDnDspTDzDy+r2VKpocRGzc7t0gn5A4v4wximGygxhYxG4gB1qtPMZihNjsFItuFao90a8tjSO2vBJnAcX32nlY7L+NMjQW
X-MS-Exchange-AntiSpam-MessageData: H/IFtVQ5PRwprUj1y8CYZgLo9AaLpssKMrvgBeqtsWdA0zff/secZzHRCKfCPqGHK1gUFhgotRkN1HqS0uYjLzMwwCTVt2SNq6kG7YNOjsESLttPgCLO95CFp0aPUSqXxfN1EnG4H0lqW2KJhTZy5JL4RCndPz1xkncYg077Xk6Qh1BqbL4dKpCh+GWLJmv0
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e77be9a-ffbe-4ede-e83d-08d7bb253cc9
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2020 01:34:50.8291
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: skjGZlG/QqfqcxYWS8/5iN3SPdyx0NuhpcS8OOZxMmqOPvwUIyeLi5tdHbNP94b7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3351
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-26_09:2020-02-26,2020-02-26 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 lowpriorityscore=0 mlxlogscore=999 adultscore=0 priorityscore=1501
 mlxscore=0 malwarescore=0 spamscore=0 impostorscore=0 phishscore=0
 suspectscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2001150001 definitions=main-2002270008
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 26, 2020 at 06:21:33PM +0100, Daniel Borkmann wrote:
> On 2/26/20 12:04 AM, Martin KaFai Lau wrote:
> > This patch will dump out the bpf_sk_storages of a sk
> > if the request has the INET_DIAG_REQ_SK_BPF_STORAGES nlattr.
> > 
> > An array of SK_DIAG_BPF_STORAGE_REQ_MAP_FD can be specified in
> > INET_DIAG_REQ_SK_BPF_STORAGES to select which bpf_sk_storage to dump.
> > If no map_fd is specified, all bpf_sk_storages of a sk will be dumped.
> > 
> > bpf_sk_storages can be added to the system at runtime.  It is difficult
> > to find a proper static value for cb->min_dump_alloc.
> > 
> > This patch learns the nlattr size required to dump the bpf_sk_storages
> > of a sk.  If it happens to be the very first nlmsg of a dump and it
> > cannot fit the needed bpf_sk_storages,  it will try to expand the
> > skb by "pskb_expand_head()".
> > 
> > Instead of expanding it in inet_sk_diag_fill(), it is expanded at a
> > sleepable context in __inet_diag_dump() so __GFP_DIRECT_RECLAIM can
> > be used.  In __inet_diag_dump(), it will retry as long as the
> > skb is empty and the cb->min_dump_alloc becomes larger than before.
> > cb->min_dump_alloc is bounded by KMALLOC_MAX_SIZE.  The min_dump_alloc
> > is also changed from 'u16' to 'u32' to accommodate a sk that may have
> > a few large bpf_sk_storages.
> > 
> > The updated cb->min_dump_alloc will also be used to allocate the skb in
> > the next dump.  This logic already exists in netlink_dump().
> > 
> > Here is the sample output of a locally modified 'ss' and it could be made
> > more readable by using BTF later:
> > [root@arch-fb-vm1 ~]# ss --bpf-map-id 14 --bpf-map-id 13 -t6an 'dst [::1]:8989'
> > State Recv-Q Send-Q Local Address:Port  Peer Address:PortProcess
> > ESTAB 0      0              [::1]:51072        [::1]:8989
> > 	 bpf_map_id:14 value:[ 3feb ]
> > 	 bpf_map_id:13 value:[ 3f ]
> > ESTAB 0      0              [::1]:51070        [::1]:8989
> > 	 bpf_map_id:14 value:[ 3feb ]
> > 	 bpf_map_id:13 value:[ 3f ]
> > 
> > [root@arch-fb-vm1 ~]# ~/devshare/github/iproute2/misc/ss --bpf-maps -t6an 'dst [::1]:8989'
> > State         Recv-Q         Send-Q                   Local Address:Port                    Peer Address:Port         Process
> > ESTAB         0              0                                [::1]:51072                          [::1]:8989
> > 	 bpf_map_id:14 value:[ 3feb ]
> > 	 bpf_map_id:13 value:[ 3f ]
> > 	 bpf_map_id:12 value:[ 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000... total:65407 ]
> > ESTAB         0              0                                [::1]:51070                          [::1]:8989
> > 	 bpf_map_id:14 value:[ 3feb ]
> > 	 bpf_map_id:13 value:[ 3f ]
> > 	 bpf_map_id:12 value:[ 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000... total:65407 ]
> > 
> > Acked-by: Song Liu <songliubraving@fb.com>
> > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> 
> Hmm, the whole approach is not too pleasant to be honest. I can see why you need
> it since the regular sk_storage lookup only takes sock fd as a key and you don't
> have it otherwise available from outside, but then dumping up to KMALLOC_MAX_SIZE
> via netlink skb is not a great experience either. :( Also, are we planning to add
> the BTF dump there in addition to bpftool? Thus resulting in two different lookup
> APIs and several tools needed for introspection instead of one? :/ Also, how do we
> dump task local storage maps in future? Does it need a third lookup interface?
> 
> In your commit logs I haven't read on other approaches and why they won't work;
> I was wondering, given sockets are backed by inodes, couldn't we have a variant
> of iget_locked() (minus the alloc_inode() part from there) where you pass in ino
> number to eventually get to the socket and then dump the map value associated with
> it the regular way from bpf() syscall?
Thanks for the feedback!

I think (1) dumping all sk(s) in a system is different from
(2) dumping all sk of a bpf_sk_storage_map or lookup a particular
sk from a bpf_sk_storage_map.

This patch is doing (1).  I believe it is useful to make the commonly used
tools like "ss" (which already shows many useful information of a sk)
to be able to introspect a kernel struct extended by bpf instead of
limiting to only the bpftool can show the bpf extended data.
The plan is to move the bpftool/btf_dumper.c to libbpf.  The libbpf's
btf_dumper print out format is still TBD and the current target is the drgn
like format instead of the current semi-json like plain-txt printout.  As
more kernel struct may be extensible by bpf, having it in libbpf will be
useful going forward.

Re: future kernel struct extended by bpf
For doing (1), I think we can ride on the existing API to iterate them also.
bpf can extend a kernel struct but should not stop the current
iteration API from working or seeing them.  That includes the current
seq_file API.  The mid-term goal is to extend the seq_file by
attaching a bpf_prog to (e.g. /proc/net/tcp) to do filtering
and printing.  Yonghong is looking into that.

Re: lookup a bpf_sk_storage_map by socket fd and KMALLOC_MAX_SIZE
In my config,
sizeof(tcp_sock) is    2076
1 MAX sk_storage is   65407 (31x of a tcp_sock)
KMALLOC_MAX_SIZE is 4194304 (2000x of a tcp_sock)

It is a lot of data to extend on a tcp_sock.
The total bpf_sk_storages that a sk could have is further bounded by
net.core.optmem_max.  It is a very unusual setup to have a sk
that has so many bpf_sk_storage data that a skb cannot
accommodate.

That said, the current sk_storage_update() does not limit the total
bpf_sk_storages of a sk to KMALLOC_MAX_SIZE.

I think this limit could be added to the update side now and the chance
of breaking is very minimal.

or the netlink can return map_id only when the max-sized skb cannot fit
all the bpf_sk_storages.  The userspace then do another syscall to
lookup the data from each individual bpf_sk_storage_map and
that requires to lookup side support with another key (non-fd).
IMO, it is weird and a bit opposite of what bpf_sk_storage should be (fast
bpf_sk_storage lookup while holding a sk).  The iteration API already
holds the sk but instead it is asking the usespace to go back to find
out the sk again in order to get the bpf_sk_storages.  I think that
should be avoided if possible.

Regarding i_ino, after looking at sock_alloc() and get_next_ino(),
hmmm...is it unique?
If it is, what is the different usecase between i_ino and
sk->sk_cookie?
