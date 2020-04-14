Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 552AB1A8A05
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 20:47:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504295AbgDNSpM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 14:45:12 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:46726 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2504270AbgDNSpJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 14:45:09 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03EIPU9b005547;
        Tue, 14 Apr 2020 11:44:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=NCVv9NsfFAzPENYO0w2C1k8MAYaDk4CbJI9enJhIS+0=;
 b=h1mOiBPEJkTKoYdA+G7Vap6N7KRvyWN46pI44up2efAc55WCJDXBHfsxZdQINUR2KPVy
 HJcX2NZvyThZOtc/rS86MDP1TRLZItEfI/6iO8euQIScF/zCK/1g7NFMEcu48JpdVlPi
 f/mUFR8/nikihHRFMMQdFr1ytMptrmIc9ME= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 30bwq7brak-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 14 Apr 2020 11:44:49 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 14 Apr 2020 11:43:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n8mcpF3MjKgWDMlSs9XXUx8eE2Hp5lj9ZPSwYDhUBUCXpGnLEuZIxcuoiNVeE5o0B83hS8l4/S8fNgd+XtiBy6YznyW4d+CgjGCwRrroc/cuTtJOVwHfYRd7umZc4lo1IxtOVfyr5w7t1HOWGjFQ6C6J1GvgLFSGt5fwvSZa/5otRmeox1ZKrbyiYOb/2IeXKL7tmV8J75jNwD3CyeLNOByiCmEzLzhIjMqUWcxDT6s/uZ5IwK5W6cm9ptScBLEj/PMkOVLn4xH8U7uQ9nzYF4y5p0VNenGRyrvQl7tjqU4V+YqJtsVUZ5WDt6u2aDSNE3DpduWr9Q3gSEhWovEJAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NCVv9NsfFAzPENYO0w2C1k8MAYaDk4CbJI9enJhIS+0=;
 b=kJnQfuuS6tHKVeLpz4UjsrzrgSJP3OwnozAj7ads0obkiHdIw3+gNRiupSzzPCsx2zBvHqErkAvokmBPAu3JQJMA+UaalTu+fuaAehGJCRnsjOI9Hgy+6HAi+VYMSN/h49AAOwOF1XADtxZJ5qO94h6pCpVPVl0vmmXEGFsi1buExRNxngrxL6VKE+bDubA7u4IagSHST6xnXvX3Cr+0B1q/rzPVUTL5JEpY0l3Zl5yEtTT/m83XDsz3pRg5FsOFdry2nav+zy2B9Kht7xHudv3B+jw2HT/QfnH5Gd9XL3cwkSXbxp9ohJpHE4rEBlu8Bz7TAzU3rOG1tzHCMqQohQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NCVv9NsfFAzPENYO0w2C1k8MAYaDk4CbJI9enJhIS+0=;
 b=evdXn2imEdoRNh8w7cpUORu3oFL87ma7ouagBr3H/qk4BAxJ8HfzZyrQdBmoJdZ9J/M62BfRydFJ+ShLY+G8TwxGGv1Q/2Sl5xYI5F2tgEHXpQmRUlte8CwN2XXoL4VpRgmWVeCyNpdeRigSANmdK80lyX3hP+a0ai2ovZ/5akw=
Received: from BYAPR15MB4119.namprd15.prod.outlook.com (2603:10b6:a02:cd::20)
 by BYAPR15MB2758.namprd15.prod.outlook.com (2603:10b6:a03:14d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.25; Tue, 14 Apr
 2020 18:43:28 +0000
Received: from BYAPR15MB4119.namprd15.prod.outlook.com
 ([fe80::90d6:ec75:fde:e992]) by BYAPR15MB4119.namprd15.prod.outlook.com
 ([fe80::90d6:ec75:fde:e992%7]) with mapi id 15.20.2900.028; Tue, 14 Apr 2020
 18:43:28 +0000
Date:   Tue, 14 Apr 2020 11:43:26 -0700
From:   Andrey Ignatov <rdna@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH v2 bpf-next] libbpf: always specify expected_attach_type
 on program load if supported
