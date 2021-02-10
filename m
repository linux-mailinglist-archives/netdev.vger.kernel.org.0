Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E28EB317252
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 22:26:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233454AbhBJV0a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 16:26:30 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:16580 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232132AbhBJVYY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 16:24:24 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11AL83Nj012685;
        Wed, 10 Feb 2021 13:23:26 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=TRdP5b88P3ZlLPYJhuzO1k8jJZEk+R2ZP7paWBVU0e0=;
 b=XVd0LcTuoaXsVn+psZj9J3LuR2axwxUG5oo1bavjsE4UhZE3VMqw4THHhYaglmrgDzKV
 ipTn+oxBXySke1hNShZ19fXw9sCMstGcOZjP1HV6qFNcYvstmGtgX3/LeuGD4/uej1hh
 rYoJA/QHWBmFRKeBaExMp1t81zhGnPnwQwU= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 36jc1cm9dq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 10 Feb 2021 13:23:26 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 10 Feb 2021 13:23:25 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DcjPlTVd4Vrh9Peb3wDhhAH2zSxW5EnE9DaUE6E0U7T1ZSK1xJTRvLFPopV22CngBSGx8qGURLcmMHKXfxe7v5Q8vdr8xFE8YYz4n/uZ+cM1PxcCWDBJYBtpt2luwkto3ZHBm42oMpg1E4g1asBUgKzwis51UTT+BZH677YwXtA7E+RvpO4HTKmVRwEa77Jbe5dYQTIS5UzQnhR4e2X2U4UaUa2QAjlTMMa+/wH2ga6g566If6HCYPjPUT9iEFUjPrayErOTYiaHdAxsTB8Bym1LGZdzmniJKAte7kuZ4Fe+kJaW61qpMWgZkUxYczP7Wq869QgfHzpo/UZx49r22g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TRdP5b88P3ZlLPYJhuzO1k8jJZEk+R2ZP7paWBVU0e0=;
 b=XWADPa7Nk9di2Tu+6loTUJ18XAFJJxzUhpsDRcg0vuZslDnFEZkwkeXznTk9cQJrNnDNytv94sf9FCVxNPaGpr4tfe3ygstTa2u+PM2nXsz5bgqhFQHU6B8gC1wPnLOBtf2bqiIS3081VigJcu7dV7eQ16DvpxMkakGf8KG/FMC09K4gDvzi9iPtKUH91iaJMCHD68RAQXhcwfCkvMdCd+syMhfHZ3l9p64sXxLMcCKuOULb4IDsm3dc5aOmhVIhbxIPzh5qk84CYJ3MzJpQqLJ6Tq9b6Y6ZKbYs3IseDfzowesmczAi878jZli3RssQsYSiCMQpJ72Ym/Dl6Fsm8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2327.namprd15.prod.outlook.com (2603:10b6:a02:8e::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.20; Wed, 10 Feb
 2021 21:23:24 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::c585:b877:45fe:4e3f]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::c585:b877:45fe:4e3f%7]) with mapi id 15.20.3825.030; Wed, 10 Feb 2021
 21:23:24 +0000
Date:   Wed, 10 Feb 2021 13:23:17 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf 1/2] libbpf: Ignore non function pointer member in
 struct_ops
Message-ID: <20210210212317.3sqgq5jxcdbq6a73@kafai-mbp.dhcp.thefacebook.com>
References: <20210209193105.1752743-1-kafai@fb.com>
 <CAEf4BzYmTSfRv4vhPeDiYq-zdoAE9rvy=hszsQNUzQ3noeii-Q@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAEf4BzYmTSfRv4vhPeDiYq-zdoAE9rvy=hszsQNUzQ3noeii-Q@mail.gmail.com>
