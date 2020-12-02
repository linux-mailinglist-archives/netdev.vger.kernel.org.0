Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AE812CC673
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 20:21:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387903AbgLBTUd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 14:20:33 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:48776 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726733AbgLBTUc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 14:20:32 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B2JDTNW025034;
        Wed, 2 Dec 2020 11:19:11 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=fbASFN6KfJUivs8yZzctW2RK6K4KdIGmMUUDjj4phug=;
 b=mlZxjI+NvV3p/GGt0e/XhFI7YJnZ4Vw9EyoH3NdDSUIXZYo5rR8Pcnbz9F05gbBlXhco
 gIf3uiD11UIik2w9k0eVXjnZSwKHOE269MNre50Es5OSAw7fOMnyE9Fo4m6MOQUevmvS
 5R1AApyDZUQ7fZz9BZ+RcAG2HkvBWY9YyO8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 356ajcausm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 02 Dec 2020 11:19:11 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 2 Dec 2020 11:19:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TyJdbln+cuGS+UVP7GLohNB866qWmJejdSgR0Io6cQDJI00J55HSf5OGj4a1Zbpx31Gp06GgE0iY6QIEZIrN0hf0n5R1J57kPJBHBYxOMs+xjfpfZZYdT5ovqsr+ojkwFqZIHUDsrUB/JzgLRLlHKvlg+13QnkigL4aantk5b3L6FB4BtrOsbQOTnNbtUiIRGDgxZBrsW+31CTTjhqvaB/ptZVmXUol2ioF+wdoxlv+QnsMzJO4BF3Y0VHjNY2NVtgnNweY7148gfAgYKCA7m038mK5UtbS1naSDMiOkOIySIxTmM43FDJwdbtr+m6sca9qKhPdAdAX+CyYcK2EJng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fbASFN6KfJUivs8yZzctW2RK6K4KdIGmMUUDjj4phug=;
 b=U11I86OLqZMDHCZJaY9p0lL0cA//csLwhEiSp4LZKinhUlmWlTpdScEgsSMiqibbQ7zc4nMszWZA3dGeCDEcXq54XVpbFfazq6iA65oj68ehRXezYIYRT/v/qpv5DS8gU4k9h5H7oYz6d2ncGUBObReZ03DN++jqNmQh3rt5W5EljdyY8BWDseKXaIkSyKiipcGPKIQCE3OLRRmOTrCG2TUGJnGOeeLk5YKKcSCcCRS7MCQYCSf34Zgr57Yg1fV76FhJghhySwIhJXVBIIoSEjEWQRDd9eos+Ji3YlqPQ1rOC8Raqc4jyEjXohV0MtifpYBfkFzLvtn14Czxaq4qaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fbASFN6KfJUivs8yZzctW2RK6K4KdIGmMUUDjj4phug=;
 b=Rv8jFL1OZ9lLYRkjTwd+LdkA9UUJzF9xSWdjh8492JZQLJrn5ioNhQYq4cyJAkFS5ziYaRWIwQzCWzl/s2ncU8sArJ1oAXyUxPAZvvvRsMGtOxGbMFNH/SZAgTEPiMsmfayrUEANLLW/qT8J9bNGaqNZq2fuF+G4P/bOQGIqixw=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB4119.namprd15.prod.outlook.com (2603:10b6:a02:cd::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.23; Wed, 2 Dec
 2020 19:19:09 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::2831:21bf:8060:a0b]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::2831:21bf:8060:a0b%7]) with mapi id 15.20.3632.020; Wed, 2 Dec 2020
 19:19:09 +0000
Date:   Wed, 2 Dec 2020 11:19:02 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <osa-contribution-log@amazon.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 bpf-next 06/11] bpf: Introduce two attach types for
 BPF_PROG_TYPE_SK_REUSEPORT.
Message-ID: <20201202191756.otne62dsmfxxfgsz@kafai-mbp.dhcp.thefacebook.com>
References: <20201201144418.35045-1-kuniyu@amazon.co.jp>
 <20201201144418.35045-7-kuniyu@amazon.co.jp>
 <CAEf4Bza2K9zPqPWTFp+yUN+najdjqY-sNtZ7T5=V=s66bqDavg@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4Bza2K9zPqPWTFp+yUN+najdjqY-sNtZ7T5=V=s66bqDavg@mail.gmail.com>
