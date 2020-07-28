Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D25E22FE52
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 02:08:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbgG1AIV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 20:08:21 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:62344 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726222AbgG1AIV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 20:08:21 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06S04xSK016450;
        Mon, 27 Jul 2020 17:08:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=TE9DQvCmw80zpa6a8gJNwkfvBTOmTzkSsF52VAZIrWI=;
 b=k3Ka3V4s9zj47xgXXO+l38p8sAv33r6LE0ChKw2sKsvobUGDkgU3eKzDg9RJ0blilHoR
 DZGK/Uc2vsWgYiVkBtdiwFZm6L2DOZRetqMg9qBbn92h8XKAswrKGx5mp4rqMApzam8R
 gyItIJK2gyF2zX9ooeqrjnOlfQc+vtrkm+Y= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 32h4q9f48c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 27 Jul 2020 17:08:07 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 27 Jul 2020 17:08:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QdYnLZvGEmXQXDNwoD41Hvry6Jp9RtzNuPCVv4XPAtnHKgTuWPZSxedin6uwlY9gMWymdHMFlLpsByobCAxnWep2kXcQ1JSyU+HbX3KonltDRYATSQbH3wcQQfS8UNbZhZ/Q9nr3wLOALJyvrld9dFmefcULghjH9QsyP4Ar2d0IKM7A48A5y6VQVhNf4cp0zaECuczqKrifu3HXD1e7rWwcIBMctc5FdieEhYxsGnWfGP97spZePJP9t5vSTwV2ybeBknSZOOSI4fCUj0yfeWQ9PYZnT9dchjmcGK13fv1ZJrztuegpYWoKCQb81bjBWlYU5biiffVk6CiIhpSWlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TE9DQvCmw80zpa6a8gJNwkfvBTOmTzkSsF52VAZIrWI=;
 b=HiLmCUtLQa5iSYGxkga4R7N/SQqomDnAlQV0I0yeVCw3vux9BHbdKTkp6zFvmGmGC+TZf64K+ADwhQoSGijxug+Uztp+pRYPvOg1ftsuUd7gsguH4xEGHdJdBZQSGIAwNTib75vpixDDPBSqVztj+j4OltUzgVBxzXgPKFlHpvlwyTPSSvkbAbaTWEZzldy/5HMgXoMiWl6xcg95U9t2TKObXDVxeELSH+G4mtVnKUDA1w4UljdMKJv3HVlYSDszGuALUvZ1eP9Z5YipciVeA0uSHoPzx6avtWB6IBAbOWSLpPI0WRmYIfjHAZTkllv1y0O0ggDxEpoFzz9V5C58ZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TE9DQvCmw80zpa6a8gJNwkfvBTOmTzkSsF52VAZIrWI=;
 b=QCdNg70wxlAcMfSWg4BiH91Tc1nNHohpI++p+oau6taY8bJteBkYq9KxztPhYbBaBaW7htgUrqokWr6KvxYdJDCRP1YyZhTO0NGCAgFc5+FlKSOsB6WhGuYHpJe4AR2ox5zUbTXZJ9rbrbLS5EOvadOG0Y7Fxw1DM2Tt8++L7Xc=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4136.namprd15.prod.outlook.com (2603:10b6:a03:96::24)
 by BYAPR15MB3141.namprd15.prod.outlook.com (2603:10b6:a03:f5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.24; Tue, 28 Jul
 2020 00:08:05 +0000
Received: from BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::48e3:c159:703d:a2f1]) by BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::48e3:c159:703d:a2f1%5]) with mapi id 15.20.3216.033; Tue, 28 Jul 2020
 00:08:05 +0000
Date:   Mon, 27 Jul 2020 17:08:02 -0700
From:   Roman Gushchin <guro@fb.com>
To:     Song Liu <song@kernel.org>
CC:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH bpf-next v2 01/35] bpf: memcg-based memory accounting for
 bpf progs
