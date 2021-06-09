Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 919AB3A1CB3
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 20:25:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229937AbhFIS1I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 14:27:08 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:34370 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229472AbhFIS1H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 14:27:07 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 159IFJu7000791;
        Wed, 9 Jun 2021 11:24:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=+niVgWqJuDM+sHXbfUjqrKGvnyQrR0Ii8d5ItVrWg+4=;
 b=B27NClasdJMrIhb0XBcb/xDdkdU9YdqdvHlU9hAPsPbgoQDV4pURzhOT5J65vtKrfJfY
 E3hLeKQAHQZKL48VLBgBxaMrGYidqwu3oO5GgR04qQVdp7Ox3FtuI9ggrS6KvFM5KwvG
 ZZlYimaXv9DHvGGifyAXKUd/4pp1gdNDcUE= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 392ta73km1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 09 Jun 2021 11:24:55 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 9 Jun 2021 11:24:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PKHCa1uHeXqXF8OTWY1vFhTkGA4nSjWxxTHnh40WlM1oF/IzQHAH831Vddjcko2srWZIUKXrphCioQiVKcIWNmsGqM5Fbo3HVwqJ+xPumCjxvB6IeTBC+rz6OfC4s18VKgKC7hkKepdiNOM6oFuUoBYMZVFhs16fBMQDlqYmGsWEz280ZW/w4TBdaGOEzodyIMwtFXyZqmhvuWK2p9S9HTr6+KUxcS95+jBVfn61dTTYFkKWcghtku1lU+8u8ci7SiWRfBB9OngSxWCEGPF2jmacQyb3Ifzb03j+aS6vvfEKIXF9GhRSAQWLKlFoCx7/Vi33V7FlF97RkizpZNz/5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+niVgWqJuDM+sHXbfUjqrKGvnyQrR0Ii8d5ItVrWg+4=;
 b=kNk7EkKZ/WE9h8SBuC5XEErhwfQeinYgXI87MC8MpwhAhKXpSjqwKEzmr/TTpDfXKQ1mYvwqJ3OdQySFp9h51RLSaXakX+ko+s4D0aocfYD43ElmRPFtRdtVbc39xaHFnOsTLGpagUrvSaRB3deFYzSzTYVtkAwSQMhtv/d3gR+Iys3x1uOy/vE/FEiHVgwTdlusrZ0XtYkA06IxXWodKd49/EOvlTuiRdd1wtAA34fLy1mev6oXoGn8udQVTLurKF9y4LWT3pyxXk9N6PCeVA7SwSuPAzkmMLfwJpjt/9PokVaTjtTvgsB0zDhc6lBcRDbhxJ7t2X7uNRTBHoIiHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fb.com;
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SA1PR15MB5013.namprd15.prod.outlook.com (2603:10b6:806:1d8::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.22; Wed, 9 Jun
 2021 18:24:52 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::f88a:b4cc:fc4f:4034]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::f88a:b4cc:fc4f:4034%3]) with mapi id 15.20.4195.030; Wed, 9 Jun 2021
 18:24:52 +0000
Date:   Wed, 9 Jun 2021 11:24:50 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Tanner Love <tannerlove@google.com>
CC:     Tanner Love <tannerlove.kernel@gmail.com>,
        <netdev@vger.kernel.org>, <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Petar Penkov <ppenkov@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Stanislav Fomichev <sdf@google.com>
Subject: Re: [PATCH net-next v4 1/3] net: flow_dissector: extend bpf flow
 dissector support with vnet hdr
Message-ID: <20210609182450.pxkaqcx3aql2ffxd@kafai-mbp>
References: <20210608170224.1138264-1-tannerlove.kernel@gmail.com>
 <20210608170224.1138264-2-tannerlove.kernel@gmail.com>
 <20210608220839.c3xuapju2efn2k24@kafai-mbp>
 <CAOckAf8W04ynA4iXXzBe8kB_yauH9TKEJ_o6tt9tQuTJBx-G6A@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAOckAf8W04ynA4iXXzBe8kB_yauH9TKEJ_o6tt9tQuTJBx-G6A@mail.gmail.com>