X-Originating-IP: [2620:10d:c090:400::5:8630]
X-ClientProxiedBy: CO2PR04CA0198.namprd04.prod.outlook.com
 (2603:10b6:104:5::28) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:8630) by CO2PR04CA0198.namprd04.prod.outlook.com (2603:10b6:104:5::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17 via Frontend Transport; Wed, 2 Dec 2020 19:19:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c4e855cf-4935-4e4e-ff2f-08d896f72480
X-MS-TrafficTypeDiagnostic: BYAPR15MB4119:
X-Microsoft-Antispam-PRVS: <BYAPR15MB41191206C186D8B7D0CA5FFAD5F30@BYAPR15MB4119.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:2089;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bv5Bz2UxDv5Xd1zov6KOLLAm0RSHuTdU4oOsecBGxt7EqlCUKHzRbjYSWhG00Sv+5YAX9e6Dhf3XozYUXPELDG405ZpAv8wb5cMXK8asMmy5hOzffKTj7QPDDb4yeR8EntjKTJgin9rZlHdHPc7qXhT3iGHcvNIcAGw9OAsZy1gZ5knd8LRDqz8/mNUahSEYqu6msPmi/4P6hJ/CgToYfSzcaWFOH1InEtEyJv5sxwpt3laIyO4dbZ9qE5ZjEUtqEx4uApIQ6A2El4gzs++G6tJEy/NQTNNabkqqi1u/ebitzOeGXxseuU4FDnIciNC+Gxga5uXt/ZGmfRV3RDD1uvAweEKtv23RzcgCpzHva2sW0irWSQ/HXsGi+XVL6iFShz7mc9DVpCJuIVhaovboCA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(396003)(39860400002)(376002)(346002)(83380400001)(7416002)(316002)(966005)(4326008)(54906003)(9686003)(16526019)(55016002)(478600001)(186003)(110136005)(5660300002)(1076003)(6666004)(7696005)(52116002)(66556008)(2906002)(8676002)(66946007)(66476007)(8936002)(53546011)(86362001)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?P5YiY9rlpHpCFHwrfqm3ZbLHd/xFWGIJ3HsnVaVv5mnCkz8/X37BvxRCS9Fj?=
 =?us-ascii?Q?foko0AMug+nclmZa5DkDol7Q3XNRuubixV12yiMKjqs2EfpsleS9hxwW7fBf?=
 =?us-ascii?Q?XTYn1CVUYGzDjzuKEkneUpd6nSDdQsXyu8Kdw4SzIrtpINyjU3FlIVYR9IAm?=
 =?us-ascii?Q?HfEc8/9QT8QoC8DxQIWLyhcwy2o42RmUWyrJubJ82YA6iaCemi8CSuUWN91s?=
 =?us-ascii?Q?SNLGhim37fR27p9w5lYFTf4bDORI2hxuslrgtoZqGC/oSYBp34dOiT7Eus2y?=
 =?us-ascii?Q?5i4bnpcl4Y+2U0reKxF30EuSDwttsIpNH29MLoyqvc19ifZXPUMCYqypodfj?=
 =?us-ascii?Q?bvHI/xjWTwVg1KpjIXBPrb6NHyh+yfGkGXKPyLirSmbIl3aeDfWV9Z1hdoWs?=
 =?us-ascii?Q?vYCAS0mQjvELfvuJRoHukT5Syq7V1Y9Lvr4F/KItAUDEDgK29YfN7EZW+0O9?=
 =?us-ascii?Q?AqzPqDSlMAmOX5L8Qe2aPmxf9W9LVB5e+wEeniFoKsI9f3T/1Tauj43aZp3x?=
 =?us-ascii?Q?cD/K+7hNJJNBb1gyT2eP9GIjT9Vh8t0v0xL/npFGvcCO3aAaKzVUKsyrws1O?=
 =?us-ascii?Q?0xKFo3xHVji+pnXSseDzydg3qGhtAqFJPd3dsXjhr0+vFow+xc6bg1O+wtHn?=
 =?us-ascii?Q?LD90eAZSzYBpHKa8dSx4UTNiLGbYKoroA6PLtF+l+9hfw3aZS33Dd1Oek1Yg?=
 =?us-ascii?Q?/zjFkkuMcQML9pUH39Sy9Lvt02qdrBNNnp04auYvTC14BAJbP+LJk9bEMBjT?=
 =?us-ascii?Q?gXE2PT8MWGuwZXp0fj8/ceJTap2XA2bAowYPClmQBiC0gUSEapr4kSyLaq0e?=
 =?us-ascii?Q?Kt9+15rhNx5NNAaskRPF01nWTXgfvNxnS/fiNFXvsRp1J2I1rmKbjirJ6o1J?=
 =?us-ascii?Q?/KQyPMKoYp1DLiiC7G+4/URYiPLpWUUC1r68QUaxbOHLv8iUu4p+hFpTyDe4?=
 =?us-ascii?Q?Y+Jj6Caw+jhDtTIUkoOwhNt8Oq4CtZeLVmNcHwjsvSOzMJIheEqImAZXVi4N?=
 =?us-ascii?Q?8ajgKZ+zJenRAPZv837kDc8etw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c4e855cf-4935-4e4e-ff2f-08d896f72480
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2020 19:19:08.9395
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WoOuJ0BbHO50ChPq3I6uWAbWVs34FQK3+PV0B0oNiKh1UKoqqLua07COMVi4zzAD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB4119
X-OriginatorOrg: fb.com
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-02_11:2020-11-30,2020-12-02 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 mlxscore=0 suspectscore=0 spamscore=0 phishscore=0 adultscore=0
 priorityscore=1501 impostorscore=0 mlxlogscore=909 malwarescore=0
 bulkscore=0 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012020113
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 01, 2020 at 06:04:50PM -0800, Andrii Nakryiko wrote:
> On Tue, Dec 1, 2020 at 6:49 AM Kuniyuki Iwashima <kuniyu@amazon.co.jp> wrote:
> >
> > This commit adds new bpf_attach_type for BPF_PROG_TYPE_SK_REUSEPORT to
> > check if the attached eBPF program is capable of migrating sockets.
> >
> > When the eBPF program is attached, the kernel runs it for socket migration
> > only if the expected_attach_type is BPF_SK_REUSEPORT_SELECT_OR_MIGRATE.
> > The kernel will change the behaviour depending on the returned value:
> >
> >   - SK_PASS with selected_sk, select it as a new listener
> >   - SK_PASS with selected_sk NULL, fall back to the random selection
> >   - SK_DROP, cancel the migration
> >
> > Link: https://lore.kernel.org/netdev/20201123003828.xjpjdtk4ygl6tg6h@kafai-mbp.dhcp.thefacebook.com/
> > Suggested-by: Martin KaFai Lau <kafai@fb.com>
> > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> > ---
> >  include/uapi/linux/bpf.h       | 2 ++
> >  kernel/bpf/syscall.c           | 8 ++++++++
> >  tools/include/uapi/linux/bpf.h | 2 ++
> >  3 files changed, 12 insertions(+)
> >
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > index 85278deff439..cfc207ae7782 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -241,6 +241,8 @@ enum bpf_attach_type {
> >         BPF_XDP_CPUMAP,
> >         BPF_SK_LOOKUP,
> >         BPF_XDP,
> > +       BPF_SK_REUSEPORT_SELECT,
> > +       BPF_SK_REUSEPORT_SELECT_OR_MIGRATE,
> >         __MAX_BPF_ATTACH_TYPE
> >  };
> >
> > diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> > index f3fe9f53f93c..a0796a8de5ea 100644
> > --- a/kernel/bpf/syscall.c
> > +++ b/kernel/bpf/syscall.c
> > @@ -2036,6 +2036,14 @@ bpf_prog_load_check_attach(enum bpf_prog_type prog_type,
> >                 if (expected_attach_type == BPF_SK_LOOKUP)
> >                         return 0;
> >                 return -EINVAL;
> > +       case BPF_PROG_TYPE_SK_REUSEPORT:
> > +               switch (expected_attach_type) {
> > +               case BPF_SK_REUSEPORT_SELECT:
> > +               case BPF_SK_REUSEPORT_SELECT_OR_MIGRATE:
> > +                       return 0;
> > +               default:
> > +                       return -EINVAL;
> > +               }
> 
> this is a kernel regression, previously expected_attach_type wasn't
> enforced, so user-space could have provided any number without an
> error.
I also think this change alone will break things like when the usual
attr->expected_attach_type == 0 case.  At least changes is needed in
bpf_prog_load_fixup_attach_type() which is also handling a
similar situation for BPF_PROG_TYPE_CGROUP_SOCK.

I now think there is no need to expose new bpf_attach_type to the UAPI.
Since the prog->expected_attach_type is not used, it can be cleared at load time
and then only set to BPF_SK_REUSEPORT_SELECT_OR_MIGRATE (probably defined
internally at filter.[c|h]) in the is_valid_access() when "migration"
is accessed.  When "migration" is accessed, the bpf prog can handle
migration (and the original not-migration) case.

> 
> >         case BPF_PROG_TYPE_EXT:
> >                 if (expected_attach_type)
> >                         return -EINVAL;
> > diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
> > index 85278deff439..cfc207ae7782 100644
> > --- a/tools/include/uapi/linux/bpf.h
> > +++ b/tools/include/uapi/linux/bpf.h
> > @@ -241,6 +241,8 @@ enum bpf_attach_type {
> >         BPF_XDP_CPUMAP,
> >         BPF_SK_LOOKUP,
> >         BPF_XDP,
> > +       BPF_SK_REUSEPORT_SELECT,
> > +       BPF_SK_REUSEPORT_SELECT_OR_MIGRATE,
> >         __MAX_BPF_ATTACH_TYPE
> >  };
> >
> > --
> > 2.17.2 (Apple Git-113)
> >