Message-ID: <20200728000802.GB352883@carbon.DHCP.thefacebook.com>
References: <20200727184506.2279656-1-guro@fb.com>
 <20200727184506.2279656-2-guro@fb.com>
 <CAPhsuW49mOQYCx77jucJ_NkeYhoSxOZ_cCujBUjgMdJBy3keeg@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPhsuW49mOQYCx77jucJ_NkeYhoSxOZ_cCujBUjgMdJBy3keeg@mail.gmail.com>
X-ClientProxiedBy: BYAPR06CA0040.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::17) To BYAPR15MB4136.namprd15.prod.outlook.com
 (2603:10b6:a03:96::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from carbon.DHCP.thefacebook.com (2620:10d:c090:400::5:1b7a) by BYAPR06CA0040.namprd06.prod.outlook.com (2603:10b6:a03:14b::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.21 via Frontend Transport; Tue, 28 Jul 2020 00:08:04 +0000
X-Originating-IP: [2620:10d:c090:400::5:1b7a]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fc9e816f-9a1d-46d2-c59c-08d8328a4cfd
X-MS-TrafficTypeDiagnostic: BYAPR15MB3141:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB3141196FF49A1BB8A11F3B59BE730@BYAPR15MB3141.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: U0mjcZMenr8vpQczdrlXgdEQnfnh8gvR4n4n3HQctDZvnvto1YzQgAOkGkzM/kkvmiNf1eyt+KMOfrHNiQJpyxMjtg0RbCmELzcAbFvi/uZ4gZgy4S53/maoeBdnOWxs0vLAU+xQWtPqpPuDlNJW+Egc0LKMCWgKYhggwO82qxLeszXLUjemMd+aVxDxCCBNM55dw8lELZPHmvs/hp1w41rI6UgjXDs1Mw1G6XTwszChOrDpADe2WO77jD6Q/zJ7E9lTr16cWIn3VFXEffvVU+DZMOe5MM/19xL9+aybK6M7aXQr/IXo67hTn2uGWrbm21Nvv6TtnIuxaDdIXybS5g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4136.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(136003)(396003)(39860400002)(366004)(376002)(346002)(8936002)(83380400001)(5660300002)(55016002)(86362001)(316002)(9686003)(33656002)(6916009)(478600001)(1076003)(66556008)(66476007)(16526019)(186003)(52116002)(53546011)(66946007)(2906002)(54906003)(8676002)(4326008)(15650500001)(6506007)(7696005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: +tXnr9XraZqpHzcAYCDrjn9V3K1HGNGzByO0YG4QteF3/fKuCCUGKWg7diq/KFujU6p1k+m5byaFJ72dVK6n5E95axlsttHvRoTb9QmR1yL8n2CXDdfRtKZ+Unv0MqGGKCyPzXyUZOM4EgPUzYesVoUH/vJoNF2zPWzDUvJYAfLVKwzLyj91EwNyoI5M6vXfaOxhv1LigVQ2Ca+yklB2IYPraRTkdhm5YTTXGVKKtOH9NMOY/dB+CFbOQzD9Ueb+cNJADmt6GrE84b4m+Lg6ZZtp9Z0wlWEEG/koRsv8aRvZJCnVY5E/urp+0XgHcW/aIHep+7UeQiRTLBmo6ANgojKNZElkMlzYkijlr0Zff12k/1p6RH+E3iliRIxU5NODIgX1Wcn438Jqx6sA3vH/3CYJo3z6+qGoPwMPz0evDuhTCnc6WdqI4woV5XdvUa30uSxylrq9elZSA3WMnzA/EQEaZ5QVHQnhLyeYlvZ81IThA2IFWhb7eWX569s8UC9NHnz0S/v4A/G146TGAB3TKQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: fc9e816f-9a1d-46d2-c59c-08d8328a4cfd
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4136.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2020 00:08:05.3339
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MrvrdU/rVQPe+3IIwLG7lH1afYD+gFZTRB3YnyW8e3kYzEXSXKzDp/wfjdNfwpm+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3141
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-27_15:2020-07-27,2020-07-27 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 impostorscore=0 clxscore=1011 lowpriorityscore=0 mlxlogscore=999
 malwarescore=0 adultscore=0 phishscore=0 mlxscore=0 priorityscore=1501
 bulkscore=0 suspectscore=5 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007270165
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 27, 2020 at 03:11:42PM -0700, Song Liu wrote:
> On Mon, Jul 27, 2020 at 12:20 PM Roman Gushchin <guro@fb.com> wrote:
> >
> > Include memory used by bpf programs into the memcg-based accounting.
> > This includes the memory used by programs itself, auxiliary data
> > and statistics.
> >
> > Signed-off-by: Roman Gushchin <guro@fb.com>
> > ---
> >  kernel/bpf/core.c | 8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> >
> > diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> > index bde93344164d..daab8dcafbd4 100644
> > --- a/kernel/bpf/core.c
> > +++ b/kernel/bpf/core.c
> > @@ -77,7 +77,7 @@ void *bpf_internal_load_pointer_neg_helper(const struct sk_buff *skb, int k, uns
> >
> >  struct bpf_prog *bpf_prog_alloc_no_stats(unsigned int size, gfp_t gfp_extra_flags)
> >  {
> > -       gfp_t gfp_flags = GFP_KERNEL | __GFP_ZERO | gfp_extra_flags;
> > +       gfp_t gfp_flags = GFP_KERNEL_ACCOUNT | __GFP_ZERO | gfp_extra_flags;
> >         struct bpf_prog_aux *aux;
> >         struct bpf_prog *fp;
> >
> > @@ -86,7 +86,7 @@ struct bpf_prog *bpf_prog_alloc_no_stats(unsigned int size, gfp_t gfp_extra_flag
> >         if (fp == NULL)
> >                 return NULL;
> >
> > -       aux = kzalloc(sizeof(*aux), GFP_KERNEL | gfp_extra_flags);
> > +       aux = kzalloc(sizeof(*aux), GFP_KERNEL_ACCOUNT | gfp_extra_flags);
> >         if (aux == NULL) {
> >                 vfree(fp);
> >                 return NULL;
> > @@ -104,7 +104,7 @@ struct bpf_prog *bpf_prog_alloc_no_stats(unsigned int size, gfp_t gfp_extra_flag
> >
> >  struct bpf_prog *bpf_prog_alloc(unsigned int size, gfp_t gfp_extra_flags)
> >  {
> > -       gfp_t gfp_flags = GFP_KERNEL | __GFP_ZERO | gfp_extra_flags;
> > +       gfp_t gfp_flags = GFP_KERNEL_ACCOUNT | __GFP_ZERO | gfp_extra_flags;
> >         struct bpf_prog *prog;
> >         int cpu;
> >
> > @@ -217,7 +217,7 @@ void bpf_prog_free_linfo(struct bpf_prog *prog)
> >  struct bpf_prog *bpf_prog_realloc(struct bpf_prog *fp_old, unsigned int size,
> >                                   gfp_t gfp_extra_flags)
> >  {
> > -       gfp_t gfp_flags = GFP_KERNEL | __GFP_ZERO | gfp_extra_flags;
> > +       gfp_t gfp_flags = GFP_KERNEL_ACCOUNT | __GFP_ZERO | gfp_extra_flags;
> >         struct bpf_prog *fp;
> >         u32 pages, delta;
> >         int ret;
> > --

Hi Song!

Thank you for looking into the patchset!

> 
> Do we need similar changes in
> 
> bpf_prog_array_copy()
> bpf_prog_alloc_jited_linfo()
> bpf_prog_clone_create()
> 
> and maybe a few more?

I've tried to follow the rlimit-based accounting, so those objects which were
skipped are mostly skipped now and vice versa. The main reason for that is
simple: I don't know many parts of bpf code well enough to decide whether
we need accounting or not.

In general with memcg-based accounting we can easily cover places which were
not covered previously: e.g. the memory used by the verifier. But I guess it's
better to do it case-by-case.

But if you're aware of any big objects which should be accounted for sure,
please, let me know.

Thanks!