Message-ID: <20200414184326.GA59623@rdna-mbp>
References: <20200414045613.2104756-1-andriin@fb.com>
 <20200414175608.GB54710@rdna-mbp>
 <CAEf4BzbM4-PvOgro-SjHx6h2ndYndSNkbQTA6xq74W=PuPTpjA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAEf4BzbM4-PvOgro-SjHx6h2ndYndSNkbQTA6xq74W=PuPTpjA@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-ClientProxiedBy: MWHPR12CA0048.namprd12.prod.outlook.com
 (2603:10b6:301:2::34) To BYAPR15MB4119.namprd15.prod.outlook.com
 (2603:10b6:a02:cd::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2620:10d:c090:400::5:895e) by MWHPR12CA0048.namprd12.prod.outlook.com (2603:10b6:301:2::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.24 via Frontend Transport; Tue, 14 Apr 2020 18:43:28 +0000
X-Originating-IP: [2620:10d:c090:400::5:895e]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7c6ade3d-0102-45f0-c2ef-08d7e0a3b90b
X-MS-TrafficTypeDiagnostic: BYAPR15MB2758:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB27584DCBB3C38DB9C3CD8F52A8DA0@BYAPR15MB2758.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:1169;
X-Forefront-PRVS: 0373D94D15
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4119.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(7916004)(346002)(39860400002)(366004)(396003)(136003)(376002)(316002)(16526019)(186003)(6916009)(4326008)(54906003)(9686003)(6496006)(66946007)(33716001)(66556008)(66476007)(52116002)(53546011)(6486002)(5660300002)(478600001)(1076003)(33656002)(81156014)(8936002)(86362001)(2906002)(8676002);DIR:OUT;SFP:1102;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Wo0gwYdH66LjWnbA4WoGYrzpDkkTPxUvqhhu/8o41bv+EGj6ibETnKUU0Jx9J1O8fEL5ikPLKOMx2C4hwASc5JAMfGtaIgLxEsZLjNPmZLYbIxMsmxHn18MMlIf/j23PUN0qhomBxXUT0KxpP63Rn+uIxwps63zsc7oeoUaaH4M9X6cU5T8WhET5pzj/jvyt73sJZVxswfmrHA02QlGGJS/1o4dZ85vvRDheqAcuwyJBtEOk0FYAje5Z02r4/lOGuIgeHcd8Id5zyzzRS97EvC7MIjggK7+8PYL+CaoDUdjZif5uEqb53ml5eZQuIOkKawqXRVqxb08VHs+kM5vGHwUU8TVwqaenQ/W8Y25ocutfUOG3Jzn+DfY8xSAIpnQkYWWOzS4ku/hzQvuhNd+aagL8KTj3It3Pfg9Ceye0DrkCHcJA3xTeA58wDu3/ZjEe
X-MS-Exchange-AntiSpam-MessageData: CWZhRJzv+mtXUSRA31TcaTZf8DDDnoPGSO4Ynx7Qh/lVpYvKbNh4WYZQ1rncZkRQn52caoPvBejEwr7Q9JO0d0bf4yIic5G0RA6JuPbyonRNji6zF7kMQNv02GhdQKSV0S+88DuXH3LhMkkyfNrR3+o9DVVaUbF4apPBj4RKs1F6lHZBs/rkAgxP6HPNO7Ex
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c6ade3d-0102-45f0-c2ef-08d7e0a3b90b
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2020 18:43:28.6860
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: shur0Swpw13PnUBZRC60As3cbE+xi251hmM6e1oEzNEbf32RdnugVVWgsFC27c6Y
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2758
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-14_09:2020-04-14,2020-04-14 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 phishscore=0 bulkscore=0 lowpriorityscore=0 priorityscore=1501
 malwarescore=0 clxscore=1015 adultscore=0 spamscore=0 impostorscore=0
 mlxlogscore=999 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004140132
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> [Tue, 2020-04-14 11:25 -0700]:
> On Tue, Apr 14, 2020 at 10:56 AM Andrey Ignatov <rdna@fb.com> wrote:
> >
> > Andrii Nakryiko <andriin@fb.com> [Mon, 2020-04-13 21:56 -0700]:

...

> > > v1->v2:
> > > - fixed prog_type/expected_attach_type combo (Andrey);
> > > - added comment explaining what we are doing in probe_exp_attach_type (Andrey).
> >
> > Thanks for changes.
> >
> > I built the patch (removing the double .sec Song mentioned since it
> > breaks compilation) and tested it: it fixes the problem with NET_XMIT_CN
> 
> Wait, what? How does it break compilation? I compiled and tested
> before submitting and just cleaned and built again, no compilation
> errors or even warnings. Can you share compilation error you got,
> please?

Sure:

	11:37:28 1 rdna@dev082.prn2:~/bpf-next$>/home/rdna/bin/clang --version
	clang version 9.0.20190721
	Target: x86_64-unknown-linux-gnu
	Thread model: posix
	InstalledDir: /home/rdna/bin
	11:37:32 0 rdna@dev082.prn2:~/bpf-next$>env GCC=~/bin/gcc CLANG=~/bin/clang CC=~/bin/clang LLC=~/bin/llc LLVM_STRIP=~/bin/llvm-strip  make V=1 -C tools/bpf/bpftool/
	
	Auto-detecting system features:
	...                        libbfd: [ on  ]
	...        disassembler-four-args: [ OFF ]
	...                          zlib: [ on  ]
	...          clang-bpf-global-var: [ on  ]
	
	make: Entering directory `/home/rdna/bpf-next/tools/bpf/bpftool'
	make -C /home/rdna/bpf-next/tools/lib/bpf/ OUTPUT= libbpf.a
	make[1]: Entering directory `/home/rdna/bpf-next/tools/lib/bpf'
	make -f /home/rdna/bpf-next/tools/build/Makefile.build dir=. obj=libbpf OUTPUT=staticobjs/
	  /home/rdna/bin/clang -Wp,-MD,staticobjs/.libbpf.o.d -Wp,-MT,staticobjs/libbpf.o -g -Wall -DHAVE_LIBELF_MMAP_SUPPORT -DCOMPAT_NEED_REALLOCARRAY -Wbad-function-cast -Wdeclaration-after-statement -Wformat-security -Wformat-y2k -Winit-self -Wmissing-declarations -Wmissing-prototypes -Wnested-externs -Wno-system-headers -Wold-style-definition -Wpacked -Wredundant-decls -Wstrict-prototypes -Wswitch-default -Wswitch-enum -Wundef -Wwrite-strings -Wformat -fno-strict-aliasing -Wno-shadow -Werror -Wall -fPIC -I. -I/home/rdna/bpf-next/tools/include -I/home/rdna/bpf-next/tools/arch/x86/include/uapi -I/home/rdna/bpf-next/tools/include/uapi -fvisibility=hidden -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D"BUILD_STR(s)=#s" -c -o staticobjs/libbpf.o libbpf.c
	libbpf.c:6329:15: error: initializer overrides prior initialization of this subobject [-Werror,-Winitializer-overrides]
	        BPF_PROG_SEC("socket",                  BPF_PROG_TYPE_SOCKET_FILTER),
	                     ^~~~~~~~
	libbpf.c:6291:55: note: expanded from macro 'BPF_PROG_SEC'
	#define BPF_PROG_SEC(string, ptype) BPF_PROG_SEC_IMPL(string, ptype, 0, 0, 0, 0)
	                                                      ^~~~~~
	libbpf.c:6283:10: note: expanded from macro 'BPF_PROG_SEC_IMPL'
	                .sec = string,                                              \
	                       ^~~~~~
	libbpf.c:6329:15: note: previous initialization is here
	        BPF_PROG_SEC("socket",                  BPF_PROG_TYPE_SOCKET_FILTER),
	                     ^~~~~~~~
	libbpf.c:6291:55: note: expanded from macro 'BPF_PROG_SEC'
	#define BPF_PROG_SEC(string, ptype) BPF_PROG_SEC_IMPL(string, ptype, 0, 0, 0, 0)
	                                                      ^~~~~~
	libbpf.c:6280:10: note: expanded from macro 'BPF_PROG_SEC_IMPL'
	                .sec = string,                                              \
	                       ^~~~~~
	libbpf.c:6330:15: error: initializer overrides prior initialization of this subobject [-Werror,-Winitializer-overrides]
	        BPF_PROG_SEC("sk_reuseport",            BPF_PROG_TYPE_SK_REUSEPORT),
	                     ^~~~~~~~~~~~~~
	libbpf.c:6291:55: note: expanded from macro 'BPF_PROG_SEC'
	#define BPF_PROG_SEC(string, ptype) BPF_PROG_SEC_IMPL(string, ptype, 0, 0, 0, 0)
	                                                      ^~~~~~
	libbpf.c:6283:10: note: expanded from macro 'BPF_PROG_SEC_IMPL'
	                .sec = string,                                              \
	                       ^~~~~~
	libbpf.c:6330:15: note: previous initialization is here
	        BPF_PROG_SEC("sk_reuseport",            BPF_PROG_TYPE_SK_REUSEPORT),
	                     ^~~~~~~~~~~~~~
	libbpf.c:6291:55: note: expanded from macro 'BPF_PROG_SEC'
	#define BPF_PROG_SEC(string, ptype) BPF_PROG_SEC_IMPL(string, ptype, 0, 0, 0, 0)
	                                                      ^~~~~~
	libbpf.c:6280:10: note: expanded from macro 'BPF_PROG_SEC_IMPL'
	                .sec = string,                                              \
	                       ^~~~~~
	
	... and so on ...
	
	fatal error: too many errors emitted, stopping now [-ferror-limit=]
	20 errors generated.
	   ld -r -o staticobjs/libbpf-in.o  staticobjs/libbpf.o staticobjs/bpf.o staticobjs/nlattr.o staticobjs/btf.o staticobjs/libbpf_errno.o staticobjs/str_error.o staticobjs/netlink.o staticobjs/bpf_prog_linfo.o staticobjs/libbpf_probes.o staticobjs/xsk.o staticobjs/hashmap.o staticobjs/btf_dump.o
	ld: cannot find staticobjs/libbpf.o: No such file or directory
	make[2]: *** [staticobjs/libbpf-in.o] Error 1
	make[1]: *** [staticobjs/libbpf-in.o] Error 2
	make[1]: Leaving directory `/home/rdna/bpf-next/tools/lib/bpf'
	make: *** [/home/rdna/bpf-next/tools/lib/bpf/libbpf.a] Error 2
	make: Leaving directory `/home/rdna/bpf-next/tools/bpf/bpftool'
	11:37:43 2 rdna@dev082.prn2:~/bpf-next$>

> > I guess we can deal with selftest separately in the original thread.
> 
> Sure, if this is going to be applied to bpf as a fix, I'd rather
> follow-up with selftests separately.

Sounds good.

> > Also a question about bpf vs bpf-next: since this fixes real problem
> > with loading cgroup skb programs, should it go to bpf tree instead?
> 
> It will be up to maintainers, it's not so clear whether it's a new
> feature or a bug fix.. I don't mind either way.

Sounds good. Thanks.

-- 
Andrey Ignatov