X-Originating-IP: [2620:10d:c090:400::5:1146]
X-ClientProxiedBy: SJ0PR03CA0223.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::18) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:1146) by SJ0PR03CA0223.namprd03.prod.outlook.com (2603:10b6:a03:39f::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20 via Frontend Transport; Wed, 9 Jun 2021 18:24:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 99886cb3-fff5-45d4-0d45-08d92b73dfac
X-MS-TrafficTypeDiagnostic: SA1PR15MB5013:
X-Microsoft-Antispam-PRVS: <SA1PR15MB50131217D716FF4C538A0423D5369@SA1PR15MB5013.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KOLTXeEb7PqCHo+LVSkNZxAozMuZS2De1fPqetInXXl3sRCeU72hxOE7hX2Gb4PEvxCGMyT03smVcgj3cHCA2eqWDz0azMaJH57gRRVV6RyqgHBkRWCE8PLfZCG4OJihbzR16ySh/YbQJe1RFuFUeW8rppA2ZAVP60N+QIDew53k4DCUP3tcrTuCvmPHs1WAPzjjAicz4FJBUT9iZb43hdbxBOAma7biEjorOWXHiJ6JLsTuQakLXEV7Y8REtym4NwvnHN2t6r1VU6rZj6xSDwZj9zM322cHrXRW7vFnalTxZh37fkH0yWUBAOAIK3mJ9l4KlqdBa//t3XdtwymRmzvSNQBUdBiIgoHxzqnu4OaxTToduX4NP3La6Ngj9JAfwzFMgdcwFLiIwB+MkJJta01ITZ3rB4brN8bRjNk+5w475eouCwKEwmtGzh/DTGMIQeuIOnv63P5DxjnUQefRU4YVEL02Xxp+9SXMmMzB8aMmalD4BoA9tdIFMwbzpSA48oi0iwZKiGvTtdfIIDhR4hT3sFqP4m9vFLhPtyBCnqZzCxSWe+2RFHe2/GHLwuLA3x+Vujs9F3xARBkSEIb2Jg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(396003)(376002)(346002)(136003)(55016002)(86362001)(316002)(54906003)(186003)(52116002)(66946007)(5660300002)(8676002)(1076003)(66476007)(83380400001)(9686003)(8936002)(16526019)(478600001)(7416002)(33716001)(6496006)(4326008)(38100700002)(6916009)(66556008)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?f/iYbbH9izdI3fJNbeG3qAguG7eHZ+c+wG5ixfPjPoHVF5rCCUjLnnexC2ej?=
 =?us-ascii?Q?hqSzXc2PsP4ureZUed9E4KBloYCN0ZfIv771TleuGQX4A65cd/mH+3ItXPgI?=
 =?us-ascii?Q?z2XLOP0YERPP68jmuv1Oxi17fvgokL8YIWn9Gwr/koORwdCyZDht2mprf/wc?=
 =?us-ascii?Q?1W6ohuFMebRyz2642bsib4yDRl1HuuuBchJJ04C3/iIvV9BT1kJgmCgE4E2n?=
 =?us-ascii?Q?H9PZ7PLgTpJysS29A++kRsLsSG1qgEmoFQmMbzVT0f8Ib5/lkI/ZngTNZIK3?=
 =?us-ascii?Q?i1idXR3qNhiDsUJLBB3gTitpSZM85bSObSDOU6Hr+EzJqqXxKPeeHc0BTA5X?=
 =?us-ascii?Q?4Tc5ObYHEvsd/xJ8ImLT2p74afuNZ3TgvHgXbIBWtR3avPQjNl79QF99aEPe?=
 =?us-ascii?Q?s0KI+TeyTCukjR3wkF++gtpAtHchlDpqcRUlKDYyzVc23eDCM9PmAt9VLv+V?=
 =?us-ascii?Q?KLBCsEkOZSiDRM0Cx7UZka9K1uZWi4l0pclJuHPOJjffza1DNDWVL2nI0bq0?=
 =?us-ascii?Q?lJ3b4WL7uvByFSZSsEWlewwGqiD/AsJ/JZq+cHFFtzxPefWPQf18ajmm1b3k?=
 =?us-ascii?Q?q5mZiiZfZpm9ne8m/6eLOs3fosDarbvJko/63szQm7coyivvh/qY+ttPcgb5?=
 =?us-ascii?Q?ZWEqlbAvmkZL8UyjkZVQfpTapXZUwu8MVhsmBVJA9p4hUfudMvv1puTKncsj?=
 =?us-ascii?Q?yu4YmN4i/llMdey3qDFYs2HecO+ddt49sHoxt3QJmvHK9UUw7hntbs++4yTK?=
 =?us-ascii?Q?k3KAewTZYFj3e6NHbGZWWPaHY55WJqvEsoAH7SFaD7FqVlfzgFBin2fZxmWM?=
 =?us-ascii?Q?IC9OWTz1sW2HK8pyrTsyCtvJuDODI9xDYZhM3hkW/bxN/YHQQNAqj8SFdlXv?=
 =?us-ascii?Q?pQlBvhNO68gFSa7z0OkZu953Dn5AmDiwCWzK1+zYZ0VkU+uYSs7EJ/XbEdez?=
 =?us-ascii?Q?j/fcNo1eUm4E9ja/FvKtwpkJJyXmZRlbJH3v3RBb+zXZS1cyWY22nadzu3Vt?=
 =?us-ascii?Q?qVYz2w2Cz1iUc6kiYW3C9pSVvQBZ8C2UZmuZq6RO31DHu130VeartO/VmdwC?=
 =?us-ascii?Q?m8uPXm2uTdyuRlbMlqPDz2/N+oQeifJC6UM7ZwqIvsJK/A/2g92NmxGYF4Rd?=
 =?us-ascii?Q?JF3Etew7S7R60TjrNV++C3rrqmbGCo8HPgjsi1HVbofaWpUT08FyjVrvfYqu?=
 =?us-ascii?Q?jCFn8KBGb7PnxbVP3j3xtUuvKgou73a6WpUSspnkEeUuUPf4TLeNC1Y7uWOn?=
 =?us-ascii?Q?qxFh0/HC9JaHmeSXUJFsGiyE+lNLwOUeXT7PeiV4yNtJHgOA82xZ8DBODec0?=
 =?us-ascii?Q?JXDQP2wKahCMDZ3MjojFqA4eCZi1PwpHyABx18nwnS8vFw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 99886cb3-fff5-45d4-0d45-08d92b73dfac
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2021 18:24:52.4967
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CMGAn/o3dP3pA/5LV4Zy51e/yAYSW9NcBnozS1sLblU7uBhW0LmmJIm6ujpqdeZh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB5013
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: ZOCFkCkQm6BUyZcbybLeYR28ILL-r25k
X-Proofpoint-ORIG-GUID: ZOCFkCkQm6BUyZcbybLeYR28ILL-r25k
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-09_07:2021-06-04,2021-06-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 phishscore=0 bulkscore=0 spamscore=0 priorityscore=1501 mlxscore=0
 clxscore=1015 impostorscore=0 mlxlogscore=999 adultscore=0 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106090093
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 09, 2021 at 10:12:36AM -0700, Tanner Love wrote:
[ ... ]

> > > @@ -4218,6 +4243,23 @@ static int check_mem_access(struct
> > bpf_verifier_env *env, int insn_idx, u32 regn
> > >               }
> > >
> > >               err = check_flow_keys_access(env, off, size);
> > > +             if (!err && t == BPF_READ && value_regno >= 0) {
> > > +                     if (off == offsetof(struct bpf_flow_keys, vhdr)) {
> > > +                             regs[value_regno].type =
> > PTR_TO_VNET_HDR_OR_NULL;
> > check_flow_keys_access() needs some modifications
> >
> > 1. What if t == BPF_WRITE?  I think "keys->vhdr = 0xdead" has to be
> > rejected.
> >
> > 2. It needs to check loading keys->vhdr is in sizeof(__u64) like other
> >    pointer loading does.  Take a look at the flow_keys case in
> >    flow_dissector_is_valid_access().
> >
> > It also needs to convert the pointer loading like how
> > flow_dissector_convert_ctx_access() does on flow_keys.
> >
> 
> I understand 1 and 2, and I agree. I will make the changes in the
> next version. Thanks. But I do not understand your comment "It
> also needs to convert the pointer loading like how
> flow_dissector_convert_ctx_access() does on flow_keys."
> Convert it to what? The pointer to struct virtio_net_hdr is in struct
> bpf_flow_keys, not struct bpf_flow_dissector (the kernel context).
> Could you please elaborate? Thank you!
Ah, right. There is no kernel counter part for bpf_flow_keys.
Please ignore the "convert the pointer loading" comment.

> 
> >
> > A high level design question.  "struct virtio_net_hdr" is in uapi and
> > there is no need to do convert_ctx.  I think using PTR_TO_BTF_ID_OR_NULL
> > will be easier here and the new PTR_TO_VNET_HDR* related changes will go
> > away.
> >
> > The "else if (reg->type == PTR_TO_CTX)" case earlier could be a good
> > example.
> >
> > To get the btf_id for "struct virtio_net_hdr", take a look at
> > the BTF_ID_LIST_SINGLE() usage in filter.c
> >
> 
> Thanks for the suggestion. Still ruminating on this, but figured I'd send my
> above question in the meantime.
btf_id points to a BTF debuginfo that describes how a kernel struct looks like.

PTR_TO_BTF_ID(_NOT_NULL) means a reg is a pointer to a kernel struct described
by a BTF (so the btf_id).  With the BTF, the access is checked commonly
in btf_struct_access() for any kernel struct.

It needs the BPF_PROBE_MEM support in the JIT which is currently in
x86/arm64/s390.
