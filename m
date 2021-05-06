Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1127D374EE6
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 07:32:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232097AbhEFFdT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 01:33:19 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:18654 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229622AbhEFFdR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 May 2021 01:33:17 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1465VdRr025000;
        Wed, 5 May 2021 22:32:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 content-transfer-encoding : mime-version; s=facebook;
 bh=d5ETYBYi2tvK35V4+VhhDX3RPSc1MvycNaai912xSZ4=;
 b=Iz3sUVCal6YTqXiWMMfjM5TGc/KdEXf5X4l4ehZL5kQcFfaj+t3nXPD9nxj9Bex59RZv
 fKFPbGrgeOAKpJCMv/IUgTQYPpJwLrpZQyhEkB8crbFmrOzkOwehFbuwvl+noIubjDlj
 e452I+ehxh1jGwPK7HEcVbzc95an8C4L0ZA= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 38c5j3h3rj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 05 May 2021 22:32:00 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 5 May 2021 22:31:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fsXo+zANMsSCWk18V/3zJqEAwKq+UzMJOGtS8u+QywrS08zPd0Stk1IrjwGIVgMEV87UI2eL4W+cB3QdbztYSclSxpQCLXS5s1iQ13uHoOfME7LPpmrAKWw4ipVRqxaV8WdjA/AqGPkkNlaKrp5Jp1zXuL5r9iD9bizji0K+968S77TkWEW4qZuBDjL4OQ3L+b2lPTb3v/BJaU5O+J06NrdZ04uATlPyk+UomNtVAC/5/+5i4fzx8sBTdBfPzX5tZEAE+PmkwFNN2+hOb/85IRF8nCcZWsm+0fNBHVNOg7KePkaFDmh8LGn5VBqRCXKtUMhzbOsoEL+a2+vrCmlvxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yoQcSEwGzIThTchpePLiK7anexj2a3mIRWn8L7V9rIo=;
 b=lWFYIid2wp4gSQoi3fiK072qBeaCbPMFN0Qkfkt/tzL2JlXQrbSyjl0fEBORXsOxBGy90YS1hgAwrPhldJuzqA1xhdiBy92BUqg0krRN/uxpAgUAgOkJ5q5mKvfifp396CHMntYARSi3F8fvbHYvRPBqXqVrnewW/fnLQW6tue9sauIQlYnDnF0Dl8/WoXttNQo4dyd1RcEUH98DZ6OEHybStSLmAp4VgSYqQerbe1iFM8w+styy8VSqrAq50aw9DOn/CQ08fxQD+AV7PptcS7ixb0IzF8D5e/TNhoJPAksa1pxE+tJgyK3QiIiiF+Kfj+4v3H5Tj7box/ZUYJ9Obg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB3047.namprd15.prod.outlook.com (2603:10b6:a03:f8::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.27; Thu, 6 May
 2021 05:31:57 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::718a:4142:4c92:732f]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::718a:4142:4c92:732f%6]) with mapi id 15.20.4108.026; Thu, 6 May 2021
 05:31:56 +0000
Date:   Wed, 5 May 2021 22:31:52 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Jiri Slaby <jirislaby@kernel.org>
CC:     Jiri Olsa <jolsa@redhat.com>,
        Michal =?utf-8?B?U3VjaMOhbmVr?= <msuchanek@suse.de>,
        Yonghong Song <yhs@fb.com>, <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, Jiri Olsa <jolsa@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        <dwarves@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: linux-next failing build due to missing cubictcp_state symbol
Message-ID: <20210506053152.e5rnv44zsitob3sn@kafai-mbp.dhcp.thefacebook.com>
References: <YIbkR6z6mxdNSzGO@krava>
 <YIcRlHQWWKbOlcXr@krava>
 <20210427121237.GK6564@kitsune.suse.cz>
 <20210430174723.GP15381@kitsune.suse.cz>
 <3d148516-0472-8f0a-085b-94d68c5cc0d5@suse.com>
 <6c14f3c8-7474-9f3f-b4a6-2966cb19e1ed@kernel.org>
 <4e051459-8532-7b61-c815-f3435767f8a0@kernel.org>
 <cbaf50c3-c85d-9239-0b37-c88e8cbed8c8@kernel.org>
 <YI/LgjLxo9VCN/d+@krava>
 <8c3cbd22-eb26-ea8b-c8bb-35a629d6d2d8@kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <8c3cbd22-eb26-ea8b-c8bb-35a629d6d2d8@kernel.org>