X-Originating-IP: [2620:10d:c090:400::5:c10c]
X-ClientProxiedBy: MW4PR03CA0355.namprd03.prod.outlook.com
 (2603:10b6:303:dc::30) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:c10c) by MW4PR03CA0355.namprd03.prod.outlook.com (2603:10b6:303:dc::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27 via Frontend Transport; Wed, 10 Feb 2021 21:23:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 16760ffe-0753-4732-08ad-08d8ce0a1925
X-MS-TrafficTypeDiagnostic: BYAPR15MB2327:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2327D52CC2D45115C7FCB0F0D58D9@BYAPR15MB2327.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gaErzNZgqJbega+rS1M4xb9/N6EtrDkbyibHz2lrI4Pbt+Md/gD0eG0xIeiyPRm3FpFVdY7Q1c8Fc8UToL+Bq0KhanwW9v/+fdBdbRrscdFs/kW/rc0DOiaupHRUK6Nzy0naRiuDLiE+lIKGEMRaY4O4hh3DLV5OPJIznpyx3Vqb3FfCak8lwQ5PghtfWUviyYRTzm74+vBOrBz0QA6KBdoQHXb0L9yTyDHW4Hq3xuAYXo7ZUauJ+Y6/8RYrmik4bau2OFwZ7mk9fkLJe6Zv3HJnCEJVAhYbU88VUbpnE2XKN4hneA7aN0sU9eQdEr8Ri7VfRZoAVY2hzuLHiWaOOaQH12jOIr8QfcdKjeV+cA49Vf02YS69EQctJlX7U4mi1ejverBJbIoc8sCf2TN4PDfuVPqB6jp3xQaQXweHsq88v2nB8RzA0u31bkVjlW3md6XIbnV3yckI0uvzJrKD97gNPqjwt+SP7nN6iw+MvMABKej7iJyGnbRsP8eUzE8ACVMv14JoKS+Dzk84OnnVhQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(376002)(39860400002)(346002)(136003)(5660300002)(8676002)(1076003)(86362001)(4326008)(6666004)(316002)(66476007)(66556008)(66946007)(7696005)(52116002)(53546011)(6506007)(83380400001)(16526019)(8936002)(478600001)(55016002)(9686003)(6916009)(54906003)(186003)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?VkQN0yXu/c4lpEAq/Tvr/zwGdWioii90NWNty+kS9u+38VSnoeRzQI/JZowy?=
 =?us-ascii?Q?clgHB0gKjc7m0fAiBJC+YRXtjPOfc+9PbQQbWOmOvqS9yLP+q6v0l3H1Oj06?=
 =?us-ascii?Q?p2oT+zPsYWKslme0ZpKhim9L4O29Vr/DmHVEUOJ28CApr3t3sie3tvjycwvU?=
 =?us-ascii?Q?y/dxxEC0HzQaO0swyL/fV6gTJqfMl9yfwM8TWyNlBk16ins+rmSre1kuFW3A?=
 =?us-ascii?Q?fBeEt//ZU9u4SHUHS5bfd+Im8jaCKDYx0JR2KudASchta7NBF5W6FBlFxx2G?=
 =?us-ascii?Q?hff/7FDuFNneTrEr+Y/lyp4UZWsXKct04k3YKDrjMlqTsthwAfOXyfVbR2zC?=
 =?us-ascii?Q?qLkH/qh/k9VpYpHslM70wKr2H2sNqWRj/j6PhYTG0ZHrU68QoZvptOuuxGBn?=
 =?us-ascii?Q?mGsjxDPFEI4544ahWj78v7TB0TSfIGYthWZFX/FgUQO17PksjSDHVFTsOMnQ?=
 =?us-ascii?Q?UOglOrCwlloSpYUb+r+Nf0+tqQW3QWRax1feKs1CIREf4NMQHOs9uwnfsPJV?=
 =?us-ascii?Q?2kbbquKIrdGxZOy2Pcp8o+65JGegd2t99Qv7Q0pUzyd5mm7/Jw6V8wTBiRFX?=
 =?us-ascii?Q?iiDkD7ZAXpXZzXAa0sH4gogCMTRTF3oMhpMMgnmAw1LYiTrAzmQuKoGqmWzY?=
 =?us-ascii?Q?adWzL+BDV8gB3QrXju/fKuOJjYWYFId82Xy7uAzI/hKGF5xKtAGT5iSY6bJG?=
 =?us-ascii?Q?w8BVymMzKm37hsMY3vT9XU1LlEfO41qFHvEYrEiYN6umIStZqUV/+Lkl11+t?=
 =?us-ascii?Q?OwK8CfWAfOntrM/P9W5ire8Q8XyTnbMxyYrbLvKLPbddtCn4HjlyNseer7Jj?=
 =?us-ascii?Q?YhYzOEW0Jz5VRrrcT7857ULPcTu40cPqFNalg93y3HL1wYzs10eIgPTI/F5v?=
 =?us-ascii?Q?WND31jNcUPd854Dv+X6eq5iapFxFSocjEu1F1AZPdy4RyWn52XH/yc8kcrvc?=
 =?us-ascii?Q?YcXBS9Emcn1IRemNnN5dhvij9Zsp9HCJqGhRDEHef2AS242I/4zCVEcHmV23?=
 =?us-ascii?Q?HATHWmFqthz752KXZ7bLPotu/6bSColdMONYeRiLrH06Xw17iYW/wt7cZPBc?=
 =?us-ascii?Q?cQXgzIAZHSceacTLqQTYq9CIFyJol0kDcVQ9QWr0z0iqFccZmvwMFEz44fYP?=
 =?us-ascii?Q?I7hoFKQE3vcnIyab+Z3Tka/gkESfBzcVOWam83opkNn85cL+JUlFh6zyADpa?=
 =?us-ascii?Q?rOmxoOx/SGH5rQpo9OmirIbNVviChAk/eY1mZCadytXwLPiRFOSRjcpev4vm?=
 =?us-ascii?Q?fyW2YZQoq4UmEJD07ZWufVcEjtwDChP0rxtOwZVVNCX4k+fhQZkJ4FbA9AZJ?=
 =?us-ascii?Q?CBUmQovtVoOhehGblqkjB5qqcbskKsQ9hvkSlyRWnAm1qg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 16760ffe-0753-4732-08ad-08d8ce0a1925
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2021 21:23:24.1326
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1bPVi98F6H6TVpE+2svOm8wM4rIIlbjDBJOXXlXppHhYEiK95M1pZyfo4qzgNUo1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2327
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-10_10:2021-02-10,2021-02-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 lowpriorityscore=0 phishscore=0 clxscore=1015 bulkscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 adultscore=0 spamscore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102100187
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 10, 2021 at 12:26:20PM -0800, Andrii Nakryiko wrote:
> On Tue, Feb 9, 2021 at 12:40 PM Martin KaFai Lau <kafai@fb.com> wrote:
> >
> > When libbpf initializes the kernel's struct_ops in
> > "bpf_map__init_kern_struct_ops()", it enforces all
> > pointer types must be a function pointer and rejects
> > others.  It turns out to be too strict.  For example,
> > when directly using "struct tcp_congestion_ops" from vmlinux.h,
> > it has a "struct module *owner" member and it is set to NULL
> > in a bpf_tcp_cc.o.
> >
> > Instead, it only needs to ensure the member is a function
> > pointer if it has been set (relocated) to a bpf-prog.
> > This patch moves the "btf_is_func_proto(kern_mtype)" check
> > after the existing "if (!prog) { continue; }".
> >
> > The "btf_is_func_proto(mtype)" has already been guaranteed
> > in "bpf_object__collect_st_ops_relos()" which has been run
> > before "bpf_map__init_kern_struct_ops()".  Thus, this check
> > is removed.
> >
> > Fixes: 590a00888250 ("bpf: libbpf: Add STRUCT_OPS support")
> > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > ---
> 
> Looks good, see nit below.
> 
> Acked-by: Andrii Nakryiko <andrii@kernel.org>
> 
> >  tools/lib/bpf/libbpf.c | 12 ++++++------
> >  1 file changed, 6 insertions(+), 6 deletions(-)
> >
> > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > index 6ae748f6ea11..b483608ea72a 100644
> > --- a/tools/lib/bpf/libbpf.c
> > +++ b/tools/lib/bpf/libbpf.c
> > @@ -887,12 +887,6 @@ static int bpf_map__init_kern_struct_ops(struct bpf_map *map,
> >                         kern_mtype = skip_mods_and_typedefs(kern_btf,
> >                                                             kern_mtype->type,
> >                                                             &kern_mtype_id);
> > -                       if (!btf_is_func_proto(mtype) ||
> > -                           !btf_is_func_proto(kern_mtype)) {
> > -                               pr_warn("struct_ops init_kern %s: non func ptr %s is not supported\n",
> > -                                       map->name, mname);
> > -                               return -ENOTSUP;
> > -                       }
> >
> >                         prog = st_ops->progs[i];
> >                         if (!prog) {
> 
> debug message below this line is a bit misleading, it talks about
> "func ptr is not set", but it actually could be any kind of field. So
> it would be nice to just talk about "members" or "fields" there, no?
Good catch.  The debug message needs to change.
