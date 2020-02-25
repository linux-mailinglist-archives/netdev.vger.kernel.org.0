Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8F2316EC1F
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 18:08:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730738AbgBYRIq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 12:08:46 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:11994 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728981AbgBYRIp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 12:08:45 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01PGsi2b000860;
        Tue, 25 Feb 2020 09:08:29 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=ZmFiJqU+8Ys072U91yc/zqvyc8f4dRdOrDaenWZk4WY=;
 b=kJbJ9uHKfIM42P2CpXc3i6c+YVLlTsPuyr/qIPfLIWsm300u06p11ZJxuHWmfmEX+GYr
 FEdBE4zr7cj6IvtTMnEzazwdmapCCkvJHx32/asz5bP2PDaua12OGwj8JtlvSjkE7nUz
 XDszCeS64DNJ1ijWdYkSdThlyCUeVweuFA8= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2ybn98bywu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 25 Feb 2020 09:08:29 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Tue, 25 Feb 2020 09:08:28 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VJkyjW9vFMDsvgbEIHM38xwFmBSR8XCL32U8jIMfz1A24BwXI1hVYe7NDWv/QVhljgSBGMmaalNOKSU+c+bu+mREn5RX4FmZvRjo6STXny5QGBVOCS53YPZOd3yJFG8aEY0iG16FtrjIiIvMaLvM+sO1uhpu/US0jDInfVytHalsvRAGQTPE6BLRlOqMrTAkmtwJXonQgWKyYIAX6gR+t+el0v7738FuX2m1PExPF8oJJw933TWkkepQJAC+lgSMh4Ig1mApvenZUo44cADLSuS40G6anJTG4dkf0XEbE4ei73tpTSFhSUDnEgHDdVPHFB1ge29F1vuHdLLBcj0zYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZmFiJqU+8Ys072U91yc/zqvyc8f4dRdOrDaenWZk4WY=;
 b=nM8nOd8orPQ1az3iaKuqZQWkb6vXGO8gBxJg0RDiEUrLTL/OdLCyaP0dMfajiuf9m0RGAeVBrAUxi8ZGxL2Xc4P3YfymcIb5X9EwF3FAcmSSwoG9qfP05vn+fk1UgS3zOJL9T320KUrIU05/nDXbKQl2/4A0rAGHmrTXdDNXxOal5IKaV8UXAZkU8FBa3WcZAIbyE4TJx2M8dIhs0GVRreg8FwnOeIhHIHCa0iv4FV2bsOzDizMijxAQs4z2GNPzxIUi2K7fVsCAW8Vg6au4pv1xM9d2cbK8a+8C5punHBHwHMdXCyzwMMMEiGMJaIohmv46Mo/I0BjO+7aLw6aSVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZmFiJqU+8Ys072U91yc/zqvyc8f4dRdOrDaenWZk4WY=;
 b=MaApP27iOnc7QkjaXr51h0BsJEc7iGOkeohzgTbKA25WsnS89z5xFCoNyiaXbo+FHM0LoXxoXbV+KPbHSYbH7niqOKcEsZJ6pakCtG6ZBYuP95DHXb3eED/bM7Vb7tO4qIXGaigRUr4GiUcLPEw0jUPha2jwunJ6+b8rNI+ek2c=
Received: from BYAPR15MB2278.namprd15.prod.outlook.com (2603:10b6:a02:8e::17)
 by BYAPR15MB2983.namprd15.prod.outlook.com (2603:10b6:a03:f6::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.21; Tue, 25 Feb
 2020 17:08:27 +0000
Received: from BYAPR15MB2278.namprd15.prod.outlook.com
 ([fe80::4d5a:6517:802b:5f47]) by BYAPR15MB2278.namprd15.prod.outlook.com
 ([fe80::4d5a:6517:802b:5f47%4]) with mapi id 15.20.2750.021; Tue, 25 Feb 2020
 17:08:27 +0000
Date:   Tue, 25 Feb 2020 09:08:24 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Song Liu <song@kernel.org>
CC:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next 4/4] bpf: inet_diag: Dump bpf_sk_storages in
 inet_diag_dump()