X-Originating-IP: [2620:10d:c090:400::5:910f]
X-ClientProxiedBy: MW4PR03CA0046.namprd03.prod.outlook.com
 (2603:10b6:303:8e::21) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:910f) by MW4PR03CA0046.namprd03.prod.outlook.com (2603:10b6:303:8e::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.24 via Frontend Transport; Thu, 6 May 2021 05:31:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6f7e755f-1101-485c-0e66-08d91050435f
X-MS-TrafficTypeDiagnostic: BYAPR15MB3047:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB30478C441E367B4AE3E146C2D5589@BYAPR15MB3047.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IC1GmI//H+l5Fqau1OKdH3Nmcd922hAtF4e6OyWyLIbVfadDItTAWhzXS2j4smF1ak4UP9S+6GKOth12ClA7jccMmFPF5qb2GtlfUJF3DYpZorvoxq8voXvM/djdC2Kg71F8fhvnS9E1tzU0gqB4EAeqLxLKMJvWGKxbX49080YCgshtW2TuXbxzOgnd/Rgq2eB3nV2ZRv9nLphut/8NAA8w/z61wMaV/2DUkkdFSjnBhFwZe6hJFwdGpW/8kcMugRbTzXCQN7IxDvDaWMAXbv8IbXWrzxKSHxIhF5/avTQtR2d4x2mOaqncpQiNtH7GH5P8xWhVVAbQnYcikb2bUEX9PURV+meBtseOUyPtGzCYEKtg1dXQnFA9IJd0/SmJOqCmeDRmBXnfNdh6a2GnF3sKsS1c9HjJAlwi85a8dhcSYvUt4/5YNv9Yhzd6XQtMY8EVQ8yTg7hBxgC3+mIR/7URwK1ShxJs5aEXI0n+2mJ2wuQUYem0s0bICwE/gJTUVVNeMcxPYSdUBeZMzmLPC6i416qZkCpTePGVUUd0writLuf5nnA9jpOvhDGy0TUnForS2ZB6IGKw/jdItt7VgovLkeL024O4CSMgkEPd2PNslY0wKdZhWfHVdhufYfnTbpOi+zPUTgltrWO0d6OjSybpUNFQgRLJ2VZ+S30DaZU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(346002)(136003)(39860400002)(376002)(83380400001)(66556008)(66476007)(66946007)(55016002)(2906002)(86362001)(4326008)(316002)(54906003)(52116002)(9686003)(7696005)(6506007)(5660300002)(8936002)(478600001)(6916009)(966005)(8676002)(16526019)(38100700002)(7416002)(1076003)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?iso-8859-1?Q?B+QPji5DT+3s1RG4gAT3KhBshZQiBAZy50J6Tb/gNahCydr4h8P3Z89XwA?=
 =?iso-8859-1?Q?yp4Faaz5jtUbq0cMOehYfYp5/57UnbvjR6FxfE+g0oTXUfGL3RZJs2n9kE?=
 =?iso-8859-1?Q?66X27tY59udT7ieG31NqP7MzjVoc2QwIKezLo4X3PG20t4FAnT4nayQBpO?=
 =?iso-8859-1?Q?im/rNYFZktk24RsqrqyUyYgTevc6SZepStc4Fh0J576UuqhelJo9xVhZMy?=
 =?iso-8859-1?Q?JaiwyleHq5dOf2MAllKR/50HttiiisdJ+Z7XCvDMvvmzLh7oum2bqwclqN?=
 =?iso-8859-1?Q?kNFQmo7B7rn6jTOQGeJJrHP8ZLWRScspV2LAzt7PllsFU4j26rx9Fpv4E2?=
 =?iso-8859-1?Q?OZEBbvnuZ9Yzh7BTIUHtp8QKQwVI/dPy3R3GmWoCwN0P7I7Qo+Yd3T4Wto?=
 =?iso-8859-1?Q?vBtDF488RgBYAXrKNxwJ/0GxyIROwY7PdtlchqJzeJUOFhUM7k6wWTo/RN?=
 =?iso-8859-1?Q?pY3/Npo2lI+2+6t7p4zFdxXF+C8GvEyRmPB6+bGQB5x+/6dXGt7J63kT2U?=
 =?iso-8859-1?Q?HW8wsaCtTLFqpjZ2r1S+cewywIOlM/RMC0J1wVepzx+jwpbcCqQenbx4vY?=
 =?iso-8859-1?Q?iFqUtK8novbNcRRg111npEBHvl6kzTuIwKXrgYUyj+JU0p2XeJIfsR1cz9?=
 =?iso-8859-1?Q?JI7ONY4grhHolFxh6sEUgHvuNOoH9oiJDeV2Vlv4o1q52GWjBpDhh8pUsz?=
 =?iso-8859-1?Q?IhiNQNVYjVl5zxVxLuPIREz4rEHBqXILC37TSFnr1PVKfoqF0bqahF/FW7?=
 =?iso-8859-1?Q?+3cZ6r6hJnboJPzR5eZLHsB3o/TRghqZ/u0AjmpoUVZl5UpxIC7hqEzZrJ?=
 =?iso-8859-1?Q?6X5z/BPzim5EW0x8BB9kNCexmZ+PtuKEWlZO3BlrLX0Ru92AEdGHMpZtub?=
 =?iso-8859-1?Q?FBn9Uuxjs62v9zB2FsZqv524EgzwbQy8Ea5z/nfcA+czZlU9L76hO8Dkp7?=
 =?iso-8859-1?Q?KbVuVCxvhnyMi90JbpAtEQNhU+VwwI8XYKJ9UsAeV3Dn1WACmkbDWWGqzo?=
 =?iso-8859-1?Q?IixEP7Jea8WQ0jcaQYtlp6nfHhoIY8eE12YGJRhO/JhvV2oT+fxQ19Nv21?=
 =?iso-8859-1?Q?3Ll7oxJRcnf+52fMpf8QslPn9zmpg1bHqJT8wQrGEKoxYcav70/CEujZE4?=
 =?iso-8859-1?Q?WHueW6YitIJAf2vUFOISmdZB3Lh9+d8pUHDWwopcSBh3MDsPQyGGlGs1gF?=
 =?iso-8859-1?Q?a9+FicdKU/YJ8k1GVbwJtw/HTy8BO19cCsRB9Z2q0VZ77ILr396d981zFf?=
 =?iso-8859-1?Q?DXywKgJE9zSRbmqMpf35y+MNBWA2Ugq9uUcNlhDBud7H+kuTocmTghIcxo?=
 =?iso-8859-1?Q?zeVujG8wKRuq4Yb2GcaOjVOuM9378fJJTtNkmig/lxa0bQrYmCJ5zyAg9b?=
 =?iso-8859-1?Q?tTQVcNSVO2jUKx1YmakR8M2r2TKE++Nw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f7e755f-1101-485c-0e66-08d91050435f
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2021 05:31:56.4666
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nRb88oKV2Kn0A3meuAgNEphPyLTiulA3ddVmWu7BHaVfgY9n93ie57iLgOD1sYpc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3047
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: WZexhsKT_IrW7otgmzAqYXFDFkoUMfQw
X-Proofpoint-ORIG-GUID: WZexhsKT_IrW7otgmzAqYXFDFkoUMfQw
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-06_03:2021-05-05,2021-05-06 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 lowpriorityscore=0 spamscore=0 mlxlogscore=575 priorityscore=1501
 suspectscore=0 bulkscore=0 impostorscore=0 clxscore=1011 phishscore=0
 mlxscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2105060036
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 04, 2021 at 08:41:47AM +0200, Jiri Slaby wrote:
> On 03. 05. 21, 12:08, Jiri Olsa wrote:
> > On Mon, May 03, 2021 at 10:59:44AM +0200, Jiri Slaby wrote:
> > > CCing pahole people.
> > > 
> > > On 03. 05. 21, 9:59, Jiri Slaby wrote:
> > > > On 03. 05. 21, 8:11, Jiri Slaby wrote:
> > > > > > > > > > looks like vfs_truncate did not get into BTF data,
> > > > > > > > > > I'll try to reproduce
> > > > > > 
> > > > > > _None_ of the functions are generated by pahole -J from
> > > > > > debuginfo on ppc64. debuginfo appears to be correct. Neither
> > > > > > pahole -J fs/open.o works correctly. collect_functions in
> > > > > > dwarves seems to be defunct on ppc64... "functions" array is
> > > > > > bogus (so find_function -- the bsearch -- fails).
> > > > > 
> > > > > It's not that bogus. I forgot an asterisk:
> > > > > > #0  find_function (btfe=0x100269f80, name=0x10024631c
> > > > > > "stream_open") at
> > > > > > /usr/src/debug/dwarves-1.21-1.1.ppc64/btf_encoder.c:350
> > > > > > (gdb) p (*functions)@84
> > > > > > $5 = {{name = 0x7ffff68e0922 ".__se_compat_sys_ftruncate", addr
> > > > > > = 75232, size = 72, sh_addr = 65536, generated = false}, {
> > > > > >      name = 0x7ffff68e019e ".__se_compat_sys_open", addr = 80592,
> > > > > > size = 216, sh_addr = 65536, generated = false}, {
> > > > > >      name = 0x7ffff68e0076 ".__se_compat_sys_openat", addr =
> > > > > > 80816, size = 232, sh_addr = 65536, generated = false}, {
> > > > > >      name = 0x7ffff68e0908 ".__se_compat_sys_truncate", addr =
> > > > > > 74304, size = 100, sh_addr = 65536, generated = false}, {
> > > > > ...
> > > > > >      name = 0x7ffff68e0808 ".stream_open", addr = 65824, size =
> > > > > > 72, sh_addr = 65536, generated = false}, {
> > > > > ...
> > > > > >      name = 0x7ffff68e0751 ".vfs_truncate", addr = 73392, size =
> > > > > > 544, sh_addr = 65536, generated = false}}
> > > > > 
> > > > > The dot makes the difference, of course. The question is why is it
> > > > > there? I keep looking into it. Only if someone has an immediate
> > > > > idea...
> > > > 
> > > > Well, .vfs_truncate is in .text (and contains an ._mcount call). And
> > > > vfs_truncate is in .opd (w/o an ._mcount call). Since setup_functions
> > > > excludes all functions without the ._mcount call, is_ftrace_func later
> > > > returns false for such functions and they are filtered before the BTF
> > > > processing.
> > > > 
> > > > Technically, get_vmlinux_addrs looks at a list of functions between
> > > > __start_mcount_loc and __stop_mcount_loc and considers only the listed.
> > > > 
> > > > I don't know what the correct fix is (exclude .opd functions from the
> > > > filter?). Neither why cross compiler doesn't fail, nor why ebi v2 avoids
> > > > this too.
> > > 
> > > Attaching a patch for pahole which fixes the issue, but I have no idea
> > > whether it is the right fix at all.
> > 
> > hi,
> > we're considering to disable ftrace filter completely,
> > I guess that would solve this issue for ppc as well
> > 
> >    https://lore.kernel.org/bpf/20210501001653.x3b4rk4vk4iqv3n7@kafai-mbp.dhcp.thefacebook.com/
> 
> Right, the attached patch fixes it for me too.
Ah, I just noticed the attachment while replying an earlier message in
this thread.

Please feel free to add SOB to mine or
repost yours and toss mine.  Either way works for me.