Message-ID: <20200225170824.dhwkw2ojzsfz223k@kafai-mbp>
References: <20200221184650.21920-1-kafai@fb.com>
 <20200221184715.24186-1-kafai@fb.com>
 <CAPhsuW4BuGQP8+QGG+E9A+n=8DV0Gg=UmWzeScrbFxBp7O_ojw@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPhsuW4BuGQP8+QGG+E9A+n=8DV0Gg=UmWzeScrbFxBp7O_ojw@mail.gmail.com>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: MWHPR20CA0019.namprd20.prod.outlook.com
 (2603:10b6:300:13d::29) To BYAPR15MB2278.namprd15.prod.outlook.com
 (2603:10b6:a02:8e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:500::4:351c) by MWHPR20CA0019.namprd20.prod.outlook.com (2603:10b6:300:13d::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.18 via Frontend Transport; Tue, 25 Feb 2020 17:08:26 +0000
X-Originating-IP: [2620:10d:c090:500::4:351c]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b74ea1ac-7919-4a99-eada-08d7ba155444
X-MS-TrafficTypeDiagnostic: BYAPR15MB2983:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB29830A32ECC35E0D475DA7FAD5ED0@BYAPR15MB2983.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:2887;
X-Forefront-PRVS: 0324C2C0E2
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(366004)(189003)(199004)(6916009)(8676002)(8936002)(16526019)(4326008)(33716001)(54906003)(81166006)(2906002)(5660300002)(86362001)(81156014)(186003)(55016002)(66946007)(66476007)(1076003)(6496006)(66556008)(498600001)(53546011)(9686003)(52116002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2983;H:BYAPR15MB2278.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0FLLrCyLMYFuhZk/ZQPyiCkEi+y//16GFJ8JKDElRzYZeuTuKSEELF1bHKHNdyNdZb/YQEgRXb+SRfjnTBAh72GHPWZisfsb9k5dMU/RnlKCUXq5UrzQEWqKshPtm6BeWVeHvFTvQAkf1Pbr1x5Ze2cGqbNzsT75VXBXLz/uVwwFxQbGBRRBc4drd7CUw3sJ+2zsmYd0ERFayerc7avGsIg6EdoNgBayDMRIJuOcgmY43B2tiKdtGyMmdroNTndzELH/4w6I6WKbS7mtcRWfFiQwFPV3M35e8W2nkERYDwQZCsyrhOsTQ0mP4DR2nrYCV+AxBd/8eMvnX+YGynBBfyvoyJTD1AscwbyPscau7BkBqlBBCwBHucSI/54NUo8mft5yWbYM5/DU4onA6qlK461UEYHziqe02QVj3F+qBEX6TI4IT6tq4soarduNSl3K
X-MS-Exchange-AntiSpam-MessageData: ChlelH5qBTMXsyxUqqSYKD513tioz+0OEZiJOryn5p6S8/dKdwSCTddZcTP8fau0uCvhwpZTVyLMZHMt4Dp2+jD97dF4yX7cABND3ZKwtgUwMDs59hGYUT0IpeaPFtI8xM4DV8J3yj2U1A9zC0teJ81Dvd/I+33qZzYPsW8Hkn3aHv895iZay5lLYqMytfls
X-MS-Exchange-CrossTenant-Network-Message-Id: b74ea1ac-7919-4a99-eada-08d7ba155444
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2020 17:08:27.0125
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7+ucfSMTtm2fM249f8Iqx3TZihpA+fNpd9bIEQs2hKoEWw/rJof0d3xPfuuY3jww
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2983
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-25_06:2020-02-25,2020-02-25 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1011 mlxscore=0
 lowpriorityscore=0 priorityscore=1501 malwarescore=0 mlxlogscore=773
 spamscore=0 adultscore=0 phishscore=0 impostorscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002250126
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 24, 2020 at 09:47:33PM -0800, Song Liu wrote:
> On Fri, Feb 21, 2020 at 10:49 AM Martin KaFai Lau <kafai@fb.com> wrote:
> >
> > This patch will dump out the bpf_sk_storages of a sk
> > if the request has the INET_DIAG_REQ_SK_BPF_STORAGES nlattr.
> >
> > An array of SK_DIAG_BPF_STORAGE_REQ_MAP_FD can be specified in
> > INET_DIAG_REQ_SK_BPF_STORAGES to select which bpf_sk_storage to dump.
> > If no map_fd is specified, all bpf_sk_storages of a sk will be dumped.
> [...]
> 
> > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > ---
> >  include/linux/inet_diag.h      |  4 ++
> >  include/linux/netlink.h        |  4 +-
> >  include/uapi/linux/inet_diag.h |  2 +
> >  net/ipv4/inet_diag.c           | 71 ++++++++++++++++++++++++++++++++++
> >  4 files changed, 79 insertions(+), 2 deletions(-)
> >
> > diff --git a/include/linux/inet_diag.h b/include/linux/inet_diag.h
> > index 1bb94cac265f..e4ba25d63913 100644
> > --- a/include/linux/inet_diag.h
> > +++ b/include/linux/inet_diag.h
> > @@ -38,9 +38,13 @@ struct inet_diag_handler {
> >         __u16           idiag_info_size;
> >  };
> >
> > +struct bpf_sk_storage_diag;
> >  struct inet_diag_dump_data {
> >         struct nlattr *req_nlas[__INET_DIAG_REQ_MAX];
> >  #define inet_diag_nla_bc req_nlas[INET_DIAG_REQ_BYTECODE]
> > +#define inet_diag_nla_bpf_stgs req_nlas[INET_DIAG_REQ_SK_BPF_STORAGES]
> > +
> > +       struct bpf_sk_storage_diag *bpf_stg_diag;
> >  };
> >
> >  struct inet_connection_sock;
> > diff --git a/include/linux/netlink.h b/include/linux/netlink.h
> > index 205fa7b1f07a..788969ccbbde 100644
> > --- a/include/linux/netlink.h
> > +++ b/include/linux/netlink.h
> > @@ -188,10 +188,10 @@ struct netlink_callback {
> >         struct module           *module;
> >         struct netlink_ext_ack  *extack;
> >         u16                     family;
> > -       u16                     min_dump_alloc;
> > -       bool                    strict_check;
> >         u16                     answer_flags;
> > +       u32                     min_dump_alloc;
> 
> Maybe highlight this change in the commit log?
ok.

> 
> >         unsigned int            prev_seq, seq;
> > +       bool                    strict_check;
> >         union {
> >                 u8              ctx[48];
> >

[ ... ]

> > diff --git a/net/ipv4/inet_diag.c b/net/ipv4/inet_diag.c
> > index 4bce8a477699..8ca4d54d7c5a 100644

[ ... ]

> > @@ -1022,8 +1069,11 @@ static int __inet_diag_dump(struct sk_buff *skb, struct netlink_callback *cb,
> >                             const struct inet_diag_req_v2 *r)
> >  {
> >         const struct inet_diag_handler *handler;
> > +       u32 prev_min_dump_alloc;
> >         int err = 0;
> >
> > +again:
> > +       prev_min_dump_alloc = cb->min_dump_alloc;
> >         handler = inet_diag_lock_handler(r->sdiag_protocol);
> >         if (!IS_ERR(handler))
> >                 handler->dump(skb, cb, r);
> > @@ -1031,6 +1081,12 @@ static int __inet_diag_dump(struct sk_buff *skb, struct netlink_callback *cb,
> >                 err = PTR_ERR(handler);
> >         inet_diag_unlock_handler(handler);
> >
> > +       if (!skb->len && cb->min_dump_alloc > prev_min_dump_alloc) {
> 
> Why do we check for !skb->len here?
skb contains the info of sk(s) to be dumped to the userspace.
It may contain no sk info (i.e. !skb->len),  1 sk info, 2 sk info...etc.
It only retries if there is no sk info and the cb->min_dump_alloc becomes
larger (together, it means the current skb is not large enough to fit one
sk info).

> 
> > +               err = pskb_expand_head(skb, 0, cb->min_dump_alloc, GFP_KERNEL);
> > +               if (!err)
> > +                       goto again;
> > +       }
> > +
> >         return err ? : skb->len;
> >  }
> >
